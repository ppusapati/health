// Package effective resolves which version of a configuration was in force at
// a given instant.
//
// SRS-PLT-013 requires effective-date evaluation for tariffs, roles, forms,
// code mappings and policies, verified by "historical transaction resolves
// configuration active at event time". That last clause is the whole design
// constraint, and it is easy to get wrong in a way that only shows up in a
// billing dispute a year later.
//
// The wrong version asks "what is the current tariff?" and applies it to an
// old encounter. The right version asks "what was the tariff on the day this
// encounter happened?". These differ every time a price changes, and the
// difference is invisible in testing because test data is usually written
// today, for today.
//
// Two instants are therefore always in play and must never be conflated:
//
//	event time    when the thing being priced, authorised or rendered happened
//	decision time when the system is now asking
//
// Everything here takes event time. Nothing here reads the clock: a resolver
// that can consult time.Now() will eventually be called without an event time
// by someone in a hurry, and that call will look correct in review.
package effective

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// Errors returned by this package.
var (
	// ErrNoneInForce reports that nothing was effective at the requested
	// instant. Distinct from "not found": the key may exist and simply not
	// have been configured yet on that date, which is a different
	// conversation with the user.
	ErrNoneInForce = errors.New("effective: no version was in force at that instant")
	// ErrOverlap reports two versions claiming the same instant.
	ErrOverlap = errors.New("effective: two versions are in force at the same instant")
	// ErrInvalidWindow reports a version whose window cannot hold.
	ErrInvalidWindow = errors.New("effective: invalid effective window")
)

// Window is a half-open interval [From, Until).
//
// Half-open, because closed intervals make the boundary ambiguous and somebody
// always gets billed twice on the changeover day. A zero Until means open-ended.
type Window struct {
	From  time.Time
	Until time.Time
}

// OpenEnded reports whether the window has no end.
func (w Window) OpenEnded() bool { return w.Until.IsZero() }

// Contains reports whether an instant falls in the window.
func (w Window) Contains(at time.Time) bool {
	at = at.UTC()
	if at.Before(w.From.UTC()) {
		return false
	}
	if w.OpenEnded() {
		return true
	}
	return at.Before(w.Until.UTC())
}

// Validate refuses a window that cannot hold.
func (w Window) Validate() error {
	if w.From.IsZero() {
		return fmt.Errorf("%w: effective-from is required", ErrInvalidWindow)
	}
	if !w.OpenEnded() && !w.Until.After(w.From) {
		return fmt.Errorf("%w: effective-until %s is not after effective-from %s",
			ErrInvalidWindow, w.Until.UTC().Format(time.RFC3339), w.From.UTC().Format(time.RFC3339))
	}
	return nil
}

// Overlaps reports whether two windows share any instant.
func (w Window) Overlaps(other Window) bool {
	// Half-open intervals overlap iff each starts before the other ends.
	endsAfter := func(a, b Window) bool {
		return a.OpenEnded() || a.Until.UTC().After(b.From.UTC())
	}
	return endsAfter(w, other) && endsAfter(other, w)
}

// Versioned is anything with an effective window and a version number.
//
// Version matters as much as the window: two versions can legitimately share a
// key over time, and when a correction is issued for a past period the later
// version must win. Sorting by window alone cannot express that.
type Versioned interface {
	EffectiveWindow() Window
	VersionNumber() int64
}

// Timeline holds the versions of one configuration key.
type Timeline[T Versioned] struct {
	key      string
	versions []T
}

// NewTimeline builds a timeline and refuses overlapping windows.
//
// Overlap is refused at construction rather than resolved at read time by
// picking the highest version. Picking silently would let a data-entry mistake
// — a tariff whose window was never closed before the next one opened — look
// like a working system while quietly applying the wrong price to everything
// in the overlap.
func NewTimeline[T Versioned](key string, versions []T) (*Timeline[T], error) {
	if strings.TrimSpace(key) == "" {
		return nil, errors.New("effective: timeline needs a key")
	}

	ordered := make([]T, len(versions))
	copy(ordered, versions)
	sort.SliceStable(ordered, func(i, j int) bool {
		a, b := ordered[i].EffectiveWindow(), ordered[j].EffectiveWindow()
		if !a.From.Equal(b.From) {
			return a.From.Before(b.From)
		}
		return ordered[i].VersionNumber() < ordered[j].VersionNumber()
	})

	for i, v := range ordered {
		if err := v.EffectiveWindow().Validate(); err != nil {
			return nil, fmt.Errorf("%s version %d: %w", key, v.VersionNumber(), err)
		}
		if i == 0 {
			continue
		}
		previous := ordered[i-1]
		if previous.EffectiveWindow().Overlaps(v.EffectiveWindow()) {
			return nil, fmt.Errorf("%w: %s versions %d and %d",
				ErrOverlap, key, previous.VersionNumber(), v.VersionNumber())
		}
	}

	return &Timeline[T]{key: key, versions: ordered}, nil
}

// At returns the version in force at an instant.
//
// The parameter is named eventTime rather than at, because the single most
// common mistake this package exists to prevent is passing the current time
// when the caller meant the time the transaction occurred.
func (t *Timeline[T]) At(eventTime time.Time) (T, error) {
	var zero T
	if eventTime.IsZero() {
		// Refused rather than defaulted to now. A zero time here means the
		// caller lost the event time somewhere upstream, and answering with
		// today's configuration would hide that.
		return zero, fmt.Errorf("%w: %s: event time is zero", ErrNoneInForce, t.key)
	}
	for _, v := range t.versions {
		if v.EffectiveWindow().Contains(eventTime) {
			return v, nil
		}
	}
	return zero, fmt.Errorf("%w: %s at %s", ErrNoneInForce, t.key, eventTime.UTC().Format(time.RFC3339))
}

// All returns the versions in effective order.
func (t *Timeline[T]) All() []T {
	out := make([]T, len(t.versions))
	copy(out, t.versions)
	return out
}

// Gaps reports intervals the timeline does not cover between its first and
// last version.
//
// A gap is not always wrong — a service genuinely withdrawn for six months has
// one — but it is always worth knowing about, because the alternative is a
// transaction in the gap failing at the point of care with "no tariff found".
func (t *Timeline[T]) Gaps() []Window {
	var gaps []Window
	for i := 1; i < len(t.versions); i++ {
		previous := t.versions[i-1].EffectiveWindow()
		next := t.versions[i].EffectiveWindow()
		if previous.OpenEnded() {
			// Cannot be followed by anything; NewTimeline would have caught
			// the overlap.
			continue
		}
		if previous.Until.UTC().Before(next.From.UTC()) {
			gaps = append(gaps, Window{From: previous.Until, Until: next.From})
		}
	}
	return gaps
}
