package transport

import (
	"crypto/tls"
	"errors"
	"fmt"
	"net/url"
	"strings"
)

// Transport security policy (SRS-SEC-001).
//
// The requirement's verification is "security scan finds no plaintext PHI
// channel in supported topology", which is a statement about deployment, not
// about a constant in a config file. Two things follow.
//
// First, there is no plaintext option. A process either terminates TLS itself
// or runs inside a mesh that does mTLS for it, and it has to say which. The
// h2c listener this service uses exists only because the second case is real;
// what makes it safe is the sidecar and the STRICT PeerAuthentication beside
// it, so declaring TLSModeMesh is a claim the manifests are checked against
// (tools/infra) rather than a way to opt out.
//
// Second, the database hop is part of the topology. A service that serves TLS
// to its callers and then ships PHI to PostgreSQL over a plaintext socket has
// a plaintext PHI channel; sslmode is therefore validated here rather than
// left to whoever writes the connection string.

// TLSMode is how a process obtains transport security.
type TLSMode string

const (
	// TLSModeServe terminates TLS in the process. Used at the edge and by
	// anything outside a mesh.
	TLSModeServe TLSMode = "serve"
	// TLSModeMesh delegates to a sidecar that enforces mTLS. The process
	// listens on plaintext HTTP/2, reachable only from the sidecar.
	TLSModeMesh TLSMode = "mesh"
)

// ErrInsecureTransport reports a configuration that would carry PHI in clear.
var ErrInsecureTransport = errors.New("transport: configuration would expose a plaintext channel")

// ParseTLSMode reads the mode from configuration.
//
// The empty string is an error, not a default. A default here would be chosen
// once, by someone thinking about their laptop, and then inherited by every
// environment that forgot to set it.
func ParseTLSMode(raw string) (TLSMode, error) {
	switch mode := TLSMode(strings.ToLower(strings.TrimSpace(raw))); mode {
	case TLSModeServe, TLSModeMesh:
		return mode, nil
	case "":
		return "", fmt.Errorf("%w: TLS_MODE is required (serve or mesh)", ErrInsecureTransport)
	default:
		return "", fmt.Errorf("%w: unsupported TLS_MODE %q", ErrInsecureTransport, raw)
	}
}

// ServerTLSConfig is the policy for anything this programme terminates.
//
// TLS 1.2 is the floor rather than 1.3 because medical devices and hospital
// integration engines are long-lived and some cannot be upgraded on our
// schedule; refusing them would push an integration onto an unencrypted
// channel, which is worse. The cipher list is what makes 1.2 acceptable: only
// AEAD suites with forward secrecy, so none of the 1.2 weaknesses that matter
// (CBC padding oracles, static RSA key exchange) are reachable.
func ServerTLSConfig() *tls.Config {
	return &tls.Config{
		MinVersion: tls.VersionTLS12,
		// Go chooses among the 1.3 suites itself; these apply to 1.2.
		CipherSuites: []uint16{
			tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
			tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
			tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,
			tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,
		},
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
		// ConnectRPC needs h2 advertised, or a gRPC client negotiates HTTP/1.1
		// and loses streaming.
		NextProtos: []string{"h2", "http/1.1"},
	}
}

// ClientTLSConfig is the policy for calls this programme makes outward.
//
// Deliberately has no InsecureSkipVerify parameter. Somewhere in the life of
// every system a hurried change sets that flag for one endpoint and it is
// never removed, so the option is not offered.
func ClientTLSConfig() *tls.Config {
	return &tls.Config{
		MinVersion:       tls.VersionTLS12,
		CurvePreferences: []tls.CurveID{tls.X25519, tls.CurveP256, tls.CurveP384},
	}
}

// secureDatabaseModes are the sslmode values that actually protect the hop.
//
// "require" is excluded on purpose. It encrypts but does not authenticate the
// server, so it stops passive capture and not an active attacker who can
// answer for the database — which, on a network where PHI is the payload, is
// the attacker worth designing against.
var secureDatabaseModes = map[string]bool{
	"verify-full": true,
	"verify-ca":   true,
}

// ValidateDatabaseDSN checks that a connection string keeps PHI encrypted in
// transit and authenticates the server it is talking to.
//
// allowLocal exists for the test harness and local development, where the
// database is a unix socket or a loopback container and there is no certificate
// to verify. It is a parameter rather than an environment lookup so that the
// decision is made by the caller that knows — the composition root passes
// false in every deployed environment.
func ValidateDatabaseDSN(dsn string, allowLocal bool) error {
	if strings.TrimSpace(dsn) == "" {
		return fmt.Errorf("%w: database DSN is empty", ErrInsecureTransport)
	}

	u, err := url.Parse(dsn)
	if err != nil {
		return fmt.Errorf("%w: database DSN is not a URL: %v", ErrInsecureTransport, err)
	}

	mode := u.Query().Get("sslmode")
	if secureDatabaseModes[mode] {
		return nil
	}

	if allowLocal && isLoopback(u.Hostname()) {
		return nil
	}

	if mode == "" {
		return fmt.Errorf("%w: database DSN sets no sslmode; set verify-full", ErrInsecureTransport)
	}
	return fmt.Errorf("%w: database sslmode %q does not authenticate the server; set verify-full",
		ErrInsecureTransport, mode)
}

func isLoopback(host string) bool {
	switch host {
	case "", "localhost", "127.0.0.1", "::1":
		return true
	default:
		return false
	}
}
