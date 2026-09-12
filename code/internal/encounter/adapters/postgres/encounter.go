package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Encounters and their status history (SRS-ENC-001 … SRS-ENC-006).

// EncounterRepo implements the encounter repository port.
type EncounterRepo struct{ *Repository }

var _ ports.EncounterRepository = EncounterRepo{}

// Insert stores a new encounter and the history entry it was created with.
func (r EncounterRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	e *domain.Encounter) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	encounterID, err := uuid.Parse(e.ID())
	if err != nil {
		return rpcerr.Internal("ENC_ID_INVALID", "encounter_id must be a UUID").WithCause(err)
	}
	facilityID, err := uuid.Parse(e.FacilityID)
	if err != nil {
		return rpcerr.Internal("ENC_FACILITY_ID_INVALID",
			"facility_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(e.PatientID)
	if err != nil {
		return rpcerr.Invalid("ENC_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	orgUnit, err := optionalUUID(e.OrgUnitID)
	if err != nil {
		return err
	}
	appointment, err := optionalUUID(e.AppointmentID)
	if err != nil {
		return err
	}
	episode, err := optionalUUID(e.EpisodeID)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	if err := q.InsertEncounter(ctx, sqlcgen.InsertEncounterParams{
		EncounterID: encounterID, TenantID: tenantID, FacilityID: facilityID,
		OrgUnitID: orgUnit, PatientID: patientID, Class: string(e.Class),
		VisitType: e.VisitType, AttendingProviderID: e.AttendingProviderID,
		AppointmentID: appointment, EpisodeID: episode,
		ReferralID: e.ReferralID, Reason: e.Reason, Status: string(e.Status),
		StartedAt: timestamptz(e.StartedAt), EndedAt: timestamptz(e.EndedAt),
		ClosedAt:  timestamptz(e.ClosedAt),
		CreatedBy: e.CreatedBy,
		CreatedAt: timestamptz(e.CreatedAt), UpdatedAt: timestamptz(e.UpdatedAt),
	}); err != nil {
		return err
	}

	// The history entries the aggregate was constructed with, in the same
	// transaction. An encounter whose history did not survive its own insert
	// would be one nobody could explain later.
	for _, change := range e.History {
		if err := r.appendHistory(ctx, q, tenantID, encounterID, change); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one encounter with its history.
func (r EncounterRepo) Get(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (*domain.Encounter, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return nil, notFound()
	}

	row, err := r.queries(ctx).GetEncounter(ctx, sqlcgen.GetEncounterParams{
		TenantID: tenantID, EncounterID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}

	e := encounterFromRow(sqlcgen.EncounterEncounter(row))
	history, err := r.History(ctx, scope, encounterID)
	if err != nil {
		return nil, err
	}
	e.History = history
	return e, nil
}

// SetState writes the status and the clinical times together (SRS-ENC-006).
func (r EncounterRepo) SetState(ctx context.Context, scope authctx.TenantScope,
	e *domain.Encounter, change domain.StatusChange, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	encounterID, err := uuid.Parse(e.ID())
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	rows, err := q.SetEncounterState(ctx, sqlcgen.SetEncounterStateParams{
		TenantID: tenantID, EncounterID: encounterID, Status: string(e.Status),
		StartedAt: timestamptz(e.StartedAt), EndedAt: timestamptz(e.EndedAt),
		ClosedAt:            timestamptz(e.ClosedAt),
		AttendingProviderID: e.AttendingProviderID,
		UpdatedAt:           timestamptz(e.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Another writer got here first. Two clinicians closing the same
		// encounter would otherwise both believe they did, and only one of the
		// two summaries would be the one anybody sees.
		return ports.ErrVersionConflict
	}
	e.Version = expectedVersion + 1

	return r.appendHistory(ctx, q, tenantID, encounterID, change)
}

// ForPatient returns a patient's chronology, newest first.
func (r EncounterRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	query ports.PatientQuery) ([]*domain.Encounter, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patientID, err := uuid.Parse(query.PatientID)
	if err != nil {
		return nil, notFound()
	}
	episode, err := optionalUUID(query.EpisodeID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListEncountersForPatient(ctx,
		sqlcgen.ListEncountersForPatientParams{
			TenantID: tenantID, PatientID: patientID, EpisodeID: episode,
			ClassFilter: string(query.Class), IncludeRetracted: query.IncludeRetracted,
			PageLimit: query.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Encounter, 0, len(rows))
	for _, row := range rows {
		out = append(out, encounterFromRow(sqlcgen.EncounterEncounter(row)))
	}
	return out, nil
}

// Open returns the encounters still under way at a facility — the ward round.
func (r EncounterRepo) Open(ctx context.Context, scope authctx.TenantScope,
	facilityID string, class domain.Class, limit int32) ([]*domain.Encounter, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := uuid.Parse(facilityID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListOpenEncounters(ctx, sqlcgen.ListOpenEncountersParams{
		TenantID: tenantID, FacilityID: facility,
		ClassFilter: string(class), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Encounter, 0, len(rows))
	for _, row := range rows {
		out = append(out, encounterFromRow(sqlcgen.EncounterEncounter(row)))
	}
	return out, nil
}

// History returns every status an encounter has held.
func (r EncounterRepo) History(ctx context.Context, scope authctx.TenantScope,
	encounterID string) ([]domain.StatusChange, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListEncounterStatusHistory(ctx,
		sqlcgen.ListEncounterStatusHistoryParams{TenantID: tenantID, EncounterID: id})
	if err != nil {
		return nil, err
	}

	out := make([]domain.StatusChange, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.StatusChange{
			From: domain.Status(row.FromStatus), To: domain.Status(row.ToStatus),
			At: timeOrZero(row.ChangedAt), By: row.ChangedBy, Reason: row.Reason,
		})
	}
	return out, nil
}

func (r EncounterRepo) appendHistory(ctx context.Context, q *sqlcgen.Queries,
	tenantID, encounterID uuid.UUID, change domain.StatusChange) error {

	at := change.At
	if at.IsZero() {
		at = time.Now()
	}
	return q.InsertEncounterStatusHistory(ctx, sqlcgen.InsertEncounterStatusHistoryParams{
		HistoryID: uuid.New(), TenantID: tenantID, EncounterID: encounterID,
		FromStatus: string(change.From), ToStatus: string(change.To),
		ChangedAt: timestamptz(at), ChangedBy: change.By, Reason: change.Reason,
	})
}

func encounterFromRow(row sqlcgen.EncounterEncounter) *domain.Encounter {
	return domain.RestoreEncounter(row.EncounterID.String(), domain.Encounter{
		TenantID: row.TenantID.String(), FacilityID: row.FacilityID.String(),
		OrgUnitID: uuidOrEmpty(row.OrgUnitID), PatientID: row.PatientID.String(),
		Class: domain.Class(row.Class), VisitType: row.VisitType,
		AttendingProviderID: row.AttendingProviderID,
		AppointmentID:       uuidOrEmpty(row.AppointmentID),
		EpisodeID:           uuidOrEmpty(row.EpisodeID),
		ReferralID:          row.ReferralID, Reason: row.Reason,
		Status:    domain.Status(row.Status),
		StartedAt: timeOrZero(row.StartedAt), EndedAt: timeOrZero(row.EndedAt),
		ClosedAt:  timeOrZero(row.ClosedAt),
		CreatedBy: row.CreatedBy,
		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	})
}
