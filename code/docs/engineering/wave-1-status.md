# Wave 1 — implementation status

Wave 1 owns **130 requirements** across SRS-EMPI, SRS-SCH, SRS-ENC, SRS-CLN,
SRS-NUR, SRS-ORD, SRS-MED and SRS-BIL, delivered as a vertical slice: patient →
appointment → encounter → clinical/order/medication → billing.

The same standard as Wave 0 applies: nothing here is claimed as RTM `Verified`.
What this records is which requirements have working, tested implementations.

## Sprint plan

| Sprint | Scope | Requirements | State |
|---|---|---|---|
| 1 | EMPI foundation | SRS-EMPI-001 … 009 | **Complete** |
| 2 | EMPI completion | SRS-EMPI-010 … 018 | **Complete** |
| 3 | Scheduling | SRS-SCH-001 … 016 | **In progress** — 001–006, 013–015 implemented |
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

Sprint 2 is complete: SRS-EMPI-010 to SRS-EMPI-018 are implemented and covered
by tests. The EMPI family — all eighteen requirements — is closed.

## Sprint 2 — identifiers, reconciliation and correction

| Requirement | What it asks for | State |
|---|---|---|
| SRS-EMPI-010 | Patient photo with consent/configuration; never the sole identity proof | **Implemented** |
| SRS-EMPI-011 | Link ABHA and other external identifiers through an adapter, not as primary keys; link/unlink history and source retained | **Implemented** |
| SRS-EMPI-012 | Demographic conflict from external sources routed to reconciliation, never a silent overwrite | **Implemented** |
| SRS-EMPI-013 | Communication and privacy preferences distinct from clinical consent | **Implemented** in Sprint 1C; notification-service consumption arrives with SRS-NTF |
| SRS-EMPI-014 | Sensitive demographic fields with configured field-level access; masked and audited | **Implemented** |
| SRS-EMPI-015 | Temporary/unknown patient registration for emergency use, reconciled later | **Implemented** |
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

### What photographs, field access and emergency registration enforce

- **A photograph is evidence a human uses, never evidence the system accepts.**
  The prohibition in SRS-EMPI-010 is not squeamishness about biometrics — a
  nurse glancing at a screen before a transfusion catches a wrong-patient error
  a matching name would not. It is that the failure mode of face comparison is
  systematically worse for the people a hospital is already most likely to
  misidentify: siblings, twins, a photo taken four years and one illness ago,
  and measurably by skin tone and age. A system that lets a photo alone confirm
  identity concentrates its errors on exactly the populations least able to
  contest them. `ConfirmIdentity` requires a *sighted, verified* identifier
  whatever else was checked.

- **An asserted identifier is not positive identification either.** A number
  read off a photocopy carries no more assurance than the photograph does, and
  admitting it would let the prohibition be satisfied by typing. This is what
  the assurance model from Sprint 2A was for.

- **A verified identifier on file is not evidence it was checked.** The caller
  names what was sighted, which keeps confirmation an assertion about what
  happened at the bedside rather than a property of the record.

- **Consent has a shape.** Somebody gave it, at a time, for a stated purpose.
  A boolean records none of that, and "did this patient agree to their
  photograph being kept" is a question somebody will be asked to answer with
  evidence. Withdrawal deletes the bytes and keeps the row: a deletion leaving
  nothing behind would leave nobody able to answer whether a photograph existed.

- **Format is an allowlist.** A blocklist accepts SVG, which is a script
  container, and HTML renamed to `.jpg`.

- **The store is a seam.** Where patient photographs live has real consequences
  — encryption at rest, retention, residency — and none belong in the patient
  index. Keys are generated from `crypto/rand` and tenant-prefixed rather than
  derived from the patient id, so the object name is not itself a patient
  identifier to anybody who can list the bucket. The digest is verified on read:
  a store that silently returned a different object would otherwise be
  indistinguishable from one that returned the right one, and showing a nurse
  the wrong patient's face is the failure the feature exists to prevent.

- **Which fields are sensitive is a tenant decision.** SRS-EMPI-014's operative
  phrase is "where configured". In a clinic treating people whose address is the
  thing that endangers them, the street address is the most restricted field on
  the record; in an outpatient department it is what the receptionist reads back
  to confirm they have the right person. Same field, opposite handling, and no
  default serves both. A policy naming a permission this system has never
  granted restricts the field rather than opening it.

- **The audit says which restricted fields were disclosed**, not merely that
  somebody with the permission opened a record — and never the values, because
  an audit trail holding demographics is a second, less protected copy of them.

- **An unconscious patient is registered immediately, with an MRN.** The
  alternative to registering is not "wait until we know who they are"; it is
  notes on paper that never reach the chart. The MRN is returned with the
  registration because a specimen leaving the room in the next minute has to
  carry it.

- **The temporary label never reaches the name index.** A record whose family
  name is "TRAUMA ALPHA" sorts into that index, fuzzy-matches the next trauma
  patient, and prints on a wristband looking exactly like a name.

- **Chronology is preserved by the identifier never changing.** Identifying an
  hour later is a demographic update, not a data migration, so SRS-EMPI-015's
  "without losing encounter chronology" falls out of SRS-EMPI-002 rather than
  needing machinery of its own. The designation is kept, because an hour of
  records was filed under it.

- **Identification runs the duplicate check registration could not.** A patient
  brought in unconscious very often already has a record here, and this is the
  first moment there is enough to find it.

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
| Identity cannot be confirmed on a photograph alone | `TestAPhotographAloneCannotConfirmIdentity`, `TestIdentityCannotBeConfirmedOnAPhotographAlone` |
| Nor on somebody vouching, nor on an asserted identifier | `TestSomebodyVouchingAloneCannotConfirmIdentity`, `TestAnAssertedIdentifierIsNotPositiveIdentification`, `TestAnAssertedIdentifierDoesNotConfirmIdentityOverTheWire` |
| A sighted verified identifier does confirm it | `TestASightedVerifiedIdentifierConfirmsIdentity`, `TestConfirmingIdentityActivatesTheRecord` |
| An unchecked identifier on file is not evidence | `TestAnUncheckedIdentifierOnFileIsNotEvidence` |
| A photograph is stored with its consent and read back intact | `TestAPhotographIsStoredWithItsConsentAndReadBack` |
| Consent must name who gave it and what for | `TestAPhotographNeedsRecordedConsent`, `TestConsentMustStateItsPurpose`, `TestAPhotographNeedsConsentWithAPurpose` |
| Only photograph formats are stored | `TestOnlyPhotographFormatsAreStored`, `TestOnlyPhotographFormatsAreAccepted` |
| Withdrawal removes the image and keeps the record | `TestWithdrawingConsentKeepsTheRecord`, `TestWithdrawingConsentRemovesTheImageAndKeepsTheRecord` |
| A deployment with no store refuses rather than recording a dangling row | `TestCapturingAPhotographNeedsAConfiguredStore` |
| A photograph cannot be read across a tenant boundary | `TestAPhotographCannotBeReadFromAnotherTenant` |
| Field restrictions follow tenant configuration, not a constant | `TestFieldRestrictionsAreConfigurable`, `TestFieldRestrictionsFollowTenantConfiguration` |
| An unknown permission restricts rather than reveals | `TestAnUnknownPermissionRestrictsRatherThanReveals` |
| A field cannot be restricted behind no permission | `TestAFieldCannotBeRestrictedBehindNoPermission`, `TestAFieldCannotBeConfiguredBehindNoPermission` |
| Configuring field access is a tenant-administration act | `TestConfiguringFieldAccessIsRestricted` |
| A restricted read records which fields were revealed, not their values | `TestARestrictedReadRecordsWhichFieldsWereRevealed`, `TestRevealedFieldsAreReportedForTheAudit` |
| Masking narrows rather than blanks | `TestMaskingNarrowsRatherThanBlanks` |
| An unconscious patient is registered and labelled, with an MRN | `TestAnUnconsciousPatientCanBeRegisteredAndLabelled` |
| The temporary label never becomes a searchable name | `TestTheTemporaryLabelNeverBecomesAName`, `TestATemporaryLabelIsNotSearchableAsAName` |
| An apparent age is an estimated birth date, marked as one | `TestAnApparentAgeBecomesAnEstimatedBirthDate` |
| Identifying keeps the same record, and the emergency MRN still resolves | `TestIdentifyingKeepsTheSameRecord`, `TestIdentifyingAnEmergencyPatientKeepsTheSameRecord` |
| Identification runs the duplicate check registration skipped | `TestIdentifyingRunsTheDuplicateCheckEmergencyRegistrationSkipped` |
| Identification applies the full demographic policy | `TestIdentifyingAppliesTheFullPolicy`, `TestIdentifyingAppliesTheFullDemographicPolicy` |
| Unidentified patients appear on a worklist and leave it | `TestUnidentifiedPatientsAppearOnAWorklistAndLeaveIt` |
| A facility may refuse unidentified registration | `TestAFacilityCanRefuseUnidentifiedRegistration` |
| Enabling emergency registration does not relax routine registration | `TestAllowingEmergencyRegistrationDoesNotRelaxRoutineRegistration` |
| sqlc sees every migration | `TestSqlcSeesEveryMigration` |

### A defect found and fixed in Sprint 2C

`DemographicPolicy.AllowUnidentified` short-circuited `Check` entirely, so a
facility that enabled emergency registration silently dropped the demographic
minimum for **every** routine registration as well. The opposite of what
enabling the flag says, and invisible until the index had filled with records
nothing could match.

The flag now governs only the emergency path, `Check` is always enforced, and
`TestAllowingEmergencyRegistrationDoesNotRelaxRoutineRegistration` holds it.
`DefaultPolicy` now permits emergency registration, which it could not safely do
while the flag had that side effect: a hospital that has configured nothing must
still be able to admit an unconscious patient, because refusing delays care or
pushes it off-record.

## Sprint 3 — scheduling

| Requirement | What it asks for | State |
|---|---|---|
| SRS-SCH-001 | Provider/resource schedules with facility, department, visit type, slot duration, capacity, effective dates | **Implemented** |
| SRS-SCH-002 | Leave/block/meeting/theatre/procedure exceptions; blocked capacity unbookable without override | **Implemented** |
| SRS-SCH-003 | Slot search by specialty, provider, facility, visit type, date range and mode; only bookable capacity, paginated | **Implemented** |
| SRS-SCH-004 | Atomic booking that cannot exceed configured capacity under concurrency | **Implemented** |
| SRS-SCH-005 | Reschedule/cancel with cutoff policy, reason, fee/refund integration; status history retained | **Implemented** |
| SRS-SCH-006 | Waitlist with expiring offers and no duplicate confirmed bookings | **Implemented** |
| SRS-SCH-007 | Check-in with token/queue state, arrival mode | Not started |
| SRS-SCH-008 | Nine queue states; invalid transitions rejected unless authorised correction | Domain and persistence complete; the queue RPCs arrive with 3C |
| SRS-SCH-009 | Wait-time estimate from service rate, queue and provider status | Not started |
| SRS-SCH-010 | Walk-in appointment/queue with reason and prioritisation | Not started |
| SRS-SCH-011 | Medically justified queue reprioritisation, audited and visible | Not started |
| SRS-SCH-012 | Configurable booking/reminder/reschedule/cancellation notifications | Not started |
| SRS-SCH-013 | Recurring appointments and therapy series | **Implemented** |
| SRS-SCH-014 | Prevent booking an inactive provider/resource/facility, with a domain-specific error | **Implemented** |
| SRS-SCH-015 | Teleconsult vs in-person rules driving location/link and eligibility | **Implemented** |
| SRS-SCH-016 | `appointment.booked/rescheduled/cancelled/checked_in/no_show`, idempotent and versioned | Partial — `booked` emitted; the rest arrive with their use cases |

### What availability and booking enforce

- **A roster is a rule; slots are generated.** A materialised diary goes stale
  the instant a roster changes, and the stale entries are indistinguishable from
  the good ones: a patient books a Tuesday that no longer exists and nobody
  finds out until they arrive. Generating on read makes SRS-SCH-003's criterion
  — "slot search reflects active roster and exceptions" — true by construction
  rather than by a refresh job whose failure nobody notices.

- **Capacity is one statement.** SRS-SCH-004's acceptance criterion is a
  concurrency test, and the only thing that reliably satisfies it is a guarded
  `UPDATE … WHERE booked < capacity RETURNING` taking a row lock — the same
  reasoning as the numbering sequence behind SRS-EMPI-016. A check-then-insert
  is a race two bookings both win, and it fails under load rather than under
  test. A CHECK constraint holds the same invariant in the table, so a
  migration or a future code path that forgets cannot breach it either.
  Fault-injecting the guard makes `TestConcurrentBookingsCannotExceedCapacity`
  fail, which is how we know it is not vacuous.

- **A slot row exists only where capacity is consumed.** Written on first
  booking with `ON CONFLICT DO NOTHING`, so two concurrent first bookings
  converge on one row and the loser does not reset the winner's counter.

- **Leave is not a permission question.** An overridable block — a provisional
  theatre list — is visible to a scheduler and bookable by one. Annual leave is
  neither, whoever asks: the clinician is not there, and an override that could
  conjure them up would be a permission to book a patient in to see nobody.
  The first version of `Available` got this wrong by asking only "is this
  blocked" and not "by what"; the domain test caught it.

- **A slot the client names is regenerated, not trusted.** A caller that could
  supply its own instant and capacity would be defining its own roster, and the
  first symptom would be appointments outside clinic hours.

- **Time is local, stored as instants.** Sessions are built from local midnight
  in the resource's own zone, so a daylight-saving transition moves the whole
  clinic with the clock rather than booking half of it into the wrong hour on
  the two days that matter most.

- **Booking is not roster configuration.** The Wave-1 backlog lists SRS-SCH-004
  under `sch.configure`, which would mean booking an appointment required the
  authority to rewrite the clinic's roster — so every receptionist would hold
  it. Implemented as a distinct `sch.appointment.book`; recorded below as a
  deliberate deviation.

- **Cancelled releases capacity; no-show does not.** The slot was consumed
  whether or not the patient came. Getting this backwards either double-books
  the clinic or leaves a morning of phantom bookings nobody can fill.

### What the appointment lifecycle enforces

- **A reschedule is a new booking chained to the old one.** SRS-SCH-005
  requires the original to retain its status history, so it is cancelled and
  linked rather than edited: a patient disputing an attendance record needs to
  see that the 9th was moved, not that it silently became the 16th. The new slot
  is claimed before the old one is released, so a move that fails leaves the
  patient holding the appointment they had.

- **The notice is captured at the moment of the decision.** A policy changed in
  March must not retroactively make a February cancellation late, so the notice
  given and the notice required are both stored on the outcome rather than
  recomputed from two timestamps when somebody disputes a fee.

- **This system never charges anybody.** It records whether the notice period
  was met and refers the case onward; SRS-BIL owns what it costs. Putting the
  fee here would put pricing in the diary, which is not where a refund gets
  approved. The default policy charges nothing, because billing patients on the
  strength of a setting nobody chose would be wrong.

- **A series change reaches one occurrence or every future one, never a past
  one.** A course stopped after four sessions is four sessions of treatment, and
  a bulk cancellation that rewrote them would rewrite the record of care that
  was given. Settled occurrences are skipped for the same reason.

- **A course books what it can.** Refusing twelve appointments because week
  seven is full would make staff book them one at a time, and the eleventh is
  the one they get wrong. Unavailable occurrences are reported; a course where
  nothing could be booked rolls back rather than leaving an empty series for
  somebody to clean up.

- **A series keeps its local time.** Occurrences advance by days rather than by
  duration, so a course crossing a daylight-saving boundary stays at ten o'clock.
  A patient told "every Tuesday at ten" does not expect the eighth session at
  nine.

- **A waitlist offer does not consume the slot.** An offer is a promise, and a
  promise that held capacity would leave the clinic holding a slot for somebody
  who has stopped reading their messages — capacity nobody can use and nobody
  can see is gone. The claim happens on acceptance, through the ordinary atomic
  path, which is also what stops an offer made twice by mistake producing two
  bookings.

- **Accepting an earlier slot replaces the appointment already held.** That is
  the "cannot create duplicate confirmed bookings" half of SRS-SCH-006, and it
  is why a waitlist entry carries the booking it is waiting to improve on. An
  offer later than that booking is refused: it is a downgrade somebody would
  have to explain.

- **An unanswered offer returns the patient to the list**, rather than closing
  it. Not answering one message is not the same as no longer wanting an
  appointment.

- **Teleconsults are off until a facility enables them.** A facility that has
  not thought about remote consultations has not decided which of its clinics
  can safely run that way, and defaulting to yes decides it for them. A
  teleconsult with no join link is an appointment nobody can attend; an
  in-person one carrying a link invites a patient to stay home, so a database
  constraint refuses it. Minting the link is a port, because it is a credential:
  anybody holding it can join a consultation.

### Sprint 3 evidence

| Property | Test |
|---|---|
| Slot search reflects the roster | `TestSlotSearchReflectsTheRoster`, `TestSlotsAreGeneratedFromTheRoster` |
| An unfiltered search is refused | `TestAnUnfilteredSlotSearchIsRefused` |
| Booking consumes the slot and it stops being offered | `TestBookingConsumesTheSlot` |
| Concurrent bookings cannot exceed capacity | `TestConcurrentBookingsCannotExceedCapacity` |
| A blocked period is neither offered nor bookable | `TestABlockedPeriodIsNotOfferedOrBookable`, `TestAnExceptionRemovesCapacity` |
| Only an overridable block can be overridden | `TestOnlyAnOverridableBlockCanBeOverridden`, `TestANonOverridableExceptionWins` |
| Overriding needs the permission | `TestOverridingNeedsThePermission` |
| A boundary slot is not eaten by an adjacent block | `TestAnExceptionDoesNotEatTheBoundarySlot` |
| A facility closure removes the whole day | `TestAFacilityClosureRemovesTheWholeDay` |
| An inactive resource is refused specifically, and offers nothing | `TestBookingAnInactiveResourceIsRefusedSpecifically`, `TestAnUnavailableResourceReportsWhy` |
| A slot outside the roster cannot be booked | `TestASlotOutsideTheRosterCannotBeBooked` |
| A deceased patient cannot be given a routine appointment | `TestADeceasedPatientCannotBeGivenARoutineAppointment` |
| A clerk cannot rewrite the roster; a clinician cannot book | `TestAClerkCannotRewriteTheRoster`, `TestAClinicianCannotBook` |
| Booking emits an event carrying no clinical or demographic detail | `TestBookingEmitsAnAppointmentBookedEvent` |
| A diary cannot be reached across a tenant boundary | `TestASlotSearchCannotReachAnotherTenant` |
| A cancellation records the notice against the policy in force | `TestCancellingRecordsTheNoticeAgainstThePolicyInForce`, `TestACancellationRecordsTheNoticeGivenAndRequired` |
| The default policy charges nothing; a configured one refers | `TestTheDefaultPolicyChargesNothing`, `TestALateCancellationIsChargeableOnlyWhereConfigured` |
| A completed appointment cannot be cancelled | `TestACompletedAppointmentCannotBeCancelled` |
| A reschedule chains to the original and keeps its history | `TestReschedulingChainsToTheOriginalAndKeepsItsHistory` |
| Reschedules are capped by policy | `TestReschedulingIsCappedByPolicy` |
| A series books what it can and reports the rest | `TestASeriesBooksWhatItCanAndReportsTheRest` |
| A series change reaches only the scope asked, never the past | `TestCancellingASeriesRespectsTheScopeAsked`, `TestASeriesChangeReachesOnlyTheScopeAsked` |
| A bulk series change skips settled occurrences | `TestABulkSeriesChangeSkipsSettledOccurrences` |
| A series keeps its local time across a daylight-saving change | `TestASeriesKeepsItsLocalTimeAcrossADaylightSavingChange` |
| A waitlist offer expires and does not hold the slot | `TestAWaitlistOfferExpiresAndDoesNotHoldTheSlot`, `TestAnOfferExpires` |
| Accepting an offer replaces the existing booking | `TestAcceptingAnOfferReplacesTheExistingBooking` |
| A waitlist will not offer a later slot | `TestAWaitlistWillNotOfferALaterSlot`, `TestAWaitlistOnlyAcceptsAnEarlierSlot` |
| An expired or declined offer returns the patient to the list | `TestAnExpiredOfferReturnsThePatientToTheList`, `TestDecliningKeepsThePatientWaiting` |
| Teleconsults are off until a facility enables them | `TestATeleconsultIsRefusedWhereNotEnabled`, `TestTeleconsultsAreOffByDefault` |
| A teleconsult policy can restrict visit types and require confirmed identity | `TestATeleconsultPolicyCanRestrictVisitTypes`, `TestATeleconsultPolicyCanRequireConfirmedIdentity` |
| An in-person appointment carries no join link | `TestAnInPersonAppointmentCarriesNoJoinLink` |
| A clerk cannot set the cancellation policy | `TestAClerkCannotSetTheCancellationPolicy` |
| The ordinary clinic path is permitted; an invalid sequence is not | `TestTheOrdinaryClinicPathIsPermitted`, `TestAnInvalidSequenceIsRejected` |
| An authorised correction can undo a mistaken no-show, and the no-show survives | `TestACorrectionCanUndoAMistakenNoShow` |
| Cancelled releases capacity; no-show does not | `TestOnlyCancellationReleasesCapacity` |
| A schedule refuses an unusable session | `TestAScheduleRefusesAnUnusableSession` |
| Effective dates are honoured in both directions | `TestAScheduleAppliesOnlyWithinItsEffectiveWindow` |

### Decisions taken against the backlog

**SRS-SCH-004 is listed under the `sch.configure` permission.** Booking an
appointment is what a receptionist does a hundred times a day; rewriting a
clinic's roster is what a scheduler does occasionally and deliberately. Behind
one permission, every receptionist could delete a clinician's Tuesday.
Implemented as a distinct `sch.appointment.book`, with `sch.schedule.configure`
reserved for rosters — the same shape as the SRS-EMPI-005 slip recorded above.
Pinned by `TestAClerkCannotRewriteTheRoster`.

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
