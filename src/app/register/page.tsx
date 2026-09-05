import type { Metadata } from "next";
import { StandaloneShell } from "@/components/standalone-shell";
import { BusinessRegistration } from "@/components/business-registration";

export const metadata: Metadata = {
  title: "Open a business account",
  description:
    "Business pricing, GST invoices, scheduled delivery and one-tap reorder. No setup fee.",
};

export default function RegisterPage() {
  return (
    <StandaloneShell>
      <BusinessRegistration />
    </StandaloneShell>
  );
}
