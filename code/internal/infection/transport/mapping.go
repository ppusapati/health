// Package transport translates between the infection control contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction: an
// unrecognised onset stays empty and the domain refuses it rather than
// guessing "community acquired", which would take an infection out of the
// hospital's rate; an unrecognised outcome stays empty rather than passing.
package transport

import (
	"time"

	infectionv1 "github.com/ppusapati/health/code/gen/go/healthcare/infection/v1"
	"github.com/ppusapati/health/code/internal/infection/application"
	"github.com/ppusapati/health/code/internal/infection/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on the
		// wire, and a review date in 1970 is a review every board treats as
		// overdue.
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

var onsetFromWire = map[infectionv1.Onset]domain.Onset{
	infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED:    domain.OnsetCommunity,
	infectionv1.Onset_ONSET_HEALTHCARE_ASSOCIATED: domain.OnsetHealthcare,
	infectionv1.Onset_ONSET_INDETERMINATE:         domain.OnsetIndeterminate,
}

var onsetToWire = map[domain.Onset]infectionv1.Onset{
	domain.OnsetCommunity:     infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED,
	domain.OnsetHealthcare:    infectionv1.Onset_ONSET_HEALTHCARE_ASSOCIATED,
	domain.OnsetIndeterminate: infectionv1.Onset_ONSET_INDETERMINATE,
}

var siteFromWire = map[infectionv1.InfectionSite]domain.InfectionSite{
	infectionv1.InfectionSite_INFECTION_SITE_VENTILATOR_ASSOCIATED_PNEUMONIA: domain.SiteVAP,
	infectionv1.InfectionSite_INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM:        domain.SiteCLABSI,
	infectionv1.InfectionSite_INFECTION_SITE_CATHETER_ASSOCIATED_URINARY:     domain.SiteCAUTI,
	infectionv1.InfectionSite_INFECTION_SITE_SURGICAL_SITE:                   domain.SiteSSI,
	infectionv1.InfectionSite_INFECTION_SITE_BLOODSTREAM:                     domain.SiteBloodstream,
	infectionv1.InfectionSite_INFECTION_SITE_RESPIRATORY:                     domain.SiteRespiratory,
	infectionv1.InfectionSite_INFECTION_SITE_URINARY:                         domain.SiteUrinary,
	infectionv1.InfectionSite_INFECTION_SITE_SKIN_SOFT_TISSUE:                domain.SiteSkin,
	infectionv1.InfectionSite_INFECTION_SITE_GASTROINTESTINAL:                domain.SiteGastro,
	infectionv1.InfectionSite_INFECTION_SITE_OTHER:                           domain.SiteOther,
}

var siteToWire = map[domain.InfectionSite]infectionv1.InfectionSite{}

var deviceFromWire = map[infectionv1.DeviceKind]domain.DeviceKind{
	infectionv1.DeviceKind_DEVICE_KIND_VENTILATOR:       domain.DeviceVentilator,
	infectionv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE:     domain.DeviceCentralLine,
	infectionv1.DeviceKind_DEVICE_KIND_URINARY_CATHETER: domain.DeviceUrinaryCatheter,
}

var deviceToWire = map[domain.DeviceKind]infectionv1.DeviceKind{}

var caseStateFromWire = map[infectionv1.CaseState]domain.CaseState{
	infectionv1.CaseState_CASE_STATE_SUSPECTED: domain.CaseSuspected,
	infectionv1.CaseState_CASE_STATE_CONFIRMED: domain.CaseConfirmed,
	infectionv1.CaseState_CASE_STATE_REFUTED:   domain.CaseRefuted,
	infectionv1.CaseState_CASE_STATE_CLOSED:    domain.CaseClosed,
}

var caseStateToWire = map[domain.CaseState]infectionv1.CaseState{}

var precautionFromWire = map[infectionv1.Precaution]domain.Precaution{
	infectionv1.Precaution_PRECAUTION_STANDARD:   domain.PrecautionStandard,
	infectionv1.Precaution_PRECAUTION_CONTACT:    domain.PrecautionContact,
	infectionv1.Precaution_PRECAUTION_DROPLET:    domain.PrecautionDroplet,
	infectionv1.Precaution_PRECAUTION_AIRBORNE:   domain.PrecautionAirborne,
	infectionv1.Precaution_PRECAUTION_PROTECTIVE: domain.PrecautionProtective,
}

var precautionToWire = map[domain.Precaution]infectionv1.Precaution{}

var outbreakStateFromWire = map[infectionv1.OutbreakState]domain.OutbreakState{
	infectionv1.OutbreakState_OUTBREAK_STATE_SUSPECTED: domain.OutbreakSuspected,
	infectionv1.OutbreakState_OUTBREAK_STATE_DECLARED:  domain.OutbreakDeclared,
	infectionv1.OutbreakState_OUTBREAK_STATE_CONTAINED: domain.OutbreakContained,
	infectionv1.OutbreakState_OUTBREAK_STATE_CLOSED:    domain.OutbreakClosed,
	infectionv1.OutbreakState_OUTBREAK_STATE_REFUTED:   domain.OutbreakRefuted,
}

var outbreakStateToWire = map[domain.OutbreakState]infectionv1.OutbreakState{}

var membershipFromWire = map[infectionv1.MembershipReason]domain.MembershipReason{
	infectionv1.MembershipReason_MEMBERSHIP_REASON_MEETS_DEFINITION:     domain.MemberMeetsDefinition,
	infectionv1.MembershipReason_MEMBERSHIP_REASON_EPIDEMIOLOGICAL_LINK: domain.MemberEpidemiologicalLink,
	infectionv1.MembershipReason_MEMBERSHIP_REASON_EXCLUDED:             domain.MemberExcluded,
}

var membershipToWire = map[domain.MembershipReason]infectionv1.MembershipReason{}

var disciplineFromWire = map[infectionv1.Discipline]domain.Discipline{
	infectionv1.Discipline_DISCIPLINE_DOCTOR:        domain.DisciplineDoctor,
	infectionv1.Discipline_DISCIPLINE_NURSE:         domain.DisciplineNurse,
	infectionv1.Discipline_DISCIPLINE_ALLIED_HEALTH: domain.DisciplineAllied,
	infectionv1.Discipline_DISCIPLINE_SUPPORT_STAFF: domain.DisciplineSupport,
	infectionv1.Discipline_DISCIPLINE_STUDENT:       domain.DisciplineStudent,
	infectionv1.Discipline_DISCIPLINE_VISITOR:       domain.DisciplineVisitor,
}

var disciplineToWire = map[domain.Discipline]infectionv1.Discipline{}

var momentFromWire = map[infectionv1.Moment]domain.Moment{
	infectionv1.Moment_MOMENT_BEFORE_PATIENT_CONTACT:     domain.MomentBeforePatient,
	infectionv1.Moment_MOMENT_BEFORE_ASEPTIC_PROCEDURE:   domain.MomentBeforeAseptic,
	infectionv1.Moment_MOMENT_AFTER_BODY_FLUID_EXPOSURE:  domain.MomentAfterBodyFluid,
	infectionv1.Moment_MOMENT_AFTER_PATIENT_CONTACT:      domain.MomentAfterPatient,
	infectionv1.Moment_MOMENT_AFTER_PATIENT_SURROUNDINGS: domain.MomentAfterSurroundings,
}

var momentToWire = map[domain.Moment]infectionv1.Moment{}

var actionFromWire = map[infectionv1.HygieneAction]domain.Action{
	infectionv1.HygieneAction_HYGIENE_ACTION_ALCOHOL_RUB:    domain.ActionRub,
	infectionv1.HygieneAction_HYGIENE_ACTION_SOAP_AND_WATER: domain.ActionWash,
	infectionv1.HygieneAction_HYGIENE_ACTION_MISSED:         domain.ActionMissed,
	infectionv1.HygieneAction_HYGIENE_ACTION_GLOVES_ONLY:    domain.ActionGlovesOnly,
}

var actionToWire = map[domain.Action]infectionv1.HygieneAction{}

var exposureKindFromWire = map[infectionv1.ExposureKind]domain.ExposureKind{
	infectionv1.ExposureKind_EXPOSURE_KIND_NEEDLESTICK:          domain.ExposureNeedlestick,
	infectionv1.ExposureKind_EXPOSURE_KIND_SHARPS:               domain.ExposureSharps,
	infectionv1.ExposureKind_EXPOSURE_KIND_MUCOCUTANEOUS_SPLASH: domain.ExposureSplash,
	infectionv1.ExposureKind_EXPOSURE_KIND_BITE:                 domain.ExposureBite,
	infectionv1.ExposureKind_EXPOSURE_KIND_AIRBORNE_CONTACT:     domain.ExposureAirborne,
}

var exposureKindToWire = map[domain.ExposureKind]infectionv1.ExposureKind{}

var taskStateFromWire = map[infectionv1.TaskState]domain.TaskState{
	infectionv1.TaskState_TASK_STATE_DUE:            domain.TaskDue,
	infectionv1.TaskState_TASK_STATE_DONE:           domain.TaskDone,
	infectionv1.TaskState_TASK_STATE_DECLINED:       domain.TaskDeclined,
	infectionv1.TaskState_TASK_STATE_NOT_APPLICABLE: domain.TaskNotApplicable,
}

var taskStateToWire = map[domain.TaskState]infectionv1.TaskState{}

var triggerFromWire = map[infectionv1.TriggerKind]domain.TriggerKind{
	infectionv1.TriggerKind_TRIGGER_KIND_RESTRICTED_AGENT:  domain.TriggerRestrictedAgent,
	infectionv1.TriggerKind_TRIGGER_KIND_DURATION:          domain.TriggerDuration,
	infectionv1.TriggerKind_TRIGGER_KIND_BUG_DRUG_MISMATCH: domain.TriggerMismatch,
	infectionv1.TriggerKind_TRIGGER_KIND_DE_ESCALATION:     domain.TriggerDeEscalation,
	infectionv1.TriggerKind_TRIGGER_KIND_IV_TO_ORAL:        domain.TriggerIVToOral,
	infectionv1.TriggerKind_TRIGGER_KIND_REDUNDANT_COVER:   domain.TriggerRedundantCover,
}

var triggerToWire = map[domain.TriggerKind]infectionv1.TriggerKind{}

var reviewStateFromWire = map[infectionv1.ReviewState]domain.ReviewState{
	infectionv1.ReviewState_REVIEW_STATE_OPEN:      domain.ReviewOpen,
	infectionv1.ReviewState_REVIEW_STATE_ADVISED:   domain.ReviewAdvised,
	infectionv1.ReviewState_REVIEW_STATE_CLOSED:    domain.ReviewClosed,
	infectionv1.ReviewState_REVIEW_STATE_WITHDRAWN: domain.ReviewWithdrawn,
}

var reviewStateToWire = map[domain.ReviewState]infectionv1.ReviewState{}

var recommendationFromWire = map[infectionv1.Recommendation]domain.Recommendation{
	infectionv1.Recommendation_RECOMMENDATION_CONTINUE:                      domain.RecommendContinue,
	infectionv1.Recommendation_RECOMMENDATION_STOP:                          domain.RecommendStop,
	infectionv1.Recommendation_RECOMMENDATION_NARROW_SPECTRUM:               domain.RecommendNarrow,
	infectionv1.Recommendation_RECOMMENDATION_SWITCH_TO_ORAL:                domain.RecommendSwitchOral,
	infectionv1.Recommendation_RECOMMENDATION_CHANGE_DOSE:                   domain.RecommendChangeDose,
	infectionv1.Recommendation_RECOMMENDATION_SEND_CULTURES:                 domain.RecommendSendCulture,
	infectionv1.Recommendation_RECOMMENDATION_REFER_TO_INFECTION_SPECIALIST: domain.RecommendReferID,
}

var recommendationToWire = map[domain.Recommendation]infectionv1.Recommendation{}

var responseFromWire = map[infectionv1.Response]domain.Response{
	infectionv1.Response_RESPONSE_ACCEPTED: domain.ResponseAccepted,
	infectionv1.Response_RESPONSE_DECLINED: domain.ResponseDeclined,
	infectionv1.Response_RESPONSE_MODIFIED: domain.ResponseModified,
}

var responseToWire = map[domain.Response]infectionv1.Response{}

var sampleKindFromWire = map[infectionv1.SampleKind]domain.SampleKind{
	infectionv1.SampleKind_SAMPLE_KIND_WATER:                domain.SampleWater,
	infectionv1.SampleKind_SAMPLE_KIND_DIALYSIS_WATER:       domain.SampleDialysisWater,
	infectionv1.SampleKind_SAMPLE_KIND_ICE:                  domain.SampleIce,
	infectionv1.SampleKind_SAMPLE_KIND_AIR_SETTLE_PLATE:     domain.SampleAirSettle,
	infectionv1.SampleKind_SAMPLE_KIND_AIR_PARTICLE_COUNT:   domain.SampleAirParticle,
	infectionv1.SampleKind_SAMPLE_KIND_SURFACE_SWAB:         domain.SampleSurfaceSwab,
	infectionv1.SampleKind_SAMPLE_KIND_ENDOSCOPE_RINSE:      domain.SampleEndoscopeRinse,
	infectionv1.SampleKind_SAMPLE_KIND_VENTILATION_PRESSURE: domain.SamplePressure,
}

var sampleKindToWire = map[domain.SampleKind]infectionv1.SampleKind{}

var outcomeToWire = map[domain.Outcome]infectionv1.Outcome{
	domain.OutcomePass:         infectionv1.Outcome_OUTCOME_PASS,
	domain.OutcomeAction:       infectionv1.Outcome_OUTCOME_ACTION_LEVEL,
	domain.OutcomeFail:         infectionv1.Outcome_OUTCOME_FAIL,
	domain.OutcomeUnassessable: infectionv1.Outcome_OUTCOME_UNASSESSABLE,
}

var sampleStateToWire = map[domain.SampleState]infectionv1.SampleState{
	domain.SampleCollected: infectionv1.SampleState_SAMPLE_STATE_COLLECTED,
	domain.SampleResulted:  infectionv1.SampleState_SAMPLE_STATE_RESULTED,
	domain.SampleClosed:    infectionv1.SampleState_SAMPLE_STATE_CLOSED,
}

var actionStateToWire = map[domain.ActionState]infectionv1.ActionState{
	domain.ActionOpen:     infectionv1.ActionState_ACTION_STATE_OPEN,
	domain.ActionDone:     infectionv1.ActionState_ACTION_STATE_DONE,
	domain.ActionVerified: infectionv1.ActionState_ACTION_STATE_VERIFIED,
}

// The reverse tables are built from the forward ones, so a value added to one
// direction cannot be forgotten in the other.
func init() {
	for wire, value := range siteFromWire {
		siteToWire[value] = wire
	}
	for wire, value := range deviceFromWire {
		deviceToWire[value] = wire
	}
	for wire, value := range caseStateFromWire {
		caseStateToWire[value] = wire
	}
	for wire, value := range precautionFromWire {
		precautionToWire[value] = wire
	}
	for wire, value := range outbreakStateFromWire {
		outbreakStateToWire[value] = wire
	}
	for wire, value := range membershipFromWire {
		membershipToWire[value] = wire
	}
	for wire, value := range disciplineFromWire {
		disciplineToWire[value] = wire
	}
	for wire, value := range momentFromWire {
		momentToWire[value] = wire
	}
	for wire, value := range actionFromWire {
		actionToWire[value] = wire
	}
	for wire, value := range exposureKindFromWire {
		exposureKindToWire[value] = wire
	}
	for wire, value := range taskStateFromWire {
		taskStateToWire[value] = wire
	}
	for wire, value := range triggerFromWire {
		triggerToWire[value] = wire
	}
	for wire, value := range reviewStateFromWire {
		reviewStateToWire[value] = wire
	}
	for wire, value := range recommendationFromWire {
		recommendationToWire[value] = wire
	}
	for wire, value := range responseFromWire {
		responseToWire[value] = wire
	}
	for wire, value := range sampleKindFromWire {
		sampleKindToWire[value] = wire
	}
}

func caseToProto(c domain.SurveillanceCase) *infectionv1.SurveillanceCase {
	return &infectionv1.SurveillanceCase{
		CaseId: c.ID, Reference: c.Reference, PatientId: c.PatientID,
		EncounterId: c.EncounterID, FacilityId: c.FacilityID,
		LocationId: c.LocationID, Organism: c.Organism,
		OrganismCode: c.OrganismCode, Site: siteToWire[c.Site],
		MultidrugResistant: c.MultidrugResistant,
		Onset:              onsetToWire[c.Onset],
		OnsetOverride:      onsetToWire[c.OnsetOverride],
		OnsetOverrideWhy:   c.OnsetOverrideWhy,
		OnsetOverriddenBy:  c.OnsetOverriddenBy,
		AdmittedAt:         stamp(c.AdmittedAt), OnsetAt: stamp(c.OnsetAt),
		WindowHours: int32(c.WindowHours), Criteria: c.Criteria,
		ReviewedBy: c.ReviewedBy, ReviewedAt: stamp(c.ReviewedAt),
		DeviceInSitu: c.DeviceInSitu, DeviceDays: int32(c.DeviceDays),
		State: caseStateToWire[c.State], Notes: c.Notes,
		ReportedAt: stamp(c.ReportedAt), ReportedBy: c.ReportedBy,
		ClosedAt: stamp(c.ClosedAt), ClosedBy: c.ClosedBy,
		Version: c.Version,
	}
}

func deviceDaysToProto(c domain.DeviceDayCount) *infectionv1.DeviceDayCount {
	return &infectionv1.DeviceDayCount{
		CountId: c.ID, FacilityId: c.FacilityID, LocationId: c.LocationID,
		Device: deviceToWire[c.Device], CountedOn: stamp(c.On),
		PatientDays: int32(c.PatientDays), DeviceDays: int32(c.DeviceDays),
		RecordedAt: stamp(c.RecordedAt), RecordedBy: c.RecordedBy,
	}
}

func rateToProto(r application.Rate) *infectionv1.Rate {
	return &infectionv1.Rate{
		Site: siteToWire[r.Site], Device: deviceToWire[r.Device],
		LocationId: r.Location,
		PeriodFrom: stamp(r.From), PeriodTo: stamp(r.To),
		Infections:                  int32(r.Infections),
		DeviceDays:                  int32(r.DeviceDays),
		PatientDays:                 int32(r.PatientDays),
		PerThousandDeviceDaysTenths: int32(r.PerThousandDeviceDays),
		UtilisationPermille:         int32(r.UtilisationPermille),
		Unanswerable:                r.Unanswerable,
		Onsets: &infectionv1.OnsetSummary{
			Healthcare:            int32(r.Onsets.Healthcare),
			Community:             int32(r.Onsets.Community),
			Indeterminate:         int32(r.Onsets.Indeterminate),
			Overridden:            int32(r.Onsets.Overridden),
			OverriddenToCommunity: int32(r.Onsets.OverriddenToCommunity),
		},
		IndicatorCode:     r.IndicatorCode,
		IndicatorRevision: int32(r.IndicatorRevision),
	}
}

func isolationToProto(i domain.Isolation) *infectionv1.Isolation {
	return &infectionv1.Isolation{
		IsolationId: i.ID, PatientId: i.PatientID,
		EncounterId: i.EncounterID, FacilityId: i.FacilityID,
		LocationId: i.LocationID, BedId: i.BedID,
		Precaution: precautionToWire[i.Precaution], Reason: i.Reason,
		CaseId: i.CaseID, StartedAt: stamp(i.StartedAt),
		StartedBy: i.StartedBy, ReviewDue: stamp(i.ReviewDue),
		EndedAt: stamp(i.EndedAt), EndedBy: i.EndedBy,
		EndReason: i.EndReason, Version: i.Version,
	}
}

// boardEntryToProto carries the precaution, the PPE and the side-room flag.
// There is no reason field on the message and nothing here that could fill
// one.
func boardEntryToProto(e domain.BoardEntry) *infectionv1.BoardEntry {
	return &infectionv1.BoardEntry{
		BedId: e.BedID, LocationId: e.LocationID, PatientId: e.PatientID,
		Precaution: precautionToWire[e.Precaution], Ppe: e.PPE,
		RequiresSideRoom: e.RequiresSideRoom, Since: stamp(e.Since),
		ReviewOverdue: e.ReviewOverdue,
	}
}

func alertRuleToProto(r domain.AlertRule) *infectionv1.AlertRule {
	return &infectionv1.AlertRule{
		RuleId: r.ID, Code: r.Code, Name: r.Name,
		Revision: int32(r.Revision), Organisms: r.Organisms,
		LookbackDays: int32(r.LookbackDays),
		Precaution:   precautionToWire[r.Precaution], Advice: r.Advice,
		Approved: r.Approved, ApprovedBy: r.ApprovedBy,
		ApprovedAt:    stamp(r.ApprovedAt),
		EffectiveFrom: stamp(r.EffectiveFrom),
		SupersededAt:  stamp(r.SupersededAt),
		CreatedAt:     stamp(r.CreatedAt), CreatedBy: r.CreatedBy,
	}
}

func alertToProto(a domain.Alert) *infectionv1.Alert {
	return &infectionv1.Alert{
		AlertId: a.ID, PatientId: a.PatientID,
		EncounterId: a.EncounterID, FacilityId: a.FacilityID,
		RuleId: a.RuleID, RuleCode: a.RuleCode,
		RuleRevision: int32(a.RuleRevision),
		Organism:     a.Organism, OrganismCode: a.OrganismCode,
		LastPositiveAt: stamp(a.LastPositiveAt),
		Precaution:     precautionToWire[a.Precaution], Advice: a.Advice,
		RaisedAt:       stamp(a.RaisedAt),
		AcknowledgedAt: stamp(a.AcknowledgedAt),
		AcknowledgedBy: a.AcknowledgedBy,
		Overridden:     a.Overridden, OverrideWhy: a.OverrideWhy,
		OverriddenBy: a.OverriddenBy, OverriddenAt: stamp(a.OverriddenAt),
	}
}

func outbreakToProto(o domain.Outbreak) *infectionv1.Outbreak {
	return &infectionv1.Outbreak{
		OutbreakId: o.ID, Reference: o.Reference, Organism: o.Organism,
		CaseDefinition: o.CaseDefinition, Locations: o.Locations,
		WindowFrom: stamp(o.WindowFrom), WindowTo: stamp(o.WindowTo),
		State: outbreakStateToWire[o.State], Findings: o.Findings,
		ControlMeasures: o.ControlMeasures, ActionIds: o.ActionIDs,
		DeclaredAt: stamp(o.DeclaredAt), DeclaredBy: o.DeclaredBy,
		ClosedAt: stamp(o.ClosedAt), ClosedBy: o.ClosedBy,
		ClosureWhy: o.ClosureWhy,
		CreatedAt:  stamp(o.CreatedAt), CreatedBy: o.CreatedBy,
		Version: o.Version,
	}
}

func membershipToProto(m domain.Membership) *infectionv1.Membership {
	return &infectionv1.Membership{
		MembershipId: m.ID, OutbreakId: m.OutbreakID, CaseId: m.CaseID,
		PatientId: m.PatientID, Reason: membershipToWire[m.Reason],
		Note: m.Note, DecidedAt: stamp(m.DecidedAt), DecidedBy: m.DecidedBy,
	}
}

func clusterToProto(c domain.ClusterSummary) *infectionv1.ClusterSummary {
	return &infectionv1.ClusterSummary{
		OutbreakId: c.OutbreakID, Included: int32(c.Included),
		Excluded: int32(c.Excluded), ByLink: int32(c.ByLink),
		Locations:  c.Locations,
		FirstOnset: stamp(c.FirstOnset), LastOnset: stamp(c.LastOnset),
	}
}

func hygieneSessionToProto(s domain.HygieneSession) *infectionv1.HygieneSession {
	return &infectionv1.HygieneSession{
		SessionId: s.ID, FacilityId: s.FacilityID,
		LocationId: s.LocationID, ObserverId: s.ObserverID,
		StartedAt: stamp(s.StartedAt), EndedAt: stamp(s.EndedAt),
		Notes: s.Notes, Version: s.Version,
	}
}

func observationToProto(
	o domain.HygieneObservation) *infectionv1.HygieneObservation {

	return &infectionv1.HygieneObservation{
		ObservationId: o.ID, SessionId: o.SessionID,
		Discipline: disciplineToWire[o.Discipline],
		Moment:     momentToWire[o.Moment],
		Action:     actionToWire[o.Action], GlovesWorn: o.GlovesWorn,
		ObservedAt: stamp(o.ObservedAt),
	}
}

func complianceToProto(c domain.Compliance) *infectionv1.Compliance {
	return &infectionv1.Compliance{
		Group: c.Group, Opportunities: int32(c.Opportunities),
		Performed: int32(c.Performed), Permille: int32(c.Permille),
		GlovesInsteadOf: int32(c.GlovesInsteadOf), Suppressed: c.Suppressed,
	}
}

func exposureToProto(e domain.Exposure) *infectionv1.Exposure {
	return &infectionv1.Exposure{
		ExposureId: e.ID, Reference: e.Reference, StaffId: e.StaffID,
		Discipline: disciplineToWire[e.Discipline],
		FacilityId: e.FacilityID, LocationId: e.LocationID,
		Kind: exposureKindToWire[e.Kind], Device: e.Device,
		Circumstance: e.Circumstance, DeepInjury: e.DeepInjury,
		SourcePatientId: e.SourcePatientID, SourceKnown: e.SourceKnown,
		SourceConsented: e.SourceConsented,
		OccurredAt:      stamp(e.OccurredAt), ReportedAt: stamp(e.ReportedAt),
		ReportedBy: e.ReportedBy,
		ClosedAt:   stamp(e.ClosedAt), ClosedBy: e.ClosedBy,
		Outcome: e.Outcome, Version: e.Version,
	}
}

func taskToProto(t domain.ExposureTask) *infectionv1.ExposureTask {
	return &infectionv1.ExposureTask{
		TaskId: t.ID, ExposureId: t.ExposureID, Code: t.Code,
		DueBy: stamp(t.DueBy), State: taskStateToWire[t.State],
		Outcome:     t.Outcome,
		CompletedAt: stamp(t.CompletedAt), CompletedBy: t.CompletedBy,
	}
}

func stewardshipRuleToProto(
	r domain.StewardshipRule) *infectionv1.StewardshipRule {

	return &infectionv1.StewardshipRule{
		RuleId: r.ID, Code: r.Code, Name: r.Name,
		Revision: int32(r.Revision), Kind: triggerToWire[r.Kind],
		Agents: r.Agents, AllAgents: r.AllAgents,
		DayThreshold: int32(r.DayThreshold), Prompt: r.Prompt,
		Approved: r.Approved, ApprovedBy: r.ApprovedBy,
		ApprovedAt:    stamp(r.ApprovedAt),
		EffectiveFrom: stamp(r.EffectiveFrom),
		SupersededAt:  stamp(r.SupersededAt),
		CreatedAt:     stamp(r.CreatedAt), CreatedBy: r.CreatedBy,
	}
}

func reviewToProto(r domain.StewardshipReview) *infectionv1.StewardshipReview {
	return &infectionv1.StewardshipReview{
		ReviewId: r.ID, PatientId: r.PatientID,
		EncounterId: r.EncounterID, LocationId: r.LocationID,
		RuleId: r.RuleID, RuleCode: r.RuleCode,
		RuleRevision: int32(r.RuleRevision), Kind: triggerToWire[r.Kind],
		Agent: r.Agent, OrderId: r.OrderID, Why: r.Why,
		State:    reviewStateToWire[r.State],
		RaisedAt: stamp(r.RaisedAt), DueBy: stamp(r.DueBy),
		Recommendation: recommendationToWire[r.Recommendation],
		Advice:         r.Advice, ReviewedBy: r.ReviewedBy,
		ReviewedAt:     stamp(r.ReviewedAt),
		Response:       responseToWire[r.Response],
		ResponseReason: r.ResponseReason, RespondedBy: r.RespondedBy,
		RespondedAt:     stamp(r.RespondedAt),
		WithdrawnReason: r.WithdrawnReason, Version: r.Version,
	}
}

func stewardshipSummaryToProto(
	r application.StewardshipReport) *infectionv1.StewardshipSummary {

	return &infectionv1.StewardshipSummary{
		Raised: int32(r.Summary.Raised), Awaiting: int32(r.Summary.Awaiting),
		Advised: int32(r.Summary.Advised), Accepted: int32(r.Summary.Accepted),
		Modified:           int32(r.Summary.Modified),
		Declined:           int32(r.Summary.Declined),
		Withdrawn:          int32(r.Summary.Withdrawn),
		Overdue:            int32(r.Summary.Overdue),
		AcceptancePermille: int32(r.Summary.AcceptancePermille),
		Unanswerable:       r.Summary.Unanswerable,
		TherapyRate: &infectionv1.TherapyRate{
			TherapyDays:       int32(r.TherapyRate.TherapyDays),
			PatientDays:       int32(r.TherapyRate.PatientDays),
			PerThousandTenths: int32(r.TherapyRate.PerThousandTenths),
			Unanswerable:      r.TherapyRate.Unanswerable,
		},
		IndicatorCode:     r.IndicatorCode,
		IndicatorRevision: int32(r.IndicatorRevision),
	}
}

func limitToProto(l domain.EnvironmentalLimit) *infectionv1.EnvironmentalLimit {
	return &infectionv1.EnvironmentalLimit{
		LimitId: l.ID, Code: l.Code, Name: l.Name,
		Revision: int32(l.Revision), SampleKind: sampleKindToWire[l.SampleKind],
		Unit: l.Unit, ActionLevel: l.ActionLevel, FailLevel: l.FailLevel,
		DetectionFails: l.DetectionFails, BelowIsFailure: l.BelowIsFailure,
		Approved: l.Approved, ApprovedBy: l.ApprovedBy,
		ApprovedAt:    stamp(l.ApprovedAt),
		EffectiveFrom: stamp(l.EffectiveFrom),
		SupersededAt:  stamp(l.SupersededAt),
		CreatedAt:     stamp(l.CreatedAt), CreatedBy: l.CreatedBy,
	}
}

func planToProto(p domain.SamplingPlan) *infectionv1.SamplingPlan {
	return &infectionv1.SamplingPlan{
		PlanId: p.ID, Code: p.Code, SampleKind: sampleKindToWire[p.Kind],
		FacilityId: p.FacilityID, LocationId: p.LocationID,
		SamplePoint: p.SamplePoint, EveryDays: int32(p.EveryDays),
		Active: p.Active, StartedAt: stamp(p.StartedAt),
		StoppedAt: stamp(p.StoppedAt),
	}
}

func sampleToProto(
	s domain.EnvironmentalSample) *infectionv1.EnvironmentalSample {

	return &infectionv1.EnvironmentalSample{
		SampleId: s.ID, Reference: s.Reference,
		SampleKind: sampleKindToWire[s.Kind], FacilityId: s.FacilityID,
		LocationId: s.LocationID, SamplePoint: s.SamplePoint,
		PlanId: s.PlanID, OutbreakId: s.OutbreakID,
		RepeatOfId:  s.RepeatOfID,
		CollectedAt: stamp(s.CollectedAt), CollectedBy: s.CollectedBy,
		Method: s.Method, State: sampleStateToWire[s.State],
		LabReference: s.LabReference, Value: s.Value, Unit: s.Unit,
		Organism: s.Organism, Detected: s.Detected,
		ResultedAt: stamp(s.ResultedAt), ResultedBy: s.ResultedBy,
		Outcome: outcomeToWire[s.Outcome], LimitCode: s.LimitCode,
		LimitRevision: int32(s.LimitRevision),
		ClosedAt:      stamp(s.ClosedAt), ClosedBy: s.ClosedBy,
		Version: s.Version,
	}
}

func correctiveActionToProto(
	a domain.CorrectiveAction) *infectionv1.CorrectiveAction {

	return &infectionv1.CorrectiveAction{
		ActionId: a.ID, SampleId: a.SampleID, LocationId: a.LocationID,
		Action: a.Action, Owner: a.Owner, DueBy: stamp(a.DueBy),
		State:  actionStateToWire[a.State],
		DoneAt: stamp(a.DoneAt), DoneBy: a.DoneBy, DoneNote: a.DoneNote,
		RepeatSampleId: a.RepeatSampleID,
		VerifiedAt:     stamp(a.VerifiedAt), VerifiedBy: a.VerifiedBy,
		Version: a.Version,
	}
}

func duePointToProto(p domain.DuePoint) *infectionv1.DuePoint {
	return &infectionv1.DuePoint{
		PlanId: p.PlanID, SampleKind: sampleKindToWire[p.Kind],
		LocationId: p.LocationID, SamplePoint: p.SamplePoint,
		LastTakenAt: stamp(p.LastTakenAt), DueAt: stamp(p.DueAt),
		OverdueDays: int32(p.OverdueDays), NeverSampled: p.NeverSampled,
	}
}

func environmentSummaryToProto(
	s domain.EnvironmentSummary) *infectionv1.EnvironmentSummary {

	return &infectionv1.EnvironmentSummary{
		Samples: int32(s.Samples), Passed: int32(s.Passed),
		ActionLevel: int32(s.ActionLevel), Failed: int32(s.Failed),
		Unassessable:    int32(s.Unassessable),
		ActionsOpen:     int32(s.ActionsOpen),
		ActionsDone:     int32(s.ActionsDone),
		ActionsVerified: int32(s.ActionsVerified),
		PassPermille:    int32(s.PassPermille),
		Unanswerable:    s.Unanswerable,
	}
}
