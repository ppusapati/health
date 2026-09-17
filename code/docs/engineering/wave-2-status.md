# Wave 2 — implementation status

Wave 2 owns **239 requirements** across twelve clinical and operational
families — SRS-ER, SRS-ICU, SRS-OT, SRS-ANE, SRS-BLD, SRS-CSSD, SRS-MAT,
SRS-BME, SRS-QMS, SRS-IPC, SRS-MRD and the support services — plus the
cross-cutting SRS-OPSAPI, SRS-OPSNFR, SRS-OPSSEC and SRS-OPSWEB sets. The wave
exit outcome is "production-capable acute/inpatient operations".

The same standard as Waves 0 and 1 applies: nothing here is claimed as RTM
`Verified`. What this records is which requirements have working, tested
implementations, and `make traceability` fails on any id claimed here that no
test names.

**This wave is early.** Most of it is not built. The table below says so per
family rather than in prose, because a status document whose honest summary is
"barely started" is one whose per-row claims have to be read carefully.

## Why this document exists before the work does

Wave 1 was audited twice and both times the audit found the same thing: a
requirement implemented, marked Implemented, and exercised by nothing at all.
That is what `make traceability` was built to catch, and until this file
existed the gate read only `wave-1-status.md` — so the Wave-2 foundations
already written were outside it. A gate that covers the finished wave and not
the one being written is a gate pointed at the past.

Wave 2 also opened on a correction worth repeating here. `wave-1-status.md`
deferred four requirements to "SRS-NTF", a family that appears in none of the
eight Master SRS phases: the id was invented while writing that document and
then read back as though the programme had planned the work. `make
traceability` now checks every id named anywhere in `docs/engineering/`
against an index built from the programme's own `.docx` files
(`tools/requirements/extract.py`), so an invented id fails the build rather
than surviving review.

## Foundations

Two cross-cutting mechanisms were built first, because several families need
them and a mechanism owned by one family is one the others duplicate or reach
across a context boundary to use.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-OPSNFR-003 | Critical clinical acknowledgement workflows persist notifications until acknowledged/escalated/closed; restart does not lose pending escalation | **Implemented** — `internal/platform/escalation` |
| SRS-OPSAPI-007 | Durable workflows for escalations and other long-running processes; survives restart and resumes idempotently | **Implemented** for escalation. Recalls, CAPA and transfers arrive with the families that own them |
| SRS-FAC-012 | Emergency contact/escalation matrix by facility/system; a critical incident can resolve active recipients | **Implemented** — the matrix, with roles resolved against the roster at the moment of escalation |
| SRS-ICU-002 | High-frequency flowsheet values are time-stamped, unit-normalized and source-attributed | **Partial** — source attribution and the device's own clock are in place; the flowsheet itself belongs to the ICU family |
| SRS-ICU-003 | Ingest bedside monitor values with device identity and quality/source metadata; raw values distinguishable from manually validated chart values | **Implemented** — `internal/clinical/domain/device.go`, with the RPC surface |
| SRS-ICU-009 | Scores calculated only from explicit validated inputs | **Partial** — the gate exists (`ValidatedInputs`); no score is implemented yet |

### What the escalation mechanism replaced

Wave 1 escalated by arithmetic. `EscalationPolicy.DueEscalations(notifiedAt,
now)` answers how many times a critical result should have escalated by now,
which is the right answer to a question nobody was acting on: nothing was
stored, nothing was delivered, and no recipient was ever named. A derived count
survives a restart trivially, because there was nothing to lose — and it never
reached a human being either.

The first producer is SRS-CLN-012's critical result, raised inside the
recording transaction. A failure there fails the whole transaction on purpose:
the alternative is a critical potassium in a chart with the safety net silently
switched off, and the ward has no way to know.

### What the device provenance model protects

A bedside monitor produces a reading every few seconds and a great many are
wrong in ways a human reads past: a saturation probe off a finger reads 60%, an
arterial line being flushed reads a systolic of 300. The nurse at the bedside
sees a patient who is fine and ignores it. A chart that absorbed those numbers
would carry every one as fact, and the two consumers that read a chart rather
than a patient — the trend and the score — would be computed from artefacts.

So a device reading starts pending, `Confirm` and `Reject` both demand a named
clinician, and `ValidatedInputs()` is a function rather than a convention.

## Family coverage

| Family | Requirements | State |
|---|---|---|
| SRS-ER Emergency Department | 18 | **Not started** |
| SRS-ICU Critical Care | 18 | **Foundations only** — device ingestion and the validated-input gate |
| SRS-OT Perioperative | 17 | **Not started** |
| SRS-ANE Anesthesia and PACU | 11 | **Not started** |
| SRS-BLD Blood Bank and Transfusion | 17 | **Not started** |
| SRS-CSSD Sterile Services | 12 | **Not started** |
| SRS-MAT Materials and Inventory | 16 | **Not started** |
| SRS-BME Biomedical Engineering | 11 | **Not started** |
| SRS-QMS Quality / NABH | 15 | **Not started** |
| SRS-IPC Infection Prevention | 10 | **Not started** |
| SRS-MRD Medical Records / HIM | 10 | **Not started** |
| SRS-AMB, SRS-DIET, SRS-FAC, SRS-HKP, SRS-LND, SRS-MORT support services | 52 | **Not started** — except SRS-FAC-012 above |
| SRS-OPSAPI / OPSNFR / OPSSEC / OPSWEB | 32 | **Partial** — the three foundations above |

## What Wave 2 depends on

The wave specification's §12 names four cross-wave dependencies, and its
dependency rule is explicit: "unavailable optional dependencies must degrade
safely. A feature may not silently reinterpret a dependency outage as a valid
negative business/clinical result."

| Dependency | State |
|---|---|
| Wave 1 patient/encounter/order/medication/billing foundations | **Present** — all 130 requirements implemented and tested |
| Barcode/positive identification and audit services | **Present** — the eMAR scan gate and its override record (SRS-NUR-006/007) |
| Device/integration adapter framework | **Deliberately absent.** The full framework is SRS-IOMT (Wave 5) and SRS-SCA-IOT (Wave 7). What Wave 2 needs is SRS-ICU-003's provenance, which is built |
| Hospital role/privilege policies and downtime patterns | **Partial** — roles and ABAC from Wave 0; the downtime pattern is the Wave-0 edge prototype (P0-13) |

## What is still open from earlier waves

Neither item blocks Wave 2 development; both block a production launch.

| Item | Wave | Why it cannot close here |
|---|---|---|
| SRS-SEC-013 penetration test | 0 | An external engagement, not an artefact. `make release-gate` refuses a production release until one is registered, which is the control working |
| The cluster half of each drill | 0 | external-secrets, the service mesh, and a multi-node or cross-zone failover. Rollouts are covered (DRILL-2026-004, on a real cluster under load); the rest needs infrastructure this environment does not have |
