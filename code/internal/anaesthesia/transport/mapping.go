// Package transport translates between the anaesthesia contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction.
package transport

import (
	"time"

	anaesthesiav1 "github.com/ppusapati/health/code/gen/go/healthcare/anaesthesia/v1"
	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
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

var techniqueFromWire = map[anaesthesiav1.Technique]domain.Technique{
	anaesthesiav1.Technique_TECHNIQUE_GENERAL:  domain.TechniqueGeneral,
	anaesthesiav1.Technique_TECHNIQUE_REGIONAL: domain.TechniqueRegional,
	anaesthesiav1.Technique_TECHNIQUE_SPINAL:   domain.TechniqueSpinal,
	anaesthesiav1.Technique_TECHNIQUE_EPIDURAL: domain.TechniqueEpidural,
	anaesthesiav1.Technique_TECHNIQUE_SEDATION: domain.TechniqueSedation,
	anaesthesiav1.Technique_TECHNIQUE_LOCAL:    domain.TechniqueLocal,
	anaesthesiav1.Technique_TECHNIQUE_COMBINED: domain.TechniqueCombined,
}

// technique maps the wire enum. An unset one stays empty, which the domain
// refuses: guessing "general" for a client that forgot the field would record
// an anaesthetic nobody gave.
func technique(in anaesthesiav1.Technique) domain.Technique {
	return techniqueFromWire[in]
}

var techniqueToWire = map[domain.Technique]anaesthesiav1.Technique{
	domain.TechniqueGeneral:  anaesthesiav1.Technique_TECHNIQUE_GENERAL,
	domain.TechniqueRegional: anaesthesiav1.Technique_TECHNIQUE_REGIONAL,
	domain.TechniqueSpinal:   anaesthesiav1.Technique_TECHNIQUE_SPINAL,
	domain.TechniqueEpidural: anaesthesiav1.Technique_TECHNIQUE_EPIDURAL,
	domain.TechniqueSedation: anaesthesiav1.Technique_TECHNIQUE_SEDATION,
	domain.TechniqueLocal:    anaesthesiav1.Technique_TECHNIQUE_LOCAL,
	domain.TechniqueCombined: anaesthesiav1.Technique_TECHNIQUE_COMBINED,
}

var consentFromWire = map[anaesthesiav1.ConsentStatus]domain.ConsentStatus{
	anaesthesiav1.ConsentStatus_CONSENT_STATUS_OBTAINED:     domain.ConsentObtained,
	anaesthesiav1.ConsentStatus_CONSENT_STATUS_PENDING:      domain.ConsentPending,
	anaesthesiav1.ConsentStatus_CONSENT_STATUS_REFUSED:      domain.ConsentRefused,
	anaesthesiav1.ConsentStatus_CONSENT_STATUS_NOT_REQUIRED: domain.ConsentNotRequired,
}

// consent maps the wire enum. An unset one stays empty, which the domain
// defaults to pending — the safe direction, because a client that forgot the
// field must not have consent recorded as obtained.
func consent(in anaesthesiav1.ConsentStatus) domain.ConsentStatus {
	return consentFromWire[in]
}

var consentToWire = map[domain.ConsentStatus]anaesthesiav1.ConsentStatus{
	domain.ConsentObtained:    anaesthesiav1.ConsentStatus_CONSENT_STATUS_OBTAINED,
	domain.ConsentPending:     anaesthesiav1.ConsentStatus_CONSENT_STATUS_PENDING,
	domain.ConsentRefused:     anaesthesiav1.ConsentStatus_CONSENT_STATUS_REFUSED,
	domain.ConsentNotRequired: anaesthesiav1.ConsentStatus_CONSENT_STATUS_NOT_REQUIRED,
}

var sourceFromWire = map[anaesthesiav1.EntrySource]domain.EntrySource{
	anaesthesiav1.EntrySource_ENTRY_SOURCE_MANUAL:   domain.SourceManual,
	anaesthesiav1.EntrySource_ENTRY_SOURCE_DEVICE:   domain.SourceDevice,
	anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED: domain.SourceImported,
}

// source maps the wire enum. An unset one stays empty, which the domain
// defaults to manual — the safe direction: a value claiming to be from a
// device it cannot name is refused, and one claiming to be manual is merely
// attributed to whoever sent it.
func source(in anaesthesiav1.EntrySource) domain.EntrySource {
	return sourceFromWire[in]
}

var sourceToWire = map[domain.EntrySource]anaesthesiav1.EntrySource{
	domain.SourceManual:   anaesthesiav1.EntrySource_ENTRY_SOURCE_MANUAL,
	domain.SourceDevice:   anaesthesiav1.EntrySource_ENTRY_SOURCE_DEVICE,
	domain.SourceImported: anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED,
}

var statusToWire = map[domain.RecordStatus]anaesthesiav1.RecordStatus{
	domain.RecordOpen:       anaesthesiav1.RecordStatus_RECORD_STATUS_OPEN,
	domain.RecordInRecovery: anaesthesiav1.RecordStatus_RECORD_STATUS_IN_RECOVERY,
	domain.RecordClosed:     anaesthesiav1.RecordStatus_RECORD_STATUS_CLOSED,
}

var directionFromWire = map[anaesthesiav1.FluidDirection]domain.FluidDirection{
	anaesthesiav1.FluidDirection_FLUID_DIRECTION_IN:  domain.FluidIn,
	anaesthesiav1.FluidDirection_FLUID_DIRECTION_OUT: domain.FluidOut,
}

// direction maps the wire enum. An unset one stays empty, which the domain
// refuses: guessing would put blood loss on the wrong side of the balance.
func direction(in anaesthesiav1.FluidDirection) domain.FluidDirection {
	return directionFromWire[in]
}

var directionToWire = map[domain.FluidDirection]anaesthesiav1.FluidDirection{
	domain.FluidIn:  anaesthesiav1.FluidDirection_FLUID_DIRECTION_IN,
	domain.FluidOut: anaesthesiav1.FluidDirection_FLUID_DIRECTION_OUT,
}

var refusalToWire = map[domain.DischargeRefusal]anaesthesiav1.DischargeRefusal{
	domain.RefusalNotHandedOver:   anaesthesiav1.DischargeRefusal_DISCHARGE_REFUSAL_NOT_HANDED_OVER,
	domain.RefusalNotAssessed:     anaesthesiav1.DischargeRefusal_DISCHARGE_REFUSAL_NOT_ASSESSED,
	domain.RefusalIncompleteScore: anaesthesiav1.DischargeRefusal_DISCHARGE_REFUSAL_INCOMPLETE_SCORE,
	domain.RefusalBelowThreshold:  anaesthesiav1.DischargeRefusal_DISCHARGE_REFUSAL_BELOW_THRESHOLD,
}

func airwayAssessmentFromProto(in *anaesthesiav1.AirwayAssessment) domain.AirwayAssessment {
	if in == nil {
		return domain.AirwayAssessment{}
	}
	return domain.AirwayAssessment{
		Mallampati:         in.GetMallampati(),
		MouthOpeningMM:     int(in.GetMouthOpeningMm()),
		ThyromentalMM:      int(in.GetThyromentalMm()),
		NeckMovement:       in.GetNeckMovement(),
		Dentition:          in.GetDentition(),
		Notes:              in.GetNotes(),
		PredictedDifficult: in.GetPredictedDifficult(),
	}
}

func airwayAssessmentToProto(in domain.AirwayAssessment) *anaesthesiav1.AirwayAssessment {
	return &anaesthesiav1.AirwayAssessment{
		Mallampati:         in.Mallampati,
		MouthOpeningMm:     int32(in.MouthOpeningMM),
		ThyromentalMm:      int32(in.ThyromentalMM),
		NeckMovement:       in.NeckMovement,
		Dentition:          in.Dentition,
		Notes:              in.Notes,
		PredictedDifficult: in.PredictedDifficult,
	}
}

func assessmentToProto(in domain.Assessment) *anaesthesiav1.Assessment {
	return &anaesthesiav1.Assessment{
		AssessmentId: in.ID, CaseId: in.CaseID, EncounterId: in.EncounterID,
		PatientId: in.PatientID,
		Version:   int32(in.Version), Supersedes: in.Supersedes,
		Current: in.Current(),
		History: in.History, Airway: airwayAssessmentToProto(in.Airway),
		// A string on the wire, because the emergency modifier is part of the
		// grade.
		AsaGrade:       string(in.ASAGrade),
		Investigations: in.Investigations, Risks: in.Risks, Plan: in.Plan,
		Consent: consentToWire[in.Consent], ConsentNote: in.ConsentNote,
		FitToProceed: in.FitToProceed, Conditions: in.Conditions,
		AssessedBy: in.AssessedBy, AssessedAt: stamp(in.AssessedAt),
		SupersededAt: stamp(in.SupersededAt),
	}
}

func assessmentsToProto(in []domain.Assessment) []*anaesthesiav1.Assessment {
	out := make([]*anaesthesiav1.Assessment, 0, len(in))
	for _, assessment := range in {
		out = append(out, assessmentToProto(assessment))
	}
	return out
}

func planToProto(in domain.Plan) *anaesthesiav1.Plan {
	return &anaesthesiav1.Plan{
		PlanId: in.ID, CaseId: in.CaseID,
		Technique: techniqueToWire[in.Technique], Agents: in.Agents,
		Airway: in.Airway, Monitoring: in.Monitoring,
		SpecialEquipment: in.SpecialEquipment, PostOperative: in.PostOperative,
		Notes: in.Notes, PlannedBy: in.PlannedBy, PlannedAt: stamp(in.PlannedAt),
	}
}

func readinessToProto(in domain.Readiness) *anaesthesiav1.Readiness {
	return &anaesthesiav1.Readiness{
		Assessed: in.Assessed, Fit: in.Fit, Conditions: in.Conditions,
		AsaGrade: string(in.ASAGrade), DifficultAirway: in.DifficultAirway,
		Consent: consentToWire[in.ConsentStatus], Planned: in.Planned,
		Technique:     techniqueToWire[in.Technique],
		PostOperative: in.PostOperative,
		// The equipment somebody has to fetch, and what is still missing.
		SpecialEquipment: in.SpecialEquipment, Outstanding: in.Outstanding,
	}
}

func deviceFromProto(in *anaesthesiav1.DeviceLink) domain.DeviceLink {
	if in == nil {
		return domain.DeviceLink{}
	}
	return domain.DeviceLink{
		DeviceID: in.GetDeviceId(), Model: in.GetModel(),
		Connected: in.GetConnected(), MeasuredAt: timeOf(in.GetMeasuredAt()),
	}
}

func deviceToProto(in domain.DeviceLink) *anaesthesiav1.DeviceLink {
	if in.DeviceID == "" {
		return nil
	}
	return &anaesthesiav1.DeviceLink{
		DeviceId: in.DeviceID, Model: in.Model,
		Connected: in.Connected, MeasuredAt: stamp(in.MeasuredAt),
	}
}

func recordToProto(in domain.Record) *anaesthesiav1.Record {
	return &anaesthesiav1.Record{
		RecordId: in.ID, CaseId: in.CaseID, EncounterId: in.EncounterID,
		PatientId: in.PatientID, Technique: techniqueToWire[in.Technique],
		Status:    statusToWire[in.Status],
		StartedAt: stamp(in.StartedAt), StartedBy: in.StartedBy,
		EndedAt: stamp(in.EndedAt),
		Origin:  sourceToWire[in.Origin], ImportNote: in.ImportNote,
		ImportedAt: stamp(in.ImportedAt), ImportedBy: in.ImportedBy,
	}
}

func vitalToProto(in domain.VitalEntry) *anaesthesiav1.VitalEntry {
	return &anaesthesiav1.VitalEntry{
		VitalId: in.ID, RecordId: in.RecordID,
		Code: in.Code, Display: in.Display, Value: in.Value, Unit: in.Unit,
		Source: sourceToWire[in.Source], Device: deviceToProto(in.Device),
		ObservedAt: stamp(in.ObservedAt), RecordedAt: stamp(in.RecordedAt),
		RecordedBy: in.RecordedBy,
		// Derived here rather than left to the client, so a value taken while
		// the monitor was detached cannot be trended by a caller that forgot
		// to check the connection flag.
		Trustworthy: in.Trustworthy(),
	}
}

func drugToProto(in domain.DrugEntry) *anaesthesiav1.DrugEntry {
	return &anaesthesiav1.DrugEntry{
		DrugId: in.ID, RecordId: in.RecordID,
		DrugCode: in.DrugCode, DrugDisplay: in.DrugDisplay,
		Route: string(in.Route), Dose: in.Dose, DoseUnit: in.DoseUnit,
		ConcentrationAmount: in.ConcentrationAmount,
		ConcentrationUnit:   in.ConcentrationUnit,
		ConcentrationVolume: in.ConcentrationVolume,
		RateMlPerHour:       in.RateMLPerHour, Infusion: in.Infusion,
		StoppedAt: stamp(in.StoppedAt),
		Source:    sourceToWire[in.Source], Device: deviceToProto(in.Device),
		GivenAt: stamp(in.GivenAt), RecordedAt: stamp(in.RecordedAt),
		RecordedBy: in.RecordedBy, Note: in.Note,
	}
}

func drugsToProto(in []domain.DrugEntry) []*anaesthesiav1.DrugEntry {
	out := make([]*anaesthesiav1.DrugEntry, 0, len(in))
	for _, drug := range in {
		out = append(out, drugToProto(drug))
	}
	return out
}

func airwayEventToProto(in domain.AirwayEvent) *anaesthesiav1.AirwayEvent {
	return &anaesthesiav1.AirwayEvent{
		AirwayId: in.ID, RecordId: in.RecordID,
		Device: in.Device, Attempt: int32(in.Attempt), Grade: string(in.Grade),
		Successful: in.Successful, Difficulty: in.Difficulty,
		Complications: in.Complications, Adjuncts: in.Adjuncts,
		OccurredAt: stamp(in.OccurredAt), RecordedBy: in.RecordedBy,
	}
}

func difficultAirwayToProto(in domain.DifficultAirway) *anaesthesiav1.DifficultAirway {
	return &anaesthesiav1.DifficultAirway{
		Attempts: int32(in.Attempts), Difficult: in.Difficult,
		Reasons: in.Reasons, FinalDevice: in.FinalDevice,
		Complications: in.Complications,
	}
}

func fluidToProto(in domain.FluidEntry) *anaesthesiav1.FluidEntry {
	return &anaesthesiav1.FluidEntry{
		FluidId: in.ID, RecordId: in.RecordID,
		Direction: directionToWire[in.Direction], Kind: in.Kind, Label: in.Label,
		VolumeMl: in.VolumeML, ProductId: in.ProductID,
		OccurredAt: stamp(in.OccurredAt), RecordedAt: stamp(in.RecordedAt),
		RecordedBy: in.RecordedBy,
	}
}

func balanceToProto(in domain.FluidBalance) *anaesthesiav1.FluidBalance {
	return &anaesthesiav1.FluidBalance{
		InMl: in.InML, OutMl: in.OutML, NetMl: in.NetML,
		BloodLossMl: in.BloodLossML, TransfusedMl: in.TransfusedML,
		UrineMl: in.UrineML, Entries: int32(in.Entries),
	}
}

func handoverToProto(in domain.Handover) *anaesthesiav1.Handover {
	return &anaesthesiav1.Handover{
		HandoverId: in.ID, RecordId: in.RecordID,
		FromClinician: in.FromClinician, ToClinician: in.ToClinician,
		Summary: in.Summary, Concerns: in.Concerns,
		Instructions:   in.Instructions,
		AnalgesiaGiven: in.AnalgesiaGiven, AntiemeticGiven: in.AntiemeticGiven,
		HandedOverAt: stamp(in.HandedOverAt),
	}
}

func scaleToProto(in domain.RecoveryScale) *anaesthesiav1.RecoveryScale {
	components := make([]*anaesthesiav1.ScoreComponent, 0, len(in.Components))
	for _, component := range in.Components {
		components = append(components, &anaesthesiav1.ScoreComponent{
			Code: component.Code, Label: component.Label,
			Max: int32(component.Max),
		})
	}
	return &anaesthesiav1.RecoveryScale{
		Name: in.Name, Version: in.Version, Components: components,
		DischargeAt: int32(in.DischargeAt),
	}
}

func recoveryAssessmentToProto(in domain.RecoveryAssessment) *anaesthesiav1.RecoveryAssessment {
	scores := make(map[string]int32, len(in.Scores))
	for code, value := range in.Scores {
		scores[code] = int32(value)
	}
	return &anaesthesiav1.RecoveryAssessment{
		AssessmentId: in.ID, RecordId: in.RecordID,
		ScaleName: in.ScaleName, ScaleVersion: in.ScaleVersion,
		Scores: scores, Total: int32(in.Total),
		DischargeThreshold: int32(in.DischargeThreshold),
		// Missing is what stops a partial assessment reading as a low one.
		Missing:    in.Missing,
		AssessedAt: stamp(in.AssessedAt), AssessedBy: in.AssessedBy,
		Complete: in.Complete(), MeetsThreshold: in.MeetsThreshold(),
	}
}

func scoresFromProto(in map[string]int32) map[string]int {
	out := make(map[string]int, len(in))
	for code, value := range in {
		out[code] = int(value)
	}
	return out
}

func decisionToProto(in domain.DischargeDecision) *anaesthesiav1.DischargeDecision {
	refusals := make([]anaesthesiav1.DischargeRefusal, 0, len(in.Refusals))
	explanations := make([]string, 0, len(in.Refusals))
	for _, refusal := range in.Refusals {
		refusals = append(refusals, refusalToWire[refusal])
		// In words too, so a client need not carry the explanations and the
		// nurse is told every refusal rather than the first.
		explanations = append(explanations, refusal.Explain())
	}
	out := &anaesthesiav1.DischargeDecision{
		Allowed: in.Allowed(), Refusals: refusals, Explanations: explanations,
	}
	if in.Score != nil {
		out.Score = recoveryAssessmentToProto(*in.Score)
	}
	return out
}

func dischargeToProto(in domain.Discharge) *anaesthesiav1.Discharge {
	return &anaesthesiav1.Discharge{
		DischargeId: in.ID, RecordId: in.RecordID, Destination: in.Destination,
		Overridden: in.Overridden, OverrideReason: in.OverrideReason,
		ScoreId:      in.ScoreID,
		DischargedAt: stamp(in.DischargedAt), DischargedBy: in.DischargedBy,
	}
}

func painOrderToProto(in domain.PainOrder, now time.Time) *anaesthesiav1.PainOrder {
	return &anaesthesiav1.PainOrder{
		OrderId: in.ID, RecordId: in.RecordID, PatientId: in.PatientID,
		EncounterId: in.EncounterID, Modality: in.Modality,
		PrescriptionIds: in.PrescriptionIDs, TargetScore: in.TargetScore,
		Monitoring: in.Monitoring, Escalation: in.Escalation,
		ReviewBy:  stamp(in.ReviewBy),
		OrderedBy: in.OrderedBy, OrderedAt: stamp(in.OrderedAt),
		StoppedAt: stamp(in.StoppedAt), StoppedBy: in.StoppedBy,
		// Derived at the moment of rendering rather than stored, so a plan
		// does not become overdue only when somebody writes to it.
		ReviewOverdue: in.ReviewOverdue(now),
	}
}

func painOrdersToProto(in []domain.PainOrder, now time.Time) []*anaesthesiav1.PainOrder {
	out := make([]*anaesthesiav1.PainOrder, 0, len(in))
	for _, order := range in {
		out = append(out, painOrderToProto(order, now))
	}
	return out
}

func summaryToProto(in domain.Summary) *anaesthesiav1.Summary {
	out := &anaesthesiav1.Summary{
		RecordId: in.RecordID, CaseId: in.CaseID, PatientId: in.PatientID,
		Technique: techniqueToWire[in.Technique], AsaGrade: string(in.ASAGrade),
		StartedAt: stamp(in.StartedAt), EndedAt: stamp(in.EndedAt),
		Airway: difficultAirwayToProto(in.Airway),
		// Derived, never submitted: a summary somebody typed separately is a
		// second account that disagrees with the record.
		KeyDrugs: drugsToProto(in.KeyDrugs),
		Fluids:   balanceToProto(in.Fluids),
		Events:   in.Events,
		Disposal: in.Disposal,
		// The one thing a summary reader must not have to dig for.
		DischargeOverridden: in.DischargeOverridden,
		OverrideReason:      in.OverrideReason,
		Incomplete:          in.Incomplete,
	}
	if in.Recovery != nil {
		out.Recovery = recoveryAssessmentToProto(*in.Recovery)
	}
	return out
}
