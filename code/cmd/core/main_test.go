package main

import (
	"context"
	"errors"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
)

// ADR-W0-003 rests on this guard: the development verifier must be reachable
// only by an explicit opt-in, so it cannot arrive in production through
// configuration drift.
func TestBuildVerifierFailsClosed(t *testing.T) {
	cases := map[string]string{
		"empty":      "",
		"whitespace": "   ",
		"typo":       "devv",
		"production": "production",
		"true":       "true",
		"yes":        "yes",
	}

	for name, mode := range cases {
		t.Run(name, func(t *testing.T) {
			verifier, err := buildVerifier(context.Background(), mode, nil)
			if err == nil {
				t.Fatalf("AUTH_MODE=%q was accepted", mode)
			}
			if verifier != nil {
				t.Fatalf("AUTH_MODE=%q returned a usable verifier alongside an error", mode)
			}
		})
	}
}

func TestBuildVerifierAcceptsExplicitDevMode(t *testing.T) {
	for _, mode := range []string{"dev", "DEV", "Dev"} {
		verifier, err := buildVerifier(context.Background(), mode, nil)
		if err != nil {
			t.Fatalf("AUTH_MODE=%q rejected: %v", mode, err)
		}
		if verifier == nil {
			t.Fatalf("AUTH_MODE=%q returned no verifier", mode)
		}
	}
}

// The error must name the remedy: an operator reading it at 3am should not have
// to find this file.
func TestBuildVerifierErrorNamesTheRemedy(t *testing.T) {
	_, err := buildVerifier(context.Background(), "", nil)
	if err == nil {
		t.Fatal("empty AUTH_MODE accepted")
	}
	if !strings.Contains(err.Error(), "AUTH_MODE") {
		t.Fatalf("error does not name the variable: %v", err)
	}
}

// Belt and braces: the devauth constructor itself refuses unless enabled.
func TestDevAuthRefusesWithoutOptIn(t *testing.T) {
	if _, err := devauth.New(false); !errors.Is(err, devauth.ErrDisabled) {
		t.Fatalf("devauth.New(false) = %v, want ErrDisabled", err)
	}
}

// ADR-008 is closed, so `oidc` is now a real mode. It must still refuse to
// start without the audience: without one, every token any provider ever
// issued for any application would be accepted.
func TestOIDCModeRequiresAnAudience(t *testing.T) {
	t.Setenv("OIDC_AUDIENCE", "")

	verifier, err := buildVerifier(context.Background(), "oidc", nil)
	if err == nil {
		t.Fatal("AUTH_MODE=oidc was accepted with no audience")
	}
	if verifier != nil {
		t.Fatal("a usable verifier was returned alongside an error")
	}
	if !strings.Contains(err.Error(), "OIDC_AUDIENCE") {
		t.Fatalf("the error does not name the variable: %v", err)
	}
}

// A malformed clock skew is a startup failure rather than a silent default.
// Silently ignoring it would leave an operator believing they had configured a
// tolerance they had not.
func TestOIDCModeRejectsAMalformedClockSkew(t *testing.T) {
	t.Setenv("OIDC_AUDIENCE", "healthcare-workspace")
	t.Setenv("OIDC_CLOCK_SKEW", "not-a-duration")

	if _, err := buildVerifier(context.Background(), "oidc", nil); err == nil {
		t.Fatal("a malformed OIDC_CLOCK_SKEW was accepted")
	}
}
