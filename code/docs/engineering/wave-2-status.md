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

**This wave is part-built.** The table below says so per family rather than in
prose, because a status document whose honest summary is a fraction is one
whose per-row claims have to be read carefully.

Eleven families are now built: SRS-ER the Emergency Department, SRS-ICU
critical care, SRS-OT the operating theatre, SRS-ANE anaesthesia and PACU,
SRS-BLD blood bank and transfusion, SRS-CSSD sterile services, SRS-MAT
materials and inventory, SRS-BIO biomedical engineering, SRS-QMS quality
management, SRS-IPC infection prevention and control and SRS-MRD medical
records and health information management. Their rows are below. One set
remains: the support services.

`make traceability` reads a row naming a requirement as a claim about it
unless the row says the work is not built, so the unbuilt ER requirements are
named here too — a status document that had to leave them out to pass its own
gate would be hiding exactly what a reader greps for.

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
| SRS-MAT Materials and Inventory | 16 | **16 implemented** — see below |
| SRS-BIO Biomedical Engineering | 11 | **11 implemented** — Phase 2 §9. Note the prefix collision below |
| SRS-QMS Quality / NABH | 15 | **15 implemented** — see below |
| SRS-IPC Infection Prevention | 10 | **10 implemented** — see below |
| SRS-MRD Medical Records / HIM | 10 | **10 implemented** — see below |
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

## SRS-MAT — Materials, procurement and inventory

Sixteen requirements, all implemented. Two jobs that share an item master —
buying and holding — in one contract (`MaterialsService`) and one schema
(`materials`), reached through `internal/materials`.

**The stock ledger is double-entry, and there is no on-hand column anywhere.**
Every movement takes a quantity out of one bucket and puts it into another,
where a bucket is a location plus a status, and at most one side may be outside
the hospital. Written that way, conservation is a property of the row rather
than of the code that wrote it. `materials.balance` is a view that sums the
ledger, and every balance read in the adapter and on the wire goes through it —
so a store's balance and its ledger cannot disagree, because there is only one
of them. SRS-MAT-007's acceptance is that on-hand is derivable from immutable
movements, and a repository test computes the same figures twice, once in SQL
and once in Go, and compares them.

**In-transit is a status, not a flag.** A transfer is two movements through a
third bucket, so SRS-MAT-010's "source/destination balances reconcile" holds at
every moment rather than only at the end. The end-to-end test asserts the total
inside the hospital mid-flight, and that two cartons short of a hundred stay
visible in transit instead of vanishing from both stores.

**Three things independently keep stock out of available-to-promise:** the
wrong status (SRS-MAT-006 — unaccepted stock cannot become available), a
blocked lot (SRS-MAT-013), and an expired one. Quarantined and blocked stock is
still counted: it is on the shelf, and somebody has to go and get it.

**Four separations are permissions rather than convention**, and each was
verified by granting it away and watching the test fail. The storekeeper who
took a delivery in cannot accept it out of quarantine. A storekeeper cannot
approve any stocktake adjustment, and the domain and the database separately
refuse an approval by the person who counted — two different controls, both
tested, because a test covering only the second would pass with the permission
granted to everybody. A storekeeper cannot block a lot, because blocking tells
every ward to stop using what they have. And a buyer never touches the ledger:
the person who commits the hospital's money does not also confirm the goods
arrived.

**An approval route needs more than a permission.** Everyone in a chain holds
the same `mat.requisition.approve`, so the route names which role signs at
which step and the caller must actually hold that role — otherwise finance
signs as the medical director by typing it. That required `authctx.Session` to
answer "do you hold this role", which it could not: it carried `Roles` and
exposed only `HasPermission`. `HasRole` was added beside it.

**Two conversions are where a by-eye check goes wrong, and both are asserted.**
A quote per box of a hundred against a quote per piece differ by two orders of
magnitude, so bid comparison normalises to landed cost per stock unit. An
invoice priced per piece against an order priced per box hides a rupee-a-piece
overcharge, so the three-way match applies the pack size. Both were verified by
removing the conversion.

**KPIs and alerts are derived on every read.** A stored KPI is by construction
not reproducible from the ledger the requirement says it must come from, and a
stored alert stays raised after the stock arrives — a storekeeper who has
learned to ignore stale alerts ignores the real one too.

| ID | Requirement | State |
|---|---|---|
| SRS-MAT-001 | Purchase requisition from manual request, min-max, planned procedure or replenishment; records source, need-by and cost centre | **Implemented** — the four sources are distinguished because they have different review; a request with no cost centre is refused, because it is one nobody's budget carries |
| SRS-MAT-002 | Configurable approval routing by amount, category and facility; approval history immutable | **Implemented** — every matching rule contributes its roles in threshold order; the chain is walked in order and appended, never rewritten; a request matching no rule is refused as a configuration gap rather than approved; nobody approves their own |
| SRS-MAT-003 | RFQ to approved suppliers and recorded responses; comparison on normalized commercial terms | **Implemented** — an unapproved supplier is neither quoted nor ordered from; the comparison normalises pack size, freight, tax and currency, carries lead time rather than scoring it, and names the bids it could not normalise |
| SRS-MAT-004 | PO with item, UOM, tax, price, delivery and terms; version and amendments retained | **Implemented** — versioned, never edited; a chain root holds "at most one live revision", which a parent pointer cannot express past the second amendment; an amendment without a reason is refused |
| SRS-MAT-005 | GRN against PO with quantity, batch/lot/serial/expiry and discrepancy; over/short follows tolerance | **Implemented** — over-receipt beyond tolerance is refused and short receipt is recorded, and the asymmetry is the rule: unordered stock accepted goes on an invoice, while refusing a short delivery leaves goods on the dock the system says never came |
| SRS-MAT-006 | Quarantine and inspection for configured categories; unaccepted stock cannot become available | **Implemented** — received stock lands where the item's configuration says, so this is a property of where it went rather than a check somebody has to remember; accepting is its own permission the receiver does not hold |
| SRS-MAT-007 | Stock ledger by location, bin, batch, serial and status; on-hand derivable from immutable movements | **Implemented** — double-entry and append-only, with no maintained total anywhere; the balance view is the only answer, and a database CHECK refuses a movement that changes no balance |
| SRS-MAT-008 | Issue and return to department, patient or cost centre with authorized source; movement and charge linkage traceable | **Implemented** — an issue with no cost centre is refused, a consumption on an unknown patient is refused, and the charge seam carries the movement id. The charge itself is a port SRS-BIL has not been wired to — see below |
| SRS-MAT-009 | FEFO for expiring consumables, configurable FIFO and serial policies; pick respects item policy | **Implemented** — a recommendation, not an instruction, with the lots it passed over and why; a perishable item cannot be set to earliest-received-first, because that throws away stock somebody could have used |
| SRS-MAT-010 | Transfer between stores with in-transit state; source and destination balances reconcile | **Implemented** — in-transit is a status, so nothing is ever nowhere; a short arrival is recorded and the missing quantity stays in transit rather than vanishing from both stores |
| SRS-MAT-011 | Cycle and physical count with controlled adjustment; variance requires approval and reason | **Implemented** — expected quantities frozen when the count opens, never recomputed at approval and never taken from the caller; every variance needs a reason; the counter cannot approve, held by the domain and by a database CHECK |
| SRS-MAT-012 | Min-max, reorder and stockout alerts; suggested order reviewable before PO | **Implemented** — derived on read, never stored; a level nobody configured raises nothing; the suggestion is returned for review and raises no requisition of its own |
| SRS-MAT-013 | Track recall and blocked lots and prevent issue; blocked lots excluded from ATP and recall list generated | **Implemented** — blocked stock leaves availability and stays counted; the recall names where the remaining stock is and every patient it reached; raising one is its own permission and a durable acknowledged notice |
| SRS-MAT-014 | Three-way match PO-GRN-invoice; mismatch surfaced for resolution | **Implemented** — every line of all three documents appears, including the ones present in only one; the price check converts through the pack size; surfaced and never resolved, because the resolution is a human negotiation |
| SRS-MAT-015 | Inventory turns, days on hand, expiry exposure and supplier fill rate; formulas reproducible from ledger/PO data | **Implemented** — derived every time, with each formula restated in the test rather than only asserted; a location holding a negative balance is reported as missing receipts rather than as a turn rate; a fill rate is capped per line, so an over-delivery does not make up for a short one |
| SRS-MAT-016 | Consignment and patient-specific implants with ownership state; consumption triggers the charge/liability event | **Implemented** — the liability is raised in the same call that records the movement, so the two cannot come apart; one liability per movement, held by a unique index, so a retry cannot bill a supplier twice for one implant |

### The consumption seam

Three contexts consume stock and none of them decrements this ledger yet. The
theatre records what it used (SRS-OT-010), the pharmacy dispenses
(SRS-MED-011), and sterile services issues packs (SRS-CSSD-009). Each is a
correct record of its own event; none is a stock movement.

The ledger is the right place for all three, because it is the only one that
can answer "what do we hold" and "which patients did this lot reach". Wiring
them means changing three Wave-1 and Wave-2 contracts and backfilling their
history, which is not SRS-MAT's to do unasked. Until then a deployment
entitled to the materials module records stock movements here and the three
contexts record their own clinical events, and the two are reconciled by
counting.

The charge half of SRS-MAT-008 is the same shape: `ports.Charges` exists and
`app.go` wires nil into it, because what a patient is charged belongs to
SRS-BIL and a hospital has one place that decides it. A consumption records the
movement and the cost centre; it does not raise a bill.

Both are known gaps with named resolutions, not designs.

## SRS-BIO — Biomedical engineering and asset maintenance

Eleven requirements, all implemented. The equipment register, its contracts
and maintenance schedules, the service work, recalls, telemetry, the
reliability figures and disposal, in one contract (`BiomedicalService`) and
one schema (`biomedical`), reached through `internal/biomedical`.

**A ticket carries a kind, and only a corrective one is a failure.** The first
version of this did not, and the domain test found the consequence: every
service visit counted against the machine, so MTBF measured how often a
ventilator was maintained rather than how reliably it ran, and a department
that serviced its equipment properly read as a department whose equipment kept
breaking. That is not a reporting nicety — it is an argument for servicing
less. Planned downtime is now reported beside the unplanned kind rather than
mixed into it, and preventive work must name the plan it was raised against,
because otherwise PM compliance is whatever anybody labels preventive.

**An SLA is derived, never supplied.** A ticket's response and resolution
clocks come from the asset's live contract — the most protective one, because
a machine under both a warranty and a CMC is covered by the CMC — and priority
only tightens them. A vendor who agreed next-business-day has not made an
emergency less urgent to the hospital. The hours are frozen onto the ticket at
the moment it is raised, because the contract may lapse before the work
finishes and the promise that applied is the one it was raised under. Nothing
on the wire can set them.

**Closing a repair is guarded twice.** `bio.ticket.close` is its own
permission, held by the biomedical manager and not the engineer; and the
domain separately refuses whoever did the work, whatever they hold. Two
controls rather than one, because a permission grant is one configuration
mistake away and the domain rule is not — a manager who fixed a machine
himself still cannot sign it off. Both are tested separately, and each was
checked by removing the other.

**Expiries and the maintenance due list are derived on read.** No stored
reminder, no stored due date. A stored reminder stays raised after the
contract is renewed, and an engineer who has learned to ignore stale reminders
ignores the real one too; a stored due date drifts the moment somebody
services a machine without closing the right record. A plan's baseline moves
only when planned work closes against it, and nothing can set it directly — a
baseline anybody can write is a compliance figure anybody can correct upwards.

**A runtime plan with no meter reading is reported as unanswerable.** Not as
not-due. "We do not know" and "it is fine" are different answers and only one
of them needs somebody to go and look at the meter.

**A recall matches and holds inside the transaction that records it.** Not in
a sweep afterwards: the gap between the two is a window in which the hospital
has been told and the equipment is still on a patient, and that window is what
SRS-BIO-008 exists to close. The notice is durable and acknowledged rather
than a screen somebody might open, and it cannot be closed while any asset
still has work outstanding. Serial ranges deliberately match an asset with no
serial recorded, because a machine nobody can rule out is a machine to go and
look at.

**A disposal is approved by the authenticated caller.** The request names who
asked for it and cannot name who approved it, so a requester cannot sign off
their own. Sanitisation evidence is required where sanitisation is — a
certificate, not "we wiped it" — and both are refusals rather than warnings,
because a disposal is the last thing that ever happens to a record and
anything missing at that point is missing for ever. The database holds all
three: one disposal per asset, an approver who is not the requester, and
evidence where it is required.

**SRS-BIO-009 was a real gap in the theatre, and it is closed.** See the
section below.

| ID | Requirement | State |
|---|---|---|
| SRS-BIO-001 | Equipment register with identifiers, location, criticality and lifecycle status | **Implemented** — UDI and serial both, because a recall is announced by one or the other and a hospital does not choose which; the tag is unique per tenant and the serial unique per make, excluding assets with none |
| SRS-BIO-002 | Warranty, AMC and CMC contracts with vendor details and renewal reminders | **Implemented** — cover is the most protective live contract, answered by the server rather than by each client; reminders are derived on read and hold contracts and calibrations in one list, because the person who chases one chases the other |
| SRS-BIO-003 | Preventive maintenance schedules by interval, runtime or risk; due and overdue reportable | **Implemented** — derived on read; a plan whose basis carries no interval is refused by a database CHECK rather than never coming due; a runtime plan with no meter reading reports unanswerable |
| SRS-BIO-004 | Calibration records with certificate and next-due date; overdue calibration flagged | **Implemented** — its own permission, because a calibration is what makes a machine's readings admissible; the certificate is required; whether a lapse blocks use or only reports is a deployment decision, and both directions are tested |
| SRS-BIO-005 | Breakdown/service request with priority, impact and SLA; assignment and escalation | **Implemented** — the SLA comes from the contract and is tightened by priority, never set by the request; awaiting-parts stops the resolution clock, because a manufacturer's lead time is a supply problem reported as an engineering one; a critical machine crossing into unusable raises a durable notice, only on the transition |
| SRS-BIO-006 | Maintenance history with diagnosis, parts, cost and downtime; closure validated | **Implemented** — a resolution with no diagnosis is refused, because a history that says a machine was fixed four times says nothing about whether it is the same fault; closure is a separate permission and never the engineer who did the work, held by the domain and by a database CHECK |
| SRS-BIO-007 | Uptime, MTBF, MTTR and PM compliance per asset and fleet | **Implemented** — only breakdowns count as failures; planned downtime is reported separately; MTTR counts only repairs that finished, so leaving a ticket open cannot improve it; the fleet ranks by uptime rather than failure count, because one week-long outage is worse than five hour-long ones |
| SRS-BIO-008 | Recall and field safety notices matched to assets; affected equipment quarantined and tracked to closure | **Implemented** — matched and held in the call that records the notice; UDI wins over make and model, and a serial range includes assets with no serial; a hold is separate from status, because a recalled machine may be perfectly serviceable and still must not be used; the notice cannot close over outstanding work |
| SRS-BIO-009 | Equipment availability visible to scheduling; unavailable equipment cannot be falsely shown as schedulable | **Implemented** — the theatre reads the register through a port and counts working units per capability rather than flagging them; see the section below for what was wrong before |
| SRS-BIO-010 | Ingest device telemetry to inform maintenance; readings cannot alter maintenance records | **Implemented** — append and read, with no method on the port that reaches a maintenance record; a batch is one transaction, because a half-ingested batch is a meter reading that jumps backwards; an ingested reading is distinguished from a typed one |
| SRS-BIO-011 | Disposal with approval, sanitisation evidence and asset closure; disposed asset cannot be assigned for use | **Implemented** — the approver is the caller and never the requester; sanitisation evidence is required where sanitisation is; a disposed asset is nowhere, takes no work orders, and its status cannot be reached by a status change |

### SRS-BIO-009 was a gap, not a label

Before this family was built, the theatre matched a case's requirements
against `Room.Equipment` — a free-text list of what the room is meant to have
— with no notion of whether any of it worked. A hospital could send an image
intensifier for service on Monday and be offered intensifier slots in that
room all week, which is exactly the outcome the requirement's acceptance
forbids.

`Room.Suits` now takes what the room's machines can actually do, read through
a port over the equipment register. Three properties matter:

It is counted, not flagged. A theatre with two intensifiers keeps its slots
when one goes for service and loses them when the second does. A boolean would
have taken the room off the list on the first fault, which is its own way of
being wrong.

The refusal names the machine and the reason — "BME-II-1: awaiting parts". A
scheduler told "this room has no image intensifier", about a room with one
bolted to the floor, concludes the system is wrong and stops reading it. The
conflict stays overridable, because a hospital can wheel one in from the next
theatre and a scheduler who knows that should be told rather than stopped.

There is no second copy of the answer. The adapter calls the same domain
function the biomedical use cases call, so a room's capability and the
equipment screen cannot drift; and the calibration setting is passed from the
biomedical configuration rather than read again, so a hospital that treats a
certificate as a condition of use has its theatre list agree with its
equipment screen.

The port takes every identifier a room is known by, its id and its code, and
sums across them. The engineer who registers a ventilator types the code on
the door and the scheduler holds the id, and a link bound to only one of those
would be wired and never carry anything. **A deployment whose register keys
equipment on neither will get the old behaviour** — the fitted list, trusted —
which is a narrower answer rather than a wrong one, and is named here rather
than hidden. `Deps.Equipment` nil does the same thing, for a deployment with
no register at all.

### What SRS-BIO does not reach

Two seams are named rather than half-built.

A part fitted during a repair carries `materials_item_id`, and nothing
decrements the materials ledger. The two ledgers can be reconciled on that
field; they are not reconciled automatically, because a part taken from the
biomedical store and one taken from central stores are different movements and
deciding which is a materials question. This is the same shape as the
consumption seam below.

Nothing here raises a charge or a cost centre entry. Contract values,
acquisition cost, part cost and disposal proceeds are all recorded in minor
units and all stay inside `biomedical`. What the hospital's finance system
does with them belongs to SRS-BIL and to a wave that owns fixed assets.

## SRS-QMS — Quality management, accreditation and risk

Fifteen requirements, all implemented. Incidents and risk, root cause
analysis, corrective and preventive action, document control, internal audit,
committees, the accreditation evidence map, the indicator dictionary,
complaints, peer review, competency and legal hold, in one contract
(`QualityService`) and one schema (`quality`), reached through
`internal/quality`.

**An incident's reach is three states, not a near-miss flag beside a harm
level.** Two columns that can contradict each other will, and the
contradiction is the one that matters: a near miss filed with harm is a
mis-filed record whichever way round it is, and every report built on it is
wrong. Both directions are unwritable — in the domain, in the schema, and at
the RPC boundary.

**A death is a sentinel event whatever the reporter ticked, and a sentinel
event is restricted.** Left to the reporter, the one incident that most needs
an executive review is the one nobody wants to escalate. The hospital's own
sentinel categories are configuration on top of that, never instead of it.

**Restriction redacts where there is something left to say and refuses where
there is not.** A ward needs to know that an incident of this kind happened in
it; what it must not have is the narrative, the patient and the people. So an
incident comes back redacted, carrying its category, department and risk band
but not the score components — which would let a reader reconstruct the
consequence, and for a restricted case that is most of the story. An analysis
or a set of minutes refuses instead, because they *are* the discussion. Every
read of restricted material under the permission is audited, which is what
SRS-QMS-012 means by "access limited to authorized committee and audit
logged".

**A corrective action closes only on an effectiveness check that passed,
approved by somebody other than its owner.** A failed check is recorded and
sends the action back to work rather than being discarded: "we checked and it
had not worked" is the finding, and the history "fixed, checked, had not
worked, fixed again, checked, had" is what tells a hospital whether its
analysis was any good. The two refusals carry different messages, because "not
checked" and "the check failed" send somebody to do two different things.

**Acknowledgement is per document version.** A system that carries an
acknowledgement forward across a revision reports full compliance with a policy
nobody has read. Approving a version supersedes the earlier ones in the same
transaction — two versions both in force is the state document control exists
to prevent, and a sweep afterwards would leave a window in which the hospital
had two hand hygiene policies.

**A major non-conformity closes only through a closed corrective action.**
That is the whole of "audit trail links finding to closure": a finding closed
with a note is one somebody talked their way out of, and the next audit finds
it again.

**Five things are read from the database rather than taken from the request**,
each closing a way the record could be made to say something untrue: how many
actions an analysis produced, whether a finding's action is actually closed,
whether an audit still has open findings, whether a clause has evidence filed,
and whether a meeting was quorate against the committee's real membership.
Three more are assigned by the server — a version's ordinal, an indicator's
revision, and an award's expiry — because a client that chose them could let
two records collide or one outlive its own rules.

**Three things are reported as unanswerable rather than as zero**: an
indicator period with no eligible cases, a document with no review interval
configured, and a controlled document with nothing in force. Each is a gap
somebody has to see, and each has a zero that would hide it.

| ID | Requirement | State |
|---|---|---|
| SRS-QMS-001 | Record incident/near miss with category, location, severity, patient/asset links and immediate action; unique ID and restricted access | **Implemented** — reach is three states so a near miss cannot record harm and an event classed as harm cannot record none; an event that reached a patient must say what was done at the time; restriction redacts to what a ward may know rather than withholding, and anonymous reporting hides the reporter from readers and never from the trail |
| SRS-QMS-002 | Severity/risk scoring and escalation; high severity triggers configured notifications | **Implemented** — the score is consequence × likelihood and the band follows, derived and held to the arithmetic by a database CHECK; a score a reporter could type is one they could type low; escalation is durable and acknowledged, fires at the configured band, and on a re-score fires only upwards |
| SRS-QMS-003 | Root cause analysis with configurable method and contributing factors; cannot close without accountable owner | **Implemented** — the method is checked against the hospital's approved set; factors are categorised because the value of analysis across many incidents is being able to count them; closing needs an owner, at least one factor, findings, and either an action or a stated reason there was none |
| SRS-QMS-004 | CAPA with action, owner, due date, effectiveness check and closure approval; overdue escalates | **Implemented** — approval is refused for the raiser and closure for the owner, in the domain and in the schema; closing needs a check that passed; a failed check is kept and returns the action to work; overdue is derived, separates the action's date from its check's, and escalates on demand rather than as a side effect of reading |
| SRS-QMS-005 | Sentinel event workflow with restricted access and executive notification; review milestones tracked | **Implemented** — a death is a sentinel event whatever was ticked and a sentinel event is restricted, both held by database CHECKs; the notice is durable and acknowledged and goes to the executive chain rather than the departmental risk queue; the restriction cannot be lifted |
| SRS-QMS-006 | Policy/SOP/document control with version, approval, effective date, acknowledgement and obsolete state; only effective version shown by default, history retained | **Implemented** — the version in force is derived from the dates rather than a flag a job maintains; approval supersedes the earlier ones in the same transaction; the author cannot approve their own revision; acknowledgement is per version and the caller cannot choose which version they are confirming |
| SRS-QMS-007 | Internal audits with findings and CAPA; audit trail links finding to closure | **Implemented** — a non-conformity records its evidence and closes only through a closed corrective action, held by the domain and by a database CHECK; an audit cannot close over an open finding, and the findings are read rather than trusted from the request |
| SRS-QMS-008 | Committee meetings, agenda, attendance, minutes, decisions and actions; action items flow to task engine | **Implemented** — minutes recording decisions cannot be approved below quorum, checked against the committee's real membership; a quorum larger than the membership is refused at formation; committee actions are CAPAs rather than a second kind of task, so there is one overdue report rather than two |
| SRS-QMS-009 | Accreditation evidence map to configurable standard/clause set; evidence attached and reviewed by clause | **Implemented** — a standard and its clauses load in one transaction, because a half-loaded standard is clauses nobody is failing; evidence is pinned to a document *version* and the record it names is checked to exist; a clause judged met with nothing filed is refused, and one found not met must name the action that will close it |
| SRS-QMS-010 | KPI dictionary with target, numerator/denominator, frequency and owner; dashboard shows current value with formula/version | **Implemented** — the dictionary is versioned by revision and never edited in place, the revision is server-assigned, and a recorded value carries the revision it was computed under; the rate is derived from the counts; a zero denominator is unanswerable rather than zero |
| SRS-QMS-011 | Patient complaint/grievance with SLA and resolution; escalation and closure reason retained | **Implemented** — two clocks rather than one, both from the deployment's SLA configuration rather than the request; a complaint cannot be resolved without the complainant being spoken to, except by withdrawal; the escalation is written to the record as well as derived, so it survives resolution |
| SRS-QMS-012 | Mortality/morbidity and peer-review restricted workflows; access limited to authorized committee and audit logged | **Implemented** — its own permission, held by neither the quality officer nor the quality manager; peer review belongs to a restricted committee; every read is audited; a completed review names the meeting that made it, and a preventable or potentially preventable death must name corrective actions that exist |
| SRS-QMS-013 | Staff training/competency evidence linked to controlled documents and roles; expired/missing competency visible | **Implemented** — gaps are derived on read and distinguish never-held from expired from trained-against-superseded-text, because they need three different actions; a revision expires earlier training only where the approver marked it as requiring retraining; the expiry is computed from the competency's validity period, never supplied |
| SRS-QMS-014 | Tracer/readiness dashboard for accreditation survey preparation; open evidence gaps and overdue actions shown | **Implemented** — derived every time, because a stored percentage is out of date the moment a document is revised; critical gaps and stale judgements are counted apart; the overdue actions are the hospital's rather than the standard's, because a survey asks whether the quality system is working |
| SRS-QMS-015 | Preserve QMS records against deletion subject to retention/legal hold; deletion attempts follow policy and audit | **Implemented** — the adapter has no DELETE anywhere in it, which is stronger than a policy somebody reads once; a hold blocks writes as well as deletion, because a closure that rewrites what a court asked to see loses the record just as surely; the hold is the platform's own mechanism reached through a port, and placing or lifting one is its own permission and audited |

### What SRS-QMS does not reach

Three seams are named rather than half-built.

**The indicator dictionary stores definitions and recorded values; it does not
compute them.** An entry says in words what its numerator and denominator are
and a value records the counts with a note saying where they came from.
Computing those counts from the hospital's source records is a reporting
engine, which is Phase 6's command centre, and a half-built one here would be
a second set of numbers disagreeing with the first. SRS-OPSNFR-008's
reproducibility requirement is met by the version pinning and the source note,
not by a calculation this context performs.

**Committee action items are CAPAs, not a separate task engine.**
SRS-QMS-008's acceptance says action items flow to the task engine; an action
item with an owner, a due date and an escalation when it is late is what a
CAPA already is, and building a second one would mean two overdue reports
that disagree. The durable workflow engine from Wave 0 (ADR-006) remains
available for anything that genuinely needs one.

**The acknowledgement and competency gap reports are only as good as the
directory.** They read who holds which role from identity and access through a
port, and a deployment that configures no roles for them gets an empty gap
report — which reads exactly like a compliant hospital. `app.Deps.Quality`
carries `AcknowledgementRoles` and `CompetencyRoles` for that reason, and a
deployment leaving them empty is named here rather than discovering it at a
survey.

## SRS-IPC — Infection prevention and control

Ten requirements, all implemented. Surveillance cases and their onset
classification, device-day denominators, isolation and the bed board,
multidrug-resistant organism alerting, outbreak investigation, hand hygiene
audit, occupational exposure, antimicrobial stewardship and environmental
testing, in one contract (`InfectionService`) and one schema (`infection`),
reached through `internal/infection`.

This family is unusual in what it measures: every other context in the system
records what the hospital did for a patient, and this one records the harms
the hospital caused. That makes the edit paths matter more than the read
paths, because each of the numbers here is one somebody has a reason to want
lower.

**Onset classification is derived, and an override is a different field.**
`Classify()` takes the admission date, the onset date and the configured
surveillance window and answers community-acquired, healthcare-associated or
indeterminate. Nothing on the RPC accepts a classification. A reviewer who
disagrees calls `OverrideOnset`, which needs its own permission
(`ipc.onset.override`, held by the infection control lead and not the
practitioner), a mandatory reason, and writes to columns the derivation never
touches — and every period summary counts overrides separately, so a month in
which eleven healthcare-associated infections became community-acquired is a
month somebody can see. A single mutable field would have made every
reclassification invisible, and reclassifying is not moving an infection
between reports: it removes it from the rate.

**Device-day denominators are counted daily and cannot double.** One row per
device per location per day, held by a unique index, so re-filing a day
corrects it rather than doubling a denominator and halving every rate that
reads it. `device_days <= patient_days` is a CHECK. A period with no device
days comes back `unanswerable` rather than as a rate of zero, because "no
ventilated patients this month" and "no infections among our ventilated
patients" are opposite facts. The period is read by calendar day for the
denominator, which is a fix rather than a nicety: comparing a midnight census
against a period that starts at half past two dropped that day's device days
while keeping its infections, and inflated the rate by however the caller's
clock happened to fall.

**The bed board carries the precaution and never the reason.** `BoardEntry` is
a value with no reason field, the proto message has none, and the mapping
function has nothing that could fill one. A board is a screen on a wall that
visitors and contractors walk past; what a nurse needs outside a bay is the
precaution, the PPE and whether a side room is required. The reason is a
diagnosis and stays in the isolation record, which infection control reads.
`ipc.board.read` is its own permission, held by every nurse and clinician,
separate from `ipc.record.read`.

**Alert rules, stewardship triggers and environmental limits are versioned by
(code, revision) and superseded rather than edited.** Every alert, review and
result pins the revision it was judged under. A rule edited in place would
make every past alert unexplainable; a limit loosened after a bad quarter
would turn past failures into passes and the water would look as though it had
improved. Each is approved by somebody other than its author — refused in the
domain and by a database CHECK, so holding `ipc.rule.approve` is necessary and
not sufficient.

**A hand hygiene observation has no column, no field and no parameter naming
the person observed.** Not a nullable one: a test reads
`information_schema.columns` and fails if any column of
`infection.hygiene_observation` could hold one, so a future screen cannot
start populating it and a future report cannot start grouping by it. An audit
that names individuals becomes a disciplinary instrument, and the moment it
does, observed compliance goes to ninety-nine per cent and stops meaning
anything. Groups below the configured minimum come back suppressed *with their
counts blanked*, because "four opportunities, one performed" against a night
shift names somebody by arithmetic. Gloves worn instead of cleaning hands is
counted apart from a plain miss: it is the commonest failure and the training
that fixes it is different.

**An occupational exposure is restricted by construction.**
`infection.exposure` carries `restricted boolean NOT NULL DEFAULT true CHECK
(restricted)` — an unrestricted row is not a configuration choice but a
mistake, so it cannot be written. Reading one needs `ipc.exposure.manage`,
held by occupational health alone, and every read (single or list) is written
to the audit trail before it is returned. A staff health record that can be
read without a trace is restricted in name only, and a hospital whose exposure
records are readable by the ward is one whose staff stop reporting exposures.
The follow-up clocks run from the exposure rather than from the report: a
member of staff who waited a day has a day less of prophylaxis window, not a
fresh seventy-two hours.

**A stewardship review cannot change a prescription, at four levels.** The
port that reads therapy has no write on it; the review table has no column an
order is written from; the proto message carries an order reference and
nothing else; and the end-to-end test raises a review against a live
prescription and then re-reads it to assert the status, route and version are
untouched. `responded_by <> reviewed_by` is a CHECK and the permissions split
it too — a pharmacist holds `ipc.stewardship.review` and not
`ipc.stewardship.respond`, a clinician the reverse. Acceptance rate is the one
number a stewardship programme is judged on, and a programme that could close
its own advice as accepted would be writing it. Advice taken in part counts as
neither accepted nor refused.

**A failing environmental result closes only through a verified corrective
action.** Verified means a repeat sample of the same point, taken after the
work, that passed — each of those is a way a hospital otherwise ends up with
three years of "flushed and cleared" against one outlet. The result's outcome
is derived from the limit in force when it was reported, never typed, and a
sample with no live limit is `unassessable` rather than a pass.

**The computed rates are filed against the quality context's dictionary, not a
second one.** SRS-IPC-010 requires versioned metric definitions and
SRS-QMS-010 already versions them. An indicator code with no current
definition is refused rather than defined from this side: a rate filed against
an indicator nobody wrote down is the thing the requirement exists to prevent.

| Requirement | What it asks | State |
|---|---|---|
| SRS-IPC-001 | Create infection surveillance case linked to patient, encounter, organism/site and onset classification; case retains criteria and reviewer | **Implemented** — the classification is derived from the dates and the configured window and appears on no request message; an override is a separate column with its own permission, a mandatory reason and its own audit entry and event; a device-associated site with no device in situ is refused; confirming or refuting requires the criteria and names the reviewer, held by a database CHECK |
| SRS-IPC-002 | Track device-associated denominators using device days where configured; rates are reproducible | **Implemented** — one census row per device per location per day, unique index and all; more device days than patient days is refused; the numerator counts confirmed healthcare-associated cases only; the rate is integer tenths per 1000 device days and utilisation is reported beside it, so a rate falling because the ward stopped using the device is distinguishable from one falling because it got safer |
| SRS-IPC-003 | Record isolation requirement and precautions; boards show the appropriate precaution to authorized staff | **Implemented** — the board value carries precaution, PPE and side-room need and has no field for the reason; `ipc.board.read` is separate from the record permission and held ward-wide; precautions carry a review date and lifting them needs a reason, held by a CHECK |
| SRS-IPC-004 | Alert on configured MDRO/history at relevant encounters; alert uses the current approved rule and override is audited | **Implemented** — rules are versioned by (code, revision), approved by somebody other than the author, and superseded on approval so two cannot be live at once; an alert pins the revision it fired under and refuses a positive outside the rule's lookback; an override needs a reason, names who made it, is audited, and never exempts the patient from the next encounter |
| SRS-IPC-005 | Manage outbreak cluster investigation with affected patients/locations/time window; membership and actions traceable | **Implemented** — membership is a row per decision rather than a list, and whether a case meets the definition is computed from the investigation: adding one that does not and removing one that does both have to say why; declaring escalates durably; a declared outbreak cannot close having changed nothing, which is what "refuted" is for |
| SRS-IPC-006 | Track hand hygiene observations and compliance; reports aggregate by location/period without exposing unnecessary identity | **Implemented** — the observation record has no person identifier at any layer, asserted against `information_schema`; the observer is named and the observed never are; small groups are suppressed with their counts; gloves-instead-of is counted apart from a miss |
| SRS-IPC-007 | Track needlestick/occupational exposure workflow with restricted health access; exposure case has time-sensitive tasks | **Implemented** — the row is restricted by CHECK rather than by configuration; reading needs occupational health's own permission and every read is audited; the steps are derived from the exposure and their deadlines run from it, so a late report has a shorter window rather than a fresh one; a source patient named without recorded consent is refused; an exposure cannot close while a step is still inside its window, and can close over one that has expired so late cases do not stay open for ever |
| SRS-IPC-008 | Support antimicrobial stewardship review triggers from cultures/antibiotics/rules; review appears in the worklist without autonomous medication change | **Implemented** — six trigger kinds, versioned and approved like the alert rules; the therapy port reads and cannot write, the review table has no column an order is written from, and the end-to-end test asserts the prescription is byte-for-byte unchanged after advice; the reviewer cannot record the prescriber's response, in the permissions, the domain and the schema; a re-evaluation does not raise the same review twice, held by a partial unique index |
| SRS-IPC-009 | Record environmental surveillance and water/air testing where used; results link to location and corrective action | **Implemented** — location and sample point are both required, because a ward's forty taps do not fail together; the outcome is derived from the versioned limit in force when the result was reported and the revision is pinned to the result; a failing result closes only through a corrective action verified by a repeat of the same point, taken after the work, that passed; sampling plans give a due list in which a point nobody has ever sampled appears immediately |
| SRS-IPC-010 | Report HAI rates, outbreak status, isolation occupancy and stewardship indicators; metric definitions are versioned | **Implemented** — rates, hand hygiene compliance and stewardship acceptance are filed against the quality context's versioned indicator dictionary (SRS-QMS-010) rather than a second one here, and a code with no current definition is refused; every measure carries an `unanswerable` flag rather than reporting zero on an empty denominator; onset overrides are counted beside the rate they changed |

### What SRS-IPC does not reach

Four seams are named rather than half-built.

**There is no laboratory context, so the culture-driven triggers never fire.**
`TherapySignal.Culture` is nil, which means the bug-drug mismatch and
de-escalation rules — two of the six, and the two a microbiologist would call
the most valuable — are written, tested in the domain, and never triggered by
the running system. This is visible rather than hidden: a worklist with only
duration, restricted-agent and route reviews on it is what a deployment sees,
not a stewardship programme that quietly believes every organism is
susceptible. SRS-LAB is a later wave, and one adapter closes this.

**Whether a patient can take oral is a ward assessment nothing here can
answer.** `OralRouteAvailable` is false, so the intravenous-to-oral trigger
fires only when something else sets it. Defaulting it true would raise a
switch review on every patient who is nil by mouth, which is how a worklist
becomes an unread one.

**There is no estates role.** `ipc.environment.act` — raising and verifying
environmental corrective actions — sits with the infection control lead
because this system has no facilities role to give it to yet. The action names
its owner, so the work is tracked to a person; what is missing is the role the
person should be logging in as. SRS-FAC is in this wave's support services and
will take it.

**Days of therapy count the agents this programme reviewed, not every
antimicrobial in the hospital.** The therapy rate divides raised reviews by
patient days, which is honest about what it measures and is not the
conventional DOT metric. A true DOT denominator needs every antimicrobial
administration, which is the medication context's to expose and the laboratory
gap's neighbour.

## SRS-MRD — Medical records and health information management

Ten requirements, Phase 2 §11. Seventeen tables in schema `records`, fifty
RPCs, and twenty-four permissions — held by three records roles (`him_officer`,
`him_manager`, `clinical_coder`), with clinicians and nurses holding only the
two they answer for: resolving a deficiency against their own documentation
and, for a clinician, signing a statutory certificate. Fifty database rules
and eight separation-of-duties rules were each individually weakened and
confirmed to fail a test before being trusted.

**The defining property of this context is what it cannot do.** It knows
which clinical documents exist, who signed them and when; it records what is
missing, what was coded, what was released and what may be destroyed. It
holds no field that could carry clinical narrative and no port that could
write one. SRS-MRD-003's "coder changes retain provenance and do not rewrite
clinical text" and SRS-MRD-008's "resolved without altering signed history"
are properties of the interface list rather than checks somebody could
remove: there is no `ChartDocuments.Write`, and `Deficiency.Resolve` refuses
a resolution that points back at the document complained about.

**Every decision that makes something disappear or leave the hospital has a
second person behind it, and holding the permission is never sufficient.**
The records office raises deficiencies and cannot waive them, requests
releases and cannot approve them, prepares a disposition list and cannot
approve it. The manager who approves the list cannot execute it, because the
person who signs and the person who shreds are not the same person in any
records office that has been audited. The domain and the database each refuse
a rule approved by its own author, so a manager holding both write and
approve still needs a colleague.

| Requirement | Summary | Status |
|---|---|---|
| SRS-MRD-001 | Track medical record completion against configured checklists by encounter type; checklist version recorded | **Implemented** — checklists are versioned by (code, revision), approved by somebody other than the author and superseded on approval so a chart is judged against exactly one; the more specific of specialty and class wins, then recency; gaps are derived from the clinical context's own documents through a read-only port rather than a copy, and an end-to-end test signs a note and watches the gap close; a missing document and an unsigned one are distinct gaps because they go to different people; an encounter class with no approved checklist is refused rather than reported as a complete chart |
| SRS-MRD-002 | Manage deficiency assignment, notification, escalation and aging reports | **Implemented** — deficiencies are derived from the checklist in force and idempotent against what is open, so a sweep that runs twice raises nothing the second time; a missing document is owed by whoever the encounter made responsible; reassignment does not reset the age, so passing a deficiency on is not the fastest way to clear a worklist; escalation is durable, goes above the owner and fires once; a waiver makes an encounter incompletable and never complete, so a hospital cannot reach a hundred per cent by waiving |
| SRS-MRD-003 | Support clinical coding workflow with code assignment, validation, query to clinician and coder productivity | **Implemented** — append-only revisions, so "what did we submit" stays answerable after a re-code; one principal diagnosis, present-on-admission required on a diagnosis and forbidden on a procedure, both held by database CHECKs; a code's system and edition are required and checked against the deployment's configured terminologies, because a grouper reading the wrong edition returns a number rather than an error; the second read is a second person, refused by the domain and by a CHECK; a query is a deficiency sent to the clinician and a queried episode cannot be finalised; `Diff` answers what a payer actually asks |
| SRS-MRD-004 | Manage release of information with authorization, purpose, recipient and scope; disclosure log is maintained | **Implemented** — the four are required and none defaults; the authority is re-checked at approval and again at release, because a consent that expired in between authorises nothing; the approver is never the requester; the package is built only from what the approved scope covers and restricted kinds stay behind unless the scope asked for them; the manifest is hashed and retained item by item, so "what exactly did we send" has one answer a year later; the disclosure is filed in the same transaction as the release |
| SRS-MRD-005 | Enforce retention and legal hold; held records are excluded from retention deletion | **Implemented** — holds go through the platform's own mechanism, the same one SRS-QMS-015 and SRS-DAT use, because a hold placed in one place with a purge that reads another is a hold that does nothing; the hold check runs before the rule lookup, so a held record in a class nobody wrote a rule for is still excluded and the two reasons do not mask each other; held records are excluded before the list is shown to anybody rather than at the point of destruction, because a list containing them is a list somebody approves; the holds are read again inside the execution transaction and any new one fails the whole list |
| SRS-MRD-006 | Track physical record location/movement where legacy paper records exist | **Implemented** — one named custodian, never a department, held by a CHECK; a record already out cannot go out again, because two answers to "who has it" is the same as none; a filed record is with nobody, also a CHECK; a missing record escalates durably rather than queueing; destruction requires the disposition list that allowed it, and an executed list moves its paper volumes so a shredded record does not still read as filed |
| SRS-MRD-007 | Generate statutory certificates (birth/death) per local format with issuer details | **Implemented** — forms are configured per jurisdiction and versioned, because a registrar's fields differ between states and a group operating in two needs two forms; a certificate is refused against a form nobody approved, against an issuer whose role the form does not name, with a required field missing or a field the form does not have; a correction adds a version and the one that went to the family and the registrar stays readable; the statutory serial is unique across certificates and shared across a certificate's own versions, which is the way round a registrar means it |
| SRS-MRD-008 | Ensure amendments/addenda do not alter signed content; deficiencies resolved without altering signed history | **Implemented** — structural rather than checked. `Resolve` refuses a resolution whose answering document is the document complained about, and `signed_history_is_answered_not_altered` holds the same rule at the table; this context has no port that writes a clinical document, so there is nothing here that could alter one whatever a caller asked; the end-to-end test raises a coding query against a signed note, answers it with an addendum, and asserts the signed note is on the same version afterwards |
| SRS-MRD-009 | Support record destruction workflow with approvals and certificates of destruction | **Implemented** — rules are versioned, approved by somebody else and pinned onto each candidate, so a rule revised afterwards does not change the answer to "what allowed this"; zero years with a disposing kind is refused, because that destroys on the anchor date; the sweep reports every record it passed over and why, because "why is this still here" is the question a records manager is actually asked; prepare, approve and execute are three permissions and the middle one is held by somebody who holds neither of the others |
| SRS-MRD-010 | Maintain accounting of disclosures accessible to patients with actor, purpose, scope and recipient | **Implemented** — all four are NOT NULL with CHECKs against the empty string, so a disclosure that cannot answer the question cannot be written; the table is append-only (FIT-08); exports and prints are recorded through the same accounting as posted copies, because a patient asking who has seen their record is not asking only about the records office; reading the accounting needs its own permission and every read is itself audited, since an accounting of disclosures that can be read without a trace has a hole in exactly the shape of the thing it exists to record |

### What SRS-MRD does not reach

Four seams are named rather than half-built.

**There is no electronic record inventory, so a disposition sweep covers the
paper and nothing else.** `RecordInventory` is a port with one adapter, and
that adapter lists the physical volumes this context owns. The electronic
records belong to every other context, and a deployment that wants them swept
supplies an adapter that knows where they are. A sweep reports what it looked
at, so an empty result from an empty inventory is distinguishable from an
empty result from a full one — but a records manager reading a disposition
list today is reading a list of paper. Closing this is one adapter per
context, not a change here.

**A paper folder's only anchor is when it was registered.** The retention
rules support discharge, last contact, death, majority and creation, and the
paper inventory can answer only the last. A rule anchored to death reports
every paper volume as having no anchor date, which is visible in the sweep's
own output rather than silently treated as not due. The same inventory
adapter closes this.

**The accounting of disclosures records what this context was told about.**
`RecordDisclosure` exists and takes an export or a print, and nothing outside
this context calls it. A patient asking who has seen their record is answered
for every posted copy and for anything the records office logged, and not for
a ward that printed a summary through the clinical viewer. The mechanism is
here and the callers are not; closing it is one call per context that renders
or exports a record, and until those exist the accounting understates itself
by however much the rest of the hospital prints.

**The encounter's visit type stands in for a specialty.** `ChecklistFor`
prefers a specialty-specific checklist over a general one, and the encounter
context does not carry a specialty; the adapter passes the visit type, which
is the nearest thing it holds. A deployment whose checklists vary by
specialty gets the general one, which asks for more documents rather than
fewer — the safe direction, and named here rather than presented as working.

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
