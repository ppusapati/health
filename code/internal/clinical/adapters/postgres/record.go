package postgres

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Problems, allergies, observations, procedures and care plans
// (SRS-CLN-003 … SRS-CLN-007, SRS-CLN-011, SRS-CLN-012).

// RecordRepo implements the coded clinical record port.
type RecordRepo struct{ *Repository }

var _ ports.RecordRepository = RecordRepo{}

// InsertProblem stores a problem-list entry.
func (r RecordRepo) InsertProblem(ctx context.Context, scope authctx.TenantScope,
	p domain.Problem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	problemID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("CLN_PROBLEM_ID_INVALID",
			"problem_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(p.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertProblem(ctx, sqlcgen.InsertProblemParams{
		ProblemID: problemID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, CodeSystem: p.Code.System,
		CodeVersion: p.Code.Version, Code: p.Code.Code, CodeDisplay: p.Code.Display,
		Note: p.Note, Status: string(p.Status),
		OnsetAt: timestamptz(p.OnsetAt), ResolvedAt: timestamptz(p.ResolvedAt),
		Confidentiality: string(p.Confidentiality),
		RecordedBy:      p.RecordedBy, RecordedAt: timestamptz(p.RecordedAt),
		UpdatedBy: p.UpdatedBy, UpdatedAt: timestamptz(p.UpdatedAt),
	})
}

// GetProblem reads one entry.
func (r RecordRepo) GetProblem(ctx context.Context, scope authctx.TenantScope,
	problemID string) (domain.Problem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Problem{}, err
	}
	id, err := uuid.Parse(problemID)
	if err != nil {
		return domain.Problem{}, notFound()
	}

	row, err := r.queries(ctx).GetProblem(ctx, sqlcgen.GetProblemParams{
		TenantID: tenantID, ProblemID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Problem{}, notFound()
	}
	if err != nil {
		return domain.Problem{}, err
	}
	return problemFromRow(sqlcgen.ClinicalProblem(row)), nil
}

// UpdateProblem writes a status change under optimistic concurrency.
func (r RecordRepo) UpdateProblem(ctx context.Context, scope authctx.TenantScope,
	p domain.Problem, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	problemID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetProblemStatus(ctx, sqlcgen.SetProblemStatusParams{
		TenantID: tenantID, ProblemID: problemID, Status: string(p.Status),
		ResolvedAt: timestamptz(p.ResolvedAt), UpdatedBy: p.UpdatedBy,
		UpdatedAt: timestamptz(p.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Problems returns a patient's list, resolved entries included by default.
func (r RecordRepo) Problems(ctx context.Context, scope authctx.TenantScope,
	patientID string, activeOnly bool, limit int32) (domain.ProblemList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListProblems(ctx, sqlcgen.ListProblemsParams{
		TenantID: tenantID, PatientID: patient,
		ActiveOnly: activeOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.ProblemList, 0, len(rows))
	for _, row := range rows {
		out = append(out, problemFromRow(sqlcgen.ClinicalProblem(row)))
	}
	return out, nil
}

func problemFromRow(row sqlcgen.ClinicalProblem) domain.Problem {
	return domain.Problem{
		ID: row.ProblemID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Note: row.Note, Status: domain.ProblemStatus(row.Status),
		OnsetAt: timeOrZero(row.OnsetAt), ResolvedAt: timeOrZero(row.ResolvedAt),
		Confidentiality: domain.Confidentiality(row.Confidentiality),
		RecordedBy:      row.RecordedBy, RecordedAt: timeOrZero(row.RecordedAt),
		UpdatedBy: row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}
}

// InsertAllergy stores an allergy or intolerance.
func (r RecordRepo) InsertAllergy(ctx context.Context, scope authctx.TenantScope,
	a domain.Allergy) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	allergyID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Internal("CLN_ALLERGY_ID_INVALID",
			"allergy_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(a.EncounterID)
	if err != nil {
		return err
	}
	reactions, err := json.Marshal(a.Reactions)
	if err != nil {
		return rpcerr.Internal("CLN_REACTIONS_ENCODE_FAILED",
			"could not encode the reactions").WithCause(err)
	}

	return r.queries(ctx).InsertAllergy(ctx, sqlcgen.InsertAllergyParams{
		AllergyID: allergyID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, SubstanceSystem: a.Substance.System,
		SubstanceVersion: a.Substance.Version, SubstanceCode: a.Substance.Code,
		SubstanceDisplay: a.Substance.Display, Kind: string(a.Kind),
		Criticality: string(a.Criticality), Verification: string(a.Verification),
		Reactions: reactions, OnsetAt: timestamptz(a.OnsetAt), Note: a.Note,
		RecordedBy: a.RecordedBy, RecordedAt: timestamptz(a.RecordedAt),
		UpdatedBy: a.UpdatedBy, UpdatedAt: timestamptz(a.UpdatedAt),
	})
}

// GetAllergy reads one record.
func (r RecordRepo) GetAllergy(ctx context.Context, scope authctx.TenantScope,
	allergyID string) (domain.Allergy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Allergy{}, err
	}
	id, err := uuid.Parse(allergyID)
	if err != nil {
		return domain.Allergy{}, notFound()
	}

	row, err := r.queries(ctx).GetAllergy(ctx, sqlcgen.GetAllergyParams{
		TenantID: tenantID, AllergyID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Allergy{}, notFound()
	}
	if err != nil {
		return domain.Allergy{}, err
	}
	return allergyFromRow(sqlcgen.ClinicalAllergy(row))
}

// UpdateAllergy records that somebody investigated.
func (r RecordRepo) UpdateAllergy(ctx context.Context, scope authctx.TenantScope,
	a domain.Allergy, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	allergyID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetAllergyVerification(ctx,
		sqlcgen.SetAllergyVerificationParams{
			TenantID: tenantID, AllergyID: allergyID,
			Verification: string(a.Verification), UpdatedBy: a.UpdatedBy,
			UpdatedAt: timestamptz(a.UpdatedAt), ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Allergies returns a patient's records.
func (r RecordRepo) Allergies(ctx context.Context, scope authctx.TenantScope,
	patientID string, activeOnly bool, limit int32) (domain.AllergyList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAllergies(ctx, sqlcgen.ListAllergiesParams{
		TenantID: tenantID, PatientID: patient,
		ActiveOnly: activeOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.AllergyList, 0, len(rows))
	for _, row := range rows {
		a, err := allergyFromRow(sqlcgen.ClinicalAllergy(row))
		if err != nil {
			return nil, err
		}
		out = append(out, a)
	}
	return out, nil
}

func allergyFromRow(row sqlcgen.ClinicalAllergy) (domain.Allergy, error) {
	var reactions []domain.Reaction
	if len(row.Reactions) > 0 {
		if err := json.Unmarshal(row.Reactions, &reactions); err != nil {
			return domain.Allergy{}, rpcerr.Internal("CLN_REACTIONS_DECODE_FAILED",
				"could not decode a stored allergy").WithCause(err)
		}
	}

	return domain.Allergy{
		ID: row.AllergyID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
		Substance: domain.Coding{
			System: row.SubstanceSystem, Version: row.SubstanceVersion,
			Code: row.SubstanceCode, Display: row.SubstanceDisplay,
		},
		Kind:         domain.AllergyKind(row.Kind),
		Criticality:  domain.AllergyCriticality(row.Criticality),
		Verification: domain.AllergyVerification(row.Verification),
		Reactions:    reactions, OnsetAt: timeOrZero(row.OnsetAt), Note: row.Note,
		RecordedBy: row.RecordedBy, RecordedAt: timeOrZero(row.RecordedAt),
		UpdatedBy: row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}, nil
}

// InsertObservation stores one measurement or finding.
func (r RecordRepo) InsertObservation(ctx context.Context, scope authctx.TenantScope,
	o domain.Observation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	observationID, err := uuid.Parse(o.ID)
	if err != nil {
		return rpcerr.Internal("CLN_OBSERVATION_ID_INVALID",
			"observation_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(o.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(o.EncounterID)
	if err != nil {
		return err
	}
	amends, err := optionalUUID(o.AmendsID)
	if err != nil {
		return err
	}

	// A zero quantity is a real measurement — a respiratory rate of zero is the
	// most important number on the chart — so the value is sent as NULL only
	// when there is no unit, which is what distinguishes "not a quantity" from
	// "quantity zero".
	var quantity *float64
	if o.Value.Unit != "" {
		value := o.Value.Value
		quantity = &value
	}

	return r.queries(ctx).InsertObservation(ctx, sqlcgen.InsertObservationParams{
		ObservationID: observationID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, CodeSystem: o.Code.System,
		CodeVersion: o.Code.Version, Code: o.Code.Code, CodeDisplay: o.Code.Display,
		ValueQuantity: quantity, ValueUnit: o.Value.Unit, ValueText: o.TextValue,
		ValueCodeSystem: o.CodedValue.System, ValueCode: o.CodedValue.Code,
		ValueCodeDisplay: o.CodedValue.Display,
		ReferenceLow:     o.ReferenceLow, ReferenceHigh: o.ReferenceHigh,
		ReferenceText:        o.ReferenceText,
		Interpretation:       string(o.Interpretation),
		InterpretationSource: o.InterpretationSource,
		Status:               string(o.Status),
		EffectiveAt:          timestamptz(o.EffectiveAt), IssuedAt: timestamptz(o.IssuedAt),
		PerformerID: o.PerformerID, DeviceID: o.DeviceID,
		SourceSystem: o.SourceSystem, Note: o.Note, AmendsID: amends,
		RecordedBy: o.RecordedBy, RecordedAt: timestamptz(o.RecordedAt),
	})
}

// GetObservation reads one result.
func (r RecordRepo) GetObservation(ctx context.Context, scope authctx.TenantScope,
	observationID string) (domain.Observation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Observation{}, err
	}
	id, err := uuid.Parse(observationID)
	if err != nil {
		return domain.Observation{}, notFound()
	}

	row, err := r.queries(ctx).GetObservation(ctx, sqlcgen.GetObservationParams{
		TenantID: tenantID, ObservationID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Observation{}, notFound()
	}
	if err != nil {
		return domain.Observation{}, err
	}
	return observationFromRow(sqlcgen.ClinicalObservation(row)), nil
}

// Observations returns a patient's results, or one code's trend.
func (r RecordRepo) Observations(ctx context.Context, scope authctx.TenantScope,
	q ports.ObservationQuery) (domain.ObservationList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(q.PatientID)
	if err != nil {
		return nil, notFound()
	}
	encounterID, err := optionalUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListObservations(ctx, sqlcgen.ListObservationsParams{
		TenantID: tenantID, PatientID: patient, CodeFilter: q.Code,
		EncounterID: encounterID, PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.ObservationList, 0, len(rows))
	for _, row := range rows {
		out = append(out, observationFromRow(sqlcgen.ClinicalObservation(row)))
	}
	return out, nil
}

// UnacknowledgedCritical returns the worklist that must reach a clinician now.
func (r RecordRepo) UnacknowledgedCritical(ctx context.Context,
	scope authctx.TenantScope, limit int32) (domain.ObservationList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListUnacknowledgedCriticalResults(ctx,
		sqlcgen.ListUnacknowledgedCriticalResultsParams{
			TenantID: tenantID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make(domain.ObservationList, 0, len(rows))
	for _, row := range rows {
		out = append(out, observationFromRow(sqlcgen.ClinicalObservation(row)))
	}
	return out, nil
}

// InsertAcknowledgement records a clinician acting on a critical result.
func (r RecordRepo) InsertAcknowledgement(ctx context.Context,
	scope authctx.TenantScope, a domain.CriticalAcknowledgement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	acknowledgementID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Internal("CLN_ACK_ID_INVALID",
			"acknowledgement_id must be a UUID").WithCause(err)
	}
	observationID, err := uuid.Parse(a.ObservationID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}

	return r.queries(ctx).InsertCriticalAcknowledgement(ctx,
		sqlcgen.InsertCriticalAcknowledgementParams{
			AcknowledgementID: acknowledgementID, TenantID: tenantID,
			ObservationID: observationID, PatientID: patientID,
			AcknowledgedBy: a.AcknowledgedBy,
			AcknowledgedAt: timestamptz(a.AcknowledgedAt),
			Action:         a.Action, NotifiedAt: timestamptz(a.NotifiedAt),
		})
}

// Acknowledgement reads the acknowledgement for one result, if there is one.
func (r RecordRepo) Acknowledgement(ctx context.Context, scope authctx.TenantScope,
	observationID string) (domain.CriticalAcknowledgement, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CriticalAcknowledgement{}, false, err
	}
	id, err := uuid.Parse(observationID)
	if err != nil {
		return domain.CriticalAcknowledgement{}, false, notFound()
	}

	row, err := r.queries(ctx).GetCriticalAcknowledgement(ctx,
		sqlcgen.GetCriticalAcknowledgementParams{
			TenantID: tenantID, ObservationID: id,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CriticalAcknowledgement{}, false, nil
	}
	if err != nil {
		return domain.CriticalAcknowledgement{}, false, err
	}

	return domain.CriticalAcknowledgement{
		ID: row.AcknowledgementID.String(), TenantID: row.TenantID.String(),
		ObservationID: row.ObservationID.String(), PatientID: row.PatientID.String(),
		AcknowledgedBy: row.AcknowledgedBy,
		AcknowledgedAt: timeOrZero(row.AcknowledgedAt),
		Action:         row.Action, NotifiedAt: timeOrZero(row.NotifiedAt),
	}, true, nil
}

func observationFromRow(row sqlcgen.ClinicalObservation) domain.Observation {
	o := domain.Observation{
		ID: row.ObservationID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Value:     domain.Quantity{Unit: row.ValueUnit},
		TextValue: row.ValueText,
		CodedValue: domain.Coding{
			System: row.ValueCodeSystem, Code: row.ValueCode,
			Display: row.ValueCodeDisplay,
		},
		ReferenceLow: row.ReferenceLow, ReferenceHigh: row.ReferenceHigh,
		ReferenceText:        row.ReferenceText,
		Interpretation:       domain.Interpretation(row.Interpretation),
		InterpretationSource: row.InterpretationSource,
		Status:               domain.ObservationStatus(row.Status),
		EffectiveAt:          timeOrZero(row.EffectiveAt),
		IssuedAt:             timeOrZero(row.IssuedAt),
		PerformerID:          row.PerformerID, DeviceID: row.DeviceID,
		SourceSystem: row.SourceSystem, Note: row.Note,
		AmendsID:   uuidOrEmpty(row.AmendsID),
		RecordedBy: row.RecordedBy, RecordedAt: timeOrZero(row.RecordedAt),
		Version: row.Version,
	}
	if row.ValueQuantity != nil {
		o.Value.Value = *row.ValueQuantity
	}
	return o
}

// InsertProcedure stores one thing done to a patient.
func (r RecordRepo) InsertProcedure(ctx context.Context, scope authctx.TenantScope,
	p domain.Procedure) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	procedureID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("CLN_PROCEDURE_ID_INVALID",
			"procedure_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := uuid.Parse(p.EncounterID)
	if err != nil {
		return rpcerr.Invalid("CLN_ENCOUNTER_ID_INVALID", "encounter_id must be a UUID")
	}

	indication, err := json.Marshal(p.Indication)
	if err != nil {
		return encodeFailed(err)
	}
	performers, err := json.Marshal(p.Performers)
	if err != nil {
		return encodeFailed(err)
	}
	bodySite, err := json.Marshal(p.BodySite)
	if err != nil {
		return encodeFailed(err)
	}
	complications, err := json.Marshal(orEmptyCodings(p.Complications))
	if err != nil {
		return encodeFailed(err)
	}

	return r.queries(ctx).InsertProcedure(ctx, sqlcgen.InsertProcedureParams{
		ProcedureID: procedureID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, CodeSystem: p.Code.System,
		CodeVersion: p.Code.Version, Code: p.Code.Code, CodeDisplay: p.Code.Display,
		Status: string(p.Status), Indication: indication, Performers: performers,
		BodySite: bodySite, Laterality: string(p.Laterality), Outcome: p.Outcome,
		Complications: complications,
		OrderIds:      orEmpty(p.OrderIDs), DeviceIds: orEmpty(p.DeviceIDs),
		SpecimenIds:    orEmpty(p.SpecimenIDs),
		PerformedStart: timestamptz(p.PerformedStart),
		PerformedEnd:   timestamptz(p.PerformedEnd),
		Note:           p.Note, RecordedBy: p.RecordedBy,
		RecordedAt: timestamptz(p.RecordedAt), UpdatedAt: timestamptz(p.UpdatedAt),
	})
}

// GetProcedure reads one record.
func (r RecordRepo) GetProcedure(ctx context.Context, scope authctx.TenantScope,
	procedureID string) (domain.Procedure, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Procedure{}, err
	}
	id, err := uuid.Parse(procedureID)
	if err != nil {
		return domain.Procedure{}, notFound()
	}

	row, err := r.queries(ctx).GetProcedure(ctx, sqlcgen.GetProcedureParams{
		TenantID: tenantID, ProcedureID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Procedure{}, notFound()
	}
	if err != nil {
		return domain.Procedure{}, err
	}
	return procedureFromRow(sqlcgen.ClinicalProcedure(row))
}

// Procedures returns a patient's procedures, most recent first.
func (r RecordRepo) Procedures(ctx context.Context, scope authctx.TenantScope,
	patientID, encounterID string, limit int32) ([]domain.Procedure, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}
	encounter, err := optionalUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListProcedures(ctx, sqlcgen.ListProceduresParams{
		TenantID: tenantID, PatientID: patient, EncounterID: encounter,
		PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Procedure, 0, len(rows))
	for _, row := range rows {
		p, err := procedureFromRow(sqlcgen.ClinicalProcedure(row))
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, nil
}

func procedureFromRow(row sqlcgen.ClinicalProcedure) (domain.Procedure, error) {
	p := domain.Procedure{
		ID: row.ProcedureID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Status:     domain.ProcedureStatus(row.Status),
		Laterality: domain.Laterality(row.Laterality), Outcome: row.Outcome,
		OrderIDs: row.OrderIds, DeviceIDs: row.DeviceIds, SpecimenIDs: row.SpecimenIds,
		PerformedStart: timeOrZero(row.PerformedStart),
		PerformedEnd:   timeOrZero(row.PerformedEnd),
		Note:           row.Note, RecordedBy: row.RecordedBy,
		RecordedAt: timeOrZero(row.RecordedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}
	if err := json.Unmarshal(row.Indication, &p.Indication); err != nil {
		return domain.Procedure{}, decodeFailed(err)
	}
	if err := json.Unmarshal(row.Performers, &p.Performers); err != nil {
		return domain.Procedure{}, decodeFailed(err)
	}
	if err := json.Unmarshal(row.BodySite, &p.BodySite); err != nil {
		return domain.Procedure{}, decodeFailed(err)
	}
	if err := json.Unmarshal(row.Complications, &p.Complications); err != nil {
		return domain.Procedure{}, decodeFailed(err)
	}
	return p, nil
}

// InsertCarePlan stores a plan of care.
func (r RecordRepo) InsertCarePlan(ctx context.Context, scope authctx.TenantScope,
	p domain.CarePlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	carePlanID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("CLN_CARE_PLAN_ID_INVALID",
			"care_plan_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(p.EncounterID)
	if err != nil {
		return err
	}

	goals, err := json.Marshal(orEmptyGoals(p.Goals))
	if err != nil {
		return encodeFailed(err)
	}
	activities, err := json.Marshal(orEmptyActivities(p.Activities))
	if err != nil {
		return encodeFailed(err)
	}

	return r.queries(ctx).InsertCarePlan(ctx, sqlcgen.InsertCarePlanParams{
		CarePlanID: carePlanID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, Title: p.Title, Status: string(p.Status),
		ProblemIds: orEmpty(p.ProblemIDs), Goals: goals, Activities: activities,
		OwnerID: p.OwnerID, StartsAt: timestamptz(p.StartsAt),
		EndsAt: timestamptz(p.EndsAt), CreatedBy: p.CreatedBy,
		CreatedAt: timestamptz(p.CreatedAt), UpdatedAt: timestamptz(p.UpdatedAt),
	})
}

// GetCarePlan reads one plan.
func (r RecordRepo) GetCarePlan(ctx context.Context, scope authctx.TenantScope,
	carePlanID string) (domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CarePlan{}, err
	}
	id, err := uuid.Parse(carePlanID)
	if err != nil {
		return domain.CarePlan{}, notFound()
	}

	row, err := r.queries(ctx).GetCarePlan(ctx, sqlcgen.GetCarePlanParams{
		TenantID: tenantID, CarePlanID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CarePlan{}, notFound()
	}
	if err != nil {
		return domain.CarePlan{}, err
	}
	return carePlanFromRow(sqlcgen.ClinicalCarePlan(row))
}

// UpdateCarePlan writes a plan back under optimistic concurrency.
func (r RecordRepo) UpdateCarePlan(ctx context.Context, scope authctx.TenantScope,
	p domain.CarePlan, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	carePlanID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	goals, err := json.Marshal(orEmptyGoals(p.Goals))
	if err != nil {
		return encodeFailed(err)
	}
	activities, err := json.Marshal(orEmptyActivities(p.Activities))
	if err != nil {
		return encodeFailed(err)
	}

	rows, err := r.queries(ctx).UpdateCarePlan(ctx, sqlcgen.UpdateCarePlanParams{
		TenantID: tenantID, CarePlanID: carePlanID, Status: string(p.Status),
		Goals: goals, Activities: activities, ProblemIds: orEmpty(p.ProblemIDs),
		UpdatedAt: timestamptz(p.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// CarePlans returns a patient's plans.
func (r RecordRepo) CarePlans(ctx context.Context, scope authctx.TenantScope,
	patientID string, activeOnly bool, limit int32) ([]domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCarePlans(ctx, sqlcgen.ListCarePlansParams{
		TenantID: tenantID, PatientID: patient,
		ActiveOnly: activeOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CarePlan, 0, len(rows))
	for _, row := range rows {
		p, err := carePlanFromRow(sqlcgen.ClinicalCarePlan(row))
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, nil
}

func carePlanFromRow(row sqlcgen.ClinicalCarePlan) (domain.CarePlan, error) {
	p := domain.CarePlan{
		ID: row.CarePlanID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
		Title: row.Title, Status: domain.CarePlanStatus(row.Status),
		ProblemIDs: row.ProblemIds, OwnerID: row.OwnerID,
		StartsAt: timeOrZero(row.StartsAt), EndsAt: timeOrZero(row.EndsAt),
		CreatedBy: row.CreatedBy, CreatedAt: timeOrZero(row.CreatedAt),
		UpdatedAt: timeOrZero(row.UpdatedAt), Version: row.Version,
	}
	if err := json.Unmarshal(row.Goals, &p.Goals); err != nil {
		return domain.CarePlan{}, decodeFailed(err)
	}
	if err := json.Unmarshal(row.Activities, &p.Activities); err != nil {
		return domain.CarePlan{}, decodeFailed(err)
	}
	return p, nil
}

func encodeFailed(err error) error {
	return rpcerr.Internal("CLN_ENCODE_FAILED",
		"could not encode a clinical record").WithCause(err)
}

func decodeFailed(err error) error {
	return rpcerr.Internal("CLN_DECODE_FAILED",
		"could not decode a stored clinical record").WithCause(err)
}

// orEmptyCodings, orEmptyGoals and orEmptyActivities render a nil slice as an
// empty JSON array rather than "null", which the NOT NULL jsonb columns refuse.
func orEmptyCodings(in []domain.Coding) []domain.Coding {
	if in == nil {
		return []domain.Coding{}
	}
	return in
}

func orEmptyGoals(in []domain.Goal) []domain.Goal {
	if in == nil {
		return []domain.Goal{}
	}
	return in
}

func orEmptyActivities(in []domain.Activity) []domain.Activity {
	if in == nil {
		return []domain.Activity{}
	}
	return in
}
