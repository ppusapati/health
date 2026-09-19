package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// ContractKind is what a service agreement covers (SRS-BIO-002).
type ContractKind string

const (
	// ContractWarranty is the manufacturer's, included in the purchase.
	ContractWarranty ContractKind = "warranty"
	// ContractAMC is an annual maintenance contract: labour only.
	ContractAMC ContractKind = "amc"
	// ContractCMC is comprehensive: labour and parts. The distinction is the
	// one that decides who pays when a board fails, so it is not collapsed.
	ContractCMC ContractKind = "cmc"
)

var knownContractKinds = map[ContractKind]bool{
	ContractWarranty: true, ContractAMC: true, ContractCMC: true,
}

// CoversParts reports an agreement under which a replacement part is free.
func (k ContractKind) CoversParts() bool {
	return k == ContractWarranty || k == ContractCMC
}

// ServiceContract is a warranty, AMC or CMC (SRS-BIO-002).
type ServiceContract struct {
	ID       string
	TenantID string
	AssetID  string

	Kind      ContractKind
	Reference string

	VendorName    string
	VendorContact string
	VendorPhone   string
	VendorEmail   string

	StartsOn time.Time
	EndsOn   time.Time
	// ValueMinor is what the hospital pays for it, in minor units.
	ValueMinor int64
	// ResponseHours and ResolutionHours are what the vendor promised. They are
	// what a service request's SLA is derived from, so a ticket's clock comes
	// from the contract rather than from a number somebody typed.
	ResponseHours   int
	ResolutionHours int

	Notes     string
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewContractInput records a service agreement.
type NewContractInput struct {
	AssetID         string
	Kind            ContractKind
	Reference       string
	VendorName      string
	VendorContact   string
	VendorPhone     string
	VendorEmail     string
	StartsOn        time.Time
	EndsOn          time.Time
	ValueMinor      int64
	ResponseHours   int
	ResolutionHours int
	Notes           string
}

// NewServiceContract records a warranty, AMC or CMC (SRS-BIO-002).
func NewServiceContract(id, tenantID string, in NewContractInput, by string,
	now time.Time) (ServiceContract, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ServiceContract{}, fmt.Errorf("%w: a contract needs an id",
			ErrInvalidAsset)
	case strings.TrimSpace(in.AssetID) == "":
		return ServiceContract{}, fmt.Errorf("%w: a contract names its asset",
			ErrInvalidAsset)
	case !knownContractKinds[in.Kind]:
		return ServiceContract{}, fmt.Errorf("%w: unknown contract kind %q",
			ErrInvalidAsset, in.Kind)
	case strings.TrimSpace(in.VendorName) == "":
		// A contract with no vendor is one nobody can call when the machine
		// stops, which is the only moment it matters.
		return ServiceContract{}, fmt.Errorf("%w: a contract names its vendor",
			ErrInvalidAsset)
	case in.EndsOn.IsZero():
		// SRS-BIO-002's acceptance is that expiry reminders are generated. A
		// contract with no end date never expires and never reminds.
		return ServiceContract{}, fmt.Errorf("%w: a contract says when it ends",
			ErrInvalidAsset)
	case !in.StartsOn.IsZero() && !in.EndsOn.After(in.StartsOn):
		return ServiceContract{}, fmt.Errorf("%w: a contract ends after it starts",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return ServiceContract{}, fmt.Errorf("%w: a contract names who recorded it",
			ErrInvalidAsset)
	case in.ResponseHours < 0 || in.ResolutionHours < 0:
		return ServiceContract{}, fmt.Errorf("%w: an SLA is not negative",
			ErrInvalidAsset)
	}

	return ServiceContract{
		ID: id, TenantID: tenantID, AssetID: strings.TrimSpace(in.AssetID),
		Kind: in.Kind, Reference: strings.TrimSpace(in.Reference),
		VendorName:    strings.TrimSpace(in.VendorName),
		VendorContact: strings.TrimSpace(in.VendorContact),
		VendorPhone:   strings.TrimSpace(in.VendorPhone),
		VendorEmail:   strings.TrimSpace(in.VendorEmail),
		StartsOn:      in.StartsOn.UTC(), EndsOn: in.EndsOn.UTC(),
		ValueMinor:    in.ValueMinor,
		ResponseHours: in.ResponseHours, ResolutionHours: in.ResolutionHours,
		Notes:     strings.TrimSpace(in.Notes),
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// Live reports a contract in force at a moment.
func (c ServiceContract) Live(now time.Time) bool {
	if !c.StartsOn.IsZero() && now.Before(c.StartsOn) {
		return false
	}
	return now.Before(c.EndsOn)
}

// CoverFor picks the agreement that applies to an asset now (SRS-BIO-002).
//
// The most protective live contract, because a hospital that holds both a
// warranty and an AMC on one machine pays nothing under the warranty. Picking
// the first or the newest would invoice the hospital for a part somebody else
// owes.
func CoverFor(contracts []ServiceContract, assetID string,
	now time.Time) (ServiceContract, bool) {

	var best ServiceContract
	found := false
	for _, contract := range contracts {
		if contract.AssetID != assetID || !contract.Live(now) {
			continue
		}
		if !found || rankContract(contract.Kind) > rankContract(best.Kind) {
			best, found = contract, true
		}
	}
	return best, found
}

func rankContract(k ContractKind) int {
	switch k {
	case ContractWarranty:
		return 3
	case ContractCMC:
		return 2
	case ContractAMC:
		return 1
	default:
		return 0
	}
}

// Expiry is a contract or certificate coming due (SRS-BIO-002, SRS-BIO-004).
type Expiry struct {
	Kind string
	// AssetID and AssetTag so a reminder names the machine rather than a UUID.
	AssetID  string
	AssetTag string
	// Reference is the contract number or the calibration certificate.
	Reference  string
	VendorName string
	ExpiresOn  time.Time
	// DaysRemaining is negative once it has lapsed, so one list holds both
	// "renew this" and "this lapsed a month ago" and a reader can sort by it.
	DaysRemaining int
	Detail        string
}

// The kinds of expiry a reminder covers.
const (
	ExpiryContract    = "contract"
	ExpiryCalibration = "calibration"
)

// Expiries derives what is coming due (SRS-BIO-002, SRS-BIO-004).
//
// Derived on read, never stored. A stored reminder stays raised after the
// contract is renewed, and an engineer who has learned to ignore stale
// reminders ignores the real one too.
//
// A zero horizon reports only what has already lapsed. That is a deployment
// that has not decided how far ahead to look, and reporting nothing at all
// would hide the lapses too.
func Expiries(assets []Asset, contracts []ServiceContract,
	horizon time.Duration, now time.Time) []Expiry {

	tags := make(map[string]string, len(assets))
	for _, asset := range assets {
		tags[asset.ID] = asset.Tag
	}
	limit := now.Add(horizon)

	var out []Expiry
	for _, contract := range contracts {
		if contract.EndsOn.After(limit) {
			continue
		}
		// A contract on an asset that has left the hospital is not a renewal
		// anybody should be reminded about.
		if retired(assets, contract.AssetID) {
			continue
		}
		out = append(out, Expiry{
			Kind: ExpiryContract, AssetID: contract.AssetID,
			AssetTag: tags[contract.AssetID], Reference: contract.Reference,
			VendorName: contract.VendorName, ExpiresOn: contract.EndsOn,
			DaysRemaining: daysBetween(now, contract.EndsOn),
			Detail:        string(contract.Kind) + " with " + contract.VendorName,
		})
	}

	for _, asset := range assets {
		if !asset.CalibrationRequired || asset.Status.Retired() {
			continue
		}
		if asset.CalibrationDue.After(limit) {
			continue
		}
		out = append(out, Expiry{
			Kind: ExpiryCalibration, AssetID: asset.ID, AssetTag: asset.Tag,
			Reference:     asset.CalibrationCertificate,
			ExpiresOn:     asset.CalibrationDue,
			DaysRemaining: daysBetween(now, asset.CalibrationDue),
			Detail:        "calibration certificate",
		})
	}

	sort.Slice(out, func(i, j int) bool {
		if out[i].DaysRemaining != out[j].DaysRemaining {
			return out[i].DaysRemaining < out[j].DaysRemaining
		}
		return out[i].AssetTag < out[j].AssetTag
	})
	return out
}

func retired(assets []Asset, assetID string) bool {
	for _, asset := range assets {
		if asset.ID == assetID {
			return asset.Status.Retired()
		}
	}
	return false
}

func daysBetween(from, to time.Time) int {
	return int(to.Sub(from).Hours() / 24)
}

// PlanBasis is what makes preventive maintenance due (SRS-BIO-003).
type PlanBasis string

const (
	// BasisInterval is every so many days, whatever the machine did.
	BasisInterval PlanBasis = "interval"
	// BasisRuntime is every so many running hours, which is what wears a pump
	// out. Needs telemetry or a meter reading to be answerable.
	BasisRuntime PlanBasis = "runtime"
	// BasisRisk is a schedule set by the asset's criticality, which a hospital
	// uses where neither a calendar nor a meter fits.
	BasisRisk PlanBasis = "risk"
)

var knownPlanBases = map[PlanBasis]bool{
	BasisInterval: true, BasisRuntime: true, BasisRisk: true,
}

// PMPlan is a preventive maintenance schedule (SRS-BIO-003).
type PMPlan struct {
	ID       string
	TenantID string
	AssetID  string

	Basis PlanBasis
	// IntervalDays drives BasisInterval and BasisRisk.
	IntervalDays int
	// RuntimeHours drives BasisRuntime.
	RuntimeHours int

	// Procedure is what the engineer is meant to do. Carried because a plan
	// that says only "service it" produces a record that says only "serviced".
	Procedure string
	// EstimatedMinutes is what the planner books out.
	EstimatedMinutes int

	// LastPerformedAt and LastRuntimeHours are the baseline the next due date
	// is computed from.
	LastPerformedAt  time.Time
	LastRuntimeHours int

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewPlanInput schedules preventive maintenance.
type NewPlanInput struct {
	AssetID          string
	Basis            PlanBasis
	IntervalDays     int
	RuntimeHours     int
	Procedure        string
	EstimatedMinutes int
	LastPerformedAt  time.Time
	LastRuntimeHours int
}

// NewPMPlan schedules preventive maintenance (SRS-BIO-003).
func NewPMPlan(id, tenantID string, in NewPlanInput, by string,
	now time.Time) (PMPlan, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return PMPlan{}, fmt.Errorf("%w: a plan needs an id", ErrInvalidAsset)
	case strings.TrimSpace(in.AssetID) == "":
		return PMPlan{}, fmt.Errorf("%w: a plan names its asset", ErrInvalidAsset)
	case !knownPlanBases[in.Basis]:
		return PMPlan{}, fmt.Errorf("%w: unknown maintenance basis %q",
			ErrInvalidAsset, in.Basis)
	case strings.TrimSpace(in.Procedure) == "":
		// A plan that says only "service it" produces a record that says only
		// "serviced", which no inspection can check anything against.
		return PMPlan{}, fmt.Errorf("%w: a plan says what is to be done",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return PMPlan{}, fmt.Errorf("%w: a plan names who wrote it",
			ErrInvalidAsset)
	}

	switch in.Basis {
	case BasisInterval, BasisRisk:
		if in.IntervalDays <= 0 {
			return PMPlan{}, fmt.Errorf(
				"%w: a %s plan needs an interval in days", ErrInvalidAsset, in.Basis)
		}
	case BasisRuntime:
		if in.RuntimeHours <= 0 {
			return PMPlan{}, fmt.Errorf(
				"%w: a runtime plan needs an interval in hours", ErrInvalidAsset)
		}
	}

	last := in.LastPerformedAt
	if last.IsZero() {
		// A new plan is due one interval from now, not immediately: a hospital
		// that registers fifty assets on Monday should not find fifty
		// overdue services on Tuesday.
		last = now
	}

	return PMPlan{
		ID: id, TenantID: tenantID, AssetID: strings.TrimSpace(in.AssetID),
		Basis: in.Basis, IntervalDays: in.IntervalDays,
		RuntimeHours:     in.RuntimeHours,
		Procedure:        strings.TrimSpace(in.Procedure),
		EstimatedMinutes: in.EstimatedMinutes,
		LastPerformedAt:  last.UTC(), LastRuntimeHours: in.LastRuntimeHours,
		Active:    true,
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// DueState is where a planned service stands (SRS-BIO-003).
type DueState string

const (
	DueNotYet  DueState = "not_due"
	DueSoon    DueState = "due_soon"
	DueNow     DueState = "due"
	DueOverdue DueState = "overdue"
)

// Due is one planned service and where it stands.
type Due struct {
	PlanID      string
	AssetID     string
	AssetTag    string
	Basis       PlanBasis
	Procedure   string
	Criticality Criticality

	State DueState
	// DueOn is the calendar date for an interval or risk plan. Zero for a
	// runtime plan, where the answer is a number of hours rather than a date.
	DueOn time.Time
	// DaysOverdue is positive once it has passed. Negative counts down.
	DaysOverdue int
	// HoursRemaining is for a runtime plan: negative once the machine has run
	// past its service.
	HoursRemaining int

	// Unanswerable marks a runtime plan with no meter reading. Named rather
	// than reported as not-due, because "we do not know" and "it is fine" are
	// different answers and only one of them needs somebody to go and look.
	Unanswerable bool
}

// DueList derives what preventive maintenance is due (SRS-BIO-003).
//
// Derived on read. The acceptance is that the due list and the overdue state
// are reportable, and a stored due date drifts the moment somebody services
// the machine without closing the right record.
//
// soonWindow is how far ahead "due soon" reaches. Zero reports only what is
// due or overdue.
func DueList(plans []PMPlan, assets []Asset, runtime map[string]int,
	soonWindow time.Duration, now time.Time) []Due {

	index := make(map[string]Asset, len(assets))
	for _, asset := range assets {
		index[asset.ID] = asset
	}

	var out []Due
	for _, plan := range plans {
		if !plan.Active {
			continue
		}
		asset, known := index[plan.AssetID]
		if !known || asset.Status.Retired() {
			// A plan against an asset that has left the hospital is not work
			// anybody should be sent to do.
			continue
		}

		due := Due{
			PlanID: plan.ID, AssetID: plan.AssetID, AssetTag: asset.Tag,
			Basis: plan.Basis, Procedure: plan.Procedure,
			Criticality: asset.Criticality, State: DueNotYet,
		}

		switch plan.Basis {
		case BasisInterval, BasisRisk:
			due.DueOn = plan.LastPerformedAt.AddDate(0, 0, plan.IntervalDays)
			due.DaysOverdue = daysBetween(due.DueOn, now)
			switch {
			case now.After(due.DueOn):
				due.State = DueOverdue
			case now.Equal(due.DueOn):
				due.State = DueNow
			case soonWindow > 0 && due.DueOn.Before(now.Add(soonWindow)):
				due.State = DueSoon
			}
		case BasisRuntime:
			hours, told := runtime[plan.AssetID]
			if !told {
				// No meter reading. Saying so is the point: a runtime plan
				// reported as not-due because nobody read the meter is a
				// service that never happens.
				due.Unanswerable = true
				out = append(out, due)
				continue
			}
			run := hours - plan.LastRuntimeHours
			due.HoursRemaining = plan.RuntimeHours - run
			switch {
			case due.HoursRemaining < 0:
				due.State = DueOverdue
			case due.HoursRemaining == 0:
				due.State = DueNow
			case soonWindow > 0 &&
				due.HoursRemaining <= plan.RuntimeHours/10:
				// Within the last tenth of its interval. A proportion rather
				// than a fixed number of hours, because a plan every 200 hours
				// and one every 5,000 do not mean the same by "soon".
				due.State = DueSoon
			}
		}

		if due.State == DueNotYet && !due.Unanswerable {
			// Not due and answerable: not work, so not on the list.
			continue
		}
		out = append(out, due)
	}

	sort.Slice(out, func(i, j int) bool {
		// Most overdue first, and within a day the most critical asset.
		if out[i].DaysOverdue != out[j].DaysOverdue {
			return out[i].DaysOverdue > out[j].DaysOverdue
		}
		if out[i].Criticality.Rank() != out[j].Criticality.Rank() {
			return out[i].Criticality.Rank() > out[j].Criticality.Rank()
		}
		return out[i].AssetTag < out[j].AssetTag
	})
	return out
}
