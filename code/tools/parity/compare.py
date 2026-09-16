#!/usr/bin/env python3
"""Compares the two implementations' answers to the shared corpus.

Prints one line per divergence, naming the rule, the case index, and what each
side said. A divergence is a bug in one of the two; this says where to look.
"""
import json
import pathlib
import sys

root = pathlib.Path(__file__).parent
cases = json.loads((root / "cases.json").read_text())
web = json.loads((root / "web-results.json").read_text())
mobile = json.loads((root / "mobile-results.json").read_text())

groups = sorted(set(web) | set(mobile))
divergences = 0
compared = 0

for group in groups:
    if group not in web:
        print(f"MISSING  {group}: web emitted nothing")
        divergences += 1
        continue
    if group not in mobile:
        print(f"MISSING  {group}: mobile emitted nothing")
        divergences += 1
        continue

    w, m = web[group], mobile[group]
    if len(w) != len(m):
        print(f"LENGTH   {group}: web {len(w)} cases, mobile {len(m)}")
        divergences += 1
        continue

    group_cases = cases.get(group)
    for i, (a, b) in enumerate(zip(w, m)):
        compared += 1
        if a == b:
            continue
        divergences += 1
        label = ""
        if isinstance(group_cases, list) and i < len(group_cases):
            label = f"  input={json.dumps(group_cases[i])}"
        print(f"DIFFER   {group}[{i}]{label}")
        print(f"           web    = {json.dumps(a)}")
        print(f"           mobile = {json.dumps(b)}")

print(f"\n{compared} cases compared, {divergences} divergences")
sys.exit(1 if divergences else 0)
