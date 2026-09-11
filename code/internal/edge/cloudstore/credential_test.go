package cloudstore_test

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"errors"
	"math/big"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/edge/cloudstore"
)

// Edge credentials (A12).
//
// The types exist so that the mistake they prevent does not compile. These
// tests cover what the compiler cannot: that the fingerprint really identifies
// the certificate presented, and that a weak enrollment token is refused.

// selfSigned mints a throwaway certificate. Each call produces a different one,
// which is what lets a test express "a different node".
func selfSigned(t *testing.T, commonName string) *x509.Certificate {
	t.Helper()

	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatalf("generate key: %v", err)
	}
	template := &x509.Certificate{
		SerialNumber: big.NewInt(time.Now().UnixNano()),
		Subject:      pkix.Name{CommonName: commonName},
		NotBefore:    time.Now().Add(-time.Hour),
		NotAfter:     time.Now().Add(time.Hour),
	}
	der, err := x509.CreateCertificate(rand.Reader, template, template, &key.PublicKey, key)
	if err != nil {
		t.Fatalf("create certificate: %v", err)
	}
	parsed, err := x509.ParseCertificate(der)
	if err != nil {
		t.Fatalf("parse certificate: %v", err)
	}
	return parsed
}

func testFingerprint(t *testing.T, commonName string) cloudstore.PeerFingerprint {
	t.Helper()
	return cloudstore.FingerprintCertificate(selfSigned(t, commonName))
}

func testToken(t *testing.T) cloudstore.EnrollmentToken {
	t.Helper()
	token, err := cloudstore.NewEnrollmentToken()
	if err != nil {
		t.Fatalf("NewEnrollmentToken: %v", err)
	}
	return token
}

// Two different certificates must not produce the same fingerprint, and the
// same certificate must always produce the same one. Without the first,
// enrollment is not identity; without the second, no node can reconnect.
func TestFingerprintIdentifiesTheCertificate(t *testing.T) {
	cert := selfSigned(t, "ward-4b")

	first := cloudstore.FingerprintCertificate(cert)
	second := cloudstore.FingerprintCertificate(cert)
	if first.String() != second.String() {
		t.Fatalf("the same certificate produced %q then %q", first, second)
	}
	if !strings.HasPrefix(first.String(), "sha256:") {
		t.Fatalf("fingerprint = %q, want a sha256: prefix", first)
	}

	// Same subject, different key. A fingerprint over the subject rather than
	// the certificate would collide here, and one node could impersonate
	// another simply by naming itself the same.
	other := cloudstore.FingerprintCertificate(selfSigned(t, "ward-4b"))
	if other.String() == first.String() {
		t.Fatal("two different certificates share a fingerprint")
	}
}

// A connection with no client certificate is an error rather than an empty
// fingerprint, so a transport cannot proceed with one by accident.
func TestFingerprintPeerRequiresACertificate(t *testing.T) {
	if _, err := cloudstore.FingerprintPeer(nil); !errors.Is(err, cloudstore.ErrNoPeerCertificate) {
		t.Fatalf("FingerprintPeer(nil) = %v, want ErrNoPeerCertificate", err)
	}
	if _, err := cloudstore.FingerprintPeer(&tls.ConnectionState{}); !errors.Is(err, cloudstore.ErrNoPeerCertificate) {
		t.Fatalf("FingerprintPeer with no peer certificates = %v, want ErrNoPeerCertificate", err)
	}
}

// The leaf, not the issuer: every node under the same CA presents the same
// intermediate, so fingerprinting one would make them interchangeable.
func TestFingerprintPeerUsesTheLeafCertificate(t *testing.T) {
	leaf := selfSigned(t, "ward-4b")
	issuer := selfSigned(t, "hospital-ca")

	got, err := cloudstore.FingerprintPeer(&tls.ConnectionState{
		PeerCertificates: []*x509.Certificate{leaf, issuer},
	})
	if err != nil {
		t.Fatalf("FingerprintPeer: %v", err)
	}
	if got.String() != cloudstore.FingerprintCertificate(leaf).String() {
		t.Fatal("the fingerprint did not come from the leaf certificate")
	}
}

// The stored hash is unsalted SHA-256, which is correct for a high-entropy
// random value and wrong for a guessable one — so the only way to get a token
// is to be given one that was generated, and every one is different.
func TestMintedTokensAreUnpredictable(t *testing.T) {
	seen := map[string]bool{}
	for range 100 {
		token, err := cloudstore.NewEnrollmentToken()
		if err != nil {
			t.Fatalf("NewEnrollmentToken: %v", err)
		}
		if seen[token.Reveal()] {
			t.Fatal("NewEnrollmentToken repeated a value")
		}
		seen[token.Reveal()] = true
	}
}

// A token reaches a log through an accidental %v far more often than through a
// deliberate decision.
func TestATokenDoesNotPrintItself(t *testing.T) {
	token := testToken(t)

	if formatted := token.String(); strings.Contains(formatted, token.Reveal()) {
		t.Fatalf("String() revealed the token: %q", formatted)
	}
	// %v and %s both go through String; this is the accident being guarded.
	if formatted := strings.TrimSpace(strings.Join([]string{
		"issued", token.String(),
	}, " ")); strings.Contains(formatted, token.Reveal()) {
		t.Fatal("the token leaked through formatting")
	}
}

func TestAShortTokenIsRefusedAtParse(t *testing.T) {
	for _, weak := range []string{"", "1234", "admin", "one-time-token"} {
		if _, err := cloudstore.ParseEnrollmentToken(weak); !errors.Is(err, cloudstore.ErrWeakEnrollmentToken) {
			t.Errorf("ParseEnrollmentToken(%q) = %v, want ErrWeakEnrollmentToken", weak, err)
		}
	}

	minted := testToken(t)
	parsed, err := cloudstore.ParseEnrollmentToken(minted.Reveal())
	if err != nil {
		t.Fatalf("a minted token failed to parse: %v", err)
	}
	if !parsed.Equal(minted) {
		t.Fatal("parsing a minted token changed it")
	}
}
