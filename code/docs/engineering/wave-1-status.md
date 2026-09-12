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

**Facility commissioning did not provision an MRN sequence.** *Closed in
Sprint 2A.* Registration used to refuse with `ORG_SEQUENCE_NOT_CONFIGURED`
until a tenant configured a sequence for the facility, which meant a freshly
created facility could not register a patient and the tests had to configure
one explicitly. Commissioning now provisions a per-facility sequence in the
same transaction as the facility row, prefixed with the facility code and
padded to `DefaultMRNPadWidth`. It is `ON CONFLICT DO NOTHING`, so
re-commissioning a code that once existed cannot reset a live counter and
re-issue an MRN already printed on a wristband. The test scaffolding that
stood in for this is deleted, and
`TestCommissioningAFacilityProvisionsItsMRNSequence` asserts the production
path instead.

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

## Sprint 2 — identifiers, reconciliation and correction

| Requirement | What it asks for | State |
|---|---|---|
| SRS-EMPI-010 | Patient photo with consent/configuration; never the sole identity proof | Not started |
| SRS-EMPI-011 | Link ABHA and other external identifiers through an adapter, not as primary keys; link/unlink history and source retained | **Implemented** |
| SRS-EMPI-012 | Demographic conflict from external sources routed to reconciliation, never a silent overwrite | **Implemented** |
| SRS-EMPI-013 | Communication and privacy preferences distinct from clinical consent | **Implemented** in Sprint 1C; notification-service consumption arrives with SRS-NTF |
| SRS-EMPI-014 | Sensitive demographic fields with configured field-level access; masked and audited | Partial — masking and audited reads exist; the *configured* per-field policy does not |
| SRS-EMPI-015 | Temporary/unknown patient registration for emergency use, reconciled later | Partial — `candidate` status and `ConfirmIdentity` exist; unidentified registration does not |
| SRS-EMPI-016 | Prevent duplicate MRN assignment under concurrent registration | **Implemented** |
| SRS-EMPI-017 | Data correction request workflow retaining prior value and provenance | **Implemented** |
| SRS-EMPI-018 | `patient.created`, `patient.demographics_updated`, `patient.merged`, `patient.deceased`, carrying only necessary metadata | **Implemented** |

### What the identifier lifecycle enforces

- **Verification is a seam, not a vendor.** `ports.IdentifierRegistry` is one
  interface: a system name and a `Verify`. ADR-003's reasoning applies again —
  ABDM is one of several national schemes this system will meet, the others are
  not specified, and binding the application layer to any of their SDKs now
  would make the second one a rewrite rather than an adapter. The development
  registry refuses to construct without an explicit opt-in, like `devauth`, so
  a production build cannot reach it through configuration drift.

- **Asserted and verified are different evidence.** "A clerk typed this ABHA
  number" and "ABDM confirmed it belongs to this person" are the same value
  with very different weight. Storing only the value loses the difference, and
  the difference is what SRS-EMPI-010 will rely on when it requires a
  configured *positive* identifier. Deliberately two states rather than a
  numeric score: two asserted identifiers do not add up to a verified one.

- **An outage is not a refusal.** A national identifier service being down must
  not stop a hospital admitting patients, so the identifier links as asserted
  and the response says the authority was unreachable. A caller that cannot
  accept an unverified national identifier sets `require_verification` and gets
  a refusal instead. Collapsing the two would make an outage either a stream of
  rejected registrations or a silent mass downgrade.

- **Nothing is deleted.** SRS-EMPI-011 retains link and unlink history, and
  there is no delete on the port or the table. A wrong link is found months
  later by a clinician reading a chart that does not match the patient; what
  makes it investigable is the row saying who claimed it, when, and on what
  basis.

- **Superseded and revoked differ in one way that matters.** A superseded value
  still resolves — it is on a discharge summary printed last week. A revoked one
  does not, because it belongs to somebody else. That single distinction is why
  there are two states rather than one "inactive", and the caller chooses
  explicitly rather than having it inferred.

- **The MRN is not linkable from outside.** It is issued from the facility's
  sequence; accepting one from a caller would let a client pick a value the
  sequence has not reached, and the next issue would collide.

- **A refusal does not name the holder.** Linking an identifier already held
  elsewhere is refused without saying by whom. The caller asked about a value,
  not about that patient, and confirming who holds a national identifier to
  anybody who can guess one is a disclosure.

- **Events carry metadata, not demographics.** An event stream is read by more
  systems, by more people and under fewer controls than the record it
  describes. `TestNoPatientEventCarriesDemographics` checks every
  `patient.*` payload written for a tenant, not the ones the test thought to
  look at.

### What reconciliation and correction enforce

SRS-EMPI-012 and SRS-EMPI-017 are one model, because they prevent the same
failure from two directions: a demographic value replaced by one nobody checked,
with nothing left recording what it used to say. For SRS-EMPI-012 the
replacement comes from a machine; for SRS-EMPI-017, from a person.

- **A feed never writes.** `SubmitExternalDemographics` compares and raises a
  proposal; there is no path from it to the patient row. A feed that can
  overwrite demographics will eventually overwrite the right value with the
  wrong one, and nothing will record what was lost.

- **Both sides are held together.** The proposal stores what was on file *at the
  time it was raised*, not a value re-read at review time. The reviewer has to
  see the comparison the proposer saw; a value re-read later may have changed
  for an unrelated reason and would make the proposal read as something else.

- **Per field, not per submission.** A registry that agrees on the name and
  disagrees on the birth date is offering one correction and one conflict, and a
  reviewer must be able to take the first without the second.

- **Agreement is not work.** A source that matches raises nothing, and a
  reformatted phone number is not a disagreement — `SameContactValue` is shared
  with the matcher precisely so the two cannot drift. A queue that fills with
  items no human should have been asked about is a queue a reviewer stops
  reading, and that is how a real conflict gets waved through.

- **A repeat is one item.** A nightly feed that keeps disagreeing refreshes its
  one open proposal rather than adding another, enforced by a partial unique
  index on `(tenant_id, patient_id, source) WHERE status = 'open'`.

- **A stale comparison is refused, then closed.** If the record moved after a
  proposal was raised, accepting would overwrite a value nobody compared against
  — the silent overwrite this requirement exists to prevent, arriving through
  the mechanism meant to prevent it. Any write to the record supersedes the open
  proposals it invalidates, so nobody is shown the stale comparison twice.

- **Rejections are kept.** That a value was offered and refused, by whom and
  why, is the answer when the same feed sends it a third time. Refusing
  everything requires a note for the same reason.

- **Asking and deciding are different acts.** Raising a correction request needs
  only read access — the person asking is often the patient — while deciding one
  needs the permission to change demographics, because that is what a decision
  does. Withdrawing is the requester's; rejecting is the reviewer's, and the two
  say different things about who decided the record is correct.

- **An accepted change takes the ordinary path.** Applying a proposal goes
  through `Patient.UpdateDemographics`, so the demographic policy still holds and
  a changed legal name still opens a history window with the source recorded
  (SRS-EMPI-007). Writing columns directly would let a proposal do what a clerk
  cannot.

### Sprint 2 evidence

| Property | Test |
|---|---|
| A development registry is off unless explicitly enabled | `TestADevelopmentRegistryIsOffUnlessEnabled` |
| One identifier system cannot have two registries | `TestARegistrySystemCannotBeClaimedTwice` |
| No registry configured still links, as asserted | `TestAnIdentifierLinksAsAssertedWhenNoRegistryIsConfigured` |
| A verified identifier records who confirmed it and when | `TestAVerifiedIdentifierRecordsWhoConfirmedItAndWhen` |
| An unrecognised value is refused when verification is required | `TestAnUnrecognisedIdentifierIsRefusedWhenVerificationIsRequired` |
| A registry outage does not block admission | `TestARegistryOutageDoesNotBlockLinking` |
| Requiring verification refuses during an outage, distinguishably | `TestRequiringVerificationRefusesDuringAnOutage` |
| An asserted identifier is verified later without losing its history | `TestAnAssertedIdentifierCanBeVerifiedLater` |
| Unlinking retains the row, its reason and its source | `TestUnlinkingRetainsTheIdentifierAndItsReason` |
| A revoked identifier stops resolving but stays on file | `TestARevokedIdentifierStopsResolvingButIsStillOnFile` |
| An MRN cannot be supplied by a caller | `TestAnMRNCannotBeLinkedFromOutside` |
| One identifier cannot be linked to two patients, and the refusal names nobody | `TestAnIdentifierCannotBeLinkedToTwoPatients` |
| Linking needs more than read access | `TestLinkingAnIdentifierNeedsMoreThanReadAccess` |
| Unlinking needs a reason; linking needs a source | `TestUnlinkingNeedsAReason`, `TestLinkingNeedsASource` |
| An identifier cannot be reached across a tenant boundary | `TestAnIdentifierCannotBeUnlinkedFromAnotherTenant` |
| A newly commissioned facility can register immediately | `TestCommissioningAFacilityProvisionsItsMRNSequence` |
| Re-provisioning does not reset a live MRN counter | `TestReprovisioningDoesNotResetALiveMRNSequence` |
| No patient event carries demographics | `TestNoPatientEventCarriesDemographics` |
| An external source cannot overwrite the record | `TestAnExternalSourceCannotOverwriteTheRecord` |
| A source that agrees raises no work | `TestASourceThatAgreesRaisesNothing` |
| A repeated disagreement is one queue item, not thirty | `TestARepeatedDisagreementRefreshesOneProposal` |
| A reviewer takes one field and refuses another | `TestAReviewerTakesOneFieldAndRefusesAnother` |
| An accepted name change opens a history window | `TestAnAcceptedNameChangeOpensAHistoryWindow` |
| A rejection is kept with its reason and its decider | `TestARejectionIsKeptWithItsReason` |
| Rejecting everything needs a note | `TestRejectingEverythingNeedsANote`, `TestRejectingEverythingNeedsANoteOverTheWire` |
| A proposal cannot be applied after the record moved | `TestAProposalCannotBeAppliedAfterTheRecordMoved`, `TestAProposalIsStaleWhenTheRecordMoved` |
| A correction can be requested without the authority to apply it | `TestACorrectionCanBeRequestedWithoutTheAuthorityToApplyIt` |
| A correction request states a reason | `TestACorrectionRequestNeedsAReason`, `TestACorrectionRequestNeedsAReasonOverTheWire` |
| Only the requester may withdraw | `TestOnlyTheRequesterMayWithdraw` |
| Verifying an identifier raises a conflict rather than applying it | `TestVerifyingAnIdentifierRaisesADemographicConflict` |
| Submitting a feed needs more than read access | `TestSubmittingAFeedNeedsMoreThanReadAccess` |
| A proposal cannot be reached across a tenant boundary | `TestAProposalCannotBeResolvedFromAnotherTenant` |
| Formatting and precision are not conflicts | `TestFormattingIsNotAConflict`, `TestALessPreciseDateIsStillReportedButNotAsTheSameValue` |
| An estimated date is never read as a stated one | `TestAnEstimatedDateIsMarkedAsEstimated` |
| sqlc sees every migration | `TestSqlcSeesEveryMigration` |

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
