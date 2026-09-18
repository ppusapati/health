package postgres

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Patients adapts the Wave-1 patient index (SRS-EMPI).
//
// An adapter rather than a direct call: the patient belongs to SRS-EMPI, and a
// blood bank holding its own copy of who a patient is would crossmatch against
// the wrong person — which surfaces at a bedside with a unit already spiked.
type Patients struct {
	patients empiports.PatientRepository
}

// NewPatients constructs the adapter.
func NewPatients(patients empiports.PatientRepository) Patients {
	return Patients{patients: patients}
}

var _ ports.Patients = Patients{}

// Exists reports a patient the index knows.
//
// A not-found from the index is false and no error, so the caller says "no
// such patient" in its own words and a probe cannot learn from the shape of
// the refusal whether an identifier is real in another tenant.
//
// Anything else propagates. Treating a database failure as an absent patient
// would refuse a crossmatch for a patient who exists, and tell the scientist
// the wrong reason — sending them to check a registration that is fine while
// the real fault goes unreported.
func (p Patients) Exists(ctx context.Context, scope authctx.TenantScope,
	patientID string) (bool, error) {

	_, err := p.patients.GetByID(ctx, scope, patientID)
	if err == nil {
		return true, nil
	}

	var refusal *rpcerr.Error
	if errors.As(err, &refusal) && refusal.Category == rpcerr.CategoryNotFound {
		return false, nil
	}
	return false, err
}
