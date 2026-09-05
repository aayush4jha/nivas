import { Container } from "./ui/container";
import { cn } from "@/lib/format";

/** Section heading with an eyebrow. Used on both storefronts for rhythm. */
export function SectionHead({
  eyebrow,
  title,
  lede,
  action,
  serif,
}: {
  eyebrow?: string;
  title: string;
  lede?: string;
  action?: React.ReactNode;
  serif?: boolean;
}) {
  return (
    <div className="mb-8 flex flex-wrap items-end justify-between gap-4">
      <div className="max-w-2xl">
        {eyebrow && <p className="eyebrow mb-2.5">{eyebrow}</p>}
        <h2
          className={cn(
            serif
              ? "serif-display text-[34px] md:text-[42px]"
              : "display text-[26px] font-semibold md:text-[32px]",
          )}
        >
          {title}
        </h2>
        {lede && (
          <p className="mt-3 text-[15px] leading-relaxed text-ink-soft">{lede}</p>
        )}
      </div>
      {action}
    </div>
  );
}

export function Section({
  className,
  children,
}: {
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <section className={cn("py-14 md:py-20", className)}>
      <Container>{children}</Container>
    </section>
  );
}
