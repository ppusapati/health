// Package escalate implements the medical records Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the records office must not
// know that an overdue deficiency notice is a row in
// platform_escalation.notice. What it knows is that somebody has to be told
// now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// Adapter raises platform notices for medical records exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a deficiency or a paper record identifier and never a
// patient. A notice travels further and under fewer controls than the record
// that produced it, and a missing-record page naming the patient whose file
// it is would be the most widely readable copy of that fact in the hospital.
//
// Every failure propagates and fails the caller's transaction. A deficiency
// marked escalated with the paging silently switched off is one the clinician
// never hears about and the system will never raise again.
func (a *Adapter) Raise(ctx context.Context, scope authctx.TenantScope,
	n ports.Notice, at time.Time) (string, error) {

	if a == nil || a.store == nil {
		return "", nil
	}

	raised, _, err := a.store.Raise(ctx, scope, escalation.Subject{
		Kind:       n.Kind,
		ID:         n.Subject,
		FacilityID: n.FacilityID,
	}, n.Summary, at)
	if err != nil {
		return "", err
	}
	return raised.ID, nil
}
