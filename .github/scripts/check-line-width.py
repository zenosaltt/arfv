"""Fail when a Typst source line exceeds the project's 80-character limit."""

import sys
from pathlib import Path


def main() -> int:
    violations = []
    for filename in sys.argv[1:]:
        for number, line in enumerate(Path(filename).read_text().splitlines(), 1):
            if len(line) > 80:
                violations.append(f"{filename}:{number}: {len(line)} characters (max 80)")

    if violations:
        print("\n".join(violations), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
