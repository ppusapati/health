package obs_test

import (
	"context"
	"net"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/obs"
	coltracepb "go.opentelemetry.io/proto/otlp/collector/trace/v1"
	tracepb "go.opentelemetry.io/proto/otlp/trace/v1"
	"google.golang.org/grpc"
)

// Trace export (P0-10, SRS-PLT-012).
//
// The deployment manifests have set OTEL_EXPORTER_OTLP_ENDPOINT since Wave 0
// began, and until now the code ignored it: spans were created, propagated and
// dropped. That failure is invisible — the service is healthy, the logs are
// fine, and the only symptom is an empty trace view during an incident.
//
// So this is tested against a real OTLP receiver rather than by asserting that
// a provider was constructed. A test that only checks the exporter exists would
// have passed throughout the period the export did not work.

// collector is an in-process OTLP gRPC receiver.
type collector struct {
	coltracepb.UnimplementedTraceServiceServer

	mu       sync.Mutex
	received []*tracepb.ResourceSpans
	arrived  chan struct{}
}

func newCollector(t *testing.T) (*collector, string) {
	t.Helper()

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatalf("listen: %v", err)
	}

	c := &collector{arrived: make(chan struct{}, 64)}
	server := grpc.NewServer()
	coltracepb.RegisterTraceServiceServer(server, c)

	go func() { _ = server.Serve(listener) }()
	t.Cleanup(server.Stop)

	return c, listener.Addr().String()
}

func (c *collector) Export(_ context.Context, req *coltracepb.ExportTraceServiceRequest) (
	*coltracepb.ExportTraceServiceResponse, error) {

	c.mu.Lock()
	c.received = append(c.received, req.GetResourceSpans()...)
	c.mu.Unlock()

	select {
	case c.arrived <- struct{}{}:
	default:
	}
	return &coltracepb.ExportTraceServiceResponse{}, nil
}

func (c *collector) await(t *testing.T, within time.Duration) []*tracepb.ResourceSpans {
	t.Helper()
	select {
	case <-c.arrived:
	case <-time.After(within):
		t.Fatalf("no spans reached the collector within %s", within)
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	return append([]*tracepb.ResourceSpans(nil), c.received...)
}

func (c *collector) count() int {
	c.mu.Lock()
	defer c.mu.Unlock()
	return len(c.received)
}

func TestSpansReachTheConfiguredCollector(t *testing.T) {
	sink, endpoint := newCollector(t)
	ctx := context.Background()

	shutdown, err := obs.SetupWithExport(ctx, "core", obs.ExportConfig{
		Endpoint: endpoint, Insecure: true, SampleRatio: 1,
		Version: "1.2.3", Environment: "preprod",
	})
	if err != nil {
		t.Fatalf("SetupWithExport: %v", err)
	}

	_, span := obs.Tracer().Start(ctx, "CreateFacility")
	span.End()

	// Shutdown flushes. The spans from the request in flight when SIGTERM
	// arrived are the ones most worth having, so this is not just tidiness.
	if err := shutdown(ctx); err != nil {
		t.Fatalf("shutdown: %v", err)
	}

	batches := sink.await(t, 10*time.Second)
	if len(batches) == 0 {
		t.Fatal("no resource spans received")
	}

	var names []string
	for _, batch := range batches {
		for _, scope := range batch.GetScopeSpans() {
			for _, s := range scope.GetSpans() {
				names = append(names, s.GetName())
			}
		}
	}
	if !contains(names, "CreateFacility") {
		t.Fatalf("the span did not arrive; got %v", names)
	}

	// Resource attributes are what let an operator tell a span from the canary
	// apart from a span from the stable pods. A span with no service.name is
	// almost useless in a shared collector.
	attrs := map[string]string{}
	for _, kv := range batches[0].GetResource().GetAttributes() {
		attrs[kv.GetKey()] = kv.GetValue().GetStringValue()
	}
	for key, want := range map[string]string{
		"service.name":           "core",
		"service.version":        "1.2.3",
		"deployment.environment": "preprod",
	} {
		if attrs[key] != want {
			t.Errorf("resource %s = %q, want %q (all: %v)", key, attrs[key], want, attrs)
		}
	}
}

// No endpoint means no export, and that must stay a working configuration: it
// is what every test and every laptop runs.
func TestNoEndpointDisablesExportWithoutFailing(t *testing.T) {
	shutdown, err := obs.SetupWithExport(context.Background(), "core", obs.ExportConfig{})
	if err != nil {
		t.Fatalf("SetupWithExport with no endpoint: %v", err)
	}

	_, span := obs.Tracer().Start(context.Background(), "local")
	span.End()

	if err := shutdown(context.Background()); err != nil {
		t.Fatalf("shutdown: %v", err)
	}
}

// A sampling ratio of zero would silently record nothing. Treating it as
// unconfigured rather than as "sample none" is the safer reading: an operator
// who wanted no traces disables the endpoint.
func TestAZeroSampleRatioDoesNotSilenceTracing(t *testing.T) {
	sink, endpoint := newCollector(t)
	ctx := context.Background()

	shutdown, err := obs.SetupWithExport(ctx, "core", obs.ExportConfig{
		Endpoint: endpoint, Insecure: true, SampleRatio: 0,
	})
	if err != nil {
		t.Fatalf("SetupWithExport: %v", err)
	}

	_, span := obs.Tracer().Start(ctx, "still-recorded")
	span.End()
	if err := shutdown(ctx); err != nil {
		t.Fatalf("shutdown: %v", err)
	}

	if sink.count() == 0 {
		t.Fatal("a zero ratio silenced tracing entirely")
	}
}

// A malformed sampler argument is a startup failure. An operator who wrote
// "0.1%" believing they had configured a tenth of a percent should find out at
// startup rather than from a bill.
func TestAMalformedSamplerArgumentIsRefused(t *testing.T) {
	_, endpoint := newCollector(t)

	for _, bad := range []string{"0.1%", "ten percent", "-1", "2"} {
		t.Run(bad, func(t *testing.T) {
			t.Setenv("OTEL_EXPORTER_OTLP_ENDPOINT", endpoint)
			t.Setenv("OTEL_TRACES_SAMPLER_ARG", bad)

			if _, err := obs.SetupFromEnv(context.Background(), "core", "test"); err == nil {
				t.Fatalf("OTEL_TRACES_SAMPLER_ARG=%q was accepted", bad)
			}
		})
	}
}

// The manifests set an http:// URL. The exporter wants host:port, and the
// scheme says whether TLS is expected — so both have to be honoured, or the
// deployment that has been shipping this configuration all along still fails.
func TestTheEndpointFromTheManifestsWorks(t *testing.T) {
	sink, endpoint := newCollector(t)

	t.Setenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://"+endpoint)
	t.Setenv("OTEL_TRACES_SAMPLER_ARG", "")

	ctx := context.Background()
	shutdown, err := obs.SetupFromEnv(ctx, "core", "test")
	if err != nil {
		t.Fatalf("SetupFromEnv: %v", err)
	}

	_, span := obs.Tracer().Start(ctx, "FromManifest")
	span.End()
	if err := shutdown(ctx); err != nil {
		t.Fatalf("shutdown: %v", err)
	}

	if sink.count() == 0 {
		t.Fatal("the manifest's http:// endpoint exported nothing")
	}
}

func contains(haystack []string, needle string) bool {
	for _, s := range haystack {
		if strings.Contains(s, needle) {
			return true
		}
	}
	return false
}
