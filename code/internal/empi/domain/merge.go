package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Merge, unmerge and the duplicate review queue (SRS-EMPI-004/005/006).
//
// Merging is the most destructive operation in this system. It takes two
// records that might be one person and makes them one — and if that judgement
// was wrong, two people's allergies, medications and diagnoses are now in a
// single chart that reads as coherent. Nothing about the resulting record looks
// broken, which is why the damage is found by a reaction rather than by a
// report.
//
// Three rules follow, and they shape everything in this file:
//
//  1. A merge is always a human decision. The scorer routes; it never merges.
//  2. A merge is never destructive at the storage level. The losing record
//     keeps its row, its identifiers are moved rather than deleted, and the
//     journal records exactly what moved — because an unmerge has to put it
//     all back (SRS-EMPI-006).
//  3. Where the evidence says "different people", the merge is refused rather
//     than confirmed. Two different national health identifiers is the clearest
//     case: a human clicking "merge" on that pair has misread something.

// ErrMergeRefused reports a merge the domain will not perform.
var ErrMergeRefused = errors.New("empi: merge refused")

// ErrUnmergeRefused reports an unmerge that cannot be performed safely.
var ErrUnmergeRefused = errors.New("empi: unmerge refused")

// ReviewStatus is where a candidate pair sits.
type ReviewStatus string

const (
	// ReviewOpen is awaiting a decision.
	ReviewOpen ReviewStatus = "open"
	// ReviewMerged was resolved by merging the pair.
	ReviewMerged ReviewStatus = "merged"
	// ReviewDismissed was judged to be two different people. Recorded rather
	// than deleted, so the same pair does not come back to the queue every
	// time one of them is touched.
	ReviewDismissed ReviewStatus = "dismissed"
)

// DuplicateCandidate is one pair awaiting or past review (SRS-EMPI-004).
//
// The queue exists because "thresholds route to manual review" needs somewhere
// to route to. Without it, a clerk who acknowledges a probable duplicate and
// registers anyway has made the decision alone, at a busy desk, with a patient
// waiting — and nobody ever looks at the pair again.
type DuplicateCandidate struct {
	ID       string
	TenantID string
	// PatientAID and PatientBID are stored in a canonical order — the lower
	// identifier first — so that the same pair discovered from either side is
	// one row rather than two.
	PatientAID string
	PatientBID string
	Score      float64
	Outcome    MatchOutcome
	Status     ReviewStatus
	// DetectedBy says what surfaced the pair: a registration, a bulk scan, an
	// operator. It matters when deciding how much to trust the score.
	DetectedBy string
	DetectedAt time.Time
	ReviewedBy string
	ReviewedAt *time.Time
	// Resolution explains a dismissal or names the merge that resolved it.
	Resolution string
}

// NewDuplicateCandidate constructs a review-queue entry.
func NewDuplicateCandidate(id, tenantID, first, second string,
	score float64, outcome MatchOutcome, detectedBy string, now time.Time) (DuplicateCandidate, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DuplicateCandidate{}, fmt.Errorf("%w: id is required", ErrInvalidPatient)
	case strings.TrimSpace(tenantID) == "":
		return DuplicateCandidate{}, fmt.Errorf("%w: tenant is required", ErrInvalidPatient)
	case first == "" || second == "":
		return DuplicateCandidate{}, fmt.Errorf("%w: a candidate needs two patients", ErrInvalidPatient)
	case first == second:
		return DuplicateCandidate{}, fmt.Errorf("%w: a patient cannot duplicate itself", ErrInvalidPatient)
	case strings.TrimSpace(detectedBy) == "":
		return DuplicateCandidate{}, fmt.Errorf("%w: a candidate needs a detection source", ErrInvalidPatient)
	}

	a, b := canonicalPair(first, second)
	return DuplicateCandidate{
		ID: id, TenantID: tenantID, PatientAID: a, PatientBID: b,
		Score: score, Outcome: outcome, Status: ReviewOpen,
		DetectedBy: detectedBy, DetectedAt: now.UTC(),
	}, nil
}

// canonicalPair orders two identifiers so a pair has one spelling.
func canonicalPair(first, second string) (string, string) {
	if first <= second {
		return first, second
	}
	return second, first
}

// Dismiss records that the pair is two different people.
func (c *DuplicateCandidate) Dismiss(by, reason string, now time.Time) error {
	if c.Status != ReviewOpen {
		return fmt.Errorf("%w: candidate %s is already %s", ErrInvalidPatient, c.ID, c.Status)
	}
	if strings.TrimSpace(reason) == "" {
		// A dismissal with no reason is indistinguishable from a mis-click,
		// and the pair never returns to the queue to be reconsidered.
		return fmt.Errorf("%w: dismissing a candidate needs a reason", ErrInvalidPatient)
	}
	at := now.UTC()
	c.Status = ReviewDismissed
	c.ReviewedBy = by
	c.ReviewedAt = &at
	c.Resolution = normaliseText(reason)
	return nil
}

// Resolve records that the pair was merged.
func (c *DuplicateCandidate) Resolve(by, mergeID string, now time.Time) {
	at := now.UTC()
	c.Status = ReviewMerged
	c.ReviewedBy = by
	c.ReviewedAt = &at
	c.Resolution = "merge:" + mergeID
}

// MovedIdentifier records one identifier's journey during a merge.
//
// Stored in the journal because an unmerge has to put it back exactly: which
// row moved, from whom, and what its status was before. Re-deriving that from
// the current state is impossible once a second merge has touched the same
// identifiers.
type MovedIdentifier struct {
	IdentifierID string
	// FromPatientID is the record it belonged to before the merge.
	FromPatientID string
	// PreviousStatus is what it was before the merge changed it.
	PreviousStatus IdentifierStatus
	// PreviousPrimary is whether it was the banner identifier.
	PreviousPrimary bool
}

// MergeRecord is the journal entry for one merge (SRS-EMPI-005/006).
type MergeRecord struct {
	ID       string
	TenantID string
	// SurvivorID keeps its own patient id. A merge never changes an internal
	// identifier — that is the point of SRS-EMPI-002.
	SurvivorID string
	MergedID   string
	// MergedPreviousStatus is what the losing record was before it lost, so an
	// unmerge restores the right state rather than guessing at "active".
	MergedPreviousStatus Status
	Reason               string
	PerformedBy          string
	PerformedAt          time.Time
	MovedIdentifiers     []MovedIdentifier
	// CarriedDeceased records that the survivor inherited a deceased record it
	// did not have, so an unmerge can take it back off.
	CarriedDeceased bool

	// Undone marks a merge that has been reversed.
	Undone     bool
	UndoneBy   string
	UndoneAt   *time.Time
	UndoReason string
}

// MergePlan is the outcome of deciding a merge, before anything is written.
//
// Separating the decision from the writing is what lets the refusals below be
// unit-tested without a database, and what keeps the transaction that performs
// a merge free of judgement.
type MergePlan struct {
	Survivor *Patient
	Merged   *Patient
	// MoveToSurvivor lists the losing record's identifiers and the status each
	// takes on the survivor.
	MoveToSurvivor []PlannedMove
	// CarryDeceased is set when the survivor inherits the losing record's
	// deceased status.
	CarryDeceased bool
}

// PlannedMove is one identifier's intended destination.
type PlannedMove struct {
	Identifier Identifier
	// NewStatus on the survivor. An MRN becomes superseded — the survivor
	// already has one, and two active MRNs would give a banner two answers —
	// while an identifier the survivor lacks moves across still active.
	NewStatus IdentifierStatus
}

// PlanMerge decides whether two records may be merged and what would move.
//
// Refuses rather than resolves wherever the evidence is contradictory. A human
// has clicked "merge", and the cases below are the ones where that human has
// misread something — so the right answer is to stop them, not to record their
// intent faithfully.
func PlanMerge(survivor, merged *Patient, survivorIdentifiers,
	mergedIdentifiers IdentifierSet) (MergePlan, error) {

	switch {
	case survivor == nil || merged == nil:
		return MergePlan{}, fmt.Errorf("%w: two patients are required", ErrMergeRefused)
	case survivor.ID() == merged.ID():
		return MergePlan{}, fmt.Errorf("%w: a patient cannot be merged into itself", ErrMergeRefused)
	case survivor.TenantID != merged.TenantID:
		// Unreachable through the repository, which cannot be called without a
		// tenant scope. Checked anyway: this is the one operation where
		// crossing a tenant boundary would fuse two hospitals' patients.
		return MergePlan{}, fmt.Errorf("%w: patients belong to different tenants", ErrMergeRefused)
	case survivor.Status == StatusMerged:
		return MergePlan{}, fmt.Errorf("%w: the survivor %s is itself merged into %s",
			ErrMergeRefused, survivor.ID(), survivor.MergedIntoPatientID)
	case merged.Status == StatusMerged:
		return MergePlan{}, fmt.Errorf("%w: %s is already merged into %s",
			ErrMergeRefused, merged.ID(), merged.MergedIntoPatientID)
	}

	// The strong-identifier conflict. Two records holding different national
	// health or government identifiers are two people, whatever the
	// demographics suggest and whoever clicked merge.
	if conflict := strongIdentifierConflict(survivorIdentifiers, mergedIdentifiers); conflict != "" {
		return MergePlan{}, fmt.Errorf(
			"%w: the records hold different %s identifiers, which means they are different people",
			ErrMergeRefused, conflict)
	}

	plan := MergePlan{Survivor: survivor, Merged: merged}

	survivorHolds := map[string]bool{}
	for _, i := range survivorIdentifiers.Active() {
		survivorHolds[identifierKey(i)] = true
	}

	for _, i := range mergedIdentifiers {
		if i.Status == IdentifierRevoked {
			// A revoked identifier was attached in error. Moving it to the
			// survivor would re-attach somebody else's number to a live
			// record.
			continue
		}

		status := IdentifierSuperseded
		switch {
		case i.Type == IdentifierMRN:
			// The survivor keeps its own MRN as the one on the wristband. The
			// losing record's MRN moves across superseded, so a clerk typing
			// the old number still reaches this patient — which is most of
			// what "child references resolve to survivor" means in practice.
		case i.Status == IdentifierActive && !survivorHolds[identifierKey(i)]:
			// An identifier the survivor does not hold — a national health id,
			// an insurance number — moves across still active. Losing it would
			// make the merge destroy information.
			status = IdentifierActive
		}

		plan.MoveToSurvivor = append(plan.MoveToSurvivor, PlannedMove{Identifier: i, NewStatus: status})
	}

	// A recorded death must survive the merge. Losing it would let a deceased
	// patient be scheduled, which is the failure SRS-EMPI-008 exists to
	// prevent.
	if survivor.Deceased == nil && merged.Deceased != nil {
		plan.CarryDeceased = true
	}

	return plan, nil
}

// strongIdentifierConflict returns the identifier type that says these are
// different people, or empty when nothing does.
func strongIdentifierConflict(a, b IdentifierSet) string {
	for _, x := range a.Active() {
		if x.Type != IdentifierNationalHealth && x.Type != IdentifierGovernment {
			continue
		}
		for _, y := range b.Active() {
			if y.Type != x.Type || !strings.EqualFold(y.System, x.System) {
				continue
			}
			if !strings.EqualFold(strings.TrimSpace(x.Value), strings.TrimSpace(y.Value)) {
				return string(x.Type)
			}
		}
	}
	return ""
}

func identifierKey(i Identifier) string {
	return string(i.Type) + "|" + strings.ToLower(i.System) + "|" + strings.ToLower(i.Value)
}

// Apply mutates both aggregates to reflect the merge and returns the journal
// entry that would undo it.
func (p MergePlan) Apply(mergeID, performedBy, reason string, now time.Time) (MergeRecord, error) {
	if strings.TrimSpace(reason) == "" {
		// A merge with no reason cannot be reviewed afterwards, and the review
		// is the only thing standing between a mistake and two people's
		// records.
		return MergeRecord{}, fmt.Errorf("%w: a merge needs a reason", ErrMergeRefused)
	}
	if strings.TrimSpace(performedBy) == "" {
		return MergeRecord{}, fmt.Errorf("%w: a merge needs an actor", ErrMergeRefused)
	}

	record := MergeRecord{
		ID: mergeID, TenantID: p.Survivor.TenantID,
		SurvivorID:           p.Survivor.ID(),
		MergedID:             p.Merged.ID(),
		MergedPreviousStatus: p.Merged.Status,
		Reason:               normaliseText(reason),
		PerformedBy:          performedBy,
		PerformedAt:          now.UTC(),
		CarriedDeceased:      p.CarryDeceased,
	}

	for _, move := range p.MoveToSurvivor {
		record.MovedIdentifiers = append(record.MovedIdentifiers, MovedIdentifier{
			IdentifierID:    move.Identifier.ID,
			FromPatientID:   p.Merged.ID(),
			PreviousStatus:  move.Identifier.Status,
			PreviousPrimary: move.Identifier.Primary,
		})
	}

	if p.CarryDeceased {
		p.Survivor.Deceased = p.Merged.Deceased
		p.Survivor.touch(now)
	}

	if err := p.Merged.TransitionTo(StatusMerged, now); err != nil {
		return MergeRecord{}, fmt.Errorf("%w: %v", ErrMergeRefused, err)
	}
	p.Merged.MergedIntoPatientID = p.Survivor.ID()

	return record, nil
}

// UnmergeCheck is the set of conditions an unmerge must satisfy.
//
// Passed in rather than discovered here because the interesting ones are facts
// about other bounded contexts — whether a clinical document has been written
// against the survivor since the merge — and the identity domain cannot see
// them. Making them parameters keeps the rule here and the lookups where they
// belong.
type UnmergeCheck struct {
	// SurvivorMergedAgain reports that the survivor has since lost a merge of
	// its own. Unmerging through a chain would have to guess which of three
	// records each identifier belongs to.
	SurvivorMergedAgain bool
	// LaterMergeExists reports another merge into this survivor after this
	// one. Reversing an earlier merge while a later one stands would restore
	// identifiers the later merge has already moved again.
	LaterMergeExists bool
	// ClinicalRecordsSinceMerge counts records written against the survivor
	// after the merge.
	//
	// This is the condition that actually blocks an unmerge in practice, and
	// the reason is worth stating: a note written against the merged record
	// belongs to one of the two people, and nothing in the note says which.
	// Splitting the records again would attribute it by guess. In Sprint 1 no
	// clinical context exists, so this is always zero — the check is here so
	// that wiring it up later is one call site rather than a new rule.
	ClinicalRecordsSinceMerge int
}

// PlanUnmerge decides whether a merge can be reversed (SRS-EMPI-006).
//
// Returns a refusal carrying the reason, because the requirement is explicit
// that an unsafe unmerge "blocks with explicit reason" — an operator told only
// "no" will try again through the database.
func PlanUnmerge(record MergeRecord, survivor, merged *Patient, check UnmergeCheck) error {
	switch {
	case record.Undone:
		return fmt.Errorf("%w: merge %s has already been reversed", ErrUnmergeRefused, record.ID)
	case survivor == nil || merged == nil:
		return fmt.Errorf("%w: both records are required", ErrUnmergeRefused)
	case merged.Status != StatusMerged:
		return fmt.Errorf("%w: %s is %s rather than merged", ErrUnmergeRefused, merged.ID(), merged.Status)
	case merged.MergedIntoPatientID != survivor.ID():
		return fmt.Errorf("%w: %s is merged into %s, not into %s",
			ErrUnmergeRefused, merged.ID(), merged.MergedIntoPatientID, survivor.ID())
	case check.SurvivorMergedAgain:
		return fmt.Errorf("%w: %s has since been merged into another record; reverse that merge first",
			ErrUnmergeRefused, survivor.ID())
	case check.LaterMergeExists:
		return fmt.Errorf("%w: a later merge into %s must be reversed first",
			ErrUnmergeRefused, survivor.ID())
	case check.ClinicalRecordsSinceMerge > 0:
		return fmt.Errorf(
			"%w: %d clinical records have been written against %s since the merge, and nothing in them says which patient they belong to",
			ErrUnmergeRefused, check.ClinicalRecordsSinceMerge, survivor.ID())
	}
	return nil
}

// ApplyUnmerge restores both aggregates from the journal.
func ApplyUnmerge(record *MergeRecord, survivor, merged *Patient,
	performedBy, reason string, now time.Time) error {

	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: an unmerge needs a reason", ErrUnmergeRefused)
	}
	if strings.TrimSpace(performedBy) == "" {
		return fmt.Errorf("%w: an unmerge needs an actor", ErrUnmergeRefused)
	}

	// Back to what it was before it lost, from the journal rather than from a
	// default. A record that was a candidate before the merge is a candidate
	// after the unmerge; restoring it as active would silently confirm an
	// identity nobody verified.
	merged.MergedIntoPatientID = ""
	merged.Status = StatusMerged
	if err := merged.TransitionTo(record.MergedPreviousStatus, now); err != nil {
		return fmt.Errorf("%w: %v", ErrUnmergeRefused, err)
	}

	if record.CarriedDeceased {
		// The survivor inherited this at merge time and did not have it
		// before, so it goes back with the record it came from.
		survivor.Deceased = nil
		survivor.touch(now)
	}

	at := now.UTC()
	record.Undone = true
	record.UndoneBy = performedBy
	record.UndoneAt = &at
	record.UndoReason = normaliseText(reason)
	return nil
}
