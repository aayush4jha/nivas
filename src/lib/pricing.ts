import type { AccountTier, CartLine, PriceTier, Product, Variant } from "./types";

/**
 * All money in this codebase is an integer number of paise. Never a float.
 * ₹349.50 is 34950. Conversion to rupees happens only at the formatting edge.
 */

const TIER_RANK: Record<AccountTier, number> = {
  retail: 0,
  business: 1,
  bulk: 2,
  enterprise: 3,
};

/** Can an account of `account` tier use a price break gated at `required`? */
export function qualifies(account: AccountTier, required: AccountTier): boolean {
  return TIER_RANK[account] >= TIER_RANK[required];
}

export interface ResolvedPrice {
  /** Paise per unit actually charged. */
  unitPrice: number;
  /** Paise per unit at list. Used to render the struck-through price. */
  listPrice: number;
  /** The break that produced `unitPrice`, or null if buying at list. */
  appliedTier: PriceTier | null;
  /** Paise saved across the whole line versus list price. */
  savings: number;
  /**
   * The next break the buyer has not yet reached, if any. Powers the
   * "add 2 more to save ₹120" nudge, which is the single highest-leverage
   * piece of copy on a B2B product card.
   */
  nextTier: { tier: PriceTier; unitsAway: number; extraSavingPerUnit: number } | null;
}

/**
 * Resolve what one unit costs, given how many are being bought and who is buying.
 *
 * Picks the cheapest tier the buyer qualifies for on BOTH counts: quantity
 * (`minQty`) and account level (`requires`). Falls back to list price, so an
 * anonymous shopper always gets a valid price and never a zero.
 */
export function resolvePrice(
  variant: Variant,
  qty: number,
  account: AccountTier = "retail",
): ResolvedPrice {
  const eligible = variant.tiers.filter(
    (t) => qty >= t.minQty && qualifies(account, t.requires),
  );

  const best = eligible.reduce<PriceTier | null>(
    (lowest, t) => (lowest === null || t.unitPrice < lowest.unitPrice ? t : lowest),
    null,
  );

  const unitPrice = best && best.unitPrice < variant.listPrice ? best.unitPrice : variant.listPrice;
  const appliedTier = unitPrice === variant.listPrice ? null : best;

  // The cheapest break the buyer qualifies for on account but not yet on quantity.
  const upcoming = variant.tiers
    .filter((t) => qty < t.minQty && qualifies(account, t.requires) && t.unitPrice < unitPrice)
    .sort((a, b) => a.minQty - b.minQty)[0];

  return {
    unitPrice,
    listPrice: variant.listPrice,
    appliedTier,
    savings: (variant.listPrice - unitPrice) * qty,
    nextTier: upcoming
      ? {
          tier: upcoming,
          unitsAway: upcoming.minQty - qty,
          extraSavingPerUnit: unitPrice - upcoming.unitPrice,
        }
      : null,
  };
}

/**
 * The lowest per-unit price this variant can ever reach, for "from ₹X" copy on
 * listing cards. Ignores account gating on purpose — the point of the label is
 * to show a retail visitor what a business account would unlock.
 */
export function floorPrice(variant: Variant): number {
  return variant.tiers.reduce((min, t) => Math.min(min, t.unitPrice), variant.listPrice);
}

/** Cheapest entry point across all pack sizes, for category grids. */
export function startingPrice(product: Product): number {
  return product.variants.reduce((min, v) => Math.min(min, v.listPrice), Infinity);
}

export interface CartTotals {
  lines: Array<{
    line: CartLine;
    product: Product;
    variant: Variant;
    price: ResolvedPrice;
    lineTotal: number;
    gst: number;
  }>;
  /** Sum of line totals, GST-exclusive. */
  subtotal: number;
  gst: number;
  shipping: number;
  total: number;
  /** Total saved versus list price. The number the business cart brags about. */
  savings: number;
  itemCount: number;
}

/** Free delivery above this order value (paise). */
export const FREE_SHIPPING_THRESHOLD = 250_000;
export const SHIPPING_FLAT = 9_900;

/**
 * Price a whole cart. Each line resolves its own tier independently — we
 * deliberately do NOT pool quantities across different variants, because a
 * supplier price break is per-SKU, not per-order.
 */
export function priceCart(
  cart: CartLine[],
  catalog: Product[],
  account: AccountTier = "retail",
): CartTotals {
  const lines: CartTotals["lines"] = [];

  for (const line of cart) {
    const product = catalog.find((p) => p.id === line.productId);
    const variant = product?.variants.find((v) => v.id === line.variantId);
    if (!product || !variant) continue; // stale cart entry; drop it silently

    const price = resolvePrice(variant, line.qty, account);
    const lineTotal = price.unitPrice * line.qty;
    lines.push({
      line,
      product,
      variant,
      price,
      lineTotal,
      gst: Math.round((lineTotal * variant.gstRate) / 100),
    });
  }

  const subtotal = lines.reduce((s, l) => s + l.lineTotal, 0);
  const gst = lines.reduce((s, l) => s + l.gst, 0);
  const savings = lines.reduce((s, l) => s + l.price.savings, 0);
  const shipping = subtotal === 0 || subtotal >= FREE_SHIPPING_THRESHOLD ? 0 : SHIPPING_FLAT;

  return {
    lines,
    subtotal,
    gst,
    shipping,
    total: subtotal + gst + shipping,
    savings,
    itemCount: lines.reduce((s, l) => s + l.line.qty, 0),
  };
}
