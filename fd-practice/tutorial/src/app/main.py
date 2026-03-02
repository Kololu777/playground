"""Main application module."""

import os
import sys
from pathlib import Path

from config import load_config


def setup_logging(level: str = "INFO") -> None:
    """Configure application logging."""
    import logging
    logging.basicConfig(
        level=getattr(logging, level),
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )


def main() -> None:
    """Application entry point."""
    config = load_config(Path("config.yaml"))
    setup_logging(config.get("log_level", "INFO"))

    print(f"Starting application (PID: {os.getpid()})")
    print(f"Python {sys.version_info.major}.{sys.version_info.minor}")
    print(f"Working directory: {Path.cwd()}")


if __name__ == "__main__":
    main()
