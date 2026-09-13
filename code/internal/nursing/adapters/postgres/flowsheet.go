package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// FlowsheetRepo persists charted observations and fluid volumes
// (SRS-NUR-003, SRS-NUR-004).
type FlowsheetRepo struct{ *Repository }

var _ ports.FlowsheetRepository = FlowsheetRepo{}

// NewFlowsheet constructs the flowsheet adapter.
func NewFlowsheet(r *Repository) FlowsheetRepo { return FlowsheetRepo{r} }

// InsertEntry charts an observation.
func (r FlowsheetRepo) InsertEntry(ctx context.Context, scope authctx.TenantScope,
	e *domain.FlowsheetEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	entryID, err := mustUUID(e.ID)
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

	return r.queries(ctx).InsertFlowsheetEntry(ctx, sqlcgen.InsertFlowsheetEntryParams{
		EntryID: entryID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		CodeSystem: e.Code.System, CodeVersion: e.Code.Version,
		Code: e.Code.Code, CodeDisplay: e.Code.Display,
		ValueNumber: optionalFloat(e.Value.Value, e.Value.Value != 0),
		ValueUnit:   e.Value.Unit, ValueText: e.TextValue,
		CodedSystem: e.CodedValue.System, CodedCode: e.CodedValue.Code,
		CodedDisplay: e.CodedValue.Display,
		// Both times, always. The chart is read by the first and the audit by
		// the second (SRS-NUR-003).
		ObservedAt: timestamptz(e.ObservedAt), RecordedAt: timestamptz(e.RecordedAt),
		Source: string(e.Source), DeviceID: e.DeviceID,
		RecordedBy: e.RecordedBy, LateEntryReason: e.LateEntryReason,
	})
}

// SupersedeEntry marks a charted observation replaced.
func (r FlowsheetRepo) SupersedeEntry(ctx context.Context,
	scope authctx.TenantScope, entryID, supersededByID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(entryID)
	if err != nil {
		return err
	}
	by, err := optionalUUID(supersededByID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).SupersedeFlowsheetEntry(ctx,
		sqlcgen.SupersedeFlowsheetEntryParams{
			TenantID: tenantID, EntryID: id, SupersededByID: by,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// ListEntries reads a chart window.
func (r FlowsheetRepo) ListEntries(ctx context.Context,
	scope authctx.TenantScope, q ports.FlowsheetQuery) (
	[]*domain.FlowsheetEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounterID, err := lookupUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListFlowsheetEntries(ctx,
		sqlcgen.ListFlowsheetEntriesParams{
			TenantID: tenantID, EncounterID: encounterID,
			CodeFilter:   q.Code,
			ObservedFrom: timestamptz(q.ObservedFrom),
			ObservedTo:   timestamptz(q.ObservedTo),
			PageLimit:    q.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.FlowsheetEntry, 0, len(rows))
	for _, row := range rows {
		entry := &domain.FlowsheetEntry{
			ID: row.EntryID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			Code: domain.Coding{
				System: row.CodeSystem, Version: row.CodeVersion,
				Code: row.Code, Display: row.CodeDisplay,
			},
			Value:     domain.Quantity{Unit: row.ValueUnit},
			TextValue: row.ValueText,
			CodedValue: domain.Coding{
				System: row.CodedSystem, Code: row.CodedCode,
				Display: row.CodedDisplay,
			},
			ObservedAt: timeOrZero(row.ObservedAt),
			RecordedAt: timeOrZero(row.RecordedAt),
			Source:     domain.EntrySource(row.Source), DeviceID: row.DeviceID,
			RecordedBy: row.RecordedBy, LateEntryReason: row.LateEntryReason,
			SupersededByID: uuidOrEmpty(row.SupersededByID),
			Version:        row.Version,
		}
		if row.ValueNumber != nil {
			entry.Value.Value = *row.ValueNumber
		}
		out = append(out, entry)
	}
	return out, nil
}

// InsertFluid records intake or output.
func (r FlowsheetRepo) InsertFluid(ctx context.Context,
	scope authctx.TenantScope, f *domain.FluidEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	fluidID, err := mustUUID(f.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(f.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(f.EncounterID)
	if err != nil {
		return err
	}
	supersedes, err := optionalUUID(f.SupersedesID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertFluidEntry(ctx, sqlcgen.InsertFluidEntryParams{
		FluidID: fluidID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Direction: string(f.Direction), Category: f.Category,
		VolumeMl:   f.VolumeML,
		ObservedAt: timestamptz(f.ObservedAt),
		RecordedAt: timestamptz(f.RecordedAt),
		RecordedBy: f.RecordedBy,
		// The amendment trail: the correction points back at what it replaced,
		// and the original stays readable (SRS-NUR-004).
		SupersedesID: supersedes, AmendmentReason: f.AmendmentReason,
	})
}

// GetFluid reads one volume.
func (r FlowsheetRepo) GetFluid(ctx context.Context, scope authctx.TenantScope,
	fluidID string) (*domain.FluidEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(fluidID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetFluidEntry(ctx, sqlcgen.GetFluidEntryParams{
		TenantID: tenantID, FluidID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return fluidFromRow(sqlcgen.NursingFluidEntry(row)), nil
}

// SupersedeFluid marks a volume corrected.
func (r FlowsheetRepo) SupersedeFluid(ctx context.Context,
	scope authctx.TenantScope, fluidID, supersededByID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(fluidID)
	if err != nil {
		return err
	}
	by, err := optionalUUID(supersededByID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).SupersedeFluidEntry(ctx,
		sqlcgen.SupersedeFluidEntryParams{
			TenantID: tenantID, FluidID: id, SupersededByID: by,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// VoidFluid retires a volume with no replacement.
func (r FlowsheetRepo) VoidFluid(ctx context.Context, scope authctx.TenantScope,
	fluidID, reason string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(fluidID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).VoidFluidEntry(ctx, sqlcgen.VoidFluidEntryParams{
		TenantID: tenantID, FluidID: id,
		VoidedReason: reason, RecordedAt: timestamptz(now),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// ListFluid reads a fluid window.
func (r FlowsheetRepo) ListFluid(ctx context.Context, scope authctx.TenantScope,
	q ports.FluidQuery) ([]*domain.FluidEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounterID, err := lookupUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListFluidEntries(ctx,
		sqlcgen.ListFluidEntriesParams{
			TenantID: tenantID, EncounterID: encounterID,
			ObservedFrom:      timestamptz(q.ObservedFrom),
			ObservedTo:        timestamptz(q.ObservedTo),
			IncludeSuperseded: q.IncludeSuperseded,
			PageLimit:         q.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.FluidEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, fluidFromRow(sqlcgen.NursingFluidEntry(row)))
	}
	return out, nil
}

func fluidFromRow(row sqlcgen.NursingFluidEntry) *domain.FluidEntry {
	return &domain.FluidEntry{
		ID: row.FluidID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Direction: domain.FluidDirection(row.Direction), Category: row.Category,
		VolumeML:        row.VolumeMl,
		ObservedAt:      timeOrZero(row.ObservedAt),
		RecordedAt:      timeOrZero(row.RecordedAt),
		RecordedBy:      row.RecordedBy,
		SupersededByID:  uuidOrEmpty(row.SupersededByID),
		SupersedesID:    uuidOrEmpty(row.SupersedesID),
		AmendmentReason: row.AmendmentReason,
		VoidedReason:    row.VoidedReason,
		Version:         row.Version,
	}
}
