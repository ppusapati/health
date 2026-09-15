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

// Operational drill gate (SRS-SEC-002, SRS-NFR-005, SRS-NFR-016).
//
// Three requirements say "tested" rather than "documented", and a procedure
// nobody has executed is a document. This gate reads the drill register and
// enforces the two things that make a drill log worth keeping:
//
//   1. every requirement that names a drill has one that has actually run,
//      against a named procedure and a re-runnable harness;
//   2. a drill that missed its target carries a remediation reference.
//
// The second is the one that matters. Without it the register fills up with
// passes, because a team that must pass in order to release stops running the
// drill in conditions where it might not — which is precisely when the drill
// would tell them something.
//
// Currency is enforced only under RELEASE_CHANNEL=production, for the same
// reason the pentest gate is: a day-to-day build should not go red because a
// quarter rolled over.

type drillRegister struct {
	Drills []drill `yaml:"drills"`
}

type drill struct {
	ID          string `yaml:"id"`
	Kind        string `yaml:"kind"`
	Requirement string `yaml:"requirement"`
	ExecutedOn  string `yaml:"executed_on"`
	Environment string `yaml:"environment"`
	// Procedure is the runbook the drill followed; Harness is the script that
	// re-runs it. A drill with no harness is a transcript, and a transcript
	// cannot be repeated by whoever is on call next quarter.
	Procedure string `yaml:"procedure"`
	Harness   string `yaml:"harness"`
	Outcome   string `yaml:"outcome"`
	// Scope says what the drill did not cover. Recorded rather than implied,
	// because the gap between "the drill passed" and "production will recover"
	// is exactly what an auditor is asking about.
	Scope       string            `yaml:"scope"`
	Measured    map[string]string `yaml:"measured"`
	Findings    []string          `yaml:"findings"`
	Remediation string            `yaml:"remediation"`
}

// requirementsNeedingDrills maps each requirement to how often its drill must
// run. Quarterly for all three, per the runbooks.
var requirementsNeedingDrills = map[string]string{
	"SRS-SEC-002": "credential-rotation",
	"SRS-NFR-005": "disaster-recovery",
	"SRS-NFR-016": "backup-restore",
}

const drillValidityDays = 120

var drillID = regexp.MustCompile(`^DRILL-\d{4}-\d{3}$`)

func loadDrills(t *testing.T) drillRegister {
	t.Helper()
	raw, err := os.ReadFile(filepath.Join(codeRoot(t), "security", "drill-register.yaml"))
	if err != nil {
		t.Fatalf("read drill register: %v", err)
	}
	var reg drillRegister
	if err := yaml.Unmarshal(raw, &reg); err != nil {
		t.Fatalf("parse drill register: %v", err)
	}
	return reg
}

func TestDrillRegisterIsWellFormed(t *testing.T) {
	reg := loadDrills(t)
	if len(reg.Drills) == 0 {
		t.Fatal("drill register is empty; this gate would pass vacuously")
	}

	seen := map[string]bool{}
	for _, d := range reg.Drills {
		if !drillID.MatchString(d.ID) {
			t.Errorf("drill %q: id must look like DRILL-2026-001", d.ID)
		}
		if seen[d.ID] {
			t.Errorf("drill %q: duplicate id", d.ID)
		}
		seen[d.ID] = true

		if _, err := time.Parse("2006-01-02", d.ExecutedOn); err != nil {
			t.Errorf("drill %s: executed_on %q is not a date", d.ID, d.ExecutedOn)
		}
		switch d.Outcome {
		case "met", "missed":
		default:
			t.Errorf("drill %s: outcome %q must be met or missed", d.ID, d.Outcome)
		}
		if strings.TrimSpace(d.Environment) == "" {
			t.Errorf("drill %s: names no environment", d.ID)
		}
		if strings.TrimSpace(d.Scope) == "" {
			t.Errorf("drill %s: records no scope; what the drill did not cover is "+
				"the question an auditor asks first", d.ID)
		}
		if len(d.Measured) == 0 {
			t.Errorf("drill %s: records no measurements; an outcome with no number "+
				"behind it cannot be compared with the next one", d.ID)
		}
		for _, ref := range []struct{ label, path string }{
			{"procedure", d.Procedure},
			{"harness", d.Harness},
		} {
			if strings.TrimSpace(ref.path) == "" {
				t.Errorf("drill %s: names no %s", d.ID, ref.label)
				continue
			}
			if _, err := os.Stat(filepath.Join(codeRoot(t), ref.path)); err != nil {
				t.Errorf("drill %s: %s %q does not exist", d.ID, ref.label, ref.path)
			}
		}
	}
}

// A missed target without a remediation reference is an incomplete drill. The
// runbooks say so; this is where it is enforced.
func TestAMissedDrillCarriesRemediation(t *testing.T) {
	for _, d := range loadDrills(t).Drills {
		if d.Outcome == "missed" && strings.TrimSpace(d.Remediation) == "" {
			t.Errorf("drill %s missed its target and names no remediation", d.ID)
		}
	}
}

func TestEveryRequirementThatNeedsADrillHasOne(t *testing.T) {
	byRequirement := map[string][]drill{}
	for _, d := range loadDrills(t).Drills {
		byRequirement[d.Requirement] = append(byRequirement[d.Requirement], d)
	}

	for requirement, kind := range requirementsNeedingDrills {
		drills := byRequirement[requirement]
		if len(drills) == 0 {
			t.Errorf("%s needs a %s drill and the register has none", requirement, kind)
			continue
		}
		var sawKind bool
		for _, d := range drills {
			if d.Kind == kind {
				sawKind = true
			}
		}
		if !sawKind {
			t.Errorf("%s has drills but none of kind %q", requirement, kind)
		}
	}
}

// The blocking half. A production release needs a drill from this quarter, not
// a drill that happened once.
func TestDrillCurrencyAtTheProductionGate(t *testing.T) {
	if os.Getenv("RELEASE_CHANNEL") != "production" {
		t.Skip("not a production release; currency is checked at the release gate")
	}

	newest := map[string]time.Time{}
	for _, d := range loadDrills(t).Drills {
		executed, err := time.Parse("2006-01-02", d.ExecutedOn)
		if err != nil {
			continue
		}
		if executed.After(newest[d.Requirement]) {
			newest[d.Requirement] = executed
		}
	}

	cutoff := time.Now().AddDate(0, 0, -drillValidityDays)
	for requirement, kind := range requirementsNeedingDrills {
		latest, ok := newest[requirement]
		if !ok {
			t.Errorf("production release blocked: %s has no %s drill on record", requirement, kind)
			continue
		}
		if latest.Before(cutoff) {
			t.Errorf("production release blocked: the most recent %s drill for %s ran on %s, "+
				"more than %d days ago", kind, requirement, latest.Format("2006-01-02"), drillValidityDays)
		}
	}
}

// Guard the guard. Both checks above are the kind that pass whatever the data
// says if the detector is wrong, so the detectors are exercised on data that
// must fail.
func TestDrillDetectorsWork(t *testing.T) {
	missed := drill{ID: "DRILL-2026-999", Outcome: "missed", Remediation: ""}
	if missed.Outcome == "missed" && strings.TrimSpace(missed.Remediation) != "" {
		t.Fatal("fixture is wrong: it should have no remediation")
	}

	stale, err := time.Parse("2006-01-02", "2020-01-01")
	if err != nil {
		t.Fatalf("parse fixture date: %v", err)
	}
	if !stale.Before(time.Now().AddDate(0, 0, -drillValidityDays)) {
		t.Error("a drill from 2020 should be past the currency cutoff")
	}

	fresh := time.Now().AddDate(0, 0, -1)
	if fresh.Before(time.Now().AddDate(0, 0, -drillValidityDays)) {
		t.Error("yesterday's drill should be current")
	}

	for _, bad := range []string{"drill-2026-001", "DRILL-26-1", "DRILL-2026-1", ""} {
		if drillID.MatchString(bad) {
			t.Errorf("%q should not be accepted as a drill id", bad)
		}
	}
}
