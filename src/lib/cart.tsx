"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import type { AccountTier, CartLine } from "./types";
import { PRODUCTS } from "@/data/products";
import { priceCart, type CartTotals } from "./pricing";

/**
 * Client-side cart.
 *
 * V1 keeps the cart in localStorage so the app is fully usable before Supabase
 * is provisioned. The shape is deliberately the same one the `carts` /
 * `cart_items` tables use, so moving to server-persisted carts is a swap of
 * this provider's internals, not a change to any component that consumes it.
 */

const STORAGE_KEY = "nivas.cart.v1";
const ACCOUNT_KEY = "nivas.account.v1";

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
  /** False until localStorage has been read, so SSR and first paint agree. */
  hydrated: boolean;
}

const CartContext = createContext<CartContextValue | null>(null);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [lines, setLines] = useState<CartLine[]>([]);
  const [account, setAccountState] = useState<AccountTier>("retail");
  const [hydrated, setHydrated] = useState(false);

  // Read persisted state after mount. Doing this in an effect rather than in
  // useState's initialiser keeps the server and client first render identical.
  useEffect(() => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (raw) setLines(JSON.parse(raw) as CartLine[]);
      const acct = localStorage.getItem(ACCOUNT_KEY);
      if (acct === "business" || acct === "bulk" || acct === "enterprise") {
        setAccountState(acct);
      }
    } catch {
      // Private browsing, blocked site data, corrupt JSON — start empty.
    }
    setHydrated(true);
  }, []);

  useEffect(() => {
    if (!hydrated) return;
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(lines));
    } catch {
      // Nothing useful to do; the cart still works for this page view.
    }
  }, [lines, hydrated]);

  const setAccount = useCallback((tier: AccountTier) => {
    setAccountState(tier);
    try {
      localStorage.setItem(ACCOUNT_KEY, tier);
    } catch {
      /* ignore */
    }
  }, []);

  const add = useCallback((productId: string, variantId: string, qty = 1) => {
    setLines((prev) => {
      const existing = prev.find((l) => l.variantId === variantId);
      if (existing) {
        return prev.map((l) =>
          l.variantId === variantId ? { ...l, qty: l.qty + qty } : l,
        );
      }
      return [...prev, { productId, variantId, qty }];
    });
  }, []);

  const setQty = useCallback((variantId: string, qty: number) => {
    setLines((prev) =>
      qty <= 0
        ? prev.filter((l) => l.variantId !== variantId)
        : prev.map((l) => (l.variantId === variantId ? { ...l, qty } : l)),
    );
  }, []);

  const remove = useCallback((variantId: string) => {
    setLines((prev) => prev.filter((l) => l.variantId !== variantId));
  }, []);

  const clear = useCallback(() => setLines([]), []);

  const totals = useMemo(
    () => priceCart(lines, PRODUCTS, account),
    [lines, account],
  );

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
