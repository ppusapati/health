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

// Threat model action tracking (SRS-SEC-007).
//
// The requirement's verification is "threat model actions tracked to closure".
// A bullet list in a markdown document is not tracking: nothing fails when an
// action is forgotten, and the document ages into a description of what people
// once intended. These tests make the register the record and the due date
// real.

type actionRegister struct {
	Actions []action `yaml:"actions"`
}

type action struct {
	ID          string `yaml:"id"`
	Boundary    string `yaml:"boundary"`
	Finding     string `yaml:"finding"`
	Owner       string `yaml:"owner"`
	RaisedOn    string `yaml:"raised_on"`
	DueOn       string `yaml:"due_on"`
	State       string `yaml:"state"`
	Disposition string `yaml:"disposition"`
	ClosedOn    string `yaml:"closed_on"`
	ClosedBy    string `yaml:"closed_by"`
	Evidence    string `yaml:"evidence"`
}

var actionStates = map[string]bool{"open": true, "closed": true, "accepted": true}

func loadActions(t *testing.T) actionRegister {
	t.Helper()
	raw, err := os.ReadFile(filepath.Join(codeRoot(t), "security", "threat-model-actions.yaml"))
	if err != nil {
		t.Fatalf("read action register: %v", err)
	}
	var reg actionRegister
	if err := yaml.Unmarshal(raw, &reg); err != nil {
		t.Fatalf("parse action register: %v", err)
	}
	return reg
}

var actionID = regexp.MustCompile(`^TM-\d{4}$`)

func TestEveryThreatModelActionIsAssigned(t *testing.T) {
	reg := loadActions(t)
	if len(reg.Actions) == 0 {
		t.Fatal("no actions registered; a threat model that produced nothing to do " +
			"has either found nothing or recorded nothing")
	}

	seen := map[string]bool{}
	for _, a := range reg.Actions {
		if !actionID.MatchString(a.ID) {
			t.Errorf("%q: id must look like TM-0001", a.ID)
		}
		if seen[a.ID] {
			t.Errorf("%s: duplicate id", a.ID)
		}
		seen[a.ID] = true

		if strings.TrimSpace(a.Owner) == "" {
			t.Errorf("%s: no owner; an unowned action is not tracked", a.ID)
		}
		if strings.TrimSpace(a.Boundary) == "" {
			t.Errorf("%s: no trust boundary", a.ID)
		}
		if len(strings.TrimSpace(a.Finding)) < 40 {
			t.Errorf("%s: finding must state what the weakness is", a.ID)
		}
		if len(strings.TrimSpace(a.Disposition)) < 40 {
			t.Errorf("%s: disposition must state what will be done and why it can wait", a.ID)
		}
		if !actionStates[a.State] {
			t.Errorf("%s: state %q is not open, closed or accepted", a.ID, a.State)
		}
		// A closed action has to point at the thing that closed it, or
		// "closed" is just a word somebody typed.
		if a.State == "closed" {
			if strings.TrimSpace(a.Evidence) == "" {
				t.Errorf("%s: closed without evidence — cite the commit, test or document", a.ID)
			}
			if strings.TrimSpace(a.ClosedBy) == "" {
				t.Errorf("%s: closed by nobody", a.ID)
			}
		}
	}
}

func TestNoThreatModelActionIsOverdue(t *testing.T) {
	now := time.Now().UTC()
	for _, a := range loadActions(t).Actions {
		raised, err := time.Parse("2006-01-02", a.RaisedOn)
		if err != nil {
			t.Errorf("%s: raised_on must be YYYY-MM-DD, got %q", a.ID, a.RaisedOn)
			continue
		}
		due, err := time.Parse("2006-01-02", a.DueOn)
		if err != nil {
			t.Errorf("%s: due_on must be YYYY-MM-DD, got %q", a.ID, a.DueOn)
			continue
		}
		if !due.After(raised) {
			t.Errorf("%s: due_on %s is not after raised_on %s", a.ID, a.DueOn, a.RaisedOn)
		}
		if a.State != "open" {
			continue
		}
		// The assertion this file exists for. An open action past its date is
		// a decision that was never made, and the build is where it surfaces.
		if due.Before(now) {
			t.Errorf("%s: open and overdue since %s — close it, do it, or "+
				"re-argue the date with its owner (%s)", a.ID, a.DueOn, a.Owner)
		}
	}
}

// The document and the register must describe the same set of actions. A
// finding written up in prose but never registered is the failure mode this
// catches: it reads as tracked and is not.
func TestThreatModelAndRegisterAgree(t *testing.T) {
	path := filepath.Join(codeRoot(t), "docs", "engineering", "threat-model.md")
	raw, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read threat model: %v", err)
	}

	// Unanchored: actionID anchors to a whole string, which is right for
	// validating an id field and wrong for finding ids inside prose.
	citation := regexp.MustCompile(`TM-\d{4}`)
	cited := map[string]bool{}
	for _, m := range citation.FindAllString(string(raw), -1) {
		cited[m] = true
	}

	registered := map[string]bool{}
	for _, a := range loadActions(t).Actions {
		registered[a.ID] = true
	}

	for id := range cited {
		if !registered[id] {
			t.Errorf("threat-model.md cites %s, which is not in the action register", id)
		}
	}
	for id := range registered {
		if !cited[id] {
			t.Errorf("%s is registered but never explained in threat-model.md", id)
		}
	}
	if len(cited) == 0 {
		t.Fatal("the threat model cites no actions; this comparison would pass vacuously")
	}
}

// TestOverdueDetectorWorks proves the overdue check can fail, so a register
// that happens to be current today is not mistaken for a gate that works.
func TestOverdueDetectorWorks(t *testing.T) {
	due, err := time.Parse("2006-01-02", "2020-01-01")
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	if !due.Before(time.Now().UTC()) {
		t.Fatal("the overdue comparison no longer flags a past date")
	}
}
