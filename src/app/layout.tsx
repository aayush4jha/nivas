import type { Metadata } from "next";
import { Inter, Instrument_Serif } from "next/font/google";
import { CartProvider } from "@/lib/cart";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

// Used only for Premium display headings. One serif, used sparingly, is what
// separates the two storefronts without needing a second design system.
const display = Instrument_Serif({
  subsets: ["latin"],
  weight: "400",
  variable: "--font-display",
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "Nivas — Supply, handled",
    template: "%s · Nivas",
  },
  description:
    "Cleaning, hygiene, housekeeping and everyday essentials — sourced for businesses and homes. Bulk pricing, GST invoices and reliable delivery.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${inter.variable} ${display.variable}`}>
      <body>
        <CartProvider>{children}</CartProvider>
      </body>
    </html>
  );
}
