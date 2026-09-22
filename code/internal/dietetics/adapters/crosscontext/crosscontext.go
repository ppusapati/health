// Package crosscontext implements the dietetics seams onto the contexts that
// own the facts (SRS-DIET-003, SRS-DIET-007).
//
// Adapters rather than tables here. What a patient is allergic to belongs to
// the clinical record, and the order that runs a feed belongs to the context
// that placed it. A copy of either would drift the first time somebody
// corrected one — and for an allergy, that correction is the one that matters
// most.
//
// Both are read-only, and that absence is the requirement rather than an
// omission: SRS-DIET-007's "without replacing medication/order controls" is a
// property of holding a reader and nothing that writes.
package crosscontext

import (
	"context"
	"errors"
	"strings"

	clinicaldomain "github.com/ppusapati/health/code/internal/clinical/domain"
	clinicalports "github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	medicationports "github.com/ppusapati/health/code/internal/medication/ports"
	ordersports "github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// allergyPageSize bounds one patient's allergy list. A patient with more
// documented allergies than this is a chart somebody should look at, and a
// truncated list is a check that silently stops looking.
const allergyPageSize = 500

// Allergies adapts the clinical context's allergy list (SRS-DIET-003).
type Allergies struct {
	repo clinicalports.RecordRepository
}

// NewAllergies constructs the adapter.
func NewAllergies(repo clinicalports.RecordRepository) Allergies {
	return Allergies{repo: repo}
}

var _ ports.Allergies = Allergies{}

// ForPatient implements ports.Allergies.
//
// Only the active entries: a refuted allergy is one a clinician has
// positively excluded, and blocking a patient's food over it is how allergy
// lists become things nobody trusts. The criticality travels with each entry,
// because a conflict against an anaphylaxis is not the same decision as one
// against an intolerance and the person resolving it needs to know which.
//
// A failure propagates rather than answering "no allergies". Treating a
// database error as a clean list is how a peanut supplement reaches somebody
// who is anaphylactic to peanuts.
func (a Allergies) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) ([]domain.Allergen, error) {

	if a.repo == nil {
		return nil, nil
	}
	list, err := a.repo.Allergies(ctx, scope, patientID, true,
		allergyPageSize)
	if err != nil {
		return nil, err
	}

	out := make([]domain.Allergen, 0, len(list))
	for _, allergy := range list.Active() {
		codes := []string{}
		if allergy.Substance.Code != "" {
			// Qualified and bare, because the kitchen's item list and the
			// clinical record do not always agree on whether a code carries
			// its system. Matching on either is the safe direction: the
			// failure mode of an extra conflict is somebody reading it, and
			// the failure mode of a missed one is anaphylaxis.
			codes = append(codes, allergy.Substance.Code)
			if allergy.Substance.System != "" {
				codes = append(codes,
					allergy.Substance.System+"|"+allergy.Substance.Code)
			}
		}
		out = append(out, domain.Allergen{
			Ref: allergy.ID, Substance: substanceOf(allergy),
			Codes: codes, Severity: string(allergy.Criticality),
		})
	}
	return out, nil
}

// substanceOf is what a dietitian reading the conflict sees.
func substanceOf(allergy clinicaldomain.Allergy) string {
	if display := strings.TrimSpace(allergy.Substance.Display); display != "" {
		return display
	}
	return allergy.Substance.Code
}

// OrderDirectory resolves the order a nutrition support plan names
// (SRS-DIET-007).
//
// Two readers and nothing else. Without this the rule that a plan cannot go
// active without an order is defeated by typing anything into the reference
// field, and the pharmacy check the requirement exists to preserve is
// preserved in wording only.
type OrderDirectory struct {
	orders        ordersports.OrderRepository
	prescriptions medicationports.PrescriptionRepository
}

// NewOrderDirectory constructs the adapter.
func NewOrderDirectory(orders ordersports.OrderRepository,
	prescriptions medicationports.PrescriptionRepository) OrderDirectory {

	return OrderDirectory{orders: orders, prescriptions: prescriptions}
}

var _ ports.OrderDirectory = OrderDirectory{}

// Exists implements ports.OrderDirectory.
//
// A context this deployment does not know about answers false rather than
// true. The whole point is that the reference resolves somewhere real, and
// "we could not check" must not read as "it is there".
func (d OrderDirectory) Exists(ctx context.Context, scope authctx.TenantScope,
	orderContext, ref string) (bool, error) {

	switch strings.ToLower(strings.TrimSpace(orderContext)) {
	case "orders":
		if d.orders == nil {
			return false, nil
		}
		if _, err := d.orders.Get(ctx, scope, ref); err != nil {
			return false, absentOrFailed(err)
		}
		return true, nil
	case "medication":
		if d.prescriptions == nil {
			return false, nil
		}
		if _, err := d.prescriptions.Get(ctx, scope, ref); err != nil {
			return false, absentOrFailed(err)
		}
		return true, nil
	default:
		return false, nil
	}
}

// absentOrFailed separates "there is no such order" from "we could not ask".
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is, because
// the wave specification is explicit that a dependency outage must not be
// reinterpreted as a valid negative result. Swallowing one here would tell a
// dietitian that the prescription pharmacy had just dispensed against does
// not exist.
func absentOrFailed(err error) error {
	var refused *rpcerr.Error
	if errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound {
		return nil
	}
	return err
}
