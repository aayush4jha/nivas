/**
 * Domain types for the platform.
 *
 * The single most important idea here: a *product* is a thing we sell
 * (e.g. "Commercial Floor Cleaner"), and a *variant* is a specific pack size
 * of it (5 L, 10 L, 25 L). Pricing, stock and MOQ all live on the variant,
 * never on the product. A 5 L jar and a 25 L drum are different economics.
 */

/** Which storefront the shopper is in. Drives pricing, layout and copy. */
export type Mode = "business" | "premium";

/**
 * What kind of buyer the *account* is. Distinct from `Mode`: an individual can
 * browse the business store, but they still get `retail` pricing. Only an
 * approved business account unlocks `business`, and volume unlocks `bulk`.
 */
export type AccountTier = "retail" | "business" | "bulk" | "enterprise";

export type BusinessType =
  | "restaurant"
  | "cafe"
  | "hotel"
  | "hostel"
  | "office"
  | "gym"
  | "salon"
  | "school"
  | "clinic"
  | "other";

export type CategorySlug =
  | "cleaning"
  | "hygiene"
  | "kitchen"
  | "waste"
  | "laundry"
  | "equipment"
  | "hospitality"
  | "premium";

export interface Category {
  slug: CategorySlug;
  name: string;
  /** Short line used on category cards. */
  tagline: string;
  icon: string;
  /** Which storefronts this category appears in. */
  modes: Mode[];
  subcategories: string[];
}

/**
 * A price break. `minQty` is inclusive: a tier of `{ minQty: 6 }` applies from
 * the 6th unit onward. Tiers are stored ascending and resolved by the pricing
 * engine, which picks the *best* tier the buyer qualifies for.
 */
export interface PriceTier {
  minQty: number;
  /** Paise per unit, to avoid float drift. Always integer. */
  unitPrice: number;
  /** Lowest account tier that may use this break. */
  requires: AccountTier;
  label?: string;
}

export interface Variant {
  id: string;
  /** Human pack size, e.g. "5 L", "500 ml", "Pack of 30". */
  size: string;
  sku: string;
  /** MRP / list price in paise. What an anonymous retail buyer pays for one. */
  listPrice: number;
  /** What we pay the supplier, in paise. Never exposed to the storefront. */
  costPrice: number;
  tiers: PriceTier[];
  /** Minimum order quantity. 1 for retail packs, higher for drums. */
  moq: number;
  stock: number;
  /** Below this, admin gets a reorder warning. */
  reorderPoint: number;
  gstRate: number;
  weightGrams: number;
}

export interface Product {
  id: string;
  slug: string;
  name: string;
  brand: string;
  category: CategorySlug;
  subcategory: string;
  /** Which storefronts this product is listed in. Some appear in both. */
  modes: Mode[];
  shortDescription: string;
  description: string;
  /** Bullet points shown on the product page. */
  highlights: string[];
  variants: Variant[];
  rating: number;
  reviewCount: number;
  /** Drives the placeholder artwork until real photography exists. */
  swatch: string;
  featured?: boolean;
}

export interface CartLine {
  productId: string;
  variantId: string;
  qty: number;
}
