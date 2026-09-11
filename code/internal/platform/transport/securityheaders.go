package transport

import (
	"net/http"
	"strings"
)

// Browser security headers (SRS-WEB-015).
//
// "Security headers, CSRF protections where applicable, CSP and XSS-safe
// rendering are enforced", verified by "automated security test validates
// baseline". Each header here closes a specific attack, and the ones that
// matter most in this system are not the ones usually listed first.
//
// The CSP is the centrepiece. A hospital workspace renders clinician-entered
// text — a note, a patient name, an allergy comment — and any of it can carry
// a script payload. Svelte escapes by default, so the first line of defence
// holds; the CSP is the second, for the day somebody reaches for `{@html}` to
// render formatted text and does not sanitise it.
//
// CSRF is handled by the transport rather than a token. ConnectRPC requires a
// custom header on every call, and a cross-origin form post cannot set one —
// so a browser's preflight refuses the request before it arrives. That is
// stronger than a token nobody rotates, and it is why there is no token here.

// SecurityHeaderConfig tunes the headers for an environment.
type SecurityHeaderConfig struct {
	// ConnectSources are origins the page may make API calls to. The web app
	// and the API are usually separate origins, so 'self' alone is not enough.
	ConnectSources []string
	// ReportURI receives CSP violation reports. Empty disables reporting.
	ReportURI string
	// ReportOnly runs the policy without enforcing it, for measuring what a new
	// policy would break before it breaks it. Never true in production, and a
	// manifest invariant would be the place to hold that if the header were
	// set from configuration rather than code.
	ReportOnly bool
	// HSTSMaxAgeSeconds is how long a browser should refuse plaintext. Zero
	// omits the header, which is correct for local development over http where
	// setting it would pin a developer's browser to https for the whole
	// localhost origin — including other projects on other ports.
	HSTSMaxAgeSeconds int
}

// DefaultSecurityHeaders is the production baseline.
func DefaultSecurityHeaders() SecurityHeaderConfig {
	return SecurityHeaderConfig{
		ConnectSources: []string{"'self'"},
		// Two years, the value browsers require for preload-list inclusion.
		HSTSMaxAgeSeconds: 63072000,
	}
}

// buildCSP assembles the policy.
//
// Written as an ordered list rather than a constant string so each directive
// can carry the reason it is there — a CSP with no explanation is a CSP nobody
// dares tighten, because nobody knows which directive some feature depends on.
func buildCSP(cfg SecurityHeaderConfig) string {
	connect := "'self'"
	if len(cfg.ConnectSources) > 0 {
		connect = strings.Join(cfg.ConnectSources, " ")
	}

	directives := []string{
		// Everything not named below falls back to same-origin only.
		"default-src 'self'",
		// No inline script and no eval. This is the directive that makes the
		// CSP worth having: an injected <script> or an onerror handler in a
		// clinician's note does nothing. SvelteKit is built to work without
		// inline script, so this costs nothing here — which is why it is
		// affordable to be strict rather than adding 'unsafe-inline' to make a
		// third-party widget work.
		"script-src 'self'",
		// Inline styles are permitted because Svelte's scoped styles and any
		// style attribute rely on them. A narrower policy would need nonces on
		// every render, and the attack it prevents — CSS exfiltration through
		// attribute selectors — is far smaller than the script case.
		"style-src 'self' 'unsafe-inline'",
		"img-src 'self' data: blob:",
		"font-src 'self'",
		"connect-src " + connect,
		// No plugins, no Flash-era content types.
		"object-src 'none'",
		// Stops a <base> tag injected into the document from re-pointing every
		// relative URL — including the API calls — at an attacker's origin.
		"base-uri 'self'",
		// Refuses a cross-origin form post from the page, which is the other
		// half of CSRF defence: even if a page is compromised it cannot post
		// elsewhere.
		"form-action 'self'",
		// Clickjacking. frame-ancestors is the modern replacement for
		// X-Frame-Options and, unlike it, understands multiple origins.
		"frame-ancestors 'none'",
		// A document loaded over https must not pull anything over http.
		"upgrade-insecure-requests",
	}

	if cfg.ReportURI != "" {
		directives = append(directives, "report-uri "+cfg.ReportURI)
	}
	return strings.Join(directives, "; ")
}

// NewSecurityHeaders wraps a handler with the browser security baseline.
//
// An http.Handler middleware rather than a Connect interceptor: these headers
// belong on every response the browser sees, including the ones a Connect
// interceptor never runs for — a 404, a malformed request rejected before
// routing, a static asset.
func NewSecurityHeaders(cfg SecurityHeaderConfig, next http.Handler) http.Handler {
	policy := buildCSP(cfg)
	policyHeader := "Content-Security-Policy"
	if cfg.ReportOnly {
		policyHeader = "Content-Security-Policy-Report-Only"
	}

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		h := w.Header()

		h.Set(policyHeader, policy)

		// Stops a browser guessing a response's type. Without it, a stored
		// document served as text/plain can be sniffed as HTML and executed —
		// which turns an uploaded file into stored XSS.
		h.Set("X-Content-Type-Options", "nosniff")

		// frame-ancestors above covers modern browsers; this covers the ones
		// on a hospital estate that are not modern.
		h.Set("X-Frame-Options", "DENY")

		// Referrer leaks URLs, and a URL in this system can contain a patient
		// or encounter identifier. Same-origin keeps it inside.
		h.Set("Referrer-Policy", "same-origin")

		// Features this application never uses. Denying them means a
		// compromised page cannot turn on a microphone in a consulting room.
		h.Set("Permissions-Policy",
			"camera=(), microphone=(), geolocation=(), payment=(), usb=(), interest-cohort=()")

		// Isolates the browsing context so a cross-origin window cannot hold a
		// reference to this one, which is what makes several Spectre-class and
		// tab-napping attacks possible.
		h.Set("Cross-Origin-Opener-Policy", "same-origin")
		h.Set("Cross-Origin-Resource-Policy", "same-origin")

		// HSTS only over TLS. Sending it over http is ignored by browsers and,
		// on localhost, would pin a developer's whole origin to https —
		// including other projects on other ports.
		if cfg.HSTSMaxAgeSeconds > 0 && (r.TLS != nil || r.Header.Get("X-Forwarded-Proto") == "https") {
			h.Set("Strict-Transport-Security",
				"max-age="+itoa(cfg.HSTSMaxAgeSeconds)+"; includeSubDomains; preload")
		}

		next.ServeHTTP(w, r)
	})
}

// itoa avoids importing strconv for one call in a hot path.
func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	var buf [20]byte
	i := len(buf)
	for n > 0 {
		i--
		buf[i] = byte('0' + n%10)
		n /= 10
	}
	return string(buf[i:])
}

// RequiresCustomHeader reports whether a request carries the header ConnectRPC
// requires, which is what makes this API immune to a cross-origin form post.
//
// Exported so the CSRF property can be asserted by test rather than asserted
// in a comment. A simple form post cannot set a custom header, so the browser
// either sends a preflight — which same-origin policy fails — or refuses.
func RequiresCustomHeader(r *http.Request) bool {
	// Connect's own protocol headers. Any one of them is enough: a form post
	// can set none of them.
	for _, name := range []string{"Connect-Protocol-Version", "Content-Type"} {
		value := r.Header.Get(name)
		if name == "Content-Type" {
			// The three content types a form can send without a preflight.
			switch strings.ToLower(strings.TrimSpace(strings.Split(value, ";")[0])) {
			case "application/x-www-form-urlencoded", "multipart/form-data", "text/plain":
				continue
			case "":
				continue
			default:
				return true
			}
		}
		if value != "" {
			return true
		}
	}
	return false
}
