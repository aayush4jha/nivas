import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

/** Formatting helpers. Every rupee value entering the UI passes through here. */

const inr = new Intl.NumberFormat("en-IN", {
  style: "currency",
  currency: "INR",
  maximumFractionDigits: 0,
});

const inrPaise = new Intl.NumberFormat("en-IN", {
  style: "currency",
  currency: "INR",
  minimumFractionDigits: 2,
});

/** 34950 -> "₹350". Rounds; use `rupeesExact` when the paise matter. */
export function rupees(paise: number): string {
  return inr.format(paise / 100);
}

/** 34950 -> "₹349.50". For invoices and cart lines. */
export function rupeesExact(paise: number): string {
  return inrPaise.format(paise / 100);
}

/**
 * Class merge. Uses tailwind-merge so a caller-supplied `px-6` reliably beats a
 * component's default `px-4` instead of both landing in the class list.
 */
export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
