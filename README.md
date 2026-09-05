# Nivas

A B2B + B2C procurement platform for cleaning, hygiene, hospitality and everyday
consumables. One catalogue and one supply chain behind two storefronts:

- **Business** — bulk sizes, tiered pricing, GST invoices, bulk quotes, reorder
  prediction. Restaurants, hotels, offices, gyms, salons, clinics.
- **Premium** — a consumer brand on the same supply chain. Handwash, body care,
  home fragrance, premium cleaning.

`Nivas` is a working name. Nothing in the code depends on it beyond copy.

---

## Running it

```bash
npm install
npm run dev          # http://localhost:3000
```

No environment variables are needed. The catalogue, cart and dashboard all run
off seed data, so the whole app is explorable before any backend exists.

| Command | What it does |
| --- | --- |
| `npm run dev` | Dev server |
| `npm run build` | Production build (~84 prerendered pages) |
| `npm run lint` | ESLint |
| `npm run db:seed` | Regenerate `supabase/seed.sql` from the TypeScript catalogue |

---

## How it is put together

```
src/
  app/
    page.tsx              Landing gateway — picks a storefront
    [mode]/               Both storefronts. mode ∈ business | premium
      page.tsx            Storefront home
      c/[slug]/           Category listing
      p/[slug]/           Product detail
      search/
    cart/  register/  bulk-quote/  account/     Shared across storefronts
  components/             UI. ui/ holds primitives, the rest are features
  lib/
    types.ts              Domain model
    pricing.ts            Tiered pricing engine
    reorder.ts            Reorder prediction
    cart.tsx              Cart provider (localStorage today, Postgres later)
    mode.ts               Storefront configuration
  data/                   Seed catalogue and demo account
supabase/
  migrations/0001_core.sql   Schema
  migrations/0002_rls.sql    Row level security
  seed.sql                   Generated — do not edit
```

### One route tree, two storefronts

`/[mode]` validates `business | premium` and sets `data-mode` on the wrapper.
`globals.css` redefines the palette under `[data-mode="premium"]`, so the whole
site changes temperament — cool and dense to warm and wide — without a single
component branching on mode for styling. Only genuine behaviour differences
(price ladders, card layout) are conditional in TypeScript.

Shared pages sit outside that tree but remember the last storefront visited, so
a Premium shopper does not land in a cart that reads like a wholesale portal.

### Pricing

The one part worth reading before changing anything.

- **All money is integer paise.** `₹349.50` is `34950`. No floats anywhere.
  Rupees exist only in `src/lib/format.ts` and in the seed file's authoring
  units.
- **Price and stock live on the variant, not the product.** A 5 L jar and a
  25 L drum are different economics. Modelling them as one row with a size
  attribute is the mistake that forces a rewrite later.
- **A price break gates on two axes**: quantity (`min_qty`) and account level
  (`requires_tier`). `resolvePrice()` picks the cheapest tier the buyer
  qualifies for on both, and falls back to list price — an anonymous visitor
  always gets a valid price.
- **Lines never pool.** Each cart line resolves its own tier, because a supplier
  price break is per-SKU, not per-order.
- `resolve_unit_price()` in `0001_core.sql` mirrors the TypeScript exactly. The
  SQL version is authoritative: clients render prices, the database decides
  them, and order creation must never accept a price from the client.

### Orders snapshot everything

`order_items` copies product name, SKU, unit price, list price and GST rate at
the moment of purchase. Catalogue edits must never rewrite history — an invoice
reprinted in two years has to show what was actually charged.

### Multi-tenant from day one

A business has members with roles (`owner`, `admin`, `purchasing`, `staff`).
Everyone on an account can *see* its orders; only owners, admins and purchasing
can *place* them. Retrofitting this onto a single-user schema is expensive; the
extra join now is not.

### Row level security

Every tenant table denies by default. Business policies route through one
`is_member_of()` function so there is a single predicate to audit rather than
thirty. Cost prices and quote margins are revoked at the column-grant level
rather than merely left unselected — a policy cannot filter columns, so
`cost_price` is unreachable by the `anon` and `authenticated` roles and the
storefront reads `catalogue_variants` instead.

### Reorder prediction

Mean gap between a business's past orders of a SKU; cycle minus days-since-last
gives the runway. Deliberately simple — at this data volume it beats a seasonal
model, and it can be explained to a customer in one sentence, which is what
makes them trust the nudge enough to act on it. Revisit after a year of real
purchase history.

---

## Placeholder data

Clearly marked, and all of it disposable:

- `src/data/products.ts` — 53 products, 92 SKUs, invented but plausible Indian
  pricing and supplier costs. **Source of truth for `supabase/seed.sql`** —
  edit here and run `npm run db:seed`, never edit the SQL directly.
- `src/data/demo-account.ts` — purchase history for the dashboard. Dates are
  generated backwards from today so predictions stay live rather than going
  stale.
- `src/components/product-art.tsx` — tinted vessel silhouettes standing in for
  photography. Delete the day real images land; it is the single biggest visual
  upgrade this site will get.

---

## What is not built yet

Deliberately out of scope for V1, in rough priority order:

1. **Supabase wiring** — schema and RLS exist, nothing connects to them yet.
   Auth, server-persisted carts, real orders.
2. **Checkout and payments** — Razorpay: order creation, verification, webhooks,
   refunds, failed-payment handling.
3. **Admin** — products, inventory, orders, customers, suppliers, quote pricing.
4. **Recurring orders** — `subscriptions` is in the schema; no UI.
5. **WhatsApp reorder** — likely the highest-retention feature for B2B, and
   worth building before anything in this list except payments.
6. **Credit terms** — `credit_limit` and `credit_days` exist on `businesses`.
   Do not extend credit without eligibility and risk controls first.

Real product photography and a final brand name are the two non-engineering
items that would most change how this looks.
