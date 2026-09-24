package domain_test

import (
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

func newFacility(t *testing.T) *domain.Facility {
	t.Helper()
	f, err := domain.NewFacility("facility-1", "tenant-a", "main", "Main Hospital",
		domain.FacilityHospital, "Asia/Kolkata", now)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}
	return f
}

func TestNewFacilityNormalisesCodeAndStartsActive(t *testing.T) {
	f := newFacility(t)
	// Codes are upper-cased so "main" and "MAIN" cannot both be created and
	// then collide in barcodes and document numbering.
	if f.Code != "MAIN" {
		t.Fatalf("Code = %q, want MAIN", f.Code)
	}
	if f.Status != domain.FacilityActive {
		t.Fatalf("Status = %q, want active", f.Status)
	}
}

func TestFacilityCodeFormatRules(t *testing.T) {
	cases := map[string]bool{
		"MAIN":                  true,
		"ICU-2":                 true,
		"LAB_01":                true,
		"M":                     false, // single char is too weak to be a stable key
		"-LEAD":                 false, // must start alphanumeric
		"HAS SPACE":             false,
		"HAS.DOT":               false,
		strings.Repeat("A", 32): true,
		strings.Repeat("A", 33): false,
	}
	for code, wantValid := range cases {
		t.Run(code, func(t *testing.T) {
			_, err := domain.NewFacility("facility-1", "tenant-a", code, "Name",
				domain.FacilityHospital, "UTC", now)
			if wantValid && err != nil {
				t.Fatalf("code %q rejected: %v", code, err)
			}
			if !wantValid && err == nil {
				t.Fatalf("code %q accepted", code)
			}
		})
	}
}

func TestUnsupportedFacilityTypeRejected(t *testing.T) {
	_, err := domain.NewFacility("facility-1", "tenant-a", "MAIN", "Main",
		domain.FacilityType("spaceport"), "UTC", now)
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("want platform error, got %v", err)
	}
	if len(e.Violations) != 1 || e.Violations[0].Field != "type" {
		t.Fatalf("violations = %v", e.Violations)
	}
}

// A facility created without verified tenant scope would be unowned data.
func TestFacilityRequiresTenant(t *testing.T) {
	_, err := domain.NewFacility("facility-1", "", "MAIN", "Main",
		domain.FacilityHospital, "UTC", now)
	if err == nil {
		t.Fatal("facility without tenant must be rejected")
	}
}

// SRS-PLT-007's verification clause: renaming a display name does not break
// references. The code is the key and the name is a label, so a rename moves
// the label and nothing that points at the facility notices.
func TestRenameKeepsCodeStable(t *testing.T) {
	f := newFacility(t)
	original := f.Code

	if err := f.Rename("Main Hospital (North Wing)", now); err != nil {
		t.Fatalf("Rename: %v", err)
	}
	if f.Code != original {
		t.Fatalf("Rename changed Code from %q to %q", original, f.Code)
	}
	if f.DisplayName != "Main Hospital (North Wing)" {
		t.Fatalf("DisplayName = %q", f.DisplayName)
	}
	if f.Version != 2 {
		t.Fatalf("Version = %d, want 2", f.Version)
	}
}

func TestRenameRejectsBlank(t *testing.T) {
	f := newFacility(t)
	if err := f.Rename("   ", now); err == nil {
		t.Fatal("blank rename must be rejected")
	}
}

// SRS-PLT-015: retirement replaces deletion, and it is one-way.
func TestRetirementIsTerminal(t *testing.T) {
	f := newFacility(t)
	if err := f.TransitionTo(domain.FacilityRetired, now); err != nil {
		t.Fatalf("retire: %v", err)
	}
	if err := f.TransitionTo(domain.FacilityActive, now); err == nil {
		t.Fatal("a retired facility must not be reactivated")
	}
}

func TestDeactivateAndReactivate(t *testing.T) {
	f := newFacility(t)
	if err := f.TransitionTo(domain.FacilityInactive, now); err != nil {
		t.Fatalf("deactivate: %v", err)
	}
	if err := f.TransitionTo(domain.FacilityActive, now); err != nil {
		t.Fatalf("reactivate: %v", err)
	}
	if f.Version != 3 {
		t.Fatalf("Version = %d, want 3", f.Version)
	}
}
