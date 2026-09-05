import { cn } from "@/lib/format";

/** Single source of truth for page gutters and max width. */
export function Container({
  className,
  children,
}: {
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <div className={cn("mx-auto w-full max-w-[1240px] px-5 md:px-8", className)}>
      {children}
    </div>
  );
}
