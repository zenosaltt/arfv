"""Run a build and turn Typst's short diagnostics into GitHub annotations."""

import os
import re
import subprocess
import sys
from pathlib import Path


DIAGNOSTIC = re.compile(
    r"^(?P<file>.+):(?P<line>\d+):(?P<column>\d+): "
    r"(?P<kind>error|warning): (?P<message>.*)$"
)
ROOT = Path.cwd().resolve()


def escape_property(value):
    return value.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A").replace(":", "%3A").replace(",", "%2C")


def escape_message(value):
    return value.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def annotate(line):
    match = DIAGNOSTIC.match(line)
    if match is None:
        return

    path = (ROOT / match["file"]).resolve()
    try:
        file = path.relative_to(ROOT).as_posix()
    except ValueError:
        return

    print(
        f"::{match['kind']} file={escape_property(file)},"
        f"line={match['line']},col={match['column']},title=Typst::"
        f"{escape_message(match['message'])}",
        flush=True,
    )


def main():
    if len(sys.argv) < 2:
        raise SystemExit("usage: build-with-diagnostics.py COMMAND [ARG ...]")

    environment = os.environ.copy()
    environment["TYPST_DIAGNOSTIC_FORMAT"] = "short"
    with subprocess.Popen(
        sys.argv[1:],
        env=environment,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    ) as process:
        for line in process.stdout:
            print(line, end="", flush=True)
            annotate(line.rstrip("\n"))
        return process.wait()


if __name__ == "__main__":
    raise SystemExit(main())
