package transport_test

import (
	"context"
	"errors"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/transport"
)

// deadlineHarness runs the interceptor over a handler and reports what the
// handler observed.
func deadlineHarness(t *testing.T, ctx context.Context, procedure string,
	overrides map[string]time.Duration,
	handler func(context.Context) error) (observedBudget time.Duration, err error) {
	t.Helper()

	interceptor := transport.NewDeadlineInterceptor(overrides)
	wrapped := interceptor(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		if deadline, ok := ctx.Deadline(); ok {
			observedBudget = time.Until(deadline)
		}
		if err := handler(ctx); err != nil {
			return nil, err
		}
		return connect.NewResponse(&struct{}{}), nil
	})

	req := connect.NewRequest(&struct{}{})
	_, err = wrapped(ctx, &spoofedRequest{AnyRequest: req, procedure: procedure})
	return observedBudget, err
}

func noop(context.Context) error { return nil }

// SRS-API-010's verification clause: an abandoned request does not create
// runaway synchronous work. The client disconnects mid-handler and the
// handler's context is cancelled, so the work it is driving stops.
func TestAbandonedRequestCancelsTheHandler(t *testing.T) {
	ctx, disconnect := context.WithCancel(context.Background())

	var sawCancellation atomic.Bool
	started := make(chan struct{})

	go func() {
		<-started
		disconnect() // the browser tab closes
	}()

	_, err := deadlineHarness(t, ctx, "/healthcare.billing.v1.BillingService/Report", nil,
		func(ctx context.Context) error {
			close(started)
			// Stand in for a long query. It must notice the disconnect rather
			// than run to completion for nobody.
			select {
			case <-ctx.Done():
				sawCancellation.Store(true)
				return ctx.Err()
			case <-time.After(5 * time.Second):
				return nil
			}
		})

	if !sawCancellation.Load() {
		t.Fatal("the handler never observed the client's disconnect")
	}
	// CANCELED, not DEADLINE_EXCEEDED: nobody is waiting, so a client must not
	// retry. Retrying abandoned work is how one tab close becomes a storm.
	if connect.CodeOf(err) != connect.CodeCanceled {
		t.Fatalf("want Canceled, got %v (%v)", connect.CodeOf(err), err)
	}
}

// A request nobody abandons still gets a bound, so a handler cannot hold a
// connection indefinitely.
func TestEveryRequestGetsADeadline(t *testing.T) {
	budget, err := deadlineHarness(t, context.Background(),
		"/healthcare.billing.v1.BillingService/CreateInvoice", nil, noop)
	if err != nil {
		t.Fatalf("handler: %v", err)
	}
	if budget <= 0 {
		t.Fatal("the handler ran with no deadline at all")
	}
	if budget > transport.DefaultDeadline {
		t.Fatalf("budget %v exceeds the default %v", budget, transport.DefaultDeadline)
	}
}

func TestPerProcedureOverride(t *testing.T) {
	const procedure = "/healthcare.reporting.v1.ReportingService/Generate"
	overrides := map[string]time.Duration{procedure: 90 * time.Second}

	budget, err := deadlineHarness(t, context.Background(), procedure, overrides, noop)
	if err != nil {
		t.Fatalf("handler: %v", err)
	}
	if budget <= transport.DefaultDeadline {
		t.Fatalf("the override did not apply: budget %v", budget)
	}

	// A procedure with no override still gets the default.
	budget, err = deadlineHarness(t, context.Background(),
		"/healthcare.billing.v1.BillingService/CreateInvoice", overrides, noop)
	if err != nil {
		t.Fatalf("handler: %v", err)
	}
	if budget > transport.DefaultDeadline {
		t.Fatalf("an unlisted procedure got %v", budget)
	}
}

// A client's deadline is honoured when it is shorter: it has already decided
// how long it will wait, and spending longer produces a result nobody reads.
func TestAShorterClientDeadlineWins(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	budget, err := deadlineHarness(t, ctx,
		"/healthcare.billing.v1.BillingService/CreateInvoice", nil, noop)
	if err != nil {
		t.Fatalf("handler: %v", err)
	}
	if budget > 2*time.Second {
		t.Fatalf("budget %v exceeds the client's own 2s deadline", budget)
	}
}

// A client-supplied deadline is a request, not an instruction. Without a cap,
// one misconfigured integration can pin a connection for an hour.
func TestAClientCannotExtendBeyondTheCap(t *testing.T) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Hour)
	defer cancel()

	const procedure = "/healthcare.reporting.v1.ReportingService/Generate"
	budget, err := deadlineHarness(t, ctx, procedure,
		map[string]time.Duration{procedure: time.Hour}, noop)
	if err != nil {
		t.Fatalf("handler: %v", err)
	}
	if budget > transport.MaxDeadline {
		t.Fatalf("budget %v exceeds the %v cap", budget, transport.MaxDeadline)
	}
}

// A request that arrives already expired is refused rather than started: the
// only thing running it can produce is load.
func TestAnExpiredDeadlineIsRefusedImmediately(t *testing.T) {
	ctx, cancel := context.WithDeadline(context.Background(), time.Now().Add(-time.Second))
	defer cancel()

	var ran atomic.Bool
	_, err := deadlineHarness(t, ctx, "/healthcare.billing.v1.BillingService/CreateInvoice", nil,
		func(context.Context) error {
			ran.Store(true)
			return nil
		})

	if ran.Load() {
		t.Fatal("an already-expired request was executed")
	}
	if err == nil {
		t.Fatal("an already-expired request was accepted")
	}
}

// Exceeding the budget is DEADLINE_EXCEEDED, which tells a client the work
// might succeed with more time — the opposite advice from CANCELED.
func TestExceedingTheBudgetIsDeadlineExceeded(t *testing.T) {
	const procedure = "/healthcare.billing.v1.BillingService/Slow"
	_, err := deadlineHarness(t, context.Background(), procedure,
		map[string]time.Duration{procedure: 50 * time.Millisecond},
		func(ctx context.Context) error {
			<-ctx.Done()
			return ctx.Err()
		})

	if connect.CodeOf(err) != connect.CodeDeadlineExceeded {
		t.Fatalf("want DeadlineExceeded, got %v (%v)", connect.CodeOf(err), err)
	}
}

// The helper expensive work uses to decide whether to keep going. Checking
// only for Canceled misses the deadline case, and a handler still working past
// its deadline is exactly as wasteful as one working after a disconnect.
func TestAbandonedCoversBothWaysARequestDies(t *testing.T) {
	if !transport.Abandoned(context.Canceled) {
		t.Error("a cancelled request was not reported abandoned")
	}
	if !transport.Abandoned(context.DeadlineExceeded) {
		t.Error("an expired request was not reported abandoned")
	}
	if transport.Abandoned(errors.New("database is down")) {
		t.Error("an ordinary failure was reported abandoned")
	}
	if transport.Abandoned(nil) {
		t.Error("nil was reported abandoned")
	}
}
