package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// RetentionAnchor is the event a retention period runs from (SRS-MRD-009).
//
// Named rather than assumed, because the anchor is where retention schedules
// actually differ: a minor's record runs from their eighteenth birthday, not
// from the discharge, and a schedule that anchored everything to discharge
// would destroy children's records years early.
type RetentionAnchor string

const (
	AnchorDischarge   RetentionAnchor = "discharge"
	AnchorLastContact RetentionAnchor = "last_contact"
	// AnchorMajority is the patient's eighteenth birthday.
	AnchorMajority RetentionAnchor = "majority"
	AnchorDeath    RetentionAnchor = "death"
	AnchorCreation RetentionAnchor = "creation"
)

var knownAnchor = map[RetentionAnchor]bool{
	AnchorDischarge: true, AnchorLastContact: true, AnchorMajority: true,
	AnchorDeath: true, AnchorCreation: true,
}

// DispositionKind is what happens at the end of a retention period
// (SRS-MRD-009).
type DispositionKind string

const (
	DispositionDestroy DispositionKind = "destroy"
	// DispositionArchive moves a record out of the live system and keeps it.
	DispositionArchive DispositionKind = "archive"
	// DispositionPermanent never disposes. A hospital's own historical
	// registers, a research cohort with its own undertaking.
	DispositionPermanent DispositionKind = "permanent"
)

var knownDisposition = map[DispositionKind]bool{
	DispositionDestroy: true, DispositionArchive: true,
	DispositionPermanent: true,
}

// RetentionRule is how long one class of record is kept in one jurisdiction
// (SRS-MRD-009).
//
// Versioned and approved like every other rule a hospital is held to. A
// retention period shortened in place would make a record destroyed last year
// look compliant against this year's schedule, which is the reverse of what a
// retention schedule is for.
type RetentionRule struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	// RecordClass is what the rule covers — inpatient episode, imaging
	// study, birth register.
	RecordClass string
	// Jurisdiction is whose law it follows. A group operating in two states
	// keeps two schedules and each record follows the one its facility is in.
	Jurisdiction string

	Anchor RetentionAnchor
	// RetainYears is how long after the anchor. Zero with a destroy
	// disposition would destroy on the anchor date, which nobody means.
	RetainYears int
	Disposition DispositionKind

	// Authority is the statute or standard this comes from. Held because the
	// first question about a destruction is which rule allowed it.
	Authority string

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a rule in force at a moment.
func (r RetentionRule) Live(at time.Time) bool {
	if !r.Approved {
		return false
	}
	if r.EffectiveFrom.IsZero() || r.EffectiveFrom.After(at) {
		return false
	}
	return r.SupersededAt.IsZero() || r.SupersededAt.After(at)
}

// NewRetentionRuleInput configures a retention rule.
type NewRetentionRuleInput struct {
	Code          string
	Name          string
	Revision      int
	RecordClass   string
	Jurisdiction  string
	Anchor        RetentionAnchor
	RetainYears   int
	Disposition   DispositionKind
	Authority     string
	EffectiveFrom time.Time
}

// NewRetentionRule configures a retention rule (SRS-MRD-009).
func NewRetentionRule(id, tenantID string, in NewRetentionRuleInput,
	by string, now time.Time) (RetentionRule, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RetentionRule{}, fmt.Errorf("%w: a rule needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Code) == "":
		return RetentionRule{}, fmt.Errorf("%w: a rule needs a code",
			ErrInvalidRecord)
	case in.Revision <= 0:
		return RetentionRule{}, fmt.Errorf("%w: a rule revision starts at 1",
			ErrInvalidRecord)
	case strings.TrimSpace(in.RecordClass) == "":
		return RetentionRule{}, fmt.Errorf(
			"%w: a rule names the record class it covers", ErrInvalidRecord)
	case strings.TrimSpace(in.Jurisdiction) == "":
		// A schedule with no jurisdiction is a schedule nobody can defend to
		// a regulator, and a group in two states needs two.
		return RetentionRule{}, fmt.Errorf(
			"%w: a rule names the jurisdiction whose law it follows",
			ErrInvalidRecord)
	case !knownAnchor[in.Anchor]:
		return RetentionRule{}, fmt.Errorf("%w: unknown retention anchor %q",
			ErrInvalidRecord, in.Anchor)
	case !knownDisposition[in.Disposition]:
		return RetentionRule{}, fmt.Errorf("%w: unknown disposition %q",
			ErrInvalidRecord, in.Disposition)
	case in.RetainYears < 0:
		return RetentionRule{}, fmt.Errorf(
			"%w: a retention period cannot be negative", ErrInvalidRecord)
	case in.Disposition != DispositionPermanent && in.RetainYears == 0:
		// Zero years with a destroy disposition destroys on the anchor date.
		return RetentionRule{}, fmt.Errorf(
			"%w: a rule that disposes names how long the record is kept first",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Authority) == "":
		return RetentionRule{}, fmt.Errorf(
			"%w: a rule names the statute or standard it rests on",
			ErrInvalidRecord)
	}

	return RetentionRule{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision:     in.Revision,
		RecordClass:  strings.TrimSpace(in.RecordClass),
		Jurisdiction: strings.TrimSpace(in.Jurisdiction),
		Anchor:       in.Anchor, RetainYears: in.RetainYears,
		Disposition:   in.Disposition,
		Authority:     strings.TrimSpace(in.Authority),
		EffectiveFrom: utcOrZero(in.EffectiveFrom),
		CreatedAt:     now.UTC(), CreatedBy: by,
	}, nil
}

// Approve puts a retention rule in force (SRS-MRD-009).
//
// Refused for its author, like every rule that decides what the hospital
// destroys.
func (r *RetentionRule) Approve(by string, effectiveFrom, now time.Time) error {
	switch {
	case r.Approved:
		return fmt.Errorf("%w: this rule is already approved", ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidRecord)
	case by == r.CreatedBy:
		return fmt.Errorf("%w: the author of a retention rule cannot approve it",
			ErrInvalidRecord)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved rule names when it takes effect",
			ErrInvalidRecord)
	}
	r.Approved, r.ApprovedBy, r.ApprovedAt = true, by, now.UTC()
	r.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// RuleFor picks the rule that applies to a record class in a jurisdiction
// (SRS-MRD-009).
//
// Nothing is defaulted. A record class nobody has written a rule for is never
// eligible for destruction, which is the safe direction: the failure mode of
// keeping a record too long is a storage bill, and the failure mode of the
// other is a record that no longer exists.
func RuleFor(rules []RetentionRule, recordClass, jurisdiction string,
	at time.Time) (RetentionRule, bool) {

	var best RetentionRule
	found := false
	for _, rule := range rules {
		if !rule.Live(at) {
			continue
		}
		if !strings.EqualFold(rule.RecordClass, recordClass) {
			continue
		}
		if !strings.EqualFold(rule.Jurisdiction, jurisdiction) {
			continue
		}
		if !found || rule.EffectiveFrom.After(best.EffectiveFrom) ||
			(rule.EffectiveFrom.Equal(best.EffectiveFrom) &&
				rule.Revision > best.Revision) {
			best, found = rule, true
		}
	}
	return best, found
}

// RetainedRecord is one thing the hospital is holding (SRS-MRD-009).
type RetainedRecord struct {
	RecordID     string
	PatientID    string
	EncounterID  string
	RecordClass  string
	Jurisdiction string
	// AnchorDates carries the dates the rules anchor to. A record whose rule
	// anchors to a date nobody supplied is never eligible, and the candidate
	// list says why.
	AnchorDates map[RetentionAnchor]time.Time
	Description string
}

// DispositionCandidate is a record whose retention period has run
// (SRS-MRD-009).
type DispositionCandidate struct {
	RecordID    string
	PatientID   string
	RecordClass string
	Description string

	RuleCode     string
	RuleRevision int
	Authority    string
	Disposition  DispositionKind
	AnchorDate   time.Time
	EligibleFrom time.Time
}

// Ineligible is a record that was considered and passed over (SRS-MRD-009).
//
// Returned alongside the candidates rather than dropped, because "why is this
// record not on the destruction list" is the question a records manager
// actually asks, and silence is not an answer. It is also where a legal hold
// becomes visible: the record is named, with the hold as the reason.
type Ineligible struct {
	RecordID string
	Reason   string
}

// The reasons a record is passed over.
const (
	IneligibleHeld      = "under legal hold"
	IneligibleNoRule    = "no retention rule covers this class and jurisdiction"
	IneligibleNoAnchor  = "the rule's anchor date is not recorded"
	IneligibleNotDue    = "the retention period has not run"
	IneligiblePermanent = "the rule keeps this class permanently"
)

// EligibleForDisposition lists the records whose retention has run
// (SRS-MRD-005, SRS-MRD-009).
//
// held answers whether a record is under legal hold, and is asked for every
// record. SRS-MRD-005's acceptance is that held records are excluded from
// retention deletion, and the check happens here — before the list is even
// shown to anybody — rather than at the point of destruction, because a list
// that includes held records is a list somebody approves.
//
// The hold check runs first, before the rule lookup. A held record is
// excluded whatever its retention says, including a class nobody wrote a rule
// for, which keeps the two reasons from masking each other.
func EligibleForDisposition(records []RetainedRecord, rules []RetentionRule,
	held func(recordID string) bool, at time.Time) (
	[]DispositionCandidate, []Ineligible) {

	var candidates []DispositionCandidate
	var passed []Ineligible

	for _, record := range records {
		if held != nil && held(record.RecordID) {
			passed = append(passed, Ineligible{
				RecordID: record.RecordID, Reason: IneligibleHeld,
			})
			continue
		}

		rule, ok := RuleFor(rules, record.RecordClass, record.Jurisdiction, at)
		if !ok {
			passed = append(passed, Ineligible{
				RecordID: record.RecordID, Reason: IneligibleNoRule,
			})
			continue
		}
		if rule.Disposition == DispositionPermanent {
			passed = append(passed, Ineligible{
				RecordID: record.RecordID, Reason: IneligiblePermanent,
			})
			continue
		}

		anchor, dated := record.AnchorDates[rule.Anchor]
		if !dated || anchor.IsZero() {
			passed = append(passed, Ineligible{
				RecordID: record.RecordID, Reason: IneligibleNoAnchor,
			})
			continue
		}

		eligibleFrom := anchor.AddDate(rule.RetainYears, 0, 0).UTC()
		if at.Before(eligibleFrom) {
			passed = append(passed, Ineligible{
				RecordID: record.RecordID, Reason: IneligibleNotDue,
			})
			continue
		}

		candidates = append(candidates, DispositionCandidate{
			RecordID: record.RecordID, PatientID: record.PatientID,
			RecordClass: record.RecordClass,
			Description: record.Description,
			RuleCode:    rule.Code, RuleRevision: rule.Revision,
			Authority: rule.Authority, Disposition: rule.Disposition,
			AnchorDate: anchor.UTC(), EligibleFrom: eligibleFrom,
		})
	}

	sort.Slice(candidates, func(a, b int) bool {
		if candidates[a].EligibleFrom.Equal(candidates[b].EligibleFrom) {
			return candidates[a].RecordID < candidates[b].RecordID
		}
		return candidates[a].EligibleFrom.Before(candidates[b].EligibleFrom)
	})
	sort.Slice(passed, func(a, b int) bool {
		return passed[a].RecordID < passed[b].RecordID
	})
	return candidates, passed
}

// DispositionState is where a disposition list stands.
type DispositionState string

const (
	DispositionDraft     DispositionState = "draft"
	DispositionApproved  DispositionState = "approved"
	DispositionExecuted  DispositionState = "executed"
	DispositionCancelled DispositionState = "cancelled"
)

// DispositionList is a batch of records proposed for destruction or archival
// (SRS-MRD-009).
//
// Approval controlled, which is the requirement's acceptance, and the
// approver is not the preparer. Destroying records is the one operation in
// this system with no undo.
type DispositionList struct {
	ID       string
	TenantID string

	Reference string
	// Jurisdiction and Disposition are what this batch is. One kind at a
	// time: a list mixing archival and destruction is a list where an
	// approver ticks one and gets both.
	Jurisdiction string
	Disposition  DispositionKind

	Items []DispositionCandidate

	State DispositionState

	PreparedAt time.Time
	PreparedBy string
	ApprovedAt time.Time
	ApprovedBy string
	ExecutedAt time.Time
	ExecutedBy string
	// Certificate is the reference of the destruction certificate, where the
	// jurisdiction requires one.
	Certificate     string
	CancelledReason string
	Version         int64
}

// PrepareDisposition builds a list from candidates (SRS-MRD-009).
func PrepareDisposition(id, tenantID, reference, jurisdiction string,
	disposition DispositionKind, candidates []DispositionCandidate,
	by string, now time.Time) (DispositionList, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DispositionList{}, fmt.Errorf("%w: a list needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(jurisdiction) == "":
		return DispositionList{}, fmt.Errorf(
			"%w: a list names its jurisdiction", ErrInvalidRecord)
	case !knownDisposition[disposition] ||
		disposition == DispositionPermanent:
		return DispositionList{}, fmt.Errorf(
			"%w: a list disposes by destroying or archiving",
			ErrInvalidRecord)
	case len(candidates) == 0:
		return DispositionList{}, fmt.Errorf("%w: a list with nothing on it",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return DispositionList{}, fmt.Errorf("%w: a list names who prepared it",
			ErrInvalidRecord)
	}

	seen := map[string]bool{}
	for _, candidate := range candidates {
		switch {
		case strings.TrimSpace(candidate.RecordID) == "":
			return DispositionList{}, fmt.Errorf(
				"%w: every item on a list names its record", ErrInvalidRecord)
		case seen[candidate.RecordID]:
			return DispositionList{}, fmt.Errorf(
				"%w: record %s is on the list twice",
				ErrInvalidRecord, candidate.RecordID)
		case candidate.Disposition != disposition:
			// A list mixing archival and destruction is a list where an
			// approver ticks one and gets both.
			return DispositionList{}, fmt.Errorf(
				"%w: record %s is for %s, not %s", ErrInvalidRecord,
				candidate.RecordID, candidate.Disposition, disposition)
		case candidate.RuleCode == "":
			// The first question about a destruction is which rule allowed
			// it.
			return DispositionList{}, fmt.Errorf(
				"%w: record %s does not name the rule that made it eligible",
				ErrInvalidRecord, candidate.RecordID)
		}
		seen[candidate.RecordID] = true
	}

	items := make([]DispositionCandidate, len(candidates))
	copy(items, candidates)
	return DispositionList{
		ID: id, TenantID: tenantID,
		Reference:    strings.TrimSpace(reference),
		Jurisdiction: strings.TrimSpace(jurisdiction),
		Disposition:  disposition, Items: items,
		State: DispositionDraft, PreparedAt: now.UTC(), PreparedBy: by,
		Version: 1,
	}, nil
}

// ApproveDisposition authorises a batch (SRS-MRD-009).
//
// Refused for the preparer. This is the last check before records stop
// existing, and one person preparing and approving it is one person deciding
// what the hospital no longer has.
func (l *DispositionList) ApproveDisposition(by string, now time.Time) error {
	switch {
	case l.State != DispositionDraft:
		return fmt.Errorf("%w: this list is already %s",
			ErrInvalidRecord, l.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidRecord)
	case by == l.PreparedBy:
		return fmt.Errorf(
			"%w: the person who prepared a disposition list cannot approve it",
			ErrInvalidRecord)
	}
	l.State = DispositionApproved
	l.ApprovedAt, l.ApprovedBy = now.UTC(), by
	return nil
}

// Execute records the disposition happening (SRS-MRD-005, SRS-MRD-009).
//
// held is asked again, for every item, at the moment of execution. A hold
// placed between approval and execution is the case this exists for: the list
// was lawful when it was approved and one of its records is now evidence, and
// a system that checked only at approval would destroy it.
func (l *DispositionList) Execute(held func(recordID string) bool,
	certificate, by string, now time.Time) error {

	switch {
	case l.State != DispositionApproved:
		return fmt.Errorf("%w: this list is %s and has not been approved",
			ErrInvalidRecord, l.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an execution names who carried it out",
			ErrInvalidRecord)
	}

	if held != nil {
		var blocked []string
		for _, item := range l.Items {
			if held(item.RecordID) {
				blocked = append(blocked, item.RecordID)
			}
		}
		if len(blocked) > 0 {
			sort.Strings(blocked)
			return fmt.Errorf(
				"%w: %d record(s) on this list came under legal hold after it "+
					"was approved: %s", ErrInvalidRecord, len(blocked),
				strings.Join(blocked, ", "))
		}
	}

	l.State = DispositionExecuted
	l.ExecutedAt, l.ExecutedBy = now.UTC(), by
	l.Certificate = strings.TrimSpace(certificate)
	return nil
}

// Cancel abandons a list (SRS-MRD-009).
func (l *DispositionList) Cancel(reason, by string, now time.Time) error {
	switch {
	case l.State == DispositionExecuted:
		return fmt.Errorf("%w: this list has already been executed",
			ErrInvalidRecord)
	case l.State == DispositionCancelled:
		return fmt.Errorf("%w: this list is already cancelled", ErrInvalidRecord)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the list was cancelled", ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a cancellation names who made it",
			ErrInvalidRecord)
	}
	l.State, l.CancelledReason = DispositionCancelled, strings.TrimSpace(reason)
	l.ExecutedAt, l.ExecutedBy = now.UTC(), by
	return nil
}
