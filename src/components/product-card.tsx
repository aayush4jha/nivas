"use client";

import Link from "next/link";
import { useState } from "react";
import { Check, Plus, Star } from "lucide-react";
import type { Mode, Product } from "@/lib/types";
import { resolvePrice, floorPrice } from "@/lib/pricing";
import { rupees, cn } from "@/lib/format";
import { useCart } from "@/lib/cart";
import { ProductArt } from "./product-art";
import { Badge } from "./ui/badge";

/**
 * Two cards, one component.
 *
 * Business needs to answer "which pack size, at what unit price, how fast can I
 * add it" — so every variant and its price is on the card itself, no click
 * through required. Premium needs to answer "do I want this" — so it is mostly
 * photograph, with a single price and a lot of air.
 */
export function ProductCard({ product, mode }: { product: Product; mode: Mode }) {
  return mode === "business" ? (
    <BusinessCard product={product} />
  ) : (
    <PremiumCard product={product} />
  );
}

function BusinessCard({ product }: { product: Product }) {
  const { add, account } = useCart();
  const [selected, setSelected] = useState(product.variants[0]);
  const [justAdded, setJustAdded] = useState(false);

  const price = resolvePrice(selected, Math.max(1, selected.moq), account);
  const best = floorPrice(selected);
  const hasBreaks = best < selected.listPrice;
  const lowStock = selected.stock <= selected.reorderPoint;

  function handleAdd() {
    add(product.id, selected.id, Math.max(1, selected.moq));
    setJustAdded(true);
    window.setTimeout(() => setJustAdded(false), 1400);
  }

  return (
    <article className="group flex flex-col overflow-hidden rounded-[var(--radius)] border border-line bg-surface transition-colors hover:border-line-strong">
      <Link href={`/business/p/${product.slug}`} className="relative block">
        <ProductArt
          swatch={product.swatch}
          category={product.category}
          size={selected.size}
          className="aspect-[4/3] w-full"
        />
        {lowStock && (
          <span className="absolute left-2 top-2">
            <Badge tone="warn">Low stock</Badge>
          </span>
        )}
      </Link>

      <div className="flex flex-1 flex-col p-3.5">
        <p className="text-[11px] font-medium uppercase tracking-wider text-muted">
          {product.brand}
        </p>
        <Link
          href={`/business/p/${product.slug}`}
          className="mt-1 line-clamp-2 text-[15px] font-medium leading-snug tracking-[-0.011em] hover:underline"
        >
          {product.name}
        </Link>

        <div className="mt-1.5 flex items-center gap-1 text-[12px] text-muted">
          <Star className="size-3 fill-current text-ink-soft" aria-hidden />
          <span className="tnum">{product.rating.toFixed(1)}</span>
          <span>({product.reviewCount})</span>
        </div>

        {/* Pack sizes as a segmented control. This is the whole point of the
            B2B card: comparing unit price across sizes without leaving the grid. */}
        <div className="mt-3 flex flex-wrap gap-1" role="group" aria-label="Pack size">
          {product.variants.map((v) => (
            <button
              key={v.id}
              type="button"
              onClick={() => setSelected(v)}
              aria-pressed={v.id === selected.id}
              className={cn(
                "tnum rounded-[3px] border px-2 py-1 text-[12px] transition-colors",
                v.id === selected.id
                  ? "border-ink bg-ink text-paper"
                  : "border-line text-ink-soft hover:border-line-strong",
              )}
            >
              {v.size}
            </button>
          ))}
        </div>

        <div className="mt-3 flex items-end justify-between gap-2">
          <div>
            <p className="tnum text-[19px] font-semibold leading-none tracking-[-0.02em]">
              {rupees(price.unitPrice)}
            </p>
            {hasBreaks && (
              <p className="tnum mt-1 text-[12px] text-muted">
                from {rupees(best)} in bulk
              </p>
            )}
          </div>
          <button
            type="button"
            onClick={handleAdd}
            aria-label={`Add ${product.name}, ${selected.size}, to cart`}
            className={cn(
              "flex size-9 shrink-0 items-center justify-center rounded-[var(--radius)] transition-colors",
              justAdded
                ? "bg-brand text-brand-ink"
                : "border border-line-strong text-ink hover:bg-ink hover:text-paper",
            )}
          >
            {justAdded ? <Check className="size-4" /> : <Plus className="size-4" />}
          </button>
        </div>

        {selected.moq > 1 && (
          <p className="tnum mt-2 text-[11px] text-muted">Min. order {selected.moq}</p>
        )}
      </div>
    </article>
  );
}

function PremiumCard({ product }: { product: Product }) {
  const [selected] = useState(product.variants[0]);

  return (
    <article className="group">
      <Link href={`/premium/p/${product.slug}`} className="block">
        <div className="overflow-hidden rounded-[var(--radius-lg)] bg-surface">
          <ProductArt
            swatch={product.swatch}
            category={product.category}
            size={selected.size}
            className="aspect-[4/5] w-full transition-transform duration-500 ease-out group-hover:scale-[1.03]"
          />
        </div>
        <div className="mt-4">
          <h3 className="text-[17px] font-medium tracking-[-0.015em]">{product.name}</h3>
          <p className="mt-1 line-clamp-2 text-[13px] leading-relaxed text-ink-soft">
            {product.shortDescription}
          </p>
          <p className="tnum mt-2.5 text-[15px]">
            {rupees(selected.listPrice)}
            {product.variants.length > 1 && (
              <span className="text-muted"> · {product.variants.length} sizes</span>
            )}
          </p>
        </div>
      </Link>
    </article>
  );
}
