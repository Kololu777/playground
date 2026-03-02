/**
 * Application entry point
 */

import { createApp } from "./main";
import { loadConfig } from "./config";

const config = loadConfig();

const app = createApp({
  port: config.port,
  host: config.host,
  debug: config.debug,
});

app.listen(() => {
  console.log(`Server started on ${config.host}:${config.port}`);
  console.log(`Environment: ${config.env}`);
});

export default app;
