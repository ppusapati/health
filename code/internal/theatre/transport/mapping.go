// Package transport translates between the perioperative contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction.
package transport

import (
	"time"

	theatrev1 "github.com/ppusapati/health/code/gen/go/healthcare/theatre/v1"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp on the wire reads as
		// 1970, and every interval derived from it would be wrong by 56 years.
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

func seconds(d time.Duration) int64 { return int64(d / time.Second) }

func optionalSeconds(d *time.Duration) *int64 {
	if d == nil {
		return nil
	}
	out := seconds(*d)
	return &out
}

var urgencyFromWire = map[theatrev1.Urgency]domain.Urgency{
	theatrev1.Urgency_URGENCY_ELECTIVE:  domain.UrgencyElective,
	theatrev1.Urgency_URGENCY_URGENT:    domain.UrgencyUrgent,
	theatrev1.Urgency_URGENCY_EMERGENCY: domain.UrgencyEmergency,
}

// urgency maps the wire enum. An unset one stays unspecified, which NewCase
// defaults to elective — the safe direction, because a client that forgot the
// field must not have a case booked as an emergency.
func urgency(in theatrev1.Urgency) domain.Urgency { return urgencyFromWire[in] }

var urgencyToWire = map[domain.Urgency]theatrev1.Urgency{
	domain.UrgencyElective:  theatrev1.Urgency_URGENCY_ELECTIVE,
	domain.UrgencyUrgent:    theatrev1.Urgency_URGENCY_URGENT,
	domain.UrgencyEmergency: theatrev1.Urgency_URGENCY_EMERGENCY,
}

var lateralityFromWire = map[theatrev1.Laterality]domain.Laterality{
	theatrev1.Laterality_LATERALITY_NOT_APPLICABLE: domain.LateralityNotApplicable,
	theatrev1.Laterality_LATERALITY_LEFT:           domain.LateralityLeft,
	theatrev1.Laterality_LATERALITY_RIGHT:          domain.LateralityRight,
	theatrev1.Laterality_LATERALITY_BILATERAL:      domain.LateralityBilateral,
}

// laterality maps the wire enum. An unset one stays unspecified rather than
// defaulting to not-applicable: for a procedure that has sides, unspecified is
// what keeps the case off the list, and defaulting it would schedule a case
// with no side recorded. Wrong-site surgery is the never-event this field
// exists for.
func laterality(in theatrev1.Laterality) domain.Laterality {
	return lateralityFromWire[in]
}

var lateralityToWire = map[domain.Laterality]theatrev1.Laterality{
	domain.LateralityNotApplicable: theatrev1.Laterality_LATERALITY_NOT_APPLICABLE,
	domain.LateralityLeft:          theatrev1.Laterality_LATERALITY_LEFT,
	domain.LateralityRight:         theatrev1.Laterality_LATERALITY_RIGHT,
	domain.LateralityBilateral:     theatrev1.Laterality_LATERALITY_BILATERAL,
}

var statusToWire = map[domain.CaseStatus]theatrev1.CaseStatus{
	domain.CaseRequested:   theatrev1.CaseStatus_CASE_STATUS_REQUESTED,
	domain.CaseSchedulable: theatrev1.CaseStatus_CASE_STATUS_SCHEDULABLE,
	domain.CaseScheduled:   theatrev1.CaseStatus_CASE_STATUS_SCHEDULED,
	domain.CaseReady:       theatrev1.CaseStatus_CASE_STATUS_READY,
	domain.CaseInTheatre:   theatrev1.CaseStatus_CASE_STATUS_IN_THEATRE,
	domain.CaseCompleted:   theatrev1.CaseStatus_CASE_STATUS_COMPLETED,
	domain.CasePostponed:   theatrev1.CaseStatus_CASE_STATUS_POSTPONED,
	domain.CaseCancelled:   theatrev1.CaseStatus_CASE_STATUS_CANCELLED,
}

var causeFromWire = map[theatrev1.CaseCause]domain.CaseOutcome{
	theatrev1.CaseCause_CASE_CAUSE_PATIENT:        domain.OutcomePatient,
	theatrev1.CaseCause_CASE_CAUSE_CLINICAL:       domain.OutcomeClinical,
	theatrev1.CaseCause_CASE_CAUSE_RESOURCE:       domain.OutcomeResource,
	theatrev1.CaseCause_CASE_CAUSE_ADMINISTRATIVE: domain.OutcomeAdministrative,
}

// cause maps the wire enum. An unset one stays empty, which the domain
// refuses: a cancellation with no coded cause is the free-text report
// SRS-OT-005 exists to prevent, and defaulting it to any of the four would put
// a made-up cause into the hospital's analytics.
func cause(in theatrev1.CaseCause) domain.CaseOutcome { return causeFromWire[in] }

var causeToWire = map[domain.CaseOutcome]theatrev1.CaseCause{
	domain.OutcomePatient:        theatrev1.CaseCause_CASE_CAUSE_PATIENT,
	domain.OutcomeClinical:       theatrev1.CaseCause_CASE_CAUSE_CLINICAL,
	domain.OutcomeResource:       theatrev1.CaseCause_CASE_CAUSE_RESOURCE,
	domain.OutcomeAdministrative: theatrev1.CaseCause_CASE_CAUSE_ADMINISTRATIVE,
}

var blockKindFromWire = map[theatrev1.BlockKind]domain.BlockKind{
	theatrev1.BlockKind_BLOCK_KIND_LIST:      domain.BlockList,
	theatrev1.BlockKind_BLOCK_KIND_DOWNTIME:  domain.BlockDowntime,
	theatrev1.BlockKind_BLOCK_KIND_EMERGENCY: domain.BlockEmergency,
}

// blockKind defaults an unset kind to a list rather than to downtime: a client
// that forgot the field allocates time rather than closing a theatre.
func blockKind(in theatrev1.BlockKind) domain.BlockKind {
	if mapped, ok := blockKindFromWire[in]; ok {
		return mapped
	}
	return domain.BlockList
}

var blockKindToWire = map[domain.BlockKind]theatrev1.BlockKind{
	domain.BlockList:      theatrev1.BlockKind_BLOCK_KIND_LIST,
	domain.BlockDowntime:  theatrev1.BlockKind_BLOCK_KIND_DOWNTIME,
	domain.BlockEmergency: theatrev1.BlockKind_BLOCK_KIND_EMERGENCY,
}

var preopStateFromWire = map[theatrev1.PreopState]domain.PreopState{
	theatrev1.PreopState_PREOP_STATE_MET:            domain.PreopMet,
	theatrev1.PreopState_PREOP_STATE_UNMET:          domain.PreopUnmet,
	theatrev1.PreopState_PREOP_STATE_WAIVED:         domain.PreopWaived,
	theatrev1.PreopState_PREOP_STATE_NOT_APPLICABLE: domain.PreopNotApplicable,
}

// preopState defaults an unset answer to unmet.
//
// The safe direction: an item nobody said anything about was not done, and
// defaulting it to met would clear a blocker because a client left a field
// out. Wrong-site surgery and operating without consent are what these gates
// hold.
func preopState(in theatrev1.PreopState) domain.PreopState {
	if mapped, ok := preopStateFromWire[in]; ok {
		return mapped
	}
	return domain.PreopUnmet
}

var preopStateToWire = map[domain.PreopState]theatrev1.PreopState{
	domain.PreopMet:           theatrev1.PreopState_PREOP_STATE_MET,
	domain.PreopUnmet:         theatrev1.PreopState_PREOP_STATE_UNMET,
	domain.PreopWaived:        theatrev1.PreopState_PREOP_STATE_WAIVED,
	domain.PreopNotApplicable: theatrev1.PreopState_PREOP_STATE_NOT_APPLICABLE,
}

var phaseFromWire = map[theatrev1.SafetyPhase]domain.SafetyPhase{
	theatrev1.SafetyPhase_SAFETY_PHASE_SIGN_IN:  domain.PhaseSignIn,
	theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT: domain.PhaseTimeOut,
	theatrev1.SafetyPhase_SAFETY_PHASE_SIGN_OUT: domain.PhaseSignOut,
}

// phase maps the wire enum. An unset one stays empty, which PerformSafety
// refuses: a check recorded against no phase is one nobody can tell from a
// time-out.
func phase(in theatrev1.SafetyPhase) domain.SafetyPhase { return phaseFromWire[in] }

var phaseToWire = map[domain.SafetyPhase]theatrev1.SafetyPhase{
	domain.PhaseSignIn:  theatrev1.SafetyPhase_SAFETY_PHASE_SIGN_IN,
	domain.PhaseTimeOut: theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT,
	domain.PhaseSignOut: theatrev1.SafetyPhase_SAFETY_PHASE_SIGN_OUT,
}

var milestoneFromWire = map[theatrev1.Milestone]domain.Milestone{
	theatrev1.Milestone_MILESTONE_PRE_OP:            domain.MilestonePreOp,
	theatrev1.Milestone_MILESTONE_THEATRE_IN:        domain.MilestoneTheatreIn,
	theatrev1.Milestone_MILESTONE_ANAESTHESIA_START: domain.MilestoneAnaesthesiaStart,
	theatrev1.Milestone_MILESTONE_INCISION:          domain.MilestoneIncision,
	theatrev1.Milestone_MILESTONE_CLOSURE:           domain.MilestoneClosure,
	theatrev1.Milestone_MILESTONE_THEATRE_OUT:       domain.MilestoneTheatreOut,
	theatrev1.Milestone_MILESTONE_PACU_IN:           domain.MilestonePacuIn,
	theatrev1.Milestone_MILESTONE_PACU_OUT:          domain.MilestonePacuOut,
}

// milestone maps the wire enum. An unset one stays empty, which
// RecordMilestone refuses: a milestone with no name would move a case through
// the board at random.
func milestone(in theatrev1.Milestone) domain.Milestone { return milestoneFromWire[in] }

var milestoneToWire = map[domain.Milestone]theatrev1.Milestone{
	domain.MilestonePreOp:            theatrev1.Milestone_MILESTONE_PRE_OP,
	domain.MilestoneTheatreIn:        theatrev1.Milestone_MILESTONE_THEATRE_IN,
	domain.MilestoneAnaesthesiaStart: theatrev1.Milestone_MILESTONE_ANAESTHESIA_START,
	domain.MilestoneIncision:         theatrev1.Milestone_MILESTONE_INCISION,
	domain.MilestoneClosure:          theatrev1.Milestone_MILESTONE_CLOSURE,
	domain.MilestoneTheatreOut:       theatrev1.Milestone_MILESTONE_THEATRE_OUT,
	domain.MilestonePacuIn:           theatrev1.Milestone_MILESTONE_PACU_IN,
	domain.MilestonePacuOut:          theatrev1.Milestone_MILESTONE_PACU_OUT,
}

var delayReasonFromWire = map[theatrev1.DelayReason]domain.DelayReason{
	theatrev1.DelayReason_DELAY_REASON_PATIENT:             domain.DelayPatient,
	theatrev1.DelayReason_DELAY_REASON_SURGEON:             domain.DelaySurgeon,
	theatrev1.DelayReason_DELAY_REASON_ANAESTHESIA:         domain.DelayAnaesthesia,
	theatrev1.DelayReason_DELAY_REASON_NURSING:             domain.DelayNursing,
	theatrev1.DelayReason_DELAY_REASON_EQUIPMENT:           domain.DelayEquipment,
	theatrev1.DelayReason_DELAY_REASON_INSTRUMENTS:         domain.DelayInstruments,
	theatrev1.DelayReason_DELAY_REASON_CLEANING:            domain.DelayCleaning,
	theatrev1.DelayReason_DELAY_REASON_BED:                 domain.DelayBed,
	theatrev1.DelayReason_DELAY_REASON_PORTERS:             domain.DelayPorters,
	theatrev1.DelayReason_DELAY_REASON_PREVIOUS_CASE:       domain.DelayPreviousCase,
	theatrev1.DelayReason_DELAY_REASON_EMERGENCY_INSERTION: domain.DelayEmergency,
	theatrev1.DelayReason_DELAY_REASON_OTHER:               domain.DelayOther,
}

// delayReason maps the wire enum. An unset one stays empty, which RecordDelay
// refuses: an unclassified delay is exactly the free-text report SRS-OT-014
// exists to prevent, and defaulting it to "other" would produce that report
// with extra steps.
func delayReason(in theatrev1.DelayReason) domain.DelayReason {
	return delayReasonFromWire[in]
}

var delayReasonToWire = map[domain.DelayReason]theatrev1.DelayReason{
	domain.DelayPatient:      theatrev1.DelayReason_DELAY_REASON_PATIENT,
	domain.DelaySurgeon:      theatrev1.DelayReason_DELAY_REASON_SURGEON,
	domain.DelayAnaesthesia:  theatrev1.DelayReason_DELAY_REASON_ANAESTHESIA,
	domain.DelayNursing:      theatrev1.DelayReason_DELAY_REASON_NURSING,
	domain.DelayEquipment:    theatrev1.DelayReason_DELAY_REASON_EQUIPMENT,
	domain.DelayInstruments:  theatrev1.DelayReason_DELAY_REASON_INSTRUMENTS,
	domain.DelayCleaning:     theatrev1.DelayReason_DELAY_REASON_CLEANING,
	domain.DelayBed:          theatrev1.DelayReason_DELAY_REASON_BED,
	domain.DelayPorters:      theatrev1.DelayReason_DELAY_REASON_PORTERS,
	domain.DelayPreviousCase: theatrev1.DelayReason_DELAY_REASON_PREVIOUS_CASE,
	domain.DelayEmergency:    theatrev1.DelayReason_DELAY_REASON_EMERGENCY_INSERTION,
	domain.DelayOther:        theatrev1.DelayReason_DELAY_REASON_OTHER,
}

var noteStatusToWire = map[domain.NoteStatus]theatrev1.NoteStatus{
	domain.NoteDraft:      theatrev1.NoteStatus_NOTE_STATUS_DRAFT,
	domain.NoteSigned:     theatrev1.NoteStatus_NOTE_STATUS_SIGNED,
	domain.NoteAmended:    theatrev1.NoteStatus_NOTE_STATUS_AMENDED,
	domain.NoteSuperseded: theatrev1.NoteStatus_NOTE_STATUS_SUPERSEDED,
}

var usageKindFromWire = map[theatrev1.UsageKind]domain.UsageKind{
	theatrev1.UsageKind_USAGE_KIND_CONSUMABLE: domain.UsageConsumable,
	theatrev1.UsageKind_USAGE_KIND_IMPLANT:    domain.UsageImplant,
}

// usageKind defaults an unset kind to consumable.
//
// The safe direction here is arguable and this is the one chosen: an implant
// must carry a serial or a lot, so defaulting to implant would refuse an
// ordinary swab for want of an identifier, while defaulting to consumable
// records the item and loses the implant's traceability. The refusal side is
// worse in a running theatre, and a client sending an implant without saying
// so is a client bug the recall list will not cover — so the field is required
// in the client documentation and the safer failure here is the one that keeps
// the item recorded.
func usageKind(in theatrev1.UsageKind) domain.UsageKind {
	if mapped, ok := usageKindFromWire[in]; ok {
		return mapped
	}
	return domain.UsageConsumable
}

var usageKindToWire = map[domain.UsageKind]theatrev1.UsageKind{
	domain.UsageConsumable: theatrev1.UsageKind_USAGE_KIND_CONSUMABLE,
	domain.UsageImplant:    theatrev1.UsageKind_USAGE_KIND_IMPLANT,
}

var stageToWire = map[domain.RoomStage]theatrev1.RoomStage{
	domain.StageEmpty:     theatrev1.RoomStage_ROOM_STAGE_EMPTY,
	domain.StageNextReady: theatrev1.RoomStage_ROOM_STAGE_NEXT_CASE_READY,
	domain.StageInUse:     theatrev1.RoomStage_ROOM_STAGE_IN_USE,
	domain.StageTurnover:  theatrev1.RoomStage_ROOM_STAGE_TURNOVER,
	domain.StageClosed:    theatrev1.RoomStage_ROOM_STAGE_CLOSED,
}

func roomToProto(r domain.Room) *theatrev1.Room {
	return &theatrev1.Room{
		RoomId: r.ID, FacilityId: r.FacilityID, Code: r.Code, Name: r.Name,
		Specialties: r.Specialties, Equipment: r.Equipment, Active: r.Active,
	}
}

func blockToProto(b domain.Block) *theatrev1.Block {
	return &theatrev1.Block{
		BlockId: b.ID, RoomId: b.RoomID, Kind: blockKindToWire[b.Kind],
		OwnerId: b.OwnerID, Specialty: b.Specialty,
		StartsAt: stamp(b.StartsAt), EndsAt: stamp(b.EndsAt), Note: b.Note,
	}
}

func caseToProto(c domain.Case) *theatrev1.SurgicalCase {
	return &theatrev1.SurgicalCase{
		CaseId: c.ID, EncounterId: c.EncounterID, PatientId: c.PatientID,
		FacilityId:    c.FacilityID,
		ProcedureCode: c.ProcedureCode, ProcedureDisplay: c.ProcedureDisplay,
		DiagnosisCode: c.DiagnosisCode, DiagnosisDisplay: c.DiagnosisDisplay,
		Laterality: lateralityToWire[c.Laterality], Site: c.Site,
		Urgency:                 urgencyToWire[c.Urgency],
		ExpectedDurationSeconds: seconds(c.ExpectedDuration),
		SurgeonId:               c.SurgeonID,
		Team:                    c.Team, Requirements: c.Requirements,
		AnaesthesiaType: c.AnaesthesiaType, SpecialNotes: c.SpecialNotes,
		Status: statusToWire[c.Status], RoomId: c.RoomID,
		ScheduledStart: stamp(c.ScheduledStart), ScheduledEnd: stamp(c.ScheduledEnd),
		Cause: causeToWire[c.Outcome], CauseReason: c.OutcomeReason,
		CauseNote: c.OutcomeNote, ClosedAt: stamp(c.OutcomeAt),
		RequestedBy: c.RequestedBy, RequestedAt: stamp(c.RequestedAt),
		Version: c.Version,
	}
}

func conflictsToProto(conflicts []domain.ScheduleConflict) []*theatrev1.ScheduleConflict {
	out := make([]*theatrev1.ScheduleConflict, 0, len(conflicts))
	for _, conflict := range conflicts {
		out = append(out, &theatrev1.ScheduleConflict{
			Kind: conflict.Kind, Detail: conflict.Detail,
			Overridable: conflict.Overridable,
		})
	}
	return out
}

func preopEntryToProto(e domain.PreopEntry) *theatrev1.PreopEntry {
	return &theatrev1.PreopEntry{
		Code: e.Code, State: preopStateToWire[e.State], Note: e.Note,
		WaivedBy: e.WaivedBy, WaivedRole: e.WaivedRole,
		RecordedBy: e.RecordedBy, RecordedAt: stamp(e.RecordedAt),
	}
}

func blockersToProto(blockers []domain.Blocker) []*theatrev1.Blocker {
	out := make([]*theatrev1.Blocker, 0, len(blockers))
	for _, blocker := range blockers {
		out = append(out, &theatrev1.Blocker{
			Code: blocker.Code, Label: blocker.Label, WaivableBy: blocker.WaivableBy,
		})
	}
	return out
}

func safetyToProto(r domain.SafetyRecord) *theatrev1.SafetyCheck {
	out := &theatrev1.SafetyCheck{
		CheckId: r.ID, CaseId: r.CaseID, Phase: phaseToWire[r.Phase],
		Participants: r.Participants,
		PerformedAt:  stamp(r.PerformedAt), PerformedBy: r.PerformedBy,
	}
	for _, answer := range r.Answers {
		out.Answers = append(out.Answers, &theatrev1.SafetyAnswer{
			Code: answer.Code, Confirmed: answer.Confirmed,
			Exception: answer.Exception,
		})
	}
	return out
}

func milestoneToProto(m domain.MilestoneRecord) *theatrev1.MilestoneRecord {
	return &theatrev1.MilestoneRecord{
		MilestoneId: m.ID, CaseId: m.CaseID,
		Milestone:  milestoneToWire[m.Milestone],
		OccurredAt: stamp(m.OccurredAt), RecordedAt: stamp(m.RecordedAt),
		RecordedBy: m.RecordedBy, Note: m.Note,
	}
}

func intervalsToProto(in domain.CaseIntervals) *theatrev1.CaseIntervals {
	return &theatrev1.CaseIntervals{
		AnaesthesiaToIncisionSeconds: optionalSeconds(in.AnaesthesiaToIncision),
		IncisionToClosureSeconds:     optionalSeconds(in.IncisionToClosure),
		TheatreOccupancySeconds:      optionalSeconds(in.TheatreOccupancy),
		PacuStaySeconds:              optionalSeconds(in.PacuStay),
		StartDelaySeconds:            optionalSeconds(in.StartDelay),
	}
}

func delayToProto(d domain.Delay) *theatrev1.Delay {
	return &theatrev1.Delay{
		DelayId: d.ID, CaseId: d.CaseID, Reason: delayReasonToWire[d.Reason],
		Dependency: d.Dependency, Minutes: int32(d.Minutes), Note: d.Note,
		RecordedAt: stamp(d.RecordedAt), RecordedBy: d.RecordedBy,
	}
}

func noteToProto(n domain.OperativeNote) *theatrev1.OperativeNote {
	return &theatrev1.OperativeNote{
		NoteId: n.ID, CaseId: n.CaseID, Version: int32(n.Version),
		Supersedes:         n.Supersedes,
		ProcedurePerformed: n.ProcedurePerformed, Findings: n.Findings,
		SpecimenIds: n.SpecimenIDs, ImplantIds: n.ImplantIDs,
		Complications:        n.Complications,
		EstimatedBloodLossMl: int32(n.EstimatedBloodLossML),
		PostOperativeOrders:  n.PostOperativeOrders, Narrative: n.Narrative,
		Status: noteStatusToWire[n.Status], AmendmentReason: n.AmendmentReason,
		AuthoredBy: n.AuthoredBy, AuthoredAt: stamp(n.AuthoredAt),
		SignedBy: n.SignedBy, SignedAt: stamp(n.SignedAt),
	}
}

func usageToProto(u domain.Usage, now time.Time) *theatrev1.Usage {
	return &theatrev1.Usage{
		UsageId: u.ID, CaseId: u.CaseID, Kind: usageKindToWire[u.Kind],
		ItemCode: u.ItemCode, ItemName: u.ItemName,
		LotNumber: u.LotNumber, SerialNumber: u.SerialNumber,
		Quantity: int32(u.Quantity), ExpiryDate: stamp(u.ExpiryDate),
		Scanned: u.Scanned, ScanData: u.ScanData,
		RecordedAt: stamp(u.RecordedAt), RecordedBy: u.RecordedBy,
		Expired: u.Expired(now),
	}
}

func specimenToProto(s domain.Specimen) *theatrev1.Specimen {
	return &theatrev1.Specimen{
		SpecimenId: s.ID, CaseId: s.CaseID, PatientId: s.PatientID,
		Label: s.Label, Site: s.Site,
		Laterality: lateralityToWire[s.Laterality],
		Container:  s.Container, Fixative: s.Fixative, OrderId: s.OrderID,
		TakenAt: stamp(s.TakenAt), TakenBy: s.TakenBy,
	}
}

func trayToProto(t domain.TrayUse) *theatrev1.TrayUse {
	return &theatrev1.TrayUse{
		TrayUseId: t.ID, CaseId: t.CaseID, TrayId: t.TrayID,
		TrayName: t.TrayName, CycleId: t.CycleID,
		IndicatorPassed: t.IndicatorPassed, IndicatorNote: t.IndicatorNote,
		OpenedAt: stamp(t.OpenedAt), OpenedBy: t.OpenedBy,
	}
}

func recipientsToProto(recipients []ports.Recipient) []*theatrev1.Recipient {
	out := make([]*theatrev1.Recipient, 0, len(recipients))
	for _, recipient := range recipients {
		out = append(out, &theatrev1.Recipient{
			PatientId: recipient.PatientID, EncounterId: recipient.EncounterID,
			CaseId: recipient.CaseID, Reference: recipient.Reference,
			At: stamp(recipient.At),
		})
	}
	return out
}

func cardToProto(c domain.PreferenceCard) *theatrev1.PreferenceCard {
	out := &theatrev1.PreferenceCard{
		CardId: c.ID, SurgeonId: c.SurgeonID, ProcedureCode: c.ProcedureCode,
		Name: c.Name, Equipment: c.Equipment, Trays: c.Trays, Notes: c.Notes,
		Version: int32(c.Version), UpdatedAt: stamp(c.UpdatedAt),
		UpdatedBy: c.UpdatedBy,
	}
	for _, item := range c.Consumables {
		out.Consumables = append(out.Consumables, &theatrev1.CardItem{
			ItemCode: item.ItemCode, ItemName: item.ItemName,
			Quantity: int32(item.Quantity),
		})
	}
	return out
}

func boardRowToProto(r domain.BoardRow) *theatrev1.BoardRow {
	return &theatrev1.BoardRow{
		RoomId: r.RoomID, RoomCode: r.RoomCode, Stage: stageToWire[r.Stage],
		CurrentCaseId: r.CurrentCaseID, CurrentProcedure: r.CurrentProcedure,
		CurrentSurgeon:   r.CurrentSurgeon,
		CurrentMilestone: milestoneToWire[r.CurrentMilestone],
		ElapsedSeconds:   seconds(r.Elapsed), OverRunning: r.OverRunning,
		NextCaseId: r.NextCaseID, NextProcedure: r.NextProcedure,
		NextStart: stamp(r.NextStart), NextReady: r.NextReady,
		NextBlockers:         r.NextBlockers,
		TurnoverSoFarSeconds: seconds(r.TurnoverSoFar),
		DelayMinutes:         int32(r.DelayMinutes),
	}
}

func utilisationToProto(u domain.Utilisation) *theatrev1.Utilisation {
	out := &theatrev1.Utilisation{
		RoomId: u.RoomID, From: stamp(u.From), To: stamp(u.To),
		ScheduledMinutes: int32(u.ScheduledMinutes),
		OperatingMinutes: int32(u.OperatingMinutes),
		BlockMinutes:     int32(u.BlockMinutes),
		Cases:            int32(u.Cases),
		Completed:        int32(u.Completed),
		Cancelled:        int32(u.Cancelled),
		Postponed:        int32(u.Postponed),
		OnTimeStarts:     int32(u.OnTimeStarts),
		FirstCases:       int32(u.FirstCases),
		OnTimeFirstCases: int32(u.OnTimeFirstCases),
		TurnoverCount:    int32(u.TurnoverCount),
		TurnoverMinutes:  int32(u.TurnoverMinutes),
		DelayMinutes:     int32(u.DelayMinutes),
	}
	// Repeated pairs rather than a map, so the order is stable and a client
	// rendering a table gets the same rows every time.
	for _, cause := range []domain.CaseOutcome{
		domain.OutcomePatient, domain.OutcomeClinical,
		domain.OutcomeResource, domain.OutcomeAdministrative,
	} {
		if count := u.CancellationsByCause[cause]; count > 0 {
			out.CancellationsByCause = append(out.CancellationsByCause,
				&theatrev1.CauseCount{
					Cause: causeToWire[cause], Count: int32(count),
				})
		}
	}
	for _, reason := range []domain.DelayReason{
		domain.DelayPatient, domain.DelaySurgeon, domain.DelayAnaesthesia,
		domain.DelayNursing, domain.DelayEquipment, domain.DelayInstruments,
		domain.DelayCleaning, domain.DelayBed, domain.DelayPorters,
		domain.DelayPreviousCase, domain.DelayEmergency, domain.DelayOther,
	} {
		if minutes := u.DelaysByReason[reason]; minutes > 0 {
			out.DelaysByReason = append(out.DelaysByReason, &theatrev1.DelayCount{
				Reason: delayReasonToWire[reason], Minutes: int32(minutes),
			})
		}
	}
	return out
}
