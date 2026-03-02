import { describe, it, expect } from "vitest";
import { capitalize, truncate, slugify, countWords } from "../../src/utils/string";

describe("capitalize", () => {
  it("capitalizes first letter", () => {
    expect(capitalize("hello")).toBe("Hello");
  });

  it("handles empty string", () => {
    expect(capitalize("")).toBe("");
  });
});

describe("truncate", () => {
  it("truncates long strings", () => {
    expect(truncate("hello world foo bar", 10)).toBe("hello w...");
  });

  it("keeps short strings unchanged", () => {
    expect(truncate("hi", 10)).toBe("hi");
  });
});

describe("slugify", () => {
  it("converts to slug", () => {
    expect(slugify("Hello World")).toBe("hello-world");
  });

  it("removes special characters", () => {
    expect(slugify("Hello, World!")).toBe("hello-world");
  });
});
