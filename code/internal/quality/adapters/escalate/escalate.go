// Package escalate implements the quality Escalator port against the platform
// escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and quality must not know that a
// sentinel-event notice is a row in platform_escalation.notice. What it knows
// is that somebody has to be told now.
package escalate

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// Adapter raises platform notices for quality exceptions.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalator = (*Adapter)(nil)

// Raise implements ports.Escalator.
//
// The subject is an incident, action or complaint reference and never a
// patient, a narrative or what somebody said about their care. A notice
// travels further and under fewer controls than the record that produced it,
// and a sentinel-event page carrying the narrative would be the most widely
// readable copy of the most sensitive text in the hospital.
//
// The notice is raised whether or not the tenant has configured a chain for
// this kind. Raising and delivering are separate on purpose: the notice is the
// durable record that somebody had to be told, and the driver is what finds
// the chain missing and says so.
//
// Every failure propagates and fails the caller's transaction. A sentinel
// event recorded with the paging silently switched off is a sentinel event the
// executive never hears about, which is the failure SRS-QMS-005 exists to
// prevent.
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
