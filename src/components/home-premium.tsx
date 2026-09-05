import Link from "next/link";
import { ArrowRight, Leaf, PackageCheck, RefreshCw } from "lucide-react";
import { featured, productsInCategory } from "@/data/products";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Section, SectionHead } from "./section";
import { ProductCard } from "./product-card";
import { ProductArt } from "./product-art";

const PILLARS = [
  {
    icon: Leaf,
    title: "Formulated, not filled",
    body: "Sulphate-free, plant-derived surfactants and fragrance built by a perfumer rather than bought off a shelf.",
  },
  {
    icon: RefreshCw,
    title: "Refills, always",
    body: "Every formula has a refill. Buy the weighted bottle once and keep it on the basin for years.",
  },
  {
    icon: PackageCheck,
    title: "Made at our own scale",
    body: "The same supply chain that stocks hotels and restaurants, held to a domestic standard.",
  },
];

export function PremiumHome() {
  const products = featured("premium", 8);
  const hero = productsInCategory("premium", "premium")[0];

  return (
    <>
      {/* ── Hero ────────────────────────────────────────────────────────── */}
      <section className="border-b border-line">
        <Container className="grid items-center gap-12 py-16 md:grid-cols-2 md:py-24">
          <div>
            <p className="eyebrow">The Premium collection</p>
            <h1 className="serif-display mt-5 text-[46px] sm:text-[60px] lg:text-[72px]">
              Everyday essentials,
              <span className="block italic text-brand">elevated.</span>
            </h1>
            <p className="mt-6 max-w-md text-[16px] leading-relaxed text-ink-soft">
              Handwash, body care, home fragrance and cleaning made properly —
              gentle formulas, considered scent, packaging worth refilling rather
              than replacing.
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <Button asChild size="lg">
                <Link href="/premium/c/premium">
                  Shop the collection <ArrowRight className="size-4" />
                </Link>
              </Button>
              <Button asChild size="lg" variant="outline">
                <Link href="/business">Shop for business</Link>
              </Button>
            </div>
          </div>

          {hero && (
            <Link href={`/premium/p/${hero.slug}`} className="group block">
              <div className="overflow-hidden rounded-[var(--radius-lg)] bg-surface">
                <ProductArt
                  swatch={hero.swatch}
                  category={hero.category}
                  size={hero.variants[0].size}
                  className="aspect-[4/5] w-full transition-transform duration-700 ease-out group-hover:scale-[1.02]"
                />
              </div>
              <p className="mt-4 text-[13px] text-muted">
                {hero.name} — {hero.shortDescription}
              </p>
            </Link>
          )}
        </Container>
      </section>

      {/* ── Collection ──────────────────────────────────────────────────── */}
      <Section>
        <SectionHead
          serif
          eyebrow="The collection"
          title="Made for daily use"
          lede="Nine formulas, each with a refill. Nothing we would not keep on our own shelf."
          action={
            <Button asChild variant="outline">
              <Link href="/premium/c/premium">View all</Link>
            </Button>
          }
        />
        <div className="grid grid-cols-2 gap-x-5 gap-y-12 md:grid-cols-4">
          {products.map((p) => (
            <ProductCard key={p.id} product={p} mode="premium" />
          ))}
        </div>
      </Section>

      {/* ── Pillars ─────────────────────────────────────────────────────── */}
      <section className="border-y border-line bg-surface py-16 md:py-24">
        <Container>
          <div className="grid gap-12 md:grid-cols-3">
            {PILLARS.map(({ icon: Icon, title, body }) => (
              <div key={title}>
                <Icon className="size-5 text-brand" />
                <h3 className="serif-display mt-5 text-[24px]">{title}</h3>
                <p className="mt-3 text-[14.5px] leading-relaxed text-ink-soft">{body}</p>
              </div>
            ))}
          </div>
        </Container>
      </section>

      {/* ── Business cross-sell ─────────────────────────────────────────── */}
      <Section>
        <div className="flex flex-wrap items-center justify-between gap-6 rounded-[var(--radius-lg)] border border-line p-8 md:p-12">
          <div className="max-w-lg">
            <p className="eyebrow">Buying for a business?</p>
            <h2 className="display mt-3 text-[28px] font-semibold md:text-[34px]">
              The same shelf, by the drum.
            </h2>
            <p className="mt-3 text-[15px] leading-relaxed text-ink-soft">
              Restaurants, hotels, salons and offices buy from the Business store —
              bulk sizes, tiered pricing, GST invoices and scheduled delivery.
            </p>
          </div>
          <Button asChild size="lg" variant="outline">
            <Link href="/business">
              Shop for business <ArrowRight className="size-4" />
            </Link>
          </Button>
        </div>
      </Section>
    </>
  );
}
