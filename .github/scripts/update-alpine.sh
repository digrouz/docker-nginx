#!/usr/bin/env bash

ALPINELINUX_URL="https://github.com/alpinelinux/aports.git"

LAST_VERSION=$(git ls-remote --tags ${ALPINELINUX_URL} | sed -e 's|.*refs/tags/v||' | grep -v '{}' | egrep "(^[0-9]+\.[0-9]+\.[0-9]+$)" | sort -V | tail -1)

if [ "${LAST_VERSION}" ];then
  sed -i -e "s|FROM alpine:.*|FROM alpine:${LAST_VERSION}|" Dockerfile*
fi

if output=$(git status --porcelain) && [ -z "$output" ]; then
  # Working directory clean
  echo "No new version available!"
else
  # Uncommitted changes
  git commit -a -m "rebased to Alpine Linux  version: ${LAST_VERSION}"
  git push
fi
