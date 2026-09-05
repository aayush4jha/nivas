import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { searchProducts } from "@/data/products";
import { isMode, MODE_CONFIG } from "@/lib/mode";
import { Container } from "@/components/ui/container";
import { ProductCard } from "@/components/product-card";
import { Button } from "@/components/ui/button";

export const metadata: Metadata = { title: "Search" };

export default async function SearchPage({
  params,
  searchParams,
}: {
  params: Promise<{ mode: string }>;
  searchParams: Promise<{ q?: string }>;
}) {
  const { mode } = await params;
  if (!isMode(mode)) notFound();

  const { q = "" } = await searchParams;
  const results = searchProducts(q, mode);
  const other = q ? searchProducts(q, MODE_CONFIG[mode].otherMode) : [];

  return (
    <Container className="py-10 md:py-14">
      <h1 className="display text-[28px] font-semibold md:text-[36px]">
        {q ? <>Results for &ldquo;{q}&rdquo;</> : "Search"}
      </h1>
      <p className="tnum mt-2 text-[14px] text-muted">
        {q
          ? `${results.length} ${results.length === 1 ? "product" : "products"} in ${MODE_CONFIG[mode].label}`
          : "Search the catalogue by product, brand or category."}
      </p>

      {results.length > 0 ? (
        <div
          className={
            mode === "business"
              ? "mt-10 grid grid-cols-2 gap-3 lg:grid-cols-4"
              : "mt-10 grid grid-cols-2 gap-x-5 gap-y-12 md:grid-cols-3 lg:grid-cols-4"
          }
        >
          {results.map((p) => (
            <ProductCard key={p.id} product={p} mode={mode} />
          ))}
        </div>
      ) : (
        q && (
          <div className="mt-12 max-w-lg">
            <p className="text-[15px] leading-relaxed text-ink-soft">
              Nothing matched in the {MODE_CONFIG[mode].label} store.
              {other.length > 0 && (
                <>
                  {" "}
                  There {other.length === 1 ? "is" : "are"}{" "}
                  <span className="tnum">{other.length}</span> match
                  {other.length === 1 ? "" : "es"} in{" "}
                  {MODE_CONFIG[MODE_CONFIG[mode].otherMode].label}.
                </>
              )}
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              {other.length > 0 && (
                <Button asChild variant="outline">
                  <Link
                    href={`/${MODE_CONFIG[mode].otherMode}/search?q=${encodeURIComponent(q)}`}
                  >
                    Search {MODE_CONFIG[MODE_CONFIG[mode].otherMode].label} instead
                  </Link>
                </Button>
              )}
              <Button asChild variant="outline">
                <Link href={`/${mode}`}>Back to {MODE_CONFIG[mode].label}</Link>
              </Button>
              {mode === "business" && (
                <Button asChild>
                  <Link href="/bulk-quote">Ask us to source it</Link>
                </Button>
              )}
            </div>
          </div>
        )
      )}
    </Container>
  );
}
