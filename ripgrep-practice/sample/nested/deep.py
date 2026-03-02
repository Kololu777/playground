"""Deeply nested module for testing recursive search."""

import json
import pathlib

# TODO: Add caching for file reads


def load_config(config_path: str) -> dict:
    """Load configuration from a JSON file."""
    path = pathlib.Path(config_path)
    if not path.exists():
        raise FileNotFoundError(f"Config not found: {config_path}")
    with open(path) as f:
        return json.load(f)


def list_files(directory: str, pattern: str = "*.py") -> list[str]:
    """List files matching a pattern in a directory."""
    path = pathlib.Path(directory)
    return [str(p) for p in path.glob(pattern)]


def read_csv_data(filepath: str) -> list[dict]:
    """Read CSV data and return as list of dicts."""
    import csv
    with open(filepath) as f:
        reader = csv.DictReader(f)
        return list(reader)
