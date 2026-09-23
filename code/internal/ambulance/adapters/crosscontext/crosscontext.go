// Package crosscontext implements the ambulance seams onto the contexts that
// own the facts (SRS-AMB-001, SRS-AMB-004, SRS-AMB-007).
//
// Adapters rather than tables. Whether the encounter a crew is handing over
// into exists belongs to the encounter context, who the patient is belongs to
// the index, and which facilities the organisation has belongs to the
// organisation context. A copy of any of them would drift the first time
// somebody corrected one — and for a handover, the correction is the one that
// decides whether the receiving doctor can find the crew's account at all.
//
// All three are read-only, and that absence is the point: the ambulance
// service cannot create an encounter, cannot register a patient and cannot
// open a facility. It reads what is there and attaches to it.
package crosscontext

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/ambulance/ports"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// absentOrFailed classifies a lookup failure.
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is, because
// the wave specification is explicit that a dependency outage must not be
// reinterpreted as a valid negative result. Swallowing one would turn "the
// encounter service is down" into "there is no such encounter", and a crew
// standing at the door with a patient would be told their reference was
// wrong.
func absentOrFailed(err error) error {
	var refused *rpcerr.Error
	if errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound {
		return nil
	}
	return err
}

// Encounters adapts the encounter context (SRS-AMB-004).
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
// Existence and nothing else. SRS-AMB-004 asks that the crew's account attach
// to the emergency encounter, not that the ambulance service read what is in
// it.
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

// Patients adapts the patient index (SRS-AMB-001).
type Patients struct {
	repo empiports.PatientRepository
}

// NewPatients constructs the adapter.
func NewPatients(repo empiports.PatientRepository) Patients {
	return Patients{repo: repo}
}

var _ ports.Patients = Patients{}

// Exists implements ports.Patients.
//
// Existence and nothing else. A dispatcher taking a call needs to know the
// identifier resolves; the name, the history and the diagnoses are the
// crew's business through the encounter, not the dispatch board's.
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

// Units adapts the organisation context's org-unit master (SRS-AMB-001,
// SRS-AMB-007).
type Units struct {
	repo orgports.OrgUnitRepository
}

// NewUnits constructs the adapter.
func NewUnits(repo orgports.OrgUnitRepository) Units {
	return Units{repo: repo}
}

var _ ports.Units = Units{}

// Exists implements ports.Units.
//
// A transfer names a sending and a receiving hospital, and both have to be
// hospitals this organisation has. A transfer booked to a facility nobody
// can find is a crew driving somewhere with a patient in the back.
func (u Units) Exists(ctx context.Context, scope authctx.TenantScope,
	unitID string) (bool, error) {

	if u.repo == nil {
		return false, nil
	}
	if _, err := u.repo.GetOrgUnit(ctx, scope, unitID); err != nil {
		return false, absentOrFailed(err)
	}
	return true, nil
}
