package domain_test

import (
	"errors"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

// Merge and unmerge (SRS-EMPI-005, SRS-EMPI-006).
//
// The asymmetry that governs every refusal here: a merge that should not have
// happened produces a chart that reads as coherent. Two people's allergies,
// medications and diagnoses sit together and nothing looks broken. It is found
// by a reaction, not by a report.

func patientNamed(t *testing.T, id, family string) *domain.Patient {
	t.Helper()
	p, err := domain.NewPatient(id, "tenant-a", "facility-1", domain.Demographics{
		Name: domain.HumanName{Family: family, Given: []string{"Meera"}},
		Sex:  domain.SexFemale,
	}, domain.DefaultPolicy("IN"), at)
	if err != nil {
		t.Fatalf("NewPatient: %v", err)
	}
	return p
}

func mrn(id, patientID, value string, status domain.IdentifierStatus, primary bool) domain.Identifier {
	return domain.Identifier{
		ID: id, PatientID: patientID, Type: domain.IdentifierMRN,
		System: "facility-1", Value: value, Status: status,
		Source: "registration", Primary: primary, LinkedAt: at,
	}
}

func nationalID(id, patientID, value string) domain.Identifier {
	return domain.Identifier{
		ID: id, PatientID: patientID, Type: domain.IdentifierNationalHealth,
		System: "abdm", Value: value, Status: domain.IdentifierActive,
		Source: "adapter", LinkedAt: at,
	}
}

// The survivor keeps its identity. That is SRS-EMPI-002 holding through the one
// operation most likely to break it.
func TestAMergeDoesNotChangeEitherInternalIdentifier(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	plan, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{mrn("i1", "patient-1", "MRN-0001", domain.IdentifierActive, true)},
		domain.IdentifierSet{mrn("i2", "patient-2", "MRN-0002", domain.IdentifierActive, true)})
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}

	record, err := plan.Apply("merge-1", "him-1", "same person, two registrations", at)
	if err != nil {
		t.Fatalf("Apply: %v", err)
	}

	if survivor.ID() != "patient-1" || merged.ID() != "patient-2" {
		t.Fatalf("a merge changed an internal identifier: %s, %s", survivor.ID(), merged.ID())
	}
	if merged.Status != domain.StatusMerged {
		t.Fatalf("the losing record is %s", merged.Status)
	}
	if merged.MergedIntoPatientID != survivor.ID() {
		t.Fatal("the losing record does not point at the survivor")
	}
	if record.SurvivorID != "patient-1" || record.MergedID != "patient-2" {
		t.Fatalf("the journal names the wrong records: %+v", record)
	}
}

// "All child references resolve to survivor". In practice most of that is a
// clerk typing the old MRN off a discharge summary, so the losing record's MRN
// moves across superseded rather than being deleted.
func TestTheLosingMRNMovesToTheSurvivorAsSuperseded(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	plan, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{mrn("i1", "patient-1", "MRN-0001", domain.IdentifierActive, true)},
		domain.IdentifierSet{mrn("i2", "patient-2", "MRN-0002", domain.IdentifierActive, true)})
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}

	if len(plan.MoveToSurvivor) != 1 {
		t.Fatalf("%d identifiers planned to move, want 1", len(plan.MoveToSurvivor))
	}
	move := plan.MoveToSurvivor[0]
	if move.Identifier.Value != "MRN-0002" {
		t.Fatalf("the wrong identifier is moving: %q", move.Identifier.Value)
	}
	// Superseded, not active: two active MRNs would give a wristband two
	// answers, and the survivor's own is the one that stays.
	if move.NewStatus != domain.IdentifierSuperseded {
		t.Fatalf("the losing MRN moves as %s, want superseded", move.NewStatus)
	}
}

// An identifier the survivor does not hold moves across still active. Losing it
// would make the merge destroy information it was supposed to consolidate.
func TestAnIdentifierTheSurvivorLacksMovesAcrossActive(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	plan, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{mrn("i1", "patient-1", "MRN-0001", domain.IdentifierActive, true)},
		domain.IdentifierSet{
			mrn("i2", "patient-2", "MRN-0002", domain.IdentifierActive, true),
			nationalID("i3", "patient-2", "11-1111-1111-1111"),
		})
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}

	var national *domain.PlannedMove
	for i := range plan.MoveToSurvivor {
		if plan.MoveToSurvivor[i].Identifier.Type == domain.IdentifierNationalHealth {
			national = &plan.MoveToSurvivor[i]
		}
	}
	if national == nil {
		t.Fatal("the national health identifier was dropped by the merge")
	}
	if national.NewStatus != domain.IdentifierActive {
		t.Fatalf("it moved as %s; the survivor did not hold one, so it stays usable", national.NewStatus)
	}
}

// The refusal that matters most. A human has clicked merge on two records
// holding different national health identifiers; they have misread something,
// and recording their intent faithfully would fuse two people.
func TestMergeIsRefusedWhenStrongIdentifiersDisagree(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	_, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{nationalID("i1", "patient-1", "11-1111-1111-1111")},
		domain.IdentifierSet{nationalID("i2", "patient-2", "22-2222-2222-2222")})
	if !errors.Is(err, domain.ErrMergeRefused) {
		t.Fatalf("PlanMerge = %v, want ErrMergeRefused", err)
	}
	if merged.Status == domain.StatusMerged {
		t.Fatal("the refused merge was applied anyway")
	}
}

// The same identifier on both sides is evidence they ARE one person, so it must
// not be mistaken for a conflict.
func TestAMatchingStrongIdentifierDoesNotBlockAMerge(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Rao")

	shared := "11-1111-1111-1111"
	if _, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{nationalID("i1", "patient-1", shared)},
		domain.IdentifierSet{nationalID("i2", "patient-2", shared)}); err != nil {
		t.Fatalf("PlanMerge on a shared identifier: %v", err)
	}
}

// A revoked identifier was attached in error. Moving it across would re-attach
// somebody else's number to a live record.
func TestARevokedIdentifierIsNotCarriedOver(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	revoked := nationalID("i3", "patient-2", "99-9999-9999-9999")
	revoked.Status = domain.IdentifierRevoked

	plan, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{mrn("i1", "patient-1", "MRN-0001", domain.IdentifierActive, true)},
		domain.IdentifierSet{mrn("i2", "patient-2", "MRN-0002", domain.IdentifierActive, true), revoked})
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}
	for _, move := range plan.MoveToSurvivor {
		if move.Identifier.ID == "i3" {
			t.Fatal("a revoked identifier was carried to the survivor")
		}
	}
}

// Losing a recorded death would let a deceased patient be scheduled, which is
// exactly the failure SRS-EMPI-008 exists to prevent.
func TestADeceasedRecordSurvivesTheMerge(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")
	merged.Deceased = &domain.DeceasedRecord{
		Date: at.AddDate(0, 0, -2), Precision: domain.PrecisionDay,
		Source: "registrar", RecordedAt: at, RecordedBy: "clerk-1",
	}

	plan, err := domain.PlanMerge(survivor, merged, nil, nil)
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}
	if !plan.CarryDeceased {
		t.Fatal("the merge planned to lose the deceased record")
	}

	record, err := plan.Apply("merge-1", "him-1", "duplicate", at)
	if err != nil {
		t.Fatalf("Apply: %v", err)
	}
	if survivor.Deceased == nil {
		t.Fatal("the survivor did not inherit the deceased record")
	}
	if survivor.AcceptsRoutineScheduling() {
		t.Fatal("the survivor still accepts routine scheduling after inheriting a death")
	}
	if !record.CarriedDeceased {
		t.Fatal("the journal does not record that the death was carried, so an unmerge cannot take it back")
	}
}

func TestMergeRefusals(t *testing.T) {
	cases := map[string]func() (*domain.Patient, *domain.Patient){
		"into itself": func() (*domain.Patient, *domain.Patient) {
			p := patientNamed(t, "patient-1", "Iyer")
			return p, p
		},
		"survivor already merged": func() (*domain.Patient, *domain.Patient) {
			survivor := patientNamed(t, "patient-1", "Iyer")
			_ = survivor.TransitionTo(domain.StatusMerged, at)
			survivor.MergedIntoPatientID = "patient-3"
			return survivor, patientNamed(t, "patient-2", "Iyer")
		},
		"loser already merged": func() (*domain.Patient, *domain.Patient) {
			merged := patientNamed(t, "patient-2", "Iyer")
			_ = merged.TransitionTo(domain.StatusMerged, at)
			merged.MergedIntoPatientID = "patient-3"
			return patientNamed(t, "patient-1", "Iyer"), merged
		},
		"different tenants": func() (*domain.Patient, *domain.Patient) {
			other := patientNamed(t, "patient-2", "Iyer")
			other.TenantID = "tenant-b"
			return patientNamed(t, "patient-1", "Iyer"), other
		},
	}

	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			survivor, merged := build()
			if _, err := domain.PlanMerge(survivor, merged, nil, nil); !errors.Is(err, domain.ErrMergeRefused) {
				t.Fatalf("PlanMerge = %v, want ErrMergeRefused", err)
			}
		})
	}
}

// A merge with no reason cannot be reviewed afterwards, and the review is the
// only thing between a mistake and two people's records.
func TestAMergeNeedsAReasonAndAnActor(t *testing.T) {
	build := func() domain.MergePlan {
		plan, err := domain.PlanMerge(patientNamed(t, "patient-1", "Iyer"),
			patientNamed(t, "patient-2", "Iyer"), nil, nil)
		if err != nil {
			t.Fatalf("PlanMerge: %v", err)
		}
		return plan
	}

	if _, err := build().Apply("merge-1", "him-1", "  ", at); !errors.Is(err, domain.ErrMergeRefused) {
		t.Fatalf("a merge with no reason was applied: %v", err)
	}
	if _, err := build().Apply("merge-1", "", "duplicate", at); !errors.Is(err, domain.ErrMergeRefused) {
		t.Fatalf("a merge with no actor was applied: %v", err)
	}
}

// Unmerge (SRS-EMPI-006).

func mergedPair(t *testing.T) (*domain.Patient, *domain.Patient, domain.MergeRecord) {
	t.Helper()

	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")

	plan, err := domain.PlanMerge(survivor, merged,
		domain.IdentifierSet{mrn("i1", "patient-1", "MRN-0001", domain.IdentifierActive, true)},
		domain.IdentifierSet{mrn("i2", "patient-2", "MRN-0002", domain.IdentifierActive, true)})
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}
	record, err := plan.Apply("merge-1", "him-1", "same person", at)
	if err != nil {
		t.Fatalf("Apply: %v", err)
	}
	return survivor, merged, record
}

// The losing record goes back to what it was, from the journal rather than from
// a default. Restoring a candidate as active would silently confirm an identity
// nobody verified.
func TestUnmergeRestoresThePreviousStatus(t *testing.T) {
	survivor, merged, record := mergedPair(t)
	if record.MergedPreviousStatus != domain.StatusCandidate {
		t.Fatalf("the journal recorded %q as the previous status", record.MergedPreviousStatus)
	}

	if err := domain.PlanUnmerge(record, survivor, merged, domain.UnmergeCheck{}); err != nil {
		t.Fatalf("PlanUnmerge: %v", err)
	}
	if err := domain.ApplyUnmerge(&record, survivor, merged, "him-1", "merged in error", at); err != nil {
		t.Fatalf("ApplyUnmerge: %v", err)
	}

	if merged.Status != domain.StatusCandidate {
		t.Fatalf("the record came back as %q, want candidate", merged.Status)
	}
	if merged.MergedIntoPatientID != "" {
		t.Fatal("the record still points at a survivor")
	}
	if !record.Undone || record.UndoneAt == nil || record.UndoReason == "" {
		t.Fatalf("the journal does not record the reversal: %+v", record)
	}
}

// The condition that actually blocks an unmerge: a note written against the
// merged record belongs to one of the two people, and nothing in the note says
// which.
func TestUnmergeIsBlockedByClinicalRecordsWrittenSinceTheMerge(t *testing.T) {
	survivor, merged, record := mergedPair(t)

	err := domain.PlanUnmerge(record, survivor, merged,
		domain.UnmergeCheck{ClinicalRecordsSinceMerge: 3})
	if !errors.Is(err, domain.ErrUnmergeRefused) {
		t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
	}
	// SRS-EMPI-006 requires the block to carry an explicit reason: an operator
	// told only "no" will try again through the database.
	if !contains(err.Error(), "clinical records") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

func TestUnmergeRefusals(t *testing.T) {
	t.Run("already reversed", func(t *testing.T) {
		survivor, merged, record := mergedPair(t)
		record.Undone = true
		if err := domain.PlanUnmerge(record, survivor, merged, domain.UnmergeCheck{}); !errors.Is(err, domain.ErrUnmergeRefused) {
			t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
		}
	})

	t.Run("survivor merged again", func(t *testing.T) {
		survivor, merged, record := mergedPair(t)
		err := domain.PlanUnmerge(record, survivor, merged,
			domain.UnmergeCheck{SurvivorMergedAgain: true})
		if !errors.Is(err, domain.ErrUnmergeRefused) {
			t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
		}
	})

	t.Run("a later merge stands", func(t *testing.T) {
		survivor, merged, record := mergedPair(t)
		err := domain.PlanUnmerge(record, survivor, merged,
			domain.UnmergeCheck{LaterMergeExists: true})
		if !errors.Is(err, domain.ErrUnmergeRefused) {
			t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
		}
	})

	t.Run("record is not merged", func(t *testing.T) {
		survivor, _, record := mergedPair(t)
		fresh := patientNamed(t, "patient-2", "Iyer")
		if err := domain.PlanUnmerge(record, survivor, fresh, domain.UnmergeCheck{}); !errors.Is(err, domain.ErrUnmergeRefused) {
			t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
		}
	})

	t.Run("merged into somebody else", func(t *testing.T) {
		survivor, merged, record := mergedPair(t)
		merged.MergedIntoPatientID = "patient-9"
		if err := domain.PlanUnmerge(record, survivor, merged, domain.UnmergeCheck{}); !errors.Is(err, domain.ErrUnmergeRefused) {
			t.Fatalf("PlanUnmerge = %v, want ErrUnmergeRefused", err)
		}
	})
}

// A death the survivor inherited at merge time goes back with the record it
// came from.
func TestUnmergeReturnsAnInheritedDeceasedRecord(t *testing.T) {
	survivor := patientNamed(t, "patient-1", "Iyer")
	merged := patientNamed(t, "patient-2", "Iyer")
	merged.Deceased = &domain.DeceasedRecord{
		Date: at, Precision: domain.PrecisionDay,
		Source: "registrar", RecordedAt: at, RecordedBy: "clerk-1",
	}

	plan, err := domain.PlanMerge(survivor, merged, nil, nil)
	if err != nil {
		t.Fatalf("PlanMerge: %v", err)
	}
	record, err := plan.Apply("merge-1", "him-1", "duplicate", at)
	if err != nil {
		t.Fatalf("Apply: %v", err)
	}

	if err := domain.ApplyUnmerge(&record, survivor, merged, "him-1", "merged in error", at); err != nil {
		t.Fatalf("ApplyUnmerge: %v", err)
	}
	if survivor.Deceased != nil {
		t.Fatal("the survivor kept a death it inherited from the record it no longer contains")
	}
}

func TestUnmergeNeedsAReasonAndAnActor(t *testing.T) {
	survivor, merged, record := mergedPair(t)
	if err := domain.ApplyUnmerge(&record, survivor, merged, "him-1", "", at); !errors.Is(err, domain.ErrUnmergeRefused) {
		t.Fatalf("an unmerge with no reason was applied: %v", err)
	}
	if err := domain.ApplyUnmerge(&record, survivor, merged, "", "wrong", at); !errors.Is(err, domain.ErrUnmergeRefused) {
		t.Fatalf("an unmerge with no actor was applied: %v", err)
	}
}

// The review queue (SRS-EMPI-004).

// The same pair found from either side is one row, not two. Without the
// canonical order a busy desk produces a queue full of A-B and B-A.
func TestACandidatePairHasOneSpelling(t *testing.T) {
	first, err := domain.NewDuplicateCandidate("c1", "tenant-a", "patient-2", "patient-1",
		0.8, domain.OutcomeProbable, "registration", at)
	if err != nil {
		t.Fatalf("NewDuplicateCandidate: %v", err)
	}
	second, err := domain.NewDuplicateCandidate("c2", "tenant-a", "patient-1", "patient-2",
		0.8, domain.OutcomeProbable, "registration", at)
	if err != nil {
		t.Fatalf("NewDuplicateCandidate: %v", err)
	}

	if first.PatientAID != second.PatientAID || first.PatientBID != second.PatientBID {
		t.Fatalf("the same pair has two spellings: %s/%s and %s/%s",
			first.PatientAID, first.PatientBID, second.PatientAID, second.PatientBID)
	}
}

// A dismissal with no reason is indistinguishable from a mis-click, and the
// pair never returns to the queue to be reconsidered.
func TestDismissingACandidateNeedsAReason(t *testing.T) {
	candidate, err := domain.NewDuplicateCandidate("c1", "tenant-a", "patient-1", "patient-2",
		0.8, domain.OutcomeProbable, "registration", at)
	if err != nil {
		t.Fatalf("NewDuplicateCandidate: %v", err)
	}

	if err := candidate.Dismiss("him-1", "  ", at); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Dismiss with no reason = %v, want a refusal", err)
	}
	if err := candidate.Dismiss("him-1", "twin sisters, confirmed with the family", at); err != nil {
		t.Fatalf("Dismiss: %v", err)
	}
	if candidate.Status != domain.ReviewDismissed || candidate.ReviewedAt == nil {
		t.Fatalf("the dismissal was not recorded: %+v", candidate)
	}

	// And it stays dismissed: reviewing a closed candidate again would let one
	// decision be quietly replaced by another.
	if err := candidate.Dismiss("him-2", "changed my mind", at); err == nil {
		t.Fatal("a dismissed candidate was dismissed again")
	}
}

func TestACandidateCannotPairAPatientWithItself(t *testing.T) {
	_, err := domain.NewDuplicateCandidate("c1", "tenant-a", "patient-1", "patient-1",
		0.9, domain.OutcomeProbable, "registration", at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewDuplicateCandidate = %v, want a refusal", err)
	}
}

func contains(haystack, needle string) bool { return strings.Contains(haystack, needle) }
