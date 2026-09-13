package postgres

import (
	"context"
	"time"

	clinicaldomain "github.com/ppusapati/health/code/internal/clinical/domain"
	clinicalports "github.com/ppusapati/health/code/internal/clinical/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Seams onto the contexts the nursing record depends on.
//
// Adapters rather than shared tables. Whether a visit still accepts content is
// the encounter context's fact and whether a consent covers photography is the
// clinical context's; a copy of either here would be a second answer that
// drifts.

// Encounters adapts the encounter context (SRS-ENC).
type Encounters struct {
	encounters encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository) Encounters {
	return Encounters{encounters: encounters}
}

var _ ports.Encounters = Encounters{}

// Check reports whether an encounter is open and which patient it belongs to.
//
// The patient comes back so the caller can check the record it is about to
// write lands on the same one. A set of observations filed against the right
// encounter but the wrong patient is the wrong-patient error every other
// control in the nursing context exists to prevent.
func (e Encounters) Check(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterState, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		// Not-found propagates: nothing can be written into an encounter this
		// tenant does not hold, and the refusal must not confirm it exists
		// elsewhere.
		return ports.EncounterState{}, err
	}
	return ports.EncounterState{
		PatientID: encounter.PatientID, FacilityID: encounter.FacilityID,
		Open: encounter.AcceptsClinicalContent(),
	}, nil
}

// Consents adapts the clinical context's consent record (SRS-NUR-012).
type Consents struct {
	governance clinicalports.GovernanceRepository
	clock      func() time.Time
}

// NewConsents constructs the adapter.
func NewConsents(governance clinicalports.GovernanceRepository,
	now func() time.Time) Consents {

	if now == nil {
		now = time.Now
	}
	return Consents{governance: governance, clock: now}
}

var _ ports.Consents = Consents{}

// CoversPhotography reports whether a consent permits clinical photography
// right now (SRS-NUR-012).
//
// Evaluated rather than looked up, because a consent that was given and later
// withdrawn is still a row. The clinical context's ConsentSet.Permits applies
// the status and the validity window, which is exactly the check a boolean
// column on the image would have skipped.
//
// The consent identifier is checked as well as the kind: without it, any
// photography consent on the patient's record would cover any photograph,
// including one taken under a consent for something else.
func (c Consents) CoversPhotography(ctx context.Context,
	scope authctx.TenantScope, consentID, patientID string) (bool, error) {

	if consentID == "" || patientID == "" {
		return false, nil
	}

	set, err := c.governance.Consents(ctx, scope, patientID,
		clinicaldomain.ConsentPhotography, 100)
	if err != nil {
		// A consent lookup that failed is not a consent. Refusing is the safe
		// direction: an unconsented photograph of a patient cannot be unsent.
		return false, err
	}

	now := c.clock()
	for _, consent := range set {
		if consent.ID != consentID {
			continue
		}
		return consent.Permits(now), nil
	}
	return false, nil
}
