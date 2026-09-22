// Package crosscontext implements the housekeeping seams onto the contexts
// that own the facts (SRS-HKP-003, SRS-HKP-006).
//
// Adapters rather than tables here. Whether a patient has left belongs to the
// encounter context, and the incident a spill belongs to belongs to quality.
// A copy of either would drift the first time somebody corrected one — and
// for a discharge, the correction is the one that decides whether a bed is
// about to be taken out of service with somebody in it.
//
// Both are read-only, and that absence is the point: housekeeping cannot
// close an encounter and cannot raise an incident. It reads what happened and
// cleans up afterwards.
package crosscontext

import (
	"context"
	"errors"

	encounterdomain "github.com/ppusapati/health/code/internal/encounter/domain"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	qualityports "github.com/ppusapati/health/code/internal/quality/ports"
)

// Encounters adapts the encounter context (SRS-HKP-003).
type Encounters struct {
	repo encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(repo encounterports.EncounterRepository) Encounters {
	return Encounters{repo: repo}
}

var _ ports.Encounters = Encounters{}

// Describe implements ports.Encounters.
//
// The projection carries an identifier, a facility, a ward and whether the
// patient has left. No reason for the visit, no diagnosis, no name: a
// housekeeper's system has no business reading why somebody was in the bed it
// is about to clean.
func (e Encounters) Describe(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterFacts, bool, error) {

	if e.repo == nil {
		return ports.EncounterFacts{}, false, nil
	}
	found, err := e.repo.Get(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterFacts{}, false, err
	}
	if found == nil {
		return ports.EncounterFacts{}, false, nil
	}
	return ports.EncounterFacts{
		PatientID:  found.PatientID,
		FacilityID: found.FacilityID,
		OrgUnitID:  found.OrgUnitID,
		// Ended on the clinical time rather than on the status, because the
		// bed is free when the patient leaves and not when somebody
		// remembers to close the record. A cancelled encounter reads as not
		// ended, which is right: the patient never arrived, so there is no
		// bed to hold and no terminal clean to raise against it.
		Ended:   !found.EndedAt.IsZero() || closed(found),
		EndedAt: found.EndedAt,
	}, true, nil
}

func closed(encounter *encounterdomain.Encounter) bool {
	return !encounter.ClosedAt.IsZero()
}

// Incidents adapts the quality context's incident register (SRS-HKP-006).
type Incidents struct {
	repo qualityports.IncidentRepository
}

// NewIncidents constructs the adapter.
func NewIncidents(repo qualityports.IncidentRepository) Incidents {
	return Incidents{repo: repo}
}

var _ ports.Incidents = Incidents{}

// Exists implements ports.Incidents.
//
// Existence and nothing else. SRS-HKP-006 asks that the link be retained, not
// that the housekeeping worklist show what the incident says: a spill
// incident's narrative is about a patient, and a cleaner's screen is read in
// a corridor.
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is, because
// the wave specification is explicit that a dependency outage must not be
// reinterpreted as a valid negative result. Swallowing one here would turn
// "quality is down" into "that incident does not exist", and the cleaner
// would be told their reference was wrong.
func (i Incidents) Exists(ctx context.Context, scope authctx.TenantScope,
	ref string) (bool, error) {

	if i.repo == nil {
		return false, nil
	}
	if _, err := i.repo.Incident(ctx, scope, ref); err != nil {
		var refused *rpcerr.Error
		if errors.As(err, &refused) &&
			refused.Category == rpcerr.CategoryNotFound {
			return false, nil
		}
		return false, err
	}
	return true, nil
}
