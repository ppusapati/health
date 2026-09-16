#!/usr/bin/env python3
"""Every requirement the status docs claim must be named by a test.

The claim in wave-1-status.md is not "implemented" but "has a working, tested
implementation", and the difference is the whole point of the document. This
checks the weaker half mechanically: that each requirement id appears in at
least one test file.

It cannot check that the test asserts the right thing — nothing can, short of
reading it — but it does catch the case the Wave-1 audit found twice, where a
requirement was implemented, marked Implemented, and had nothing exercising it
at all.
"""
import pathlib
import subprocess
import sys

root = pathlib.Path(__file__).resolve().parents[2]
# POSIX ERE, not Python's: grep -E has no non-capturing group, and (?: there is
# matched literally, which silently finds nothing.
PATTERN = r"SRS-(EMPI|SCH|ENC|CLN|NUR|ORD|MED|BIL)-[0-9]{3}"


def ids(args: list[str]) -> set[str]:
    out = subprocess.run(
        ["grep", "-rhoE", PATTERN, *args],
        cwd=root, capture_output=True, text=True,
    )
    return set(out.stdout.split())


claimed = ids(["docs/engineering/wave-1-status.md"])
tested = ids([
    "--include=*_test.go", "--include=*_test.dart", "--include=*.test.ts", ".",
])

missing = sorted(claimed - tested)
for requirement in missing:
    print(f"UNTESTED  {requirement}: claimed in wave-1-status.md, named by no test")

print(f"\n{len(claimed)} requirements claimed, {len(missing)} with no test naming them")
sys.exit(1 if missing else 0)
