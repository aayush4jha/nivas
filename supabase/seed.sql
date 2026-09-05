-- ═══════════════════════════════════════════════════════════════════════
-- GENERATED FILE — do not edit by hand.
--
-- Source of truth: src/data/products.ts and src/data/categories.ts
-- Regenerate with: npm run db:seed
--
-- Placeholder catalogue. Every price and supplier cost is invented but
-- plausible; replace once real rate cards arrive.
-- ═══════════════════════════════════════════════════════════════════════

begin;

-- ── Categories ─────────────────────────────────────────────────────────
insert into categories (slug, name, tagline, icon, storefronts, sort_order) values
  ('cleaning', 'Cleaning', 'Floors, surfaces, washrooms, disinfection', 'SprayCan', '{business,premium}', 0),
  ('hygiene', 'Hygiene', 'Handwash, sanitiser, gloves, tissue', 'Droplets', '{business,premium}', 1),
  ('kitchen', 'Kitchen', 'Dishwash, degreasers, scrubbers, cloths', 'UtensilsCrossed', '{business,premium}', 2),
  ('waste', 'Waste Management', 'Garbage bags, bin liners, bins', 'Trash2', '{business}', 3),
  ('laundry', 'Laundry', 'Detergents, softeners, laundry chemicals', 'Shirt', '{business,premium}', 4),
  ('equipment', 'Cleaning Equipment', 'Mops, wipers, brushes, buckets', 'Wrench', '{business}', 5),
  ('hospitality', 'Hospitality', 'Guest amenities for hotels and stays', 'BedDouble', '{business}', 6),
  ('premium', 'Premium', 'Everyday essentials, elevated', 'Sparkles', '{premium}', 7)
on conflict (slug) do update set
  name = excluded.name,
  tagline = excluded.tagline,
  icon = excluded.icon,
  storefronts = excluded.storefronts,
  sort_order = excluded.sort_order;

-- ── Products ───────────────────────────────────────────────────────────
-- Commercial Floor Cleaner — Citrus
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'commercial-floor-cleaner-citrus', 'Commercial Floor Cleaner — Citrus', 'Nivas Pro', 'cleaning', 'Floor cleaners',
  '{business}',
  'Concentrated daily floor cleaner for high-footfall areas.',
  'A concentrated neutral-pH floor cleaner built for restaurants, lobbies and corridors that get mopped several times a day. Dilutes 1:40, leaves no film on vitrified tile, marble or granite, and dries fast enough for a floor to go back into service in minutes.',
  array['Dilutes 1:40 — one 5 L jar makes 200 L of solution', 'Neutral pH, safe on marble, granite and vitrified tile', 'No sticky residue or dulling film', 'Fast-drying, low-slip finish'], '#C9DCC4', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'commercial-floor-cleaner-citrus'),
  'COMMERCIALFLO-01', '5 L', 46000, 29200, 18, 1, 5200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMMERCIALFLO-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 1, 41400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 6, 38600, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 6, 36800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 24, 35000, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 24, 33100, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-01'), 40, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'commercial-floor-cleaner-citrus'),
  'COMMERCIALFLO-02', '10 L', 84000, 52800, 18, 1, 10300, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMMERCIALFLO-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 1, 75600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 6, 70600, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 6, 67200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 24, 63800, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 24, 60500, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-02'), 69, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'commercial-floor-cleaner-citrus'),
  'COMMERCIALFLO-03', '25 L', 195000, 122500, 18, 1, 25600, 2
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMMERCIALFLO-03');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 1, 175500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 6, 163800, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 6, 156000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 24, 148200, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 24, 140400, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMMERCIALFLO-03'), 98, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- White Phenyl Concentrate
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'white-phenyl-concentrate', 'White Phenyl Concentrate', 'Nivas Pro', 'cleaning', 'Phenyl',
  '{business}',
  'Classic white phenyl for daily housekeeping.',
  'The workhorse. A pine-based white phenyl concentrate for corridors, staircases, washrooms and back-of-house areas. Dilutes 1:30 and carries a clean, familiar fragrance that signals a floor has just been done.',
  array['Dilutes 1:30', 'Pine fragrance', 'Suitable for all hard floors', 'Bulk drum available'], '#E4E7DC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'white-phenyl-concentrate'),
  'WHITEPHENYLC-01', '5 L', 32000, 19800, 18, 1, 5200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'WHITEPHENYLC-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 1, 28800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 6, 26900, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 6, 25600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 24, 24300, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 24, 23000, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'WHITEPHENYLC-01'), 57, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'white-phenyl-concentrate'),
  'WHITEPHENYLC-02', '20 L', 118000, 73000, 18, 1, 20500, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'WHITEPHENYLC-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 1, 106200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 6, 99100, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 6, 94400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 24, 89700, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 24, 85000, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'WHITEPHENYLC-02'), 86, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Toilet Bowl Cleaner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'toilet-bowl-cleaner', 'Toilet Bowl Cleaner', 'Nivas Pro', 'cleaning', 'Toilet cleaners',
  '{business}',
  'Thick acid cleaner that clings to the bowl.',
  'A thickened hydrochloric acid cleaner that clings to the porcelain instead of running straight into the trap. Removes hard-water scale, rust marks and staining in a single application.',
  array['Clings to vertical surfaces', 'Removes hard-water scale and rust', 'Angled-neck bottle reaches under the rim', 'Not for use on marble or natural stone'], '#BFD4E8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'toilet-bowl-cleaner'),
  'TOILETBOWLCL-01', '500 ml', 9500, 5600, 18, 1, 560, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TOILETBOWLCL-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 1, 8600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 6, 8000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 6, 7600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 24, 7200, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 24, 6800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-01'), 74, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'toilet-bowl-cleaner'),
  'TOILETBOWLCL-02', '5 L', 54000, 34000, 18, 1, 5300, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TOILETBOWLCL-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 1, 48600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 6, 45400, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 6, 43200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 24, 41000, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 24, 38900, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-02'), 103, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'toilet-bowl-cleaner'),
  'TOILETBOWLCL-03', '25 L', 230000, 145000, 18, 1, 25800, 2
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TOILETBOWLCL-03');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 1, 207000, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 6, 193200, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 6, 184000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 24, 174800, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 24, 165600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TOILETBOWLCL-03'), 132, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Glass & Surface Cleaner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'glass-surface-cleaner', 'Glass & Surface Cleaner', 'Nivas Pro', 'cleaning', 'Glass cleaners',
  '{business,premium}',
  'Streak-free glass, mirrors and display cases.',
  'An ammonia-light formula for shopfronts, display cabinets, mirrors and partitions. Evaporates evenly so there is no streaking even in direct sunlight — the reason most glass cleaners fail on a storefront.',
  array['Streak-free in direct sun', 'Safe on tinted and laminated glass', 'Also cleans stainless and acrylic'], '#CFE3EC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'glass-surface-cleaner'),
  'GLASSSURFACE-01', '500 ml', 11000, 6400, 18, 1, 560, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GLASSSURFACE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 1, 9900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 6, 9200, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 6, 8800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 24, 8400, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 24, 7900, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GLASSSURFACE-01'), 91, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'glass-surface-cleaner'),
  'GLASSSURFACE-02', '5 L', 48000, 30000, 18, 1, 5300, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GLASSSURFACE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 1, 43200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 6, 40300, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 6, 38400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 24, 36500, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 24, 34600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GLASSSURFACE-02'), 120, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Multipurpose Surface Cleaner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'multipurpose-surface-cleaner', 'Multipurpose Surface Cleaner', 'Nivas Pro', 'cleaning', 'Multipurpose cleaners',
  '{business}',
  'One dilution for counters, tables and fixtures.',
  'A mild alkaline all-purpose cleaner that covers most of what a housekeeping trolley needs — tables, counters, doors, switch plates, fixtures. Dilutes 1:20 for daily work, 1:5 for anything neglected.',
  array['Two dilutions cover daily and deep clean', 'Food-contact safe after rinse', 'Low-foam, wipes dry quickly'], '#DCE6D6', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'multipurpose-surface-cleaner'),
  'MULTIPURPOSES-01', '5 L', 43000, 26800, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MULTIPURPOSES-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 1, 38700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 6, 36100, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 6, 34400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 24, 32700, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 24, 31000, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MULTIPURPOSES-01'), 108, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'multipurpose-surface-cleaner'),
  'MULTIPURPOSES-02', '25 L', 185000, 116000, 18, 1, 25800, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MULTIPURPOSES-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 1, 166500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 6, 155400, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 6, 148000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 24, 140600, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 24, 133200, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MULTIPURPOSES-02'), 137, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Hospital-Grade Disinfectant
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'hospital-grade-disinfectant', 'Hospital-Grade Disinfectant', 'Nivas Pro', 'cleaning', 'Disinfectants',
  '{business}',
  'Broad-spectrum quaternary disinfectant.',
  'A quaternary ammonium disinfectant for clinics, kitchens, gyms and washrooms. Effective against bacteria, enveloped viruses and fungi at a one-minute contact time, with no rinse required on non-food surfaces.',
  array['60-second contact time', 'Broad-spectrum: bacteria, enveloped viruses, fungi', 'No-rinse on non-food surfaces', 'Fragrance-free option on bulk orders'], '#D2DDE9', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hospital-grade-disinfectant'),
  'HOSPITALGRADE-01', '5 L', 72000, 45200, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HOSPITALGRADE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 1, 64800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 6, 60500, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 6, 57600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 24, 54700, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 24, 51800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HOSPITALGRADE-01'), 125, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hospital-grade-disinfectant'),
  'HOSPITALGRADE-02', '20 L', 265000, 167000, 18, 1, 20600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HOSPITALGRADE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 1, 238500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 6, 222600, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 6, 212000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 24, 201400, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 24, 190800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HOSPITALGRADE-02'), 154, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Heavy-Duty Degreaser
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'heavy-duty-degreaser', 'Heavy-Duty Degreaser', 'Nivas Pro', 'cleaning', 'Degreasers',
  '{business}',
  'Cuts baked-on kitchen grease and carbon.',
  'A strong alkaline degreaser for exhaust hoods, chimney filters, tandoor surrounds and kitchen floors. Designed for commercial kitchens where grease bakes on rather than wipes off.',
  array['Dissolves baked-on carbon', 'Hood, filter and floor rated', 'Wear gloves — strongly alkaline'], '#E8DFC8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'heavy-duty-degreaser'),
  'HEAVYDUTYDEG-01', '5 L', 62000, 38800, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HEAVYDUTYDEG-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 1, 55800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 6, 52100, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 6, 49600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 24, 47100, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 24, 44600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-01'), 142, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'heavy-duty-degreaser'),
  'HEAVYDUTYDEG-02', '20 L', 228000, 143000, 18, 1, 20600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HEAVYDUTYDEG-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 1, 205200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 6, 191500, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 6, 182400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 24, 173300, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 24, 164200, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HEAVYDUTYDEG-02'), 171, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Bathroom Descaler
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'bathroom-descaler', 'Bathroom Descaler', 'Nivas Pro', 'cleaning', 'Bathroom cleaners',
  '{business}',
  'Removes hard-water scale from tile and chrome.',
  'A milder acid than bowl cleaner, formulated for wall tile, chrome fittings, shower glass and washroom floors where hard water leaves a white haze.',
  array['Safe on chrome and CP fittings', 'Clears shower-glass haze', 'Mild acid — safer than bowl cleaner on tile'], '#D9E4E1', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'bathroom-descaler'),
  'BATHROOMDESCA-01', '5 L', 51000, 32000, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'BATHROOMDESCA-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 1, 45900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 6, 42800, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 6, 40800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 24, 38800, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 24, 36700, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'BATHROOMDESCA-01'), 159, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Herbal Floor Cleaner Concentrate
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'herbal-floor-cleaner-concentrate', 'Herbal Floor Cleaner Concentrate', 'Nivas Pro', 'cleaning', 'Floor cleaners',
  '{business,premium}',
  'Neem and eucalyptus, for spaces guests notice.',
  'A herbal concentrate built around neem and eucalyptus for spaces where the fragrance is part of the experience — spas, salons, boutique hotels, clinics. Dilutes 1:40, same coverage as the citrus.',
  array['Neem and eucalyptus', 'Dilutes 1:40', 'No harsh chemical smell', 'Popular with spas and clinics'], '#C6D8C2', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'herbal-floor-cleaner-concentrate'),
  'HERBALFLOORC-01', '5 L', 54000, 33800, 18, 1, 5200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HERBALFLOORC-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 1, 48600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 6, 45400, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 6, 43200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 24, 41000, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 24, 38900, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HERBALFLOORC-01'), 176, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'herbal-floor-cleaner-concentrate'),
  'HERBALFLOORC-02', '20 L', 198000, 124500, 18, 1, 20500, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HERBALFLOORC-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 1, 178200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 6, 166300, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 6, 158400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 24, 150500, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 24, 142600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HERBALFLOORC-02'), 205, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Marble & Stone Cleaner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'marble-stone-cleaner', 'Marble & Stone Cleaner', 'Nivas Pro', 'cleaning', 'Multipurpose cleaners',
  '{business}',
  'pH-neutral, will not etch natural stone.',
  'Most floor cleaners slowly etch marble. This one does not. A strictly pH-neutral formula for marble, kota, granite and terrazzo lobbies where the floor is an asset worth protecting.',
  array['Strictly pH-neutral', 'Will not etch or dull polished stone', 'Safe for daily use on lobbies'], '#E6E3DC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'marble-stone-cleaner'),
  'MARBLESTONEC-01', '5 L', 62000, 39000, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MARBLESTONEC-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 1, 55800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 6, 52100, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 6, 49600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 24, 47100, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 24, 44600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MARBLESTONEC-01'), 193, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Liquid Handwash — Rose
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'liquid-handwash-rose', 'Liquid Handwash — Rose', 'Nivas Pro', 'hygiene', 'Handwash',
  '{business}',
  'Refill-grade handwash for washroom dispensers.',
  'A pearlised rose handwash sold in refill sizes, meant for wall dispensers rather than counter bottles. Mild enough for staff washing hands twenty times a shift.',
  array['Fits standard wall dispensers', 'pH-balanced for frequent washing', 'Contains glycerine', 'Refill economics, not bottle economics'], '#EBD3DA', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'liquid-handwash-rose'),
  'LIQUIDHANDWAS-01', '5 L', 47000, 29200, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'LIQUIDHANDWAS-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 1, 42300, 'business', 'Business price'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 6, 39500, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 6, 37600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 24, 35700, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 24, 33800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-01'), 210, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'liquid-handwash-rose'),
  'LIQUIDHANDWAS-02', '20 L', 172000, 108000, 18, 1, 20600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'LIQUIDHANDWAS-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 1, 154800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 6, 144500, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 6, 137600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 24, 130700, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 24, 123800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'LIQUIDHANDWAS-02'), 59, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Foaming Handwash Refill
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'foaming-handwash-refill', 'Foaming Handwash Refill', 'Nivas Pro', 'hygiene', 'Handwash',
  '{business}',
  'Foam dispensers use up to 60% less per wash.',
  'A dilute-to-foam concentrate for foaming dispensers. The reason to switch: a foam pump delivers roughly a third of the liquid per press, so a washroom''s handwash cost falls sharply without anyone noticing a difference.',
  array['Up to 60% lower cost per wash', 'For foaming dispensers only', 'Light, clean fragrance'], '#E4E8F0', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'foaming-handwash-refill'),
  'FOAMINGHANDWA-01', '5 L', 56000, 35000, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FOAMINGHANDWA-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 1, 50400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 6, 47000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 6, 44800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 24, 42600, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 24, 40300, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FOAMINGHANDWA-01'), 47, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Instant Hand Sanitiser 70%
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'instant-hand-sanitiser-70', 'Instant Hand Sanitiser 70%', 'Nivas Pro', 'hygiene', 'Sanitisers',
  '{business,premium}',
  '70% IPA gel with added emollients.',
  'A 70% isopropyl alcohol gel that meets the standard efficacy threshold, with glycerine and aloe so that hands used many times a day do not crack.',
  array['70% IPA — meets efficacy threshold', 'Glycerine and aloe against drying', 'Dries without stickiness'], '#D8E7E4', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'instant-hand-sanitiser-70'),
  'INSTANTHANDS-01', '500 ml', 14000, 8200, 18, 1, 540, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'INSTANTHANDS-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 1, 12600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 6, 11800, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 6, 11200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 24, 10600, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 24, 10100, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'INSTANTHANDS-01'), 64, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'instant-hand-sanitiser-70'),
  'INSTANTHANDS-02', '5 L', 89000, 56000, 18, 1, 5200, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'INSTANTHANDS-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 1, 80100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 6, 74800, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 6, 71200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 24, 67600, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 24, 64100, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'INSTANTHANDS-02'), 93, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Nitrile Examination Gloves
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'nitrile-examination-gloves', 'Nitrile Examination Gloves', 'Sterix', 'hygiene', 'Gloves',
  '{business}',
  'Powder-free nitrile, box of 100.',
  'Powder-free blue nitrile gloves for kitchens, clinics and housekeeping. Nitrile over latex because it does not trigger latex allergy and holds up far better against oils and cleaning chemicals.',
  array['Powder-free, latex-free', 'Textured fingertips for wet grip', 'Chemical and oil resistant', '100 gloves per box'], '#CBD9E8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'nitrile-examination-gloves'),
  'NITRILEEXAMIN-01', 'Medium — box of 100', 48000, 33000, 18, 1, 900, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'NITRILEEXAMIN-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 1, 44600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 5, 42200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 5, 40800, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 20, 39400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 20, 37900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'NITRILEEXAMIN-01'), 81, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'nitrile-examination-gloves'),
  'NITRILEEXAMIN-02', 'Large — box of 100', 48000, 33000, 18, 1, 950, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'NITRILEEXAMIN-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 1, 44600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 5, 42200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 5, 40800, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 20, 39400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 20, 37900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'NITRILEEXAMIN-02'), 110, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Facial Tissue Box
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'facial-tissue-box', 'Facial Tissue Box', 'Softline', 'hygiene', 'Tissues',
  '{business,premium}',
  '2-ply, 100 pulls per box.',
  'Soft 2-ply facial tissue in a flat box for tables, guest rooms and reception counters. 100 pulls per box, sold by the pack or the carton.',
  array['2-ply, 100 pulls', 'Virgin pulp, unbleached-safe', 'Flat box fits table dispensers'], '#EFEDE7', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'facial-tissue-box'),
  'FACIALTISSUE-01', 'Pack of 12 boxes', 54000, 37200, 18, 1, 3200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FACIALTISSUE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 1, 50200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 5, 47500, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 5, 45900, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 20, 44300, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 20, 42700, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FACIALTISSUE-01'), 98, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'facial-tissue-box'),
  'FACIALTISSUE-02', 'Carton of 48 boxes', 198000, 137000, 18, 1, 12800, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FACIALTISSUE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 1, 184100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 5, 174200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 5, 168300, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 20, 162400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 20, 156400, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FACIALTISSUE-02'), 127, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Multifold Paper Towels
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'multifold-paper-towels', 'Multifold Paper Towels', 'Softline', 'hygiene', 'Paper towels',
  '{business}',
  'Interfolded hand towels for washroom dispensers.',
  'Interfolded multifold towels that dispense one at a time — which is what actually controls washroom paper cost, more than the price per sheet does.',
  array['One-at-a-time dispensing', 'Fits standard multifold dispensers', '150 sheets per pack', 'Absorbent 1-ply'], '#E9E4D9', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'multifold-paper-towels'),
  'MULTIFOLDPAPE-01', 'Pack of 20 (3,000 sheets)', 76000, 52000, 18, 1, 6400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MULTIFOLDPAPE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 1, 70700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 5, 66900, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 5, 64600, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 20, 62300, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 20, 60000, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-01'), 115, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'multifold-paper-towels'),
  'MULTIFOLDPAPE-02', 'Carton of 60 (9,000 sheets)', 215000, 148000, 18, 1, 19200, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MULTIFOLDPAPE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 1, 199900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 5, 189200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 5, 182800, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 20, 176300, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 20, 169900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MULTIFOLDPAPE-02'), 144, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Toilet Rolls — 2 Ply
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'toilet-rolls-2-ply', 'Toilet Rolls — 2 Ply', 'Softline', 'hygiene', 'Tissues',
  '{business,premium}',
  'Soft 2-ply, 300 pulls per roll.',
  'Standard-core 2-ply toilet rolls at 300 pulls, the size most Indian washroom holders are built for. Sold by the pack for small sites and the carton for hotels.',
  array['2-ply, 300 pulls per roll', 'Standard core fits most holders', 'Carton pricing for hotels'], '#F0EBE2', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'toilet-rolls-2-ply'),
  'TOILETROLLS2-01', 'Pack of 12 rolls', 42000, 28800, 18, 1, 2400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TOILETROLLS2-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 1, 39100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 5, 37000, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 5, 35700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 20, 34400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 20, 33200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TOILETROLLS2-01'), 132, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'toilet-rolls-2-ply'),
  'TOILETROLLS2-02', 'Carton of 48 rolls', 156000, 107500, 18, 1, 9600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TOILETROLLS2-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 1, 145100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 5, 137300, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 5, 132600, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 20, 127900, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 20, 123200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TOILETROLLS2-02'), 161, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Alcohol Surface Wipes
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'alcohol-surface-wipes', 'Alcohol Surface Wipes', 'Sterix', 'hygiene', 'Disinfectants',
  '{business}',
  '70% alcohol wipes, 80-sheet canister.',
  'Pull-top canister wipes for tables, POS terminals, gym equipment and door handles — anywhere a spray bottle is impractical because there is a customer standing there.',
  array['70% alcohol', '80 wipes per canister', 'Safe on screens and POS terminals', 'Resealable lid keeps wipes moist'], '#DDE7EC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'alcohol-surface-wipes'),
  'ALCOHOLSURFAC-01', 'Pack of 6 canisters', 69000, 47000, 18, 1, 2900, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'ALCOHOLSURFAC-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 1, 64200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 5, 60700, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 5, 58700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 20, 56600, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 20, 54500, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'ALCOHOLSURFAC-01'), 149, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Dishwash Liquid — Lime
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'dishwash-liquid-lime', 'Dishwash Liquid — Lime', 'Nivas Pro', 'kitchen', 'Dishwash',
  '{business,premium}',
  'High-foam, cuts oil in hard water.',
  'A high-active dishwash concentrate that keeps foaming in hard water and through heavy oil — the two conditions that make a cheap dishwash stop working halfway through a sink.',
  array['Holds foam in hard water', 'Cuts vegetable and animal fat', 'Dilutes 1:10 for pot wash', 'Rinses clean, no film'], '#DCE8C8', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'dishwash-liquid-lime'),
  'DISHWASHLIQUI-01', '5 L', 44000, 27200, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DISHWASHLIQUI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 1, 39600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 6, 37000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 6, 35200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 24, 33400, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 24, 31700, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DISHWASHLIQUI-01'), 166, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'dishwash-liquid-lime'),
  'DISHWASHLIQUI-02', '25 L', 192000, 120000, 18, 1, 25800, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DISHWASHLIQUI-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 1, 172800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 6, 161300, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 6, 153600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 24, 145900, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 24, 138200, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DISHWASHLIQUI-02'), 195, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Kitchen Degreaser Spray
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'kitchen-degreaser-spray', 'Kitchen Degreaser Spray', 'Nivas Pro', 'kitchen', 'Kitchen cleaners',
  '{business}',
  'Ready-to-use spray for counters and ranges.',
  'A ready-to-use trigger spray for stainless counters, range surrounds and splash-backs during service, when there is no time to mix a dilution.',
  array['Ready to use — no dilution', 'Food-contact safe after rinse', 'Safe on stainless steel'], '#E7E0C6', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'kitchen-degreaser-spray'),
  'KITCHENDEGREA-01', '500 ml', 13000, 7800, 18, 1, 560, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'KITCHENDEGREA-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 1, 11700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 6, 10900, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 6, 10400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 24, 9900, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 24, 9400, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'KITCHENDEGREA-01'), 183, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'kitchen-degreaser-spray'),
  'KITCHENDEGREA-02', '5 L refill', 56000, 35000, 18, 1, 5300, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'KITCHENDEGREA-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 1, 50400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 6, 47000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 6, 44800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 24, 42600, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 24, 40300, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'KITCHENDEGREA-02'), 212, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Dishwasher Rinse Aid
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'dishwasher-rinse-aid', 'Dishwasher Rinse Aid', 'Nivas Pro', 'kitchen', 'Dishwash',
  '{business}',
  'Spot-free drying for commercial machines.',
  'For hood-type and undercounter commercial dishwashers. Breaks the surface tension of the final rinse so glassware dries without water spots and comes out of the machine ready for service.',
  array['Spot-free glassware', 'For commercial machines only', 'Low dosage — 2–4 ml per rack'], '#D6E4EA', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'dishwasher-rinse-aid'),
  'DISHWASHERRIN-01', '5 L', 78000, 49000, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DISHWASHERRIN-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 1, 70200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 6, 65500, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 6, 62400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 24, 59300, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 24, 56200, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DISHWASHERRIN-01'), 200, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Scrubber Pads
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'scrubber-pads', 'Scrubber Pads', 'GripCo', 'kitchen', 'Scrubbers',
  '{business}',
  'Green abrasive pads, standard kitchen size.',
  'The standard green nylon abrasive pad. Consumable, high-turnover, and the item most kitchens run out of first.',
  array['Standard 100 × 150 mm', 'Non-rusting nylon', 'Rinses clean and re-dries'], '#CFE0C4', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'scrubber-pads'),
  'SCRUBBERPADS-01', 'Pack of 10', 13000, 8400, 18, 1, 320, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SCRUBBERPADS-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 1, 12100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 5, 11400, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 5, 11100, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 20, 10700, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 20, 10300, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SCRUBBERPADS-01'), 217, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'scrubber-pads'),
  'SCRUBBERPADS-02', 'Pack of 50', 56000, 36800, 18, 1, 1600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SCRUBBERPADS-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 1, 52100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 5, 49300, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 5, 47600, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 20, 45900, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 20, 44200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SCRUBBERPADS-02'), 66, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Stainless Steel Scrubbers
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'stainless-steel-scrubbers', 'Stainless Steel Scrubbers', 'GripCo', 'kitchen', 'Scrubbers',
  '{business}',
  'Spiral steel scrubbers for pots and tawas.',
  'Spiral-wound stainless scrubbers for burnt pots, tawas and kadhais. Rust-resistant grade so they survive a wet kitchen.',
  array['Rust-resistant stainless', 'Spiral wound — holds shape', 'For heavy pot wash'], '#DFE2E5', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'stainless-steel-scrubbers'),
  'STAINLESSSTEE-01', 'Pack of 12', 24000, 15800, 18, 1, 480, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'STAINLESSSTEE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 1, 22300, 'business', 'Business price'),
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 5, 21100, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 5, 20400, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 20, 19700, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 20, 19000, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'STAINLESSSTEE-01'), 54, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Microfibre Kitchen Cloths
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'microfibre-kitchen-cloths', 'Microfibre Kitchen Cloths', 'GripCo', 'kitchen', 'Cleaning cloths',
  '{business,premium}',
  'Lint-free, colour-coded, machine washable.',
  'Colour-coded microfibre cloths so kitchen, washroom and front-of-house cloths never get mixed up — the cheapest cross-contamination control there is. Machine washable 300+ times.',
  array['Colour-coded by zone', 'Lint-free on glass and steel', 'Machine washable 300+ times', '40 × 40 cm'], '#D5E2E8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'microfibre-kitchen-cloths'),
  'MICROFIBREKIT-01', 'Pack of 6', 29000, 18600, 18, 1, 300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MICROFIBREKIT-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 1, 27000, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 5, 25500, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 5, 24700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 20, 23800, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 20, 22900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MICROFIBREKIT-01'), 71, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'microfibre-kitchen-cloths'),
  'MICROFIBREKIT-02', 'Pack of 24', 99000, 64000, 18, 1, 1200, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MICROFIBREKIT-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 1, 92100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 5, 87100, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 5, 84200, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 20, 81200, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 20, 78200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MICROFIBREKIT-02'), 100, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Garbage Bags — Medium (19 × 21 in)
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'garbage-bags-medium-19-21-in', 'Garbage Bags — Medium (19 × 21 in)', 'Nivas Pro', 'waste', 'Garbage bags',
  '{business}',
  'For desk-side and washroom bins.',
  'Medium bin liners for office desks, washrooms and guest rooms. Gauge chosen so they hold wet waste without splitting, which is where the cheapest bags fail.',
  array['19 × 21 in, fits 10–15 L bins', 'Leak-resistant seal', '30 bags per roll'], '#D3D6DA', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-medium-19-21-in'),
  'GARBAGEBAGSM-01', 'Pack of 30', 13000, 8400, 18, 1, 600, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSM-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 1, 12100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 5, 11400, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 5, 11100, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 20, 10700, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 20, 10300, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSM-01'), 88, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-medium-19-21-in'),
  'GARBAGEBAGSM-02', 'Case of 10 packs', 118000, 77000, 18, 1, 6000, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSM-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 1, 109700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 5, 103800, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 5, 100300, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 20, 96800, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 20, 93200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSM-02'), 117, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Garbage Bags — Large (24 × 32 in)
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'garbage-bags-large-24-32-in', 'Garbage Bags — Large (24 × 32 in)', 'Nivas Pro', 'waste', 'Garbage bags',
  '{business}',
  'Kitchen and corridor bins.',
  'Large liners for kitchen bins and corridor stations. Heavier gauge for wet kitchen waste.',
  array['24 × 32 in, fits 30–40 L bins', 'Heavier gauge for wet waste', '30 bags per roll'], '#CBCFD4', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-large-24-32-in'),
  'GARBAGEBAGSL-01', 'Pack of 30', 23000, 15000, 18, 1, 1100, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSL-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 1, 21400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 5, 20200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 5, 19600, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 20, 18900, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 20, 18200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSL-01'), 105, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-large-24-32-in'),
  'GARBAGEBAGSL-02', 'Case of 10 packs', 208000, 136000, 18, 1, 11000, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSL-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 1, 193400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 5, 183000, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 5, 176800, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 20, 170600, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 20, 164300, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSL-02'), 134, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Garbage Bags — Extra Large (30 × 37 in)
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'garbage-bags-extra-large-30-37-in', 'Garbage Bags — Extra Large (30 × 37 in)', 'Nivas Pro', 'waste', 'Garbage bags',
  '{business}',
  'Loading-bay and collection bins.',
  'Extra-large liners for collection points, loading bays and event waste. Sold in 20s because they take up real space.',
  array['30 × 37 in, fits 60–80 L bins', 'Extra-heavy gauge', '20 bags per roll'], '#C4C8CD', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-extra-large-30-37-in'),
  'GARBAGEBAGSE-01', 'Pack of 20', 29000, 19000, 18, 1, 1400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 1, 27000, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 5, 25500, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 5, 24700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 20, 23800, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 20, 22900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSE-01'), 122, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'garbage-bags-extra-large-30-37-in'),
  'GARBAGEBAGSE-02', 'Case of 10 packs', 262000, 172000, 18, 1, 14000, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GARBAGEBAGSE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 1, 243700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 5, 230600, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 5, 222700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 20, 214800, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 20, 207000, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GARBAGEBAGSE-02'), 151, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Compostable Bin Liners
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'compostable-bin-liners', 'Compostable Bin Liners', 'Nivas Pro', 'waste', 'Bin liners',
  '{business}',
  'IS 17088 certified, for wet-waste segregation.',
  'Certified compostable liners for wet-waste bins. Relevant wherever municipal segregation rules apply, and increasingly asked for by corporate clients during audits.',
  array['IS 17088 compostable certification', 'Corn-starch based', 'For wet-waste streams', '24 × 32 in'], '#D6DFC9', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'compostable-bin-liners'),
  'COMPOSTABLEBI-01', 'Pack of 30', 34000, 23200, 18, 1, 1150, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMPOSTABLEBI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 1, 31600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 5, 29900, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 5, 28900, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 20, 27900, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 20, 26900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMPOSTABLEBI-01'), 139, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Pedal Waste Bin
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'pedal-waste-bin', 'Pedal Waste Bin', 'GripCo', 'waste', 'Waste bins',
  '{business}',
  'Hands-free plastic bin with inner bucket.',
  'Moulded pedal bin with a removable inner bucket, so the liner can be changed without touching the outer body. Hands-free operation matters most in kitchens and clinics.',
  array['Removable inner bucket', 'Hands-free pedal', 'Impact-resistant polypropylene'], '#DADEE1', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'pedal-waste-bin'),
  'PEDALWASTEBI-01', '20 L', 69000, 46000, 18, 1, 1800, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'PEDALWASTEBI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'PEDALWASTEBI-01'), 1, 64900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'PEDALWASTEBI-01'), 10, 62100, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'PEDALWASTEBI-01'), 10, 60700, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'PEDALWASTEBI-01'), 156, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'pedal-waste-bin'),
  'PEDALWASTEBI-02', '60 L', 149000, 99000, 18, 1, 4200, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'PEDALWASTEBI-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'PEDALWASTEBI-02'), 1, 140100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'PEDALWASTEBI-02'), 10, 134100, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'PEDALWASTEBI-02'), 10, 131100, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'PEDALWASTEBI-02'), 185, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Commercial Laundry Detergent
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'commercial-laundry-detergent', 'Commercial Laundry Detergent', 'Nivas Pro', 'laundry', 'Laundry detergent',
  '{business}',
  'Low-foam liquid for front-loading machines.',
  'A low-foam liquid detergent for commercial front-loaders handling linen, uniforms and towels. Low-foam matters — a high-foam domestic detergent will cushion the drum and stop the wash mechanically working.',
  array['Low-foam, for front-loaders', 'Enzyme blend for food and body soil', 'Effective from 30 °C', 'Dilutes by load weight'], '#D5DEEC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'commercial-laundry-detergent'),
  'COMMERCIALLAU-01', '5 L', 62000, 38800, 18, 1, 5400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMMERCIALLAU-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 1, 55800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 6, 52100, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 6, 49600, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 24, 47100, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 24, 44600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMMERCIALLAU-01'), 173, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'commercial-laundry-detergent'),
  'COMMERCIALLAU-02', '25 L', 275000, 172500, 18, 1, 26000, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'COMMERCIALLAU-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 1, 247500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 6, 231000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 6, 220000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 24, 209000, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 24, 198000, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'COMMERCIALLAU-02'), 202, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Fabric Conditioner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'fabric-conditioner', 'Fabric Conditioner', 'Nivas Pro', 'laundry', 'Fabric conditioner',
  '{business,premium}',
  'Softens linen and cuts ironing time.',
  'A concentrated conditioner for hotel and restaurant linen. The real economic argument is not softness — it is that conditioned linen irons faster, and ironing is the expensive part of a laundry.',
  array['Reduces ironing time', 'Light, clean fragrance', 'Reduces static on synthetics', 'Concentrated — 15 ml per load'], '#E3DCEA', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'fabric-conditioner'),
  'FABRICCONDITI-01', '5 L', 48000, 30000, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FABRICCONDITI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 1, 43200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 6, 40300, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 6, 38400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 24, 36500, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 24, 34600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FABRICCONDITI-01'), 190, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'fabric-conditioner'),
  'FABRICCONDITI-02', '20 L', 176000, 110500, 18, 1, 20600, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FABRICCONDITI-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 1, 158400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 6, 147800, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 6, 140800, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 24, 133800, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 24, 126700, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FABRICCONDITI-02'), 219, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Laundry Stain Remover
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'laundry-stain-remover', 'Laundry Stain Remover', 'Nivas Pro', 'laundry', 'Laundry chemicals',
  '{business}',
  'Pre-spotter for oil, curry and wine.',
  'A pre-wash spotter for the stains that actually show up in Indian hospitality laundry: cooking oil, turmeric, curry, red wine and tea.',
  array['Works on turmeric and curry', 'Apply 5 minutes before wash', 'Safe on cotton and poly-cotton'], '#EADFD6', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'laundry-stain-remover'),
  'LAUNDRYSTAIN-01', '5 L', 69000, 43200, 18, 1, 5300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'LAUNDRYSTAIN-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 1, 62100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 6, 58000, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 6, 55200, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 24, 52400, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 24, 49700, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'LAUNDRYSTAIN-01'), 207, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Detergent Powder — Bulk
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'detergent-powder-bulk', 'Detergent Powder — Bulk', 'Nivas Pro', 'laundry', 'Laundry detergent',
  '{business}',
  'High-active powder for top-loaders and hand wash.',
  'A high-active detergent powder for top-loading machines and hand wash, sold in sacks for staff quarters, hostels and small laundries.',
  array['High active content', 'For top-loaders and hand wash', 'Sack packing, low cost per kg'], '#E1E5EA', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'detergent-powder-bulk'),
  'DETERGENTPOWD-01', '5 kg', 48000, 31000, 18, 1, 5100, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DETERGENTPOWD-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 1, 43200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 6, 40300, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 6, 38400, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 24, 36500, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 24, 34600, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DETERGENTPOWD-01'), 44, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'detergent-powder-bulk'),
  'DETERGENTPOWD-02', '25 kg', 215000, 139000, 18, 1, 25200, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DETERGENTPOWD-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 1, 193500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 6, 180600, 'retail', '6+ units'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 6, 172000, 'business', '6+ on business'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 24, 163400, 'retail', '24+ units'),
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 24, 154800, 'business', '24+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DETERGENTPOWD-02'), 73, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Microfibre Wet Mop with Handle
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'microfibre-wet-mop-with-handle', 'Microfibre Wet Mop with Handle', 'GripCo', 'equipment', 'Mops',
  '{business}',
  '360° flat mop with telescopic handle.',
  'A flat microfibre mop on a telescopic aluminium handle with a 360° swivel head, so it reaches under fixed seating and behind equipment without lifting furniture.',
  array['360° swivel head', 'Telescopic aluminium handle', 'Washable microfibre pad included', 'Replacement pads sold separately'], '#D8DEE4', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'microfibre-wet-mop-with-handle'),
  'MICROFIBREWET-01', 'Single unit', 78000, 50500, 18, 1, 900, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MICROFIBREWET-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MICROFIBREWET-01'), 1, 73300, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MICROFIBREWET-01'), 10, 70200, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'MICROFIBREWET-01'), 10, 68600, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MICROFIBREWET-01'), 61, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Floor Wiper
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'floor-wiper', 'Floor Wiper', 'GripCo', 'equipment', 'Wipers',
  '{business}',
  'Double-blade silicone squeegee.',
  'A double-blade silicone floor wiper that clears water in one pass instead of two. Standard equipment for washrooms and wet kitchens.',
  array['Double silicone blade', 'Steel handle', 'Clears water in one pass'], '#D0D9E0', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'floor-wiper'),
  'FLOORWIPER-01', '45 cm', 34000, 22000, 18, 1, 700, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FLOORWIPER-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FLOORWIPER-01'), 1, 32000, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FLOORWIPER-01'), 10, 30600, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'FLOORWIPER-01'), 10, 29900, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FLOORWIPER-01'), 78, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'floor-wiper'),
  'FLOORWIPER-02', '60 cm', 46000, 29800, 18, 1, 950, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'FLOORWIPER-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'FLOORWIPER-02'), 1, 43200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'FLOORWIPER-02'), 10, 41400, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'FLOORWIPER-02'), 10, 40500, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'FLOORWIPER-02'), 107, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Heavy-Duty Toilet Brush
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'heavy-duty-toilet-brush', 'Heavy-Duty Toilet Brush', 'GripCo', 'equipment', 'Brushes',
  '{business}',
  'Stiff bristle with drip holder.',
  'Stiff-bristle toilet brush with a matching drip holder. Sold in sixes because washrooms are counted in stalls, not units.',
  array['Stiff, non-shedding bristle', 'Drip holder included', 'Sold in packs of 6'], '#DEDCD8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'heavy-duty-toilet-brush'),
  'HEAVYDUTYTOI-01', 'Pack of 6', 54000, 35200, 18, 1, 1400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HEAVYDUTYTOI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HEAVYDUTYTOI-01'), 1, 50800, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HEAVYDUTYTOI-01'), 10, 48600, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'HEAVYDUTYTOI-01'), 10, 47500, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HEAVYDUTYTOI-01'), 95, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Mop Bucket with Wringer
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'mop-bucket-with-wringer', 'Mop Bucket with Wringer', 'GripCo', 'equipment', 'Buckets',
  '{business}',
  'Wheeled bucket with side-press wringer.',
  'A wheeled mop bucket with a side-press wringer. The double-chamber version keeps dirty water separate from clean, which is the difference between mopping a floor and redistributing dirt across it.',
  array['Side-press wringer', 'Castor wheels', 'Double chamber separates clean and dirty water'], '#CFD8DE', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'mop-bucket-with-wringer'),
  'MOPBUCKETWIT-01', 'Single chamber — 20 L', 169000, 112000, 18, 1, 3200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MOPBUCKETWIT-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MOPBUCKETWIT-01'), 1, 158900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MOPBUCKETWIT-01'), 10, 152100, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'MOPBUCKETWIT-01'), 10, 148700, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MOPBUCKETWIT-01'), 112, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'mop-bucket-with-wringer'),
  'MOPBUCKETWIT-02', 'Double chamber — 40 L', 329000, 218000, 18, 1, 6100, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MOPBUCKETWIT-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MOPBUCKETWIT-02'), 1, 309300, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MOPBUCKETWIT-02'), 10, 296100, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'MOPBUCKETWIT-02'), 10, 289500, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MOPBUCKETWIT-02'), 141, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Trigger Spray Bottles
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'trigger-spray-bottles', 'Trigger Spray Bottles', 'GripCo', 'equipment', 'Spray bottles',
  '{business}',
  '500 ml chemical-resistant bottles.',
  'Chemical-resistant 500 ml spray bottles with an adjustable nozzle and a writable label panel, so diluted chemicals get labelled rather than guessed at.',
  array['Chemical-resistant seals', 'Adjustable jet-to-mist nozzle', 'Writable label panel'], '#DBE3E6', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'trigger-spray-bottles'),
  'TRIGGERSPRAY-01', 'Pack of 6', 33000, 21400, 18, 1, 480, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TRIGGERSPRAY-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 1, 30700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 5, 29000, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 5, 28100, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 20, 27100, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 20, 26100, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TRIGGERSPRAY-01'), 129, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'trigger-spray-bottles'),
  'TRIGGERSPRAY-02', 'Pack of 24', 116000, 76000, 18, 1, 1900, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'TRIGGERSPRAY-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 1, 107900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 5, 102100, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 5, 98600, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 20, 95100, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 20, 91600, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'TRIGGERSPRAY-02'), 158, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Microfibre Cleaning Cloths
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'microfibre-cleaning-cloths', 'Microfibre Cleaning Cloths', 'GripCo', 'equipment', 'Microfibre cloths',
  '{business}',
  'General-purpose, 40 × 40 cm.',
  'General-purpose microfibre cloths for surfaces, glass and stainless. The single highest-turnover item on most housekeeping trolleys.',
  array['40 × 40 cm, 300 GSM', 'Lint-free', 'Machine washable 300+ times'], '#D4DEE2', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'microfibre-cleaning-cloths'),
  'MICROFIBRECLE-01', 'Pack of 12', 42000, 27200, 18, 1, 560, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MICROFIBRECLE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 1, 39100, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 5, 37000, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 5, 35700, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 20, 34400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 20, 33200, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MICROFIBRECLE-01'), 146, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'microfibre-cleaning-cloths'),
  'MICROFIBRECLE-02', 'Pack of 50', 159000, 103500, 18, 1, 2300, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'MICROFIBRECLE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 1, 147900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 5, 139900, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 5, 135200, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 20, 130400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 20, 125600, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'MICROFIBRECLE-02'), 175, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Guest Soap Bars — 15 g
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'guest-soap-bars-15-g', 'Guest Soap Bars — 15 g', 'Nivas Hospitality', 'hospitality', 'Guest soaps',
  '{business}',
  'Wrapped guest soaps for rooms and washrooms.',
  'Individually wrapped 15 g guest soaps in a neutral wrap that suits most room schemes. Custom-branded wrap is available on carton quantities through a bulk quote.',
  array['Individually wrapped', '15 g — standard room size', 'Custom branding on bulk orders', '500 bars per carton'], '#EDE6D9', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'guest-soap-bars-15-g'),
  'GUESTSOAPBAR-01', 'Carton of 500', 345000, 228000, 18, 1, 9500, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GUESTSOAPBAR-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 1, 320900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 5, 303600, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 5, 293300, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 20, 282900, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 20, 272600, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GUESTSOAPBAR-01'), 163, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Hotel Shampoo Sachets — 10 ml
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'hotel-shampoo-sachets-10-ml', 'Hotel Shampoo Sachets — 10 ml', 'Nivas Hospitality', 'hospitality', 'Shampoo',
  '{business}',
  'Single-use guest shampoo sachets.',
  'Single-use 10 ml shampoo sachets for guest rooms. Sachets rather than bottles where amenity budget matters more than presentation.',
  array['10 ml single use', 'Neutral fragrance', '500 sachets per carton'], '#E7E9DE', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hotel-shampoo-sachets-10-ml'),
  'HOTELSHAMPOO-01', 'Carton of 500', 265000, 175000, 18, 1, 6200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HOTELSHAMPOO-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 1, 246500, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 5, 233200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 5, 225300, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 20, 217300, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 20, 209400, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HOTELSHAMPOO-01'), 180, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Guest Dental Kits
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'guest-dental-kits', 'Guest Dental Kits', 'Nivas Hospitality', 'hospitality', 'Dental kits',
  '{business}',
  'Brush and paste in a sealed pouch.',
  'A toothbrush and a sachet of paste in a sealed pouch — the most-requested amenity at the front desk, and the cheapest complaint to prevent.',
  array['Brush plus paste sachet', 'Sealed hygienic pouch', '250 kits per carton'], '#DFE7EA', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'guest-dental-kits'),
  'GUESTDENTALK-01', 'Carton of 250', 315000, 208000, 18, 1, 5400, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'GUESTDENTALK-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 1, 293000, 'business', 'Business price'),
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 5, 277200, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 5, 267800, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 20, 258300, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 20, 248900, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'GUESTDENTALK-01'), 197, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Disposable Guest Slippers
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'disposable-guest-slippers', 'Disposable Guest Slippers', 'Nivas Hospitality', 'hospitality', 'Slippers',
  '{business}',
  'Non-woven closed-toe, one size.',
  'Closed-toe non-woven slippers with an EVA sole, individually bagged. One size fits most.',
  array['Closed toe with EVA sole', 'Individually bagged', '100 pairs per carton'], '#E9E4E0', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'disposable-guest-slippers'),
  'DISPOSABLEGUE-01', 'Carton of 100 pairs', 420000, 279000, 18, 1, 8800, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'DISPOSABLEGUE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 1, 390600, 'business', 'Business price'),
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 5, 369600, 'retail', '5+ units'),
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 5, 357000, 'business', '5+ on business'),
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 20, 344400, 'retail', '20+ units'),
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 20, 331800, 'business', '20+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'DISPOSABLEGUE-01'), 214, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Bath Towels — 500 GSM
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'bath-towels-500-gsm', 'Bath Towels — 500 GSM', 'Nivas Hospitality', 'hospitality', 'Towels',
  '{business}',
  'Ring-spun cotton, hotel white.',
  '500 GSM ring-spun cotton bath towels in hotel white, built to survive commercial laundering. Anything lighter than 450 GSM will not hold up past a season of industrial washing.',
  array['500 GSM ring-spun cotton', 'Withstands commercial laundering', '70 × 140 cm', 'Hotel white'], '#F1F0EC', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'bath-towels-500-gsm'),
  'BATHTOWELS50-01', 'Pack of 12', 468000, 312000, 18, 1, 7200, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'BATHTOWELS50-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'BATHTOWELS50-01'), 1, 439900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'BATHTOWELS50-01'), 10, 421200, 'retail', '10+ units'),
  ((select id from product_variants where sku = 'BATHTOWELS50-01'), 10, 411800, 'business', '10+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'BATHTOWELS50-01'), 51, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Signature Handwash
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'signature-handwash', 'Signature Handwash', 'Nivas', 'premium', 'Premium handwash',
  '{premium}',
  'Bergamot, cedar and a rich, quiet lather.',
  'A gentle everyday handwash built around bergamot and cedarwood. Sulphate-free, glycerine-rich, and formulated so that hands washed a dozen times a day still feel like skin rather than paper. The 1 L refill exists so the weighted bottle stays on the basin.',
  array['Bergamot, cedarwood and vetiver', 'Sulphate-free, glycerine-rich', 'pH 5.5 — matched to skin', '1 L refill for the weighted bottle'], '#DCCFC0', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'signature-handwash'),
  'SIGNATUREHAND-01', '250 ml', 24900, 9600, 18, 1, 300, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SIGNATUREHAND-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 1, 23700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 3, 22900, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 3, 22400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 12, 21400, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 12, 20900, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-01'), 68, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'signature-handwash'),
  'SIGNATUREHAND-02', '500 ml', 34900, 13200, 18, 1, 560, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SIGNATUREHAND-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 1, 33200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 3, 32100, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 3, 31400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 12, 30000, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 12, 29300, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-02'), 97, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'signature-handwash'),
  'SIGNATUREHAND-03', '1 L refill', 54900, 19800, 18, 1, 1080, 2
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SIGNATUREHAND-03');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 1, 52200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 3, 50500, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 3, 49400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 12, 47200, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 12, 46100, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SIGNATUREHAND-03'), 126, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Hydrating Body Wash
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'hydrating-body-wash', 'Hydrating Body Wash', 'Nivas', 'premium', 'Body wash',
  '{premium}',
  'Oat milk and shea, for skin that dries out.',
  'A creamy, low-foam body wash with colloidal oat and shea butter. Low foam is deliberate: foam is what strips skin, and this is built for people whose skin does not tolerate being stripped.',
  array['Colloidal oat and shea butter', 'Sulphate-free, low-foam', 'Fragrance-light', 'Suitable for dry and sensitive skin'], '#E6DCCC', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hydrating-body-wash'),
  'HYDRATINGBODY-01', '300 ml', 44900, 16800, 18, 1, 350, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HYDRATINGBODY-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 1, 42700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 3, 41300, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 3, 40400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 12, 38600, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 12, 37700, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HYDRATINGBODY-01'), 85, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hydrating-body-wash'),
  'HYDRATINGBODY-02', '500 ml', 64900, 23600, 18, 1, 560, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HYDRATINGBODY-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 1, 61700, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 3, 59700, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 3, 58400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 12, 55800, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 12, 54500, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HYDRATINGBODY-02'), 114, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Nourishing Shampoo
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'nourishing-shampoo', 'Nourishing Shampoo', 'Nivas', 'premium', 'Shampoo',
  '{premium}',
  'Sulphate-free, safe on colour.',
  'A sulphate-free shampoo with amino-acid surfactants that cleans without stripping colour. It will not lather like a supermarket shampoo — that is the point.',
  array['Sulphate and silicone free', 'Colour-safe', 'Amino-acid surfactant base', 'Argan and rice protein'], '#E0D9C6', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'nourishing-shampoo'),
  'NOURISHINGSHA-01', '300 ml', 54900, 20500, 18, 1, 350, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'NOURISHINGSHA-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 1, 52200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 3, 50500, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 3, 49400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 12, 47200, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 12, 46100, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'NOURISHINGSHA-01'), 102, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'nourishing-shampoo'),
  'NOURISHINGSHA-02', '500 ml', 74900, 27200, 18, 1, 560, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'NOURISHINGSHA-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 1, 71200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 3, 68900, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 3, 67400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 12, 64400, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 12, 62900, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'NOURISHINGSHA-02'), 131, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Silk Conditioner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'silk-conditioner', 'Silk Conditioner', 'Nivas', 'premium', 'Conditioner',
  '{premium}',
  'Lightweight slip, no build-up.',
  'A lightweight conditioner that gives enough slip to comb through wet hair without leaving the weight that silicone conditioners build up over weeks.',
  array['Silicone-free', 'No build-up', 'Rice protein and jojoba', 'Pairs with the Nourishing Shampoo'], '#E3DED2', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'silk-conditioner'),
  'SILKCONDITION-01', '300 ml', 54900, 20800, 18, 1, 350, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'SILKCONDITION-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 1, 52200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 3, 50500, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 3, 49400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 12, 47200, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 12, 46100, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'SILKCONDITION-01'), 119, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Home Fragrance Diffuser
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'home-fragrance-diffuser', 'Home Fragrance Diffuser', 'Nivas', 'premium', 'Home fragrance',
  '{premium}',
  'Sandalwood and amber. Eight weeks of throw.',
  'A reed diffuser in sandalwood, amber and a dry cedar base. Eight to ten weeks of throw in a normal-sized room, in a weighted glass vessel worth keeping and refilling.',
  array['Sandalwood, amber, cedar', '8–10 weeks of throw', 'Weighted glass vessel', 'Refill available separately'], '#D9C9B4', true
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'home-fragrance-diffuser'),
  'HOMEFRAGRANCE-01', '200 ml', 89900, 32000, 18, 1, 700, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HOMEFRAGRANCE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 1, 85400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 3, 82700, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 3, 80900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 12, 77300, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 12, 75500, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-01'), 136, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'home-fragrance-diffuser'),
  'HOMEFRAGRANCE-02', '200 ml refill', 59900, 19200, 18, 1, 320, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HOMEFRAGRANCE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 1, 56900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 3, 55100, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 3, 53900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 12, 51500, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 12, 50300, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HOMEFRAGRANCE-02'), 165, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Luxury Surface Cleaner
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'luxury-surface-cleaner', 'Luxury Surface Cleaner', 'Nivas', 'premium', 'Premium home cleaning',
  '{premium}',
  'Plant-derived, fig leaf and neroli.',
  'A plant-derived multi-surface spray that happens to smell like fig leaf and neroli — made for kitchens people cook in and then sit down in, where the smell of the cleaner lingers longer than the meal.',
  array['Plant-derived surfactants', 'Fig leaf and neroli', 'Safe on sealed stone and wood', 'Glass bottle, refill available'], '#D3DCC8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'luxury-surface-cleaner'),
  'LUXURYSURFACE-01', '500 ml', 39900, 14200, 18, 1, 620, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'LUXURYSURFACE-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 1, 37900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 3, 36700, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 3, 35900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 12, 34300, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 12, 33500, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'LUXURYSURFACE-01'), 153, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'luxury-surface-cleaner'),
  'LUXURYSURFACE-02', '1 L refill', 59900, 20500, 18, 1, 1080, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'LUXURYSURFACE-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 1, 56900, 'business', 'Business price'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 3, 55100, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 3, 53900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 12, 51500, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 12, 50300, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'LUXURYSURFACE-02'), 182, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Premium Dishwash
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'premium-dishwash', 'Premium Dishwash', 'Nivas', 'premium', 'Premium home cleaning',
  '{premium}',
  'Kind to hands, hard on oil.',
  'A concentrated dishwash with added glycerine, for people who wash up by hand and would rather not need hand cream afterwards.',
  array['Glycerine-enriched', 'Plant-derived surfactants', 'Concentrated — a little goes far', 'Lemongrass and basil'], '#DCE4C9', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'premium-dishwash'),
  'PREMIUMDISHWA-01', '500 ml', 34900, 12400, 18, 1, 620, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'PREMIUMDISHWA-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 1, 33200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 3, 32100, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 3, 31400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 12, 30000, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 12, 29300, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'PREMIUMDISHWA-01'), 170, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'premium-dishwash'),
  'PREMIUMDISHWA-02', '1 L refill', 54900, 18600, 18, 1, 1080, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'PREMIUMDISHWA-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 1, 52200, 'business', 'Business price'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 3, 50500, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 3, 49400, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 12, 47200, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 12, 46100, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'PREMIUMDISHWA-02'), 199, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Room & Linen Mist
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'room-linen-mist', 'Room & Linen Mist', 'Nivas', 'premium', 'Home fragrance',
  '{premium}',
  'Light enough for bedding.',
  'A fine mist for linen, curtains and upholstery, dosed light enough that it settles into fabric rather than sitting on top of it.',
  array['Safe on bedding and upholstery', 'Alcohol-light, no staining', 'White tea and iris'], '#E4E1D8', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'room-linen-mist'),
  'ROOMLINENMIS-01', '200 ml', 49900, 17800, 18, 1, 280, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'ROOMLINENMIS-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 1, 47400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 3, 45900, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 3, 44900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 12, 42900, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 12, 41900, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'ROOMLINENMIS-01'), 187, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

-- Hand & Body Lotion
insert into products (
  slug, name, brand, category_slug, subcategory, storefronts,
  short_description, description, highlights, swatch, featured
) values (
  'hand-body-lotion', 'Hand & Body Lotion', 'Nivas', 'premium', 'Body wash',
  '{premium}',
  'Absorbs before you put the bottle down.',
  'A non-greasy lotion with shea and squalane that absorbs fast enough to use during a working day rather than only before bed.',
  array['Shea butter and squalane', 'Absorbs in under a minute', 'Non-greasy finish', 'Matches the Signature fragrance'], '#E8DFD1', false
) on conflict (slug) do update set
  name = excluded.name, brand = excluded.brand,
  category_slug = excluded.category_slug, subcategory = excluded.subcategory,
  storefronts = excluded.storefronts,
  short_description = excluded.short_description,
  description = excluded.description, highlights = excluded.highlights,
  swatch = excluded.swatch, featured = excluded.featured;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hand-body-lotion'),
  'HANDBODYLOTI-01', '300 ml', 49900, 18200, 18, 1, 350, 0
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HANDBODYLOTI-01');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 1, 47400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 3, 45900, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 3, 44900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 12, 42900, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 12, 41900, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HANDBODYLOTI-01'), 204, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

insert into product_variants (
  product_id, sku, size, list_price, cost_price, gst_rate, moq, weight_grams, position
) values (
  (select id from products where slug = 'hand-body-lotion'),
  'HANDBODYLOTI-02', '500 ml', 69900, 24800, 18, 1, 560, 1
) on conflict (sku) do update set
  size = excluded.size, list_price = excluded.list_price,
  cost_price = excluded.cost_price, gst_rate = excluded.gst_rate,
  moq = excluded.moq, weight_grams = excluded.weight_grams,
  position = excluded.position;

delete from price_tiers where variant_id = (select id from product_variants where sku = 'HANDBODYLOTI-02');
insert into price_tiers (variant_id, min_qty, unit_price, requires_tier, label) values
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 1, 66400, 'business', 'Business price'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 3, 64300, 'retail', '3+ units'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 3, 62900, 'business', '3+ on business'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 12, 60100, 'retail', '12+ units'),
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 12, 58700, 'business', '12+ on business')
on conflict (variant_id, min_qty, requires_tier) do nothing;

insert into inventory (variant_id, on_hand, reorder_point, reorder_qty) values
  ((select id from product_variants where sku = 'HANDBODYLOTI-02'), 53, 20, 40)
on conflict (variant_id) do update set on_hand = excluded.on_hand;

commit;
