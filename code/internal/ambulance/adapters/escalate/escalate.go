// Package escalate implements the ambulance Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the ambulance service must
// not know that an overridden dispatch is a row in
// platform_escalation.notice. What it knows is that somebody has to be told
// now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for ambulance exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a trip or a record identifier and the summary names a
// vehicle and a reason. Never a patient, never an address and never a
// clinical need: a notice goes further and under fewer controls than the
// record that produced it.
//
// Every failure propagates and fails the caller's transaction. A dispatch
// made under override with the paging silently switched off is a safety rule
// that has become a line in a log nobody reads.
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
