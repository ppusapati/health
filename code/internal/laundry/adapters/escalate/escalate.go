// Package escalate implements the laundry Escalator port against the platform
// escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the laundry must not know
// that a failed-wash notice is a row in platform_escalation.notice. What it
// knows is that somebody has to be told now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for laundry exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a batch identifier and the summary names a machine and a
// count of units. Never a patient and never a soil class against a named
// ward: a notice goes further and under fewer controls than the record that
// produced it.
//
// Every failure propagates and fails the caller's transaction. A wash
// recorded as failed with the paging silently switched off is linen the wards
// in it are already making beds with.
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
