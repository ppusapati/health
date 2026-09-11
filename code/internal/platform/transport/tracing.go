package transport

import (
	"context"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/obs"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/codes"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/trace"
)

// NewTracingInterceptor starts a server span per RPC and records the outcome.
//
// The span name is the procedure. Span attributes are drawn only from the
// obs.SafeAttrs allowlist, so a request message can never be serialised into
// telemetry (SRS-WEB-010, SRS-API-009, FIT-06).
func NewTracingInterceptor() connect.UnaryInterceptorFunc {
	tracer := otel.Tracer("github.com/ppusapati/health/code/transport")

	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			// Continue an inbound trace when the client supplied one.
			ctx = otel.GetTextMapPropagator().Extract(ctx,
				propagation.HeaderCarrier(req.Header()))

			ctx, span := tracer.Start(ctx, req.Spec().Procedure,
				trace.WithSpanKind(trace.SpanKindServer))
			defer span.End()

			span.SetAttributes(obs.SafeAttrs{
				Action: req.Spec().Procedure,
			}.SpanAttrs()...)

			resp, err := next(ctx, req)
			if err != nil {
				// The status code is recorded; the error message is not, since
				// a validation message can quote user input.
				span.SetStatus(codes.Error, connect.CodeOf(err).String())
				span.SetAttributes(obs.SafeAttrs{Outcome: "error"}.SpanAttrs()...)
				return nil, err
			}

			span.SetStatus(codes.Ok, "")
			span.SetAttributes(obs.SafeAttrs{Outcome: "success"}.SpanAttrs()...)
			return resp, nil
		}
	}
}
