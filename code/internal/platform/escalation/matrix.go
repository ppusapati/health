// Package escalation persists a clinical notice until somebody acknowledges it.
//
// SRS-OPSNFR-003: "critical clinical acknowledgement workflows shall persist
// notifications until acknowledged/escalated/closed", verified by "restart does
// not lose pending escalation". SRS-OPSAPI-007 asks the same of the mechanism —
// durable, and idempotent on resume. SRS-FAC-012 asks who to tell.
//
// It exists because Wave 1's escalation was a calculation. `EscalationPolicy.
// DueEscalations(notifiedAt, now)` answers how many times a critical result
// *should* have escalated, which is the right answer to a question nobody was
// acting on: nothing was stored, nothing was delivered, and nobody was named.
// A derived count cannot be lost in a restart, and it also never reached a
// human being. Wave 2 puts ER, ICU, blood bank, infection control, quality and
// facilities behind the same mechanism, and at that point "the screen would
// have shown a number if somebody had been looking at the screen" stops being
// good enough.
//
// This is a platform capability rather than a clinical one for the same reason
// the outbox is. Seven Wave-2 families escalate. A mechanism owned by any one
// of them is a mechanism the other six either duplicate or reach across a
// context boundary to use.
package escalation

import (
	"fmt"
	"sort"
	"strings"
)

// Recipient is somebody a notice can reach.
//
// Either a named person or a role on duty at a facility, never both. A rung
// that named both would be ambiguous about which was authoritative when the
// person is not the one on duty — and at three in the morning that is exactly
// the case that matters.
type Recipient struct {
	// UserID names one person. Empty when the rung names a role.
	UserID string
	// Role is a duty role — "ed_consultant_on_call", "icu_registrar". Resolved
	// against the roster at the moment of escalation rather than at
	// configuration time, because the point of a rota is that the answer
	// changes.
	Role string
	// FacilityID scopes a role. A role with no facility is a tenant-wide duty,
	// which is rare and deliberate.
	FacilityID string
}

// Named reports whether this recipient identifies a specific person.
func (r Recipient) Named() bool { return strings.TrimSpace(r.UserID) != "" }

// Validate rejects a recipient nothing could deliver to.
func (r Recipient) Validate() error {
	hasUser := strings.TrimSpace(r.UserID) != ""
	hasRole := strings.TrimSpace(r.Role) != ""
	if hasUser == hasRole {
		return fmt.Errorf(
			"%w: a recipient is one named person or one duty role, not both and not neither",
			ErrInvalidMatrix)
	}
	return nil
}

// Rung is one step of an escalation chain.
type Rung struct {
	// Level counts from zero. Level zero is whoever was responsible in the
	// first place — the ordering clinician, the ward team — and every rung
	// above it is somebody who did not ask to be involved.
	Level int
	// Recipients are told together rather than in turn. A rung that tried each
	// recipient in sequence would be a second escalation chain inside a rung,
	// with its own timers and its own way of stalling.
	Recipients []Recipient
	// Note explains the rung to whoever configures it, and appears in the
	// audit trail of an escalation that used it.
	Note string
}

// Matrix is the escalation chain for a facility and a subject kind
// (SRS-FAC-012).
//
// Keyed by both because they escalate differently and to different people: a
// critical potassium goes to the ordering clinician and then the on-call
// consultant, while a medical gas alarm goes to facilities and then to the
// duty engineer, and neither chain is a sensible default for the other.
type Matrix struct {
	FacilityID string
	// Kind is what is being escalated — "critical_result", "medical_gas",
	// "sentinel_event". A string rather than an enum because the set grows with
	// every Wave-2 family, and an enumeration here would need editing by each
	// of them in turn.
	Kind  string
	Rungs []Rung
}

// Validate rejects a matrix that could not be walked.
func (m Matrix) Validate() error {
	if strings.TrimSpace(m.Kind) == "" {
		return fmt.Errorf("%w: an escalation matrix is for a kind of notice", ErrInvalidMatrix)
	}
	if len(m.Rungs) == 0 {
		return fmt.Errorf("%w: an escalation matrix with no rungs tells nobody", ErrInvalidMatrix)
	}

	seen := make(map[int]bool, len(m.Rungs))
	for _, rung := range m.Rungs {
		if rung.Level < 0 {
			return fmt.Errorf("%w: rung levels count from zero", ErrInvalidMatrix)
		}
		if seen[rung.Level] {
			return fmt.Errorf("%w: two rungs at level %d", ErrInvalidMatrix, rung.Level)
		}
		seen[rung.Level] = true

		if len(rung.Recipients) == 0 {
			// Not the same as a gap in the chain, which is tolerated below. A
			// rung that exists and names nobody is a configuration mistake
			// that would silently swallow an escalation step.
			return fmt.Errorf("%w: rung %d names nobody", ErrInvalidMatrix, rung.Level)
		}
		for _, recipient := range rung.Recipients {
			if err := recipient.Validate(); err != nil {
				return fmt.Errorf("rung %d: %w", rung.Level, err)
			}
		}
	}

	if !seen[0] {
		// Level zero is the person who was already responsible. A chain that
		// starts at level one begins by telling somebody else's boss.
		return fmt.Errorf("%w: an escalation matrix needs a level 0", ErrInvalidMatrix)
	}
	return nil
}

// Sorted returns the rungs in ascending level order.
//
// Stored order is not trusted: a matrix assembled from rows, or edited by
// hand, can arrive in any order, and walking it in that order would escalate
// to the chief executive before the registrar.
func (m Matrix) Sorted() []Rung {
	out := append([]Rung(nil), m.Rungs...)
	sort.SliceStable(out, func(i, j int) bool { return out[i].Level < out[j].Level })
	return out
}

// Top is the highest level the matrix defines.
func (m Matrix) Top() int {
	top := 0
	for _, rung := range m.Rungs {
		if rung.Level > top {
			top = rung.Level
		}
	}
	return top
}

// At resolves the recipients for a level.
//
// A level with no rung returns the next rung above it, because an escalation
// chain with a gap at level 2 must not stop at level 2 — the gap is a
// configuration mistake and the notice is still unacknowledged. The level
// actually used is returned so the escalation records who it really told
// rather than who it meant to.
//
// Returns false past the top rung. That is not a failure: it means the chain
// is exhausted, which is a state the notice has to represent rather than
// paper over by telling the top rung forever.
func (m Matrix) At(level int) ([]Recipient, int, bool) {
	for _, rung := range m.Sorted() {
		if rung.Level >= level {
			return rung.Recipients, rung.Level, true
		}
	}
	return nil, 0, false
}
