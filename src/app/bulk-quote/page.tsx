import type { Metadata } from "next";
import { StandaloneShell } from "@/components/standalone-shell";
import { BulkQuoteForm } from "@/components/bulk-quote-form";

export const metadata: Metadata = {
  title: "Request a bulk quote",
  description:
    "Ordering 100+ units? Upload your list or enter it below and we price it against live supplier rates.",
};

export default function BulkQuotePage() {
  return (
    <StandaloneShell>
      <BulkQuoteForm />
    </StandaloneShell>
  );
}
