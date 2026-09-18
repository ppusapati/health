package postgres

import (
	"context"

	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// Encounters adapts the Wave-1 encounter context (SRS-ENC).
//
// An adapter rather than a direct call: the theatre must not read the
// encounter schema, and a theatre holding its own copy of whether an admission
// is still open is one that books a case against a discharged patient.
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
func (e Encounters) Writable(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (string, bool, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		return "", false, err
	}
	return encounter.PatientID, encounter.AcceptsClinicalContent(), nil
}

// LateralProcedures answers whether a procedure code has sides.
//
// Configured rather than looked up, for now. Whether a procedure has
// laterality is a fact about the code system, which a terminology service
// owns; until this deployment has one, the set is a list a hospital maintains
// with its coding department — which is who would maintain it anyway, and is
// visible in configuration rather than buried in a default.
type LateralProcedures struct {
	codes map[string]bool
}

// NewLateralProcedures constructs the adapter from a configured list.
func NewLateralProcedures(codes []string) LateralProcedures {
	set := make(map[string]bool, len(codes))
	for _, code := range codes {
		set[code] = true
	}
	return LateralProcedures{codes: set}
}

var _ ports.Procedures = LateralProcedures{}

// SideRequired reports whether a procedure has laterality.
//
// A code the list does not mention returns false and no error. An unknown code
// is the coding department's problem, and refusing to book the patient is not
// the fix — the checklist's site-marking gate still stands, and it is
// unwaivable.
func (p LateralProcedures) SideRequired(ctx context.Context,
	scope authctx.TenantScope, code string) (bool, error) {

	return p.codes[code], nil
}
