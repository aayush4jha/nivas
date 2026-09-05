import type { CategorySlug, Mode, PriceTier, Product, Variant } from "@/lib/types";

/**
 * SEED CATALOGUE — placeholder data.
 *
 * Every SKU, price and cost below is invented but plausible for the Indian
 * market. Replace wholesale once real supplier rate cards arrive; the shapes
 * are what matter. Costs are included so the admin margin views have something
 * to compute against.
 *
 * Prices here are written in RUPEES for readability and converted to paise by
 * the builder. Nothing downstream of this file ever sees rupees.
 */

/** How price breaks are generated for a product. */
interface Curve {
  /** Discount off MRP an approved business account gets at any quantity. */
  business: number;
  /** Quantity breaks open to everyone: [minQty, discount off MRP]. */
  breaks: Array<[number, number]>;
  /** Extra discount a business account gets on top of each quantity break. */
  businessBonus: number;
}

/** Consumables sold by the drum — steep curve, this is where volume lives. */
const BULK: Curve = { business: 0.1, breaks: [[6, 0.16], [24, 0.24]], businessBonus: 0.04 };
/** Paper, bags, gloves — bought by the case, thin margins, shallow curve. */
const CASE: Curve = { business: 0.07, breaks: [[5, 0.12], [20, 0.18]], businessBonus: 0.03 };
/** Durable equipment — barely discounted, low reorder frequency. */
const HARD: Curve = { business: 0.06, breaks: [[10, 0.1]], businessBonus: 0.02 };
/** Premium D2C — protect the brand. Small breaks only, no business gating. */
const PREM: Curve = { business: 0.05, breaks: [[3, 0.08], [12, 0.14]], businessBonus: 0.02 };

const rs = (rupees: number) => Math.round(rupees) * 100;

function buildTiers(mrp: number, curve: Curve): PriceTier[] {
  const tiers: PriceTier[] = [
    {
      minQty: 1,
      unitPrice: rs(mrp * (1 - curve.business)),
      requires: "business",
      label: "Business price",
    },
  ];
  for (const [minQty, off] of curve.breaks) {
    tiers.push({
      minQty,
      unitPrice: rs(mrp * (1 - off)),
      requires: "retail",
      label: `${minQty}+ units`,
    });
    tiers.push({
      minQty,
      unitPrice: rs(mrp * (1 - off - curve.businessBonus)),
      requires: "business",
      label: `${minQty}+ on business`,
    });
  }
  return tiers.sort((a, b) => a.minQty - b.minQty || b.unitPrice - a.unitPrice);
}

interface VSpec {
  size: string;
  /** MRP in rupees. */
  mrp: number;
  /** Supplier cost in rupees. */
  cost: number;
  moq?: number;
  stock?: number;
  /** Grams. Drives shipping weight later. */
  wt: number;
  gst?: number;
}

interface PSpec {
  name: string;
  brand: string;
  category: CategorySlug;
  subcategory: string;
  modes?: Mode[];
  short: string;
  description: string;
  highlights: string[];
  rating: number;
  reviews: number;
  swatch: string;
  curve?: Curve;
  featured?: boolean;
  variants: VSpec[];
}

const slugify = (s: string) =>
  s
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");

function build(spec: PSpec, index: number): Product {
  const curve = spec.curve ?? BULK;
  const slug = slugify(spec.name);
  const skuBase = slug.slice(0, 14).toUpperCase().replace(/-/g, "");

  const variants: Variant[] = spec.variants.map((v, i) => ({
    id: `${slug}--${slugify(v.size)}`,
    size: v.size,
    sku: `${skuBase}-${String(i + 1).padStart(2, "0")}`,
    listPrice: rs(v.mrp),
    costPrice: rs(v.cost),
    tiers: buildTiers(v.mrp, curve),
    moq: v.moq ?? 1,
    // Deterministic pseudo-stock so server and client render the same number.
    stock: v.stock ?? 40 + ((index * 17 + i * 29) % 180),
    reorderPoint: 20,
    gstRate: v.gst ?? 18,
    weightGrams: v.wt,
  }));

  return {
    id: slug,
    slug,
    name: spec.name,
    brand: spec.brand,
    category: spec.category,
    subcategory: spec.subcategory,
    modes: spec.modes ?? ["business"],
    shortDescription: spec.short,
    description: spec.description,
    highlights: spec.highlights,
    variants,
    rating: spec.rating,
    reviewCount: spec.reviews,
    swatch: spec.swatch,
    featured: spec.featured,
  };
}

const SPECS: PSpec[] = [
  // ─── Cleaning ──────────────────────────────────────────────────────────────
  {
    name: "Commercial Floor Cleaner — Citrus",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Floor cleaners",
    short: "Concentrated daily floor cleaner for high-footfall areas.",
    description:
      "A concentrated neutral-pH floor cleaner built for restaurants, lobbies and corridors that get mopped several times a day. Dilutes 1:40, leaves no film on vitrified tile, marble or granite, and dries fast enough for a floor to go back into service in minutes.",
    highlights: [
      "Dilutes 1:40 — one 5 L jar makes 200 L of solution",
      "Neutral pH, safe on marble, granite and vitrified tile",
      "No sticky residue or dulling film",
      "Fast-drying, low-slip finish",
    ],
    rating: 4.6,
    reviews: 214,
    swatch: "#C9DCC4",
    featured: true,
    variants: [
      { size: "5 L", mrp: 460, cost: 292, wt: 5200 },
      { size: "10 L", mrp: 840, cost: 528, wt: 10300 },
      { size: "25 L", mrp: 1950, cost: 1225, moq: 1, wt: 25600 },
    ],
  },
  {
    name: "White Phenyl Concentrate",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Phenyl",
    short: "Classic white phenyl for daily housekeeping.",
    description:
      "The workhorse. A pine-based white phenyl concentrate for corridors, staircases, washrooms and back-of-house areas. Dilutes 1:30 and carries a clean, familiar fragrance that signals a floor has just been done.",
    highlights: ["Dilutes 1:30", "Pine fragrance", "Suitable for all hard floors", "Bulk drum available"],
    rating: 4.4,
    reviews: 168,
    swatch: "#E4E7DC",
    variants: [
      { size: "5 L", mrp: 320, cost: 198, wt: 5200 },
      { size: "20 L", mrp: 1180, cost: 730, wt: 20500 },
    ],
  },
  {
    name: "Toilet Bowl Cleaner",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Toilet cleaners",
    short: "Thick acid cleaner that clings to the bowl.",
    description:
      "A thickened hydrochloric acid cleaner that clings to the porcelain instead of running straight into the trap. Removes hard-water scale, rust marks and staining in a single application.",
    highlights: [
      "Clings to vertical surfaces",
      "Removes hard-water scale and rust",
      "Angled-neck bottle reaches under the rim",
      "Not for use on marble or natural stone",
    ],
    rating: 4.5,
    reviews: 302,
    swatch: "#BFD4E8",
    variants: [
      { size: "500 ml", mrp: 95, cost: 56, wt: 560 },
      { size: "5 L", mrp: 540, cost: 340, wt: 5300 },
      { size: "25 L", mrp: 2300, cost: 1450, wt: 25800 },
    ],
  },
  {
    name: "Glass & Surface Cleaner",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Glass cleaners",
    modes: ["business", "premium"],
    short: "Streak-free glass, mirrors and display cases.",
    description:
      "An ammonia-light formula for shopfronts, display cabinets, mirrors and partitions. Evaporates evenly so there is no streaking even in direct sunlight — the reason most glass cleaners fail on a storefront.",
    highlights: ["Streak-free in direct sun", "Safe on tinted and laminated glass", "Also cleans stainless and acrylic"],
    rating: 4.7,
    reviews: 189,
    swatch: "#CFE3EC",
    variants: [
      { size: "500 ml", mrp: 110, cost: 64, wt: 560 },
      { size: "5 L", mrp: 480, cost: 300, wt: 5300 },
    ],
  },
  {
    name: "Multipurpose Surface Cleaner",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Multipurpose cleaners",
    short: "One dilution for counters, tables and fixtures.",
    description:
      "A mild alkaline all-purpose cleaner that covers most of what a housekeeping trolley needs — tables, counters, doors, switch plates, fixtures. Dilutes 1:20 for daily work, 1:5 for anything neglected.",
    highlights: ["Two dilutions cover daily and deep clean", "Food-contact safe after rinse", "Low-foam, wipes dry quickly"],
    rating: 4.5,
    reviews: 141,
    swatch: "#DCE6D6",
    variants: [
      { size: "5 L", mrp: 430, cost: 268, wt: 5300 },
      { size: "25 L", mrp: 1850, cost: 1160, wt: 25800 },
    ],
  },
  {
    name: "Hospital-Grade Disinfectant",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Disinfectants",
    short: "Broad-spectrum quaternary disinfectant.",
    description:
      "A quaternary ammonium disinfectant for clinics, kitchens, gyms and washrooms. Effective against bacteria, enveloped viruses and fungi at a one-minute contact time, with no rinse required on non-food surfaces.",
    highlights: [
      "60-second contact time",
      "Broad-spectrum: bacteria, enveloped viruses, fungi",
      "No-rinse on non-food surfaces",
      "Fragrance-free option on bulk orders",
    ],
    rating: 4.8,
    reviews: 97,
    swatch: "#D2DDE9",
    featured: true,
    variants: [
      { size: "5 L", mrp: 720, cost: 452, wt: 5300 },
      { size: "20 L", mrp: 2650, cost: 1670, wt: 20600 },
    ],
  },
  {
    name: "Heavy-Duty Degreaser",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Degreasers",
    short: "Cuts baked-on kitchen grease and carbon.",
    description:
      "A strong alkaline degreaser for exhaust hoods, chimney filters, tandoor surrounds and kitchen floors. Designed for commercial kitchens where grease bakes on rather than wipes off.",
    highlights: ["Dissolves baked-on carbon", "Hood, filter and floor rated", "Wear gloves — strongly alkaline"],
    rating: 4.6,
    reviews: 156,
    swatch: "#E8DFC8",
    variants: [
      { size: "5 L", mrp: 620, cost: 388, wt: 5300 },
      { size: "20 L", mrp: 2280, cost: 1430, wt: 20600 },
    ],
  },
  {
    name: "Bathroom Descaler",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Bathroom cleaners",
    short: "Removes hard-water scale from tile and chrome.",
    description:
      "A milder acid than bowl cleaner, formulated for wall tile, chrome fittings, shower glass and washroom floors where hard water leaves a white haze.",
    highlights: ["Safe on chrome and CP fittings", "Clears shower-glass haze", "Mild acid — safer than bowl cleaner on tile"],
    rating: 4.3,
    reviews: 88,
    swatch: "#D9E4E1",
    variants: [{ size: "5 L", mrp: 510, cost: 320, wt: 5300 }],
  },
  {
    name: "Herbal Floor Cleaner Concentrate",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Floor cleaners",
    modes: ["business", "premium"],
    short: "Neem and eucalyptus, for spaces guests notice.",
    description:
      "A herbal concentrate built around neem and eucalyptus for spaces where the fragrance is part of the experience — spas, salons, boutique hotels, clinics. Dilutes 1:40, same coverage as the citrus.",
    highlights: ["Neem and eucalyptus", "Dilutes 1:40", "No harsh chemical smell", "Popular with spas and clinics"],
    rating: 4.7,
    reviews: 124,
    swatch: "#C6D8C2",
    variants: [
      { size: "5 L", mrp: 540, cost: 338, wt: 5200 },
      { size: "20 L", mrp: 1980, cost: 1245, wt: 20500 },
    ],
  },
  {
    name: "Marble & Stone Cleaner",
    brand: "Nivas Pro",
    category: "cleaning",
    subcategory: "Multipurpose cleaners",
    short: "pH-neutral, will not etch natural stone.",
    description:
      "Most floor cleaners slowly etch marble. This one does not. A strictly pH-neutral formula for marble, kota, granite and terrazzo lobbies where the floor is an asset worth protecting.",
    highlights: ["Strictly pH-neutral", "Will not etch or dull polished stone", "Safe for daily use on lobbies"],
    rating: 4.6,
    reviews: 73,
    swatch: "#E6E3DC",
    variants: [{ size: "5 L", mrp: 620, cost: 390, wt: 5300 }],
  },

  // ─── Hygiene ───────────────────────────────────────────────────────────────
  {
    name: "Liquid Handwash — Rose",
    brand: "Nivas Pro",
    category: "hygiene",
    subcategory: "Handwash",
    short: "Refill-grade handwash for washroom dispensers.",
    description:
      "A pearlised rose handwash sold in refill sizes, meant for wall dispensers rather than counter bottles. Mild enough for staff washing hands twenty times a shift.",
    highlights: ["Fits standard wall dispensers", "pH-balanced for frequent washing", "Contains glycerine", "Refill economics, not bottle economics"],
    rating: 4.5,
    reviews: 267,
    swatch: "#EBD3DA",
    featured: true,
    variants: [
      { size: "5 L", mrp: 470, cost: 292, wt: 5300 },
      { size: "20 L", mrp: 1720, cost: 1080, wt: 20600 },
    ],
  },
  {
    name: "Foaming Handwash Refill",
    brand: "Nivas Pro",
    category: "hygiene",
    subcategory: "Handwash",
    short: "Foam dispensers use up to 60% less per wash.",
    description:
      "A dilute-to-foam concentrate for foaming dispensers. The reason to switch: a foam pump delivers roughly a third of the liquid per press, so a washroom's handwash cost falls sharply without anyone noticing a difference.",
    highlights: ["Up to 60% lower cost per wash", "For foaming dispensers only", "Light, clean fragrance"],
    rating: 4.6,
    reviews: 118,
    swatch: "#E4E8F0",
    variants: [{ size: "5 L", mrp: 560, cost: 350, wt: 5300 }],
  },
  {
    name: "Instant Hand Sanitiser 70%",
    brand: "Nivas Pro",
    category: "hygiene",
    subcategory: "Sanitisers",
    modes: ["business", "premium"],
    short: "70% IPA gel with added emollients.",
    description:
      "A 70% isopropyl alcohol gel that meets the standard efficacy threshold, with glycerine and aloe so that hands used many times a day do not crack.",
    highlights: ["70% IPA — meets efficacy threshold", "Glycerine and aloe against drying", "Dries without stickiness"],
    rating: 4.4,
    reviews: 205,
    swatch: "#D8E7E4",
    variants: [
      { size: "500 ml", mrp: 140, cost: 82, wt: 540 },
      { size: "5 L", mrp: 890, cost: 560, wt: 5200 },
    ],
  },
  {
    name: "Nitrile Examination Gloves",
    brand: "Sterix",
    category: "hygiene",
    subcategory: "Gloves",
    curve: CASE,
    short: "Powder-free nitrile, box of 100.",
    description:
      "Powder-free blue nitrile gloves for kitchens, clinics and housekeeping. Nitrile over latex because it does not trigger latex allergy and holds up far better against oils and cleaning chemicals.",
    highlights: ["Powder-free, latex-free", "Textured fingertips for wet grip", "Chemical and oil resistant", "100 gloves per box"],
    rating: 4.5,
    reviews: 342,
    swatch: "#CBD9E8",
    variants: [
      { size: "Medium — box of 100", mrp: 480, cost: 330, wt: 900 },
      { size: "Large — box of 100", mrp: 480, cost: 330, wt: 950 },
    ],
  },
  {
    name: "Facial Tissue Box",
    brand: "Softline",
    category: "hygiene",
    subcategory: "Tissues",
    curve: CASE,
    modes: ["business", "premium"],
    short: "2-ply, 100 pulls per box.",
    description:
      "Soft 2-ply facial tissue in a flat box for tables, guest rooms and reception counters. 100 pulls per box, sold by the pack or the carton.",
    highlights: ["2-ply, 100 pulls", "Virgin pulp, unbleached-safe", "Flat box fits table dispensers"],
    rating: 4.3,
    reviews: 156,
    swatch: "#EFEDE7",
    variants: [
      { size: "Pack of 12 boxes", mrp: 540, cost: 372, wt: 3200 },
      { size: "Carton of 48 boxes", mrp: 1980, cost: 1370, wt: 12800 },
    ],
  },
  {
    name: "Multifold Paper Towels",
    brand: "Softline",
    category: "hygiene",
    subcategory: "Paper towels",
    curve: CASE,
    short: "Interfolded hand towels for washroom dispensers.",
    description:
      "Interfolded multifold towels that dispense one at a time — which is what actually controls washroom paper cost, more than the price per sheet does.",
    highlights: ["One-at-a-time dispensing", "Fits standard multifold dispensers", "150 sheets per pack", "Absorbent 1-ply"],
    rating: 4.4,
    reviews: 211,
    swatch: "#E9E4D9",
    variants: [
      { size: "Pack of 20 (3,000 sheets)", mrp: 760, cost: 520, wt: 6400 },
      { size: "Carton of 60 (9,000 sheets)", mrp: 2150, cost: 1480, wt: 19200 },
    ],
  },
  {
    name: "Toilet Rolls — 2 Ply",
    brand: "Softline",
    category: "hygiene",
    subcategory: "Tissues",
    curve: CASE,
    modes: ["business", "premium"],
    short: "Soft 2-ply, 300 pulls per roll.",
    description:
      "Standard-core 2-ply toilet rolls at 300 pulls, the size most Indian washroom holders are built for. Sold by the pack for small sites and the carton for hotels.",
    highlights: ["2-ply, 300 pulls per roll", "Standard core fits most holders", "Carton pricing for hotels"],
    rating: 4.4,
    reviews: 289,
    swatch: "#F0EBE2",
    variants: [
      { size: "Pack of 12 rolls", mrp: 420, cost: 288, wt: 2400 },
      { size: "Carton of 48 rolls", mrp: 1560, cost: 1075, wt: 9600 },
    ],
  },
  {
    name: "Alcohol Surface Wipes",
    brand: "Sterix",
    category: "hygiene",
    subcategory: "Disinfectants",
    curve: CASE,
    short: "70% alcohol wipes, 80-sheet canister.",
    description:
      "Pull-top canister wipes for tables, POS terminals, gym equipment and door handles — anywhere a spray bottle is impractical because there is a customer standing there.",
    highlights: ["70% alcohol", "80 wipes per canister", "Safe on screens and POS terminals", "Resealable lid keeps wipes moist"],
    rating: 4.5,
    reviews: 134,
    swatch: "#DDE7EC",
    variants: [{ size: "Pack of 6 canisters", mrp: 690, cost: 470, wt: 2900 }],
  },

  // ─── Kitchen ───────────────────────────────────────────────────────────────
  {
    name: "Dishwash Liquid — Lime",
    brand: "Nivas Pro",
    category: "kitchen",
    subcategory: "Dishwash",
    modes: ["business", "premium"],
    short: "High-foam, cuts oil in hard water.",
    description:
      "A high-active dishwash concentrate that keeps foaming in hard water and through heavy oil — the two conditions that make a cheap dishwash stop working halfway through a sink.",
    highlights: ["Holds foam in hard water", "Cuts vegetable and animal fat", "Dilutes 1:10 for pot wash", "Rinses clean, no film"],
    rating: 4.7,
    reviews: 398,
    swatch: "#DCE8C8",
    featured: true,
    variants: [
      { size: "5 L", mrp: 440, cost: 272, wt: 5300 },
      { size: "25 L", mrp: 1920, cost: 1200, wt: 25800 },
    ],
  },
  {
    name: "Kitchen Degreaser Spray",
    brand: "Nivas Pro",
    category: "kitchen",
    subcategory: "Kitchen cleaners",
    short: "Ready-to-use spray for counters and ranges.",
    description:
      "A ready-to-use trigger spray for stainless counters, range surrounds and splash-backs during service, when there is no time to mix a dilution.",
    highlights: ["Ready to use — no dilution", "Food-contact safe after rinse", "Safe on stainless steel"],
    rating: 4.5,
    reviews: 167,
    swatch: "#E7E0C6",
    variants: [
      { size: "500 ml", mrp: 130, cost: 78, wt: 560 },
      { size: "5 L refill", mrp: 560, cost: 350, wt: 5300 },
    ],
  },
  {
    name: "Dishwasher Rinse Aid",
    brand: "Nivas Pro",
    category: "kitchen",
    subcategory: "Dishwash",
    short: "Spot-free drying for commercial machines.",
    description:
      "For hood-type and undercounter commercial dishwashers. Breaks the surface tension of the final rinse so glassware dries without water spots and comes out of the machine ready for service.",
    highlights: ["Spot-free glassware", "For commercial machines only", "Low dosage — 2–4 ml per rack"],
    rating: 4.6,
    reviews: 61,
    swatch: "#D6E4EA",
    variants: [{ size: "5 L", mrp: 780, cost: 490, wt: 5300 }],
  },
  {
    name: "Scrubber Pads",
    brand: "GripCo",
    category: "kitchen",
    subcategory: "Scrubbers",
    curve: CASE,
    short: "Green abrasive pads, standard kitchen size.",
    description:
      "The standard green nylon abrasive pad. Consumable, high-turnover, and the item most kitchens run out of first.",
    highlights: ["Standard 100 × 150 mm", "Non-rusting nylon", "Rinses clean and re-dries"],
    rating: 4.2,
    reviews: 224,
    swatch: "#CFE0C4",
    variants: [
      { size: "Pack of 10", mrp: 130, cost: 84, wt: 320 },
      { size: "Pack of 50", mrp: 560, cost: 368, wt: 1600 },
    ],
  },
  {
    name: "Stainless Steel Scrubbers",
    brand: "GripCo",
    category: "kitchen",
    subcategory: "Scrubbers",
    curve: CASE,
    short: "Spiral steel scrubbers for pots and tawas.",
    description: "Spiral-wound stainless scrubbers for burnt pots, tawas and kadhais. Rust-resistant grade so they survive a wet kitchen.",
    highlights: ["Rust-resistant stainless", "Spiral wound — holds shape", "For heavy pot wash"],
    rating: 4.1,
    reviews: 143,
    swatch: "#DFE2E5",
    variants: [{ size: "Pack of 12", mrp: 240, cost: 158, wt: 480 }],
  },
  {
    name: "Microfibre Kitchen Cloths",
    brand: "GripCo",
    category: "kitchen",
    subcategory: "Cleaning cloths",
    curve: CASE,
    modes: ["business", "premium"],
    short: "Lint-free, colour-coded, machine washable.",
    description:
      "Colour-coded microfibre cloths so kitchen, washroom and front-of-house cloths never get mixed up — the cheapest cross-contamination control there is. Machine washable 300+ times.",
    highlights: ["Colour-coded by zone", "Lint-free on glass and steel", "Machine washable 300+ times", "40 × 40 cm"],
    rating: 4.6,
    reviews: 186,
    swatch: "#D5E2E8",
    variants: [
      { size: "Pack of 6", mrp: 290, cost: 186, wt: 300 },
      { size: "Pack of 24", mrp: 990, cost: 640, wt: 1200 },
    ],
  },

  // ─── Waste ─────────────────────────────────────────────────────────────────
  {
    name: "Garbage Bags — Medium (19 × 21 in)",
    brand: "Nivas Pro",
    category: "waste",
    subcategory: "Garbage bags",
    curve: CASE,
    short: "For desk-side and washroom bins.",
    description:
      "Medium bin liners for office desks, washrooms and guest rooms. Gauge chosen so they hold wet waste without splitting, which is where the cheapest bags fail.",
    highlights: ["19 × 21 in, fits 10–15 L bins", "Leak-resistant seal", "30 bags per roll"],
    rating: 4.3,
    reviews: 412,
    swatch: "#D3D6DA",
    featured: true,
    variants: [
      { size: "Pack of 30", mrp: 130, cost: 84, wt: 600 },
      { size: "Case of 10 packs", mrp: 1180, cost: 770, wt: 6000 },
    ],
  },
  {
    name: "Garbage Bags — Large (24 × 32 in)",
    brand: "Nivas Pro",
    category: "waste",
    subcategory: "Garbage bags",
    curve: CASE,
    short: "Kitchen and corridor bins.",
    description: "Large liners for kitchen bins and corridor stations. Heavier gauge for wet kitchen waste.",
    highlights: ["24 × 32 in, fits 30–40 L bins", "Heavier gauge for wet waste", "30 bags per roll"],
    rating: 4.4,
    reviews: 356,
    swatch: "#CBCFD4",
    variants: [
      { size: "Pack of 30", mrp: 230, cost: 150, wt: 1100 },
      { size: "Case of 10 packs", mrp: 2080, cost: 1360, wt: 11000 },
    ],
  },
  {
    name: "Garbage Bags — Extra Large (30 × 37 in)",
    brand: "Nivas Pro",
    category: "waste",
    subcategory: "Garbage bags",
    curve: CASE,
    short: "Loading-bay and collection bins.",
    description: "Extra-large liners for collection points, loading bays and event waste. Sold in 20s because they take up real space.",
    highlights: ["30 × 37 in, fits 60–80 L bins", "Extra-heavy gauge", "20 bags per roll"],
    rating: 4.4,
    reviews: 178,
    swatch: "#C4C8CD",
    variants: [
      { size: "Pack of 20", mrp: 290, cost: 190, wt: 1400 },
      { size: "Case of 10 packs", mrp: 2620, cost: 1720, wt: 14000 },
    ],
  },
  {
    name: "Compostable Bin Liners",
    brand: "Nivas Pro",
    category: "waste",
    subcategory: "Bin liners",
    curve: CASE,
    short: "IS 17088 certified, for wet-waste segregation.",
    description:
      "Certified compostable liners for wet-waste bins. Relevant wherever municipal segregation rules apply, and increasingly asked for by corporate clients during audits.",
    highlights: ["IS 17088 compostable certification", "Corn-starch based", "For wet-waste streams", "24 × 32 in"],
    rating: 4.2,
    reviews: 64,
    swatch: "#D6DFC9",
    variants: [{ size: "Pack of 30", mrp: 340, cost: 232, wt: 1150 }],
  },
  {
    name: "Pedal Waste Bin",
    brand: "GripCo",
    category: "waste",
    subcategory: "Waste bins",
    curve: HARD,
    short: "Hands-free plastic bin with inner bucket.",
    description:
      "Moulded pedal bin with a removable inner bucket, so the liner can be changed without touching the outer body. Hands-free operation matters most in kitchens and clinics.",
    highlights: ["Removable inner bucket", "Hands-free pedal", "Impact-resistant polypropylene"],
    rating: 4.3,
    reviews: 92,
    swatch: "#DADEE1",
    variants: [
      { size: "20 L", mrp: 690, cost: 460, wt: 1800 },
      { size: "60 L", mrp: 1490, cost: 990, wt: 4200 },
    ],
  },

  // ─── Laundry ───────────────────────────────────────────────────────────────
  {
    name: "Commercial Laundry Detergent",
    brand: "Nivas Pro",
    category: "laundry",
    subcategory: "Laundry detergent",
    short: "Low-foam liquid for front-loading machines.",
    description:
      "A low-foam liquid detergent for commercial front-loaders handling linen, uniforms and towels. Low-foam matters — a high-foam domestic detergent will cushion the drum and stop the wash mechanically working.",
    highlights: ["Low-foam, for front-loaders", "Enzyme blend for food and body soil", "Effective from 30 °C", "Dilutes by load weight"],
    rating: 4.6,
    reviews: 128,
    swatch: "#D5DEEC",
    variants: [
      { size: "5 L", mrp: 620, cost: 388, wt: 5400 },
      { size: "25 L", mrp: 2750, cost: 1725, wt: 26000 },
    ],
  },
  {
    name: "Fabric Conditioner",
    brand: "Nivas Pro",
    category: "laundry",
    subcategory: "Fabric conditioner",
    modes: ["business", "premium"],
    short: "Softens linen and cuts ironing time.",
    description:
      "A concentrated conditioner for hotel and restaurant linen. The real economic argument is not softness — it is that conditioned linen irons faster, and ironing is the expensive part of a laundry.",
    highlights: ["Reduces ironing time", "Light, clean fragrance", "Reduces static on synthetics", "Concentrated — 15 ml per load"],
    rating: 4.5,
    reviews: 96,
    swatch: "#E3DCEA",
    variants: [
      { size: "5 L", mrp: 480, cost: 300, wt: 5300 },
      { size: "20 L", mrp: 1760, cost: 1105, wt: 20600 },
    ],
  },
  {
    name: "Laundry Stain Remover",
    brand: "Nivas Pro",
    category: "laundry",
    subcategory: "Laundry chemicals",
    short: "Pre-spotter for oil, curry and wine.",
    description:
      "A pre-wash spotter for the stains that actually show up in Indian hospitality laundry: cooking oil, turmeric, curry, red wine and tea.",
    highlights: ["Works on turmeric and curry", "Apply 5 minutes before wash", "Safe on cotton and poly-cotton"],
    rating: 4.4,
    reviews: 71,
    swatch: "#EADFD6",
    variants: [{ size: "5 L", mrp: 690, cost: 432, wt: 5300 }],
  },
  {
    name: "Detergent Powder — Bulk",
    brand: "Nivas Pro",
    category: "laundry",
    subcategory: "Laundry detergent",
    short: "High-active powder for top-loaders and hand wash.",
    description: "A high-active detergent powder for top-loading machines and hand wash, sold in sacks for staff quarters, hostels and small laundries.",
    highlights: ["High active content", "For top-loaders and hand wash", "Sack packing, low cost per kg"],
    rating: 4.2,
    reviews: 149,
    swatch: "#E1E5EA",
    variants: [
      { size: "5 kg", mrp: 480, cost: 310, wt: 5100 },
      { size: "25 kg", mrp: 2150, cost: 1390, wt: 25200 },
    ],
  },

  // ─── Equipment ─────────────────────────────────────────────────────────────
  {
    name: "Microfibre Wet Mop with Handle",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Mops",
    curve: HARD,
    short: "360° flat mop with telescopic handle.",
    description:
      "A flat microfibre mop on a telescopic aluminium handle with a 360° swivel head, so it reaches under fixed seating and behind equipment without lifting furniture.",
    highlights: ["360° swivel head", "Telescopic aluminium handle", "Washable microfibre pad included", "Replacement pads sold separately"],
    rating: 4.5,
    reviews: 203,
    swatch: "#D8DEE4",
    featured: true,
    variants: [{ size: "Single unit", mrp: 780, cost: 505, wt: 900 }],
  },
  {
    name: "Floor Wiper",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Wipers",
    curve: HARD,
    short: "Double-blade silicone squeegee.",
    description: "A double-blade silicone floor wiper that clears water in one pass instead of two. Standard equipment for washrooms and wet kitchens.",
    highlights: ["Double silicone blade", "Steel handle", "Clears water in one pass"],
    rating: 4.4,
    reviews: 187,
    swatch: "#D0D9E0",
    variants: [
      { size: "45 cm", mrp: 340, cost: 220, wt: 700 },
      { size: "60 cm", mrp: 460, cost: 298, wt: 950 },
    ],
  },
  {
    name: "Heavy-Duty Toilet Brush",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Brushes",
    curve: HARD,
    short: "Stiff bristle with drip holder.",
    description: "Stiff-bristle toilet brush with a matching drip holder. Sold in sixes because washrooms are counted in stalls, not units.",
    highlights: ["Stiff, non-shedding bristle", "Drip holder included", "Sold in packs of 6"],
    rating: 4.2,
    reviews: 118,
    swatch: "#DEDCD8",
    variants: [{ size: "Pack of 6", mrp: 540, cost: 352, wt: 1400 }],
  },
  {
    name: "Mop Bucket with Wringer",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Buckets",
    curve: HARD,
    short: "Wheeled bucket with side-press wringer.",
    description:
      "A wheeled mop bucket with a side-press wringer. The double-chamber version keeps dirty water separate from clean, which is the difference between mopping a floor and redistributing dirt across it.",
    highlights: ["Side-press wringer", "Castor wheels", "Double chamber separates clean and dirty water"],
    rating: 4.5,
    reviews: 84,
    swatch: "#CFD8DE",
    variants: [
      { size: "Single chamber — 20 L", mrp: 1690, cost: 1120, wt: 3200 },
      { size: "Double chamber — 40 L", mrp: 3290, cost: 2180, wt: 6100 },
    ],
  },
  {
    name: "Trigger Spray Bottles",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Spray bottles",
    curve: CASE,
    short: "500 ml chemical-resistant bottles.",
    description: "Chemical-resistant 500 ml spray bottles with an adjustable nozzle and a writable label panel, so diluted chemicals get labelled rather than guessed at.",
    highlights: ["Chemical-resistant seals", "Adjustable jet-to-mist nozzle", "Writable label panel"],
    rating: 4.3,
    reviews: 165,
    swatch: "#DBE3E6",
    variants: [
      { size: "Pack of 6", mrp: 330, cost: 214, wt: 480 },
      { size: "Pack of 24", mrp: 1160, cost: 760, wt: 1900 },
    ],
  },
  {
    name: "Microfibre Cleaning Cloths",
    brand: "GripCo",
    category: "equipment",
    subcategory: "Microfibre cloths",
    curve: CASE,
    short: "General-purpose, 40 × 40 cm.",
    description: "General-purpose microfibre cloths for surfaces, glass and stainless. The single highest-turnover item on most housekeeping trolleys.",
    highlights: ["40 × 40 cm, 300 GSM", "Lint-free", "Machine washable 300+ times"],
    rating: 4.5,
    reviews: 298,
    swatch: "#D4DEE2",
    variants: [
      { size: "Pack of 12", mrp: 420, cost: 272, wt: 560 },
      { size: "Pack of 50", mrp: 1590, cost: 1035, wt: 2300 },
    ],
  },

  // ─── Hospitality ───────────────────────────────────────────────────────────
  {
    name: "Guest Soap Bars — 15 g",
    brand: "Nivas Hospitality",
    category: "hospitality",
    subcategory: "Guest soaps",
    curve: CASE,
    short: "Wrapped guest soaps for rooms and washrooms.",
    description:
      "Individually wrapped 15 g guest soaps in a neutral wrap that suits most room schemes. Custom-branded wrap is available on carton quantities through a bulk quote.",
    highlights: ["Individually wrapped", "15 g — standard room size", "Custom branding on bulk orders", "500 bars per carton"],
    rating: 4.4,
    reviews: 76,
    swatch: "#EDE6D9",
    variants: [{ size: "Carton of 500", mrp: 3450, cost: 2280, wt: 9500 }],
  },
  {
    name: "Hotel Shampoo Sachets — 10 ml",
    brand: "Nivas Hospitality",
    category: "hospitality",
    subcategory: "Shampoo",
    curve: CASE,
    short: "Single-use guest shampoo sachets.",
    description: "Single-use 10 ml shampoo sachets for guest rooms. Sachets rather than bottles where amenity budget matters more than presentation.",
    highlights: ["10 ml single use", "Neutral fragrance", "500 sachets per carton"],
    rating: 4.2,
    reviews: 58,
    swatch: "#E7E9DE",
    variants: [{ size: "Carton of 500", mrp: 2650, cost: 1750, wt: 6200 }],
  },
  {
    name: "Guest Dental Kits",
    brand: "Nivas Hospitality",
    category: "hospitality",
    subcategory: "Dental kits",
    curve: CASE,
    short: "Brush and paste in a sealed pouch.",
    description: "A toothbrush and a sachet of paste in a sealed pouch — the most-requested amenity at the front desk, and the cheapest complaint to prevent.",
    highlights: ["Brush plus paste sachet", "Sealed hygienic pouch", "250 kits per carton"],
    rating: 4.3,
    reviews: 44,
    swatch: "#DFE7EA",
    variants: [{ size: "Carton of 250", mrp: 3150, cost: 2080, wt: 5400 }],
  },
  {
    name: "Disposable Guest Slippers",
    brand: "Nivas Hospitality",
    category: "hospitality",
    subcategory: "Slippers",
    curve: CASE,
    short: "Non-woven closed-toe, one size.",
    description: "Closed-toe non-woven slippers with an EVA sole, individually bagged. One size fits most.",
    highlights: ["Closed toe with EVA sole", "Individually bagged", "100 pairs per carton"],
    rating: 4.1,
    reviews: 39,
    swatch: "#E9E4E0",
    variants: [{ size: "Carton of 100 pairs", mrp: 4200, cost: 2790, wt: 8800 }],
  },
  {
    name: "Bath Towels — 500 GSM",
    brand: "Nivas Hospitality",
    category: "hospitality",
    subcategory: "Towels",
    curve: HARD,
    short: "Ring-spun cotton, hotel white.",
    description:
      "500 GSM ring-spun cotton bath towels in hotel white, built to survive commercial laundering. Anything lighter than 450 GSM will not hold up past a season of industrial washing.",
    highlights: ["500 GSM ring-spun cotton", "Withstands commercial laundering", "70 × 140 cm", "Hotel white"],
    rating: 4.6,
    reviews: 67,
    swatch: "#F1F0EC",
    variants: [{ size: "Pack of 12", mrp: 4680, cost: 3120, wt: 7200 }],
  },

  // ─── Premium (D2C) ─────────────────────────────────────────────────────────
  {
    name: "Signature Handwash",
    brand: "Nivas",
    category: "premium",
    subcategory: "Premium handwash",
    modes: ["premium"],
    curve: PREM,
    short: "Bergamot, cedar and a rich, quiet lather.",
    description:
      "A gentle everyday handwash built around bergamot and cedarwood. Sulphate-free, glycerine-rich, and formulated so that hands washed a dozen times a day still feel like skin rather than paper. The 1 L refill exists so the weighted bottle stays on the basin.",
    highlights: [
      "Bergamot, cedarwood and vetiver",
      "Sulphate-free, glycerine-rich",
      "pH 5.5 — matched to skin",
      "1 L refill for the weighted bottle",
    ],
    rating: 4.8,
    reviews: 412,
    swatch: "#DCCFC0",
    featured: true,
    variants: [
      { size: "250 ml", mrp: 249, cost: 96, wt: 300 },
      { size: "500 ml", mrp: 349, cost: 132, wt: 560 },
      { size: "1 L refill", mrp: 549, cost: 198, wt: 1080 },
    ],
  },
  {
    name: "Hydrating Body Wash",
    brand: "Nivas",
    category: "premium",
    subcategory: "Body wash",
    modes: ["premium"],
    curve: PREM,
    short: "Oat milk and shea, for skin that dries out.",
    description:
      "A creamy, low-foam body wash with colloidal oat and shea butter. Low foam is deliberate: foam is what strips skin, and this is built for people whose skin does not tolerate being stripped.",
    highlights: ["Colloidal oat and shea butter", "Sulphate-free, low-foam", "Fragrance-light", "Suitable for dry and sensitive skin"],
    rating: 4.7,
    reviews: 286,
    swatch: "#E6DCCC",
    featured: true,
    variants: [
      { size: "300 ml", mrp: 449, cost: 168, wt: 350 },
      { size: "500 ml", mrp: 649, cost: 236, wt: 560 },
    ],
  },
  {
    name: "Nourishing Shampoo",
    brand: "Nivas",
    category: "premium",
    subcategory: "Shampoo",
    modes: ["premium"],
    curve: PREM,
    short: "Sulphate-free, safe on colour.",
    description:
      "A sulphate-free shampoo with amino-acid surfactants that cleans without stripping colour. It will not lather like a supermarket shampoo — that is the point.",
    highlights: ["Sulphate and silicone free", "Colour-safe", "Amino-acid surfactant base", "Argan and rice protein"],
    rating: 4.6,
    reviews: 198,
    swatch: "#E0D9C6",
    variants: [
      { size: "300 ml", mrp: 549, cost: 205, wt: 350 },
      { size: "500 ml", mrp: 749, cost: 272, wt: 560 },
    ],
  },
  {
    name: "Silk Conditioner",
    brand: "Nivas",
    category: "premium",
    subcategory: "Conditioner",
    modes: ["premium"],
    curve: PREM,
    short: "Lightweight slip, no build-up.",
    description: "A lightweight conditioner that gives enough slip to comb through wet hair without leaving the weight that silicone conditioners build up over weeks.",
    highlights: ["Silicone-free", "No build-up", "Rice protein and jojoba", "Pairs with the Nourishing Shampoo"],
    rating: 4.5,
    reviews: 152,
    swatch: "#E3DED2",
    variants: [{ size: "300 ml", mrp: 549, cost: 208, wt: 350 }],
  },
  {
    name: "Home Fragrance Diffuser",
    brand: "Nivas",
    category: "premium",
    subcategory: "Home fragrance",
    modes: ["premium"],
    curve: PREM,
    short: "Sandalwood and amber. Eight weeks of throw.",
    description:
      "A reed diffuser in sandalwood, amber and a dry cedar base. Eight to ten weeks of throw in a normal-sized room, in a weighted glass vessel worth keeping and refilling.",
    highlights: ["Sandalwood, amber, cedar", "8–10 weeks of throw", "Weighted glass vessel", "Refill available separately"],
    rating: 4.8,
    reviews: 174,
    swatch: "#D9C9B4",
    featured: true,
    variants: [
      { size: "200 ml", mrp: 899, cost: 320, wt: 700 },
      { size: "200 ml refill", mrp: 599, cost: 192, wt: 320 },
    ],
  },
  {
    name: "Luxury Surface Cleaner",
    brand: "Nivas",
    category: "premium",
    subcategory: "Premium home cleaning",
    modes: ["premium"],
    curve: PREM,
    short: "Plant-derived, fig leaf and neroli.",
    description:
      "A plant-derived multi-surface spray that happens to smell like fig leaf and neroli — made for kitchens people cook in and then sit down in, where the smell of the cleaner lingers longer than the meal.",
    highlights: ["Plant-derived surfactants", "Fig leaf and neroli", "Safe on sealed stone and wood", "Glass bottle, refill available"],
    rating: 4.7,
    reviews: 143,
    swatch: "#D3DCC8",
    variants: [
      { size: "500 ml", mrp: 399, cost: 142, wt: 620 },
      { size: "1 L refill", mrp: 599, cost: 205, wt: 1080 },
    ],
  },
  {
    name: "Premium Dishwash",
    brand: "Nivas",
    category: "premium",
    subcategory: "Premium home cleaning",
    modes: ["premium"],
    curve: PREM,
    short: "Kind to hands, hard on oil.",
    description: "A concentrated dishwash with added glycerine, for people who wash up by hand and would rather not need hand cream afterwards.",
    highlights: ["Glycerine-enriched", "Plant-derived surfactants", "Concentrated — a little goes far", "Lemongrass and basil"],
    rating: 4.6,
    reviews: 167,
    swatch: "#DCE4C9",
    variants: [
      { size: "500 ml", mrp: 349, cost: 124, wt: 620 },
      { size: "1 L refill", mrp: 549, cost: 186, wt: 1080 },
    ],
  },
  {
    name: "Room & Linen Mist",
    brand: "Nivas",
    category: "premium",
    subcategory: "Home fragrance",
    modes: ["premium"],
    curve: PREM,
    short: "Light enough for bedding.",
    description: "A fine mist for linen, curtains and upholstery, dosed light enough that it settles into fabric rather than sitting on top of it.",
    highlights: ["Safe on bedding and upholstery", "Alcohol-light, no staining", "White tea and iris"],
    rating: 4.5,
    reviews: 118,
    swatch: "#E4E1D8",
    variants: [{ size: "200 ml", mrp: 499, cost: 178, wt: 280 }],
  },
  {
    name: "Hand & Body Lotion",
    brand: "Nivas",
    category: "premium",
    subcategory: "Body wash",
    modes: ["premium"],
    curve: PREM,
    short: "Absorbs before you put the bottle down.",
    description: "A non-greasy lotion with shea and squalane that absorbs fast enough to use during a working day rather than only before bed.",
    highlights: ["Shea butter and squalane", "Absorbs in under a minute", "Non-greasy finish", "Matches the Signature fragrance"],
    rating: 4.7,
    reviews: 221,
    swatch: "#E8DFD1",
    variants: [
      { size: "300 ml", mrp: 499, cost: 182, wt: 350 },
      { size: "500 ml", mrp: 699, cost: 248, wt: 560 },
    ],
  },
];

export const PRODUCTS: Product[] = SPECS.map(build);

export function productsInMode(mode: Mode): Product[] {
  return PRODUCTS.filter((p) => p.modes.includes(mode));
}

export function getProduct(slug: string): Product | undefined {
  return PRODUCTS.find((p) => p.slug === slug);
}

export function productsInCategory(category: string, mode?: Mode): Product[] {
  return PRODUCTS.filter(
    (p) => p.category === category && (!mode || p.modes.includes(mode)),
  );
}

export function featured(mode: Mode, limit = 4): Product[] {
  const pool = productsInMode(mode);
  return [...pool.filter((p) => p.featured), ...pool.filter((p) => !p.featured)].slice(0, limit);
}

/** Naive search over name, brand, category and subcategory. Postgres FTS later. */
export function searchProducts(query: string, mode?: Mode): Product[] {
  const q = query.trim().toLowerCase();
  if (!q) return [];
  const terms = q.split(/\s+/);
  return PRODUCTS.filter((p) => {
    if (mode && !p.modes.includes(mode)) return false;
    const haystack = `${p.name} ${p.brand} ${p.category} ${p.subcategory} ${p.shortDescription}`.toLowerCase();
    return terms.every((t) => haystack.includes(t));
  });
}
