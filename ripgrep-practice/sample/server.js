/**
 * Express-style server - JavaScript example
 */

const express = require("express");
const cors = require("cors");

// TODO: Add rate limiting middleware

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

/* BEGIN: Authentication middleware */
const authenticate = (req, res, next) => {
  const token = req.headers["authorization"];
  if (!token) {
    console.log("Authentication failed: no token provided");
    return res.status(401).json({ error: "Unauthorized" });
  }
  console.log("Authentication successful");
  next();
};
/* END: Authentication middleware */

/* BEGIN: Route handlers */
app.get("/api/health", (req, res) => {
  console.log("Health check requested");
  res.json({ status: "ok", uptime: process.uptime() });
});

app.get("/api/users", authenticate, (req, res) => {
  console.log("Fetching user list");
  const users = [
    { id: 1, name: "Alice", email: "alice@example.com" },
    { id: 2, name: "Bob", email: "bob@example.com" },
    { id: 3, name: "Charlie", email: "charlie@example.com" },
  ];
  res.json(users);
});

app.post("/api/users", authenticate, (req, res) => {
  const { name, email } = req.body;
  console.log(`Creating user: ${name}`);
  if (!name || !email) {
    return res.status(400).json({ error: "Name and email are required" });
  }
  res.status(201).json({ id: Date.now(), name, email });
});
/* END: Route handlers */

app.use((err, req, res, _next) => {
  console.log(`Error occurred: ${err.message}`);
  res.status(500).json({ error: "Internal server error" });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
});
