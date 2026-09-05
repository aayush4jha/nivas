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

/**
 * [variantId, qty per order, days between orders, orders placed, cycle elapsed]
 *
 * The last figure is how far through its reorder cycle each item currently is:
 * 1.0 means due today, above 1.0 overdue, below 1.0 still has runway. It is
 * what decides whether an item appears under "Running low", so the spread here
 * is chosen to exercise every state — a couple overdue, a couple due soon, the
 * rest quiet. A demo account where nothing is ever due hides the one feature
 * the dashboard exists to show.
 */
const HISTORY: Array<[string, number, number, number, number]> = [
  ["commercial-floor-cleaner-citrus--10-l", 3, 28, 6, 1.22],
  ["garbage-bags-large-24-32-in--pack-of-30", 8, 21, 7, 1.08],
  ["dishwash-liquid-lime--25-l", 1, 24, 5, 0.96],
  ["liquid-handwash-rose--5-l", 4, 35, 4, 0.86],
  ["multifold-paper-towels--pack-of-20-3-000-sheets", 3, 26, 5, 0.78],
  ["heavy-duty-degreaser--5-l", 2, 45, 3, 0.55],
  ["nitrile-examination-gloves--large-box-of-100", 6, 30, 4, 0.40],
  ["commercial-laundry-detergent--5-l", 2, 60, 2, 0.28],
];

function datesFor(gapDays: number, count: number, elapsed: number, now: Date): Date[] {
  // Jitter each gap slightly so the predictor sees realistic variance rather
  // than a perfect arithmetic sequence.
  const jitter = [0, -3, 2, -1, 4, -2, 1];
  const dates: Date[] = [];
  // How long ago the most recent order was, as a fraction of the cycle.
  let offset = Math.round(gapDays * elapsed);
  for (let i = 0; i < count; i++) {
    dates.push(new Date(now.getTime() - offset * 86_400_000));
    offset += gapDays + jitter[i % jitter.length];
  }
  return dates;
}

export function trackedItems(now = new Date()): TrackedItem[] {
  return HISTORY.map(([variantId, qty, gap, count, elapsed]) => {
    const product = PRODUCTS.find((p) => p.variants.some((v) => v.id === variantId));
    const variant = product?.variants.find((v) => v.id === variantId);
    if (!product || !variant) return null;

    const orderDates = datesFor(gap, count, elapsed, now);
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
