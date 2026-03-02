/**
 * Global error handler middleware
 */

import { Request, Response, NextFunction } from "express";

// FIXME: Error responses should include a request ID for tracing
// HACK: Using any type because Express error types are inconsistent
// NOTE: This handler must be registered last in the middleware chain

interface AppError extends Error {
  statusCode?: number;
  code?: string;
}

export function errorHandler(
  err: AppError,
  req: Request,
  res: Response,
  _next: NextFunction,
): void {
  const statusCode = err.statusCode || 500;
  const message = statusCode === 500 ? "Internal Server Error" : err.message;

  // FIXME: Sensitive error details are leaking to client in development mode
  console.error(`[ERROR] ${req.method} ${req.path}: ${err.message}`);
  console.error(err.stack);

  // HACK: Workaround for double-response bug in streaming endpoints
  if (res.headersSent) {
    return;
  }

  res.status(statusCode).json({
    error: message,
    code: err.code || "UNKNOWN_ERROR",
    // TODO: Add request_id field once tracing is implemented
  });
}
