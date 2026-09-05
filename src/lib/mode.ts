import type { AccountTier, Mode } from "./types";

export const MODES: Mode[] = ["business", "premium"];

export function isMode(value: string): value is Mode {
  return (MODES as string[]).includes(value);
}

interface ModeConfig {
  label: string;
  /** Line under the wordmark in the header. */
  strapline: string;
  otherMode: Mode;
  switchLabel: string;
  /** Pricing tier applied to a signed-out visitor browsing this store. */
  defaultAccount: AccountTier;
  /** Business store shows per-unit price breaks; Premium never does. */
  showTiers: boolean;
}

export const MODE_CONFIG: Record<Mode, ModeConfig> = {
  business: {
    label: "Business",
    strapline: "Supply, handled",
    otherMode: "premium",
    switchLabel: "Shop Premium",
    defaultAccount: "retail",
    showTiers: true,
  },
  premium: {
    label: "Premium",
    strapline: "Everyday, elevated",
    otherMode: "business",
    switchLabel: "Shop for Business",
    defaultAccount: "retail",
    showTiers: false,
  },
};
