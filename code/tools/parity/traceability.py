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
import re
import subprocess
import sys

root = pathlib.Path(__file__).resolve().parents[2]
# POSIX ERE, not Python's: grep -E has no non-capturing group, and (?: there is
# matched literally, which silently finds nothing.
PATTERN = (
    r"SRS-("
    # Wave 1.
    r"EMPI|SCH|ENC|CLN|NUR|ORD|MED|BIL"
    # Wave 2: the twelve clinical and operational families, the support
    # services, and the cross-cutting Phase-2 sets.
    r"|ER|ICU|OT|ANE|BLD|CSSD|MAT|BME|QMS|IPC|MRD"
    r"|AMB|DIET|FAC|HKP|LND|MORT"
    r"|OPSAPI|OPSNFR|OPSSEC|OPSWEB"
    r")-[0-9]{3}"
)

# Each status document and what it claims. A gate that reads the finished wave
# and not the one being written is a gate pointed at the past.
STATUS_DOCS = [
    "docs/engineering/wave-1-status.md",
    "docs/engineering/wave-2-status.md",
]


def matching(pattern: str, args: list[str]) -> set[str]:
    out = subprocess.run(
        ["grep", "-rhoE", pattern, *args],
        cwd=root, capture_output=True, text=True,
    )
    return set(out.stdout.split())


def ids(args: list[str]) -> set[str]:
    return matching(PATTERN, args)


# A row that says the work is not built is not a claim about it.
#
# Without this the gate cannot tell "implemented, and here is the test" from
# "eighteen requirements, four of which nobody has started", and a status
# document is forced to leave the unbuilt ones unnamed — which is exactly the
# information a reader greps for. Marking a row absent is not a way round the
# gate: it puts "not built" in the document, which is the honest outcome the
# gate is trying to produce.
# The row's verdict, not any sentence in it. Matched in bold because that is
# how every state cell in these documents opens, and because "the summary
# itself is not built" inside a **Partial** row is prose about a different
# thing — a substring match on it would silently stop checking a requirement
# that is claimed.
ABSENT_VERDICT = re.compile(
    r"\*\*\s*(?:not started|not built|not implemented|deferred)",
    re.IGNORECASE)


def split_claims(docs: list[str]) -> tuple[set[str], set[str]]:
    """Return (claimed, declared absent), per line of each status document."""
    pattern = re.compile(PATTERN.replace("(", "(?:"))
    claimed_ids: set[str] = set()
    absent_ids: set[str] = set()

    for doc in docs:
        path = root / doc
        if not path.exists():
            continue
        for line in path.read_text().splitlines():
            found = set(pattern.findall(line))
            if not found:
                continue
            if ABSENT_VERDICT.search(line):
                absent_ids |= found
            else:
                claimed_ids |= found

    # A requirement claimed on one line and disclaimed on another is claimed:
    # the stronger statement is the one somebody will act on.
    return claimed_ids, absent_ids - claimed_ids


claimed, absent = split_claims(STATUS_DOCS)
tested = ids([
    "--include=*_test.go", "--include=*_test.dart", "--include=*.test.ts", ".",
])

missing = sorted(claimed - tested)
for requirement in missing:
    print(f"UNTESTED  {requirement}: claimed in a status doc, named by no test")

# Every id a status document claims must be one the programme actually defines.
#
# This half was added after `wave-1-status.md` was found deferring work to
# "SRS-NTF", a family that appears in none of the eight Master SRS phases. An
# invented id is worse than an absent one: it looks like every real id around
# it, so it reads as a plan and survives review, while the work it names is
# owned by nobody. The index is built by tools/requirements/extract.py from the
# programme .docx files.
known_path = root / "tools" / "requirements" / "known-ids.txt"
unknown: list[str] = []
if known_path.exists():
    known = set(known_path.read_text().split())
    # Any family, not only the eight PATTERN covers. An invented id is invented
    # precisely because its family is not one we already know about, so a
    # pattern listing the known families could never catch one.
    mentioned = matching(r"SRS-[A-Z]{2,8}(-[A-Z]{2,8})?-[0-9]{3}",
                         ["docs/engineering/"])
    unknown = sorted(mentioned - known)
    for requirement in unknown:
        print(f"UNKNOWN   {requirement}: named in docs/engineering/, "
              f"defined in no programme document")
else:
    print("NOTE      tools/requirements/known-ids.txt is missing; "
          "id existence was not checked")

print(f"\n{len(claimed)} requirements claimed, {len(absent)} declared not built, "
      f"{len(missing)} with no test naming them, "
      f"{len(unknown)} naming no real requirement")
sys.exit(1 if missing or unknown else 0)
