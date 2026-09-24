package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// OutageState is where a planned shutdown stands (SRS-FAC-004).
type OutageState string

const (
	// OutagePlanned has been requested and not yet permitted.
	OutagePlanned OutageState = "planned"
	// OutageApproved has its permit. The areas have been told.
	OutageApproved OutageState = "approved"
	// OutageInEffect means the supply is actually off.
	OutageInEffect  OutageState = "in_effect"
	OutageRestored  OutageState = "restored"
	OutageCancelled OutageState = "cancelled"
)

var knownOutageState = map[OutageState]bool{
	OutagePlanned: true, OutageApproved: true, OutageInEffect: true,
	OutageRestored: true, OutageCancelled: true,
}

// Live reports whether an outage is still going to happen or is happening.
func (s OutageState) Live() bool {
	return s == OutagePlanned || s == OutageApproved || s == OutageInEffect
}

// Outage is a utility shutdown permit and the planned interruption it covers
// (SRS-FAC-004).
//
// The permit and the outage are one record rather than two because they are
// one decision: a hospital does not issue a shutdown permit and then decide
// separately whether to shut anything down. What is genuinely separate — and
// is a second table — is who it affects.
type Outage struct {
	ID       string
	TenantID string
	// Reference is the permit number the estates office writes in its
	// book.
	Reference  string
	FacilityID string

	System System
	Title  string
	// Reason is why the supply has to go off, which is the part a ward
	// asks about when it objects.
	Reason string

	PlannedFrom time.Time
	PlannedTo   time.Time
	ActualFrom  time.Time
	ActualTo    time.Time

	State OutageState

	RequestedBy string
	RequestedAt time.Time
	ApprovedBy  string
	ApprovedAt  time.Time
	// PermitRef is the safety permit under which the isolation is done,
	// which is not the same as this outage's own reference: the first is
	// estates paperwork, the second is the permit-to-work system.
	PermitRef string

	// Contingency is what covers the affected areas while the supply is
	// off — the standby generator, the portable chiller, the cylinder
	// manifold. Required before approval: an outage with no contingency
	// over a critical area is a decision nobody has actually made.
	Contingency string

	RestoredBy   string
	CancelReason string

	CreatedAt time.Time
	Version   int64
}

// OutageArea is one department a shutdown reaches (SRS-FAC-004).
//
// A row per area rather than a list on the outage, because the acceptance is
// that impacted departments receive a notification, and a notification has a
// recipient, a time and an acknowledgement. None of those fit in a string
// array.
type OutageArea struct {
	ID       string
	TenantID string
	OutageID string

	OrgUnitID string
	Name      string
	// Critical marks an area that cannot simply be told: theatres, ICU,
	// dialysis, the blood bank's fridges. A critical area has to answer
	// before the supply goes off.
	Critical bool

	// OutageSystem and OutageState are copied from the outage. They exist
	// so the database can hold two rules it otherwise could not: that two
	// live shutdowns of the same system cannot cover the same department,
	// and that an area row cannot drift from the outage it belongs to. A
	// composite foreign key with ON UPDATE CASCADE keeps the copies
	// correct — an outage taking effect rewrites its own area rows.
	OutageSystem System
	OutageState  OutageState

	NotifiedAt     time.Time
	AcknowledgedAt time.Time
	AcknowledgedBy string
	// Objection is what the area said if it said no. Recorded rather than
	// enforced: a ward cannot veto a statutory shutdown, but the
	// objection being on the record changes how the conversation goes.
	Objection string

	CreatedAt time.Time
	Version   int64
}

// Acknowledged reports whether the area has answered.
func (a OutageArea) Acknowledged() bool { return !a.AcknowledgedAt.IsZero() }

// PlanOutageInput requests a utility shutdown.
type PlanOutageInput struct {
	Reference   string
	FacilityID  string
	System      System
	Title       string
	Reason      string
	PlannedFrom time.Time
	PlannedTo   time.Time
	Contingency string
}

// PlanOutage requests a planned shutdown (SRS-FAC-004).
func PlanOutage(id, tenantID string, in PlanOutageInput, by string,
	now time.Time) (Outage, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Outage{}, fmt.Errorf("%w: an outage needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Reference) == "":
		return Outage{}, fmt.Errorf("%w: an outage needs a permit reference",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Title) == "":
		return Outage{}, fmt.Errorf("%w: an outage needs a title",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Reason) == "":
		return Outage{}, fmt.Errorf("%w: say why the supply has to go off",
			ErrInvalidFacilities)
	case !knownSystem[in.System]:
		return Outage{}, fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, in.System)
	case in.PlannedFrom.IsZero() || in.PlannedTo.IsZero():
		return Outage{}, fmt.Errorf("%w: an outage needs a planned window",
			ErrInvalidFacilities)
	case !in.PlannedTo.After(in.PlannedFrom):
		return Outage{}, fmt.Errorf("%w: an outage ends after it starts",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return Outage{}, fmt.Errorf("%w: an outage names who requested it",
			ErrInvalidFacilities)
	}

	return Outage{
		ID: id, TenantID: tenantID,
		Reference:   strings.ToUpper(strings.TrimSpace(in.Reference)),
		FacilityID:  strings.TrimSpace(in.FacilityID),
		System:      in.System,
		Title:       strings.TrimSpace(in.Title),
		Reason:      strings.TrimSpace(in.Reason),
		PlannedFrom: in.PlannedFrom.UTC(), PlannedTo: in.PlannedTo.UTC(),
		State:       OutagePlanned,
		RequestedBy: by, RequestedAt: now.UTC(),
		Contingency: strings.TrimSpace(in.Contingency),
		CreatedAt:   now.UTC(), Version: 1,
	}, nil
}

// AddArea records a department a shutdown will reach (SRS-FAC-004).
func AddArea(id string, o Outage, orgUnitID, name string, critical bool,
	now time.Time) (OutageArea, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return OutageArea{}, fmt.Errorf("%w: an area needs an id",
			ErrInvalidFacilities)
	case o.State != OutagePlanned:
		// Areas are declared before the permit is signed. Adding one
		// afterwards means the permit was approved against a different
		// set of consequences from the one that actually applied.
		return OutageArea{}, fmt.Errorf(
			"%w: areas are declared while the outage is still planned, not %s",
			ErrInvalidFacilities, o.State)
	case strings.TrimSpace(orgUnitID) == "" && strings.TrimSpace(name) == "":
		return OutageArea{}, fmt.Errorf("%w: an area needs a department or a name",
			ErrInvalidFacilities)
	}

	return OutageArea{
		ID: id, TenantID: o.TenantID, OutageID: o.ID,
		OrgUnitID:    strings.TrimSpace(orgUnitID),
		Name:         strings.TrimSpace(name),
		Critical:     critical,
		OutageSystem: o.System, OutageState: o.State,
		CreatedAt: now.UTC(), Version: 1,
	}, nil
}

// Approve signs the shutdown permit (SRS-FAC-004).
//
// areas is every area declared against this outage. The two rules here are
// the reason the acceptance says impacted departments receive a notification:
// an outage with no declared areas has not been thought about, and one whose
// critical areas have nothing to fall back on is a decision to take the ICU's
// supply away and hope.
func (o *Outage) Approve(areas []OutageArea, permitRef, by string,
	now time.Time) error {

	var critical int
	for _, area := range areas {
		if area.OutageID != o.ID {
			continue
		}
		if area.Critical {
			critical++
		}
	}

	switch {
	case o.State != OutagePlanned:
		return fmt.Errorf("%w: this outage is already %s",
			ErrInvalidFacilities, o.State)
	case len(areas) == 0:
		return fmt.Errorf("%w: say which departments the outage reaches",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who approved the outage",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == strings.TrimSpace(o.RequestedBy):
		// The engineer who wants the shutdown does not approve it. The
		// whole value of a permit is that somebody else looked.
		return fmt.Errorf("%w: an outage is approved by somebody other than %s",
			ErrInvalidFacilities, o.RequestedBy)
	case critical > 0 && strings.TrimSpace(o.Contingency) == "":
		return fmt.Errorf(
			"%w: say what covers the critical areas while the supply is off",
			ErrInvalidFacilities)
	case o.System.LifeSafety() && strings.TrimSpace(permitRef) == "":
		// Taking the medical gas or the fire system off needs a
		// permit-to-work behind it, not just an estates note.
		return fmt.Errorf("%w: a %s shutdown needs a permit to work",
			ErrInvalidFacilities, o.System)
	}

	o.State = OutageApproved
	o.ApprovedBy = strings.TrimSpace(by)
	o.ApprovedAt = now.UTC()
	o.PermitRef = strings.TrimSpace(permitRef)
	return nil
}

// Notify records that an area has been told (SRS-FAC-004).
func (a *OutageArea) Notify(now time.Time) error {
	if !a.OutageState.Live() {
		return fmt.Errorf("%w: this outage is %s",
			ErrInvalidFacilities, a.OutageState)
	}
	if a.NotifiedAt.IsZero() {
		a.NotifiedAt = now.UTC()
	}
	return nil
}

// Acknowledge records a department answering (SRS-FAC-004).
func (a *OutageArea) Acknowledge(by, objection string, now time.Time) error {
	switch {
	case a.NotifiedAt.IsZero():
		// An acknowledgement of a notice nobody sent is a row that
		// makes an unnotified outage look consulted.
		return fmt.Errorf("%w: this area has not been notified",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who answered for the area",
			ErrInvalidFacilities)
	}
	a.AcknowledgedAt = now.UTC()
	a.AcknowledgedBy = strings.TrimSpace(by)
	a.Objection = strings.TrimSpace(objection)
	return nil
}

// Unacknowledged lists critical areas that have not answered (SRS-FAC-004).
func Unacknowledged(areas []OutageArea) []OutageArea {
	out := make([]OutageArea, 0, len(areas))
	for _, area := range areas {
		if area.Critical && !area.Acknowledged() {
			out = append(out, area)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].Name < out[j].Name
	})
	return out
}

// TakeEffect records the supply actually going off (SRS-FAC-004).
//
// This is where the notification stops being a formality. A critical area
// that has not answered blocks the shutdown, because "we emailed theatres"
// and "theatres know" are different facts and only the second one is safe to
// cut the power on.
func (o *Outage) TakeEffect(areas []OutageArea, now time.Time) error {
	if o.State != OutageApproved {
		return fmt.Errorf("%w: an outage takes effect once approved, not %s",
			ErrInvalidFacilities, o.State)
	}

	mine := make([]OutageArea, 0, len(areas))
	for _, area := range areas {
		if area.OutageID == o.ID {
			mine = append(mine, area)
		}
	}
	for _, area := range mine {
		if area.NotifiedAt.IsZero() {
			return fmt.Errorf("%w: %s has not been notified",
				ErrInvalidFacilities, area.Label())
		}
	}
	if pending := Unacknowledged(mine); len(pending) > 0 {
		return fmt.Errorf("%w: %s has not acknowledged the shutdown",
			ErrInvalidFacilities, pending[0].Label())
	}

	o.State = OutageInEffect
	o.ActualFrom = now.UTC()
	return nil
}

// Restore records the supply coming back (SRS-FAC-004).
func (o *Outage) Restore(by string, now time.Time) error {
	switch {
	case o.State != OutageInEffect:
		return fmt.Errorf("%w: only an outage in effect is restored, not %s",
			ErrInvalidFacilities, o.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who restored the supply",
			ErrInvalidFacilities)
	}
	o.State = OutageRestored
	o.RestoredBy = strings.TrimSpace(by)
	o.ActualTo = now.UTC()
	return nil
}

// CancelOutage withdraws a shutdown that will not happen (SRS-FAC-004).
func (o *Outage) CancelOutage(reason string, now time.Time) error {
	switch {
	case o.State == OutageInEffect:
		// A supply that is already off is restored, not cancelled.
		// Cancelling it would leave the record saying the shutdown
		// never happened while the ward sat in the dark.
		return fmt.Errorf("%w: an outage in effect is restored, not cancelled",
			ErrInvalidFacilities)
	case !o.State.Live():
		return fmt.Errorf("%w: this outage is already %s",
			ErrInvalidFacilities, o.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the outage was cancelled",
			ErrInvalidFacilities)
	}
	o.State = OutageCancelled
	o.CancelReason = strings.TrimSpace(reason)
	return nil
}

// Label names an area for a message.
func (a OutageArea) Label() string {
	if a.Name != "" {
		return a.Name
	}
	return a.OrgUnitID
}

// Overlaps reports whether two outages of the same system cover the same
// window (SRS-FAC-004).
//
// Used before approval to warn. The database holds the harder version of this
// rule — two shutdowns of one system cannot be in effect over one department
// at once — which this cannot express, because two outages of the same system
// over different wards are perfectly reasonable.
func (o Outage) Overlaps(other Outage) bool {
	if o.System != other.System || o.ID == other.ID {
		return false
	}
	if !o.State.Live() || !other.State.Live() {
		return false
	}
	return o.PlannedFrom.Before(other.PlannedTo) &&
		other.PlannedFrom.Before(o.PlannedTo)
}
