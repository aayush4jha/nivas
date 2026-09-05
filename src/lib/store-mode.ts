import type { Mode } from "./types";

/**
 * Which storefront the visitor was last in.
 *
 * Cart, checkout, quotes and the account area sit outside the `/[mode]` tree
 * because they are shared, but they still have to *look* like the store the
 * visitor came from. Remembering the last mode is what stops a Premium shopper
 * landing in a cart that suddenly reads like a wholesale portal.
 */
const KEY = "nivas.mode.v1";

export function rememberMode(mode: Mode): void {
  try {
    localStorage.setItem(KEY, mode);
  } catch {
    /* private browsing — fall back to the default */
  }
}

export function recallMode(): Mode {
  try {
    const stored = localStorage.getItem(KEY);
    if (stored === "premium" || stored === "business") return stored;
  } catch {
    /* ignore */
  }
  // Business is the core of the business, so it is the safer default.
  return "business";
}
