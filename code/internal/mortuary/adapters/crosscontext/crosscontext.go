// Package crosscontext implements the mortuary seams onto the contexts that
// own the facts (SRS-MORT-001).
//
// Adapters rather than tables. Which deaths this hospital recorded belongs to
// the encounter context and who the patient is belongs to the index, and a
// copy of either here would drift the first time somebody corrected one. For
// a mortuary case the correction that matters is the one that changes which
// person a body is recorded as being.
//
// Both are read-only, and that absence is the point: the mortuary cannot
// create an encounter and cannot register a patient. It records what arrived
// and links it to what is already there.
package crosscontext

import (
	"context"
	"errors"

	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// absentOrFailed classifies a lookup failure.
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is, because
// the wave specification is explicit that a dependency outage must not be
// reinterpreted as a valid negative result. Swallowing one would turn "the
// encounter service is down" into "there is no such death", and a body that
// arrived from a ward would be refused at the mortuary door.
func absentOrFailed(err error) error {
	var refused *rpcerr.Error
	if errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound {
		return nil
	}
	return err
}

// Encounters adapts the encounter context (SRS-MORT-001).
type Encounters struct {
	repo encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(repo encounterports.EncounterRepository) Encounters {
	return Encounters{repo: repo}
}

var _ ports.Encounters = Encounters{}

// Exists implements ports.Encounters.
//
// Existence and nothing else. SRS-MORT-001 asks that the case be linked or
// clearly external; what the encounter says happened is the clinical record's
// business, not the mortuary register's.
func (e Encounters) Exists(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (bool, error) {

	if e.repo == nil {
		return false, nil
	}
	found, err := e.repo.Get(ctx, scope, encounterID)
	if err != nil {
		return false, absentOrFailed(err)
	}
	return found != nil, nil
}

// Patients adapts the patient index (SRS-MORT-001).
type Patients struct {
	repo empiports.PatientRepository
}

// NewPatients constructs the adapter.
func NewPatients(repo empiports.PatientRepository) Patients {
	return Patients{repo: repo}
}

var _ ports.Patients = Patients{}

// Exists implements ports.Patients.
func (p Patients) Exists(ctx context.Context, scope authctx.TenantScope,
	patientID string) (bool, error) {

	if p.repo == nil {
		return false, nil
	}
	found, err := p.repo.GetByID(ctx, scope, patientID)
	if err != nil {
		return false, absentOrFailed(err)
	}
	return found != nil, nil
}
