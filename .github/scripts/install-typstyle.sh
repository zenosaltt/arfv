#!/usr/bin/env bash
set -euo pipefail

version=v0.15.1
asset=typstyle-x86_64-unknown-linux-gnu
sha256=213c11bc2c64f7237c382b4bb1d06991530ed9d44d3a05204ca3c19615d55b99
destination="${RUNNER_TEMP:?RUNNER_TEMP must be set}/typstyle"

curl --fail --location --silent --show-error \
  "https://github.com/typstyle-rs/typstyle/releases/download/$version/$asset" \
  --output "$destination"
printf '%s  %s\n' "$sha256" "$destination" | sha256sum --check -
chmod +x "$destination"
printf '%s\n' "$RUNNER_TEMP" >> "${GITHUB_PATH:?GITHUB_PATH must be set}"
