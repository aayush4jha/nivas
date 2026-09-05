import { PRODUCTS } from "./products";
import { predictReorder, type TrackedItem } from "@/lib/reorder";

/**
 * DEMO ACCOUNT — placeholder purchase history.
 *
 * Everything here is invented so the dashboard has something to reason about
 * before real orders exist. Dates are generated backwards from "today" so the
 * reorder predictions stay live no matter when the page is opened, rather than
 * going stale the week after this was written.
 *
 * Replace with a Supabase query against `orders` / `order_items`.
 */

export const ACCOUNT = {
  businessName: "Anchor & Oak",
  businessType: "Restaurant",
  contactName: "Priya",
  tier: "business" as const,
  gstin: "29ABCDE1234F1Z5",
  memberSince: "March 2025",
};

/** [variantId, qty per order, days between orders, orders placed] */
const HISTORY: Array<[string, number, number, number]> = [
  ["commercial-floor-cleaner-citrus--10-l", 3, 28, 6],
  ["dishwash-liquid-lime--25-l", 1, 24, 5],
  ["liquid-handwash-rose--5-l", 4, 35, 4],
  ["garbage-bags-large-24-32-in--pack-of-30", 8, 21, 7],
  ["heavy-duty-degreaser--5-l", 2, 45, 3],
  ["nitrile-examination-gloves--large-box-of-100", 6, 30, 4],
  ["multifold-paper-towels--pack-of-20-3-000-sheets", 3, 26, 5],
  ["commercial-laundry-detergent--5-l", 2, 60, 2],
];

function datesFor(gapDays: number, count: number, now: Date): Date[] {
  // Jitter each gap slightly so the predictor sees realistic variance rather
  // than a perfect arithmetic sequence.
  const jitter = [0, -3, 2, -1, 4, -2, 1];
  const dates: Date[] = [];
  let offset = Math.round(gapDays * 0.6); // days since the most recent order
  for (let i = 0; i < count; i++) {
    dates.push(new Date(now.getTime() - offset * 86_400_000));
    offset += gapDays + jitter[i % jitter.length];
  }
  return dates;
}

export function trackedItems(now = new Date()): TrackedItem[] {
  return HISTORY.map(([variantId, qty, gap, count]) => {
    const product = PRODUCTS.find((p) => p.variants.some((v) => v.id === variantId));
    const variant = product?.variants.find((v) => v.id === variantId);
    if (!product || !variant) return null;

    const orderDates = datesFor(gap, count, now);
    return { product, variant, qty, orderDates, signal: predictReorder(orderDates, now) };
  }).filter((x): x is TrackedItem => x !== null);
}

export interface DemoOrder {
  id: string;
  placedDaysAgo: number;
  status: "delivered" | "out-for-delivery" | "packed" | "confirmed";
  lines: number;
  total: number;
}

export const RECENT_ORDERS: DemoOrder[] = [
  { id: "NIV-10412", placedDaysAgo: 2, status: "out-for-delivery", lines: 6, total: 1_842_00 },
  { id: "NIV-10388", placedDaysAgo: 16, status: "delivered", lines: 9, total: 3_104_00 },
  { id: "NIV-10351", placedDaysAgo: 34, status: "delivered", lines: 5, total: 1_268_00 },
  { id: "NIV-10309", placedDaysAgo: 52, status: "delivered", lines: 11, total: 4_420_00 },
];

export const MONTHLY_SPEND = {
  current: 18_450_00,
  previous: 20_080_00,
};
