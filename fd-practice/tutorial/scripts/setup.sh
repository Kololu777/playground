#!/bin/bash
set -euo pipefail

echo "Setting up development environment..."

if ! command -v node &> /dev/null; then
  echo "Error: Node.js is not installed"
  exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

echo "Installing dependencies..."
npm install

echo "Creating .env file..."
if [ ! -f .env ]; then
  cp .env.example .env 2>/dev/null || echo "DB_HOST=localhost" > .env
  echo "Created .env from template"
else
  echo ".env already exists, skipping"
fi

echo "Setup complete! Run 'npm run dev' to start."
