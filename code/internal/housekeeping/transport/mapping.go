// Package transport translates between the housekeeping contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised risk class stays
// empty and the domain refuses it rather than defaulting to low, which would
// put a theatre on an office's schedule; an unrecognised task kind stays
// empty rather than becoming routine, which would raise a terminal clean that
// holds no bed.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	housekeepingv1 "github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1"
	"github.com/ppusapati/health/code/internal/housekeeping/application"
	"github.com/ppusapati/health/code/internal/housekeeping/domain"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on
		// the wire, and a clean due in 1970 is one every screen shows as
		// decades overdue.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var riskClassFromWire = map[housekeepingv1.RiskClass]domain.RiskClass{
	housekeepingv1.RiskClass_RISK_CLASS_VERY_HIGH: domain.RiskVeryHigh,
	housekeepingv1.RiskClass_RISK_CLASS_HIGH:      domain.RiskHigh,
	housekeepingv1.RiskClass_RISK_CLASS_MODERATE:  domain.RiskModerate,
	housekeepingv1.RiskClass_RISK_CLASS_LOW:       domain.RiskLow,
}

var taskKindFromWire = map[housekeepingv1.TaskKind]domain.TaskKind{
	housekeepingv1.TaskKind_TASK_KIND_ROUTINE:  domain.TaskRoutine,
	housekeepingv1.TaskKind_TASK_KIND_TERMINAL: domain.TaskTerminal,
	housekeepingv1.TaskKind_TASK_KIND_SPILL:    domain.TaskSpill,
	housekeepingv1.TaskKind_TASK_KIND_DEEP:     domain.TaskDeep,
}

var taskStateFromWire = map[housekeepingv1.TaskState]domain.TaskState{
	housekeepingv1.TaskState_TASK_STATE_OPEN:        domain.TaskOpen,
	housekeepingv1.TaskState_TASK_STATE_IN_PROGRESS: domain.TaskInProgress,
	housekeepingv1.TaskState_TASK_STATE_COMPLETED:   domain.TaskCompleted,
	housekeepingv1.TaskState_TASK_STATE_VERIFIED:    domain.TaskVerified,
	housekeepingv1.TaskState_TASK_STATE_CANCELLED:   domain.TaskCancelled,
}

var holdStateFromWire = map[housekeepingv1.HoldState]domain.HoldState{
	housekeepingv1.HoldState_HOLD_STATE_OPEN:       domain.HoldOpen,
	housekeepingv1.HoldState_HOLD_STATE_RELEASED:   domain.HoldReleased,
	housekeepingv1.HoldState_HOLD_STATE_OVERRIDDEN: domain.HoldOverridden,
}

var (
	riskClassToWire = map[domain.RiskClass]housekeepingv1.RiskClass{}
	taskKindToWire  = map[domain.TaskKind]housekeepingv1.TaskKind{}
	taskStateToWire = map[domain.TaskState]housekeepingv1.TaskState{}
	holdStateToWire = map[domain.HoldState]housekeepingv1.HoldState{}
)

func init() {
	for wire, value := range riskClassFromWire {
		riskClassToWire[value] = wire
	}
	for wire, value := range taskKindFromWire {
		taskKindToWire[value] = wire
	}
	for wire, value := range taskStateFromWire {
		taskStateToWire[value] = wire
	}
	for wire, value := range holdStateFromWire {
		holdStateToWire[value] = wire
	}
}

func checklistFromWire(
	in []*housekeepingv1.ChecklistItem) []domain.ChecklistItem {

	out := make([]domain.ChecklistItem, 0, len(in))
	for _, item := range in {
		out = append(out, domain.ChecklistItem{
			Code: item.GetCode(), Label: item.GetLabel(),
			Required: item.GetRequired(),
		})
	}
	return out
}

func checklistToWire(
	in []domain.ChecklistItem) []*housekeepingv1.ChecklistItem {

	out := make([]*housekeepingv1.ChecklistItem, 0, len(in))
	for _, item := range in {
		out = append(out, &housekeepingv1.ChecklistItem{
			Code: item.Code, Label: item.Label, Required: item.Required,
		})
	}
	return out
}

func answersFromWire(
	in []*housekeepingv1.ChecklistAnswer) []domain.ChecklistAnswer {

	out := make([]domain.ChecklistAnswer, 0, len(in))
	for _, answer := range in {
		out = append(out, domain.ChecklistAnswer{
			Code: answer.GetCode(), Done: answer.GetDone(),
			Exception: answer.GetException(),
		})
	}
	return out
}

func answersToWire(
	in []domain.ChecklistAnswer) []*housekeepingv1.ChecklistAnswer {

	out := make([]*housekeepingv1.ChecklistAnswer, 0, len(in))
	for _, answer := range in {
		out = append(out, &housekeepingv1.ChecklistAnswer{
			Code: answer.Code, Done: answer.Done,
			Exception: answer.Exception,
		})
	}
	return out
}

func scanToWire(in domain.LocationScan) *housekeepingv1.LocationScan {
	return &housekeepingv1.LocationScan{
		ScannedCode: in.ScannedCode, Matched: in.Matched,
		ScannedBy: in.ScannedBy, ScannedAt: stamp(in.ScannedAt),
	}
}

func scansToWire(in []domain.LocationScan) []*housekeepingv1.LocationScan {
	out := make([]*housekeepingv1.LocationScan, 0, len(in))
	for _, scan := range in {
		out = append(out, scanToWire(scan))
	}
	return out
}

func locationToWire(
	in domain.CleanableLocation) *housekeepingv1.CleanableLocation {

	return &housekeepingv1.CleanableLocation{
		LocationId: in.ID, Code: in.Code, Name: in.Name,
		Revision: int32(in.Revision), FacilityId: in.FacilityID,
		Zone: in.Zone, BedId: in.BedID,
		RiskClass:          riskClassToWire[in.RiskClass],
		RoutineEveryHours:  int32(in.RoutineEveryHours),
		RoutineSlaMinutes:  int32(in.RoutineSLAMinutes),
		TerminalSlaMinutes: int32(in.TerminalSLAMinutes),
		Checklist:          checklistToWire(in.Checklist),
		ScanCode:           in.ScanCode,
		Approved:           in.Approved, ApprovedBy: in.ApprovedBy,
		ApprovedAt:    stamp(in.ApprovedAt),
		EffectiveFrom: stamp(in.EffectiveFrom),
		SupersededAt:  stamp(in.SupersededAt),
		CreatedAt:     stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func locationsToWire(
	in []domain.CleanableLocation) []*housekeepingv1.CleanableLocation {

	out := make([]*housekeepingv1.CleanableLocation, 0, len(in))
	for _, location := range in {
		out = append(out, locationToWire(location))
	}
	return out
}

func taskToWire(in domain.CleaningTask) *housekeepingv1.CleaningTask {
	return &housekeepingv1.CleaningTask{
		TaskId: in.ID, Kind: taskKindToWire[in.Kind],
		LocationCode: in.LocationCode, LocationName: in.LocationName,
		FacilityId: in.FacilityID, Zone: in.Zone, BedId: in.BedID,
		RiskClass:        riskClassToWire[in.RiskClass],
		LocationRevision: int32(in.LocationRevision),
		Checklist:        checklistToWire(in.Checklist),
		ScanCode:         in.ScanCode, Restricted: in.Restricted,
		IncidentRef: in.IncidentRef, Detail: in.Detail,
		AssigneeId: in.AssigneeID, DueBy: stamp(in.DueBy),
		State:   taskStateToWire[in.State],
		Answers: answersToWire(in.Answers), Scans: scansToWire(in.Scans),
		StartedAt: stamp(in.StartedAt), StartedBy: in.StartedBy,
		CompletedAt: stamp(in.CompletedAt), CompletedBy: in.CompletedBy,
		VerifiedAt: stamp(in.VerifiedAt), VerifiedBy: in.VerifiedBy,
		VerifyNote: in.VerifyNote, CancelReason: in.CancelReason,
		EscalatedAt: stamp(in.EscalatedAt),
		RaisedAt:    stamp(in.RaisedAt), RaisedBy: in.RaisedBy,
		Version: in.Version,
	}
}

func tasksToWire(in []domain.CleaningTask) []*housekeepingv1.CleaningTask {
	out := make([]*housekeepingv1.CleaningTask, 0, len(in))
	for _, task := range in {
		out = append(out, taskToWire(task))
	}
	return out
}

func holdToWire(in domain.BedHold) *housekeepingv1.BedHold {
	if in.ID == "" {
		return nil
	}
	return &housekeepingv1.BedHold{
		HoldId: in.ID, BedId: in.BedID, LocationCode: in.LocationCode,
		FacilityId: in.FacilityID, Zone: in.Zone,
		TaskId: in.TaskID, EncounterId: in.EncounterID,
		State:    holdStateToWire[in.State],
		PlacedAt: stamp(in.PlacedAt), PlacedBy: in.PlacedBy,
		ReleasedAt: stamp(in.ReleasedAt), ReleasedBy: in.ReleasedBy,
		OverriddenAt:   stamp(in.OverriddenAt),
		OverriddenBy:   in.OverriddenBy,
		OverrideReason: in.OverrideReason,
		Version:        in.Version,
	}
}

func holdsToWire(in []domain.BedHold) []*housekeepingv1.BedHold {
	out := make([]*housekeepingv1.BedHold, 0, len(in))
	for _, hold := range in {
		out = append(out, holdToWire(hold))
	}
	return out
}

func dueToWire(in []domain.DueRoutine) []*housekeepingv1.DueRoutineClean {
	out := make([]*housekeepingv1.DueRoutineClean, 0, len(in))
	for _, due := range in {
		out = append(out, &housekeepingv1.DueRoutineClean{
			Location:      locationToWire(due.Location),
			LastCleanedAt: stamp(due.LastCleanedAt),
			DueSince:      stamp(due.DueSince),
			NeverCleaned:  due.Never,
		})
	}
	return out
}

// statesFromWire drops any state it does not recognise, so a request naming
// only unknown states comes back as no filter at all. That widens the read
// rather than narrowing it, which is the safe direction here: a supervisor
// shown more cleaning tasks than they asked for notices, and one shown none
// concludes the ward is clean.
func statesFromWire(in []housekeepingv1.TaskState) []string {
	out := make([]string, 0, len(in))
	for _, state := range in {
		if mapped, ok := taskStateFromWire[state]; ok {
			out = append(out, string(mapped))
		}
	}
	return out
}

func cleaningSummaryToWire(
	in domain.CleaningSummary) *housekeepingv1.CleaningSummary {

	return &housekeepingv1.CleaningSummary{
		Raised: int32(in.Raised), Completed: int32(in.Completed),
		Cancelled: int32(in.Cancelled), Outstanding: int32(in.Outstanding),
		OverdueNow:               int32(in.OverdueNow),
		CompletedLate:            int32(in.CompletedLate),
		WithinSla:                int32(in.WithinSLA),
		MeanTurnaroundMinutes:    int32(in.MeanTurnaroundMinutes),
		LongestTurnaroundMinutes: int32(in.LongestTurnaroundMinutes),
		Verified:                 int32(in.Verified),
		ScanVerified:             int32(in.ScanVerified),
		Unanswerable:             in.Unanswerable,
	}
}

func turnaroundSummaryToWire(
	in domain.TurnaroundSummary) *housekeepingv1.TurnaroundSummary {

	return &housekeepingv1.TurnaroundSummary{
		Held: int32(in.Held), Released: int32(in.Released),
		StillHeld: int32(in.StillHeld), Overridden: int32(in.Overridden),
		MeanMinutes:    int32(in.MeanMinutes),
		LongestMinutes: int32(in.LongestMinutes),
		Unanswerable:   in.Unanswerable,
	}
}

func reportInput(facilityID, zone string, from,
	to *timestamppb.Timestamp) application.ReportInput {

	return application.ReportInput{
		FacilityID: facilityID, Zone: zone,
		From: timeOf(from), To: timeOf(to),
	}
}
