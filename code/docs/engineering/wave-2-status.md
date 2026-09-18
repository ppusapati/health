# Wave 2 — implementation status

Wave 2 owns **239 requirements** across twelve clinical and operational
families — SRS-ER, SRS-ICU, SRS-OT, SRS-ANE, SRS-BLD, SRS-CSSD, SRS-MAT,
SRS-BIO, SRS-QMS, SRS-IPC, SRS-MRD and the support services — plus the
cross-cutting SRS-OPSAPI, SRS-OPSNFR, SRS-OPSSEC and SRS-OPSWEB sets. The wave
exit outcome is "production-capable acute/inpatient operations".

The same standard as Waves 0 and 1 applies: nothing here is claimed as RTM
`Verified`. What this records is which requirements have working, tested
implementations, and `make traceability` fails on any id claimed here that no
test names.

**This wave is early.** Most of it is not built. The table below says so per
family rather than in prose, because a status document whose honest summary is
"barely started" is one whose per-row claims have to be read carefully.

Three families are now built: SRS-ER, the Emergency Department, SRS-ICU,
critical care, and SRS-OT, the operating theatre. Their rows are below. `make traceability` reads a row naming a requirement as a claim about
it unless the row says the work is not built, so the unbuilt ER requirements
are named here too — a status document that had to leave them out to pass its
own gate would be hiding exactly what a reader greps for.

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

The three SRS-ICU rows this table carried are now in the family section below,
where the flowsheet, the scores and the provenance model they anticipated
actually live. What the clinical context still holds is the provenance model
for observations charted outside critical care, which is where SRS-ICU-003's
device seam was first built and still applies.

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
| SRS-ER Emergency Department | 18 | **12 implemented, 2 partial, 4 not built** — see below |
| SRS-ICU Critical Care | 18 | **17 implemented, 1 not built** — see below |
| SRS-OT Perioperative | 17 | **15 implemented, 2 partial** — see below |
| SRS-ANE Anesthesia and PACU | 11 | **11 implemented** — see below |
| SRS-BLD Blood Bank and Transfusion | 17 | **15 implemented, 2 partial** — see below |
| SRS-CSSD Sterile Services | 12 | **12 implemented** — see below |
| SRS-MAT Materials and Inventory | 16 | **Not started** |
| SRS-BIO Biomedical Engineering | 11 | **Not started** — Phase 2 §9. Note the prefix collision below |
| SRS-QMS Quality / NABH | 15 | **Not started** |
| SRS-IPC Infection Prevention | 10 | **Not started** |
| SRS-MRD Medical Records / HIM | 10 | **Not started** |
| SRS-AMB, SRS-DIET, SRS-FAC, SRS-HKP, SRS-LND, SRS-MORT support services | 52 | **Not started** — except SRS-FAC-012 above |
| SRS-OPSAPI / OPSNFR / OPSSEC / OPSWEB | 32 | **Partial** — the three foundations above |

### A note on SRS-BIO

Earlier drafts of this document and of the traceability gate called the
biomedical engineering family SRS-BME. That identifier appears nowhere in the
SRS; it was invented here, which is the same defect the SRS-NTF fix closed in
Wave 1. The family is SRS-BIO, Phase 2 §9, eleven requirements.

The reason it is worth a paragraph rather than a silent rename is that SRS-BIO
is genuinely ambiguous in the source. Phase 2 §9 uses it for Biomedical
Engineering and Asset Maintenance (SRS-BIO-001 … 011); Phase 7 §6.4 uses the
same prefix for Biobank and Research Specimen (SRS-BIO-001 … 012). They are
different families with overlapping numbers, so an unqualified "SRS-BIO-003"
does not identify a requirement.

Wave 2 owns the Phase-2 family only. Every SRS-BIO reference in this repository
means Phase 2 §9 unless it says otherwise, and the Phase-7 biobank family will
need a qualified identifier before Wave 7 can claim it — inventing one now
would repeat the mistake this note records.

## SRS-ER — Emergency Department

The department is reachable over the wire: `internal/emergency`, the
`EmergencyService` contract, and end-to-end tests in `internal/app` that run
against a real database through the assembled stack.

Three shapes in it are worth naming, because each is a decision that could
have gone the easy way.

An emergency visit is the emergency detail of a Wave-1 encounter, not a second
kind of encounter. The patient, the allergies and the episode belong to the
encounter, and a department holding its own copy is a department whose chart
disagrees with the ward's.

Every interval SRS-ER-006 asks for is computed per response from the event
timeline. Nothing stores a door-to-doctor number, because a stored one is a
field somebody can set, and an absent interval means nobody has seen the
patient — where a zero would be the number that makes a dashboard look best
while the department is at its worst.

A timeline event carries `occurred_at` and `recorded_at` separately and the
timeline sorts on the first. A resuscitation is written up in arrears more
often than not, and the gap between the two is the only thing that separates a
contemporaneous record from a reconstruction.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-ER-001 | Create an arrival by walk-in, ambulance, referral or transfer with mode, complaint and timestamp | **Implemented** — the arrival event is written in the arriving transaction, because every clock below is measured from it |
| SRS-ER-002 | Configurable triage acuity on an approved scale, with vitals, pain, consciousness and red flags | **Implemented** — ESI by default; missing mandatory fields are flagged rather than refused, and re-triage is the same call |
| SRS-ER-003 | Queue by acuity and clinical override rather than arrival order | **Implemented** — an untriaged patient sorts as rank 1, and an override needs a reason in both directions |
| SRS-ER-004 | Unknown patient with a temporary identity and later EMPI reconciliation | **Implemented** — reconciliation keeps the temporary name and rewrites nothing written under it |
| SRS-ER-005 | Activate resuscitation, trauma, stroke, STEMI, sepsis or a local pathway | **Implemented** — the activation and the escalation notice are one transaction, on the SRS-OPSNFR-003 mechanism |
| SRS-ER-006 | Door-to-triage, door-to-doctor and pathway timestamps from immutable events | **Implemented** — derived per response; an absent interval is absent, never zero |
| SRS-ER-008 | Continuous resuscitation events with sequence, actor and late-entry marking | **Implemented** — two clocks and a derived `late` flag, both stored |
| SRS-ER-009 | Administration before full order entry, under protocol and reconciled afterwards | **Implemented** — the debt is facility-wide and announced on the event stream, because one visible only inside a chart is close enough to silent |
| SRS-ER-011 | Medico-legal flag and restricted documentation workflow | **Partial** — the flag, the restricted read and its audit are in place; statutory document handling is not |
| SRS-ER-012 | Status board with patient, acuity, location, elapsed time and disposition barrier | **Implemented** — redaction happens in one place, and the board reports how many rows it redacted rather than being silently shorter |
| SRS-ER-013 | Disposition with required documentation and downstream handover | **Implemented** — every refusal is returned at once, because a clinician told one gate at a time makes one attempt per gate |
| SRS-ER-014 | ED observation beds and timers, independent of inpatient admission | **Implemented** — a separate call from admission, and an overdue review shows on the board |
| SRS-ER-015 | Emergency discharge/referral summary from signed and validated source data only | **Partial** — the signed-summary gate is enforced at disposition; generating the summary belongs to SRS-CLN and is not built |
| SRS-ER-016 | Critical result routes to the responsible clinician and requires acknowledgement | **Implemented** through the SRS-OPSNFR-003 mechanism and SRS-CLN-012's producer |
| SRS-ER-007 | Stat orders and medications through Phase-1 CPOE, preserving priority and indication | **Not built** — needs the orders context to carry an emergency priority end to end |
| SRS-ER-010 | Trauma primary and secondary survey with an injury body map | **Not built** |
| SRS-ER-017 | Ambulance pre-arrival notification with ETA and handover | **Not built** — SHOULD, and the only non-MUST in the family |
| SRS-ER-018 | Downtime emergency registration with later idempotent synchronization | **Not built** — the Wave-0 edge prototype (P0-13) is the pattern; nothing wires the department to it |

### Who may do what

The permissions are split along the jobs rather than the screens, because the
ED is the place where one person holding every permission is most tempting and
most wrong.

A triage nurse assigns acuity and cannot decide a disposition. An ED physician
decides the disposition and cannot assign acuity — a department where anybody
may restate an acuity has no scale. A registration clerk books the arrival and
does neither. The charge nurse moves a patient in the queue, which overrules a
triage nurse's assessment and is therefore its own permission. Seeing a
medico-legal case's detail is a fifth.

## SRS-ICU — Critical care

`internal/icu`, the `IcuService` contract, and end-to-end tests in
`internal/app` that run against a real database through the assembled stack.

Four decisions are worth naming.

A score stores its formula, its version and every input it used, and each
input names the observation it came from. `ReproduceScore` recomputes the
total from them, which is SRS-ICU-009's "score can be reproduced from recorded
inputs" made callable. A stored number with no inputs is a claim nobody can
check a year later, when the formula has been revised and the chart corrected.

The same requirement's "only from explicit validated inputs" cuts both ways. A
component with no confirmed value makes the score *incomplete*, not lower. An
absent platelet count scored as normal is how a coagulopathy scores zero.

SRS-ICU-013 is written as a prohibition, and it shapes the code rather than a
comment. There is no `Suppress`, no alarm limit this system sets, and the
method that closes a worklist entry is `Acknowledge` rather than `Silence`.
The advisory list is derived rather than stored, so taking a line out clears
its own overdue-review entry, and escalating one is a separate call a human
makes — because deciding when a human is needed is the judgement the
requirement leaves with the person.

A unit is normalised or the value is stored as it arrived and visibly marked
un-normalised, with what the device actually sent kept beside the converted
number. A temperature silently read as Celsius when the monitor sent
Fahrenheit is a fever that is not there.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-ICU-001 | ICU admission and transfer context linked to the inpatient encounter, bed and team | **Implemented** — the admission source is required, because an unplanned ward admission is a deterioration somebody may have missed and a post-operative bed is a plan |
| SRS-ICU-002 | High-frequency flowsheet, time-stamped, unit-normalised and source-attributed | **Implemented** — a unit the dimension does not define is stored unconverted and marked, never guessed |
| SRS-ICU-003 | Bedside monitor values with device identity and quality metadata, raw distinguishable from validated | **Implemented** — a device reading starts pending and is invisible to every score until a named nurse confirms it |
| SRS-ICU-004 | Ventilator mode, settings, measured parameters and changes, queryable as a timeline | **Implemented** — set and measured side by side, because the difference between them is the clinical finding |
| SRS-ICU-005 | Continuous infusions with concentration, rate, dose units and titration | **Implemented** — a rate change names the nurse who made it or the pump that reported it; neither is optional |
| SRS-ICU-006 | Lines, tubes and drains with insertion and removal, device days and overdue review | **Implemented** — a device never reviewed is measured from insertion, which is the case the clause exists for |
| SRS-ICU-007 | Hourly and shift intake-output with automatic totals; late corrections versioned | **Implemented** — totals recompute from the live entries, so no running total can disagree with the rows |
| SRS-ICU-008 | Daily goals and multidisciplinary rounds, with owner and status | **Implemented** — a goal names who is to achieve it, and one that was not met says why |
| SRS-ICU-009 | Scores from explicit validated inputs only, storing formula and version, reproducible | **Implemented** — `ReproduceScore` is the verification clause made callable |
| SRS-ICU-010 | Sepsis, VTE, delirium, pressure injury, sedation and ventilator bundles, compliance reportable, exceptions captured | **Implemented** — all-or-nothing compliance, and a reasoned exception is not a failure |
| SRS-ICU-011 | Organ support: ventilation, vasopressor, RRT, ECMO, longitudinally visible | **Implemented** — a run with a start and a stop, because "how many ventilator days" is the question actually asked |
| SRS-ICU-012 | Dashboard with support, meds, labs, trends, devices and tasks; traceable to source, stale feeds marked | **Implemented** — every number names the chart entry it came from, and a quiet feed is shown and marked rather than hidden |
| SRS-ICU-013 | Handle alarms without replacing bedside safety alarms; advisory only, cannot suppress device-native behaviour | **Implemented** — as a prohibition in the type system, not a convention |
| SRS-ICU-014 | Pressure injury, skin, positioning and restraint assessments with generated reassessment timers | **Implemented** — the restraint interval is the short one, because an interval a unit drifts past is how a restraint becomes indefinite |
| SRS-ICU-015 | Goals-of-care and escalation limitation with restricted authorization, visible and audited | **Implemented** — exactly one ceiling in force, enforced by the database; every read audited; restricted rather than blank for a viewer who may not see it |
| SRS-ICU-016 | Transfer-out readiness and structured handoff before completion | **Implemented** — every outstanding item at once, and a death is not gated on paperwork |
| SRS-ICU-017 | Device days, occupancy, length of stay and quality metrics reconciling to timestamps | **Implemented** — derived every time rather than kept as counters, because a counter can disagree with the rows it came from |
| SRS-ICU-018 | Tele-ICU monitoring worklist for configured facilities | **Not built** — SHOULD, and the only non-MUST in the family |

## SRS-OT — The operating theatre

`internal/theatre`, the `TheatreService` contract, and end-to-end tests in
`internal/app` that run against a real database through the assembled stack.

Five decisions are worth naming.

Laterality is a field, not a word in the procedure name. A procedure the
deployment has listed as lateral cannot reach the schedulable state without
one. Wrong-site surgery is the never-event the checklists exist to prevent,
and "left" buried in a sentence is not something a system can check. The
site-marking item on the pre-operative checklist cannot be waived by anybody,
and neither can consent — a system where every gate has an override has no
gates.

A slot check returns every clash at once and marks each overridable or not.
A missing piece of equipment can be wheeled in; another case in the room, or a
surgeon already operating, cannot, so those are refused whoever asks and
whatever reason they give. Overriding a soft conflict needs its own permission
and a mandatory reason, because a list that overran is traced back to that
decision.

A time-out needs at least two participants and an answer to every question,
with an explicit exception for anything not confirmed. One person reading a
list to themselves is the failure SRS-OT-007's "team confirmation" clause
exists to prevent, and silence is not confirmation.

Nothing stores a duration. Turnover, operating time, theatre occupancy and
on-time starts are derived from the milestone rows every time, and an interval
whose milestones have not both happened is absent rather than zero.

Two queries run in the direction an investigation actually runs: a recall goes
from an item and a lot to the patients who received it, and an infection
investigation goes from a sterilisation cycle to the patients whose cases used
it. Both need a permission of their own, held by HIM rather than by theatre
staff, and every search is audited with the item and how many patients it
reached — because a recall and a fishing expedition look identical in the
query log.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-OT-001 | Rooms, block schedules, specialties, equipment constraints and planned downtime | **Implemented** — closing a theatre needs a reason, because a closed theatre is one somebody will ask about |
| SRS-OT-002 | Surgery request with procedure, diagnosis, urgency, laterality, duration, team and requirements | **Implemented** — an incomplete request is recorded and kept out of the schedulable state, rather than refused: a surgeon who cannot book at all keeps a paper list |
| SRS-OT-003 | Elective, urgent and emergency priority with controlled override | **Implemented** — the reason is required in both directions and carried into the audit entry |
| SRS-OT-004 | Schedule against room, time, surgeon, anaesthesia and equipment capacity | **Implemented** — every conflict at once; hard ones are never overridable |
| SRS-OT-005 | Waitlist, postponement and cancellation reasons, rescheduling | **Implemented** — coded causes, and a postponed case releases its slot and returns to the list |
| SRS-OT-006 | Pre-op checklist; no move to ready with unwaived mandatory blockers | **Implemented** — consent and site marking are unwaivable; every other waiver names the entitled role and a reason; an unanswered item counts as unmet |
| SRS-OT-007 | Sign-in, time-out and sign-out with team confirmation and timestamps | **Implemented** — at least two participants, held by a database constraint as well as the domain |
| SRS-OT-008 | Patient movement from pre-op to PACU out, driving utilisation | **Implemented** — two clocks per milestone, and out-of-sequence entries reported rather than refused |
| SRS-OT-009 | Operative note with findings, specimens, implants, blood loss and complications; signed, versioned, amendment-controlled | **Implemented** — signing is separate from writing, and an amendment is a new version with a mandatory reason |
| SRS-OT-010 | Consumables and implants by barcode, lot and serial; inventory decrement and charge traceable to the scan | **Partial** — the scan, the lot, the serial and the traceability are in place, and the implant is announced on the event stream. The decrement belongs to SRS-MAT and the charge to SRS-BIL; neither family consumes the event yet |
| SRS-OT-011 | Specimens linked to the diagnostic order and accession workflow | **Partial** — the specimen takes its patient and side from the case, is announced, and can be accessioned to an order. Raising that order is the diagnostics context's, which is Wave 3 |
| SRS-OT-012 | Instrument tray and CSSD traceability to the case | **Implemented** from the theatre's side — a tray cannot be opened without its sterilisation cycle, and the cycle traces forward to every patient it reached. The cycle itself is SRS-CSSD, below |
| SRS-OT-013 | Command board with room status, case stage, delays, turnover and next-case readiness | **Implemented** — the stage is derived from the milestones, so it cannot disagree with the room |
| SRS-OT-014 | Case delays with coded reasons and the responsible dependency | **Implemented** |
| SRS-OT-015 | Room, block and turnover utilisation, cancellation and on-time-start metrics | **Implemented** — derived from the timestamps every time; three occupancy numbers, because the ratio anybody quotes depends on which pair they divided |
| SRS-OT-016 | Preference cards seeding case requirements without forcing usage | **Implemented** — additive, and nothing in the usage record refers to the card |
| SRS-OT-017 | Emergency insertion without corrupting elective schedule history | **Implemented** — the displaced elective is postponed explicitly with a coded cause and keeps its history; nothing is silently overwritten |

## SRS-ANE — Anaesthesia and recovery

Reachable over the wire: `internal/anaesthesia`, the `AnaesthesiaService`
contract, and end-to-end tests in `internal/app` that run against a real
database through the assembled stack.

The anaesthetic record hangs off the theatre case rather than replacing it. The
patient, the procedure and the operative note belong to SRS-OT; what is here is
the anaesthetist's record of what they did, reached through a port so that this
context never holds its own copy of which patient is on the table.

Four shapes are worth naming, because each is a decision that could reasonably
have gone the other way.

**The ASA grade is a string.** The emergency modifier is part of the grade: "3"
and "3E" are different patients. Storing an integer and a boolean would produce
reports where they were the same, and the reports are what the grade is for.

**An assessment is versioned, never edited.** A patient assessed in clinic and
reassessed on the morning of surgery has two records, and the difference
between them — a chest infection that appeared in the fortnight between — is
frequently the point. The database holds "at most one current assessment per
case" as a partial unique index, which forces supersede-then-insert and hence a
deferrable forward reference from the retired row to its replacement.

**Every intraoperative entry carries its source and, for a device, the
connection state at the moment of the reading.** SRS-ANE-005 asks for
integrated data to be marked by device and connection status. The reason to
mark it is that somebody downstream must be able to exclude it: a 41 systolic
from a detached cuff would otherwise start a resuscitation nobody needs. The
wire message carries a derived `trustworthy` flag so a client cannot forget the
rule.

**A patient nobody handed over cannot leave recovery, whoever asks.** The
override exists for a patient who is clinically ready and scores below a bar,
not for one nobody has taken responsibility for — so `not_handed_over` is the
one refusal the override does not reach. Discharging below the bar is its own
permission, held by the anaesthetist and not by the recovery nurse.

The role catalogue gains `anaesthetist` for the same reason. Two of its
permissions do not belong to every clinician: discharging below the score is
the decision a complaint is traced back to, and transcribing a record from
paper after a downtime writes a backdated record by construction.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-ANE-001 | Pre-anaesthesia assessment with history, airway, ASA, investigations, risks, consent, linked to the planned procedure | **Implemented** — versioned rather than edited; refused, not cancelled, if an "unfit" conclusion names nothing that would change it |
| SRS-ANE-002 | Anaesthesia plan visible to the theatre readiness checklist | **Implemented** — a projection rather than the record: the checklist is read by the whole team and does not need the history |
| SRS-ANE-003 | Intraoperative record: vitals, drugs, fluids, events, timings | **Implemented** — one record per case, held by the database as well as the service |
| SRS-ANE-004 | Drug administration with dose, unit, route, time, and unit validation | **Implemented** — a dose in a unit family the formulary does not dose in is refused unless it is explicitly acknowledged, and the acknowledgement is audited |
| SRS-ANE-005 | Device-integrated data marked by device and connection status | **Implemented** — the connection state is on the row and a derived `trustworthy` flag is on the wire |
| SRS-ANE-006 | Airway management with attempts, devices, grades, difficulty and complications | **Implemented** — attempts count from one and are unique per record; the difficult-airway history is readable by patient across admissions, and publishes an event so systems outside this one learn of it |
| SRS-ANE-007 | Fluid balance with blood loss, transfusion and urine output | **Implemented** — a transfusion cannot be recorded without the blood bank's unit identifier, which is half of every transfusion audit |
| SRS-ANE-008 | PACU handover, recovery scoring and discharge criteria | **Implemented** — the scale and its threshold are configured and travel with each score; an unscored component is recorded as missing rather than as zero; every refusal is returned, not the first |
| SRS-ANE-009 | Post-operative pain orders with monitoring and escalation | **Implemented** — the plan names the prescriptions rather than being one: the drug chart is SRS-MED's, and a second place to prescribe from is how a patient gets two doses |
| SRS-ANE-010 | Anaesthesia summary generated from signed source data | **Implemented** — derived on read, never submitted, and it names what it could not be built from rather than quietly omitting it |
| SRS-ANE-011 | Downtime paper record import, clearly marked and audit-linked | **Implemented** — its own permission, because an imported record is backdated by construction; the note, the transcriber and the transcription time are all required by the database |

## SRS-BLD — Blood bank and transfusion medicine

Reachable over the wire: `internal/bloodbank`, the `BloodBankService` contract,
and end-to-end tests in `internal/app` that run against a real database through
the assembled stack.

Five shapes are worth naming, because each is a decision that could reasonably
have gone the other way.

**The ABO compatibility tables run in both directions, and the component class
decides which applies.** Red cells go from O outward; plasma goes the other
way, because it carries the antibodies rather than the antigens. Whole blood is
held to both, so O whole blood is refused to an A patient although O red cells
are not. Getting this wrong in one direction only is the kind of defect that
reads as correct in every example anybody writes down, so the tests assert all
sixteen ABO pairs per class rather than three cases: a table checked by example
is a table with thirteen untested entries, each of which is a patient. The
assertion was verified to fail against a single wrong entry before being
trusted.

**An unknown group is incompatible with everything, in both directions.** "We
have not grouped this patient" must never read as a match. The wire enums have
explicit unspecified members that map to it, a component always carries a real
group because an ungrouped unit cannot be given to anybody, and a patient
carries theirs on a sample whose absence is what ungrouped means.

**A unit starts quarantined, by database default.** SRS-BLD-004 says an
unreleased component cannot be allocated, and a default of available would make
a row inserted by any path that forgot to say otherwise issuable. Release is
its own permission, held by the manager rather than the scientist, for the
reason every laboratory separates them: the person who ran the assay should not
also be the person who declares the donation clear. A reactive result arriving
late pulls every component already made from that donation back off the shelf.

**A bedside mismatch's critical exception survives the refusal that produced
it.** This was a defect found by the end-to-end test rather than by design: the
escalation was raised inside the transaction that the refusal then rolled back,
so a wrong-patient check blocked the transfusion and told nobody. The notice
and its audit row now run in their own transaction, before the one that fails.
The check itself runs twice — once to escalate, once inside the transaction
that decides whether blood goes into a patient — so a client cannot substitute
a different unit in between.

**An emergency uncrossmatched release skips the crossmatch and nothing else.**
It needs its own permission, a named senior authoriser and a reason; it does
not reach a quarantined unit, because untested blood is not safer than no
blood; and it stays on an outstanding list until the retrospective crossmatch
is recorded. An ordinary issue cannot be marked reconciled, which would make
that list wrong in the direction that looks safe.

The role catalogue gains three: `blood_bank_scientist` (the bench),
`blood_bank_manager` (release and emergency release), and
`haemovigilance_officer` (investigations and look-backs). The separations are
the point. A clinician requests blood and never crossmatches it. A nurse runs
the bedside check and never issues. A scientist runs the bench and neither
releases nor authorises. Only the haemovigilance officer can run a look-back,
because a look-back reaches every patient who received blood from one donation.

| Requirement | What it asks for | State |
|---|---|---|
| SRS-BLD-001 | Register donor or receive external unit data with unique donor/unit identity | **Implemented** — unique within the tenant; a unit names its donor or the supplier it came from, and neither is optional |
| SRS-BLD-002 | Donor screening, deferral and consent per site policy | **Implemented** — accepting an unconsented donor is unrecordable; a temporary deferral must say when it ends and lapses on its own date; a permanent one is not lifted at a screening desk |
| SRS-BLD-003 | Collection and component preparation with parent-child traceability | **Implemented** — every component names the collection it was made from, and the collection names the screening that permitted it |
| SRS-BLD-004 | Mandatory testing results and quarantine/release state | **Implemented** — quarantined by database default; an unconfigured test panel releases nothing; release is the manager's; a late reactive result quarantines the whole donation |
| SRS-BLD-005 | Component inventory by ABO/Rh, type, location, expiry, status and special attributes | **Implemented** — status and expiry are checked together everywhere, because they fail independently |
| SRS-BLD-006 | Blood request with indication, urgency, quantity and special requirements | **Implemented** — a request with no indication is refused, because the utilisation review exists to find transfusions that should not have happened |
| SRS-BLD-007 | Patient group/sample verification and compatibility testing | **Implemented** — a sample expires; a patient with none is told to send a tube rather than that no blood is available; a search returns every candidate with its verdict |
| SRS-BLD-008 | Reserve/crossmatch with expiry of reservation | **Implemented** — one live hold per unit, held by a partial unique index; holds lapse, and a sweep returns the blood to the shelf |
| SRS-BLD-009 | Issue only after final identity/compatibility checks | **Implemented** — the check is compared against the record rather than trusted, and who made it is on the issue row |
| SRS-BLD-010 | Bedside positive patient/unit verification; mismatch blocks and raises a critical exception | **Implemented** — two people required, every failure reported at once, and the escalation survives the refusal |
| SRS-BLD-011 | Transfusion start/end, observations and interruption; longitudinally visible | **Implemented** — one transfusion per unit, held by a unique index; the protocol sets a transfusion has not had are named rather than blocking |
| SRS-BLD-012 | Suspected reaction triggering a blood bank investigation | **Implemented** — a reaction names the component, so the siblings from the same donation are found and quarantined immediately rather than after the investigation |
| SRS-BLD-013 | Return/reissue/discard with reason and eligibility checks | **Partial** — discard with a coded reason is built, and a transfused unit cannot be unwound. The temperature and time-window checks on a *return* are not: this deployment has no cold-chain telemetry, and a check that assumed compliance would be worse than none |
| SRS-BLD-014 | Full vein-to-vein traceability where data exists | **Implemented** — the chain runs in both directions and names its gaps, so "never transfused" is distinguishable from "we lost the record" |
| SRS-BLD-015 | Haemovigilance and component utilisation reports | **Implemented** — derived from the issue, transfusion and reaction records every time; a running transfusion is not counted as one that happened |
| SRS-BLD-016 | Emergency uncrossmatched release with senior authorisation, flagged and later reconciled | **Implemented** — its own permission, and an outstanding list that is what "later reconciled" is read against |
| SRS-BLD-017 | Low-stock and expiry alerts by component type, configurable and acknowledged | **Partial** — thresholds are configurable per component and group, and both alert kinds are derived. Acknowledgement is not built: alerts are computed on read rather than raised as durable notices, so there is nothing to acknowledge yet |

## SRS-CSSD — Sterile services

Twelve requirements, all implemented. The department's own contract
(`SterileServicesService`) and schema (`sterile`), reached through
`internal/sterile`.

**The stage sequence is a table, and the table is the test.** SRS-CSSD-003's
clause is that a stage "cannot be skipped unless authorized exception", which
is only a rule if the order is one. `Advance` permits exactly one step forward;
anything else is refused with which stage was expected. The domain test asserts
all sixty-four transitions rather than a sample, and the assertion was verified
by deliberately widening the rule: forty-nine of the sixty-four then passed
that should not have.

**Skipping is its own permission, and the authoriser is the caller.** The
request carries no `skip_authorised_by` field. A technician holding
`cssd.run.process` cannot skip; a supervisor holding `cssd.stage.skip` can, and
the row records them. A field naming somebody else would let a technician type
a manager's approval without the manager being there. Two stages —
sterilisation and release — are not skippable by anybody, whatever permission
they hold.

**A pack names the packing-list version it was assembled against, not the
set.** Tray sets are versioned rather than edited, with a partial unique index
holding "at most one current version per code". A revision published tomorrow
does not change what today's pack was checked against, and the version is the
only thing that could audit it.

**Release is separate from result, and the department's policy is
configurable while its consequence is not.** A passed cycle whose biological
indicator is still incubating is a load nobody may distribute. Most departments
release routine loads on the chemical indicator and hold implant loads; a few
hold everything, which `RequireBiologicalIndicator` expresses. Whichever a
hospital picks, a load that does not satisfy it cannot be distributed, and the
refusal names every reason rather than the first.

**A pack's issuability is two independent failures.** Unreleased and expired
fail separately, and both are checked wherever a pack could leave — including
in the `issuable` field the wire carries, so a client that checked only the
stage cannot offer an out-of-date pack. The database enforces the other half:
a sterilised pack's expiry is NOT NULL and must be after its sterilisation,
because a missing expiry reads as "never expires" to every query that filters
on it.

**The instrument history is rows, not a status column.** 0034 gave an
instrument a current status; SRS-CSSD-012's acceptance is "history supports
replacement and loss analysis", and both questions are about the past. 0035
adds `sterile.instrument_event`, append-only, written in the same transaction
as every move. An item that has been away twice and is back in service reads
as unremarkable in the status column and as a replacement candidate in the
history.

**A recall reaches the packs that left and the patients they were opened
for.** The scope names every pack in the load with where it is now — in the
department, out on a ward, or already used — and every case one was opened
for. The used packs cannot come back; the case list is why the recall exists.
Raising one is its own permission, because it tells wards to stop using what
they have, and it raises a durable acknowledged notice rather than a line in a
log.

| ID | Requirement | State |
|---|---|---|
| SRS-CSSD-001 | Instrument, tray/set and container master with unique identifiers; set composition/version traceable | **Implemented** — sets are versioned, never edited; a serial number identifies one physical object and cannot be reused while another holds it; bulk items have no serial, which is not a gap |
| SRS-CSSD-002 | Receive contaminated sets from source unit with scan and count | **Implemented** — the count against the packing list happens at receipt, because that is the last moment anybody can say where a missing instrument was; a short set is recorded, not refused |
| SRS-CSSD-003 | Track decontamination, washing and inspection stages; no skip without authorised exception | **Implemented** — one step forward only, all 64 transitions asserted; a skip needs its own permission and the caller is the authoriser; sterilisation and release are never skippable |
| SRS-CSSD-004 | Assemble tray against versioned packing list, recording missing and replaced items | **Implemented** — a critical shortfall refuses the assembly, because that pack is a cancelled case found when the surgeon opens it; a non-critical one goes out recorded |
| SRS-CSSD-005 | Record packaging method, indicator and load assignment | **Implemented** — a load is attached in one call, because a partial attachment leaves packs whose cycle differs from the ones beside them in the chamber |
| SRS-CSSD-006 | Sterilization cycle parameters, or ingest from equipment where integrated | **Implemented** — parameters are free-form because sterilizers differ; the source distinguishes an ingested record from a typed one, which is evidence of a different weight |
| SRS-CSSD-007 | Chemical/biological indicator result and release authorisation; failed or uncleared load cannot be distributed | **Implemented** — release is a separate field from result, held by a database CHECK that a released load names who released it; every refusal is returned, not the first |
| SRS-CSSD-008 | Label sterile packs with set, cycle, sterilized-on and expiry; expired pack cannot be issued | **Implemented** — the label is derived on read and names what it could not be built from; expiry is NOT NULL once sterilised, and issuability is checked at issue rather than trusted from a printed label |
| SRS-CSSD-009 | Issue sterile sets to OT/ward and record return and usage | **Implemented** — the count comes back with the pack and a shortfall is reported; a pack marked used names its case, held by a database CHECK |
| SRS-CSSD-010 | Trace patient procedure to tray/set and sterilization cycle | **Implemented** — its own permission and audited, because the answer names every set and cycle a patient was exposed to; the trace names its gaps rather than quietly returning fewer sets |
| SRS-CSSD-011 | Recall affected packs after a failed indicator or sterilizer event; locations and cases identified, recall tasks generated | **Implemented** — every pack in the load including the ones already opened; a durable acknowledged notice rather than a screen nobody opened; its own permission |
| SRS-CSSD-012 | Track instrument lifecycle, repairs and missing instruments; history supports replacement and loss analysis | **Implemented** — an append-only history written in the same transaction as every move, so a status cannot change without it; the database refuses a move out of service with no reason |

### The SRS-NUR-014 duplication

SRS-NUR-014 built a transfusion record in Wave 1 — `nursing.transfusion` and
`nursing.transfusion_observation` — before this context existed. It records the
same clinical event from the ward's side: a unit number, a bedside check,
observations, a reaction.

Two records of one transfusion will disagree, which is the defect most of this
codebase's constraints exist to prevent. `bloodbank.episode` is the one that
should survive, because it is the only one linked to the issue, the component
and the collection, and therefore the only one a look-back can run along: asked
"who else received blood from this donation", the nursing table cannot answer.

Resolving it means changing a Wave-1 contract and migrating the rows, which is
not SRS-BLD's to do unasked. Until then a deployment entitled to the bloodbank
module records transfusions here and the nursing table is the ward chart's view
of the same event. This is a known defect with a named resolution, not a
design.

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
