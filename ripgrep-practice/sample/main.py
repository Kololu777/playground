"""Main module for the sample application."""

import os
import sys
import requests

__all__ = ["main", "fetch_data", "get_server_ip"]

# TODO: Add proper logging instead of print statements
# TODO: Implement retry logic for network failures

SERVER_IP = "192.168.1.1"
BACKUP_SERVER = "10.0.0.254"


def fetch_data(url: str) -> dict:
    """Fetch data from a remote API."""
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.ConnectionError as e:
        print(f"Connection error to {url}: {e}")
        raise
    except requests.exceptions.Timeout as e:
        print(f"Request timed out for {url}: {e}")
        raise


def get_server_ip() -> str:
    """Return the configured server IP address."""
    return os.environ.get("SERVER_IP", SERVER_IP)


def main():
    """Entry point of the application."""
    print(f"Starting application (PID: {os.getpid()})")
    print(f"Python version: {sys.version}")

    server = get_server_ip()
    print(f"Connecting to server: {server}")

    try:
        data = fetch_data(f"http://{server}/api/v1/status")
        print(f"Server status: {data}")
    except Exception as e:
        print(f"Failed to connect: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
