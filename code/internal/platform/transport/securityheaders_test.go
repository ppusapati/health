package transport_test

import (
	"crypto/tls"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/transport"
)

// Automated security-header baseline (SRS-WEB-015).

func respond(t *testing.T, cfg transport.SecurityHeaderConfig, req *http.Request) http.Header {
	t.Helper()
	handler := transport.NewSecurityHeaders(cfg, http.HandlerFunc(
		func(w http.ResponseWriter, _ *http.Request) { w.WriteHeader(http.StatusOK) }))

	rec := httptest.NewRecorder()
	handler.ServeHTTP(rec, req)
	return rec.Result().Header
}

func plainRequest() *http.Request {
	return httptest.NewRequest(http.MethodGet, "http://localhost/", nil)
}

func tlsRequest() *http.Request {
	req := httptest.NewRequest(http.MethodGet, "https://app.example/", nil)
	req.TLS = &tls.ConnectionState{}
	return req
}

func TestBaselineHeadersArePresent(t *testing.T) {
	headers := respond(t, transport.DefaultSecurityHeaders(), tlsRequest())

	required := map[string]string{
		"X-Content-Type-Options":       "nosniff",
		"X-Frame-Options":              "DENY",
		"Referrer-Policy":              "same-origin",
		"Cross-Origin-Opener-Policy":   "same-origin",
		"Cross-Origin-Resource-Policy": "same-origin",
	}
	for name, want := range required {
		if got := headers.Get(name); got != want {
			t.Errorf("%s = %q, want %q", name, got, want)
		}
	}
	if headers.Get("Content-Security-Policy") == "" {
		t.Error("no Content-Security-Policy")
	}
	if headers.Get("Permissions-Policy") == "" {
		t.Error("no Permissions-Policy")
	}
}

// The directive that makes the CSP worth having. An injected <script> or an
// onerror handler in a clinician's note does nothing under it.
func TestScriptSourceAdmitsNoInlineOrEval(t *testing.T) {
	policy := respond(t, transport.DefaultSecurityHeaders(), tlsRequest()).
		Get("Content-Security-Policy")

	if !strings.Contains(policy, "script-src 'self'") {
		t.Fatalf("script-src is not restricted to self: %s", policy)
	}
	for _, forbidden := range []string{"'unsafe-inline'", "'unsafe-eval'"} {
		// Checked against the script-src directive specifically: style-src
		// legitimately carries 'unsafe-inline', so a whole-policy search would
		// pass vacuously or fail wrongly.
		for _, directive := range strings.Split(policy, ";") {
			directive = strings.TrimSpace(directive)
			if strings.HasPrefix(directive, "script-src") && strings.Contains(directive, forbidden) {
				t.Errorf("script-src allows %s: %s", forbidden, directive)
			}
		}
	}
}

func TestClickjackingAndBaseTagAreClosed(t *testing.T) {
	policy := respond(t, transport.DefaultSecurityHeaders(), tlsRequest()).
		Get("Content-Security-Policy")

	for _, directive := range []string{
		"frame-ancestors 'none'",
		// Stops an injected <base> re-pointing every relative URL — including
		// the API calls — at an attacker's origin.
		"base-uri 'self'",
		// The other half of CSRF defence: a compromised page cannot post
		// elsewhere.
		"form-action 'self'",
		"object-src 'none'",
	} {
		if !strings.Contains(policy, directive) {
			t.Errorf("policy is missing %q: %s", directive, policy)
		}
	}
}

func TestConnectSourcesAreConfigurable(t *testing.T) {
	// The web app and the API are usually separate origins, so 'self' alone
	// would break every call.
	cfg := transport.DefaultSecurityHeaders()
	cfg.ConnectSources = []string{"'self'", "https://api.example"}

	policy := respond(t, cfg, tlsRequest()).Get("Content-Security-Policy")
	if !strings.Contains(policy, "connect-src 'self' https://api.example") {
		t.Fatalf("connect-src not configured: %s", policy)
	}
}

// Sending HSTS over http is ignored by browsers and, on localhost, would pin a
// developer's whole origin to https — including other projects on other ports.
func TestHSTSOnlyOverTLS(t *testing.T) {
	cfg := transport.DefaultSecurityHeaders()

	if got := respond(t, cfg, plainRequest()).Get("Strict-Transport-Security"); got != "" {
		t.Errorf("HSTS sent over plaintext: %q", got)
	}

	over := respond(t, cfg, tlsRequest()).Get("Strict-Transport-Security")
	if !strings.Contains(over, "max-age=63072000") {
		t.Errorf("HSTS max-age is not the preload-list value: %q", over)
	}
	if !strings.Contains(over, "includeSubDomains") {
		t.Errorf("HSTS does not include subdomains: %q", over)
	}

	// Behind a TLS-terminating ingress the connection to the pod is plaintext,
	// so the forwarded-proto header is what says the client's hop was secure.
	forwarded := httptest.NewRequest(http.MethodGet, "http://core.svc/", nil)
	forwarded.Header.Set("X-Forwarded-Proto", "https")
	if respond(t, cfg, forwarded).Get("Strict-Transport-Security") == "" {
		t.Error("no HSTS behind a TLS-terminating ingress")
	}
}

func TestReportOnlyModeUsesTheReportingHeader(t *testing.T) {
	cfg := transport.DefaultSecurityHeaders()
	cfg.ReportOnly = true
	cfg.ReportURI = "/csp-report"

	headers := respond(t, cfg, tlsRequest())
	if headers.Get("Content-Security-Policy") != "" {
		t.Error("report-only mode still enforced the policy")
	}
	policy := headers.Get("Content-Security-Policy-Report-Only")
	if policy == "" {
		t.Fatal("no report-only policy")
	}
	if !strings.Contains(policy, "report-uri /csp-report") {
		t.Errorf("no report-uri: %s", policy)
	}
}

// The camera and microphone case is not hypothetical: these run on machines in
// consulting rooms.
func TestSensitiveBrowserFeaturesAreDenied(t *testing.T) {
	policy := respond(t, transport.DefaultSecurityHeaders(), tlsRequest()).Get("Permissions-Policy")
	for _, feature := range []string{"camera=()", "microphone=()", "geolocation=()"} {
		if !strings.Contains(policy, feature) {
			t.Errorf("Permissions-Policy does not deny %s: %s", feature, policy)
		}
	}
}

// CSRF is handled by the transport rather than a token: a cross-origin form
// post cannot set a custom header, so the browser refuses before the request
// arrives. Asserted rather than left as a comment.
func TestCrossOriginFormPostsCannotReachTheAPI(t *testing.T) {
	// The three content types a form can send without triggering a preflight.
	for _, contentType := range []string{
		"application/x-www-form-urlencoded",
		"multipart/form-data; boundary=x",
		"text/plain",
	} {
		req := httptest.NewRequest(http.MethodPost, "https://api.example/rpc", nil)
		req.Header.Set("Content-Type", contentType)
		if transport.RequiresCustomHeader(req) {
			t.Errorf("a simple form post with %s was treated as a preflighted request", contentType)
		}
	}

	// A real Connect call carries something a form cannot set, so it is
	// preflighted and same-origin policy applies.
	connect := httptest.NewRequest(http.MethodPost, "https://api.example/rpc", nil)
	connect.Header.Set("Content-Type", "application/json")
	connect.Header.Set("Connect-Protocol-Version", "1")
	if !transport.RequiresCustomHeader(connect) {
		t.Error("a Connect request was not recognised as preflighted")
	}
}

// Headers must reach responses a Connect interceptor never runs for.
func TestHeadersReachNonRPCResponses(t *testing.T) {
	handler := transport.NewSecurityHeaders(transport.DefaultSecurityHeaders(),
		http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
			http.Error(w, "not found", http.StatusNotFound)
		}))

	rec := httptest.NewRecorder()
	handler.ServeHTTP(rec, tlsRequest())

	if rec.Code != http.StatusNotFound {
		t.Fatalf("status %d", rec.Code)
	}
	if rec.Header().Get("Content-Security-Policy") == "" {
		t.Error("a 404 was served without a CSP")
	}
	if rec.Header().Get("X-Content-Type-Options") != "nosniff" {
		t.Error("a 404 was served without nosniff, so it can be sniffed as HTML")
	}
}
