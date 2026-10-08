#!/usr/bin/env bash

mkdir -p public

echo "jenkins-ci-demo version 4" > public/index.html

echo "Starting application on port 8080..."

python3 -m http.server 8080 --directory public
