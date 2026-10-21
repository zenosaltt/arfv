#!/bin/sh
# Share one Typst watcher across repositories on the current Docker daemon.
set -eu
name=typst-watch
mode=$1
shift

case "$mode" in
  watch)
    # Listing containers distinguishes an absent watcher from a Docker failure.
    existing=$(docker container ls --all --filter "name=^/${name}$" --format '{{.ID}}')
    if [ -n "$existing" ]; then
      printf '%s\n' "Container '$name' already exists. Run make clean in either notes repository before starting another watcher." >&2
      exit 1
    fi
    printf '%s\n' 'Watching Typst sources (Ctrl+C stops and removes the container)'
    # The init process forwards signals; Typst does not run as PID 1.
    exec docker run --rm --init --name "$name" "$@"
    ;;
  clean)
    if ! existing=$(docker container ls --all --filter "name=^/${name}$" --format '{{.ID}}'); then
      printf '%s\n' "Warning: cannot check '$name'; Docker is unavailable. Cleaning PDFs only." >&2
      exit 0
    fi
    if [ -n "$existing" ]; then
      printf '%s\n' "Stopping and removing container '$name'"
      docker container stop --timeout 5 "$existing" >/dev/null
      # --rm normally removes it on stop; also handle a leftover stopped container.
      remaining=$(docker container ls --all --filter "id=$existing" --format '{{.ID}}')
      if [ -n "$remaining" ]; then
        docker container rm "$remaining" >/dev/null
      fi
    fi
    ;;
  *)
    printf 'Usage: %s watch|clean [docker run arguments...]\n' "$0" >&2
    exit 2
    ;;
esac
