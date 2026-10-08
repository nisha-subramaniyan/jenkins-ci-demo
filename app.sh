#!/usr/bin/env bash

mkdir -p public
echo "jenkins-ci-demo version 1" > public/index.html

echo "Application listening on port 8080"
busybox-extras httpd -f -p 0.0.0.0:8080 -h public
