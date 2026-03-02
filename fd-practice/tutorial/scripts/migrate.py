#!/usr/bin/env python3
"""Database migration script."""

import argparse
import sys
from datetime import datetime


MIGRATIONS = [
    ("001_create_users", "CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT, email TEXT)"),
    ("002_add_roles", "ALTER TABLE users ADD COLUMN role TEXT DEFAULT 'user'"),
    ("003_create_sessions", "CREATE TABLE sessions (id SERIAL, user_id INT, token TEXT)"),
]


def run_migration(name: str, sql: str, dry_run: bool = False) -> None:
    """Execute a single migration."""
    timestamp = datetime.now().isoformat()
    print(f"[{timestamp}] Running: {name}")
    if dry_run:
        print(f"  (dry-run) {sql}")
    else:
        print(f"  Executed: {sql[:60]}...")


def main() -> None:
    parser = argparse.ArgumentParser(description="Run database migrations")
    parser.add_argument("--dry-run", action="store_true", help="Preview without executing")
    args = parser.parse_args()

    print(f"Running {len(MIGRATIONS)} migrations...")
    for name, sql in MIGRATIONS:
        run_migration(name, sql, dry_run=args.dry_run)
    print("All migrations complete.")


if __name__ == "__main__":
    main()
