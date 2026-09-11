package domain_test

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

var manifestNow = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func digestOf(content []byte) string {
	sum := sha256.Sum256(content)
	return hex.EncodeToString(sum[:])
}

const someDigest = "abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789"

func manifest(t *testing.T, content []byte, entries []domain.ManifestEntry) domain.Manifest {
	t.Helper()
	m, err := domain.NewManifest("exp-1", "tenant-a", "job-1",
		json.RawMessage(`{"from":"2026-01-01"}`), manifestNow.Add(-time.Hour),
		entries, digestOf(content), int64(len(content)), manifestNow)
	if err != nil {
		t.Fatalf("NewManifest: %v", err)
	}
	return m
}

func entries() []domain.ManifestEntry {
	return []domain.ManifestEntry{
		{ResourceType: "encounter", RowCount: 1200, SHA256: someDigest, SourceMaxVersion: 45},
		{ResourceType: "patient", RowCount: 800, SHA256: someDigest, SourceMaxVersion: 12},
	}
}

// SRS-NFR-012's verification clause: export completeness can be verified.
func TestCompleteExportVerifies(t *testing.T) {
	content := []byte("patient,encounter,...")
	m := manifest(t, content, entries())

	if err := m.VerifyIntegrity(content); err != nil {
		t.Fatalf("VerifyIntegrity: %v", err)
	}
	check := m.VerifyCompleteness(map[string]int64{"patient": 800, "encounter": 1200})
	if !check.Complete {
		t.Fatalf("a complete export failed verification: %+v", check)
	}
	if m.TotalRows != 2000 {
		t.Fatalf("total rows %d, want 2000", m.TotalRows)
	}
}

// The half a checksum cannot do. An export that dropped rows because a query
// timed out mid-stream has a perfectly valid digest.
func TestAShortExportHasAValidDigestAndFailsCompleteness(t *testing.T) {
	content := []byte("patient,encounter,...")
	m := manifest(t, content, entries())

	// The bytes are intact — the file that was produced is the file that
	// arrived.
	if err := m.VerifyIntegrity(content); err != nil {
		t.Fatalf("VerifyIntegrity: %v", err)
	}

	// And it is a thousand rows short.
	check := m.VerifyCompleteness(map[string]int64{"patient": 800, "encounter": 200})
	if check.Complete {
		t.Fatal("an export missing 1000 encounters passed completeness")
	}
	if check.Reason != domain.ReasonExportShort {
		t.Fatalf("reason %q, want %q", check.Reason, domain.ReasonExportShort)
	}
	if len(check.Missing) != 1 || check.Missing[0].ResourceType != "encounter" {
		t.Fatalf("discrepancies: %+v", check.Missing)
	}
	if check.Missing[0].Expected != 1200 || check.Missing[0].Observed != 200 {
		t.Fatalf("the discrepancy does not say how short: %+v", check.Missing[0])
	}
}

func TestCorruptedContentFailsIntegrity(t *testing.T) {
	m := manifest(t, []byte("patient,encounter,..."), entries())

	if err := m.VerifyIntegrity([]byte("patient,encounter,tampered")); !errors.Is(err, domain.ErrIncomplete) {
		t.Fatalf("want ErrIncomplete for altered content, got %v", err)
	}
}

// Content nobody described is rarer and more alarming than content that is
// short, so it gets its own reason rather than being folded in.
func TestUndescribedContentIsReportedSeparately(t *testing.T) {
	content := []byte("patient,encounter,...")
	m := manifest(t, content, entries())

	check := m.VerifyCompleteness(map[string]int64{
		"patient": 800, "encounter": 1200, "prescription": 50,
	})
	if check.Complete {
		t.Fatal("an export containing an undescribed resource passed")
	}
	if check.Reason != domain.ReasonExportHasExtra {
		t.Fatalf("reason %q, want %q", check.Reason, domain.ReasonExportHasExtra)
	}
	if len(check.Unexpected) != 1 || check.Unexpected[0] != "prescription" {
		t.Fatalf("unexpected: %v", check.Unexpected)
	}
}

// More rows than promised is not "extra data is fine": it means the export ran
// past its watermark, so the file is not the consistent snapshot it claims.
func TestMoreRowsThanPromisedIsADiscrepancyNotABonus(t *testing.T) {
	content := []byte("patient,encounter,...")
	m := manifest(t, content, entries())

	check := m.VerifyCompleteness(map[string]int64{"patient": 900, "encounter": 1200})
	if check.Complete {
		t.Fatal("an over-full export passed completeness")
	}
	if check.Reason != domain.ReasonExportCountsDisagree {
		t.Fatalf("reason %q, want %q", check.Reason, domain.ReasonExportCountsDisagree)
	}
}

// An absent resource type reads as zero rows, so a completely missing section
// is caught rather than skipped.
func TestAMissingResourceTypeIsCaught(t *testing.T) {
	content := []byte("patient only")
	m := manifest(t, content, entries())

	check := m.VerifyCompleteness(map[string]int64{"patient": 800})
	if check.Complete {
		t.Fatal("an export missing an entire resource type passed")
	}
	if len(check.Missing) != 1 || check.Missing[0].Observed != 0 {
		t.Fatalf("the missing section was not reported as zero: %+v", check.Missing)
	}
}

// Two manifests for the same export must be byte-identical, so a manifest can
// itself be compared by digest.
func TestManifestEntriesAreCanonicallyOrdered(t *testing.T) {
	content := []byte("x")
	forward := manifest(t, content, entries())

	reversed := []domain.ManifestEntry{entries()[1], entries()[0]}
	backward := manifest(t, content, reversed)

	a, err := json.Marshal(forward)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	b, err := json.Marshal(backward)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	if string(a) != string(b) {
		t.Fatalf("manifests differ by input order:\n%s\n%s", a, b)
	}
}

func TestManifestValidation(t *testing.T) {
	content := []byte("x")
	good := entries()

	cases := map[string]func() error{
		// An export with no watermark is one nobody can say anything about:
		// a missing record is indistinguishable from one written afterwards.
		"no watermark": func() error {
			_, err := domain.NewManifest("e", "t", "job", nil, time.Time{}, good, digestOf(content), 1, manifestNow)
			return err
		},
		"no entries": func() error {
			_, err := domain.NewManifest("e", "t", "job", nil, manifestNow, nil, digestOf(content), 1, manifestNow)
			return err
		},
		"no producing job": func() error {
			_, err := domain.NewManifest("e", "t", "", nil, manifestNow, good, digestOf(content), 1, manifestNow)
			return err
		},
		"short object digest": func() error {
			_, err := domain.NewManifest("e", "t", "job", nil, manifestNow, good, "abc", 1, manifestNow)
			return err
		},
		// Two entries for one type make the row count ambiguous.
		"duplicate resource type": func() error {
			_, err := domain.NewManifest("e", "t", "job", nil, manifestNow,
				[]domain.ManifestEntry{good[0], good[0]}, digestOf(content), 1, manifestNow)
			return err
		},
		"entry with no digest": func() error {
			_, err := domain.NewManifest("e", "t", "job", nil, manifestNow,
				[]domain.ManifestEntry{{ResourceType: "patient", RowCount: 1}},
				digestOf(content), 1, manifestNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidManifest) {
				t.Fatalf("want ErrInvalidManifest, got %v", err)
			}
		})
	}
}
