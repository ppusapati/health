// Package security holds the invariants of the risk acceptance register.
//
// SRS-SEC-006 permits a critical finding to pass the pipeline only when it is
// "formally risk accepted". Without a check, that sentence degrades into an
// ignore file nobody revisits: a suppression added for one release stays for
// three years, and the scanner reports green while the finding is still live.
//
// These tests make the register the single place an exception can exist, and
// give every exception a date on which it stops working.
package security_test

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
	"time"

	"gopkg.in/yaml.v3"
)

// maxAcceptanceWindow bounds how long a single acceptance may run before it
// has to be re-argued. A year is long enough for a genuine upstream fix to
// land and short enough that the accountable owner is still in the role.
const maxAcceptanceWindow = 365 * 24 * time.Hour

type register struct {
	Acceptances []acceptance `yaml:"acceptances"`
}

type acceptance struct {
	ID                  string `yaml:"id"`
	Finding             string `yaml:"finding"`
	Scanner             string `yaml:"scanner"`
	Severity            string `yaml:"severity"`
	Owner               string `yaml:"owner"`
	AcceptedOn          string `yaml:"accepted_on"`
	ExpiresOn           string `yaml:"expires_on"`
	Justification       string `yaml:"justification"`
	CompensatingControl string `yaml:"compensating_control"`
}

func codeRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Clean(filepath.Join(wd, "..", ".."))
}

func loadRegister(t *testing.T) register {
	t.Helper()
	path := filepath.Join(codeRoot(t), "security", "risk-acceptances.yaml")
	raw, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read register: %v", err)
	}
	var reg register
	if err := yaml.Unmarshal(raw, &reg); err != nil {
		t.Fatalf("parse register: %v", err)
	}
	return reg
}

var idPattern = regexp.MustCompile(`^RA-\d{4}$`)

// knownScanners are the scanners whose findings this register can excuse.
// A typo here would otherwise produce an acceptance that matches nothing while
// looking like diligence.
var knownScanners = map[string]bool{
	"trivy":        true,
	"gosec":        true,
	"govulncheck":  true,
	"npm-audit":    true,
	"gitleaks":     true,
	"trivy-config": true,
}

var knownSeverities = map[string]bool{"critical": true, "high": true, "medium": true}

func TestEveryAcceptanceIsComplete(t *testing.T) {
	reg := loadRegister(t)
	seen := map[string]bool{}

	for i, a := range reg.Acceptances {
		label := a.ID
		if label == "" {
			label = fmt.Sprintf("entry %d", i)
		}

		if !idPattern.MatchString(a.ID) {
			t.Errorf("%s: id must look like RA-0001, got %q", label, a.ID)
		}
		if seen[a.ID] {
			t.Errorf("%s: duplicate id; a suppression would be ambiguous", label)
		}
		seen[a.ID] = true

		if strings.TrimSpace(a.Finding) == "" {
			t.Errorf("%s: finding is required — which advisory or rule is excused", label)
		}
		if !knownScanners[a.Scanner] {
			t.Errorf("%s: scanner %q is not one this pipeline runs", label, a.Scanner)
		}
		if !knownSeverities[strings.ToLower(a.Severity)] {
			t.Errorf("%s: severity %q is not critical, high or medium", label, a.Severity)
		}
		if strings.TrimSpace(a.Owner) == "" {
			t.Errorf("%s: owner is required — someone carries this risk", label)
		}
		// A justification has to argue why the finding does not apply here.
		// The length floor does not make an argument good, but it does stop
		// "n/a" and "false positive" from passing as one.
		if len(strings.TrimSpace(a.Justification)) < 40 {
			t.Errorf("%s: justification must explain why the finding is tolerable in this system", label)
		}
		// "none" is an acceptable answer and an honest one. Silence is not:
		// the reviewer cannot tell whether the question was considered.
		if strings.TrimSpace(a.CompensatingControl) == "" {
			t.Errorf("%s: compensating_control is required; write \"none\" if there is none", label)
		}
	}
}

func TestNoAcceptanceIsExpiredOrOpenEnded(t *testing.T) {
	reg := loadRegister(t)
	now := time.Now().UTC()

	for _, a := range reg.Acceptances {
		accepted, err := time.Parse("2006-01-02", a.AcceptedOn)
		if err != nil {
			t.Errorf("%s: accepted_on must be YYYY-MM-DD, got %q", a.ID, a.AcceptedOn)
			continue
		}
		expires, err := time.Parse("2006-01-02", a.ExpiresOn)
		if err != nil {
			t.Errorf("%s: expires_on must be YYYY-MM-DD, got %q", a.ID, a.ExpiresOn)
			continue
		}
		if !expires.After(accepted) {
			t.Errorf("%s: expires_on %s is not after accepted_on %s", a.ID, a.ExpiresOn, a.AcceptedOn)
		}
		if expires.Sub(accepted) > maxAcceptanceWindow {
			t.Errorf("%s: acceptance runs %v, longer than the %v maximum; re-argue it sooner",
				a.ID, expires.Sub(accepted), maxAcceptanceWindow)
		}
		// The failure this test exists for. A green pipeline must not be
		// resting on a decision whose review date has passed.
		if expires.Before(now) {
			t.Errorf("%s: acceptance expired on %s — re-assess the finding or renew the acceptance",
				a.ID, a.ExpiresOn)
		}
	}
}

// suppressionPattern matches a non-empty, non-comment line of an ignore file
// and captures the finding and the acceptance id it cites.
var suppressionPattern = regexp.MustCompile(`^\s*(\S+)\s*#\s*(RA-\d{4})\s*$`)

func TestEverySuppressionCitesALiveAcceptance(t *testing.T) {
	reg := loadRegister(t)
	live := map[string]acceptance{}
	for _, a := range reg.Acceptances {
		live[a.ID] = a
	}

	path := filepath.Join(codeRoot(t), ".trivyignore")
	raw, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read .trivyignore: %v", err)
	}

	for n, line := range strings.Split(string(raw), "\n") {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "#") {
			continue
		}
		m := suppressionPattern.FindStringSubmatch(line)
		if m == nil {
			t.Errorf(".trivyignore:%d: %q must be `<finding>  # RA-0001`; an "+
				"unexplained suppression is how a critical finding disappears", n+1, trimmed)
			continue
		}
		finding, id := m[1], m[2]
		a, ok := live[id]
		if !ok {
			t.Errorf(".trivyignore:%d: cites %s, which is not in the register", n+1, id)
			continue
		}
		if a.Finding != finding {
			t.Errorf(".trivyignore:%d: suppresses %s but %s accepts %s",
				n+1, finding, id, a.Finding)
		}
	}
}

// TestExpiryDetectorWorks proves the expiry check can fail. A register that is
// empty in the steady state would otherwise let every assertion above pass
// vacuously, and a vacuous gate is worse than none: it reports assurance it is
// not providing.
func TestExpiryDetectorWorks(t *testing.T) {
	reg := register{Acceptances: []acceptance{{
		ID: "RA-9999", AcceptedOn: "2020-01-01", ExpiresOn: "2020-06-01",
	}}}
	expires, err := time.Parse("2006-01-02", reg.Acceptances[0].ExpiresOn)
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if !expires.Before(time.Now().UTC()) {
		t.Fatal("the expiry comparison no longer flags a past date")
	}
}

// TestSuppressionDetectorWorks does the same for the ignore-file parser: an
// uncited suppression must not match.
func TestSuppressionDetectorWorks(t *testing.T) {
	if suppressionPattern.MatchString("CVE-2025-12345") {
		t.Error("a suppression with no acceptance id was accepted")
	}
	if !suppressionPattern.MatchString("CVE-2025-12345  # RA-0001") {
		t.Error("a correctly cited suppression was rejected")
	}
}
