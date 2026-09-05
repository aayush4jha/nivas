"use client";

import { useEffect } from "react";
import { modeStore } from "@/lib/store-mode";
import type { Mode } from "@/lib/types";

/**
 * Records the current storefront so shared pages can match it. Renders nothing.
 *
 * Writing to an external store in an effect is what effects are for — this
 * synchronises React state *out* to localStorage, rather than pulling state in.
 */
export function ModeMemory({ mode }: { mode: Mode }) {
  useEffect(() => {
    modeStore.set(mode);
  }, [mode]);
  return null;
}
