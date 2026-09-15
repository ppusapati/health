package transport_test

import (
	"net/netip"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/transport"
)

// clock lets the test advance time instead of sleeping.
type clock struct {
	mu  sync.Mutex
	now time.Time
}

func (c *clock) Now() time.Time {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.now
}

func (c *clock) advance(d time.Duration) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.now = c.now.Add(d)
}

func newLimiter(rate, burst float64) (*transport.RateLimiter, *clock) {
	c := &clock{now: time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)}
	return transport.NewRateLimiter(transport.RateLimitConfig{
		RequestsPerSecond: rate, Burst: burst,
	}, c.Now), c
}

// Interactive work arrives in bursts; a burst of 1 would make normal use feel
// broken, so the bucket must absorb one.
func TestBurstIsAllowedThenRefused(t *testing.T) {
	limiter, _ := newLimiter(10, 5)

	for i := 0; i < 5; i++ {
		if !limiter.Allow("caller", 10, 5) {
			t.Fatalf("request %d within the burst was refused", i+1)
		}
	}
	if limiter.Allow("caller", 10, 5) {
		t.Fatal("a request beyond the burst was allowed")
	}
}

func TestTokensRefillOverTime(t *testing.T) {
	limiter, c := newLimiter(10, 5)

	for i := 0; i < 5; i++ {
		limiter.Allow("caller", 10, 5)
	}
	if limiter.Allow("caller", 10, 5) {
		t.Fatal("bucket was not empty")
	}

	// 10/sec means 100ms buys one token.
	c.advance(100 * time.Millisecond)
	if !limiter.Allow("caller", 10, 5) {
		t.Fatal("no token after the refill interval")
	}
	if limiter.Allow("caller", 10, 5) {
		t.Fatal("more than one token was refilled")
	}
}

// The bucket must not accumulate credit indefinitely, or an idle caller
// returns with an unlimited allowance.
func TestRefillIsCappedAtBurst(t *testing.T) {
	limiter, c := newLimiter(10, 5)

	c.advance(time.Hour)

	for i := 0; i < 5; i++ {
		if !limiter.Allow("caller", 10, 5) {
			t.Fatalf("request %d refused after a long idle period", i+1)
		}
	}
	if limiter.Allow("caller", 10, 5) {
		t.Fatal("an idle caller accumulated more than the burst")
	}
}

// One tenant's traffic must not exhaust another's allowance, and one
// compromised account must not spend the whole tenant's budget.
func TestBucketsAreIndependentPerKey(t *testing.T) {
	limiter, _ := newLimiter(10, 2)

	for i := 0; i < 2; i++ {
		limiter.Allow("sub:tenant-a:user-1", 10, 2)
	}
	if limiter.Allow("sub:tenant-a:user-1", 10, 2) {
		t.Fatal("first caller was not limited")
	}

	if !limiter.Allow("sub:tenant-a:user-2", 10, 2) {
		t.Fatal("a second user in the same tenant was refused")
	}
	if !limiter.Allow("sub:tenant-b:user-1", 10, 2) {
		t.Fatal("another tenant was refused")
	}
}

// The bucket map must not grow with every caller the service has ever seen.
func TestIdleBucketsAreEvicted(t *testing.T) {
	limiter, c := newLimiter(10, 5)

	limiter.Allow("caller-1", 10, 5)
	limiter.Allow("caller-2", 10, 5)
	if limiter.Size() != 2 {
		t.Fatalf("Size = %d", limiter.Size())
	}

	c.advance(30 * time.Minute)
	limiter.Allow("caller-3", 10, 5)

	removed := limiter.Evict(10 * time.Minute)
	if removed != 2 {
		t.Fatalf("evicted %d, want 2", removed)
	}
	if limiter.Size() != 1 {
		t.Fatalf("Size after eviction = %d, want 1", limiter.Size())
	}
}

// Eviction must not discard an allowance a caller is actively using.
func TestActiveBucketsSurviveEviction(t *testing.T) {
	limiter, c := newLimiter(10, 5)

	limiter.Allow("active", 10, 5)
	c.advance(time.Minute)
	limiter.Allow("active", 10, 5)

	if removed := limiter.Evict(10 * time.Minute); removed != 0 {
		t.Fatalf("evicted %d active buckets", removed)
	}
}

// A zero rate means unlimited, so an unconfigured limiter cannot silently
// block every request.
func TestUnconfiguredLimiterAllowsEverything(t *testing.T) {
	limiter, _ := newLimiter(0, 0)

	for i := 0; i < 100; i++ {
		if !limiter.Allow("caller", 0, 0) {
			t.Fatal("an unconfigured limiter refused a request")
		}
	}
}

func TestConcurrentCallersDoNotCorruptTheBucket(t *testing.T) {
	limiter, _ := newLimiter(1000, 100)

	var wg sync.WaitGroup
	var allowed int
	var mu sync.Mutex

	for i := 0; i < 200; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if limiter.Allow("shared", 1000, 100) {
				mu.Lock()
				allowed++
				mu.Unlock()
			}
		}()
	}
	wg.Wait()

	// Exactly the burst, no more: a data race would let extra requests through.
	if allowed != 100 {
		t.Fatalf("allowed %d of 200 concurrent requests, want exactly the burst of 100", allowed)
	}
}

// A mesh terminates the connection in a sidecar, so every request reaches the
// application from the same address. The peer stage must not turn that into a
// two-request-per-second cap on the whole deployment.
//
// This is the defect the rotation drill surfaced (DRILL-2026-001): a load
// generator at under five requests per second, from one address, was refused.
func TestCredentialBearingTrafficFromOneAddressIsNotCappedAtTheUnauthenticatedRate(t *testing.T) {
	c := &clock{now: time.Date(2026, 9, 15, 9, 0, 0, 0, time.UTC)}
	config := transport.DefaultRateLimit()
	limiter := transport.NewRateLimiter(config, c.Now)

	// Well past the unauthenticated burst of 10, and past what any mesh-shared
	// bucket at 2/s would allow.
	const requests = 200
	for i := 0; i < requests; i++ {
		if !limiter.Allow("peer:127.0.0.1", config.PeerRequestsPerSecond, config.PeerBurst) {
			t.Fatalf("request %d from the mesh address was refused; behind a sidecar "+
				"this is every user of the deployment", i+1)
		}
	}
}

// The tight budget still exists, and still applies to traffic with no
// credential — which is what it was for.
func TestUncredentialedTrafficKeepsTheTightBudget(t *testing.T) {
	c := &clock{now: time.Date(2026, 9, 15, 9, 0, 0, 0, time.UTC)}
	config := transport.DefaultRateLimit()
	limiter := transport.NewRateLimiter(config, c.Now)

	var refusedAt int
	for i := 1; i <= 40; i++ {
		if !limiter.Allow("peer:203.0.113.9",
			config.UnauthenticatedRequestsPerSecond, config.UnauthenticatedBurst) {
			refusedAt = i
			break
		}
	}
	if refusedAt == 0 {
		t.Fatal("an uncredentialed flood was never refused")
	}
	if refusedAt > int(config.UnauthenticatedBurst)+2 {
		t.Errorf("uncredentialed traffic was allowed %d requests before refusal; "+
			"the burst is %.0f", refusedAt, config.UnauthenticatedBurst)
	}
}

func TestClientAddressIgnoresForwardedForByDefault(t *testing.T) {
	// No trusted proxies configured, so the header is somebody's claim about
	// themselves. Believing it would let a caller choose their own bucket.
	got := transport.ClientAddress("10.0.0.7:41234", "203.0.113.5", nil)
	if got != "10.0.0.7" {
		t.Errorf("got %q, want the peer address 10.0.0.7", got)
	}
}

func TestClientAddressBelievesATrustedProxy(t *testing.T) {
	trusted := []netip.Prefix{netip.MustParsePrefix("10.0.0.0/8")}

	got := transport.ClientAddress("10.0.0.7:41234", "198.51.100.2, 203.0.113.5", trusted)
	if got != "203.0.113.5" {
		t.Errorf("got %q, want the entry the trusted proxy appended", got)
	}
}

func TestClientAddressTakesOnlyTheProxysOwnEntry(t *testing.T) {
	// Everything before the last entry was supplied by whoever the proxy was
	// talking to, so a caller cannot pin themselves to a bucket of their
	// choosing by prepending one.
	trusted := []netip.Prefix{netip.MustParsePrefix("10.0.0.0/8")}

	got := transport.ClientAddress("10.0.0.7:41234", "not-an-address, 203.0.113.5", trusted)
	if got != "203.0.113.5" {
		t.Errorf("got %q, want 203.0.113.5", got)
	}
}

func TestClientAddressRejectsAnUntrustedPeersHeader(t *testing.T) {
	trusted := []netip.Prefix{netip.MustParsePrefix("10.0.0.0/8")}

	got := transport.ClientAddress("198.51.100.9:33221", "203.0.113.5", trusted)
	if got != "198.51.100.9" {
		t.Errorf("got %q, want the peer address; the header came from outside the trusted set", got)
	}
}

func TestClientAddressFallsBackWhenTheHeaderIsJunk(t *testing.T) {
	trusted := []netip.Prefix{netip.MustParsePrefix("10.0.0.0/8")}

	for _, junk := range []string{"", "   ", "nonsense", "1.2.3"} {
		if got := transport.ClientAddress("10.0.0.7:41234", junk, trusted); got != "10.0.0.7" {
			t.Errorf("X-Forwarded-For %q: got %q, want the peer address", junk, got)
		}
	}
}

func TestParseTrustedProxies(t *testing.T) {
	got, err := transport.ParseTrustedProxies(" 10.0.0.0/8 , 192.168.1.0/24 ")
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if len(got) != 2 || got[0].String() != "10.0.0.0/8" || got[1].String() != "192.168.1.0/24" {
		t.Errorf("got %v", got)
	}
}

func TestParseTrustedProxiesRefusesABareAddress(t *testing.T) {
	// An operator who wrote a host address meaning "trust this one proxy"
	// should be told. Skipping the line would leave them with a configuration
	// in which nothing is trusted and every caller behind the mesh shares a
	// bucket — which is the failure this setting exists to prevent.
	if _, err := transport.ParseTrustedProxies("10.0.0.7"); err == nil {
		t.Error("a bare address was accepted as a trusted proxy")
	}
}

func TestParseTrustedProxiesTreatsEmptyAsNone(t *testing.T) {
	for _, empty := range []string{"", "   ", ","} {
		got, err := transport.ParseTrustedProxies(empty)
		if err != nil {
			t.Errorf("%q: %v", empty, err)
		}
		if len(got) != 0 {
			t.Errorf("%q: got %v, want none", empty, got)
		}
	}
}

// A partial configuration must not produce a peer budget of zero, which would
// refuse every request. The wiring fills the field; this pins the shape the
// wiring depends on.
func TestDefaultPeerBudgetIsFarAboveTheUncredentialedOne(t *testing.T) {
	config := transport.DefaultRateLimit()

	if config.PeerRequestsPerSecond <= config.UnauthenticatedRequestsPerSecond {
		t.Errorf("peer budget %.0f/s is not above the uncredentialed %.0f/s",
			config.PeerRequestsPerSecond, config.UnauthenticatedRequestsPerSecond)
	}
	// Above the per-caller budget too: behind a mesh this bucket is shared by
	// every caller, so it cannot be the thing that shapes one caller's traffic.
	if config.PeerRequestsPerSecond <= config.RequestsPerSecond {
		t.Errorf("peer budget %.0f/s is not above the per-caller %.0f/s; "+
			"behind a mesh it would become the effective per-caller limit",
			config.PeerRequestsPerSecond, config.RequestsPerSecond)
	}
}
