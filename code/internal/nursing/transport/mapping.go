// Package transport serves healthcare.nursing.v1.NursingService.
package transport

import (
	"time"

	nursingv1 "github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1"
	"github.com/ppusapati/health/code/internal/nursing/application"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Enumeration maps. Written out rather than derived, because a generated
// mapping would silently gain a value the domain has not thought about — and in
// this context the unthought-about value is a medication outcome or a
// confidentiality class.

var entrySourceToProto = map[domain.EntrySource]nursingv1.EntrySource{
	domain.SourceManual:  nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
	domain.SourceDevice:  nursingv1.EntrySource_ENTRY_SOURCE_DEVICE,
	domain.SourcePaper:   nursingv1.EntrySource_ENTRY_SOURCE_PAPER,
	domain.SourcePatient: nursingv1.EntrySource_ENTRY_SOURCE_PATIENT,
}

var entrySourceFromProto = map[nursingv1.EntrySource]domain.EntrySource{
	nursingv1.EntrySource_ENTRY_SOURCE_MANUAL:  domain.SourceManual,
	nursingv1.EntrySource_ENTRY_SOURCE_DEVICE:  domain.SourceDevice,
	nursingv1.EntrySource_ENTRY_SOURCE_PAPER:   domain.SourcePaper,
	nursingv1.EntrySource_ENTRY_SOURCE_PATIENT: domain.SourcePatient,
}

var fluidDirectionToProto = map[domain.FluidDirection]nursingv1.FluidDirection{
	domain.FluidIntake: nursingv1.FluidDirection_FLUID_DIRECTION_INTAKE,
	domain.FluidOutput: nursingv1.FluidDirection_FLUID_DIRECTION_OUTPUT,
}

var fluidDirectionFromProto = map[nursingv1.FluidDirection]domain.FluidDirection{
	nursingv1.FluidDirection_FLUID_DIRECTION_INTAKE: domain.FluidIntake,
	nursingv1.FluidDirection_FLUID_DIRECTION_OUTPUT: domain.FluidOutput,
}

var assessmentKindToProto = map[domain.AssessmentKind]nursingv1.AssessmentKind{
	domain.AssessmentAdmission: nursingv1.AssessmentKind_ASSESSMENT_KIND_ADMISSION,
	domain.AssessmentShift:     nursingv1.AssessmentKind_ASSESSMENT_KIND_SHIFT,
	domain.AssessmentFocused:   nursingv1.AssessmentKind_ASSESSMENT_KIND_FOCUSED,
	domain.AssessmentDischarge: nursingv1.AssessmentKind_ASSESSMENT_KIND_DISCHARGE,
}

var assessmentKindFromProto = map[nursingv1.AssessmentKind]domain.AssessmentKind{
	nursingv1.AssessmentKind_ASSESSMENT_KIND_ADMISSION: domain.AssessmentAdmission,
	nursingv1.AssessmentKind_ASSESSMENT_KIND_SHIFT:     domain.AssessmentShift,
	nursingv1.AssessmentKind_ASSESSMENT_KIND_FOCUSED:   domain.AssessmentFocused,
	nursingv1.AssessmentKind_ASSESSMENT_KIND_DISCHARGE: domain.AssessmentDischarge,
}

var riskDomainToProto = map[domain.RiskDomain]nursingv1.RiskDomain{
	domain.RiskFalls:          nursingv1.RiskDomain_RISK_DOMAIN_FALLS,
	domain.RiskPressureInjury: nursingv1.RiskDomain_RISK_DOMAIN_PRESSURE_INJURY,
	domain.RiskPain:           nursingv1.RiskDomain_RISK_DOMAIN_PAIN,
	domain.RiskNutrition:      nursingv1.RiskDomain_RISK_DOMAIN_NUTRITION,
	domain.RiskDeterioration:  nursingv1.RiskDomain_RISK_DOMAIN_DETERIORATION,
}

var riskDomainFromProto = map[nursingv1.RiskDomain]domain.RiskDomain{
	nursingv1.RiskDomain_RISK_DOMAIN_FALLS:           domain.RiskFalls,
	nursingv1.RiskDomain_RISK_DOMAIN_PRESSURE_INJURY: domain.RiskPressureInjury,
	nursingv1.RiskDomain_RISK_DOMAIN_PAIN:            domain.RiskPain,
	nursingv1.RiskDomain_RISK_DOMAIN_NUTRITION:       domain.RiskNutrition,
	nursingv1.RiskDomain_RISK_DOMAIN_DETERIORATION:   domain.RiskDeterioration,
}

var deviceKindToProto = map[domain.DeviceKind]nursingv1.DeviceKind{
	domain.DeviceCentralLine:      nursingv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
	domain.DevicePeripheralLine:   nursingv1.DeviceKind_DEVICE_KIND_PERIPHERAL_LINE,
	domain.DeviceUrinaryCatheter:  nursingv1.DeviceKind_DEVICE_KIND_URINARY_CATHETER,
	domain.DeviceDrain:            nursingv1.DeviceKind_DEVICE_KIND_DRAIN,
	domain.DeviceFeedingTube:      nursingv1.DeviceKind_DEVICE_KIND_FEEDING_TUBE,
	domain.DeviceEndotrachealTube: nursingv1.DeviceKind_DEVICE_KIND_ENDOTRACHEAL_TUBE,
	domain.DeviceChestTube:        nursingv1.DeviceKind_DEVICE_KIND_CHEST_TUBE,
}

var deviceKindFromProto = map[nursingv1.DeviceKind]domain.DeviceKind{
	nursingv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE:      domain.DeviceCentralLine,
	nursingv1.DeviceKind_DEVICE_KIND_PERIPHERAL_LINE:   domain.DevicePeripheralLine,
	nursingv1.DeviceKind_DEVICE_KIND_URINARY_CATHETER:  domain.DeviceUrinaryCatheter,
	nursingv1.DeviceKind_DEVICE_KIND_DRAIN:             domain.DeviceDrain,
	nursingv1.DeviceKind_DEVICE_KIND_FEEDING_TUBE:      domain.DeviceFeedingTube,
	nursingv1.DeviceKind_DEVICE_KIND_ENDOTRACHEAL_TUBE: domain.DeviceEndotrachealTube,
	nursingv1.DeviceKind_DEVICE_KIND_CHEST_TUBE:        domain.DeviceChestTube,
}

var lateralityToProto = map[domain.Laterality]nursingv1.Laterality{
	domain.LateralityLeft:          nursingv1.Laterality_LATERALITY_LEFT,
	domain.LateralityRight:         nursingv1.Laterality_LATERALITY_RIGHT,
	domain.LateralityBilateral:     nursingv1.Laterality_LATERALITY_BILATERAL,
	domain.LateralityNotApplicable: nursingv1.Laterality_LATERALITY_NOT_APPLICABLE,
}

var lateralityFromProto = map[nursingv1.Laterality]domain.Laterality{
	nursingv1.Laterality_LATERALITY_LEFT:           domain.LateralityLeft,
	nursingv1.Laterality_LATERALITY_RIGHT:          domain.LateralityRight,
	nursingv1.Laterality_LATERALITY_BILATERAL:      domain.LateralityBilateral,
	nursingv1.Laterality_LATERALITY_NOT_APPLICABLE: domain.LateralityNotApplicable,
}

var orderStatusToProto = map[domain.OrderStatus]nursingv1.OrderStatus{
	domain.OrderDraft:     nursingv1.OrderStatus_ORDER_STATUS_DRAFT,
	domain.OrderActive:    nursingv1.OrderStatus_ORDER_STATUS_ACTIVE,
	domain.OrderHeld:      nursingv1.OrderStatus_ORDER_STATUS_HELD,
	domain.OrderCompleted: nursingv1.OrderStatus_ORDER_STATUS_COMPLETED,
	domain.OrderCancelled: nursingv1.OrderStatus_ORDER_STATUS_CANCELLED,
}

var outcomeToProto = map[domain.AdministrationOutcome]nursingv1.AdministrationOutcome{
	domain.Administered:    nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
	domain.NotAdministered: nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_NOT_ADMINISTERED,
	domain.Held:            nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_HELD,
	domain.Refused:         nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_REFUSED,
	domain.Delayed:         nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_DELAYED,
}

var outcomeFromProto = map[nursingv1.AdministrationOutcome]domain.AdministrationOutcome{
	nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED:     domain.Administered,
	nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_NOT_ADMINISTERED: domain.NotAdministered,
	nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_HELD:             domain.Held,
	nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_REFUSED:          domain.Refused,
	nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_DELAYED:          domain.Delayed,
}

var priorityToProto = map[domain.TaskPriority]nursingv1.TaskPriority{
	domain.PriorityRoutine:  nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE,
	domain.PriorityUrgent:   nursingv1.TaskPriority_TASK_PRIORITY_URGENT,
	domain.PriorityCritical: nursingv1.TaskPriority_TASK_PRIORITY_CRITICAL,
}

var priorityFromProto = map[nursingv1.TaskPriority]domain.TaskPriority{
	nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE:  domain.PriorityRoutine,
	nursingv1.TaskPriority_TASK_PRIORITY_URGENT:   domain.PriorityUrgent,
	nursingv1.TaskPriority_TASK_PRIORITY_CRITICAL: domain.PriorityCritical,
}

var taskStatusToProto = map[domain.TaskStatus]nursingv1.TaskStatus{
	domain.TaskPending:   nursingv1.TaskStatus_TASK_STATUS_PENDING,
	domain.TaskDone:      nursingv1.TaskStatus_TASK_STATUS_DONE,
	domain.TaskNotDone:   nursingv1.TaskStatus_TASK_STATUS_NOT_DONE,
	domain.TaskCancelled: nursingv1.TaskStatus_TASK_STATUS_CANCELLED,
}

var planStatusToProto = map[domain.PlanStatus]nursingv1.PlanStatus{
	domain.PlanActive:    nursingv1.PlanStatus_PLAN_STATUS_ACTIVE,
	domain.PlanCompleted: nursingv1.PlanStatus_PLAN_STATUS_COMPLETED,
	domain.PlanCancelled: nursingv1.PlanStatus_PLAN_STATUS_CANCELLED,
}

var restraintKindToProto = map[domain.RestraintKind]nursingv1.RestraintKind{
	domain.RestraintPhysical:  nursingv1.RestraintKind_RESTRAINT_KIND_PHYSICAL,
	domain.RestraintChemical:  nursingv1.RestraintKind_RESTRAINT_KIND_CHEMICAL,
	domain.RestraintSeclusion: nursingv1.RestraintKind_RESTRAINT_KIND_SECLUSION,
}

var restraintKindFromProto = map[nursingv1.RestraintKind]domain.RestraintKind{
	nursingv1.RestraintKind_RESTRAINT_KIND_PHYSICAL:  domain.RestraintPhysical,
	nursingv1.RestraintKind_RESTRAINT_KIND_CHEMICAL:  domain.RestraintChemical,
	nursingv1.RestraintKind_RESTRAINT_KIND_SECLUSION: domain.RestraintSeclusion,
}

var transfusionStatusToProto = map[domain.TransfusionStatus]nursingv1.TransfusionStatus{
	domain.TransfusionInProgress: nursingv1.TransfusionStatus_TRANSFUSION_STATUS_IN_PROGRESS,
	domain.TransfusionCompleted:  nursingv1.TransfusionStatus_TRANSFUSION_STATUS_COMPLETED,
	domain.TransfusionStopped:    nursingv1.TransfusionStatus_TRANSFUSION_STATUS_STOPPED,
}

var woundKindToProto = map[domain.WoundKind]nursingv1.WoundKind{
	domain.WoundPressureInjury: nursingv1.WoundKind_WOUND_KIND_PRESSURE_INJURY,
	domain.WoundSurgical:       nursingv1.WoundKind_WOUND_KIND_SURGICAL,
	domain.WoundTrauma:         nursingv1.WoundKind_WOUND_KIND_TRAUMA,
	domain.WoundBurn:           nursingv1.WoundKind_WOUND_KIND_BURN,
	domain.WoundUlcer:          nursingv1.WoundKind_WOUND_KIND_ULCER,
	domain.WoundOther:          nursingv1.WoundKind_WOUND_KIND_OTHER,
}

var woundKindFromProto = map[nursingv1.WoundKind]domain.WoundKind{
	nursingv1.WoundKind_WOUND_KIND_PRESSURE_INJURY: domain.WoundPressureInjury,
	nursingv1.WoundKind_WOUND_KIND_SURGICAL:        domain.WoundSurgical,
	nursingv1.WoundKind_WOUND_KIND_TRAUMA:          domain.WoundTrauma,
	nursingv1.WoundKind_WOUND_KIND_BURN:            domain.WoundBurn,
	nursingv1.WoundKind_WOUND_KIND_ULCER:           domain.WoundUlcer,
	nursingv1.WoundKind_WOUND_KIND_OTHER:           domain.WoundOther,
}

var learnerToProto = map[domain.Learner]nursingv1.Learner{
	domain.LearnerPatient: nursingv1.Learner_LEARNER_PATIENT,
	domain.LearnerFamily:  nursingv1.Learner_LEARNER_FAMILY,
	domain.LearnerCarer:   nursingv1.Learner_LEARNER_CARER,
}

var learnerFromProto = map[nursingv1.Learner]domain.Learner{
	nursingv1.Learner_LEARNER_PATIENT: domain.LearnerPatient,
	nursingv1.Learner_LEARNER_FAMILY:  domain.LearnerFamily,
	nursingv1.Learner_LEARNER_CARER:   domain.LearnerCarer,
}

var understandingToProto = map[domain.Understanding]nursingv1.Understanding{
	domain.UnderstandingDemonstrated:       nursingv1.Understanding_UNDERSTANDING_DEMONSTRATED,
	domain.UnderstandingVerbalised:         nursingv1.Understanding_UNDERSTANDING_VERBALISED,
	domain.UnderstandingNeedsReinforcement: nursingv1.Understanding_UNDERSTANDING_NEEDS_REINFORCEMENT,
	domain.UnderstandingUnableToAssess:     nursingv1.Understanding_UNDERSTANDING_UNABLE_TO_ASSESS,
}

var understandingFromProto = map[nursingv1.Understanding]domain.Understanding{
	nursingv1.Understanding_UNDERSTANDING_DEMONSTRATED:        domain.UnderstandingDemonstrated,
	nursingv1.Understanding_UNDERSTANDING_VERBALISED:          domain.UnderstandingVerbalised,
	nursingv1.Understanding_UNDERSTANDING_NEEDS_REINFORCEMENT: domain.UnderstandingNeedsReinforcement,
	nursingv1.Understanding_UNDERSTANDING_UNABLE_TO_ASSESS:    domain.UnderstandingUnableToAssess,
}

var relationshipToProto = map[domain.CareRelationship]nursingv1.CareRelationship{
	domain.RelationshipPrimary:   nursingv1.CareRelationship_CARE_RELATIONSHIP_PRIMARY,
	domain.RelationshipAssociate: nursingv1.CareRelationship_CARE_RELATIONSHIP_ASSOCIATE,
	domain.RelationshipCovering:  nursingv1.CareRelationship_CARE_RELATIONSHIP_COVERING,
	domain.RelationshipInCharge:  nursingv1.CareRelationship_CARE_RELATIONSHIP_IN_CHARGE,
}

var relationshipFromProto = map[nursingv1.CareRelationship]domain.CareRelationship{
	nursingv1.CareRelationship_CARE_RELATIONSHIP_PRIMARY:   domain.RelationshipPrimary,
	nursingv1.CareRelationship_CARE_RELATIONSHIP_ASSOCIATE: domain.RelationshipAssociate,
	nursingv1.CareRelationship_CARE_RELATIONSHIP_COVERING:  domain.RelationshipCovering,
	nursingv1.CareRelationship_CARE_RELATIONSHIP_IN_CHARGE: domain.RelationshipInCharge,
}

func ts(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

func goTime(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

func codingToProto(c domain.Coding) *nursingv1.Coding {
	if c.Empty() {
		return nil
	}
	return &nursingv1.Coding{
		System: c.System, Version: c.Version, Code: c.Code, Display: c.Display,
	}
}

func codingFromProto(c *nursingv1.Coding) domain.Coding {
	if c == nil {
		return domain.Coding{}
	}
	return domain.Coding{
		System: c.GetSystem(), Version: c.GetVersion(),
		Code: c.GetCode(), Display: c.GetDisplay(),
	}
}

func quantityToProto(q domain.Quantity) *nursingv1.Quantity {
	if q.Value == 0 && q.Unit == "" {
		return nil
	}
	return &nursingv1.Quantity{Value: q.Value, Unit: q.Unit}
}

func quantityFromProto(q *nursingv1.Quantity) domain.Quantity {
	if q == nil {
		return domain.Quantity{}
	}
	return domain.Quantity{Value: q.GetValue(), Unit: q.GetUnit()}
}

// flowsheetEntryToProto renders a charted observation.
//
// The late flag is computed here rather than stored, so a client cannot render
// an entry as contemporaneous by omitting a field (SRS-NUR-003).
func flowsheetEntryToProto(e *domain.FlowsheetEntry) *nursingv1.FlowsheetEntry {
	if e == nil {
		return nil
	}
	return &nursingv1.FlowsheetEntry{
		EntryId: e.ID, PatientId: e.PatientID, EncounterId: e.EncounterID,
		Code: codingToProto(e.Code), Value: quantityToProto(e.Value),
		TextValue: e.TextValue, CodedValue: codingToProto(e.CodedValue),
		ObservedAt: ts(e.ObservedAt), RecordedAt: ts(e.RecordedAt),
		Source: entrySourceToProto[e.Source], DeviceId: e.DeviceID,
		RecordedBy: e.RecordedBy, LateEntryReason: e.LateEntryReason,
		Late: e.IsLate(), Version: e.Version,
	}
}

func fluidEntryToProto(f *domain.FluidEntry) *nursingv1.FluidEntry {
	if f == nil {
		return nil
	}
	return &nursingv1.FluidEntry{
		FluidId: f.ID, PatientId: f.PatientID, EncounterId: f.EncounterID,
		Direction: fluidDirectionToProto[f.Direction], Category: f.Category,
		VolumeMl:   f.VolumeML,
		ObservedAt: ts(f.ObservedAt), RecordedAt: ts(f.RecordedAt),
		RecordedBy:      f.RecordedBy,
		SupersededById:  f.SupersededByID,
		SupersedesId:    f.SupersedesID,
		AmendmentReason: f.AmendmentReason,
		VoidedReason:    f.VoidedReason,
		Version:         f.Version,
	}
}

func balanceToProto(b domain.FluidBalance) *nursingv1.FluidBalance {
	return &nursingv1.FluidBalance{
		From: ts(b.From), To: ts(b.To),
		IntakeMl: b.IntakeML, OutputMl: b.OutputML, NetMl: b.NetML(),
		ByCategory: b.ByCategory, Counted: int32(b.Counted),
	}
}

func templateToProto(t domain.AssessmentTemplate) *nursingv1.AssessmentTemplate {
	sections := make([]*nursingv1.TemplateSection, 0, len(t.Sections))
	for _, s := range t.Sections {
		sections = append(sections, &nursingv1.TemplateSection{
			Heading: s.Heading, Required: s.Required, Prompts: s.Prompts,
		})
	}
	return &nursingv1.AssessmentTemplate{
		TemplateId: t.TemplateID, Version: t.Version, Name: t.Name,
		MinAgeYears: t.AppliesTo.MinAgeYears, MaxAgeYears: t.AppliesTo.MaxAgeYears,
		ServiceCode: t.AppliesTo.ServiceCode, Sections: sections,
		Retired: t.Retired(),
	}
}

func templateFromProto(t *nursingv1.AssessmentTemplate) domain.AssessmentTemplate {
	if t == nil {
		return domain.AssessmentTemplate{}
	}
	sections := make([]domain.TemplateSection, 0, len(t.GetSections()))
	for _, s := range t.GetSections() {
		sections = append(sections, domain.TemplateSection{
			Heading: s.GetHeading(), Required: s.GetRequired(),
			Prompts: s.GetPrompts(),
		})
	}
	return domain.AssessmentTemplate{
		TemplateID: t.GetTemplateId(), Version: t.GetVersion(),
		Name: t.GetName(),
		AppliesTo: domain.Applicability{
			MinAgeYears: t.GetMinAgeYears(), MaxAgeYears: t.GetMaxAgeYears(),
			ServiceCode: t.GetServiceCode(),
		},
		Sections: sections,
	}
}

func answersToProto(in []domain.Answer) []*nursingv1.Answer {
	out := make([]*nursingv1.Answer, 0, len(in))
	for _, a := range in {
		out = append(out, &nursingv1.Answer{
			Heading: a.Heading, Prompt: a.Prompt, Value: a.Value,
			Coded: codingToProto(a.Coded),
		})
	}
	return out
}

func answersFromProto(in []*nursingv1.Answer) []domain.Answer {
	out := make([]domain.Answer, 0, len(in))
	for _, a := range in {
		out = append(out, domain.Answer{
			Heading: a.GetHeading(), Prompt: a.GetPrompt(), Value: a.GetValue(),
			Coded: codingFromProto(a.GetCoded()),
		})
	}
	return out
}

func assessmentToProto(a *domain.Assessment) *nursingv1.Assessment {
	if a == nil {
		return nil
	}
	return &nursingv1.Assessment{
		AssessmentId: a.ID, PatientId: a.PatientID, EncounterId: a.EncounterID,
		Kind:       assessmentKindToProto[a.Kind],
		TemplateId: a.TemplateID, TemplateVersion: a.TemplateVersion,
		Answers:    answersToProto(a.Answers),
		AssessedAt: ts(a.AssessedAt), RecordedAt: ts(a.RecordedAt),
		AssessedBy: a.AssessedBy, Version: a.Version,
	}
}

func riskScaleToProto(s domain.RiskScale) *nursingv1.RiskScale {
	inputs := make([]*nursingv1.RiskInput, 0, len(s.Inputs))
	for _, i := range s.Inputs {
		inputs = append(inputs, &nursingv1.RiskInput{
			Key: i.Key, Label: i.Label, Min: i.Min, Max: i.Max,
		})
	}
	bands := make([]*nursingv1.RiskBand, 0, len(s.Bands))
	for _, b := range s.Bands {
		bands = append(bands, &nursingv1.RiskBand{
			From: b.From, To: b.To, Label: b.Label, Escalate: b.Escalate,
		})
	}
	return &nursingv1.RiskScale{
		ScaleId: s.ScaleID, Version: s.Version, Name: s.Name,
		Domain: riskDomainToProto[s.Domain], Inputs: inputs, Bands: bands,
		ReassessAfterSeconds: int64(s.ReassessAfter / time.Second),
		Retired:              s.Retired(),
	}
}

func riskScaleFromProto(s *nursingv1.RiskScale) domain.RiskScale {
	if s == nil {
		return domain.RiskScale{}
	}
	inputs := make([]domain.RiskInput, 0, len(s.GetInputs()))
	for _, i := range s.GetInputs() {
		inputs = append(inputs, domain.RiskInput{
			Key: i.GetKey(), Label: i.GetLabel(), Min: i.GetMin(), Max: i.GetMax(),
		})
	}
	bands := make([]domain.RiskBand, 0, len(s.GetBands()))
	for _, b := range s.GetBands() {
		bands = append(bands, domain.RiskBand{
			From: b.GetFrom(), To: b.GetTo(), Label: b.GetLabel(),
			Escalate: b.GetEscalate(),
		})
	}
	return domain.RiskScale{
		ScaleID: s.GetScaleId(), Version: s.GetVersion(), Name: s.GetName(),
		Domain: riskDomainFromProto[s.GetDomain()], Inputs: inputs, Bands: bands,
		ReassessAfter: time.Duration(s.GetReassessAfterSeconds()) * time.Second,
	}
}

func riskAssessmentToProto(a *domain.RiskAssessment) *nursingv1.RiskAssessment {
	if a == nil {
		return nil
	}
	return &nursingv1.RiskAssessment{
		RiskId: a.ID, PatientId: a.PatientID, EncounterId: a.EncounterID,
		ScaleId: a.ScaleID, ScaleVersion: a.ScaleVersion,
		Domain: riskDomainToProto[a.Domain],
		// The inputs travel with the total: a score on its own cannot be
		// checked, explained or recomputed (SRS-NUR-005).
		Inputs: a.Inputs, Total: a.Total, Band: a.Band, Escalate: a.Escalate,
		AssessedAt: ts(a.AssessedAt), RecordedAt: ts(a.RecordedAt),
		AssessedBy: a.AssessedBy, DueAt: ts(a.DueAt),
		SupersededById: a.SupersededByID, Version: a.Version,
	}
}

func deviceReportToProto(r application.DeviceDayReport) *nursingv1.Device {
	d := r.Device
	if d == nil {
		return nil
	}
	care := make([]*nursingv1.DeviceCare, 0, len(d.Care))
	for _, c := range d.Care {
		care = append(care, &nursingv1.DeviceCare{
			CareId: c.ID, Kind: c.Kind, Finding: c.Finding,
			OutputMl: c.OutputML, PerformedAt: ts(c.PerformedAt),
			PerformedBy: c.PerformedBy,
		})
	}
	return &nursingv1.Device{
		DeviceId: d.ID, PatientId: d.PatientID, EncounterId: d.EncounterID,
		Kind: deviceKindToProto[d.Kind], Site: d.Site,
		Laterality: lateralityToProto[d.Laterality],
		Size:       d.Size, Lot: d.Lot,
		InsertedAt: ts(d.InsertedAt), InsertedBy: d.InsertedBy,
		RemovedAt: ts(d.RemovedAt), RemovedBy: d.RemovedBy,
		RemovalReason: d.RemovalReason, Care: care,
		// Computed from the canonical dates and nothing else (SRS-NUR-006).
		DeviceDays:         int32(r.DeviceDays),
		DwellSeconds:       int64(r.Dwell / time.Second),
		SurveillanceDevice: r.Surveillance,
		Version:            d.Version,
	}
}

func deviceToProto(d *domain.Device, asOf time.Time) *nursingv1.Device {
	if d == nil {
		return nil
	}
	return deviceReportToProto(application.DeviceDayReport{
		Device: d, DeviceDays: d.DeviceDays(asOf), Dwell: d.Dwell(asOf),
		Surveillance: d.Kind.SurveillanceDevice(),
	})
}

func verificationToProto(v domain.Verification) *nursingv1.Verification {
	return &nursingv1.Verification{
		PatientScanned: v.PatientScanned, MedicationScanned: v.MedicationScanned,
		Performed: v.Performed, ScannedAt: ts(v.ScannedAt),
	}
}

func verificationFromProto(v *nursingv1.Verification) domain.Verification {
	if v == nil {
		return domain.Verification{}
	}
	return domain.Verification{
		PatientScanned:    v.GetPatientScanned(),
		MedicationScanned: v.GetMedicationScanned(),
		Performed:         v.GetPerformed(),
		ScannedAt:         goTime(v.GetScannedAt()),
	}
}

func administrationToProto(a *domain.Administration,
	policy domain.AdministrationPolicy) *nursingv1.Administration {

	if a == nil {
		return nil
	}
	out := &nursingv1.Administration{
		AdministrationId: a.ID, PatientId: a.PatientID,
		EncounterId: a.EncounterID, OrderId: a.OrderID,
		Medication: codingToProto(a.Medication),
		// Both, always. Overwriting the scheduled values would leave "was it
		// late" unanswerable (SRS-NUR-009).
		ScheduledDose: quantityToProto(a.ScheduledDose),
		ScheduledAt:   ts(a.ScheduledAt),
		GivenDose:     quantityToProto(a.GivenDose),
		GivenAt:       ts(a.GivenAt),
		Route:         a.Route, Site: a.Site,
		Outcome: outcomeToProto[a.Outcome], Reason: a.Reason,
		Verification:    verificationToProto(a.Verification),
		IdempotencyKey:  a.IdempotencyKey,
		RecordedOffline: a.RecordedOffline,
		AdministeredBy:  a.AdministeredBy, WitnessedBy: a.WitnessedBy,
		RecordedAt: ts(a.RecordedAt), Late: a.Late(policy),
		Version: a.Version,
	}
	if a.Override != nil {
		out.Override = &nursingv1.Override{
			Reason: a.Override.Reason, By: a.Override.By,
			At:                 ts(a.Override.At),
			PatientMismatch:    a.Override.PatientMismatch,
			MedicationMismatch: a.Override.MedicationMismatch,
			NotScanned:         a.Override.NotScanned,
		}
	}
	return out
}

func orderToProto(o domain.MedicationOrder) *nursingv1.MedicationOrder {
	return &nursingv1.MedicationOrder{
		OrderId: o.OrderID, PatientId: o.PatientID, EncounterId: o.EncounterID,
		Medication: codingToProto(o.Medication), Dose: quantityToProto(o.Dose),
		Route: o.Route, Frequency: o.Frequency,
		Status: orderStatusToProto[o.Status],
		// Separate from status, because an order can be active and unverified
		// and that distinction is what SRS-NUR-007 is about.
		Verified: o.Verified, VerifiedBy: o.VerifiedBy,
		VerifiedAt: ts(o.VerifiedAt), Prn: o.PRN,
		StartsAt: ts(o.StartsAt), EndsAt: ts(o.EndsAt),
	}
}

func policyToProto(p domain.AdministrationPolicy) *nursingv1.AdministrationPolicy {
	return &nursingv1.AdministrationPolicy{
		BarcodeRequired: p.BarcodeRequired, OverrideAllowed: p.OverrideAllowed,
		LateAfterSeconds: int64(p.LateAfter / time.Second),
	}
}

func policyFromProto(p *nursingv1.AdministrationPolicy) domain.AdministrationPolicy {
	if p == nil {
		return domain.DefaultAdministrationPolicy()
	}
	return domain.AdministrationPolicy{
		BarcodeRequired: p.GetBarcodeRequired(),
		OverrideAllowed: p.GetOverrideAllowed(),
		LateAfter:       time.Duration(p.GetLateAfterSeconds()) * time.Second,
	}
}

func taskToProto(t *domain.NursingTask, now time.Time) *nursingv1.NursingTask {
	if t == nil {
		return nil
	}
	return &nursingv1.NursingTask{
		TaskId: t.ID, PatientId: t.PatientID, EncounterId: t.EncounterID,
		Description: t.Description, Priority: priorityToProto[t.Priority],
		DueAt:      ts(t.DueAt),
		SourceKind: string(t.SourceKind), SourceId: t.SourceID,
		RecurEverySeconds: int64(t.RecurEvery / time.Second),
		RecurUntil:        ts(t.RecurUntil),
		Status:            taskStatusToProto[t.Status],
		Evidence:          t.Evidence,
		CompletedAt:       ts(t.CompletedAt), CompletedBy: t.CompletedBy,
		NotDoneReason: t.NotDoneReason, AssignedTo: t.AssignedTo,
		EscalatedAt: ts(t.EscalatedAt), EscalatedTo: t.EscalatedTo,
		Overdue: t.Overdue(now), Version: t.Version,
	}
}

func planProblemsToProto(in []domain.PlanProblem) []*nursingv1.PlanProblem {
	out := make([]*nursingv1.PlanProblem, 0, len(in))
	for _, p := range in {
		goals := make([]*nursingv1.PlanGoal, 0, len(p.Goals))
		for _, g := range p.Goals {
			goals = append(goals, &nursingv1.PlanGoal{
				GoalId: g.ID, Description: g.Description,
				TargetDate: ts(g.TargetDate), Met: g.Met, Evaluation: g.Evaluation,
			})
		}
		interventions := make([]*nursingv1.Intervention, 0, len(p.Interventions))
		for _, i := range p.Interventions {
			interventions = append(interventions, &nursingv1.Intervention{
				InterventionId: i.ID, Description: i.Description,
				EverySeconds: int64(i.Every / time.Second),
				Priority:     priorityToProto[i.Priority], Owner: i.Owner,
			})
		}
		out = append(out, &nursingv1.PlanProblem{
			ProblemId: p.ID, Description: p.Description,
			Coded: codingToProto(p.Coded), Goals: goals,
			Interventions: interventions, Resolved: p.Resolved,
		})
	}
	return out
}

func planProblemsFromProto(in []*nursingv1.PlanProblem) []domain.PlanProblem {
	out := make([]domain.PlanProblem, 0, len(in))
	for _, p := range in {
		goals := make([]domain.PlanGoal, 0, len(p.GetGoals()))
		for _, g := range p.GetGoals() {
			goals = append(goals, domain.PlanGoal{
				ID: g.GetGoalId(), Description: g.GetDescription(),
				TargetDate: goTime(g.GetTargetDate()), Met: g.GetMet(),
				Evaluation: g.GetEvaluation(),
			})
		}
		interventions := make([]domain.Intervention, 0, len(p.GetInterventions()))
		for _, i := range p.GetInterventions() {
			interventions = append(interventions, domain.Intervention{
				ID: i.GetInterventionId(), Description: i.GetDescription(),
				Every:    time.Duration(i.GetEverySeconds()) * time.Second,
				Priority: priorityFromProto[i.GetPriority()], Owner: i.GetOwner(),
			})
		}
		out = append(out, domain.PlanProblem{
			ID: p.GetProblemId(), Description: p.GetDescription(),
			Coded: codingFromProto(p.GetCoded()), Goals: goals,
			Interventions: interventions, Resolved: p.GetResolved(),
		})
	}
	return out
}

func carePlanToProto(p *domain.CarePlan) *nursingv1.CarePlan {
	if p == nil {
		return nil
	}
	return &nursingv1.CarePlan{
		PlanId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		Title: p.Title, Problems: planProblemsToProto(p.Problems),
		Status:    planStatusToProto[p.Status],
		CreatedAt: ts(p.CreatedAt), CreatedBy: p.CreatedBy,
		ReviewedAt: ts(p.ReviewedAt), ReviewedBy: p.ReviewedBy,
		Evaluation: p.Evaluation, Version: p.Version,
	}
}

func shiftToProto(s domain.Shift) *nursingv1.Shift {
	return &nursingv1.Shift{
		Code: s.Code, StartsAt: ts(s.StartsAt), EndsAt: ts(s.EndsAt),
	}
}

func shiftFromProto(s *nursingv1.Shift) domain.Shift {
	if s == nil {
		return domain.Shift{}
	}
	return domain.Shift{
		Code: s.GetCode(), StartsAt: goTime(s.GetStartsAt()),
		EndsAt: goTime(s.GetEndsAt()),
	}
}

func handoverToProto(h *domain.Handover) *nursingv1.Handover {
	if h == nil {
		return nil
	}
	devices := make([]*nursingv1.HandoverDevice, 0, len(h.Devices))
	for _, d := range h.Devices {
		devices = append(devices, &nursingv1.HandoverDevice{
			DeviceId: d.DeviceID, Kind: deviceKindToProto[d.Kind],
			Site: d.Site, InsertedAt: ts(d.InsertedAt),
			DeviceDays: int32(d.DeviceDays),
		})
	}
	tasks := make([]*nursingv1.HandoverTask, 0, len(h.PendingTasks))
	for _, t := range h.PendingTasks {
		tasks = append(tasks, &nursingv1.HandoverTask{
			TaskId: t.TaskID, Description: t.Description,
			Priority: priorityToProto[t.Priority], DueAt: ts(t.DueAt),
			Overdue: t.Overdue,
		})
	}
	return &nursingv1.Handover{
		HandoverId: h.ID, PatientId: h.PatientID, EncounterId: h.EncounterID,
		UnitId:    h.UnitID,
		FromShift: shiftToProto(h.FromShift), ToShift: shiftToProto(h.ToShift),
		Situation: h.Situation, Background: h.Background,
		Assessment: h.Assessment, Recommendation: h.Recommendation,
		CriticalRisks: h.CriticalRisks, Outstanding: h.OutstandingIssue,
		// The snapshot: what the handover said stays what it said
		// (SRS-NUR-010).
		Devices: devices, PendingTasks: tasks,
		ComposedAt: ts(h.ComposedAt), ComposedBy: h.ComposedBy,
		AcknowledgedAt: ts(h.AcknowledgedAt), AcknowledgedBy: h.AcknowledgedBy,
		Questions: h.Questions, Version: h.Version,
	}
}

func authorizationToProto(a domain.RestraintAuthorization) *nursingv1.RestraintAuthorization {
	return &nursingv1.RestraintAuthorization{
		AuthorizedBy: a.AuthorizedBy, AuthorizedAt: ts(a.AuthorizedAt),
		ExpiresAt: ts(a.ExpiresAt), Indication: a.Indication,
	}
}

func authorizationFromProto(a *nursingv1.RestraintAuthorization) domain.RestraintAuthorization {
	if a == nil {
		return domain.RestraintAuthorization{}
	}
	return domain.RestraintAuthorization{
		AuthorizedBy: a.GetAuthorizedBy(),
		AuthorizedAt: goTime(a.GetAuthorizedAt()),
		ExpiresAt:    goTime(a.GetExpiresAt()),
		Indication:   a.GetIndication(),
	}
}

func restraintToProto(r *domain.Restraint, now time.Time) *nursingv1.Restraint {
	if r == nil {
		return nil
	}
	renewals := make([]*nursingv1.RestraintAuthorization, 0, len(r.Renewals))
	for _, a := range r.Renewals {
		renewals = append(renewals, authorizationToProto(a))
	}
	checks := make([]*nursingv1.RestraintCheck, 0, len(r.Monitoring))
	for _, c := range r.Monitoring {
		checks = append(checks, &nursingv1.RestraintCheck{
			CheckId: c.ID, ObservedAt: ts(c.ObservedAt), ObservedBy: c.ObservedBy,
			Findings: c.Findings, ContinuedReason: c.ContinuedReason,
		})
	}
	return &nursingv1.Restraint{
		RestraintId: r.ID, PatientId: r.PatientID, EncounterId: r.EncounterID,
		Kind: restraintKindToProto[r.Kind], Description: r.Description,
		Authorization: authorizationToProto(r.Authorization), Renewals: renewals,
		StartedAt: ts(r.StartedAt), StartedBy: r.StartedBy,
		MonitorEverySeconds: int64(r.MonitorEvery / time.Second),
		Monitoring:          checks,
		DiscontinuedAt:      ts(r.DiscontinuedAt),
		DiscontinuedBy:      r.DiscontinuedBy,
		DiscontinuedReason:  r.DiscontinuedReason,
		// An expired authorization does not end the restraint: the patient is
		// still restrained, and what has lapsed is the permission
		// (SRS-NUR-013).
		AuthorizationExpired: r.AuthorizationExpired(now),
		MonitoringOverdue:    r.MonitoringOverdue(now),
		Version:              r.Version,
	}
}

func transfusionObservationToProto(o domain.TransfusionObservation) *nursingv1.TransfusionObservation {
	return &nursingv1.TransfusionObservation{
		ObservationId: o.ID, ObservedAt: ts(o.ObservedAt),
		ObservedBy: o.ObservedBy, TemperatureC: o.TemperatureC,
		Pulse: o.Pulse, SystolicBp: o.SystolicBP,
		RespiratoryRate: o.RespiratoryRate, Baseline: o.Baseline,
		Notes: o.Notes,
	}
}

func transfusionObservationFromProto(o *nursingv1.TransfusionObservation) domain.TransfusionObservation {
	if o == nil {
		return domain.TransfusionObservation{}
	}
	return domain.TransfusionObservation{
		ObservedAt: goTime(o.GetObservedAt()), ObservedBy: o.GetObservedBy(),
		TemperatureC: o.GetTemperatureC(), Pulse: o.GetPulse(),
		SystolicBP: o.GetSystolicBp(), RespiratoryRate: o.GetRespiratoryRate(),
		Notes: o.GetNotes(),
	}
}

func transfusionToProto(t *domain.Transfusion) *nursingv1.Transfusion {
	if t == nil {
		return nil
	}
	observations := make([]*nursingv1.TransfusionObservation, 0, len(t.Observations))
	for _, o := range t.Observations {
		observations = append(observations, transfusionObservationToProto(o))
	}
	out := &nursingv1.Transfusion{
		TransfusionId: t.ID, PatientId: t.PatientID, EncounterId: t.EncounterID,
		UnitNumber: t.UnitNumber, Product: codingToProto(t.Product),
		AboGroup: t.ABOGroup, Rhd: t.RhD, VolumeMl: t.VolumeML,
		StartedAt: ts(t.StartedAt), StartedBy: t.StartedBy,
		CheckedBy: t.CheckedBy, Observations: observations,
		Status: transfusionStatusToProto[t.Status], EndedAt: ts(t.EndedAt),
		Version: t.Version,
	}
	if t.Reaction != nil {
		out.Reaction = &nursingv1.TransfusionReaction{
			ReportedAt:   ts(t.Reaction.ReportedAt),
			ReportedBy:   t.Reaction.ReportedBy,
			Features:     t.Reaction.Features,
			ActionTaken:  t.Reaction.ActionTaken,
			UnitReturned: t.Reaction.UnitReturned,
		}
	}
	return out
}

func woundToProto(w *domain.WoundAssessment) *nursingv1.WoundAssessment {
	if w == nil {
		return nil
	}
	images := make([]*nursingv1.WoundImage, 0, len(w.Images))
	for _, i := range w.Images {
		images = append(images, &nursingv1.WoundImage{
			ImageId: i.ImageID, ConsentId: i.ConsentID,
			StorageKey: i.StorageKey, ContentType: i.ContentType,
			CapturedAt: ts(i.CapturedAt), CapturedBy: i.CapturedBy,
			Sequence: i.Sequence,
		})
	}
	out := &nursingv1.WoundAssessment{
		WoundAssessmentId: w.ID, PatientId: w.PatientID,
		EncounterId: w.EncounterID, WoundId: w.WoundID,
		Location: w.Location, BodyMapCode: codingToProto(w.BodyMapCode),
		Laterality: lateralityToProto[w.Laterality],
		Kind:       woundKindToProto[w.Kind], Stage: w.Stage,
		LengthMm: w.LengthMM, WidthMm: w.WidthMM, DepthMm: w.DepthMM,
		Appearance: w.Appearance, Exudate: w.Exudate,
		SurroundingSkin: w.SurroundingSkin,
		Images:          images, AreaMm2: w.AreaMM2(),
		AssessedAt: ts(w.AssessedAt), RecordedAt: ts(w.RecordedAt),
		AssessedBy: w.AssessedBy, Version: w.Version,
	}
	if w.PainScore != nil {
		// A pain score of 0 and an unrecorded one are different facts, which a
		// bare int32 cannot tell apart.
		out.PainScore = *w.PainScore
		out.PainScoreRecorded = true
	}
	return out
}

func educationToProto(e *domain.EducationRecord) *nursingv1.EducationRecord {
	if e == nil {
		return nil
	}
	return &nursingv1.EducationRecord{
		EducationId: e.ID, PatientId: e.PatientID, EncounterId: e.EncounterID,
		Topic: codingToProto(e.Topic), Learner: learnerToProto[e.Learner],
		LearnerName: e.LearnerName, Method: e.Method,
		Understanding: understandingToProto[e.Understanding],
		Barriers:      e.Barriers,
		TaughtAt:      ts(e.TaughtAt), TaughtBy: e.TaughtBy,
		Version: e.Version,
	}
}

func readinessToProto(r domain.DischargeReadiness) *nursingv1.DischargeReadiness {
	criteria := make([]*nursingv1.ReadinessCriterion, 0, len(r.Criteria))
	for _, c := range r.Criteria {
		criteria = append(criteria, &nursingv1.ReadinessCriterion{
			Key: c.Key, Label: c.Label, Met: c.Met, Note: c.Note,
		})
	}
	return &nursingv1.DischargeReadiness{
		Criteria: criteria, Ready: r.Ready(),
		AssessedAt: ts(r.AssessedAt), AssessedBy: r.AssessedBy,
	}
}

func assignmentToProto(a *domain.NurseAssignment) *nursingv1.NurseAssignment {
	if a == nil {
		return nil
	}
	return &nursingv1.NurseAssignment{
		AssignmentId: a.ID, UnitId: a.UnitID, BedId: a.BedID,
		PatientId: a.PatientID, NurseId: a.NurseID,
		Relationship:  relationshipToProto[a.Relationship],
		EffectiveFrom: ts(a.EffectiveFrom), EffectiveTo: ts(a.EffectiveTo),
		AssignedBy: a.AssignedBy, EndedReason: a.EndedReason,
		Version: a.Version,
	}
}

func acuityWeightsToProto(w domain.AcuityWeights) *nursingv1.AcuityWeights {
	return &nursingv1.AcuityWeights{
		Dependency: w.Dependency, OpenTask: w.OpenTask,
		OverdueTask: w.OverdueTask, Device: w.Device,
		HighRisk: w.HighRisk, Isolation: w.Isolation,
	}
}

func acuityWeightsFromProto(w *nursingv1.AcuityWeights) domain.AcuityWeights {
	if w == nil {
		return domain.DefaultAcuityWeights()
	}
	return domain.AcuityWeights{
		Dependency: w.GetDependency(), OpenTask: w.GetOpenTask(),
		OverdueTask: w.GetOverdueTask(), Device: w.GetDevice(),
		HighRisk: w.GetHighRisk(), Isolation: w.GetIsolation(),
	}
}

func unitAcuityToProto(u domain.UnitAcuity) *nursingv1.UnitAcuity {
	patients := make([]*nursingv1.PatientAcuity, 0, len(u.Patients))
	for _, p := range u.Patients {
		patients = append(patients, &nursingv1.PatientAcuity{
			PatientId: p.PatientID,
			Inputs: &nursingv1.AcuityInputs{
				DependencyScore: p.Inputs.DependencyScore,
				OpenTasks:       p.Inputs.OpenTasks,
				OverdueTasks:    p.Inputs.OverdueTasks,
				Devices:         p.Inputs.Devices,
				HighRisk:        p.Inputs.HighRisk,
				Isolation:       p.Inputs.Isolation,
			},
			Score: p.Score, Weights: acuityWeightsToProto(p.Weights),
		})
	}
	perNurse, available := u.PerNurse()
	return &nursingv1.UnitAcuity{
		UnitId: u.UnitID, AsOf: ts(u.AsOf), Patients: patients,
		NursesOnDuty: u.NursesOnDuty, Total: u.Total,
		// False when nobody is on duty: a ward with no nurses assigned is not a
		// ward with zero workload per nurse (SRS-NUR-016).
		PerNurse: perNurse, PerNurseAvailable: available,
	}
}

func downtimeToProto(e *domain.DowntimeEpisode) *nursingv1.DowntimeEpisode {
	if e == nil {
		return nil
	}
	return &nursingv1.DowntimeEpisode{
		EpisodeId: e.ID, UnitId: e.UnitID, Reason: e.Reason,
		StartedAt: ts(e.StartedAt), StartedBy: e.StartedBy,
		EndedAt: ts(e.EndedAt), EndedBy: e.EndedBy,
		ReconciledAt: ts(e.ReconciledAt), ReconciledBy: e.ReconciledBy,
		Version: e.Version,
	}
}
