import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/format";

const badge = cva(
  "inline-flex items-center gap-1 rounded-[3px] px-1.5 py-0.5 text-[11px] font-semibold leading-none",
  {
    variants: {
      tone: {
        brand: "bg-brand-tint text-brand",
        neutral: "bg-sunk text-ink-soft",
        warn: "bg-warn-tint text-warn",
        outline: "border border-line-strong text-muted",
      },
    },
    defaultVariants: { tone: "neutral" },
  },
);

export function Badge({
  className,
  tone,
  ...props
}: React.HTMLAttributes<HTMLSpanElement> & VariantProps<typeof badge>) {
  return <span className={cn(badge({ tone }), className)} {...props} />;
}
