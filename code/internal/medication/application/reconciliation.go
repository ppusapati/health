package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// StartReconciliationInput opens a reconciliation pass (SRS-MED-005).
type StartReconciliationInput struct {
	PatientID       string
	EncounterID     string
	Event           domain.ReconciliationEvent
	HomeMedications []domain.ReconciliationItem
}

// StartReconciliation records the home-medication list to be worked through
// (SRS-MED-005).
//
// Nothing is decided here. The list and the decisions are separate steps
// because they happen at separate times and often by separate people: a nurse
// takes the history on admission and a doctor decides what to continue, and a
// single call that took both would force one of them to guess the other's half.
func (s *Service) StartReconciliation(ctx context.Context,
	in StartReconciliationInput) (*domain.Reconciliation, error) {

	session, scope, err := s.authorize(ctx, PermReconcile, "reconciliation", "", true)
	if err != nil {
		return nil, err
	}

	state, err := s.requireOpenEncounter(ctx, scope, in.EncounterID, in.PatientID)
	if err != nil {
		return nil, err
	}
	patientID := in.PatientID
	if patientID == "" {
		patientID = state.PatientID
	}

	now := s.clock.Now()
	r, err := domain.NewReconciliation(s.ids.NewID(), session.TenantID, patientID,
		in.EncounterID, in.Event, in.HomeMedications, session.SubjectID, now)
	if err != nil {
		return nil, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.reconciliations.Insert(ctx, scope, r); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.reconciliation.perform", ResourceType: "reconciliation",
			ResourceID: r.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(r.Event),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return r, nil
}

// DecideInput records one disposition (SRS-MED-005).
type DecideInput struct {
	ReconciliationID string
	Sequence         int
	Disposition      domain.Disposition
	Rationale        string
	// ResultingPrescriptionID links a continued or changed medication to the
	// prescription carrying it forward, which is what makes the reconciliation
	// auditable rather than a form somebody filled in.
	ResultingPrescriptionID string
}

// Decide records what was decided about one home medication (SRS-MED-005).
func (s *Service) Decide(ctx context.Context, in DecideInput) (
	*domain.Reconciliation, error) {

	session, scope, err := s.authorize(ctx, PermReconcile, "reconciliation",
		in.ReconciliationID, true)
	if err != nil {
		return nil, err
	}

	r, err := s.reconciliations.Get(ctx, scope, in.ReconciliationID)
	if err != nil {
		return nil, err
	}

	expectedVersion := r.Version
	now := s.clock.Now()
	if err := r.Decide(in.Sequence, in.Disposition, in.Rationale,
		in.ResultingPrescriptionID, session.SubjectID, now); err != nil {
		return nil, medicationError(err)
	}

	decided, ok := itemAt(r, in.Sequence)
	if !ok {
		return nil, rpcerr.Internal("MED_RECONCILIATION_ITEM_LOST",
			"the decided medication is no longer in the list")
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.reconciliations.Decide(ctx, scope, r, decided,
			expectedVersion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.reconciliation.perform", ResourceType: "reconciliation",
			ResourceID: r.ID, Outcome: audit.OutcomeSuccess,
			Reason: decided.Medication.Display + ": " + string(decided.Disposition),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return r, nil
}

func itemAt(r *domain.Reconciliation, sequence int) (domain.ReconciliationItem, bool) {
	for _, item := range r.Items {
		if item.Sequence == sequence {
			return item, true
		}
	}
	return domain.ReconciliationItem{}, false
}

// CompleteReconciliation closes a pass (SRS-MED-005).
//
// Refused while anything is undecided, and the refusal names what. That is the
// acceptance criterion, and it is held in two places on purpose: the domain
// refuses, and the guarded UPDATE refuses again, so two clinicians working the
// same list cannot complete it between each other's decisions.
func (s *Service) CompleteReconciliation(ctx context.Context, reconciliationID string) (
	*domain.Reconciliation, error) {

	session, scope, err := s.authorize(ctx, PermReconcile, "reconciliation",
		reconciliationID, true)
	if err != nil {
		return nil, err
	}

	r, err := s.reconciliations.Get(ctx, scope, reconciliationID)
	if err != nil {
		return nil, err
	}

	expectedVersion := r.Version
	now := s.clock.Now()
	if err := r.Complete(session.SubjectID, now); err != nil {
		return nil, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.reconciliations.Complete(ctx, scope, r, expectedVersion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.reconciliation.perform", ResourceType: "reconciliation",
			ResourceID: r.ID, Outcome: audit.OutcomeSuccess, Reason: "completed",
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return r, nil
}

// Reconciliations lists a visit's passes.
func (s *Service) Reconciliations(ctx context.Context, encounterID string,
	limit int32) ([]*domain.Reconciliation, error) {

	_, scope, err := s.authorize(ctx, PermReconcile, "reconciliation", encounterID, false)
	if err != nil {
		return nil, err
	}
	return s.reconciliations.ForEncounter(ctx, scope, encounterID, clampPageSize(limit))
}

// ProposeSubstitutionInput is a pharmacist's suggested swap (SRS-MED-011).
type ProposeSubstitutionInput struct {
	PrescriptionID string
	Dispensed      domain.Coding
	Kind           domain.SubstitutionKind
	Reason         string
}

// ProposeSubstitution records a swap the pharmacy suggests (SRS-MED-011).
//
// The prescribed product is read from the prescription rather than taken from
// the caller: a substitution whose "prescribed" side the caller supplied could
// misstate what the clinician wrote, and the whole point of recording the two
// separately is that the record says which of the two people chose what.
func (s *Service) ProposeSubstitution(ctx context.Context,
	in ProposeSubstitutionInput) (*domain.Substitution, error) {

	session, scope, err := s.authorize(ctx, PermSubstitute, "substitution",
		in.PrescriptionID, true)
	if err != nil {
		return nil, err
	}

	p, err := s.prescriptions.Get(ctx, scope, in.PrescriptionID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	sub, err := domain.NewSubstitution(s.ids.NewID(), session.TenantID, p.ID,
		orderMedication(p), in.Dispensed, in.Kind, in.Reason, session.SubjectID, now)
	if err != nil {
		return nil, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.substitutions.Insert(ctx, scope, sub); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.substitution.record", ResourceType: "substitution",
			ResourceID: sub.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(sub.Kind) + ": " + sub.Reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return sub, nil
}

// AuthorizeSubstitution records who agreed to a swap (SRS-MED-011).
func (s *Service) AuthorizeSubstitution(ctx context.Context, substitutionID string) (
	*domain.Substitution, error) {

	return s.advanceSubstitution(ctx, substitutionID,
		func(sub *domain.Substitution, by string, now time.Time) error {
			return sub.Authorize(by, now)
		})
}

// RejectSubstitution records a refused proposal (SRS-MED-011).
func (s *Service) RejectSubstitution(ctx context.Context, substitutionID,
	reason string) (*domain.Substitution, error) {

	return s.advanceSubstitution(ctx, substitutionID,
		func(sub *domain.Substitution, by string, now time.Time) error {
			return sub.Reject(by, reason, now)
		})
}

// DispenseSubstitution records the product that actually went to the ward
// (SRS-MED-011).
func (s *Service) DispenseSubstitution(ctx context.Context, substitutionID string) (
	*domain.Substitution, error) {

	return s.advanceSubstitution(ctx, substitutionID,
		func(sub *domain.Substitution, _ string, now time.Time) error {
			return sub.Dispense(now)
		})
}

func (s *Service) advanceSubstitution(ctx context.Context, substitutionID string,
	apply func(*domain.Substitution, string, time.Time) error) (
	*domain.Substitution, error) {

	session, scope, err := s.authorize(ctx, PermSubstitute, "substitution",
		substitutionID, true)
	if err != nil {
		return nil, err
	}

	sub, err := s.substitutions.Get(ctx, scope, substitutionID)
	if err != nil {
		return nil, err
	}

	expectedStatus := sub.Status
	now := s.clock.Now()
	if err := apply(sub, session.SubjectID, now); err != nil {
		return nil, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.substitutions.Update(ctx, scope, sub, expectedStatus); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.substitution.record", ResourceType: "substitution",
			ResourceID: sub.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(expectedStatus) + " -> " + string(sub.Status),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return sub, nil
}

// Substitutions lists the swaps recorded against a prescription.
func (s *Service) Substitutions(ctx context.Context, prescriptionID string) (
	[]*domain.Substitution, error) {

	_, scope, err := s.authorize(ctx, PermPrescriptionRead, "substitution",
		prescriptionID, false)
	if err != nil {
		return nil, err
	}
	return s.substitutions.ForPrescription(ctx, scope, prescriptionID)
}

// Policy reads the tenant's medication configuration.
func (s *Service) Policy(ctx context.Context) (ports.Policy, error) {
	_, scope, err := s.authorize(ctx, PermPrescriptionRead, "policy", "", false)
	if err != nil {
		return ports.Policy{}, err
	}
	return s.catalogue.Policy(ctx, scope)
}
