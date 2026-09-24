package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// The bed and room master (SRS-PLT-006).

var _ ports.BedMasterRepository = (*Repository)(nil)

// InsertClass records an accommodation class.
func (r *Repository) InsertClass(ctx context.Context, scope authctx.TenantScope,
	c domain.BedClass) error {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("ORG_CLASS_ID_INVALID", "class id must be a UUID")
	}

	err = r.queries(ctx).InsertBedClass(ctx, sqlcgen.InsertBedClassParams{
		ClassID: id, TenantID: tenant,
		Code: c.Code, DisplayName: c.DisplayName, ChargeCode: c.ChargeCode,
		Status:    string(c.Status),
		CreatedAt: timestamptz(c.CreatedAt), UpdatedAt: timestamptz(c.UpdatedAt),
		Version: c.Version,
	})
	return bedMasterError(err, "class", c.Code)
}

// ClassByCode reads one class by its code, which is the key a tariff names.
func (r *Repository) ClassByCode(ctx context.Context, scope authctx.TenantScope,
	code string) (domain.BedClass, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return domain.BedClass{}, err
	}
	row, err := r.queries(ctx).GetBedClassByCode(ctx,
		sqlcgen.GetBedClassByCodeParams{TenantID: tenant, Code: code})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.BedClass{}, rpcerr.NotFound(
			"ORG_CLASS_NOT_FOUND", "accommodation class not found")
	}
	if err != nil {
		return domain.BedClass{}, err
	}
	return classFromRow(row), nil
}

// ListClasses returns the tenant's catalogue.
func (r *Repository) ListClasses(ctx context.Context,
	scope authctx.TenantScope) ([]domain.BedClass, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListBedClasses(ctx, tenant)
	if err != nil {
		return nil, err
	}
	out := make([]domain.BedClass, 0, len(rows))
	for _, row := range rows {
		out = append(out, classFromRow(row))
	}
	return out, nil
}

// InsertRoom records a room.
func (r *Repository) InsertRoom(ctx context.Context, scope authctx.TenantScope,
	room domain.Room) error {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(room.ID)
	if err != nil {
		return rpcerr.Internal("ORG_ROOM_ID_INVALID", "room id must be a UUID")
	}
	facility, err := uuid.Parse(room.FacilityID)
	if err != nil {
		return rpcerr.Invalid("ORG_ROOM_FACILITY_INVALID",
			"a room's facility must be a UUID")
	}
	unit, err := uuid.Parse(room.UnitID)
	if err != nil {
		return rpcerr.Invalid("ORG_ROOM_UNIT_INVALID",
			"a room's ward must be a UUID")
	}

	err = r.queries(ctx).InsertRoom(ctx, sqlcgen.InsertRoomParams{
		RoomID: id, TenantID: tenant, FacilityID: facility, UnitID: unit,
		Code: room.Code, DisplayName: room.DisplayName,
		ClassCode:    room.ClassCode,
		GenderPolicy: string(room.GenderPolicy),
		Isolation:    string(room.Isolation),
		Status:       string(room.Status),
		CreatedAt:    timestamptz(room.CreatedAt),
		UpdatedAt:    timestamptz(room.UpdatedAt),
		Version:      room.Version,
	})
	return bedMasterError(err, "room", room.Code)
}

// Room reads one room.
func (r *Repository) Room(ctx context.Context, scope authctx.TenantScope,
	roomID string) (domain.Room, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return domain.Room{}, err
	}
	id, err := uuid.Parse(roomID)
	if err != nil {
		return domain.Room{}, rpcerr.NotFound("ORG_ROOM_NOT_FOUND", "room not found")
	}
	row, err := r.queries(ctx).GetRoom(ctx,
		sqlcgen.GetRoomParams{TenantID: tenant, RoomID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Room{}, rpcerr.NotFound("ORG_ROOM_NOT_FOUND", "room not found")
	}
	if err != nil {
		return domain.Room{}, err
	}
	return roomFromRow(row), nil
}

// InsertBed records a bed.
func (r *Repository) InsertBed(ctx context.Context, scope authctx.TenantScope,
	b domain.Bed) error {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(b.ID)
	if err != nil {
		return rpcerr.Internal("ORG_BED_ID_INVALID", "bed id must be a UUID")
	}
	room, err := uuid.Parse(b.RoomID)
	if err != nil {
		return rpcerr.Invalid("ORG_BED_ROOM_INVALID", "a bed's room must be a UUID")
	}
	facility, err := uuid.Parse(b.FacilityID)
	if err != nil {
		return rpcerr.Invalid("ORG_BED_FACILITY_INVALID",
			"a bed's facility must be a UUID")
	}

	err = r.queries(ctx).InsertBed(ctx, sqlcgen.InsertBedParams{
		BedID: id, TenantID: tenant, RoomID: room, FacilityID: facility,
		Code: b.Code, DisplayName: b.DisplayName,
		Status: string(b.Status), Availability: string(b.Availability),
		UnavailableReason: b.UnavailableReason,
		CreatedAt:         timestamptz(b.CreatedAt),
		UpdatedAt:         timestamptz(b.UpdatedAt),
		Version:           b.Version,
	})
	return bedMasterError(err, "bed", b.Code)
}

// Bed reads one bed.
func (r *Repository) Bed(ctx context.Context, scope authctx.TenantScope,
	bedID string) (domain.Bed, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return domain.Bed{}, err
	}
	id, err := uuid.Parse(bedID)
	if err != nil {
		return domain.Bed{}, rpcerr.NotFound("ORG_BED_NOT_FOUND", "bed not found")
	}
	row, err := r.queries(ctx).GetBed(ctx,
		sqlcgen.GetBedParams{TenantID: tenant, BedID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Bed{}, rpcerr.NotFound("ORG_BED_NOT_FOUND", "bed not found")
	}
	if err != nil {
		return domain.Bed{}, err
	}
	return bedFromRow(row), nil
}

// UpdateBedState writes existence and availability together.
func (r *Repository) UpdateBedState(ctx context.Context,
	scope authctx.TenantScope, b domain.Bed, expectedVersion int64) error {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(b.ID)
	if err != nil {
		return rpcerr.NotFound("ORG_BED_NOT_FOUND", "bed not found")
	}

	rows, err := r.queries(ctx).UpdateBedState(ctx, sqlcgen.UpdateBedStateParams{
		TenantID: tenant, BedID: id,
		Status: string(b.Status), Availability: string(b.Availability),
		UnavailableReason: b.UnavailableReason,
		UpdatedAt:         timestamptz(b.UpdatedAt),
		ExpectedVersion:   expectedVersion,
	})
	if err != nil {
		return bedMasterError(err, "bed", b.Code)
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("ORG_BED_VERSION_CONFLICT",
			"somebody else changed this bed")
	}
	return nil
}

// Board assembles the ward's view in one read (SRS-PLT-006).
func (r *Repository) Board(ctx context.Context, scope authctx.TenantScope,
	f ports.BedBoardFilter) ([]ports.BedPlace, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := uuid.Parse(f.FacilityID)
	if err != nil {
		return nil, rpcerr.Invalid("ORG_BOARD_FACILITY_INVALID",
			"a bed board is asked for one facility")
	}
	// An empty unit means every ward. Passed as text and compared against ''
	// rather than as a NULL uuid, because a NULL comparison is never true and
	// the filter would silently return nothing.
	unit := ""
	if f.UnitID != "" {
		if _, err := uuid.Parse(f.UnitID); err != nil {
			return nil, rpcerr.Invalid("ORG_BOARD_UNIT_INVALID",
				"a ward filter must be a UUID")
		}
		unit = f.UnitID
	}

	rows, err := r.queries(ctx).BedBoard(ctx, sqlcgen.BedBoardParams{
		TenantID: tenant, FacilityID: facility,
		UnitID: unit, PageLimit: f.PageSize,
	})
	if err != nil {
		return nil, err
	}

	out := make([]ports.BedPlace, 0, len(rows))
	for _, row := range rows {
		out = append(out, ports.BedPlace{
			Bed: domain.Bed{
				ID: row.BedID.String(), TenantID: scope.TenantID(),
				RoomID: row.RoomID.String(), FacilityID: f.FacilityID,
				Code: row.BedCode, DisplayName: row.BedName,
				Status:            domain.MasterStatus(row.Status),
				Availability:      domain.BedAvailability(row.Availability),
				UnavailableReason: row.UnavailableReason,
				Version:           row.Version,
			},
			Room: domain.Room{
				ID: row.RoomID.String(), TenantID: scope.TenantID(),
				FacilityID: f.FacilityID, UnitID: row.UnitID.String(),
				Code:         row.RoomCode,
				ClassCode:    row.ClassCode,
				GenderPolicy: domain.GenderPolicy(row.GenderPolicy),
				Isolation:    domain.IsolationCapability(row.Isolation),
			},
			Class: domain.BedClass{
				TenantID: scope.TenantID(), Code: row.ClassCode,
				DisplayName: row.ClassName, ChargeCode: row.ChargeCode,
			},
		})
	}
	return out, nil
}

func classFromRow(row sqlcgen.OrganizationBedClass) domain.BedClass {
	return domain.BedClass{
		ID: row.ClassID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, DisplayName: row.DisplayName,
		ChargeCode: row.ChargeCode,
		Status:     domain.MasterStatus(row.Status),
		CreatedAt:  row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		Version: row.Version,
	}
}

func roomFromRow(row sqlcgen.OrganizationRoom) domain.Room {
	return domain.Room{
		ID: row.RoomID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID.String(), UnitID: row.UnitID.String(),
		Code: row.Code, DisplayName: row.DisplayName,
		ClassCode:    row.ClassCode,
		GenderPolicy: domain.GenderPolicy(row.GenderPolicy),
		Isolation:    domain.IsolationCapability(row.Isolation),
		Status:       domain.MasterStatus(row.Status),
		CreatedAt:    row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		Version: row.Version,
	}
}

func bedFromRow(row sqlcgen.OrganizationBed) domain.Bed {
	return domain.Bed{
		ID: row.BedID.String(), TenantID: row.TenantID.String(),
		RoomID: row.RoomID.String(), FacilityID: row.FacilityID.String(),
		Code: row.Code, DisplayName: row.DisplayName,
		Status:            domain.MasterStatus(row.Status),
		Availability:      domain.BedAvailability(row.Availability),
		UnavailableReason: row.UnavailableReason,
		CreatedAt:         row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		Version: row.Version,
	}
}

// bedMasterError maps the constraints this master relies on to answers a
// caller can act on. A duplicate code is the common one: two wards numbering
// their beds the same way is a mistake somebody has to correct, not an
// internal error.
func bedMasterError(err error, kind, code string) error {
	if err == nil {
		return nil
	}
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) && pgErr.Code == uniqueViolation {
		return rpcerr.AlreadyExists("ORG_"+kind+"_CODE_TAKEN",
			"another "+kind+" already uses the code "+code)
	}
	return err
}
