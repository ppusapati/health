// Package escalate implements the blood bank's Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the blood bank must not know
// that a mismatch is a row in platform_escalation.notice. What it knows is
// that somebody at a bedside is holding the wrong bag.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for blood bank exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The notice is raised whether or not the tenant has configured a chain for
// this kind. Raising and delivering are separate on purpose: the notice is the
// durable record that somebody had to be told, and the driver is what finds
// the chain missing and says so. A blood bank that configures its matrix a
// week later still has the mismatch in the mechanism rather than only in the
// audit trail.
//
// Every failure propagates and fails the caller's transaction. A bedside
// mismatch recorded with the paging silently switched off is the outcome that
// has to be impossible: the whole point of SRS-BLD-010's critical exception is
// that the bank finds out before the next unit goes out.
func (a *Adapter) Raise(ctx context.Context, scope authctx.TenantScope,
	n ports.Notice, at time.Time) (string, error) {

	if a == nil || a.store == nil {
		return "", nil
	}

	raised, _, err := a.store.Raise(ctx, scope, escalation.Subject{
		Kind:       n.Kind,
		ID:         n.Subject,
		PatientID:  n.PatientID,
		FacilityID: n.FacilityID,
	}, n.Summary, at)
	if err != nil {
		return "", err
	}
	return raised.ID, nil
}
