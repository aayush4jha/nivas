import { cn } from "@/lib/format";

export function Field({
  label,
  hint,
  required,
  children,
  className,
}: {
  label: string;
  hint?: string;
  required?: boolean;
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <label className={cn("block", className)}>
      <span className="block text-[13px] font-medium">
        {label}
        {!required && <span className="ml-1.5 font-normal text-muted">optional</span>}
      </span>
      {hint && <span className="mt-0.5 block text-[12px] text-muted">{hint}</span>}
      <span className="mt-1.5 block">{children}</span>
    </label>
  );
}

const inputStyles =
  "h-10 w-full rounded-[var(--radius)] border border-line bg-surface px-3 text-[14px] text-ink outline-none transition-colors placeholder:text-muted focus:border-ink";

export function Input({ className, ...props }: React.InputHTMLAttributes<HTMLInputElement>) {
  return <input className={cn(inputStyles, className)} {...props} />;
}

export function Textarea({
  className,
  ...props
}: React.TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return (
    <textarea className={cn(inputStyles, "h-auto min-h-24 py-2.5", className)} {...props} />
  );
}
