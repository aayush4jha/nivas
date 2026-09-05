import Link from "next/link";
import {
  ArrowRight,
  BedDouble,
  Building2,
  CalendarClock,
  Droplets,
  FileText,
  Headset,
  RotateCcw,
  ShieldCheck,
  Shirt,
  SprayCan,
  Sparkles,
  Trash2,
  Truck,
  UtensilsCrossed,
  Wrench,
} from "lucide-react";
import { CATEGORIES } from "@/data/categories";
import { featured } from "@/data/products";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Section, SectionHead } from "./section";
import { ProductCard } from "./product-card";
import { ReorderStrip } from "./reorder-strip";

const ICONS: Record<string, React.ComponentType<{ className?: string }>> = {
  SprayCan,
  Droplets,
  UtensilsCrossed,
  Trash2,
  Shirt,
  Wrench,
  BedDouble,
  Sparkles,
};

const SEGMENTS = [
  {
    title: "Restaurants & cafés",
    blurb: "Kitchen degreasers, dishwash, floor care, gloves, bin liners.",
    href: "/business/c/kitchen",
  },
  {
    title: "Hotels & stays",
    blurb: "Guest amenities, linen, laundry chemicals, housekeeping supplies.",
    href: "/business/c/hospitality",
  },
  {
    title: "Offices & gyms",
    blurb: "Washroom consumables, surface disinfection, waste management.",
    href: "/business/c/hygiene",
  },
];

const ADVANTAGES = [
  { icon: Building2, title: "Business pricing", body: "Tiered rates that fall as volume rises — visible on every product page, not hidden behind a sales call." },
  { icon: CalendarClock, title: "Scheduled delivery", body: "Set a weekly or monthly cadence and stop thinking about it." },
  { icon: FileText, title: "GST invoices", body: "Compliant invoices against your GSTIN, issued automatically on every order." },
  { icon: RotateCcw, title: "One-tap reorder", body: "Your last order, rebuilt in a single tap. Most reorders take under 30 seconds." },
  { icon: Truck, title: "Reliable delivery", body: "Committed delivery windows, because running out is more expensive than the stock." },
  { icon: Headset, title: "A person to call", body: "A named contact who knows your account, not a ticket queue." },
];

export function BusinessHome() {
  const products = featured("business", 8);

  return (
    <>
      {/* ── Hero ────────────────────────────────────────────────────────── */}
      <section className="border-b border-line bg-surface">
        <Container className="grid gap-12 py-16 md:grid-cols-[1.15fr_1fr] md:items-center md:py-24">
          <div>
            <p className="eyebrow">Procurement for businesses</p>
            <h1 className="display mt-4 text-[42px] font-semibold sm:text-[56px] lg:text-[68px]">
              Everything your business needs.
              <span className="block text-muted">Without the procurement headache.</span>
            </h1>
            <p className="mt-6 max-w-xl text-[16px] leading-relaxed text-ink-soft">
              Cleaning, hygiene, housekeeping and everyday consumables — sourced,
              priced and delivered for restaurants, hotels, offices and clinics.
              One supplier instead of nine.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Button asChild size="lg">
                <Link href="/business/c/cleaning">
                  Browse the catalogue <ArrowRight className="size-4" />
                </Link>
              </Button>
              <Button asChild size="lg" variant="outline">
                <Link href="/bulk-quote">Request a bulk quote</Link>
              </Button>
            </div>
            <dl className="mt-12 grid max-w-lg grid-cols-3 gap-6 border-t border-line pt-6">
              {[
                ["1,200+", "SKUs in stock"],
                ["48 hrs", "Typical delivery"],
                ["₹0", "Account setup"],
              ].map(([stat, label]) => (
                <div key={label}>
                  <dt className="tnum text-[24px] font-semibold tracking-[-0.02em]">{stat}</dt>
                  <dd className="mt-1 text-[13px] text-muted">{label}</dd>
                </div>
              ))}
            </dl>
          </div>

          {/* Segment cards double as the "what are you shopping for" step. */}
          <div className="grid gap-3">
            {SEGMENTS.map((s) => (
              <Link
                key={s.title}
                href={s.href}
                className="group rounded-[var(--radius)] border border-line bg-paper p-5 transition-colors hover:border-line-strong hover:bg-sunk"
              >
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="text-[15px] font-medium tracking-[-0.011em]">{s.title}</p>
                    <p className="mt-1.5 text-[13px] leading-relaxed text-ink-soft">{s.blurb}</p>
                  </div>
                  <ArrowRight className="mt-1 size-4 shrink-0 text-muted transition-transform group-hover:translate-x-0.5 group-hover:text-ink" />
                </div>
              </Link>
            ))}
          </div>
        </Container>
      </section>

      {/* ── Categories ──────────────────────────────────────────────────── */}
      <Section>
        <SectionHead
          eyebrow="Catalogue"
          title="Shop by category"
          lede="Eight categories covering everything a site gets through in a month."
        />
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
          {CATEGORIES.filter((c) => c.modes.includes("business")).map((c) => {
            const Icon = ICONS[c.icon] ?? SprayCan;
            return (
              <Link
                key={c.slug}
                href={`/business/c/${c.slug}`}
                className="group flex flex-col rounded-[var(--radius)] border border-line bg-surface p-5 transition-colors hover:border-line-strong"
              >
                <Icon className="size-5 text-brand" />
                <p className="mt-8 text-[15px] font-medium tracking-[-0.011em]">{c.name}</p>
                <p className="mt-1 text-[12.5px] leading-relaxed text-muted">{c.tagline}</p>
              </Link>
            );
          })}
        </div>
      </Section>

      {/* ── Reorder ─────────────────────────────────────────────────────── */}
      <ReorderStrip />

      {/* ── Popular products ────────────────────────────────────────────── */}
      <Section className="pt-0">
        <SectionHead
          eyebrow="Moving fastest"
          title="What businesses reorder most"
          action={
            <Button asChild variant="outline">
              <Link href="/business/c/cleaning">View all</Link>
            </Button>
          }
        />
        <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
          {products.map((p) => (
            <ProductCard key={p.id} product={p} mode="business" />
          ))}
        </div>
      </Section>

      {/* ── Business advantage ──────────────────────────────────────────── */}
      <section className="bg-ink py-16 text-paper md:py-24">
        <Container>
          <div className="max-w-2xl">
            <p className="eyebrow text-paper/50">Business accounts</p>
            <h2 className="display mt-3 text-[30px] font-semibold md:text-[40px]">
              Built for businesses that can&rsquo;t afford to run out.
            </h2>
          </div>
          <div className="mt-12 grid gap-x-10 gap-y-9 sm:grid-cols-2 lg:grid-cols-3">
            {ADVANTAGES.map(({ icon: Icon, title, body }) => (
              <div key={title}>
                <Icon className="size-5 text-paper/60" />
                <p className="mt-4 text-[15px] font-medium">{title}</p>
                <p className="mt-1.5 text-[13.5px] leading-relaxed text-paper/60">{body}</p>
              </div>
            ))}
          </div>
          <div className="mt-12 flex flex-wrap gap-3">
            <Button asChild size="lg" className="bg-paper text-ink hover:bg-paper/90">
              <Link href="/register">Open a business account</Link>
            </Button>
            <Button
              asChild
              size="lg"
              variant="outline"
              className="border-paper/25 bg-transparent text-paper hover:bg-paper/10"
            >
              <Link href="/bulk-quote">Talk about volume</Link>
            </Button>
          </div>
        </Container>
      </section>

      {/* ── Premium cross-sell ──────────────────────────────────────────── */}
      <Section>
        <div className="flex flex-wrap items-center justify-between gap-6 rounded-[var(--radius-lg)] border border-line bg-surface p-8 md:p-12">
          <div className="max-w-lg">
            <p className="eyebrow">Also from Nivas</p>
            <h2 className="serif-display mt-3 text-[30px] md:text-[36px]">
              Everyday essentials, elevated.
            </h2>
            <p className="mt-3 text-[15px] leading-relaxed text-ink-soft">
              The same supply chain, refined for the home. Handwash, body care and
              home fragrance made to a standard we would put on our own basin.
            </p>
          </div>
          <Button asChild size="lg" variant="outline">
            <Link href="/premium">
              Explore Premium <ArrowRight className="size-4" />
            </Link>
          </Button>
        </div>
      </Section>

      {/* ── Trust ───────────────────────────────────────────────────────── */}
      <Section className="pt-0">
        <SectionHead eyebrow="Why Nivas" title="Reliable supplies. Every time." />
        <div className="grid gap-px overflow-hidden rounded-[var(--radius)] border border-line bg-line sm:grid-cols-2 lg:grid-cols-4">
          {[
            { icon: ShieldCheck, t: "Quality checked", b: "Every batch tested against spec before it reaches a shelf." },
            { icon: FileText, t: "Transparent pricing", b: "Every price break published. No quote required to see a rate." },
            { icon: Truck, t: "Committed windows", b: "You get a delivery window and we hold to it." },
            { icon: Headset, t: "Real support", b: "A named account contact, reachable on WhatsApp." },
          ].map(({ icon: Icon, t, b }) => (
            <div key={t} className="bg-surface p-6">
              <Icon className="size-5 text-brand" />
              <p className="mt-4 text-[15px] font-medium">{t}</p>
              <p className="mt-1.5 text-[13px] leading-relaxed text-ink-soft">{b}</p>
            </div>
          ))}
        </div>
      </Section>
    </>
  );
}
