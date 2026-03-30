#!/usr/bin/env bash
# Double-click this file in Finder to run the app locally on macOS.
# Opens a browser tab and starts a local HTTP server — Ctrl+C to stop.

cd "$(dirname "$0")"

PORT=8765

# Check if port is already taken
if lsof -iTCP:$PORT -sTCP:LISTEN &>/dev/null; then
  echo "Port $PORT is already in use — opening existing server."
  open "http://localhost:$PORT"
  exit 0
fi

echo "Starting server at http://localhost:$PORT"
python3 -m http.server $PORT &
SERVER_PID=$!

# Wait briefly, then open browser
sleep 0.4
open "http://localhost:$PORT"

echo "Press Ctrl+C to stop."
trap "kill $SERVER_PID 2>/dev/null; echo 'Server stopped.'; exit" INT TERM
wait $SERVER_PID
