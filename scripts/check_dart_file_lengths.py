#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
LIMIT = 120
IGNORE_FILE = ROOT / ".dart_linecap_ignore"


def load_ignored_paths() -> set[str]:
    if not IGNORE_FILE.exists():
        return set()
    return {
        line.strip()
        for line in IGNORE_FILE.read_text().splitlines()
        if line.strip() and not line.strip().startswith("#")
    }


def main() -> int:
    ignored = load_ignored_paths()
    violations: list[tuple[int, str]] = []
    for path in sorted(LIB.rglob("*.dart")):
        rel_path = path.relative_to(ROOT).as_posix()
        if path.name.endswith(".g.dart") or rel_path in ignored:
            continue
        lines = path.read_text().count("\n") + 1
        if lines > LIMIT:
            violations.append((lines, rel_path))

    if not violations:
        print(f"All handwritten Dart files are within {LIMIT} lines.")
        return 0

    print(f"Found {len(violations)} handwritten Dart files over {LIMIT} lines:")
    for lines, rel_path in sorted(violations, reverse=True):
        print(f"  {lines:4} {rel_path}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
