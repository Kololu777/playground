import { describe, it, expect } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { App } from "../../src/components/App";

describe("App", () => {
  it("renders with default title", () => {
    render(<App />);
    expect(screen.getByText("fd Practice")).toBeDefined();
  });

  it("renders with custom title", () => {
    render(<App title="Custom Title" />);
    expect(screen.getByText("Custom Title")).toBeDefined();
  });

  it("increments counter on button click", () => {
    render(<App />);
    const incrementBtn = screen.getByText("Increment");
    fireEvent.click(incrementBtn);
    expect(screen.getByText("Count: 1")).toBeDefined();
  });

  it("resets counter", () => {
    render(<App />);
    const incrementBtn = screen.getByText("Increment");
    fireEvent.click(incrementBtn);
    fireEvent.click(incrementBtn);
    const resetBtn = screen.getByText("Reset");
    fireEvent.click(resetBtn);
    expect(screen.getByText("Count: 0")).toBeDefined();
  });
});
