package transport

import (
	"context"
	"errors"
	"time"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Deadlines and cancellation propagation (SRS-API-010).
//
// The verification clause names the failure: "abandoned browser request does
// not create runaway synchronous work". A user closes a tab; the browser drops
// the connection; and unless something notices, the handler keeps holding a
// database connection, a transaction and a row lock for a query nobody will
// ever read. Under load that is how a service dies — not from the work it is
// doing, but from the work it is doing for nobody.
//
// Go gives most of this for free: net/http cancels the request context when
// the client disconnects, and pgx honours context cancellation. What it does
// not give is a bound on a request that nobody abandons and nobody times out,
// so this interceptor supplies one — and, more importantly, makes the bound
// visible and per-procedure rather than a single global timeout that is always
// wrong for something.

// DefaultDeadline bounds any request that does not set its own.
//
// Thirty seconds is chosen against the client, not the server: a browser or a
// mobile app has given up long before that, so a handler still working at
// thirty seconds is working for nobody by definition.
const DefaultDeadline = 30 * time.Second

// MaxDeadline caps what a client may ask for.
//
// A client-supplied deadline is a request, not an instruction. Without a cap,
// one caller setting an hour-long timeout can pin a connection for an hour,
// and the caller most likely to do that is a misconfigured integration rather
// than a legitimate slow consumer — a legitimately slow operation belongs in a
// job (SRS-API-011), which is why this cap can be tight.
const MaxDeadline = 2 * time.Minute

// NewDeadlineInterceptor bounds every request.
//
// perProcedure overrides the default for named procedures. Nil is fine and
// means every procedure gets DefaultDeadline.
func NewDeadlineInterceptor(perProcedure map[string]time.Duration) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			budget := DefaultDeadline
			if override, found := perProcedure[req.Spec().Procedure]; found && override > 0 {
				budget = override
			}

			// A client's own deadline is honoured when it is shorter. Extending
			// it would be wrong twice over: the client has already decided it
			// will not wait, and a caller could otherwise raise its own limit
			// past what the server is willing to spend.
			if clientDeadline, hasDeadline := ctx.Deadline(); hasDeadline {
				remaining := time.Until(clientDeadline)
				if remaining <= 0 {
					return nil, ToConnect(
						rpcerr.FailedPrecondition("API_DEADLINE_ALREADY_PASSED",
							"the request arrived with an expired deadline"),
						CorrelationIDFromContext(ctx))
				}
				if remaining < budget {
					budget = remaining
				}
			}
			if budget > MaxDeadline {
				budget = MaxDeadline
			}

			ctx, cancel := context.WithTimeout(ctx, budget)
			// Cancel on every path, so the work a handler started downstream
			// stops when this one returns — including when it returns early
			// with an error.
			defer cancel()

			res, err := next(ctx, req)
			if err != nil {
				return nil, translateCancellation(err)
			}
			return res, nil
		}
	}
}

// translateCancellation turns a context failure into the right status.
//
// The distinction matters to the client's retry behaviour, and getting it
// wrong is costly in both directions. DEADLINE_EXCEEDED says "this might work
// if you allow more time", so a client retries. CANCELED says "nobody is
// waiting for this", so a client must not — retrying work that was abandoned
// is how one tab close becomes an abandoned-request storm.
//
// Everything else passes through untouched. This interceptor sits above the
// error interceptor, so a domain error arriving here has already been rendered
// into the wire contract; converting it again would replace a precise
// PERMISSION_DENIED with a generic INTERNAL and take the structured detail —
// the code a client branches on — with it.
func translateCancellation(err error) error {
	switch {
	case errors.Is(err, context.DeadlineExceeded):
		return connect.NewError(connect.CodeDeadlineExceeded, err)
	case errors.Is(err, context.Canceled):
		// The client went away. Not an error the service did anything about,
		// and logging it as one buries real failures under tab closes.
		return connect.NewError(connect.CodeCanceled, err)
	default:
		return err
	}
}

// Abandoned reports whether an error means nobody is waiting for the result.
//
// Worth a helper because the check appears wherever expensive work decides
// whether to continue, and `errors.Is(err, context.Canceled)` alone misses the
// deadline case — a handler that keeps going after its deadline is exactly as
// wasteful as one that keeps going after a disconnect.
func Abandoned(err error) bool {
	return errors.Is(err, context.Canceled) || errors.Is(err, context.DeadlineExceeded)
}
