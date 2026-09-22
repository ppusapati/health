package crosscontext_test

import (
	"context"
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/housekeeping/adapters/crosscontext"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	qualitydomain "github.com/ppusapati/health/code/internal/quality/domain"
	qualityports "github.com/ppusapati/health/code/internal/quality/ports"
)

// The seam onto the quality context.
//
// The rule under test is the wave specification's: "unavailable optional
// dependencies must degrade safely. A feature may not silently reinterpret a
// dependency outage as a valid negative business/clinical result." An adapter
// that answered "no such incident" when the quality database was unreachable
// would tell a nurse standing over a blood spill that their reference was
// wrong, which is both untrue and unfixable by them.

type stubIncidents struct {
	err error
}

func (s stubIncidents) InsertIncident(context.Context, authctx.TenantScope,
	qualitydomain.Incident) error {
	panic("housekeeping must not write an incident")
}

func (s stubIncidents) Incident(context.Context, authctx.TenantScope,
	string) (qualitydomain.Incident, error) {
	if s.err != nil {
		return qualitydomain.Incident{}, s.err
	}
	return qualitydomain.Incident{}, nil
}

func (s stubIncidents) UpdateIncident(context.Context, authctx.TenantScope,
	qualitydomain.Incident, int64) error {
	panic("housekeeping must not change an incident")
}

func (s stubIncidents) Incidents(context.Context, authctx.TenantScope,
	qualityports.IncidentFilter) ([]qualitydomain.Incident, error) {
	panic("housekeeping must not browse the incident register")
}

func (s stubIncidents) ForPatient(context.Context, authctx.TenantScope,
	string, int32) ([]qualitydomain.Incident, error) {
	panic("housekeeping must not read a patient's incidents")
}

var _ qualityports.IncidentRepository = stubIncidents{}

func TestOnlyAMissingIncidentReadsAsAMissingIncident(t *testing.T) {
	ctx := context.Background()
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "hk-1", TenantID: "t1",
	}).TenantScope()

	// A row that is not there is an answer to the question asked.
	absent := crosscontext.NewIncidents(stubIncidents{
		err: rpcerr.NotFound("QMS_NOT_FOUND", "no such record"),
	})
	exists, err := absent.Exists(ctx, scope, "INC-1")
	if err != nil || exists {
		t.Fatalf("want (false, nil) for a missing incident, got (%v, %v)",
			exists, err)
	}

	// Anything else is the failure it is. Returning false here would refuse
	// the spill clean with "no such incident", and the person holding the
	// mop would go looking for a reference that was right all along.
	outage := crosscontext.NewIncidents(stubIncidents{
		err: errors.New("dial tcp: connection refused"),
	})
	if _, err := outage.Exists(ctx, scope, "INC-1"); err == nil {
		t.Fatal("a dependency outage was reported as a missing incident")
	}

	// And a permission refusal is not an absence either: a deployment that
	// had not granted housekeeping the read would otherwise see every
	// incident reference rejected as invalid.
	denied := crosscontext.NewIncidents(stubIncidents{
		err: rpcerr.PermissionDenied("QMS_FORBIDDEN", "not permitted"),
	})
	if _, err := denied.Exists(ctx, scope, "INC-1"); err == nil {
		t.Fatal("a permission refusal was reported as a missing incident")
	}

	// A deployment with no quality context wired answers that it found
	// nothing, which is what the status document says it does.
	none := crosscontext.NewIncidents(nil)
	exists, err = none.Exists(ctx, scope, "INC-1")
	if err != nil || exists {
		t.Fatalf("want (false, nil) with no adapter, got (%v, %v)",
			exists, err)
	}
}
