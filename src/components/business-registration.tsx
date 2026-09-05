"use client";

import Link from "next/link";
import { useState } from "react";
import { ArrowLeft, ArrowRight, Check } from "lucide-react";
import type { BusinessType } from "@/lib/types";
import { cn } from "@/lib/format";
import { Container } from "./ui/container";
import { Button } from "./ui/button";
import { Field, Input } from "./ui/field";

/**
 * Business onboarding.
 *
 * Three steps, in this order deliberately: business type first because it is a
 * single tap and gets the visitor committed; details second; spend band last,
 * because asking a stranger what they spend before they have invested anything
 * is how forms get abandoned.
 *
 * The spend band is the most commercially valuable field on the form — it sets
 * the opening pricing tier and decides who gets a call. So it is asked once the
 * visitor is already three-quarters through.
 */

const BUSINESS_TYPES: Array<{ value: BusinessType; label: string; note: string }> = [
  { value: "restaurant", label: "Restaurant", note: "Kitchen, dining, washroom" },
  { value: "cafe", label: "Café", note: "Counter service, small kitchen" },
  { value: "hotel", label: "Hotel", note: "Rooms, laundry, amenities" },
  { value: "hostel", label: "Hostel / PG", note: "Shared facilities, laundry" },
  { value: "office", label: "Office", note: "Pantry, washroom, housekeeping" },
  { value: "gym", label: "Gym / Studio", note: "Equipment hygiene, changing rooms" },
  { value: "salon", label: "Salon / Spa", note: "Treatment areas, laundry" },
  { value: "school", label: "School", note: "Classrooms, washrooms, canteen" },
  { value: "clinic", label: "Clinic", note: "Disinfection, clinical waste" },
  { value: "other", label: "Something else", note: "Tell us on the next step" },
];

const SPEND_BANDS = [
  { value: "under-5k", label: "Under ₹5,000", note: "per month on supplies" },
  { value: "5k-20k", label: "₹5,000 – ₹20,000", note: "per month on supplies" },
  { value: "20k-50k", label: "₹20,000 – ₹50,000", note: "per month on supplies" },
  { value: "50k-plus", label: "₹50,000+", note: "per month on supplies" },
];

const STEPS = ["Business type", "Your details", "Volume"] as const;

export function BusinessRegistration() {
  const [step, setStep] = useState(0);
  const [type, setType] = useState<BusinessType | null>(null);
  const [spend, setSpend] = useState<string | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [details, setDetails] = useState({
    businessName: "",
    contactName: "",
    phone: "",
    email: "",
    gstin: "",
    address: "",
    city: "",
    pincode: "",
  });

  const detailsComplete =
    details.businessName.trim() !== "" &&
    details.contactName.trim() !== "" &&
    details.phone.trim() !== "" &&
    details.email.trim() !== "";

  const canAdvance = step === 0 ? type !== null : step === 1 ? detailsComplete : spend !== null;

  if (submitted) return <Submitted name={details.businessName} spend={spend} />;

  return (
    <Container className="max-w-3xl py-12 md:py-16">
      <p className="eyebrow">Business account</p>
      <h1 className="display mt-3 text-[32px] font-semibold md:text-[42px]">
        Open a business account
      </h1>
      <p className="mt-4 max-w-xl text-[15px] leading-relaxed text-ink-soft">
        Business pricing, GST invoices, scheduled delivery and one-tap reorder.
        No setup fee, no minimum commitment — about two minutes.
      </p>

      {/* ── Progress ────────────────────────────────────────────────────── */}
      <ol className="mt-10 flex items-center gap-2" aria-label="Progress">
        {STEPS.map((label, i) => (
          <li key={label} className="flex flex-1 items-center gap-2">
            <div className="flex-1">
              <div
                className={cn(
                  "h-0.5 rounded-full transition-colors",
                  i <= step ? "bg-brand" : "bg-line",
                )}
              />
              <p
                className={cn(
                  "mt-2 text-[12px]",
                  i === step ? "font-medium text-ink" : "text-muted",
                )}
              >
                {i < step && <Check className="mr-1 inline size-3 text-brand" aria-hidden />}
                {label}
              </p>
            </div>
          </li>
        ))}
      </ol>

      <div className="mt-10">
        {step === 0 && (
          <fieldset>
            <legend className="text-[17px] font-medium">What kind of business are you?</legend>
            <p className="mt-1.5 text-[13.5px] text-ink-soft">
              This sets which categories we put in front of you first.
            </p>
            <div className="mt-6 grid gap-2 sm:grid-cols-2">
              {BUSINESS_TYPES.map((t) => (
                <button
                  key={t.value}
                  type="button"
                  onClick={() => setType(t.value)}
                  aria-pressed={type === t.value}
                  className={cn(
                    "rounded-[var(--radius)] border px-4 py-3 text-left transition-colors",
                    type === t.value
                      ? "border-brand bg-brand-tint"
                      : "border-line hover:border-line-strong",
                  )}
                >
                  <span className="block text-[14.5px] font-medium">{t.label}</span>
                  <span className="mt-0.5 block text-[12.5px] text-muted">{t.note}</span>
                </button>
              ))}
            </div>
          </fieldset>
        )}

        {step === 1 && (
          <div>
            <p className="text-[17px] font-medium">Business details</p>
            <p className="mt-1.5 text-[13.5px] text-ink-soft">
              GSTIN is optional now — you can add it before your first invoice.
            </p>
            <div className="mt-6 grid gap-5 sm:grid-cols-2">
              <Field label="Business name" required className="sm:col-span-2">
                <Input
                  value={details.businessName}
                  onChange={(e) => setDetails({ ...details, businessName: e.target.value })}
                  placeholder="ABC Café"
                  autoComplete="organization"
                />
              </Field>
              <Field label="Contact person" required>
                <Input
                  value={details.contactName}
                  onChange={(e) => setDetails({ ...details, contactName: e.target.value })}
                  placeholder="Full name"
                  autoComplete="name"
                />
              </Field>
              <Field label="Phone" required>
                <Input
                  type="tel"
                  value={details.phone}
                  onChange={(e) => setDetails({ ...details, phone: e.target.value })}
                  placeholder="+91 98765 43210"
                  autoComplete="tel"
                />
              </Field>
              <Field label="Email" required className="sm:col-span-2">
                <Input
                  type="email"
                  value={details.email}
                  onChange={(e) => setDetails({ ...details, email: e.target.value })}
                  placeholder="orders@abccafe.in"
                  autoComplete="email"
                />
              </Field>
              <Field label="GSTIN" hint="Needed for input tax credit on your invoices">
                <Input
                  value={details.gstin}
                  onChange={(e) =>
                    setDetails({ ...details, gstin: e.target.value.toUpperCase() })
                  }
                  placeholder="29ABCDE1234F1Z5"
                  maxLength={15}
                  className="tnum"
                />
              </Field>
              <Field label="Pincode" hint="Confirms we deliver to you">
                <Input
                  value={details.pincode}
                  onChange={(e) => setDetails({ ...details, pincode: e.target.value })}
                  placeholder="560001"
                  maxLength={6}
                  className="tnum"
                  autoComplete="postal-code"
                />
              </Field>
              <Field label="Delivery address" className="sm:col-span-2">
                <Input
                  value={details.address}
                  onChange={(e) => setDetails({ ...details, address: e.target.value })}
                  placeholder="Street, area, landmark"
                  autoComplete="street-address"
                />
              </Field>
            </div>
          </div>
        )}

        {step === 2 && (
          <fieldset>
            <legend className="text-[17px] font-medium">
              Roughly what do you spend on supplies?
            </legend>
            <p className="mt-1.5 max-w-lg text-[13.5px] text-ink-soft">
              An estimate is fine. It decides your opening pricing tier — larger
              accounts start lower, and we would rather set that correctly than
              make you ask.
            </p>
            <div className="mt-6 grid gap-2 sm:grid-cols-2">
              {SPEND_BANDS.map((b) => (
                <button
                  key={b.value}
                  type="button"
                  onClick={() => setSpend(b.value)}
                  aria-pressed={spend === b.value}
                  className={cn(
                    "rounded-[var(--radius)] border px-4 py-3.5 text-left transition-colors",
                    spend === b.value
                      ? "border-brand bg-brand-tint"
                      : "border-line hover:border-line-strong",
                  )}
                >
                  <span className="tnum block text-[15px] font-medium">{b.label}</span>
                  <span className="mt-0.5 block text-[12.5px] text-muted">{b.note}</span>
                </button>
              ))}
            </div>
          </fieldset>
        )}
      </div>

      <div className="mt-10 flex items-center justify-between border-t border-line pt-6">
        {step > 0 ? (
          <Button variant="ghost" onClick={() => setStep((s) => s - 1)}>
            <ArrowLeft className="size-4" /> Back
          </Button>
        ) : (
          <Link href="/business" className="text-[13.5px] text-muted hover:text-ink">
            Not now
          </Link>
        )}

        <Button
          size="lg"
          disabled={!canAdvance}
          onClick={() => (step === 2 ? setSubmitted(true) : setStep((s) => s + 1))}
        >
          {step === 2 ? "Create account" : "Continue"}
          {step < 2 && <ArrowRight className="size-4" />}
        </Button>
      </div>
    </Container>
  );
}

function Submitted({ name, spend }: { name: string; spend: string | null }) {
  // Larger accounts get a human; smaller ones get self-serve. Same form, two paths.
  const highValue = spend === "20k-50k" || spend === "50k-plus";

  return (
    <Container className="max-w-2xl py-24 text-center">
      <div className="mx-auto flex size-12 items-center justify-center rounded-full bg-brand-tint">
        <Check className="size-6 text-brand" aria-hidden />
      </div>
      <h1 className="display mt-6 text-[30px] font-semibold md:text-[38px]">
        Account created
      </h1>
      <p className="mx-auto mt-4 max-w-md text-[15px] leading-relaxed text-ink-soft">
        {name ? <strong className="font-medium">{name}</strong> : "Your business"} is set
        up with business pricing.{" "}
        {highValue
          ? "Given your volume, an account manager will call within one working day to set your tier and delivery schedule."
          : "Business rates are live on your cart now. Add a GSTIN before your first invoice to claim input tax credit."}
      </p>
      <div className="mt-8 flex flex-wrap justify-center gap-3">
        <Button asChild size="lg">
          <Link href="/account">Go to your dashboard</Link>
        </Button>
        <Button asChild size="lg" variant="outline">
          <Link href="/business">Start ordering</Link>
        </Button>
      </div>
      <p className="mt-8 text-[12.5px] text-muted">
        Placeholder flow — nothing is persisted until Supabase auth is wired up.
      </p>
    </Container>
  );
}
