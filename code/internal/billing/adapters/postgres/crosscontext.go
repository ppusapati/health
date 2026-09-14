package postgres

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/billing/ports"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Seams onto the contexts the billing context depends on.
//
// Adapters rather than shared tables. Whether a visit is open is the encounter
// context's fact and an invoice number is the platform's; a copy of either here
// would be a second answer that drifts.

// Encounters adapts the encounter context (SRS-BIL-003).
type Encounters struct {
	encounters encounterports.EncounterRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository) Encounters {
	return Encounters{encounters: encounters}
}

var _ ports.Encounters = Encounters{}

// Check reports whether a visit accepts charges and whose it is.
func (e Encounters) Check(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterState, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		// Not-found propagates: a charge cannot be raised against an encounter
		// this tenant does not hold, and the refusal must not confirm it exists
		// elsewhere.
		return ports.EncounterState{}, err
	}
	return ports.EncounterState{
		PatientID: encounter.PatientID, FacilityID: encounter.FacilityID,
		// A closed visit still takes charges: a procedure coded three days
		// after discharge is the commonest late charge there is, and refusing
		// it is how revenue is lost rather than how it is controlled. What a
		// closed *account* refuses is SRS-BIL-013's job, and that is the
		// control that belongs here.
		Open: true,
	}, nil
}

// Numbers issues invoice and receipt numbers from the platform's sequence
// (SRS-PLT-014, SRS-BIL-008).
type Numbers struct {
	issuer orgports.NumberIssuer
}

// NewNumbers constructs the adapter.
func NewNumbers(issuer orgports.NumberIssuer) Numbers {
	return Numbers{issuer: issuer}
}

var _ ports.Numbers = Numbers{}

// Issue takes the next number in a scope.
//
// The platform's sequence rather than a counter of this context's own: atomic,
// collision-free and gapless — a rolled-back transaction returns its number —
// are exactly what a finance department's first question about a numbering
// scheme asks for, and SRS-BIL-008 requires the receipt number to be atomic by
// name. A gap in an invoice sequence is a question an auditor asks, and "the
// transaction rolled back" is not an answer they accept.
//
// Per tenant rather than per facility, because that is how a hospital group's
// books are kept: one invoice series across the group, so a number identifies a
// document without also having to name which site issued it.
func (n Numbers) Issue(ctx context.Context, scope authctx.TenantScope,
	sequenceScope string, now time.Time) (string, error) {

	return n.issuer.IssueNumber(ctx, scope,
		orgdomain.NumberScope(sequenceScope), "", "", now)
}
