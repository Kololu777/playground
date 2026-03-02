/**
 * Legacy formatting utilities
 * @deprecated Use string.ts instead
 */

function formatDate(date) {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function formatCurrency(amount, currency) {
  currency = currency || "USD";
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: currency,
  }).format(amount);
}

module.exports = { formatDate, formatCurrency };
