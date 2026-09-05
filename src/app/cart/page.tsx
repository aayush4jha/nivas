import type { Metadata } from "next";
import { StandaloneShell } from "@/components/standalone-shell";
import { CartView } from "@/components/cart-view";

export const metadata: Metadata = { title: "Cart" };

export default function CartPage() {
  return (
    <StandaloneShell>
      <CartView />
    </StandaloneShell>
  );
}
