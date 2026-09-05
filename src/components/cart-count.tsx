"use client";

import { useCart } from "@/lib/cart";

/**
 * The little number on the bag. Renders nothing until the cart has hydrated
 * from localStorage, which avoids a flash of "0" on every page load.
 */
export function CartCount() {
  const { totals, hydrated } = useCart();
  if (!hydrated || totals.itemCount === 0) return null;

  return (
    <span className="tnum absolute -right-0.5 -top-0.5 flex h-[17px] min-w-[17px] items-center justify-center rounded-full bg-brand px-1 text-[10px] font-semibold text-brand-ink">
      {totals.itemCount > 99 ? "99+" : totals.itemCount}
    </span>
  );
}
