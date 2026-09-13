package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// DeviceRepo persists lines, tubes, drains and catheters (SRS-NUR-006).
type DeviceRepo struct{ *Repository }

var _ ports.DeviceRepository = DeviceRepo{}

// NewDevices constructs the device adapter.
func NewDevices(r *Repository) DeviceRepo { return DeviceRepo{r} }

// Insert records an insertion.
func (r DeviceRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	d *domain.Device) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	deviceID, err := mustUUID(d.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(d.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(d.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertDevice(ctx, sqlcgen.InsertDeviceParams{
		DeviceID: deviceID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Kind: string(d.Kind), Site: d.Site, Laterality: string(d.Laterality),
		Size: d.Size, Lot: d.Lot,
		// The canonical date. Device-days are computed from this and the
		// removal, and from nothing else (SRS-NUR-006).
		InsertedAt: timestamptz(d.InsertedAt), InsertedBy: d.InsertedBy,
	})
}

// Get reads one device.
func (r DeviceRepo) Get(ctx context.Context, scope authctx.TenantScope,
	deviceID string) (*domain.Device, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(deviceID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetDevice(ctx, sqlcgen.GetDeviceParams{
		TenantID: tenantID, DeviceID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return deviceFromRow(sqlcgen.NursingDevice(row)), nil
}

// Remove records a removal.
func (r DeviceRepo) Remove(ctx context.Context, scope authctx.TenantScope,
	d *domain.Device, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(d.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).RemoveDevice(ctx, sqlcgen.RemoveDeviceParams{
		TenantID: tenantID, DeviceID: id,
		RemovedAt: timestamptz(d.RemovedAt), RemovedBy: d.RemovedBy,
		RemovalReason: d.RemovalReason, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// List reads an encounter's devices.
func (r DeviceRepo) List(ctx context.Context, scope authctx.TenantScope,
	encounterID string, inPlaceOnly bool, limit int32) ([]*domain.Device, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListDevices(ctx, sqlcgen.ListDevicesParams{
		TenantID: tenantID, EncounterID: id,
		InPlaceOnly: inPlaceOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Device, 0, len(rows))
	for _, row := range rows {
		out = append(out, deviceFromRow(sqlcgen.NursingDevice(row)))
	}
	return out, nil
}

// RecordCare adds a care episode.
func (r DeviceRepo) RecordCare(ctx context.Context, scope authctx.TenantScope,
	deviceID string, care domain.DeviceCare) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	device, err := lookupUUID(deviceID)
	if err != nil {
		return err
	}
	careID, err := mustUUID(care.ID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertDeviceCare(ctx, sqlcgen.InsertDeviceCareParams{
		CareID: careID, TenantID: tenantID, DeviceID: device,
		Kind: care.Kind, Finding: care.Finding, OutputMl: care.OutputML,
		PerformedAt: timestamptz(care.PerformedAt), PerformedBy: care.PerformedBy,
	})
}

// ListCare reads a device's care episodes.
func (r DeviceRepo) ListCare(ctx context.Context, scope authctx.TenantScope,
	deviceID string, limit int32) ([]domain.DeviceCare, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(deviceID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListDeviceCare(ctx, sqlcgen.ListDeviceCareParams{
		TenantID: tenantID, DeviceID: id, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.DeviceCare, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.DeviceCare{
			ID: row.CareID.String(), Kind: row.Kind, Finding: row.Finding,
			OutputML:    row.OutputMl,
			PerformedAt: timeOrZero(row.PerformedAt),
			PerformedBy: row.PerformedBy,
		})
	}
	return out, nil
}

func deviceFromRow(row sqlcgen.NursingDevice) *domain.Device {
	return &domain.Device{
		ID: row.DeviceID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Kind: domain.DeviceKind(row.Kind), Site: row.Site,
		Laterality: domain.Laterality(row.Laterality),
		Size:       row.Size, Lot: row.Lot,
		InsertedAt: timeOrZero(row.InsertedAt), InsertedBy: row.InsertedBy,
		RemovedAt: timeOrZero(row.RemovedAt), RemovedBy: row.RemovedBy,
		RemovalReason: row.RemovalReason, Version: row.Version,
	}
}

// WardRepo persists wound assessments, education, assignments and the acuity
// weights (SRS-NUR-012, SRS-NUR-015, SRS-NUR-016, SRS-NUR-017).
type WardRepo struct{ *Repository }

var _ ports.WardRepository = WardRepo{}

// NewWard constructs the ward adapter.
func NewWard(r *Repository) WardRepo { return WardRepo{r} }

// InsertWound stores a wound assessment.
func (r WardRepo) InsertWound(ctx context.Context, scope authctx.TenantScope,
	w *domain.WoundAssessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assessmentID, err := mustUUID(w.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(w.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(w.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertWoundAssessment(ctx,
		sqlcgen.InsertWoundAssessmentParams{
			WoundAssessmentID: assessmentID, TenantID: tenantID,
			PatientID: patientID, EncounterID: encounterID,
			WoundID: w.WoundID, Location: w.Location,
			BodyMapSystem: w.BodyMapCode.System, BodyMapCode: w.BodyMapCode.Code,
			BodyMapDisplay: w.BodyMapCode.Display,
			Laterality:     string(w.Laterality),
			Kind:           string(w.Kind), Stage: w.Stage,
			LengthMm: w.LengthMM, WidthMm: w.WidthMM, DepthMm: w.DepthMM,
			Appearance: w.Appearance, Exudate: w.Exudate,
			SurroundingSkin: w.SurroundingSkin, PainScore: w.PainScore,
			AssessedAt: timestamptz(w.AssessedAt),
			RecordedAt: timestamptz(w.RecordedAt),
			AssessedBy: w.AssessedBy,
		})
}

// GetWound reads one assessment.
func (r WardRepo) GetWound(ctx context.Context, scope authctx.TenantScope,
	assessmentID string) (*domain.WoundAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(assessmentID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetWoundAssessment(ctx,
		sqlcgen.GetWoundAssessmentParams{
			TenantID: tenantID, WoundAssessmentID: id,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	assessment := woundFromRow(sqlcgen.NursingWoundAssessment(row))
	images, err := r.listWoundImages(ctx, tenantID, id)
	if err != nil {
		return nil, err
	}
	assessment.Images = images
	return assessment, nil
}

// ListWounds reads a wound's history.
func (r WardRepo) ListWounds(ctx context.Context, scope authctx.TenantScope,
	patientID, woundID string, limit int32) ([]*domain.WoundAssessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListWoundAssessments(ctx,
		sqlcgen.ListWoundAssessmentsParams{
			TenantID: tenantID, PatientID: patient,
			WoundFilter: woundID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.WoundAssessment, 0, len(rows))
	for _, row := range rows {
		assessment := woundFromRow(sqlcgen.NursingWoundAssessment(row))
		images, err := r.listWoundImages(ctx, tenantID, row.WoundAssessmentID)
		if err != nil {
			return nil, err
		}
		assessment.Images = images
		out = append(out, assessment)
	}
	return out, nil
}

func (r WardRepo) listWoundImages(ctx context.Context, tenantID,
	assessmentID uuid.UUID) ([]domain.WoundImage, error) {

	rows, err := r.queries(ctx).ListWoundImages(ctx, sqlcgen.ListWoundImagesParams{
		TenantID: tenantID, WoundAssessmentID: assessmentID,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.WoundImage, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.WoundImage{
			ImageID: row.ImageID.String(), ConsentID: row.ConsentID.String(),
			StorageKey: row.StorageKey, ContentType: row.ContentType,
			CapturedAt: timeOrZero(row.CapturedAt), CapturedBy: row.CapturedBy,
			Sequence: row.Sequence,
		})
	}
	return out, nil
}

// InsertWoundImage attaches a photograph.
//
// The consent is a foreign key rather than a flag, so an image whose consent
// was never recorded cannot be stored at all (SRS-NUR-012).
func (r WardRepo) InsertWoundImage(ctx context.Context,
	scope authctx.TenantScope, assessmentID string, img domain.WoundImage) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assessment, err := lookupUUID(assessmentID)
	if err != nil {
		return err
	}
	imageID, err := mustUUID(img.ImageID)
	if err != nil {
		return err
	}
	consentID, err := lookupUUID(img.ConsentID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertWoundImage(ctx, sqlcgen.InsertWoundImageParams{
		ImageID: imageID, TenantID: tenantID,
		WoundAssessmentID: assessment, ConsentID: consentID,
		StorageKey: img.StorageKey, ContentType: img.ContentType,
		CapturedAt: timestamptz(img.CapturedAt), CapturedBy: img.CapturedBy,
		Sequence: img.Sequence,
	})
}

func woundFromRow(row sqlcgen.NursingWoundAssessment) *domain.WoundAssessment {
	return &domain.WoundAssessment{
		ID: row.WoundAssessmentID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		WoundID: row.WoundID, Location: row.Location,
		BodyMapCode: domain.Coding{
			System: row.BodyMapSystem, Code: row.BodyMapCode,
			Display: row.BodyMapDisplay,
		},
		Laterality: domain.Laterality(row.Laterality),
		Kind:       domain.WoundKind(row.Kind), Stage: row.Stage,
		LengthMM: row.LengthMm, WidthMM: row.WidthMm, DepthMM: row.DepthMm,
		Appearance: row.Appearance, Exudate: row.Exudate,
		SurroundingSkin: row.SurroundingSkin, PainScore: row.PainScore,
		AssessedAt: timeOrZero(row.AssessedAt),
		RecordedAt: timeOrZero(row.RecordedAt),
		AssessedBy: row.AssessedBy, Version: row.Version,
	}
}

// InsertEducation stores a teaching episode.
func (r WardRepo) InsertEducation(ctx context.Context, scope authctx.TenantScope,
	e *domain.EducationRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	educationID, err := mustUUID(e.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(e.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(e.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertEducation(ctx, sqlcgen.InsertEducationParams{
		EducationID: educationID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		TopicSystem: e.Topic.System, TopicVersion: e.Topic.Version,
		TopicCode: e.Topic.Code, TopicDisplay: e.Topic.Display,
		Learner: string(e.Learner), LearnerName: e.LearnerName,
		Method: e.Method,
		// The outcome, and the reason the record exists: teaching delivered is
		// not teaching received (SRS-NUR-015).
		Understanding: string(e.Understanding), Barriers: e.Barriers,
		TaughtAt: timestamptz(e.TaughtAt), TaughtBy: e.TaughtBy,
	})
}

// ListEducation reads a patient's teaching record.
func (r WardRepo) ListEducation(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) ([]*domain.EducationRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListEducation(ctx, sqlcgen.ListEducationParams{
		TenantID: tenantID, PatientID: patient, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.EducationRecord, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.EducationRecord{
			ID: row.EducationID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			Topic: domain.Coding{
				System: row.TopicSystem, Version: row.TopicVersion,
				Code: row.TopicCode, Display: row.TopicDisplay,
			},
			Learner: domain.Learner(row.Learner), LearnerName: row.LearnerName,
			Method:        row.Method,
			Understanding: domain.Understanding(row.Understanding),
			Barriers:      row.Barriers,
			TaughtAt:      timeOrZero(row.TaughtAt), TaughtBy: row.TaughtBy,
			Version: row.Version,
		})
	}
	return out, nil
}

// InsertAssignment assigns a nurse.
func (r WardRepo) InsertAssignment(ctx context.Context,
	scope authctx.TenantScope, a *domain.NurseAssignment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assignmentID, err := mustUUID(a.ID)
	if err != nil {
		return err
	}
	patient, err := optionalUUID(a.PatientID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertAssignment(ctx, sqlcgen.InsertAssignmentParams{
		AssignmentID: assignmentID, TenantID: tenantID,
		UnitID: a.UnitID, BedID: a.BedID, PatientID: patient,
		NurseID: a.NurseID, Relationship: string(a.Relationship),
		EffectiveFrom: timestamptz(a.EffectiveFrom), AssignedBy: a.AssignedBy,
	})
}

// EndAssignment closes an assignment.
//
// Closed rather than deleted, so the answer to "who held this patient last
// Tuesday night" survives the shift ending (SRS-NUR-017).
func (r WardRepo) EndAssignment(ctx context.Context, scope authctx.TenantScope,
	a *domain.NurseAssignment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(a.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).EndAssignment(ctx, sqlcgen.EndAssignmentParams{
		TenantID: tenantID, AssignmentID: id,
		EffectiveTo: timestamptz(a.EffectiveTo), EndedReason: a.EndedReason,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// Assignments answers "who was looking after this patient at this time".
func (r WardRepo) Assignments(ctx context.Context, scope authctx.TenantScope,
	q ports.AssignmentQuery) ([]*domain.NurseAssignment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := optionalUUID(q.PatientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListAssignments(ctx, sqlcgen.ListAssignmentsParams{
		TenantID: tenantID, UnitFilter: q.UnitID,
		PatientFilter: patient, NurseFilter: q.NurseID,
		AsOf: timestamptz(q.AsOf), PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.NurseAssignment, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.NurseAssignment{
			ID: row.AssignmentID.String(), TenantID: row.TenantID.String(),
			UnitID: row.UnitID, BedID: row.BedID,
			PatientID: uuidOrEmpty(row.PatientID), NurseID: row.NurseID,
			Relationship:  domain.CareRelationship(row.Relationship),
			EffectiveFrom: timeOrZero(row.EffectiveFrom),
			EffectiveTo:   timeOrZero(row.EffectiveTo),
			AssignedBy:    row.AssignedBy, EndedReason: row.EndedReason,
			Version: row.Version,
		})
	}
	return out, nil
}

// NursesOnDuty counts the nurses actually assigned on a unit.
//
// From live assignments rather than from a roster: a roster says who was meant
// to be there (SRS-NUR-016).
func (r WardRepo) NursesOnDuty(ctx context.Context, scope authctx.TenantScope,
	unitID string, asOf time.Time) (int32, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}

	count, err := r.queries(ctx).CountNursesOnDuty(ctx,
		sqlcgen.CountNursesOnDutyParams{
			TenantID: tenantID, UnitID: unitID, AsOf: timestamptz(asOf),
		})
	if err != nil {
		return 0, err
	}
	return int32(count), nil
}

// SetAcuityWeights stores a unit's multipliers.
func (r WardRepo) SetAcuityWeights(ctx context.Context,
	scope authctx.TenantScope, unitID string, w domain.AcuityWeights,
	updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertAcuityWeights(ctx, sqlcgen.UpsertAcuityWeightsParams{
		TenantID: tenantID, UnitID: unitID,
		Dependency: w.Dependency, OpenTask: w.OpenTask,
		OverdueTask: w.OverdueTask, Device: w.Device,
		HighRisk: w.HighRisk, Isolation: w.Isolation,
		UpdatedBy: updatedBy, UpdatedAt: timestamptz(now),
	})
}

// AcuityWeights reads a unit's multipliers, falling back to the tenant's and
// then to the defaults.
//
// The defaults are a starting point rather than a clinical standard: every
// hospital that has tried to compute nursing workload has ended up with
// different weights.
func (r WardRepo) AcuityWeights(ctx context.Context, scope authctx.TenantScope,
	unitID string) (domain.AcuityWeights, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.AcuityWeights{}, err
	}

	for _, key := range []string{unitID, ""} {
		row, err := r.queries(ctx).GetAcuityWeights(ctx,
			sqlcgen.GetAcuityWeightsParams{TenantID: tenantID, UnitID: key})
		if errors.Is(err, pgx.ErrNoRows) {
			continue
		}
		if err != nil {
			return domain.AcuityWeights{}, err
		}
		return domain.AcuityWeights{
			Dependency: row.Dependency, OpenTask: row.OpenTask,
			OverdueTask: row.OverdueTask, Device: row.Device,
			HighRisk: row.HighRisk, Isolation: row.Isolation,
		}, nil
	}
	return domain.DefaultAcuityWeights(), nil
}
