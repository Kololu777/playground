/**
 * Request processing middleware
 */

import { Request, Response, NextFunction } from "express";

// HACK: Rate limiter state is stored in memory; will break with multiple instances
// TODO: Move rate limiter state to Redis for horizontal scaling

const requestCounts = new Map<string, number>();

export function rateLimiter(limit: number = 100) {
  return (req: Request, res: Response, next: NextFunction) => {
    const ip = req.ip || "unknown";
    const count = requestCounts.get(ip) || 0;

    if (count >= limit) {
      // NOTE: 429 status is not cached by CDN, safe to return directly
      res.status(429).json({ error: "Too many requests" });
      return;
    }

    requestCounts.set(ip, count + 1);
    next();
  };
}

// FIXME: Logger should use structured JSON format instead of plain text
export function requestLogger(req: Request, _res: Response, next: NextFunction) {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path} from ${req.ip}`);
  next();
}
