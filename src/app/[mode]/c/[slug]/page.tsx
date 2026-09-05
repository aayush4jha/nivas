import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CATEGORIES, getCategory } from "@/data/categories";
import { productsInCategory } from "@/data/products";
import { isMode, MODES } from "@/lib/mode";
import { Container } from "@/components/ui/container";
import { CatalogueGrid } from "@/components/catalogue-grid";

export function generateStaticParams() {
  return MODES.flatMap((mode) =>
    CATEGORIES.filter((c) => c.modes.includes(mode)).map((c) => ({
      mode,
      slug: c.slug,
    })),
  );
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ mode: string; slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const category = getCategory(slug);
  if (!category) return {};
  return { title: category.name, description: category.tagline };
}

export default async function CategoryPage({
  params,
}: {
  params: Promise<{ mode: string; slug: string }>;
}) {
  const { mode, slug } = await params;
  if (!isMode(mode)) notFound();

  const category = getCategory(slug);
  if (!category || !category.modes.includes(mode)) notFound();

  const products = productsInCategory(slug, mode);

  return (
    <Container className="py-10 md:py-14">
      <nav aria-label="Breadcrumb" className="mb-6 flex gap-2 text-[13px] text-muted">
        <Link href={`/${mode}`} className="hover:text-ink">
          {mode === "business" ? "Business" : "Premium"}
        </Link>
        <span aria-hidden>/</span>
        <span className="text-ink-soft">{category.name}</span>
      </nav>

      <header className="mb-10 max-w-2xl">
        <h1
          className={
            mode === "premium"
              ? "serif-display text-[40px] md:text-[52px]"
              : "display text-[32px] font-semibold md:text-[42px]"
          }
        >
          {category.name}
        </h1>
        <p className="mt-3 text-[15px] leading-relaxed text-ink-soft">
          {category.tagline}
          {mode === "business" && ". Bulk sizes and tiered pricing on every line."}
        </p>
      </header>

      <CatalogueGrid
        products={products}
        mode={mode}
        subcategories={category.subcategories}
      />
    </Container>
  );
}
