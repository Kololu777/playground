import { describe, it, expect } from "vitest";

const BASE_URL = "http://localhost:3000";

describe("Login Flow", () => {
  it("rejects login without credentials", async () => {
    const res = await fetch(`${BASE_URL}/api/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({}),
    });
    expect(res.status).toBe(400);
  });

  it("accepts valid credentials", async () => {
    const res = await fetch(`${BASE_URL}/api/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: "admin@example.com",
        password: "password123",
      }),
    });
    const body = await res.json();
    expect(res.status).toBe(200);
    expect(body).toHaveProperty("token");
  });
});
