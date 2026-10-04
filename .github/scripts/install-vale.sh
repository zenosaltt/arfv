#!/usr/bin/env bash
set -euo pipefail

version=3.23.0
archive="vale_${version}_Linux_64-bit.tar.gz"
destination="${RUNNER_TEMP:?RUNNER_TEMP must be set}/vale"
mkdir -p "$destination"
curl --fail --location --silent --show-error \
  "https://github.com/vale-cli/vale/releases/download/v${version}/${archive}" \
  | tar -xz -C "$destination" vale
echo "$destination" >> "${GITHUB_PATH:?GITHUB_PATH must be set}"
