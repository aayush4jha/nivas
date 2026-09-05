import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Star } from "lucide-react";
import { PRODUCTS, getProduct, productsInCategory } from "@/data/products";
import { getCategory } from "@/data/categories";
import { isMode, MODES } from "@/lib/mode";
import { Container } from "@/components/ui/container";
import { ProductArt } from "@/components/product-art";
import { ProductPurchase } from "@/components/product-purchase";
import { ProductCard } from "@/components/product-card";

export function generateStaticParams() {
  return MODES.flatMap((mode) =>
    PRODUCTS.filter((p) => p.modes.includes(mode)).map((p) => ({
      mode,
      slug: p.slug,
    })),
  );
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ mode: string; slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const product = getProduct(slug);
  if (!product) return {};
  return { title: product.name, description: product.shortDescription };
}

export default async function ProductPage({
  params,
}: {
  params: Promise<{ mode: string; slug: string }>;
}) {
  const { mode, slug } = await params;
  if (!isMode(mode)) notFound();

  const product = getProduct(slug);
  if (!product || !product.modes.includes(mode)) notFound();

  const category = getCategory(product.category);
  const related = productsInCategory(product.category, mode)
    .filter((p) => p.id !== product.id)
    .slice(0, 4);

  return (
    <Container className="py-8 md:py-12">
      <nav aria-label="Breadcrumb" className="mb-8 flex flex-wrap gap-2 text-[13px] text-muted">
        <Link href={`/${mode}`} className="hover:text-ink">
          {mode === "business" ? "Business" : "Premium"}
        </Link>
        <span aria-hidden>/</span>
        {category && (
          <>
            <Link href={`/${mode}/c/${category.slug}`} className="hover:text-ink">
              {category.name}
            </Link>
            <span aria-hidden>/</span>
          </>
        )}
        <span className="text-ink-soft">{product.name}</span>
      </nav>

      <div className="grid gap-10 lg:grid-cols-2 lg:gap-16">
        <div className="lg:sticky lg:top-32 lg:self-start">
          <div className="overflow-hidden rounded-[var(--radius-lg)] bg-surface">
            <ProductArt
              swatch={product.swatch}
              category={product.category}
              size={product.variants[0].size}
              className="aspect-square w-full"
            />
          </div>
        </div>

        <div>
          <p className="text-[12px] font-medium uppercase tracking-wider text-muted">
            {product.brand}
          </p>
          <h1
            className={
              mode === "premium"
                ? "serif-display mt-2 text-[38px] md:text-[46px]"
                : "display mt-2 text-[30px] font-semibold md:text-[38px]"
            }
          >
            {product.name}
          </h1>

          <div className="mt-3 flex items-center gap-2 text-[13px] text-ink-soft">
            <span className="flex" aria-label={`Rated ${product.rating} out of 5`}>
              {[0, 1, 2, 3, 4].map((i) => (
                <Star
                  key={i}
                  className={
                    i < Math.round(product.rating)
                      ? "size-3.5 fill-current"
                      : "size-3.5 text-line-strong"
                  }
                  aria-hidden
                />
              ))}
            </span>
            <span className="tnum">{product.rating.toFixed(1)}</span>
            <span className="text-muted">({product.reviewCount} reviews)</span>
          </div>

          <p className="mt-5 max-w-lg text-[15px] leading-relaxed text-ink-soft">
            {product.description}
          </p>

          <div className="mt-8 border-t border-line pt-8">
            <ProductPurchase product={product} mode={mode} />
          </div>

          <div className="mt-10 border-t border-line pt-8">
            <p className="eyebrow mb-4">Key details</p>
            <ul className="space-y-2.5">
              {product.highlights.map((h) => (
                <li key={h} className="flex gap-3 text-[14px] leading-relaxed text-ink-soft">
                  <span aria-hidden className="mt-[9px] size-1 shrink-0 rounded-full bg-brand" />
                  {h}
                </li>
              ))}
            </ul>
          </div>

          <dl className="mt-10 grid grid-cols-2 gap-x-6 gap-y-4 border-t border-line pt-8 text-[13.5px] sm:grid-cols-3">
            <Spec label="Category" value={category?.name ?? "—"} />
            <Spec label="Type" value={product.subcategory} />
            <Spec label="Brand" value={product.brand} />
            <Spec label="Pack sizes" value={product.variants.map((v) => v.size).join(", ")} />
            <Spec label="GST" value={`${product.variants[0].gstRate}%`} />
            <Spec
              label="Unit weight"
              value={`${(product.variants[0].weightGrams / 1000).toFixed(1)} kg`}
            />
          </dl>
        </div>
      </div>

      {related.length > 0 && (
        <section className="mt-20 border-t border-line pt-14">
          <h2
            className={
              mode === "premium"
                ? "serif-display mb-8 text-[30px]"
                : "display mb-8 text-[24px] font-semibold"
            }
          >
            More in {category?.name}
          </h2>
          <div
            className={
              mode === "business"
                ? "grid grid-cols-2 gap-3 lg:grid-cols-4"
                : "grid grid-cols-2 gap-x-5 gap-y-12 md:grid-cols-4"
            }
          >
            {related.map((p) => (
              <ProductCard key={p.id} product={p} mode={mode} />
            ))}
          </div>
        </section>
      )}
    </Container>
  );
}

function Spec({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="text-[11px] font-medium uppercase tracking-wider text-muted">{label}</dt>
      <dd className="mt-1 text-ink-soft">{value}</dd>
    </div>
  );
}
