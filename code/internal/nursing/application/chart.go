package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The bedside chart: assessments, observations, fluids, risk scores and
// devices (SRS-NUR-001, SRS-NUR-003 … SRS-NUR-006).

// ChartInput is what charting an observation needs.
type ChartInput struct {
	PatientID       string
	EncounterID     string
	Code            domain.Coding
	Value           domain.Quantity
	TextValue       string
	CodedValue      domain.Coding
	ObservedAt      time.Time
	Source          domain.EntrySource
	DeviceID        string
	LateEntryReason string
}

// Chart records an observation on the flowsheet (SRS-NUR-003).
func (s *Service) Chart(ctx context.Context, in ChartInput) (
	*domain.FlowsheetEntry, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "flowsheet_entry",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	// The recording time comes from the clock, never from the caller: the one
	// thing a late entry must not be able to do is claim it was on time.
	now := s.clock.Now()
	entry, err := domain.NewFlowsheetEntry(s.ids.NewID(), session.TenantID,
		domain.NewFlowsheetEntryInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			Code: in.Code, Value: in.Value, TextValue: in.TextValue,
			CodedValue: in.CodedValue, ObservedAt: in.ObservedAt,
			Source: in.Source, DeviceID: in.DeviceID,
			LateEntryReason: in.LateEntryReason,
		}, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.flowsheet.InsertEntry(ctx, scope, entry); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.observation.chart", ResourceType: "flowsheet_entry",
			ResourceID: entry.ID, Outcome: audit.OutcomeSuccess,
			Reason: lateReason(entry),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return entry, nil
}

// lateReason surfaces a late entry in the audit trail as well as on the chart.
//
// Both, because the chart shows the ward what it is reading and the audit trail
// shows a reviewer how the record was built.
func lateReason(e *domain.FlowsheetEntry) string {
	if !e.IsLate() {
		return ""
	}
	return "late entry: " + e.LateEntryReason
}

// Flowsheet reads a chart window (SRS-NUR-003).
func (s *Service) Flowsheet(ctx context.Context, encounterID, patientID,
	code string, from, to time.Time, limit int32) (
	[]*domain.FlowsheetEntry, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "flowsheet_entry",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	from, to = defaultWindow(s.clock.Now(), from, to)
	entries, err := s.flowsheet.ListEntries(ctx, scope, ports.FlowsheetQuery{
		EncounterID: encounterID, Code: code,
		ObservedFrom: from, ObservedTo: to, Limit: clampPageSize(limit),
	})
	if err != nil {
		return nil, err
	}
	// Sorted by observation time, so a late 06:00 reading sits where the
	// patient was, not where the typing was.
	domain.SortFlowsheet(entries)

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.flowsheet.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return entries, nil
}

// defaultWindow bounds a chart or balance query.
//
// Twenty-four hours back: a ward round reads today, and an unbounded default
// would pull a long admission's entire flowsheet on every screen refresh.
func defaultWindow(now, from, to time.Time) (time.Time, time.Time) {
	if from.IsZero() {
		from = now.Add(-24 * time.Hour)
	}
	if to.IsZero() {
		to = now.Add(time.Minute)
	}
	return from, to
}

// RecordFluidInput is what recording a volume needs.
type RecordFluidInput struct {
	PatientID   string
	EncounterID string
	Direction   domain.FluidDirection
	Category    string
	VolumeML    float64
	ObservedAt  time.Time
}

// RecordFluid records intake or output (SRS-NUR-004).
func (s *Service) RecordFluid(ctx context.Context, in RecordFluidInput) (
	*domain.FluidEntry, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "fluid_entry",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	entry, err := domain.NewFluidEntry(s.ids.NewID(), session.TenantID,
		domain.NewFluidEntryInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			Direction: in.Direction, Category: in.Category,
			VolumeML: in.VolumeML, ObservedAt: in.ObservedAt,
		}, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.flowsheet.InsertFluid(ctx, scope, entry); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.fluid.record", ResourceType: "fluid_entry",
			ResourceID: entry.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return entry, nil
}

// CorrectFluid replaces a mis-recorded volume (SRS-NUR-004).
//
// The original is superseded, not edited: the shift balance that was handed
// over was computed from it, and a trail showing only the corrected figure
// cannot explain a decision made on the original.
func (s *Service) CorrectFluid(ctx context.Context, fluidID string,
	volumeML float64, reason string) (*domain.FluidEntry, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "fluid_entry",
		fluidID, true)
	if err != nil {
		return nil, err
	}

	original, err := s.flowsheet.GetFluid(ctx, scope, fluidID)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, original.EncounterID,
		original.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	correction, err := original.Correct(s.ids.NewID(), volumeML, reason,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Insert first, then supersede: the correction has to exist before the
		// original can point at it.
		if err := s.flowsheet.InsertFluid(ctx, scope, correction); err != nil {
			return err
		}
		if err := s.flowsheet.SupersedeFluid(ctx, scope, original.ID,
			correction.ID); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.fluid.correct", ResourceType: "fluid_entry",
			ResourceID: original.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return correction, nil
}

// Balance totals the fluids over a window (SRS-NUR-004).
func (s *Service) Balance(ctx context.Context, encounterID, patientID string,
	from, to time.Time) (domain.FluidBalance, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "fluid_entry",
		encounterID, false)
	if err != nil {
		return domain.FluidBalance{}, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return domain.FluidBalance{}, err
	}

	from, to = defaultWindow(s.clock.Now(), from, to)
	entries, err := s.flowsheet.ListFluid(ctx, scope, ports.FluidQuery{
		EncounterID: encounterID, ObservedFrom: from, ObservedTo: to,
		// Live entries only: the amendment trail is for an audit, not for a
		// total.
		IncludeSuperseded: false, Limit: MaxPageSize,
	})
	if err != nil {
		return domain.FluidBalance{}, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.balance.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return domain.FluidBalance{}, err
	}
	return domain.Balance(entries, from, to), nil
}

// FluidTrail reads the amendment history, superseded entries included
// (SRS-NUR-004).
func (s *Service) FluidTrail(ctx context.Context, encounterID, patientID string,
	from, to time.Time, limit int32) ([]*domain.FluidEntry, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "fluid_entry",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	from, to = defaultWindow(s.clock.Now(), from, to)
	entries, err := s.flowsheet.ListFluid(ctx, scope, ports.FluidQuery{
		EncounterID: encounterID, ObservedFrom: from, ObservedTo: to,
		IncludeSuperseded: true, Limit: clampPageSize(limit),
	})
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.fluid_trail.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return entries, nil
}

// AssessInput is what recording a nursing assessment needs.
type AssessInput struct {
	PatientID       string
	EncounterID     string
	Kind            domain.AssessmentKind
	TemplateID      string
	TemplateVersion string
	Answers         []domain.Answer
	AssessedAt      time.Time
}

// Assess records a completed nursing assessment (SRS-NUR-001).
func (s *Service) Assess(ctx context.Context, in AssessInput) (
	*domain.Assessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "assessment",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	template, err := s.assessments.GetTemplate(ctx, scope, in.TemplateID,
		in.TemplateVersion)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	assessment, err := domain.NewAssessment(s.ids.NewID(), session.TenantID,
		domain.NewAssessmentInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			Kind: in.Kind, Template: template, Answers: in.Answers,
			AssessedAt: in.AssessedAt,
		}, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.assessments.Insert(ctx, scope, assessment); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.assessment.record", ResourceType: "assessment",
			ResourceID: assessment.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return assessment, nil
}

// DefineAssessmentTemplate publishes a versioned assessment structure
// (SRS-NUR-001).
func (s *Service) DefineAssessmentTemplate(ctx context.Context,
	t domain.AssessmentTemplate) (domain.AssessmentTemplate, error) {

	session, scope, err := s.authorize(ctx, PermNursingConfigure,
		"assessment_template", t.TemplateID, true)
	if err != nil {
		return domain.AssessmentTemplate{}, err
	}
	if t.TemplateID == "" {
		t.TemplateID = s.ids.NewID()
	}
	t.TenantID = session.TenantID
	if err := t.Validate(); err != nil {
		return domain.AssessmentTemplate{}, nursingError(err)
	}

	now := s.clock.Now()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.assessments.InsertTemplate(ctx, scope, t,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "nursing.assessment_template.define",
			ResourceType: "assessment_template", ResourceID: t.TemplateID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.AssessmentTemplate{}, mapConflict(err)
	}
	return t, nil
}

// ListAssessmentTemplates lists what a nurse may answer against.
func (s *Service) ListAssessmentTemplates(ctx context.Context,
	serviceCode string, includeRetired bool, limit int32) (
	[]domain.AssessmentTemplate, error) {

	_, scope, err := s.authorize(ctx, PermNursingRead, "assessment_template",
		"", false)
	if err != nil {
		return nil, err
	}
	return s.assessments.ListTemplates(ctx, scope, serviceCode, includeRetired,
		clampPageSize(limit))
}

// RetireAssessmentTemplate withdraws a template from new assessments.
func (s *Service) RetireAssessmentTemplate(ctx context.Context,
	templateID, version string) error {

	session, scope, err := s.authorize(ctx, PermNursingConfigure,
		"assessment_template", templateID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.assessments.RetireTemplate(ctx, scope, templateID,
			version); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "nursing.assessment_template.retire",
			ResourceType: "assessment_template", ResourceID: templateID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
}

// ListAssessments reads an encounter's assessments.
func (s *Service) ListAssessments(ctx context.Context, encounterID,
	patientID string, kind domain.AssessmentKind, limit int32) (
	[]*domain.Assessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "assessment",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	out, err := s.assessments.List(ctx, scope, encounterID, kind,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.assessment.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// DefineRiskScale publishes a versioned scoring instrument (SRS-NUR-005).
func (s *Service) DefineRiskScale(ctx context.Context, scale domain.RiskScale) (
	domain.RiskScale, error) {

	session, scope, err := s.authorize(ctx, PermNursingConfigure, "risk_scale",
		scale.ScaleID, true)
	if err != nil {
		return domain.RiskScale{}, err
	}
	if scale.ScaleID == "" {
		scale.ScaleID = s.ids.NewID()
	}
	scale.TenantID = session.TenantID
	if err := scale.Validate(); err != nil {
		return domain.RiskScale{}, nursingError(err)
	}

	now := s.clock.Now()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.risks.InsertScale(ctx, scope, scale, session.SubjectID,
			now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.risk_scale.define", ResourceType: "risk_scale",
			ResourceID: scale.ScaleID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.RiskScale{}, mapConflict(err)
	}
	return scale, nil
}

// ScoreRiskInput is what recording a risk score needs.
type ScoreRiskInput struct {
	PatientID    string
	EncounterID  string
	ScaleID      string
	ScaleVersion string
	Inputs       map[string]int32
	AssessedAt   time.Time
}

// ScoreRisk records a risk assessment and supersedes the previous one
// (SRS-NUR-005).
//
// Superseded, never overwritten: the nurse acted on the old number, and a
// rescore under a retuned scale that rewrote history would make the earlier
// decision look wrong.
func (s *Service) ScoreRisk(ctx context.Context, in ScoreRiskInput) (
	*domain.RiskAssessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "risk_assessment",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	scale, err := s.risks.GetScale(ctx, scope, in.ScaleID, in.ScaleVersion)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	assessment, err := domain.Score(s.ids.NewID(), session.TenantID,
		in.PatientID, in.EncounterID, scale, in.Inputs, in.AssessedAt,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	previous, err := s.risks.Latest(ctx, scope, in.PatientID, scale.Domain)
	if err != nil {
		var rpcErr *rpcerr.Error
		// No previous score is the normal case on admission, not a failure.
		if !isNotFound(err, &rpcErr) {
			return nil, err
		}
		previous = nil
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.risks.Insert(ctx, scope, assessment); err != nil {
			return err
		}
		if previous != nil {
			if err := s.risks.Supersede(ctx, scope, previous.ID,
				assessment.ID); err != nil {
				return err
			}
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.risk.score", ResourceType: "risk_assessment",
			ResourceID: assessment.ID, Outcome: audit.OutcomeSuccess,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventRiskAssessed, "risk_assessment",
			assessment.ID, map[string]any{
				"risk_id":       assessment.ID,
				"patient_id":    assessment.PatientID,
				"domain":        string(assessment.Domain),
				"scale_id":      assessment.ScaleID,
				"scale_version": assessment.ScaleVersion,
				"band":          assessment.Band,
				"escalate":      assessment.Escalate,
				"due_at":        timeOrNil(assessment.DueAt),
			}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return assessment, nil
}

// isNotFound reports a NOT_FOUND refusal from the repository layer.
func isNotFound(err error, target **rpcerr.Error) bool {
	e, ok := rpcerr.As(err)
	if !ok {
		return false
	}
	*target = e
	return e.Code == "NUR_NOT_FOUND"
}

// DueReassessments lists risk scores past their reassessment time
// (SRS-NUR-005).
func (s *Service) DueReassessments(ctx context.Context, encounterID string,
	limit int32) ([]*domain.RiskAssessment, error) {

	_, scope, err := s.authorize(ctx, PermNursingRead, "risk_assessment",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	return s.risks.Due(ctx, scope, encounterID, s.clock.Now(),
		clampPageSize(limit))
}

// ListRiskAssessments reads a patient's scores.
func (s *Service) ListRiskAssessments(ctx context.Context, patientID string,
	riskDomain domain.RiskDomain, limit int32) ([]*domain.RiskAssessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "risk_assessment",
		patientID, false)
	if err != nil {
		return nil, err
	}
	out, err := s.risks.List(ctx, scope, patientID, riskDomain,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.risk.read", ResourceType: "patient",
		ResourceID: patientID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// InsertDeviceInput is what recording an insertion needs.
type InsertDeviceInput struct {
	PatientID   string
	EncounterID string
	Kind        domain.DeviceKind
	Site        string
	Laterality  domain.Laterality
	Size        string
	Lot         string
	InsertedAt  time.Time
}

// InsertDevice records a line, tube, drain or catheter (SRS-NUR-006).
func (s *Service) InsertDevice(ctx context.Context, in InsertDeviceInput) (
	*domain.Device, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "device",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	device, err := domain.NewDevice(s.ids.NewID(), session.TenantID,
		domain.NewDeviceInput{
			PatientID: in.PatientID, EncounterID: in.EncounterID,
			Kind: in.Kind, Site: in.Site, Laterality: in.Laterality,
			Size: in.Size, Lot: in.Lot, InsertedAt: in.InsertedAt,
		}, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.devices.Insert(ctx, scope, device); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.device.insert", ResourceType: "device",
			ResourceID: device.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return device, nil
}

// RemoveDevice records a removal (SRS-NUR-006).
func (s *Service) RemoveDevice(ctx context.Context, deviceID string,
	removedAt time.Time, reason string) (*domain.Device, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "device",
		deviceID, true)
	if err != nil {
		return nil, err
	}

	device, err := s.devices.Get(ctx, scope, deviceID)
	if err != nil {
		return nil, err
	}
	expected := device.Version

	now := s.clock.Now()
	if err := device.Remove(removedAt, reason, session.SubjectID, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.devices.Remove(ctx, scope, device, expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.device.remove", ResourceType: "device",
			ResourceID: device.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return device, nil
}

// RecordDeviceCare records looking after a device.
//
// Never used as a proxy for the device being in place: device-days come from
// the canonical dates (SRS-NUR-006).
func (s *Service) RecordDeviceCare(ctx context.Context, deviceID string,
	care domain.DeviceCare) error {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "device",
		deviceID, true)
	if err != nil {
		return err
	}

	device, err := s.devices.Get(ctx, scope, deviceID)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	care.ID = s.ids.NewID()
	if care.PerformedBy == "" {
		care.PerformedBy = session.SubjectID
	}
	if err := device.RecordCare(care, now); err != nil {
		return nursingError(err)
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.devices.RecordCare(ctx, scope, deviceID, care); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.device.care", ResourceType: "device",
			ResourceID: deviceID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
}

// DeviceDayReport is a device's surveillance denominator (SRS-NUR-006).
type DeviceDayReport struct {
	Device     *domain.Device
	DeviceDays int
	Dwell      time.Duration
	// Surveillance says whether this device counts towards a published
	// infection rate, so a report cannot quietly include or exclude one.
	Surveillance bool
}

// Devices lists an encounter's devices with their device-day counts.
func (s *Service) Devices(ctx context.Context, encounterID, patientID string,
	inPlaceOnly bool, limit int32) ([]DeviceDayReport, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "device",
		encounterID, false)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return nil, err
	}

	devices, err := s.devices.List(ctx, scope, encounterID, inPlaceOnly,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	asOf := s.clock.Now()
	out := make([]DeviceDayReport, 0, len(devices))
	for _, d := range devices {
		out = append(out, DeviceDayReport{
			Device: d, DeviceDays: d.DeviceDays(asOf), Dwell: d.Dwell(asOf),
			Surveillance: d.Kind.SurveillanceDevice(),
		})
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.device.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, asOf); err != nil {
		return nil, err
	}
	return out, nil
}
