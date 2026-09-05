import Link from "next/link";
import type { Metadata } from "next";
import { ArrowRight } from "lucide-react";
import { Container } from "@/components/ui/container";

export const metadata: Metadata = {
  title: "Nivas — Supply, handled",
};

/**
 * The gateway.
 *
 * Two storefronts share a supply chain but not an audience, and guessing wrong
 * costs more than asking. This page asks once, in two panels, and then gets out
 * of the way — every link from here is deep into one store or the other.
 */
export default function Landing() {
  return (
    <div className="flex min-h-dvh flex-col bg-paper text-ink">
      <header className="border-b border-line">
        <Container className="flex h-16 items-center justify-between">
          <span className="text-[19px] font-semibold tracking-[-0.02em]">NIVAS</span>
          <p className="hidden text-[13px] text-muted sm:block">
            Cleaning · Hygiene · Hospitality · Everyday essentials
          </p>
        </Container>
      </header>

      <main className="flex flex-1 flex-col">
        <Container className="py-16 md:py-24">
          <p className="eyebrow">One supply chain, two storefronts</p>
          <h1 className="display mt-5 max-w-4xl text-[42px] font-semibold sm:text-[58px] lg:text-[72px]">
            Everything your business needs.
            <span className="block text-muted">And everything your home deserves.</span>
          </h1>
          <p className="mt-6 max-w-2xl text-[16px] leading-relaxed text-ink-soft">
            Nivas sources cleaning, hygiene, housekeeping and everyday consumables —
            by the drum for restaurants, hotels and offices, and by the bottle for
            the people who live with them.
          </p>
        </Container>

        <Container className="pb-20">
          <div className="grid gap-4 md:grid-cols-2">
            <Gate
              href="/business"
              eyebrow="For businesses"
              title="Business"
              lede="Bulk quantities, tiered pricing, GST invoices, scheduled delivery and one-tap reorder."
              points={[
                "Restaurants, cafés, hotels, hostels",
                "Offices, gyms, salons, clinics, schools",
                "Bulk quotes on 100+ units",
              ]}
              cta="Shop for business"
              tone="business"
            />
            <Gate
              href="/premium"
              eyebrow="For homes"
              title="Premium"
              lede="Handwash, body care, home fragrance and cleaning — formulated properly, built to be refilled."
              points={[
                "Sulphate-free, plant-derived formulas",
                "Refills for every bottle",
                "Delivered across India",
              ]}
              cta="Shop Premium"
              tone="premium"
            />
          </div>
        </Container>
      </main>

      <footer className="border-t border-line">
        <Container className="flex h-14 items-center justify-between text-[12px] text-muted">
          <p>© {new Date().getFullYear()} Nivas Supply Co.</p>
          <p>Placeholder catalogue — pricing is seed data.</p>
        </Container>
      </footer>
    </div>
  );
}

function Gate({
  href,
  eyebrow,
  title,
  lede,
  points,
  cta,
  tone,
}: {
  href: string;
  eyebrow: string;
  title: string;
  lede: string;
  points: string[];
  cta: string;
  tone: "business" | "premium";
}) {
  return (
    <Link
      href={href}
      data-mode={tone}
      className="group flex flex-col justify-between rounded-[var(--radius-lg)] border border-line bg-surface p-8 transition-colors hover:border-line-strong md:min-h-[420px] md:p-10"
    >
      <div>
        <p className="eyebrow">{eyebrow}</p>
        <h2
          className={
            tone === "premium"
              ? "serif-display mt-4 text-[40px] md:text-[52px]"
              : "display mt-4 text-[36px] font-semibold md:text-[46px]"
          }
        >
          {title}
        </h2>
        <p className="mt-4 max-w-sm text-[15px] leading-relaxed text-ink-soft">{lede}</p>
        <ul className="mt-7 space-y-2">
          {points.map((p) => (
            <li key={p} className="flex gap-2.5 text-[13.5px] text-ink-soft">
              <span aria-hidden className="mt-[7px] size-1 shrink-0 rounded-full bg-brand" />
              {p}
            </li>
          ))}
        </ul>
      </div>
      <p className="mt-10 flex items-center gap-2 text-[15px] font-medium text-brand">
        {cta}
        <ArrowRight className="size-4 transition-transform group-hover:translate-x-1" />
      </p>
    </Link>
  );
}
