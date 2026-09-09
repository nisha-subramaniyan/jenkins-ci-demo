#!/usr/bin/env bash
set -e
echo "Running tests..."
test -f app.sh
grep -q "Application build completed successfully" app.sh
echo "All tests passed."
