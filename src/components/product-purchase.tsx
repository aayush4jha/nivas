"use client";

import Link from "next/link";
import { useState } from "react";
import { Check, Minus, Plus, TrendingDown } from "lucide-react";
import type { Mode, Product } from "@/lib/types";
import { resolvePrice } from "@/lib/pricing";
import { rupees, cn } from "@/lib/format";
import { useCart } from "@/lib/cart";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";

/**
 * The buy box.
 *
 * Business and Premium diverge hard here. Business gets the full price-break
 * ladder, a live unit price that moves as quantity changes, and a nudge toward
 * the next break — because a purchasing manager is optimising cost per unit.
 * Premium gets a size, a quantity, and a price, because a shopper is not.
 */
export function ProductPurchase({ product, mode }: { product: Product; mode: Mode }) {
  const { add, account } = useCart();
  const [variant, setVariant] = useState(product.variants[0]);
  const [qty, setQty] = useState(Math.max(1, product.variants[0].moq));
  const [added, setAdded] = useState(false);

  const price = resolvePrice(variant, qty, account);
  const lineTotal = price.unitPrice * qty;
  const lowStock = variant.stock <= variant.reorderPoint;
  const showTiers = mode === "business" && variant.tiers.length > 0;

  function selectVariant(id: string) {
    const next = product.variants.find((v) => v.id === id);
    if (!next) return;
    setVariant(next);
    // Never leave the quantity below the new variant's minimum.
    setQty((q) => Math.max(q, next.moq));
  }

  function handleAdd() {
    add(product.id, variant.id, qty);
    setAdded(true);
    window.setTimeout(() => setAdded(false), 2000);
  }

  return (
    <div>
      {/* ── Price ───────────────────────────────────────────────────────── */}
      <div className="flex flex-wrap items-baseline gap-3">
        <p className="tnum text-[34px] font-semibold leading-none tracking-[-0.025em]">
          {rupees(price.unitPrice)}
        </p>
        {price.unitPrice < price.listPrice && (
          <>
            <p className="tnum text-[16px] text-muted line-through">
              {rupees(price.listPrice)}
            </p>
            <Badge tone="brand">
              {Math.round(((price.listPrice - price.unitPrice) / price.listPrice) * 100)}% off
            </Badge>
          </>
        )}
        <span className="text-[13px] text-muted">per {variant.size}</span>
      </div>

      {mode === "business" && (
        <p className="mt-1.5 text-[13px] text-muted">
          {variant.gstRate}% GST extra · SKU <span className="tnum">{variant.sku}</span>
        </p>
      )}

      {/* ── Sizes ───────────────────────────────────────────────────────── */}
      <fieldset className="mt-8">
        <legend className="eyebrow mb-3">
          {product.variants.length > 1 ? "Choose a size" : "Size"}
        </legend>
        <div className="flex flex-wrap gap-2">
          {product.variants.map((v) => {
            const vp = resolvePrice(v, Math.max(qty, v.moq), account);
            const isActive = v.id === variant.id;
            return (
              <button
                key={v.id}
                type="button"
                onClick={() => selectVariant(v.id)}
                aria-pressed={isActive}
                className={cn(
                  "min-w-[104px] rounded-[var(--radius)] border px-3.5 py-2.5 text-left transition-colors",
                  isActive
                    ? "border-ink bg-ink text-paper"
                    : "border-line hover:border-line-strong",
                )}
              >
                <span className="block text-[13.5px] font-medium">{v.size}</span>
                <span
                  className={cn(
                    "tnum mt-0.5 block text-[12.5px]",
                    isActive ? "text-paper/65" : "text-muted",
                  )}
                >
                  {rupees(vp.unitPrice)}
                </span>
              </button>
            );
          })}
        </div>
      </fieldset>

      {/* ── Price breaks ────────────────────────────────────────────────── */}
      {showTiers && (
        <div className="mt-8">
          <p className="eyebrow mb-3">Price breaks</p>
          <table className="w-full border-collapse overflow-hidden rounded-[var(--radius)] border border-line text-[13px]">
            <thead>
              <tr className="bg-sunk text-left text-muted">
                <th scope="col" className="px-3 py-2 font-medium">Quantity</th>
                <th scope="col" className="px-3 py-2 font-medium">Per unit</th>
                <th scope="col" className="px-3 py-2 font-medium">Requires</th>
              </tr>
            </thead>
            <tbody>
              <TierRow
                label="1+"
                unit={variant.listPrice}
                requires="Anyone"
                active={price.appliedTier === null}
              />
              {variant.tiers.map((t, i) => (
                <TierRow
                  key={`${t.minQty}-${t.requires}-${i}`}
                  label={`${t.minQty}+`}
                  unit={t.unitPrice}
                  requires={t.requires === "business" ? "Business account" : "Anyone"}
                  active={price.appliedTier === t}
                />
              ))}
            </tbody>
          </table>

          {price.nextTier && (
            <p className="mt-3 flex items-start gap-2 rounded-[var(--radius)] bg-brand-tint px-3 py-2.5 text-[13px] text-brand">
              <TrendingDown className="mt-px size-4 shrink-0" aria-hidden />
              <span>
                Add <span className="tnum font-semibold">{price.nextTier.unitsAway} more</span> to
                drop to{" "}
                <span className="tnum font-semibold">
                  {rupees(price.nextTier.tier.unitPrice)}
                </span>{" "}
                per unit
                {price.nextTier.tier.requires === "business" && (
                  <>
                    {" "}
                    — <Link href="/register" className="underline">open a business account</Link>
                  </>
                )}
                .
              </span>
            </p>
          )}
        </div>
      )}

      {/* ── Quantity and add ────────────────────────────────────────────── */}
      <div className="mt-8 flex flex-wrap items-center gap-3">
        <div className="flex h-12 items-center rounded-[var(--radius)] border border-line-strong">
          <button
            type="button"
            onClick={() => setQty((q) => Math.max(variant.moq, q - 1))}
            disabled={qty <= variant.moq}
            aria-label="Decrease quantity"
            className="flex size-11 items-center justify-center text-ink-soft hover:text-ink disabled:opacity-30"
          >
            <Minus className="size-4" />
          </button>
          <input
            type="number"
            value={qty}
            min={variant.moq}
            aria-label="Quantity"
            onChange={(e) =>
              setQty(Math.max(variant.moq, Number(e.target.value) || variant.moq))
            }
            className="tnum h-full w-14 border-x border-line bg-transparent text-center text-[15px] font-medium outline-none [appearance:textfield] [&::-webkit-inner-spin-button]:appearance-none"
          />
          <button
            type="button"
            onClick={() => setQty((q) => q + 1)}
            aria-label="Increase quantity"
            className="flex size-11 items-center justify-center text-ink-soft hover:text-ink"
          >
            <Plus className="size-4" />
          </button>
        </div>

        <Button size="lg" onClick={handleAdd} className="min-w-[210px] flex-1 sm:flex-none">
          {added ? (
            <>
              <Check className="size-4" /> Added
            </>
          ) : (
            <>
              {mode === "business" ? "Add to business cart" : "Add to cart"} ·{" "}
              <span className="tnum">{rupees(lineTotal)}</span>
            </>
          )}
        </Button>
      </div>

      <div className="mt-4 flex flex-wrap gap-x-5 gap-y-1.5 text-[12.5px] text-muted">
        {variant.moq > 1 && <span className="tnum">Minimum order {variant.moq}</span>}
        <span className={cn("tnum", lowStock && "text-warn")}>
          {lowStock ? `Only ${variant.stock} left` : `${variant.stock} in stock`}
        </span>
        {price.savings > 0 && (
          <span className="tnum text-brand">
            You save {rupees(price.savings)} on this line
          </span>
        )}
      </div>
    </div>
  );
}

function TierRow({
  label,
  unit,
  requires,
  active,
}: {
  label: string;
  unit: number;
  requires: string;
  active: boolean;
}) {
  return (
    <tr
      className={cn(
        "border-t border-line",
        active ? "bg-brand-tint font-medium text-brand" : "text-ink-soft",
      )}
    >
      <td className="tnum px-3 py-2">{label}</td>
      <td className="tnum px-3 py-2">{rupees(unit)}</td>
      <td className="px-3 py-2">{requires}</td>
    </tr>
  );
}
