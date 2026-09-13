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
| 3 | Scheduling | SRS-SCH-001 … 016 | **Complete** |
| 4 | Encounter, clinical, nursing | SRS-ENC/CLN/NUR | **In progress** — SRS-ENC complete |
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
| SRS-SCH-007 | Check-in with token/queue state, arrival mode | **Implemented** |
| SRS-SCH-008 | Nine queue states; invalid transitions rejected unless authorised correction | **Implemented** |
| SRS-SCH-009 | Wait-time estimate from service rate, queue and provider status | **Implemented** |
| SRS-SCH-010 | Walk-in appointment/queue with reason and prioritisation | **Implemented** |
| SRS-SCH-011 | Medically justified queue reprioritisation, audited and visible | **Implemented** |
| SRS-SCH-012 | Configurable booking/reminder/reschedule/cancellation notifications | **Implemented** — scheduling records that a message is owed and what came back; sending belongs to SRS-NTF |
| SRS-SCH-013 | Recurring appointments and therapy series | **Implemented** |
| SRS-SCH-014 | Prevent booking an inactive provider/resource/facility, with a domain-specific error | **Implemented** |
| SRS-SCH-015 | Teleconsult vs in-person rules driving location/link and eligibility | **Implemented** |
| SRS-SCH-016 | `appointment.booked/rescheduled/cancelled/checked_in/no_show`, idempotent and versioned | **Implemented** — all five, plus `status_changed` and `reprioritised` |

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

### What the queue enforces

- **Clinical priority is a clinical judgement, never arithmetic.** A five-band
  scale is what triage systems use and what staff can hold in their heads. A
  numeric score would invite arithmetic, and arithmetic on clinical urgency is
  how somebody ends up behind a spreadsheet. The estimate never reorders the
  queue: SRS-SCH-009 is explicit that it "updates without changing clinical
  priority", and a queue that rearranged itself to make its own predictions come
  true would be optimising the wrong thing.
- **A reason for a move is shown, not filed.** SRS-SCH-011 asks for
  reprioritisation to be "audited and visible to queue users", and the second
  half is the one that matters at the desk: the people waiting can see that
  somebody went ahead of them, and a board that shows the move without the
  reason produces the argument the reason exists to prevent. So the reason is on
  the appointment the board renders, as well as in the audit trail.
- **The queue is ordered by arrival, not by appointment time.** Somebody who
  turned up on time for a 09:00 slot has been waiting since 09:00, and an order
  built on booking time would keep putting late arrivals in front of them.
- **A queue number is a number.** SRS-SCH-007 says "token/queue number", and a
  waiting room understands that 014 comes after 013; a board showing "K7QX"
  tells nobody how long they have left. Issued from a per-facility, per-day
  counter advanced by a guarded upsert — the same row-lock primitive as MRN
  issuance — so two clerks checking patients in at the same instant cannot both
  be handed 014. A clinic with its own numbering scheme supplies its own token
  instead.
- **The estimate is observed, and says so.** It comes from consultations that
  actually finished today rather than from the roster: a clinic running twenty
  minutes behind is running twenty minutes behind whatever the diary says. Below
  three finished consultations it falls back to the rostered slot length and
  reports `observed: false`, because one is an anecdote and two is a
  coincidence. The arithmetic travels with the number — patients ahead, service
  rate, clinicians working — so a display can say "about forty minutes, based on
  four ahead and ten minutes each", which a person can judge, rather than "about
  forty minutes", which they can only believe or disbelieve.
- **A walk-in is an ordinary appointment.** SRS-SCH-010's criterion is that it
  is "linked to same encounter creation flow". A parallel lightweight record
  would be a second thing every downstream context has to know about, and the
  first one to forget would drop walk-ins from a report. It holds no rostered
  slot, because by definition nobody set time aside: consuming one somebody else
  booked would turn an unscheduled arrival into a cancelled appointment for a
  patient who did nothing wrong.
- **The correction escape hatch is a permission of its own.** A state machine
  with no escape hatch gets worked around, and the workaround is worse than the
  hole: a clerk who marked the wrong patient as a no-show will otherwise cancel
  the real appointment and book a new one, destroying the chronology the record
  existed to keep. So corrections are permitted, named as corrections, carry a
  reason, and need `sch.appointment.correct` — which a clerk working the queue
  does not hold.
- **Scheduling records notifications; it does not send them.** Channels,
  templates, retries, opt-outs and quiet hours belong to a notification service
  (SRS-NTF); a booking screen waiting on an SMS gateway is a booking screen that
  times out. What this context does is decide a message is owed, ask the patient
  index whether the patient agreed to hear about it, and record what came back —
  which is SRS-SCH-012's acceptance criterion, and the thing that distinguishes
  a patient who says they were never told from one who was.
- **An unrecorded consent is a refusal.** SRS-EMPI-013 holds communication
  preference per channel *and* per purpose, and scheduling reads it through a
  port rather than keeping a copy that drifts. A patient who has agreed to
  nothing has their messages recorded as suppressed, with the reason, rather
  than silently skipped: "we did not tell them, and here is why" is an answer a
  desk can give; silence is not.
- **A waitlist offer is a notification about an offer, not about a booking.**
  There is no appointment yet, and its delivery outcome is the one that matters
  most — an offer nobody received expires against a patient who never had the
  chance to answer. So a notification names exactly one subject, an appointment
  or a waiting-list entry, enforced by a database constraint.

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
| Checking in issues a queue number and records the arrival mode | `TestCheckingInIssuesAQueueNumber`, `TestCheckingInIssuesATokenAndRecordsArrival` |
| Queue numbers are unique per facility per day | `TestQueueNumbersAreUniquePerFacilityPerDay` |
| A check-in above standard priority states why, and nobody checks in twice | `TestANonStandardPriorityNeedsAReasonAtTheDoor`, `TestAPatientCannotCheckInTwice`, `TestCheckingInNeedsAToken` |
| The queue state machine refuses an impossible jump | `TestTheQueueStateMachineRefusesAnImpossibleJump` |
| A correction needs its own permission and a reason | `TestACorrectionNeedsItsOwnPermissionAndAReason` |
| The queue is ordered by priority, then by arrival | `TestTheQueueIsOrderedByPriorityThenArrival`, `TestTheQueueOrdersByPriorityThenArrival` |
| The queue holds only waiting patients, and the estimate grows down it | `TestTheQueueHoldsOnlyWaitingPatients`, `TestTheWaitEstimateGrowsDownTheQueueAndExplainsItself` |
| The estimate is observed once enough consultations have finished | `TestTheWaitEstimateIsObservedOnceEnoughConsultationsHaveFinished`, `TestTheServiceRateIsObservedFromWhatActuallyHappened` |
| Two clinicians halve the wait; an unobserved rate falls back rather than promising no wait | `TestTheWaitEstimateDividesByActiveClinicians`, `TestTheWaitEstimateFallsBackRatherThanReportingNoWait` |
| An unknown priority sorts last, not first | `TestAnUnknownPrioritySortsLast` |
| A walk-in becomes an ordinary appointment and joins the same queue | `TestAWalkInBecomesAnOrdinaryAppointment`, `TestAWalkInIsAnOrdinaryAppointment` |
| A walk-in consumes no rostered slot | `TestAWalkInDoesNotConsumeARosteredSlot` |
| A walk-in needs a stated reason | `TestAWalkInNeedsAStatedReason` (both layers) |
| Reprioritising needs a reason and shows it on the board | `TestReprioritisingNeedsAReasonAndShowsItOnTheBoard`, `TestReprioritisingNeedsAReasonAndKeepsIt` |
| A patient who has not arrived cannot be reprioritised | `TestAPatientWhoHasNotArrivedCannotBeReprioritised`, `TestOnlyACheckedInPatientCanBeReprioritised` |
| Booking records a confirmation and schedules a reminder | `TestBookingRecordsAConfirmationAndAReminder` |
| A delivery outcome is recorded and cannot be overwritten late | `TestBookingRecordsAConfirmationAndAReminder`, `TestANotificationRecordsItsOutcome` |
| A failure or suppression states why | `TestAFailureOrSuppressionNeedsAReason` |
| A patient who agreed to nothing has messages suppressed visibly | `TestAPatientWhoAgreedToNothingHasTheirMessagesSuppressedVisibly` |
| A facility that sends nothing records nothing | `TestAFacilityThatSendsNothingRecordsNothing`, `TestAFacilityCanSendNothing` |
| A reminder that would arrive too late is not scheduled | `TestAReminderIsNotDueWhenItWouldArriveTooLate`, `TestAReminderAtZeroHoursIsNotAReminder` |
| A notification is about exactly one appointment or one offer | `TestANotificationIsAboutExactlyOneThing` |
| An unknown stored notification kind is dropped | `TestAnUnknownStoredNotificationKindIsDropped` |
| Check-in emits an event carrying the token but no demographics | `TestCheckingInEmitsAnEvent` |
| A no-show does not give the slot back | `TestANoShowDoesNotGiveTheSlotBack` |
| A queue cannot be reached from another tenant | `TestAQueueCannotBeReachedFromAnotherTenant` |

### Decisions taken against the backlog

**SRS-SCH-004 is listed under the `sch.configure` permission.** Booking an
appointment is what a receptionist does a hundred times a day; rewriting a
clinic's roster is what a scheduler does occasionally and deliberately. Behind
one permission, every receptionist could delete a clinician's Tuesday.
Implemented as a distinct `sch.appointment.book`, with `sch.schedule.configure`
reserved for rosters — the same shape as the SRS-EMPI-005 slip recorded above.
Pinned by `TestAClerkCannotRewriteTheRoster`.

## Sprint 4 — encounter, clinical and nursing

| Requirement | What it asks for | State |
|---|---|---|
| SRS-ENC-001 | Encounter linked to patient, facility, service, visit type, attending provider and reason | **Implemented** |
| SRS-ENC-002 | Seven encounter classes deriving class-specific rules from one common model | **Implemented** |
| SRS-ENC-003 | Start/end with timestamps independent of appointment status; both separately auditable | **Implemented** |
| SRS-ENC-004 | Episode-of-care grouping; many encounters reference one episode without copying data | **Implemented** |
| SRS-ENC-005 | Care team with role and effective time, so authorization can evaluate an active relationship | **Implemented** |
| SRS-ENC-006 | Status transitions with explicit cancellation and entered-in-error semantics | **Implemented** |
| SRS-ENC-007 | Encounter diagnoses with certainty, rank and coding system; history and author retained | **Implemented** |
| SRS-ENC-008 | Block finalisation on incomplete mandatory documentation, with an audited emergency override | **Implemented** |
| SRS-ENC-009 | Close with a visit summary generated from signed data; later changes are amendments | **Implemented** |
| SRS-ENC-010 | Linked external referral/request source | **Implemented** — the reference is held and travels with the encounter; closing the loop back to the referrer is SRS-CLN-022's consult response, which arrives with 4B |
| SRS-ENC-011 | Longitudinal timeline with purpose/permission filtering; unauthorised restricted notes omitted or masked | **Implemented** |
| SRS-ENC-012 | `encounter.started/completed/cancelled` and `diagnosis.recorded`, deterministic ordering and version per aggregate | **Implemented** |
| SRS-CLN-001 | Patient banner with positive identifiers, age/sex, allergies, major alerts and encounter context | **Implemented** |
| SRS-CLN-002 | Structured and narrative notes against versioned specialty templates; the saved note references the exact version | **Implemented** |
| SRS-CLN-003 | Problem list with status, onset, resolution and coded mapping; a resolved problem stays historical | **Implemented** |
| SRS-CLN-004 | Allergy/intolerance with substance, reaction, severity, certainty and verification status, visible to decision support on commit | **Implemented** |
| SRS-CLN-005 | Observations with code, value, unit, reference/interpretation, time, performer, device and status; trends keep the original unit | **Implemented** |
| SRS-CLN-006 | Procedure record with indication, performer, site/laterality, outcome, complications and linked orders | **Implemented** |
| SRS-CLN-007 | Care plans with problems, goals, interventions, owners, target dates and status | **Implemented** — the plan and its activities are modelled and stored; the task linkage lands with SRS-NUR-011's worklist in 4C |
| SRS-CLN-008 | Document lifecycle draft → signed → amended/addendum/entered-in-error; signed content cannot be edited in place | **Implemented** |
| SRS-CLN-009 | Signature with authenticated identity, timestamp and meaning; signature metadata and content hash retained | **Implemented** |
| SRS-CLN-010 | Provenance for imported records: source organisation, source system and ingestion time, distinguishable from local authorship | **Implemented** |
| SRS-CLN-011 | Abnormal/critical flags come from the authoritative diagnostic service; the UI must not infer criticality | **Implemented** |
| SRS-CLN-012 | Critical-result acknowledgement with timestamp and action; unacknowledged alerts escalate | **Implemented** — escalation is computed and due alerts are listed; the delivery channel is the notification port Sprint 3C established |
| SRS-CLN-013 | Clinical and procedure-specific consents, not conflated with privacy consents | **Implemented** |
| SRS-CLN-014 | Attachments and images with type, source, timestamp and confidentiality class | **Implemented** — metadata, classification and access follow the parent record; the binary store is a port with no production adapter yet |
| SRS-CLN-015 | Smart phrases with user-visible expansion; the signed note stores the expanded text | **Implemented** |
| SRS-CLN-016 | Dictation as draft input; the clinician reviews and signs | **Implemented** — dictated content is marked and a transcriber's signature does not finalise; the speech-recognition vendor is a seam |
| SRS-CLN-017 | Patient-context lock and warning across multiple open charts | **Implemented** |
| SRS-CLN-018 | Chronological timeline filtered by kind, never changing the underlying record | **Implemented** |
| SRS-CLN-019 | Restricted note class with narrower authorization; restricted reads explicitly audited | **Implemented** |
| SRS-CLN-020 | Versioned calculators storing inputs, formula version, output, units and interpretation; recalculation never overwrites | **Implemented** |
| SRS-CLN-021 | CDS alerts naming the triggering rule and version, with a stored, reportable override reason | **Implemented** |
| SRS-CLN-022 | Referral/consult request with specialty, urgency, reason and question; the response closes the loop and stays linked | **Implemented** |
| SRS-CLN-023 | Registry references pointing at canonical clinical facts rather than copying the chart | **Implemented** |
| SRS-CLN-024 | `clinical_document.signed`, `observation.recorded`, `problem.updated`, `allergy.updated`, `procedure.completed`, `critical_result.acknowledged` | **Implemented** |
| SRS-NUR-001 | Admission assessment against a versioned age/service-specific template; author, time and version retained | **Implemented** |
| SRS-NUR-002 | Nursing care plan with problems, goals, interventions, frequency and evaluation; its tasks appear in the worklist | **Implemented** |
| SRS-NUR-003 | Flowsheet vitals with source and timestamp; a late entry is identified as late and carries the actual observation time | **Implemented** |
| SRS-NUR-004 | Intake and output by category with a running shift/day balance; corrections use an amendment trail | **Implemented** |
| SRS-NUR-005 | Fall, pressure-injury, pain and configured risk scores; version and inputs stored, due reassessment appears as work | **Implemented** |
| SRS-NUR-006 | Lines, tubes, drains and catheters with insertion, site, care, output and removal; device-days from canonical dates | **Implemented** |
| SRS-NUR-007 | Administration schedule from the medication service; only active verified orders create tasks | **Implemented** — the eMAR is written against the medication port and refuses everything while it is unwired; Sprint 5's SRS-MED supplies the adapter |
| SRS-NUR-008 | Positive patient identification before administration; a mismatch prevents completion unless policy allows an override | **Implemented** |
| SRS-NUR-009 | Administered/not-administered/held/refused/delayed with dose, time, route, site and reason; scheduled versus actual retained | **Implemented** |
| SRS-NUR-010 | Shift handover with outstanding issues, critical risks, devices and pending tasks; acknowledgement and shift recorded | **Implemented** |
| SRS-NUR-011 | Nursing tasks with priority, due time, recurrence and completion evidence; overdue critical tasks escalate | **Implemented** — escalation is raised and recorded against the task; the delivery channel is the notification port Sprint 3C established |
| SRS-NUR-012 | Wound and skin assessment with location, body map and consented image; images versioned and access-controlled | **Implemented** — the image series, its consent and its access rules are enforced; the binary store is a port with no production adapter yet |
| SRS-NUR-013 | Restraints with indication, authorisation, monitoring and discontinuation; an expired authorisation triggers an alert | **Implemented** |
| SRS-NUR-014 | Transfusion monitoring linked to a blood-product episode; the reaction action runs from the bedside | **Implemented** |
| SRS-NUR-015 | Patient and family education and discharge readiness, with topic, learner, method and understanding status | **Implemented** |
| SRS-NUR-016 | Acuity and workload dashboard by unit, from defined inputs, never silently altering staffing decisions | **Implemented** |
| SRS-NUR-017 | Nurse assignment by unit and bed with a care relationship; changes are effective-dated and auditable | **Implemented** |
| SRS-NUR-018 | Downtime-safe workflows for medication and critical nursing tasks; recovery reconciliation prevents duplicate administration | **Implemented** — the duplicate guard, the offline marking and the reconciliation lifecycle are in place; the printable downtime forms are a client concern and the edge queue is the Wave-0 prototype (P0-13) |

### What the encounter context enforces

- **An appointment is a plan; an encounter is what happened.** SRS-ENC-003 is
  explicit that the two stay separately auditable, and the reason is that a
  patient can be seen without an appointment, an appointment can be kept without
  a consultation ever starting, and a consultation can run long past the slot it
  was booked into. So the encounter carries its own clinical start and end, and
  the appointment is a nullable reference rather than a parent. A system that
  conflated them cannot answer "when was this patient actually seen", which is
  the question every audit and every billing dispute turns on. The start time is
  supplied rather than taken from the clock, so a late entry records when the
  patient was seen rather than when somebody got to a keyboard.
- **One encounter model, seven classes.** Everything downstream — orders,
  results, notes, billing — attaches to an encounter and would otherwise have to
  know about seven of them. The differences between an outpatient visit and an
  admission are rules about one thing, not seven things. The class-specific rules
  that exist are small and load-bearing: a consultation names somebody answerable
  and a diagnostic-only visit does not, because inventing an attending clinician
  for a walk-in X-ray would put a name against a decision that person never made.
- **Cancelled and entered-in-error are different facts.** A cancelled visit did
  not take place; an entered-in-error one is a record that was never true, almost
  always an encounter opened against the wrong patient. Counting them together
  would tell a quality team that patients are cancelling when in fact clerks are
  misclicking. Entered-in-error is reachable even from closed, because the mistake
  is usually noticed afterwards and the only alternative is leaving a false record
  standing. It is not a delete: the clinical content written against it is still
  real and still has to be traceable, and orphaning it is how a result ends up
  attributed to nobody.
- **A care-team membership is dated, and the question is about the past.**
  Authorization asks whether this clinician was looking after this patient *at the
  time*. A list with no dates answers today's question and silently gives the
  wrong answer to every question about the past — including the one an
  investigation asks. Ending an assignment closes it rather than deleting it, for
  the same reason. The attending clinician joins their own care team on the way
  in, because otherwise authorization would answer "no" for the person responsible
  for the patient.
- **An episode holds the grouping and nothing else.** SRS-ENC-004's criterion is
  that encounters reference one episode "without copying data", so the moment the
  episode held a copy of a diagnosis or a plan, that copy would be the version
  somebody read after the original changed. A finished course of care is not
  reopened: a pregnancy that resumes is a different pregnancy.
- **A diagnosis is superseded, never overwritten.** A differential that became a
  final diagnosis is a clinical reasoning trail, and overwriting it destroys the
  only evidence that the reasoning happened. A second primary diagnosis supersedes
  the first automatically rather than being refused — the clinician correcting it
  is doing the right thing and should not have to retract first — and a partial
  unique index holds "at most one live primary" at the table, because the rank
  answers "what was this visit about" and two answers is no answer. The
  superseding chain's foreign key is deferred to commit, so the supersede can
  precede the insert that the unique index requires it to precede.
- **A code with no terminology is a number nobody can safely act on.** "C50"
  means breast cancer in ICD-10 and something else in a local scheme, so system
  and code travel together, with the terminology version pinned — ICD-10 codes
  have been reassigned between revisions — and a display term, because a bare code
  on a screen is a screen clinicians stop reading.
- **The closure gate blocks, names everything, and can be forced with a
  reason.** A hard block with no way through does not produce complete records; it
  produces encounters left open for months, and an open encounter looks like a
  patient still under care. So SRS-ENC-008's gate lists *every* missing item
  rather than the first — a clinician told about one item, who fixes it and is
  then told about another, stops trusting the message — phrases each as the action
  to take rather than the rule that was broken, and can be overridden where policy
  allows by somebody who states why. The override is stored as well as audited:
  the audit trail answers "who did this", and the stored record answers "how often
  does this happen and for what", which is the question a quality committee asks.
  What was outstanding is captured at the moment of the override rather than
  recomputed, because the items are usually completed afterwards and a recomputing
  report would show every override as having overridden nothing. Overriding a
  complete encounter is refused, because it would inflate the report the override
  exists to make possible.
- **The visit summary is stored, not rendered.** A summary rendered on demand
  shows today's chart, so a patient handed a printout in March and a clinician
  looking at the same "summary" in June see different documents with the same
  name. SRS-ENC-009 requires that a closed encounter's chronology cannot be
  *silently* rewritten, and a stored artefact is what makes "silently" impossible:
  a later change is a new version with a mandatory reason, and the previous
  version stays readable because somebody acted on it.
- **The confidentiality filter runs once, on the way out.** A timeline is the
  screen where every context's output meets, which makes it the screen where a
  confidentiality mistake reaches the most people. Restricted entries are *masked*
  rather than omitted — a clinician who can see that a note exists knows to ask,
  while an omitted note produces a chart that silently claims to be complete — and
  the very-restricted tier is omitted, because the existence of a safeguarding
  note can itself be the disclosure. Break-glass reaches restricted content and
  stops there. A confidentiality class this version does not recognise is treated
  as the tightest: over-restricting is an inconvenience somebody reports, and
  under-restricting is a disclosure nobody notices.

### What the clinical record enforces

- **A signature is a claim about a specific set of words.** SRS-CLN-009 asks
  for the content hash to be retained, and the reason is that "Dr Rao signed
  this note" is worthless if nobody can say which note. The hash covers the
  section headings and their order as well as the text, because moving a
  sentence from *History* to *Plan* changes what the clinician asserted while
  leaving the words identical. `Intact()` recomputes it, so a note whose stored
  content has drifted from what was signed is detectable rather than merely
  improbable.
- **Signed content is never edited; it is amended or annotated.** The
  requirement says "cannot be edited in-place", and in-place is the whole
  point: a correction that overwrites destroys the version somebody else acted
  on. So an amendment produces a new document with a mandatory reason and the
  old one stays readable, and the guard is not only in the domain — the update
  query carries `AND status = 'draft'`, so a second path to the table cannot
  reach a signed row either. An amendment and an addendum are deliberately
  different things: an amendment says the record was wrong, an addendum says
  the record was incomplete, and a reader who cannot tell them apart cannot
  tell a correction from a continuation.
- **A transcriber's signature does not finalise a note.** SRS-CLN-016 is
  explicit that the clinician reviews and signs dictated content. A signature
  meaning of *transcriber* asserts "I typed what I heard", which is a very
  different claim from "I am answerable for this clinical judgement", and a
  system that let the first one close the document would put a clinician's name
  against words they never read.
- **Smart phrases are expanded before the note is stored, never after.**
  SRS-CLN-015's criterion is "no hidden clinical text". A macro resolved at
  display time means the stored note and the note on the screen are different
  documents, and the one that gets disclosed in a complaint is the stored one.
  Expansion happens on the way in, so what was signed is what is on the screen.
- **Criticality comes from the laboratory, not from us.** SRS-CLN-011 says the
  UI must not infer criticality independently, and the reason is that reference
  ranges are method-specific and age-specific: a potassium that is critical on
  one analyser is ordinary on another, and a neonatal bilirubin compared
  against an adult range is dangerous in both directions. So the interpretation
  arrives with the result, carries the name of the source that assigned it, and
  an interpretation with no named source is refused. An interpretation code
  this version does not recognise is *not* treated as normal — the failure mode
  of guessing "normal" is a missed critical result.
- **Acknowledging a critical result requires saying what was done.** A
  timestamp alone answers "was it seen", which is the question the system
  wants; "what happened to the patient" is the question the incident review
  asks. Requiring the action turns the acknowledgement from a dismissed dialog
  into a clinical record, and an alert that nobody acknowledges escalates on a
  clock rather than waiting to be noticed.
- **An unverified allergy still warns.** Verification status is recorded
  because SRS-CLN-004 asks for it, but the severity ranking deliberately does
  not discount an unconfirmed entry, and an allergy of unknown criticality
  outranks a confirmed mild intolerance. A patient who says "penicillin makes
  me stop breathing" has not been through an allergy clinic, and suppressing
  that warning until somebody verifies it inverts the safety argument. The
  banner leads with what could kill: the ordering is by danger, not by entry
  date.
- **A resolved problem stays on the list.** SRS-CLN-003's criterion is that it
  remains historical, and the reason is that "resolved" is a clinical claim
  that can be wrong — a cancer in remission is on the list precisely because it
  might come back — and a chart that deletes resolved problems cannot answer
  "has this patient ever had".
- **A measured value without a unit is not a value.** 5 of potassium is
  ordinary in mmol/L and lethal in g/L. The unit travels with the number,
  trends keep the original unit and source rather than silently normalising,
  and a value that arrives unitless is refused at the domain rather than
  rendered.
- **Laterality is stated, never assumed.** Wrong-site surgery is the canonical
  never-event, and a procedure on a paired organ that leaves the side blank is
  how it happens. A body site that has sides requires one.
- **Clinical consent and privacy consent are different records.** SRS-CLN-013
  says not to conflate them, and conflating them is worse than untidy:
  "consented to surgery" and "consented to share my record with the district
  registry" answer to different law, different withdrawal rules and different
  readers. A consent that is absent is not a refusal, and a refusal is visible
  rather than inferred from silence — the alternative is treating "nobody
  asked" as "the patient agreed".
- **A recalculation is a new result, not an update.** SRS-CLN-020 requires that
  a new formula never overwrites a historical one, because the clinician acted
  on the old score and an audit that shows only the recomputed value says the
  decision was made on evidence that did not exist at the time. Inputs and
  formula version are stored alongside the output for the same reason.
- **The patient-context lock is about the chart you are not looking at.** Two
  charts open is normal on a ward round; ordering into the wrong one is the
  error SRS-CLN-017 exists to catch. The client asserts which patient it
  believes it is acting on and the server compares that against the target, so
  a stale tab is refused rather than trusted. Asserting nothing is not a
  mismatch — the lock catches a wrong claim, it does not force every caller to
  make one.
- **Restricted notes are a class on the document, not a separate store.** A
  parallel store for sensitive notes is a store that gets forgotten by the next
  feature. The class rides with the document, the timeline filter applies it on
  the way out, and a class this version does not recognise counts as
  restricted. Reads of restricted content are audited as such, so "who looked
  at the psychiatric note" is answerable.
- **A CDS override is stored, not just allowed.** SRS-CLN-021 asks for the
  triggering rule and version, because an alert everybody overrides is an alert
  that should be retired, and that argument can only be made from counted
  overrides against a named rule version. A soft alert does not block — a
  system that blocks on everything trains clinicians to click through
  everything, which is how the hard blocks stop working.
- **A consult that is never answered is an open loop.** SRS-CLN-022's criterion
  is that the response closes the loop and stays linked. So the request states
  the question being asked rather than just the specialty — "please see" is not
  a question — and declining needs a reason, because an unexplained decline
  leaves the referrer with nothing to act on.
- **A registry membership points; it does not copy.** SRS-CLN-023 is explicit,
  and the reason is the same one behind the episode in 4A: a copied fact is the
  version somebody reads after the original changed.
- **The clinical events carry references, not content.** SRS-CLN-024's
  criterion is "minimum necessary data and references", so
  `clinical_document.signed` names the document, the patient and the signer and
  says nothing about what the note says. An event bus is the widest-reach
  surface in the system, and a diagnosis in an event payload is a diagnosis in
  every consumer's logs.

### What the nursing record enforces

- **Every bedside record carries two times, and they are never reconciled into
  one.** SRS-NUR-003 requires that a late entry is identified as late and
  carries the actual observation time, and the reason is a ward that takes
  observations at 06:00 and reaches a terminal at 08:40. A system that stamps
  08:40 says the patient was stable two hours after they in fact were, and the
  deterioration in between becomes invisible. So the observation time is
  supplied by the nurse and refused when absent, the recording time comes from
  the server's clock and is never taken from the caller, and the chart sorts by
  the first while the audit reads the second. A late entry also needs a reason:
  "the nurse was busy" and "this was found on paper during downtime" lead to
  different conclusions in a review, and a flag with no explanation says a
  record is weak without saying why.
- **A fluid balance is corrected by superseding, never by editing.** A running
  total that can be edited is a total nobody can reconstruct, and the shift
  balance that was handed over at 20:00 was computed from the entry somebody
  later changed. So SRS-NUR-004's amendment trail is a new row that points back,
  the original stays readable, and the balance counts only what is live. A
  negative volume is refused outright — it is how a balance gets "corrected" by
  a system with no amendment trail, and this one has one.
- **Device-days come from the insertion and removal dates and from nothing
  else.** Device-days are the denominator of the infection rates a hospital
  publishes and is judged on. A denominator derived from how often somebody
  documented line care falls when the ward is busy, which makes the rate rise
  exactly when it should not. So SRS-NUR-006's "canonical dates" are a property
  of the record: care episodes are stored because they are nursing work, and the
  count never looks at them. The counting convention is stated in the code —
  once per calendar day in place, insertion and removal days included, UTC
  boundaries — because the number is only comparable between hospitals if
  everybody counts it the same way, and a denominator that shifts with a
  daylight-saving change produces an unexplained blip twice a year.
- **Only an order a pharmacist has verified produces a dose to give.**
  SRS-NUR-007 is explicit, and the gap between a doctor prescribing and a
  pharmacist verifying is where dose and interaction errors are caught. A task
  list built from unverified orders invites a nurse to give the dose the
  pharmacist was about to question. The check runs when the round is built *and*
  again when the dose is recorded, because a stale round is exactly what a nurse
  would be acting on. Until Sprint 5 wires the medication context, the port is
  nil and every administration is refused: an eMAR that cannot check
  verification must not pretend it has, and a stub answering "verified" would be
  a safety control present in the code and absent in effect.
- **A barcode mismatch is a refusal, not a warning.** SRS-NUR-008 says a
  mismatch prevents completion, and a warning that can be clicked through is how
  wrong-patient administrations happen on wards that have scanners. The scan is
  compared against the *order's* patient rather than against what the screen is
  showing, because the screen is what the check exists to doubt. Not scanning at
  all is a failure of the check rather than an absence of it. The override is
  allowed where policy says so, needs a substantive reason, and is stored on the
  administration as well as audited — the audit answers "who did this", and the
  stored record answers "how often, on which ward, for which drugs", which is
  the question that gets a broken scanner replaced. A facility may turn the
  override off entirely, and a facility with no scanners turns the check off
  deliberately: the default is on, because a safety control that has to be
  switched on is a control that is off in the wards that most need it.
- **The MAR keeps what was ordered and what happened, side by side.**
  SRS-NUR-009's criterion is exactly this, and the reason is that a record
  showing only what was given cannot answer "was it late" — the question an
  insulin or an antibiotic review turns on. Held, refused, not-administered and
  delayed are four different facts and stay four: holding is a clinical
  judgement somebody is answerable for, refusing is the patient's decision and
  not the nurse's to record as a hold, and a nurse asserting a dose was late is
  different evidence from a report deriving it. Anything but a plain
  administration needs a reason.
- **The duplicate-administration guard is keyed on the dose, not the
  submission.** SRS-NUR-018's failure is easy to produce and hard to see: during
  downtime a ward charts on paper, and when the system returns two nurses split
  the pile and type the same entry. A client-generated identifier does not help,
  because the two transcriptions are genuinely separate submissions of one
  event. What identifies the event is the order and the scheduled time, which is
  what is written on the paper chart and therefore what both transcribers read.
  The uniqueness lives in a partial index at the table rather than in a
  check-then-insert, because the two submissions can be in flight at the same
  moment. A PRN dose has no scheduled time and is *not* refused — two doses of
  breakthrough analgesia an hour apart can be entirely correct — so there the
  guard is an idempotency key and a report that flags near-duplicates for
  somebody to look at.
- **An expired restraint authorisation raises an alarm; it does not free the
  patient.** SRS-NUR-013 asks for an alert, and note what it does not ask for.
  The patient is still restrained when the paperwork lapses, and a system that
  "removed" the restraint at expiry would produce a record showing a patient
  free while they were tied to a bed. So expiry is a computed state on a
  still-active restraint, it emits an event so the alert reaches the nurse in
  charge rather than waiting for somebody to open a screen, and only a person
  discontinues. The authorisation cannot be open-ended and cannot run past a
  ceiling, because an authorisation written once on admission that never expires
  is the failure the requirement exists to prevent. Every monitoring check must
  say why the restraint is still needed: a check that records observations
  without asking that question is a check that keeps patients restrained.
- **A handover is a stored snapshot, and somebody else accepts it.**
  SRS-NUR-010's criterion is that the acknowledgement and the shift are
  recorded, which is a statement about what handover is for: the moment
  responsibility moves. Rendered live, the handover acknowledged at 20:00 shows
  something different at 23:00 and nobody can say afterwards what they were
  told. So the devices and the outstanding work are captured by the server at
  composition time — a handover cannot quietly omit the line that has been in
  for nine days — and a nurse cannot acknowledge their own, because one person
  marking their own work received is not a transfer. An unacknowledged handover
  is visible as such: it means a patient nobody has taken responsibility for.
- **A recurring task is scheduled from when it was due, not from when it was
  done.** Four-hourly observations completed an hour late, rescheduled from
  completion, drift later every round until they are happening once a shift.
  Completion needs evidence rather than a tick, because a tick with no evidence
  is indistinguishable from a tick to clear the list, and a task deliberately
  not done is a different fact from one nobody did — only one of them is a gap
  in care. Escalation is for overdue *critical* work alone: escalating every
  overdue routine task produces a stream nobody reads, and the first thing lost
  in an unread stream is the critical one.
- **A risk score stores the instrument version and every input.** A Braden of 14
  means nothing without knowing it was a Braden, and a total on its own cannot
  be checked, explained to the patient, or recomputed when somebody asks whether
  the scale was applied correctly. A factor left unanswered is refused rather
  than scored zero, because zero reports a patient at lower risk than they were
  assessed at; a total no band covers is refused rather than reported as no
  risk, because "no risk" is the dangerous reading of a misconfigured scale. A
  rescore supersedes rather than overwrites, and the band's escalation flag is
  captured at the time, so retuning a scale cannot rewrite what the nurse was
  told.
- **A photograph of a wound is a photograph of a patient.** SRS-NUR-012 says
  "where consented", so the image carries a consent reference rather than a
  boolean — a boolean cannot be checked against a consent that was later
  withdrawn — and whether that consent covers clinical photography is the
  clinical context's question, asked across the seam and evaluated against the
  consent's status and validity window. An image is added to a numbered series
  and never replaced, because the series is the evidence of healing. A pressure
  injury charted without a stage is refused: the stage drives the care plan and
  the incident report, and one without it is a pressure injury nobody reports.
- **The acuity dashboard reports and has no mechanism to decide.**
  SRS-NUR-016's criterion — "never silently alters staffing decisions" — is the
  most carefully worded in the family, and it is right to be. An acuity figure
  is an input to a judgement made by a person who is accountable for it, and it
  is built from proxies that are wrong in exactly the cases that matter most. So
  the inputs are named and stored with the figure, the weights travel with the
  score (a retune must not silently rewrite history, and two wards' numbers are
  comparable only when computed the same way), the nurse count comes from live
  assignments rather than from a roster — a roster says who was *meant* to be
  there — and a unit with nobody on duty reports no per-nurse figure at all,
  because a ward with no nurses assigned is not a ward with zero workload per
  nurse.
- **A nurse assignment is dated, and the question is about the past.** The
  question an incident review asks is "who was looking after this patient at
  03:40", and a list with no dates answers today's question and silently gives
  the wrong answer to every question about the past. Ending an assignment closes
  it rather than deleting it, and one live primary nurse per patient is held by
  a partial unique index — two answers to "who is responsible" is no answer.
- **Ending downtime and reconciling it are different facts.** The system coming
  back and the paper being typed in are hours apart, and the gap is where the
  record is incomplete. An episode that ended and was never reconciled is
  somebody who never finished typing, which is a gap in the medication record
  rather than a tidiness problem, and it stays visible until it is closed.

### Sprint 4 evidence

| Property | Test |
|---|---|
| An encounter begins in a valid state with an identifier of its own | `TestOpeningAnEncounterStartsItInAValidState` |
| An encounter needs a patient, a facility and somebody answerable | `TestAnEncounterNeedsAPatientAFacilityAndAResponsibleClinician` |
| A walk-in encounter needs no appointment | `TestAnEncounterNeedsNoAppointment` |
| The encounter records when the patient was actually seen | `TestAnEncounterRecordsWhenThePatientWasActuallySeen`, `TestAnEncounterKeepsItsOwnClinicalTimes` |
| An encounter cannot start in the future or end before it started | `TestAnEncounterCannotStartInTheFuture`, `TestAnEncounterCannotEndBeforeItStarted` |
| A consultation names its clinician; a diagnostic-only visit does not | `TestAConsultationNamesItsClinicianAndAnXRayDoesNot`, `TestADiagnosticOnlyVisitNeedsNoAttendingClinician` |
| The attending clinician is on the care team from the start | `TestTheAttendingClinicianIsOnTheCareTeamFromTheStart` |
| Care-team membership is answered as of a time | `TestCareTeamMembershipIsAnsweredAsOfATime` |
| Ending a care-team assignment keeps it | `TestEndingACareTeamAssignmentKeepsIt` |
| A care-team assignment must end after it begins | `TestACareTeamAssignmentMustEndAfterItBegins` |
| Encounters share an episode without copying it | `TestEncountersShareAnEpisodeWithoutCopyingIt`, `TestAnEpisodeGroupsEncountersWithoutCopyingThem` |
| A finished episode takes no more encounters | `TestAFinishedEpisodeTakesNoMoreEncounters` |
| An episode needs a label | `TestAnEpisodeNeedsALabel` |
| One patient's encounter cannot be filed into another's episode, and the refusal leaks nothing | `TestAnEpisodeCannotBeUsedForAnotherPatient` |
| An impossible state change is rejected | `TestAnEncounterRefusesAnImpossibleStateChange` (both layers), `TestAnInvalidTransitionNamesBothStates` |
| Cancelled and entered-in-error stay distinct | `TestCancelledAndEnteredInErrorStayDistinct`, `TestCancelledAndEnteredInErrorAreDistinct` |
| Cancelling and retracting need reasons | `TestCancellingNeedsAReason`, `TestCancellingAndRetractingNeedReasons` |
| A closed encounter is amended, not reopened | `TestAClosedEncounterCannotBeReopened` |
| A finished encounter can be continued | `TestAFinishedEncounterCanBeContinued` |
| Only an inpatient can go on leave | `TestOnlyAnInpatientCanGoOnLeave` |
| Only an open encounter accepts clinical content | `TestOnlyAnOpenEncounterAcceptsClinicalContent`, `TestAClosedEncounterTakesNoNewDiagnosis` |
| A status change records its author, and repeating one is harmless | `TestAStatusChangeRecordsItsAuthor`, `TestRepeatingAStatusChangeIsHarmless` |
| A diagnosis needs its terminology and a display term | `TestADiagnosisNeedsItsTerminologyAndADisplayTerm`, `TestADiagnosisNeedsItsTerminology`, `TestADiagnosisNeedsADisplayTerm` |
| Revising a diagnosis keeps the reasoning trail and leaves one live primary | `TestRevisingADiagnosisKeepsTheReasoningTrail`, `TestSupersedingADiagnosisKeepsTheReasoningTrail` |
| A condition cannot have begun in the future | `TestAConditionCannotHaveBegunInTheFuture` |
| A clerk cannot record a diagnosis | `TestAClerkCannotRecordADiagnosis` |
| An incomplete closure lists everything that is missing, as actions | `TestAnIncompleteEncounterCannotBeClosedAndSaysWhy`, `TestAnIncompleteClosureListsEverythingThatIsMissing` |
| A complete encounter closes cleanly; a diagnostic-only visit has nothing to document | `TestACompleteEncounterClosesCleanly`, `TestADiagnosticOnlyVisitHasNothingToDocument` |
| An emergency encounter can be forced closed with an audited reason | `TestAnEmergencyEncounterCanBeForcedClosedWithAnAuditedReason`, `TestOnlyEmergencyEncountersCanBeForcedClosedByDefault` |
| A routine encounter cannot be forced closed | `TestARoutineEncounterCannotBeForcedClosed` |
| Overriding a complete encounter is refused, and "ok" is not a reason | `TestOverridingACompleteEncounterIsRefused`, `TestAnOverrideNeedsASubstantiveReasonAndSomethingToOverride` |
| An unrecognised documentation requirement blocks | `TestAnUnknownDocumentationRequirementBlocks` |
| A facility can configure what blocks a closure; a clerk cannot | `TestAFacilityCanConfigureWhatBlocksAClosure`, `TestAClerkCannotSetTheClosurePolicy` |
| A visit summary is amended rather than rewritten | `TestAVisitSummaryIsAmendedRatherThanRewritten` (both layers) |
| The encounter events carry the aggregate version and no clinical detail | `TestTheEncounterEventsCarryTheAggregateVersion` |
| The timeline shows encounters and diagnoses newest first | `TestTheTimelineShowsEncountersAndDiagnosesNewestFirst`, `TestTheTimelineSortsNewestFirst` |
| An ordinary reader sees neither restricted note | `TestAnOrdinaryReaderSeesNeitherRestrictedNote` |
| The author of a restricted note can always read it back | `TestTheAuthorOfARestrictedNoteCanAlwaysReadItBack` |
| Break-glass reaches restricted but not very-restricted | `TestBreakGlassReachesRestrictedButNotVeryRestricted` |
| An unknown confidentiality class is treated as the tightest | `TestAnUnknownConfidentialityClassIsTreatedAsTheTightest` |
| The filter reports what it withheld, for audit | `TestTheFilterReportsWhatItWithheld` |
| Filtering by kind leaves the timeline alone | `TestFilteringByKindLeavesTheTimelineAlone` |
| An encounter cannot be reached from another tenant, or opened for their patient | `TestAnEncounterCannotBeReachedFromAnotherTenant`, `TestAnEncounterCannotBeOpenedForAnotherTenantsPatient` |
| The banner leads with what could kill, and quiet allergies stay off it | `TestTheBannerLeadsWithWhatCouldKill`, `TestOnlyDangerousAllergiesReachTheBanner` |
| A note needs a patient and an encounter | `TestADocumentNeedsAPatientAndAnEncounter` |
| A template needs a version and at least one section | `TestATemplateNeedsAVersionAndASection` |
| A note records the template version it was composed against, and a retired template cannot be chosen | `TestANoteRecordsTheTemplateVersionItWasComposedAgainst`, `TestANoteRecordsItsTemplateVersionAndARetiredOneCannotBeChosen` |
| A signature needs an identity and something to sign | `TestASignatureNeedsAnIdentityAndSomethingToSign` |
| A signature pins exactly what was signed | `TestASignaturePinsWhatWasSigned` (both layers) |
| The content hash covers heading order, not just words | `TestTheContentHashCoversOrderAndHeadings` |
| A signature records what it asserts | `TestASignatureRecordsWhatItAsserts` (both layers) |
| A transcriber's signature does not finalise a note | `TestATranscribersSignatureDoesNotFinaliseANote` |
| Signed content cannot be edited in place; a draft can | `TestASignedNoteCannotBeEdited`, `TestASignedNoteCannotBeEditedInPlace`, `TestADraftIsEditedRatherThanAmended` |
| An amendment and an addendum are different things | `TestAnAmendmentAndAnAddendumAreDifferentThings` (both layers) |
| A retracted document is kept, not deleted | `TestARetractedDocumentIsKept` |
| A clerk can type a note but cannot sign it | `TestAClerkCanTypeANoteButNotSignIt` |
| A closed encounter takes no new note | `TestAClosedEncounterTakesNoNewNote` |
| Smart phrases are expanded before the note is stored | `TestSmartPhrasesAreExpandedBeforeTheNoteIsStored`, `TestSmartPhrasesAreExpandedIntoTheStoredNote` |
| A resolved problem stays on the list, and cannot resolve before it began | `TestAResolvedProblemStaysOnTheList`, `TestAProblemCannotResolveBeforeItBegan` |
| An allergy substance must be coded | `TestAnAllergySubstanceMustBeCoded` |
| An unconfirmed allergy still warns, and unknown criticality outranks a mild intolerance | `TestAnUnconfirmedAllergyStillWarns`, `TestAnUnassessedAllergyOutranksAnIntolerance` |
| A measured value needs its unit | `TestAMeasuredValueNeedsItsUnit` |
| An interpretation must name its source, and an unknown one is not normal | `TestAnInterpretationMustNameItsSource`, `TestAnUnknownInterpretationIsNotNormal` |
| A trend is oldest first and keeps its original source | `TestATrendIsOldestFirstAndKeepsItsSource` |
| Acknowledging a critical result needs the action taken | `TestAcknowledgingACriticalResultNeedsTheActionTaken` |
| An unacknowledged critical result escalates | `TestAnUnacknowledgedCriticalResultEscalates` |
| A completed procedure names its performer, and laterality is stated rather than assumed | `TestACompletedProcedureNamesItsPerformer`, `TestALateralityIsStatedRatherThanAssumed` |
| A complication is coded | `TestAComplicationIsCoded` |
| A care plan needs an owner and orders its work | `TestACarePlanNeedsAnOwnerAndOrdersItsWork` |
| Provenance names where imported data came from | `TestProvenanceNamesWhereDataCameFrom` |
| A procedure consent names the procedure, and consent on somebody's behalf names the giver | `TestAProcedureConsentNamesTheProcedure`, `TestAConsentGivenOnSomebodysBehalfNamesTheGiver` |
| An absent consent is not a consent, and a refusal is visible | `TestAnAbsentConsentIsNotAConsentAndARefusalIsVisible` |
| An attachment carries its own confidentiality | `TestAnAttachmentCarriesItsOwnConfidentiality` |
| A document carries its confidentiality class, and an unknown class counts as restricted | `TestADocumentCarriesItsConfidentialityClass`, `TestAnUnknownConfidentialityClassCountsAsRestricted` |
| A restricted note is not visible without the permission | `TestARestrictedNoteIsNotVisibleWithoutThePermission` |
| The patient-context lock catches the wrong chart | `TestThePatientContextLockCatchesTheWrongChart` (both layers), `TestAStalePatientContextIsRefused` |
| Asserting no context is not a mismatch | `TestNoAssertedContextIsNotAMismatch` |
| A calculation stores its inputs and formula version | `TestACalculationStoresItsInputsAndFormulaVersion` |
| A CDS alert names its rule version and records the override; a soft alert does not block | `TestACDSAlertNamesItsRuleVersionAndRecordsTheOverride`, `TestASoftAlertDoesNotBlock` |
| A consult states its question and closes the loop; declining needs a reason | `TestAConsultStatesItsQuestionAndCloseTheLoop`, `TestDecliningAConsultNeedsAReason` |
| A registry membership points at something | `TestARegistryMembershipPointsAtSomething` |
| Signing emits an event carrying no clinical content | `TestSigningEmitsAnEventCarryingNoClinicalContent` |
| The encounter closure gate reads the clinical record across the seam | `TestTheClosureGateSeesASignedNote` |
| A note cannot be reached from another tenant | `TestANoteCannotBeReachedFromAnotherTenant` |
| A catch-up entry is charted as late, with its real observation time | `TestACatchUpEntryIsChartedAsLateWithItsRealObservationTime`, `TestACatchUpEntryIsMarkedLate` |
| An observation records when it was taken, not when it was typed | `TestAnObservationRecordsWhenItWasTakenNotWhenItWasTyped` |
| A late entry must say why it is late | `TestALateEntryMustSayWhyItIsLate`, `TestALateEntryIsRefusedWithoutAnExplanation` |
| An observation needs the time it was taken, and cannot be in the future | `TestAnObservationNeedsTheTimeItWasTaken`, `TestAnObservationCannotHaveBeenTakenInTheFuture` |
| A charted number needs its unit, and a device reading names the device | `TestAChartedNumberNeedsItsUnit`, `TestADeviceReadingMustNameTheDevice`, `TestAChartedValueMustSayWhereItCameFrom` |
| The flowsheet sorts by observation time, not typing time | `TestTheFlowsheetSortsByObservationTimeNotTypingTime`, `TestTheFlowsheetReadsByObservationTime` |
| The fluid balance runs by category | `TestTheFluidBalanceRunsByCategory` |
| Correcting a volume keeps the original and moves the balance | `TestCorrectingAVolumeKeepsTheOriginalAndMovesTheBalance` (both layers) |
| A correction needs a substantive reason, and an entry is corrected once | `TestACorrectionNeedsASubstantiveReason`, `TestAnEntryCannotBeCorrectedTwice` |
| A volume cannot be negative; a voided entry leaves the balance | `TestAVolumeCannotBeNegative`, `TestAVoidedEntryLeavesTheBalance` |
| A balance is bounded by observation time | `TestABalanceIsBoundedByObservationTime` |
| An assessment records the template version it was answered against | `TestAnAssessmentRecordsTheTemplateVersionItWasAnsweredAgainst`, `TestAnAssessmentRecordsItsTemplateVersionAndNamesEveryGap` |
| An incomplete assessment names every missing section | `TestAnIncompleteAssessmentNamesEveryMissingSection` |
| An optional section may be left blank | `TestAnOptionalSectionMayBeLeftBlank` |
| A retired template cannot be answered against, and the assessments already answered stay valid | `TestARetiredTemplateCannotBeAnsweredAgainst` |
| A template applies to an age band and a service | `TestATemplateAppliesToAnAgeBandAndAService` |
| A template needs a version and a section to answer | `TestATemplateNeedsAVersionAndASectionToAnswer` |
| A risk score stores its scale version and every input | `TestARiskScoreStoresItsScaleVersionAndEveryInput`, `TestARiskScoreStoresItsInputsAndARescoreSupersedes` |
| A missing risk factor is refused rather than scored zero | `TestAMissingRiskFactorIsRefusedRatherThanScoredZero` |
| A risk factor outside its range is refused | `TestARiskFactorOutsideItsRangeIsRefused` |
| A risk score expires and becomes due for reassessment | `TestARiskScoreExpiresAndBecomesDue` |
| A risk scale needs a version | `TestARiskScaleNeedsAVersion` |
| A total outside every band is refused rather than reported as no risk | `TestATotalOutsideEveryBandIsRefusedRatherThanReportedAsNoRisk` |
| A rescore is a new record rather than an update | `TestARescoreIsANewRecordRatherThanAnUpdate` |
| Device-days are counted from insertion and removal, and from nothing else | `TestDeviceDaysAreCountedFromInsertionAndRemoval`, `TestDeviceDaysComeFromTheCanonicalDates` |
| A line in and out the same day is one device-day | `TestALineInAndOutTheSameDayIsOneDeviceDay` |
| Documenting care does not change the device-day count | `TestDocumentingCareDoesNotChangeTheDeviceDayCount` |
| Dwell is measured to the minute, not the day | `TestDwellIsMeasuredToTheMinuteNotTheDay` |
| Removing a device needs a reason, and happens once | `TestRemovingADeviceNeedsAReason`, `TestADeviceCannotBeRemovedTwice` |
| A device needs the time it was inserted | `TestADeviceNeedsTheTimeItWasInserted` |
| The surveillance device set is named rather than left to a query | `TestTheSurveillanceDeviceSetIsNamed` |
| An unverified or held order produces no administration | `TestAnUnverifiedOrderProducesNoAdministrationTask`, `TestAHeldOrderProducesNoAdministrationTask`, `TestADoseCannotBeGivenAgainstAnUnverifiedOrder` |
| An order outside its dates produces no task | `TestAnOrderOutsideItsDatesProducesNoTask` |
| The MAR keeps the scheduled dose as well as the one given | `TestTheMARKeepsTheScheduledDoseAsWellAsTheOneGiven`, `TestTheMARKeepsScheduledAndActualApart` |
| A variance across two units is not reported | `TestAVarianceAcrossUnitsIsNotReported` |
| The wrong wristband or the wrong product stops the administration | `TestAWrongWristbandStopsTheAdministration`, `TestTheWrongWristbandStopsTheAdministration`, `TestTheWrongProductStopsTheAdministration` |
| Not scanning is itself a failed check | `TestNotScanningIsItselfAFailedCheck` |
| An override is stored with what it overrode, and is reportable | `TestAnOverrideIsStoredWithWhatItOverrode`, `TestAnOverrideIsRecordedAndReportable` |
| An override needs a substantive reason | `TestAnOverrideNeedsASubstantiveReason` |
| A facility can refuse overrides entirely, and one without scanners can still give medication | `TestAFacilityCanRefuseOverridesEntirely`, `TestAWardWithoutScannersCanStillGiveMedication` |
| A refusal needs no barcode but needs a reason | `TestARefusalNeedsNoBarcodeButNeedsAReason`, `TestARefusedDoseNeedsAReason` |
| Holding and not giving are different facts | `TestHoldingAndNotGivingAreDifferentFacts` |
| A dose that was given needs its route | `TestADoseThatWasGivenNeedsItsRoute` |
| The barcode check is on by default | `TestTheBarcodeCheckIsOnByDefault` |
| Only a nurse can chart an administration | `TestOnlyANurseCanChartAnAdministration` |
| The scheduled-dose key is the order and the scheduled time | `TestTheScheduledDoseKeyIsTheOrderAndTheScheduledTime` |
| Re-keying a paper chart twice cannot duplicate a dose | `TestRekeyingAPaperChartTwiceCannotDuplicateADose` |
| A PRN dose has no scheduled-dose key, and two close together are flagged rather than refused | `TestAPRNDoseHasNoScheduledDoseKey`, `TestTwoPRNDosesCloseTogetherAreFlaggedNotRefused`, `TestTwoPRNDosesCloseTogetherAreFlaggedRatherThanRefused` |
| A genuine second PRN dose is not flagged | `TestAGenuineSecondPRNDoseIsNotFlagged` |
| Scheduled doses and refusals stay out of the suspected-duplicate report | `TestScheduledDosesAreNotInTheSuspectedDuplicateReport`, `TestARefusedDoseIsNotASuspectedDuplicate` |
| The duplicate refusal names the record that already exists | `TestTheDuplicateRefusalNamesTheRecordThatAlreadyExists` |
| A dose transcribed from paper is visible as offline | `TestAnOfflineDoseIsVisibleAsOffline` |
| The round shows what is still outstanding | `TestTheRoundShowsWhatIsStillOutstanding` |
| Ending downtime is not the same as reconciling it | `TestEndingDowntimeIsNotTheSameAsReconcilingIt` (both layers) |
| A downtime episode needs a unit and a reason | `TestADowntimeEpisodeNeedsAUnitAndAReason` |
| A care plan's interventions generate the worklist | `TestACarePlansInterventionsGenerateTheWorklist`, `TestACarePlansInterventionsAppearInTheWorklist` |
| A resolved problem and a closed plan generate no work | `TestAResolvedProblemAndAClosedPlanGenerateNoWork`, `TestAContinuousInterventionSchedulesNothing` |
| A care-plan problem needs a goal | `TestACarePlanProblemNeedsAGoal` |
| Reviewing a care plan records the evaluation | `TestReviewingACarePlanRecordsTheEvaluation` |
| Completing a task needs evidence of what was done | `TestCompletingATaskNeedsEvidenceOfWhatWasDone`, `TestCompletingRecurringWorkNeedsEvidenceAndDoesNotDrift` |
| Recurring work does not drift later each round | `TestRecurringWorkDoesNotDriftLaterEachRound` |
| A one-off task produces no next occurrence, and a recurrence stops at its end | `TestAOneOffTaskProducesNoNextOccurrence`, `TestARecurrenceStopsAtItsEnd` |
| Only overdue critical tasks escalate, and only once | `TestOnlyOverdueCriticalTasksEscalate`, `TestOnlyOverdueCriticalWorkEscalates` |
| A deliberate omission is not the same as an undone task | `TestADeliberateOmissionIsNotTheSameAsAnUndoneTask`, `TestANotDoneTaskNeedsAReason` |
| A task needs a due time | `TestATaskNeedsADueTime` |
| The worklist puts the most urgent and most overdue first | `TestTheWorklistPutsTheMostUrgentAndMostOverdueFirst` |
| A handover is acknowledged before responsibility moves, and captures the ward | `TestAHandoverIsAcknowledgedBeforeResponsibilityMoves`, `TestAHandoverCapturesTheWardAndIsAcceptedBySomebodyElse` |
| A nurse cannot acknowledge their own handover, and a handover is acknowledged once | `TestANurseCannotAcknowledgeTheirOwnHandover`, `TestAHandoverIsAcknowledgedOnce` |
| An unacknowledged handover is visible as such | `TestAnUnacknowledgedHandoverIsVisibleAsSuch` |
| A handover names its shifts and says what the incoming shift should do | `TestAHandoverNamesTheShiftsItIsBetween`, `TestAHandoverNeedsWhatTheIncomingShiftShouldDo` |
| A handover is a snapshot, not a live view | `TestAHandoverIsASnapshotNotALiveView` |
| An expired restraint authorisation alerts without ending the restraint | `TestAnExpiredAuthorizationAlertsWithoutEndingTheRestraint`, `TestAnExpiredRestraintAuthorizationAlertsWithoutFreeingThePatient` |
| A restraint authorisation must expire, and cannot run past the ceiling | `TestARestraintAuthorizationMustExpire`, `TestARestraintAuthorizationCannotRunPastTheCeiling` |
| A restraint needs an indication and a named authoriser | `TestARestraintNeedsAnIndicationAndANamedAuthoriser` |
| Renewing a restraint keeps the earlier authorisations, and must extend them | `TestRenewingARestraintKeepsTheEarlierAuthorizations`, `TestARenewalMustExtendTheAuthorization` |
| A restraint check must say why the restraint is still needed | `TestARestraintCheckMustSayWhyTheRestraintIsStillNeeded` |
| A restrained patient not checked in time is overdue | `TestARestrainedPatientNotCheckedInTimeIsOverdue` |
| A discontinued restraint takes no more checks | `TestADiscontinuedRestraintTakesNoMoreChecks` |
| A transfusion needs a baseline before it starts | `TestATransfusionNeedsABaselineBeforeItStarts` |
| A temperature rise is reported against the baseline | `TestATemperatureRiseIsReportedAgainstTheBaseline` |
| A transfusion needs a second person's bedside check and the pack's unit number | `TestATransfusionNeedsASecondPersonsBedsideCheck`, `TestATransfusionNeedsTheUnitNumberOfThePack` |
| Reporting a reaction stops the transfusion | `TestReportingAReactionStopsTheTransfusion`, `TestReportingATransfusionReactionStopsIt` |
| A reaction needs the action taken | `TestAReactionNeedsTheActionTaken` |
| A completed transfusion is distinct from a stopped one | `TestACompletedTransfusionIsDistinctFromAStoppedOne` |
| A wound photograph needs a consent that covers it | `TestAWoundPhotographNeedsAConsentThatCoversIt`, `TestAWoundPhotographIsRefusedWithoutConsent` |
| Wound images are added in sequence and never replaced | `TestWoundImagesAreAddedInSequenceAndNeverReplaced` |
| A pressure injury needs its stage, and a wound assessment says which wound | `TestAPressureInjuryNeedsItsStage` (both layers), `TestAWoundAssessmentSaysWhichWoundItIsOf` |
| An education record stores whether the teaching was understood | `TestAnEducationRecordStoresWhetherItWasUnderstood` |
| Teaching somebody other than the patient must name them | `TestTeachingSomebodyOtherThanThePatientMustNameThem` |
| Discharge readiness lists everything outstanding | `TestDischargeReadinessListsEverythingOutstanding`, `TestDischargeReadinessNamesWhatIsOutstanding` |
| A nurse assignment is answered as of a time | `TestANurseAssignmentIsAnsweredAsOfATime`, `TestWhoWasLookingAfterThePatientIsAnsweredAsOfATime` |
| An assignment cannot end before it began, and needs a patient or a bed | `TestAnAssignmentCannotEndBeforeItBegan`, `TestAnAssignmentNeedsAPatientOrABed` |
| An acuity score carries the weights it was computed with | `TestAnAcuityScoreCarriesTheWeightsItWasComputedWith` |
| The acuity dashboard reports and never staffs the ward | `TestTheAcuityDashboardReportsAndNeverStaffsTheWard` |
| A unit with nobody on duty reports no per-nurse figure | `TestAUnitWithNobodyOnDutyReportsNoPerNurseFigure` |
| A closed encounter takes no new observations | `TestAClosedEncounterTakesNoNewObservations` |
| Administering emits an event carrying no clinical reasoning | `TestAdministeringEmitsAnEventCarryingNoClinicalReasoning` |
| A nursing record cannot be reached from another tenant | `TestANursingRecordCannotBeReachedFromAnotherTenant` |

### Decisions taken against the backlog

**SRS-ENC-008's override is a permission of its own.** The requirement says
"with emergency override where policy allows", which is two controls, not one:
policy decides which encounter classes can be forced at all, and a permission
decides who may do it. Implemented as `enc.encounter.override`, held by
clinicians and not by clerks, so a hospital can withhold it from junior staff.
The control that actually bites, though, is the mandatory reason and the stored
report it feeds — a permission everybody holds is not a permission, and an
override nobody counts is not a control.

**Recording a diagnosis is separated from managing an encounter.** A clerk
opens and closes encounters all day; what is wrong with the patient is a
clinical act. Behind one permission every receptionist could enter a diagnosis
under their own name. Implemented as a distinct `enc.diagnosis.record`, pinned
by `TestAClerkCannotRecordADiagnosis`.

**SRS-CLN-009's signature is a permission separate from writing.** The
requirement bundles composing and signing into "document clinical notes", but a
ward clerk typing up a dictated round is doing data entry, and the signature is
a clinician asserting responsibility for a clinical judgement. Behind one
permission, the desk would be signing notes. Implemented as `cln.record.write`
for composition and `cln.document.sign` for the assertion, pinned by
`TestAClerkCanTypeANoteButNotSignIt`.

**The clerk who types notes deliberately cannot read them back.** This looks
wrong until you ask what the alternative grants: a clerk who holds
`cln.record.read` holds the clinical record of every patient they book, which
is the largest quiet disclosure surface in the system. Transcription needs write
and does not need read, so the clerk gets write alone. The same reasoning is why
`cln.record.configure` — note templates, smart phrases and the escalation policy
— sits with the tenant admin and carries no read: deciding what a note asks and
reading what it says are different jobs.

**Reading restricted content is its own permission, not a tier of the read
permission.** SRS-CLN-019 asks for "narrower role/purpose authorization", and a
narrower tier inside one permission is a tier that every future feature has to
remember to check. `cln.record.read_restricted` is a distinct grant, so the
default answer for any code path that forgets to ask is *no*.

**SRS-CLN-011's "UI must not infer criticality" is enforced at the domain, not
the UI.** A requirement written against the user interface is a requirement that
holds until the second client is written. The interpretation arrives with the
result and carries the name of the service that assigned it; an interpretation
with no named source is refused before it is stored, so there is no path by
which a client could supply one. Pinned by `TestAnInterpretationMustNameItsSource`.

**Nursing is a role, not a variant of clinician.** The backlog's actor list
names "Nurse" and "Nurse Manager" separately from "Clinician", and the
permission sets turn out to differ in both directions: a nurse gives medication
and applies restraints, a doctor prescribes and signs clinical documents and
records diagnoses. Folding nursing into the clinician role would hand every
junior doctor the administration and restraint permissions and every nurse the
diagnosis one, and both directions are wrong. Implemented as `nurse` and
`nurse_manager` roles. The manager role deliberately does not carry
`nur.medication.administer`: a manager who is also rostered to give medication
holds the nurse role as well, so "who may give a drug" stays answerable from
the roles alone.

**Giving a drug is its own permission, and so is overriding the barcode
check.** SRS-NUR-009 reads as one act, but the eMAR exists to record the moment
a drug goes into a patient, and behind a general nursing-write permission a ward
clerk could chart a dose under their own name. Implemented as
`nur.medication.administer`, pinned by `TestOnlyANurseCanChartAnAdministration`.
SRS-NUR-008's override is separated again as `nur.medication.override`, so a
hospital can restrict it — though the control that actually bites is the
mandatory reason and the report it feeds, not scarcity of the permission, and a
nurse who cannot override when the trolley scanner fails at 03:00 will chart the
dose somewhere the system cannot see.

**SRS-NUR-007's medication seam is left unwired rather than stubbed.** The
requirement's whole content is that only pharmacist-verified orders produce
administration tasks, and a stub answering "verified" would be that safety
control present in the code and absent in effect. The port is declared, the eMAR
is written against it, and with nothing wired every administration is refused
with a message naming the missing service. Sprint 5's SRS-MED supplies the
adapter.

**SRS-NUR-018's duplicate guard is a database constraint, not an application
check.** The requirement is about reconciliation after downtime, where the same
paper entry is genuinely submitted twice by two different people. A
check-then-insert would let both through when they overlap, and a
client-generated identifier cannot help because the two transcriptions are
separate submissions by construction. Implemented as a partial unique index on
(tenant, order, scheduled time) — the tuple that is written on the paper chart
and read by both transcribers — with the adapter turning the constraint
violation into a refusal that names the record already there. Pinned by
`TestRekeyingAPaperChartTwiceCannotDuplicateADose`, and the index's necessity
was confirmed by re-keying it on the submission identifier and watching the test
fail.

**The device-day counting convention is written down in the code.** SRS-NUR-006
says device-days are calculated from canonical dates and stops there, but the
convention matters as much as the source: an inclusive calendar-day count in UTC
is not the same number as an elapsed-hours-divided-by-24 count, and an infection
rate is only comparable between hospitals when everybody counts the same way.
The convention, and the reason for the UTC boundary, are stated at
`Device.DeviceDays`.

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
