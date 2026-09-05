"use client";

import { useSyncExternalStore } from "react";
import { SiteHeader } from "./site-header";
import { SiteFooter } from "./site-footer";
import { modeStore } from "@/lib/store-mode";

/**
 * Shell for pages shared between both storefronts — cart, quotes, registration,
 * the account area. Adopts whichever store the visitor came from.
 *
 * Renders as Business on the server and corrects after hydration if the visitor
 * was in Premium. The correction is a palette swap, not a layout shift.
 */
export function StandaloneShell({ children }: { children: React.ReactNode }) {
  const mode = useSyncExternalStore(
    modeStore.subscribe,
    modeStore.getSnapshot,
    modeStore.getServerSnapshot,
  );

  return (
    <div data-mode={mode} className="flex min-h-dvh flex-col bg-paper text-ink">
      <SiteHeader mode={mode} />
      <main className="flex-1">{children}</main>
      <SiteFooter mode={mode} />
    </div>
  );
}
