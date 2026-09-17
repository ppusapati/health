// Package escalate implements the critical-care Escalations port against the
// platform escalation mechanism.
//
// An adapter rather than a direct call, for the reason the ports package
// gives: the dependency arrow points inward, and the unit must not know that
// an escalation is a row in platform_escalation.notice.
package escalate

import (
	"context"
	"fmt"
	"strings"

	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
)

// Kind is the matrix a critical-care advisory escalates along.
//
// Its own matrix rather than the critical-result one, because the people are
// different: a monitor that has gone quiet is the nurse in charge and then the
// biomedical department, and a critical potassium is the clinician who ordered
// it. A hospital configuring SRS-ICU-013's chain looks for "icu_advisory".
const Kind = "icu_advisory"

// Adapter raises platform notices for critical-care advisories.
type Adapter struct {
	store *escalation.Store
}

// New constructs an adapter.
func New(store *escalation.Store) *Adapter { return &Adapter{store: store} }

var _ ports.Escalations = (*Adapter)(nil)

// RaiseAdvisory implements ports.Escalations.
//
// The notice is raised whether or not the tenant has configured a chain.
// Raising and delivering are separate: the notice is the durable record that
// somebody was asked to look, and the driver is what finds the chain missing
// and says so.
//
// What reaches the inbox is operational, which is SRS-ICU-013's constraint
// stated in the only place a reader of the escalation table would see it. A
// line that needs reviewing and a monitor that has stopped sending are this
// software's business; a bedside alarm is a safety function of a regulated
// device and is not reachable from here.
func (a *Adapter) RaiseAdvisory(ctx context.Context, scope authctx.TenantScope,
	notice ports.AdvisoryNotice) (string, error) {

	if a == nil || a.store == nil {
		return "", nil
	}

	raised, _, err := a.store.Raise(ctx, scope, escalation.Subject{
		Kind: Kind,
		// The episode rather than the condition, so a second advisory about
		// the same bed joins the notice already open instead of paging
		// somebody twice about one patient.
		ID:         notice.EpisodeID + ":" + notice.Kind,
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
// The bed and what to look at, never a value. The escalation inbox is read by
// a mechanism that knows nothing about clinical confidentiality (SRS-API-009),
// and "Bed 4 in ICU: a line needs reviewing" is enough to make somebody go.
func summarise(notice ports.AdvisoryNotice) string {
	summary := strings.TrimSpace(notice.Summary)
	if summary == "" {
		summary = "Something on this bed needs looking at."
	}
	bed := strings.TrimSpace(notice.BedID)
	unit := strings.TrimSpace(notice.UnitID)
	switch {
	case bed != "" && unit != "":
		return fmt.Sprintf("Bed %s in %s: %s", bed, unit, summary)
	case bed != "":
		return fmt.Sprintf("Bed %s: %s", bed, summary)
	default:
		return summary
	}
}
