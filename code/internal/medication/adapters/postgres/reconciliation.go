package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Reconciliations persists medication reconciliation (SRS-MED-005).
type Reconciliations struct{ *Repository }

// NewReconciliations constructs the adapter.
func NewReconciliations(r *Repository) Reconciliations { return Reconciliations{r} }

var _ ports.ReconciliationRepository = Reconciliations{}

// Insert stores a reconciliation with its home-medication list.
func (a Reconciliations) Insert(ctx context.Context, scope authctx.TenantScope,
	r *domain.Reconciliation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(r.ID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(r.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(r.EncounterID)
	if err != nil {
		return err
	}

	q := a.queries(ctx)
	if err := q.InsertReconciliation(ctx, sqlcgen.InsertReconciliationParams{
		ReconciliationID: id, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID, Event: string(r.Event),
		StartedBy: r.StartedBy, StartedAt: timestamptz(r.StartedAt),
		UpdatedAt: timestamptz(r.UpdatedAt), Version: r.Version,
	}); err != nil {
		return err
	}

	for _, item := range r.Items {
		resulting, err := optionalUUID(item.ResultingPrescriptionID)
		if err != nil {
			return err
		}
		if err := q.InsertReconciliationItem(ctx, sqlcgen.InsertReconciliationItemParams{
			TenantID: tenantID, ReconciliationID: id, Sequence: int32(item.Sequence),
			MedicationSystem:  item.Medication.System,
			MedicationCode:    item.Medication.Code,
			MedicationDisplay: item.Medication.Display,
			DoseText:          item.DoseText, Route: item.Route,
			Source: string(item.Source), Disposition: string(item.Disposition),
			Rationale: item.Rationale, ResultingPrescriptionID: resulting,
			DecidedBy: item.DecidedBy, DecidedAt: timestamptz(item.DecidedAt),
		}); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one reconciliation with its items.
func (a Reconciliations) Get(ctx context.Context, scope authctx.TenantScope,
	reconciliationID string) (*domain.Reconciliation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(reconciliationID)
	if err != nil {
		return nil, err
	}

	row, err := a.queries(ctx).GetReconciliation(ctx, sqlcgen.GetReconciliationParams{
		TenantID: tenantID, ReconciliationID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFoundReconciliation()
		}
		return nil, err
	}
	return a.hydrateReconciliation(ctx, tenantID, row)
}

func notFoundReconciliation() error { return notFound() }

func (a Reconciliations) hydrateReconciliation(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.MedicationReconciliation) (*domain.Reconciliation, error) {

	r := &domain.Reconciliation{
		ID: row.ReconciliationID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Event:     domain.ReconciliationEvent(row.Event),
		StartedBy: row.StartedBy, StartedAt: timeOrZero(row.StartedAt),
		CompletedBy: row.CompletedBy, CompletedAt: timeOrZero(row.CompletedAt),
		UpdatedAt: timeOrZero(row.UpdatedAt), Version: row.Version,
	}

	items, err := a.queries(ctx).ListReconciliationItems(ctx,
		sqlcgen.ListReconciliationItemsParams{
			TenantID: tenantID, ReconciliationID: row.ReconciliationID,
		})
	if err != nil {
		return nil, err
	}
	for _, i := range items {
		r.Items = append(r.Items, domain.ReconciliationItem{
			Sequence: int(i.Sequence),
			Medication: domain.Coding{
				System: i.MedicationSystem, Code: i.MedicationCode,
				Display: i.MedicationDisplay,
			},
			DoseText: i.DoseText, Route: i.Route,
			Source:                  domain.HomeMedicationSource(i.Source),
			Disposition:             domain.Disposition(i.Disposition),
			Rationale:               i.Rationale,
			ResultingPrescriptionID: uuidOrEmpty(i.ResultingPrescriptionID),
			DecidedBy:               i.DecidedBy, DecidedAt: timeOrZero(i.DecidedAt),
		})
	}
	return r, nil
}

// Decide records one disposition and bumps the reconciliation's version
// together (SRS-MED-005).
func (a Reconciliations) Decide(ctx context.Context, scope authctx.TenantScope,
	r *domain.Reconciliation, item domain.ReconciliationItem,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(r.ID)
	if err != nil {
		return err
	}
	resulting, err := optionalUUID(item.ResultingPrescriptionID)
	if err != nil {
		return err
	}

	q := a.queries(ctx)
	// The reconciliation is touched first, so its version guard is what two
	// clinicians deciding at the same moment collide on. Deciding the item
	// first and touching afterwards would let both items land and only one
	// version bump survive, leaving a list that disagrees with its own version.
	affected, err := q.TouchReconciliation(ctx, sqlcgen.TouchReconciliationParams{
		UpdatedAt: timestamptz(r.UpdatedAt), Version: r.Version,
		TenantID: tenantID, ReconciliationID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}

	affected, err = q.UpdateReconciliationItem(ctx, sqlcgen.UpdateReconciliationItemParams{
		Disposition: string(item.Disposition), Rationale: item.Rationale,
		ResultingPrescriptionID: resulting,
		DecidedBy:               item.DecidedBy, DecidedAt: timestamptz(item.DecidedAt),
		TenantID: tenantID, ReconciliationID: id, Sequence: int32(item.Sequence),
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return notFound()
	}
	return nil
}

// Complete closes the pass (SRS-MED-005).
//
// The guarded UPDATE carries the "nothing left pending" precondition, so the
// acceptance criterion holds even against a caller that went round the domain,
// and two clinicians working the same list cannot complete it between each
// other's decisions.
func (a Reconciliations) Complete(ctx context.Context, scope authctx.TenantScope,
	r *domain.Reconciliation, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(r.ID)
	if err != nil {
		return err
	}

	affected, err := a.queries(ctx).CompleteReconciliation(ctx,
		sqlcgen.CompleteReconciliationParams{
			CompletedBy: r.CompletedBy, CompletedAt: timestamptz(r.CompletedAt),
			UpdatedAt: timestamptz(r.UpdatedAt), Version: r.Version,
			TenantID: tenantID, ReconciliationID: id, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// ForEncounter lists a visit's reconciliations.
func (a Reconciliations) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string, limit int32) ([]*domain.Reconciliation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := a.queries(ctx).ListReconciliationsForEncounter(ctx,
		sqlcgen.ListReconciliationsForEncounterParams{
			TenantID: tenantID, EncounterID: id, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Reconciliation, 0, len(rows))
	for _, row := range rows {
		r, err := a.hydrateReconciliation(ctx, tenantID, row)
		if err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, nil
}

// Substitutions persists substitutions (SRS-MED-011).
type Substitutions struct{ *Repository }

// NewSubstitutions constructs the adapter.
func NewSubstitutions(r *Repository) Substitutions { return Substitutions{r} }

var _ ports.SubstitutionRepository = Substitutions{}

// Insert stores a proposed substitution.
func (a Substitutions) Insert(ctx context.Context, scope authctx.TenantScope,
	s *domain.Substitution) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(s.ID)
	if err != nil {
		return err
	}
	prescriptionID, err := lookupUUID(s.PrescriptionID)
	if err != nil {
		return err
	}

	return a.queries(ctx).InsertSubstitution(ctx, sqlcgen.InsertSubstitutionParams{
		SubstitutionID: id, TenantID: tenantID, PrescriptionID: prescriptionID,
		PrescribedSystem: s.Prescribed.System, PrescribedCode: s.Prescribed.Code,
		PrescribedDisplay: s.Prescribed.Display,
		DispensedSystem:   s.Dispensed.System, DispensedCode: s.Dispensed.Code,
		DispensedDisplay: s.Dispensed.Display,
		Kind:             string(s.Kind), Status: string(s.Status), Reason: s.Reason,
		ProposedBy: s.ProposedBy, ProposedAt: timestamptz(s.ProposedAt),
	})
}

// Get reads one substitution.
func (a Substitutions) Get(ctx context.Context, scope authctx.TenantScope,
	substitutionID string) (*domain.Substitution, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(substitutionID)
	if err != nil {
		return nil, err
	}

	row, err := a.queries(ctx).GetSubstitution(ctx, sqlcgen.GetSubstitutionParams{
		TenantID: tenantID, SubstitutionID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return substitutionFromRow(row), nil
}

func substitutionFromRow(row sqlcgen.MedicationSubstitution) *domain.Substitution {
	return &domain.Substitution{
		ID: row.SubstitutionID.String(), TenantID: row.TenantID.String(),
		PrescriptionID: row.PrescriptionID.String(),
		Prescribed: domain.Coding{
			System: row.PrescribedSystem, Code: row.PrescribedCode,
			Display: row.PrescribedDisplay,
		},
		Dispensed: domain.Coding{
			System: row.DispensedSystem, Code: row.DispensedCode,
			Display: row.DispensedDisplay,
		},
		Kind:       domain.SubstitutionKind(row.Kind),
		Status:     domain.SubstitutionStatus(row.Status),
		Reason:     row.Reason,
		ProposedBy: row.ProposedBy, ProposedAt: timeOrZero(row.ProposedAt),
		AuthorizedBy: row.AuthorizedBy, AuthorizedAt: timeOrZero(row.AuthorizedAt),
		DispensedAt: timeOrZero(row.DispensedAt),
	}
}

// Update advances a substitution, guarded on the status it came from.
func (a Substitutions) Update(ctx context.Context, scope authctx.TenantScope,
	s *domain.Substitution, expectedStatus domain.SubstitutionStatus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(s.ID)
	if err != nil {
		return err
	}

	affected, err := a.queries(ctx).UpdateSubstitution(ctx, sqlcgen.UpdateSubstitutionParams{
		Status: string(s.Status), Reason: s.Reason,
		AuthorizedBy: s.AuthorizedBy, AuthorizedAt: timestamptz(s.AuthorizedAt),
		DispensedAt: timestamptz(s.DispensedAt),
		TenantID:    tenantID, SubstitutionID: id, ExpectedStatus: string(expectedStatus),
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// ForPrescription lists the substitutions against one prescription.
func (a Substitutions) ForPrescription(ctx context.Context, scope authctx.TenantScope,
	prescriptionID string) ([]*domain.Substitution, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(prescriptionID)
	if err != nil {
		return nil, err
	}

	rows, err := a.queries(ctx).ListSubstitutions(ctx, sqlcgen.ListSubstitutionsParams{
		TenantID: tenantID, PrescriptionID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]*domain.Substitution, 0, len(rows))
	for _, row := range rows {
		out = append(out, substitutionFromRow(row))
	}
	return out, nil
}
