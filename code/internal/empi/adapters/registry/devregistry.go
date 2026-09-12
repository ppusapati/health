package registry

import (
	"context"
	"errors"
	"strings"
	"sync"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
)

// A non-production identifier registry.
//
// ADR-011 (national identifier adapter) is not written: which scheme, which
// onboarding process and which consent flow ABDM will require of this system is
// not a decision the code can make. So this satisfies the same
// ports.IdentifierRegistry seam the real adapter will, and every layer above it
// — use case, transport, audit — is written against the seam rather than
// against ABDM.
//
// Like devauth, it refuses to construct unless explicitly enabled, so a
// production build cannot reach it through configuration drift alone.

// ErrDisabled is returned when the development registry is built without an
// explicit opt-in.
var ErrDisabled = errors.New("devregistry: development identifier registry is not enabled")

// outage makes every Verify report the authority as unreachable.
type outage struct{ cause error }

// DevRegistry answers from an in-memory table seeded by the test or operator.
type DevRegistry struct {
	system string
	clock  func() time.Time

	mu     sync.RWMutex
	known  map[string]domain.Verification
	outage *outage
}

// NewDev returns a development registry for one identifier system.
func NewDev(enabled bool, system string, clock func() time.Time) (*DevRegistry, error) {
	if !enabled {
		return nil, ErrDisabled
	}
	if strings.TrimSpace(system) == "" {
		return nil, errors.New("devregistry: a registry must name its identifier system")
	}
	if clock == nil {
		clock = time.Now
	}
	return &DevRegistry{
		system: system, clock: clock,
		known: map[string]domain.Verification{},
	}, nil
}

// System reports the identifier system this registry answers for.
func (d *DevRegistry) System() string { return d.system }

// Seed makes a value verifiable, optionally with the demographics the
// authority holds against it.
//
// The demographics are what SRS-EMPI-012 reconciles against: a registry that
// returns a different birth date from the one on file is the conflict that
// requirement is about, and seeding one is how that path gets exercised.
func (d *DevRegistry) Seed(value string, v domain.Verification) {
	d.mu.Lock()
	defer d.mu.Unlock()
	if v.AssigningAuthority == "" {
		v.AssigningAuthority = d.system
	}
	d.known[normaliseValue(value)] = v
}

// Fail makes a value answer "not recognised" with a stated reason.
func (d *DevRegistry) Fail(value, reason string) {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.known[normaliseValue(value)] = domain.Verification{
		Verified: false, Reason: reason, AssigningAuthority: d.system,
	}
}

// SetOutage simulates the authority being unavailable, which is a different
// answer from "not recognised" and has to stay distinguishable.
func (d *DevRegistry) SetOutage(cause error) {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.outage = &outage{cause: cause}
}

// ClearOutage restores normal answers.
func (d *DevRegistry) ClearOutage() {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.outage = nil
}

// Verify answers from the seeded table.
func (d *DevRegistry) Verify(ctx context.Context, value string) (domain.Verification, error) {
	if err := ctx.Err(); err != nil {
		return domain.Verification{}, domain.ErrRegistryUnavailable{System: d.system, Cause: err}
	}

	d.mu.RLock()
	defer d.mu.RUnlock()

	if d.outage != nil {
		return domain.Verification{}, domain.ErrRegistryUnavailable{
			System: d.system, Cause: d.outage.cause,
		}
	}

	v, ok := d.known[normaliseValue(value)]
	if !ok {
		// Unknown is a real answer: the authority was asked and does not
		// recognise the value.
		return domain.Verification{
			Verified: false, AssigningAuthority: d.system,
			Reason: "the issuing authority does not recognise this value",
		}, nil
	}
	if v.VerifiedAt.IsZero() {
		v.VerifiedAt = d.clock().UTC()
	}
	return v, nil
}

// normaliseValue matches how identifiers are compared: whitespace and case are
// presentation, not identity.
func normaliseValue(v string) string {
	return strings.ToUpper(strings.TrimSpace(v))
}

var _ ports.IdentifierRegistry = (*DevRegistry)(nil)
