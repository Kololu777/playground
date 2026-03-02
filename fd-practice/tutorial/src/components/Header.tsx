import React from "react";

interface HeaderProps {
  title: string;
  subtitle?: string;
}

export function Header({ title, subtitle }: HeaderProps) {
  return (
    <header className="header">
      <h1>{title}</h1>
      {subtitle && <p className="subtitle">{subtitle}</p>}
      <nav>
        <a href="/">Home</a>
        <a href="/about">About</a>
        <a href="/docs">Docs</a>
      </nav>
    </header>
  );
}
