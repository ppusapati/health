// Package postgres is the perioperative persistence adapter.
//
// It is the only package permitted to issue SQL against the theatre schema
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

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// Repository implements the perioperative repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("OT_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("OT_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("OT_NOT_FOUND", "no such theatre record")
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

// uuidList parses a slice of identifiers, skipping any that are malformed.
//
// Skipping rather than refusing: these come from rows this adapter has just
// read, so a malformed one would be a corrupt row, and failing a whole board
// because of it would hide every other theatre.
func uuidList(values []string) []uuid.UUID {
	out := make([]uuid.UUID, 0, len(values))
	for _, value := range values {
		if parsed, err := uuid.Parse(value); err == nil {
			out = append(out, parsed)
		}
	}
	return out
}

func strings0(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// ScheduleRepo implements ports.ScheduleRepository.
type ScheduleRepo struct{ *Repository }

var _ ports.ScheduleRepository = ScheduleRepo{}

// SaveRoom creates or updates a theatre.
func (r ScheduleRepo) SaveRoom(ctx context.Context, scope authctx.TenantScope,
	room domain.Room) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	roomID, err := uuid.Parse(room.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpsertTheatreRoom(ctx, sqlcgen.UpsertTheatreRoomParams{
		RoomID: roomID, TenantID: tenantID, FacilityID: room.FacilityID,
		Code: room.Code, Name: room.Name,
		Specialties: strings0(room.Specialties), Equipment: strings0(room.Equipment),
		Active: room.Active,
	})
}

// Room reads one theatre.
func (r ScheduleRepo) Room(ctx context.Context, scope authctx.TenantScope,
	roomID string) (domain.Room, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Room{}, err
	}
	id, err := uuid.Parse(roomID)
	if err != nil {
		return domain.Room{}, notFound()
	}

	row, err := r.queries(ctx).GetTheatreRoom(ctx, sqlcgen.GetTheatreRoomParams{
		TenantID: tenantID, RoomID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Room{}, notFound()
	}
	if err != nil {
		return domain.Room{}, err
	}
	return roomFrom(row), nil
}

// Rooms lists a facility's theatres.
func (r ScheduleRepo) Rooms(ctx context.Context, scope authctx.TenantScope,
	facilityID string) ([]domain.Room, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTheatreRooms(ctx, sqlcgen.ListTheatreRoomsParams{
		TenantID: tenantID, FacilityID: facilityID,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Room, 0, len(rows))
	for _, row := range rows {
		out = append(out, roomFrom(row))
	}
	return out, nil
}

func roomFrom(row sqlcgen.TheatreRoom) domain.Room {
	return domain.Room{
		ID: row.RoomID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID, Code: row.Code, Name: row.Name,
		Specialties: row.Specialties, Equipment: row.Equipment, Active: row.Active,
	}
}

// InsertBlock records a stretch of theatre time.
func (r ScheduleRepo) InsertBlock(ctx context.Context, scope authctx.TenantScope,
	block domain.Block) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	blockID, err := uuid.Parse(block.ID)
	if err != nil {
		return notFound()
	}
	roomID, err := uuid.Parse(block.RoomID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreBlock(ctx, sqlcgen.InsertTheatreBlockParams{
		BlockID: blockID, TenantID: tenantID, RoomID: roomID,
		Kind: string(block.Kind), OwnerID: block.OwnerID, Specialty: block.Specialty,
		StartsAt: stamp(block.StartsAt), EndsAt: stamp(block.EndsAt),
		Note: block.Note,
	})
}

// Blocks reads a facility's blocks over a window.
func (r ScheduleRepo) Blocks(ctx context.Context, scope authctx.TenantScope,
	facilityID string, from, to time.Time) ([]domain.Block, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTheatreBlocks(ctx, sqlcgen.ListTheatreBlocksParams{
		TenantID: tenantID, FacilityID: facilityID,
		PeriodStart: stamp(from), PeriodEnd: stamp(to),
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Block, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Block{
			ID: row.BlockID.String(), TenantID: row.TenantID.String(),
			RoomID: row.RoomID.String(), Kind: domain.BlockKind(row.Kind),
			OwnerID: row.OwnerID, Specialty: row.Specialty,
			StartsAt: timeOf(row.StartsAt), EndsAt: timeOf(row.EndsAt),
			Note: row.Note,
		})
	}
	return out, nil
}

// InsertCase raises a surgery request.
func (r ScheduleRepo) InsertCase(ctx context.Context, scope authctx.TenantScope,
	c domain.Case) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	// The aggregate must belong to the scope writing it, so a caller who
	// assembled one by hand cannot plant it in another tenant.
	if c.TenantID != scope.TenantID() {
		return rpcerr.Internal("OT_SCOPE_MISMATCH",
			"this case belongs to another tenant")
	}
	caseID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	encounterID, err := uuid.Parse(c.EncounterID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(c.PatientID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTheatreCase(ctx, sqlcgen.InsertTheatreCaseParams{
		CaseID: caseID, TenantID: tenantID, EncounterID: encounterID,
		PatientID: patientID, FacilityID: c.FacilityID,
		ProcedureCode: c.ProcedureCode, ProcedureDisplay: c.ProcedureDisplay,
		DiagnosisCode: c.DiagnosisCode, DiagnosisDisplay: c.DiagnosisDisplay,
		Laterality: string(c.Laterality), Site: c.Site,
		Urgency:                 string(c.Urgency),
		ExpectedDurationSeconds: int64(c.ExpectedDuration / time.Second),
		SurgeonID:               c.SurgeonID,
		Team:                    strings0(c.Team),
		Requirements:            strings0(c.Requirements),
		AnaesthesiaType:         c.AnaesthesiaType,
		SpecialNotes:            c.SpecialNotes,
		Status:                  string(c.Status),
		RequestedBy:             c.RequestedBy,
		RequestedAt:             stamp(c.RequestedAt),
		UpdatedAt:               stamp(c.UpdatedAt),
	})
}

// Case reads one case.
func (r ScheduleRepo) Case(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Case{}, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return domain.Case{}, notFound()
	}

	row, err := r.queries(ctx).GetTheatreCase(ctx, sqlcgen.GetTheatreCaseParams{
		TenantID: tenantID, CaseID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Case{}, notFound()
	}
	if err != nil {
		return domain.Case{}, err
	}
	return caseFrom(row), nil
}

// UpdateCase writes a case back, guarded on its version.
func (r ScheduleRepo) UpdateCase(ctx context.Context, scope authctx.TenantScope,
	c domain.Case, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	if c.TenantID != scope.TenantID() {
		return rpcerr.Internal("OT_SCOPE_MISMATCH",
			"this case belongs to another tenant")
	}
	caseID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	roomID, err := optionalUUID(c.RoomID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateTheatreCase(ctx, sqlcgen.UpdateTheatreCaseParams{
		DiagnosisCode: c.DiagnosisCode, DiagnosisDisplay: c.DiagnosisDisplay,
		Laterality: string(c.Laterality), Site: c.Site,
		Urgency:                 string(c.Urgency),
		ExpectedDurationSeconds: int64(c.ExpectedDuration / time.Second),
		SurgeonID:               c.SurgeonID,
		Team:                    strings0(c.Team),
		Requirements:            strings0(c.Requirements),
		AnaesthesiaType:         c.AnaesthesiaType,
		SpecialNotes:            c.SpecialNotes,
		Status:                  string(c.Status),
		RoomID:                  roomID,
		ScheduledStart:          stamp(c.ScheduledStart),
		ScheduledEnd:            stamp(c.ScheduledEnd),
		Outcome:                 string(c.Outcome),
		OutcomeReason:           c.OutcomeReason,
		OutcomeNote:             c.OutcomeNote,
		OutcomeAt:               stamp(c.OutcomeAt),
		UpdatedAt:               stamp(c.UpdatedAt),
		TenantID:                tenantID,
		CaseID:                  caseID,
		ExpectedVersion:         expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// RoomCases is one room's list over a window.
func (r ScheduleRepo) RoomCases(ctx context.Context, scope authctx.TenantScope,
	roomID string, from, to time.Time) ([]domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(roomID)
	if err != nil {
		return nil, notFound()
	}
	rows, err := r.queries(ctx).ListTheatreCasesForRoom(ctx,
		sqlcgen.ListTheatreCasesForRoomParams{
			TenantID: tenantID, RoomID: pgtype.UUID{Bytes: id, Valid: true},
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	return casesFrom(rows), nil
}

// SurgeonCases is a surgeon's own diary.
func (r ScheduleRepo) SurgeonCases(ctx context.Context, scope authctx.TenantScope,
	surgeonID string, from, to time.Time) ([]domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListSurgeonTheatreCases(ctx,
		sqlcgen.ListSurgeonTheatreCasesParams{
			TenantID: tenantID, SurgeonID: surgeonID,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	return casesFrom(rows), nil
}

// CasesInPeriod is every case in a window, for utilisation and cancellation
// analytics.
func (r ScheduleRepo) CasesInPeriod(ctx context.Context, scope authctx.TenantScope,
	facilityID string, from, to time.Time) ([]domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTheatreCasesInPeriod(ctx,
		sqlcgen.ListTheatreCasesInPeriodParams{
			TenantID: tenantID, FacilityID: facilityID,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	return casesFrom(rows), nil
}

// Waiting is the cases with no slot yet.
func (r ScheduleRepo) Waiting(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) ([]domain.Case, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListWaitingTheatreCases(ctx,
		sqlcgen.ListWaitingTheatreCasesParams{
			TenantID: tenantID, FacilityID: facilityID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return casesFrom(rows), nil
}

func casesFrom(rows []sqlcgen.TheatreCase) []domain.Case {
	out := make([]domain.Case, 0, len(rows))
	for _, row := range rows {
		out = append(out, caseFrom(row))
	}
	return out
}

func caseFrom(row sqlcgen.TheatreCase) domain.Case {
	return domain.Case{
		ID: row.CaseID.String(), TenantID: row.TenantID.String(),
		EncounterID: row.EncounterID.String(), PatientID: row.PatientID.String(),
		FacilityID:    row.FacilityID,
		ProcedureCode: row.ProcedureCode, ProcedureDisplay: row.ProcedureDisplay,
		DiagnosisCode: row.DiagnosisCode, DiagnosisDisplay: row.DiagnosisDisplay,
		Laterality: domain.Laterality(row.Laterality), Site: row.Site,
		Urgency:          domain.Urgency(row.Urgency),
		ExpectedDuration: time.Duration(row.ExpectedDurationSeconds) * time.Second,
		SurgeonID:        row.SurgeonID,
		Team:             row.Team, Requirements: row.Requirements,
		AnaesthesiaType: row.AnaesthesiaType, SpecialNotes: row.SpecialNotes,
		Status:         domain.CaseStatus(row.Status),
		RoomID:         uuidOrEmpty(row.RoomID),
		ScheduledStart: timeOf(row.ScheduledStart),
		ScheduledEnd:   timeOf(row.ScheduledEnd),
		Outcome:        domain.CaseOutcome(row.Outcome),
		OutcomeReason:  row.OutcomeReason, OutcomeNote: row.OutcomeNote,
		OutcomeAt:   timeOf(row.OutcomeAt),
		RequestedBy: row.RequestedBy, RequestedAt: timeOf(row.RequestedAt),
		UpdatedAt: timeOf(row.UpdatedAt), Version: row.Version,
	}
}
