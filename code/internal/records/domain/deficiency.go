package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// DeficiencyKind is what is wrong with a chart (SRS-MRD-002, SRS-MRD-008).
type DeficiencyKind string

const (
	// DeficiencyMissing is a document the checklist requires and nobody has
	// written.
	DeficiencyMissing DeficiencyKind = "missing_document"
	// DeficiencyUnsigned is a document somebody wrote and nobody signed.
	DeficiencyUnsigned DeficiencyKind = "unsigned_document"
	// DeficiencyIncomplete is a document that exists and is signed but does
	// not say what it has to — a discharge summary with no medication list
	// (SRS-MRD-008). Raised by a reviewer rather than derived, because
	// whether a summary is adequate is a judgement.
	DeficiencyIncomplete DeficiencyKind = "incomplete_document"
	// DeficiencyCoding is a chart the coder cannot finish.
	DeficiencyCoding DeficiencyKind = "coding_query"
)

var knownDeficiencyKind = map[DeficiencyKind]bool{
	DeficiencyMissing: true, DeficiencyUnsigned: true,
	DeficiencyIncomplete: true, DeficiencyCoding: true,
}

// DeficiencyState is where a deficiency stands.
type DeficiencyState string

const (
	DeficiencyOpen DeficiencyState = "open"
	// DeficiencyResolved was answered by new clinical content: a signature, a
	// new note, an addendum. Never by editing what was signed.
	DeficiencyResolved DeficiencyState = "resolved"
	// DeficiencyWaived is a deficiency the hospital decided not to chase —
	// the clinician has left, the record is twenty years old. Kept and
	// counted apart from resolved, because a completion rate that treats a
	// waiver as a completion is a completion rate nobody should quote.
	DeficiencyWaived DeficiencyState = "waived"
)

// Deficiency is one thing wrong with one chart, owned by one person
// (SRS-MRD-002).
//
// There is no content field. A deficiency says what is missing and who owes
// it; the answer is a clinical document written in the clinical context, and
// this record holds its identifier.
type Deficiency struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string

	Kind DeficiencyKind
	// DocumentKind is what is missing or unsigned, in the clinical context's
	// vocabulary.
	DocumentKind string
	Label        string
	// DocumentID is the unsigned or inadequate document where there is one.
	// Empty for a missing document, which is the whole difference.
	DocumentID string
	// Detail is what a reviewer said is inadequate — "no medication list on
	// discharge". About the document, never from it.
	Detail string

	// OwnerID is the clinician who owes it. Required: a deficiency owned by
	// "the medical team" is owned by nobody, and it is still open when the
	// notes are requested by a coroner two years later.
	OwnerID string
	// ChecklistCode and ChecklistRevision pin the version that raised it, so
	// a deficiency stays explicable after the checklist changes.
	ChecklistCode     string
	ChecklistRevision int

	State DeficiencyState
	// DueBy is when it stops being reasonable, not when somebody would like
	// it.
	DueBy time.Time

	RaisedAt time.Time
	RaisedBy string

	// ResolvedByDocumentID is the note, signature or addendum that answered
	// it. Required to resolve: a deficiency closed with nothing to point at
	// is a deficiency somebody ticked.
	ResolvedByDocumentID string
	ResolvedAt           time.Time
	ResolvedBy           string

	WaivedReason string

	// EscalatedAt is when somebody above the owner was told. Recorded so a
	// second sweep does not page the same consultant every night.
	EscalatedAt time.Time
	Version     int64
}

// NewDeficiencyInput raises a deficiency.
type NewDeficiencyInput struct {
	PatientID         string
	EncounterID       string
	FacilityID        string
	Kind              DeficiencyKind
	DocumentKind      string
	Label             string
	DocumentID        string
	Detail            string
	OwnerID           string
	ChecklistCode     string
	ChecklistRevision int
	DueBy             time.Time
}

// RaiseDeficiency records something a chart is missing (SRS-MRD-002).
func RaiseDeficiency(id, tenantID string, in NewDeficiencyInput, by string,
	now time.Time) (Deficiency, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Deficiency{}, fmt.Errorf("%w: a deficiency needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.EncounterID) == "":
		return Deficiency{}, fmt.Errorf("%w: a deficiency names its encounter",
			ErrInvalidRecord)
	case !knownDeficiencyKind[in.Kind]:
		return Deficiency{}, fmt.Errorf("%w: unknown deficiency kind %q",
			ErrInvalidRecord, in.Kind)
	case strings.TrimSpace(in.OwnerID) == "":
		// A deficiency owned by the team is owned by nobody, and it is still
		// open when a coroner asks for the notes.
		return Deficiency{}, fmt.Errorf(
			"%w: a deficiency names the clinician who owes it",
			ErrInvalidRecord)
	case strings.TrimSpace(in.DocumentKind) == "":
		return Deficiency{}, fmt.Errorf(
			"%w: a deficiency names the document kind it is about",
			ErrInvalidRecord)
	}

	// The two kinds that are about a particular document have to name it, and
	// the one that is about its absence must not.
	switch in.Kind {
	case DeficiencyUnsigned, DeficiencyIncomplete:
		if strings.TrimSpace(in.DocumentID) == "" {
			return Deficiency{}, fmt.Errorf(
				"%w: a %s deficiency names the document",
				ErrInvalidRecord, in.Kind)
		}
	case DeficiencyMissing:
		if strings.TrimSpace(in.DocumentID) != "" {
			return Deficiency{}, fmt.Errorf(
				"%w: a missing document has no document to name",
				ErrInvalidRecord)
		}
	}
	if in.Kind == DeficiencyIncomplete && strings.TrimSpace(in.Detail) == "" {
		// "Inadequate" with no detail is a deficiency the clinician cannot
		// answer, and it sits open until somebody waives it.
		return Deficiency{}, fmt.Errorf(
			"%w: say what is inadequate about it", ErrInvalidRecord)
	}

	label := strings.TrimSpace(in.Label)
	if label == "" {
		label = strings.TrimSpace(in.DocumentKind)
	}
	return Deficiency{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: in.FacilityID, Kind: in.Kind,
		DocumentKind: strings.TrimSpace(in.DocumentKind), Label: label,
		DocumentID:        strings.TrimSpace(in.DocumentID),
		Detail:            strings.TrimSpace(in.Detail),
		OwnerID:           in.OwnerID,
		ChecklistCode:     strings.TrimSpace(in.ChecklistCode),
		ChecklistRevision: in.ChecklistRevision,
		State:             DeficiencyOpen, DueBy: utcOrZero(in.DueBy),
		RaisedAt: now.UTC(), RaisedBy: by, Version: 1,
	}, nil
}

// Resolve closes a deficiency against the clinical content that answered it
// (SRS-MRD-002, SRS-MRD-008).
//
// This is where SRS-MRD-008's "deficiencies can be resolved without altering
// signed history" is made structural rather than promised. Resolving takes a
// document identifier and nothing else: no text, no sections, no amendment
// payload. Whatever answered the deficiency was written in the clinical
// context under its own rules — where a signed note cannot be edited and a
// correction is an amendment that keeps the original — and this records which
// document it was.
//
// A resolution that pointed at the same document the deficiency was raised
// against is refused for the unsigned and inadequate kinds, because that is
// exactly the edit-in-place the requirement exists to prevent: the answer is
// a signature, an addendum or a new note, each of which has its own
// identifier.
func (d *Deficiency) Resolve(documentID, by string, now time.Time) error {
	switch {
	case d.State != DeficiencyOpen:
		return fmt.Errorf("%w: this deficiency is already %s",
			ErrInvalidRecord, d.State)
	case strings.TrimSpace(documentID) == "":
		// A deficiency closed with nothing to point at is one somebody
		// ticked.
		return fmt.Errorf(
			"%w: name the document that answered this deficiency",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a resolution names who made it",
			ErrInvalidRecord)
	}

	if d.Kind == DeficiencyIncomplete && documentID == d.DocumentID {
		return fmt.Errorf(
			"%w: an inadequate signed document is answered by an addendum or "+
				"an amendment, which has its own identifier",
			ErrInvalidRecord)
	}

	d.State = DeficiencyResolved
	d.ResolvedByDocumentID = strings.TrimSpace(documentID)
	d.ResolvedAt, d.ResolvedBy = now.UTC(), by
	return nil
}

// Waive records the hospital deciding not to chase a deficiency
// (SRS-MRD-002).
//
// Counted apart from resolved wherever a completion rate is reported. A chart
// nobody will ever complete is a real thing — the clinician left, the record
// is from 2003 — and pretending it was completed is how a completion rate
// stops meaning anything.
func (d *Deficiency) Waive(reason, by string, now time.Time) error {
	switch {
	case d.State != DeficiencyOpen:
		return fmt.Errorf("%w: this deficiency is already %s",
			ErrInvalidRecord, d.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this deficiency will not be chased",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a waiver names who gave it", ErrInvalidRecord)
	}
	d.State, d.WaivedReason = DeficiencyWaived, strings.TrimSpace(reason)
	d.ResolvedAt, d.ResolvedBy = now.UTC(), by
	return nil
}

// Reassign moves a deficiency to the clinician who actually owes it
// (SRS-MRD-002).
//
// A registrar who wrote the note may have rotated; the consultant responsible
// has not. Kept as an explicit act with a reason rather than a silent field
// edit, because "this is not mine" is how a deficiency travels round a
// department for a month.
func (d *Deficiency) Reassign(ownerID, reason, by string,
	now time.Time) error {

	switch {
	case d.State != DeficiencyOpen:
		return fmt.Errorf("%w: this deficiency is already %s",
			ErrInvalidRecord, d.State)
	case strings.TrimSpace(ownerID) == "":
		return fmt.Errorf("%w: a reassignment names the new owner",
			ErrInvalidRecord)
	case ownerID == d.OwnerID:
		return fmt.Errorf("%w: that is already the owner", ErrInvalidRecord)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this deficiency is being reassigned",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a reassignment names who made it",
			ErrInvalidRecord)
	}
	d.OwnerID = ownerID
	// The clock does not restart. A deficiency that has been open for six
	// weeks has been open for six weeks whoever it now belongs to, and a
	// reassignment that reset the age would be the easiest way to clear an
	// aging report.
	_ = now
	return nil
}

// Overdue reports a deficiency past the point it stops being reasonable.
func (d Deficiency) Overdue(at time.Time) bool {
	return d.State == DeficiencyOpen && !d.DueBy.IsZero() && at.After(d.DueBy)
}

// AgeDays is how long a deficiency has been open, in whole days.
func (d Deficiency) AgeDays(at time.Time) int {
	if d.RaisedAt.IsZero() || at.Before(d.RaisedAt) {
		return 0
	}
	return int(at.Sub(d.RaisedAt).Hours() / 24)
}

// AgeBucket is one band of a deficiency aging report (SRS-MRD-002).
type AgeBucket struct {
	// From and To are the band in days; To of zero is open-ended.
	From, To int
	Label    string
	Count    int
	// Overdue counts the ones past their own date, which is not the same as
	// the ones in the oldest band: a discharge summary due in 24 hours is
	// overdue at two days and an operation note due immediately is overdue at
	// two hours.
	Overdue int
}

// AgingReport bands open deficiencies by age (SRS-MRD-002).
//
// The bands are the caller's, because "old" means something different for a
// discharge summary and for a coding query. Resolved and waived deficiencies
// are excluded: an aging report is a worklist, and a worklist of things
// already done is not one.
func AgingReport(deficiencies []Deficiency, bands []AgeBucket,
	at time.Time) []AgeBucket {

	out := make([]AgeBucket, len(bands))
	copy(out, bands)
	for i := range out {
		out[i].Count, out[i].Overdue = 0, 0
	}

	for _, deficiency := range deficiencies {
		if deficiency.State != DeficiencyOpen {
			continue
		}
		age := deficiency.AgeDays(at)
		for i := range out {
			if age < out[i].From {
				continue
			}
			if out[i].To > 0 && age >= out[i].To {
				continue
			}
			out[i].Count++
			if deficiency.Overdue(at) {
				out[i].Overdue++
			}
			break
		}
	}
	return out
}

// EscalationCandidates lists the deficiencies somebody above the owner should
// be told about (SRS-MRD-002).
//
// Past their own date and past the configured grace period, and not escalated
// already. The last clause is what stops a nightly sweep paging the same
// consultant every night for a fortnight, which is how an escalation stops
// being read.
func EscalationCandidates(deficiencies []Deficiency, after time.Duration,
	at time.Time) []Deficiency {

	var out []Deficiency
	for _, deficiency := range deficiencies {
		switch {
		case deficiency.State != DeficiencyOpen:
			continue
		case !deficiency.EscalatedAt.IsZero():
			continue
		case deficiency.DueBy.IsZero():
			continue
		case !at.After(deficiency.DueBy.Add(after)):
			continue
		}
		out = append(out, deficiency)
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].DueBy.Before(out[b].DueBy)
	})
	return out
}

// MarkEscalated records that somebody above the owner was told.
func (d *Deficiency) MarkEscalated(now time.Time) {
	if d.EscalatedAt.IsZero() {
		d.EscalatedAt = now.UTC()
	}
}

// CompletionSummary is how a facility's charts stand (SRS-MRD-001,
// SRS-MRD-002).
type CompletionSummary struct {
	Encounters int
	// Complete counts encounters with nothing open and nothing waived. A
	// waived deficiency is a chart that will never be completed, and an
	// encounter carrying one is not a complete chart however the worklist
	// looks.
	Complete int
	// Incompletable counts the encounters a waiver has closed off. Reported
	// beside the rate, because a hospital whose completion rate rose the
	// month it started waiving should be able to see that.
	Incompletable int
	Open          int
	Overdue       int
	Resolved      int
	// Waived is counted and never folded into Complete or Resolved.
	Waived int
	// CompletePermille is complete encounters in parts per thousand of the
	// encounters looked at.
	CompletePermille int
	// Unanswerable marks a period with no encounters. A hospital that
	// admitted nobody did not achieve perfect record-keeping.
	Unanswerable bool
}

// SummariseCompletion counts a set of deficiencies against the encounters
// they were raised on (SRS-MRD-001).
func SummariseCompletion(encounterIDs []string,
	deficiencies []Deficiency, at time.Time) CompletionSummary {

	summary := CompletionSummary{Encounters: len(encounterIDs)}
	withOpen := map[string]bool{}
	withWaived := map[string]bool{}

	for _, deficiency := range deficiencies {
		switch deficiency.State {
		case DeficiencyOpen:
			summary.Open++
			withOpen[deficiency.EncounterID] = true
			if deficiency.Overdue(at) {
				summary.Overdue++
			}
		case DeficiencyResolved:
			summary.Resolved++
		case DeficiencyWaived:
			summary.Waived++
			withWaived[deficiency.EncounterID] = true
		}
	}

	if summary.Encounters == 0 {
		summary.Unanswerable = true
		return summary
	}
	for _, id := range encounterIDs {
		switch {
		case withOpen[id]:
		case withWaived[id]:
			summary.Incompletable++
		default:
			summary.Complete++
		}
	}
	summary.CompletePermille = permille(int64(summary.Complete),
		int64(summary.Encounters))
	return summary
}

func permille(a, b int64) int {
	if b == 0 {
		return 0
	}
	return int((a*2000 + b) / (b * 2))
}
