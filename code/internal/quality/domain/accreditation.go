package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Standard is an accreditation standard a hospital is assessed against
// (SRS-QMS-009).
//
// Configurable rather than built in. NABH, JCI, NABL and a state licensing
// schedule all have different clause trees, and a hospital is usually against
// more than one at once.
type Standard struct {
	ID       string
	TenantID string

	Code string
	Name string
	// Edition is which version of the standard — "NABH 5th edition". Part of
	// the identity, because clause numbering changes between editions and
	// evidence filed under the old numbering is evidence against a clause that
	// no longer exists.
	Edition string

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Clause is one requirement of a standard (SRS-QMS-009).
type Clause struct {
	ID         string
	TenantID   string
	StandardID string

	// Reference is the standard's own numbering — "AAC.1.a".
	Reference string
	Chapter   string
	Text      string
	// Critical marks a clause a survey will not pass without. Carried because
	// a readiness report that treats every clause as equal is a readiness
	// report that hides the ones that matter.
	Critical bool

	CreatedAt time.Time
	Version   int64
}

// EvidenceKind is what sort of thing is being offered against a clause.
type EvidenceKind string

const (
	// EvidenceDocument is a controlled document *version*, never a document.
	// Pinned to the version because an SOP revised after the evidence was
	// filed is a different document, and a survey asking "show me what you
	// filed" must not be shown something else.
	EvidenceDocument EvidenceKind = "document_version"
	EvidenceAudit    EvidenceKind = "audit"
	EvidenceFinding  EvidenceKind = "audit_finding"
	EvidenceCAPA     EvidenceKind = "capa"
	EvidenceKPI      EvidenceKind = "kpi"
	EvidenceMeeting  EvidenceKind = "committee_meeting"
	EvidenceTraining EvidenceKind = "competency"
	// EvidenceExternal is a certificate, licence or report held outside this
	// system. A reference and a description, because pretending to hold a fire
	// NOC would be worse than naming where it is.
	EvidenceExternal EvidenceKind = "external"
)

var knownEvidenceKind = map[EvidenceKind]bool{
	EvidenceDocument: true, EvidenceAudit: true, EvidenceFinding: true,
	EvidenceCAPA: true, EvidenceKPI: true, EvidenceMeeting: true,
	EvidenceTraining: true, EvidenceExternal: true,
}

// Verdict is a reviewer's judgement of a clause (SRS-QMS-009).
type Verdict string

const (
	VerdictUnreviewed    Verdict = "unreviewed"
	VerdictMet           Verdict = "met"
	VerdictPartiallyMet  Verdict = "partially_met"
	VerdictNotMet        Verdict = "not_met"
	VerdictNotApplicable Verdict = "not_applicable"
)

var knownVerdict = map[Verdict]bool{
	VerdictUnreviewed: true, VerdictMet: true, VerdictPartiallyMet: true,
	VerdictNotMet: true, VerdictNotApplicable: true,
}

// Evidence is one thing offered against one clause (SRS-QMS-009).
type Evidence struct {
	ID       string
	TenantID string
	ClauseID string

	Kind EvidenceKind
	// RefID points at the record inside this system, where the kind names one.
	RefID string
	// ExternalRef and Description carry what an external certificate is and
	// where it lives.
	ExternalRef string
	Description string

	AddedAt time.Time
	AddedBy string
	// Removed retires evidence without deleting it. A survey that asks what
	// changed since the last one is asking exactly this.
	RemovedAt  time.Time
	RemovedBy  string
	RemovedWhy string
}

// Live reports evidence still being offered.
func (e Evidence) Live() bool { return e.RemovedAt.IsZero() }

// AddEvidence files something against a clause (SRS-QMS-009).
func AddEvidence(id, tenantID, clauseID string, kind EvidenceKind,
	refID, externalRef, description, by string, now time.Time) (
	Evidence, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Evidence{}, fmt.Errorf("%w: evidence needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(clauseID) == "":
		return Evidence{}, fmt.Errorf("%w: evidence names its clause",
			ErrInvalidQuality)
	case !knownEvidenceKind[kind]:
		return Evidence{}, fmt.Errorf("%w: unknown evidence kind %q",
			ErrInvalidQuality, kind)
	case kind != EvidenceExternal && strings.TrimSpace(refID) == "":
		return Evidence{}, fmt.Errorf("%w: %s evidence names the record it is",
			ErrInvalidQuality, kind)
	case kind == EvidenceExternal &&
		(strings.TrimSpace(externalRef) == "" ||
			strings.TrimSpace(description) == ""):
		// Evidence held elsewhere has to say what it is and where, or it is a
		// tick in a box.
		return Evidence{}, fmt.Errorf(
			"%w: external evidence needs a reference and a description",
			ErrInvalidQuality)
	}

	return Evidence{
		ID: id, TenantID: tenantID, ClauseID: clauseID, Kind: kind,
		RefID: refID, ExternalRef: strings.TrimSpace(externalRef),
		Description: strings.TrimSpace(description),
		AddedAt:     now.UTC(), AddedBy: by,
	}, nil
}

// ClauseReview is a reviewer's judgement of one clause (SRS-QMS-009).
type ClauseReview struct {
	ID       string
	TenantID string
	ClauseID string

	Verdict Verdict
	Note    string
	// CAPAID is the action raised where the clause is not met. Required for a
	// not-met verdict: a gap recorded with nothing to close it is a gap the
	// survey will find in the same state next year.
	CAPAID string

	ReviewedAt time.Time
	ReviewedBy string
}

// ReviewClause records a judgement (SRS-QMS-009).
func ReviewClause(id, tenantID, clauseID string, verdict Verdict,
	note, capaID string, evidence []Evidence, by string, now time.Time) (
	ClauseReview, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ClauseReview{}, fmt.Errorf("%w: a review needs an id",
			ErrInvalidQuality)
	case !knownVerdict[verdict] || verdict == VerdictUnreviewed:
		return ClauseReview{}, fmt.Errorf("%w: unknown clause verdict %q",
			ErrInvalidQuality, verdict)
	case verdict == VerdictNotApplicable && strings.TrimSpace(note) == "":
		// "Not applicable" is the verdict that removes a clause from the
		// assessment. It is the one that needs a reason.
		return ClauseReview{}, fmt.Errorf(
			"%w: say why this clause does not apply", ErrInvalidQuality)
	case verdict == VerdictNotMet && strings.TrimSpace(capaID) == "":
		return ClauseReview{}, fmt.Errorf(
			"%w: a clause found not met names the action that will close it",
			ErrInvalidQuality)
	}

	if verdict == VerdictMet && liveEvidence(evidence) == 0 {
		return ClauseReview{}, fmt.Errorf(
			"%w: this clause is judged met with no evidence filed against it",
			ErrInvalidQuality)
	}

	return ClauseReview{
		ID: id, TenantID: tenantID, ClauseID: clauseID,
		Verdict: verdict, Note: strings.TrimSpace(note), CAPAID: capaID,
		ReviewedAt: now.UTC(), ReviewedBy: by,
	}, nil
}

func liveEvidence(evidence []Evidence) int {
	count := 0
	for _, one := range evidence {
		if one.Live() {
			count++
		}
	}
	return count
}

// ClauseStatus is one line of the readiness view (SRS-QMS-014).
type ClauseStatus struct {
	ClauseID  string
	Reference string
	Chapter   string
	Critical  bool

	Verdict       Verdict
	EvidenceCount int
	ReviewedAt    time.Time
	ReviewedBy    string
	// Stale marks a clause reviewed longer ago than the survey window the
	// hospital is preparing inside. A judgement from three years ago is not
	// evidence that the clause is met today.
	Stale bool
	// CAPAID is what will close it, where the review named one.
	CAPAID string
}

// Readiness is the accreditation survey picture (SRS-QMS-014).
type Readiness struct {
	StandardID    string
	Total         int
	Met           int
	PartiallyMet  int
	NotMet        int
	NotApplicable int
	Unreviewed    int
	// CriticalGaps counts critical clauses that are not met, partially met, or
	// have never been reviewed. Counted separately because a survey does not
	// average them in with the rest.
	CriticalGaps int
	// StaleReviews counts judgements older than the window.
	StaleReviews int
	// EvidenceGaps counts clauses with no live evidence at all, whatever the
	// verdict says.
	EvidenceGaps int
	// OverdueActions is how many corrective actions are past their dates. Not
	// computed here — the caller supplies it from OverdueActions, because
	// those actions are not all accreditation's.
	OverdueActions int

	Clauses []ClauseStatus
}

// AssessReadiness builds the survey-preparation picture (SRS-QMS-014).
//
// Derived on read. A stored readiness percentage is out of date the moment a
// document is revised or an action closes, and a hospital preparing for a
// survey checks it daily.
//
// staleAfter is how old a review may be before it stops counting as current.
// Zero never marks anything stale, which is a deployment that has not decided
// and is visible in the status document.
func AssessReadiness(standardID string, clauses []Clause,
	reviews map[string]ClauseReview, evidence map[string][]Evidence,
	staleAfter time.Duration, overdueActions int, now time.Time) Readiness {

	out := Readiness{
		StandardID: standardID, Total: len(clauses),
		OverdueActions: overdueActions,
	}

	for _, clause := range clauses {
		status := ClauseStatus{
			ClauseID: clause.ID, Reference: clause.Reference,
			Chapter: clause.Chapter, Critical: clause.Critical,
			Verdict:       VerdictUnreviewed,
			EvidenceCount: liveEvidence(evidence[clause.ID]),
		}

		if review, reviewed := reviews[clause.ID]; reviewed {
			status.Verdict = review.Verdict
			status.ReviewedAt, status.ReviewedBy = review.ReviewedAt, review.ReviewedBy
			status.CAPAID = review.CAPAID
			if staleAfter > 0 && now.Sub(review.ReviewedAt) > staleAfter {
				status.Stale = true
				out.StaleReviews++
			}
		}

		switch status.Verdict {
		case VerdictMet:
			out.Met++
		case VerdictPartiallyMet:
			out.PartiallyMet++
		case VerdictNotMet:
			out.NotMet++
		case VerdictNotApplicable:
			out.NotApplicable++
		default:
			out.Unreviewed++
		}

		// A clause that does not apply needs no evidence; everything else
		// does, whatever a reviewer wrote.
		if status.EvidenceCount == 0 && status.Verdict != VerdictNotApplicable {
			out.EvidenceGaps++
		}
		if clause.Critical && status.Verdict != VerdictMet &&
			status.Verdict != VerdictNotApplicable {
			out.CriticalGaps++
		}
		out.Clauses = append(out.Clauses, status)
	}

	sort.Slice(out.Clauses, func(a, b int) bool {
		// Worst first, and critical before ordinary at the same verdict: a
		// readiness screen is read from the top and stopped part-way.
		rank := func(s ClauseStatus) int {
			switch s.Verdict {
			case VerdictNotMet:
				return 0
			case VerdictUnreviewed:
				return 1
			case VerdictPartiallyMet:
				return 2
			case VerdictMet:
				return 3
			default:
				return 4
			}
		}
		if rank(out.Clauses[a]) != rank(out.Clauses[b]) {
			return rank(out.Clauses[a]) < rank(out.Clauses[b])
		}
		if out.Clauses[a].Critical != out.Clauses[b].Critical {
			return out.Clauses[a].Critical
		}
		return out.Clauses[a].Reference < out.Clauses[b].Reference
	})
	return out
}

// Direction says which way a KPI should move (SRS-QMS-010).
type Direction string

const (
	DirectionHigherIsBetter Direction = "higher_is_better"
	DirectionLowerIsBetter  Direction = "lower_is_better"
)

var knownDirection = map[Direction]bool{
	DirectionHigherIsBetter: true, DirectionLowerIsBetter: true,
}

// Frequency is how often a KPI is measured (SRS-QMS-010).
type Frequency string

const (
	FrequencyDaily     Frequency = "daily"
	FrequencyWeekly    Frequency = "weekly"
	FrequencyMonthly   Frequency = "monthly"
	FrequencyQuarterly Frequency = "quarterly"
	FrequencyAnnual    Frequency = "annual"
)

var knownFrequency = map[Frequency]bool{
	FrequencyDaily: true, FrequencyWeekly: true, FrequencyMonthly: true,
	FrequencyQuarterly: true, FrequencyAnnual: true,
}

// KPIDefinition is one entry in the indicator dictionary (SRS-QMS-010).
//
// Versioned and never edited in place. SRS-OPSNFR-008 requires that a quality
// indicator be reproducible from source records, and an indicator whose
// formula was changed in place is one whose history is a mixture of two
// different measurements plotted on one line.
type KPIDefinition struct {
	ID       string
	TenantID string

	Code string
	Name string
	// Revision increments with every change. The dictionary entry is
	// (code, revision), and a recorded value names the revision it was
	// computed under.
	Revision int

	// Numerator and Denominator describe what is counted, in words. This
	// context stores the definition and the recorded values; computing them
	// from the hospital's source records is a reporting engine's job and is
	// named as a seam rather than half-built here.
	Numerator   string
	Denominator string
	Unit        string

	// TargetPermille is the target as parts per thousand, an integer. A float
	// target that reads 0.949999 in one report and 95% in another is an
	// argument in a committee meeting.
	TargetPermille int
	Direction      Direction
	Frequency      Frequency
	OwnerID        string

	EffectiveFrom time.Time
	SupersededAt  time.Time

	CreatedAt time.Time
	CreatedBy string
}

// NewKPIInput defines an indicator.
type NewKPIInput struct {
	Code           string
	Name           string
	Revision       int
	Numerator      string
	Denominator    string
	Unit           string
	TargetPermille int
	Direction      Direction
	Frequency      Frequency
	OwnerID        string
	EffectiveFrom  time.Time
}

// DefineKPI adds or revises a dictionary entry (SRS-QMS-010).
func DefineKPI(id, tenantID string, in NewKPIInput, by string,
	now time.Time) (KPIDefinition, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return KPIDefinition{}, fmt.Errorf("%w: an indicator needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Code) == "":
		return KPIDefinition{}, fmt.Errorf("%w: an indicator needs a code",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Name) == "":
		return KPIDefinition{}, fmt.Errorf("%w: an indicator needs a name",
			ErrInvalidQuality)
	case in.Revision <= 0:
		return KPIDefinition{}, fmt.Errorf(
			"%w: an indicator revision starts at 1", ErrInvalidQuality)
	case strings.TrimSpace(in.Numerator) == "" ||
		strings.TrimSpace(in.Denominator) == "":
		// An indicator whose formula is not written down is an indicator two
		// departments will compute differently and then argue about.
		return KPIDefinition{}, fmt.Errorf(
			"%w: an indicator states its numerator and denominator",
			ErrInvalidQuality)
	case !knownDirection[in.Direction]:
		return KPIDefinition{}, fmt.Errorf("%w: unknown indicator direction %q",
			ErrInvalidQuality, in.Direction)
	case !knownFrequency[in.Frequency]:
		return KPIDefinition{}, fmt.Errorf("%w: unknown indicator frequency %q",
			ErrInvalidQuality, in.Frequency)
	case strings.TrimSpace(in.OwnerID) == "":
		return KPIDefinition{}, fmt.Errorf("%w: an indicator names its owner",
			ErrInvalidQuality)
	case in.TargetPermille < 0:
		return KPIDefinition{}, fmt.Errorf("%w: a target cannot be negative",
			ErrInvalidQuality)
	case in.EffectiveFrom.IsZero():
		return KPIDefinition{}, fmt.Errorf(
			"%w: an indicator revision names when it takes effect",
			ErrInvalidQuality)
	}

	return KPIDefinition{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision:       in.Revision,
		Numerator:      strings.TrimSpace(in.Numerator),
		Denominator:    strings.TrimSpace(in.Denominator),
		Unit:           strings.TrimSpace(in.Unit),
		TargetPermille: in.TargetPermille, Direction: in.Direction,
		Frequency: in.Frequency, OwnerID: in.OwnerID,
		EffectiveFrom: in.EffectiveFrom.UTC(),
		CreatedAt:     now.UTC(), CreatedBy: by,
	}, nil
}

// KPIValue is one measurement of one indicator over one period
// (SRS-QMS-010).
type KPIValue struct {
	ID       string
	TenantID string

	DefinitionID string
	Code         string
	// Revision is the dictionary revision this value was computed under. The
	// whole point: a value plotted against a target must be comparable with
	// the values beside it, and the revision is how a reader knows whether it
	// is.
	Revision int

	PeriodFrom time.Time
	PeriodTo   time.Time

	Numerator   int64
	Denominator int64
	// Permille is numerator over denominator, in parts per thousand. Derived,
	// never supplied: a value a submitter can type is a value that will not
	// match its own numerator.
	Permille int
	// Unanswerable marks a period with a zero denominator. Named rather than
	// reported as zero, because "no eligible cases this month" and "we failed
	// every case this month" are opposite facts and a zero says the second.
	Unanswerable bool

	// SourceNote records where the counts came from, which is what makes the
	// figure auditable (SRS-OPSNFR-008).
	SourceNote string
	RecordedAt time.Time
	RecordedBy string
}

// RecordKPIValue records a measurement (SRS-QMS-010).
func RecordKPIValue(id, tenantID string, definition KPIDefinition,
	from, to time.Time, numerator, denominator int64, sourceNote, by string,
	now time.Time) (KPIValue, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return KPIValue{}, fmt.Errorf("%w: a value needs an id",
			ErrInvalidQuality)
	case definition.ID == "":
		return KPIValue{}, fmt.Errorf("%w: a value names its indicator",
			ErrInvalidQuality)
	case from.IsZero() || to.IsZero() || !to.After(from):
		return KPIValue{}, fmt.Errorf("%w: a value needs a period with length",
			ErrInvalidQuality)
	case numerator < 0 || denominator < 0:
		return KPIValue{}, fmt.Errorf("%w: counts cannot be negative",
			ErrInvalidQuality)
	case numerator > denominator && denominator > 0:
		// A rate above 100% is an arithmetic mistake or a definition mistake,
		// and either way it is not a measurement.
		return KPIValue{}, fmt.Errorf(
			"%w: the numerator (%d) exceeds the denominator (%d)",
			ErrInvalidQuality, numerator, denominator)
	case strings.TrimSpace(sourceNote) == "":
		return KPIValue{}, fmt.Errorf("%w: a value records where it came from",
			ErrInvalidQuality)
	}

	value := KPIValue{
		ID: id, TenantID: tenantID,
		DefinitionID: definition.ID, Code: definition.Code,
		Revision:   definition.Revision,
		PeriodFrom: from.UTC(), PeriodTo: to.UTC(),
		Numerator: numerator, Denominator: denominator,
		SourceNote: strings.TrimSpace(sourceNote),
		RecordedAt: now.UTC(), RecordedBy: by,
	}
	if denominator == 0 {
		value.Unanswerable = true
		return value, nil
	}
	// Integer arithmetic throughout: parts per thousand, rounded to nearest.
	value.Permille = int((numerator*2000 + denominator) / (denominator * 2))
	return value, nil
}

// MeetsTarget reports a value against its indicator's target.
//
// Returns false for an unanswerable period rather than passing it: a month
// with no eligible cases has not met the target, it has not been measured.
func (v KPIValue) MeetsTarget(definition KPIDefinition) (bool, bool) {
	if v.Unanswerable {
		return false, false
	}
	switch definition.Direction {
	case DirectionLowerIsBetter:
		return v.Permille <= definition.TargetPermille, true
	default:
		return v.Permille >= definition.TargetPermille, true
	}
}
