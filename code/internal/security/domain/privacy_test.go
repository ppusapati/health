package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

func marketingPurpose(t *testing.T) domain.ProcessingPurpose {
	t.Helper()
	p, err := domain.NewProcessingPurpose("p-1", "tenant-a", "marketing",
		"Service updates and health campaigns", "consent", true, at)
	if err != nil {
		t.Fatalf("NewProcessingPurpose: %v", err)
	}
	return p
}

func carePurpose(t *testing.T) domain.ProcessingPurpose {
	t.Helper()
	p, err := domain.NewProcessingPurpose("p-2", "tenant-a", "care_delivery",
		"Provision of healthcare", "vital_interests", false, at)
	if err != nil {
		t.Fatalf("NewProcessingPurpose: %v", err)
	}
	return p
}

// Without a stated basis there is nothing to defend the processing on.
func TestPurposeRequiresALawfulBasis(t *testing.T) {
	if _, err := domain.NewProcessingPurpose("p-1", "tenant-a", "marketing",
		"Campaigns", "", true, at); !errors.Is(err, domain.ErrInvalidPurpose) {
		t.Fatalf("a purpose with no lawful basis was accepted: %v", err)
	}
}

func TestWithdrawableePurposeAcceptsWithdrawal(t *testing.T) {
	g, err := domain.NewPurposeGrant("g-1", "tenant-a", "patient-1", "desk-1",
		marketingPurpose(t), 3, false, at)
	if err != nil {
		t.Fatalf("withdrawal refused: %v", err)
	}
	if g.Granted {
		t.Fatal("a withdrawal was recorded as a grant")
	}
	// Which notice the subject saw is part of what they agreed to.
	if g.NoticeVersion != 3 {
		t.Fatalf("NoticeVersion = %d", g.NoticeVersion)
	}
}

// Pretending to honour a withdrawal that cannot lawfully be honoured is worse
// than refusing it.
// The rest of SRS-SEC-009: withdrawal affects future optional processing and
// nothing else. A purpose the hospital processes under a legal obligation is
// not one a withdrawal can switch off.
func TestNonWithdrawablePurposeRefusesWithdrawal(t *testing.T) {
	_, err := domain.NewPurposeGrant("g-1", "tenant-a", "patient-1", "desk-1",
		carePurpose(t), 3, false, at)
	if !errors.Is(err, domain.ErrNotWithdrawable) {
		t.Fatalf("withdrawal from care delivery was accepted: %v", err)
	}

	// Granting it is still fine.
	if _, err := domain.NewPurposeGrant("g-1", "tenant-a", "patient-1", "desk-1",
		carePurpose(t), 3, true, at); err != nil {
		t.Fatalf("grant refused: %v", err)
	}
}

// SRS-SEC-009's verification clause: privacy notices, purposes and consent
// artifacts are kept independently of clinical consent, and a grant names the
// notice version it was given against — without it, nobody can say what the
// subject was actually told.
func TestGrantRequiresANoticeVersion(t *testing.T) {
	if _, err := domain.NewPurposeGrant("g-1", "tenant-a", "patient-1", "desk-1",
		marketingPurpose(t), 0, true, at); err == nil {
		t.Fatal("a grant with no notice version was accepted")
	}
}

func TestSubjectRequestStartsReceivedWithADueDate(t *testing.T) {
	r, err := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestAccess, at, 0)
	if err != nil {
		t.Fatalf("NewSubjectRequest: %v", err)
	}
	if r.Status != domain.RequestReceived {
		t.Fatalf("Status = %q", r.Status)
	}
	if !r.DueAt.After(r.ReceivedAt) {
		t.Fatal("no response window was set")
	}
}

func TestUnknownRequestTypeRejected(t *testing.T) {
	if _, err := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1",
		domain.SubjectRequestType("telepathy"), at, 0); !errors.Is(err, domain.ErrInvalidSubjectRequest) {
		t.Fatalf("unknown request type accepted: %v", err)
	}
}

// An erasure refused because a clinical retention obligation applies is
// defensible; an unexplained refusal is not.
func TestRefusalRequiresAStatedBasis(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestErasure, at, 0)

	if err := r.Decide(domain.RequestRefused, "privacy-officer", "Refused", "", "", at); err == nil {
		t.Fatal("an unexplained refusal was accepted")
	}

	if err := r.Decide(domain.RequestRefused, "privacy-officer", "Refused",
		"Clinical record retention obligation under national law", "doc-1", at); err != nil {
		t.Fatalf("explained refusal rejected: %v", err)
	}
	if r.ClosedAt.IsZero() {
		t.Fatal("a refused request was not closed")
	}
}

func TestPartialFulfilmentRequiresABasis(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestErasure, at, 0)

	if err := r.Decide(domain.RequestPartiallyFulfilled, "officer", "Partly done", "", "ev-1", at); err == nil {
		t.Fatal("an unexplained partial fulfilment was accepted")
	}
}

// "We did it" without a reference is not evidence.
// SRS-SEC-010's verification clause, second half: a data-subject request
// carries a status, a reviewer, a decision and evidence. A fulfilment with no
// evidence is a claim that something was done.
func TestFulfilmentRequiresEvidence(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestAccess, at, 0)

	if err := r.Decide(domain.RequestFulfilled, "officer", "Provided", "", "", at); err == nil {
		t.Fatal("fulfilment without evidence was accepted")
	}
	if err := r.Decide(domain.RequestFulfilled, "officer", "Provided", "", "export:exp-1", at); err != nil {
		t.Fatalf("fulfilment with evidence rejected: %v", err)
	}
}

func TestClosedRequestCannotBeRedecided(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestAccess, at, 0)
	if err := r.Decide(domain.RequestFulfilled, "officer", "Provided", "", "ev-1", at); err != nil {
		t.Fatalf("Decide: %v", err)
	}

	if err := r.Decide(domain.RequestRefused, "other-officer", "Actually no", "changed mind", "", at); err == nil {
		t.Fatal("a fulfilled request was re-decided")
	}
	if r.Reviewer != "officer" {
		t.Fatalf("Reviewer was overwritten to %q", r.Reviewer)
	}
}

func TestIntermediateStatesNeedNoDecision(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestAccess, at, 0)

	if err := r.Decide(domain.RequestVerifying, "officer", "", "", "", at); err != nil {
		t.Fatalf("moving to verifying: %v", err)
	}
	if !r.ClosedAt.IsZero() {
		t.Fatal("an intermediate state closed the request")
	}
}

func TestOverdueDetection(t *testing.T) {
	r, _ := domain.NewSubjectRequest("r-1", "tenant-a", "patient-1", domain.RequestAccess, at, 24*time.Hour)

	if r.IsOverdue(at.Add(time.Hour)) {
		t.Fatal("reported overdue inside the window")
	}
	if !r.IsOverdue(at.Add(48 * time.Hour)) {
		t.Fatal("not reported overdue past the window")
	}

	// A closed request is never overdue, however late it was answered.
	if err := r.Decide(domain.RequestFulfilled, "officer", "Provided", "", "ev-1", at.Add(48*time.Hour)); err != nil {
		t.Fatalf("Decide: %v", err)
	}
	if r.IsOverdue(at.Add(72 * time.Hour)) {
		t.Fatal("a closed request reported overdue")
	}
}
