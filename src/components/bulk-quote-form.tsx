"use client";

import Link from "next/link";
import { useMemo, useRef, useState } from "react";
import { Check, FileUp, Plus, Trash2 } from "lucide-react";
import { PRODUCTS } from "@/data/products";
import { floorPrice } from "@/lib/pricing";
import { rupees, cn } from "@/lib/format";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Field, Input, Textarea } from "./ui/field";

/**
 * Bulk quote request.
 *
 * Two ways in, because purchasing managers arrive with different artefacts:
 * a spreadsheet they already maintain, or a list in their head. The CSV path
 * matches loosely on product name — a quote request is reviewed by a human
 * before it becomes a price, so a fuzzy match is cheap and a rejected upload
 * is not.
 *
 * The indicative total shown is deliberately labelled as an upper bound: it is
 * built from published bulk tiers, and a real quote should come in under it.
 */

interface QuoteLine {
  /** Local row id — rows outlive the product selected in them. */
  key: string;
  variantId: string;
  qty: number;
}

const VARIANTS = PRODUCTS.flatMap((p) =>
  p.variants.map((v) => ({
    id: v.id,
    label: `${p.name} — ${v.size}`,
    search: `${p.name} ${v.size} ${v.sku}`.toLowerCase(),
    variant: v,
    product: p,
  })),
);

let rowCounter = 0;
const newRow = (): QuoteLine => ({ key: `r${rowCounter++}`, variantId: "", qty: 100 });

export function BulkQuoteForm() {
  const [lines, setLines] = useState<QuoteLine[]>([newRow(), newRow(), newRow()]);
  const [notes, setNotes] = useState("");
  const [contact, setContact] = useState({ business: "", name: "", phone: "", email: "" });
  const [submitted, setSubmitted] = useState(false);
  const [importNote, setImportNote] = useState<string | null>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  const filled = lines.filter((l) => l.variantId && l.qty > 0);

  const indicative = useMemo(
    () =>
      filled.reduce((sum, l) => {
        const match = VARIANTS.find((v) => v.id === l.variantId);
        return match ? sum + floorPrice(match.variant) * l.qty : sum;
      }, 0),
    [filled],
  );

  const totalUnits = filled.reduce((sum, l) => sum + l.qty, 0);
  const canSubmit =
    filled.length > 0 && contact.business.trim() !== "" && contact.phone.trim() !== "";

  function update(key: string, patch: Partial<QuoteLine>) {
    setLines((prev) => prev.map((l) => (l.key === key ? { ...l, ...patch } : l)));
  }

  /**
   * Parse a pasted or uploaded CSV. Expects `product,quantity`; a header row is
   * skipped if present. Unmatched rows are reported rather than silently dropped.
   */
  function importCsv(text: string) {
    const rows = text
      .split(/\r?\n/)
      .map((r) => r.trim())
      .filter(Boolean);
    if (rows.length === 0) return;
    if (/product|item|sku/i.test(rows[0]) && /qty|quantity/i.test(rows[0])) rows.shift();

    const parsed: QuoteLine[] = [];
    let unmatched = 0;

    for (const row of rows) {
      const cells = row.split(/[,\t;]/).map((c) => c.trim().replace(/^"|"$/g, ""));
      if (cells.length < 2) continue;
      const qty = parseInt(cells[cells.length - 1].replace(/[^\d]/g, ""), 10);
      const name = cells.slice(0, -1).join(" ").toLowerCase();
      if (!name || !Number.isFinite(qty) || qty <= 0) continue;

      const terms = name.split(/\s+/).filter((t) => t.length > 2);
      const match =
        VARIANTS.find((v) => v.search === name) ??
        VARIANTS.find((v) => terms.every((t) => v.search.includes(t)));

      if (match) parsed.push({ key: `r${rowCounter++}`, variantId: match.id, qty });
      else unmatched++;
    }

    if (parsed.length === 0) {
      setImportNote("Couldn't read that file. Expected two columns: product, quantity.");
      return;
    }
    setLines([...parsed, newRow()]);
    setImportNote(
      unmatched > 0
        ? `Imported ${parsed.length} lines. ${unmatched} couldn't be matched — add them by hand or describe them in the notes.`
        : `Imported ${parsed.length} lines.`,
    );
  }

  if (submitted) {
    return (
      <Container className="max-w-2xl py-24 text-center">
        <div className="mx-auto flex size-12 items-center justify-center rounded-full bg-brand-tint">
          <Check className="size-6 text-brand" aria-hidden />
        </div>
        <h1 className="display mt-6 text-[30px] font-semibold md:text-[38px]">
          Quote request received
        </h1>
        <p className="mx-auto mt-4 max-w-md text-[15px] leading-relaxed text-ink-soft">
          <span className="tnum">{filled.length}</span> lines,{" "}
          <span className="tnum">{totalUnits.toLocaleString("en-IN")}</span> units. We
          price against live supplier rates and come back within one working day —
          usually below the published bulk tier.
        </p>
        <div className="mt-8 flex flex-wrap justify-center gap-3">
          <Button asChild size="lg">
            <Link href="/business">Back to the catalogue</Link>
          </Button>
          <Button asChild size="lg" variant="outline">
            <Link href="/account">Track this quote</Link>
          </Button>
        </div>
        <p className="mt-8 text-[12.5px] text-muted">
          Placeholder flow — nothing is submitted until the backend is wired up.
        </p>
      </Container>
    );
  }

  return (
    <Container className="max-w-4xl py-12 md:py-16">
      <p className="eyebrow">Bulk orders</p>
      <h1 className="display mt-3 text-[32px] font-semibold md:text-[42px]">
        Need 100+ units?
      </h1>
      <p className="mt-4 max-w-xl text-[15px] leading-relaxed text-ink-soft">
        Send the list and we price it against live supplier rates. Upload the
        spreadsheet you already keep, or type the lines in below.
      </p>

      {/* ── Import ──────────────────────────────────────────────────────── */}
      <div className="mt-10 rounded-[var(--radius)] border border-dashed border-line-strong p-5">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <p className="text-[14px] font-medium">Import a list</p>
            <p className="mt-1 text-[12.5px] text-muted">
              CSV with two columns: product name, quantity.
            </p>
          </div>
          <Button variant="outline" size="sm" onClick={() => fileRef.current?.click()}>
            <FileUp className="size-4" /> Upload CSV
          </Button>
          <input
            ref={fileRef}
            type="file"
            accept=".csv,text/csv,text/plain"
            className="sr-only"
            onChange={async (e) => {
              const file = e.target.files?.[0];
              if (file) importCsv(await file.text());
              e.target.value = "";
            }}
          />
        </div>
        {importNote && <p className="mt-3 text-[12.5px] text-brand">{importNote}</p>}
      </div>

      {/* ── Lines ───────────────────────────────────────────────────────── */}
      <div className="mt-8">
        <div className="mb-2 hidden grid-cols-[1fr_120px_40px] gap-3 px-1 sm:grid">
          <span className="eyebrow">Product</span>
          <span className="eyebrow">Quantity</span>
          <span />
        </div>

        <ul className="space-y-2">
          {lines.map((line) => (
            <li key={line.key} className="grid grid-cols-[1fr_100px_40px] gap-3 sm:grid-cols-[1fr_120px_40px]">
              <select
                value={line.variantId}
                onChange={(e) => update(line.key, { variantId: e.target.value })}
                aria-label="Product"
                className={cn(
                  "h-10 w-full truncate rounded-[var(--radius)] border border-line bg-surface px-3 text-[14px] outline-none focus:border-ink",
                  !line.variantId && "text-muted",
                )}
              >
                <option value="">Select a product…</option>
                {VARIANTS.map((v) => (
                  <option key={v.id} value={v.id}>
                    {v.label}
                  </option>
                ))}
              </select>
              <Input
                type="number"
                min={1}
                value={line.qty}
                aria-label="Quantity"
                onChange={(e) => update(line.key, { qty: Number(e.target.value) || 0 })}
                className="tnum"
              />
              <button
                type="button"
                onClick={() => setLines((prev) => prev.filter((l) => l.key !== line.key))}
                disabled={lines.length === 1}
                aria-label="Remove line"
                className="flex size-10 items-center justify-center rounded-[var(--radius)] text-muted hover:text-danger disabled:opacity-30"
              >
                <Trash2 className="size-4" />
              </button>
            </li>
          ))}
        </ul>

        <Button
          variant="ghost"
          size="sm"
          className="mt-3"
          onClick={() => setLines((prev) => [...prev, newRow()])}
        >
          <Plus className="size-4" /> Add line
        </Button>
      </div>

      {filled.length > 0 && (
        <div className="mt-6 flex flex-wrap items-baseline justify-between gap-3 rounded-[var(--radius)] bg-sunk px-4 py-3.5">
          <p className="text-[13.5px] text-ink-soft">
            <span className="tnum font-medium text-ink">{filled.length}</span> lines ·{" "}
            <span className="tnum font-medium text-ink">
              {totalUnits.toLocaleString("en-IN")}
            </span>{" "}
            units
          </p>
          <p className="tnum text-[13.5px] text-ink-soft">
            Indicative ceiling{" "}
            <span className="font-semibold text-ink">{rupees(indicative)}</span>
            <span className="ml-1.5 text-muted">— your quote should come in under this</span>
          </p>
        </div>
      )}

      {/* ── Contact ─────────────────────────────────────────────────────── */}
      <div className="mt-10 border-t border-line pt-8">
        <p className="text-[17px] font-medium">Where should we send it?</p>
        <div className="mt-6 grid gap-5 sm:grid-cols-2">
          <Field label="Business name" required>
            <Input
              value={contact.business}
              onChange={(e) => setContact({ ...contact, business: e.target.value })}
              placeholder="ABC Café"
              autoComplete="organization"
            />
          </Field>
          <Field label="Contact person">
            <Input
              value={contact.name}
              onChange={(e) => setContact({ ...contact, name: e.target.value })}
              placeholder="Full name"
              autoComplete="name"
            />
          </Field>
          <Field label="Phone" required hint="We usually reply on WhatsApp">
            <Input
              type="tel"
              value={contact.phone}
              onChange={(e) => setContact({ ...contact, phone: e.target.value })}
              placeholder="+91 98765 43210"
              autoComplete="tel"
            />
          </Field>
          <Field label="Email">
            <Input
              type="email"
              value={contact.email}
              onChange={(e) => setContact({ ...contact, email: e.target.value })}
              placeholder="orders@abccafe.in"
              autoComplete="email"
            />
          </Field>
          <Field
            label="Anything else"
            hint="Delivery deadline, branding, items not in the catalogue"
            className="sm:col-span-2"
          >
            <Textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Need delivery before the 20th. Also looking for custom-branded guest soap."
            />
          </Field>
        </div>
      </div>

      <div className="mt-8 flex flex-wrap items-center gap-4 border-t border-line pt-6">
        <Button size="lg" disabled={!canSubmit} onClick={() => setSubmitted(true)}>
          Request quote
        </Button>
        <p className="text-[12.5px] text-muted">
          No commitment — you see the price before anything is confirmed.
        </p>
      </div>
    </Container>
  );
}
