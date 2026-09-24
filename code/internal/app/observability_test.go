package app_test

import (
	"context"
	"strings"
	"testing"

	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"go.opentelemetry.io/otel"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	"go.opentelemetry.io/otel/sdk/trace/tracetest"
)

// captureSpans installs an in-memory exporter for the duration of a test and
// restores the previous provider afterwards.
func captureSpans(t *testing.T) *tracetest.InMemoryExporter {
	t.Helper()

	exporter := tracetest.NewInMemoryExporter()
	previous := otel.GetTracerProvider()

	provider := sdktrace.NewTracerProvider(
		sdktrace.WithSyncer(exporter),
		sdktrace.WithSampler(sdktrace.AlwaysSample()),
	)
	otel.SetTracerProvider(provider)

	t.Cleanup(func() {
		_ = provider.Shutdown(context.Background())
		otel.SetTracerProvider(previous)
	})
	return exporter
}

// Gate A6, and SRS-API-014's verification clause: one trace and correlation
// identifier follows an end-to-end transaction. The trace must cross the
// client, RPC, database and event boundary and carry the identifiers that join
// it to an audit record.
func TestTraceCrossesRequestAndCarriesCorrelation(t *testing.T) {
	exporter := captureSpans(t)
	h := newHarness(t)
	ctx := context.Background()

	tenantID := h.provisionTenant(t, "Apollo Group")
	if _, err := h.org.CreateFacility(ctx, as(tenantAdminToken(tenantID),
		&organizationv1.CreateFacilityRequest{
			Code:        "MAIN",
			DisplayName: "Main Hospital",
			Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone:    "Asia/Kolkata",
		})); err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}

	spans := exporter.GetSpans()
	if len(spans) == 0 {
		t.Fatal("no spans were recorded for the request")
	}

	var createSpan *tracetest.SpanStub
	for i := range spans {
		if strings.HasSuffix(spans[i].Name, "/CreateFacility") {
			createSpan = &spans[i]
			break
		}
	}
	if createSpan == nil {
		t.Fatalf("no span for CreateFacility; got %v", spanNames(spans))
	}

	attrs := map[string]string{}
	for _, a := range createSpan.Attributes {
		attrs[string(a.Key)] = a.Value.Emit()
	}
	if attrs["correlation.id"] == "" {
		t.Fatalf("span has no correlation.id: %v", attrs)
	}
	if attrs["tenant.id"] != tenantID {
		t.Fatalf("span tenant.id = %q, want %q", attrs["tenant.id"], tenantID)
	}
	if attrs["outcome"] != "success" {
		t.Fatalf("span outcome = %q", attrs["outcome"])
	}
}

// SRS-WEB-010 / SRS-API-009 / FIT-06: routine telemetry must not carry request
// payloads. The allowlist is the control, and this test is what stops a future
// "just add the request for debugging" change.
func TestSpansCarryNoRequestPayload(t *testing.T) {
	exporter := captureSpans(t)
	h := newHarness(t)
	ctx := context.Background()

	const secretName = "Sensitive Cardiology Wing"
	tenantID := h.provisionTenant(t, "Apollo Group")
	if _, err := h.org.CreateFacility(ctx, as(tenantAdminToken(tenantID),
		&organizationv1.CreateFacilityRequest{
			Code:        "CARD",
			DisplayName: secretName,
			Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
			TimeZone:    "Asia/Kolkata",
		})); err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}

	allowed := map[string]bool{
		"tenant.id": true, "subject.id": true, "correlation.id": true,
		"request.id": true, "action": true, "outcome": true,
	}

	for _, span := range exporter.GetSpans() {
		for _, a := range span.Attributes {
			key := string(a.Key)
			if !allowed[key] {
				t.Errorf("span %q carries non-allowlisted attribute %q", span.Name, key)
			}
			if strings.Contains(a.Value.Emit(), secretName) {
				t.Errorf("span %q leaked request content in %q", span.Name, key)
			}
		}
		if strings.Contains(span.Status.Description, secretName) {
			t.Errorf("span %q leaked request content in its status", span.Name)
		}
	}
}

// A rejected request must still produce a span, otherwise failures are the one
// thing missing from the trace when an operator needs them most.
func TestFailedRequestIsStillTraced(t *testing.T) {
	exporter := captureSpans(t)
	h := newHarness(t)

	_, err := h.org.ListFacilities(context.Background(),
		as("tenant-a:user-1:not_a_real_role", &organizationv1.ListFacilitiesRequest{}))
	if err == nil {
		t.Fatal("request with an unknown role succeeded")
	}

	var found bool
	for _, span := range exporter.GetSpans() {
		if strings.HasSuffix(span.Name, "/ListFacilities") {
			found = true
			attrs := map[string]string{}
			for _, a := range span.Attributes {
				attrs[string(a.Key)] = a.Value.Emit()
			}
			if attrs["outcome"] != "error" {
				t.Fatalf("failed request span outcome = %q", attrs["outcome"])
			}
		}
	}
	if !found {
		t.Fatalf("no span for the failed request; got %v", spanNames(exporter.GetSpans()))
	}
}

func spanNames(spans tracetest.SpanStubs) []string {
	out := make([]string, 0, len(spans))
	for _, s := range spans {
		out = append(out, s.Name)
	}
	return out
}
