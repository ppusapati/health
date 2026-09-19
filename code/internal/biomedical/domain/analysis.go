package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Reading is one telemetry sample (SRS-BIO-010).
//
// Append-only and its own record. SRS-BIO-010's acceptance is that telemetry
// does not overwrite maintenance records, and the shape that guarantees it is
// this one: a reading is never a field on a ticket or a plan. It can tell a
// planner that a pump has run 4,000 hours; it can never alter what an engineer
// wrote about the last repair.
type Reading struct {
	ID       string
	TenantID string
	AssetID  string

	// Metric is what was measured — "runtime_hours", "chamber_temperature_c".
	Metric string
	Value  float64
	Unit   string

	// Source is the device or gateway that reported it. Recorded because a
	// hand-entered meter reading and an ingested one are evidence of different
	// weight, and a planner deciding whether a service is due should be able
	// to see which this is.
	Source string
	// Ingested marks a reading that came from equipment rather than a
	// keyboard.
	Ingested bool

	ObservedAt time.Time
	RecordedAt time.Time
	RecordedBy string
}

// NewReadingInput records a telemetry sample.
type NewReadingInput struct {
	AssetID    string
	Metric     string
	Value      float64
	Unit       string
	Source     string
	Ingested   bool
	ObservedAt time.Time
}

// The metrics a runtime maintenance plan reads.
const MetricRuntimeHours = "runtime_hours"

// NewReading records a telemetry sample (SRS-BIO-010).
func NewReading(id, tenantID string, in NewReadingInput, by string,
	now time.Time) (Reading, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Reading{}, fmt.Errorf("%w: a reading needs an id", ErrInvalidAsset)
	case strings.TrimSpace(in.AssetID) == "":
		return Reading{}, fmt.Errorf("%w: a reading names its asset",
			ErrInvalidAsset)
	case strings.TrimSpace(in.Metric) == "":
		// A number with no metric is a number. Every plan and every chart
		// selects on this.
		return Reading{}, fmt.Errorf("%w: a reading names what it measured",
			ErrInvalidAsset)
	case strings.TrimSpace(by) == "":
		return Reading{}, fmt.Errorf("%w: a reading names who recorded it",
			ErrInvalidAsset)
	}

	observed := in.ObservedAt
	if observed.IsZero() {
		observed = now
	}
	if observed.After(now.Add(time.Hour)) {
		// A clock an hour ahead is a device with the wrong time, and a runtime
		// reading from the future would make a service look not due.
		return Reading{}, fmt.Errorf(
			"%w: this reading is dated in the future; check the device clock",
			ErrInvalidAsset)
	}

	return Reading{
		ID: id, TenantID: tenantID, AssetID: strings.TrimSpace(in.AssetID),
		Metric: strings.TrimSpace(in.Metric), Value: in.Value,
		Unit:   strings.TrimSpace(in.Unit),
		Source: strings.TrimSpace(in.Source), Ingested: in.Ingested,
		ObservedAt: observed.UTC(), RecordedAt: now.UTC(),
		RecordedBy: strings.TrimSpace(by),
	}, nil
}

// LatestRuntime is the most recent runtime reading per asset (SRS-BIO-003,
// SRS-BIO-010).
//
// What a runtime maintenance plan is measured against. Latest by observation
// rather than by recording, because a batch of readings uploaded after a
// network outage arrives out of order and the newest measurement is the one
// that matters.
func LatestRuntime(readings []Reading) map[string]int {
	latest := map[string]Reading{}
	for _, reading := range readings {
		if reading.Metric != MetricRuntimeHours {
			continue
		}
		existing, seen := latest[reading.AssetID]
		if !seen || reading.ObservedAt.After(existing.ObservedAt) {
			latest[reading.AssetID] = reading
		}
	}

	out := make(map[string]int, len(latest))
	for assetID, reading := range latest {
		out[assetID] = int(reading.Value)
	}
	return out
}

// Metrics are one asset's reliability figures (SRS-BIO-007).
//
// Every figure is derived from the service events at the moment it is asked
// for. The acceptance is that metrics reconcile to service events, and a
// stored metric is by construction not reconcilable: it is whatever the job
// that wrote it computed, from tickets that have since been re-opened,
// corrected or cancelled.
type Metrics struct {
	AssetID  string
	AssetTag string
	From     time.Time
	To       time.Time

	// PeriodMinutes is the window's length, which every percentage is over.
	PeriodMinutes   int
	DowntimeMinutes int
	UptimeMinutes   int
	// UptimePercent is uptime over the period. A hundred where nothing broke.
	UptimePercent float64

	// Failures counts breakdowns only. Planned work is not a failure, and
	// counting it would make a well-maintained machine look unreliable.
	Failures int
	// PlannedDowntimeMinutes is time out for scheduled work, reported beside
	// the unplanned kind rather than mixed into it: a department that takes a
	// machine out for a day to service it properly should not read the same
	// as one whose machine broke for a day.
	PlannedDowntimeMinutes int
	// MTBFHours is mean time between failures: uptime divided by the number of
	// failures. Zero failures gives zero rather than infinity, and the caller
	// reads it alongside Failures rather than as "never fails".
	MTBFHours float64
	// MTTRHours is mean time to repair: total downtime over the repairs that
	// finished. Only closed or resolved tickets count, because a machine still
	// broken has no repair time yet and including it would make MTTR fall
	// every time a ticket was left open.
	MTTRHours float64

	// PMDue and PMDone measure compliance over the window; PMCompliance is
	// done over due.
	PMDue        int
	PMDone       int
	PMCompliance float64

	// Incomplete names what a figure could not be built from, so a reader can
	// tell a real zero from a gap.
	Incomplete []string
}

// MetricsInput is what the reliability figures are computed from.
type MetricsInput struct {
	Asset   Asset
	From    time.Time
	To      time.Time
	Tickets []Ticket
	// Plans and CompletedPM measure preventive compliance: what fell due in
	// the window against what was done.
	Plans       []PMPlan
	CompletedPM []Ticket
}

// ComputeMetrics derives one asset's reliability figures (SRS-BIO-007).
func ComputeMetrics(in MetricsInput) Metrics {
	out := Metrics{
		AssetID: in.Asset.ID, AssetTag: in.Asset.Tag,
		From: in.From.UTC(), To: in.To.UTC(),
	}
	if !in.From.Before(in.To) {
		out.Incomplete = append(out.Incomplete,
			"the period has no length, so nothing could be measured")
		return out
	}
	out.PeriodMinutes = int(in.To.Sub(in.From).Minutes())

	var repairMinutes, repairs int
	for _, ticket := range in.Tickets {
		if ticket.AssetID != in.Asset.ID || ticket.DownFrom.IsZero() {
			continue
		}
		// Clipped to the window, so a machine that was down over a month
		// boundary counts its time in the month it was actually down.
		from := ticket.DownFrom
		if from.Before(in.From) {
			from = in.From
		}
		until := ticket.DownUntil
		if until.IsZero() {
			// Still down: counted to the end of the window, because a machine
			// that is broken now was broken for all of it.
			until = in.To
		}
		if until.After(in.To) {
			until = in.To
		}
		if !until.After(from) {
			continue
		}

		minutes := int(until.Sub(from).Minutes())
		if ticket.Kind.Planned() {
			// Real downtime, and not a failure. Kept apart so uptime can be
			// read either way and MTBF stays a measure of reliability.
			out.PlannedDowntimeMinutes += minutes
			continue
		}

		out.DowntimeMinutes += minutes
		out.Failures++

		if !ticket.DownUntil.IsZero() {
			repairMinutes += ticket.DowntimeMinutes(in.To)
			repairs++
		}
	}

	if out.DowntimeMinutes > out.PeriodMinutes {
		// Overlapping tickets on one machine. Clamped rather than reported as
		// more than a hundred per cent down, and named so a reader knows the
		// data is odd rather than the machine.
		out.DowntimeMinutes = out.PeriodMinutes
		out.Incomplete = append(out.Incomplete,
			"this asset had overlapping open tickets, so downtime is clamped "+
				"to the period")
	}
	out.UptimeMinutes = out.PeriodMinutes - out.DowntimeMinutes
	if out.PeriodMinutes > 0 {
		out.UptimePercent = float64(out.UptimeMinutes) /
			float64(out.PeriodMinutes) * 100
	}

	if out.Failures > 0 && out.UptimeMinutes > 0 {
		out.MTBFHours = float64(out.UptimeMinutes) / float64(out.Failures) / 60
	}
	if repairs > 0 {
		out.MTTRHours = float64(repairMinutes) / float64(repairs) / 60
	}

	out.PMDue, out.PMDone = pmCompliance(in)
	if out.PMDue > 0 {
		out.PMCompliance = float64(out.PMDone) / float64(out.PMDue) * 100
	}
	out.Incomplete = normalise(out.Incomplete)
	return out
}

// pmCompliance counts the preventive services that fell due against those
// done (SRS-BIO-007).
func pmCompliance(in MetricsInput) (due, done int) {
	for _, plan := range in.Plans {
		if plan.AssetID != in.Asset.ID || plan.Basis == BasisRuntime {
			// A runtime plan's due count depends on how hard the machine was
			// used, which is not answerable from the plan alone. Left out
			// rather than guessed at.
			continue
		}
		if plan.IntervalDays <= 0 {
			continue
		}
		// How many intervals fell inside the window. Counting starts one
		// interval after the last service, not at it: a plan serviced on the
		// first of the month is not also due that day, and starting at the
		// baseline would report one more service due than a hospital ever
		// owed.
		next := plan.LastPerformedAt.AddDate(0, 0, plan.IntervalDays)
		for next.Before(in.From) {
			next = next.AddDate(0, 0, plan.IntervalDays)
		}
		for !next.After(in.To) {
			due++
			next = next.AddDate(0, 0, plan.IntervalDays)
		}
	}

	planned := map[string]bool{}
	for _, plan := range in.Plans {
		if plan.AssetID == in.Asset.ID && plan.Basis != BasisRuntime {
			planned[plan.ID] = true
		}
	}

	for _, ticket := range in.CompletedPM {
		if ticket.AssetID != in.Asset.ID || !ticket.Kind.Planned() {
			continue
		}
		// Against one of the plans that were counted as due. A closed ticket
		// naming no plan — or a plan whose intervals were not counted — is
		// not evidence that a plan was followed, and counting it would make
		// compliance whatever anybody happened to label preventive.
		if !planned[ticket.PlanID] {
			continue
		}
		if ticket.ClosedAt.IsZero() || ticket.State != TicketClosed {
			continue
		}
		if ticket.ClosedAt.Before(in.From) || ticket.ClosedAt.After(in.To) {
			continue
		}
		done++
	}
	return due, done
}

// FleetLine is one asset in a reliability summary.
type FleetLine struct {
	AssetID     string
	AssetTag    string
	Criticality Criticality
	Metrics     Metrics
}

// Fleet summarises a set of assets, worst uptime first (SRS-BIO-007).
//
// Ordered by uptime rather than by failures, because a machine that failed
// once for a week is a worse problem than one that failed five times for an
// hour, and a list sorted the other way puts the wrong one at the top.
func Fleet(lines []FleetLine) []FleetLine {
	out := make([]FleetLine, len(lines))
	copy(out, lines)
	sort.Slice(out, func(i, j int) bool {
		if out[i].Metrics.UptimePercent != out[j].Metrics.UptimePercent {
			return out[i].Metrics.UptimePercent < out[j].Metrics.UptimePercent
		}
		if out[i].Criticality.Rank() != out[j].Criticality.Rank() {
			return out[i].Criticality.Rank() > out[j].Criticality.Rank()
		}
		return out[i].AssetTag < out[j].AssetTag
	})
	return out
}

// Disposal is an asset leaving the hospital (SRS-BIO-011).
type Disposal struct {
	ID       string
	TenantID string
	AssetID  string
	AssetTag string

	Method string
	Reason string

	// ApprovedBy is required, and is never the person who requested it: a
	// disposal signed off by whoever asked for it is not an approval.
	RequestedBy string
	ApprovedBy  string
	ApprovedAt  time.Time

	// SanitisationRequired is true for anything that held patient data.
	// SRS-BIO-011's clause is "data-sanitization evidence where applicable",
	// and this is what decides whether it applies.
	SanitisationRequired bool
	// SanitisationMethod and Certificate are the evidence. Required where
	// sanitisation is, because a disposal recorded without them is a hard
	// drive in a skip.
	SanitisationMethod      string
	SanitisationCertificate string
	SanitisedBy             string

	// Recipient is who took it: a recycler, a charity, a buyer.
	Recipient     string
	ProceedsMinor int64

	DisposedAt time.Time
	RecordedBy string
}

// DisposalInput records an asset leaving.
type DisposalInput struct {
	AssetID                 string
	Method                  string
	Reason                  string
	RequestedBy             string
	SanitisationRequired    bool
	SanitisationMethod      string
	SanitisationCertificate string
	SanitisedBy             string
	Recipient               string
	ProceedsMinor           int64
}

// Dispose records an asset leaving the hospital (SRS-BIO-011).
//
// The approver is not the requester, and sanitisation evidence is required
// where sanitisation is. Both are refusals rather than warnings: a disposal is
// the last thing that ever happens to a record, and anything missing at this
// point is missing for ever.
func Dispose(id, tenantID string, in DisposalInput, asset Asset,
	approvedBy string, now time.Time) (Disposal, Asset, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Disposal{}, asset, fmt.Errorf("%w: a disposal needs an id",
			ErrInvalidAsset)
	case asset.Status == AssetDisposed:
		return Disposal{}, asset, fmt.Errorf(
			"%w: %s has already been disposed of", ErrInvalidAsset, asset.Tag)
	case strings.TrimSpace(in.Method) == "":
		return Disposal{}, asset, fmt.Errorf("%w: a disposal records its method",
			ErrInvalidAsset)
	case strings.TrimSpace(in.Reason) == "":
		return Disposal{}, asset, fmt.Errorf("%w: a disposal says why",
			ErrInvalidAsset)
	case strings.TrimSpace(approvedBy) == "":
		return Disposal{}, asset, fmt.Errorf("%w: a disposal needs an approval",
			ErrInvalidAsset)
	case strings.TrimSpace(approvedBy) == strings.TrimSpace(in.RequestedBy):
		return Disposal{}, asset, fmt.Errorf(
			"%w: the person who requested a disposal does not approve it",
			ErrInvalidAsset)
	case in.ProceedsMinor < 0:
		return Disposal{}, asset, fmt.Errorf("%w: proceeds are not negative",
			ErrInvalidAsset)
	}

	if in.SanitisationRequired {
		switch {
		case strings.TrimSpace(in.SanitisationMethod) == "":
			return Disposal{}, asset, fmt.Errorf(
				"%w: %s held data; record how it was sanitised",
				ErrInvalidAsset, asset.Tag)
		case strings.TrimSpace(in.SanitisationCertificate) == "":
			// The evidence, not the claim. "We wiped it" is what everybody
			// says; a certificate is what an inspection can check.
			return Disposal{}, asset, fmt.Errorf(
				"%w: %s held data; record the sanitisation certificate",
				ErrInvalidAsset, asset.Tag)
		case strings.TrimSpace(in.SanitisedBy) == "":
			return Disposal{}, asset, fmt.Errorf(
				"%w: a sanitisation names who performed it", ErrInvalidAsset)
		}
	}

	disposed := asset
	disposed.Status = AssetDisposed
	// The location is cleared, so it stops contributing capability to a room
	// the moment it goes. SRS-BIO-009's "cannot be falsely shown as
	// schedulable" would otherwise survive the machine leaving the building.
	disposed.LocationID = ""
	disposed.SafetyHold, disposed.SafetyHoldReason = false, ""

	return Disposal{
		ID: id, TenantID: tenantID, AssetID: asset.ID, AssetTag: asset.Tag,
		Method:      strings.TrimSpace(in.Method),
		Reason:      strings.TrimSpace(in.Reason),
		RequestedBy: strings.TrimSpace(in.RequestedBy),
		ApprovedBy:  strings.TrimSpace(approvedBy), ApprovedAt: now.UTC(),
		SanitisationRequired:    in.SanitisationRequired,
		SanitisationMethod:      strings.TrimSpace(in.SanitisationMethod),
		SanitisationCertificate: strings.TrimSpace(in.SanitisationCertificate),
		SanitisedBy:             strings.TrimSpace(in.SanitisedBy),
		Recipient:               strings.TrimSpace(in.Recipient),
		ProceedsMinor:           in.ProceedsMinor,
		DisposedAt:              now.UTC(),
		RecordedBy:              strings.TrimSpace(approvedBy),
	}, disposed, nil
}
