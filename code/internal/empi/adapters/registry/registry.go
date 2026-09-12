// Package registry resolves identifier systems to the authorities that issue
// them (SRS-EMPI-011).
//
// The set is a table rather than a switch because which national scheme a
// deployment talks to is a deployment question. An Indian hospital verifies
// ABHA against ABDM; the same binary in another jurisdiction verifies something
// else, or nothing at all, and that must not require a different build.
//
// Absence is the normal case and not an error. Most identifiers a hospital
// records — an insurer's membership number, a card from a clinic across town —
// have no online authority to ask, and they stay asserted.
package registry

import (
	"fmt"
	"sync"

	"github.com/ppusapati/health/code/internal/empi/ports"
)

// Set is a registry lookup by identifier system.
//
// Safe for concurrent reads after construction. Registration happens at wiring
// time, reads happen per request, and the mutex is there so a future
// hot-reload of configuration does not turn a map read into a data race the
// tests would only find under -race.
type Set struct {
	mu  sync.RWMutex
	all map[string]ports.IdentifierRegistry
}

// New returns an empty set. A deployment that verifies nothing is valid.
func New() *Set { return &Set{all: map[string]ports.IdentifierRegistry{}} }

// Register adds a registry, refusing a second one for the same system.
//
// Refusing rather than overwriting: two registries for one system means the
// wiring is ambiguous, and picking the last one registered makes the behaviour
// depend on initialisation order.
func (s *Set) Register(r ports.IdentifierRegistry) error {
	if r == nil {
		return fmt.Errorf("registry: cannot register a nil registry")
	}
	system := r.System()
	if system == "" {
		return fmt.Errorf("registry: a registry must name the identifier system it answers for")
	}

	s.mu.Lock()
	defer s.mu.Unlock()
	if existing, ok := s.all[system]; ok {
		return fmt.Errorf("registry: %q already has a registry (%T)", system, existing)
	}
	s.all[system] = r
	return nil
}

// For returns the registry for an identifier system, if one is configured.
func (s *Set) For(system string) (ports.IdentifierRegistry, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	r, ok := s.all[system]
	return r, ok
}

// Systems lists the configured systems, for a startup log line that says what
// this deployment can actually verify.
func (s *Set) Systems() []string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	out := make([]string, 0, len(s.all))
	for system := range s.all {
		out = append(out, system)
	}
	return out
}

var _ ports.IdentifierRegistries = (*Set)(nil)
