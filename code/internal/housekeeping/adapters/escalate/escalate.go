// Package escalate implements the housekeeping Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and housekeeping must not know
// that an overdue-theatre notice is a row in platform_escalation.notice. What
// it knows is that somebody has to be told now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for housekeeping exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a task or a hold identifier and the summary names a room or
// a bed. Never a patient and never what was spilled: a notice goes further
// and under fewer controls than the record that produced it, and the one
// thing a spill notice must not carry is which bay and who was in it.
//
// Every failure propagates and fails the caller's transaction. A bed recorded
// as returned to service uncleaned with the paging silently switched off is a
// bed the next ward admits into knowing nothing.
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
