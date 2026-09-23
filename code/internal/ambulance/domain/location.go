package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The location feed (SRS-AMB-005).
//
// SRS-AMB-005's acceptance is that the location feed is permissioned and
// retention-configurable, and the reason both halves are there is that a map
// of an ambulance's day is a list of the addresses somebody was ill at.
//
// Three shapes follow. A ping carries no patient identifier and no request
// identifier: it says where a vehicle was, and the link to who was in it runs
// through the trip, which is behind a different permission. Every ping carries
// the moment it stops being kept, computed at write time from the deployment's
// horizon rather than looked up at read time — a retention policy that lives
// only in the purge job is one that does nothing between runs. And there is no
// function here that changes a ping: a trail somebody can edit is a trail that
// says whatever the last person to touch it wanted.

// Ping is one position report (SRS-AMB-005).
type Ping struct {
	ID       string
	TenantID string

	VehicleID string
	// TripID links the ping to a job where there was one, so a trail can be
	// read for one call rather than for a whole shift. Empty when the
	// vehicle is not on a trip, which is most of the day.
	TripID string

	// LatitudeMicro and LongitudeMicro are degrees times a million.
	// Integers: a position stored as a float and read back as
	// 51.50730000000001 fails an equality check in a replay nobody expected
	// to be about floating point, and a micro-degree is about ten
	// centimetres.
	LatitudeMicro  int
	LongitudeMicro int
	// SpeedKph and HeadingDegrees are what the box reported.
	SpeedKph       int
	HeadingDegrees int
	// AccuracyMetres is how much to trust it. Zero means the provider did
	// not say, which is reported rather than treated as perfect.
	AccuracyMetres int

	// Source names the provider the feed came from, because two providers
	// disagreeing about where a vehicle was is a thing that happens.
	Source string

	At time.Time
	// RetainUntil is when this ping stops being kept. Carried on the row so
	// the horizon a deployment configured is a property of the data rather
	// than of whatever the purge job was last told.
	RetainUntil time.Time
}

// NewPingInput reports a position.
type NewPingInput struct {
	VehicleID      string
	TripID         string
	LatitudeMicro  int
	LongitudeMicro int
	SpeedKph       int
	HeadingDegrees int
	AccuracyMetres int
	Source         string
	At             time.Time
}

// RecordPing takes one position report (SRS-AMB-005).
//
// The retention horizon is required. A deployment that has not decided how
// long it keeps a map of where its ambulances went has not decided the one
// thing SRS-AMB-005 asks it to decide, and defaulting to "for ever" would
// make that decision for it in the worst direction.
func RecordPing(id, tenantID string, in NewPingInput,
	retainFor time.Duration, now time.Time) (Ping, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Ping{}, fmt.Errorf("%w: a ping needs an id",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.VehicleID) == "":
		return Ping{}, fmt.Errorf("%w: a ping names its vehicle",
			ErrInvalidAmbulance)
	case retainFor <= 0:
		return Ping{}, fmt.Errorf(
			"%w: this deployment has set no retention period for the "+
				"location feed", ErrInvalidAmbulance)
	case in.LatitudeMicro < -90_000_000 || in.LatitudeMicro > 90_000_000:
		return Ping{}, fmt.Errorf("%w: latitude is out of range",
			ErrInvalidAmbulance)
	case in.LongitudeMicro < -180_000_000 ||
		in.LongitudeMicro > 180_000_000:
		return Ping{}, fmt.Errorf("%w: longitude is out of range",
			ErrInvalidAmbulance)
	case in.SpeedKph < 0 || in.AccuracyMetres < 0:
		return Ping{}, fmt.Errorf("%w: a speed or an accuracy cannot be "+
			"negative", ErrInvalidAmbulance)
	case in.HeadingDegrees < 0 || in.HeadingDegrees >= 360:
		return Ping{}, fmt.Errorf("%w: a heading is between 0 and 359",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.Source) == "":
		// Two providers disagreeing about where a vehicle was is a thing
		// that happens, and an unattributed ping cannot be reconciled.
		return Ping{}, fmt.Errorf("%w: a ping names where it came from",
			ErrInvalidAmbulance)
	}

	at := in.At
	if at.IsZero() {
		at = now
	}

	return Ping{
		ID: id, TenantID: tenantID,
		VehicleID:      strings.TrimSpace(in.VehicleID),
		TripID:         strings.TrimSpace(in.TripID),
		LatitudeMicro:  in.LatitudeMicro,
		LongitudeMicro: in.LongitudeMicro,
		SpeedKph:       in.SpeedKph,
		HeadingDegrees: in.HeadingDegrees,
		AccuracyMetres: in.AccuracyMetres,
		Source:         strings.TrimSpace(in.Source),
		At:             at.UTC(),
		RetainUntil:    at.Add(retainFor).UTC(),
	}, nil
}

// Expired reports a ping past its retention horizon (SRS-AMB-005).
//
// Derived rather than stored as a flag, so a ping is out of retention the
// moment it is rather than the next time a job runs. A read that respects
// this is a read that cannot return yesterday's trail because the purge is
// behind.
func (p Ping) Expired(at time.Time) bool {
	return !p.RetainUntil.IsZero() && !at.Before(p.RetainUntil)
}

// Retained filters a feed to what a deployment still keeps (SRS-AMB-005).
//
// Applied on the read rather than trusted to the purge. The purge frees the
// disk; this is what stops an expired position reaching a screen in the
// window between runs.
func Retained(pings []Ping, at time.Time) []Ping {
	var out []Ping
	for _, ping := range pings {
		if !ping.Expired(at) {
			out = append(out, ping)
		}
	}
	sort.Slice(out, func(a, b int) bool {
		if !out[a].At.Equal(out[b].At) {
			return out[a].At.Before(out[b].At)
		}
		return out[a].ID < out[b].ID
	})
	return out
}

// Position is where a vehicle is now (SRS-AMB-005).
type Position struct {
	VehicleID      string
	LatitudeMicro  int
	LongitudeMicro int
	SpeedKph       int
	AccuracyMetres int
	Source         string
	At             time.Time
	// Stale reports a position older than the deployment thinks useful.
	// Reported rather than withheld: a dispatcher who can see the vehicle
	// was last heard from eleven minutes ago knows something a blank screen
	// does not tell them.
	Stale bool
	// Known is false when there is nothing in retention for this vehicle.
	// Reported rather than defaulting to the base, which would put an
	// ambulance somewhere it is not.
	Known bool
}

// Latest answers where a vehicle was last seen (SRS-AMB-005).
func Latest(pings []Ping, vehicleID string, staleAfter time.Duration,
	at time.Time) Position {

	out := Position{VehicleID: vehicleID}
	var newest Ping
	for _, ping := range pings {
		if ping.VehicleID != vehicleID || ping.Expired(at) {
			continue
		}
		if !out.Known || ping.At.After(newest.At) {
			newest, out.Known = ping, true
		}
	}
	if !out.Known {
		return out
	}
	out.LatitudeMicro = newest.LatitudeMicro
	out.LongitudeMicro = newest.LongitudeMicro
	out.SpeedKph = newest.SpeedKph
	out.AccuracyMetres = newest.AccuracyMetres
	out.Source, out.At = newest.Source, newest.At
	out.Stale = staleAfter > 0 && at.Sub(newest.At) > staleAfter
	return out
}

// ETA is an estimated arrival (SRS-AMB-005).
//
// Supplied by the provider rather than computed here. A road network, live
// traffic and a blue-light routing model are the provider's job; guessing
// from a straight line and an average speed would produce a number that looks
// like an ETA and is not one, and a dispatcher would hold a bed against it.
type ETA struct {
	VehicleID string
	TripID    string
	// Seconds until arrival, as the provider gave it.
	Seconds int
	// DistanceMetres is how far it has to go.
	DistanceMetres int
	Source         string
	At             time.Time
	// Known is false when no provider answered. Reported rather than
	// estimated, for the reason above.
	Known bool
}

// NewETA records a provider's estimate (SRS-AMB-005).
func NewETA(vehicleID, tripID string, seconds, distanceMetres int,
	source string, at time.Time) (ETA, error) {

	switch {
	case strings.TrimSpace(vehicleID) == "":
		return ETA{}, fmt.Errorf("%w: an estimate names its vehicle",
			ErrInvalidAmbulance)
	case seconds < 0 || distanceMetres < 0:
		return ETA{}, fmt.Errorf(
			"%w: a time or a distance cannot be negative",
			ErrInvalidAmbulance)
	case strings.TrimSpace(source) == "":
		// An estimate nobody can attribute is one nobody can stop
		// believing when the provider turns out to be wrong.
		return ETA{}, fmt.Errorf("%w: an estimate names where it came from",
			ErrInvalidAmbulance)
	}
	return ETA{
		VehicleID: strings.TrimSpace(vehicleID),
		TripID:    strings.TrimSpace(tripID),
		Seconds:   seconds, DistanceMetres: distanceMetres,
		Source: strings.TrimSpace(source), At: utcOrZero(at), Known: true,
	}, nil
}
