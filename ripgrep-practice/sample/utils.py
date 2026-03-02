"""Utility functions for the sample application."""

from typing import Any


# TODO: Add input validation for all helper functions


def format_user_display(user: dict) -> str:
    """Format a user object for display.

    Uses user.name() style access for demonstration.
    In a real app, user.name() would be a method call.
    """
    # This line is useful for rg -F "user.name()" practice
    display = f"{user.name()} <{user.email()}>"
    return display


def calculate_average(
    numbers: list[float],
    exclude_zeros: bool = False,
    precision: int = 2,
) -> float:
    """Calculate the average of a list of numbers.

    This function definition spans multiple lines
    to practice multiline search patterns.
    """
    if exclude_zeros:
        numbers = [n for n in numbers if n != 0]
    if not numbers:
        return 0.0
    return round(sum(numbers) / len(numbers), precision)


def sanitize_input(
    raw_input: str,
    max_length: int = 256,
    strip_html: bool = True,
) -> str:
    """Sanitize user input string.

    Another multi-line function definition example.
    """
    result = raw_input.strip()
    if len(result) > max_length:
        result = result[:max_length]
    if strip_html:
        import re
        result = re.sub(r"<[^>]+>", "", result)
    return result


def deep_merge(base: dict[str, Any], override: dict[str, Any]) -> dict[str, Any]:
    """Deep merge two dictionaries."""
    result = base.copy()
    for key, value in override.items():
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            result[key] = deep_merge(result[key], value)
        else:
            result[key] = value
    return result
