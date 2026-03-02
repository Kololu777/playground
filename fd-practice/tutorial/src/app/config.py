"""Application configuration management."""

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


@dataclass
class AppConfig:
    host: str = "localhost"
    port: int = 3000
    debug: bool = False
    env: str = "development"
    log_level: str = "INFO"
    allowed_origins: list[str] = field(default_factory=lambda: ["http://localhost:3000"])


def load_config(path: Path | None = None) -> dict[str, Any]:
    """Load configuration from file and environment variables."""
    config = AppConfig(
        host=os.getenv("APP_HOST", "localhost"),
        port=int(os.getenv("APP_PORT", "3000")),
        debug=os.getenv("APP_DEBUG", "false").lower() == "true",
        env=os.getenv("APP_ENV", "development"),
    )
    return {
        "host": config.host,
        "port": config.port,
        "debug": config.debug,
        "env": config.env,
        "log_level": config.log_level,
    }
