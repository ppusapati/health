// Package escalate implements the biomedical Escalator port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and biomedical must not know
// that a recall is a row in platform_escalation.notice. What it knows is that
// a ward is using a machine the manufacturer has recalled.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Adapter raises platform notices for biomedical exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is an asset tag or a notice reference and never a patient.
// Nothing in this context is about one, and a notice travels further and under
// fewer controls than the record that produced it.
//
// The notice is raised whether or not the tenant has configured a chain for
// this kind. Raising and delivering are separate on purpose: the notice is the
// durable record that somebody had to be told, and the driver is what finds
// the chain missing and says so.
//
// Every failure propagates and fails the caller's transaction. A recall
// recorded with the paging silently switched off is a recall the wards never
// hear about, which is the failure SRS-BIO-008 exists to prevent.
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
