import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { BusinessHome } from "@/components/home-business";
import { PremiumHome } from "@/components/home-premium";
import { isMode } from "@/lib/mode";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ mode: string }>;
}): Promise<Metadata> {
  const { mode } = await params;
  return mode === "premium"
    ? {
        title: "Premium — Everyday essentials, elevated",
        description:
          "Handwash, body care, home fragrance and cleaning, formulated properly and built to be refilled.",
      }
    : {
        title: "Business — Everything your business needs",
        description:
          "Cleaning, hygiene and housekeeping supplies for restaurants, hotels, offices and clinics. Bulk pricing, GST invoices, reliable delivery.",
      };
}

export default async function StorefrontHome({
  params,
}: {
  params: Promise<{ mode: string }>;
}) {
  const { mode } = await params;
  if (!isMode(mode)) notFound();

  return mode === "business" ? <BusinessHome /> : <PremiumHome />;
}
