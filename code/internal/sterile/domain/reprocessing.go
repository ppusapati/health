package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Stage is a step of reprocessing (SRS-CSSD-002 … 005).
//
// Ordered, and the order is the safety property: the requirement's clause is
// "stage cannot be skipped unless authorized exception", and an instrument
// packed without being washed is one that carries the last patient's tissue
// into the next one.
type Stage string

const (
	// StageReceived begins the chain of custody: a dirty set arriving from
	// theatre or a ward, scanned and counted.
	StageReceived Stage = "received"
	// StageDecontaminated is the first step that makes the set safe to handle.
	StageDecontaminated Stage = "decontaminated"
	StageWashed         Stage = "washed"
	// StageInspected is where a technician looks at each instrument. The step
	// that finds the crack before it finds the patient.
	StageInspected  Stage = "inspected"
	StageAssembled  Stage = "assembled"
	StagePackaged   Stage = "packaged"
	StageSterilised Stage = "sterilised"
	// StageReleased is the authorisation that lets a pack leave. Separate from
	// sterilised, because a cycle that ran is not a cycle that passed.
	StageReleased Stage = "released"
)

// stageOrder is the sequence. Its index is the whole of the skip rule.
var stageOrder = []Stage{
	StageReceived, StageDecontaminated, StageWashed, StageInspected,
	StageAssembled, StagePackaged, StageSterilised, StageReleased,
}

var stageIndex = func() map[Stage]int {
	out := make(map[Stage]int, len(stageOrder))
	for i, stage := range stageOrder {
		out[stage] = i
	}
	return out
}()

// KnownStage reports a stage the department recognises.
func KnownStage(s Stage) bool {
	_, ok := stageIndex[s]
	return ok
}

// Next returns the stage that should follow, and false at the end.
func (s Stage) Next() (Stage, bool) {
	i, ok := stageIndex[s]
	if !ok || i+1 >= len(stageOrder) {
		return "", false
	}
	return stageOrder[i+1], true
}

// StageRecord is one step actually performed (SRS-CSSD-003).
type StageRecord struct {
	ID       string
	TenantID string
	// TrayUseID is the reprocessing run this step belongs to.
	RunID string

	Stage Stage
	// Equipment is the washer or sterilizer used, where one was. Blank for
	// inspection, which is done by eye.
	Equipment string
	Notes     string

	// Skipped marks an authorised exception: a stage that did not happen and
	// was signed off. The requirement allows it, so the record has to hold
	// it — an exception that cannot be recorded is one that happens off the
	// system.
	Skipped          bool
	SkipAuthorisedBy string
	SkipReason       string

	PerformedAt time.Time
	PerformedBy string
}

// Run is one pass of a set through the department (SRS-CSSD-002 … 008).
//
// Its own aggregate rather than a status on the tray, because a tray goes
// round many times and each pass is separately auditable: an infection
// investigation asks about one cycle, not about a tray's whole life.
type Run struct {
	ID       string
	TenantID string

	// SetID and SetVersion are the tray and the packing list it was assembled
	// against. The version is recorded because a revision published tomorrow
	// must not change what this pack was checked against.
	SetID      string
	SetVersion int
	SetCode    string

	// SourceUnit is where the dirty set came from, which begins the chain of
	// custody (SRS-CSSD-002).
	SourceUnit string
	// SourceCaseID links back to the operation it was used in, where the
	// theatre recorded one. Empty for a set returned from a ward.
	SourceCaseID string

	Stage  Stage
	Stages []StageRecord

	// ReceivedCount is what arrived, against the packing list. A set that
	// arrives short is a set with an instrument somewhere else.
	ReceivedCount map[string]int
	// PackedCount is what went into the pack, recorded at assembly.
	PackedCount map[string]int
	// Missing and Replaced are what assembly found, kept because the pack's
	// composition is what a case trace reads (SRS-CSSD-004).
	Missing  []string
	Replaced []string

	// CycleID is the sterilizer load this pack went into (SRS-CSSD-005).
	CycleID string
	// PackagingMethod and IndicatorType are what the pack was wrapped and
	// marked with.
	PackagingMethod string
	IndicatorType   string

	// SterilisedAt and ExpiresAt bound the pack's sterile life
	// (SRS-CSSD-008).
	SterilisedAt time.Time
	ExpiresAt    time.Time

	StartedAt time.Time
	StartedBy string
	Version   int64
}

// ReceiveInput begins a reprocessing run (SRS-CSSD-002).
type ReceiveInput struct {
	SetID        string
	SetVersion   int
	SetCode      string
	SourceUnit   string
	SourceCaseID string
	// Counted is what arrived, by catalogue code.
	Counted map[string]int
}

// Receive takes a dirty set in (SRS-CSSD-002).
//
// The count against the packing list happens here rather than later, because
// this is the moment the department can still say where a missing instrument
// was last: in theatre. A shortfall found at assembly, three stages on, is a
// shortfall nobody can localise.
func Receive(id, tenantID string, in ReceiveInput, set TraySet, by string,
	now time.Time) (Run, []string, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Run{}, nil, fmt.Errorf("%w: a run needs an id", ErrInvalidSet)
	case strings.TrimSpace(in.SetID) == "":
		return Run{}, nil, fmt.Errorf("%w: a run names the set it is processing",
			ErrInvalidSet)
	case strings.TrimSpace(in.SourceUnit) == "":
		// The chain of custody begins with source, time and user. Without the
		// source, the chain begins nowhere.
		return Run{}, nil, fmt.Errorf(
			"%w: a receipt records where the set came from", ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return Run{}, nil, fmt.Errorf("%w: a receipt names who took it in",
			ErrInvalidSet)
	}

	counted := copyCounts(in.Counted)
	short := shortfall(set.Expected(), counted)

	run := Run{
		ID: id, TenantID: tenantID,
		SetID:      strings.TrimSpace(in.SetID),
		SetVersion: set.Version, SetCode: set.Code,
		SourceUnit:    strings.TrimSpace(in.SourceUnit),
		SourceCaseID:  strings.TrimSpace(in.SourceCaseID),
		Stage:         StageReceived,
		ReceivedCount: counted,
		StartedAt:     now.UTC(), StartedBy: strings.TrimSpace(by),
		Version: 1,
	}
	run.Stages = []StageRecord{{
		TenantID: tenantID, RunID: id, Stage: StageReceived,
		PerformedAt: now.UTC(), PerformedBy: strings.TrimSpace(by),
	}}
	// Returned rather than refused: a set arriving short is a fact, and
	// refusing to take it in would leave it in a corridor with nothing
	// recorded. What matters is that the shortfall is named now.
	return run, short, nil
}

func copyCounts(in map[string]int) map[string]int {
	out := make(map[string]int, len(in))
	for code, count := range in {
		out[code] = count
	}
	return out
}

// shortfall names the codes that arrived in fewer numbers than expected.
func shortfall(expected, actual map[string]int) []string {
	var out []string
	for code, want := range expected {
		if actual[code] < want {
			out = append(out, code)
		}
	}
	sort.Strings(out)
	return out
}

// AdvanceInput records one stage (SRS-CSSD-003).
type AdvanceInput struct {
	Stage     Stage
	Equipment string
	Notes     string

	// Skipped and its authorisation, for the exception the requirement allows.
	Skipped          bool
	SkipAuthorisedBy string
	SkipReason       string
}

// Advance moves a run to the next stage (SRS-CSSD-003).
//
// Strictly the next one. A stage out of order is refused, and a stage passed
// over needs a named authoriser and a reason — which is what "cannot be
// skipped unless authorized exception" means when it is written down as code
// rather than as a policy nobody can enforce.
func (r *Run) Advance(id string, in AdvanceInput, by string,
	now time.Time) (StageRecord, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return StageRecord{}, fmt.Errorf("%w: a stage record needs an id",
			ErrInvalidSet)
	case !KnownStage(in.Stage):
		return StageRecord{}, fmt.Errorf("%w: unknown stage %q",
			ErrInvalidSet, in.Stage)
	case strings.TrimSpace(by) == "":
		return StageRecord{}, fmt.Errorf("%w: a stage record names who did it",
			ErrInvalidSet)
	}

	expected, more := r.Stage.Next()
	if !more {
		return StageRecord{}, fmt.Errorf(
			"%w: this run is already released", ErrInvalidSet)
	}
	if in.Stage != expected {
		if stageIndex[in.Stage] < stageIndex[r.Stage] {
			return StageRecord{}, fmt.Errorf(
				"%w: this run is already at %s; %s is behind it",
				ErrInvalidSet, r.Stage, in.Stage)
		}
		return StageRecord{}, fmt.Errorf(
			"%w: %s comes after %s, not after %s; skip it explicitly if it "+
				"was authorised", ErrInvalidSet, in.Stage, previousOf(in.Stage),
			r.Stage)
	}

	if in.Skipped {
		switch {
		case strings.TrimSpace(in.SkipAuthorisedBy) == "":
			// The whole of the exception is that somebody is named. An
			// unauthorised skip is a stage that did not happen and that
			// nobody is answerable for.
			return StageRecord{}, fmt.Errorf(
				"%w: skipping %s names who authorised it", ErrInvalidSet, in.Stage)
		case strings.TrimSpace(in.SkipReason) == "":
			return StageRecord{}, fmt.Errorf("%w: skipping %s records why",
				ErrInvalidSet, in.Stage)
		case in.Stage == StageSterilised:
			// The one stage that cannot be skipped at all. Everything else in
			// this department exists to make this step meaningful, and a pack
			// released without it is an unsterile pack with a sterile label.
			return StageRecord{}, fmt.Errorf(
				"%w: sterilisation is not skippable, whoever authorises it",
				ErrInvalidSet)
		case in.Stage == StageReleased:
			// Nor is release: it is the authorisation itself.
			return StageRecord{}, fmt.Errorf(
				"%w: release is the authorisation; it cannot be skipped",
				ErrInvalidSet)
		}
	}

	record := StageRecord{
		ID: id, TenantID: r.TenantID, RunID: r.ID,
		Stage: in.Stage, Equipment: strings.TrimSpace(in.Equipment),
		Notes:            strings.TrimSpace(in.Notes),
		Skipped:          in.Skipped,
		SkipAuthorisedBy: strings.TrimSpace(in.SkipAuthorisedBy),
		SkipReason:       strings.TrimSpace(in.SkipReason),
		PerformedAt:      now.UTC(), PerformedBy: strings.TrimSpace(by),
	}
	r.Stage = in.Stage
	r.Stages = append(r.Stages, record)
	return record, nil
}

func previousOf(s Stage) Stage {
	i, ok := stageIndex[s]
	if !ok || i == 0 {
		return ""
	}
	return stageOrder[i-1]
}

// SkippedStages names the stages this run did not actually perform.
//
// Read at release and carried into the case trace: a pack assembled without
// inspection is one an infection investigation needs to know about.
func (r Run) SkippedStages() []string {
	var out []string
	for _, record := range r.Stages {
		if record.Skipped {
			out = append(out, string(record.Stage))
		}
	}
	sort.Strings(out)
	return out
}

// AssembleInput records what went into the pack (SRS-CSSD-004).
type AssembleInput struct {
	// Packed is what was actually put in, by catalogue code.
	Packed map[string]int
	// Replaced names items swapped for a substitute, which a later count has
	// to know about: a replaced instrument has a different serial number.
	Replaced []string
	Notes    string
}

// Assemble records a tray packed against its versioned list (SRS-CSSD-004).
//
// Returns the shortfall rather than refusing on it. A tray short of a
// non-critical item goes out short and the record says so; a tray short of a
// critical one is refused, because that pack is a cancelled case discovered
// at the moment the surgeon opens it.
func (r *Run) Assemble(id string, in AssembleInput, set TraySet, by string,
	now time.Time) (StageRecord, []string, error) {

	if r.Stage != StageInspected {
		return StageRecord{}, nil, fmt.Errorf(
			"%w: a set is assembled after inspection, not after %s",
			ErrInvalidSet, r.Stage)
	}

	packed := copyCounts(in.Packed)
	missing := shortfall(set.Expected(), packed)

	critical := map[string]bool{}
	for _, code := range set.CriticalItems() {
		critical[code] = true
	}
	var criticalMissing []string
	for _, code := range missing {
		if critical[code] {
			criticalMissing = append(criticalMissing, code)
		}
	}
	if len(criticalMissing) > 0 {
		return StageRecord{}, missing, fmt.Errorf(
			"%w: this set cannot go out without %s",
			ErrInvalidSet, strings.Join(criticalMissing, ", "))
	}

	record, err := r.Advance(id, AdvanceInput{
		Stage: StageAssembled, Notes: in.Notes,
	}, by, now)
	if err != nil {
		return StageRecord{}, missing, err
	}

	r.PackedCount = packed
	r.Missing = missing
	r.Replaced = trimmedAll(in.Replaced)
	return record, missing, nil
}

func trimmedAll(in []string) []string {
	out := make([]string, 0, len(in))
	for _, value := range in {
		if trimmed := strings.TrimSpace(value); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	sort.Strings(out)
	return out
}

// PackageInput records how the pack was wrapped (SRS-CSSD-005).
type PackageInput struct {
	Method        string
	IndicatorType string
	Notes         string
}

// Package records packaging and the indicator (SRS-CSSD-005).
func (r *Run) Package(id string, in PackageInput, by string, now time.Time) (
	StageRecord, error) {

	switch {
	case strings.TrimSpace(in.Method) == "":
		return StageRecord{}, fmt.Errorf(
			"%w: packaging records the method, which decides the shelf life",
			ErrInvalidSet)
	case strings.TrimSpace(in.IndicatorType) == "":
		// The indicator is the thing a scrub nurse reads as the pack is
		// opened. A pack with none carries no evidence at the only moment
		// anybody looks.
		return StageRecord{}, fmt.Errorf("%w: packaging records the indicator",
			ErrInvalidSet)
	}

	record, err := r.Advance(id, AdvanceInput{
		Stage: StagePackaged, Notes: in.Notes,
	}, by, now)
	if err != nil {
		return StageRecord{}, err
	}
	r.PackagingMethod = strings.TrimSpace(in.Method)
	r.IndicatorType = strings.TrimSpace(in.IndicatorType)
	return record, nil
}
