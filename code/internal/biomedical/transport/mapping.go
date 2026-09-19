// Package transport translates between the biomedical contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction: an
// unrecognised criticality stays empty and the domain refuses it rather than
// guessing that a client meant "routine", and an unrecognised asset status
// stays empty so a move becomes a no-op rather than an accidental
// return-to-service.
package transport

import (
	"sort"
	"time"

	biomedicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/biomedical/v1"
	"github.com/ppusapati/health/code/internal/biomedical/application"
	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on the
		// wire, and a calibration due in 1970 would take a working analyser
		// off the floor.
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

var criticalityFromWire = map[biomedicalv1.Criticality]domain.Criticality{
	biomedicalv1.Criticality_CRITICALITY_ROUTINE:      domain.CriticalityRoutine,
	biomedicalv1.Criticality_CRITICALITY_IMPORTANT:    domain.CriticalityImportant,
	biomedicalv1.Criticality_CRITICALITY_CRITICAL:     domain.CriticalityCritical,
	biomedicalv1.Criticality_CRITICALITY_LIFE_SUPPORT: domain.CriticalityLifeSupport,
}

var criticalityToWire = map[domain.Criticality]biomedicalv1.Criticality{
	domain.CriticalityRoutine:     biomedicalv1.Criticality_CRITICALITY_ROUTINE,
	domain.CriticalityImportant:   biomedicalv1.Criticality_CRITICALITY_IMPORTANT,
	domain.CriticalityCritical:    biomedicalv1.Criticality_CRITICALITY_CRITICAL,
	domain.CriticalityLifeSupport: biomedicalv1.Criticality_CRITICALITY_LIFE_SUPPORT,
}

var assetStatusFromWire = map[biomedicalv1.AssetStatus]domain.AssetStatus{
	biomedicalv1.AssetStatus_ASSET_STATUS_IN_SERVICE:        domain.AssetInService,
	biomedicalv1.AssetStatus_ASSET_STATUS_UNDER_MAINTENANCE: domain.AssetUnderMaintenance,
	biomedicalv1.AssetStatus_ASSET_STATUS_AWAITING_PARTS:    domain.AssetAwaitingParts,
	biomedicalv1.AssetStatus_ASSET_STATUS_OUT_OF_SERVICE:    domain.AssetOutOfService,
	// Deliberately no mapping for DISPOSED. Disposal needs an approval and
	// sanitisation evidence, so it has its own RPC — and the domain refuses
	// it as a status change anyway. Two controls rather than one.
	biomedicalv1.AssetStatus_ASSET_STATUS_DECOMMISSIONED: domain.AssetDecommissioned,
}

var assetStatusToWire = map[domain.AssetStatus]biomedicalv1.AssetStatus{
	domain.AssetInService:        biomedicalv1.AssetStatus_ASSET_STATUS_IN_SERVICE,
	domain.AssetUnderMaintenance: biomedicalv1.AssetStatus_ASSET_STATUS_UNDER_MAINTENANCE,
	domain.AssetAwaitingParts:    biomedicalv1.AssetStatus_ASSET_STATUS_AWAITING_PARTS,
	domain.AssetOutOfService:     biomedicalv1.AssetStatus_ASSET_STATUS_OUT_OF_SERVICE,
	domain.AssetDecommissioned:   biomedicalv1.AssetStatus_ASSET_STATUS_DECOMMISSIONED,
	domain.AssetDisposed:         biomedicalv1.AssetStatus_ASSET_STATUS_DISPOSED,
}

var contractKindFromWire = map[biomedicalv1.ContractKind]domain.ContractKind{
	biomedicalv1.ContractKind_CONTRACT_KIND_WARRANTY: domain.ContractWarranty,
	biomedicalv1.ContractKind_CONTRACT_KIND_AMC:      domain.ContractAMC,
	biomedicalv1.ContractKind_CONTRACT_KIND_CMC:      domain.ContractCMC,
}

var contractKindToWire = map[domain.ContractKind]biomedicalv1.ContractKind{
	domain.ContractWarranty: biomedicalv1.ContractKind_CONTRACT_KIND_WARRANTY,
	domain.ContractAMC:      biomedicalv1.ContractKind_CONTRACT_KIND_AMC,
	domain.ContractCMC:      biomedicalv1.ContractKind_CONTRACT_KIND_CMC,
}

var planBasisFromWire = map[biomedicalv1.PlanBasis]domain.PlanBasis{
	biomedicalv1.PlanBasis_PLAN_BASIS_INTERVAL: domain.BasisInterval,
	biomedicalv1.PlanBasis_PLAN_BASIS_RUNTIME:  domain.BasisRuntime,
	biomedicalv1.PlanBasis_PLAN_BASIS_RISK:     domain.BasisRisk,
}

var planBasisToWire = map[domain.PlanBasis]biomedicalv1.PlanBasis{
	domain.BasisInterval: biomedicalv1.PlanBasis_PLAN_BASIS_INTERVAL,
	domain.BasisRuntime:  biomedicalv1.PlanBasis_PLAN_BASIS_RUNTIME,
	domain.BasisRisk:     biomedicalv1.PlanBasis_PLAN_BASIS_RISK,
}

var dueStateToWire = map[domain.DueState]biomedicalv1.DueState{
	domain.DueNotYet:  biomedicalv1.DueState_DUE_STATE_NOT_DUE,
	domain.DueSoon:    biomedicalv1.DueState_DUE_STATE_DUE_SOON,
	domain.DueNow:     biomedicalv1.DueState_DUE_STATE_DUE,
	domain.DueOverdue: biomedicalv1.DueState_DUE_STATE_OVERDUE,
}

var ticketKindFromWire = map[biomedicalv1.TicketKind]domain.TicketKind{
	biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE:  domain.KindCorrective,
	biomedicalv1.TicketKind_TICKET_KIND_PREVENTIVE:  domain.KindPreventive,
	biomedicalv1.TicketKind_TICKET_KIND_CALIBRATION: domain.KindCalibration,
	biomedicalv1.TicketKind_TICKET_KIND_INSPECTION:  domain.KindInspection,
}

var ticketKindToWire = map[domain.TicketKind]biomedicalv1.TicketKind{
	domain.KindCorrective:  biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE,
	domain.KindPreventive:  biomedicalv1.TicketKind_TICKET_KIND_PREVENTIVE,
	domain.KindCalibration: biomedicalv1.TicketKind_TICKET_KIND_CALIBRATION,
	domain.KindInspection:  biomedicalv1.TicketKind_TICKET_KIND_INSPECTION,
}

var priorityFromWire = map[biomedicalv1.Priority]domain.Priority{
	biomedicalv1.Priority_PRIORITY_LOW:       domain.PriorityLow,
	biomedicalv1.Priority_PRIORITY_NORMAL:    domain.PriorityNormal,
	biomedicalv1.Priority_PRIORITY_HIGH:      domain.PriorityHigh,
	biomedicalv1.Priority_PRIORITY_EMERGENCY: domain.PriorityEmergency,
}

var priorityToWire = map[domain.Priority]biomedicalv1.Priority{
	domain.PriorityLow:       biomedicalv1.Priority_PRIORITY_LOW,
	domain.PriorityNormal:    biomedicalv1.Priority_PRIORITY_NORMAL,
	domain.PriorityHigh:      biomedicalv1.Priority_PRIORITY_HIGH,
	domain.PriorityEmergency: biomedicalv1.Priority_PRIORITY_EMERGENCY,
}

var impactFromWire = map[biomedicalv1.Impact]domain.Impact{
	biomedicalv1.Impact_IMPACT_NONE:             domain.ImpactNone,
	biomedicalv1.Impact_IMPACT_DEGRADED:         domain.ImpactDegraded,
	biomedicalv1.Impact_IMPACT_SERVICE_STOPPED:  domain.ImpactServiceStopped,
	biomedicalv1.Impact_IMPACT_PATIENT_AFFECTED: domain.ImpactPatientAffected,
}

var impactToWire = map[domain.Impact]biomedicalv1.Impact{
	domain.ImpactNone:            biomedicalv1.Impact_IMPACT_NONE,
	domain.ImpactDegraded:        biomedicalv1.Impact_IMPACT_DEGRADED,
	domain.ImpactServiceStopped:  biomedicalv1.Impact_IMPACT_SERVICE_STOPPED,
	domain.ImpactPatientAffected: biomedicalv1.Impact_IMPACT_PATIENT_AFFECTED,
}

var ticketStateFromWire = map[biomedicalv1.TicketState]domain.TicketState{
	biomedicalv1.TicketState_TICKET_STATE_OPEN:           domain.TicketOpen,
	biomedicalv1.TicketState_TICKET_STATE_ASSIGNED:       domain.TicketAssigned,
	biomedicalv1.TicketState_TICKET_STATE_IN_PROGRESS:    domain.TicketInProgress,
	biomedicalv1.TicketState_TICKET_STATE_AWAITING_PARTS: domain.TicketAwaitingParts,
	biomedicalv1.TicketState_TICKET_STATE_RESOLVED:       domain.TicketResolved,
	biomedicalv1.TicketState_TICKET_STATE_CLOSED:         domain.TicketClosed,
	biomedicalv1.TicketState_TICKET_STATE_CANCELLED:      domain.TicketCancelled,
}

var ticketStateToWire = map[domain.TicketState]biomedicalv1.TicketState{
	domain.TicketOpen:          biomedicalv1.TicketState_TICKET_STATE_OPEN,
	domain.TicketAssigned:      biomedicalv1.TicketState_TICKET_STATE_ASSIGNED,
	domain.TicketInProgress:    biomedicalv1.TicketState_TICKET_STATE_IN_PROGRESS,
	domain.TicketAwaitingParts: biomedicalv1.TicketState_TICKET_STATE_AWAITING_PARTS,
	domain.TicketResolved:      biomedicalv1.TicketState_TICKET_STATE_RESOLVED,
	domain.TicketClosed:        biomedicalv1.TicketState_TICKET_STATE_CLOSED,
	domain.TicketCancelled:     biomedicalv1.TicketState_TICKET_STATE_CANCELLED,
}

var noticeKindFromWire = map[biomedicalv1.NoticeKind]domain.NoticeKind{
	biomedicalv1.NoticeKind_NOTICE_KIND_RECALL:       domain.NoticeRecall,
	biomedicalv1.NoticeKind_NOTICE_KIND_FIELD_SAFETY: domain.NoticeFieldSafety,
	biomedicalv1.NoticeKind_NOTICE_KIND_ADVISORY:     domain.NoticeAdvisory,
}

var noticeKindToWire = map[domain.NoticeKind]biomedicalv1.NoticeKind{
	domain.NoticeRecall:      biomedicalv1.NoticeKind_NOTICE_KIND_RECALL,
	domain.NoticeFieldSafety: biomedicalv1.NoticeKind_NOTICE_KIND_FIELD_SAFETY,
	domain.NoticeAdvisory:    biomedicalv1.NoticeKind_NOTICE_KIND_ADVISORY,
}

var taskStateFromWire = map[biomedicalv1.TaskState]domain.TaskState{
	biomedicalv1.TaskState_TASK_STATE_OUTSTANDING:  domain.TaskOutstanding,
	biomedicalv1.TaskState_TASK_STATE_INSPECTED:    domain.TaskInspected,
	biomedicalv1.TaskState_TASK_STATE_CORRECTED:    domain.TaskCorrected,
	biomedicalv1.TaskState_TASK_STATE_NOT_AFFECTED: domain.TaskNotAffected,
	biomedicalv1.TaskState_TASK_STATE_QUARANTINED:  domain.TaskQuarantined,
}

var taskStateToWire = map[domain.TaskState]biomedicalv1.TaskState{
	domain.TaskOutstanding: biomedicalv1.TaskState_TASK_STATE_OUTSTANDING,
	domain.TaskInspected:   biomedicalv1.TaskState_TASK_STATE_INSPECTED,
	domain.TaskCorrected:   biomedicalv1.TaskState_TASK_STATE_CORRECTED,
	domain.TaskNotAffected: biomedicalv1.TaskState_TASK_STATE_NOT_AFFECTED,
	domain.TaskQuarantined: biomedicalv1.TaskState_TASK_STATE_QUARANTINED,
}

var expiryKindToWire = map[string]biomedicalv1.ExpiryKind{
	domain.ExpiryContract:    biomedicalv1.ExpiryKind_EXPIRY_KIND_CONTRACT,
	domain.ExpiryCalibration: biomedicalv1.ExpiryKind_EXPIRY_KIND_CALIBRATION,
}

// assetToProto renders one asset, deriving why it cannot be used right now.
//
// Derived at the moment of rendering rather than stored: a calibration that
// lapsed an hour ago has lapsed whether or not a job has run, and a stored
// flag would say the machine is fine.
func assetToProto(a domain.Asset, now time.Time,
	blockOnCalibration bool) *biomedicalv1.Asset {

	return &biomedicalv1.Asset{
		AssetId: a.ID, Tag: a.Tag, Udi: a.UDI, Serial: a.Serial,
		Make: a.Make, Model: a.Model, Category: a.Category,
		Criticality: criticalityToWire[a.Criticality],
		Status:      assetStatusToWire[a.Status],
		LocationId:  a.LocationID, Department: a.Department,
		Capabilities:           a.Capabilities,
		AcquiredOn:             stamp(a.AcquiredOn),
		AcquisitionCostMinor:   a.AcquisitionCostMinor,
		ExpectedLifeYears:      int32(a.ExpectedLifeYears),
		CalibrationRequired:    a.CalibrationRequired,
		CalibrationDue:         stamp(a.CalibrationDue),
		CalibrationCertificate: a.CalibrationCertificate,
		SafetyHold:             a.SafetyHold,
		SafetyHoldReason:       a.SafetyHoldReason,
		Notes:                  a.Notes,
		CreatedAt:              stamp(a.CreatedAt),
		CreatedBy:              a.CreatedBy,
		Version:                a.Version,
		UnusableReasons:        a.Unusable(now, blockOnCalibration),
	}
}

func contractToProto(c domain.ServiceContract) *biomedicalv1.ServiceContract {
	return &biomedicalv1.ServiceContract{
		ContractId: c.ID, AssetId: c.AssetID,
		Kind: contractKindToWire[c.Kind], Reference: c.Reference,
		VendorName: c.VendorName, VendorContact: c.VendorContact,
		VendorPhone: c.VendorPhone, VendorEmail: c.VendorEmail,
		StartsOn: stamp(c.StartsOn), EndsOn: stamp(c.EndsOn),
		ValueMinor:      c.ValueMinor,
		ResponseHours:   int32(c.ResponseHours),
		ResolutionHours: int32(c.ResolutionHours),
		Notes:           c.Notes,
		CreatedAt:       stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
		Version: c.Version,
	}
}

func expiryToProto(e domain.Expiry) *biomedicalv1.Expiry {
	return &biomedicalv1.Expiry{
		Kind: expiryKindToWire[e.Kind], AssetId: e.AssetID,
		AssetTag: e.AssetTag, Reference: e.Reference,
		VendorName: e.VendorName, ExpiresOn: stamp(e.ExpiresOn),
		DaysRemaining: int32(e.DaysRemaining), Detail: e.Detail,
	}
}

func planToProto(p domain.PMPlan) *biomedicalv1.PMPlan {
	return &biomedicalv1.PMPlan{
		PlanId: p.ID, AssetId: p.AssetID,
		Basis:            planBasisToWire[p.Basis],
		IntervalDays:     int32(p.IntervalDays),
		RuntimeHours:     int32(p.RuntimeHours),
		Procedure:        p.Procedure,
		EstimatedMinutes: int32(p.EstimatedMinutes),
		LastPerformedAt:  stamp(p.LastPerformedAt),
		LastRuntimeHours: int32(p.LastRuntimeHours),
		Active:           p.Active,
		CreatedAt:        stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		Version: p.Version,
	}
}

func dueToProto(d domain.Due) *biomedicalv1.Due {
	return &biomedicalv1.Due{
		PlanId: d.PlanID, AssetId: d.AssetID, AssetTag: d.AssetTag,
		Basis: planBasisToWire[d.Basis], Procedure: d.Procedure,
		Criticality:    criticalityToWire[d.Criticality],
		State:          dueStateToWire[d.State],
		DueOn:          stamp(d.DueOn),
		DaysOverdue:    int32(d.DaysOverdue),
		HoursRemaining: int32(d.HoursRemaining),
		Unanswerable:   d.Unanswerable,
	}
}

func partsToProto(parts []domain.PartUsed) []*biomedicalv1.PartUsed {
	out := make([]*biomedicalv1.PartUsed, 0, len(parts))
	for _, part := range parts {
		out = append(out, &biomedicalv1.PartUsed{
			Code: part.Code, Description: part.Description,
			MaterialsItemId:   part.MaterialsItemID,
			Quantity:          int32(part.Quantity),
			CostMinor:         part.CostMinor,
			CoveredByContract: part.CoveredByContract,
		})
	}
	return out
}

func partsFromProto(parts []*biomedicalv1.PartUsed) []domain.PartUsed {
	out := make([]domain.PartUsed, 0, len(parts))
	for _, part := range parts {
		out = append(out, domain.PartUsed{
			Code: part.GetCode(), Description: part.GetDescription(),
			MaterialsItemID:   part.GetMaterialsItemId(),
			Quantity:          int(part.GetQuantity()),
			CostMinor:         part.GetCostMinor(),
			CoveredByContract: part.GetCoveredByContract(),
		})
	}
	return out
}

func ticketToProto(t domain.Ticket) *biomedicalv1.Ticket {
	return &biomedicalv1.Ticket{
		TicketId: t.ID, Number: t.Number,
		Kind:    ticketKindToWire[t.Kind],
		AssetId: t.AssetID, PlanId: t.PlanID, AssetTag: t.AssetTag,
		LocationId: t.LocationID, Symptom: t.Symptom,
		Priority:  priorityToWire[t.Priority],
		Impact:    impactToWire[t.Impact],
		State:     ticketStateToWire[t.State],
		OwnerId:   t.OwnerID,
		RespondBy: stamp(t.RespondBy), ResolveBy: stamp(t.ResolveBy),
		ContractId: t.ContractID,
		Diagnosis:  t.Diagnosis, WorkPerformed: t.WorkPerformed,
		Parts:    partsToProto(t.Parts),
		DownFrom: stamp(t.DownFrom), DownUntil: stamp(t.DownUntil),
		AwaitingPartsMinutes: int32(t.AwaitingPartsMinutes),
		RespondedAt:          stamp(t.RespondedAt),
		ResolvedAt:           stamp(t.ResolvedAt),
		ClosedAt:             stamp(t.ClosedAt),
		ClosedBy:             t.ClosedBy,
		ClosureNote:          t.ClosureNote,
		CancelledReason:      t.CancelledReason,
		RaisedAt:             stamp(t.RaisedAt), RaisedBy: t.RaisedBy,
		Version: t.Version,
	}
}

func noticeToProto(n domain.SafetyNotice) *biomedicalv1.SafetyNotice {
	return &biomedicalv1.SafetyNotice{
		NoticeId: n.ID, Reference: n.Reference,
		Kind: noticeKindToWire[n.Kind], Issuer: n.Issuer, Summary: n.Summary,
		Make: n.Make, Model: n.Model,
		SerialFrom: n.SerialFrom, SerialTo: n.SerialTo,
		AffectedUdi: n.AffectedUDI, HoldAffected: n.HoldAffected,
		RequiredAction: n.RequiredAction,
		DueBy:          stamp(n.DueBy), IssuedOn: stamp(n.IssuedOn),
		RaisedAt: stamp(n.RaisedAt), RaisedBy: n.RaisedBy,
		ClosedAt: stamp(n.ClosedAt), ClosedBy: n.ClosedBy,
		ClosureNote: n.ClosureNote, Version: n.Version,
	}
}

func taskToProto(t domain.NoticeTask) *biomedicalv1.NoticeTask {
	return &biomedicalv1.NoticeTask{
		TaskId: t.ID, NoticeId: t.NoticeID,
		AssetId: t.AssetID, AssetTag: t.AssetTag,
		State: taskStateToWire[t.State], Note: t.Note,
		CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
	}
}

func readingToProto(r domain.Reading) *biomedicalv1.Reading {
	return &biomedicalv1.Reading{
		ReadingId: r.ID, AssetId: r.AssetID, Metric: r.Metric,
		Value: r.Value, Unit: r.Unit, Source: r.Source, Ingested: r.Ingested,
		ObservedAt: stamp(r.ObservedAt), RecordedAt: stamp(r.RecordedAt),
		RecordedBy: r.RecordedBy,
	}
}

func metricsToProto(m domain.Metrics) *biomedicalv1.Metrics {
	return &biomedicalv1.Metrics{
		AssetId: m.AssetID, AssetTag: m.AssetTag,
		From: stamp(m.From), To: stamp(m.To),
		PeriodMinutes:          int32(m.PeriodMinutes),
		DowntimeMinutes:        int32(m.DowntimeMinutes),
		UptimeMinutes:          int32(m.UptimeMinutes),
		UptimePercent:          m.UptimePercent,
		Failures:               int32(m.Failures),
		PlannedDowntimeMinutes: int32(m.PlannedDowntimeMinutes),
		MtbfHours:              m.MTBFHours,
		MttrHours:              m.MTTRHours,
		PmDue:                  int32(m.PMDue),
		PmDone:                 int32(m.PMDone),
		PmCompliance:           m.PMCompliance,
		Incomplete:             m.Incomplete,
	}
}

func disposalToProto(d domain.Disposal) *biomedicalv1.Disposal {
	return &biomedicalv1.Disposal{
		DisposalId: d.ID, AssetId: d.AssetID, AssetTag: d.AssetTag,
		Method: d.Method, Reason: d.Reason,
		RequestedBy: d.RequestedBy, ApprovedBy: d.ApprovedBy,
		ApprovedAt:              stamp(d.ApprovedAt),
		SanitisationRequired:    d.SanitisationRequired,
		SanitisationMethod:      d.SanitisationMethod,
		SanitisationCertificate: d.SanitisationCertificate,
		SanitisedBy:             d.SanitisedBy,
		Recipient:               d.Recipient,
		ProceedsMinor:           d.ProceedsMinor,
		DisposedAt:              stamp(d.DisposedAt),
		RecordedBy:              d.RecordedBy,
	}
}

func capabilityToProto(c application.Capability) *biomedicalv1.GetLocationCapabilityResponse {
	available := make(map[string]int32, len(c.Available))
	for name, count := range c.Available {
		available[name] = int32(count)
	}
	unusable := make([]*biomedicalv1.UnusableAsset, 0, len(c.Unusable))
	for tag, reasons := range c.Unusable {
		unusable = append(unusable, &biomedicalv1.UnusableAsset{
			Tag: tag, Reasons: reasons,
		})
	}
	sortUnusable(unusable)
	return &biomedicalv1.GetLocationCapabilityResponse{
		LocationId: c.LocationID, Available: available,
		Unavailable: c.Unavailable, Unusable: unusable,
		ObservedAt: stamp(c.ObservedAt),
	}
}

// sortUnusable orders by tag, because a map's iteration order is random and a
// list that reorders between two reads of the same room looks like a change.
func sortUnusable(in []*biomedicalv1.UnusableAsset) {
	sort.Slice(in, func(i, j int) bool { return in[i].GetTag() < in[j].GetTag() })
}
