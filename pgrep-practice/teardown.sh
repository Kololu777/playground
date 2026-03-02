#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/tmp/pgrep-practice-pids.txt"

if [[ ! -f "$PID_FILE" ]]; then
    echo "No PID file found at $PID_FILE"
    echo "Nothing to clean up. (Did you run setup.sh first?)"
    exit 0
fi

echo "=== pgrep Practice Teardown ==="
echo ""

stopped=0
failed=0

while IFS= read -r pid; do
    [[ -z "$pid" ]] && continue
    if kill "$pid" 2>/dev/null; then
        echo "  Stopped PID $pid"
        ((stopped++))
    else
        echo "  PID $pid already stopped or not found"
        ((failed++))
    fi
done < "$PID_FILE"

rm -f "$PID_FILE"

echo ""
echo "All practice processes stopped. ($stopped killed, $failed already gone)"
echo "PID file removed."
