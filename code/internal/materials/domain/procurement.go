package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// RequisitionSource is what raised a request (SRS-MAT-001).
//
// Recorded because the four have different review: a manual request is
// somebody's judgement, a min-max suggestion is the system's arithmetic, and
// a procedure-driven one is a commitment already made in a theatre list.
// Collapsing them would make it impossible to ask whether the replenishment
// rules are any good.
type RequisitionSource string

const (
	SourceManual RequisitionSource = "manual"
	// SourceMinMax is raised by the reorder calculation (SRS-MAT-012).
	SourceMinMax RequisitionSource = "min_max"
	// SourceProcedure is raised from a booked case's preference card.
	SourceProcedure RequisitionSource = "procedure"
	// SourceReplenishment is a signal from a ward's par level.
	SourceReplenishment RequisitionSource = "replenishment"
)

var knownSources = map[RequisitionSource]bool{
	SourceManual: true, SourceMinMax: true,
	SourceProcedure: true, SourceReplenishment: true,
}

// RequisitionState is where a request has got to.
type RequisitionState string

const (
	RequisitionDraft    RequisitionState = "draft"
	RequisitionPending  RequisitionState = "pending_approval"
	RequisitionApproved RequisitionState = "approved"
	RequisitionRejected RequisitionState = "rejected"
	// RequisitionOrdered means a purchase order has been raised from it.
	RequisitionOrdered   RequisitionState = "ordered"
	RequisitionCancelled RequisitionState = "cancelled"
)

// RequisitionLine is one item wanted.
type RequisitionLine struct {
	ItemID   string
	ItemCode string
	Quantity int
	UOM      string
	// EstimatedUnitPrice is what the route is costed on before any quote
	// exists. Zero is allowed and routes at zero value, which is a decision
	// the approval rules can see rather than a hidden default.
	EstimatedUnitPrice Money
	Notes              string
}

// Money is an amount in minor units, with its currency.
//
// Minor units and an integer, never a float: a rupee is 100 paise and a
// float would make two identical orders total differently. The currency
// travels with the amount because a hospital buys from more than one country
// and an amount with no currency is a number somebody will add to the wrong
// total.
type Money struct {
	Minor    int64
	Currency string
}

// Add returns the sum, refusing a mixed-currency total.
func (m Money) Add(other Money) (Money, error) {
	switch {
	case m.Currency == "":
		return other, nil
	case other.Currency == "":
		return m, nil
	case m.Currency != other.Currency:
		// Silently adding them would produce a number that looks like money
		// and is not, and it would be the number an approval threshold is
		// compared against.
		return Money{}, fmt.Errorf("%w: cannot add %s to %s",
			ErrInvalidMaterials, other.Currency, m.Currency)
	}
	return Money{Minor: m.Minor + other.Minor, Currency: m.Currency}, nil
}

// Times multiplies by a count.
func (m Money) Times(n int) Money {
	return Money{Minor: m.Minor * int64(n), Currency: m.Currency}
}

// Requisition is a request to buy (SRS-MAT-001).
type Requisition struct {
	ID       string
	TenantID string

	Number     string
	FacilityID string
	// Source, NeedBy and CostCentre are the three the acceptance names.
	Source     RequisitionSource
	NeedBy     time.Time
	CostCentre string
	// SourceReference points at what raised it: the case, the stock level,
	// the ward par. Empty for a manual request, which is its own explanation.
	SourceReference string

	Lines []RequisitionLine
	State RequisitionState
	// Approvals is the immutable chain (SRS-MAT-002). Appended, never
	// rewritten: an approval history that can be edited is not a history.
	Approvals []ApprovalStep

	Justification string
	RaisedAt      time.Time
	RaisedBy      string
	Version       int64
}

// NewRequisitionInput raises a request.
type NewRequisitionInput struct {
	Number          string
	FacilityID      string
	Source          RequisitionSource
	NeedBy          time.Time
	CostCentre      string
	SourceReference string
	Lines           []RequisitionLine
	Justification   string
}

// NewRequisition raises a request to buy (SRS-MAT-001).
func NewRequisition(id, tenantID string, in NewRequisitionInput, by string,
	now time.Time) (Requisition, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Requisition{}, fmt.Errorf("%w: a requisition needs an id",
			ErrInvalidMaterials)
	case strings.TrimSpace(in.CostCentre) == "":
		// The acceptance names it, and the reason is that a request with no
		// cost centre is one nobody's budget carries and nobody reviews.
		return Requisition{}, fmt.Errorf(
			"%w: a requisition names the cost centre it is against",
			ErrInvalidMaterials)
	case in.NeedBy.IsZero():
		// Without it, every request is equally urgent, which means none is.
		return Requisition{}, fmt.Errorf("%w: a requisition says when it is needed by",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return Requisition{}, fmt.Errorf("%w: a requisition names who raised it",
			ErrInvalidMaterials)
	}

	source := in.Source
	if source == "" {
		source = SourceManual
	}
	if !knownSources[source] {
		return Requisition{}, fmt.Errorf("%w: unknown requisition source %q",
			ErrInvalidMaterials, source)
	}

	lines, err := checkedRequisitionLines(in.Lines)
	if err != nil {
		return Requisition{}, err
	}

	return Requisition{
		ID: id, TenantID: tenantID,
		Number:     strings.TrimSpace(in.Number),
		FacilityID: strings.TrimSpace(in.FacilityID),
		Source:     source, NeedBy: in.NeedBy.UTC(),
		CostCentre:      strings.TrimSpace(in.CostCentre),
		SourceReference: strings.TrimSpace(in.SourceReference),
		Lines:           lines, State: RequisitionDraft,
		Justification: strings.TrimSpace(in.Justification),
		RaisedAt:      now.UTC(), RaisedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

func checkedRequisitionLines(in []RequisitionLine) ([]RequisitionLine, error) {
	if len(in) == 0 {
		return nil, fmt.Errorf("%w: a requisition asks for something",
			ErrInvalidMaterials)
	}
	seen := map[string]bool{}
	out := make([]RequisitionLine, 0, len(in))
	for _, line := range in {
		itemID := strings.TrimSpace(line.ItemID)
		switch {
		case itemID == "":
			return nil, fmt.Errorf("%w: a requisition line names its item",
				ErrInvalidMaterials)
		case seen[itemID]:
			// Two lines for one item make the quantity ambiguous, and the
			// purchase order built from it would order one of them.
			return nil, fmt.Errorf("%w: %s appears twice on this requisition",
				ErrInvalidMaterials, line.ItemCode)
		case line.Quantity <= 0:
			return nil, fmt.Errorf("%w: %s is asked for with no quantity",
				ErrInvalidMaterials, line.ItemCode)
		}
		seen[itemID] = true
		out = append(out, RequisitionLine{
			ItemID: itemID, ItemCode: strings.TrimSpace(line.ItemCode),
			Quantity: line.Quantity, UOM: strings.TrimSpace(line.UOM),
			EstimatedUnitPrice: line.EstimatedUnitPrice,
			Notes:              strings.TrimSpace(line.Notes),
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].ItemID < out[j].ItemID })
	return out, nil
}

// EstimatedValue totals the request, which is what the route is chosen on.
func (r Requisition) EstimatedValue() (Money, error) {
	total := Money{}
	for _, line := range r.Lines {
		var err error
		total, err = total.Add(line.EstimatedUnitPrice.Times(line.Quantity))
		if err != nil {
			return Money{}, err
		}
	}
	return total, nil
}

// Categories names the item categories on the request, which the route also
// reads.
func (r Requisition) Categories(items map[string]Item) []string {
	var out []string
	for _, line := range r.Lines {
		if item, known := items[line.ItemID]; known {
			out = append(out, item.Category)
		}
	}
	return sortedCodes(out)
}

// ApprovalDecision is what an approver said.
type ApprovalDecision string

const (
	ApprovalApproved ApprovalDecision = "approved"
	ApprovalRejected ApprovalDecision = "rejected"
)

// ApprovalStep is one immutable entry in an approval chain (SRS-MAT-002).
//
// Appended and never changed. The acceptance is "approval history is
// immutable", and the reason is the one every finance control has: an approval
// that can be edited afterwards is indistinguishable from one that was never
// given.
type ApprovalStep struct {
	ID string
	// Level is the position in the route, from one. A rejected step ends the
	// chain, so levels are contiguous and a gap means a step was lost.
	Level int
	// Role is who was required, and Decider is who actually decided. Both,
	// because "the head of department approved it" and "somebody with the
	// head of department's permission approved it" are different claims.
	Role     string
	Decision ApprovalDecision
	Decider  string
	Note     string
	At       time.Time
}

// ApprovalRule routes a requisition (SRS-MAT-002).
//
// Configurable per the requirement: amount, category and facility. A rule with
// none of the three matches everything, which is how a deployment expresses
// "everything needs the storekeeper".
type ApprovalRule struct {
	ID       string
	TenantID string

	// MinimumValue is the threshold this rule applies from, in minor units.
	// Zero applies from nothing.
	MinimumValue int64
	Currency     string
	// Category and FacilityID narrow the rule. Empty matches any.
	Category   string
	FacilityID string

	// Roles are the approvals required, in order. The chain is the whole of
	// the route: a rule with no roles approves nothing and is refused rather
	// than silently letting everything through.
	Roles []string
}

// Validate refuses a rule that could not route anything.
func (r ApprovalRule) Validate() error {
	switch {
	case len(r.Roles) == 0:
		// The failure this prevents is the dangerous one: a rule that matches
		// and requires nobody approves every request it touches.
		return fmt.Errorf("%w: an approval rule names who must approve",
			ErrInvalidMaterials)
	case r.MinimumValue < 0:
		return fmt.Errorf("%w: an approval threshold is not negative",
			ErrInvalidMaterials)
	}
	for _, role := range r.Roles {
		if strings.TrimSpace(role) == "" {
			return fmt.Errorf("%w: an approval step names a role",
				ErrInvalidMaterials)
		}
	}
	return nil
}

// Route picks the chain a requisition must pass (SRS-MAT-002).
//
// Every matching rule contributes its roles, in threshold order, de-duplicated
// while keeping the first occurrence. A hospital's rules are written as
// "anything over fifty thousand also needs finance", not as a separate
// complete chain per bracket, and reading them the second way would drop the
// storekeeper from every large order.
//
// An empty route is returned rather than treated as "approved": the caller
// decides whether an unrouted request is one nobody configured or one that
// genuinely needs nobody, and that is a decision with a name on it.
func Route(rules []ApprovalRule, value Money, categories []string,
	facilityID string) []string {

	matching := make([]ApprovalRule, 0, len(rules))
	for _, rule := range rules {
		if !rule.matches(value, categories, facilityID) {
			continue
		}
		matching = append(matching, rule)
	}
	sort.SliceStable(matching, func(i, j int) bool {
		return matching[i].MinimumValue < matching[j].MinimumValue
	})

	seen := map[string]bool{}
	var out []string
	for _, rule := range matching {
		for _, role := range rule.Roles {
			role = strings.TrimSpace(role)
			if role == "" || seen[role] {
				continue
			}
			seen[role] = true
			out = append(out, role)
		}
	}
	return out
}

func (r ApprovalRule) matches(value Money, categories []string,
	facilityID string) bool {

	if r.FacilityID != "" && r.FacilityID != facilityID {
		return false
	}
	if r.Category != "" {
		found := false
		for _, category := range categories {
			if category == r.Category {
				found = true
				break
			}
		}
		if !found {
			return false
		}
	}
	if r.MinimumValue > 0 {
		if r.Currency != "" && value.Currency != "" && r.Currency != value.Currency {
			// A threshold in one currency says nothing about an amount in
			// another. Not matching is the safe direction: the request stays
			// unrouted and visible rather than quietly approved.
			return false
		}
		if value.Minor < r.MinimumValue {
			return false
		}
	}
	return true
}

// Submit sends a requisition for approval (SRS-MAT-002).
func (r *Requisition) Submit(route []string, now time.Time) error {
	switch {
	case r.State != RequisitionDraft:
		return fmt.Errorf("%w: this requisition is %s", ErrInvalidMaterials, r.State)
	case len(route) == 0:
		// A request that matched no rule is not a request nobody has to
		// approve: it is a configuration gap, and approving it silently is
		// how a hospital discovers its rules were empty by reading an
		// invoice.
		return fmt.Errorf(
			"%w: no approval rule covers this requisition; configure a route "+
				"before it can be submitted", ErrInvalidMaterials)
	}
	r.State = RequisitionPending
	return nil
}

// Decide records one approval or rejection (SRS-MAT-002).
//
// Appends. The chain is never rewritten and a step is never revisited: an
// approver who changes their mind records a second decision on a new
// requisition, because the first one is what somebody acted on.
func (r *Requisition) Decide(id string, route []string,
	decision ApprovalDecision, decider, role, note string,
	now time.Time) (ApprovalStep, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ApprovalStep{}, fmt.Errorf("%w: an approval needs an id",
			ErrInvalidMaterials)
	case r.State != RequisitionPending:
		return ApprovalStep{}, fmt.Errorf("%w: this requisition is %s",
			ErrInvalidMaterials, r.State)
	case decision != ApprovalApproved && decision != ApprovalRejected:
		return ApprovalStep{}, fmt.Errorf("%w: unknown approval decision %q",
			ErrInvalidMaterials, decision)
	case strings.TrimSpace(decider) == "":
		return ApprovalStep{}, fmt.Errorf("%w: an approval names who decided",
			ErrInvalidMaterials)
	case decision == ApprovalRejected && strings.TrimSpace(note) == "":
		// A rejection with no reason sends the requester back to guess, and
		// they will raise it again unchanged.
		return ApprovalStep{}, fmt.Errorf("%w: a rejection says why",
			ErrInvalidMaterials)
	}

	level := len(r.Approvals) + 1
	if level > len(route) {
		return ApprovalStep{}, fmt.Errorf(
			"%w: this requisition has all %d approvals it needs",
			ErrInvalidMaterials, len(route))
	}
	expected := route[level-1]
	if strings.TrimSpace(role) != expected {
		// The route is an order, not a set. Letting finance sign before the
		// head of department means the head of department never sees it.
		return ApprovalStep{}, fmt.Errorf("%w: step %d of this route is %s, not %s",
			ErrInvalidMaterials, level, expected, role)
	}
	if decider == r.RaisedBy {
		// Self-approval. The domain refuses it rather than leaving it to a
		// permission model, because the permission that routes to a role is
		// held by many people and one of them raised this.
		return ApprovalStep{}, fmt.Errorf(
			"%w: the person who raised a requisition does not approve it",
			ErrInvalidMaterials)
	}

	step := ApprovalStep{
		ID: strings.TrimSpace(id), Level: level, Role: expected,
		Decision: decision, Decider: strings.TrimSpace(decider),
		Note: strings.TrimSpace(note), At: now.UTC(),
	}
	r.Approvals = append(r.Approvals, step)

	switch {
	case decision == ApprovalRejected:
		r.State = RequisitionRejected
	case level == len(route):
		r.State = RequisitionApproved
	}
	return step, nil
}

// Bid is one supplier's response to an RFQ (SRS-MAT-003).
type Bid struct {
	ID         string
	TenantID   string
	RFQID      string
	SupplierID string

	Lines []BidLine
	// LeadTimeDays and WarrantyMonths are commercial terms a comparison has to
	// normalise: a cheaper quote that arrives three weeks later is not
	// cheaper for a hospital that needs it on Thursday.
	LeadTimeDays     int
	WarrantyMonths   int
	PaymentTermsDays int
	// FreightMinor and TaxMinor are added to the line total, because a quote
	// that excludes them is not comparable with one that includes them.
	FreightMinor int64
	TaxMinor     int64
	Currency     string

	Notes      string
	ReceivedAt time.Time
	RecordedBy string
}

// BidLine is one item priced.
type BidLine struct {
	ItemID    string
	UnitPrice Money
	Quantity  int
	// PackSize is how many stock units one purchase unit holds. A quote per
	// box of a hundred and a quote per piece are the same quote until
	// somebody forgets, and then they are two orders of magnitude apart.
	PackSize int
}

// RFQ is a request for quotation (SRS-MAT-003).
type RFQ struct {
	ID       string
	TenantID string

	Number        string
	RequisitionID string
	// SupplierIDs are who was asked. Recorded because "we went to three
	// suppliers" is the claim a procurement audit checks.
	SupplierIDs []string
	Lines       []RequisitionLine
	ClosesAt    time.Time

	IssuedAt time.Time
	IssuedBy string
	Version  int64
}

// NewRFQInput opens a quotation round.
type NewRFQInput struct {
	Number        string
	RequisitionID string
	SupplierIDs   []string
	Lines         []RequisitionLine
	ClosesAt      time.Time
}

// NewRFQ opens a quotation round to approved suppliers (SRS-MAT-003).
func NewRFQ(id, tenantID string, in NewRFQInput, suppliers map[string]Supplier,
	by string, now time.Time) (RFQ, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RFQ{}, fmt.Errorf("%w: an RFQ needs an id", ErrInvalidMaterials)
	case len(in.SupplierIDs) == 0:
		return RFQ{}, fmt.Errorf("%w: an RFQ goes to somebody",
			ErrInvalidMaterials)
	case strings.TrimSpace(by) == "":
		return RFQ{}, fmt.Errorf("%w: an RFQ names who issued it",
			ErrInvalidMaterials)
	}

	for _, supplierID := range in.SupplierIDs {
		supplier, known := suppliers[supplierID]
		switch {
		case !known:
			return RFQ{}, fmt.Errorf("%w: no such supplier", ErrInvalidMaterials)
		case !supplier.Approved:
			// SRS-MAT-003 says approved suppliers, and an unapproved one
			// quoted is an unapproved one that will be ordered from.
			return RFQ{}, fmt.Errorf("%w: %s is not an approved supplier",
				ErrInvalidMaterials, supplier.Code)
		}
	}

	lines, err := checkedRequisitionLines(in.Lines)
	if err != nil {
		return RFQ{}, err
	}

	return RFQ{
		ID: id, TenantID: tenantID,
		Number:        strings.TrimSpace(in.Number),
		RequisitionID: strings.TrimSpace(in.RequisitionID),
		SupplierIDs:   sortedCodes(in.SupplierIDs),
		Lines:         lines, ClosesAt: in.ClosesAt.UTC(),
		IssuedAt: now.UTC(), IssuedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Comparison is one bid reduced to comparable terms (SRS-MAT-003).
type Comparison struct {
	BidID      string
	SupplierID string
	// LandedMinor is the whole cost of the quoted quantities: price times
	// quantity, plus freight, plus tax. The number two quotes are actually
	// compared on.
	LandedMinor int64
	Currency    string
	// UnitMinor is landed cost per stock unit, which is what makes a quote
	// per box comparable with a quote per piece.
	UnitMinor int64
	// LeadTimeDays and PaymentTermsDays are carried rather than scored: how a
	// hospital weighs three weeks against three per cent is its decision, and
	// a ranking that buried it would be a decision this code made instead.
	LeadTimeDays     int
	PaymentTermsDays int
	WarrantyMonths   int
	// Incomparable names why a bid could not be normalised, so a buyer sees
	// "quoted in USD" rather than a row that quietly sorted last.
	Incomparable []string
}

// Compare normalises bids onto the same commercial terms (SRS-MAT-003).
//
// The acceptance is "bid comparison uses normalized commercial terms", and the
// normalising that matters is the boring kind: pack sizes, freight, tax and
// currency. A comparison that ranked on headline unit price would recommend
// the quote per box against the quote per piece, every time, by a factor of
// the pack size.
//
// It returns the comparison, not a winner. Which quote to accept weighs lead
// time against price against a relationship, and that is a buyer's judgement
// recorded against their name.
func Compare(bids []Bid) []Comparison {
	out := make([]Comparison, 0, len(bids))
	for _, bid := range bids {
		comparison := Comparison{
			BidID: bid.ID, SupplierID: bid.SupplierID,
			Currency:         bid.Currency,
			LeadTimeDays:     bid.LeadTimeDays,
			PaymentTermsDays: bid.PaymentTermsDays,
			WarrantyMonths:   bid.WarrantyMonths,
		}

		var landed int64
		var units int64
		for _, line := range bid.Lines {
			if line.UnitPrice.Currency != "" && bid.Currency != "" &&
				line.UnitPrice.Currency != bid.Currency {
				comparison.Incomparable = append(comparison.Incomparable,
					"a line is quoted in "+line.UnitPrice.Currency+
						" and the bid in "+bid.Currency)
				continue
			}
			landed += line.UnitPrice.Minor * int64(line.Quantity)

			pack := line.PackSize
			if pack <= 0 {
				// Assuming one would make a quote per box look like a quote
				// per piece. Saying so leaves the buyer with a number they
				// can check rather than one that is quietly wrong.
				comparison.Incomparable = append(comparison.Incomparable,
					"a line does not say how many stock units are in a pack")
				pack = 1
			}
			units += int64(line.Quantity) * int64(pack)
		}
		landed += bid.FreightMinor + bid.TaxMinor
		comparison.LandedMinor = landed
		if units > 0 {
			comparison.UnitMinor = landed / units
		}
		comparison.Incomparable = sortedCodes(comparison.Incomparable)
		out = append(out, comparison)
	}

	sort.SliceStable(out, func(i, j int) bool {
		// Comparable bids first, then by landed cost. A bid nobody could
		// normalise is not cheapest just because its total parsed to a small
		// number.
		ai, bi := len(out[i].Incomparable) > 0, len(out[j].Incomparable) > 0
		if ai != bi {
			return bi
		}
		return out[i].LandedMinor < out[j].LandedMinor
	})
	return out
}
