import type { Metadata } from "next";
import { StandaloneShell } from "@/components/standalone-shell";
import { AccountDashboard } from "@/components/account-dashboard";

export const metadata: Metadata = { title: "Your account" };

export default function AccountPage() {
  return (
    <StandaloneShell>
      <AccountDashboard />
    </StandaloneShell>
  );
}
