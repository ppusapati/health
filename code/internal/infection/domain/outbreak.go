package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// OutbreakState is where an investigation stands (SRS-IPC-005).
type OutbreakState string

const (
	OutbreakSuspected OutbreakState = "suspected"
	OutbreakDeclared  OutbreakState = "declared"
	OutbreakContained OutbreakState = "contained"
	OutbreakClosed    OutbreakState = "closed"
	// OutbreakRefuted is an investigation that found no cluster. Kept rather
	// than deleted: a suspicion that was looked at and dismissed is evidence
	// the hospital was watching.
	OutbreakRefuted OutbreakState = "refuted"
)

var knownOutbreakState = map[OutbreakState]bool{
	OutbreakSuspected: true, OutbreakDeclared: true,
	OutbreakContained: true, OutbreakClosed: true, OutbreakRefuted: true,
}

// Open reports an investigation still running.
func (s OutbreakState) Open() bool {
	return s != OutbreakClosed && s != OutbreakRefuted
}

// Outbreak is one cluster investigation (SRS-IPC-005).
type Outbreak struct {
	ID       string
	TenantID string

	Reference string
	Organism  string
	// CaseDefinition is what makes a patient part of this cluster. Recorded
	// because membership is only defensible against a definition: an outbreak
	// whose cases were chosen one at a time is an outbreak whose size is
	// whatever the investigator decided.
	CaseDefinition string

	// Locations and the window bound the investigation. A cluster with no
	// window grows for ever, and one with no locations is the whole hospital.
	Locations  []string
	WindowFrom time.Time
	WindowTo   time.Time

	State OutbreakState
	// Findings and ControlMeasures are the investigation's output.
	Findings        string
	ControlMeasures []string
	// ActionIDs are the corrective actions raised in the quality system. Named
	// rather than duplicated: an outbreak's actions escalate when they are
	// late, and SRS-QMS-004 already does that.
	ActionIDs []string

	DeclaredAt time.Time
	DeclaredBy string
	ClosedAt   time.Time
	ClosedBy   string
	ClosureWhy string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewOutbreakInput opens an investigation.
type NewOutbreakInput struct {
	Reference      string
	Organism       string
	CaseDefinition string
	Locations      []string
	WindowFrom     time.Time
	WindowTo       time.Time
}

// OpenOutbreak starts a cluster investigation (SRS-IPC-005).
func OpenOutbreak(id, tenantID string, in NewOutbreakInput, by string,
	now time.Time) (Outbreak, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Outbreak{}, fmt.Errorf("%w: an investigation needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Organism) == "":
		return Outbreak{}, fmt.Errorf("%w: an investigation names its organism",
			ErrInvalidInfection)
	case strings.TrimSpace(in.CaseDefinition) == "":
		// Membership is only defensible against a definition.
		return Outbreak{}, fmt.Errorf(
			"%w: an investigation states what makes a case part of it",
			ErrInvalidInfection)
	case in.WindowFrom.IsZero():
		return Outbreak{}, fmt.Errorf("%w: an investigation needs a start date",
			ErrInvalidInfection)
	case !in.WindowTo.IsZero() && in.WindowTo.Before(in.WindowFrom):
		return Outbreak{}, fmt.Errorf("%w: that window ends before it starts",
			ErrInvalidInfection)
	}

	return Outbreak{
		ID: id, TenantID: tenantID,
		Reference:      strings.TrimSpace(in.Reference),
		Organism:       strings.TrimSpace(in.Organism),
		CaseDefinition: strings.TrimSpace(in.CaseDefinition),
		Locations:      normalise(in.Locations),
		WindowFrom:     in.WindowFrom.UTC(),
		WindowTo:       utcOrZero(in.WindowTo),
		State:          OutbreakSuspected,
		CreatedAt:      now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Advance moves an investigation along (SRS-IPC-005).
func (o *Outbreak) Advance(to OutbreakState, reason, by string,
	now time.Time) error {

	switch {
	case !knownOutbreakState[to]:
		return fmt.Errorf("%w: unknown outbreak state %q",
			ErrInvalidInfection, to)
	case !o.State.Open():
		return fmt.Errorf("%w: this investigation is %s",
			ErrInvalidInfection, o.State)
	case to == OutbreakSuspected:
		return fmt.Errorf("%w: an investigation does not go back to suspected",
			ErrInvalidInfection)
	case (to == OutbreakClosed || to == OutbreakRefuted) &&
		strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this investigation is %s",
			ErrInvalidInfection, to)
	}

	o.State = to
	switch to {
	case OutbreakDeclared:
		o.DeclaredAt, o.DeclaredBy = now.UTC(), by
	case OutbreakClosed, OutbreakRefuted:
		o.ClosedAt, o.ClosedBy = now.UTC(), by
		o.ClosureWhy = strings.TrimSpace(reason)
	}
	return nil
}

// CloseOutbreak signs an investigation off (SRS-IPC-005).
//
// Refused with no control measures on a declared outbreak. A cluster the
// hospital declared, investigated and closed having changed nothing is either
// an investigation that found nothing — which is what "refuted" is for — or
// one whose conclusions went nowhere.
func (o *Outbreak) CloseOutbreak(findings, reason, by string,
	now time.Time) error {

	switch {
	case !o.State.Open():
		return fmt.Errorf("%w: this investigation is already %s",
			ErrInvalidInfection, o.State)
	case strings.TrimSpace(findings) == "":
		return fmt.Errorf("%w: an investigation closes with its findings",
			ErrInvalidInfection)
	case o.DeclaredAt.IsZero():
		return fmt.Errorf(
			"%w: an investigation that was never declared is refuted, not closed",
			ErrInvalidInfection)
	case len(o.ControlMeasures) == 0 && len(o.ActionIDs) == 0:
		return fmt.Errorf(
			"%w: this outbreak closes having changed nothing and recorded no reason",
			ErrInvalidInfection)
	}

	o.Findings = strings.TrimSpace(findings)
	return o.Advance(OutbreakClosed, reason, by, now)
}

// MembershipReason says why a case is or is not part of a cluster.
type MembershipReason string

const (
	// MemberMeetsDefinition is the ordinary case: it matches.
	MemberMeetsDefinition MembershipReason = "meets_definition"
	// MemberEpidemiologicalLink is a case outside the window or location that
	// the investigation links anyway — a contact, a transfer.
	MemberEpidemiologicalLink MembershipReason = "epidemiological_link"
	// MemberExcluded is a case that looked like part of the cluster and is
	// not.
	MemberExcluded MembershipReason = "excluded"
)

var knownMembershipReason = map[MembershipReason]bool{
	MemberMeetsDefinition: true, MemberEpidemiologicalLink: true,
	MemberExcluded: true,
}

// Membership is one case's place in a cluster (SRS-IPC-005).
//
// A row per decision rather than a list on the outbreak, because the
// requirement's acceptance is that membership is traceable: a case added by
// hand after the fact, and a case removed, both have to be visible as
// decisions somebody made.
type Membership struct {
	ID         string
	TenantID   string
	OutbreakID string
	CaseID     string
	PatientID  string

	Reason MembershipReason
	// Note is required for anything but the ordinary case: adding a case that
	// does not meet the definition, or removing one that does, are both
	// judgements.
	Note string

	DecidedAt time.Time
	DecidedBy string
}

// Included reports a membership that counts towards the cluster's size.
func (m Membership) Included() bool { return m.Reason != MemberExcluded }

// AddMember records a case's place in a cluster (SRS-IPC-005).
//
// meetsDefinition is whether the case falls inside the investigation's window
// and locations, computed by the caller from the outbreak. A case that does
// not and is being added anyway must say why, and a case that does and is
// being excluded must say why — the two directions a cluster's size gets
// quietly adjusted.
func AddMember(id, tenantID, outbreakID, caseID, patientID string,
	reason MembershipReason, note string, meetsDefinition bool,
	by string, now time.Time) (Membership, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Membership{}, fmt.Errorf("%w: a membership needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(caseID) == "":
		return Membership{}, fmt.Errorf("%w: a membership names its case",
			ErrInvalidInfection)
	case !knownMembershipReason[reason]:
		return Membership{}, fmt.Errorf("%w: unknown membership reason %q",
			ErrInvalidInfection, reason)
	case strings.TrimSpace(by) == "":
		return Membership{}, fmt.Errorf("%w: a membership names who decided it",
			ErrInvalidInfection)
	}

	if reason == MemberMeetsDefinition && !meetsDefinition {
		return Membership{}, fmt.Errorf(
			"%w: this case falls outside the investigation's window or locations",
			ErrInvalidInfection)
	}
	if reason != MemberMeetsDefinition && strings.TrimSpace(note) == "" {
		return Membership{}, fmt.Errorf(
			"%w: say why this case is %s", ErrInvalidInfection, reason)
	}

	return Membership{
		ID: id, TenantID: tenantID, OutbreakID: outbreakID,
		CaseID: caseID, PatientID: patientID,
		Reason: reason, Note: strings.TrimSpace(note),
		DecidedAt: now.UTC(), DecidedBy: by,
	}, nil
}

// Matches reports whether a case falls inside an investigation's window and
// locations (SRS-IPC-005).
func (o Outbreak) Matches(one SurveillanceCase) bool {
	if one.OnsetAt.Before(o.WindowFrom) {
		return false
	}
	if !o.WindowTo.IsZero() && !one.OnsetAt.Before(o.WindowTo) {
		return false
	}
	if len(o.Locations) == 0 {
		return true
	}
	for _, location := range o.Locations {
		if strings.EqualFold(location, one.LocationID) {
			return true
		}
	}
	return false
}

// ClusterSummary is an investigation's size and shape (SRS-IPC-005,
// SRS-IPC-010).
type ClusterSummary struct {
	OutbreakID string
	// Included counts the cases in the cluster; Excluded counts the ones
	// somebody took out. Reported together, because a cluster of six that
	// started as a cluster of fourteen is a different fact from a cluster of
	// six.
	Included int
	Excluded int
	// ByLink counts the members added without meeting the definition.
	ByLink int
	// Locations and FirstOnset/LastOnset describe the cluster's spread.
	Locations  []string
	FirstOnset time.Time
	LastOnset  time.Time
}

// Summarise describes a cluster (SRS-IPC-005).
func Summarise(outbreak Outbreak, members []Membership,
	cases map[string]SurveillanceCase) ClusterSummary {

	out := ClusterSummary{OutbreakID: outbreak.ID}
	locations := map[string]bool{}

	for _, member := range members {
		if member.OutbreakID != outbreak.ID {
			continue
		}
		if !member.Included() {
			out.Excluded++
			continue
		}
		out.Included++
		if member.Reason == MemberEpidemiologicalLink {
			out.ByLink++
		}

		one, known := cases[member.CaseID]
		if !known {
			continue
		}
		if one.LocationID != "" {
			locations[one.LocationID] = true
		}
		if out.FirstOnset.IsZero() || one.OnsetAt.Before(out.FirstOnset) {
			out.FirstOnset = one.OnsetAt
		}
		if one.OnsetAt.After(out.LastOnset) {
			out.LastOnset = one.OnsetAt
		}
	}

	for location := range locations {
		out.Locations = append(out.Locations, location)
	}
	sort.Strings(out.Locations)
	return out
}
