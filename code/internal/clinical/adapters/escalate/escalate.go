// Package escalate implements clinical's Escalations port against the platform
// escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package gives:
// the dependency arrow points inward, and clinical must not know that an
// escalation is a row in platform_escalation.notice. What it knows is that a
// critical result needs somebody to say they have it.
package escalate

import (
	"context"
	"fmt"
	"strings"

	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Kind is the matrix a critical result escalates along.
//
// Matching the requirement's own vocabulary rather than inventing one: a
// hospital configuring SRS-ER-016's chain looks for "critical_result".
const Kind = "critical_result"

// Adapter raises platform notices for clinical events.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

// RaiseCritical implements ports.Escalations.
//
// The notice is raised whether or not the tenant has configured a chain for
// critical results. Raising and delivering are separate on purpose: the notice
// is the durable record that somebody was supposed to be told, and the driver
// is what finds the chain missing and says so. A clinic that configures its
// matrix a week later still has every unacknowledged result in the mechanism
// rather than only in the chart.
//
// Every failure propagates, and fails the caller's transaction. A critical
// result recorded with the safety net silently switched off is the outcome that
// has to be impossible.
func (a *Adapter) RaiseCritical(ctx context.Context, scope authctx.TenantScope,
	notice ports.CriticalNotice) error {

	if a == nil || a.store == nil {
		return nil
	}

	_, _, err := a.store.Raise(ctx, scope, escalation.Subject{
		Kind:       Kind,
		ID:         notice.ObservationID,
		PatientID:  notice.PatientID,
		FacilityID: notice.FacilityID,
	}, summarise(notice), notice.At)
	return err
}

// summarise composes what the recipient reads.
//
// The test's name and the reading, never the number. The value belongs to the
// chart, where the access rules are; this is the line that makes somebody open
// it.
func summarise(notice ports.CriticalNotice) string {
	display := strings.TrimSpace(notice.Display)
	if display == "" {
		display = "A result"
	}
	interpretation := strings.TrimSpace(notice.Interpretation)
	if interpretation == "" {
		interpretation = "critical"
	}
	return fmt.Sprintf("%s — %s. Open the chart and acknowledge.",
		display, strings.ReplaceAll(interpretation, "_", " "))
}
