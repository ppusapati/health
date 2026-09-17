// Package transport adapts the emergency service to ConnectRPC.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	emergencyv1 "github.com/ppusapati/health/code/gen/go/healthcare/emergency/v1"
	"github.com/ppusapati/health/code/internal/emergency/application"
	"github.com/ppusapati/health/code/internal/emergency/domain"
)

func timestamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

func fromTimestamp(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var arrivalToProto = map[domain.ArrivalMode]emergencyv1.ArrivalMode{
	domain.ArrivalWalkIn:    emergencyv1.ArrivalMode_ARRIVAL_MODE_WALK_IN,
	domain.ArrivalAmbulance: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
	domain.ArrivalReferral:  emergencyv1.ArrivalMode_ARRIVAL_MODE_REFERRAL,
	domain.ArrivalTransfer:  emergencyv1.ArrivalMode_ARRIVAL_MODE_TRANSFER,
	// ArrivalUnspecified is a stored mode this build cannot read. It goes out
	// as UNSPECIFIED — "not stated" — rather than as any of the four, because
	// a transfer misread as a walk-in is a referring hospital nobody writes
	// back to.
	domain.ArrivalUnspecified: emergencyv1.ArrivalMode_ARRIVAL_MODE_UNSPECIFIED,
}

var arrivalFromProto = map[emergencyv1.ArrivalMode]domain.ArrivalMode{
	emergencyv1.ArrivalMode_ARRIVAL_MODE_WALK_IN:     domain.ArrivalWalkIn,
	emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE:   domain.ArrivalAmbulance,
	emergencyv1.ArrivalMode_ARRIVAL_MODE_REFERRAL:    domain.ArrivalReferral,
	emergencyv1.ArrivalMode_ARRIVAL_MODE_TRANSFER:    domain.ArrivalTransfer,
	emergencyv1.ArrivalMode_ARRIVAL_MODE_UNSPECIFIED: domain.ArrivalWalkIn,
}

var statusToProto = map[domain.VisitStatus]emergencyv1.VisitStatus{
	domain.StatusArrived:     emergencyv1.VisitStatus_VISIT_STATUS_ARRIVED,
	domain.StatusTriaged:     emergencyv1.VisitStatus_VISIT_STATUS_TRIAGED,
	domain.StatusInTreatment: emergencyv1.VisitStatus_VISIT_STATUS_IN_TREATMENT,
	domain.StatusObservation: emergencyv1.VisitStatus_VISIT_STATUS_OBSERVATION,
	domain.StatusDisposed:    emergencyv1.VisitStatus_VISIT_STATUS_DISPOSED,
}

var dispositionToProto = map[domain.Disposition]emergencyv1.Disposition{
	domain.DispositionDischarge:         emergencyv1.Disposition_DISPOSITION_DISCHARGE,
	domain.DispositionObservation:       emergencyv1.Disposition_DISPOSITION_OBSERVATION,
	domain.DispositionAdmission:         emergencyv1.Disposition_DISPOSITION_ADMISSION,
	domain.DispositionTheatre:           emergencyv1.Disposition_DISPOSITION_THEATRE,
	domain.DispositionICU:               emergencyv1.Disposition_DISPOSITION_ICU,
	domain.DispositionTransfer:          emergencyv1.Disposition_DISPOSITION_TRANSFER,
	domain.DispositionLeftAgainstAdvice: emergencyv1.Disposition_DISPOSITION_LEFT_AGAINST_ADVICE,
	domain.DispositionAbsconded:         emergencyv1.Disposition_DISPOSITION_ABSCONDED,
	domain.DispositionDeath:             emergencyv1.Disposition_DISPOSITION_DEATH,
	domain.DispositionReferral:          emergencyv1.Disposition_DISPOSITION_REFERRAL,
	domain.DispositionUnknown:           emergencyv1.Disposition_DISPOSITION_UNSPECIFIED,
}

var dispositionFromProto = map[emergencyv1.Disposition]domain.Disposition{
	emergencyv1.Disposition_DISPOSITION_DISCHARGE:           domain.DispositionDischarge,
	emergencyv1.Disposition_DISPOSITION_OBSERVATION:         domain.DispositionObservation,
	emergencyv1.Disposition_DISPOSITION_ADMISSION:           domain.DispositionAdmission,
	emergencyv1.Disposition_DISPOSITION_THEATRE:             domain.DispositionTheatre,
	emergencyv1.Disposition_DISPOSITION_ICU:                 domain.DispositionICU,
	emergencyv1.Disposition_DISPOSITION_TRANSFER:            domain.DispositionTransfer,
	emergencyv1.Disposition_DISPOSITION_LEFT_AGAINST_ADVICE: domain.DispositionLeftAgainstAdvice,
	emergencyv1.Disposition_DISPOSITION_ABSCONDED:           domain.DispositionAbsconded,
	emergencyv1.Disposition_DISPOSITION_DEATH:               domain.DispositionDeath,
	emergencyv1.Disposition_DISPOSITION_REFERRAL:            domain.DispositionReferral,
	// UNSPECIFIED maps to the domain's "unknown", which Dispose refuses. A
	// client that sent no disposition is told to choose one rather than having
	// one chosen for it.
	emergencyv1.Disposition_DISPOSITION_UNSPECIFIED: domain.DispositionUnknown,
}

var pathwayToProto = map[domain.PathwayKind]emergencyv1.PathwayKind{
	domain.PathwayResuscitation: emergencyv1.PathwayKind_PATHWAY_KIND_RESUSCITATION,
	domain.PathwayTrauma:        emergencyv1.PathwayKind_PATHWAY_KIND_TRAUMA,
	domain.PathwayStroke:        emergencyv1.PathwayKind_PATHWAY_KIND_STROKE,
	domain.PathwaySTEMI:         emergencyv1.PathwayKind_PATHWAY_KIND_STEMI,
	domain.PathwaySepsis:        emergencyv1.PathwayKind_PATHWAY_KIND_SEPSIS,
	domain.PathwayOther:         emergencyv1.PathwayKind_PATHWAY_KIND_OTHER,
	domain.PathwayUnknown:       emergencyv1.PathwayKind_PATHWAY_KIND_UNSPECIFIED,
}

var pathwayFromProto = map[emergencyv1.PathwayKind]domain.PathwayKind{
	emergencyv1.PathwayKind_PATHWAY_KIND_RESUSCITATION: domain.PathwayResuscitation,
	emergencyv1.PathwayKind_PATHWAY_KIND_TRAUMA:        domain.PathwayTrauma,
	emergencyv1.PathwayKind_PATHWAY_KIND_STROKE:        domain.PathwayStroke,
	emergencyv1.PathwayKind_PATHWAY_KIND_STEMI:         domain.PathwaySTEMI,
	emergencyv1.PathwayKind_PATHWAY_KIND_SEPSIS:        domain.PathwaySepsis,
	emergencyv1.PathwayKind_PATHWAY_KIND_OTHER:         domain.PathwayOther,
	emergencyv1.PathwayKind_PATHWAY_KIND_UNSPECIFIED:   domain.PathwayUnknown,
}

var eventKindToProto = map[domain.EventKind]emergencyv1.EventKind{
	domain.EventArrival:          emergencyv1.EventKind_EVENT_KIND_ARRIVAL,
	domain.EventTriage:           emergencyv1.EventKind_EVENT_KIND_TRIAGE,
	domain.EventClinicianSeen:    emergencyv1.EventKind_EVENT_KIND_CLINICIAN_SEEN,
	domain.EventPathwayActivated: emergencyv1.EventKind_EVENT_KIND_PATHWAY_ACTIVATED,
	domain.EventMilestone:        emergencyv1.EventKind_EVENT_KIND_MILESTONE,
	domain.EventAirway:           emergencyv1.EventKind_EVENT_KIND_AIRWAY,
	domain.EventCPR:              emergencyv1.EventKind_EVENT_KIND_CPR,
	domain.EventDefibrillation:   emergencyv1.EventKind_EVENT_KIND_DEFIBRILLATION,
	domain.EventFluid:            emergencyv1.EventKind_EVENT_KIND_FLUID,
	domain.EventDrug:             emergencyv1.EventKind_EVENT_KIND_DRUG,
	domain.EventProcedure:        emergencyv1.EventKind_EVENT_KIND_PROCEDURE,
	domain.EventObservation:      emergencyv1.EventKind_EVENT_KIND_OBSERVATION,
	domain.EventDisposition:      emergencyv1.EventKind_EVENT_KIND_DISPOSITION,
	// An event nobody can classify still happened, and goes out as UNSPECIFIED
	// with its detail intact: a timeline with a silent hole is worse than one
	// with a question mark.
	domain.EventUnknown: emergencyv1.EventKind_EVENT_KIND_UNSPECIFIED,
}

var eventKindFromProto = func() map[emergencyv1.EventKind]domain.EventKind {
	out := make(map[emergencyv1.EventKind]domain.EventKind, len(eventKindToProto))
	for k, v := range eventKindToProto {
		if k == domain.EventUnknown {
			continue
		}
		out[v] = k
	}
	return out
}()

func visitToProto(v domain.Visit, restricted bool) *emergencyv1.EmergencyVisit {
	return &emergencyv1.EmergencyVisit{
		VisitId: v.ID, EncounterId: v.EncounterID, PatientId: v.PatientID,
		FacilityId: v.FacilityID, ArrivalMode: arrivalToProto[v.ArrivalMode],
		ChiefComplaint: v.ChiefComplaint, ArrivedAt: timestamp(v.ArrivedAt),
		Unidentified: v.Unidentified, TemporaryName: v.TemporaryName,
		MedicoLegal: v.MedicoLegal, MedicoLegalRef: v.MedicoLegalRef,
		Status: statusToProto[v.Status], Location: v.Location,
		Disposition:     dispositionToProto[v.Disposition],
		DisposedAt:      timestamp(v.DisposedAt),
		DispositionNote: v.DispositionNote, ReceivingService: v.ReceivingService,
		ObservationStartedAt: timestamp(v.ObservationStartedAt),
		ObservationEndsAt:    timestamp(v.ObservationEndsAt),
		CreatedBy:            v.CreatedBy, CreatedAt: timestamp(v.CreatedAt),
		UpdatedAt: timestamp(v.UpdatedAt), Version: v.Version,
		Restricted: restricted,
	}
}

func triageToProto(t domain.Triage) *emergencyv1.Triage {
	flags := make([]string, 0, len(t.RedFlags))
	for _, flag := range t.RedFlags {
		flags = append(flags, string(flag))
	}
	out := &emergencyv1.Triage{
		TriageId: t.ID, VisitId: t.VisitID,
		ScaleName: t.ScaleName, ScaleVersion: t.ScaleVersion,
		AcuityCode: t.AcuityCode, AcuityRank: int32(t.AcuityRank),
		Consciousness: t.Consciousness, RedFlags: flags,
		MissingFields: t.Missing, Note: t.Note,
		AssessedBy: t.AssessedBy, AssessedAt: timestamp(t.AssessedAt),
	}
	// Optional throughout: a missing observation travels as absent rather than
	// as zero, because a systolic of nought is a different claim from "nobody
	// measured it".
	if t.RespiratoryRate != nil {
		v := int32(*t.RespiratoryRate)
		out.RespiratoryRate = &v
	}
	if t.HeartRate != nil {
		v := int32(*t.HeartRate)
		out.HeartRate = &v
	}
	if t.SystolicBP != nil {
		v := int32(*t.SystolicBP)
		out.SystolicBp = &v
	}
	if t.OxygenSaturation != nil {
		v := int32(*t.OxygenSaturation)
		out.OxygenSaturation = &v
	}
	if t.Temperature != nil {
		out.Temperature = t.Temperature
	}
	if t.PainScore != nil {
		v := int32(*t.PainScore)
		out.PainScore = &v
	}
	return out
}

func targetToProto(t domain.MilestoneTarget) *emergencyv1.MilestoneTarget {
	return &emergencyv1.MilestoneTarget{
		Code: t.Code, Label: t.Label,
		WithinSeconds: int64(t.Within / time.Second),
	}
}

func pathwayToProtoMsg(p domain.Pathway) *emergencyv1.Pathway {
	targets := make([]*emergencyv1.MilestoneTarget, 0, len(p.Targets))
	for _, target := range p.Targets {
		targets = append(targets, targetToProto(target))
	}
	return &emergencyv1.Pathway{
		PathwayId: p.ID, VisitId: p.VisitID, Kind: pathwayToProto[p.Kind],
		Label: p.Label, ActivatedAt: timestamp(p.ActivatedAt),
		ActivatedBy: p.ActivatedBy, NotifiedTeam: p.NotifiedTeam,
		EscalationNoticeId: p.EscalationNoticeID, Targets: targets,
		StoodDownAt: timestamp(p.StoodDownAt), StoodDownReason: p.StoodDownReason,
	}
}

func eventToProto(e domain.Event) *emergencyv1.EmergencyEvent {
	return &emergencyv1.EmergencyEvent{
		EventId: e.ID, VisitId: e.VisitID, Kind: eventKindToProto[e.Kind],
		Detail: e.Detail, OccurredAt: timestamp(e.OccurredAt),
		RecordedAt: timestamp(e.RecordedAt), Sequence: int32(e.Sequence),
		ActorId: e.ActorID, Late: e.Late, PathwayId: e.PathwayID,
		ProtocolId: e.ProtocolID, NeedsReconciliation: e.NeedsReconciliation,
		ReconciledOrderId: e.ReconciledOrderID,
	}
}

func eventsToProto(in domain.Timeline) []*emergencyv1.EmergencyEvent {
	out := make([]*emergencyv1.EmergencyEvent, 0, len(in))
	for _, event := range in {
		out = append(out, eventToProto(event))
	}
	return out
}

func intervalsToProto(in domain.Intervals) *emergencyv1.Intervals {
	out := &emergencyv1.Intervals{}
	if in.DoorToTriage != nil {
		v := int64(*in.DoorToTriage / time.Second)
		out.DoorToTriageSeconds = &v
	}
	if in.DoorToClinician != nil {
		v := int64(*in.DoorToClinician / time.Second)
		out.DoorToClinicianSeconds = &v
	}
	if in.DoorToDisposition != nil {
		v := int64(*in.DoorToDisposition / time.Second)
		out.DoorToDispositionSeconds = &v
	}
	return out
}

func progressToProto(states []domain.MilestoneState) *emergencyv1.MilestoneProgress {
	out := &emergencyv1.MilestoneProgress{
		States: make([]*emergencyv1.MilestoneState, 0, len(states)),
	}
	for _, state := range states {
		out.States = append(out.States, &emergencyv1.MilestoneState{
			Target: targetToProto(state.Target), Reached: state.Reached,
			ReachedAt:      timestamp(state.ReachedAt),
			ElapsedSeconds: int64(state.Elapsed / time.Second),
			Breached:       state.Breached,
		})
	}
	return out
}

func boardRowToProto(row domain.BoardRow) *emergencyv1.BoardRow {
	pathways := make([]emergencyv1.PathwayKind, 0, len(row.Pathways))
	for _, kind := range row.Pathways {
		pathways = append(pathways, pathwayToProto[kind])
	}
	out := &emergencyv1.BoardRow{
		VisitId: row.VisitID, Display: row.Display,
		AcuityRank: int32(row.AcuityRank), ScaleName: row.ScaleName,
		Triaged: row.Triaged, ArrivedAt: timestamp(row.ArrivedAt),
		Status: statusToProto[row.Status], Location: row.Location,
		PendingOrders:      int32(row.PendingOrders),
		DispositionBarrier: row.DispositionBarrier,
		Pathways:           pathways,
		WaitingSeconds:     int64(row.Waiting / time.Second),
		Breaching:          row.Breaching,
		ObservationOverdue: row.ObservationOverdue,
		Restricted:         row.Restricted,
	}
	if row.Override != nil {
		out.Override = &emergencyv1.PriorityOverride{
			AcuityRank: int32(row.Override.Rank), Reason: row.Override.Reason,
			OverriddenBy: row.Override.By, OverriddenAt: timestamp(row.Override.At),
		}
	}
	return out
}

func recordToProto(r application.VisitRecord) *emergencyv1.GetEmergencyVisitResponse {
	out := &emergencyv1.GetEmergencyVisitResponse{
		Visit:     visitToProto(r.Visit, r.Restricted),
		Intervals: intervalsToProto(r.Intervals),
	}
	if r.Restricted {
		// The bed and the clock, and nothing else.
		return out
	}
	for _, t := range r.Triage {
		out.Triage = append(out.Triage, triageToProto(t))
	}
	for _, p := range r.Pathways {
		out.Pathways = append(out.Pathways, pathwayToProtoMsg(p))
	}
	if len(r.Progress) > 0 {
		out.Progress = make(map[string]*emergencyv1.MilestoneProgress, len(r.Progress))
		for id, states := range r.Progress {
			out.Progress[id] = progressToProto(states)
		}
	}
	out.Timeline = eventsToProto(r.Timeline)
	return out
}
