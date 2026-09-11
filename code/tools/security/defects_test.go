package security_test

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
	"time"

	"gopkg.in/yaml.v3"
)

// Severity-1 defect gate (SRS-NFR-015).
//
// "No unresolved severity-1 clinical/security/data-integrity defect at the
// production gate." The gate is only real if something refuses, so this refuses
// — and, like the penetration-test gate, only under RELEASE_CHANNEL=production
// so it does not stand between a developer and a green build.

type defectRegister struct {
	Defects []defect `yaml:"defects"`
}

type defect struct {
	ID            string `yaml:"id"`
	Category      string `yaml:"category"`
	Summary       string `yaml:"summary"`
	DiscoveredOn  string `yaml:"discovered_on"`
	State         string `yaml:"state"`
	FixedOn       string `yaml:"fixed_on"`
	Evidence      string `yaml:"evidence"`
	AcceptedBy    string `yaml:"accepted_by"`
	AcceptedOn    string `yaml:"accepted_on"`
	ExpiresOn     string `yaml:"expires_on"`
	Justification string `yaml:"justification"`
}

// severity1Categories are the three where the consequence is not recoverable
// by trying again. Deliberately narrow: widening it makes the gate a list of
// forty items nobody reads.
var severity1Categories = map[string]bool{
	"clinical":       true,
	"security":       true,
	"data-integrity": true,
}

var defectID = regexp.MustCompile(`^DEF-\d{4}$`)

func loadDefects(t *testing.T) defectRegister {
	t.Helper()
	raw, err := os.ReadFile(filepath.Join(codeRoot(t), "security", "defect-register.yaml"))
	if err != nil {
		t.Fatalf("read defect register: %v", err)
	}
	var reg defectRegister
	if err := yaml.Unmarshal(raw, &reg); err != nil {
		t.Fatalf("parse defect register: %v", err)
	}
	return reg
}

func TestDefectRegisterIsWellFormed(t *testing.T) {
	seen := map[string]bool{}

	for _, d := range loadDefects(t).Defects {
		if !defectID.MatchString(d.ID) {
			t.Errorf("%q: id must look like DEF-0001", d.ID)
		}
		if seen[d.ID] {
			t.Errorf("%s: duplicate id", d.ID)
		}
		seen[d.ID] = true

		if !severity1Categories[d.Category] {
			t.Errorf("%s: category %q is not clinical, security or data-integrity — "+
				"a defect that is merely severe does not belong in this register", d.ID, d.Category)
		}
		if len(strings.TrimSpace(d.Summary)) < 20 {
			t.Errorf("%s: summary must describe what a user or patient experiences", d.ID)
		}
		if _, err := time.Parse("2006-01-02", d.DiscoveredOn); err != nil {
			t.Errorf("%s: discovered_on must be YYYY-MM-DD, got %q", d.ID, d.DiscoveredOn)
		}

		switch d.State {
		case "open":
		case "fixed":
			// A fix with no evidence is a claim. The evidence is what a
			// reviewer checks rather than takes on trust.
			if strings.TrimSpace(d.Evidence) == "" {
				t.Errorf("%s: fixed with no evidence — cite the commit and the regression test", d.ID)
			}
			if _, err := time.Parse("2006-01-02", d.FixedOn); err != nil {
				t.Errorf("%s: fixed_on must be YYYY-MM-DD, got %q", d.ID, d.FixedOn)
			}
		case "accepted":
			if !accountableAuthorities[strings.ToLower(d.AcceptedBy)] {
				t.Errorf("%s: accepted by %q, who is not an accountable authority for a "+
					"severity-1 defect", d.ID, d.AcceptedBy)
			}
			if len(strings.TrimSpace(d.Justification)) < 40 {
				t.Errorf("%s: an acceptance must say why the risk is tolerable and what "+
					"compensates", d.ID)
			}
			expires, err := time.Parse("2006-01-02", d.ExpiresOn)
			if err != nil {
				t.Errorf("%s: an accepted defect needs an expires_on, got %q", d.ID, d.ExpiresOn)
			} else if expires.Before(time.Now().UTC()) {
				t.Errorf("%s: acceptance expired on %s; the defect blocks again", d.ID, d.ExpiresOn)
			}
		default:
			t.Errorf("%s: state %q is not open, fixed or accepted", d.ID, d.State)
		}
	}
}

// TestNoSeverity1DefectAtTheProductionGate is the blocking half.
func TestNoSeverity1DefectAtTheProductionGate(t *testing.T) {
	if os.Getenv("RELEASE_CHANNEL") != "production" {
		t.Skip("not a production release; set RELEASE_CHANNEL=production to run the gate")
	}
	assertNoOpenSeverity1(t, loadDefects(t), time.Now().UTC())
}

// assertNoOpenSeverity1 holds the gate's logic, so it can be tested against
// registers other than the one on disk — which is empty in the steady state
// and would otherwise leave the gate unexercised.
func assertNoOpenSeverity1(t *testing.T, reg defectRegister, now time.Time) {
	t.Helper()

	for _, d := range reg.Defects {
		switch d.State {
		case "fixed":
		case "accepted":
			expires, err := time.Parse("2006-01-02", d.ExpiresOn)
			if err != nil || expires.Before(now) {
				t.Errorf("%s (%s): the acceptance is expired or undated; release blocked",
					d.ID, d.Category)
			}
		default:
			t.Errorf("%s (%s) is open: %q. A severity-1 defect must be fixed, or "+
				"accepted by an accountable authority, before production (SRS-NFR-015)",
				d.ID, d.Category, d.Summary)
		}
	}
}

// TestDefectGateBlocks proves the gate refuses what it exists to refuse.
func TestDefectGateBlocks(t *testing.T) {
	now := time.Date(2026, 9, 11, 0, 0, 0, 0, time.UTC)

	t.Run("an open defect blocks", func(t *testing.T) {
		probe := &testing.T{}
		assertNoOpenSeverity1(probe, defectRegister{Defects: []defect{{
			ID: "DEF-0001", Category: "clinical", State: "open",
			Summary: "a medication administration can be recorded against the wrong patient",
		}}}, now)
		if !probe.Failed() {
			t.Fatal("a release with an open severity-1 clinical defect was allowed")
		}
	})

	t.Run("an expired acceptance blocks again", func(t *testing.T) {
		probe := &testing.T{}
		assertNoOpenSeverity1(probe, defectRegister{Defects: []defect{{
			ID: "DEF-0002", Category: "security", State: "accepted",
			AcceptedBy: "vp-security", ExpiresOn: "2026-01-01",
		}}}, now)
		if !probe.Failed() {
			t.Fatal("a release resting on an expired acceptance was allowed")
		}
	})

	t.Run("a fixed defect does not block", func(t *testing.T) {
		probe := &testing.T{}
		assertNoOpenSeverity1(probe, defectRegister{Defects: []defect{{
			ID: "DEF-0003", Category: "data-integrity", State: "fixed",
			Evidence: "commit abc1234; TestOutboxSurvivesRollback",
		}}}, now)
		if probe.Failed() {
			t.Fatal("a fixed defect blocked a release")
		}
	})

	t.Run("a live acceptance does not block", func(t *testing.T) {
		probe := &testing.T{}
		assertNoOpenSeverity1(probe, defectRegister{Defects: []defect{{
			ID: "DEF-0004", Category: "security", State: "accepted",
			AcceptedBy: "vp-security", ExpiresOn: "2027-01-01",
		}}}, now)
		if probe.Failed() {
			t.Fatal("a live, signed acceptance blocked a release")
		}
	})
}
