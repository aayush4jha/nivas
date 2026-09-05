-- ═══════════════════════════════════════════════════════════════════════════
-- NIVAS — core commerce schema
--
-- Design rules this schema holds to:
--
--   1. Money is BIGINT paise. Never numeric, never float. ₹349.50 is 34950.
--      Every rate is stored, never derived at read time, so an invoice reprinted
--      in two years shows what was actually charged.
--
--   2. Price and stock live on the VARIANT, not the product. A 5 L jar and a
--      25 L drum of the same cleaner are different economics; modelling them as
--      one row with a size attribute is the mistake that forces a rewrite.
--
--   3. Orders snapshot everything. An order line copies the name, SKU and unit
--      price it was placed at. Catalogue edits must never rewrite history.
--
--   4. A business is a tenant with members, from day one. Retrofitting
--      multi-user accounts onto a single-user schema is expensive; the extra
--      join now is not.
-- ═══════════════════════════════════════════════════════════════════════════

create extension if not exists "pgcrypto";
create extension if not exists "pg_trgm";

-- ── Enums ──────────────────────────────────────────────────────────────────

create type account_tier as enum ('retail', 'business', 'bulk', 'enterprise');
create type business_type as enum (
  'restaurant', 'cafe', 'hotel', 'hostel', 'office',
  'gym', 'salon', 'school', 'clinic', 'other'
);
create type member_role as enum ('owner', 'admin', 'purchasing', 'staff');
create type storefront as enum ('business', 'premium');
create type order_status as enum (
  'pending', 'confirmed', 'packed', 'shipped', 'delivered', 'cancelled', 'returned'
);
create type payment_status as enum ('pending', 'authorised', 'paid', 'failed', 'refunded');
create type quote_status as enum ('requested', 'priced', 'accepted', 'rejected', 'expired');
create type subscription_cadence as enum ('weekly', 'fortnightly', 'monthly', 'custom');

-- ── Identity ───────────────────────────────────────────────────────────────

-- Mirrors auth.users. Supabase owns authentication; this owns everything else.
create table profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  full_name    text,
  phone        text,
  email        text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create table businesses (
  id             uuid primary key default gen_random_uuid(),
  name           text not null,
  type           business_type not null default 'other',
  gstin          text,
  -- Set at onboarding from the declared spend band, adjusted by actual volume.
  tier           account_tier not null default 'business',
  -- Declared monthly spend in paise. Nullable: an estimate, not a measurement.
  declared_spend bigint,
  credit_limit   bigint not null default 0,
  -- 0 = prepaid. 7/15/30 once the account has earned terms.
  credit_days    smallint not null default 0,
  active         boolean not null default true,
  created_at     timestamptz not null default now(),

  constraint gstin_format check (
    gstin is null or gstin ~ '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z][0-9A-Z][Z][0-9A-Z]$'
  ),
  constraint credit_days_valid check (credit_days in (0, 7, 15, 30, 45, 60))
);

-- Multi-tenancy from day one: a business has members with distinct permissions.
create table business_members (
  business_id uuid not null references businesses(id) on delete cascade,
  profile_id  uuid not null references profiles(id) on delete cascade,
  role        member_role not null default 'staff',
  created_at  timestamptz not null default now(),
  primary key (business_id, profile_id)
);

create index on business_members (profile_id);

create table addresses (
  id           uuid primary key default gen_random_uuid(),
  profile_id   uuid references profiles(id) on delete cascade,
  business_id  uuid references businesses(id) on delete cascade,
  label        text,
  line1        text not null,
  line2        text,
  city         text not null,
  state        text not null,
  pincode      text not null,
  is_billing   boolean not null default false,
  is_delivery  boolean not null default true,
  created_at   timestamptz not null default now(),

  constraint pincode_format check (pincode ~ '^[1-9][0-9]{5}$'),
  -- An address belongs to exactly one of a person or a business.
  constraint owner_exclusive check (num_nonnulls(profile_id, business_id) = 1)
);

-- ── Catalogue ──────────────────────────────────────────────────────────────

create table categories (
  slug        text primary key,
  name        text not null,
  tagline     text,
  icon        text,
  -- Which storefronts list this category.
  storefronts storefront[] not null default '{business}',
  sort_order  smallint not null default 0
);

create table suppliers (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  contact_name  text,
  phone         text,
  email         text,
  gstin         text,
  -- Days from PO to delivery. Drives the reorder point calculation.
  lead_days     smallint not null default 3,
  payment_days  smallint not null default 15,
  active        boolean not null default true,
  notes         text,
  created_at    timestamptz not null default now()
);

create table products (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique,
  name          text not null,
  brand         text,
  category_slug text not null references categories(slug),
  subcategory   text,
  storefronts   storefront[] not null default '{business}',
  short_description text,
  description   text,
  highlights    text[] not null default '{}',
  swatch        text,
  featured      boolean not null default false,
  active        boolean not null default true,
  -- Generated column keeps full-text search in step with edits automatically.
  search_vector tsvector generated always as (
    setweight(to_tsvector('english', coalesce(name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(brand, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(subcategory, '')), 'C') ||
    setweight(to_tsvector('english', coalesce(short_description, '')), 'D')
  ) stored,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create index on products using gin (search_vector);
create index on products using gin (name gin_trgm_ops);
create index on products (category_slug) where active;

create table product_variants (
  id           uuid primary key default gen_random_uuid(),
  product_id   uuid not null references products(id) on delete cascade,
  sku          text not null unique,
  size         text not null,
  -- MRP in paise. What an anonymous retail buyer pays for a single unit.
  list_price   bigint not null,
  -- Current supplier cost in paise. Never exposed to the storefront.
  cost_price   bigint not null,
  gst_rate     numeric(4,2) not null default 18.00,
  moq          integer not null default 1,
  weight_grams integer,
  position     smallint not null default 0,
  active       boolean not null default true,

  constraint prices_positive check (list_price > 0 and cost_price >= 0),
  constraint moq_positive check (moq >= 1),
  -- Selling below cost is almost always a data-entry error. Catch it here.
  constraint price_above_cost check (list_price >= cost_price)
);

create index on product_variants (product_id) where active;

-- Price breaks. A tier applies when BOTH conditions hold: the line quantity
-- reaches min_qty, and the buyer's account tier is at least requires_tier.
-- The resolver picks the cheapest qualifying tier — see resolve_unit_price().
create table price_tiers (
  id            uuid primary key default gen_random_uuid(),
  variant_id    uuid not null references product_variants(id) on delete cascade,
  min_qty       integer not null,
  unit_price    bigint not null,
  requires_tier account_tier not null default 'retail',
  label         text,

  constraint min_qty_positive check (min_qty >= 1),
  constraint tier_price_positive check (unit_price > 0),
  unique (variant_id, min_qty, requires_tier)
);

create index on price_tiers (variant_id);

create table product_images (
  id         uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  variant_id uuid references product_variants(id) on delete cascade,
  url        text not null,
  alt        text,
  position   smallint not null default 0
);

-- ── Inventory and supply ───────────────────────────────────────────────────

create table inventory (
  variant_id     uuid primary key references product_variants(id) on delete cascade,
  on_hand        integer not null default 0,
  -- Committed to unshipped orders. Available stock is on_hand - reserved.
  reserved       integer not null default 0,
  reorder_point  integer not null default 20,
  reorder_qty    integer not null default 50,
  updated_at     timestamptz not null default now(),

  constraint counts_non_negative check (on_hand >= 0 and reserved >= 0)
);

create view inventory_status as
select
  i.variant_id,
  i.on_hand,
  i.reserved,
  i.on_hand - i.reserved as available,
  i.reorder_point,
  case
    when i.on_hand - i.reserved <= 0 then 'out_of_stock'
    when i.on_hand - i.reserved <= i.reorder_point then 'low'
    else 'ok'
  end as status
from inventory i;

create table supplier_products (
  supplier_id uuid not null references suppliers(id) on delete cascade,
  variant_id  uuid not null references product_variants(id) on delete cascade,
  cost_price  bigint not null,
  moq         integer not null default 1,
  lead_days   smallint,
  -- Preferred supplier for this SKU when more than one can fill it.
  preferred   boolean not null default false,
  primary key (supplier_id, variant_id)
);

-- ── Carts ──────────────────────────────────────────────────────────────────

create table carts (
  id          uuid primary key default gen_random_uuid(),
  profile_id  uuid references profiles(id) on delete cascade,
  business_id uuid references businesses(id) on delete cascade,
  storefront  storefront not null default 'business',
  updated_at  timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

create table cart_items (
  cart_id    uuid not null references carts(id) on delete cascade,
  variant_id uuid not null references product_variants(id) on delete cascade,
  qty        integer not null,
  added_at   timestamptz not null default now(),
  primary key (cart_id, variant_id),
  constraint qty_positive check (qty > 0)
);

-- ── Orders ─────────────────────────────────────────────────────────────────

create table orders (
  id               uuid primary key default gen_random_uuid(),
  -- Human-facing reference. NIV-10412.
  reference        text not null unique,
  profile_id       uuid references profiles(id) on delete set null,
  business_id      uuid references businesses(id) on delete set null,
  storefront       storefront not null default 'business',
  status           order_status not null default 'pending',
  -- Tier the order was priced at. Frozen: a later upgrade must not reprice history.
  priced_at_tier   account_tier not null default 'retail',

  subtotal         bigint not null,
  gst_total        bigint not null,
  shipping         bigint not null default 0,
  discount         bigint not null default 0,
  total            bigint not null,

  -- Snapshots, not references. Addresses get edited; invoices must not change.
  billing_address  jsonb,
  delivery_address jsonb,
  gstin            text,
  po_number        text,

  placed_at        timestamptz not null default now(),
  delivered_at     timestamptz,
  notes            text,

  constraint totals_non_negative check (subtotal >= 0 and total >= 0)
);

create index on orders (business_id, placed_at desc);
create index on orders (profile_id, placed_at desc);
create index on orders (status) where status not in ('delivered', 'cancelled');

create table order_items (
  id            uuid primary key default gen_random_uuid(),
  order_id      uuid not null references orders(id) on delete cascade,
  variant_id    uuid references product_variants(id) on delete set null,
  -- Snapshot of the catalogue at the moment of purchase.
  product_name  text not null,
  variant_size  text not null,
  sku           text not null,
  qty           integer not null,
  unit_price    bigint not null,
  list_price    bigint not null,
  gst_rate      numeric(4,2) not null,
  line_total    bigint not null,
  -- Which price break produced unit_price, for margin analysis later.
  tier_label    text,

  constraint qty_positive check (qty > 0)
);

create index on order_items (order_id);
create index on order_items (variant_id);

create table payments (
  id            uuid primary key default gen_random_uuid(),
  order_id      uuid not null references orders(id) on delete cascade,
  status        payment_status not null default 'pending',
  amount        bigint not null,
  method        text,
  provider      text,
  provider_ref  text,
  -- Full webhook body, so a disputed payment can be reconstructed.
  provider_payload jsonb,
  created_at    timestamptz not null default now(),
  settled_at    timestamptz
);

create index on payments (order_id);
create unique index on payments (provider, provider_ref)
  where provider_ref is not null;

-- ── Quotes ─────────────────────────────────────────────────────────────────

create table quotes (
  id            uuid primary key default gen_random_uuid(),
  reference     text not null unique,
  business_id   uuid references businesses(id) on delete set null,
  profile_id    uuid references profiles(id) on delete set null,
  status        quote_status not null default 'requested',
  -- Contact details captured inline: a quote can precede an account.
  contact_name  text,
  contact_phone text,
  contact_email text,
  business_name text,
  notes         text,

  -- Filled in when priced. Cost is internal; margin is derived, not stored.
  quoted_total  bigint,
  cost_total    bigint,
  valid_until   date,
  priced_by     uuid references profiles(id) on delete set null,
  priced_at     timestamptz,

  created_at    timestamptz not null default now()
);

create index on quotes (status, created_at desc);

create table quote_items (
  id            uuid primary key default gen_random_uuid(),
  quote_id      uuid not null references quotes(id) on delete cascade,
  variant_id    uuid references product_variants(id) on delete set null,
  -- Free text for items not in the catalogue yet — the reason a quote exists.
  description   text,
  qty           integer not null,
  quoted_unit   bigint,
  cost_unit     bigint,

  constraint qty_positive check (qty > 0)
);

create index on quote_items (quote_id);

-- ── Recurring orders ───────────────────────────────────────────────────────

create table subscriptions (
  id            uuid primary key default gen_random_uuid(),
  business_id   uuid not null references businesses(id) on delete cascade,
  cadence       subscription_cadence not null default 'monthly',
  -- Only used when cadence = 'custom'.
  interval_days smallint,
  next_run      date not null,
  active        boolean not null default true,
  created_at    timestamptz not null default now(),

  constraint custom_needs_interval check (
    cadence <> 'custom' or interval_days is not null
  )
);

create table subscription_items (
  subscription_id uuid not null references subscriptions(id) on delete cascade,
  variant_id      uuid not null references product_variants(id) on delete cascade,
  qty             integer not null,
  primary key (subscription_id, variant_id),
  constraint qty_positive check (qty > 0)
);

-- ── Reviews and notifications ──────────────────────────────────────────────

create table reviews (
  id         uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  -- Only buyers can review, and only once per product.
  order_id   uuid references orders(id) on delete set null,
  rating     smallint not null,
  title      text,
  body       text,
  created_at timestamptz not null default now(),

  constraint rating_range check (rating between 1 and 5),
  unique (product_id, profile_id)
);

create table notifications (
  id         uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  kind       text not null,
  title      text not null,
  body       text,
  link       text,
  read_at    timestamptz,
  created_at timestamptz not null default now()
);

create index on notifications (profile_id, created_at desc) where read_at is null;

-- ── Pricing resolver ───────────────────────────────────────────────────────

-- Mirrors src/lib/pricing.ts resolvePrice(). Kept in SQL so server-side order
-- creation cannot be tricked by a client sending its own price. The TypeScript
-- version renders; this one decides.
create or replace function resolve_unit_price(
  p_variant_id uuid,
  p_qty        integer,
  p_tier       account_tier default 'retail'
) returns bigint
language sql
stable
as $$
  select least(
    (select list_price from product_variants where id = p_variant_id),
    coalesce(
      (select min(t.unit_price)
         from price_tiers t
        where t.variant_id = p_variant_id
          and p_qty >= t.min_qty
          -- Enum ordering encodes the hierarchy: retail < business < bulk < enterprise.
          and t.requires_tier <= p_tier),
      (select list_price from product_variants where id = p_variant_id)
    )
  );
$$;

comment on function resolve_unit_price is
  'Cheapest price break a buyer qualifies for on both quantity and account tier, '
  'falling back to list price. Authoritative — clients never supply prices.';

-- ── Housekeeping ───────────────────────────────────────────────────────────

create or replace function touch_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger products_touch before update on products
  for each row execute function touch_updated_at();
create trigger profiles_touch before update on profiles
  for each row execute function touch_updated_at();
