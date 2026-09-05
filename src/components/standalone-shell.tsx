"use client";

import { useEffect, useState } from "react";
import { SiteHeader } from "./site-header";
import { SiteFooter } from "./site-footer";
import { recallMode } from "@/lib/store-mode";
import type { Mode } from "@/lib/types";

/**
 * Shell for pages that are shared between both storefronts — cart, quotes,
 * registration, the account area. Adopts whichever store the visitor came from.
 *
 * Renders as Business on the server and corrects after mount if the visitor was
 * in Premium. The correction is a palette swap, not a layout shift.
 */
export function StandaloneShell({ children }: { children: React.ReactNode }) {
  const [mode, setMode] = useState<Mode>("business");

  useEffect(() => {
    setMode(recallMode());
  }, []);

  return (
    <div data-mode={mode} className="flex min-h-dvh flex-col bg-paper text-ink">
      <SiteHeader mode={mode} />
      <main className="flex-1">{children}</main>
      <SiteFooter mode={mode} />
    </div>
  );
}
