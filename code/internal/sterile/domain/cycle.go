package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// CycleResult is what the sterilizer reported (SRS-CSSD-006).
type CycleResult string

const (
	// CycleRunning is a load in the machine. Not a result, and the state a
	// load sits in until the machine says otherwise.
	CycleRunning CycleResult = "running"
	CyclePassed  CycleResult = "passed"
	CycleFailed  CycleResult = "failed"
	// CycleAborted is a run stopped part-way. Distinct from failed, because
	// the parameters were never reached rather than missed.
	CycleAborted CycleResult = "aborted"
)

var knownCycleResults = map[CycleResult]bool{
	CycleRunning: true, CyclePassed: true,
	CycleFailed: true, CycleAborted: true,
}

// IndicatorKind is what was used to check the load (SRS-CSSD-007).
type IndicatorKind string

const (
	// IndicatorChemical changes colour when the conditions were met. Read
	// immediately, and the weaker evidence.
	IndicatorChemical IndicatorKind = "chemical"
	// IndicatorBiological is a spore challenge, incubated. The stronger
	// evidence and the slower: a load released before it reads is a load
	// released on a promise.
	IndicatorBiological IndicatorKind = "biological"
)

var knownIndicators = map[IndicatorKind]bool{
	IndicatorChemical: true, IndicatorBiological: true,
}

// IndicatorResult is one indicator read (SRS-CSSD-007).
type IndicatorResult struct {
	ID       string
	TenantID string
	CycleID  string

	Kind IndicatorKind
	// Lot identifies the indicator batch, because a bad batch of indicators
	// invalidates every load they cleared.
	Lot    string
	Passed bool
	Notes  string

	ReadAt time.Time
	ReadBy string
}

// Cycle is one sterilizer load (SRS-CSSD-006).
type Cycle struct {
	ID       string
	TenantID string

	// Machine and LoadNumber identify the run to an engineer. The load number
	// is what a recall is announced by.
	Machine    string
	LoadNumber string
	Program    string

	// Parameters are what the machine reported or a technician recorded:
	// temperature, pressure, hold time. Free-form, because sterilizers differ
	// and a fixed schema would lose whatever this one measures.
	Parameters map[string]float64
	// Source marks a cycle whose parameters came from the machine rather than
	// a keyboard. A hand-typed cycle record is evidence of a different weight,
	// and SRS-CSSD-006 asks for the ingestion where it exists.
	Source CycleSource

	Result CycleResult
	// Released is the authorisation that lets the packs in this load leave.
	// Separate from the result: a passed cycle with an unread biological
	// indicator is a load nobody may distribute yet.
	Released    bool
	ReleasedBy  string
	ReleasedAt  time.Time
	ReleaseNote string

	Indicators []IndicatorResult

	StartedAt time.Time
	EndedAt   time.Time
	StartedBy string
	Version   int64
}

// CycleSource is where a cycle record came from.
type CycleSource string

const (
	CycleManual   CycleSource = "manual"
	CycleIngested CycleSource = "ingested"
)

// NewCycleInput starts a sterilizer load.
type NewCycleInput struct {
	Machine    string
	LoadNumber string
	Program    string
	Parameters map[string]float64
	Source     CycleSource
	StartedAt  time.Time
}

// StartCycle records a sterilizer load (SRS-CSSD-006).
func StartCycle(id, tenantID string, in NewCycleInput, by string,
	now time.Time) (Cycle, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Cycle{}, fmt.Errorf("%w: a cycle needs an id", ErrInvalidSet)
	case strings.TrimSpace(in.Machine) == "":
		// Without the machine a recall cannot reach the other loads it ran,
		// and a sterilizer failing is a machine-shaped problem.
		return Cycle{}, fmt.Errorf("%w: a cycle names the sterilizer",
			ErrInvalidSet)
	case strings.TrimSpace(in.LoadNumber) == "":
		return Cycle{}, fmt.Errorf("%w: a cycle names its load number",
			ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return Cycle{}, fmt.Errorf("%w: a cycle names who ran it", ErrInvalidSet)
	}

	source := in.Source
	if source == "" {
		source = CycleManual
	}
	started := in.StartedAt
	if started.IsZero() {
		started = now
	}

	return Cycle{
		ID: id, TenantID: tenantID,
		Machine:    strings.TrimSpace(in.Machine),
		LoadNumber: strings.TrimSpace(in.LoadNumber),
		Program:    strings.TrimSpace(in.Program),
		Parameters: copyParameters(in.Parameters),
		Source:     source,
		Result:     CycleRunning,
		StartedAt:  started.UTC(), StartedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

func copyParameters(in map[string]float64) map[string]float64 {
	out := make(map[string]float64, len(in))
	for key, value := range in {
		out[key] = value
	}
	return out
}

// Finish records the sterilizer's verdict (SRS-CSSD-006).
func (c *Cycle) Finish(result CycleResult, parameters map[string]float64,
	at time.Time) error {

	switch {
	case c.Result != CycleRunning:
		return fmt.Errorf("%w: this cycle has already finished (%s)",
			ErrInvalidSet, c.Result)
	case !knownCycleResults[result] || result == CycleRunning:
		return fmt.Errorf("%w: unknown cycle result %q", ErrInvalidSet, result)
	case at.Before(c.StartedAt):
		return fmt.Errorf("%w: a cycle ends after it starts", ErrInvalidSet)
	}

	for key, value := range parameters {
		c.Parameters[key] = value
	}
	c.Result, c.EndedAt = result, at.UTC()
	return nil
}

// RecordIndicator reads an indicator against the load (SRS-CSSD-007).
func (c *Cycle) RecordIndicator(id string, kind IndicatorKind, lot string,
	passed bool, notes, by string, now time.Time) (IndicatorResult, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return IndicatorResult{}, fmt.Errorf("%w: an indicator needs an id",
			ErrInvalidSet)
	case !knownIndicators[kind]:
		return IndicatorResult{}, fmt.Errorf("%w: unknown indicator %q",
			ErrInvalidSet, kind)
	case strings.TrimSpace(lot) == "":
		// A bad batch of indicators invalidates every load they cleared, and
		// the lot is the only thing that can find them.
		return IndicatorResult{}, fmt.Errorf("%w: an indicator names its lot",
			ErrInvalidSet)
	case strings.TrimSpace(by) == "":
		return IndicatorResult{}, fmt.Errorf("%w: an indicator names who read it",
			ErrInvalidSet)
	case !passed && strings.TrimSpace(notes) == "":
		return IndicatorResult{}, fmt.Errorf(
			"%w: a failed indicator records what was seen", ErrInvalidSet)
	}

	result := IndicatorResult{
		ID: id, TenantID: c.TenantID, CycleID: c.ID,
		Kind: kind, Lot: strings.TrimSpace(lot), Passed: passed,
		Notes:  strings.TrimSpace(notes),
		ReadAt: now.UTC(), ReadBy: strings.TrimSpace(by),
	}
	c.Indicators = append(c.Indicators, result)
	return result, nil
}

// ReleaseRefusal is why a load may not be distributed (SRS-CSSD-007).
type ReleaseRefusal string

const (
	ReleaseStillRunning      ReleaseRefusal = "cycle_still_running"
	ReleaseCycleFailed       ReleaseRefusal = "cycle_did_not_pass"
	ReleaseNoChemical        ReleaseRefusal = "no_chemical_indicator"
	ReleaseIndicatorFailed   ReleaseRefusal = "indicator_failed"
	ReleaseBiologicalPending ReleaseRefusal = "biological_indicator_not_read"
	ReleaseAlreadyReleased   ReleaseRefusal = "already_released"
)

// Explain renders a refusal for somebody who has to act on it.
func (r ReleaseRefusal) Explain() string {
	switch r {
	case ReleaseStillRunning:
		return "This cycle has not finished."
	case ReleaseCycleFailed:
		return "This cycle did not pass."
	case ReleaseNoChemical:
		return "No chemical indicator has been read for this load."
	case ReleaseIndicatorFailed:
		return "An indicator for this load failed."
	case ReleaseBiologicalPending:
		return "The biological indicator for this load has not been read."
	case ReleaseAlreadyReleased:
		return "This load has already been released."
	default:
		return string(r)
	}
}

// ReleaseDecision is whether a load's packs may be distributed.
type ReleaseDecision struct {
	// Refusals are every reason, not the first. A technician told one at a
	// time comes back to the same screen three times.
	Refusals     []ReleaseRefusal
	Explanations []string
}

// Allowed reports a load with nothing against it.
func (d ReleaseDecision) Allowed() bool { return len(d.Refusals) == 0 }

func (d *ReleaseDecision) refuse(reason ReleaseRefusal) {
	d.Refusals = append(d.Refusals, reason)
	d.Explanations = append(d.Explanations, reason.Explain())
}

// EvaluateRelease decides whether a load may be distributed (SRS-CSSD-007).
//
// requireBiological is the deployment's policy. Most departments release
// routine loads on the chemical indicator and hold implant loads for the
// biological one; a few hold everything. The choice belongs to the hospital,
// but the consequence of the choice does not: whichever it picks, a load that
// does not satisfy it is not distributable.
func (c Cycle) EvaluateRelease(requireBiological bool) ReleaseDecision {
	out := ReleaseDecision{}

	if c.Released {
		out.refuse(ReleaseAlreadyReleased)
	}
	switch c.Result {
	case CycleRunning:
		out.refuse(ReleaseStillRunning)
	case CyclePassed:
	default:
		out.refuse(ReleaseCycleFailed)
	}

	var chemical, biological bool
	for _, indicator := range c.Indicators {
		if !indicator.Passed {
			out.refuse(ReleaseIndicatorFailed)
			// One refusal for any number of failed indicators: the technician
			// needs to know the load is not going out, not how many ways.
			break
		}
	}
	for _, indicator := range c.Indicators {
		switch indicator.Kind {
		case IndicatorChemical:
			chemical = true
		case IndicatorBiological:
			biological = true
		}
	}
	if !chemical {
		out.refuse(ReleaseNoChemical)
	}
	if requireBiological && !biological {
		out.refuse(ReleaseBiologicalPending)
	}
	return out
}

// Release authorises distribution (SRS-CSSD-007).
//
// The decision is passed in rather than recomputed, so that the one place
// which decides is EvaluateRelease and a caller cannot release by skipping it.
func (c *Cycle) Release(decision ReleaseDecision, note, by string,
	now time.Time) error {

	switch {
	case !decision.Allowed():
		return fmt.Errorf("%w: %s", ErrInvalidSet,
			strings.Join(decision.Explanations, " "))
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: release names who authorised it", ErrInvalidSet)
	}

	c.Released, c.ReleasedBy = true, strings.TrimSpace(by)
	c.ReleasedAt, c.ReleaseNote = now.UTC(), strings.TrimSpace(note)
	return nil
}

// Sterilise attaches a run to a cycle (SRS-CSSD-005).
func (r *Run) Sterilise(id string, cycle Cycle, shelfLife time.Duration,
	by string, now time.Time) (StageRecord, error) {

	switch {
	case cycle.ID == "":
		return StageRecord{}, fmt.Errorf("%w: a pack names the load it went into",
			ErrInvalidSet)
	case shelfLife <= 0:
		// A pack with no shelf life never expires, which is the one direction
		// that lets an out-of-date pack reach a patient (SRS-CSSD-008).
		return StageRecord{}, fmt.Errorf(
			"%w: a pack needs an expiry policy", ErrInvalidSet)
	}

	record, err := r.Advance(id, AdvanceInput{
		Stage: StageSterilised, Equipment: cycle.Machine,
	}, by, now)
	if err != nil {
		return StageRecord{}, err
	}

	r.CycleID = cycle.ID
	r.SterilisedAt = now.UTC()
	r.ExpiresAt = now.Add(shelfLife).UTC()
	return record, nil
}

// ReleaseRun authorises one pack to leave, once its cycle has been released
// (SRS-CSSD-007).
func (r *Run) ReleaseRun(id string, cycle Cycle, by string, now time.Time) (
	StageRecord, error) {

	switch {
	case r.CycleID == "":
		return StageRecord{}, fmt.Errorf("%w: this pack has not been sterilised",
			ErrInvalidSet)
	case cycle.ID != r.CycleID:
		return StageRecord{}, fmt.Errorf("%w: that is a different load",
			ErrInvalidSet)
	case !cycle.Released:
		// The requirement's clause is that a failed or uncleared load cannot
		// be distributed, and this is where it bites: the pack's release is
		// gated on the load's.
		return StageRecord{}, fmt.Errorf(
			"%w: load %s has not been released", ErrInvalidSet, cycle.LoadNumber)
	}

	return r.Advance(id, AdvanceInput{Stage: StageReleased}, by, now)
}

// Expired reports a pack past its sterile life (SRS-CSSD-008).
func (r Run) Expired(now time.Time) bool {
	return !r.ExpiresAt.IsZero() && !now.Before(r.ExpiresAt)
}

// Issuable reports a pack that may be issued now (SRS-CSSD-008, SRS-CSSD-009).
func (r Run) Issuable(now time.Time) bool {
	return r.Stage == StageReleased && !r.Expired(now)
}

// Label is what goes on the outside of a pack (SRS-CSSD-008).
//
// Derived rather than stored: a label typed separately is a second account of
// what is in the pack, and it is the one the scrub nurse reads.
type Label struct {
	RunID      string
	SetCode    string
	SetVersion int
	CycleID    string
	LoadNumber string
	Machine    string

	SterilisedAt time.Time
	ExpiresAt    time.Time

	// Incomplete names what the label could not be built from. A pack whose
	// label silently omitted its cycle would look like any other.
	Incomplete []string
}

// BuildLabel derives a pack's label (SRS-CSSD-008).
func BuildLabel(run Run, cycle Cycle) Label {
	out := Label{
		RunID: run.ID, SetCode: run.SetCode, SetVersion: run.SetVersion,
		CycleID: run.CycleID, LoadNumber: cycle.LoadNumber,
		Machine:      cycle.Machine,
		SterilisedAt: run.SterilisedAt, ExpiresAt: run.ExpiresAt,
	}
	if run.CycleID == "" {
		out.Incomplete = append(out.Incomplete, "sterilisation cycle")
	}
	if run.SterilisedAt.IsZero() {
		out.Incomplete = append(out.Incomplete, "sterilised-on date")
	}
	if run.ExpiresAt.IsZero() {
		out.Incomplete = append(out.Incomplete, "expiry")
	}
	if run.Stage != StageReleased {
		out.Incomplete = append(out.Incomplete, "release authorisation")
	}
	sort.Strings(out.Incomplete)
	return out
}
