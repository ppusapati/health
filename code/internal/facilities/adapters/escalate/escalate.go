// Package escalate implements the facilities Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the facilities service must
// not know that a medical gas emergency is a row in
// platform_escalation.notice. What it knows is that somebody has to be told
// now, and how far up the chain.
package escalate

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for facilities exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is a work order or a deficiency identifier and the summary
// names a system, a number and an impact. Never a patient and never a ward
// census: a notice goes further and under fewer controls than the record that
// produced it.
//
// A notice that must start above rung zero is raised and then written back at
// that level, because SRS-FAC-006's acceptance is that a critical gas issue
// receives the highest configured escalation — not that it eventually reaches
// it after the timer has run three times.
//
// Every failure propagates and fails the caller's transaction. An empty
// oxygen manifold recorded with the paging silently switched off is a safety
// rule that has become a line in a log nobody reads.
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

	if n.Level > 0 && raised.Level < n.Level {
		raised.Level = n.Level
		if err := a.store.Save(ctx, scope, raised); err != nil {
			return "", err
		}
	}
	return raised.ID, nil
}

// Top implements ports.Escalator.
//
// A matrix nobody configured is not an error here. It means the hospital has
// not written down who to call for this kind of notice, and the honest answer
// is that the chain has one rung — inventing a higher one would page nobody
// while looking like it had paged somebody senior.
func (a *Adapter) Top(ctx context.Context, scope authctx.TenantScope,
	kind, facilityID string) (int, error) {

	if a == nil || a.store == nil {
		return 0, nil
	}
	matrix, err := a.store.Matrix(ctx, scope, facilityID, kind)
	if errors.Is(err, escalation.ErrNoMatrix) {
		return 0, nil
	}
	if err != nil {
		return 0, err
	}
	return matrix.Top(), nil
}
