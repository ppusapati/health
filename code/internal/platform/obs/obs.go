// Package obs is the OpenTelemetry and safe-logging baseline.
//
// Two rules drive the design:
//   - Trace context propagates from the browser through RPC, database and
//     event hops so one correlation ID reconstructs a whole journey
//     (SRS-API-014, SRS-PLT-012).
//   - Routine telemetry never carries PHI or secrets (SRS-API-009,
//     SRS-WEB-010, FIT-06). Logging takes explicit allowlisted attributes
//     rather than whole request/response messages.
package obs

import (
	"context"
	"log/slog"
	"os"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/propagation"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	"go.opentelemetry.io/otel/trace"
)

const tracerName = "github.com/ppusapati/health/code"

// Setup installs the global tracer provider and W3C propagators and returns a
// shutdown function. The exporter is intentionally pluggable: the collector
// endpoint is a deployment concern, so the default here is a no-op sampler
// pipeline suitable for tests and local runs.
func Setup(serviceName string, opts ...sdktrace.TracerProviderOption) func(context.Context) error {
	base := []sdktrace.TracerProviderOption{sdktrace.WithSampler(sdktrace.AlwaysSample())}
	tp := sdktrace.NewTracerProvider(append(base, opts...)...)

	otel.SetTracerProvider(tp)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(
		propagation.TraceContext{},
		propagation.Baggage{},
	))

	slog.SetDefault(NewLogger(serviceName))
	return tp.Shutdown
}

// Tracer returns the platform tracer.
func Tracer() trace.Tracer { return otel.Tracer(tracerName) }

// NewLogger builds the structured JSON logger. Level comes from LOG_LEVEL so
// operators can raise verbosity without a redeploy.
func NewLogger(serviceName string) *slog.Logger {
	level := slog.LevelInfo
	if err := level.UnmarshalText([]byte(os.Getenv("LOG_LEVEL"))); err != nil {
		level = slog.LevelInfo
	}
	h := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: level})
	return slog.New(h).With(slog.String("service", serviceName))
}

// SafeAttrs are the identifiers permitted in routine telemetry. Deliberately
// narrow: identifiers correlate, payloads leak.
type SafeAttrs struct {
	TenantID      string
	SubjectID     string
	CorrelationID string
	RequestID     string
	Action        string
	Outcome       string
}

// LogAttrs converts the allowlist to slog attributes, skipping empties.
func (a SafeAttrs) LogAttrs() []slog.Attr {
	out := make([]slog.Attr, 0, 6)
	for _, kv := range []struct{ k, v string }{
		{"tenant_id", a.TenantID},
		{"subject_id", a.SubjectID},
		{"correlation_id", a.CorrelationID},
		{"request_id", a.RequestID},
		{"action", a.Action},
		{"outcome", a.Outcome},
	} {
		if kv.v != "" {
			out = append(out, slog.String(kv.k, kv.v))
		}
	}
	return out
}

// SpanAttrs converts the allowlist to span attributes.
func (a SafeAttrs) SpanAttrs() []attribute.KeyValue {
	out := make([]attribute.KeyValue, 0, 6)
	for _, kv := range []struct{ k, v string }{
		{"tenant.id", a.TenantID},
		{"subject.id", a.SubjectID},
		{"correlation.id", a.CorrelationID},
		{"request.id", a.RequestID},
		{"action", a.Action},
		{"outcome", a.Outcome},
	} {
		if kv.v != "" {
			out = append(out, attribute.String(kv.k, kv.v))
		}
	}
	return out
}
