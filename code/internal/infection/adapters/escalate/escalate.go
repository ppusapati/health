// Package escalate implements the infection control Escalator port against
// the platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and infection control must not
// know that an outbreak notice is a row in platform_escalation.notice. What
// it knows is that somebody has to be told now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for infection control exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is an outbreak, exposure or sample identifier and never a
// patient, a member of staff or an organism against a name. A notice travels
// further and under fewer controls than the record that produced it, and an
// occupational exposure page naming the nurse it happened to would be the
// most widely readable copy of a staff health record.
//
// Every failure propagates and fails the caller's transaction. An outbreak
// recorded with the paging silently switched off is an outbreak nobody hears
// about.
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
