import { describe, it, expect, beforeAll, afterAll } from "vitest";

const BASE_URL = "http://localhost:3000";

describe("API Integration", () => {
  beforeAll(async () => {
    console.log("Starting test server...");
  });

  afterAll(async () => {
    console.log("Stopping test server...");
  });

  it("GET /health returns ok", async () => {
    const res = await fetch(`${BASE_URL}/health`);
    const body = await res.json();
    expect(res.status).toBe(200);
    expect(body.status).toBe("ok");
  });

  it("GET /api/users returns user list", async () => {
    const res = await fetch(`${BASE_URL}/api/users`);
    const users = await res.json();
    expect(res.status).toBe(200);
    expect(users.length).toBeGreaterThan(0);
    expect(users[0]).toHaveProperty("name");
  });
});
