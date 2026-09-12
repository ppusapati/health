package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Patient photographs and emergency registration (SRS-EMPI-010, SRS-EMPI-015).

// PhotoRepo implements the photograph repository port.
type PhotoRepo struct{ *Repository }

var _ ports.PhotoRepository = PhotoRepo{}

// Insert stores a photograph record.
func (r PhotoRepo) Insert(ctx context.Context, scope authctx.TenantScope, p domain.Photo) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	photoID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_PHOTO_ID_INVALID", "photo_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).InsertPatientPhoto(ctx, sqlcgen.InsertPatientPhotoParams{
		PhotoID: photoID, TenantID: tenantID, PatientID: patientID,
		StorageKey: p.StorageKey, ContentType: p.ContentType,
		ByteSize: p.ByteSize, Digest: p.Digest,
		ConsentGivenBy: p.Consent.GivenBy, ConsentOnBehalf: p.Consent.OnBehalf,
		ConsentPurpose: p.Consent.Purpose, ConsentGivenAt: timestamptz(p.Consent.GivenAt),
		ConsentRecordedBy: p.Consent.RecordedBy,
		CapturedAt:        timestamptz(p.CapturedAt), CapturedBy: p.CapturedBy,
	})
}

// Current returns the photograph a screen should show.
func (r PhotoRepo) Current(ctx context.Context, scope authctx.TenantScope,
	patientID string) (domain.Photo, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Photo{}, false, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return domain.Photo{}, false, notFound()
	}

	row, err := r.queries(ctx).GetCurrentPatientPhoto(ctx, sqlcgen.GetCurrentPatientPhotoParams{
		TenantID: tenantID, PatientID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		// No photograph is an ordinary state, not an error: most patients have
		// none, and a caller rendering a banner should not have to distinguish
		// "absent" from "failed".
		return domain.Photo{}, false, nil
	}
	if err != nil {
		return domain.Photo{}, false, err
	}
	return photoFromRow(sqlcgen.EmpiPatientPhoto(row)), true, nil
}

// Get reads one photograph by its own id.
func (r PhotoRepo) Get(ctx context.Context, scope authctx.TenantScope,
	photoID string) (domain.Photo, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Photo{}, err
	}
	id, err := uuid.Parse(photoID)
	if err != nil {
		return domain.Photo{}, notFound()
	}

	row, err := r.queries(ctx).GetPatientPhoto(ctx, sqlcgen.GetPatientPhotoParams{
		TenantID: tenantID, PhotoID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Photo{}, notFound()
	}
	if err != nil {
		return domain.Photo{}, err
	}
	return photoFromRow(sqlcgen.EmpiPatientPhoto(row)), nil
}

// Withdraw marks consent withdrawn, keeping the row.
func (r PhotoRepo) Withdraw(ctx context.Context, scope authctx.TenantScope, p domain.Photo) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	if p.WithdrawnAt == nil {
		return rpcerr.Internal("EMPI_PHOTO_NOT_WITHDRAWN",
			"the photograph was not marked withdrawn before being written back")
	}

	rows, err := r.queries(ctx).WithdrawPatientPhoto(ctx, sqlcgen.WithdrawPatientPhotoParams{
		TenantID: tenantID, PhotoID: id,
		WithdrawnAt: timestamptz(*p.WithdrawnAt), WithdrawnReason: p.WithdrawnReason,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// The statement is guarded on withdrawn_at IS NULL, so no rows means
		// somebody withdrew it first. Reporting that matters: this caller's
		// reason was not the one recorded.
		return rpcerr.FailedPrecondition("EMPI_PHOTO_ALREADY_WITHDRAWN",
			"consent for this photograph was already withdrawn")
	}
	return nil
}

func photoFromRow(row sqlcgen.EmpiPatientPhoto) domain.Photo {
	p := domain.Photo{
		ID: row.PhotoID.String(), PatientID: row.PatientID.String(),
		StorageKey: row.StorageKey, ContentType: row.ContentType,
		ByteSize: row.ByteSize, Digest: row.Digest,
		Consent: domain.PhotoConsent{
			GivenBy: row.ConsentGivenBy, OnBehalf: row.ConsentOnBehalf,
			Purpose: row.ConsentPurpose, GivenAt: row.ConsentGivenAt.Time.UTC(),
			RecordedBy: row.ConsentRecordedBy,
		},
		CapturedAt: row.CapturedAt.Time.UTC(), CapturedBy: row.CapturedBy,
		WithdrawnReason: row.WithdrawnReason,
	}
	if row.WithdrawnAt.Valid {
		at := row.WithdrawnAt.Time.UTC()
		p.WithdrawnAt = &at
	}
	return p
}

// UnidentifiedRepo serves the emergency-registration worklist (SRS-EMPI-015).
type UnidentifiedRepo struct{ *Repository }

var _ ports.UnidentifiedRepository = UnidentifiedRepo{}

// MarkIdentified records that real demographics replaced a designation.
func (r UnidentifiedRepo) MarkIdentified(ctx context.Context, scope authctx.TenantScope,
	patientID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).MarkPatientIdentified(ctx, sqlcgen.MarkPatientIdentifiedParams{
		TenantID: tenantID, PatientID: id, IdentifiedAt: timestamptz(at),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Guarded on being unidentified and not already identified, so no rows
		// means one of those was untrue — and identifying an already-identified
		// patient would move the moment that ties the emergency chart to this
		// one.
		return rpcerr.FailedPrecondition("EMPI_NOT_UNIDENTIFIED",
			"this patient was not awaiting identification")
	}
	return nil
}

// ListUnidentified returns who is still unknown.
func (r UnidentifiedRepo) ListUnidentified(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]*domain.Patient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListUnidentifiedPatients(ctx,
		sqlcgen.ListUnidentifiedPatientsParams{TenantID: tenantID, PageLimit: limit})
	if err != nil {
		return nil, err
	}
	return patientsFromRows(rows)
}
