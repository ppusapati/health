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
	"errors"
	"fmt"
	"log/slog"
	"os"
	"strconv"
	"strings"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
	"go.opentelemetry.io/otel/trace"
)

const tracerName = "github.com/ppusapati/health/code"

// ExportConfig describes where traces go and how many of them.
type ExportConfig struct {
	// Endpoint is the OTLP collector, e.g. "otel-collector.observability:4317".
	// Empty means no exporter: spans are still created and propagated, and
	// nothing is shipped. That is the right default for tests and a laptop, and
	// must be a deliberate choice in a deployment rather than a fallback — see
	// SetupFromEnv.
	Endpoint string
	// Insecure sends without TLS. Correct for a collector reached over a
	// service mesh or a cluster-internal address, wrong over any network the
	// deployment does not control.
	Insecure bool
	// SampleRatio is the fraction of root traces recorded, 0..1. Parent-based:
	// a request already sampled upstream stays sampled, so a trace is never
	// half-recorded.
	SampleRatio float64
	// Version and Environment land on the resource, which is how an operator
	// tells a span from the canary apart from a span from the stable pods.
	Version     string
	Environment string
}

// DefaultSampleRatio records everything.
//
// Right for Wave 0, where the volume is small and a missing trace costs more
// than the storage. A production deployment lowers it through
// OTEL_TRACES_SAMPLER_ARG rather than by editing this.
const DefaultSampleRatio = 1.0

// exportTimeout bounds the shutdown flush. A pod being replaced must not hang
// on a collector that has already gone away.
const exportTimeout = 5 * time.Second

// Setup installs the global tracer provider and W3C propagators and returns a
// shutdown function.
//
// No exporter is configured: spans are created and context propagates, and
// nothing is shipped anywhere. Tests and local runs want exactly this. A
// deployment calls SetupFromEnv.
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

// SetupWithExport installs the tracer provider with an OTLP exporter.
//
// Returns an error rather than degrading to no export. A service that starts
// happily with its telemetry silently going nowhere is a service whose first
// incident is investigated without traces — and the configuration said it
// wanted them, so the mismatch is a fault, not a preference.
func SetupWithExport(ctx context.Context, serviceName string, cfg ExportConfig) (func(context.Context) error, error) {
	if cfg.Endpoint == "" {
		return Setup(serviceName), nil
	}
	if cfg.SampleRatio <= 0 || cfg.SampleRatio > 1 {
		cfg.SampleRatio = DefaultSampleRatio
	}

	options := []otlptracegrpc.Option{otlptracegrpc.WithEndpoint(cfg.Endpoint)}
	if cfg.Insecure {
		options = append(options, otlptracegrpc.WithInsecure())
	}

	exporter, err := otlptracegrpc.New(ctx, options...)
	if err != nil {
		return nil, fmt.Errorf("obs: connect trace exporter at %s: %w", cfg.Endpoint, err)
	}

	attrs := []attribute.KeyValue{semconv.ServiceName(serviceName)}
	if cfg.Version != "" {
		attrs = append(attrs, semconv.ServiceVersion(cfg.Version))
	}
	if cfg.Environment != "" {
		attrs = append(attrs, semconv.DeploymentEnvironment(cfg.Environment))
	}

	// WithSchemaless rather than resource.Merge with the default: merging
	// across two schema URLs fails, and the failure is a nil resource that
	// strips service.name from every span.
	res := resource.NewSchemaless(attrs...)

	tp := sdktrace.NewTracerProvider(
		// Parent-based, so a sampling decision made at the browser or the
		// gateway is honoured all the way down. Sampling each hop independently
		// produces traces with holes in them, which are worse than no trace:
		// they look complete.
		sdktrace.WithSampler(sdktrace.ParentBased(sdktrace.TraceIDRatioBased(cfg.SampleRatio))),
		sdktrace.WithBatcher(exporter, sdktrace.WithBatchTimeout(exportTimeout)),
		sdktrace.WithResource(res),
	)

	otel.SetTracerProvider(tp)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(
		propagation.TraceContext{},
		propagation.Baggage{},
	))
	slog.SetDefault(NewLogger(serviceName))

	return func(ctx context.Context) error {
		ctx, cancel := context.WithTimeout(ctx, exportTimeout)
		defer cancel()
		// Flush before closing: the spans from the request that was in flight
		// when SIGTERM arrived are the ones most worth having.
		return errors.Join(tp.Shutdown(ctx), exporter.Shutdown(ctx))
	}, nil
}

// SetupFromEnv reads the standard OpenTelemetry environment variables.
//
// OTEL_EXPORTER_OTLP_ENDPOINT   host:port of the collector; empty disables export
// OTEL_EXPORTER_OTLP_INSECURE   "true" to send without TLS
// OTEL_TRACES_SAMPLER_ARG       sampling ratio 0..1, default 1
// DEPLOY_ENVIRONMENT            dev / preprod / prod, stamped on every span
//
// The names are the OpenTelemetry standard ones on purpose: an operator who has
// configured any other OTLP service already knows them, and the manifests
// already set them.
func SetupFromEnv(ctx context.Context, serviceName, version string) (func(context.Context) error, error) {
	cfg := ExportConfig{
		Endpoint:    strings.TrimPrefix(strings.TrimPrefix(os.Getenv("OTEL_EXPORTER_OTLP_ENDPOINT"), "http://"), "https://"),
		Insecure:    strings.EqualFold(os.Getenv("OTEL_EXPORTER_OTLP_INSECURE"), "true"),
		SampleRatio: DefaultSampleRatio,
		Version:     version,
		Environment: os.Getenv("DEPLOY_ENVIRONMENT"),
	}

	// An http:// endpoint means insecure, whatever the flag says. Honouring the
	// scheme rather than silently attempting TLS against a plaintext collector
	// saves an operator a confusing handshake failure.
	if strings.HasPrefix(os.Getenv("OTEL_EXPORTER_OTLP_ENDPOINT"), "http://") {
		cfg.Insecure = true
	}

	if raw := os.Getenv("OTEL_TRACES_SAMPLER_ARG"); raw != "" {
		ratio, err := strconv.ParseFloat(raw, 64)
		if err != nil || ratio < 0 || ratio > 1 {
			// Not a silent default. An operator who wrote "0.1%" believing they
			// had configured a tenth of a percent should find out at startup,
			// not from a bill.
			return nil, fmt.Errorf("obs: OTEL_TRACES_SAMPLER_ARG must be a ratio between 0 and 1, got %q", raw)
		}
		cfg.SampleRatio = ratio
	}

	return SetupWithExport(ctx, serviceName, cfg)
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
