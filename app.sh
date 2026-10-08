#!/usr/bin/env bash

mkdir -p public

echo "jenkins-ci-demo version 3 - BROKEN" > public/index.html

echo "Application startup failed intentionally"

exit 1
