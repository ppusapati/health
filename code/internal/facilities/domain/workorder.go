package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Priority is how fast a work order needs somebody (SRS-FAC-002).
type Priority string

const (
	// PriorityEmergency is a failure that is hurting the hospital now: no
	// oxygen on a floor, no power to a theatre, water coming through a
	// ceiling into a ward.
	PriorityEmergency Priority = "emergency"
	// PriorityUrgent will become an emergency if it is left.
	PriorityUrgent  Priority = "urgent"
	PriorityRoutine Priority = "routine"
	// PriorityPlanned is work with a date rather than a clock — the
	// quarterly service, the scheduled replacement.
	PriorityPlanned Priority = "planned"
)

var knownPriority = map[Priority]bool{
	PriorityEmergency: true, PriorityUrgent: true,
	PriorityRoutine: true, PriorityPlanned: true,
}

func (p Priority) rank() int {
	switch p {
	case PriorityEmergency:
		return 0
	case PriorityUrgent:
		return 1
	case PriorityRoutine:
		return 2
	default:
		return 3
	}
}

// WorkState is where a work order stands (SRS-FAC-002).
type WorkState string

const (
	WorkRaised     WorkState = "raised"
	WorkAssigned   WorkState = "assigned"
	WorkInProgress WorkState = "in_progress"
	// WorkOnHold is waiting on something outside the team: a part, a
	// vendor, a window when the ward can be emptied. A state rather than a
	// flag, because an order sitting on hold for a fortnight and one being
	// worked on look identical otherwise.
	WorkOnHold WorkState = "on_hold"
	// WorkResolved is the engineer saying it is fixed. Not the same as
	// closed: somebody else checks.
	WorkResolved  WorkState = "resolved"
	WorkClosed    WorkState = "closed"
	WorkCancelled WorkState = "cancelled"
)

var knownWorkState = map[WorkState]bool{
	WorkRaised: true, WorkAssigned: true, WorkInProgress: true,
	WorkOnHold: true, WorkResolved: true, WorkClosed: true,
	WorkCancelled: true,
}

// Open reports whether a work order is still somebody's.
func (s WorkState) Open() bool {
	return s != WorkClosed && s != WorkCancelled
}

// WorkClass is a configured kind of maintenance work (SRS-FAC-010).
//
// It exists to carry two booleans. "Which classes of work need a permit" is a
// decision a hospital makes once, in writing, usually after an incident, and
// it must not be re-made by whoever is raising the ticket at the time. So the
// class says whether the work needs a permit to work and a lockout-tagout
// reference, the order copies both answers, and a composite foreign key in the
// database holds the copy to the original.
//
// The copy is the point. A CHECK constraint can only see one row, so "a closed
// order of a permit class names its permit" is only expressible as a database
// rule if the order carries the flag. The foreign key with ON UPDATE CASCADE
// is what stops the copy drifting: changing the class rewrites every order
// that references it, and an order whose flags disagree with its class cannot
// be written at all.
type WorkClass struct {
	TenantID string
	// Code is the stable key: "hot_work", "confined_space", "hv_switching".
	Code string
	Name string
	// RequiresPermit means no work starts without a permit to work.
	RequiresPermit bool
	// RequiresLOTO means the energy source is isolated, locked and tagged,
	// and the tag is recorded. Separate from the permit because they are
	// separate controls: hot work needs a permit and nothing to isolate,
	// and a belt change needs an isolation and no permit.
	RequiresLOTO bool
	Active       bool
	Note         string
}

// Unsafe reports whether this class needs safety paperwork (SRS-FAC-010).
func (c WorkClass) Unsafe() bool { return c.RequiresPermit || c.RequiresLOTO }

// Validate rejects a work class nothing could be raised against.
func (c WorkClass) Validate() error {
	switch {
	case strings.TrimSpace(c.Code) == "":
		return fmt.Errorf("%w: a work class needs a code",
			ErrInvalidFacilities)
	case strings.TrimSpace(c.Name) == "":
		return fmt.Errorf("%w: a work class needs a name",
			ErrInvalidFacilities)
	case c.Unsafe() && strings.TrimSpace(c.Note) == "":
		// A class somebody marked unsafe without saying why is one the
		// next person to review the list will quietly unmark.
		return fmt.Errorf("%w: say why %q needs safety paperwork",
			ErrInvalidFacilities, c.Code)
	}
	return nil
}

// SLATarget is how long a priority is allowed to take (SRS-FAC-002).
type SLATarget struct {
	Priority Priority
	// RespondMinutes is until somebody is on it. The number a ward
	// actually feels.
	RespondMinutes int
	// ResolveMinutes is until it is fixed.
	ResolveMinutes int
}

// SLAPolicy is a tenant's response and resolution targets.
type SLAPolicy struct {
	Targets []SLATarget
}

// DefaultSLAPolicy is the fallback when a tenant has configured nothing.
//
// A default rather than a refusal, because the acceptance for SRS-FAC-002 is
// that a ticket receives an SLA, and a deployment that has not yet held the
// meeting about response times still raises tickets. The figures are
// deliberately unambitious: a target nobody meets is one nobody reads.
func DefaultSLAPolicy() SLAPolicy {
	return SLAPolicy{Targets: []SLATarget{
		{Priority: PriorityEmergency, RespondMinutes: 15, ResolveMinutes: 240},
		{Priority: PriorityUrgent, RespondMinutes: 60, ResolveMinutes: 1440},
		{Priority: PriorityRoutine, RespondMinutes: 480, ResolveMinutes: 4320},
		{Priority: PriorityPlanned, RespondMinutes: 4320, ResolveMinutes: 43200},
	}}
}

// Target resolves the SLA for a priority.
func (p SLAPolicy) Target(priority Priority) (SLATarget, bool) {
	for _, target := range p.Targets {
		if target.Priority == priority {
			return target, true
		}
	}
	return SLATarget{}, false
}

// Validate rejects an SLA policy that could not be applied.
func (p SLAPolicy) Validate() error {
	seen := map[Priority]bool{}
	for _, target := range p.Targets {
		switch {
		case !knownPriority[target.Priority]:
			return fmt.Errorf("%w: unknown priority %q",
				ErrInvalidFacilities, target.Priority)
		case seen[target.Priority]:
			return fmt.Errorf("%w: two targets for %s",
				ErrInvalidFacilities, target.Priority)
		case target.RespondMinutes <= 0 || target.ResolveMinutes <= 0:
			return fmt.Errorf("%w: %s needs positive targets",
				ErrInvalidFacilities, target.Priority)
		case target.ResolveMinutes < target.RespondMinutes:
			// A resolution target inside the response target is a
			// target that is breached the moment it is met.
			return fmt.Errorf(
				"%w: %s must not be resolved before it is answered",
				ErrInvalidFacilities, target.Priority)
		}
		seen[target.Priority] = true
	}
	return nil
}

// WorkOrder is one piece of facilities work (SRS-FAC-002).
type WorkOrder struct {
	ID       string
	TenantID string
	// Number is the human reference: what a ward quotes on the phone.
	Number string

	FacilityID string
	// AssetID is the plant this is about, where there is one. A ceiling
	// leaking into a ward is a work order with a location and no asset,
	// and refusing it would push that work off the system entirely.
	AssetID string
	// System is always known even when the asset is not, because it
	// decides who the order routes to.
	System       System
	LocationID   string
	LocationNote string

	// Fault is what is wrong, Impact is what it is stopping. Both
	// required: "AHU-3 noisy" and "AHU-3 noisy, theatre 2 cancelled" are
	// the same fault and different work.
	Fault    string
	Impact   string
	Priority Priority

	// ClassCode and the two flags beside it are the safety contract
	// described on WorkClass. The flags are copied deliberately.
	ClassCode           string
	ClassRequiresPermit bool
	ClassRequiresLOTO   bool

	// OwnerTeam is resolved at raise time from the system, so a ticket
	// always has an owner rather than sitting in an unrouted pile.
	OwnerTeam   string
	OwnerUserID string

	State     WorkState
	RaisedAt  time.Time
	RaisedBy  string
	RespondBy time.Time
	ResolveBy time.Time

	RespondedAt time.Time
	StartedAt   time.Time
	ResolvedAt  time.Time
	ClosedAt    time.Time
	ClosedBy    string

	// PermitRef and LOTORef are the references SRS-FAC-010 asks for. They
	// are references rather than documents: the permit lives in the
	// hospital's permit book and this records which one.
	PermitRef      string
	PermitIssuedBy string
	LOTORef        string
	LOTOAppliedBy  string

	CompletionNote string
	RootCause      string
	// DowntimeMinutes is how long the asset was unavailable, which is a
	// KPI input rather than a duration anybody derives from the
	// timestamps: an order raised on Friday and worked on Monday did not
	// have the chiller down all weekend.
	DowntimeMinutes int

	HoldReason   string
	CancelReason string

	// AlarmID is left empty here on purpose. The link between an alarm and
	// the work it caused lives on the alarm (SRS-FAC-005), so that neither
	// row carries the other's lifecycle.

	CreatedAt time.Time
	Version   int64
}

// RaiseInput opens a facilities work order.
type RaiseInput struct {
	Number       string
	FacilityID   string
	AssetID      string
	System       System
	LocationID   string
	LocationNote string
	Fault        string
	Impact       string
	Priority     Priority
	Class        WorkClass
	// OwnerTeam is the routed owner. The application resolves it; the
	// domain insists on it.
	OwnerTeam string
}

// Raise opens a work order (SRS-FAC-002).
//
// The acceptance is "ticket receives owner/SLA", and both are computed here
// rather than left to be filled in later: an order with no owner is one that
// waits for somebody to notice it, and an order with no deadline is one no
// report can call late.
func Raise(id, tenantID string, in RaiseInput, policy SLAPolicy, by string,
	now time.Time) (WorkOrder, error) {

	target, ok := policy.Target(in.Priority)

	switch {
	case strings.TrimSpace(id) == "":
		return WorkOrder{}, fmt.Errorf("%w: a work order needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Number) == "":
		return WorkOrder{}, fmt.Errorf("%w: a work order needs a number",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Fault) == "":
		return WorkOrder{}, fmt.Errorf("%w: say what is wrong",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Impact) == "":
		// The field that decides priority honestly. Without it every
		// ticket is urgent because every ticket matters to whoever
		// raised it.
		return WorkOrder{}, fmt.Errorf("%w: say what the fault is stopping",
			ErrInvalidFacilities)
	case !knownPriority[in.Priority]:
		return WorkOrder{}, fmt.Errorf("%w: unknown priority %q",
			ErrInvalidFacilities, in.Priority)
	case !knownSystem[in.System]:
		return WorkOrder{}, fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, in.System)
	case strings.TrimSpace(in.LocationID) == "" &&
		strings.TrimSpace(in.LocationNote) == "":
		return WorkOrder{}, fmt.Errorf("%w: say where the fault is",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.OwnerTeam) == "":
		return WorkOrder{}, fmt.Errorf("%w: a work order needs an owner",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return WorkOrder{}, fmt.Errorf("%w: a work order names who raised it",
			ErrInvalidFacilities)
	case !ok:
		return WorkOrder{}, fmt.Errorf("%w: no SLA target for %s",
			ErrInvalidFacilities, in.Priority)
	}
	if err := in.Class.Validate(); err != nil {
		return WorkOrder{}, err
	}
	if !in.Class.Active {
		return WorkOrder{}, fmt.Errorf("%w: work class %q is not in use",
			ErrInvalidFacilities, in.Class.Code)
	}

	raised := now.UTC()
	return WorkOrder{
		ID: id, TenantID: tenantID,
		Number:              strings.ToUpper(strings.TrimSpace(in.Number)),
		FacilityID:          strings.TrimSpace(in.FacilityID),
		AssetID:             strings.TrimSpace(in.AssetID),
		System:              in.System,
		LocationID:          strings.TrimSpace(in.LocationID),
		LocationNote:        strings.TrimSpace(in.LocationNote),
		Fault:               strings.TrimSpace(in.Fault),
		Impact:              strings.TrimSpace(in.Impact),
		Priority:            in.Priority,
		ClassCode:           strings.TrimSpace(in.Class.Code),
		ClassRequiresPermit: in.Class.RequiresPermit,
		ClassRequiresLOTO:   in.Class.RequiresLOTO,
		OwnerTeam:           strings.TrimSpace(in.OwnerTeam),
		State:               WorkRaised,
		RaisedAt:            raised,
		RaisedBy:            by,
		RespondBy: raised.Add(
			time.Duration(target.RespondMinutes) * time.Minute),
		ResolveBy: raised.Add(
			time.Duration(target.ResolveMinutes) * time.Minute),
		CreatedAt: raised, Version: 1,
	}, nil
}

// Assign gives a work order to a person (SRS-FAC-002).
func (w *WorkOrder) Assign(userID, team string, now time.Time) error {
	switch {
	case !w.State.Open():
		return fmt.Errorf("%w: this work order is %s",
			ErrInvalidFacilities, w.State)
	case strings.TrimSpace(userID) == "":
		return fmt.Errorf("%w: name who is taking the work",
			ErrInvalidFacilities)
	}

	w.OwnerUserID = strings.TrimSpace(userID)
	if team = strings.TrimSpace(team); team != "" {
		w.OwnerTeam = team
	}
	if w.RespondedAt.IsZero() {
		// Assignment is the response. A ticket somebody has picked up
		// has been answered, whatever else is still true of it.
		w.RespondedAt = now.UTC()
	}
	if w.State == WorkRaised {
		w.State = WorkAssigned
	}
	return nil
}

// Start begins the work (SRS-FAC-002, SRS-FAC-010).
//
// This is where the permit and the isolation are checked, not at close. The
// paperwork exists to make the work safe, so requiring it at the end would be
// requiring it after it could have helped — and an engineer asked for a permit
// number once the panel is back together will find one.
//
// The database repeats the rule at close as a CHECK, which catches a row that
// reached the closed state by any route this method did not.
func (w *WorkOrder) Start(permitRef, permitBy, lotoRef, lotoBy string,
	now time.Time) error {

	switch {
	case w.State != WorkAssigned && w.State != WorkOnHold:
		return fmt.Errorf("%w: work starts once it is assigned, not %s",
			ErrInvalidFacilities, w.State)
	case w.ClassRequiresPermit && strings.TrimSpace(permitRef) == "":
		return fmt.Errorf(
			"%w: %s work does not start without a permit to work",
			ErrInvalidFacilities, w.ClassCode)
	case w.ClassRequiresPermit && strings.TrimSpace(permitBy) == "":
		// An unsigned permit is a form. Who issued it is the part that
		// makes somebody answerable for the isolation being real.
		return fmt.Errorf("%w: name who issued the permit",
			ErrInvalidFacilities)
	case w.ClassRequiresLOTO && strings.TrimSpace(lotoRef) == "":
		return fmt.Errorf(
			"%w: %s work does not start without a lockout-tagout reference",
			ErrInvalidFacilities, w.ClassCode)
	case w.ClassRequiresLOTO && strings.TrimSpace(lotoBy) == "":
		return fmt.Errorf("%w: name who applied the lock",
			ErrInvalidFacilities)
	case strings.TrimSpace(w.OwnerUserID) == "":
		return fmt.Errorf("%w: nobody has taken this work",
			ErrInvalidFacilities)
	}

	if ref := strings.TrimSpace(permitRef); ref != "" {
		w.PermitRef, w.PermitIssuedBy = ref, strings.TrimSpace(permitBy)
	}
	if ref := strings.TrimSpace(lotoRef); ref != "" {
		w.LOTORef, w.LOTOAppliedBy = ref, strings.TrimSpace(lotoBy)
	}
	w.State = WorkInProgress
	w.HoldReason = ""
	if w.StartedAt.IsZero() {
		w.StartedAt = now.UTC()
	}
	if w.RespondedAt.IsZero() {
		w.RespondedAt = now.UTC()
	}
	return nil
}

// Hold parks a work order on something outside the team's control.
func (w *WorkOrder) Hold(reason string) error {
	switch {
	case w.State != WorkInProgress && w.State != WorkAssigned:
		return fmt.Errorf("%w: cannot hold work that is %s",
			ErrInvalidFacilities, w.State)
	case strings.TrimSpace(reason) == "":
		// An order on hold for no recorded reason is one that never
		// comes off hold, because nobody knows what to chase.
		return fmt.Errorf("%w: say what the work is waiting for",
			ErrInvalidFacilities)
	}
	w.State = WorkOnHold
	w.HoldReason = strings.TrimSpace(reason)
	return nil
}

// Resolve records that the work is done (SRS-FAC-002).
func (w *WorkOrder) Resolve(note, rootCause string, downtimeMinutes int,
	now time.Time) error {

	switch {
	case w.State != WorkInProgress:
		return fmt.Errorf("%w: work is resolved from in_progress, not %s",
			ErrInvalidFacilities, w.State)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: say what was done",
			ErrInvalidFacilities)
	case downtimeMinutes < 0:
		return fmt.Errorf("%w: downtime cannot be negative",
			ErrInvalidFacilities)
	}

	w.State = WorkResolved
	w.CompletionNote = strings.TrimSpace(note)
	w.RootCause = strings.TrimSpace(rootCause)
	w.DowntimeMinutes = downtimeMinutes
	w.ResolvedAt = now.UTC()
	return nil
}

// Close signs off a resolved work order (SRS-FAC-002, SRS-FAC-010).
func (w *WorkOrder) Close(by string, now time.Time) error {
	switch {
	case w.State != WorkResolved:
		return fmt.Errorf("%w: only resolved work closes, not %s",
			ErrInvalidFacilities, w.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who closed the work order",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == strings.TrimSpace(w.OwnerUserID):
		// The engineer who did the work does not also sign off that it
		// was done. One pair of eyes is the arrangement that produces a
		// maintenance history of jobs that were all completed.
		return fmt.Errorf("%w: work is closed by somebody other than %s",
			ErrInvalidFacilities, w.OwnerUserID)
	}

	w.State = WorkClosed
	w.ClosedBy = strings.TrimSpace(by)
	w.ClosedAt = now.UTC()
	return nil
}

// Cancel withdraws a work order that should not have been raised.
func (w *WorkOrder) Cancel(reason, by string, now time.Time) error {
	switch {
	case !w.State.Open():
		return fmt.Errorf("%w: this work order is already %s",
			ErrInvalidFacilities, w.State)
	case w.State == WorkResolved:
		// Work that has been done is closed, not cancelled. Cancelling
		// it would lose the fact that somebody fixed something.
		return fmt.Errorf("%w: resolved work is closed rather than cancelled",
			ErrInvalidFacilities)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the work order is cancelled",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who cancelled the work order",
			ErrInvalidFacilities)
	}
	w.State = WorkCancelled
	w.CancelReason = strings.TrimSpace(reason)
	w.ClosedBy = strings.TrimSpace(by)
	w.ClosedAt = now.UTC()
	return nil
}

// Breach says which SLA targets a work order has missed (SRS-FAC-002).
type Breach struct {
	Response bool
	// Resolution is measured against the resolution the order actually
	// achieved, or against now for work still open.
	Resolution bool
	// ResponseLateMinutes and ResolutionLateMinutes are how far past, for
	// a report that can rank the worst rather than count the late.
	ResponseLateMinutes   int
	ResolutionLateMinutes int
}

// Late reports whether anything was missed.
func (b Breach) Late() bool { return b.Response || b.Resolution }

// Breached measures a work order against its SLA (SRS-FAC-002, SRS-FAC-009).
//
// A cancelled order is measured against nothing: it was withdrawn, and
// counting it as late would make withdrawing tickets a way to look worse.
func (w WorkOrder) Breached(now time.Time) Breach {
	if w.State == WorkCancelled {
		return Breach{}
	}

	var out Breach
	answered := w.RespondedAt
	if answered.IsZero() {
		answered = now
	}
	if !w.RespondBy.IsZero() && answered.After(w.RespondBy) {
		out.Response = true
		out.ResponseLateMinutes = int(
			answered.Sub(w.RespondBy).Round(time.Minute).Minutes())
	}

	fixed := w.ResolvedAt
	if fixed.IsZero() {
		fixed = now
	}
	if !w.ResolveBy.IsZero() && fixed.After(w.ResolveBy) {
		out.Resolution = true
		out.ResolutionLateMinutes = int(
			fixed.Sub(w.ResolveBy).Round(time.Minute).Minutes())
	}
	return out
}

// EscalationKind names the chain a work order escalates on (SRS-FAC-006).
//
// Medical gas and fire have their own chains because the people who answer
// them are different from the people who answer a broken lift, and because
// SRS-FAC-012's matrix is keyed by exactly this.
func EscalationKind(system System) string {
	switch system {
	case SystemMedicalGas:
		return "medical_gas"
	case SystemFire:
		return "fire_safety"
	default:
		return "facilities"
	}
}

// EscalationLevel is the rung a work order starts on (SRS-FAC-006).
//
// The acceptance is that a critical gas issue receives the highest configured
// escalation, and "configured" is the operative word: the level is the top of
// whatever matrix the tenant set up, not a constant. A hospital with a
// three-rung gas chain gets rung three and a hospital with six gets rung six.
//
// Everything else starts at zero and climbs on the platform's timer, which is
// the normal arrangement. Going straight to the top is reserved for the case
// where waiting fifteen minutes to tell the next person is itself the harm.
func EscalationLevel(order WorkOrder, criticality Criticality, top int) int {
	if top < 0 {
		top = 0
	}
	if order.Priority != PriorityEmergency {
		return 0
	}
	if order.System.LifeSafety() && criticality == CriticalityLife {
		return top
	}
	return 0
}

// OpenWork lists open work orders worst first (SRS-FAC-002, SRS-FAC-009).
func OpenWork(orders []WorkOrder, now time.Time) []WorkOrder {
	out := make([]WorkOrder, 0, len(orders))
	for _, order := range orders {
		if order.State.Open() {
			out = append(out, order)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		bi, bj := out[i].Breached(now), out[j].Breached(now)
		if bi.Late() != bj.Late() {
			return bi.Late()
		}
		if out[i].Priority != out[j].Priority {
			return out[i].Priority.rank() < out[j].Priority.rank()
		}
		return out[i].RaisedAt.Before(out[j].RaisedAt)
	})
	return out
}
