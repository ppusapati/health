package oidc

import (
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
)

// unverifiedIssuer reads the `iss` claim from a token without validating it.
//
// This is the one place an unverified value is read, and it exists because of
// a genuine ordering problem: the token cannot be verified until the right
// keys are chosen, the keys come from the issuer's JWKS, and the issuer is
// inside the token. Something has to be read first.
//
// What makes it safe is what happens next. The issuer selects a federation and
// therefore a verifier, and that verifier checks `iss` again against its own
// configuration and validates the signature with that issuer's keys. A forged
// issuer selects a provider whose keys will not validate the token, so the
// only thing a caller can achieve by lying here is to be rejected by a
// different code path.
//
// The parsing is deliberately strict and minimal — segment count, base64,
// one field — because this runs before any authentication and must not be a
// place where a malformed token causes anything more interesting than an
// error.
func unverifiedIssuer(token string) (string, error) {
	parts := strings.Split(token, ".")
	if len(parts) != 3 {
		return "", fmt.Errorf("not a JWS: %d segments", len(parts))
	}

	// Payload only. The header is not read at all: `alg` and `kid` belong to
	// the library's verification path, and reading them here would invite
	// somebody to make a decision from them — which is how algorithm-confusion
	// vulnerabilities start.
	payload, err := base64.RawURLEncoding.DecodeString(parts[1])
	if err != nil {
		return "", fmt.Errorf("payload is not base64url: %w", err)
	}
	// A bound on what is parsed before authentication. A megabyte of JSON in
	// an unauthenticated request should cost a rejection, not a parse.
	if len(payload) > maxUnverifiedPayloadBytes {
		return "", fmt.Errorf("payload is %d bytes, over the %d limit",
			len(payload), maxUnverifiedPayloadBytes)
	}

	var envelope struct {
		Issuer string `json:"iss"`
	}
	if err := json.Unmarshal(payload, &envelope); err != nil {
		return "", fmt.Errorf("payload is not JSON: %w", err)
	}
	if strings.TrimSpace(envelope.Issuer) == "" {
		return "", errors.New("token carries no issuer")
	}
	return envelope.Issuer, nil
}

// maxUnverifiedPayloadBytes bounds pre-authentication parsing. Real ID tokens
// are a few hundred bytes; 8 KiB is generous for one carrying many group
// claims and still far below anything worth spending CPU on.
const maxUnverifiedPayloadBytes = 8 << 10
