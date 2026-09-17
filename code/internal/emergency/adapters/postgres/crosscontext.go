package postgres

import (
	"context"

	"github.com/ppusapati/health/code/internal/emergency/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Encounters adapts the Wave-1 encounter context (SRS-ENC).
//
// An adapter rather than a direct call: the department must not read the
// encounter schema, and a department holding its own copy of whether a visit is
// still open is one that records a dressing change into a discharged episode.
type Encounters struct {
	encounters encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository) Encounters {
	return Encounters{encounters: encounters}
}

var _ ports.Encounters = Encounters{}

// Writable reports whether content may still be recorded against the
// encounter, and the patient it belongs to.
//
// The patient comes back so the caller can check that the visit it is about to
// write against hangs off the same one. Not-found propagates unchanged: a
// timeline entry cannot be written into an encounter this tenant does not hold,
// and the refusal must not confirm that it exists elsewhere.
func (e Encounters) Writable(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (string, bool, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		return "", false, err
	}
	return encounter.PatientID, encounter.AcceptsClinicalContent(), nil
}
