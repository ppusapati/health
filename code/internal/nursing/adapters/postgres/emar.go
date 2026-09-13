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

// AdministrationRepo persists the medication administration record
// (SRS-NUR-007 … SRS-NUR-009, SRS-NUR-018).
type AdministrationRepo struct{ *Repository }

var _ ports.AdministrationRepository = AdministrationRepo{}

// NewAdministrations constructs the eMAR adapter.
func NewAdministrations(r *Repository) AdministrationRepo {
	return AdministrationRepo{r}
}

// doseKeyConstraint is the unique index that holds SRS-NUR-018.
const doseKeyConstraint = "nursing_administration_dose_key"

// idempotencyConstraint deduplicates a replayed PRN submission.
const idempotencyConstraint = "nursing_administration_idempotency_key"

// Insert stores a dose.
//
// The duplicate guard is the table's, not this method's. Two transcriptions of
// one paper entry can be in flight at the same moment, so a check-then-insert
// would let both through; the unique index rejects the second whichever order
// they arrive in, and this method turns that refusal into something a
// transcriber can act on.
func (r AdministrationRepo) Insert(ctx context.Context,
	scope authctx.TenantScope, a *domain.Administration) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	administrationID, err := mustUUID(a.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(a.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(a.EncounterID)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(a.OrderID)
	if err != nil {
		return err
	}

	params := sqlcgen.InsertAdministrationParams{
		AdministrationID: administrationID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID, OrderID: orderID,
		MedicationSystem:  a.Medication.System,
		MedicationVersion: a.Medication.Version,
		MedicationCode:    a.Medication.Code,
		MedicationDisplay: a.Medication.Display,
		// Scheduled and actual, both stored. Overwriting the scheduled values
		// would leave "was it late" unanswerable (SRS-NUR-009).
		ScheduledDose: a.ScheduledDose.Value, ScheduledUnit: a.ScheduledDose.Unit,
		ScheduledAt: timestamptz(a.ScheduledAt),
		GivenDose:   a.GivenDose.Value, GivenUnit: a.GivenDose.Unit,
		GivenAt: timestamptz(a.GivenAt),
		Route:   a.Route, Site: a.Site,
		Outcome: string(a.Outcome), Reason: a.Reason,
		ScanPerformed:     a.Verification.Performed,
		ScannedPatient:    a.Verification.PatientScanned,
		ScannedMedication: a.Verification.MedicationScanned,
		ScannedAt:         timestamptz(a.Verification.ScannedAt),
		IdempotencyKey:    a.IdempotencyKey,
		RecordedOffline:   a.RecordedOffline,
		AdministeredBy:    a.AdministeredBy, WitnessedBy: a.WitnessedBy,
		RecordedAt: timestamptz(a.RecordedAt),
	}
	if a.Override != nil {
		params.OverrideReason = a.Override.Reason
		params.OverrideBy = a.Override.By
		params.OverrideAt = timestamptz(a.Override.At)
		params.OverridePatientMismatch = a.Override.PatientMismatch
		params.OverrideMedicationMismatch = a.Override.MedicationMismatch
		params.OverrideNotScanned = a.Override.NotScanned
	}

	err = r.queries(ctx).InsertAdministration(ctx, params)
	switch {
	case uniqueViolation(err, doseKeyConstraint):
		return r.duplicate(ctx, scope, a)
	case uniqueViolation(err, idempotencyConstraint):
		return domain.ErrDuplicateAdministration{OrderID: a.OrderID}
	}
	return err
}

// duplicate names the record that already exists, so a transcriber checks
// rather than retrying with a changed time.
func (r AdministrationRepo) duplicate(ctx context.Context,
	scope authctx.TenantScope, a *domain.Administration) error {

	refusal := domain.ErrDuplicateAdministration{
		OrderID: a.OrderID, ScheduledAt: a.ScheduledAt,
	}
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return refusal
	}
	orderID, err := mustUUID(a.OrderID)
	if err != nil {
		return refusal
	}

	existing, err := r.queries(ctx).FindAdministrationForDose(ctx,
		sqlcgen.FindAdministrationForDoseParams{
			TenantID: tenantID, OrderID: orderID,
			ScheduledAt: timestamptz(a.ScheduledAt),
		})
	if err != nil {
		// The row is there — the insert just collided with it — so a failure
		// here is a lookup problem, not evidence that the dose is unrecorded.
		// Refuse anyway: the alternative is writing the duplicate.
		return refusal
	}
	refusal.ExistingID = existing.AdministrationID.String()
	return refusal
}

// List reads the MAR for an encounter.
func (r AdministrationRepo) List(ctx context.Context, scope authctx.TenantScope,
	encounterID, orderID string, limit int32) ([]*domain.Administration, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}
	order, err := optionalUUID(orderID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListAdministrations(ctx,
		sqlcgen.ListAdministrationsParams{
			TenantID: tenantID, EncounterID: encounter,
			OrderFilter: order, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Administration, 0, len(rows))
	for _, row := range rows {
		out = append(out, administrationFromRow(sqlcgen.NursingAdministration(row)))
	}
	return out, nil
}

// Overrides feeds the report that gets a broken scanner replaced
// (SRS-NUR-008).
func (r AdministrationRepo) Overrides(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time, limit int32) (
	[]*domain.Administration, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOverrides(ctx, sqlcgen.ListOverridesParams{
		TenantID: tenantID,
		FromTime: timestamptz(from), ToTime: timestamptz(to),
		PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Administration, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.Administration{
			ID: row.AdministrationID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			OrderID:        row.OrderID.String(),
			Medication:     domain.Coding{Display: row.MedicationDisplay},
			AdministeredBy: row.AdministeredBy,
			Override: &domain.Override{
				Reason: row.OverrideReason, By: row.OverrideBy,
				At:                 timeOrZero(row.OverrideAt),
				PatientMismatch:    row.OverridePatientMismatch,
				MedicationMismatch: row.OverrideMedicationMismatch,
				NotScanned:         row.OverrideNotScanned,
			},
		})
	}
	return out, nil
}

// SetPolicy stores a facility's administration policy.
func (r AdministrationRepo) SetPolicy(ctx context.Context,
	scope authctx.TenantScope, facilityID string, p domain.AdministrationPolicy,
	updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	facility, err := lookupUUID(facilityID)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertAdministrationPolicy(ctx,
		sqlcgen.UpsertAdministrationPolicyParams{
			TenantID: tenantID, FacilityID: facility,
			BarcodeRequired: p.BarcodeRequired, OverrideAllowed: p.OverrideAllowed,
			LateAfterSeconds: int64(p.LateAfter / time.Second),
			UpdatedBy:        updatedBy, UpdatedAt: timestamptz(now),
		})
}

// Policy reads a facility's administration policy.
//
// An absent row is the safe default rather than an error: a facility that has
// never configured one gets the barcode check, because a safety control that
// has to be switched on is a control that is off in the wards that most need
// it.
func (r AdministrationRepo) Policy(ctx context.Context,
	scope authctx.TenantScope, facilityID string) (
	domain.AdministrationPolicy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.AdministrationPolicy{}, err
	}
	facility, err := lookupUUID(facilityID)
	if err != nil {
		return domain.AdministrationPolicy{}, err
	}

	row, err := r.queries(ctx).GetAdministrationPolicy(ctx,
		sqlcgen.GetAdministrationPolicyParams{
			TenantID: tenantID, FacilityID: facility,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DefaultAdministrationPolicy(), nil
	}
	if err != nil {
		return domain.AdministrationPolicy{}, err
	}
	return domain.AdministrationPolicy{
		BarcodeRequired: row.BarcodeRequired,
		OverrideAllowed: row.OverrideAllowed,
		LateAfter:       time.Duration(row.LateAfterSeconds) * time.Second,
	}, nil
}

func administrationFromRow(row sqlcgen.NursingAdministration) *domain.Administration {
	a := &domain.Administration{
		ID: row.AdministrationID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		OrderID: row.OrderID.String(),
		Medication: domain.Coding{
			System: row.MedicationSystem, Version: row.MedicationVersion,
			Code: row.MedicationCode, Display: row.MedicationDisplay,
		},
		ScheduledDose: domain.Quantity{
			Value: row.ScheduledDose, Unit: row.ScheduledUnit,
		},
		ScheduledAt: timeOrZero(row.ScheduledAt),
		GivenDose: domain.Quantity{
			Value: row.GivenDose, Unit: row.GivenUnit,
		},
		GivenAt: timeOrZero(row.GivenAt),
		Route:   row.Route, Site: row.Site,
		Outcome: domain.AdministrationOutcome(row.Outcome), Reason: row.Reason,
		Verification: domain.Verification{
			Performed:         row.ScanPerformed,
			PatientScanned:    row.ScannedPatient,
			MedicationScanned: row.ScannedMedication,
			ScannedAt:         timeOrZero(row.ScannedAt),
		},
		IdempotencyKey:  row.IdempotencyKey,
		RecordedOffline: row.RecordedOffline,
		AdministeredBy:  row.AdministeredBy, WitnessedBy: row.WitnessedBy,
		RecordedAt: timeOrZero(row.RecordedAt), Version: row.Version,
	}
	if row.OverrideReason != "" {
		a.Override = &domain.Override{
			Reason: row.OverrideReason, By: row.OverrideBy,
			At:                 timeOrZero(row.OverrideAt),
			PatientMismatch:    row.OverridePatientMismatch,
			MedicationMismatch: row.OverrideMedicationMismatch,
			NotScanned:         row.OverrideNotScanned,
		}
	}
	return a
}
