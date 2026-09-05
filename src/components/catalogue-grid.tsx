"use client";

import { useMemo, useState } from "react";
import { SlidersHorizontal } from "lucide-react";
import type { Mode, Product } from "@/lib/types";
import { startingPrice } from "@/lib/pricing";
import { cn } from "@/lib/format";
import { ProductCard } from "./product-card";

type Sort = "featured" | "price-asc" | "price-desc" | "rating";

const SORTS: Array<{ value: Sort; label: string }> = [
  { value: "featured", label: "Featured" },
  { value: "price-asc", label: "Price: low to high" },
  { value: "price-desc", label: "Price: high to low" },
  { value: "rating", label: "Top rated" },
];

/**
 * Catalogue grid with subcategory filtering and sort.
 *
 * Filtering happens client-side because the whole catalogue is a few hundred
 * rows. When it stops being a few hundred rows this becomes a server component
 * reading a filtered query — the props are already shaped for that.
 */
export function CatalogueGrid({
  products,
  mode,
  subcategories,
}: {
  products: Product[];
  mode: Mode;
  subcategories: string[];
}) {
  const [active, setActive] = useState<string | null>(null);
  const [sort, setSort] = useState<Sort>("featured");

  // Only offer filters that would actually return something.
  const available = useMemo(
    () => subcategories.filter((s) => products.some((p) => p.subcategory === s)),
    [subcategories, products],
  );

  const visible = useMemo(() => {
    const filtered = active ? products.filter((p) => p.subcategory === active) : products;
    const sorted = [...filtered];
    switch (sort) {
      case "price-asc":
        sorted.sort((a, b) => startingPrice(a) - startingPrice(b));
        break;
      case "price-desc":
        sorted.sort((a, b) => startingPrice(b) - startingPrice(a));
        break;
      case "rating":
        sorted.sort((a, b) => b.rating - a.rating);
        break;
      default:
        sorted.sort((a, b) => Number(!!b.featured) - Number(!!a.featured));
    }
    return sorted;
  }, [products, active, sort]);

  return (
    <>
      <div className="mb-8 flex flex-wrap items-center gap-3 border-b border-line pb-4">
        <div className="flex flex-wrap gap-1.5">
          <FilterChip active={active === null} onClick={() => setActive(null)}>
            All
          </FilterChip>
          {available.map((s) => (
            <FilterChip key={s} active={active === s} onClick={() => setActive(s)}>
              {s}
            </FilterChip>
          ))}
        </div>

        <label className="ml-auto flex items-center gap-2 text-[13px] text-muted">
          <SlidersHorizontal className="size-3.5" aria-hidden />
          <span className="sr-only sm:not-sr-only">Sort</span>
          <select
            value={sort}
            onChange={(e) => setSort(e.target.value as Sort)}
            className="rounded-[var(--radius)] border border-line bg-surface px-2 py-1.5 text-[13px] text-ink outline-none focus:border-line-strong"
          >
            {SORTS.map((s) => (
              <option key={s.value} value={s.value}>
                {s.label}
              </option>
            ))}
          </select>
        </label>
      </div>

      <p className="tnum mb-6 text-[13px] text-muted">
        {visible.length} {visible.length === 1 ? "product" : "products"}
      </p>

      {visible.length === 0 ? (
        <p className="py-16 text-center text-[15px] text-muted">
          Nothing here yet. Try another filter.
        </p>
      ) : (
        <div
          className={cn(
            "grid",
            mode === "business"
              ? "grid-cols-2 gap-3 lg:grid-cols-4"
              : "grid-cols-2 gap-x-5 gap-y-12 md:grid-cols-3 lg:grid-cols-4",
          )}
        >
          {visible.map((p) => (
            <ProductCard key={p.id} product={p} mode={mode} />
          ))}
        </div>
      )}
    </>
  );
}

function FilterChip({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      aria-pressed={active}
      className={cn(
        "rounded-full border px-3 py-1.5 text-[13px] transition-colors",
        active
          ? "border-ink bg-ink text-paper"
          : "border-line text-ink-soft hover:border-line-strong hover:text-ink",
      )}
    >
      {children}
    </button>
  );
}
