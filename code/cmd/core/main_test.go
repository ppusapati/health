package main

import (
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
		"oidc":       "oidc", // not implemented yet; must fail, not fall back
		"true":       "true",
		"yes":        "yes",
	}

	for name, mode := range cases {
		t.Run(name, func(t *testing.T) {
			verifier, err := buildVerifier(mode)
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
		verifier, err := buildVerifier(mode)
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
	_, err := buildVerifier("")
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
