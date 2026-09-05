import { notFound } from "next/navigation";
import { SiteHeader } from "@/components/site-header";
import { ModeMemory } from "@/components/mode-memory";
import { SiteFooter } from "@/components/site-footer";
import { MODES, isMode } from "@/lib/mode";

/**
 * One route tree, two storefronts.
 *
 * `data-mode` on the wrapper is what actually re-skins the site: globals.css
 * redefines the palette under `[data-mode="premium"]`, so every child component
 * changes temperament without a single conditional class.
 */
export function generateStaticParams() {
  return MODES.map((mode) => ({ mode }));
}

export default async function ModeLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ mode: string }>;
}) {
  const { mode } = await params;
  if (!isMode(mode)) notFound();

  return (
    <div data-mode={mode} className="flex min-h-dvh flex-col bg-paper text-ink">
      <ModeMemory mode={mode} />
      <SiteHeader mode={mode} />
      <main className="flex-1">{children}</main>
      <SiteFooter mode={mode} />
    </div>
  );
}
