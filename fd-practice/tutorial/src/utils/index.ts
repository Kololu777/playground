/**
 * Utility module exports
 */

export { add, subtract, multiply, clamp } from "./math";
export { capitalize, truncate, slugify } from "./string";

export function isNonNull<T>(value: T | null | undefined): value is T {
  return value !== null && value !== undefined;
}

export function groupBy<T>(items: T[], key: keyof T): Record<string, T[]> {
  return items.reduce(
    (acc, item) => {
      const group = String(item[key]);
      acc[group] = acc[group] || [];
      acc[group].push(item);
      return acc;
    },
    {} as Record<string, T[]>,
  );
}
