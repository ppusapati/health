#!/usr/bin/env python3
"""Extract every requirement id the programme actually defines.

Writes `known-ids.txt` from the Master SRS and wave specification .docx files
in `docs/`. That file is committed, and `tools/parity/traceability.py` checks
every id a status document claims against it.

This exists because of a specific defect. `wave-1-status.md` deferred four
requirements to "SRS-NTF (notification delivery, later wave)", and there is no
SRS-NTF: the id was invented while writing the document. It survived review,
a traceability check and an audit, because it looked exactly like every real id
around it and nothing compared it to the source. A deferral that names an
invented owner is not a plan — it is a note that reads as one, and the work it
describes is owned by nobody.

Requirement ids live in the .docx files rather than the repository, so this
runs deliberately rather than on every build: the corpus only changes when the
programme documents do.

    python3 tools/requirements/extract.py

Run `--check` in CI-like fashion to fail when the committed file is stale.
"""
import html
import pathlib
import re
import sys
import zipfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
DOCS = ROOT.parent / "docs"
OUT = pathlib.Path(__file__).resolve().parent / "known-ids.txt"

# A family is two to eight upper-case letters, optionally hyphenated once
# (SRS-INS-CLM, SRS-SRE-OBS), followed by a three-digit number.
ID = re.compile(r"\bSRS-[A-Z]{2,8}(?:-[A-Z]{2,8})?-[0-9]{3}\b")


def text_of(path: pathlib.Path) -> str:
    with zipfile.ZipFile(path) as archive:
        xml = archive.read("word/document.xml").decode("utf8")
    # Paragraph boundaries first, so ids cannot be concatenated across runs.
    xml = re.sub(r"<w:p[ >]", "\n<w:p>", xml)
    return html.unescape(re.sub(r"<[^>]+>", "", xml))


def extract() -> set[str]:
    found: set[str] = set()
    sources = sorted(DOCS.glob("SRS/*.docx")) + sorted(DOCS.glob("waves/*.docx"))
    if not sources:
        print(f"no programme documents under {DOCS}", file=sys.stderr)
        sys.exit(2)
    for path in sources:
        found |= set(ID.findall(text_of(path)))
    return found


def main() -> int:
    found = extract()
    rendered = "\n".join(sorted(found)) + "\n"

    if "--check" in sys.argv:
        if not OUT.exists():
            print(f"{OUT} is missing; run tools/requirements/extract.py")
            return 1
        if OUT.read_text() != rendered:
            print(f"{OUT} is stale; run tools/requirements/extract.py")
            return 1
        print(f"{len(found)} requirement ids, index up to date")
        return 0

    OUT.write_text(rendered)
    print(f"{len(found)} requirement ids written to {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
