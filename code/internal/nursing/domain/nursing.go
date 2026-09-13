// Package domain is the nursing context's model (SRS-NUR-001 … SRS-NUR-018).
//
// Nursing is where the record meets the bedside, and almost every rule in this
// package exists because of the gap between the two: an observation is taken at
// the bed and typed at a terminal, a dose is scheduled by a system and given by
// a person, a device is inserted on one shift and removed on another. The
// requirements are unusually consistent about which of the two times matters,
// and the answer is always the bedside one.
package domain

import (
	"errors"
	"fmt"
	"strings"
)

// ErrInvalidNursingRecord reports a record that must not be stored.
//
// A sentinel rather than a transport error: the domain does not know it is
// behind an RPC, and FIT-01 holds it to that. The application layer maps it
// onto the wire contract.
var ErrInvalidNursingRecord = errors.New("nursing: invalid record")

// ErrNotAllowed reports a state change the record's own state forbids —
// distinct from a malformed one, because the caller's remedy is different.
var ErrNotAllowed = errors.New("nursing: not allowed in this state")

func invalidf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrInvalidNursingRecord, fmt.Sprintf(format, args...))
}

func notAllowedf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrNotAllowed, fmt.Sprintf(format, args...))
}

// Coding is a code and the terminology it came from.
//
// Duplicated from the clinical and encounter contexts rather than shared. A
// value type common to three bounded contexts is a dependency that makes them
// one context the first time any of them needs to change it; the cost is a
// mapping at each seam, and the mapping is where a version skew becomes
// visible rather than silent.
type Coding struct {
	System  string
	Version string
	Code    string
	Display string
}

// Validate rejects a coding that could not be acted on.
func (c Coding) Validate() error {
	switch {
	case strings.TrimSpace(c.System) == "":
		return invalidf("a code needs the terminology it came from")
	case strings.TrimSpace(c.Code) == "":
		return invalidf("a coding needs a code")
	case strings.TrimSpace(c.Display) == "":
		return invalidf("a coding needs a display term")
	}
	return nil
}

// Empty reports a coding nobody filled in.
func (c Coding) Empty() bool {
	return strings.TrimSpace(c.System) == "" && strings.TrimSpace(c.Code) == ""
}

// Quantity is a measured value with its unit.
//
// Inseparable, for the reason the clinical context gives: the number alone has
// eventually been rendered under the wrong label by every system that stored
// it that way.
type Quantity struct {
	Value float64
	Unit  string
}
