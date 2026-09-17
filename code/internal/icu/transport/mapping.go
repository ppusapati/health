// Package transport translates between the critical-care contract and the
// domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default is chosen to fail in the safe direction:
// an unset source is unspecified rather than manual, an unset validation is
// pending rather than confirmed, and an unset outcome is one Discharge
// refuses.
package transport

import (
	"time"

	icuv1 "github.com/ppusapati/health/code/gen/go/healthcare/icu/v1"
	"github.com/ppusapati/health/code/internal/icu/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch. A zero timestamp on the wire reads as
		// 1970, and every clock derived from it would be wrong by 56 years.
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

var admissionSourceFromWire = map[icuv1.AdmissionSource]domain.AdmissionSource{
	icuv1.AdmissionSource_ADMISSION_SOURCE_EMERGENCY: domain.AdmissionEmergency,
	icuv1.AdmissionSource_ADMISSION_SOURCE_WARD:      domain.AdmissionWard,
	icuv1.AdmissionSource_ADMISSION_SOURCE_THEATRE:   domain.AdmissionTheatre,
	icuv1.AdmissionSource_ADMISSION_SOURCE_OTHER_ICU: domain.AdmissionOtherICU,
	icuv1.AdmissionSource_ADMISSION_SOURCE_EXTERNAL:  domain.AdmissionExternal,
	icuv1.AdmissionSource_ADMISSION_SOURCE_DIRECT:    domain.AdmissionDirect,
}

// admissionSource maps the wire enum. An unset one stays unspecified, which
// NewEpisode refuses — rather than defaulting to "ward", which would make a
// client that forgot the field report every admission as a ward
// deterioration.
func admissionSource(in icuv1.AdmissionSource) domain.AdmissionSource {
	return admissionSourceFromWire[in]
}

var admissionSourceToWire = map[domain.AdmissionSource]icuv1.AdmissionSource{
	domain.AdmissionEmergency: icuv1.AdmissionSource_ADMISSION_SOURCE_EMERGENCY,
	domain.AdmissionWard:      icuv1.AdmissionSource_ADMISSION_SOURCE_WARD,
	domain.AdmissionTheatre:   icuv1.AdmissionSource_ADMISSION_SOURCE_THEATRE,
	domain.AdmissionOtherICU:  icuv1.AdmissionSource_ADMISSION_SOURCE_OTHER_ICU,
	domain.AdmissionExternal:  icuv1.AdmissionSource_ADMISSION_SOURCE_EXTERNAL,
	domain.AdmissionDirect:    icuv1.AdmissionSource_ADMISSION_SOURCE_DIRECT,
}

var episodeStatusToWire = map[domain.EpisodeStatus]icuv1.EpisodeStatus{
	domain.EpisodeOpen:             icuv1.EpisodeStatus_EPISODE_STATUS_OPEN,
	domain.EpisodeReadyForTransfer: icuv1.EpisodeStatus_EPISODE_STATUS_READY_FOR_TRANSFER,
	domain.EpisodeClosed:           icuv1.EpisodeStatus_EPISODE_STATUS_CLOSED,
}

var outcomeFromWire = map[icuv1.EpisodeOutcome]domain.Outcome{
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_WARD:              domain.OutcomeWard,
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_OTHER_ICU:         domain.OutcomeOtherICU,
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_THEATRE:           domain.OutcomeTheatre,
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_EXTERNAL_TRANSFER: domain.OutcomeExternal,
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_DISCHARGE:         domain.OutcomeDischarge,
	icuv1.EpisodeOutcome_EPISODE_OUTCOME_DEATH:             domain.OutcomeDeath,
}

// outcome maps the wire enum. An unset one is OutcomeUnspecified, which
// Discharge refuses: an episode must not close on a field a client forgot.
func outcome(in icuv1.EpisodeOutcome) domain.Outcome { return outcomeFromWire[in] }

var outcomeToWire = map[domain.Outcome]icuv1.EpisodeOutcome{
	domain.OutcomeWard:      icuv1.EpisodeOutcome_EPISODE_OUTCOME_WARD,
	domain.OutcomeOtherICU:  icuv1.EpisodeOutcome_EPISODE_OUTCOME_OTHER_ICU,
	domain.OutcomeTheatre:   icuv1.EpisodeOutcome_EPISODE_OUTCOME_THEATRE,
	domain.OutcomeExternal:  icuv1.EpisodeOutcome_EPISODE_OUTCOME_EXTERNAL_TRANSFER,
	domain.OutcomeDischarge: icuv1.EpisodeOutcome_EPISODE_OUTCOME_DISCHARGE,
	domain.OutcomeDeath:     icuv1.EpisodeOutcome_EPISODE_OUTCOME_DEATH,
}

var sourceFromWire = map[icuv1.ObservationSource]domain.SourceKind{
	icuv1.ObservationSource_OBSERVATION_SOURCE_MANUAL:     domain.SourceManual,
	icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE:     domain.SourceDevice,
	icuv1.ObservationSource_OBSERVATION_SOURCE_CALCULATED: domain.SourceCalculated,
	icuv1.ObservationSource_OBSERVATION_SOURCE_UNKNOWN:    domain.SourceUnknown,
}

// observationSource defaults an unset enum to manual.
//
// The safe direction here is the opposite of the others: NewObservation
// defaults an empty source to manual too, and a value that arrived as a device
// reading without saying so would otherwise skip validation and land straight
// in the chart. Manual means a person is answerable for it, which is the
// stricter claim.
func observationSource(in icuv1.ObservationSource) domain.SourceKind {
	if mapped, ok := sourceFromWire[in]; ok {
		return mapped
	}
	return domain.SourceManual
}

var sourceToWire = map[domain.SourceKind]icuv1.ObservationSource{
	domain.SourceManual:     icuv1.ObservationSource_OBSERVATION_SOURCE_MANUAL,
	domain.SourceDevice:     icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
	domain.SourceCalculated: icuv1.ObservationSource_OBSERVATION_SOURCE_CALCULATED,
	domain.SourceUnknown:    icuv1.ObservationSource_OBSERVATION_SOURCE_UNKNOWN,
}

var validationToWire = map[domain.Validation]icuv1.ValidationState{
	domain.ValidationNotRequired: icuv1.ValidationState_VALIDATION_STATE_NOT_REQUIRED,
	domain.ValidationPending:     icuv1.ValidationState_VALIDATION_STATE_PENDING,
	domain.ValidationConfirmed:   icuv1.ValidationState_VALIDATION_STATE_CONFIRMED,
	domain.ValidationRejected:    icuv1.ValidationState_VALIDATION_STATE_REJECTED,
}

// validationOnTheWire never sends UNSPECIFIED.
//
// A client reading an unspecified validation state has no way to tell a value
// it may chart from one it may not, and the safe reading of "I do not know" is
// pending.
func validationOnTheWire(in domain.Validation) icuv1.ValidationState {
	if mapped, ok := validationToWire[in]; ok {
		return mapped
	}
	return icuv1.ValidationState_VALIDATION_STATE_PENDING
}

var supportKindFromWire = map[icuv1.SupportKind]domain.SupportKind{
	icuv1.SupportKind_SUPPORT_KIND_VENTILATION:       domain.SupportVentilation,
	icuv1.SupportKind_SUPPORT_KIND_VASOPRESSOR:       domain.SupportVasopressor,
	icuv1.SupportKind_SUPPORT_KIND_RENAL_REPLACEMENT: domain.SupportRRT,
	icuv1.SupportKind_SUPPORT_KIND_ECMO:              domain.SupportECMO,
	icuv1.SupportKind_SUPPORT_KIND_OTHER:             domain.SupportOther,
}

var supportKindToWire = map[domain.SupportKind]icuv1.SupportKind{
	domain.SupportVentilation: icuv1.SupportKind_SUPPORT_KIND_VENTILATION,
	domain.SupportVasopressor: icuv1.SupportKind_SUPPORT_KIND_VASOPRESSOR,
	domain.SupportRRT:         icuv1.SupportKind_SUPPORT_KIND_RENAL_REPLACEMENT,
	domain.SupportECMO:        icuv1.SupportKind_SUPPORT_KIND_ECMO,
	domain.SupportOther:       icuv1.SupportKind_SUPPORT_KIND_OTHER,
}

var bundleKindFromWire = map[icuv1.BundleKind]domain.BundleKind{
	icuv1.BundleKind_BUNDLE_KIND_SEPSIS:          domain.BundleSepsis,
	icuv1.BundleKind_BUNDLE_KIND_VTE:             domain.BundleVTE,
	icuv1.BundleKind_BUNDLE_KIND_DELIRIUM:        domain.BundleDelirium,
	icuv1.BundleKind_BUNDLE_KIND_PRESSURE_INJURY: domain.BundlePressure,
	icuv1.BundleKind_BUNDLE_KIND_SEDATION:        domain.BundleSedation,
	icuv1.BundleKind_BUNDLE_KIND_VENTILATOR:      domain.BundleVentilator,
	icuv1.BundleKind_BUNDLE_KIND_LOCAL:           domain.BundleLocal,
}

var bundleKindToWire = map[domain.BundleKind]icuv1.BundleKind{
	domain.BundleSepsis:     icuv1.BundleKind_BUNDLE_KIND_SEPSIS,
	domain.BundleVTE:        icuv1.BundleKind_BUNDLE_KIND_VTE,
	domain.BundleDelirium:   icuv1.BundleKind_BUNDLE_KIND_DELIRIUM,
	domain.BundlePressure:   icuv1.BundleKind_BUNDLE_KIND_PRESSURE_INJURY,
	domain.BundleSedation:   icuv1.BundleKind_BUNDLE_KIND_SEDATION,
	domain.BundleVentilator: icuv1.BundleKind_BUNDLE_KIND_VENTILATOR,
	domain.BundleLocal:      icuv1.BundleKind_BUNDLE_KIND_LOCAL,
}

var itemStateFromWire = map[icuv1.BundleItemState]domain.ItemState{
	icuv1.BundleItemState_BUNDLE_ITEM_STATE_DONE:      domain.ItemDone,
	icuv1.BundleItemState_BUNDLE_ITEM_STATE_EXCEPTION: domain.ItemException,
	icuv1.BundleItemState_BUNDLE_ITEM_STATE_NOT_DONE:  domain.ItemNotDone,
}

// itemState defaults an unset element to not-done.
//
// The safe direction: an element nobody said anything about was not done, and
// defaulting it to done would make a bundle look compliant because a client
// left a field out.
func itemState(in icuv1.BundleItemState) domain.ItemState {
	if mapped, ok := itemStateFromWire[in]; ok {
		return mapped
	}
	return domain.ItemNotDone
}

var itemStateToWire = map[domain.ItemState]icuv1.BundleItemState{
	domain.ItemDone:      icuv1.BundleItemState_BUNDLE_ITEM_STATE_DONE,
	domain.ItemException: icuv1.BundleItemState_BUNDLE_ITEM_STATE_EXCEPTION,
	domain.ItemNotDone:   icuv1.BundleItemState_BUNDLE_ITEM_STATE_NOT_DONE,
}

var intentFromWire = map[icuv1.CareIntent]domain.CareIntent{
	icuv1.CareIntent_CARE_INTENT_FULL_ESCALATION: domain.IntentFullEscalation,
	icuv1.CareIntent_CARE_INTENT_LIMITED:         domain.IntentLimited,
	icuv1.CareIntent_CARE_INTENT_COMFORT:         domain.IntentComfort,
}

// careIntent maps the wire enum. An unset one stays empty, which
// RecordGoalsOfCare refuses: a ceiling of treatment must never be set by a
// field a client forgot, in either direction.
func careIntent(in icuv1.CareIntent) domain.CareIntent { return intentFromWire[in] }

var intentToWire = map[domain.CareIntent]icuv1.CareIntent{
	domain.IntentFullEscalation: icuv1.CareIntent_CARE_INTENT_FULL_ESCALATION,
	domain.IntentLimited:        icuv1.CareIntent_CARE_INTENT_LIMITED,
	domain.IntentComfort:        icuv1.CareIntent_CARE_INTENT_COMFORT,
}

var goalStatusFromWire = map[icuv1.GoalStatus]domain.GoalStatus{
	icuv1.GoalStatus_GOAL_STATUS_OPEN:      domain.GoalOpen,
	icuv1.GoalStatus_GOAL_STATUS_MET:       domain.GoalMet,
	icuv1.GoalStatus_GOAL_STATUS_NOT_MET:   domain.GoalNotMet,
	icuv1.GoalStatus_GOAL_STATUS_CANCELLED: domain.GoalCancelled,
}

var goalStatusToWire = map[domain.GoalStatus]icuv1.GoalStatus{
	domain.GoalOpen:      icuv1.GoalStatus_GOAL_STATUS_OPEN,
	domain.GoalMet:       icuv1.GoalStatus_GOAL_STATUS_MET,
	domain.GoalNotMet:    icuv1.GoalStatus_GOAL_STATUS_NOT_MET,
	domain.GoalCancelled: icuv1.GoalStatus_GOAL_STATUS_CANCELLED,
}

var severityToWire = map[domain.AlarmSeverity]icuv1.AlarmSeverity{
	domain.AlarmInformation: icuv1.AlarmSeverity_ALARM_SEVERITY_INFORMATION,
	domain.AlarmWarning:     icuv1.AlarmSeverity_ALARM_SEVERITY_WARNING,
	domain.AlarmUrgent:      icuv1.AlarmSeverity_ALARM_SEVERITY_URGENT,
}

func episodeToProto(e domain.Episode) *icuv1.IcuEpisode {
	return &icuv1.IcuEpisode{
		EpisodeId: e.ID, EncounterId: e.EncounterID, PatientId: e.PatientID,
		FacilityId: e.FacilityID, UnitId: e.UnitID, BedId: e.BedID,
		Source: admissionSourceToWire[e.Source], TransferredFrom: e.TransferredFrom,
		ResponsibleTeam: e.ResponsibleTeam, ResponsibleClinician: e.ResponsibleClinician,
		Status:     episodeStatusToWire[e.Status],
		AdmittedAt: stamp(e.AdmittedAt), ReadyAt: stamp(e.ReadyAt),
		DischargedAt: stamp(e.DischargedAt),
		Outcome:      outcomeToWire[e.Outcome], OutcomeNote: e.OutcomeNote,
		Version: e.Version,
	}
}

func deviceSourceToProto(d domain.DeviceSource) *icuv1.DeviceSource {
	if d.DeviceID == "" {
		// A manual entry has no device. An empty message would read as a
		// device with no identity, which is what a stale-feed check looks for.
		return nil
	}
	return &icuv1.DeviceSource{
		DeviceId: d.DeviceID, Model: d.Model, ChannelId: d.ChannelID,
		MeasuredAt: stamp(d.MeasuredAt), Quality: d.Quality,
	}
}

func deviceSourceFromProto(d *icuv1.DeviceSource) domain.DeviceSource {
	if d == nil {
		return domain.DeviceSource{}
	}
	return domain.DeviceSource{
		DeviceID: d.GetDeviceId(), Model: d.GetModel(),
		ChannelID: d.GetChannelId(), MeasuredAt: timeOf(d.GetMeasuredAt()),
		Quality: d.GetQuality(),
	}
}

func observationToProto(o domain.Observation) *icuv1.Observation {
	return &icuv1.Observation{
		ObservationId: o.ID, EpisodeId: o.EpisodeID,
		CodeSystem: o.CodeSystem, Code: o.Code, Display: o.Display,
		Dimension: string(o.Dimension),
		Value:     o.Value, Unit: o.Unit,
		RawValue: o.RawValue, RawUnit: o.RawUnit, Normalised: o.Normalised,
		Source: sourceToWire[o.Source], Validation: validationOnTheWire(o.Validation),
		Device:     deviceSourceToProto(o.Device),
		ObservedAt: stamp(o.ObservedAt), RecordedAt: stamp(o.RecordedAt),
		RecordedBy:  o.RecordedBy,
		ValidatedBy: o.ValidatedBy, ValidatedAt: stamp(o.ValidatedAt),
		ValidationNote: o.ValidationNote,
	}
}

func balanceToProto(b domain.Balance) *icuv1.Balance {
	return &icuv1.Balance{
		From: stamp(b.From), To: stamp(b.To),
		IntakeMl: b.IntakeML, OutputMl: b.OutputML, NetMl: b.NetML,
		Entries: int32(b.Entries), Corrections: int32(b.Corrections),
	}
}

func balanceEntryToProto(e domain.BalanceEntry) *icuv1.BalanceEntry {
	return &icuv1.BalanceEntry{
		EntryId: e.ID, EpisodeId: e.EpisodeID,
		Direction: string(e.Direction), Route: e.Route, VolumeMl: e.VolumeML,
		OccurredAt: stamp(e.OccurredAt), RecordedAt: stamp(e.RecordedAt),
		RecordedBy: e.RecordedBy, SupersededBy: e.SupersededBy,
		Corrects: e.Corrects, CorrectionReason: e.CorrectionReason,
	}
}

func supportToProto(s domain.Support) *icuv1.Support {
	return &icuv1.Support{
		SupportId: s.ID, EpisodeId: s.EpisodeID,
		Kind: supportKindToWire[s.Kind], Label: s.Label, Modality: s.Modality,
		StartedAt: stamp(s.StartedAt), StartedBy: s.StartedBy,
		StoppedAt: stamp(s.StoppedAt), StoppedBy: s.StoppedBy, StopNote: s.StopNote,
	}
}

func ventSettingToProto(s domain.VentSetting) *icuv1.VentSetting {
	return &icuv1.VentSetting{
		SettingId: s.ID, EpisodeId: s.EpisodeID, SupportId: s.SupportID,
		Mode: s.Mode, Parameters: s.Parameters, Measured: s.Measured,
		Units: s.Units, DeviceId: s.DeviceID,
		EffectiveAt: stamp(s.EffectiveAt), RecordedAt: stamp(s.RecordedAt),
		RecordedBy: s.RecordedBy, ChangeReason: s.ChangeReason,
	}
}

func titrationToProto(t domain.Titration) *icuv1.Titration {
	return &icuv1.Titration{
		TitrationId: t.ID, Rate: t.Rate, RateUnit: t.RateUnit, Dose: t.Dose,
		EffectiveAt: stamp(t.EffectiveAt), RecordedAt: stamp(t.RecordedAt),
		RecordedBy: t.RecordedBy, DeviceId: t.DeviceID, Reason: t.Reason,
	}
}

func infusionToProto(i domain.Infusion) *icuv1.Infusion {
	out := &icuv1.Infusion{
		InfusionId: i.ID, EpisodeId: i.EpisodeID,
		PrescriptionId: i.PrescriptionID,
		DrugCode:       i.DrugCode, DrugDisplay: i.DrugDisplay,
		ConcentrationAmount: i.ConcentrationAmount,
		ConcentrationUnit:   i.ConcentrationUnit,
		ConcentrationVolume: i.ConcentrationVolume,
		DoseUnit:            i.DoseUnit, WeightKg: i.WeightKg,
		StartedAt: stamp(i.StartedAt), StartedBy: i.StartedBy,
		StoppedAt: stamp(i.StoppedAt), StoppedBy: i.StoppedBy,
	}
	for _, titration := range i.Titrations {
		out.Titrations = append(out.Titrations, titrationToProto(titration))
	}
	return out
}

// invasiveDeviceToProto renders a device, deriving its overdue state now.
//
// Derived per response rather than stored, so a device whose review interval
// changed yesterday is overdue against the new one.
func invasiveDeviceToProto(d domain.InvasiveDevice, now time.Time) *icuv1.InvasiveDevice {
	return &icuv1.InvasiveDevice{
		DeviceId: d.ID, EpisodeId: d.EpisodeID,
		Kind: d.Kind, Site: d.Site, Lumens: int32(d.Lumens),
		InsertedAt: stamp(d.InsertedAt), InsertedBy: d.InsertedBy,
		RemovedAt: stamp(d.RemovedAt), RemovedBy: d.RemovedBy,
		RemovalReason:      d.RemovalReason,
		ReviewEverySeconds: int64(d.ReviewEvery / time.Second),
		LastReviewedAt:     stamp(d.LastReviewedAt),
		LastReviewedBy:     d.LastReviewedBy,
		ReviewOverdue:      d.ReviewOverdue(now),
	}
}

func scoreToProto(s domain.Score) *icuv1.Score {
	out := &icuv1.Score{
		ScoreId: s.ID, EpisodeId: s.EpisodeID,
		Name: s.Name, FormulaVersion: s.FormulaVersion,
		Total: int32(s.Total), Missing: s.Missing, Complete: s.Complete(),
		CalculatedAt: stamp(s.CalculatedAt), CalculatedBy: s.CalculatedBy,
	}
	for _, input := range s.Inputs {
		out.Inputs = append(out.Inputs, &icuv1.ScoreInput{
			Code: input.Code, ObservationId: input.ObservationID,
			Value: input.Value, Unit: input.Unit,
			ObservedAt: stamp(input.ObservedAt), Points: int32(input.Points),
		})
	}
	return out
}

func complianceToProto(c domain.Compliance) *icuv1.Compliance {
	return &icuv1.Compliance{
		Required: int32(c.Required), Done: int32(c.Done),
		Excepted: int32(c.Excepted), Missed: int32(c.Missed),
		Compliant: c.Compliant,
	}
}

func bundleToProto(p domain.BundlePerformance, c domain.Compliance) *icuv1.BundlePerformance {
	out := &icuv1.BundlePerformance{
		PerformanceId: p.ID, EpisodeId: p.EpisodeID,
		Kind: bundleKindToWire[p.Kind], Label: p.Label, Version: p.Version,
		PerformedAt: stamp(p.PerformedAt), PerformedBy: p.PerformedBy,
		Compliance: complianceToProto(c),
	}
	for _, result := range p.Results {
		out.Results = append(out.Results, &icuv1.BundleResult{
			Code: result.Code, State: itemStateToWire[result.State],
			Reason: result.Reason,
		})
	}
	return out
}

func assessmentToProto(a domain.Assessment, now time.Time) *icuv1.Assessment {
	out := &icuv1.Assessment{
		AssessmentId: a.ID, EpisodeId: a.EpisodeID,
		Kind: string(a.Kind), Scale: a.Scale,
		Findings: a.Findings, Note: a.Note,
		PerformedAt: stamp(a.PerformedAt), PerformedBy: a.PerformedBy,
		NextDueAt: stamp(a.NextDueAt), Overdue: a.Overdue(now),
	}
	if a.Score != nil {
		score := int32(*a.Score)
		out.Score = &score
	}
	return out
}

func roundToProto(r domain.Round) *icuv1.Round {
	return &icuv1.Round{
		RoundId: r.ID, EpisodeId: r.EpisodeID,
		Attendance: r.Attendance, Summary: r.Summary,
		PerformedAt: stamp(r.PerformedAt), PerformedBy: r.PerformedBy,
	}
}

func goalToProto(g domain.Goal) *icuv1.Goal {
	return &icuv1.Goal{
		GoalId: g.ID, EpisodeId: g.EpisodeID, RoundId: g.RoundID,
		Domain: g.Domain, Text: g.Text,
		OwnerRole: g.OwnerRole, OwnerId: g.OwnerID,
		Status: goalStatusToWire[g.Status], TargetAt: stamp(g.TargetAt),
		ResolvedAt: stamp(g.ResolvedAt), ResolvedBy: g.ResolvedBy,
		Outcome:   g.Outcome,
		CreatedAt: stamp(g.CreatedAt), CreatedBy: g.CreatedBy,
	}
}

func ceilingToProto(c domain.GoalsOfCare, now time.Time) *icuv1.GoalsOfCare {
	if c.ID == "" {
		return nil
	}
	return &icuv1.GoalsOfCare{
		GoalsOfCareId: c.ID, EpisodeId: c.EpisodeID,
		Intent: intentToWire[c.Intent], Limitations: c.Limitations,
		CprStatus: c.CPRStatus, DiscussedWith: c.DiscussedWith,
		Rationale:    c.Rationale,
		AuthorisedBy: c.AuthorisedBy, AuthorisedRole: c.AuthorisedRole,
		RecordedAt: stamp(c.RecordedAt), RecordedBy: c.RecordedBy,
		SupersededBy: c.SupersededBy, SupersededAt: stamp(c.SupersededAt),
		ReviewBy: stamp(c.ReviewBy),
		Current:  c.Current(), ReviewOverdue: c.ReviewOverdue(now),
	}
}

func alarmToProto(a domain.Alarm) *icuv1.Alarm {
	return &icuv1.Alarm{
		AlarmId: a.ID, EpisodeId: a.EpisodeID, Kind: a.Kind,
		Severity: severityToWire[a.Severity], Summary: a.Summary,
		RaisedAt: stamp(a.RaisedAt),
	}
}

func dashboardRowToProto(r domain.DashboardRow) *icuv1.DashboardRow {
	out := &icuv1.DashboardRow{
		EpisodeId: r.EpisodeID, PatientId: r.PatientID,
		BedId: r.BedID, UnitId: r.UnitID, Display: r.Display,
		Devices: int32(r.Devices), OverdueDevices: int32(r.OverdueDevices),
		DueAssessments: int32(r.DueAssessments), OpenGoals: int32(r.OpenGoals),
		Balance:           balanceToProto(r.Balance),
		CareIntent:        intentToWire[r.CareIntent],
		CprStatus:         r.CPRStatus,
		CeilingRestricted: r.CeilingRestricted,
		StaleFeeds:        int32(r.StaleFeeds),
		AdmittedAt:        stamp(r.AdmittedAt),
		ReadyForTransfer:  r.ReadyForTransfer,
	}
	for _, vital := range r.Vitals {
		out.Vitals = append(out.Vitals, &icuv1.DashboardValue{
			Code: vital.Code, Display: vital.Display,
			Value: vital.Value, Unit: vital.Unit,
			ObservationId: vital.ObservationID,
			Source:        sourceToWire[vital.Source],
			Validation:    validationOnTheWire(vital.Validation),
			DeviceId:      vital.DeviceID,
			ObservedAt:    stamp(vital.ObservedAt),
			Stale:         vital.Stale,
		})
	}
	for _, kind := range r.Support {
		out.Support = append(out.Support, supportKindToWire[kind])
	}
	if r.LatestScore != nil {
		out.LatestScore = scoreToProto(*r.LatestScore)
	}
	return out
}
