// Package domain holds the perioperative rules (SRS-OT-001 … 017).
//
// No infrastructure: the rules here are the ones a theatre manager would
// recognise as theirs, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidCase refuses a theatre record that could not be true.
var ErrInvalidCase = errors.New("theatre: invalid")

// Room is a theatre and what it can take (SRS-OT-001).
type Room struct {
	ID         string
	TenantID   string
	FacilityID string
	Code       string
	Name       string
	// Specialties the room is equipped for. Empty means any: a hospital with
	// one theatre should not have to enumerate every specialty it does.
	Specialties []string
	// Equipment the room has fitted — an image intensifier, a laminar flow
	// canopy. What a case's requirements are matched against.
	Equipment []string
	Active    bool
}

// EquipmentStatus is what the machines standing in a room can actually do
// right now (SRS-BIO-009).
//
// Separate from Room.Equipment, which is what the room is meant to have. The
// two disagree the moment an image intensifier goes for service, and the
// requirement's acceptance is precisely that the disagreement is visible:
// unavailable equipment must not be shown as schedulable.
type EquipmentStatus struct {
	// Working counts the working units per capability. Counted rather than
	// flagged, because a theatre with two intensifiers loses nothing when one
	// goes for service.
	Working map[string]int
	// Down explains, per capability the room has and cannot deliver, why. A
	// scheduler told "this room has no image intensifier" about a room with
	// one bolted to the floor will assume the system is wrong; told "its
	// image intensifier is awaiting parts" they will go and find another
	// room.
	Down map[string]string
}

// Suits reports whether a room can take a case's specialty and equipment.
//
// status is what the room's machines can do right now, or nil where no
// equipment register is wired. Nil trusts the room's fitted list, which is
// the behaviour a deployment without SRS-BIO has and the one it had before
// the register existed — it is a narrower answer, not a wrong one, and the
// status document names it rather than this code pretending otherwise.
func (r Room) Suits(specialty string, equipment []string,
	status *EquipmentStatus) ([]string, bool) {

	if !r.Active {
		return []string{"room is not in service"}, false
	}
	var missing []string
	if specialty != "" && len(r.Specialties) > 0 && !contains(r.Specialties, specialty) {
		missing = append(missing, "specialty "+specialty)
	}
	for _, needed := range equipment {
		if !contains(r.Equipment, needed) {
			missing = append(missing, needed)
			continue
		}
		if status == nil {
			continue
		}
		// Fitted, and the register says none of it is working. Reported with
		// the reason where the register gave one, because "no image
		// intensifier" about a room that visibly has one reads as a bug.
		if workingUnits(status.Working, needed) > 0 {
			continue
		}
		if reason := lookup(status.Down, needed); reason != "" {
			missing = append(missing, needed+" in service ("+reason+")")
			continue
		}
		missing = append(missing, needed+" in service")
	}
	return missing, len(missing) == 0
}

// workingUnits looks a capability up without caring about case, because the
// room's fitted list and the equipment register are maintained by different
// departments and one of them will capitalise differently.
func workingUnits(working map[string]int, capability string) int {
	if count, found := working[capability]; found {
		return count
	}
	for name, count := range working {
		if strings.EqualFold(name, capability) {
			return count
		}
	}
	return 0
}

func lookup(reasons map[string]string, capability string) string {
	if reason, found := reasons[capability]; found {
		return reason
	}
	for name, reason := range reasons {
		if strings.EqualFold(name, capability) {
			return reason
		}
	}
	return ""
}

func contains(haystack []string, needle string) bool {
	for _, value := range haystack {
		if strings.EqualFold(value, needle) {
			return true
		}
	}
	return false
}

// BlockKind is what a stretch of theatre time is for.
type BlockKind string

const (
	// BlockList is a surgeon's or specialty's allocated list.
	BlockList BlockKind = "list"
	// BlockDowntime is planned closure — maintenance, deep clean, a fumigation
	// day. Distinct from an unallocated gap, because a room that is closed is
	// not a room somebody can be persuaded to open (SRS-OT-001).
	BlockDowntime BlockKind = "downtime"
	// BlockEmergency is a room deliberately kept free.
	BlockEmergency BlockKind = "emergency"
)

// Block is a stretch of theatre time (SRS-OT-001).
type Block struct {
	ID       string
	TenantID string
	RoomID   string
	Kind     BlockKind
	// OwnerID is the surgeon or specialty the list belongs to, where it is a
	// list.
	OwnerID   string
	Specialty string
	StartsAt  time.Time
	EndsAt    time.Time
	Note      string
}

// Covers reports whether the block contains an instant.
func (b Block) Covers(at time.Time) bool {
	return !at.Before(b.StartsAt) && at.Before(b.EndsAt)
}

// Overlaps reports whether two intervals share any time.
//
// Half-open on both sides, so a case ending exactly when the next begins does
// not conflict — which is the ordinary way a list is built, and treating it as
// a clash would make every list unschedulable.
func Overlaps(aStart, aEnd, bStart, bEnd time.Time) bool {
	return aStart.Before(bEnd) && bStart.Before(aEnd)
}

// Urgency is how soon the case has to happen (SRS-OT-003).
type Urgency string

const (
	UrgencyUnspecified Urgency = ""
	UrgencyElective    Urgency = "elective"
	UrgencyUrgent      Urgency = "urgent"
	UrgencyEmergency   Urgency = "emergency"
)

var knownUrgencies = map[Urgency]bool{
	UrgencyElective: true, UrgencyUrgent: true, UrgencyEmergency: true,
}

// Rank orders urgencies, most urgent first.
func (u Urgency) Rank() int {
	switch u {
	case UrgencyEmergency:
		return 0
	case UrgencyUrgent:
		return 1
	default:
		return 2
	}
}

// Laterality is which side (SRS-OT-002).
//
// Its own field rather than free text in the procedure name, because wrong-site
// surgery is the never-event the whole pre-operative checklist exists to
// prevent, and "left" buried in a sentence is not something a system can check.
type Laterality string

const (
	LateralityNotApplicable Laterality = "not_applicable"
	LateralityLeft          Laterality = "left"
	LateralityRight         Laterality = "right"
	LateralityBilateral     Laterality = "bilateral"
	// LateralityUnspecified is the refusal state: a procedure that has sides
	// and has not said which.
	LateralityUnspecified Laterality = ""
)

// CaseStatus is where the case is (SRS-OT-002, SRS-OT-005).
type CaseStatus string

const (
	// CaseRequested is a surgery request that is not yet schedulable.
	CaseRequested CaseStatus = "requested"
	// CaseSchedulable has every required field and is waiting for a slot.
	CaseSchedulable CaseStatus = "schedulable"
	CaseScheduled   CaseStatus = "scheduled"
	// CaseReady has passed the pre-operative checklist (SRS-OT-006).
	CaseReady     CaseStatus = "ready"
	CaseInTheatre CaseStatus = "in_theatre"
	CaseCompleted CaseStatus = "completed"
	CasePostponed CaseStatus = "postponed"
	CaseCancelled CaseStatus = "cancelled"
)

// Open reports whether the case is still going to happen.
func (s CaseStatus) Open() bool {
	switch s {
	case CaseCompleted, CaseCancelled:
		return false
	default:
		return true
	}
}

// Case is one planned or performed operation.
type Case struct {
	ID       string
	TenantID string

	// EncounterID is the Wave-1 encounter. The patient, the allergies and the
	// admission belong to it; a theatre system with its own patient record is
	// one whose consent disagrees with the ward's.
	EncounterID string
	PatientID   string
	FacilityID  string

	// ProcedureCode and ProcedureDisplay are the deployment's terminology.
	ProcedureCode    string
	ProcedureDisplay string
	DiagnosisCode    string
	DiagnosisDisplay string

	Laterality Laterality
	// Site is the anatomical site in words, beside the laterality. Both,
	// because "left" is checkable and "medial third of the clavicle" is what
	// the surgeon marks.
	Site string

	Urgency Urgency
	// ExpectedDuration is what the list is built from. A case with none cannot
	// be scheduled without guessing, and a guessed list overruns.
	ExpectedDuration time.Duration

	SurgeonID string
	// Team is everyone else expected — assistant, scrub nurse, perfusionist.
	Team []string
	// Requirements are the equipment and services the case needs. Matched
	// against the room (SRS-OT-004).
	Requirements []string
	// AnaesthesiaType is what was planned. The anaesthesia context owns the
	// detail; this is what the scheduler needs to book a session.
	AnaesthesiaType string
	SpecialNotes    string

	Status CaseStatus
	// RoomID, ScheduledStart and ScheduledEnd are set once booked.
	RoomID         string
	ScheduledStart time.Time
	ScheduledEnd   time.Time

	// PostponeReason and CancelReason classify why, in coded form
	// (SRS-OT-005).
	Outcome       CaseOutcome
	OutcomeReason string
	OutcomeNote   string
	OutcomeAt     time.Time

	RequestedBy string
	RequestedAt time.Time
	UpdatedAt   time.Time
	Version     int64
}

// CaseOutcome classifies a postponement or cancellation (SRS-OT-005).
//
// Coded rather than free text, because the requirement's clause is
// "cancellation analytics distinguish patient/clinical/resource/administrative
// causes" — and a free-text field produces a report nobody can act on: the
// hospital that cancels for want of a bed and the one that cancels because
// patients do not attend need different fixes.
type CaseOutcome string

const (
	OutcomeNone CaseOutcome = ""
	// OutcomePatient is the patient: did not attend, not fasted, unwell,
	// declined.
	OutcomePatient CaseOutcome = "patient"
	// OutcomeClinical is a clinical decision: condition changed, needs further
	// investigation, no longer indicated.
	OutcomeClinical CaseOutcome = "clinical"
	// OutcomeResource is the hospital's capacity: no bed, no equipment, no
	// staff, list overran.
	OutcomeResource CaseOutcome = "resource"
	// OutcomeAdministrative is everything else the hospital did: booked in
	// error, consent not obtained, notes missing.
	OutcomeAdministrative CaseOutcome = "administrative"
)

var knownOutcomes = map[CaseOutcome]bool{
	OutcomePatient: true, OutcomeClinical: true,
	OutcomeResource: true, OutcomeAdministrative: true,
}

// NewCaseInput is a surgery request (SRS-OT-002).
type NewCaseInput struct {
	EncounterID      string
	PatientID        string
	FacilityID       string
	ProcedureCode    string
	ProcedureDisplay string
	DiagnosisCode    string
	DiagnosisDisplay string
	Laterality       Laterality
	Site             string
	Urgency          Urgency
	ExpectedDuration time.Duration
	SurgeonID        string
	Team             []string
	Requirements     []string
	AnaesthesiaType  string
	SpecialNotes     string
	// SideRequired says whether this procedure has sides. Passed in because it
	// is a fact about the procedure code, which the deployment's terminology
	// owns.
	SideRequired bool
}

// NewCase raises a surgery request (SRS-OT-002).
//
// The requirement's clause is "request enters schedulable state only after
// required fields", so this always succeeds where the request is coherent and
// the status reflects how complete it is. A request refused outright for a
// missing expected duration would be a surgeon unable to put a patient on a
// list at all.
func NewCase(id, tenantID string, in NewCaseInput, requestedBy string,
	now time.Time) (Case, []string, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Case{}, nil, fmt.Errorf("%w: a case needs an id", ErrInvalidCase)
	case strings.TrimSpace(in.EncounterID) == "":
		return Case{}, nil, fmt.Errorf(
			"%w: a case is the theatre detail of an encounter", ErrInvalidCase)
	case strings.TrimSpace(in.PatientID) == "":
		return Case{}, nil, fmt.Errorf("%w: a case names a patient", ErrInvalidCase)
	case strings.TrimSpace(in.ProcedureCode) == "":
		return Case{}, nil, fmt.Errorf("%w: a case names a procedure", ErrInvalidCase)
	case strings.TrimSpace(requestedBy) == "":
		return Case{}, nil, fmt.Errorf("%w: a request names who made it", ErrInvalidCase)
	}

	urgency := in.Urgency
	if urgency == UrgencyUnspecified {
		urgency = UrgencyElective
	}
	if !knownUrgencies[urgency] {
		return Case{}, nil, fmt.Errorf("%w: unknown urgency %q", ErrInvalidCase, urgency)
	}

	laterality := in.Laterality
	if !in.SideRequired && laterality == LateralityUnspecified {
		laterality = LateralityNotApplicable
	}

	c := Case{
		ID: id, TenantID: tenantID,
		EncounterID:      strings.TrimSpace(in.EncounterID),
		PatientID:        strings.TrimSpace(in.PatientID),
		FacilityID:       strings.TrimSpace(in.FacilityID),
		ProcedureCode:    strings.TrimSpace(in.ProcedureCode),
		ProcedureDisplay: strings.TrimSpace(in.ProcedureDisplay),
		DiagnosisCode:    strings.TrimSpace(in.DiagnosisCode),
		DiagnosisDisplay: strings.TrimSpace(in.DiagnosisDisplay),
		Laterality:       laterality,
		Site:             strings.TrimSpace(in.Site),
		Urgency:          urgency,
		ExpectedDuration: in.ExpectedDuration,
		SurgeonID:        strings.TrimSpace(in.SurgeonID),
		Team:             trimmedAll(in.Team),
		Requirements:     trimmedAll(in.Requirements),
		AnaesthesiaType:  strings.TrimSpace(in.AnaesthesiaType),
		SpecialNotes:     strings.TrimSpace(in.SpecialNotes),
		RequestedBy:      strings.TrimSpace(requestedBy),
		RequestedAt:      now.UTC(),
		UpdatedAt:        now.UTC(),
		Version:          1,
	}

	outstanding := c.Outstanding(in.SideRequired)
	if len(outstanding) == 0 {
		c.Status = CaseSchedulable
	} else {
		c.Status = CaseRequested
	}
	return c, outstanding, nil
}

// Outstanding names the fields a request still needs to be schedulable
// (SRS-OT-002).
func (c Case) Outstanding(sideRequired bool) []string {
	var missing []string
	if c.SurgeonID == "" {
		missing = append(missing, "surgeon")
	}
	if c.ExpectedDuration <= 0 {
		// A list built from guessed durations overruns, and an overrunning
		// list cancels the case at the end of it.
		missing = append(missing, "expected duration")
	}
	if c.DiagnosisCode == "" {
		missing = append(missing, "diagnosis")
	}
	if sideRequired && (c.Laterality == LateralityUnspecified ||
		c.Laterality == LateralityNotApplicable) {
		// Wrong-site surgery is the never-event the whole checklist exists to
		// prevent, and it starts here.
		missing = append(missing, "laterality")
	}
	sort.Strings(missing)
	return missing
}

func trimmedAll(in []string) []string {
	out := make([]string, 0, len(in))
	for _, value := range in {
		if trimmed := strings.TrimSpace(value); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// Complete fills in a request's missing fields.
func (c *Case) Complete(in NewCaseInput, sideRequired bool, at time.Time) error {
	if !c.Status.Open() {
		return fmt.Errorf("%w: this case is closed", ErrInvalidCase)
	}
	if c.Status != CaseRequested && c.Status != CaseSchedulable {
		return fmt.Errorf("%w: this case is already scheduled", ErrInvalidCase)
	}

	if surgeon := strings.TrimSpace(in.SurgeonID); surgeon != "" {
		c.SurgeonID = surgeon
	}
	if in.ExpectedDuration > 0 {
		c.ExpectedDuration = in.ExpectedDuration
	}
	if code := strings.TrimSpace(in.DiagnosisCode); code != "" {
		c.DiagnosisCode, c.DiagnosisDisplay = code,
			strings.TrimSpace(in.DiagnosisDisplay)
	}
	if in.Laterality != LateralityUnspecified {
		c.Laterality = in.Laterality
	}
	if site := strings.TrimSpace(in.Site); site != "" {
		c.Site = site
	}
	if len(in.Requirements) > 0 {
		c.Requirements = trimmedAll(in.Requirements)
	}
	if len(in.Team) > 0 {
		c.Team = trimmedAll(in.Team)
	}

	c.UpdatedAt = at.UTC()
	if len(c.Outstanding(sideRequired)) == 0 {
		c.Status = CaseSchedulable
	} else {
		c.Status = CaseRequested
	}
	return nil
}

// Reprioritise changes a case's urgency (SRS-OT-003).
//
// The reason is required in both directions. Moving a case up is the decision
// somebody asks about afterwards, and moving one down is the decision the
// patient asks about — a system that demanded a reason only for upgrades would
// leave the harder one unexplained.
func (c *Case) Reprioritise(urgency Urgency, reason string, at time.Time) error {
	switch {
	case !c.Status.Open():
		return fmt.Errorf("%w: this case is closed", ErrInvalidCase)
	case !knownUrgencies[urgency]:
		return fmt.Errorf("%w: unknown urgency %q", ErrInvalidCase, urgency)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: changing a case's priority needs a reason",
			ErrInvalidCase)
	case urgency == c.Urgency:
		return fmt.Errorf("%w: this case is already %s", ErrInvalidCase, urgency)
	}
	c.Urgency, c.UpdatedAt = urgency, at.UTC()
	return nil
}

// ScheduleConflict is one reason a case cannot go in a slot (SRS-OT-004).
type ScheduleConflict struct {
	Kind   string
	Detail string
	// Overridable marks a soft constraint. A hard one — the room is closed,
	// another case is in it — is never overridable, because overriding it
	// does not make a second theatre appear.
	Overridable bool
}

// Explain says what the conflict is.
func (c ScheduleConflict) Explain() string { return c.Kind + ": " + c.Detail }

// ScheduleRequest is a proposed booking.
type ScheduleRequest struct {
	RoomID string
	Start  time.Time
	End    time.Time
}

// SchedulingContext is what the slot is checked against.
type SchedulingContext struct {
	Room Room
	// Booked is what is already in the room. Every case, not just the
	// confirmed ones: a room double-booked with a case somebody is about to
	// confirm is still double-booked.
	Booked []Case
	// Blocks are the room's list and downtime blocks.
	Blocks []Block
	// SurgeonBusy is the surgeon's other bookings, anywhere. A surgeon in two
	// theatres at once is the conflict a room-only check misses.
	SurgeonBusy []Case

	// Equipment is what the room's machines can actually do right now
	// (SRS-BIO-009), or nil where no equipment register is wired. Read rather
	// than stored on the Room: a room's fitted list is a fact about the
	// building, and what is working is a fact about this minute.
	Equipment *EquipmentStatus
}

// CheckSlot reports every reason a case cannot go in a slot (SRS-OT-004).
//
// All of them at once, for the reason every other gate in this system returns
// all its refusals: a scheduler told one clash at a time rebooks once per
// clash while a list is being built.
func (c Case) CheckSlot(req ScheduleRequest, ctx SchedulingContext,
	now time.Time) []ScheduleConflict {

	var conflicts []ScheduleConflict

	if !req.End.After(req.Start) {
		conflicts = append(conflicts, ScheduleConflict{
			Kind: "slot", Detail: "the slot ends before it starts",
		})
		return conflicts
	}

	if missing, ok := ctx.Room.Suits(specialtyOf(c), c.Requirements,
		ctx.Equipment); !ok {
		for _, item := range missing {
			conflicts = append(conflicts, ScheduleConflict{
				Kind: "room", Detail: "this room has no " + item,
				// A missing image intensifier is overridable because a
				// hospital can wheel one in; a closed room is not.
				Overridable: item != "room is not in service",
			})
		}
	}

	for _, booked := range ctx.Booked {
		if booked.ID == c.ID || !booked.Status.Open() {
			continue
		}
		if Overlaps(req.Start, req.End, booked.ScheduledStart, booked.ScheduledEnd) {
			conflicts = append(conflicts, ScheduleConflict{
				Kind: "room", Detail: "another case is in this room then",
			})
		}
	}

	for _, busy := range ctx.SurgeonBusy {
		if busy.ID == c.ID || !busy.Status.Open() || busy.SurgeonID != c.SurgeonID {
			continue
		}
		if Overlaps(req.Start, req.End, busy.ScheduledStart, busy.ScheduledEnd) {
			conflicts = append(conflicts, ScheduleConflict{
				Kind: "surgeon", Detail: "this surgeon is operating elsewhere then",
			})
		}
	}

	for _, block := range ctx.Blocks {
		if block.RoomID != req.RoomID {
			continue
		}
		if block.Kind == BlockDowntime &&
			Overlaps(req.Start, req.End, block.StartsAt, block.EndsAt) {
			conflicts = append(conflicts, ScheduleConflict{
				Kind: "room", Detail: "the room is closed then: " + block.Note,
			})
		}
	}

	if req.Start.Before(now) && c.Urgency == UrgencyElective {
		conflicts = append(conflicts, ScheduleConflict{
			Kind: "slot", Detail: "an elective case cannot be booked in the past",
			Overridable: true,
		})
	}

	return conflicts
}

// specialtyOf reports the case's specialty, which the deployment records on
// the procedure. Empty where it has not, and an empty specialty matches every
// room rather than none.
func specialtyOf(c Case) string {
	for _, requirement := range c.Requirements {
		if strings.HasPrefix(requirement, "specialty:") {
			return strings.TrimPrefix(requirement, "specialty:")
		}
	}
	return ""
}

// Schedule books the case (SRS-OT-004).
//
// Overrides are recorded rather than silent, and a non-overridable conflict
// refuses whatever the caller asks: a scheduler who could override "another
// case is in this room" would produce a list two theatres could not run.
func (c *Case) Schedule(req ScheduleRequest, conflicts []ScheduleConflict,
	override bool, at time.Time) error {

	switch {
	case !c.Status.Open():
		return fmt.Errorf("%w: this case is closed", ErrInvalidCase)
	case c.Status == CaseInTheatre:
		return fmt.Errorf("%w: this case has started", ErrInvalidCase)
	case c.Status == CaseRequested:
		return fmt.Errorf(
			"%w: this request is not complete enough to schedule", ErrInvalidCase)
	}

	for _, conflict := range conflicts {
		if !conflict.Overridable {
			return fmt.Errorf("%w: %s", ErrInvalidCase, conflict.Explain())
		}
	}
	if len(conflicts) > 0 && !override {
		return fmt.Errorf("%w: this slot has conflicts; override to book anyway",
			ErrInvalidCase)
	}

	c.RoomID, c.ScheduledStart, c.ScheduledEnd = req.RoomID, req.Start.UTC(), req.End.UTC()
	c.Status, c.UpdatedAt = CaseScheduled, at.UTC()
	return nil
}

// MarkReady moves a scheduled case to ready (SRS-OT-006).
//
// Called only after the pre-operative checklist has no unwaived blockers; the
// checklist itself lives in checklist.go, and this is the state it gates.
func (c *Case) MarkReady(at time.Time) error {
	if c.Status != CaseScheduled {
		return fmt.Errorf("%w: only a scheduled case becomes ready", ErrInvalidCase)
	}
	c.Status, c.UpdatedAt = CaseReady, at.UTC()
	return nil
}

// Start moves the case into theatre.
func (c *Case) Start(at time.Time) error {
	if c.Status != CaseReady {
		return fmt.Errorf(
			"%w: a case enters theatre from ready, not from %s", ErrInvalidCase, c.Status)
	}
	c.Status, c.UpdatedAt = CaseInTheatre, at.UTC()
	return nil
}

// Complete closes the case after the operation.
func (c *Case) CompleteCase(at time.Time) error {
	if c.Status != CaseInTheatre {
		return fmt.Errorf("%w: only a case in theatre completes", ErrInvalidCase)
	}
	c.Status, c.UpdatedAt = CaseCompleted, at.UTC()
	c.OutcomeAt = at.UTC()
	return nil
}

// Postpone takes the case off the list, to be rebooked (SRS-OT-005).
func (c *Case) Postpone(outcome CaseOutcome, reason, note string, at time.Time) error {
	if err := c.close(CasePostponed, outcome, reason, note, at); err != nil {
		return err
	}
	// A postponed case goes back to waiting for a slot rather than staying
	// booked in a room it is not using.
	c.RoomID = ""
	c.ScheduledStart, c.ScheduledEnd = time.Time{}, time.Time{}
	return nil
}

// Cancel takes the case off the list for good (SRS-OT-005).
func (c *Case) Cancel(outcome CaseOutcome, reason, note string, at time.Time) error {
	return c.close(CaseCancelled, outcome, reason, note, at)
}

func (c *Case) close(status CaseStatus, outcome CaseOutcome, reason, note string,
	at time.Time) error {

	switch {
	case !c.Status.Open():
		return fmt.Errorf("%w: this case is already closed", ErrInvalidCase)
	case c.Status == CaseInTheatre:
		return fmt.Errorf(
			"%w: this case has started; complete it and record what happened",
			ErrInvalidCase)
	case !knownOutcomes[outcome]:
		// The coded cause is the requirement. A hospital that cancels for want
		// of a bed and one whose patients do not attend need different fixes,
		// and a free-text field cannot tell them apart.
		return fmt.Errorf(
			"%w: classify the cause as patient, clinical, resource or administrative",
			ErrInvalidCase)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: name the specific reason", ErrInvalidCase)
	}

	c.Status = status
	c.Outcome, c.OutcomeReason = outcome, strings.TrimSpace(reason)
	c.OutcomeNote, c.OutcomeAt = strings.TrimSpace(note), at.UTC()
	c.UpdatedAt = at.UTC()
	return nil
}

// WaitingList orders the cases waiting for a slot (SRS-OT-005).
//
// Urgency first, then how long they have waited. Not a queue number: a case
// upgraded to urgent this morning goes ahead of one that has waited six weeks,
// and a system that sorted on waiting time alone would need somebody to
// override it every day.
func WaitingList(cases []Case) []Case {
	out := make([]Case, 0, len(cases))
	for _, c := range cases {
		if c.Status == CaseSchedulable || c.Status == CaseRequested ||
			c.Status == CasePostponed {
			out = append(out, c)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Urgency.Rank() != out[j].Urgency.Rank() {
			return out[i].Urgency.Rank() < out[j].Urgency.Rank()
		}
		return out[i].RequestedAt.Before(out[j].RequestedAt)
	})
	return out
}
