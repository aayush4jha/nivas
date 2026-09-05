"use client";

import Link from "next/link";
import { Minus, Plus, ShoppingBag, Trash2, TrendingDown } from "lucide-react";
import { useCart } from "@/lib/cart";
import { FREE_SHIPPING_THRESHOLD } from "@/lib/pricing";
import { rupees, rupeesExact, cn } from "@/lib/format";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { ProductArt } from "./product-art";

export function CartView() {
  const { totals, setQty, remove, account, setAccount, hydrated } = useCart();

  if (!hydrated) {
    return (
      <Container className="py-24">
        <div className="h-64 animate-pulse rounded-[var(--radius)] bg-sunk" />
      </Container>
    );
  }

  if (totals.lines.length === 0) return <EmptyCart />;

  const awayFromFreeShipping = FREE_SHIPPING_THRESHOLD - totals.subtotal;

  return (
    <Container className="py-10 md:py-14">
      <h1 className="display text-[32px] font-semibold md:text-[40px]">Your cart</h1>
      <p className="tnum mt-2 text-[14px] text-muted">
        {totals.itemCount} {totals.itemCount === 1 ? "item" : "items"}
      </p>

      {/* Account-tier simulator. Until auth exists this is how a visitor sees
          what a business account would actually be worth to them. */}
      <div className="mt-8 flex flex-wrap items-center gap-3 rounded-[var(--radius)] border border-line bg-surface px-4 py-3">
        <span className="text-[13px] font-medium">Pricing as</span>
        <div className="flex gap-1">
          {(["retail", "business", "bulk"] as const).map((tier) => (
            <button
              key={tier}
              type="button"
              onClick={() => setAccount(tier)}
              aria-pressed={account === tier}
              className={cn(
                "rounded-full border px-3 py-1 text-[12.5px] capitalize transition-colors",
                account === tier
                  ? "border-ink bg-ink text-paper"
                  : "border-line text-ink-soft hover:border-line-strong",
              )}
            >
              {tier}
            </button>
          ))}
        </div>
        <span className="text-[12.5px] text-muted">
          Preview only — <Link href="/register" className="underline">open an account</Link> to
          lock in business rates.
        </span>
      </div>

      <div className="mt-8 grid gap-10 lg:grid-cols-[1fr_360px] lg:gap-14">
        <ul className="divide-y divide-line border-y border-line">
          {totals.lines.map(({ line, product, variant, price, lineTotal }) => (
            <li key={variant.id} className="flex gap-4 py-5">
              <Link
                href={`/business/p/${product.slug}`}
                className="size-20 shrink-0 overflow-hidden rounded-[var(--radius)] bg-surface sm:size-24"
              >
                <ProductArt
                  swatch={product.swatch}
                  category={product.category}
                  size={variant.size}
                  className="size-full"
                />
              </Link>

              <div className="flex min-w-0 flex-1 flex-col">
                <div className="flex items-start justify-between gap-4">
                  <div className="min-w-0">
                    <Link
                      href={`/business/p/${product.slug}`}
                      className="text-[15px] font-medium tracking-[-0.011em] hover:underline"
                    >
                      {product.name}
                    </Link>
                    <p className="tnum mt-0.5 text-[13px] text-muted">
                      {variant.size} · {variant.sku}
                    </p>
                    {price.appliedTier && (
                      <span className="mt-1.5 inline-block">
                        <Badge tone="brand">{price.appliedTier.label ?? "Tier price"}</Badge>
                      </span>
                    )}
                  </div>
                  <div className="text-right">
                    <p className="tnum text-[15px] font-medium">{rupees(lineTotal)}</p>
                    <p className="tnum mt-0.5 text-[12.5px] text-muted">
                      {rupees(price.unitPrice)} each
                    </p>
                  </div>
                </div>

                <div className="mt-auto flex items-center justify-between gap-4 pt-3">
                  <div className="flex h-9 items-center rounded-[var(--radius)] border border-line">
                    <button
                      type="button"
                      onClick={() => setQty(variant.id, Math.max(variant.moq, line.qty - 1))}
                      disabled={line.qty <= variant.moq}
                      aria-label={`Decrease quantity of ${product.name}`}
                      className="flex size-8 items-center justify-center text-ink-soft hover:text-ink disabled:opacity-30"
                    >
                      <Minus className="size-3.5" />
                    </button>
                    <span className="tnum w-9 text-center text-[13.5px] font-medium">
                      {line.qty}
                    </span>
                    <button
                      type="button"
                      onClick={() => setQty(variant.id, line.qty + 1)}
                      aria-label={`Increase quantity of ${product.name}`}
                      className="flex size-8 items-center justify-center text-ink-soft hover:text-ink"
                    >
                      <Plus className="size-3.5" />
                    </button>
                  </div>

                  <button
                    type="button"
                    onClick={() => remove(variant.id)}
                    className="flex items-center gap-1.5 text-[13px] text-muted hover:text-danger"
                  >
                    <Trash2 className="size-3.5" /> Remove
                  </button>
                </div>

                {price.nextTier && (
                  <p className="mt-3 flex items-start gap-1.5 text-[12.5px] text-brand">
                    <TrendingDown className="mt-px size-3.5 shrink-0" aria-hidden />
                    Add {price.nextTier.unitsAway} more for{" "}
                    <span className="tnum font-semibold">
                      {rupees(price.nextTier.tier.unitPrice)}
                    </span>{" "}
                    each
                  </p>
                )}
              </div>
            </li>
          ))}
        </ul>

        {/* ── Summary ───────────────────────────────────────────────────── */}
        <aside className="lg:sticky lg:top-32 lg:self-start">
          <div className="rounded-[var(--radius)] border border-line bg-surface p-6">
            <h2 className="text-[15px] font-semibold">Order summary</h2>

            <dl className="mt-5 space-y-3 text-[14px]">
              <Row label="Subtotal" value={rupeesExact(totals.subtotal)} />
              <Row label="GST" value={rupeesExact(totals.gst)} />
              <Row
                label="Delivery"
                value={totals.shipping === 0 ? "Free" : rupeesExact(totals.shipping)}
              />
              <div className="flex justify-between border-t border-line pt-3 text-[17px] font-semibold">
                <dt>Total</dt>
                <dd className="tnum">{rupeesExact(totals.total)}</dd>
              </div>
            </dl>

            {totals.savings > 0 && (
              <p className="tnum mt-4 rounded-[var(--radius)] bg-brand-tint px-3 py-2.5 text-[13px] font-medium text-brand">
                You&rsquo;re saving {rupees(totals.savings)} with volume pricing.
              </p>
            )}

            {totals.shipping > 0 && awayFromFreeShipping > 0 && (
              <p className="tnum mt-3 text-[12.5px] text-muted">
                Add {rupees(awayFromFreeShipping)} more for free delivery.
              </p>
            )}

            <Button size="lg" className="mt-5 w-full">
              Proceed to checkout
            </Button>
            <p className="mt-3 text-center text-[12px] text-muted">
              GST invoice issued against your GSTIN
            </p>
          </div>

          <div className="mt-4 rounded-[var(--radius)] border border-line p-5">
            <p className="text-[14px] font-medium">Ordering 100+ units?</p>
            <p className="mt-1.5 text-[13px] leading-relaxed text-ink-soft">
              Send the list and we will quote it directly — usually below the
              published bulk tier.
            </p>
            <Button asChild variant="outline" size="sm" className="mt-4">
              <Link href="/bulk-quote">Request a bulk quote</Link>
            </Button>
          </div>
        </aside>
      </div>
    </Container>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between text-ink-soft">
      <dt>{label}</dt>
      <dd className="tnum text-ink">{value}</dd>
    </div>
  );
}

function EmptyCart() {
  return (
    <Container className="py-24 text-center">
      <ShoppingBag className="mx-auto size-8 text-muted" aria-hidden />
      <h1 className="display mt-5 text-[28px] font-semibold">Your cart is empty</h1>
      <p className="mx-auto mt-3 max-w-sm text-[15px] leading-relaxed text-ink-soft">
        Nothing here yet. Start from a category, or pull up your last order and
        rebuild it in one tap.
      </p>
      <div className="mt-8 flex flex-wrap justify-center gap-3">
        <Button asChild size="lg">
          <Link href="/business">Browse the catalogue</Link>
        </Button>
        <Button asChild size="lg" variant="outline">
          <Link href="/premium">Shop Premium</Link>
        </Button>
      </div>
    </Container>
  );
}
