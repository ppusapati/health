// Package escalate implements the materials Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call: the dependency arrow points inward,
// and the stores must not know that a recall is a row in
// platform_escalation.notice. What they know is that a ward is holding stock
// from a lot that has been blocked.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for materials exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject carries no patient: a recall is about a manufacturing lot, and
// the patients it reached are the ones in the recall list rather than one name
// on a pager. A notice naming a single patient would read as that patient's
// problem, which is the one thing it is not.
//
// Every failure propagates and fails the caller's transaction. A lot blocked
// with the paging silently switched off is a recall the wards never hear
// about, which is the failure SRS-MAT-013 exists to prevent.
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
