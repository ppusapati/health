# Wave 1 — implementation status

Wave 1 owns **130 requirements** across SRS-EMPI, SRS-SCH, SRS-ENC, SRS-CLN,
SRS-NUR, SRS-ORD, SRS-MED and SRS-BIL, delivered as a vertical slice: patient →
appointment → encounter → clinical/order/medication → billing.

The same standard as Wave 0 applies: nothing here is claimed as RTM `Verified`.
What this records is which requirements have working, tested implementations.

## Sprint plan

| Sprint | Scope | Requirements | State |
|---|---|---|---|
| 1 | EMPI foundation | SRS-EMPI-001 … 009 | **In progress** — 001–006 implemented |
| 2 | EMPI completion | SRS-EMPI-010 … 018 | Not started |
| 3 | Scheduling | SRS-SCH-001 … 016 | Not started |
| 4 | Encounter, clinical, nursing | SRS-ENC/CLN/NUR | Not started |
| 5 | Orders, medication, billing | SRS-ORD/MED/BIL | Not started |

## Sprint 1 — patient identity

| Requirement | What it asks for | State |
|---|---|---|
| SRS-EMPI-001 | Create a patient with the demographic minimum set configured by jurisdiction/facility; MRN per facility policy | **Implemented** |
| SRS-EMPI-002 | Immutable internal `patient_id`, separate from MRN and external identifiers | **Implemented** |
| SRS-EMPI-003 | Search before create, exact and fuzzy, duplicates shown with confidence and protected fields masked by role | **Implemented** |
| SRS-EMPI-004 | Configurable duplicate confidence routing to auto-clear / warning / manual review, no unsafe auto-merge | **Implemented** |
| SRS-EMPI-005 | Merge only through a reviewed workflow | **Implemented** |
| SRS-EMPI-006 | Controlled unmerge from the merge journal | **Implemented** |
| SRS-EMPI-007 | Aliases, prior names, multiple contacts, effective-dated | **Implemented** |
| SRS-EMPI-008 | Deceased status with date and source, restricting routine scheduling | **Implemented**; the identity half. Scheduling reads `accepts_routine_scheduling` and decides warn-or-block with SRS-SCH |
| SRS-EMPI-009 | Guardian/caregiver relationships with authority and expiry | **Implemented** |

### Decisions taken against the backlog

Two rows in the Wave-1 Executable Feature Backlog were not implemented as
written. Both are recorded here rather than silently followed or silently
ignored.

**SRS-EMPI-005 is listed under the `empi.read` permission.** Merging fuses two
people's records into one chart; it is the most destructive action in this
context. Behind a read permission it would be available to every clerk who can
search. Implemented as a distinct `empi.patient.merge` held only by
`him_officer`, matching the requirement's own actor ("Authorized HIM") and the
adjacent SRS-EMPI-006 row, which does say `empi.merge`. Read as a transcription
slip in the backlog. Pinned by `TestOnlyHIMCanMergePatients`.

**Facility commissioning does not provision an MRN sequence.** Registration
refuses with `ORG_SEQUENCE_NOT_CONFIGURED` until a tenant configures one for
the facility. That is deliberate — the format of a number printed on a
wristband for the rest of somebody's life is a hospital's decision, not a
default quietly made for them — but it means a freshly created facility cannot
register a patient. Facility creation should provision a default sequence that
a tenant admin reviews before the first registration. Tracked as a Sprint-2
item; the tests configure it explicitly today.

### What merge and unmerge enforce

- **The scorer routes; a human merges.** There is no outcome that authorises a
  merge, and there is no code path from a score to one. The queue is where
  "thresholds route to manual review" actually routes to.
- **A clerk who waves a duplicate through does not close the question.** Their
  judgement stands — they can see the patient — but the pair goes to HIM,
  because that call was made at a busy desk with somebody waiting.
- **A merge is refused where the evidence says these are different people.**
  Two records holding different national health or government identifiers are
  two people whatever the demographics suggest and whoever clicked merge. The
  refusal says so rather than returning a bare "no".
- **Nothing is deleted.** The losing record keeps its row and points at its
  survivor; its MRN moves across superseded, so a clerk typing the old number
  off a discharge summary reaches the survivor. An identifier the survivor does
  not hold moves across still active, because a merge that loses information is
  not a merge.
- **A recorded death survives the merge and goes back on an unmerge.** Losing
  it would let a deceased patient be scheduled.
- **The journal records what moved, from whom, and what it was.** Re-deriving
  that from current state is impossible once a second merge has touched the
  same identifiers, so an unmerge reads the journal rather than guessing.
- **An unmerge restores the previous status, not "active".** A record that was
  a candidate before the merge is a candidate after it; restoring it as active
  would silently confirm an identity nobody verified.
- **An unsafe unmerge blocks with its reason.** SRS-EMPI-006 is explicit about
  this, and the reason matters: an operator told only "no" goes to the
  database. The conditions are a survivor merged again, a later merge into the
  same survivor, an already-reversed merge — and clinical records written since
  the merge, which is the one that will block in practice and is wired but
  always zero until a clinical context exists.

### What the registration path enforces

- **The internal identifier is unforgeable.** `Patient.id` is unexported with a
  getter and no setter, so `p.id = x` does not compile outside the domain
  package. Merges, corrections and status changes all leave it alone.
- **The demographic minimum is configuration, not a constraint.** A government
  hospital in one state must capture an identifier a private clinic in another
  may not ask for, and an emergency department must register an unconscious
  patient with no name. A `NOT NULL` expresses exactly one of those.
- **A probable duplicate does not register.** Registration comes back with
  candidates and no patient until the caller acknowledges them, which is what
  makes search-before-create a control rather than a courtesy. Only the
  probable band blocks; a warning is shown and stepped past, because refusing
  on every possible duplicate makes a busy desk unable to register twins.
- **Duplicates are masked for the role that sees them.** A clerk comparing
  candidates sees the name and the last four digits of the phone — enough to
  confirm what the patient just read out, not enough to use the screen as a
  directory. HIM, who decides merges, sees the record unmasked.
- **The MRN comes from the platform's numbering sequence.** Its statement takes
  a row lock, which is what makes SRS-EMPI-016 hold under concurrent
  registration. A value minted in this context would not.
- **Reads are audited; search terms are not.** Who looked at a patient record
  is a regulated question. The query is not recorded, because an audit trail
  storing search terms becomes a second copy of the patient index — searchable
  by everyone with audit access and outside every masking rule.

### What the history, deceased and relationship rules enforce

- **A name is an interval, not a field.** Recording a new legal name closes the
  previous window rather than overwriting it, and a partial unique index permits
  exactly one open window per kind. A result addressed to a maiden name needs to
  know the interval that name applied to, and a patient with two open legal
  names or none is a record the database refuses to hold.

- **Search reaches names no longer held.** `SearchPatients` matches the current
  family name *or* any name in the history, and reports which former name
  matched. Finding the row is not sufficient on its own: a maiden-name hit
  scored against the married name reads as near-zero similarity, which a clerk
  correctly interprets as "not this person" — so the score is taken against the
  name that actually matched and the row names it.

- **A preferred name is not the legal name.** Preferred names and aliases are
  separate kinds with their own windows. Recording one leaves the legal record
  and the demographics the matcher reads untouched.

- **Communication preference is deny-by-default and held per purpose.** A
  patient who agreed to appointment reminders by SMS has not agreed to research
  contact by SMS. `PreferenceSet.Permits` answers per channel *and* purpose, and
  an unrecorded combination is a refusal rather than a permission.

- **A death is recorded with its source and withdrawn with a reason.** SRS-EMPI-008
  requires the source because a registry feed can be wrong about the wrong
  patient, and reversing it needs to know what claimed it. A withdrawal is a
  further record, not a deletion: the interval during which the system believed
  the patient dead is the fact that explains a cancelled appointment.

- **The identity context answers the factual half of scheduling.** `Patient`
  carries `accepts_routine_scheduling`. Whether a booking attempt warns or
  blocks is a scheduling decision and belongs to SRS-SCH; putting it here would
  put a scheduling rule in the identity context.

- **Authority requires verification and expires.** An unverified relationship
  holds no authority at all, verification records what document was checked, and
  authority is asked for at a point in time — a guardianship that ended last
  month does not answer yes today. An emergency contact is a person to telephone,
  not a person who may consent, so the database itself refuses to store one
  holding authority.

### Evidence

| Property | Test |
|---|---|
| MRN issued from the facility's sequence, namespaced by facility | `TestRegisteringAPatientIssuesAnMRN` |
| The internal identifier is not the MRN and survives a correction | `TestTheInternalIdentifierIsNotTheMRN`, `TestTheInternalIdentifierCannotBeReassigned` |
| Concurrent registrations get distinct MRNs | `TestConcurrentRegistrationsGetDistinctMRNs` |
| A probable duplicate blocks until acknowledged | `TestAProbableDuplicateBlocksRegistrationUntilAcknowledged` |
| The duplicate outcome carries the candidates and the score breakdown | `TestTheDuplicateRefusalShowsWhatToReview` |
| Protected fields masked for a clerk, unmasked for HIM | `TestDuplicateCandidatesAreMaskedForAClerkAndNotForHIM` |
| Tenant isolation against a fully provisioned neighbour | `TestPatientsAreInvisibleAcrossTenants` |
| Strong identifiers are decisive in both directions | `TestADifferingStrongIdentifierOverridesEveryOtherSignal`, `TestAMatchingStrongIdentifierDominates` |
| No outcome authorises a merge | `TestAnIdenticalRecordScoresAsProbable` |
| Reads audited with purpose-of-use; terms not stored | `TestReadingAPatientIsAudited`, `TestSearchTermsAreNotWrittenToTheAuditTrail` |
| The old MRN resolves to the survivor after a merge | `TestMergingResolvesTheOldMRNToTheSurvivor` |
| The merged record is kept and resolves to its survivor | `TestTheMergedRecordResolvesToItsSurvivor` |
| Merge refused when national identifiers disagree | `TestMergeIsRefusedWhenNationalIdentifiersDisagree`, `TestMergeIsRefusedWhenStrongIdentifiersDisagree` |
| Only HIM may merge | `TestAClerkCannotMerge`, `TestOnlyHIMCanMergePatients` |
| An unmerge restores both records and the MRN | `TestUnmergingRestoresBothRecords` |
| An unsafe unmerge blocks with its reason | `TestUnmergeIsBlockedByALaterMergeIntoTheSameSurvivor`, `TestUnmergeIsBlockedByClinicalRecordsWrittenSinceTheMerge` |
| A merge is reversible exactly once | `TestAMergeCannotBeReversedTwice` |
| An acknowledged duplicate reaches the review queue | `TestAnAcknowledgedDuplicateReachesTheReviewQueue` |
| A dismissal is final and is not reopened by re-detection | `TestDismissingACandidateClosesItForGood` |
| A death survives a merge and returns on an unmerge | `TestADeceasedRecordSurvivesTheMerge`, `TestUnmergeReturnsAnInheritedDeceasedRecord` |
| The journal records what moved and what it was | `TestTheMergeJournalRecordsWhatMoved` |
| Registration opens the name history, so the first rename has something to close | `TestRegistrationOpensTheNameHistory` |
| A prior name stays searchable, and the result says which name matched | `TestRenamingAPatientKeepsThePriorNameSearchable` |
| A current-name hit is not mislabelled as a former name | `TestACurrentNameMatchIsNotReportedAsAFormerName` |
| A preferred name does not overwrite the legal record | `TestAPreferredNameDoesNotChangeTheLegalRecord` |
| Preferences are held per channel and per purpose | `TestCommunicationPreferencesAreHeldPerPurpose` |
| Changing a preference closes the previous window rather than editing it | `TestChangingAPreferenceClosesThePreviousOne` |
| A death stops routine scheduling and needs a named source | `TestRecordingADeathStopsRoutineScheduling`, `TestRecordingADeathNeedsASource` |
| A misrecorded death is withdrawn with a reason, not deleted | `TestAMisrecordedDeathCanBeWithdrawn`, `TestWithdrawingADeathNeedsAReason` |
| Caregiver authority is scoped, verified and expires | `TestCaregiverAuthorityIsScopedVerifiedAndExpiring` |
| Verification records what was checked | `TestVerifyingARelationshipNeedsANote` |
| An emergency contact cannot be given authority | `TestAnEmergencyContactCannotBeGivenAuthority` |
| A relationship cannot name a patient in another tenant | `TestARelationshipCannotNameAPatientInAnotherTenant` |
| History reads are audited | `TestReadingTheHistoryIsAudited` |

Sprint 1 is complete: SRS-EMPI-001 to SRS-EMPI-009 are implemented and
covered by tests.

## Wave-0 capabilities Wave 1 consumes

Sprint 1 wrote no new platform capability. It consumed:

| Capability | Used for |
|---|---|
| Tenant scope (`authctx.TenantScope`) | Every repository call; cross-tenant access does not compile |
| RBAC + ABAC policy engine | Permission, facility scope and purpose-of-use on every use case |
| Numbering sequences (SRS-PLT-014) | MRN issuance, collision-free under concurrency |
| Module entitlements (SRS-PLT-011) | `empi` is refused at the wire for a tenant that has not bought it |
| Transactional outbox | `patient.created` and `patient.demographics_updated` |
| Effective dating (SRS-PLT-013) | Name, preference and relationship windows |
| Append-only audit | Reads, writes and denials |
| Architecture fitness tests | FIT-02 and FIT-03 applied to the new context without modification |

That is the return on Wave 0: a new bounded context is a domain, a schema, a
repository and a service, with the tenant, authorization, audit and event
machinery already there and already enforced.
