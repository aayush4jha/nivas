"use client";

import { createContext, useCallback, useContext, useMemo, useSyncExternalStore } from "react";
import type { AccountTier, CartLine } from "./types";
import { PRODUCTS } from "@/data/products";
import { priceCart, type CartTotals } from "./pricing";
import { createPersistedStore, hydrationStore } from "./persisted-store";

/**
 * Client-side cart.
 *
 * V1 persists to localStorage so the app is fully usable before Supabase is
 * provisioned. The shape is deliberately the same one the `carts` /
 * `cart_items` tables use, so moving to server-persisted carts replaces this
 * provider's internals without touching a single consumer.
 */

const ACCOUNT_TIERS: AccountTier[] = ["retail", "business", "bulk", "enterprise"];

function isCart(value: unknown): value is CartLine[] {
  return (
    Array.isArray(value) &&
    value.every(
      (l): l is CartLine =>
        typeof l === "object" &&
        l !== null &&
        typeof (l as CartLine).productId === "string" &&
        typeof (l as CartLine).variantId === "string" &&
        typeof (l as CartLine).qty === "number",
    )
  );
}

function isTier(value: unknown): value is AccountTier {
  return typeof value === "string" && (ACCOUNT_TIERS as string[]).includes(value);
}

const EMPTY_CART: CartLine[] = [];
const cartStore = createPersistedStore<CartLine[]>("nivas.cart.v1", EMPTY_CART, isCart);
const accountStore = createPersistedStore<AccountTier>("nivas.account.v1", "retail", isTier);

interface CartContextValue {
  lines: CartLine[];
  /** Pricing tier of the signed-in account. Drives every price on screen. */
  account: AccountTier;
  setAccount: (tier: AccountTier) => void;
  totals: CartTotals;
  add: (productId: string, variantId: string, qty?: number) => void;
  setQty: (variantId: string, qty: number) => void;
  remove: (variantId: string) => void;
  clear: () => void;
  /** False during SSR and the hydration render. */
  hydrated: boolean;
}

const CartContext = createContext<CartContextValue | null>(null);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const lines = useSyncExternalStore(
    cartStore.subscribe,
    cartStore.getSnapshot,
    cartStore.getServerSnapshot,
  );
  const account = useSyncExternalStore(
    accountStore.subscribe,
    accountStore.getSnapshot,
    accountStore.getServerSnapshot,
  );
  const hydrated = useSyncExternalStore(
    hydrationStore.subscribe,
    hydrationStore.getSnapshot,
    hydrationStore.getServerSnapshot,
  );

  const setAccount = useCallback((tier: AccountTier) => accountStore.set(tier), []);

  const add = useCallback((productId: string, variantId: string, qty = 1) => {
    cartStore.update((prev) =>
      prev.some((l) => l.variantId === variantId)
        ? prev.map((l) => (l.variantId === variantId ? { ...l, qty: l.qty + qty } : l))
        : [...prev, { productId, variantId, qty }],
    );
  }, []);

  const setQty = useCallback((variantId: string, qty: number) => {
    cartStore.update((prev) =>
      qty <= 0
        ? prev.filter((l) => l.variantId !== variantId)
        : prev.map((l) => (l.variantId === variantId ? { ...l, qty } : l)),
    );
  }, []);

  const remove = useCallback((variantId: string) => {
    cartStore.update((prev) => prev.filter((l) => l.variantId !== variantId));
  }, []);

  const clear = useCallback(() => cartStore.set(EMPTY_CART), []);

  const totals = useMemo(() => priceCart(lines, PRODUCTS, account), [lines, account]);

  const value = useMemo(
    () => ({ lines, account, setAccount, totals, add, setQty, remove, clear, hydrated }),
    [lines, account, setAccount, totals, add, setQty, remove, clear, hydrated],
  );

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}

export function useCart(): CartContextValue {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error("useCart must be used inside <CartProvider>");
  return ctx;
}
