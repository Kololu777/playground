#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/tmp/pgrep-practice-pids.txt"

# Clean up any previous session
if [[ -f "$PID_FILE" ]]; then
    echo "Previous session detected. Cleaning up first..."
    while IFS= read -r pid; do
        kill "$pid" 2>/dev/null || true
    done < "$PID_FILE"
    rm -f "$PID_FILE"
    echo "Previous processes cleaned up."
    echo ""
fi

PIDS=()

# --- worker-alpha, worker-beta, worker-gamma ---
# exec -a renames the process so pgrep can find it by that name
bash -c 'exec -a worker-alpha sleep 300' &
PIDS+=($!)

bash -c 'exec -a worker-beta sleep 300' &
PIDS+=($!)

bash -c 'exec -a worker-gamma sleep 300' &
PIDS+=($!)

# --- python3-like process ---
bash -c 'exec -a python3 sleep 300' &
PIDS+=($!)

# --- Extra processes for variety ---
bash -c 'exec -a myapp-server sleep 300' &
PIDS+=($!)

bash -c 'exec -a myapp-worker sleep 300' &
PIDS+=($!)

# Save PIDs to file
printf '%s\n' "${PIDS[@]}" > "$PID_FILE"

echo "=== pgrep Practice Setup ==="
echo ""
echo "Started the following processes:"
echo "  worker-alpha   (PID: ${PIDS[0]})"
echo "  worker-beta    (PID: ${PIDS[1]})"
echo "  worker-gamma   (PID: ${PIDS[2]})"
echo "  python3        (PID: ${PIDS[3]})"
echo "  myapp-server   (PID: ${PIDS[4]})"
echo "  myapp-worker   (PID: ${PIDS[5]})"
echo ""
echo "PID file: $PID_FILE"
echo ""
echo "Setup complete. ${#PIDS[@]} processes started."
echo ""
echo "Run ./exercise.sh to start practicing!"
