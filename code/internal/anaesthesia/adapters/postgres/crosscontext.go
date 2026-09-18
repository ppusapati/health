package postgres

import (
	"context"

	"github.com/ppusapati/health/code/internal/anaesthesia/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	theatreports "github.com/ppusapati/health/code/internal/theatre/ports"
)

// Cases adapts the theatre's own case repository (SRS-OT).
//
// An adapter rather than a direct call: the operation belongs to SRS-OT, and
// an anaesthesia context holding its own copy of which patient is on the table
// is one that charts a drug against the wrong person.
type Cases struct {
	schedule theatreports.ScheduleRepository
}

// NewCases constructs the adapter.
func NewCases(schedule theatreports.ScheduleRepository) Cases {
	return Cases{schedule: schedule}
}

var _ ports.Cases = Cases{}

// Case returns the patient and encounter the case is for, and whether it still
// accepts charting.
//
// A completed or cancelled case returns writable false. Charting against a
// closed case is how a record acquires entries made after the patient left,
// and the anaesthetist who has to sign it is the one who finds out.
func (c Cases) Case(ctx context.Context, scope authctx.TenantScope, caseID string) (
	string, string, bool, error) {

	found, err := c.schedule.Case(ctx, scope, caseID)
	if err != nil {
		return "", "", false, err
	}
	return found.PatientID, found.EncounterID, found.Status.Open(), nil
}
