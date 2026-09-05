import type { Mode } from "./types";
import { createPersistedStore } from "./persisted-store";

/**
 * Which storefront the visitor was last in.
 *
 * Cart, checkout, quotes and the account area sit outside the `/[mode]` tree
 * because they are shared, but they still have to *look* like the store the
 * visitor came from. Remembering the last mode is what stops a Premium shopper
 * landing in a cart that suddenly reads like a wholesale portal.
 *
 * Business is the default: it is the core of the business, and the safer guess
 * for anyone arriving cold on a shared page.
 */
function isMode(value: unknown): value is Mode {
  return value === "business" || value === "premium";
}

export const modeStore = createPersistedStore<Mode>("nivas.mode.v1", "business", isMode);
