package domain

import (
	"sort"
	"strings"
	"time"
)

// Order policy, duplicate detection, order sets and favourites
// (SRS-ORD-002, SRS-ORD-003, SRS-ORD-007, SRS-ORD-009, SRS-ORD-012).
//
// The rule that ties this file together is SRS-ORD-012's: "personal preferences
// cannot bypass mandatory rules". The way to hold that is structural rather
// than by remembering to check — there is exactly one path from a composed
// order to a placed one, Order.Submit, and it applies this policy. An order set
// and a favourite produce drafts and then take the same path, so a favourite
// that omits a required indication is refused at submit like anything else.

// Policy is what a tenant requires before an order may be placed
// (SRS-ORD-002, SRS-ORD-007).
type Policy struct {
	// IndicationRequired lists the order types that cannot be placed without a
	// clinical reason. Per type rather than universal: an indication for a
	// CT scan is what justifies the radiation dose and a national body audits
	// it, and an indication for a diet order is a field nobody fills in
	// honestly once it is mandatory.
	IndicationRequired map[Type]bool
	// StructuredTimingRequired lists the types that must carry a schedule
	// rather than an instruction in free text.
	StructuredTimingRequired map[Type]bool
	// PrivilegedTypes lists the types a requester needs a specific privilege
	// for, mapped to the privilege name. The authorization check itself belongs
	// to the application layer, which holds the session; the domain holds which
	// types are gated, so the two cannot drift.
	PrivilegedTypes map[Type]string
}

// DefaultPolicy is the safe starting point.
//
// Indication required for the types where somebody outside the hospital asks
// why: imaging carries a radiation dose that is audited, blood products are
// traced unit by unit, and a medication with no indication is the prescription
// nobody can review.
func DefaultPolicy() Policy {
	return Policy{
		IndicationRequired: map[Type]bool{
			TypeImaging: true, TypeBloodProduct: true, TypeMedication: true,
			TypeProcedure: true,
		},
		StructuredTimingRequired: map[Type]bool{
			TypeMedication: true, TypeNursing: true,
		},
		PrivilegedTypes: map[Type]string{
			TypeBloodProduct: "ord.blood_product.order",
		},
	}
}

// Check applies the policy to an order about to be placed.
//
// Returns every failure rather than the first: a clinician told about one
// missing field, who fills it in and is then told about another, stops reading
// the message — the same argument the encounter closure gate makes.
func (p Policy) Check(o *Order) error {
	var violations []FieldViolation

	if p.IndicationRequired[o.Type] &&
		strings.TrimSpace(o.Indication) == "" && o.IndicationCode.Empty() {
		violations = append(violations, FieldViolation{
			Field:  "indication",
			Reason: "state why this order is being placed",
		})
	}
	if p.StructuredTimingRequired[o.Type] && !o.Timing.PRN &&
		!o.Timing.Repeating() && o.Timing.StartAt.IsZero() {
		// Not "no timing at all": a one-off order with a start time is
		// perfectly structured. What is refused is an order of a type that runs
		// on a schedule carrying nothing a downstream service could act on.
		violations = append(violations, FieldViolation{
			Field:  "timing",
			Reason: "this order type needs a start time or a schedule",
		})
	}
	if o.Type == TypeMedication && strings.TrimSpace(o.Detail) == "" {
		violations = append(violations, FieldViolation{
			Field:  "detail",
			Reason: "a medication order needs its dose and route",
		})
	}

	if len(violations) == 0 {
		return nil
	}
	sort.Slice(violations, func(i, j int) bool {
		return violations[i].Field < violations[j].Field
	})
	return ErrOrderIncomplete{Violations: violations}
}

// RequiredPrivilege reports the privilege this order type needs, if any.
func (p Policy) RequiredPrivilege(t Type) (string, bool) {
	privilege, ok := p.PrivilegedTypes[t]
	return privilege, ok
}

// FieldViolation names one thing wrong with an order.
type FieldViolation struct {
	Field  string
	Reason string
}

// ErrOrderIncomplete reports an order that cannot be placed (SRS-ORD-002).
//
// The requirement's acceptance criterion is "structured field/domain errors",
// so the failures travel as data rather than as a sentence a client would have
// to parse to highlight the right box.
type ErrOrderIncomplete struct {
	Violations []FieldViolation
}

func (e ErrOrderIncomplete) Error() string {
	parts := make([]string, 0, len(e.Violations))
	for _, v := range e.Violations {
		parts = append(parts, v.Field+": "+v.Reason)
	}
	return "orders: this order cannot be placed — " + strings.Join(parts, "; ")
}

// Is lets callers match with errors.Is.
func (e ErrOrderIncomplete) Is(target error) bool {
	_, ok := target.(ErrOrderIncomplete)
	return ok
}

// DuplicateRule is how a tenant decides two orders are the same
// (SRS-ORD-009).
//
// Configurable per type, which the requirement asks for, because the answer
// genuinely differs: two chest X-rays an hour apart is almost always a mistake,
// two paracetamol orders is a dosing error, and two physiotherapy referrals in
// a week is how a hospital works.
type DuplicateRule struct {
	Type Type
	// Within is how far back to look. Zero disables the check for this type.
	Within time.Duration
	// SameCodeOnly restricts the match to the identical code. Off means any
	// order of this type in the window counts, which is right for a diet order
	// — a patient has one diet — and wrong for a laboratory order.
	SameCodeOnly bool
	// Overridable says whether a clinician may proceed. Note that the default
	// is yes: SRS-ORD-009 is explicit that the system shows a warning "rather
	// than arbitrary suppression", and a duplicate check that silently refused
	// would be exactly the suppression the requirement forbids.
	Overridable bool
}

// DefaultDuplicateRules is a starting point a tenant is expected to retune.
func DefaultDuplicateRules() map[Type]DuplicateRule {
	return map[Type]DuplicateRule{
		TypeLaboratory: {
			Type: TypeLaboratory, Within: 12 * time.Hour,
			SameCodeOnly: true, Overridable: true,
		},
		TypeImaging: {
			Type: TypeImaging, Within: 24 * time.Hour,
			SameCodeOnly: true, Overridable: true,
		},
		TypeMedication: {
			Type: TypeMedication, Within: 24 * time.Hour,
			SameCodeOnly: true, Overridable: true,
		},
		TypeDiet: {
			// Any diet order supersedes the last one; a patient has one diet.
			Type: TypeDiet, Within: 7 * 24 * time.Hour,
			SameCodeOnly: false, Overridable: true,
		},
		TypeBloodProduct: {
			Type: TypeBloodProduct, Within: 24 * time.Hour,
			SameCodeOnly: true, Overridable: true,
		},
	}
}

// DuplicateWarning is what a clinician is shown (SRS-ORD-009).
type DuplicateWarning struct {
	// Existing are the live orders that match. Shown in full rather than
	// counted, because the requirement says the clinician can "review existing
	// order", and a warning that says "a duplicate exists" without saying which
	// one is a warning nobody can act on.
	Existing []*Order
	// Overridable says whether proceeding is allowed at all.
	Overridable bool
	Rule        DuplicateRule
}

// Any reports whether anything matched.
func (w DuplicateWarning) Any() bool { return len(w.Existing) > 0 }

// DetectDuplicates finds live orders a new one would repeat (SRS-ORD-009).
//
// Returns a warning rather than refusing. The requirement is unusually explicit
// about this — "show warning rather than arbitrary suppression" — and the
// reason is that the system is wrong often enough to matter: a repeat
// potassium four hours after the last one is a duplicate on a medical ward and
// correct management on a renal unit, and a system that suppressed it would be
// deciding a clinical question it cannot see.
func DetectDuplicates(candidate *Order, existing []*Order,
	rules map[Type]DuplicateRule, now time.Time) DuplicateWarning {

	rule, ok := rules[candidate.Type]
	if !ok || rule.Within <= 0 {
		return DuplicateWarning{}
	}

	cutoff := now.UTC().Add(-rule.Within)
	var matched []*Order
	for _, o := range existing {
		if o == nil || o.ID == candidate.ID {
			continue
		}
		if o.PatientID != candidate.PatientID || o.Type != candidate.Type {
			continue
		}
		// Completed and cancelled orders are not duplicates: the patient may
		// well need the test again, and warning about last week's finished
		// bloods is how a warning becomes noise.
		if !o.Live() {
			continue
		}
		if o.CreatedAt.Before(cutoff) {
			continue
		}
		if rule.SameCodeOnly &&
			(o.Code.System != candidate.Code.System ||
				o.Code.Code != candidate.Code.Code) {
			continue
		}
		matched = append(matched, o)
	}
	if len(matched) == 0 {
		return DuplicateWarning{}
	}
	sort.SliceStable(matched, func(i, j int) bool {
		return matched[i].CreatedAt.After(matched[j].CreatedAt)
	})
	return DuplicateWarning{
		Existing: matched, Overridable: rule.Overridable, Rule: rule,
	}
}

// OrderSet is an institutional bundle of orders (SRS-ORD-003).
type OrderSet struct {
	ID       string
	TenantID string
	Version  string
	Name     string
	// Specialty and indication narrow where the set is offered.
	Specialty string
	// Components are what the set offers. Each is individually selectable,
	// which is the requirement's word: a set that places all fifteen orders as
	// a unit is a set clinicians stop using, because the one they did not want
	// is the one that gets performed.
	Components []Component
	RetiredAt  time.Time
	CreatedBy  string
	CreatedAt  time.Time
}

// Component is one order a set offers.
type Component struct {
	ID   string
	Type Type
	Code Coding
	// Detail, Indication, Priority and Timing are the visible defaults
	// SRS-ORD-003 asks for. Defaults rather than fixed values: a clinician may
	// change any of them, and the set records what it suggested rather than
	// what was placed.
	Detail     string
	Indication string
	Priority   Priority
	Timing     Timing
	// SelectedByDefault is whether the box is ticked when the set opens. The
	// distinction that matters: an unticked component is offered, and a ticked
	// one is what the institution recommends.
	SelectedByDefault bool
	// Mandatory marks a component that cannot be unticked — a group-and-save
	// with a blood-product order, a pregnancy test before a CT. Rare and
	// deliberate: a set where everything is mandatory is a set with no
	// selection at all.
	Mandatory bool
}

// Validate rejects a set that could not be used.
func (s OrderSet) Validate() error {
	switch {
	case strings.TrimSpace(s.ID) == "":
		return invalidf("an order set needs an identifier")
	case strings.TrimSpace(s.Version) == "":
		// Without it, the provenance stored on an order points at a set whose
		// content has since changed.
		return invalidf("an order set needs a version")
	case strings.TrimSpace(s.Name) == "":
		return invalidf("an order set needs a name")
	case len(s.Components) == 0:
		return invalidf("an order set needs at least one component")
	}
	seen := map[string]bool{}
	for _, c := range s.Components {
		if strings.TrimSpace(c.ID) == "" {
			return invalidf("every order-set component needs an identifier")
		}
		if seen[c.ID] {
			return invalidf("component %q appears twice", c.ID)
		}
		seen[c.ID] = true
		if !knownTypes[c.Type] {
			return invalidf("component %q has unknown order type %q", c.ID, c.Type)
		}
		if err := c.Code.Validate(); err != nil {
			return err
		}
		if c.Priority != "" && !knownPriorities[c.Priority] {
			return invalidf("component %q has unknown priority %q", c.ID, c.Priority)
		}
		if err := c.Timing.Validate(); err != nil {
			return err
		}
		if c.Mandatory && !c.SelectedByDefault {
			// A mandatory component that starts unticked is a contradiction the
			// clinician resolves by not noticing it.
			return invalidf(
				"component %q is mandatory and must be selected by default", c.ID)
		}
	}
	return nil
}

// Retired reports whether a set may still be used.
func (s OrderSet) Retired() bool { return !s.RetiredAt.IsZero() }

// Component returns one component by identifier.
func (s OrderSet) Component(id string) (Component, bool) {
	for _, c := range s.Components {
		if c.ID == id {
			return c, true
		}
	}
	return Component{}, false
}

// Selection is what a clinician chose from a set.
type Selection struct {
	ComponentID string
	// Overrides let the clinician change a default. Empty fields keep the set's
	// suggestion.
	Detail     string
	Indication string
	Priority   Priority
	Timing     *Timing
}

// Expand turns a selection into order inputs (SRS-ORD-003).
//
// Every mandatory component is included whether or not the caller selected it,
// and the set's version travels onto each order as provenance. The orders come
// back as drafts and are placed through Submit like any other, which is how the
// set cannot bypass the policy either.
func (s OrderSet) Expand(base NewOrderInput, selections []Selection) (
	[]NewOrderInput, error) {

	if s.Retired() {
		return nil, notAllowedf("order set %s version %s has been retired",
			s.ID, s.Version)
	}

	chosen := map[string]Selection{}
	for _, sel := range selections {
		if _, ok := s.Component(sel.ComponentID); !ok {
			return nil, invalidf("order set %s has no component %q",
				s.ID, sel.ComponentID)
		}
		chosen[sel.ComponentID] = sel
	}

	var out []NewOrderInput
	for _, c := range s.Components {
		sel, selected := chosen[c.ID]
		if !selected && !c.Mandatory {
			continue
		}

		in := base
		in.Type = c.Type
		in.Code = c.Code
		in.Detail = c.Detail
		in.Indication = c.Indication
		in.Priority = c.Priority
		in.Timing = c.Timing
		// The set's version, not a reference to it: a set edited afterwards
		// must not restate what was ordered (SRS-ORD-003).
		in.OrderSetID = s.ID
		in.OrderSetVersion = s.Version

		if selected {
			if strings.TrimSpace(sel.Detail) != "" {
				in.Detail = sel.Detail
			}
			if strings.TrimSpace(sel.Indication) != "" {
				in.Indication = sel.Indication
			}
			if sel.Priority != "" {
				in.Priority = sel.Priority
			}
			if sel.Timing != nil {
				in.Timing = *sel.Timing
			}
		}
		out = append(out, in)
	}
	if len(out) == 0 {
		return nil, invalidf("nothing was selected from this order set")
	}
	return out, nil
}

// Favourite is one clinician's saved order (SRS-ORD-012).
//
// Personal, and deliberately a different type from OrderSet rather than a
// private one. An order set is institutional governance — reviewed, versioned,
// retired by a committee — and a favourite is somebody's shortcut. Making the
// second a variant of the first would put a consultant's preference into the
// governance the requirement says it must not bypass.
type Favourite struct {
	ID       string
	TenantID string
	// OwnerID is whose it is. A favourite is never shared: a shared shortcut
	// with no review is an order set that escaped governance.
	OwnerID string
	Name    string

	Type       Type
	Code       Coding
	Detail     string
	Indication string
	Priority   Priority
	Timing     Timing

	CreatedAt time.Time
	UpdatedAt time.Time
}

// Validate rejects a favourite that could not be used.
func (f Favourite) Validate() error {
	switch {
	case strings.TrimSpace(f.OwnerID) == "":
		return invalidf("a favourite belongs to somebody")
	case strings.TrimSpace(f.Name) == "":
		return invalidf("a favourite needs a name")
	case !knownTypes[f.Type]:
		return invalidf("unknown order type %q", f.Type)
	}
	if err := f.Code.Validate(); err != nil {
		return err
	}
	if f.Priority != "" && !knownPriorities[f.Priority] {
		return invalidf("unknown priority %q", f.Priority)
	}
	return f.Timing.Validate()
}

// Apply turns a favourite into an order input (SRS-ORD-012).
//
// Pre-filled values and nothing else. The resulting draft goes through Submit
// and therefore through the policy, so a favourite saved before the tenant made
// indications mandatory is refused rather than quietly placed — which is the
// whole of "personal preferences cannot bypass mandatory rules".
func (f Favourite) Apply(base NewOrderInput) NewOrderInput {
	in := base
	in.Type = f.Type
	in.Code = f.Code
	in.Detail = f.Detail
	in.Indication = f.Indication
	in.Priority = f.Priority
	in.Timing = f.Timing
	in.FavouriteID = f.ID
	return in
}
