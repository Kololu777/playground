/**
 * Main application factory
 */

import { Router } from "express";

interface AppOptions {
  port: number;
  host: string;
  debug: boolean;
}

export function createApp(options: AppOptions) {
  const router = Router();

  router.get("/health", (_req, res) => {
    res.json({ status: "ok", uptime: process.uptime() });
  });

  router.get("/api/users", (_req, res) => {
    res.json([
      { id: 1, name: "Alice", role: "admin" },
      { id: 2, name: "Bob", role: "user" },
    ]);
  });

  return {
    router,
    listen: (callback: () => void) => {
      console.log(`Binding to ${options.host}:${options.port}`);
      callback();
    },
  };
}
