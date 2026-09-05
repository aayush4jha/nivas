import Link from "next/link";
import { Search, ShoppingBag, User } from "lucide-react";
import { CATEGORIES } from "@/data/categories";
import { MODE_CONFIG } from "@/lib/mode";
import type { Mode } from "@/lib/types";
import { Container } from "./ui/container";
import { CartCount } from "./cart-count";
import { cn } from "@/lib/format";

/**
 * The header carries the whole "one platform, two experiences" idea, so it does
 * three things at once: says which store you are in, lets you cross to the
 * other in one click, and keeps the categories for *this* store one row down.
 */
export function SiteHeader({ mode }: { mode: Mode }) {
  const config = MODE_CONFIG[mode];
  const categories = CATEGORIES.filter((c) => c.modes.includes(mode));

  return (
    <header className="sticky top-0 z-40 border-b border-line bg-paper/85 backdrop-blur-md">
      {/* Cross-sell strip. Deliberately quiet — it is a doorway, not a banner. */}
      <div className="border-b border-line bg-ink text-paper">
        <Container className="flex h-9 items-center justify-between text-[12px]">
          <p className="text-paper/70">
            {mode === "business"
              ? "Free delivery on orders over ₹2,500 · GST invoices on every order"
              : "Complimentary delivery over ₹2,500 · Refills on every formula"}
          </p>
          <Link
            href={`/${config.otherMode}`}
            className="font-medium text-paper underline-offset-4 hover:underline"
          >
            {config.switchLabel} →
          </Link>
        </Container>
      </div>

      <Container>
        <div className="flex h-16 items-center gap-6">
          <Link href={`/${mode}`} className="flex shrink-0 items-baseline gap-2">
            <span
              className={cn(
                "text-[19px] font-semibold tracking-[-0.02em]",
                mode === "premium" && "serif-display text-[23px]",
              )}
            >
              NIVAS
            </span>
            <span className="hidden text-[11px] text-muted sm:inline">
              {config.label}
            </span>
          </Link>

          <form action={`/${mode}/search`} className="relative hidden flex-1 md:block">
            <Search
              className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted"
              aria-hidden
            />
            <input
              name="q"
              type="search"
              placeholder={
                mode === "business"
                  ? "Search floor cleaner, garbage bags, gloves…"
                  : "Search handwash, body wash, home fragrance…"
              }
              aria-label="Search products"
              className="h-10 w-full rounded-[var(--radius)] border border-line bg-surface pl-9 pr-3 text-sm outline-none placeholder:text-muted focus:border-line-strong"
            />
          </form>

          <nav className="ml-auto flex items-center gap-1">
            {mode === "business" && (
              <Link
                href="/bulk-quote"
                className="hidden rounded-[var(--radius)] px-3 py-2 text-sm font-medium text-ink-soft hover:bg-sunk hover:text-ink lg:block"
              >
                Bulk quote
              </Link>
            )}
            <Link
              href="/account"
              aria-label="Account"
              className="rounded-[var(--radius)] p-2 text-ink-soft hover:bg-sunk hover:text-ink"
            >
              <User className="size-[18px]" />
            </Link>
            <Link
              href="/cart"
              aria-label="Cart"
              className="relative rounded-[var(--radius)] p-2 text-ink-soft hover:bg-sunk hover:text-ink"
            >
              <ShoppingBag className="size-[18px]" />
              <CartCount />
            </Link>
          </nav>
        </div>

        <nav
          aria-label={`${config.label} categories`}
          className="-mx-1 flex h-11 items-center gap-1 overflow-x-auto text-[13px] [scrollbar-width:none] [&::-webkit-scrollbar]:hidden"
        >
          {categories.map((c) => (
            <Link
              key={c.slug}
              href={`/${mode}/c/${c.slug}`}
              className="shrink-0 rounded-[var(--radius)] px-2.5 py-1.5 text-ink-soft transition-colors hover:bg-sunk hover:text-ink"
            >
              {c.name}
            </Link>
          ))}
          {mode === "business" && (
            <Link
              href="/register"
              className="ml-auto hidden shrink-0 rounded-[var(--radius)] px-2.5 py-1.5 font-medium text-brand hover:bg-brand-tint sm:block"
            >
              Open a business account
            </Link>
          )}
        </nav>
      </Container>
    </header>
  );
}
