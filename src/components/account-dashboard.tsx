"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import {
  ArrowDownRight,
  ArrowUpRight,
  Check,
  FileText,
  Package,
  RotateCcw,
  Truck,
} from "lucide-react";
import { ACCOUNT, MONTHLY_SPEND, RECENT_ORDERS, trackedItems } from "@/data/demo-account";
import { byUrgency } from "@/lib/reorder";
import { resolvePrice } from "@/lib/pricing";
import { rupees, cn } from "@/lib/format";
import { useCart } from "@/lib/cart";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { ProductArt } from "./product-art";

const STATUS_LABEL: Record<string, string> = {
  delivered: "Delivered",
  "out-for-delivery": "Out for delivery",
  packed: "Packed",
  confirmed: "Confirmed",
};

export function AccountDashboard() {
  const { add, account, setAccount } = useCart();
  const [addedKey, setAddedKey] = useState<string | null>(null);

  // Computed once per mount: prediction is relative to "now", and recomputing
  // it on every render would make the numbers twitch as the user interacts.
  const items = useMemo(() => trackedItems().sort(byUrgency), []);
  const dueNow = items.filter((i) => i.signal && i.signal.status !== "ok");
  const frequent = [...items].sort((a, b) => b.orderDates.length - a.orderDates.length).slice(0, 4);

  const spendDelta =
    ((MONTHLY_SPEND.current - MONTHLY_SPEND.previous) / MONTHLY_SPEND.previous) * 100;
  const spendDown = spendDelta < 0;

  const dueTotal = dueNow.reduce(
    (sum, i) => sum + resolvePrice(i.variant, i.qty, account).unitPrice * i.qty,
    0,
  );

  function addItem(key: string, productId: string, variantId: string, qty: number) {
    add(productId, variantId, qty);
    setAddedKey(key);
    window.setTimeout(() => setAddedKey(null), 1500);
  }

  function reorderAllDue() {
    for (const i of dueNow) add(i.product.id, i.variant.id, i.qty);
    setAddedKey("all");
    window.setTimeout(() => setAddedKey(null), 2000);
  }

  return (
    <Container className="py-10 md:py-14">
      {/* ── Header ──────────────────────────────────────────────────────── */}
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <p className="eyebrow">{ACCOUNT.businessType} · Business account</p>
          <h1 className="display mt-2.5 text-[32px] font-semibold md:text-[40px]">
            Good morning, {ACCOUNT.businessName}
          </h1>
          <p className="tnum mt-2 text-[13.5px] text-muted">
            GSTIN {ACCOUNT.gstin} · Member since {ACCOUNT.memberSince}
          </p>
        </div>
        <Badge tone="brand" className="mt-2 px-2 py-1 text-[12px] capitalize">
          {account} pricing
        </Badge>
      </div>

      {/* ── Quick actions ───────────────────────────────────────────────── */}
      <div className="mt-8 grid grid-cols-2 gap-2 md:grid-cols-4">
        <QuickAction href="/business" icon={Package} label="Browse products" />
        <QuickAction href="/bulk-quote" icon={FileText} label="Request bulk quote" />
        <QuickAction href="/cart" icon={RotateCcw} label="View cart" />
        <QuickAction href="/account" icon={Truck} label="Track orders" />
      </div>

      <div className="mt-10 grid gap-10 lg:grid-cols-[1.6fr_1fr] lg:gap-14">
        <div>
          {/* ── Running low ───────────────────────────────────────────── */}
          <section>
            <div className="flex flex-wrap items-end justify-between gap-3">
              <div>
                <h2 className="text-[19px] font-semibold tracking-[-0.015em]">Running low</h2>
                <p className="mt-1 text-[13.5px] text-ink-soft">
                  Predicted from how often you have reordered each item.
                </p>
              </div>
              {dueNow.length > 0 && (
                <Button size="sm" onClick={reorderAllDue} disabled={addedKey === "all"}>
                  {addedKey === "all" ? (
                    <>
                      <Check className="size-3.5" /> Added
                    </>
                  ) : (
                    <>
                      <RotateCcw className="size-3.5" /> Reorder all ·{" "}
                      <span className="tnum">{rupees(dueTotal)}</span>
                    </>
                  )}
                </Button>
              )}
            </div>

            {dueNow.length === 0 ? (
              <p className="mt-6 rounded-[var(--radius)] border border-line bg-surface px-4 py-8 text-center text-[14px] text-muted">
                Nothing due in the next week.
              </p>
            ) : (
              <ul className="mt-6 divide-y divide-line overflow-hidden rounded-[var(--radius)] border border-line">
                {dueNow.map((item) => {
                  const key = item.variant.id;
                  const price = resolvePrice(item.variant, item.qty, account);
                  const s = item.signal!;
                  return (
                    <li key={key} className="flex items-center gap-4 bg-surface px-4 py-4">
                      <div className="size-12 shrink-0 overflow-hidden rounded-[var(--radius)] bg-paper">
                        <ProductArt
                          swatch={item.product.swatch}
                          category={item.product.category}
                          size={item.variant.size}
                          className="size-full"
                        />
                      </div>

                      <div className="min-w-0 flex-1">
                        <Link
                          href={`/business/p/${item.product.slug}`}
                          className="block truncate text-[14.5px] font-medium tracking-[-0.008em] hover:underline"
                        >
                          {item.product.name}
                        </Link>
                        <p className="tnum mt-0.5 text-[12.5px] text-muted">
                          {item.variant.size} · usual order {item.qty} ·{" "}
                          {rupees(price.unitPrice)} each
                        </p>
                        <p
                          className={cn(
                            "tnum mt-1 text-[12.5px]",
                            s.status === "overdue" ? "text-warn" : "text-ink-soft",
                          )}
                        >
                          {s.status === "overdue"
                            ? `Due ${Math.abs(s.daysRemaining)} days ago`
                            : `Due in ${s.daysRemaining} days`}
                          <span className="text-muted">
                            {" "}
                            · you reorder about every {s.cycleDays} days
                            {!s.confident && " (low confidence)"}
                          </span>
                        </p>
                      </div>

                      <Button
                        size="sm"
                        variant={addedKey === key ? "primary" : "outline"}
                        onClick={() => addItem(key, item.product.id, item.variant.id, item.qty)}
                      >
                        {addedKey === key ? <Check className="size-3.5" /> : "Reorder"}
                      </Button>
                    </li>
                  );
                })}
              </ul>
            )}
          </section>

          {/* ── Recent orders ─────────────────────────────────────────── */}
          <section className="mt-14">
            <h2 className="text-[19px] font-semibold tracking-[-0.015em]">Recent orders</h2>
            <ul className="mt-6 divide-y divide-line overflow-hidden rounded-[var(--radius)] border border-line">
              {RECENT_ORDERS.map((order) => (
                <li
                  key={order.id}
                  className="flex flex-wrap items-center justify-between gap-3 bg-surface px-4 py-4"
                >
                  <div>
                    <p className="tnum text-[14.5px] font-medium">{order.id}</p>
                    <p className="tnum mt-0.5 text-[12.5px] text-muted">
                      {order.lines} lines ·{" "}
                      {order.placedDaysAgo === 0
                        ? "today"
                        : `${order.placedDaysAgo} days ago`}
                    </p>
                  </div>
                  <div className="flex items-center gap-4">
                    <Badge tone={order.status === "delivered" ? "neutral" : "brand"}>
                      {STATUS_LABEL[order.status]}
                    </Badge>
                    <p className="tnum w-20 text-right text-[14.5px] font-medium">
                      {rupees(order.total)}
                    </p>
                  </div>
                </li>
              ))}
            </ul>
          </section>
        </div>

        {/* ── Sidebar ───────────────────────────────────────────────────── */}
        <aside className="space-y-4">
          <div className="rounded-[var(--radius)] border border-line bg-surface p-6">
            <p className="eyebrow">This month</p>
            <p className="tnum mt-3 text-[34px] font-semibold leading-none tracking-[-0.025em]">
              {rupees(MONTHLY_SPEND.current)}
            </p>
            <p
              className={cn(
                "tnum mt-3 flex items-center gap-1 text-[13px]",
                spendDown ? "text-brand" : "text-warn",
              )}
            >
              {spendDown ? (
                <ArrowDownRight className="size-4" aria-hidden />
              ) : (
                <ArrowUpRight className="size-4" aria-hidden />
              )}
              {Math.abs(spendDelta).toFixed(0)}% vs last month
            </p>
            <p className="tnum mt-4 border-t border-line pt-4 text-[12.5px] text-muted">
              Last month {rupees(MONTHLY_SPEND.previous)}
            </p>
          </div>

          <div className="rounded-[var(--radius)] border border-line bg-surface p-6">
            <p className="eyebrow">Ordered most often</p>
            <ul className="mt-4 space-y-3">
              {frequent.map((item) => (
                <li key={item.variant.id} className="flex items-baseline justify-between gap-3">
                  <Link
                    href={`/business/p/${item.product.slug}`}
                    className="truncate text-[13.5px] text-ink-soft hover:text-ink"
                  >
                    {item.product.name}
                  </Link>
                  <span className="tnum shrink-0 text-[12.5px] text-muted">
                    ×{item.orderDates.length}
                  </span>
                </li>
              ))}
            </ul>
          </div>

          {/* Same tier switcher as the cart — a dashboard is where the value of
              moving up a tier is most obvious, because the spend is on screen. */}
          <div className="rounded-[var(--radius)] border border-line p-6">
            <p className="eyebrow">Pricing tier</p>
            <p className="mt-3 text-[13px] leading-relaxed text-ink-soft">
              Preview what another tier would do to your prices.
            </p>
            <div className="mt-4 flex gap-1">
              {(["retail", "business", "bulk"] as const).map((tier) => (
                <button
                  key={tier}
                  type="button"
                  onClick={() => setAccount(tier)}
                  aria-pressed={account === tier}
                  className={cn(
                    "rounded-full border px-3 py-1 text-[12.5px] capitalize transition-colors",
                    account === tier
                      ? "border-ink bg-ink text-paper"
                      : "border-line text-ink-soft hover:border-line-strong",
                  )}
                >
                  {tier}
                </button>
              ))}
            </div>
          </div>

          <p className="px-1 text-[12px] leading-relaxed text-muted">
            Demo account. Order history and predictions are seed data until
            Supabase auth and orders are wired up.
          </p>
        </aside>
      </div>
    </Container>
  );
}

function QuickAction({
  href,
  icon: Icon,
  label,
}: {
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  label: string;
}) {
  return (
    <Link
      href={href}
      className="flex items-center gap-2.5 rounded-[var(--radius)] border border-line bg-surface px-4 py-3.5 text-[13.5px] font-medium transition-colors hover:border-line-strong hover:bg-sunk"
    >
      <Icon className="size-4 shrink-0 text-brand" aria-hidden />
      <span className="truncate">{label}</span>
    </Link>
  );
}
