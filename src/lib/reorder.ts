import type { Product, Variant } from "./types";

/**
 * Reorder prediction.
 *
 * The premise: a business consumes a SKU at a roughly steady rate, so the gap
 * between its past orders predicts the next one. Given order dates for a SKU,
 * the mean gap is the cycle, and cycle minus days-since-last is the runway.
 *
 * Deliberately simple. A mean over the last few intervals beats a seasonal
 * model at this data volume, and — more importantly — it can be explained to a
 * customer in one sentence, which is what makes them trust the nudge enough to
 * act on it. Revisit once there is a year of real purchase history.
 */

export interface ReorderSignal {
  /** Average days between orders of this SKU. */
  cycleDays: number;
  daysSinceLast: number;
  /** Days until predicted depletion. Negative means overdue. */
  daysRemaining: number;
  status: "overdue" | "due-soon" | "ok";
  /** Enough history to say anything at all. */
  confident: boolean;
}

/** Flag a reorder this many days before predicted depletion. */
const DUE_SOON_WINDOW = 7;

export function predictReorder(orderDates: Date[], now = new Date()): ReorderSignal | null {
  if (orderDates.length < 2) return null;

  const sorted = [...orderDates].sort((a, b) => a.getTime() - b.getTime());
  const gaps: number[] = [];
  for (let i = 1; i < sorted.length; i++) {
    gaps.push((sorted[i].getTime() - sorted[i - 1].getTime()) / 86_400_000);
  }

  const cycleDays = Math.round(gaps.reduce((a, b) => a + b, 0) / gaps.length);
  const daysSinceLast = Math.round(
    (now.getTime() - sorted[sorted.length - 1].getTime()) / 86_400_000,
  );
  const daysRemaining = cycleDays - daysSinceLast;

  return {
    cycleDays,
    daysSinceLast,
    daysRemaining,
    status: daysRemaining < 0 ? "overdue" : daysRemaining <= DUE_SOON_WINDOW ? "due-soon" : "ok",
    // Three orders is the point where a mean gap stops being one coincidence.
    confident: orderDates.length >= 3,
  };
}

export interface TrackedItem {
  product: Product;
  variant: Variant;
  qty: number;
  orderDates: Date[];
  signal: ReorderSignal | null;
}

/** Sort by urgency: overdue first, then soonest due. */
export function byUrgency(a: TrackedItem, b: TrackedItem): number {
  const ra = a.signal?.daysRemaining ?? Infinity;
  const rb = b.signal?.daysRemaining ?? Infinity;
  return ra - rb;
}
