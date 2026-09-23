package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Cycle is a wash programme (SRS-LND-003, SRS-LND-005).
type Cycle string

const (
	// CycleStandard is the ordinary wash.
	CycleStandard Cycle = "standard"
	// CycleHot is the thermal-disinfection programme used for fouled
	// linen.
	CycleHot Cycle = "hot"
	// CycleBarrier is the programme rated to take sealed infected linen:
	// the bag dissolves in the drum and nobody handles the contents.
	CycleBarrier Cycle = "barrier"
	// CycleDelicate is for theatre drapes and anything that cannot take a
	// hot wash.
	CycleDelicate Cycle = "delicate"
)

var knownCycle = map[Cycle]bool{
	CycleStandard: true, CycleHot: true,
	CycleBarrier: true, CycleDelicate: true,
}

// TakesInfected reports the cycles a sealed infected load may enter
// (SRS-LND-005).
//
// One, and it is not a configuration. A hospital that could mark its ordinary
// programme as barrier-rated would, on the night the barrier machine broke.
func (c Cycle) TakesInfected() bool { return c == CycleBarrier }

// BatchState is where a wash batch stands (SRS-LND-003).
type BatchState string

const (
	// BatchLoading is a batch being filled with collections.
	BatchLoading BatchState = "loading"
	// BatchProcessing is the machine running.
	BatchProcessing BatchState = "processing"
	// BatchPassed is a batch that completed its cycle. The only state
	// linen may be issued from.
	BatchPassed BatchState = "passed"
	// BatchFailed is a batch whose cycle did not hold. Its linen looks
	// exactly like clean linen and is not.
	BatchFailed BatchState = "failed"
	// BatchRewashed is a failed batch whose load went back through. Its own
	// state, so a report cannot count the second pass as though the first
	// had never happened.
	BatchRewashed BatchState = "rewashed"
)

// Done reports a batch nobody is still running.
func (s BatchState) Done() bool {
	return s == BatchPassed || s == BatchFailed || s == BatchRewashed
}

// BatchException is something that went wrong in a wash (SRS-LND-003).
type BatchException struct {
	Code   string
	Detail string
}

// Batch is one wash load (SRS-LND-003).
type Batch struct {
	ID       string
	TenantID string

	Reference  string
	FacilityID string
	MachineID  string
	Cycle      Cycle
	// Infected marks a load carrying sealed infected linen. Derived from
	// what went in rather than set, so it cannot be cleared by a caller who
	// would rather not run the barrier programme.
	Infected bool

	// CollectionIDs is the chain SRS-LND-002 asks to be retained: which
	// units' linen is in this load, and therefore who to tell when it
	// fails.
	CollectionIDs []string
	WeightG       int

	State BatchState
	// Outcome is what the cycle reported, in the machine's own words.
	Outcome string
	// Exceptions are what went wrong. Recorded on a pass as well as a
	// failure: a load that passed with the temperature probe out of
	// calibration is a load somebody wants to know about.
	Exceptions []BatchException
	// PeakTemperatureC is the highest temperature reached, in whole
	// degrees. Integers: a thermal disinfection record of 71.4999 degrees
	// is a number whose decimal is about the probe.
	PeakTemperatureC int
	// HoldMinutes is how long it held there.
	HoldMinutes int

	// RewashBatchID names the batch a failed load went into.
	RewashBatchID string
	// RewashOfBatchID names the failed batch this one is redoing.
	RewashOfBatchID string

	StartedAt   time.Time
	StartedBy   string
	CompletedAt time.Time
	CompletedBy string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewBatchInput opens a wash batch.
type NewBatchInput struct {
	Reference       string
	FacilityID      string
	MachineID       string
	Cycle           Cycle
	RewashOfBatchID string
}

// OpenBatch opens an empty wash batch (SRS-LND-003).
func OpenBatch(id, tenantID string, in NewBatchInput, by string,
	now time.Time) (Batch, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Batch{}, fmt.Errorf("%w: a batch needs an id",
			ErrInvalidLaundry)
	case !knownCycle[in.Cycle]:
		return Batch{}, fmt.Errorf("%w: unknown wash cycle %q",
			ErrInvalidLaundry, in.Cycle)
	case strings.TrimSpace(in.MachineID) == "":
		// A batch with no machine is a wash nobody can trace when the
		// machine turns out to be the problem.
		return Batch{}, fmt.Errorf("%w: a batch names the machine it ran in",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return Batch{}, fmt.Errorf("%w: a batch names who opened it",
			ErrInvalidLaundry)
	}

	return Batch{
		ID: id, TenantID: tenantID,
		Reference:       strings.TrimSpace(in.Reference),
		FacilityID:      in.FacilityID,
		MachineID:       strings.TrimSpace(in.MachineID),
		Cycle:           in.Cycle,
		RewashOfBatchID: strings.TrimSpace(in.RewashOfBatchID),
		State:           BatchLoading,
		CreatedAt:       now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Load puts a collection into a batch (SRS-LND-002, SRS-LND-003,
// SRS-LND-005).
//
// The rule that matters is the third case. Sealed infected linen goes into a
// barrier cycle or it goes nowhere: a standard programme does not dissolve
// the inner bag and does not reach disinfection temperature, so the load
// comes out contaminated and indistinguishable from clean, and the people who
// sort it afterwards are the ones who find out.
func (b *Batch) Load(c *Collection, now time.Time) error {
	if b.State != BatchLoading {
		return fmt.Errorf("%w: this batch is %s and is not taking linen",
			ErrInvalidLaundry, b.State)
	}
	// Checked before the collection's own state, because the caller this
	// guard is for is one holding a stale read: their copy still says open,
	// and loading it again would weigh one trolley twice.
	for _, existing := range b.CollectionIDs {
		if existing == c.ID {
			return fmt.Errorf("%w: this collection is already in the batch",
				ErrInvalidLaundry)
		}
	}
	switch {
	case c.State != CollectionOpen:
		return fmt.Errorf("%w: this collection is %s",
			ErrInvalidLaundry, c.State)
	case c.SoilClass.Sealed() && !b.Cycle.TakesInfected():
		return fmt.Errorf(
			"%w: infected linen goes into a barrier cycle, not a %s one",
			ErrInvalidLaundry, b.Cycle)
	}

	b.CollectionIDs = append(b.CollectionIDs, c.ID)
	b.WeightG += c.WeightG
	if c.SoilClass.Sealed() {
		b.Infected = true
	}
	c.State = CollectionBatched
	c.BatchID = b.ID
	_ = now
	return nil
}

// Start begins the wash (SRS-LND-003).
func (b *Batch) Start(by string, now time.Time) error {
	switch {
	case b.State != BatchLoading:
		return fmt.Errorf("%w: this batch is %s",
			ErrInvalidLaundry, b.State)
	case len(b.CollectionIDs) == 0:
		// An empty batch that later reads as passed is a batch somebody can
		// issue linen from without any linen having been washed.
		return fmt.Errorf("%w: a batch with nothing in it is not a wash",
			ErrInvalidLaundry)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a wash names who started it",
			ErrInvalidLaundry)
	}
	b.State = BatchProcessing
	b.StartedAt, b.StartedBy = now.UTC(), by
	return nil
}

// CompleteInput closes a wash.
type CompleteInput struct {
	Passed           bool
	Outcome          string
	PeakTemperatureC int
	HoldMinutes      int
	Exceptions       []BatchException
}

// Complete records the outcome of a wash (SRS-LND-003).
//
// A failure says why. SRS-LND-003's acceptance is that the outcome and the
// exceptions are recorded, and an outcome of "failed" with nothing beside it
// tells the person deciding whether to rewash or condemn the load nothing at
// all.
func (b *Batch) Complete(in CompleteInput, by string, now time.Time) error {
	switch {
	case b.State != BatchProcessing:
		return fmt.Errorf("%w: this batch is %s and has not been started",
			ErrInvalidLaundry, b.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an outcome names who recorded it",
			ErrInvalidLaundry)
	case strings.TrimSpace(in.Outcome) == "":
		return fmt.Errorf("%w: a wash says how it went",
			ErrInvalidLaundry)
	case !in.Passed && len(in.Exceptions) == 0:
		return fmt.Errorf("%w: a failed wash says what went wrong",
			ErrInvalidLaundry)
	case in.PeakTemperatureC < 0 || in.HoldMinutes < 0:
		return fmt.Errorf(
			"%w: a temperature or a hold time cannot be negative",
			ErrInvalidLaundry)
	}

	exceptions := make([]BatchException, 0, len(in.Exceptions))
	for _, exception := range in.Exceptions {
		code := strings.TrimSpace(exception.Code)
		if code == "" {
			return fmt.Errorf("%w: an exception names what it is",
				ErrInvalidLaundry)
		}
		exceptions = append(exceptions, BatchException{
			Code: code, Detail: strings.TrimSpace(exception.Detail),
		})
	}

	b.State = BatchFailed
	if in.Passed {
		b.State = BatchPassed
	}
	b.Outcome = strings.TrimSpace(in.Outcome)
	b.Exceptions = exceptions
	b.PeakTemperatureC = in.PeakTemperatureC
	b.HoldMinutes = in.HoldMinutes
	b.CompletedAt, b.CompletedBy = now.UTC(), by
	return nil
}

// Rewash sends a failed load back through (SRS-LND-003).
//
// Only a failed one, and the failure stays on the record. A hospital that
// could turn a failed batch into a passed one by washing it again would have
// no way of noticing that one machine fails every third load.
func (b *Batch) Rewash(into *Batch, now time.Time) error {
	switch {
	case b.State != BatchFailed:
		return fmt.Errorf("%w: this batch is %s, not failed",
			ErrInvalidLaundry, b.State)
	case into.State != BatchLoading:
		return fmt.Errorf("%w: the replacement batch is %s",
			ErrInvalidLaundry, into.State)
	case b.Infected && !into.Cycle.TakesInfected():
		return fmt.Errorf(
			"%w: this load is infected and the replacement batch is a %s "+
				"cycle", ErrInvalidLaundry, into.Cycle)
	}

	into.CollectionIDs = append(into.CollectionIDs, b.CollectionIDs...)
	into.WeightG += b.WeightG
	into.Infected = into.Infected || b.Infected
	into.RewashOfBatchID = b.ID

	b.State = BatchRewashed
	b.RewashBatchID = into.ID
	_ = now
	return nil
}

// Issuable reports a batch whose linen may go back to a ward
// (SRS-LND-003, SRS-LND-004).
func (b Batch) Issuable() bool { return b.State == BatchPassed }

// BatchSummary reports how a set of washes went (SRS-LND-003).
type BatchSummary struct {
	Run      int
	Passed   int
	Failed   int
	Rewashed int
	InFlight int
	Infected int
	WeightKg int
	// WithExceptions counts batches that recorded an exception, passed or
	// failed. Counted apart from the failures, because a load that passed
	// with a probe fault is the one that tells a hospital its next load
	// will not.
	WithExceptions int
	// Unanswerable is a set with nothing completed in it.
	Unanswerable bool
}

// SummariseBatches counts a set of washes (SRS-LND-003).
func SummariseBatches(batches []Batch) BatchSummary {
	out := BatchSummary{}
	for _, batch := range batches {
		out.Run++
		if batch.Infected {
			out.Infected++
		}
		out.WeightKg += batch.WeightG / 1000
		if len(batch.Exceptions) > 0 {
			out.WithExceptions++
		}
		switch batch.State {
		case BatchPassed:
			out.Passed++
		case BatchFailed:
			out.Failed++
		case BatchRewashed:
			out.Rewashed++
		default:
			out.InFlight++
		}
	}
	if out.Passed+out.Failed+out.Rewashed == 0 {
		out.Unanswerable = true
	}
	return out
}

// FailedBatchUnits names the units whose linen was in a failed wash
// (SRS-LND-002, SRS-LND-003).
//
// The reason the chain is worth retaining. A batch that failed is linen that
// may already be on its way back, and the answer to "whose" is this.
func FailedBatchUnits(batch Batch, collections []Collection) []string {
	if batch.State != BatchFailed {
		return nil
	}
	inBatch := map[string]bool{}
	for _, id := range batch.CollectionIDs {
		inBatch[id] = true
	}
	seen := map[string]bool{}
	var out []string
	for _, collection := range collections {
		if !inBatch[collection.ID] || seen[collection.UnitID] {
			continue
		}
		seen[collection.UnitID] = true
		out = append(out, collection.UnitID)
	}
	sort.Strings(out)
	return out
}
