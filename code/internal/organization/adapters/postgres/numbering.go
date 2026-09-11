package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Numbering, calendars and labels (SRS-PLT-014, 016, 017).

// EnsureSequence creates a counter if it does not exist.
//
// ON CONFLICT DO NOTHING rather than an upsert: an upsert would reset a live
// counter's next_value to the configured start, and re-issuing an MRN that is
// already printed on a wristband is a patient-safety event, not a data
// problem. Changing a live sequence's start is deliberately not expressible
// here.
func (r *Repository) EnsureSequence(ctx context.Context, scope authctx.TenantScope, s domain.NumberSequence) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Internal("ORG_SEQUENCE_ID_INVALID", "sequence_id must be a UUID").WithCause(err)
	}
	facility, err := optionalUUID(s.FacilityID)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertNumberSequence(ctx, sqlcgen.UpsertNumberSequenceParams{
		SequenceID: id, TenantID: tenant, FacilityID: facility,
		Scope: string(s.Scope), Prefix: s.Prefix, PadWidth: s.PadWidth,
		NextValue: s.NextValue, PeriodKey: s.PeriodKey,
		CreatedAt: timestamptz(s.CreatedAt), UpdatedAt: timestamptz(s.UpdatedAt),
	})
}

// IssueNumber allocates the next document number.
//
// Atomicity is the statement's, not this function's: UPDATE ... RETURNING
// takes a row lock, so concurrent callers serialise and each receives a
// distinct value. Because it is an ordinary transactional write, a caller
// whose transaction rolls back returns its number rather than burning it —
// which a PostgreSQL SEQUENCE would not do, and which an invoice number a tax
// authority expects to be gapless requires.
func (r *Repository) IssueNumber(ctx context.Context, scope authctx.TenantScope,
	numberScope domain.NumberScope, facilityID, periodKey string, now time.Time) (string, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return "", err
	}

	var issued int64
	var prefix string
	var padWidth int32

	if facilityID == "" {
		row, err := r.queries(ctx).IssueTenantNumber(ctx, sqlcgen.IssueTenantNumberParams{
			Now: timestamptz(now), TenantID: tenant,
			Scope: string(numberScope), PeriodKey: periodKey,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			return "", sequenceNotConfigured(numberScope, periodKey)
		}
		if err != nil {
			return "", err
		}
		issued, prefix, padWidth = row.Issued, row.Prefix, row.PadWidth
	} else {
		facility, err := optionalUUID(facilityID)
		if err != nil {
			return "", err
		}
		row, err := r.queries(ctx).IssueFacilityNumber(ctx, sqlcgen.IssueFacilityNumberParams{
			Now: timestamptz(now), TenantID: tenant, FacilityID: facility,
			Scope: string(numberScope), PeriodKey: periodKey,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			return "", sequenceNotConfigured(numberScope, periodKey)
		}
		if err != nil {
			return "", err
		}
		issued, prefix, padWidth = row.Issued, row.Prefix, row.PadWidth
	}

	return domain.Format(prefix, padWidth, issued), nil
}

// sequenceNotConfigured is FAILED_PRECONDITION rather than NOT_FOUND: the
// caller asked for a number and the tenant has not been set up to give one,
// which an administrator fixes. NOT_FOUND would send them looking for a
// missing record instead.
func sequenceNotConfigured(scope domain.NumberScope, periodKey string) error {
	message := "no " + string(scope) + " sequence is configured for this tenant"
	if periodKey != "" {
		message += " and period " + periodKey
	}
	return rpcerr.FailedPrecondition("ORG_SEQUENCE_NOT_CONFIGURED", message)
}

// InsertCalendarEntry records a holiday, closure or special opening.
func (r *Repository) InsertCalendarEntry(ctx context.Context, scope authctx.TenantScope, e domain.CalendarEntry) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	entryID, err := uuid.Parse(e.ID)
	if err != nil {
		return rpcerr.Internal("ORG_CALENDAR_ID_INVALID", "entry_id must be a UUID").WithCause(err)
	}
	facility, err := uuid.Parse(e.FacilityID)
	if err != nil {
		return rpcerr.Internal("ORG_FACILITY_ID_INVALID", "facility_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).InsertCalendarEntry(ctx, sqlcgen.InsertCalendarEntryParams{
		EntryID: entryID, TenantID: tenant, FacilityID: facility,
		EntryType: string(e.Type), StartsOn: dateOf(e.StartsOn), EndsOn: dateOf(e.EndsOn),
		Label: e.Label, OverridePermitted: e.OverridePermitted,
		CreatedAt: timestamptz(e.CreatedAt), UpdatedAt: timestamptz(e.UpdatedAt),
	})
}

// CalendarEntriesOn returns every entry covering a date.
//
// Every entry, not the first: a public holiday and a planned closure can
// overlap and differ on whether an override is permitted, and a special
// opening within a closure period is the case the whole type exists for.
func (r *Repository) CalendarEntriesOn(ctx context.Context, scope authctx.TenantScope,
	facilityID string, date time.Time) ([]domain.CalendarEntry, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := uuid.Parse(facilityID)
	if err != nil {
		return nil, rpcerr.NotFound("ORG_FACILITY_NOT_FOUND", "facility not found")
	}

	rows, err := r.queries(ctx).ListCalendarEntriesOn(ctx, sqlcgen.ListCalendarEntriesOnParams{
		TenantID: tenant, FacilityID: facility, OnDate: dateOf(date),
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.CalendarEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.CalendarEntry{
			ID: row.EntryID.String(), TenantID: row.TenantID.String(),
			FacilityID: row.FacilityID.String(), Type: domain.CalendarEntryType(row.EntryType),
			StartsOn: row.StartsOn.Time, EndsOn: row.EndsOn.Time,
			Label: row.Label, OverridePermitted: row.OverridePermitted,
			CreatedAt: row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		})
	}
	return out, nil
}

// PutLabel writes or replaces a locale's rendering of a code.
func (r *Repository) PutLabel(ctx context.Context, scope authctx.TenantScope, l domain.DisplayLabel) error {
	tenant, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(l.ID)
	if err != nil {
		return rpcerr.Internal("ORG_LABEL_ID_INVALID", "label_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).UpsertDisplayLabel(ctx, sqlcgen.UpsertDisplayLabelParams{
		LabelID: id, TenantID: tenant, CodeSystem: l.CodeSystem, Code: l.Code,
		Locale: l.Locale, Display: l.Display, ShortDisplay: l.ShortDisplay,
		CreatedAt: timestamptz(l.CreatedAt), UpdatedAt: timestamptz(l.UpdatedAt),
	})
}

// LabelsFor returns every locale's rendering of a code, so the caller can
// apply its own fallback chain without a query per candidate locale.
func (r *Repository) LabelsFor(ctx context.Context, scope authctx.TenantScope,
	codeSystem, code string) ([]domain.DisplayLabel, error) {

	tenant, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListDisplayLabels(ctx, sqlcgen.ListDisplayLabelsParams{
		TenantID: tenant, CodeSystem: codeSystem, Code: code,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.DisplayLabel, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.DisplayLabel{
			ID: row.LabelID.String(), TenantID: row.TenantID.String(),
			CodeSystem: row.CodeSystem, Code: row.Code, Locale: row.Locale,
			Display: row.Display, ShortDisplay: row.ShortDisplay,
			CreatedAt: row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		})
	}
	return out, nil
}
