// Package transport is the facilities ConnectRPC surface.
package transport

import (
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"

	facilitiesv1 "github.com/ppusapati/health/code/gen/go/healthcare/facilities/v1"
	"github.com/ppusapati/health/code/internal/facilities/application"
	"github.com/ppusapati/health/code/internal/facilities/domain"
)

// Enum tables rather than switch statements.
//
// A map with an entry per value fails loudly when a value is added to the
// proto and not here: the zero value comes back, which a test catches. A
// switch with a default silently maps the new value onto whatever the default
// is, which is how an unknown severity becomes "info".

var systemToWire = map[domain.System]facilitiesv1.System{
	domain.SystemElectrical: facilitiesv1.System_SYSTEM_ELECTRICAL,
	domain.SystemHVAC:       facilitiesv1.System_SYSTEM_HVAC,
	domain.SystemPlumbing:   facilitiesv1.System_SYSTEM_PLUMBING,
	domain.SystemFire:       facilitiesv1.System_SYSTEM_FIRE,
	domain.SystemMedicalGas: facilitiesv1.System_SYSTEM_MEDICAL_GAS,
	domain.SystemLifts:      facilitiesv1.System_SYSTEM_LIFTS,
	domain.SystemWater:      facilitiesv1.System_SYSTEM_WATER,
	domain.SystemEffluent:   facilitiesv1.System_SYSTEM_EFFLUENT,
	domain.SystemPower:      facilitiesv1.System_SYSTEM_POWER,
	domain.SystemOther:      facilitiesv1.System_SYSTEM_OTHER,
}

var systemFromWire = invert(systemToWire)

var criticalityToWire = map[domain.Criticality]facilitiesv1.Criticality{
	domain.CriticalityLife:   facilitiesv1.Criticality_CRITICALITY_LIFE,
	domain.CriticalityHigh:   facilitiesv1.Criticality_CRITICALITY_HIGH,
	domain.CriticalityNormal: facilitiesv1.Criticality_CRITICALITY_NORMAL,
	domain.CriticalityLow:    facilitiesv1.Criticality_CRITICALITY_LOW,
}

var criticalityFromWire = invert(criticalityToWire)

var assetStatusToWire = map[domain.AssetStatus]facilitiesv1.AssetStatus{
	domain.AssetInService: facilitiesv1.AssetStatus_ASSET_STATUS_IN_SERVICE,
	domain.AssetDegraded:  facilitiesv1.AssetStatus_ASSET_STATUS_DEGRADED,
	domain.AssetDown:      facilitiesv1.AssetStatus_ASSET_STATUS_DOWN,
	domain.AssetDecommissioned: facilitiesv1.
		AssetStatus_ASSET_STATUS_DECOMMISSIONED,
}

var assetStatusFromWire = invert(assetStatusToWire)

var priorityToWire = map[domain.Priority]facilitiesv1.Priority{
	domain.PriorityEmergency: facilitiesv1.Priority_PRIORITY_EMERGENCY,
	domain.PriorityUrgent:    facilitiesv1.Priority_PRIORITY_URGENT,
	domain.PriorityRoutine:   facilitiesv1.Priority_PRIORITY_ROUTINE,
	domain.PriorityPlanned:   facilitiesv1.Priority_PRIORITY_PLANNED,
}

var priorityFromWire = invert(priorityToWire)

var workStateToWire = map[domain.WorkState]facilitiesv1.WorkState{
	domain.WorkRaised:     facilitiesv1.WorkState_WORK_STATE_RAISED,
	domain.WorkAssigned:   facilitiesv1.WorkState_WORK_STATE_ASSIGNED,
	domain.WorkInProgress: facilitiesv1.WorkState_WORK_STATE_IN_PROGRESS,
	domain.WorkOnHold:     facilitiesv1.WorkState_WORK_STATE_ON_HOLD,
	domain.WorkResolved:   facilitiesv1.WorkState_WORK_STATE_RESOLVED,
	domain.WorkClosed:     facilitiesv1.WorkState_WORK_STATE_CLOSED,
	domain.WorkCancelled:  facilitiesv1.WorkState_WORK_STATE_CANCELLED,
}

var workStateFromWire = invert(workStateToWire)

var kindToWire = map[domain.MaintenanceKind]facilitiesv1.MaintenanceKind{
	domain.MaintenancePreventive: facilitiesv1.
		MaintenanceKind_MAINTENANCE_KIND_PREVENTIVE,
	domain.MaintenanceStatutory: facilitiesv1.
		MaintenanceKind_MAINTENANCE_KIND_STATUTORY,
}

var kindFromWire = invert(kindToWire)

var triggerToWire = map[domain.Trigger]facilitiesv1.Trigger{
	domain.TriggerCalendar: facilitiesv1.Trigger_TRIGGER_CALENDAR,
	domain.TriggerRuntime:  facilitiesv1.Trigger_TRIGGER_RUNTIME,
	domain.TriggerEither:   facilitiesv1.Trigger_TRIGGER_EITHER,
}

var triggerFromWire = invert(triggerToWire)

var taskStateToWire = map[domain.TaskState]facilitiesv1.TaskState{
	domain.TaskPlanned: facilitiesv1.TaskState_TASK_STATE_PLANNED,
	domain.TaskDone:    facilitiesv1.TaskState_TASK_STATE_DONE,
	domain.TaskMissed:  facilitiesv1.TaskState_TASK_STATE_MISSED,
	domain.TaskWaived:  facilitiesv1.TaskState_TASK_STATE_WAIVED,
}

var taskStateFromWire = invert(taskStateToWire)

var sourceToWire = map[domain.Source]facilitiesv1.Source{
	domain.SourceManual:     facilitiesv1.Source_SOURCE_MANUAL,
	domain.SourceSCADA:      facilitiesv1.Source_SOURCE_SCADA,
	domain.SourceBMS:        facilitiesv1.Source_SOURCE_BMS,
	domain.SourceAMI:        facilitiesv1.Source_SOURCE_AMI,
	domain.SourceVendor:     facilitiesv1.Source_SOURCE_VENDOR,
	domain.SourceCalculated: facilitiesv1.Source_SOURCE_CALCULATED,
}

var sourceFromWire = invert(sourceToWire)

var utilityToWire = map[domain.Utility]facilitiesv1.Utility{
	domain.UtilityElectricity: facilitiesv1.Utility_UTILITY_ELECTRICITY,
	domain.UtilityWater:       facilitiesv1.Utility_UTILITY_WATER,
	domain.UtilityDiesel:      facilitiesv1.Utility_UTILITY_DIESEL,
	domain.UtilityOxygen:      facilitiesv1.Utility_UTILITY_OXYGEN,
	domain.UtilityLPG:         facilitiesv1.Utility_UTILITY_LPG,
	domain.UtilitySteam:       facilitiesv1.Utility_UTILITY_STEAM,
	domain.UtilityEffluent:    facilitiesv1.Utility_UTILITY_EFFLUENT,
}

var utilityFromWire = invert(utilityToWire)

var outageStateToWire = map[domain.OutageState]facilitiesv1.OutageState{
	domain.OutagePlanned:   facilitiesv1.OutageState_OUTAGE_STATE_PLANNED,
	domain.OutageApproved:  facilitiesv1.OutageState_OUTAGE_STATE_APPROVED,
	domain.OutageInEffect:  facilitiesv1.OutageState_OUTAGE_STATE_IN_EFFECT,
	domain.OutageRestored:  facilitiesv1.OutageState_OUTAGE_STATE_RESTORED,
	domain.OutageCancelled: facilitiesv1.OutageState_OUTAGE_STATE_CANCELLED,
}

var severityToWire = map[domain.Severity]facilitiesv1.Severity{
	domain.SeverityCritical: facilitiesv1.Severity_SEVERITY_CRITICAL,
	domain.SeverityMajor:    facilitiesv1.Severity_SEVERITY_MAJOR,
	domain.SeverityMinor:    facilitiesv1.Severity_SEVERITY_MINOR,
	domain.SeverityInfo:     facilitiesv1.Severity_SEVERITY_INFO,
}

var severityFromWire = invert(severityToWire)

var alarmStateToWire = map[domain.AlarmState]facilitiesv1.AlarmState{
	domain.AlarmActive:  facilitiesv1.AlarmState_ALARM_STATE_ACTIVE,
	domain.AlarmCleared: facilitiesv1.AlarmState_ALARM_STATE_CLEARED,
}

var alarmStateFromWire = invert(alarmStateToWire)

var deficiencyStateToWire = map[domain.DeficiencyState]facilitiesv1.
	DeficiencyState{
	domain.DeficiencyOpen: facilitiesv1.
		DeficiencyState_DEFICIENCY_STATE_OPEN,
	domain.DeficiencyMitigated: facilitiesv1.
		DeficiencyState_DEFICIENCY_STATE_MITIGATED,
	domain.DeficiencyClosed: facilitiesv1.
		DeficiencyState_DEFICIENCY_STATE_CLOSED,
}

var visitStateToWire = map[domain.VisitState]facilitiesv1.VisitState{
	domain.VisitOnSite:   facilitiesv1.VisitState_VISIT_STATE_ON_SITE,
	domain.VisitDeparted: facilitiesv1.VisitState_VISIT_STATE_DEPARTED,
}

// invert builds the wire-to-domain direction from the domain-to-wire one, so
// the two cannot drift. A hand-written second table is where a value gets
// mapped one way and not the other.
func invert[D comparable, W comparable](in map[D]W) map[W]D {
	out := make(map[W]D, len(in))
	for domainValue, wireValue := range in {
		out[wireValue] = domainValue
	}
	return out
}

func stampOf(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

// textOf renders an optional timestamp for an application input, which takes
// RFC 3339 strings. Absent stays absent: a zero time somebody meant and a
// field nobody filled in are different facts.
func textOf(t *timestamppb.Timestamp) string {
	if t == nil || !t.IsValid() {
		return ""
	}
	return t.AsTime().UTC().Format(time.RFC3339)
}

func assetToWire(a domain.Asset) *facilitiesv1.Asset {
	return &facilitiesv1.Asset{
		AssetId: a.ID, Tag: a.Tag, Name: a.Name,
		System:      systemToWire[a.System],
		Criticality: criticalityToWire[a.Criticality],
		ParentId:    a.ParentID, FacilityId: a.FacilityID,
		LocationId: a.LocationID, LocationNote: a.LocationNote,
		Status:       assetStatusToWire[a.Status],
		StatusReason: a.StatusReason, StatusAt: stampOf(a.StatusAt),
		Manufacturer: a.Manufacturer, Model: a.Model,
		SerialNumber:   a.SerialNumber,
		CommissionedAt: stampOf(a.CommissionedAt),
		RuntimeHours:   int32(a.RuntimeHours),
		RuntimeAt:      stampOf(a.RuntimeAt),
		CreatedAt:      stampOf(a.CreatedAt), CreatedBy: a.CreatedBy,
		Version: a.Version,
	}
}

func assetsToWire(in []domain.Asset) []*facilitiesv1.Asset {
	out := make([]*facilitiesv1.Asset, 0, len(in))
	for _, a := range in {
		out = append(out, assetToWire(a))
	}
	return out
}

func classToWire(c domain.WorkClass) *facilitiesv1.WorkClass {
	return &facilitiesv1.WorkClass{
		Code: c.Code, Name: c.Name,
		RequiresPermit: c.RequiresPermit, RequiresLoto: c.RequiresLOTO,
		Active: c.Active, Note: c.Note,
	}
}

func workToWire(w domain.WorkOrder) *facilitiesv1.WorkOrder {
	return &facilitiesv1.WorkOrder{
		WorkOrderId: w.ID, Number: w.Number,
		FacilityId: w.FacilityID, AssetId: w.AssetID,
		System:     systemToWire[w.System],
		LocationId: w.LocationID, LocationNote: w.LocationNote,
		Fault: w.Fault, Impact: w.Impact,
		Priority:            priorityToWire[w.Priority],
		ClassCode:           w.ClassCode,
		ClassRequiresPermit: w.ClassRequiresPermit,
		ClassRequiresLoto:   w.ClassRequiresLOTO,
		OwnerTeam:           w.OwnerTeam, OwnerUserId: w.OwnerUserID,
		State:    workStateToWire[w.State],
		RaisedAt: stampOf(w.RaisedAt), RaisedBy: w.RaisedBy,
		RespondBy: stampOf(w.RespondBy), ResolveBy: stampOf(w.ResolveBy),
		RespondedAt: stampOf(w.RespondedAt),
		StartedAt:   stampOf(w.StartedAt),
		ResolvedAt:  stampOf(w.ResolvedAt),
		ClosedAt:    stampOf(w.ClosedAt), ClosedBy: w.ClosedBy,
		PermitRef: w.PermitRef, PermitIssuedBy: w.PermitIssuedBy,
		LotoRef: w.LOTORef, LotoAppliedBy: w.LOTOAppliedBy,
		CompletionNote:  w.CompletionNote,
		RootCause:       w.RootCause,
		DowntimeMinutes: int32(w.DowntimeMinutes),
		HoldReason:      w.HoldReason, CancelReason: w.CancelReason,
		Version: w.Version,
	}
}

func workOrdersToWire(in []domain.WorkOrder) []*facilitiesv1.WorkOrder {
	out := make([]*facilitiesv1.WorkOrder, 0, len(in))
	for _, w := range in {
		out = append(out, workToWire(w))
	}
	return out
}

func breachToWire(b domain.Breach) *facilitiesv1.Breach {
	return &facilitiesv1.Breach{
		Response: b.Response, Resolution: b.Resolution,
		ResponseLateMinutes:   int32(b.ResponseLateMinutes),
		ResolutionLateMinutes: int32(b.ResolutionLateMinutes),
	}
}

func scheduleToWire(s domain.Schedule) *facilitiesv1.Schedule {
	return &facilitiesv1.Schedule{
		ScheduleId: s.ID, AssetId: s.AssetID,
		FacilityId: s.FacilityID, Title: s.Title,
		Kind: kindToWire[s.Kind], Trigger: triggerToWire[s.Trigger],
		IntervalDays:         int32(s.IntervalDays),
		IntervalRuntimeHours: int32(s.IntervalRuntimeHours),
		Authority:            s.Authority,
		RequiresEvidence:     s.RequiresEvidence,
		WorkClassCode:        s.WorkClassCode,
		GraceDays:            int32(s.GraceDays),
		Active:               s.Active, Version: s.Version,
	}
}

func taskToWire(t domain.Task) *facilitiesv1.Task {
	return &facilitiesv1.Task{
		TaskId: t.ID, ScheduleId: t.ScheduleID,
		AssetId: t.AssetID, FacilityId: t.FacilityID, Title: t.Title,
		ScheduleKind:             kindToWire[t.ScheduleKind],
		ScheduleRequiresEvidence: t.ScheduleRequiresEvidence,
		DueAt:                    stampOf(t.DueAt),
		DueRuntimeHours:          int32(t.DueRuntimeHours),
		TriggeredBy:              triggerToWire[t.TriggeredBy],
		State:                    taskStateToWire[t.State],
		DoneAt:                   stampOf(t.DoneAt), DoneBy: t.DoneBy,
		Findings: t.Findings, EvidenceRef: t.EvidenceRef,
		CertificateRef:       t.CertificateRef,
		CertificateExpiresAt: stampOf(t.CertificateExpiresAt),
		WaivedReason:         t.WaivedReason,
		WorkOrderId:          t.WorkOrderID, Version: t.Version,
	}
}

func tasksToWire(in []domain.Task) []*facilitiesv1.Task {
	out := make([]*facilitiesv1.Task, 0, len(in))
	for _, t := range in {
		out = append(out, taskToWire(t))
	}
	return out
}

func maintenanceReportToWire(r domain.MaintenanceReport) *facilitiesv1.
	MaintenanceReport {

	return &facilitiesv1.MaintenanceReport{
		Planned: int32(r.Planned), Overdue: int32(r.Overdue),
		Done: int32(r.Done), Missed: int32(r.Missed),
		Waived:           int32(r.Waived),
		StatutoryOverdue: int32(r.StatutoryOverdue),
		EvidenceMissing:  int32(r.EvidenceMissing),
		OverdueTasks:     tasksToWire(r.OverdueTasks),
	}
}

func runtimeToWire(r domain.RuntimeReading) *facilitiesv1.RuntimeReading {
	return &facilitiesv1.RuntimeReading{
		ReadingId: r.ID, AssetId: r.AssetID, Hours: int32(r.Hours),
		ReadAt: stampOf(r.ReadAt), Source: sourceToWire[r.Source],
		SourceRef: r.SourceRef, RecordedBy: r.RecordedBy,
		CounterReplaced: r.CounterReplaced, Note: r.Note,
	}
}

func outageToWire(o domain.Outage) *facilitiesv1.Outage {
	return &facilitiesv1.Outage{
		OutageId: o.ID, Reference: o.Reference,
		FacilityId: o.FacilityID, System: systemToWire[o.System],
		Title: o.Title, Reason: o.Reason,
		PlannedFrom: stampOf(o.PlannedFrom),
		PlannedTo:   stampOf(o.PlannedTo),
		ActualFrom:  stampOf(o.ActualFrom),
		ActualTo:    stampOf(o.ActualTo),
		State:       outageStateToWire[o.State],
		RequestedBy: o.RequestedBy,
		RequestedAt: stampOf(o.RequestedAt),
		ApprovedBy:  o.ApprovedBy, ApprovedAt: stampOf(o.ApprovedAt),
		PermitRef: o.PermitRef, Contingency: o.Contingency,
		RestoredBy: o.RestoredBy, CancelReason: o.CancelReason,
		Version: o.Version,
	}
}

func outagesToWire(in []domain.Outage) []*facilitiesv1.Outage {
	out := make([]*facilitiesv1.Outage, 0, len(in))
	for _, o := range in {
		out = append(out, outageToWire(o))
	}
	return out
}

func areaToWire(a domain.OutageArea) *facilitiesv1.OutageArea {
	return &facilitiesv1.OutageArea{
		AreaId: a.ID, OutageId: a.OutageID,
		OrgUnitId: a.OrgUnitID, Name: a.Name, Critical: a.Critical,
		NotifiedAt:     stampOf(a.NotifiedAt),
		AcknowledgedAt: stampOf(a.AcknowledgedAt),
		AcknowledgedBy: a.AcknowledgedBy, Objection: a.Objection,
		Version: a.Version,
	}
}

func areasToWire(in []domain.OutageArea) []*facilitiesv1.OutageArea {
	out := make([]*facilitiesv1.OutageArea, 0, len(in))
	for _, a := range in {
		out = append(out, areaToWire(a))
	}
	return out
}

func alarmToWire(a domain.Alarm) *facilitiesv1.Alarm {
	return &facilitiesv1.Alarm{
		AlarmId: a.ID, GatewayId: a.GatewayID, PointRef: a.PointRef,
		ExternalId: a.ExternalID, AssetId: a.AssetID,
		FacilityId: a.FacilityID, System: systemToWire[a.System],
		Severity: severityToWire[a.Severity], Message: a.Message,
		Source:         sourceToWire[a.Source],
		RaisedAt:       stampOf(a.RaisedAt),
		ClearedAt:      stampOf(a.ClearedAt),
		State:          alarmStateToWire[a.State],
		AcknowledgedAt: stampOf(a.AcknowledgedAt),
		AcknowledgedBy: a.AcknowledgedBy,
		WorkOrderId:    a.WorkOrderID,
		LinkedAt:       stampOf(a.LinkedAt), LinkedBy: a.LinkedBy,
		Version: a.Version,
	}
}

func alarmsToWire(in []domain.Alarm) []*facilitiesv1.Alarm {
	out := make([]*facilitiesv1.Alarm, 0, len(in))
	for _, a := range in {
		out = append(out, alarmToWire(a))
	}
	return out
}

func ruleToWire(r domain.AlarmRule) *facilitiesv1.AlarmRule {
	return &facilitiesv1.AlarmRule{
		FacilityId: r.FacilityID, System: systemToWire[r.System],
		MinSeverity: severityToWire[r.MinSeverity],
		Priority:    priorityToWire[r.Priority],
		ClassCode:   r.ClassCode, OwnerTeam: r.OwnerTeam,
		Active: r.Active,
	}
}

func deficiencyToWire(d domain.Deficiency) *facilitiesv1.Deficiency {
	return &facilitiesv1.Deficiency{
		DeficiencyId: d.ID, TaskId: d.TaskID, AssetId: d.AssetID,
		FacilityId: d.FacilityID, LocationId: d.LocationID,
		LocationNote: d.LocationNote,
		System:       systemToWire[d.System],
		Severity:     severityToWire[d.Severity],
		Finding:      d.Finding, Standard: d.Standard,
		State:    deficiencyStateToWire[d.State],
		RaisedAt: stampOf(d.RaisedAt), RaisedBy: d.RaisedBy,
		DueAt: stampOf(d.DueAt), WorkOrderId: d.WorkOrderID,
		MitigationNote: d.MitigationNote,
		MitigatedAt:    stampOf(d.MitigatedAt),
		MitigatedBy:    d.MitigatedBy,
		ClosedAt:       stampOf(d.ClosedAt), ClosedBy: d.ClosedBy,
		ClosureEvidenceRef: d.ClosureEvidenceRef,
		Version:            d.Version,
	}
}

func deficienciesToWire(in []domain.Deficiency) []*facilitiesv1.Deficiency {
	out := make([]*facilitiesv1.Deficiency, 0, len(in))
	for _, d := range in {
		out = append(out, deficiencyToWire(d))
	}
	return out
}

func safetyReportToWire(r domain.SafetyReport) *facilitiesv1.SafetyReport {
	return &facilitiesv1.SafetyReport{
		OpenCritical: int32(r.OpenCritical),
		Mitigated:    int32(r.Mitigated), Overdue: int32(r.Overdue),
		ClosedInWindow: int32(r.ClosedInWindow),
		OldestOpenDays: int32(r.OldestOpenDays),
		Findings:       deficienciesToWire(r.Findings),
	}
}

func meterToWire(m domain.Meter) *facilitiesv1.Meter {
	return &facilitiesv1.Meter{
		MeterId: m.ID, Code: m.Code, Name: m.Name,
		Utility: utilityToWire[m.Utility], Unit: m.Unit,
		FacilityId: m.FacilityID, LocationId: m.LocationID,
		AssetId: m.AssetID, Source: sourceToWire[m.Source],
		SourceRef: m.SourceRef, Cumulative: m.Cumulative,
		RegisterMax: int32(m.RegisterMax), Active: m.Active,
		Version: m.Version,
	}
}

func metersToWire(in []domain.Meter) []*facilitiesv1.Meter {
	out := make([]*facilitiesv1.Meter, 0, len(in))
	for _, m := range in {
		out = append(out, meterToWire(m))
	}
	return out
}

func readingToWire(r domain.Reading) *facilitiesv1.Reading {
	return &facilitiesv1.Reading{
		ReadingId: r.ID, MeterId: r.MeterID, Value: int32(r.Value),
		ReadAt: stampOf(r.ReadAt), Source: sourceToWire[r.Source],
		SourceRef: r.SourceRef, RecordedBy: r.RecordedBy,
		RolledOver: r.RolledOver, Note: r.Note,
	}
}

func consumptionToWire(c domain.Consumption) *facilitiesv1.Consumption {
	sources := make([]facilitiesv1.Source, 0, len(c.Sources))
	for _, source := range c.Sources {
		sources = append(sources, sourceToWire[source])
	}
	return &facilitiesv1.Consumption{
		MeterId: c.MeterID, Utility: utilityToWire[c.Utility],
		Unit: c.Unit, From: stampOf(c.From), To: stampOf(c.To),
		Quantity: int32(c.Quantity), Readings: int32(c.Readings),
		Sources: sources, Estimated: c.Estimated,
		Rollovers: int32(c.Rollovers),
	}
}

func downtimeToWire(in []domain.Downtime) []*facilitiesv1.Downtime {
	out := make([]*facilitiesv1.Downtime, 0, len(in))
	for _, d := range in {
		out = append(out, &facilitiesv1.Downtime{
			System:       systemToWire[d.System],
			Minutes:      int32(d.Minutes),
			Incidents:    int32(d.Incidents),
			WorkOrderIds: d.WorkOrderIDs,
			Unmeasured:   int32(d.Unmeasured),
		})
	}
	return out
}

func performanceToWire(p application.SLAPerformance) *facilitiesv1.
	SLAPerformance {

	return &facilitiesv1.SLAPerformance{
		Open:               int32(p.Open),
		ResponseBreaches:   int32(p.ResponseBreaches),
		ResolutionBreaches: int32(p.ResolutionBreaches),
		WorstOpen:          workOrdersToWire(p.WorstOpen),
	}
}

func visitToWire(v domain.Visit) *facilitiesv1.Visit {
	return &facilitiesv1.Visit{
		VisitId: v.ID, VendorName: v.VendorName,
		VendorRef: v.VendorRef, ContactName: v.ContactName,
		Technicians: v.Technicians, FacilityId: v.FacilityID,
		WorkOrderId: v.WorkOrderID, AssetId: v.AssetID,
		TaskId:             v.TaskID,
		WorkRequiresPermit: v.WorkRequiresPermit,
		InductionRef:       v.InductionRef, Purpose: v.Purpose,
		State:      visitStateToWire[v.State],
		SignedInAt: stampOf(v.SignedInAt), SignedInBy: v.SignedInBy,
		SignedOutAt:      stampOf(v.SignedOutAt),
		SignedOutBy:      v.SignedOutBy,
		ServiceReportRef: v.ServiceReportRef,
		ReportSummary:    v.ReportSummary,
		PartsUsed:        v.PartsUsed, FollowUp: v.FollowUp,
		Version: v.Version,
	}
}

func visitsToWire(in []domain.Visit) []*facilitiesv1.Visit {
	out := make([]*facilitiesv1.Visit, 0, len(in))
	for _, v := range in {
		out = append(out, visitToWire(v))
	}
	return out
}
