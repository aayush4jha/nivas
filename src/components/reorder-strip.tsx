"use client";

import Link from "next/link";
import { useState } from "react";
import { Check, RotateCcw } from "lucide-react";
import { PRODUCTS } from "@/data/products";
import { resolvePrice } from "@/lib/pricing";
import { rupees } from "@/lib/format";
import { useCart } from "@/lib/cart";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";

/**
 * "Running low? Reorder in seconds."
 *
 * The single most valuable surface on a B2B storefront — a restaurant does not
 * want to browse, it wants last month's order again. Until order history exists
 * this renders a representative basket so the interaction can be designed and
 * tested; the shape is exactly what a real `orders` row will supply.
 */

/** Stand-in for the customer's most recent order. */
const LAST_ORDER: Array<{ product: string; variant: string; qty: number }> = [
  { product: "commercial-floor-cleaner-citrus", variant: "commercial-floor-cleaner-citrus--10-l", qty: 2 },
  { product: "liquid-handwash-rose", variant: "liquid-handwash-rose--5-l", qty: 3 },
  { product: "dishwash-liquid-lime", variant: "dishwash-liquid-lime--5-l", qty: 4 },
  { product: "garbage-bags-large-24-32-in", variant: "garbage-bags-large-24-32-in--pack-of-30", qty: 6 },
  { product: "multifold-paper-towels", variant: "multifold-paper-towels--pack-of-20-3-000-sheets", qty: 2 },
];

export function ReorderStrip() {
  const { add, account } = useCart();
  const [added, setAdded] = useState(false);

  const items = LAST_ORDER.map((entry) => {
    const product = PRODUCTS.find((p) => p.id === entry.product);
    const variant = product?.variants.find((v) => v.id === entry.variant);
    return product && variant ? { product, variant, qty: entry.qty } : null;
  }).filter((x): x is NonNullable<typeof x> => x !== null);

  const total = items.reduce(
    (sum, i) => sum + resolvePrice(i.variant, i.qty, account).unitPrice * i.qty,
    0,
  );

  function reorderAll() {
    for (const i of items) add(i.product.id, i.variant.id, i.qty);
    setAdded(true);
    window.setTimeout(() => setAdded(false), 2000);
  }

  if (items.length === 0) return null;

  return (
    <section className="border-y border-line bg-surface py-12 md:py-16">
      <Container>
        <div className="grid gap-8 lg:grid-cols-[1fr_1.45fr] lg:items-center">
          <div>
            <div className="flex items-center gap-2">
              <p className="eyebrow">Reorder</p>
              <Badge tone="outline">Sample order</Badge>
            </div>
            <h2 className="display mt-3 text-[26px] font-semibold md:text-[32px]">
              Running low? Reorder in seconds.
            </h2>
            <p className="mt-3 max-w-md text-[15px] leading-relaxed text-ink-soft">
              Your last order, rebuilt in one tap. Sign in and this becomes your
              real purchase history — including a nudge when you are due.
            </p>
            <div className="mt-6 flex flex-wrap items-center gap-3">
              <Button onClick={reorderAll} size="lg" disabled={added}>
                {added ? (
                  <>
                    <Check className="size-4" /> Added to cart
                  </>
                ) : (
                  <>
                    <RotateCcw className="size-4" /> Reorder everything ·{" "}
                    <span className="tnum">{rupees(total)}</span>
                  </>
                )}
              </Button>
              <Link href="/account" className="text-sm text-ink-soft underline-offset-4 hover:underline">
                View order history
              </Link>
            </div>
          </div>

          <ul className="divide-y divide-line overflow-hidden rounded-[var(--radius)] border border-line">
            {items.map(({ product, variant, qty }) => {
              const price = resolvePrice(variant, qty, account);
              return (
                <li key={variant.id} className="flex items-center gap-4 bg-paper px-4 py-3">
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[14px] font-medium tracking-[-0.008em]">
                      {product.name}
                    </p>
                    <p className="tnum mt-0.5 text-[12.5px] text-muted">
                      {variant.size} · {qty} × {rupees(price.unitPrice)}
                    </p>
                  </div>
                  <p className="tnum text-[14px] font-medium">
                    {rupees(price.unitPrice * qty)}
                  </p>
                </li>
              );
            })}
          </ul>
        </div>
      </Container>
    </section>
  );
}
