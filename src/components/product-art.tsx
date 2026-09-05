import type { CategorySlug } from "@/lib/types";

/**
 * Placeholder product artwork.
 *
 * Real photography is the single biggest visual upgrade this site will get,
 * and it does not exist yet. Rather than ship grey boxes or mismatched
 * supplier JPEGs, each product renders a tinted vessel silhouette derived from
 * its category and swatch. It is deterministic, weighs nothing, and looks
 * intentional — which buys time to shoot the catalogue properly.
 *
 * Delete this component the day real images land.
 */

type Silhouette = "jerrycan" | "bottle" | "pump" | "carton" | "tool" | "roll";

const SILHOUETTE: Record<CategorySlug, Silhouette> = {
  cleaning: "jerrycan",
  hygiene: "pump",
  kitchen: "bottle",
  waste: "carton",
  laundry: "jerrycan",
  equipment: "tool",
  hospitality: "carton",
  premium: "pump",
};

/** Pick a silhouette from the pack size where it is more telling than category. */
function resolve(category: CategorySlug, size: string): Silhouette {
  const s = size.toLowerCase();
  if (/pack|carton|case|box/.test(s)) return category === "hygiene" ? "roll" : "carton";
  if (/\b(2[05]|20)\s*l\b/.test(s)) return "jerrycan";
  if (/ml\b/.test(s)) return category === "premium" ? "pump" : "bottle";
  return SILHOUETTE[category];
}

function Shape({ kind, fill, edge }: { kind: Silhouette; fill: string; edge: string }) {
  switch (kind) {
    case "jerrycan":
      return (
        <g>
          <rect x="62" y="52" width="76" height="112" rx="9" fill={fill} stroke={edge} />
          <rect x="86" y="30" width="28" height="24" rx="4" fill={fill} stroke={edge} />
          <rect x="74" y="76" width="52" height="34" rx="3" fill={edge} opacity="0.32" />
          <path d="M114 34h16a8 8 0 0 1 8 8v6" fill="none" stroke={edge} strokeWidth="3" />
        </g>
      );
    case "bottle":
      return (
        <g>
          <path
            d="M78 70c0-9 6-11 6-19V38h32v13c0 8 6 10 6 19v101a8 8 0 0 1-8 8H86a8 8 0 0 1-8-8V70Z"
            fill={fill}
            stroke={edge}
          />
          <rect x="86" y="24" width="28" height="16" rx="3" fill={edge} opacity="0.5" />
          <rect x="82" y="92" width="36" height="42" rx="3" fill={edge} opacity="0.28" />
        </g>
      );
    case "pump":
      return (
        <g>
          <rect x="72" y="66" width="56" height="106" rx="14" fill={fill} stroke={edge} />
          <rect x="90" y="44" width="20" height="24" rx="3" fill={edge} opacity="0.55" />
          <path d="M90 50h-14a6 6 0 0 0-6 6v6" fill="none" stroke={edge} strokeWidth="3.5" />
          <rect x="82" y="96" width="36" height="44" rx="3" fill={edge} opacity="0.26" />
        </g>
      );
    case "carton":
      return (
        <g>
          <path d="M56 74l44-22 44 22v76l-44 22-44-22V74Z" fill={fill} stroke={edge} />
          <path d="M56 74l44 22 44-22M100 96v76" fill="none" stroke={edge} opacity="0.55" />
          <rect x="80" y="112" width="40" height="26" rx="3" fill={edge} opacity="0.24" />
        </g>
      );
    case "tool":
      return (
        <g>
          <rect x="94" y="26" width="12" height="104" rx="6" fill={edge} opacity="0.55" />
          <rect x="58" y="130" width="84" height="20" rx="6" fill={fill} stroke={edge} />
          <path d="M62 150h76l-6 24H68l-6-24Z" fill={fill} stroke={edge} opacity="0.85" />
        </g>
      );
    case "roll":
      return (
        <g>
          <rect x="64" y="58" width="72" height="106" rx="36" fill={fill} stroke={edge} />
          <ellipse cx="100" cy="58" rx="36" ry="13" fill={edge} opacity="0.28" />
          <ellipse cx="100" cy="58" rx="13" ry="5" fill={edge} opacity="0.55" />
        </g>
      );
  }
}

export function ProductArt({
  swatch,
  category,
  size,
  className,
}: {
  swatch: string;
  category: CategorySlug;
  size: string;
  className?: string;
}) {
  const kind = resolve(category, size);
  const id = `${category}-${kind}-${swatch.replace("#", "")}`;

  return (
    <svg
      viewBox="0 0 200 200"
      className={className}
      role="img"
      aria-label={`${category} product illustration`}
    >
      <defs>
        <linearGradient id={`bg-${id}`} x1="0" y1="0" x2="0.6" y2="1">
          <stop offset="0%" stopColor={swatch} stopOpacity="0.5" />
          <stop offset="100%" stopColor={swatch} stopOpacity="0.16" />
        </linearGradient>
      </defs>
      <rect width="200" height="200" fill={`url(#bg-${id})`} />
      {/* Grounding shadow — without it the vessel floats and reads as clip-art. */}
      <ellipse cx="100" cy="176" rx="46" ry="7" fill="#000" opacity="0.07" />
      <Shape kind={kind} fill="#ffffff" edge={swatch} />
    </svg>
  );
}
