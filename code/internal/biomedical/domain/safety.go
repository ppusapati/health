package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// NoticeKind is what a manufacturer or regulator has issued (SRS-BIO-008).
type NoticeKind string

const (
	// NoticeRecall takes the equipment back. The strongest, and the one that
	// always holds the asset.
	NoticeRecall NoticeKind = "recall"
	// NoticeFieldSafety is a field safety notice: a correction to be applied,
	// usually in place.
	NoticeFieldSafety NoticeKind = "field_safety"
	// NoticeAdvisory is information — a changed instruction for use, a known
	// limitation. It does not stop the machine by itself.
	NoticeAdvisory NoticeKind = "advisory"
)

var knownNoticeKinds = map[NoticeKind]bool{
	NoticeRecall: true, NoticeFieldSafety: true, NoticeAdvisory: true,
}

// HoldsAsset reports a notice that stops the equipment being used.
//
// A recall always does. A field safety notice does where the issuer says so,
// which is the hospital's reading of the notice rather than this code's — so
// it is a field on the notice, not a rule here. An advisory never does.
func (k NoticeKind) HoldsAsset() bool { return k == NoticeRecall }

// TaskState is where one asset's response to a notice has got to.
type TaskState string

const (
	TaskOutstanding TaskState = "outstanding"
	// TaskInspected means somebody has looked. Distinct from corrected,
	// because most notices ask for an inspection first and only some assets
	// then need the correction.
	TaskInspected   TaskState = "inspected"
	TaskCorrected   TaskState = "corrected"
	TaskNotAffected TaskState = "not_affected"
	// TaskQuarantined is an asset taken out of service rather than corrected —
	// awaiting the manufacturer, or condemned.
	TaskQuarantined TaskState = "quarantined"
)

var knownTaskStates = map[TaskState]bool{
	TaskOutstanding: true, TaskInspected: true, TaskCorrected: true,
	TaskNotAffected: true, TaskQuarantined: true,
}

// Complete reports a task nobody needs to do anything more about.
func (s TaskState) Complete() bool {
	return s == TaskCorrected || s == TaskNotAffected || s == TaskQuarantined
}

// NoticeTask is one asset's response to a safety notice (SRS-BIO-008).
type NoticeTask struct {
	ID       string
	TenantID string
	NoticeID string

	AssetID  string
	AssetTag string

	State TaskState
	Note  string

	CompletedAt time.Time
	CompletedBy string
}

// SafetyNotice is a recall or field safety notice (SRS-BIO-008).
type SafetyNotice struct {
	ID       string
	TenantID string

	Reference string
	Kind      NoticeKind
	Issuer    string
	Summary   string

	// Make, Model and the serial range are how a notice names the equipment it
	// covers. Kept as the notice states them, because the matching is only as
	// good as what was written down and a reader has to be able to check it.
	Make        string
	Model       string
	SerialFrom  string
	SerialTo    string
	AffectedUDI string

	// HoldAffected stops every matched asset. True by default for a recall;
	// the hospital's reading of a field safety notice decides for that kind.
	HoldAffected bool
	// RequiredAction is what the notice asks be done to each asset.
	RequiredAction string
	// DueBy is when the manufacturer or regulator wants it done.
	DueBy time.Time

	IssuedOn    time.Time
	RaisedAt    time.Time
	RaisedBy    string
	ClosedAt    time.Time
	ClosedBy    string
	ClosureNote string
	Version     int64
}

// NewNoticeInput records a safety notice.
type NewNoticeInput struct {
	Reference      string
	Kind           NoticeKind
	Issuer         string
	Summary        string
	Make           string
	Model          string
	SerialFrom     string
	SerialTo       string
	AffectedUDI    string
	HoldAffected   bool
	RequiredAction string
	DueBy          time.Time
	IssuedOn       time.Time
}

// NewSafetyNotice records a recall or safety notice (SRS-BIO-008).
func NewSafetyNotice(id, tenantID string, in NewNoticeInput, by string,
	now time.Time) (SafetyNotice, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return SafetyNotice{}, fmt.Errorf("%w: a notice needs an id",
			ErrInvalidAsset)
	case strings.TrimSpace(in.Reference) == "":
		// The manufacturer's or regulator's own reference. An inspection asks
		// for it by name, and a notice recorded without one cannot be shown to
		// have been acted on.
		return SafetyNotice{}, fmt.Errorf("%w: a notice names its reference",
			ErrInvalidAsset)
	case !knownNoticeKinds[in.Kind]:
		return SafetyNotice{}, fmt.Errorf("%w: unknown notice kind %q",
			ErrInvalidAsset, in.Kind)
	case strings.TrimSpace(in.Summary) == "":
		return SafetyNotice{}, fmt.Errorf("%w: a notice says what it is about",
			ErrInvalidAsset)
	case strings.TrimSpace(in.RequiredAction) == "":
		// A notice with no action produces tasks nobody knows how to
		// complete, and they sit outstanding for ever.
		return SafetyNotice{}, fmt.Errorf("%w: a notice says what must be done",
			ErrInvalidAsset)
	case strings.TrimSpace(in.Make) == "" && strings.TrimSpace(in.AffectedUDI) == "":
		// Without a make or a UDI nothing can be matched, and the notice
		// reaches no asset at all.
		return SafetyNotice{}, fmt.Errorf(
			"%w: a notice names the equipment it covers, by make or by UDI",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return SafetyNotice{}, fmt.Errorf("%w: a notice names who recorded it",
			ErrInvalidAsset)
	}

	hold := in.HoldAffected
	if in.Kind.HoldsAsset() {
		// A recall always holds, whatever the request said. The one direction
		// that must not be configurable.
		hold = true
	}

	return SafetyNotice{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), Kind: in.Kind,
		Issuer:  strings.TrimSpace(in.Issuer),
		Summary: strings.TrimSpace(in.Summary),
		Make:    strings.TrimSpace(in.Make), Model: strings.TrimSpace(in.Model),
		SerialFrom:     strings.TrimSpace(in.SerialFrom),
		SerialTo:       strings.TrimSpace(in.SerialTo),
		AffectedUDI:    strings.TrimSpace(in.AffectedUDI),
		HoldAffected:   hold,
		RequiredAction: strings.TrimSpace(in.RequiredAction),
		DueBy:          in.DueBy.UTC(), IssuedOn: in.IssuedOn.UTC(),
		RaisedAt: now.UTC(), RaisedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Covers reports whether a notice reaches one asset (SRS-BIO-008).
//
// A UDI match is exact and wins outright. Otherwise the make must match and,
// where the notice names one, the model; a serial range narrows it further.
// Deliberately inclusive where the notice is vague: a notice naming a make and
// no model reaches every asset of that make, because the alternative is
// missing one.
func (n SafetyNotice) Covers(a Asset) bool {
	if a.Status == AssetDisposed {
		// Already gone. Raising a task against it would leave an outstanding
		// item nobody can complete.
		return false
	}
	if n.AffectedUDI != "" && a.UDI != "" {
		return strings.EqualFold(n.AffectedUDI, a.UDI)
	}
	if n.Make == "" || !strings.EqualFold(n.Make, a.Make) {
		return false
	}
	if n.Model != "" && !strings.EqualFold(n.Model, a.Model) {
		return false
	}
	if n.SerialFrom != "" || n.SerialTo != "" {
		if a.Serial == "" {
			// A serial range on an asset with no serial: included, because
			// excluding it would quietly drop the machine from a recall on the
			// strength of a missing field.
			return true
		}
		if n.SerialFrom != "" && a.Serial < n.SerialFrom {
			return false
		}
		if n.SerialTo != "" && a.Serial > n.SerialTo {
			return false
		}
	}
	return true
}

// Match builds the task list a notice produces (SRS-BIO-008).
//
// One task per affected asset, so the acceptance — "tasks track
// inspection/correction completion" — is answerable per machine rather than as
// a single tick for the whole notice.
func (n SafetyNotice) Match(assets []Asset, newID func() string) []NoticeTask {
	var out []NoticeTask
	for _, asset := range assets {
		if !n.Covers(asset) {
			continue
		}
		out = append(out, NoticeTask{
			ID: newID(), TenantID: n.TenantID, NoticeID: n.ID,
			AssetID: asset.ID, AssetTag: asset.Tag, State: TaskOutstanding,
		})
	}
	sort.Slice(out, func(i, j int) bool {
		return out[i].AssetTag < out[j].AssetTag
	})
	return out
}

// Advance records progress on one asset's task (SRS-BIO-008).
func (t *NoticeTask) Advance(to TaskState, note, by string,
	now time.Time) error {

	switch {
	case !knownTaskStates[to]:
		return fmt.Errorf("%w: unknown task state %q", ErrInvalidAsset, to)
	case t.State.Complete():
		return fmt.Errorf("%w: this task is already %s", ErrInvalidAsset, t.State)
	case to == TaskOutstanding:
		return fmt.Errorf("%w: a task does not go back to outstanding",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a task names who acted on it", ErrInvalidAsset)
	case to == TaskNotAffected && strings.TrimSpace(note) == "":
		// "Not affected" removes a machine from a recall. It is the one
		// verdict that needs a reason, because it is the one that ends the
		// enquiry.
		return fmt.Errorf(
			"%w: say why this asset is not affected by the notice",
			ErrInvalidAsset)
	}

	t.State, t.Note = to, strings.TrimSpace(note)
	if to.Complete() {
		t.CompletedAt, t.CompletedBy = now.UTC(), strings.TrimSpace(by)
	}
	return nil
}

// Progress is how far a notice has got (SRS-BIO-008).
type Progress struct {
	NoticeID    string
	Total       int
	Outstanding int
	Inspected   int
	Complete    int
	// Overdue counts tasks past the notice's due date and not complete, which
	// is what an inspection actually asks about.
	Overdue bool
}

// Track summarises a notice's tasks (SRS-BIO-008).
func Track(notice SafetyNotice, tasks []NoticeTask, now time.Time) Progress {
	out := Progress{NoticeID: notice.ID}
	for _, task := range tasks {
		if task.NoticeID != notice.ID {
			continue
		}
		out.Total++
		switch {
		case task.State.Complete():
			out.Complete++
		case task.State == TaskInspected:
			out.Inspected++
			out.Outstanding++
		default:
			out.Outstanding++
		}
	}
	if !notice.DueBy.IsZero() && out.Outstanding > 0 && now.After(notice.DueBy) {
		out.Overdue = true
	}
	return out
}

// CloseNotice ends a safety notice (SRS-BIO-008).
//
// Refused while any task is outstanding. A notice closed with work left is a
// hospital that has told itself it dealt with a recall, which is worse than
// one that knows it has not.
func (n *SafetyNotice) CloseNotice(progress Progress, by, note string,
	now time.Time) error {

	switch {
	case !n.ClosedAt.IsZero():
		return fmt.Errorf("%w: this notice is already closed", ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who signed it", ErrInvalidAsset)
	case progress.Outstanding > 0:
		return fmt.Errorf(
			"%w: %d asset(s) still have work outstanding under this notice",
			ErrInvalidAsset, progress.Outstanding)
	}
	n.ClosedAt, n.ClosedBy = now.UTC(), strings.TrimSpace(by)
	n.ClosureNote = strings.TrimSpace(note)
	return nil
}
