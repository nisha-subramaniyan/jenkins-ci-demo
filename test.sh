#!/usr/bin/env bash
set -e

echo "Running tests..."

test -f app.sh
grep -q "jenkins-ci-demo version" app.sh
grep -q "8080" app.sh

echo "All tests passed."
