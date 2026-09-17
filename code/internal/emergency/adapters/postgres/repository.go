// Package postgres is the emergency context's persistence adapter.
//
// It is the only package permitted to issue SQL against the emergency schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/emergency/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the emergency repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("ER_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("ER_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

func notFound() error {
	return rpcerr.NotFound("ER_VISIT_NOT_FOUND", "no such emergency visit")
}

func stamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func timeOf(t pgtype.Timestamptz) time.Time {
	if !t.Valid {
		return time.Time{}
	}
	return t.Time.UTC()
}

// optionalUUID renders an empty string as SQL NULL.
func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, notFound()
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidOrEmpty(value pgtype.UUID) string {
	if !value.Valid {
		return ""
	}
	return uuid.UUID(value.Bytes).String()
}

// VisitRepo implements ports.VisitRepository.
type VisitRepo struct{ *Repository }

var _ ports.VisitRepository = VisitRepo{}

// InsertVisit books a patient into the department.
func (r VisitRepo) InsertVisit(ctx context.Context, scope authctx.TenantScope,
	v domain.Visit) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	visitID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}
	encounterID, err := uuid.Parse(v.EncounterID)
	if err != nil {
		return rpcerr.Invalid("ER_ENCOUNTER_ID_INVALID", "encounter_id must be a UUID")
	}
	patientID, err := optionalUUID(v.PatientID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertEmergencyVisit(ctx, sqlcgen.InsertEmergencyVisitParams{
		VisitID: visitID, TenantID: tenantID, EncounterID: encounterID,
		PatientID: patientID, FacilityID: v.FacilityID,
		ArrivalMode: string(v.ArrivalMode), ChiefComplaint: v.ChiefComplaint,
		ArrivedAt: stamp(v.ArrivedAt), Unidentified: v.Unidentified,
		TemporaryName: v.TemporaryName, MedicoLegal: v.MedicoLegal,
		MedicoLegalRef: v.MedicoLegalRef, Status: string(v.Status),
		Location: v.Location, CreatedBy: v.CreatedBy,
		CreatedAt: stamp(v.CreatedAt), UpdatedAt: stamp(v.UpdatedAt),
	})
}

// GetVisit reads one visit.
func (r VisitRepo) GetVisit(ctx context.Context, scope authctx.TenantScope,
	visitID string) (domain.Visit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Visit{}, err
	}
	id, err := uuid.Parse(visitID)
	if err != nil {
		return domain.Visit{}, notFound()
	}

	row, err := r.queries(ctx).GetEmergencyVisit(ctx, sqlcgen.GetEmergencyVisitParams{
		TenantID: tenantID, VisitID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Visit{}, notFound()
	}
	if err != nil {
		return domain.Visit{}, err
	}
	return visitFromRow(row), nil
}

// UpdateVisit writes a visit back, guarded on its version.
func (r VisitRepo) UpdateVisit(ctx context.Context, scope authctx.TenantScope,
	v domain.Visit, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	visitID, err := uuid.Parse(v.ID)
	if err != nil {
		return notFound()
	}
	patientID, err := optionalUUID(v.PatientID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateEmergencyVisit(ctx, sqlcgen.UpdateEmergencyVisitParams{
		TenantID: tenantID, VisitID: visitID, ExpectedVersion: expectedVersion,
		PatientID: patientID, Unidentified: v.Unidentified,
		Status: string(v.Status), Location: v.Location,
		Disposition: string(v.Disposition), DisposedAt: stamp(v.DisposedAt),
		DispositionNote: v.DispositionNote, ReceivingService: v.ReceivingService,
		ObservationStartedAt: stamp(v.ObservationStartedAt),
		ObservationEndsAt:    stamp(v.ObservationEndsAt),
		MedicoLegal:          v.MedicoLegal, MedicoLegalRef: v.MedicoLegalRef,
		UpdatedAt: stamp(v.UpdatedAt),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Either the visit is gone or somebody else advanced it. The caller
		// re-reads and decides; guessing which would be wrong half the time.
		return ports.ErrVersionConflict
	}
	return nil
}

// OpenVisits is the department as it stands.
func (r VisitRepo) OpenVisits(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) ([]domain.Visit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if limit <= 0 {
		limit = 200
	}

	rows, err := r.queries(ctx).ListOpenEmergencyVisits(ctx,
		sqlcgen.ListOpenEmergencyVisitsParams{
			TenantID: tenantID, FacilityFilter: facilityID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Visit, 0, len(rows))
	for _, row := range rows {
		out = append(out, visitFromRow(row))
	}
	return out, nil
}

func visitFromRow(row sqlcgen.EmergencyVisit) domain.Visit {
	v := domain.Visit{
		ID: row.VisitID.String(), TenantID: row.TenantID.String(),
		EncounterID:    row.EncounterID.String(),
		PatientID:      uuidOrEmpty(row.PatientID),
		FacilityID:     row.FacilityID,
		ArrivalMode:    domain.ArrivalMode(row.ArrivalMode),
		ChiefComplaint: row.ChiefComplaint,
		ArrivedAt:      timeOf(row.ArrivedAt),
		Unidentified:   row.Unidentified, TemporaryName: row.TemporaryName,
		MedicoLegal: row.MedicoLegal, MedicoLegalRef: row.MedicoLegalRef,
		Status: domain.VisitStatus(row.Status), Location: row.Location,
		Disposition:          domain.Disposition(row.Disposition),
		DisposedAt:           timeOf(row.DisposedAt),
		DispositionNote:      row.DispositionNote,
		ReceivingService:     row.ReceivingService,
		ObservationStartedAt: timeOf(row.ObservationStartedAt),
		ObservationEndsAt:    timeOf(row.ObservationEndsAt),
		CreatedBy:            row.CreatedBy, CreatedAt: timeOf(row.CreatedAt),
		UpdatedAt: timeOf(row.UpdatedAt), Version: row.Version,
	}
	// A stored value this build cannot read is named as unreadable rather than
	// guessed at. A transfer misread as a walk-in is a referring hospital
	// nobody writes back to.
	if !domain.KnownArrivalMode(row.ArrivalMode) {
		v.ArrivalMode = domain.ArrivalUnspecified
	}
	if row.Disposition != "" && !domain.KnownDisposition(row.Disposition) {
		v.Disposition = domain.DispositionUnknown
	}
	return v
}
