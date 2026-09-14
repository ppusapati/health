package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The eMAR seam (SRS-NUR-007, SRS-MED-007).
//
// These two methods are what the nursing context's MedicationOrders port is
// implemented against. They take a verified TenantScope rather than reading a
// session from the context, because the caller is the eMAR inside its own use
// case: that use case has already authorized the nurse for the drug round, and
// a second permission check here would ask a nurse to hold a prescribing
// context's read permission in order to give a drug they are already entitled
// to give.
//
// That is a deliberate narrowing rather than a hole. Nothing here writes, the
// tenant scope is still unforgeable (FIT-03), and the projection the eMAR
// receives carries no indication, no safety findings and no prescriber
// reasoning — so what a nurse can reach through this seam is what they need to
// give the drug and nothing more.

// DueFor expands a visit's eligible prescriptions into the doses due in a
// window.
func (s *Service) DueFor(ctx context.Context, scope authctx.TenantScope,
	encounterID string, from, to time.Time) ([]domain.DueDose, error) {

	return s.dueDoses(ctx, scope, encounterID, from, to)
}

// Prescription reads one prescription by its order identifier, falling back to
// its own.
//
// The order identifier first, because that is what the eMAR holds: an
// administration is recorded against the order a ward was told about, and the
// prescription identifier is this context's own business. The fallback exists
// for callers inside this context that hold the prescription identifier
// already.
//
// A missing prescription comes back as "not found" rather than as an error,
// because the caller's right answer is to leave the dose off the round rather
// than to fail the whole drug round: a worklist that refuses to render because
// one order has been retracted is a worklist a ward stops using.
func (s *Service) Prescription(ctx context.Context, scope authctx.TenantScope,
	prescriptionOrOrderID string) (*domain.Prescription, bool, error) {

	p, err := s.prescriptions.GetByOrder(ctx, scope, prescriptionOrOrderID)
	if err == nil {
		return p, true, nil
	}
	if !isNotFound(err) {
		return nil, false, err
	}

	p, err = s.prescriptions.Get(ctx, scope, prescriptionOrOrderID)
	if err != nil {
		if isNotFound(err) {
			return nil, false, nil
		}
		return nil, false, err
	}
	return p, true, nil
}

func isNotFound(err error) bool {
	var rpcErr *rpcerr.Error
	if !errors.As(err, &rpcErr) {
		return false
	}
	return rpcErr.Category == rpcerr.CategoryNotFound
}
