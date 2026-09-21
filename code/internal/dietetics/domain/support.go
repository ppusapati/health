package domain

import (
	"fmt"
	"strings"
	"time"
)

// SupportKind is how nutrition support is delivered (SRS-DIET-007).
type SupportKind string

const (
	// SupportEnteral is tube feeding. The regimen that runs it is an order
	// in the orders context.
	SupportEnteral SupportKind = "enteral"
	// SupportParenteral is intravenous. The bag is a prescription in the
	// medication context, with the pharmacy checks that belong to one.
	SupportParenteral SupportKind = "parenteral"
)

var knownSupportKind = map[SupportKind]bool{
	SupportEnteral: true, SupportParenteral: true,
}

// SupportState is where a support plan stands (SRS-DIET-007).
type SupportState string

const (
	// SupportPlanned is the dietitian's plan with no order behind it yet.
	// Nothing is running: this state exists precisely so that a plan cannot
	// be mistaken for a feed.
	SupportPlanned SupportState = "planned"
	// SupportActive is a plan the order carrying it out has been placed for.
	SupportActive  SupportState = "active"
	SupportStopped SupportState = "stopped"
)

// NutritionSupportPlan is the dietitian's plan for tube or intravenous
// feeding (SRS-DIET-007).
//
// The requirement is explicit that this must not replace medication and order
// controls, and the way to mean that is what this type does not have. There
// is no administration record, no rate a pump is set from, no bag, no
// signature that would stand as a prescription. What it has is targets and
// OrderRef — the identifier of the order or prescription in the context that
// owns it, with all the checking that context does.
//
// A plan cannot go active without that reference. A hospital where a
// dietitian's plan alone starts a feed is a hospital where parenteral
// nutrition bypasses pharmacy, and the refeeding syndrome that follows is the
// reason those checks exist.
type NutritionSupportPlan struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	Kind        SupportKind

	// FormulaCode is the product the dietitian is asking for, from the
	// deployment's own list. A request, not a dispense.
	FormulaCode string
	FormulaName string
	// The daily targets. Integers in base units: millilitres, kcal, grams.
	TargetVolumeML   int
	TargetEnergyKcal int
	TargetProteinG   int
	// RampPlan is how to build up, which matters more than the target for a
	// patient at refeeding risk. Free text because it is advice to a
	// clinician, not an instruction to a machine.
	RampPlan string

	// OrderRef and OrderContext name the order or prescription that carries
	// the plan out, and which context owns it. Required before the plan goes
	// active.
	OrderRef     string
	OrderContext string

	State      SupportState
	StoppedAt  time.Time
	StoppedBy  string
	StopReason string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewSupportPlanInput proposes nutrition support.
type NewSupportPlanInput struct {
	PatientID        string
	EncounterID      string
	Kind             SupportKind
	FormulaCode      string
	FormulaName      string
	TargetVolumeML   int
	TargetEnergyKcal int
	TargetProteinG   int
	RampPlan         string
}

// PlanNutritionSupport proposes tube or intravenous feeding (SRS-DIET-007).
func PlanNutritionSupport(id, tenantID string, in NewSupportPlanInput,
	by string, now time.Time) (NutritionSupportPlan, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return NutritionSupportPlan{}, fmt.Errorf("%w: a plan needs an id",
			ErrInvalidDietetics)
	case strings.TrimSpace(in.PatientID) == "":
		return NutritionSupportPlan{}, fmt.Errorf(
			"%w: a plan names its patient", ErrInvalidDietetics)
	case !knownSupportKind[in.Kind]:
		return NutritionSupportPlan{}, fmt.Errorf(
			"%w: unknown nutrition support kind %q",
			ErrInvalidDietetics, in.Kind)
	case strings.TrimSpace(in.FormulaCode) == "":
		return NutritionSupportPlan{}, fmt.Errorf(
			"%w: a plan names the formula it is asking for",
			ErrInvalidDietetics)
	case in.TargetVolumeML < 0 || in.TargetEnergyKcal < 0 ||
		in.TargetProteinG < 0:
		return NutritionSupportPlan{}, fmt.Errorf(
			"%w: a target cannot be negative", ErrInvalidDietetics)
	}

	return NutritionSupportPlan{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Kind:             in.Kind,
		FormulaCode:      strings.TrimSpace(in.FormulaCode),
		FormulaName:      strings.TrimSpace(in.FormulaName),
		TargetVolumeML:   in.TargetVolumeML,
		TargetEnergyKcal: in.TargetEnergyKcal,
		TargetProteinG:   in.TargetProteinG,
		RampPlan:         strings.TrimSpace(in.RampPlan),
		State:            SupportPlanned,
		CreatedAt:        now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// LinkOrder records the order or prescription carrying the plan out, and
// only then does the plan go active (SRS-DIET-007).
//
// The reference is required and so is the context that owns it: "order 4471"
// means one thing in the orders context and another in medication, and a
// reference nobody can resolve is a plan with nothing behind it.
func (p *NutritionSupportPlan) LinkOrder(ref, context string,
	now time.Time) error {

	switch {
	case p.State == SupportStopped:
		return fmt.Errorf("%w: this plan is stopped", ErrInvalidDietetics)
	case strings.TrimSpace(ref) == "":
		return fmt.Errorf(
			"%w: a support plan goes active against an order, not on its own",
			ErrInvalidDietetics)
	case strings.TrimSpace(context) == "":
		return fmt.Errorf(
			"%w: say which context owns the order carrying this out",
			ErrInvalidDietetics)
	}
	p.OrderRef = strings.TrimSpace(ref)
	p.OrderContext = strings.TrimSpace(context)
	p.State = SupportActive
	_ = now
	return nil
}

// Stop ends nutrition support (SRS-DIET-007).
//
// Stopping the plan does not stop the feed: the order does that, in the
// context that owns it. This records the dietetics decision, and the state
// name says what it is.
func (p *NutritionSupportPlan) Stop(reason, by string, now time.Time) error {
	switch {
	case p.State == SupportStopped:
		return fmt.Errorf("%w: this plan is already stopped",
			ErrInvalidDietetics)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the support is being stopped",
			ErrInvalidDietetics)
	}
	p.State = SupportStopped
	p.StoppedAt, p.StoppedBy = now.UTC(), by
	p.StopReason = strings.TrimSpace(reason)
	return nil
}
