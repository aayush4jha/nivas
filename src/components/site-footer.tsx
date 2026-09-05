import Link from "next/link";
import { CATEGORIES } from "@/data/categories";
import type { Mode } from "@/lib/types";
import { Container } from "./ui/container";

export function SiteFooter({ mode }: { mode: Mode }) {
  const categories = CATEGORIES.filter((c) => c.modes.includes(mode));

  return (
    <footer className="mt-24 border-t border-line bg-surface">
      <Container className="py-14">
        <div className="grid gap-10 md:grid-cols-[1.4fr_1fr_1fr_1fr]">
          <div>
            <p className="text-[19px] font-semibold tracking-[-0.02em]">NIVAS</p>
            <p className="mt-3 max-w-xs text-sm leading-relaxed text-ink-soft">
              Cleaning, hygiene and everyday essentials, sourced for businesses
              and homes. One supply chain, two storefronts.
            </p>
          </div>

          <FooterColumn title="Shop">
            {categories.slice(0, 5).map((c) => (
              <FooterLink key={c.slug} href={`/${mode}/c/${c.slug}`}>
                {c.name}
              </FooterLink>
            ))}
          </FooterColumn>

          <FooterColumn title="Business">
            <FooterLink href="/register">Open an account</FooterLink>
            <FooterLink href="/bulk-quote">Request a bulk quote</FooterLink>
            <FooterLink href="/account">Reorder</FooterLink>
            <FooterLink href="/business">Business store</FooterLink>
          </FooterColumn>

          <FooterColumn title="Company">
            <FooterLink href="/premium">Premium store</FooterLink>
            <FooterLink href="/">About</FooterLink>
            <FooterLink href="/">Delivery</FooterLink>
            <FooterLink href="/">Contact</FooterLink>
          </FooterColumn>
        </div>

        <div className="mt-12 flex flex-col gap-2 border-t border-line pt-6 text-[12px] text-muted sm:flex-row sm:items-center sm:justify-between">
          <p>© {new Date().getFullYear()} Nivas Supply Co. All prices include GST where shown.</p>
          <p>Placeholder catalogue — pricing and stock are seed data.</p>
        </div>
      </Container>
    </footer>
  );
}

function FooterColumn({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <p className="eyebrow">{title}</p>
      <ul className="mt-4 space-y-2.5">{children}</ul>
    </div>
  );
}

function FooterLink({ href, children }: { href: string; children: React.ReactNode }) {
  return (
    <li>
      <Link href={href} className="text-sm text-ink-soft hover:text-ink">
        {children}
      </Link>
    </li>
  );
}
