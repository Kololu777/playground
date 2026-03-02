import React from "react";

interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: "primary" | "secondary" | "danger";
  disabled?: boolean;
}

export function Button({
  label,
  onClick,
  variant = "primary",
  disabled = false,
}: ButtonProps) {
  const className = `btn btn-${variant}`;

  return (
    <button className={className} onClick={onClick} disabled={disabled}>
      {label}
    </button>
  );
}
