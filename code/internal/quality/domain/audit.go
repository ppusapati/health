package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// FindingSeverity is how serious an audit finding is (SRS-QMS-007).
//
// Three levels rather than a boolean, because the three take different
// actions: an observation is advice, a minor non-conformity needs a plan, and
// a major one is a failure of the system that has to be corrected and proven
// corrected.
type FindingSeverity string

const (
	FindingObservation FindingSeverity = "observation"
	FindingMinor       FindingSeverity = "minor_nc"
	FindingMajor       FindingSeverity = "major_nc"
)

var knownFindingSeverity = map[FindingSeverity]bool{
	FindingObservation: true, FindingMinor: true, FindingMajor: true,
}

// NonConformity reports a finding that is a failure rather than advice.
func (s FindingSeverity) NonConformity() bool {
	return s == FindingMinor || s == FindingMajor
}

// AuditState is where an audit stands.
type AuditState string

const (
	AuditPlanned    AuditState = "planned"
	AuditInProgress AuditState = "in_progress"
	AuditReported   AuditState = "reported"
	AuditClosed     AuditState = "closed"
	AuditCancelled  AuditState = "cancelled"
)

var knownAuditState = map[AuditState]bool{
	AuditPlanned: true, AuditInProgress: true, AuditReported: true,
	AuditClosed: true, AuditCancelled: true,
}

// Audit is one planned internal audit (SRS-QMS-007).
type Audit struct {
	ID       string
	TenantID string

	Reference string
	Title     string
	// Scope is what is being audited — a department, a process, a standard.
	Scope string
	// StandardID names the clause set the audit is against, where it is
	// against one. Empty for an audit of the hospital's own process.
	StandardID string

	// AuditorID and AuditeeDepartment are kept apart and checked: an audit of
	// your own department is not an audit.
	AuditorID         string
	AuditeeDepartment string

	PlannedFrom time.Time
	PlannedTo   time.Time

	State AuditState
	// Summary is the audit report's conclusion.
	Summary string

	CreatedAt time.Time
	CreatedBy string
	ClosedAt  time.Time
	ClosedBy  string
	Version   int64
}

// NewAuditInput plans an internal audit.
type NewAuditInput struct {
	Reference         string
	Title             string
	Scope             string
	StandardID        string
	AuditorID         string
	AuditeeDepartment string
	PlannedFrom       time.Time
	PlannedTo         time.Time
}

// PlanAudit schedules an internal audit (SRS-QMS-007).
func PlanAudit(id, tenantID string, in NewAuditInput, by string,
	now time.Time) (Audit, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Audit{}, fmt.Errorf("%w: an audit needs an id", ErrInvalidQuality)
	case strings.TrimSpace(in.Title) == "":
		return Audit{}, fmt.Errorf("%w: an audit needs a title", ErrInvalidQuality)
	case strings.TrimSpace(in.Scope) == "":
		return Audit{}, fmt.Errorf("%w: an audit needs a scope",
			ErrInvalidQuality)
	case strings.TrimSpace(in.AuditorID) == "":
		return Audit{}, fmt.Errorf("%w: an audit names its auditor",
			ErrInvalidQuality)
	case in.PlannedFrom.IsZero() || in.PlannedTo.IsZero():
		return Audit{}, fmt.Errorf("%w: an audit needs a planned window",
			ErrInvalidQuality)
	case in.PlannedTo.Before(in.PlannedFrom):
		return Audit{}, fmt.Errorf("%w: this audit ends before it starts",
			ErrInvalidQuality)
	}

	return Audit{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference),
		Title:     strings.TrimSpace(in.Title),
		Scope:     strings.TrimSpace(in.Scope), StandardID: in.StandardID,
		AuditorID:         in.AuditorID,
		AuditeeDepartment: strings.TrimSpace(in.AuditeeDepartment),
		PlannedFrom:       in.PlannedFrom.UTC(), PlannedTo: in.PlannedTo.UTC(),
		State:     AuditPlanned,
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Finding is one thing an audit found (SRS-QMS-007).
type Finding struct {
	ID       string
	TenantID string
	AuditID  string

	// ClauseID ties the finding to the accreditation clause it fails, where
	// there is one. What makes an evidence map able to say which clauses are
	// currently in trouble.
	ClauseID string
	Severity FindingSeverity
	Detail   string
	Evidence string

	// CAPAID is the action raised to correct it. The link SRS-QMS-007's
	// acceptance means by "audit trail links finding to closure".
	CAPAID string

	ClosedAt time.Time
	ClosedBy string
	// ClosureNote is how an observation is closed without an action. A
	// non-conformity cannot be closed this way.
	ClosureNote string

	RaisedAt time.Time
	RaisedBy string
}

// NewFindingInput records an audit finding.
type NewFindingInput struct {
	AuditID  string
	ClauseID string
	Severity FindingSeverity
	Detail   string
	Evidence string
}

// RecordFinding records what an audit found (SRS-QMS-007).
func RecordFinding(id, tenantID string, in NewFindingInput, by string,
	now time.Time) (Finding, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Finding{}, fmt.Errorf("%w: a finding needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(in.AuditID) == "":
		return Finding{}, fmt.Errorf("%w: a finding names its audit",
			ErrInvalidQuality)
	case !knownFindingSeverity[in.Severity]:
		return Finding{}, fmt.Errorf("%w: unknown finding severity %q",
			ErrInvalidQuality, in.Severity)
	case strings.TrimSpace(in.Detail) == "":
		return Finding{}, fmt.Errorf("%w: a finding needs a description",
			ErrInvalidQuality)
	case in.Severity.NonConformity() && strings.TrimSpace(in.Evidence) == "":
		// A non-conformity is an accusation about the hospital's system. One
		// with no evidence is an opinion, and the department it names will
		// treat it as one.
		return Finding{}, fmt.Errorf("%w: a non-conformity records its evidence",
			ErrInvalidQuality)
	}

	return Finding{
		ID: id, TenantID: tenantID, AuditID: in.AuditID,
		ClauseID: in.ClauseID, Severity: in.Severity,
		Detail:   strings.TrimSpace(in.Detail),
		Evidence: strings.TrimSpace(in.Evidence),
		RaisedAt: now.UTC(), RaisedBy: by,
	}, nil
}

// CloseFinding signs a finding off (SRS-QMS-007).
//
// A non-conformity closes only through a closed corrective action. That is the
// whole of "audit trail links finding to closure": a finding closed with a
// note is a finding somebody talked their way out of, and the next audit finds
// it again.
func (f *Finding) CloseFinding(action *CAPA, note, by string,
	now time.Time) error {

	switch {
	case !f.ClosedAt.IsZero():
		return fmt.Errorf("%w: this finding is already closed",
			ErrInvalidQuality)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who made it", ErrInvalidQuality)
	}

	if f.Severity.NonConformity() {
		switch {
		case action == nil:
			return fmt.Errorf(
				"%w: a %s closes through a corrective action, not a note",
				ErrInvalidQuality, f.Severity)
		case action.ID != f.CAPAID:
			return fmt.Errorf("%w: that action is not this finding's",
				ErrInvalidQuality)
		case action.State != CAPAClosed:
			return fmt.Errorf(
				"%w: this finding's corrective action is %s, not closed",
				ErrInvalidQuality, action.State)
		}
	} else if strings.TrimSpace(note) == "" {
		return fmt.Errorf("%w: say how this observation was addressed",
			ErrInvalidQuality)
	}

	f.ClosedAt, f.ClosedBy = now.UTC(), by
	f.ClosureNote = strings.TrimSpace(note)
	return nil
}

// LinkAction attaches the corrective action a finding will close through.
func (f *Finding) LinkAction(capaID string) error {
	switch {
	case !f.ClosedAt.IsZero():
		return fmt.Errorf("%w: this finding is closed", ErrInvalidQuality)
	case strings.TrimSpace(capaID) == "":
		return fmt.Errorf("%w: an action link needs an action",
			ErrInvalidQuality)
	}
	f.CAPAID = capaID
	return nil
}

// ReportAudit records the auditor's conclusion (SRS-QMS-007).
func (a *Audit) ReportAudit(summary, by string, now time.Time) error {
	switch {
	case a.State != AuditPlanned && a.State != AuditInProgress:
		return fmt.Errorf("%w: this audit is %s", ErrInvalidQuality, a.State)
	case strings.TrimSpace(summary) == "":
		return fmt.Errorf("%w: an audit report needs a conclusion",
			ErrInvalidQuality)
	}
	a.State = AuditReported
	a.Summary = strings.TrimSpace(summary)
	return nil
}

// CloseAudit signs an audit off (SRS-QMS-007).
//
// Refused while any finding is open. An audit closed over open non-conformities
// is a hospital that believes a process was checked and corrected when only the
// first happened.
func (a *Audit) CloseAudit(findings []Finding, by string, now time.Time) error {
	switch {
	case a.State != AuditReported:
		return fmt.Errorf("%w: this audit is %s, not reported",
			ErrInvalidQuality, a.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who made it", ErrInvalidQuality)
	}

	open := 0
	for _, finding := range findings {
		if finding.AuditID == a.ID && finding.ClosedAt.IsZero() {
			open++
		}
	}
	if open > 0 {
		return fmt.Errorf("%w: %d finding(s) are still open under this audit",
			ErrInvalidQuality, open)
	}

	a.State = AuditClosed
	a.ClosedAt, a.ClosedBy = now.UTC(), by
	return nil
}

// Committee is a standing group that meets and decides (SRS-QMS-008).
type Committee struct {
	ID       string
	TenantID string

	Code  string
	Name  string
	Terms string
	// QuorumSize is how many members must attend for the meeting to decide
	// anything. Zero means the hospital has not set one, which is reported
	// rather than treated as "any number will do".
	QuorumSize int
	// Restricted marks a committee whose minutes are peer-review material —
	// mortality and morbidity, and serious-incident review (SRS-QMS-012).
	Restricted bool

	Members   []string
	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// MeetingState is where a meeting stands.
type MeetingState string

const (
	MeetingScheduled MeetingState = "scheduled"
	MeetingHeld      MeetingState = "held"
	MeetingApproved  MeetingState = "minutes_approved"
	MeetingCancelled MeetingState = "cancelled"
)

// Decision is one thing a meeting decided (SRS-QMS-008).
type Decision struct {
	Text string
	// ActionIDs are the corrective actions it raised. Committee actions are
	// CAPAs, not a second kind of task: an action item with an owner and a due
	// date that escalates when it is late is what a CAPA already is, and two
	// of them would need two overdue reports.
	ActionIDs []string
}

// Meeting is one sitting of a committee (SRS-QMS-008).
type Meeting struct {
	ID          string
	TenantID    string
	CommitteeID string

	ScheduledAt time.Time
	HeldAt      time.Time
	Agenda      []string
	// Attendees are the members who came. Apologies are recorded separately,
	// because "did not come and said so" and "did not come" are different
	// facts about a committee.
	Attendees []string
	Apologies []string
	Minutes   string
	Decisions []Decision

	State      MeetingState
	ApprovedBy string
	ApprovedAt time.Time

	Restricted bool
	CreatedAt  time.Time
	CreatedBy  string
	Version    int64
}

// Quorate reports whether enough members attended to decide anything.
func (m Meeting) Quorate(committee Committee) bool {
	if committee.QuorumSize <= 0 {
		return true
	}
	members := map[string]bool{}
	for _, member := range committee.Members {
		members[member] = true
	}
	present := 0
	for _, attendee := range m.Attendees {
		if members[attendee] {
			present++
		}
	}
	return present >= committee.QuorumSize
}

// ApproveMinutes signs a meeting's record off (SRS-QMS-008).
//
// Refused below quorum where the committee has one. A decision taken by two
// people from a committee of nine is not the committee's decision, and minutes
// that record it as one are the document an accreditation survey reads.
func (m *Meeting) ApproveMinutes(committee Committee, by string,
	now time.Time) error {

	switch {
	case m.State != MeetingHeld:
		return fmt.Errorf("%w: this meeting is %s", ErrInvalidQuality, m.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: minutes are approved by somebody",
			ErrInvalidQuality)
	case strings.TrimSpace(m.Minutes) == "":
		return fmt.Errorf("%w: there are no minutes to approve",
			ErrInvalidQuality)
	case len(m.Attendees) == 0:
		return fmt.Errorf("%w: minutes record who was there",
			ErrInvalidQuality)
	case len(m.Decisions) > 0 && !m.Quorate(committee):
		return fmt.Errorf(
			"%w: this meeting took decisions without a quorum of %d",
			ErrInvalidQuality, committee.QuorumSize)
	}

	m.State = MeetingApproved
	m.ApprovedBy, m.ApprovedAt = by, now.UTC()
	return nil
}

// HoldMeeting records that a meeting took place (SRS-QMS-008).
func (m *Meeting) HoldMeeting(attendees, apologies []string, minutes string,
	decisions []Decision, at time.Time) error {

	if m.State != MeetingScheduled {
		return fmt.Errorf("%w: this meeting is %s", ErrInvalidQuality, m.State)
	}
	m.Attendees, m.Apologies = dedupe(attendees), dedupe(apologies)
	m.Minutes = strings.TrimSpace(minutes)
	m.Decisions = decisions
	m.HeldAt = at.UTC()
	m.State = MeetingHeld
	return nil
}

func dedupe(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		value = strings.TrimSpace(value)
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, value)
	}
	sort.Strings(out)
	return out
}
