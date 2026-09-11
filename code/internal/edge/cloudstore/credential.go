package cloudstore

import (
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"crypto/tls"
	"crypto/x509"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"time"
)

// Edge credentials (A12).
//
// Two unforgeable types, for the same reason authctx.TenantScope is one
// (ADR-W0-001): the rule these enforce is one a reviewer would otherwise have
// to notice, and the failure is silent.

// PeerFingerprint identifies an edge node by the TLS certificate it presented.
//
// It can only be constructed from a certificate. That is the whole point: the
// obvious mistake when writing the edge transport is to read the fingerprint
// out of a header or a request field, which turns node authentication into
// "tell us who you are" — and the identifiers involved are non-secret UUIDs
// that appear in logs and manifests. With this type, that mistake does not
// compile.
//
// The digest itself is not a secret; a certificate is public. What
// authenticates the node is possession of the private key, proven by the mTLS
// handshake that produced the certificate this is derived from.
type PeerFingerprint struct{ value string }

// ErrNoPeerCertificate reports a connection that presented no client
// certificate. Treated as an error rather than an empty fingerprint so a
// transport cannot accidentally proceed with one.
var ErrNoPeerCertificate = errors.New("edge: connection presented no client certificate")

// FingerprintPeer derives the fingerprint from a completed TLS handshake.
//
// Uses the leaf certificate — PeerCertificates[0] — because that is the one the
// peer proved possession of. An intermediate or root would identify the issuer,
// which every node under the same CA shares.
func FingerprintPeer(state *tls.ConnectionState) (PeerFingerprint, error) {
	if state == nil || len(state.PeerCertificates) == 0 {
		return PeerFingerprint{}, ErrNoPeerCertificate
	}
	return FingerprintCertificate(state.PeerCertificates[0]), nil
}

// FingerprintCertificate derives the fingerprint from a parsed certificate.
//
// Over the raw DER rather than a field of the certificate: a subject or serial
// can repeat across issuers, and the DER is the exact bytes the peer proved
// possession of.
func FingerprintCertificate(cert *x509.Certificate) PeerFingerprint {
	if cert == nil || len(cert.Raw) == 0 {
		return PeerFingerprint{}
	}
	sum := sha256.Sum256(cert.Raw)
	return PeerFingerprint{value: "sha256:" + hex.EncodeToString(sum[:])}
}

// IsZero reports an unset fingerprint.
func (f PeerFingerprint) IsZero() bool { return f.value == "" }

// String returns the stored form. Safe to log: a certificate digest is public.
func (f PeerFingerprint) String() string { return f.value }

// Enrollment tokens.

// enrollmentTokenBytes is the entropy in a token. 256 bits, because the token
// is looked up by hash and the hash is a single unsalted SHA-256: that is the
// right construction for a high-entropy random value and the wrong one for
// anything guessable, so the constructor has to guarantee which this is.
const enrollmentTokenBytes = 32

// MaxEnrollmentValidity bounds how long a one-time token may be redeemable.
//
// A token valid for a month is not a one-time token; it is a standing
// credential that happens to be redeemable once, and it will be pasted into a
// ticket, a chat message and a runbook on the way to the ward.
const MaxEnrollmentValidity = 24 * time.Hour

// minEnrollmentTokenLength is the shortest acceptable encoded token. Derived
// from the byte count rather than written as a number so the two cannot drift.
var minEnrollmentTokenLength = len(base64.RawURLEncoding.EncodeToString(make([]byte, enrollmentTokenBytes)))

// ErrWeakEnrollmentToken reports a token that is too short to resist guessing.
var ErrWeakEnrollmentToken = errors.New("edge: enrollment token is too weak")

// EnrollmentToken is a one-time secret that enrols exactly one node.
type EnrollmentToken struct{ value string }

// NewEnrollmentToken mints a token.
//
// Callers cannot choose the value. A human-chosen or sequential token is the
// one weakness an unsalted hash cannot survive, and "the caller is responsible
// for entropy" is a sentence in a comment rather than a control.
func NewEnrollmentToken() (EnrollmentToken, error) {
	raw := make([]byte, enrollmentTokenBytes)
	if _, err := rand.Read(raw); err != nil {
		return EnrollmentToken{}, fmt.Errorf("edge: generate enrollment token: %w", err)
	}
	return EnrollmentToken{value: base64.RawURLEncoding.EncodeToString(raw)}, nil
}

// ParseEnrollmentToken accepts a token presented for redemption.
//
// Redemption receives whatever the wire carried, so this is where a short or
// empty value is refused — before it reaches a lookup that would otherwise
// happily hash "1234" and go looking for it.
func ParseEnrollmentToken(raw string) (EnrollmentToken, error) {
	if len(raw) < minEnrollmentTokenLength {
		return EnrollmentToken{}, ErrWeakEnrollmentToken
	}
	return EnrollmentToken{value: raw}, nil
}

// IsZero reports an unset token.
func (t EnrollmentToken) IsZero() bool { return t.value == "" }

// String deliberately does not reveal the token.
//
// A token reaches a log through an accidental %v far more often than through a
// deliberate decision, and a token in a log is a token an operator has to
// revoke.
func (t EnrollmentToken) String() string { return "EnrollmentToken(redacted)" }

// Reveal returns the secret, for handing to the operator who will carry it to
// the node. Named so that a reader can see where a secret escapes.
func (t EnrollmentToken) Reveal() string { return t.value }

// hash returns the stored form.
func (t EnrollmentToken) hash() string {
	sum := sha256.Sum256([]byte(t.value))
	return hex.EncodeToString(sum[:])
}

// Equal compares two tokens in constant time. Not used by the database lookup,
// which compares hashes, but available to any caller that must compare tokens
// directly without leaking length or prefix through timing.
func (t EnrollmentToken) Equal(other EnrollmentToken) bool {
	return subtle.ConstantTimeCompare([]byte(t.value), []byte(other.value)) == 1
}
