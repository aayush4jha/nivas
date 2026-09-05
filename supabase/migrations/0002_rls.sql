-- ═══════════════════════════════════════════════════════════════════════════
-- Row level security
--
-- The threat this guards against is not an attacker — it is the ordinary case
-- of one business seeing another's orders, prices or spend. Every table that
-- holds tenant data denies by default and opens only through explicit policy.
--
-- Two ideas carry most of the weight:
--
--   * `is_member_of(business_id)` — the single membership check every business
--     policy routes through. One function to audit, not thirty predicates.
--
--   * Cost prices are never exposed. `product_variants` is world-readable for
--     the catalogue, so `cost_price` is stripped by the public view below and
--     column-level grants keep it out of reach of the anon and authenticated
--     roles entirely.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Helpers ────────────────────────────────────────────────────────────────

-- SECURITY DEFINER so the membership lookup itself is not subject to RLS,
-- which would otherwise recurse. Kept tiny and side-effect free for that reason.
create or replace function is_member_of(p_business uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from business_members
    where business_id = p_business and profile_id = auth.uid()
  );
$$;

create or replace function has_business_role(p_business uuid, p_roles member_role[])
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from business_members
    where business_id = p_business
      and profile_id = auth.uid()
      and role = any(p_roles)
  );
$$;

-- Staff flag lives in the JWT so admin checks cost nothing.
create or replace function is_staff()
returns boolean
language sql
stable
as $$
  select coalesce(
    (auth.jwt() -> 'app_metadata' ->> 'staff')::boolean,
    false
  );
$$;

-- ── Catalogue: readable by everyone, written by staff ──────────────────────

alter table categories        enable row level security;
alter table products          enable row level security;
alter table product_variants  enable row level security;
alter table price_tiers       enable row level security;
alter table product_images    enable row level security;

create policy "catalogue readable" on categories
  for select using (true);
create policy "products readable" on products
  for select using (active or is_staff());
create policy "variants readable" on product_variants
  for select using (active or is_staff());
create policy "tiers readable" on price_tiers
  for select using (true);
create policy "images readable" on product_images
  for select using (true);

create policy "staff write categories" on categories
  for all using (is_staff()) with check (is_staff());
create policy "staff write products" on products
  for all using (is_staff()) with check (is_staff());
create policy "staff write variants" on product_variants
  for all using (is_staff()) with check (is_staff());
create policy "staff write tiers" on price_tiers
  for all using (is_staff()) with check (is_staff());
create policy "staff write images" on product_images
  for all using (is_staff()) with check (is_staff());

-- Cost price is commercially sensitive and must never reach a client. Policies
-- cannot filter columns, so revoke it at the grant level and expose a view.
revoke all on product_variants from anon, authenticated;
grant select (
  id, product_id, sku, size, list_price, gst_rate, moq,
  weight_grams, position, active
) on product_variants to anon, authenticated;

create view catalogue_variants
with (security_invoker = true) as
select id, product_id, sku, size, list_price, gst_rate, moq,
       weight_grams, position, active
from product_variants
where active;

comment on view catalogue_variants is
  'Storefront-safe projection of product_variants. Excludes cost_price.';

-- ── Supply chain: staff only ───────────────────────────────────────────────

alter table suppliers         enable row level security;
alter table supplier_products enable row level security;
alter table inventory         enable row level security;

create policy "staff only suppliers" on suppliers
  for all using (is_staff()) with check (is_staff());
create policy "staff only supplier products" on supplier_products
  for all using (is_staff()) with check (is_staff());

-- Customers need availability but not the reorder economics. The view exposes
-- only what a stock badge requires.
create policy "staff manage inventory" on inventory
  for all using (is_staff()) with check (is_staff());
revoke all on inventory from anon, authenticated;
grant select (variant_id, on_hand, reserved) on inventory to anon, authenticated;

-- ── Identity ───────────────────────────────────────────────────────────────

alter table profiles         enable row level security;
alter table businesses       enable row level security;
alter table business_members enable row level security;
alter table addresses        enable row level security;

create policy "own profile" on profiles
  for select using (id = auth.uid() or is_staff());
create policy "update own profile" on profiles
  for update using (id = auth.uid()) with check (id = auth.uid());
create policy "insert own profile" on profiles
  for insert with check (id = auth.uid());

create policy "read own businesses" on businesses
  for select using (is_member_of(id) or is_staff());
-- Only owners and admins change business details; purchasing and staff cannot
-- raise their own credit limit or edit the GSTIN on invoices.
create policy "owners update business" on businesses
  for update using (has_business_role(id, array['owner', 'admin']::member_role[]))
  with check (has_business_role(id, array['owner', 'admin']::member_role[]));
create policy "staff manage businesses" on businesses
  for all using (is_staff()) with check (is_staff());

create policy "read own memberships" on business_members
  for select using (profile_id = auth.uid() or is_member_of(business_id) or is_staff());
create policy "owners manage members" on business_members
  for all using (has_business_role(business_id, array['owner', 'admin']::member_role[]))
  with check (has_business_role(business_id, array['owner', 'admin']::member_role[]));

create policy "read own addresses" on addresses
  for all using (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
    or is_staff()
  )
  with check (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
  );

-- ── Carts ──────────────────────────────────────────────────────────────────

alter table carts      enable row level security;
alter table cart_items enable row level security;

create policy "own cart" on carts
  for all using (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
  )
  with check (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
  );

create policy "own cart items" on cart_items
  for all using (
    exists (
      select 1 from carts c
      where c.id = cart_items.cart_id
        and (c.profile_id = auth.uid()
             or (c.business_id is not null and is_member_of(c.business_id)))
    )
  )
  with check (
    exists (
      select 1 from carts c
      where c.id = cart_items.cart_id
        and (c.profile_id = auth.uid()
             or (c.business_id is not null and is_member_of(c.business_id)))
    )
  );

-- ── Orders ─────────────────────────────────────────────────────────────────

alter table orders      enable row level security;
alter table order_items enable row level security;
alter table payments    enable row level security;

-- Everyone on the account can see the account's orders. Visibility is shared
-- even where permission to place them is not — a manager needs to see what
-- purchasing ordered.
create policy "read own orders" on orders
  for select using (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
    or is_staff()
  );

-- Staff role can browse but not place orders. Placing spends the account's money.
create policy "place orders" on orders
  for insert with check (
    profile_id = auth.uid()
    and (
      business_id is null
      or has_business_role(business_id, array['owner', 'admin', 'purchasing']::member_role[])
    )
  );

-- Orders are immutable to customers once placed. Status transitions are staff
-- or service-role work; a customer cancelling goes through a function, not an
-- UPDATE, so the transition can be validated.
create policy "staff manage orders" on orders
  for all using (is_staff()) with check (is_staff());

create policy "read own order items" on order_items
  for select using (
    exists (
      select 1 from orders o
      where o.id = order_items.order_id
        and (o.profile_id = auth.uid()
             or (o.business_id is not null and is_member_of(o.business_id))
             or is_staff())
    )
  );
create policy "staff manage order items" on order_items
  for all using (is_staff()) with check (is_staff());

create policy "read own payments" on payments
  for select using (
    exists (
      select 1 from orders o
      where o.id = payments.order_id
        and (o.profile_id = auth.uid()
             or (o.business_id is not null and is_member_of(o.business_id))
             or is_staff())
    )
  );
-- Payments are written only by the webhook handler running as service_role,
-- which bypasses RLS. No client-facing insert policy exists, on purpose.
create policy "staff manage payments" on payments
  for all using (is_staff()) with check (is_staff());

-- ── Quotes ─────────────────────────────────────────────────────────────────

alter table quotes      enable row level security;
alter table quote_items enable row level security;

-- A quote can be requested before an account exists, so anonymous inserts are
-- allowed; reading one back still requires ownership.
create policy "anyone may request a quote" on quotes
  for insert with check (true);
create policy "read own quotes" on quotes
  for select using (
    profile_id = auth.uid()
    or (business_id is not null and is_member_of(business_id))
    or is_staff()
  );
create policy "staff manage quotes" on quotes
  for all using (is_staff()) with check (is_staff());

create policy "insert quote items" on quote_items
  for insert with check (true);
create policy "read own quote items" on quote_items
  for select using (
    exists (
      select 1 from quotes q
      where q.id = quote_items.quote_id
        and (q.profile_id = auth.uid()
             or (q.business_id is not null and is_member_of(q.business_id))
             or is_staff())
    )
  );
create policy "staff manage quote items" on quote_items
  for all using (is_staff()) with check (is_staff());

-- Cost columns on a quote are internal margin working. Same treatment as
-- variant cost: revoked rather than merely unselected.
revoke all on quotes from anon, authenticated;
grant select (
  id, reference, business_id, profile_id, status, contact_name, contact_phone,
  contact_email, business_name, notes, quoted_total, valid_until, created_at
) on quotes to anon, authenticated;
grant insert on quotes to anon, authenticated;

revoke all on quote_items from anon, authenticated;
grant select (id, quote_id, variant_id, description, qty, quoted_unit)
  on quote_items to anon, authenticated;
grant insert on quote_items to anon, authenticated;

-- ── Subscriptions ──────────────────────────────────────────────────────────

alter table subscriptions      enable row level security;
alter table subscription_items enable row level security;

create policy "manage own subscriptions" on subscriptions
  for all using (
    has_business_role(business_id, array['owner', 'admin', 'purchasing']::member_role[])
    or is_staff()
  )
  with check (
    has_business_role(business_id, array['owner', 'admin', 'purchasing']::member_role[])
  );

create policy "manage own subscription items" on subscription_items
  for all using (
    exists (
      select 1 from subscriptions s
      where s.id = subscription_items.subscription_id
        and (is_member_of(s.business_id) or is_staff())
    )
  )
  with check (
    exists (
      select 1 from subscriptions s
      where s.id = subscription_items.subscription_id
        and has_business_role(
          s.business_id, array['owner', 'admin', 'purchasing']::member_role[]
        )
    )
  );

-- ── Reviews and notifications ──────────────────────────────────────────────

alter table reviews       enable row level security;
alter table notifications enable row level security;

create policy "reviews readable" on reviews
  for select using (true);
-- Only a delivered order earns a review. This is the whole anti-spam story.
create policy "buyers may review" on reviews
  for insert with check (
    profile_id = auth.uid()
    and exists (
      select 1
        from orders o
        join order_items oi on oi.order_id = o.id
        join product_variants v on v.id = oi.variant_id
       where o.id = reviews.order_id
         and o.status = 'delivered'
         and v.product_id = reviews.product_id
         and (o.profile_id = auth.uid()
              or (o.business_id is not null and is_member_of(o.business_id)))
    )
  );
create policy "edit own review" on reviews
  for update using (profile_id = auth.uid()) with check (profile_id = auth.uid());
create policy "delete own review" on reviews
  for delete using (profile_id = auth.uid() or is_staff());

create policy "own notifications" on notifications
  for select using (profile_id = auth.uid());
create policy "mark own notifications read" on notifications
  for update using (profile_id = auth.uid()) with check (profile_id = auth.uid());
