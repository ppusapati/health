package transport

import (
	"context"
	"fmt"
	"math"
	"net/netip"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RateLimitConfig bounds how fast one caller may issue requests.
type RateLimitConfig struct {
	// RequestsPerSecond is the sustained refill rate.
	RequestsPerSecond float64
	// Burst is the bucket depth, which is what a client may spend at once.
	// Interactive work arrives in bursts, so a burst of 1 makes normal use
	// feel broken.
	Burst float64
	// UnauthenticatedRequestsPerSecond applies before a caller is identified.
	// It is tighter because the only key available is the peer address, and an
	// unauthenticated caller has no business making sustained traffic.
	UnauthenticatedRequestsPerSecond float64
	UnauthenticatedBurst             float64

	// PeerRequestsPerSecond bounds credential-bearing traffic from one address
	// before the token is verified.
	//
	// It exists because the tight unauthenticated budget cannot be applied to
	// every request: a service mesh terminates the connection in a sidecar, so
	// the application sees one peer address for the whole hospital, and a 2/s
	// bucket keyed on that address limits the deployment to two requests per
	// second in total. The drill found exactly that (see
	// docs/engineering/drill-log.md, DRILL-2026-001), and it would have been
	// found in production otherwise, because nothing below sustained concurrent
	// load through the real binary can see it.
	//
	// This is still only a flood backstop. The per-caller budget is the subject
	// stage, which runs after authentication and keys on something the caller
	// cannot choose.
	PeerRequestsPerSecond float64
	PeerBurst             float64

	// TrustedProxies are the networks whose X-Forwarded-For header may be
	// believed. Empty by default, which means the header is ignored: an
	// attacker who can set it would otherwise choose their own rate-limit
	// bucket, which is worse than having no per-address limit at all.
	TrustedProxies []netip.Prefix
}

// DefaultRateLimit is the Wave-0 baseline. Real limits are a deployment and
// contract decision (SRS-SEC-005); these are chosen to be generous enough not
// to interfere with interactive use and tight enough to bound abuse.
func DefaultRateLimit() RateLimitConfig {
	return RateLimitConfig{
		RequestsPerSecond:                20,
		Burst:                            60,
		UnauthenticatedRequestsPerSecond: 2,
		UnauthenticatedBurst:             10,
		// Two orders of magnitude above the unauthenticated budget, because
		// behind a mesh this bucket may be shared by every user of the
		// deployment. It is sized to stop a flood, not to shape traffic.
		PeerRequestsPerSecond: 500,
		PeerBurst:             1000,
	}
}

// ParseTrustedProxies reads a comma-separated list of CIDR blocks.
//
// An entry that is not a CIDR is an error rather than a skipped line: an
// operator who wrote "10.0.0.7" meaning one host should be told, not silently
// given a configuration in which no proxy is trusted and every caller behind
// the mesh shares a bucket.
func ParseTrustedProxies(raw string) ([]netip.Prefix, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" {
		return nil, nil
	}

	var prefixes []netip.Prefix
	for _, entry := range strings.Split(raw, ",") {
		entry = strings.TrimSpace(entry)
		if entry == "" {
			continue
		}
		prefix, err := netip.ParsePrefix(entry)
		if err != nil {
			return nil, fmt.Errorf("transport: trusted proxy %q is not a CIDR block: %w", entry, err)
		}
		prefixes = append(prefixes, prefix)
	}
	return prefixes, nil
}

// tokenBucket is a single caller's allowance.
//
// Tokens are computed lazily from elapsed time rather than refilled by a
// background ticker: one goroutine per caller would be its own resource
// problem, and a bucket nobody is using costs nothing to not refill.
type tokenBucket struct {
	tokens   float64
	lastSeen time.Time
}

// RateLimiter enforces a per-caller request budget.
type RateLimiter struct {
	config RateLimitConfig
	now    func() time.Time

	mu      sync.Mutex
	buckets map[string]*tokenBucket
}

// NewRateLimiter constructs a limiter.
func NewRateLimiter(config RateLimitConfig, now func() time.Time) *RateLimiter {
	if now == nil {
		now = time.Now
	}
	return &RateLimiter{
		config:  config,
		now:     now,
		buckets: make(map[string]*tokenBucket),
	}
}

// Allow reports whether a request from key may proceed.
func (l *RateLimiter) Allow(key string, ratePerSecond, burst float64) bool {
	if ratePerSecond <= 0 || burst <= 0 {
		return true
	}

	l.mu.Lock()
	defer l.mu.Unlock()

	now := l.now()
	bucket, known := l.buckets[key]
	if !known {
		bucket = &tokenBucket{tokens: burst, lastSeen: now}
		l.buckets[key] = bucket
	}

	elapsed := now.Sub(bucket.lastSeen).Seconds()
	if elapsed > 0 {
		bucket.tokens = math.Min(burst, bucket.tokens+elapsed*ratePerSecond)
	}
	bucket.lastSeen = now

	if bucket.tokens < 1 {
		return false
	}
	bucket.tokens--
	return true
}

// Evict drops buckets untouched for longer than idle, so the map does not grow
// with every caller the service has ever seen.
func (l *RateLimiter) Evict(idle time.Duration) int {
	l.mu.Lock()
	defer l.mu.Unlock()

	cutoff := l.now().Add(-idle)
	var removed int
	for key, bucket := range l.buckets {
		if bucket.lastSeen.Before(cutoff) {
			delete(l.buckets, key)
			removed++
		}
	}
	return removed
}

// Size reports how many buckets are tracked.
func (l *RateLimiter) Size() int {
	l.mu.Lock()
	defer l.mu.Unlock()
	return len(l.buckets)
}

// Rate limiting is deliberately two-stage (SRS-SEC-005).
//
// A single limiter placed before authentication can only key on the peer
// address, which lumps every caller behind a proxy or NAT into one bucket: one
// busy user would lock out their colleagues. A single limiter placed after
// authentication makes an unauthenticated flood pay for token verification
// before being refused.
//
// So both run. The peer stage is cheap and tight, and bounds unauthenticated
// abuse; the subject stage is the real per-caller budget.

// NewPeerRateLimitInterceptor bounds traffic by peer address.
//
// It must run BEFORE authentication, so a flood is refused without the cost of
// verifying a token. The peer address is a weak key behind a proxy, which is
// why this is a coarse backstop rather than the primary control.
func NewPeerRateLimitInterceptor(limiter *RateLimiter) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			peer := ClientAddress(req.Peer().Addr, req.Header().Get("X-Forwarded-For"),
				limiter.config.TrustedProxies)

			// Requests arriving with no credential at all get the tight budget:
			// they are the flood this stage exists to refuse cheaply, and they
			// are the ones that would otherwise pay for token verification.
			//
			// Requests carrying a credential get a much larger one. The header
			// is not verified here -- that is the auth interceptor's job a step
			// later -- so this is not a security decision, only a decision about
			// which bucket to spend. A forged header buys the flood nothing
			// except a token verification that fails.
			rate, burst := limiter.config.UnauthenticatedRequestsPerSecond, limiter.config.UnauthenticatedBurst
			if req.Header().Get(HeaderAuthorization) != "" {
				rate, burst = limiter.config.PeerRequestsPerSecond, limiter.config.PeerBurst
			}

			if !limiter.Allow("peer:"+peer, rate, burst) {
				return nil, ToConnect(
					rpcerr.ResourceExhausted("RATE_LIMIT_EXCEEDED", "too many requests"),
					CorrelationIDFromContext(ctx))
			}
			return next(ctx, req)
		}
	}
}

// ClientAddress resolves the address a rate-limit bucket should be keyed on.
//
// X-Forwarded-For is believed only when the immediate peer is inside a
// configured trusted network, and then only its last entry -- the one the
// trusted proxy itself appended. Earlier entries were supplied by whoever the
// proxy was talking to and can say anything.
func ClientAddress(peerAddr, forwardedFor string, trusted []netip.Prefix) string {
	peer := peerAddr
	if host, _, found := strings.Cut(peer, ":"); found {
		peer = host
	}
	if forwardedFor == "" || len(trusted) == 0 {
		return peer
	}

	parsed, err := netip.ParseAddr(peer)
	if err != nil {
		return peer
	}
	var isTrusted bool
	for _, prefix := range trusted {
		if prefix.Contains(parsed) {
			isTrusted = true
			break
		}
	}
	if !isTrusted {
		return peer
	}

	parts := strings.Split(forwardedFor, ",")
	candidate := strings.TrimSpace(parts[len(parts)-1])
	if candidate == "" {
		return peer
	}
	if _, err := netip.ParseAddr(candidate); err != nil {
		return peer
	}
	return candidate
}

// NewSubjectRateLimitInterceptor bounds traffic per authenticated caller.
//
// It must run AFTER authentication, where a subject is available. The key is
// the subject within its tenant, so one tenant's traffic cannot exhaust
// another's allowance and one compromised account cannot spend the whole
// tenant's budget.
func NewSubjectRateLimitInterceptor(limiter *RateLimiter) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			session, err := authctx.FromContext(ctx)
			if err != nil {
				// Public procedures reach here with no session; the peer stage
				// has already bounded them.
				return next(ctx, req)
			}

			key := "sub:" + session.TenantID + ":" + session.SubjectID
			if !limiter.Allow(key, limiter.config.RequestsPerSecond, limiter.config.Burst) {
				return nil, ToConnect(
					rpcerr.ResourceExhausted("RATE_LIMIT_EXCEEDED", "too many requests"),
					CorrelationIDFromContext(ctx))
			}
			return next(ctx, req)
		}
	}
}
