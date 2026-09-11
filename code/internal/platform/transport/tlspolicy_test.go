package transport_test

import (
	"crypto/tls"
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/transport"
)

func TestTLSModeHasNoDefault(t *testing.T) {
	// An empty TLS_MODE must fail loudly. A default would be inherited by
	// whichever environment forgot to set it, which is exactly the environment
	// least likely to notice.
	if _, err := transport.ParseTLSMode(""); !errors.Is(err, transport.ErrInsecureTransport) {
		t.Fatalf("want ErrInsecureTransport for an unset mode, got %v", err)
	}
	if _, err := transport.ParseTLSMode("plaintext"); !errors.Is(err, transport.ErrInsecureTransport) {
		t.Fatalf("want refusal of an unknown mode, got %v", err)
	}
	for _, in := range []string{"serve", "SERVE", " mesh "} {
		if _, err := transport.ParseTLSMode(in); err != nil {
			t.Errorf("ParseTLSMode(%q): %v", in, err)
		}
	}
}

func TestServerPolicyAdmitsNoWeakSuite(t *testing.T) {
	cfg := transport.ServerTLSConfig()
	if cfg.MinVersion < tls.VersionTLS12 {
		t.Fatalf("minimum version is below TLS 1.2: %x", cfg.MinVersion)
	}

	// Go publishes the suites it considers insecure. Asserting against that
	// list rather than a hand-written denylist means a suite downgraded by a
	// future Go release fails this test instead of silently staying allowed.
	insecure := map[uint16]string{}
	for _, s := range tls.InsecureCipherSuites() {
		insecure[s.ID] = s.Name
	}
	for _, id := range cfg.CipherSuites {
		if name, bad := insecure[id]; bad {
			t.Errorf("policy allows %s, which Go classifies as insecure", name)
		}
	}
	if len(cfg.CipherSuites) == 0 {
		t.Fatal("no TLS 1.2 cipher suites configured, so the policy asserts nothing")
	}

	// ConnectRPC needs h2 advertised or gRPC clients silently drop to HTTP/1.1.
	var hasH2 bool
	for _, p := range cfg.NextProtos {
		if p == "h2" {
			hasH2 = true
		}
	}
	if !hasH2 {
		t.Error("h2 is not advertised; gRPC clients will not negotiate HTTP/2")
	}
}

func TestClientPolicyVerifiesCertificates(t *testing.T) {
	cfg := transport.ClientTLSConfig()
	if cfg.InsecureSkipVerify {
		t.Fatal("client policy skips certificate verification")
	}
	if cfg.MinVersion < tls.VersionTLS12 {
		t.Fatalf("client minimum version is below TLS 1.2: %x", cfg.MinVersion)
	}
}

func TestDatabaseDSNMustAuthenticateTheServer(t *testing.T) {
	const host = "postgres://core@db.internal:5432/core"

	refused := map[string]string{
		"no sslmode":   host,
		"disabled":     host + "?sslmode=disable",
		"allow":        host + "?sslmode=allow",
		"prefer":       host + "?sslmode=prefer",
		"encrypt only": host + "?sslmode=require",
		"empty":        "",
	}
	for name, dsn := range refused {
		t.Run(name, func(t *testing.T) {
			if err := transport.ValidateDatabaseDSN(dsn, false); !errors.Is(err, transport.ErrInsecureTransport) {
				t.Fatalf("want ErrInsecureTransport, got %v", err)
			}
		})
	}

	for name, dsn := range map[string]string{
		"verify-full": host + "?sslmode=verify-full",
		"verify-ca":   host + "?sslmode=verify-ca",
	} {
		t.Run(name, func(t *testing.T) {
			if err := transport.ValidateDatabaseDSN(dsn, false); err != nil {
				t.Fatalf("ValidateDatabaseDSN: %v", err)
			}
		})
	}
}

// sslmode=require is the interesting rejection: it encrypts, so it looks
// secure in a packet capture, but it accepts any certificate and therefore
// any server that can win a race to answer. On a link carrying PHI that is
// the attacker worth designing against.
func TestRequireIsNotEnough(t *testing.T) {
	err := transport.ValidateDatabaseDSN("postgres://core@db.internal/core?sslmode=require", false)
	if err == nil {
		t.Fatal("sslmode=require was accepted")
	}
	if !errors.Is(err, transport.ErrInsecureTransport) {
		t.Fatalf("want ErrInsecureTransport, got %v", err)
	}
}

func TestLocalDevelopmentIsAllowedOnlyOnLoopback(t *testing.T) {
	if err := transport.ValidateDatabaseDSN("postgres://postgres@127.0.0.1:55432/postgres?sslmode=disable", true); err != nil {
		t.Fatalf("loopback with allowLocal should pass: %v", err)
	}
	// The escape hatch must not extend to a remote host: that is how a
	// developer setting becomes a production connection string.
	if err := transport.ValidateDatabaseDSN("postgres://core@db.internal/core?sslmode=disable", true); !errors.Is(err, transport.ErrInsecureTransport) {
		t.Fatalf("allowLocal must not excuse a remote plaintext DSN, got %v", err)
	}
}
