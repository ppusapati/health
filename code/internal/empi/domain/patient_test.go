package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

var at = time.Date(2026, 9, 12, 9, 0, 0, 0, time.UTC)

func minimalDemographics() domain.Demographics {
	return domain.Demographics{
		Name: domain.HumanName{Family: "Iyer", Given: []string{"Meera"}},
		Sex:  domain.SexFemale,
	}
}

func newPatient(t *testing.T) *domain.Patient {
	t.Helper()
	p, err := domain.NewPatient("patient-1", "tenant-a", "facility-1",
		minimalDemographics(), domain.DefaultPolicy("IN"), at)
	if err != nil {
		t.Fatalf("NewPatient: %v", err)
	}
	return p
}

// SRS-EMPI-002. The whole reason this context exists: an MRN is printed on a
// wristband, quoted on the phone, corrected for a transposition and superseded
// by a merge. A clinical record keyed on it would follow every one of those
// changes, and one of them leads to the wrong patient.
func TestTheInternalIdentifierCannotBeReassigned(t *testing.T) {
	p := newPatient(t)
	original := p.ID()

	// Every mutation the aggregate offers, and the id survives all of them.
	if err := p.Confirm(at); err != nil {
		t.Fatalf("Confirm: %v", err)
	}
	if err := p.UpdateDemographics(domain.Demographics{
		Name: domain.HumanName{Family: "Iyer-Rao", Given: []string{"Meera"}},
		Sex:  domain.SexFemale,
	}, domain.DefaultPolicy("IN"), at); err != nil {
		t.Fatalf("UpdateDemographics: %v", err)
	}
	if err := p.TransitionTo(domain.StatusMerged, at); err != nil {
		t.Fatalf("TransitionTo: %v", err)
	}

	if p.ID() != original {
		t.Fatalf("the internal identifier changed from %q to %q", original, p.ID())
	}

	// And there is no exported way to set it. This is checked by the compiler
	// rather than here — `p.id = "other"` does not compile outside the package
	// — but the property is worth naming where a reader will look for it.
}

func TestANewPatientStartsAsACandidate(t *testing.T) {
	p := newPatient(t)

	// Not active. Identity is confirmed by somebody who saw a document or the
	// patient; defaulting to active would make "confirmed" a state nobody ever
	// has to reach, and the distinction is what SRS-EMPI-010 rests on.
	if p.Status != domain.StatusCandidate {
		t.Fatalf("Status = %q, want candidate", p.Status)
	}
	if p.Version != 1 {
		t.Fatalf("Version = %d, want 1", p.Version)
	}
}

func TestLifecycleRefusesAnUndefinedTransition(t *testing.T) {
	p := newPatient(t)
	if err := p.TransitionTo(domain.StatusMerged, at); err != nil {
		t.Fatalf("candidate -> merged: %v", err)
	}

	// Merged records are restored by an unmerge, which decides the status from
	// the merge journal. There is no direct route to inactive.
	if err := p.TransitionTo(domain.StatusInactive, at); !errors.Is(err, domain.ErrInvalidTransition) {
		t.Fatalf("merged -> inactive = %v, want ErrInvalidTransition", err)
	}
}

func TestTransitioningToTheCurrentStatusIsANoOp(t *testing.T) {
	p := newPatient(t)
	before := p.Version

	if err := p.TransitionTo(domain.StatusCandidate, at); err != nil {
		t.Fatalf("TransitionTo(current): %v", err)
	}
	if p.Version != before {
		t.Fatalf("a no-op transition bumped the version to %d", p.Version)
	}
}

// Correcting the losing side of a merge writes to a record nobody reads. The
// survivor is the record to correct, and silently accepting the write would
// leave a clerk believing they had fixed something.
func TestDemographicsCannotBeEditedOnAMergedRecord(t *testing.T) {
	p := newPatient(t)
	if err := p.TransitionTo(domain.StatusMerged, at); err != nil {
		t.Fatalf("TransitionTo: %v", err)
	}
	p.MergedIntoPatientID = "patient-2"

	err := p.UpdateDemographics(minimalDemographics(), domain.DefaultPolicy("IN"), at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("UpdateDemographics on a merged record = %v, want a refusal", err)
	}
}

func TestRegistrationRequiresATenantAndAFacility(t *testing.T) {
	cases := map[string]struct{ id, tenant, facility string }{
		"no id":       {"", "tenant-a", "facility-1"},
		"no tenant":   {"patient-1", "", "facility-1"},
		"no facility": {"patient-1", "tenant-a", ""},
	}

	for name, c := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := domain.NewPatient(c.id, c.tenant, c.facility,
				minimalDemographics(), domain.DefaultPolicy("IN"), at)
			if !errors.Is(err, domain.ErrInvalidPatient) {
				t.Fatalf("NewPatient = %v, want ErrInvalidPatient", err)
			}
		})
	}
}

// SRS-EMPI-008's factual half. The policy half — warn or block — belongs to
// scheduling, because the identity context cannot see a scheduling decision.
func TestADeceasedPatientDoesNotAcceptRoutineScheduling(t *testing.T) {
	p := newPatient(t)
	if !p.AcceptsRoutineScheduling() {
		t.Fatal("a living patient was refused routine scheduling")
	}

	p.Deceased = &domain.DeceasedRecord{
		Date: at.AddDate(0, 0, -1), Precision: domain.PrecisionDay,
		Source: "registrar", RecordedAt: at, RecordedBy: "clerk-1",
	}
	if p.AcceptsRoutineScheduling() {
		t.Fatal("a deceased patient accepts routine scheduling")
	}
}

// A merged record is not the record to book against either: the survivor is.
func TestAMergedPatientDoesNotAcceptRoutineScheduling(t *testing.T) {
	p := newPatient(t)
	if err := p.TransitionTo(domain.StatusMerged, at); err != nil {
		t.Fatalf("TransitionTo: %v", err)
	}
	if p.AcceptsRoutineScheduling() {
		t.Fatal("a merged record accepts routine scheduling")
	}
	if p.IsResolvable() {
		t.Fatal("a merged record reports itself as directly resolvable")
	}
}

func TestADeceasedRecordNeedsASourceAndAnActor(t *testing.T) {
	cases := map[string]domain.DeceasedRecord{
		"no source": {RecordedBy: "clerk-1"},
		"no actor":  {Source: "registrar"},
		"dated without precision": {
			Date: at, Source: "registrar", RecordedBy: "clerk-1",
		},
	}

	for name, record := range cases {
		t.Run(name, func(t *testing.T) {
			if err := record.Validate(); !errors.Is(err, domain.ErrInvalidPatient) {
				t.Fatalf("Validate = %v, want a refusal", err)
			}
		})
	}

	good := domain.DeceasedRecord{
		Date: at, Precision: domain.PrecisionDay,
		Source: "national death registry", RecordedBy: "feed", RecordedAt: at,
	}
	if err := good.Validate(); err != nil {
		t.Fatalf("a complete deceased record was refused: %v", err)
	}
}
