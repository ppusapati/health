package domain

import (
	"sort"
	"strconv"
	"time"
)

// ChainLink is one step of the vein-to-vein chain (SRS-BLD-014).
type ChainLink struct {
	Stage string
	ID    string
	Label string
	At    time.Time
	By    string
}

// The stages of the chain, in the order blood travels.
const (
	StageDonor       = "donor"
	StageCollection  = "collection"
	StageComponent   = "component"
	StageTesting     = "testing"
	StageReservation = "reservation"
	StageIssue       = "issue"
	StageTransfusion = "transfusion"
	StageReaction    = "reaction"
	StageDisposal    = "disposal"
)

// Chain is the traceable history of one unit (SRS-BLD-014).
//
// The requirement's clause is "full vein-to-vein traceability where data
// exists", and "where data exists" is load-bearing: a unit bought in from a
// regional centre has no donor row here, and a chain that refused to render
// without one would be useless for exactly the units a recall is about.
type Chain struct {
	ComponentID string
	UnitNumber  string
	Links       []ChainLink
	// Gaps name the stages with no record, so a reader can tell "this unit was
	// never transfused" from "we have lost the transfusion record".
	Gaps []string
}

// BuildChain assembles a unit's chain from the records that exist
// (SRS-BLD-014).
func BuildChain(unit Component, donor *Donor, collection *Collection,
	tests []TestResult, reservations []Reservation, issues []Issue,
	episodes []Episode, reactions []Reaction) Chain {

	out := Chain{ComponentID: unit.ID, UnitNumber: unit.UnitNumber}

	if donor != nil {
		out.Links = append(out.Links, ChainLink{
			Stage: StageDonor, ID: donor.ID, Label: donor.DonorNumber,
			At: donor.RegisteredAt, By: donor.RegisteredBy,
		})
	} else if unit.Source != "" {
		// Not a gap: a unit received from a supplier has no donor here by
		// design, and the supplier is the provenance.
		out.Links = append(out.Links, ChainLink{
			Stage: StageDonor, Label: "received from " + unit.Source,
		})
	} else {
		out.Gaps = append(out.Gaps, StageDonor)
	}

	if collection != nil {
		out.Links = append(out.Links, ChainLink{
			Stage: StageCollection, ID: collection.ID,
			Label: collection.DonationNumber,
			At:    collection.CollectedAt, By: collection.CollectedBy,
		})
	} else {
		out.Gaps = append(out.Gaps, StageCollection)
	}

	out.Links = append(out.Links, ChainLink{
		Stage: StageComponent, ID: unit.ID, Label: unit.UnitNumber,
		At: unit.CreatedAt, By: unit.CreatedBy,
	})

	for _, test := range tests {
		label := test.Code
		if test.Reactive {
			label += " (reactive)"
		}
		out.Links = append(out.Links, ChainLink{
			Stage: StageTesting, ID: test.ID, Label: label,
			At: test.TestedAt, By: test.TestedBy,
		})
	}
	if len(tests) == 0 {
		out.Gaps = append(out.Gaps, StageTesting)
	}

	for _, reservation := range reservations {
		out.Links = append(out.Links, ChainLink{
			Stage: StageReservation, ID: reservation.ID,
			Label: reservation.PatientID,
			At:    reservation.ReservedAt, By: reservation.ReservedBy,
		})
	}
	for _, issue := range issues {
		label := issue.Destination
		if issue.Emergency {
			label += " (emergency release)"
		}
		out.Links = append(out.Links, ChainLink{
			Stage: StageIssue, ID: issue.ID, Label: label,
			At: issue.IssuedAt, By: issue.IssuedBy,
		})
	}
	for _, episode := range episodes {
		out.Links = append(out.Links, ChainLink{
			Stage: StageTransfusion, ID: episode.ID, Label: episode.PatientID,
			At: episode.StartedAt, By: episode.StartedBy,
		})
	}
	if len(episodes) == 0 && unit.Status == UnitTransfused {
		// The one inconsistency worth naming: the unit says it went into
		// somebody and no transfusion record says who.
		out.Gaps = append(out.Gaps, StageTransfusion)
	}
	for _, reaction := range reactions {
		out.Links = append(out.Links, ChainLink{
			Stage: StageReaction, ID: reaction.ID,
			Label: string(reaction.Severity),
			At:    reaction.ReportedAt, By: reaction.ReportedBy,
		})
	}

	sort.SliceStable(out.Links, func(i, j int) bool {
		return out.Links[i].At.Before(out.Links[j].At)
	})
	sort.Strings(out.Gaps)
	return out
}

// StockLevel is the count of allocatable units in one bucket (SRS-BLD-017).
type StockLevel struct {
	Class ComponentClass
	Group Group
	// Available is the count that could be issued now: allocatable status and
	// not expired. A count that included quarantined units would read as
	// comfortable stock that nobody can give.
	Available int
	// ExpiringSoon is the subset inside the alert horizon, which is the number
	// somebody has to act on: those units are about to become waste.
	ExpiringSoon int
	// Quarantined and Reserved are shown beside it, because a bank that is
	// short because everything is reserved has a different problem from one
	// that is short because nothing has been tested.
	Quarantined int
	Reserved    int
}

// StockThreshold is a configured minimum for one bucket (SRS-BLD-017).
type StockThreshold struct {
	Class ComponentClass
	Group Group
	// Minimum is the level below which an alert is raised.
	Minimum int
}

// StockAlertKind distinguishes the two things that go wrong with stock.
type StockAlertKind string

const (
	AlertLowStock StockAlertKind = "low_stock"
	AlertExpiring StockAlertKind = "expiring"
)

// StockAlert is one thing somebody has to do (SRS-BLD-017).
type StockAlert struct {
	Kind  StockAlertKind
	Class ComponentClass
	Group Group
	// Available and Minimum for a low-stock alert; Count and Horizon for an
	// expiry one. Both carried, because an alert a reader has to go and look
	// up the numbers for is an alert that gets dismissed.
	Available int
	Minimum   int
	Count     int
	Horizon   time.Duration
	Message   string
}

// DefaultExpiryHorizon is how far ahead an expiry alert looks when a
// deployment has not said.
//
// Three days: long enough that a unit can still be used somewhere, short
// enough that the list is worth reading.
const DefaultExpiryHorizon = 72 * time.Hour

// SummariseStock counts the inventory by component and group (SRS-BLD-005,
// SRS-BLD-017).
func SummariseStock(units []Component, horizon time.Duration,
	now time.Time) []StockLevel {

	if horizon <= 0 {
		horizon = DefaultExpiryHorizon
	}

	type key struct {
		class ComponentClass
		group Group
	}
	levels := map[key]*StockLevel{}
	at := func(k key) *StockLevel {
		if existing, ok := levels[k]; ok {
			return existing
		}
		level := &StockLevel{Class: k.class, Group: k.group}
		levels[k] = level
		return level
	}

	for _, unit := range units {
		k := key{unit.Class, unit.Group}
		level := at(k)
		switch {
		case unit.Status == UnitQuarantined:
			level.Quarantined++
		case unit.Status == UnitReserved:
			level.Reserved++
		case unit.Issuable(now):
			level.Available++
			if unit.ExpiresAt.Before(now.Add(horizon)) {
				level.ExpiringSoon++
			}
		}
	}

	out := make([]StockLevel, 0, len(levels))
	for _, level := range levels {
		out = append(out, *level)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Class != out[j].Class {
			return out[i].Class < out[j].Class
		}
		return out[i].Group.String() < out[j].Group.String()
	})
	return out
}

// StockAlerts raises the alerts a configured threshold asks for
// (SRS-BLD-017).
//
// Thresholds drive the low-stock alerts, so a bucket nobody has configured
// raises none: a bank that does not stock AB plasma should not be told daily
// that it has none. Expiry alerts need no threshold, because an expiring unit
// is waste whether or not anybody set a minimum.
func StockAlerts(levels []StockLevel, thresholds []StockThreshold,
	horizon time.Duration) []StockAlert {

	if horizon <= 0 {
		horizon = DefaultExpiryHorizon
	}

	minimums := map[string]int{}
	for _, threshold := range thresholds {
		minimums[string(threshold.Class)+"/"+threshold.Group.String()] =
			threshold.Minimum
	}

	var out []StockAlert
	for _, level := range levels {
		key := string(level.Class) + "/" + level.Group.String()
		if minimum, configured := minimums[key]; configured &&
			level.Available < minimum {
			out = append(out, StockAlert{
				Kind: AlertLowStock, Class: level.Class, Group: level.Group,
				Available: level.Available, Minimum: minimum,
				Message: level.Group.String() + " " + string(level.Class) +
					": " + itoa(level.Available) + " available, minimum " +
					itoa(minimum),
			})
		}
		if level.ExpiringSoon > 0 {
			out = append(out, StockAlert{
				Kind: AlertExpiring, Class: level.Class, Group: level.Group,
				Count: level.ExpiringSoon, Horizon: horizon,
				Message: itoa(level.ExpiringSoon) + " " + level.Group.String() +
					" " + string(level.Class) + " expiring soon",
			})
		}
	}
	return out
}

// Utilisation is the component utilisation report (SRS-BLD-015).
//
// Derived from the issue, transfusion and reaction records rather than
// maintained as counters: the requirement's clause is "reports derive from
// recorded issues/transfusions/reactions", and a counter drifts from the
// records it counts the first time anything is corrected.
type Utilisation struct {
	Issued     int
	Transfused int
	// Returned is issued-and-not-transfused, which is the number a blood bank
	// manages down: every returned unit spent time out of the fridge.
	Returned  int
	Discarded int
	Reactions int
	// EmergencyReleases and the subset still unreconciled, because
	// SRS-BLD-016's clause is "later reconciled" and an unreconciled release
	// is the finding.
	EmergencyReleases    int
	UnreconciledReleases int
	// CrossmatchToTransfusion is the C:T ratio, the number this report exists
	// for: reserving three units for every one given ties up a bank's stock.
	// Zero transfusions gives a zero ratio rather than an infinity, and
	// Reservations is carried so a reader can see why.
	Reservations            int
	CrossmatchToTransfusion float64
	// ByIndication counts transfusions against the reason they were requested,
	// which is what a utilisation review reads.
	ByIndication map[string]int
}

// SummariseUtilisation derives the report (SRS-BLD-015).
//
// Reservations is a count rather than the rows, because it is the only input
// the report uses purely as a number: the C:T ratio needs how many units were
// crossmatched, not which. Passing the rows would mean loading every
// reservation in the period to call len() on them.
func SummariseUtilisation(issues []Issue, episodes []Episode,
	reactions []Reaction, reservations int,
	indications map[string]string, discarded int) Utilisation {

	out := Utilisation{
		Discarded: discarded, Reactions: len(reactions),
		Reservations: reservations,
		ByIndication: map[string]int{},
	}

	transfusedUnits := map[string]bool{}
	for _, episode := range episodes {
		if episode.Status != EpisodeCompleted && episode.Status != EpisodeStopped {
			// A running transfusion has not been given yet. Counting it would
			// make the report disagree with itself an hour later.
			continue
		}
		out.Transfused++
		transfusedUnits[episode.ComponentID] = true
		if indication := indications[episode.ComponentID]; indication != "" {
			out.ByIndication[indication]++
		}
	}

	for _, issue := range issues {
		out.Issued++
		if issue.Emergency {
			out.EmergencyReleases++
			if !issue.Reconciled {
				out.UnreconciledReleases++
			}
		}
		if !transfusedUnits[issue.ComponentID] {
			out.Returned++
		}
	}

	if out.Transfused > 0 {
		out.CrossmatchToTransfusion =
			float64(out.Reservations) / float64(out.Transfused)
	}
	return out
}

// itoa keeps alert messages readable.
func itoa(n int) string { return strconv.Itoa(n) }
