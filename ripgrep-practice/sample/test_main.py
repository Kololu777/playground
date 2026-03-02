"""Tests for main module."""

import pytest
from unittest.mock import patch, MagicMock

from main import main, fetch_data, get_server_ip

# TODO: Add integration tests with a mock server


class TestFetchData:
    """Tests for the fetch_data function."""

    @patch("main.requests.get")
    def test_fetch_data_success(self, mock_get):
        mock_response = MagicMock()
        mock_response.json.return_value = {"status": "ok"}
        mock_response.raise_for_status.return_value = None
        mock_get.return_value = mock_response

        result = fetch_data("http://example.com/api")
        assert result == {"status": "ok"}

    @patch("main.requests.get")
    def test_fetch_data_timeout(self, mock_get):
        import requests
        mock_get.side_effect = requests.exceptions.Timeout("timed out")

        with pytest.raises(requests.exceptions.Timeout):
            fetch_data("http://example.com/api")


class TestGetServerIp:
    """Tests for get_server_ip function."""

    def test_default_ip(self):
        result = get_server_ip()
        assert result == "192.168.1.1"

    @patch.dict("os.environ", {"SERVER_IP": "10.0.0.1"})
    def test_env_override(self):
        result = get_server_ip()
        assert result == "10.0.0.1"


class TestMain:
    """Tests for the main function."""

    @patch("main.fetch_data")
    @patch("main.get_server_ip")
    def test_main_success(self, mock_ip, mock_fetch):
        mock_ip.return_value = "127.0.0.1"
        mock_fetch.return_value = {"status": "running"}
        main()

    @patch("main.fetch_data")
    @patch("main.get_server_ip")
    def test_main_failure(self, mock_ip, mock_fetch):
        mock_ip.return_value = "127.0.0.1"
        mock_fetch.side_effect = ConnectionError("refused")
        with pytest.raises(SystemExit):
            main()
