#!/usr/bin/env bash

set -e

echo "Running tests..."

echo "1. Checking app.sh exists..."
if [ -f app.sh ]; then
    echo "PASS: app.sh exists"
else
    echo "FAIL: app.sh missing"
    exit 1
fi

echo "2. Checking application version..."
if grep -q "jenkins-ci-demo version" app.sh; then
    echo "PASS: version found"
else
    echo "FAIL: version not found"
    exit 1
fi

echo "3. Checking application port..."
if grep -q "8080" app.sh; then
    echo "PASS: port 8080 found"
else
    echo "FAIL: port 8080 not found"
    exit 1
fi

echo "All tests passed!"
