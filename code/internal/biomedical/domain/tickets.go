package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Priority is how fast a breakdown is answered (SRS-BIO-005).
type Priority string

const (
	PriorityLow    Priority = "low"
	PriorityNormal Priority = "normal"
	PriorityHigh   Priority = "high"
	// PriorityEmergency is equipment a patient is on now.
	PriorityEmergency Priority = "emergency"
)

var knownPriorities = map[Priority]bool{
	PriorityLow: true, PriorityNormal: true,
	PriorityHigh: true, PriorityEmergency: true,
}

// Impact is what the breakdown stops (SRS-BIO-005).
//
// Recorded separately from priority because they are different facts and a
// hospital learns from the difference: a low-priority ticket that stopped a
// list was triaged wrongly, and only having both makes that visible.
type Impact string

const (
	ImpactNone            Impact = "none"
	ImpactDegraded        Impact = "degraded"
	ImpactServiceStopped  Impact = "service_stopped"
	ImpactPatientAffected Impact = "patient_affected"
)

var knownImpacts = map[Impact]bool{
	ImpactNone: true, ImpactDegraded: true,
	ImpactServiceStopped: true, ImpactPatientAffected: true,
}

// TicketKind is why the engineer is there (SRS-BIO-005, SRS-BIO-007).
//
// The distinction that keeps the reliability figures meaningful. MTBF is the
// mean time between *failures*, and counting a scheduled service as one makes
// a well-maintained machine look unreliable — which is exactly backwards, and
// would be an argument for servicing less.
type TicketKind string

const (
	// KindCorrective is a breakdown: something stopped working.
	KindCorrective TicketKind = "corrective"
	// KindPreventive is planned work against a maintenance plan. Its downtime
	// is real but chosen, and it is not a failure.
	KindPreventive TicketKind = "preventive"
	// KindCalibration is a calibration visit.
	KindCalibration TicketKind = "calibration"
	// KindInspection is a safety notice's inspection or a regulatory check.
	KindInspection TicketKind = "inspection"
)

var knownTicketKinds = map[TicketKind]bool{
	KindCorrective: true, KindPreventive: true,
	KindCalibration: true, KindInspection: true,
}

// Failure reports work that counts against reliability.
//
// Only a breakdown. A machine taken out of service for its annual service was
// not unreliable that day, and a metric that said so would be an argument for
// skipping the service.
func (k TicketKind) Failure() bool { return k == KindCorrective }

// Planned reports work the department chose the timing of.
func (k TicketKind) Planned() bool { return !k.Failure() }

// TicketState is where a service request has got to.
type TicketState string

const (
	TicketOpen       TicketState = "open"
	TicketAssigned   TicketState = "assigned"
	TicketInProgress TicketState = "in_progress"
	// TicketAwaitingParts stops the resolution clock: the wait is the
	// vendor's, and counting it against the engineer's SLA makes every
	// figure a measure of the supply chain instead.
	TicketAwaitingParts TicketState = "awaiting_parts"
	TicketResolved      TicketState = "resolved"
	// TicketClosed is resolved and validated by somebody other than the
	// engineer who fixed it.
	TicketClosed    TicketState = "closed"
	TicketCancelled TicketState = "cancelled"
)

// Open reports a ticket still being worked.
func (s TicketState) Open() bool {
	return s != TicketClosed && s != TicketCancelled
}

// Ticket is a breakdown or service request (SRS-BIO-005, SRS-BIO-006).
type Ticket struct {
	ID       string
	TenantID string

	Number string
	// Kind separates a breakdown from planned work, which is what keeps MTBF
	// a measure of reliability rather than of how often a machine is
	// serviced.
	Kind    TicketKind
	AssetID string
	// PlanID is the maintenance plan this work was raised against, where it
	// was. What PM compliance is counted along: a closed ticket naming no
	// plan is not evidence that a plan was followed.
	PlanID string
	// AssetTag is carried so a closed ticket still names the machine after the
	// asset record is re-tagged or moved.
	AssetTag   string
	LocationID string

	Symptom  string
	Priority Priority
	Impact   Impact

	State TicketState
	// OwnerID is the engineer it is assigned to. SRS-BIO-005's acceptance is
	// that a ticket receives an SLA and an owner.
	OwnerID string

	// RespondBy and ResolveBy come from the asset's live contract where there
	// is one, and from the deployment's defaults where there is not. Frozen on
	// the ticket, because the contract may lapse before the ticket closes and
	// the promise that applied is the one it was raised under.
	RespondBy time.Time
	ResolveBy time.Time
	// ContractID is which agreement set them, so an SLA breach can be taken to
	// the right vendor.
	ContractID string

	// Diagnosis, WorkPerformed and Parts are the maintenance history
	// SRS-BIO-006 requires be retained.
	Diagnosis     string
	WorkPerformed string
	Parts         []PartUsed

	// DownFrom and DownUntil bound the outage. Separate from the ticket's own
	// timestamps because a machine can be reported on Monday and have failed
	// on Friday, and uptime is measured from when it stopped working rather
	// than from when somebody noticed.
	DownFrom  time.Time
	DownUntil time.Time

	// AwaitingPartsMinutes accumulates the time the resolution clock was
	// stopped.
	AwaitingPartsMinutes int
	awaitingSince        time.Time

	RespondedAt time.Time
	ResolvedAt  time.Time
	// ClosedBy is the validation SRS-BIO-006 asks for, and it is never the
	// engineer who did the work: a repair signed off by the person who made it
	// is not a validated repair.
	ClosedAt        time.Time
	ClosedBy        string
	ClosureNote     string
	CancelledReason string

	RaisedAt time.Time
	RaisedBy string
	Version  int64
}

// PartUsed is one component fitted during a repair (SRS-BIO-006).
type PartUsed struct {
	// Code and Description identify it. The materials item id where the part
	// came from stock, so the two ledgers can be reconciled.
	Code            string
	Description     string
	MaterialsItemID string
	Quantity        int
	// CostMinor is what it cost, zero where the contract covered it.
	CostMinor int64
	// CoveredByContract records that somebody else paid, which is the number a
	// contract renewal is argued with.
	CoveredByContract bool
}

// SLA is what a ticket promises (SRS-BIO-005).
type SLA struct {
	ResponseHours   int
	ResolutionHours int
	ContractID      string
}

// SLAFor derives a ticket's clock from the asset's cover and the priority
// (SRS-BIO-005).
//
// The contract's hours where there is one, because that is the promise the
// hospital actually bought and the one an SLA breach is argued with. Priority
// only tightens it: an emergency on a machine with a next-business-day
// contract is still an emergency to the hospital, whatever the vendor agreed.
func SLAFor(contracts []ServiceContract, assetID string, priority Priority,
	defaults SLA, now time.Time) SLA {

	out := defaults
	if contract, found := CoverFor(contracts, assetID, now); found {
		out.ContractID = contract.ID
		if contract.ResponseHours > 0 {
			out.ResponseHours = contract.ResponseHours
		}
		if contract.ResolutionHours > 0 {
			out.ResolutionHours = contract.ResolutionHours
		}
	}

	cap := priorityCap(priority)
	if cap.ResponseHours > 0 &&
		(out.ResponseHours == 0 || out.ResponseHours > cap.ResponseHours) {
		out.ResponseHours = cap.ResponseHours
	}
	if cap.ResolutionHours > 0 &&
		(out.ResolutionHours == 0 || out.ResolutionHours > cap.ResolutionHours) {
		out.ResolutionHours = cap.ResolutionHours
	}
	return out
}

// priorityCap is the longest a priority may promise, whatever a contract says.
func priorityCap(p Priority) SLA {
	switch p {
	case PriorityEmergency:
		return SLA{ResponseHours: 1, ResolutionHours: 4}
	case PriorityHigh:
		return SLA{ResponseHours: 4, ResolutionHours: 24}
	default:
		return SLA{}
	}
}

// NewTicketInput raises a breakdown or service request.
type NewTicketInput struct {
	Number   string
	Kind     TicketKind
	AssetID  string
	PlanID   string
	Symptom  string
	Priority Priority
	Impact   Impact
	// DownFrom is when the machine actually stopped, where the reporter knows.
	// Empty takes the moment the ticket was raised, which is the later of the
	// two and therefore the one that understates downtime rather than
	// inventing it.
	DownFrom time.Time
}

// RaiseTicket raises a breakdown or service request (SRS-BIO-005).
//
// Refused against a disposed asset: SRS-BIO-011's clause is that a disposed
// asset cannot be assigned for use, and a work order is an assignment. It is
// deliberately allowed against a decommissioned one, because the last thing
// that happens to a condemned machine is often a final safety check.
func RaiseTicket(id, tenantID string, in NewTicketInput, asset Asset,
	sla SLA, by string, now time.Time) (Ticket, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Ticket{}, fmt.Errorf("%w: a ticket needs an id", ErrInvalidAsset)
	case strings.TrimSpace(in.Symptom) == "":
		// An engineer reading "broken" arrives without the part.
		return Ticket{}, fmt.Errorf("%w: a ticket says what is wrong",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return Ticket{}, fmt.Errorf("%w: a ticket names who raised it",
			ErrInvalidAsset)
	case asset.Status == AssetDisposed:
		return Ticket{}, fmt.Errorf(
			"%w: %s has been disposed of", ErrInvalidAsset, asset.Tag)
	}

	kind := in.Kind
	if kind == "" {
		// Corrective, because that is what somebody raising a ticket by hand
		// almost always means, and because defaulting the other way would
		// quietly drop breakdowns out of the failure count.
		kind = KindCorrective
	}
	if !knownTicketKinds[kind] {
		return Ticket{}, fmt.Errorf("%w: unknown ticket kind %q",
			ErrInvalidAsset, kind)
	}
	if kind == KindPreventive && strings.TrimSpace(in.PlanID) == "" {
		// Planned work naming no plan cannot be counted towards compliance
		// with one, and PM compliance would become whatever anybody happened
		// to label preventive.
		return Ticket{}, fmt.Errorf(
			"%w: preventive work names the plan it is against", ErrInvalidAsset)
	}

	priority := in.Priority
	if priority == "" {
		priority = PriorityNormal
	}
	if !knownPriorities[priority] {
		return Ticket{}, fmt.Errorf("%w: unknown priority %q",
			ErrInvalidAsset, priority)
	}

	impact := in.Impact
	if impact == "" {
		impact = ImpactNone
	}
	if !knownImpacts[impact] {
		return Ticket{}, fmt.Errorf("%w: unknown impact %q",
			ErrInvalidAsset, impact)
	}

	down := in.DownFrom
	if down.IsZero() {
		down = now
	}
	if down.After(now) {
		return Ticket{}, fmt.Errorf("%w: a machine did not stop in the future",
			ErrInvalidAsset)
	}

	out := Ticket{
		ID: id, TenantID: tenantID,
		Number: strings.TrimSpace(in.Number), Kind: kind,
		PlanID: strings.TrimSpace(in.PlanID), AssetID: asset.ID,
		AssetTag: asset.Tag, LocationID: asset.LocationID,
		Symptom:  strings.TrimSpace(in.Symptom),
		Priority: priority, Impact: impact,
		State: TicketOpen, ContractID: sla.ContractID,
		DownFrom: down.UTC(),
		RaisedAt: now.UTC(), RaisedBy: strings.TrimSpace(by),
		Version: 1,
	}
	if sla.ResponseHours > 0 {
		out.RespondBy = now.Add(time.Duration(sla.ResponseHours) * time.Hour).UTC()
	}
	if sla.ResolutionHours > 0 {
		out.ResolveBy = now.Add(time.Duration(sla.ResolutionHours) * time.Hour).UTC()
	}
	return out, nil
}

// Assign gives a ticket an owner (SRS-BIO-005).
func (t *Ticket) Assign(ownerID string, now time.Time) error {
	switch {
	case !t.State.Open():
		return fmt.Errorf("%w: this ticket is %s", ErrInvalidAsset, t.State)
	case strings.TrimSpace(ownerID) == "":
		return fmt.Errorf("%w: an assignment names an owner", ErrInvalidAsset)
	}
	t.OwnerID = strings.TrimSpace(ownerID)
	if t.State == TicketOpen {
		t.State = TicketAssigned
	}
	if t.RespondedAt.IsZero() {
		// Assignment is the response: somebody has picked it up. Recording it
		// here rather than as a separate act means the response clock cannot
		// be satisfied by a step nobody performs.
		t.RespondedAt = now.UTC()
	}
	return nil
}

// Start marks work begun.
func (t *Ticket) Start(now time.Time) error {
	switch {
	case !t.State.Open():
		return fmt.Errorf("%w: this ticket is %s", ErrInvalidAsset, t.State)
	case t.OwnerID == "":
		return fmt.Errorf("%w: assign this ticket before starting work on it",
			ErrInvalidAsset)
	}
	if t.State == TicketAwaitingParts {
		t.stopAwaiting(now)
	}
	t.State = TicketInProgress
	if t.RespondedAt.IsZero() {
		t.RespondedAt = now.UTC()
	}
	return nil
}

// AwaitParts stops the resolution clock (SRS-BIO-007).
//
// Because the wait is the vendor's. Counting it against the engineer makes
// MTTR a measure of the supply chain, and a department that is judged on it
// learns to leave tickets open rather than order the part.
func (t *Ticket) AwaitParts(note string, now time.Time) error {
	switch {
	case !t.State.Open():
		return fmt.Errorf("%w: this ticket is %s", ErrInvalidAsset, t.State)
	case t.State == TicketAwaitingParts:
		return fmt.Errorf("%w: this ticket is already awaiting parts",
			ErrInvalidAsset)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: say what is on order", ErrInvalidAsset)
	}
	t.State = TicketAwaitingParts
	t.awaitingSince = now.UTC()
	t.WorkPerformed = appendLine(t.WorkPerformed, "awaiting parts: "+note)
	return nil
}

func (t *Ticket) stopAwaiting(now time.Time) {
	if t.awaitingSince.IsZero() {
		return
	}
	t.AwaitingPartsMinutes += int(now.Sub(t.awaitingSince).Minutes())
	t.awaitingSince = time.Time{}
}

// ResolveInput records what was found and done (SRS-BIO-006).
type ResolveInput struct {
	Diagnosis     string
	WorkPerformed string
	Parts         []PartUsed
	// BackInServiceAt is when the machine worked again. Empty takes the moment
	// of resolution.
	BackInServiceAt time.Time
}

// Resolve records the repair (SRS-BIO-006).
func (t *Ticket) Resolve(in ResolveInput, by string, now time.Time) error {
	switch {
	case !t.State.Open():
		return fmt.Errorf("%w: this ticket is %s", ErrInvalidAsset, t.State)
	case strings.TrimSpace(in.Diagnosis) == "":
		// What was wrong. Without it the history says a machine was fixed
		// four times and nothing about whether it is the same fault.
		return fmt.Errorf("%w: a resolution records the diagnosis",
			ErrInvalidAsset)
	case strings.TrimSpace(in.WorkPerformed) == "":
		return fmt.Errorf("%w: a resolution records what was done",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a resolution names who did the work",
			ErrInvalidAsset)
	}

	back := in.BackInServiceAt
	if back.IsZero() {
		back = now
	}
	if back.Before(t.DownFrom) {
		return fmt.Errorf(
			"%w: a machine cannot come back before it stopped", ErrInvalidAsset)
	}

	parts, err := checkedParts(in.Parts)
	if err != nil {
		return err
	}

	t.stopAwaiting(now)
	t.Diagnosis = strings.TrimSpace(in.Diagnosis)
	t.WorkPerformed = appendLine(t.WorkPerformed, strings.TrimSpace(in.WorkPerformed))
	t.Parts = parts
	t.DownUntil = back.UTC()
	t.State, t.ResolvedAt = TicketResolved, now.UTC()
	if t.OwnerID == "" {
		t.OwnerID = strings.TrimSpace(by)
	}
	if t.RespondedAt.IsZero() {
		t.RespondedAt = now.UTC()
	}
	return nil
}

func checkedParts(in []PartUsed) ([]PartUsed, error) {
	out := make([]PartUsed, 0, len(in))
	for _, part := range in {
		code := strings.TrimSpace(part.Code)
		switch {
		case code == "" && strings.TrimSpace(part.Description) == "":
			return nil, fmt.Errorf("%w: a part is named or described",
				ErrInvalidAsset)
		case part.Quantity <= 0:
			return nil, fmt.Errorf("%w: a part is fitted in a quantity",
				ErrInvalidAsset)
		case part.CostMinor < 0:
			return nil, fmt.Errorf("%w: a part cost is not negative",
				ErrInvalidAsset)
		case part.CoveredByContract && part.CostMinor > 0:
			// A part the contract covered and the hospital paid for is one of
			// the two, and the difference is what a renewal is argued with.
			return nil, fmt.Errorf(
				"%w: %s is marked as covered by contract and also costed",
				ErrInvalidAsset, code)
		}
		out = append(out, PartUsed{
			Code: code, Description: strings.TrimSpace(part.Description),
			MaterialsItemID: strings.TrimSpace(part.MaterialsItemID),
			Quantity:        part.Quantity, CostMinor: part.CostMinor,
			CoveredByContract: part.CoveredByContract,
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Code < out[j].Code })
	return out, nil
}

// Close validates a repair (SRS-BIO-006).
//
// The validator is never the engineer who did the work. SRS-BIO-006's
// acceptance is "closure validation", and a repair signed off by the person
// who made it is not validated — it is the same claim twice.
func (t *Ticket) Close(by, note string, now time.Time) error {
	switch {
	case t.State != TicketResolved:
		return fmt.Errorf("%w: this ticket is %s, not resolved",
			ErrInvalidAsset, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who validated it", ErrInvalidAsset)
	case strings.TrimSpace(by) == t.OwnerID:
		return fmt.Errorf(
			"%w: the engineer who did the work does not validate it",
			ErrInvalidAsset)
	}
	t.State, t.ClosedAt = TicketClosed, now.UTC()
	t.ClosedBy, t.ClosureNote = strings.TrimSpace(by), strings.TrimSpace(note)
	return nil
}

// Cancel ends a ticket without a repair.
func (t *Ticket) Cancel(reason string, now time.Time) error {
	switch {
	case !t.State.Open():
		return fmt.Errorf("%w: this ticket is %s", ErrInvalidAsset, t.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: a cancelled ticket says why", ErrInvalidAsset)
	}
	t.State, t.ClosedAt = TicketCancelled, now.UTC()
	t.CancelledReason = strings.TrimSpace(reason)
	// A cancelled ticket records no downtime: nothing was wrong, or nothing
	// was done, and counting it would make uptime a measure of how often
	// somebody mis-reported a machine.
	t.DownFrom, t.DownUntil = time.Time{}, time.Time{}
	return nil
}

// Breached reports a ticket past its promise (SRS-BIO-005).
//
// Two clocks, reported separately: a ticket answered in ten minutes and fixed
// in a week has met one promise and broken the other, and a single flag would
// lose which.
func (t Ticket) Breached(now time.Time) (response, resolution bool) {
	if !t.RespondBy.IsZero() {
		if t.RespondedAt.IsZero() {
			response = now.After(t.RespondBy)
		} else {
			response = t.RespondedAt.After(t.RespondBy)
		}
	}
	if !t.ResolveBy.IsZero() {
		// The parts wait is added back, because it stopped the clock.
		allowance := t.ResolveBy.Add(
			time.Duration(t.AwaitingPartsMinutes) * time.Minute)
		if t.ResolvedAt.IsZero() {
			resolution = now.After(allowance)
		} else {
			resolution = t.ResolvedAt.After(allowance)
		}
	}
	return response, resolution
}

// DowntimeMinutes is how long the machine was out (SRS-BIO-007).
//
// Measured from when it stopped to when it worked again, not from the ticket's
// own timestamps: a machine that failed on Friday and was reported on Monday
// was out for three days, and a metric that said otherwise would reward late
// reporting.
func (t Ticket) DowntimeMinutes(now time.Time) int {
	if t.DownFrom.IsZero() {
		return 0
	}
	until := t.DownUntil
	if until.IsZero() {
		if !t.State.Open() {
			return 0
		}
		until = now
	}
	minutes := int(until.Sub(t.DownFrom).Minutes())
	if minutes < 0 {
		return 0
	}
	return minutes
}

func appendLine(existing, line string) string {
	if line == "" {
		return existing
	}
	if existing == "" {
		return line
	}
	return existing + "\n" + line
}
