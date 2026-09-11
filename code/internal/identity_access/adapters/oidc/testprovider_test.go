package oidc_test

import (
	"crypto/rand"
	"crypto/rsa"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"math/big"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	jose "github.com/go-jose/go-jose/v4"
)

// testProvider is a real OIDC provider: a discovery document, a JWKS endpoint,
// and tokens signed with a key the JWKS publishes.
//
// A fake that returns a pre-made session would leave the part that matters —
// signature verification, key selection, issuer and audience checking —
// completely untested, which for an authentication component is most of it.
// Everything here is genuine crypto against the real library.
type testProvider struct {
	server *httptest.Server
	key    *rsa.PrivateKey
	keyID  string
	// extraKey is published alongside the signing key so key selection by kid
	// is actually exercised rather than working by having only one choice.
	extraKey   *rsa.PrivateKey
	extraKeyID string
}

func newTestProvider(t *testing.T) *testProvider {
	t.Helper()

	key, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("generate key: %v", err)
	}
	extra, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("generate extra key: %v", err)
	}

	p := &testProvider{key: key, keyID: "signing-key-1", extraKey: extra, extraKeyID: "rotated-key-0"}

	mux := http.NewServeMux()
	mux.HandleFunc("/.well-known/openid-configuration", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"issuer":                                p.Issuer(),
			"authorization_endpoint":                p.Issuer() + "/authorize",
			"token_endpoint":                        p.Issuer() + "/token",
			"jwks_uri":                              p.Issuer() + "/jwks",
			"id_token_signing_alg_values_supported": []string{"RS256"},
		})
	})
	mux.HandleFunc("/jwks", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"keys": []any{
				publicJWK(p.extraKeyID, &p.extraKey.PublicKey),
				publicJWK(p.keyID, &p.key.PublicKey),
			},
		})
	})

	// TLS, not plain HTTP. The federation aggregate refuses a non-https issuer
	// — an issuer an attacker on the path can impersonate is an issuer the
	// whole federation rests on — so a plain-HTTP test server would have
	// forced that rule to be weakened for test convenience. The server's own
	// client trusts its self-signed certificate, and passing that client into
	// the verifier also proves Config.HTTPClient is honoured rather than
	// ignored in favour of http.DefaultClient.
	p.server = httptest.NewTLSServer(mux)
	t.Cleanup(p.server.Close)
	return p
}

// Client returns an HTTP client that trusts this provider's certificate.
func (p *testProvider) Client() *http.Client { return p.server.Client() }

func (p *testProvider) Issuer() string {
	if p.server == nil {
		return ""
	}
	return p.server.URL
}

func publicJWK(kid string, pub *rsa.PublicKey) map[string]any {
	return map[string]any{
		"kty": "RSA",
		"kid": kid,
		"alg": "RS256",
		"use": "sig",
		"n":   base64.RawURLEncoding.EncodeToString(pub.N.Bytes()),
		"e":   base64.RawURLEncoding.EncodeToString(big.NewInt(int64(pub.E)).Bytes()),
	}
}

// tokenClaims is what a test asks the provider to mint.
type tokenClaims struct {
	Subject   string
	Audience  string
	Issuer    string
	IssuedAt  time.Time
	ExpiresAt time.Time
	AuthTime  time.Time
	Email     string
	Name      string
	Groups    []string
	ACR       string
	AMR       []string
	// signWith overrides the signing key, so a token signed by a key the JWKS
	// does not publish can be tested.
	signWith *rsa.PrivateKey
	keyID    string
	// omitIssuer produces a token with no iss claim.
	omitIssuer bool
}

func (p *testProvider) mint(t *testing.T, c tokenClaims) string {
	t.Helper()

	payload := map[string]any{
		"sub": c.Subject,
		"aud": c.Audience,
		"iat": c.IssuedAt.Unix(),
		"exp": c.ExpiresAt.Unix(),
	}
	if !c.omitIssuer {
		issuer := c.Issuer
		if issuer == "" {
			issuer = p.Issuer()
		}
		payload["iss"] = issuer
	}
	if c.Email != "" {
		payload["email"] = c.Email
	}
	if c.Name != "" {
		payload["name"] = c.Name
	}
	if len(c.Groups) > 0 {
		payload["groups"] = c.Groups
	}
	if c.ACR != "" {
		payload["acr"] = c.ACR
	}
	if len(c.AMR) > 0 {
		payload["amr"] = c.AMR
	}
	if !c.AuthTime.IsZero() {
		payload["auth_time"] = c.AuthTime.Unix()
	}

	body, err := json.Marshal(payload)
	if err != nil {
		t.Fatalf("marshal claims: %v", err)
	}

	key := c.signWith
	if key == nil {
		key = p.key
	}
	kid := c.keyID
	if kid == "" {
		kid = p.keyID
	}

	signer, err := jose.NewSigner(
		jose.SigningKey{Algorithm: jose.RS256, Key: key},
		(&jose.SignerOptions{}).WithType("JWT").WithHeader("kid", kid))
	if err != nil {
		t.Fatalf("new signer: %v", err)
	}
	signed, err := signer.Sign(body)
	if err != nil {
		t.Fatalf("sign: %v", err)
	}
	serialized, err := signed.CompactSerialize()
	if err != nil {
		t.Fatalf("serialize: %v", err)
	}
	return serialized
}

// unsignedToken produces a token with `alg: none`, the classic bypass.
func unsignedToken(t *testing.T, issuer, subject, audience string, exp time.Time) string {
	t.Helper()

	header := base64.RawURLEncoding.EncodeToString([]byte(`{"alg":"none","typ":"JWT"}`))
	payload := base64.RawURLEncoding.EncodeToString([]byte(fmt.Sprintf(
		`{"iss":%q,"sub":%q,"aud":%q,"exp":%d,"iat":%d}`,
		issuer, subject, audience, exp.Unix(), time.Now().Unix())))
	return header + "." + payload + "."
}
