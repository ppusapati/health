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
238 cases, one of which was a money defect nobody's tests had noticed.

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

## What it does not cover

Rules only one client has. The web's prescribing module (`meds/prescribe.ts`)
and the mobile administration module (`meds/round.dart`) are different jobs that
happen to share a bounded context, and comparing them would be comparing a
prescriber's screen with a nurse's. Screens are not compared either — only the
logic underneath them, which is where the decisions are.

## Findings from the first run

| Divergence | Verdict |
|---|---|
| `parseMoney("-.")` returned zero on the web, null on mobile | **Web defect.** `"-"` and `"."` are each refused explicitly and the regex allows an empty whole part and an empty fraction, so the two together slipped past every check and produced a zero payment — the exact outcome the function's contract exists to refuse. Fixed, with a regression test. |
| `unbilledTotal` counted held charges on mobile, not on the web | **Mobile defect, and the worst of the three.** A held charge is waiting on a coding query or an authorisation and is held precisely so it does not reach an invoice. Counting it inflated the figure a cashier bills from — by 100% on the corpus case. The mobile unit test asserted the wrong behaviour too, having been written from the same misreading. Fixed; held charges are now listed but not counted. |
| Two allergy labels worded differently | **Neither wrong, both a problem.** `ward/worklist.dart` states the principle: a clinician who learns the words on a desk terminal should not meet a second vocabulary on a tablet. Reconciled — the web's "Not assessed — risk unknown" wins because it names the clinical fact rather than the process, and the mobile's "Not classified" wins because "Not recorded" reads as "no allergy recorded". |
