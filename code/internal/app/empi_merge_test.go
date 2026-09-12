package app_test

import (
	"context"
	"strings"
	"testing"

	"connectrpc.com/connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
)

// Merge, unmerge and duplicate review end to end (SRS-EMPI-004/005/006).
//
// A merge that should not have happened produces a chart that reads as
// coherent: two people's allergies, medications and diagnoses sit together and
// nothing about the record looks broken. It is found by a reaction rather than
// by a report. Everything below is shaped by that.

func (h *empiHarness) mrnOf(t *testing.T, patient *empiv1.Patient) string {
	t.Helper()
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN && i.GetPrimary() {
			return i.GetValue()
		}
	}
	t.Fatalf("patient %s has no primary MRN", patient.GetPatientId())
	return ""
}

// registerPair creates two records for the same person, the second by
// acknowledging the duplicate — which is exactly how a real duplicate arises.
func (h *empiHarness) registerPair(t *testing.T) (*empiv1.Patient, *empiv1.Patient) {
	t.Helper()
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	first := h.mustRegister(t, h.clerkToken(), d)
	second := h.mustRegister(t, h.clerkToken(), d, first.GetPatientId())
	return first, second
}

func (h *empiHarness) merge(t *testing.T, survivor, merged *empiv1.Patient, reason string) (
	*empiv1.MergePatientsResponse, error) {

	t.Helper()
	resp, err := h.patients.MergePatients(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.MergePatientsRequest{
			SurvivorPatientId: survivor.GetPatientId(),
			MergedPatientId:   merged.GetPatientId(),
			Reason:            reason,
		}))
	if err != nil {
		return nil, err
	}
	return resp.Msg, nil
}

// SRS-EMPI-005: all child references resolve to the survivor, and the merge
// provenance is preserved.
func TestMergingResolvesTheOldMRNToTheSurvivor(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	survivingMRN := h.mrnOf(t, first)
	losingMRN := h.mrnOf(t, second)

	result, err := h.merge(t, first, second, "same person registered twice on the same day")
	if err != nil {
		t.Fatalf("MergePatients: %v", err)
	}
	if result.GetMergeId() == "" {
		t.Fatal("no merge journal entry was named, so the merge cannot be reversed")
	}

	// The survivor keeps its own MRN as the one on the wristband.
	if got := h.mrnOf(t, result.GetSurvivor()); got != survivingMRN {
		t.Fatalf("the survivor's primary MRN changed to %q", got)
	}

	// A clerk typing the losing record's MRN off a discharge summary reaches
	// the survivor. That is most of what "child references resolve to
	// survivor" means at a registration desk.
	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			IdentifierValue: losingMRN,
			IdentifierType:  empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
		}))
	if err != nil {
		t.Fatalf("SearchPatients by the old MRN: %v", err)
	}
	if len(found.Msg.GetMatches()) != 1 {
		t.Fatalf("the old MRN found %d patients, want 1", len(found.Msg.GetMatches()))
	}
	if got := found.Msg.GetMatches()[0].GetPatient().GetPatientId(); got != first.GetPatientId() {
		t.Fatalf("the old MRN resolved to %s, want the survivor %s", got, first.GetPatientId())
	}
}

// The losing record is never deleted: every note written against it still
// references it, and resolution is what makes those readable.
func TestTheMergedRecordResolvesToItsSurvivor(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	if _, err := h.merge(t, first, second, "duplicate"); err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	// Asked for directly, the record is still there and says what happened.
	direct, err := h.patients.GetPatient(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: second.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient on the merged record: %v", err)
	}
	if direct.Msg.GetPatient().GetStatus() != empiv1.PatientStatus_PATIENT_STATUS_MERGED {
		t.Fatalf("status = %v, want merged", direct.Msg.GetPatient().GetStatus())
	}
	if direct.Msg.GetPatient().GetMergedIntoPatientId() != first.GetPatientId() {
		t.Fatal("the merged record does not name its survivor")
	}

	// Asked to resolve, it follows the pointer and says where it came from.
	resolved, err := h.patients.GetPatient(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: second.GetPatientId(), ResolveMerged: true,
		}))
	if err != nil {
		t.Fatalf("GetPatient resolving: %v", err)
	}
	if got := resolved.Msg.GetPatient().GetPatientId(); got != first.GetPatientId() {
		t.Fatalf("resolution returned %s, want the survivor %s", got, first.GetPatientId())
	}
	if resolved.Msg.GetResolvedFromPatientId() != second.GetPatientId() {
		t.Fatal("the response does not say which record was asked for")
	}
}

// The refusal that matters most: a human has clicked merge on two records
// holding different national health identifiers, and has misread something.
func TestMergeIsRefusedWhenNationalIdentifiersDisagree(t *testing.T) {
	h := newEmpiHarness(t)
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	withABHA := func(value string) *empiv1.RegisterPatientRequest {
		return &empiv1.RegisterPatientRequest{
			Demographics: d,
			Identifiers: []*empiv1.PatientIdentifier{{
				Type:   empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
				System: "abdm", Value: value, Source: "registration",
			}},
		}
	}

	firstResp, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, withABHA("11-1111-1111-1111")))
	if err != nil {
		t.Fatalf("first registration: %v", err)
	}
	first := firstResp.Msg.GetPatient()

	secondReq := withABHA("22-2222-2222-2222")
	secondReq.AcknowledgedDuplicatePatientIds = []string{first.GetPatientId()}
	secondResp, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, secondReq))
	if err != nil {
		t.Fatalf("second registration: %v", err)
	}
	second := secondResp.Msg.GetPatient()

	_, err = h.merge(t, first, second, "look like the same person")
	if err == nil {
		t.Fatal("two records with different ABHA numbers were merged")
	}
	if got := connectCode(err); got != connect.CodeFailedPrecondition {
		t.Fatalf("code = %v, want FailedPrecondition", got)
	}
	if !strings.Contains(err.Error(), "different people") {
		t.Fatalf("the refusal does not say why: %v", err)
	}

	// And nothing changed.
	after, err := h.patients.GetPatient(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: second.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	if after.Msg.GetPatient().GetStatus() == empiv1.PatientStatus_PATIENT_STATUS_MERGED {
		t.Fatal("the refused merge was applied anyway")
	}
}

// Merging fuses two people's records. The clerk who created the duplicate at a
// busy desk is the last person who should resolve it unreviewed.
func TestAClerkCannotMerge(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	_, err := h.patients.MergePatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.MergePatientsRequest{
			SurvivorPatientId: first.GetPatientId(),
			MergedPatientId:   second.GetPatientId(),
			Reason:            "duplicate",
		}))
	if err == nil {
		t.Fatal("a registration clerk merged two patients")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want PermissionDenied", got)
	}
}

// A merge with no reason cannot be reviewed afterwards, and that review is the
// only thing between a mistake and two people's records.
func TestAMergeWithoutAReasonIsRefused(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	if _, err := h.merge(t, first, second, "   "); err == nil {
		t.Fatal("a merge with no reason was accepted")
	}
}

// SRS-EMPI-006: an unmerge restores ownership from the merge journal.
func TestUnmergingRestoresBothRecords(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	losingMRN := h.mrnOf(t, second)

	merged, err := h.merge(t, first, second, "duplicate")
	if err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	restored, err := h.patients.UnmergePatients(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnmergePatientsRequest{
			MergeId: merged.GetMergeId(), Reason: "merged in error, different people",
		}))
	if err != nil {
		t.Fatalf("UnmergePatients: %v", err)
	}

	// Back to candidate, which is what it was before the merge — not active,
	// which would silently confirm an identity nobody verified.
	if got := restored.Msg.GetRestored().GetStatus(); got != empiv1.PatientStatus_PATIENT_STATUS_CANDIDATE {
		t.Fatalf("the restored record is %v, want candidate", got)
	}
	if restored.Msg.GetRestored().GetMergedIntoPatientId() != "" {
		t.Fatal("the restored record still points at a survivor")
	}

	// Its MRN came back with it, and resolves to it again rather than to the
	// record it was briefly merged into.
	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			IdentifierValue: losingMRN,
			IdentifierType:  empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}
	if len(found.Msg.GetMatches()) != 1 {
		t.Fatalf("the restored MRN found %d patients, want 1", len(found.Msg.GetMatches()))
	}
	if got := found.Msg.GetMatches()[0].GetPatient().GetPatientId(); got != second.GetPatientId() {
		t.Fatalf("the restored MRN resolves to %s, want %s", got, second.GetPatientId())
	}
}

// A merge can be reversed once. Reversing it twice would restore identifiers
// that are already where they belong, and the second journal entry would
// describe a state that no longer exists.
func TestAMergeCannotBeReversedTwice(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	merged, err := h.merge(t, first, second, "duplicate")
	if err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	unmerge := func() error {
		_, err := h.patients.UnmergePatients(context.Background(),
			withFacility(h.himToken(), h.facility, &empiv1.UnmergePatientsRequest{
				MergeId: merged.GetMergeId(), Reason: "merged in error",
			}))
		return err
	}

	if err := unmerge(); err != nil {
		t.Fatalf("first unmerge: %v", err)
	}
	if err := unmerge(); err == nil {
		t.Fatal("the same merge was reversed twice")
	}
}

// Reversing an earlier merge while a later one stands would restore
// identifiers the later merge has already moved again.
func TestUnmergeIsBlockedByALaterMergeIntoTheSameSurvivor(t *testing.T) {
	h := newEmpiHarness(t)
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	first := h.mustRegister(t, h.clerkToken(), d)
	second := h.mustRegister(t, h.clerkToken(), d, first.GetPatientId())
	third := h.mustRegister(t, h.clerkToken(), d, first.GetPatientId(), second.GetPatientId())

	firstMerge, err := h.merge(t, first, second, "duplicate")
	if err != nil {
		t.Fatalf("first merge: %v", err)
	}
	// A second registration of the same person, merged into the same survivor
	// afterwards.
	if _, err := h.merge(t, first, third, "another duplicate"); err != nil {
		t.Fatalf("second merge: %v", err)
	}

	_, err = h.patients.UnmergePatients(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnmergePatientsRequest{
			MergeId: firstMerge.GetMergeId(), Reason: "actually different people",
		}))
	if err == nil {
		t.Fatal("an earlier merge was reversed while a later one stood")
	}
	if got := connectCode(err); got != connect.CodeFailedPrecondition {
		t.Fatalf("code = %v, want FailedPrecondition", got)
	}
	// SRS-EMPI-006 requires the block to carry an explicit reason: an operator
	// told only "no" will go to the database.
	if !strings.Contains(err.Error(), "later merge") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// SRS-EMPI-004: the pair a clerk waved through still reaches the people whose
// job it is to decide.
func TestAnAcknowledgedDuplicateReachesTheReviewQueue(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	queue, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}

	var found *empiv1.DuplicateCandidate
	for _, c := range queue.Msg.GetCandidates() {
		pair := map[string]bool{c.GetPatientAId(): true, c.GetPatientBId(): true}
		if pair[first.GetPatientId()] && pair[second.GetPatientId()] {
			found = c
		}
	}
	if found == nil {
		t.Fatalf("the acknowledged duplicate is not in the review queue: %+v", queue.Msg.GetCandidates())
	}
	if found.GetStatus() != empiv1.ReviewStatus_REVIEW_STATUS_OPEN {
		t.Fatalf("status = %v, want open", found.GetStatus())
	}
	if found.GetScore() <= 0 {
		t.Fatal("the queued candidate carries no score")
	}
	if found.GetDetectedBy() != "registration" {
		t.Fatalf("detected_by = %q", found.GetDetectedBy())
	}
}

// A clerk must not see the review queue: it is a list of pairs somebody has to
// decide about, and the decision is not theirs.
func TestAClerkCannotSeeTheReviewQueue(t *testing.T) {
	h := newEmpiHarness(t)
	h.registerPair(t)

	_, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err == nil {
		t.Fatal("a registration clerk read the duplicate review queue")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want PermissionDenied", got)
	}
}

// Dismissing records a decision. The pair does not come back: a decision
// already taken is not a new question, and re-queueing it would put the same
// two records in front of HIM every time either is touched.
func TestDismissingACandidateClosesItForGood(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	queue, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}
	if len(queue.Msg.GetCandidates()) == 0 {
		t.Fatal("nothing queued")
	}
	candidateID := queue.Msg.GetCandidates()[0].GetCandidateId()

	if _, err := h.patients.DismissDuplicateCandidate(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.DismissDuplicateCandidateRequest{
			CandidateId: candidateID, Reason: "twin sisters, confirmed with the family",
		})); err != nil {
		t.Fatalf("DismissDuplicateCandidate: %v", err)
	}

	after, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}
	for _, c := range after.Msg.GetCandidates() {
		if c.GetCandidateId() == candidateID {
			t.Fatal("the dismissed candidate is still on the worklist")
		}
	}

	// Registering the same person a third time re-detects the pair and must
	// not reopen the closed one.
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")
	h.mustRegister(t, h.clerkToken(), d, first.GetPatientId(), second.GetPatientId())

	reopened, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}
	for _, c := range reopened.Msg.GetCandidates() {
		if c.GetCandidateId() == candidateID {
			t.Fatal("a dismissed decision was reopened by re-detection")
		}
	}
}

// A dismissal with no reason is indistinguishable from a mis-click.
func TestDismissingWithoutAReasonIsRefused(t *testing.T) {
	h := newEmpiHarness(t)
	h.registerPair(t)

	queue, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}

	_, err = h.patients.DismissDuplicateCandidate(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.DismissDuplicateCandidateRequest{
			CandidateId: queue.Msg.GetCandidates()[0].GetCandidateId(), Reason: "",
		}))
	if err == nil {
		t.Fatal("a candidate was dismissed with no reason")
	}
}

// Merging through the queue closes the entry, so the same pair does not sit
// there after it has been resolved.
func TestMergingThroughTheQueueClosesTheCandidate(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	queue, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}
	candidateID := queue.Msg.GetCandidates()[0].GetCandidateId()

	if _, err := h.patients.MergePatients(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.MergePatientsRequest{
			SurvivorPatientId: first.GetPatientId(),
			MergedPatientId:   second.GetPatientId(),
			Reason:            "same person",
			CandidateId:       candidateID,
		})); err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	after, err := h.patients.ListDuplicateCandidates(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDuplicateCandidatesRequest{}))
	if err != nil {
		t.Fatalf("ListDuplicateCandidates: %v", err)
	}
	for _, c := range after.Msg.GetCandidates() {
		if c.GetCandidateId() == candidateID {
			t.Fatal("the merged candidate is still on the worklist")
		}
	}
}

// A merge emits the event downstream projections need to know which record to
// keep (SRS-EMPI-018).
func TestMergingEmitsAnEvent(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	result, err := h.merge(t, first, second, "duplicate")
	if err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE event_type = 'patient.merged' AND aggregate_id = $1`,
		first.GetPatientId()).Scan(&payload); err != nil {
		t.Fatalf("no patient.merged event: %v", err)
	}

	for _, want := range []string{first.GetPatientId(), second.GetPatientId(), result.GetMergeId()} {
		if !strings.Contains(payload, want) {
			t.Fatalf("the event does not name %s: %s", want, payload)
		}
	}
	// Identifiers, not demographics: an event stream is read by more systems
	// than a record is.
	if strings.Contains(payload, "Iyer") {
		t.Fatalf("the merge event carries demographics: %s", payload)
	}
}

// The journal is the provenance SRS-EMPI-005 requires preserved.
func TestTheMergeJournalRecordsWhatMoved(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	result, err := h.merge(t, first, second, "same person, two registrations")
	if err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	var performedBy, reason, previousStatus, moved string
	err = h.pool.QueryRow(context.Background(),
		`SELECT performed_by, reason, merged_previous_status, moved_identifiers::text
		 FROM empi.merge_journal WHERE merge_id = $1`,
		result.GetMergeId()).Scan(&performedBy, &reason, &previousStatus, &moved)
	if err != nil {
		t.Fatalf("no journal entry: %v", err)
	}

	if performedBy != "him-1" {
		t.Fatalf("performed_by = %q", performedBy)
	}
	if reason != "same person, two registrations" {
		t.Fatalf("reason = %q", reason)
	}
	// What the losing record was before it lost, so an unmerge restores the
	// right state rather than guessing at "active".
	if previousStatus != "candidate" {
		t.Fatalf("merged_previous_status = %q, want candidate", previousStatus)
	}
	if !strings.Contains(moved, "PreviousStatus") && !strings.Contains(moved, "previous_status") {
		t.Fatalf("the journal does not record what each identifier was before: %s", moved)
	}
}

// Merging is audited with the reason, because that is what a review reads.
func TestMergingIsAuditedWithItsReason(t *testing.T) {
	h := newEmpiHarness(t)
	first, second := h.registerPair(t)

	if _, err := h.merge(t, first, second, "same person, two registrations"); err != nil {
		t.Fatalf("MergePatients: %v", err)
	}

	var actor, reason string
	err := h.pool.QueryRow(context.Background(),
		`SELECT actor_id, reason FROM platform_data.audit_record
		 WHERE action = 'empi.patient.merge' AND resource_id = $1 AND outcome = 'success'`,
		first.GetPatientId()).Scan(&actor, &reason)
	if err != nil {
		t.Fatalf("the merge was not audited: %v", err)
	}
	if actor != "him-1" || reason != "same person, two registrations" {
		t.Fatalf("audit records actor %q reason %q", actor, reason)
	}
}
