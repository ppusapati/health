# Web/mobile parity harness

Two clients implement the same Wave-1 presentation rules — the registration
gate, the note lifecycle, the allergy panel, the order composer, the billing
arithmetic — in two languages. This runs both against one corpus and reports
where they disagree.

## Why it exists

The mobile modules were ported by reading the TypeScript and rewriting in Dart,
and then the Dart tests were written from the same reading. **A rule misread
during the port produces code and tests that agree with each other and with
nothing else.** Unit tests on either side cannot catch that, by construction:
they inherit the misreading.

Running both implementations against the same inputs can, because the two were
written from different readings. On its first run it found three divergences in
238 cases, one of which was a money defect nobody's tests had noticed. It has
since found four more, in the two ports that closed the one-client gap — the
worst being a dose amount of `NaN` that passed validation on mobile, because
`double.tryParse` accepts it and NaN fails every comparison, so `amount <= 0`
was false.

## Running it

```
make parity
```

Each runner is an ordinary test in its own suite, so it also runs with
`npm test` and `flutter test` — but those only regenerate the results. The
comparison is what fails, and `make ci` includes it.

## Files

| File | What it is |
|---|---|
| `cases.json` | The shared corpus: inputs only, grouped by rule |
| `web-results.json` | What the TypeScript said, written by `apps/web/src/lib/parity.runner.test.ts` |
| `mobile-results.json` | What the Dart said, written by `apps/mobile/test/parity_runner_test.dart` |
| `compare.py` | Diffs the two and exits non-zero on any divergence |

The two results files are committed on purpose. A behaviour change shows up in
review as a diff to them, which is the cheapest possible way to notice that a
refactor moved a clinical or financial rule.

## Adding a rule

Add its inputs to `cases.json`, emit its answers from both runners, and run
`make parity`. The corpus speaks the web's vocabulary — snake_case enum names —
and the Dart runner translates, so a case reads the same for both sides.

## The traceability check

`make traceability` is the other half of the same audit, and lives here because
it answers the same kind of question. The status documents do not claim
"implemented" — they claim "has a working, tested implementation", and the
difference is the whole point of them. The check asserts the weaker half
mechanically: every requirement id a doc claims appears in at least one test
file.

It reads every status document, not the newest one. That sounds obvious and
was not: for the first three Wave-2 commits the gate read only
`wave-1-status.md`, so the Wave-2 foundations being written that week were
outside it — a gate covering the finished wave and not the one in progress is
a gate pointed at the past. Pointing it at `wave-2-status.md` too found three
requirements on its first run (SRS-FAC-012, SRS-ICU-002, SRS-OPSAPI-007) that
were claimed, genuinely implemented, and exercised by tests that never named
them. Which is the failure mode exactly: the tests were real, and nothing
connected them to the claim.

It checks a second thing since Wave 2 opened: that every requirement id named
anywhere in `docs/engineering/` is one the programme actually defines.
`wave-1-status.md` deferred four requirements to "SRS-NTF (notification
delivery, later wave)", and there is no SRS-NTF — in any of the eight Master
SRS phases, or in the Development Backlog. The id was invented while writing
the document and then read back, by a later reader and by the model that wrote
it, as though the programme had planned the work. An invented id is worse than
an absent one: it looks like every real id around it, so it survives review,
and the work it names is owned by nobody. `tools/requirements/extract.py`
builds the index of real ids from the programme `.docx` files; `make
traceability` fails on any id that is not in it, and on an index gone stale.

Neither half can check that a test asserts the right thing; nothing can, short
of reading it. The first half does catch what the audit found twice — a
requirement implemented, marked Implemented, and exercised by nothing at all:

| Requirement | What was missing |
|---|---|
| SRS-ENC-010 | The referral a visit answers was held on the domain and the proto, and no test touched `ReferralID`. "Travels with the encounter" is the claim that fails silently, because a field dropped in a mapping layer looks like nothing until somebody tries to close the loop back to the referrer. Now round-tripped through storage and back. |
| SRS-ORD-010 | Placement and cancellation were audited, and nothing asserted it. The audit call is three lines inside a transaction — the kind of thing a refactor moves out or drops — and an audit trail nobody checks is one discovered to be missing at the moment somebody needs it. Now asserted with the actor and the reason. |

## What it does not cover

Screens. Only the logic underneath them, which is where the decisions are: what
gates, what refuses, what a label says. Two clients can lay the same decision
out differently — a segmented control against a sidebar — without a clinician
meeting a second set of rules, and holding pixel layout to parity would be
holding the wrong thing.

It used to say something else here. "Rules only one client has" was listed as
out of scope, on the argument that the web's prescribing module and the mobile
administration module are different jobs that happen to share a bounded
context. That argument was about the modules and it was the wrong axis: the two
are the two halves of UX-W1-05, and the reason each existed on one client only
was that nobody had written the other half, not that the other half did not
belong there. A prescriber does ward rounds with a tablet and a nurse gives
medicines at a workstation. Both halves now exist on both clients and both are
compared, which is what closed the gap rather than documented it.

## Findings from the prescribing and administration ports

| Divergence | Verdict |
|---|---|
| A dose amount of `NaN` validated cleanly on mobile | **Mobile defect.** `double.tryParse('NaN')` returns NaN, and NaN fails every comparison — so `amount <= 0` was false and the prescription was ready to send. `Infinity` passed on both sides, for the plainer reason that infinity is greater than zero. Both now check the shape before parsing: a dose is a plain decimal or it is not a dose, which also refuses `0x10` and `1e3`. |
| A naked decimal point was accepted by both | **Shared defect, found by asking.** `.5` read as `5` is a tenfold overdose, which is why every medication-safety list says to write the leading zero. Both now refuse it and say why, rather than passing an ambiguous string on. |
| `Not graded` against `Severity not graded` | **Neither wrong, both a problem** — the same finding as the allergy labels below. The long form won: the label sits beside a kind chip, and a bare "Not graded" next to "Allergy" reads as though the allergy is what was not graded. |
| The Dart port invented two `FindingKind` members the contract does not have | **Port defect the corpus did not catch, because the corpus did not compare the kind label.** It does now. This is the failure mode the harness exists for, arriving through the one hole left in it. |

## Findings from the first run

| Divergence | Verdict |
|---|---|
| `parseMoney("-.")` returned zero on the web, null on mobile | **Web defect.** `"-"` and `"."` are each refused explicitly and the regex allows an empty whole part and an empty fraction, so the two together slipped past every check and produced a zero payment — the exact outcome the function's contract exists to refuse. Fixed, with a regression test. |
| `unbilledTotal` counted held charges on mobile, not on the web | **Mobile defect, and the worst of the three.** A held charge is waiting on a coding query or an authorisation and is held precisely so it does not reach an invoice. Counting it inflated the figure a cashier bills from — by 100% on the corpus case. The mobile unit test asserted the wrong behaviour too, having been written from the same misreading. Fixed; held charges are now listed but not counted. |
| Two allergy labels worded differently | **Neither wrong, both a problem.** `ward/worklist.dart` states the principle: a clinician who learns the words on a desk terminal should not meet a second vocabulary on a tablet. Reconciled — the web's "Not assessed — risk unknown" wins because it names the clinical fact rather than the process, and the mobile's "Not classified" wins because "Not recorded" reads as "no allergy recorded". |
