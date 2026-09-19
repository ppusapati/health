package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// ComplainantKind is who is complaining (SRS-QMS-011).
type ComplainantKind string

const (
	ComplainantPatient  ComplainantKind = "patient"
	ComplainantRelative ComplainantKind = "relative"
	ComplainantVisitor  ComplainantKind = "visitor"
	ComplainantStaff    ComplainantKind = "staff"
	ComplainantExternal ComplainantKind = "external"
)

var knownComplainantKind = map[ComplainantKind]bool{
	ComplainantPatient: true, ComplainantRelative: true,
	ComplainantVisitor: true, ComplainantStaff: true,
	ComplainantExternal: true,
}

// Outcome is how a complaint was decided (SRS-QMS-011).
type Outcome string

const (
	OutcomeUpheld          Outcome = "upheld"
	OutcomePartiallyUpheld Outcome = "partially_upheld"
	OutcomeNotUpheld       Outcome = "not_upheld"
	OutcomeWithdrawn       Outcome = "withdrawn"
)

var knownOutcome = map[Outcome]bool{
	OutcomeUpheld: true, OutcomePartiallyUpheld: true,
	OutcomeNotUpheld: true, OutcomeWithdrawn: true,
}

// ComplaintState is where a grievance stands.
type ComplaintState string

const (
	ComplaintReceived      ComplaintState = "received"
	ComplaintAcknowledged  ComplaintState = "acknowledged"
	ComplaintInvestigating ComplaintState = "investigating"
	ComplaintResolved      ComplaintState = "resolved"
	ComplaintClosed        ComplaintState = "closed"
)

var knownComplaintState = map[ComplaintState]bool{
	ComplaintReceived: true, ComplaintAcknowledged: true,
	ComplaintInvestigating: true, ComplaintResolved: true,
	ComplaintClosed: true,
}

// Open reports a complaint still being worked.
func (s ComplaintState) Open() bool { return s != ComplaintClosed }

// Complaint is one grievance and its handling (SRS-QMS-011).
type Complaint struct {
	ID       string
	TenantID string

	Reference string
	Kind      ComplainantKind
	// ComplainantRef is how to reach them. A patient id where the complainant
	// is the patient; otherwise a contact reference.
	ComplainantRef string
	PatientID      string
	EncounterID    string

	Category   string
	Department string
	FacilityID string
	Channel    string
	Detail     string

	// Two clocks, not one. A hospital that acknowledges within a day and
	// resolves in a month is behaving correctly; one that resolves in a day
	// without acknowledging has not spoken to the complainant. Merging them
	// hides whichever one is being missed.
	AcknowledgeBy  time.Time
	AcknowledgedAt time.Time
	AcknowledgedBy string
	ResolveBy      time.Time

	State   ComplaintState
	Outcome Outcome
	// Resolution is what was decided and what was done about it.
	Resolution string
	// ClosureReason is required at closure, including when the complaint was
	// withdrawn: "withdrawn" without a reason is indistinguishable from
	// "we stopped answering".
	ClosureReason string

	// Escalated records that the complaint passed a clock. Kept on the record
	// as well as derived, because SRS-QMS-011's acceptance is that the
	// escalation is retained — a derived-only view loses that it ever happened
	// once the complaint is resolved.
	Escalated   bool
	EscalatedAt time.Time

	// CAPAIDs are the actions raised from it.
	CAPAIDs []string

	ReceivedAt time.Time
	ReceivedBy string
	ClosedAt   time.Time
	ClosedBy   string
	Version    int64
}

// NewComplaintInput records a grievance.
type NewComplaintInput struct {
	Reference      string
	Kind           ComplainantKind
	ComplainantRef string
	PatientID      string
	EncounterID    string
	Category       string
	Department     string
	FacilityID     string
	Channel        string
	Detail         string
	ReceivedAt     time.Time
	// AcknowledgeWithin and ResolveWithin come from the deployment's SLA
	// configuration rather than from the request. A complainant-facing clock
	// the person recording the complaint can set is a clock that will be set
	// generously for the complaints that most need it.
	AcknowledgeWithin time.Duration
	ResolveWithin     time.Duration
}

// ReceiveComplaint records a grievance (SRS-QMS-011).
func ReceiveComplaint(id, tenantID string, in NewComplaintInput, by string,
	now time.Time) (Complaint, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Complaint{}, fmt.Errorf("%w: a complaint needs an id",
			ErrInvalidQuality)
	case !knownComplainantKind[in.Kind]:
		return Complaint{}, fmt.Errorf("%w: unknown complainant kind %q",
			ErrInvalidQuality, in.Kind)
	case strings.TrimSpace(in.Category) == "":
		return Complaint{}, fmt.Errorf("%w: a complaint needs a category",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Detail) == "":
		return Complaint{}, fmt.Errorf("%w: a complaint needs its substance",
			ErrInvalidQuality)
	}

	received := in.ReceivedAt
	if received.IsZero() {
		received = now
	}
	if received.After(now) {
		return Complaint{}, fmt.Errorf("%w: this complaint is in the future",
			ErrInvalidQuality)
	}

	complaint := Complaint{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), Kind: in.Kind,
		ComplainantRef: strings.TrimSpace(in.ComplainantRef),
		PatientID:      in.PatientID, EncounterID: in.EncounterID,
		Category:   strings.TrimSpace(in.Category),
		Department: strings.TrimSpace(in.Department),
		FacilityID: in.FacilityID,
		Channel:    strings.TrimSpace(in.Channel),
		Detail:     strings.TrimSpace(in.Detail),
		State:      ComplaintReceived,
		ReceivedAt: received.UTC(), ReceivedBy: by,
		Version: 1,
	}
	if in.AcknowledgeWithin > 0 {
		complaint.AcknowledgeBy = received.Add(in.AcknowledgeWithin).UTC()
	}
	if in.ResolveWithin > 0 {
		complaint.ResolveBy = received.Add(in.ResolveWithin).UTC()
	}
	return complaint, nil
}

// Acknowledge records that the complainant has been spoken to (SRS-QMS-011).
func (c *Complaint) Acknowledge(by string, now time.Time) error {
	switch {
	case !c.State.Open():
		return fmt.Errorf("%w: this complaint is closed", ErrInvalidQuality)
	case !c.AcknowledgedAt.IsZero():
		return fmt.Errorf("%w: this complaint is already acknowledged",
			ErrInvalidQuality)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an acknowledgement names who gave it",
			ErrInvalidQuality)
	}
	c.AcknowledgedAt, c.AcknowledgedBy = now.UTC(), by
	if c.State == ComplaintReceived {
		c.State = ComplaintAcknowledged
	}
	return nil
}

// Escalate marks a complaint that has passed a clock (SRS-QMS-011).
func (c *Complaint) Escalate(now time.Time) {
	if c.Escalated {
		return
	}
	c.Escalated, c.EscalatedAt = true, now.UTC()
}

// Resolve records what was decided (SRS-QMS-011).
func (c *Complaint) Resolve(outcome Outcome, resolution, by string,
	now time.Time) error {

	switch {
	case !c.State.Open():
		return fmt.Errorf("%w: this complaint is closed", ErrInvalidQuality)
	case !knownOutcome[outcome]:
		return fmt.Errorf("%w: unknown complaint outcome %q",
			ErrInvalidQuality, outcome)
	case strings.TrimSpace(resolution) == "":
		return fmt.Errorf("%w: a resolution says what was decided and done",
			ErrInvalidQuality)
	case c.AcknowledgedAt.IsZero() && outcome != OutcomeWithdrawn:
		// A complaint resolved without the complainant ever being spoken to is
		// a file closed rather than a grievance handled. Withdrawal is the one
		// exception: they went away before anybody got to them, and recording
		// that honestly is better than forcing a false acknowledgement.
		return fmt.Errorf(
			"%w: this complaint has not been acknowledged to the complainant",
			ErrInvalidQuality)
	}

	c.State = ComplaintResolved
	c.Outcome = outcome
	c.Resolution = strings.TrimSpace(resolution)
	return nil
}

// CloseComplaint signs a grievance off (SRS-QMS-011).
func (c *Complaint) CloseComplaint(reason, by string, now time.Time) error {
	switch {
	case !c.State.Open():
		return fmt.Errorf("%w: this complaint is already closed",
			ErrInvalidQuality)
	case c.State != ComplaintResolved:
		return fmt.Errorf("%w: this complaint has not been resolved",
			ErrInvalidQuality)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this complaint is closed",
			ErrInvalidQuality)
	}
	c.State = ComplaintClosed
	c.ClosureReason = strings.TrimSpace(reason)
	c.ClosedAt, c.ClosedBy = now.UTC(), by
	return nil
}

// ComplaintBreach is one grievance past a clock (SRS-QMS-011).
type ComplaintBreach struct {
	Complaint Complaint
	// Acknowledgement and Resolution are each true where that clock has been
	// passed. Reported separately for the reason they are kept separately.
	Acknowledgement bool
	Resolution      bool
}

// ComplaintBreaches lists what has run past its dates (SRS-QMS-011).
func ComplaintBreaches(complaints []Complaint, now time.Time) []ComplaintBreach {
	var out []ComplaintBreach
	for _, complaint := range complaints {
		if !complaint.State.Open() {
			continue
		}
		line := ComplaintBreach{Complaint: complaint}
		if complaint.AcknowledgedAt.IsZero() &&
			!complaint.AcknowledgeBy.IsZero() &&
			now.After(complaint.AcknowledgeBy) {
			line.Acknowledgement = true
		}
		if complaint.State != ComplaintResolved &&
			!complaint.ResolveBy.IsZero() && now.After(complaint.ResolveBy) {
			line.Resolution = true
		}
		if line.Acknowledgement || line.Resolution {
			out = append(out, line)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].Complaint.ReceivedAt.Before(out[b].Complaint.ReceivedAt)
	})
	return out
}

// DeathClassification is a review's verdict on a death (SRS-QMS-012).
//
// The four the review exists to distinguish. "Potentially preventable" is the
// one that produces change, and a scale without it collapses every death into
// expected or unexpected and learns nothing.
type DeathClassification string

const (
	DeathExpected               DeathClassification = "expected"
	DeathUnexpected             DeathClassification = "unexpected"
	DeathPotentiallyPreventable DeathClassification = "potentially_preventable"
	DeathPreventable            DeathClassification = "preventable"
)

var knownDeathClassification = map[DeathClassification]bool{
	DeathExpected: true, DeathUnexpected: true,
	DeathPotentiallyPreventable: true, DeathPreventable: true,
}

// PreventableDeath reports the classifications that require action.
func (c DeathClassification) PreventableDeath() bool {
	return c == DeathPotentiallyPreventable || c == DeathPreventable
}

// MortalityReview is one peer review of a death (SRS-QMS-012).
//
// Always restricted. Peer review is a discussion between clinicians about
// whether a colleague's care was adequate, and it only happens honestly if it
// is not readable by everybody with a clinical login. The record here is the
// review, never a change to the clinical record: what the notes say happened
// is not amended by a committee's opinion of it.
type MortalityReview struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	DiedAt      time.Time

	CommitteeID string
	// MeetingID is the sitting that reviewed it. Required at completion,
	// because a peer review signed by one person is not a peer review.
	MeetingID string

	Classification DeathClassification
	Findings       string
	// LearningPoints are what the hospital takes from it. Separate from
	// findings, because the findings are about this death and the learning is
	// what changes for the next patient.
	LearningPoints string
	CAPAIDs        []string

	State       RCAState
	OpenedAt    time.Time
	OpenedBy    string
	CompletedAt time.Time
	CompletedBy string
	Version     int64
}

// StartMortalityReview opens a peer review (SRS-QMS-012).
func StartMortalityReview(id, tenantID, patientID, encounterID, committeeID string,
	diedAt time.Time, by string, now time.Time) (MortalityReview, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return MortalityReview{}, fmt.Errorf("%w: a review needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(patientID) == "":
		return MortalityReview{}, fmt.Errorf("%w: a review names its patient",
			ErrInvalidQuality)
	case diedAt.IsZero():
		return MortalityReview{}, fmt.Errorf("%w: a review needs the date of death",
			ErrInvalidQuality)
	case diedAt.After(now):
		return MortalityReview{}, fmt.Errorf("%w: that date is in the future",
			ErrInvalidQuality)
	}

	return MortalityReview{
		ID: id, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, DiedAt: diedAt.UTC(),
		CommitteeID: committeeID, State: RCAOpen,
		OpenedAt: now.UTC(), OpenedBy: by, Version: 1,
	}, nil
}

// CompleteMortalityReview records the committee's verdict (SRS-QMS-012).
//
// A preventable or potentially preventable death must name a corrective
// action. That is the whole purpose of the review, and a classification of
// "potentially preventable" with nothing raised from it is a hospital that has
// written down that it could have done better and done nothing.
func (m *MortalityReview) CompleteMortalityReview(meetingID string,
	classification DeathClassification, findings, learning string,
	actions []string, by string, now time.Time) error {

	switch {
	case m.State != RCAOpen:
		return fmt.Errorf("%w: this review is %s", ErrInvalidQuality, m.State)
	case strings.TrimSpace(meetingID) == "":
		return fmt.Errorf("%w: a peer review names the meeting that made it",
			ErrInvalidQuality)
	case !knownDeathClassification[classification]:
		return fmt.Errorf("%w: unknown death classification %q",
			ErrInvalidQuality, classification)
	case strings.TrimSpace(findings) == "":
		return fmt.Errorf("%w: a review records its findings", ErrInvalidQuality)
	case classification.PreventableDeath() && len(actions) == 0:
		return fmt.Errorf(
			"%w: a %s death is classified with no corrective action raised",
			ErrInvalidQuality, classification)
	}

	m.MeetingID = meetingID
	m.Classification = classification
	m.Findings = strings.TrimSpace(findings)
	m.LearningPoints = strings.TrimSpace(learning)
	m.CAPAIDs = actions
	m.State = RCAComplete
	m.CompletedAt, m.CompletedBy = now.UTC(), by
	return nil
}

// The record classes this context holds, for retention and legal hold
// (SRS-QMS-015).
//
// Named constants rather than free strings, because a hold placed on
// "Incident" and a purge that looks for "incident" is a hold that does
// nothing, and nobody finds out until the records are gone.
const (
	RecordIncident        = "qms_incident"
	RecordRCA             = "qms_rca"
	RecordCAPA            = "qms_capa"
	RecordAudit           = "qms_audit"
	RecordComplaint       = "qms_complaint"
	RecordMortalityReview = "qms_mortality_review"
	RecordDocumentVersion = "qms_document_version"
	RecordMeeting         = "qms_committee_meeting"
)

// RecordClasses is every class this context can hold or retain.
func RecordClasses() []string {
	return []string{
		RecordIncident, RecordRCA, RecordCAPA, RecordAudit,
		RecordComplaint, RecordMortalityReview, RecordDocumentVersion,
		RecordMeeting,
	}
}
