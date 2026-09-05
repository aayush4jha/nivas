"use client";

import { useEffect } from "react";
import { rememberMode } from "@/lib/store-mode";
import type { Mode } from "@/lib/types";

/** Records the current storefront so shared pages can match it. Renders nothing. */
export function ModeMemory({ mode }: { mode: Mode }) {
  useEffect(() => {
    rememberMode(mode);
  }, [mode]);
  return null;
}
