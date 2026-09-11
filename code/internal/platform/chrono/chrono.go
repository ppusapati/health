// Package chrono carries instants together with the local time they were.
//
// SRS-DAT-004 asks for timestamps stored "in unambiguous instant form plus
// source timezone/local-time metadata where clinically or legally material",
// verified by a rendered historical timestamp being deterministic. Those are
// two different problems and only the first is solved by timestamptz.
//
// The instant is easy: PostgreSQL stores UTC and the driver hands back a
// time.Time. The hard part is rendering it back the way it was experienced.
// "The dose was given at 01:30" is a clinical fact, and re-deriving it later
// by applying today's rules for the ward's timezone does not reliably give
// 01:30 back:
//
//   - During a daylight-saving fallback, 01:30 local occurs twice. The instant
//     is unambiguous; the wall time alone is not, and neither is the wall time
//     plus the zone name. Only the offset in effect distinguishes them.
//   - Jurisdictions change their rules, sometimes retroactively. A record from
//     2019 rendered with the 2026 tzdata can shift by an hour.
//   - A patient transferred between facilities in different zones has doses
//     recorded under both; the ward's current zone is not the right lens for a
//     dose given elsewhere.
//
// So a LocalInstant keeps three things: the instant, the IANA zone identifier,
// and the UTC offset that was in force. The offset makes rendering
// deterministic without consulting tzdata at all; the zone identifier keeps
// the information a human needs to know which ward's clock this was.
package chrono

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidInstant reports a timestamp that could not be rendered
// deterministically later.
var ErrInvalidInstant = errors.New("chrono: invalid local instant")

// LocalInstant is a moment plus the local clock that observed it.
type LocalInstant struct {
	// Instant is the unambiguous moment, always UTC.
	Instant time.Time
	// Zone is the IANA identifier of the observing clock, e.g. "Asia/Kolkata".
	// Kept for display and for answering "which site was this?", never used to
	// re-derive the offset.
	Zone string
	// OffsetSeconds is the UTC offset in force at Instant, in that Zone. This
	// is what makes rendering deterministic: it is a fact about the past, and
	// unlike a zone rule it cannot be changed retroactively by a tzdata update.
	OffsetSeconds int
}

// Observe captures an instant as seen from a location.
//
// loc must be a real location; time.Local is refused. A server's local zone is
// a property of where the process happens to run, which is not clinical
// information and changes when the deployment moves.
func Observe(t time.Time, loc *time.Location) (LocalInstant, error) {
	if t.IsZero() {
		return LocalInstant{}, fmt.Errorf("%w: instant is zero", ErrInvalidInstant)
	}
	if loc == nil {
		return LocalInstant{}, fmt.Errorf("%w: location is required", ErrInvalidInstant)
	}
	if loc == time.Local {
		return LocalInstant{}, fmt.Errorf("%w: time.Local is the server's zone, not the "+
			"site's; pass the facility's IANA location", ErrInvalidInstant)
	}

	local := t.In(loc)
	_, offset := local.Zone()
	return LocalInstant{
		Instant:       t.UTC(),
		Zone:          loc.String(),
		OffsetSeconds: offset,
	}, nil
}

// Load resolves an IANA zone identifier.
func Load(zone string) (*time.Location, error) {
	if strings.TrimSpace(zone) == "" {
		return nil, fmt.Errorf("%w: zone is required", ErrInvalidInstant)
	}
	if zone == "Local" {
		return nil, fmt.Errorf("%w: %q is not a site identifier", ErrInvalidInstant, zone)
	}
	loc, err := time.LoadLocation(zone)
	if err != nil {
		return nil, fmt.Errorf("%w: unknown zone %q", ErrInvalidInstant, zone)
	}
	return loc, nil
}

// Restore rebuilds a LocalInstant from stored columns.
//
// It validates rather than trusts: an offset that no zone ever had at that
// instant means the two columns disagree, and rendering either one would be a
// guess. That has to surface as an error, because the alternative is a
// medication time that is quietly an hour wrong.
func Restore(instant time.Time, zone string, offsetSeconds int) (LocalInstant, error) {
	if instant.IsZero() {
		return LocalInstant{}, fmt.Errorf("%w: instant is zero", ErrInvalidInstant)
	}
	if strings.TrimSpace(zone) == "" {
		return LocalInstant{}, fmt.Errorf("%w: zone is required", ErrInvalidInstant)
	}
	return LocalInstant{
		Instant:       instant.UTC(),
		Zone:          zone,
		OffsetSeconds: offsetSeconds,
	}, nil
}

// Local renders the wall-clock time as it was observed.
//
// Deterministic by construction: it applies the stored offset and never
// consults tzdata, so the same stored row renders identically on every machine
// and after every tzdata update. The returned time carries a fixed zone whose
// name is the IANA identifier, which is what a human wants to see.
func (l LocalInstant) Local() time.Time {
	return l.Instant.In(time.FixedZone(l.Zone, l.OffsetSeconds))
}

// String renders the instant in RFC 3339 with the observed offset.
func (l LocalInstant) String() string {
	return l.Local().Format(time.RFC3339)
}

// Ambiguous reports whether the local wall time occurs more than once in the
// zone on that day — the daylight-saving fallback case.
//
// This is why the offset is stored. The answer is informational: a renderer
// may want to mark 01:30 as "01:30 IST (first occurrence)". Nothing about the
// stored value is ambiguous; the wall time on its own would be.
func (l LocalInstant) Ambiguous() (bool, error) {
	loc, err := Load(l.Zone)
	if err != nil {
		return false, err
	}
	wall := l.Local()
	// Reconstructing the wall time in the real zone: if Go resolves it to a
	// different instant than the one we hold, the same wall time exists twice
	// and Go picked the other one.
	resolved := time.Date(wall.Year(), wall.Month(), wall.Day(),
		wall.Hour(), wall.Minute(), wall.Second(), wall.Nanosecond(), loc)
	return !resolved.Equal(l.Instant), nil
}

// DriftsFromZoneRules reports whether re-deriving the offset from today's
// tzdata would give a different answer than the stored offset.
//
// True means a zone rule changed since the record was written — or that the
// instant falls in an ambiguous hour. Either way the stored offset is the one
// to trust: it is what was observed. This exists so a data-quality job can
// find such rows rather than have them silently render differently.
func (l LocalInstant) DriftsFromZoneRules() (bool, error) {
	loc, err := Load(l.Zone)
	if err != nil {
		return false, err
	}
	_, current := l.Instant.In(loc).Zone()
	return current != l.OffsetSeconds, nil
}
