// Package escalate implements the emergency context's Escalations port against
// the platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package gives:
// the dependency arrow points inward, and the department must not know that an
// activation is a row in platform_escalation.notice. What it knows is that a
// trauma call needs a team to arrive.
package escalate

import (
	"context"
	"fmt"
	"strings"

	"github.com/ppusapati/health/code/internal/emergency/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Kind is the matrix a pathway activation escalates along.
//
// The requirement's own vocabulary rather than an invented one: a hospital
// configuring SRS-ER-005's chain looks for "pathway_activation".
const Kind = "pathway_activation"

// Adapter raises platform notices for emergency activations.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalations = (*Adapter)(nil)

// RaisePathway implements ports.Escalations.
//
// The notice is raised whether or not the tenant has configured a chain for
// activations. Raising and delivering are separate on purpose: the notice is
// the durable record that somebody was supposed to come, and the driver is
// what finds the chain missing and says so. A department that configures its
// matrix an hour later still has the trauma call in the mechanism rather than
// only in the chart.
//
// Every failure propagates and fails the caller's transaction. An activation
// recorded with the paging silently switched off is the outcome that has to be
// impossible.
func (a *Adapter) RaisePathway(ctx context.Context, scope authctx.TenantScope,
	notice ports.PathwayNotice) (string, error) {

	if a == nil || a.store == nil {
		return "", nil
	}

	raised, _, err := a.store.Raise(ctx, scope, escalation.Subject{
		Kind:       Kind,
		ID:         notice.PathwayID,
		PatientID:  notice.PatientID,
		FacilityID: notice.FacilityID,
	}, summarise(notice), notice.At)

	if err != nil {
		return "", err
	}
	return raised.ID, nil
}

// summarise composes what the recipient reads.
//
// The pathway and where to go, never the patient's complaint. The escalation
// inbox is read by a mechanism that knows nothing about clinical
// confidentiality (SRS-API-009), and "STEMI pathway activated in Resus 1" is
// enough to make the right person move.
func summarise(notice ports.PathwayNotice) string {
	label := strings.TrimSpace(notice.Label)
	if label == "" {
		label = strings.TrimSpace(notice.Kind)
	}
	if label == "" {
		label = "An emergency pathway"
	}
	if location := strings.TrimSpace(notice.Location); location != "" {
		return fmt.Sprintf("%s activated in %s. Go now.", label, location)
	}
	return fmt.Sprintf("%s activated in the emergency department. Go now.", label)
}
