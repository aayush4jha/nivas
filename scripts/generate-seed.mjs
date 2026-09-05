/**
 * Generates supabase/seed.sql from the TypeScript catalogue.
 *
 * The seed data has exactly one source of truth — src/data/products.ts — and
 * this derives the SQL from it. Hand-maintaining a parallel .sql file is how
 * the two silently drift apart, and a drifted seed is worse than none, because
 * it makes local and deployed environments disagree about prices.
 *
 * Both data modules import only *types* from @/lib/types, so tsc erases those
 * imports and the emitted JS is self-contained. That is why this can compile
 * two files in isolation rather than needing a bundler. Keep it that way: if
 * either file ever imports a runtime value across the alias, this breaks.
 *
 *   npm run db:seed
 */

import { execFileSync } from "node:child_process";
import { mkdirSync, writeFileSync, rmSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const tmp = join(root, "node_modules", ".cache", "nivas-seed");

rmSync(tmp, { recursive: true, force: true });
mkdirSync(tmp, { recursive: true });

// tsc reports the erased type-only imports as errors but still emits valid JS,
// so the non-zero exit is expected and ignored.
try {
  execFileSync(
    "npx",
    [
      "tsc",
      "src/data/products.ts",
      "src/data/categories.ts",
      "--outDir", tmp,
      "--module", "esnext",
      "--target", "es2022",
      "--moduleResolution", "bundler",
      "--skipLibCheck",
    ],
    { cwd: root, stdio: "pipe" },
  );
} catch {
  /* expected: type-only import resolution failures */
}

const { PRODUCTS } = await import(pathToFileURL(join(tmp, "products.js")).href);
const { CATEGORIES } = await import(pathToFileURL(join(tmp, "categories.js")).href);

/** Single-quote a SQL string literal, or emit NULL. */
const q = (v) => (v === null || v === undefined ? "null" : `'${String(v).replace(/'/g, "''")}'`);
/** Postgres text[] literal. */
const arr = (values) =>
  values.length === 0
    ? "'{}'"
    : `array[${values.map(q).join(", ")}]`;
const enumArr = (values) => `'{${values.join(",")}}'`;

const lines = [];
const w = (s = "") => lines.push(s);

w("-- ═══════════════════════════════════════════════════════════════════════");
w("-- GENERATED FILE — do not edit by hand.");
w("--");
w("-- Source of truth: src/data/products.ts and src/data/categories.ts");
w("-- Regenerate with: npm run db:seed");
w("--");
w("-- Placeholder catalogue. Every price and supplier cost is invented but");
w("-- plausible; replace once real rate cards arrive.");
w("-- ═══════════════════════════════════════════════════════════════════════");
w();
w("begin;");
w();

w("-- ── Categories ─────────────────────────────────────────────────────────");
w("insert into categories (slug, name, tagline, icon, storefronts, sort_order) values");
w(
  CATEGORIES.map(
    (c, i) =>
      `  (${q(c.slug)}, ${q(c.name)}, ${q(c.tagline)}, ${q(c.icon)}, ${enumArr(c.modes)}, ${i})`,
  ).join(",\n") + "\non conflict (slug) do update set",
);
w("  name = excluded.name,");
w("  tagline = excluded.tagline,");
w("  icon = excluded.icon,");
w("  storefronts = excluded.storefronts,");
w("  sort_order = excluded.sort_order;");
w();

w("-- ── Products ───────────────────────────────────────────────────────────");
for (const p of PRODUCTS) {
  w(`-- ${p.name}`);
  w("insert into products (");
  w("  slug, name, brand, category_slug, subcategory, storefronts,");
  w("  short_description, description, highlights, swatch, featured");
  w(") values (");
  w(`  ${q(p.slug)}, ${q(p.name)}, ${q(p.brand)}, ${q(p.category)}, ${q(p.subcategory)},`);
  w(`  ${enumArr(p.modes)},`);
  w(`  ${q(p.shortDescription)},`);
  w(`  ${q(p.description)},`);
  w(`  ${arr(p.highlights)}, ${q(p.swatch)}, ${p.featured ? "true" : "false"}`);
  w(") on conflict (slug) do update set");
  w("  name = excluded.name, brand = excluded.brand,");
  w("  category_slug = excluded.category_slug, subcategory = excluded.subcategory,");
  w("  storefronts = excluded.storefronts,");
  w("  short_description = excluded.short_description,");
  w("  description = excluded.description, highlights = excluded.highlights,");
  w("  swatch = excluded.swatch, featured = excluded.featured;");
  w();

  for (const [i, v] of p.variants.entries()) {
    w("insert into product_variants (");
    w("  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position");
    w(") values (");
    w(`  (select id from products where slug = ${q(p.slug)}),`);
    w(
      `  ${q(v.sku)}, ${q(v.size)}, ${v.listPrice}, ${v.costPrice}, ${v.gstRate}, ${v.moq}, ${v.weightGrams}, ${i}`,
    );
    w(") on conflict (sku) do update set");
    w("  size = excluded.size, list_price = excluded.list_price,");
    w("  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,");
    w("  moq = excluded.moq, weight_grams = excluded.weight_grams,");
    w("  position = excluded.position;");
    w();

    // Tiers are fully regenerated: a removed break must actually disappear.
    w(`delete from price_tiers where variant_id = (select id from product_variants where sku = ${q(v.sku)});`);
    if (v.tiers.length > 0) {
      w("insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values");
      w(
        v.tiers
          .map(
            (t) =>
              `  ((select id from product_variants where sku = ${q(v.sku)}), ${t.minQty}, ${t.unitPrice}, ${q(t.requires)}, ${q(t.label)})`,
          )
          .join(",\n") + "\non conflict (variant_id, min_qty, requires_tier) do nothing;",
      );
    }
    w();

    w("insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values");
    w(
      `  ((select id from product_variants where sku = ${q(v.sku)}), ${v.stock}, ${v.reorderPoint}, ${Math.max(v.reorderPoint * 2, 40)})`,
    );
    w("on conflict (variant_id) do update set on_hand = excluded.on_hand;");
    w();
  }
}

w("commit;");
w();

const skus = PRODUCTS.reduce((n, p) => n + p.variants.length, 0);
const tiers = PRODUCTS.reduce(
  (n, p) => n + p.variants.reduce((m, v) => m + v.tiers.length, 0),
  0,
);

writeFileSync(join(root, "supabase", "seed.sql"), lines.join("\n"));
rmSync(tmp, { recursive: true, force: true });

console.log(
  `Wrote supabase/seed.sql — ${CATEGORIES.length} categories, ${PRODUCTS.length} products, ${skus} SKUs, ${tiers} price tiers.`,
);
