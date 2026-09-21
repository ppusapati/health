// Package escalate implements the dietetics Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the kitchen must not
// know that a withheld-tray notice is a row in platform_escalation.notice.
// What it knows is that somebody has to be told now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for dietetics exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a tray identifier, and for a run of missed meals a patient
// identifier — the one case here where it has to be, because the ward needs
// to know which patient has not eaten. The reason never travels with a
// diagnosis on it: a notice goes further and under fewer controls than the
// record that produced it.
//
// Every failure propagates and fails the caller's transaction. A tray
// recorded as withheld with the paging silently switched off is a meal the
// ward will go looking for.
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
