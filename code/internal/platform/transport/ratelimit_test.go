package transport_test

import (
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
