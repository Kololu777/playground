import { describe, it, expect } from "vitest";
import { add, subtract, multiply, clamp, average } from "../../src/utils/math";

describe("add", () => {
  it("adds two positive numbers", () => {
    expect(add(2, 3)).toBe(5);
  });

  it("handles negative numbers", () => {
    expect(add(-1, 1)).toBe(0);
  });
});

describe("clamp", () => {
  it("returns value when within range", () => {
    expect(clamp(5, 0, 10)).toBe(5);
  });

  it("clamps to min", () => {
    expect(clamp(-5, 0, 10)).toBe(0);
  });

  it("clamps to max", () => {
    expect(clamp(15, 0, 10)).toBe(10);
  });
});

describe("average", () => {
  it("calculates average", () => {
    expect(average([1, 2, 3, 4, 5])).toBe(3);
  });

  it("returns 0 for empty array", () => {
    expect(average([])).toBe(0);
  });
});
