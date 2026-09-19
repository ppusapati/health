package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/quality/domain"
)

var at = time.Date(2026, 6, 1, 9, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, what string) {
	t.Helper()
	if err == nil {
		t.Fatalf("%s was accepted", what)
	}
	if !errors.Is(err, domain.ErrInvalidQuality) {
		t.Fatalf("%s failed with %v, want an invalid-quality refusal", what, err)
	}
}

func incidentInput() domain.NewIncidentInput {
	return domain.NewIncidentInput{
		Reference: "INC-1", Category: "medication",
		Reach: domain.ReachNearMiss, Harm: domain.HarmNone,
		Consequence: domain.ConsequenceModerate,
		Likelihood:  domain.LikelihoodPossible,
		Narrative:   "wrong dose drawn up, caught at the second check",
		OccurredAt:  at.Add(-time.Hour),
	}
}

// SRS-QMS-001. A near miss that reached the patient is not a near miss, and
// the three-state reach exists so that the contradiction cannot be recorded.
func TestANearMissThatReachedThePatientIsRefused(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachNearMiss
	in.Harm = domain.HarmModerate

	_, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	refused(t, err, "a near miss with recorded harm")
	if !strings.Contains(err.Error(), "never reached a patient") {
		t.Fatalf("refusal does not say what is wrong: %v", err)
	}
}

// SRS-QMS-001. The other direction: an event classed as harm that records no
// harm level is a report that says nothing.
func TestHarmWithNoHarmLevelIsRefused(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachHarm
	in.Harm = domain.HarmNone
	in.ImmediateAction = "reviewed by the registrar"

	_, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	refused(t, err, "an event classed as harm recording no harm")
}

// SRS-QMS-001. Something happened to somebody and nothing was done at the
// time: either the report is incomplete or the response failed, and a blank
// field hides which.
func TestAnEventThatReachedThePatientNeedsItsImmediateAction(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachNoHarm

	_, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	refused(t, err, "an event that reached a patient with no immediate action")

	in.ImmediateAction = "observed for an hour, no effect"
	if _, err := domain.ReportIncident("i1", "t", in, "nurse-1", at); err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
}

// SRS-QMS-005. A death is a sentinel event whatever the reporter ticked.
// Left to the reporter, the one incident that most needs an executive review
// is the one nobody wants to escalate.
func TestADeathIsASentinelEventWhateverWasTicked(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachHarm
	in.Harm = domain.HarmDeath
	in.ImmediateAction = "resuscitation attempted"
	in.Sentinel = false

	incident, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if !incident.Sentinel {
		t.Fatal("a death was recorded as a routine incident")
	}
	// And a sentinel event is restricted, because its review is peer-review
	// material and the people in it are identifiable.
	if !incident.Restricted {
		t.Fatal("a sentinel event is not restricted")
	}
}

// SRS-QMS-002. The score is derived from consequence and likelihood. A score
// a reporter can set is a score a reporter can set low.
func TestTheRiskScoreIsDerivedAndTheBandEscalates(t *testing.T) {
	for _, tc := range []struct {
		consequence domain.Consequence
		likelihood  domain.Likelihood
		score       int
		band        domain.RiskBand
		escalates   bool
	}{
		{domain.ConsequenceNegligible, domain.LikelihoodRare, 1, domain.RiskLow, false},
		{domain.ConsequenceModerate, domain.LikelihoodPossible, 9, domain.RiskModerate, false},
		{domain.ConsequenceMajor, domain.LikelihoodPossible, 12, domain.RiskHigh, true},
		{domain.ConsequenceCatastrophic, domain.LikelihoodLikely, 20, domain.RiskExtreme, true},
	} {
		risk, err := domain.Score(tc.consequence, tc.likelihood)
		if err != nil {
			t.Fatalf("Score(%s, %s): %v", tc.consequence, tc.likelihood, err)
		}
		if risk.Score != tc.score || risk.Band != tc.band {
			t.Fatalf("Score(%s, %s) = %d/%s, want %d/%s",
				tc.consequence, tc.likelihood, risk.Score, risk.Band,
				tc.score, tc.band)
		}
		if risk.Band.Escalates() != tc.escalates {
			t.Fatalf("%s escalates = %v, want %v",
				risk.Band, risk.Band.Escalates(), tc.escalates)
		}
	}
}

// SRS-QMS-001, SRS-QMS-012. A ward may need to know an incident happened in
// it without reading the peer-review analysis of it.
func TestARestrictedIncidentRedactsToWhatAWardMayKnow(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachHarm
	in.Harm = domain.HarmSevere
	in.ImmediateAction = "returned to theatre"
	in.PatientID = "pat-1"
	in.Department = "orthopaedics"
	in.Consequence = domain.ConsequenceMajor
	in.Likelihood = domain.LikelihoodUnlikely

	incident, err := domain.ReportIncident("i1", "t", in, "surgeon-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if err := incident.Restrict("serious incident review"); err != nil {
		t.Fatalf("Restrict: %v", err)
	}

	redacted := incident.Redacted()
	if redacted.Narrative != "" || redacted.PatientID != "" ||
		redacted.ImmediateAction != "" || redacted.ReportedBy != "" {
		t.Fatalf("redaction left content behind: %+v", redacted)
	}
	// What the ward keeps: that something of this kind happened here.
	if redacted.Category != "medication" || redacted.Department != "orthopaedics" ||
		redacted.OccurredAt != incident.OccurredAt {
		t.Fatalf("redaction removed what the ward needs: %+v", redacted)
	}
	// The band, not the score: the components would let a reader reconstruct
	// the consequence, which for a restricted case is most of the story.
	if redacted.Risk.Band != incident.Risk.Band {
		t.Fatalf("band = %q, want it kept", redacted.Risk.Band)
	}
	if redacted.Risk.Score != 0 || redacted.Risk.Consequence != "" {
		t.Fatalf("redaction kept the score components: %+v", redacted.Risk)
	}

	// An unrestricted incident is returned whole.
	in.Reach, in.Harm, in.ImmediateAction = domain.ReachNearMiss, domain.HarmNone, ""
	open, err := domain.ReportIncident("i2", "t", in, "surgeon-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if open.Redacted().Narrative == "" {
		t.Fatal("an unrestricted incident was redacted")
	}
}

// SRS-QMS-005. A restriction that can be lifted by whoever finds it
// inconvenient is not a restriction.
func TestASentinelEventStaysRestricted(t *testing.T) {
	in := incidentInput()
	in.Reach = domain.ReachHarm
	in.Harm = domain.HarmDeath
	in.ImmediateAction = "resuscitation attempted"

	incident, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	refused(t, incident.Unrestrict(), "unrestricting a sentinel event")

	// An ordinary restricted incident can be opened up again.
	in.Reach, in.Harm, in.ImmediateAction = domain.ReachNearMiss, domain.HarmNone, ""
	ordinary, err := domain.ReportIncident("i2", "t", in, "nurse-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if err := ordinary.Restrict("under review"); err != nil {
		t.Fatalf("Restrict: %v", err)
	}
	if err := ordinary.Unrestrict(); err != nil {
		t.Fatalf("Unrestrict: %v", err)
	}
}

// SRS-QMS-002. A category whose count is rising because people have started
// reporting near misses is a category that is getting safer, and a single
// total says the opposite.
func TestTrendsCountNearMissesSeparatelyAndCarryTheWorstOutcome(t *testing.T) {
	report := func(id, category string, reach domain.Reach, harm domain.Harm) domain.Incident {
		in := incidentInput()
		in.Category, in.Reach, in.Harm = category, reach, harm
		if reach.ReachedThePatient() {
			in.ImmediateAction = "reviewed"
		}
		incident, err := domain.ReportIncident(id, "t", in, "nurse-1", at)
		if err != nil {
			t.Fatalf("ReportIncident(%s): %v", id, err)
		}
		return incident
	}

	trends := domain.Trends([]domain.Incident{
		report("a", "falls", domain.ReachNearMiss, domain.HarmNone),
		report("b", "falls", domain.ReachNearMiss, domain.HarmNone),
		report("c", "falls", domain.ReachHarm, domain.HarmMild),
		report("d", "medication", domain.ReachHarm, domain.HarmSevere),
	})

	if len(trends) != 2 {
		t.Fatalf("trends = %v, want two categories", trends)
	}
	// Worst outcome first: one severe beats three falls.
	if trends[0].Category != "medication" {
		t.Fatalf("first trend = %q, want the category with the worst outcome",
			trends[0].Category)
	}

	var falls domain.Trend
	for _, trend := range trends {
		if trend.Category == "falls" {
			falls = trend
		}
	}
	if falls.Count != 3 || falls.NearMisses != 2 || falls.Harmful != 1 {
		t.Fatalf("falls = %+v, want 3 total, 2 near misses, 1 harmful", falls)
	}
	if falls.WorstHarm != domain.HarmMild {
		t.Fatalf("falls worst harm = %q, want mild", falls.WorstHarm)
	}
}

// SRS-QMS-001. A reporting system in which staff are identified is a
// reporting system staff stop using, and the trail still knows.
func TestAnAnonymousReportHidesTheReporterAndNotTheTrail(t *testing.T) {
	in := incidentInput()
	in.Anonymous = true

	incident, err := domain.ReportIncident("i1", "t", in, "nurse-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if incident.Reporter() != "" {
		t.Fatalf("Reporter() = %q, want it hidden", incident.Reporter())
	}
	if incident.ReportedBy != "nurse-1" {
		t.Fatalf("ReportedBy = %q, want the record to still know",
			incident.ReportedBy)
	}
}

func openRCA(t *testing.T) domain.RCA {
	t.Helper()
	rca, err := domain.StartRCA("r1", "t", "i1", "london_protocol", false,
		"quality-1", at)
	if err != nil {
		t.Fatalf("StartRCA: %v", err)
	}
	if err := rca.AddFactor(domain.ContributingFactor{
		Category: domain.FactorOrganisational,
		Detail:   "two nurses covering four bays overnight", Root: true,
	}); err != nil {
		t.Fatalf("AddFactor: %v", err)
	}
	return rca
}

// SRS-QMS-003. An analysis owned by "the committee" is owned by nobody.
func TestAnAnalysisCannotCloseWithoutAnAccountableOwner(t *testing.T) {
	rca := openRCA(t)
	refused(t, rca.CompleteRCA("", "staffing was the cause", 1, "quality-1", at),
		"an analysis closing with no accountable owner")

	if err := rca.CompleteRCA("matron-1", "staffing was the cause", 1,
		"quality-1", at); err != nil {
		t.Fatalf("CompleteRCA: %v", err)
	}
	if len(rca.RootCauses()) != 1 {
		t.Fatalf("root causes = %v, want the one marked", rca.RootCauses())
	}
}

// SRS-QMS-003. "We investigated and changed nothing" is a defensible
// conclusion, and an undefended one is how root cause analysis becomes
// paperwork.
func TestAnAnalysisThatRaisedNothingMustSayWhy(t *testing.T) {
	rca := openRCA(t)
	refused(t, rca.CompleteRCA("matron-1", "staffing was the cause", 0,
		"quality-1", at),
		"an analysis closing with no action and no explanation")

	rca.NoActionReason = "the ward establishment was already under review"
	if err := rca.CompleteRCA("matron-1", "staffing was the cause", 0,
		"quality-1", at); err != nil {
		t.Fatalf("CompleteRCA: %v", err)
	}
}

// SRS-QMS-003. An analysis that recorded no contributing factors recorded
// nothing.
func TestAnAnalysisWithNoFactorsCannotClose(t *testing.T) {
	rca, err := domain.StartRCA("r1", "t", "i1", "five_whys", false,
		"quality-1", at)
	if err != nil {
		t.Fatalf("StartRCA: %v", err)
	}
	refused(t, rca.CompleteRCA("matron-1", "nothing found", 1, "quality-1", at),
		"an analysis closing with no contributing factors")
}

func capaInput() domain.NewCAPAInput {
	return domain.NewCAPAInput{
		Reference: "CAPA-1", Kind: domain.ActionPreventive,
		SourceKind: domain.SourceRCA, SourceID: "r1",
		Action:             "second nurse rostered overnight",
		OwnerID:            "matron-1",
		DueOn:              at.AddDate(0, 1, 0),
		EffectivenessDueOn: at.AddDate(0, 3, 0),
	}
}

// SRS-QMS-004. An action somebody raised, approved, did and closed is one
// person's account of their own work.
func TestAnActionCannotBeApprovedByWhoeverRaisedIt(t *testing.T) {
	capa, err := domain.RaiseCAPA("c1", "t", capaInput(), "quality-1", at)
	if err != nil {
		t.Fatalf("RaiseCAPA: %v", err)
	}
	refused(t, capa.ApproveCAPA("quality-1", at),
		"an action approved by the person who raised it")

	if err := capa.ApproveCAPA("director-1", at); err != nil {
		t.Fatalf("ApproveCAPA: %v", err)
	}
}

// SRS-QMS-004. The check everybody skips. A corrective action that was done
// and never verified to work is an action that will come back.
//
// The message is asserted, not just the refusal. "This has not been checked"
// and "the check found it did not work" send somebody to do two different
// things, and a single refusal that covers both would tell the second person
// to go and run a check that has already been run.
func TestAnActionCannotCloseWithoutAnEffectivenessCheck(t *testing.T) {
	capa := approvedCAPA(t)

	err := capa.CloseCAPA("director-1", "done", at.AddDate(0, 2, 0))
	refused(t, err, "an action closing with no effectiveness check")
	if !strings.Contains(err.Error(), "has not been checked") {
		t.Fatalf("refusal = %v, want it to say the check has not been done", err)
	}

	later := at.AddDate(0, 4, 0)
	if err := capa.RecordCheck(domain.EffectivenessCheck{
		CheckedBy: "quality-1", Effective: false,
		Evidence: "re-audit found the same gap",
	}, later); err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	err = capa.CloseCAPA("director-1", "done", later)
	refused(t, err, "an action closing on a check that failed")
	if !strings.Contains(err.Error(), "did not work") {
		t.Fatalf("refusal = %v, want it to say the check failed", err)
	}
}

// SRS-QMS-004. "We checked and it did not work" has to be recordable and has
// to not close the action.
func TestAFailedEffectivenessCheckSendsTheActionBackToWork(t *testing.T) {
	capa := approvedCAPA(t)

	later := at.AddDate(0, 4, 0)
	if err := capa.RecordCheck(domain.EffectivenessCheck{
		CheckedBy: "quality-1", Effective: false,
		Evidence: "re-audit found the same gap on four of ten nights",
	}, later); err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	if capa.State != domain.CAPAInProgress {
		t.Fatalf("state = %q, want the action back in progress", capa.State)
	}
	refused(t, capa.CloseCAPA("director-1", "done", later),
		"an action closing on a check that failed")

	// And the failed check is kept, because "fixed, checked, had not worked,
	// fixed again" is the history that tells a hospital something.
	if err := capa.RecordCheck(domain.EffectivenessCheck{
		CheckedBy: "quality-1", Effective: true,
		Evidence: "re-audit found no gaps over twenty nights",
	}, later); err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	if len(capa.Checks) != 2 {
		t.Fatalf("checks = %d, want the failed one kept", len(capa.Checks))
	}
	if err := capa.CloseCAPA("director-1", "verified", later); err != nil {
		t.Fatalf("CloseCAPA: %v", err)
	}
}

// SRS-QMS-004. The owner did the work; somebody else says it is done.
func TestTheOwnerOfAnActionCannotApproveItsClosure(t *testing.T) {
	capa := approvedCAPA(t)
	later := at.AddDate(0, 4, 0)
	if err := capa.RecordCheck(domain.EffectivenessCheck{
		CheckedBy: "quality-1", Effective: true, Evidence: "re-audit clean",
	}, later); err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	refused(t, capa.CloseCAPA("matron-1", "done", later),
		"an action closed by its own owner")
}

func approvedCAPA(t *testing.T) domain.CAPA {
	t.Helper()
	capa, err := domain.RaiseCAPA("c1", "t", capaInput(), "quality-1", at)
	if err != nil {
		t.Fatalf("RaiseCAPA: %v", err)
	}
	if err := capa.ApproveCAPA("director-1", at); err != nil {
		t.Fatalf("ApproveCAPA: %v", err)
	}
	if err := capa.AdvanceCAPA(domain.CAPAInProgress, "", at); err != nil {
		t.Fatalf("AdvanceCAPA: %v", err)
	}
	return capa
}

// SRS-QMS-004. An action that was done on time and never checked is a
// different failure from one that was never done.
func TestOverdueSeparatesTheActionFromItsCheck(t *testing.T) {
	late := approvedCAPA(t)
	late.Reference = "CAPA-late"

	// Two months on: the action is overdue, the check is not yet due.
	overdue := domain.OverdueActions([]domain.CAPA{late}, at.AddDate(0, 2, 0))
	if len(overdue) != 1 {
		t.Fatalf("overdue = %v, want the late action", overdue)
	}
	if overdue[0].ActionOverdueDays <= 0 || overdue[0].CheckOverdueDays != 0 {
		t.Fatalf("overdue = %+v, want only the action late", overdue[0])
	}

	// Done and under review, four months on: the action's own date no longer
	// matters and the check is late.
	done := approvedCAPA(t)
	done.State = domain.CAPAEffectivenessDue
	overdue = domain.OverdueActions([]domain.CAPA{done}, at.AddDate(0, 4, 0))
	if len(overdue) != 1 {
		t.Fatalf("overdue = %v, want the unchecked action", overdue)
	}
	if overdue[0].ActionOverdueDays != 0 || overdue[0].CheckOverdueDays <= 0 {
		t.Fatalf("overdue = %+v, want only the check late", overdue[0])
	}

	// A closed action is nobody's problem.
	closed := approvedCAPA(t)
	closed.State = domain.CAPAClosed
	if got := domain.OverdueActions([]domain.CAPA{closed},
		at.AddDate(0, 6, 0)); len(got) != 0 {
		t.Fatalf("a closed action is reported overdue: %v", got)
	}
}

// SRS-QMS-004. Checking whether a change worked before it was made is a check
// that will pass and mean nothing.
func TestAnEffectivenessCheckCannotFallBeforeTheAction(t *testing.T) {
	in := capaInput()
	in.EffectivenessDueOn = in.DueOn.AddDate(0, 0, -1)
	_, err := domain.RaiseCAPA("c1", "t", in, "quality-1", at)
	refused(t, err, "an effectiveness check due before the action")
}

func document(t *testing.T) domain.ControlledDocument {
	t.Helper()
	doc, err := domain.NewControlledDocument("d1", "t", domain.NewDocumentInput{
		Code: "IPC-01", Title: "Hand hygiene policy",
		Kind: domain.DocumentSOP, OwnerID: "ipc-1", ReviewMonths: 24,
	}, "quality-1", at)
	if err != nil {
		t.Fatalf("NewControlledDocument: %v", err)
	}
	return doc
}

func version(t *testing.T, id string, ordinal int, ack bool) domain.DocumentVersion {
	t.Helper()
	v, err := domain.DraftVersion(id, "t", domain.NewVersionInput{
		DocumentID: "d1", Label: "v" + id, Ordinal: ordinal,
		ContentRef: "blob://" + id, RequiresAcknowledgement: ack,
	}, "author-1", at)
	if err != nil {
		t.Fatalf("DraftVersion(%s): %v", id, err)
	}
	return v
}

// SRS-QMS-006. Only the effective version is the document, and a version
// approved for next month is not it yet.
func TestOnlyTheVersionInForceIsTheDocument(t *testing.T) {
	first := version(t, "v1", 1, false)
	second := version(t, "v2", 2, false)

	if err := first.ApproveVersion("ipc-1", at.AddDate(0, -6, 0), at); err != nil {
		t.Fatalf("ApproveVersion(first): %v", err)
	}
	if err := second.ApproveVersion("ipc-1", at.AddDate(0, 1, 0), at); err != nil {
		t.Fatalf("ApproveVersion(second): %v", err)
	}
	draft := version(t, "v3", 3, false)

	versions := []domain.DocumentVersion{first, second, draft}
	current, found := domain.CurrentVersion(versions, at)
	if !found || current.ID != "v1" {
		t.Fatalf("current = %+v (%v), want the version already in force",
			current, found)
	}

	// Next month the second one takes over, without anybody running a job.
	current, found = domain.CurrentVersion(versions, at.AddDate(0, 2, 0))
	if !found || current.ID != "v2" {
		t.Fatalf("current next month = %+v (%v), want v2", current, found)
	}

	// A document with nothing in force reports nothing rather than a draft:
	// a gap somebody has to see, not a reason to show an unapproved draft.
	if _, found := domain.CurrentVersion([]domain.DocumentVersion{draft},
		at); found {
		t.Fatal("an unapproved draft was shown as the document")
	}

	// And a draft carrying an effective date is still not the document. Only
	// approval sets that date, so this state should not arise — which is
	// exactly why it is worth asserting: the check that catches it is
	// invisible until something else writes the field, and a document control
	// system that shows an unapproved draft as policy has failed at its only
	// job.
	tampered := draft
	tampered.EffectiveFrom = at.AddDate(0, -1, 0)
	if tampered.InForce(at) {
		t.Fatal("a draft with an effective date was treated as in force")
	}
	if _, found := domain.CurrentVersion([]domain.DocumentVersion{tampered},
		at); found {
		t.Fatal("a draft with an effective date was shown as the document")
	}
}

// SRS-QMS-006. A policy approved with nothing attached will be cited in a
// survey as though it were a document.
func TestAVersionIsApprovedBySomebodyElseAndHasContent(t *testing.T) {
	v := version(t, "v1", 1, false)
	refused(t, v.ApproveVersion("author-1", at, at),
		"a version approved by its own author")

	empty := v
	empty.ContentRef = ""
	refused(t, empty.ApproveVersion("ipc-1", at, at),
		"a version approved with no content")

	refused(t, v.ApproveVersion("ipc-1", time.Time{}, at),
		"a version approved with no effective date")
}

// SRS-QMS-006. Acknowledging version 1 says nothing about version 2, and a
// system that carries the old acknowledgement forward reports full compliance
// with a policy nobody has read.
func TestAcknowledgementIsPerVersion(t *testing.T) {
	doc := document(t)
	first := version(t, "v1", 1, true)
	if err := first.ApproveVersion("ipc-1", at.AddDate(0, -6, 0), at); err != nil {
		t.Fatalf("ApproveVersion: %v", err)
	}

	expected := map[string]string{"nurse-1": "nurse", "nurse-2": "nurse"}
	acks := []domain.Acknowledgement{
		{VersionID: "v1", PersonID: "nurse-1", AcknowledgedAt: at},
	}

	gaps := domain.OutstandingAcknowledgements(doc,
		[]domain.DocumentVersion{first}, expected, acks, at)
	if len(gaps) != 1 || gaps[0].PersonID != "nurse-2" {
		t.Fatalf("gaps = %v, want only the nurse who has not read it", gaps)
	}

	// A new version comes into force and both are outstanding again.
	second := version(t, "v2", 2, true)
	if err := second.ApproveVersion("ipc-1", at.AddDate(0, -1, 0), at); err != nil {
		t.Fatalf("ApproveVersion(second): %v", err)
	}
	gaps = domain.OutstandingAcknowledgements(doc,
		[]domain.DocumentVersion{first, second}, expected, acks, at)
	if len(gaps) != 2 {
		t.Fatalf("gaps after a revision = %v, want both nurses", gaps)
	}
}

// SRS-QMS-006. A document nobody set a review period for is named, because
// treating it as never due is the answer that makes the report look clean.
func TestADocumentWithNoReviewIntervalIsNamedRatherThanNeverDue(t *testing.T) {
	doc := document(t)
	doc.ReviewMonths = 0

	v := version(t, "v1", 1, false)
	if err := v.ApproveVersion("ipc-1", at.AddDate(-5, 0, 0), at); err != nil {
		t.Fatalf("ApproveVersion: %v", err)
	}

	due, reported := domain.ReviewsDue(doc, []domain.DocumentVersion{v}, at)
	if !reported || !due.NoReviewInterval {
		t.Fatalf("review = %+v (%v), want it named as having no interval",
			due, reported)
	}

	// With an interval, five years on, it is simply overdue.
	doc.ReviewMonths = 24
	due, reported = domain.ReviewsDue(doc, []domain.DocumentVersion{v}, at)
	if !reported || due.DaysOverdue <= 0 || due.NoReviewInterval {
		t.Fatalf("review = %+v (%v), want an overdue review", due, reported)
	}

	// A document with nothing in force is the worse case and says so.
	draft := version(t, "v9", 9, false)
	due, reported = domain.ReviewsDue(doc, []domain.DocumentVersion{draft}, at)
	if !reported || !due.NoEffectiveVersion {
		t.Fatalf("review = %+v (%v), want no-effective-version", due, reported)
	}
}

// SRS-QMS-007. A finding closed with a note is a finding somebody talked
// their way out of, and the next audit finds it again.
func TestAMajorNonConformityClosesOnlyThroughAClosedAction(t *testing.T) {
	finding, err := domain.RecordFinding("f1", "t", domain.NewFindingInput{
		AuditID: "a1", Severity: domain.FindingMajor,
		Detail:   "no hand hygiene audit run for eight months",
		Evidence: "audit register, last entry October",
	}, "auditor-1", at)
	if err != nil {
		t.Fatalf("RecordFinding: %v", err)
	}

	refused(t, finding.CloseFinding(nil, "discussed with the ward", "quality-1", at),
		"a major non-conformity closed with a note")

	capa := approvedCAPA(t)
	if err := finding.LinkAction(capa.ID); err != nil {
		t.Fatalf("LinkAction: %v", err)
	}
	refused(t, finding.CloseFinding(&capa, "", "quality-1", at),
		"a finding closed on an action that is still open")

	later := at.AddDate(0, 4, 0)
	if err := capa.RecordCheck(domain.EffectivenessCheck{
		CheckedBy: "quality-1", Effective: true, Evidence: "re-audit clean",
	}, later); err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	if err := capa.CloseCAPA("director-1", "verified", later); err != nil {
		t.Fatalf("CloseCAPA: %v", err)
	}
	if err := finding.CloseFinding(&capa, "", "quality-1", later); err != nil {
		t.Fatalf("CloseFinding: %v", err)
	}

	// An observation is advice, and closes with a note.
	observation, err := domain.RecordFinding("f2", "t", domain.NewFindingInput{
		AuditID: "a1", Severity: domain.FindingObservation,
		Detail: "the register would be easier to read by ward",
	}, "auditor-1", at)
	if err != nil {
		t.Fatalf("RecordFinding(observation): %v", err)
	}
	refused(t, observation.CloseFinding(nil, "", "quality-1", at),
		"an observation closed with no note at all")
	if err := observation.CloseFinding(nil, "register reformatted",
		"quality-1", at); err != nil {
		t.Fatalf("CloseFinding(observation): %v", err)
	}
}

// SRS-QMS-007. An audit closed over open non-conformities is a hospital that
// believes a process was checked and corrected when only the first happened.
func TestAnAuditCannotCloseOverOpenFindings(t *testing.T) {
	audit, err := domain.PlanAudit("a1", "t", domain.NewAuditInput{
		Title: "IPC audit", Scope: "hand hygiene", AuditorID: "auditor-1",
		AuditeeDepartment: "medicine",
		PlannedFrom:       at, PlannedTo: at.AddDate(0, 0, 7),
	}, "quality-1", at)
	if err != nil {
		t.Fatalf("PlanAudit: %v", err)
	}
	if err := audit.ReportAudit("two non-conformities", "auditor-1", at); err != nil {
		t.Fatalf("ReportAudit: %v", err)
	}

	open, err := domain.RecordFinding("f1", "t", domain.NewFindingInput{
		AuditID: "a1", Severity: domain.FindingMinor,
		Detail: "gap", Evidence: "register",
	}, "auditor-1", at)
	if err != nil {
		t.Fatalf("RecordFinding: %v", err)
	}

	refused(t, audit.CloseAudit([]domain.Finding{open}, "quality-1", at),
		"an audit closed over an open finding")

	open.ClosedAt, open.ClosedBy = at, "quality-1"
	if err := audit.CloseAudit([]domain.Finding{open}, "quality-1", at); err != nil {
		t.Fatalf("CloseAudit: %v", err)
	}
}

// SRS-QMS-007. A non-conformity with no evidence is an opinion, and the
// department it names will treat it as one.
func TestANonConformityRecordsItsEvidence(t *testing.T) {
	_, err := domain.RecordFinding("f1", "t", domain.NewFindingInput{
		AuditID: "a1", Severity: domain.FindingMajor, Detail: "gap",
	}, "auditor-1", at)
	refused(t, err, "a non-conformity with no evidence")
}

// SRS-QMS-008. A decision taken by two people from a committee of nine is not
// the committee's decision, and minutes that record it as one are the
// document a survey reads.
func TestMinutesRecordingDecisionsNeedAQuorum(t *testing.T) {
	committee := domain.Committee{
		ID: "c1", TenantID: "t", Code: "QC", Name: "Quality committee",
		QuorumSize: 4, Active: true,
		Members: []string{"a", "b", "c", "d", "e", "f"},
	}
	meeting := domain.Meeting{
		ID: "m1", TenantID: "t", CommitteeID: "c1",
		ScheduledAt: at, State: domain.MeetingScheduled,
	}

	if err := meeting.HoldMeeting([]string{"a", "b"}, []string{"c"},
		"discussed the incident log",
		[]domain.Decision{{Text: "roster a second nurse overnight"}},
		at); err != nil {
		t.Fatalf("HoldMeeting: %v", err)
	}
	refused(t, meeting.ApproveMinutes(committee, "chair-1", at),
		"minutes recording decisions taken below quorum")

	// The same meeting with nobody deciding anything is a meeting, and its
	// minutes are approvable.
	informational := meeting
	informational.Decisions = nil
	if err := informational.ApproveMinutes(committee, "chair-1", at); err != nil {
		t.Fatalf("ApproveMinutes: %v", err)
	}

	// And with a quorum, the decisions stand.
	quorate := domain.Meeting{
		ID: "m2", TenantID: "t", CommitteeID: "c1",
		ScheduledAt: at, State: domain.MeetingScheduled,
	}
	if err := quorate.HoldMeeting([]string{"a", "b", "c", "d"}, nil,
		"discussed the incident log",
		[]domain.Decision{{Text: "roster a second nurse overnight"}},
		at); err != nil {
		t.Fatalf("HoldMeeting: %v", err)
	}
	if err := quorate.ApproveMinutes(committee, "chair-1", at); err != nil {
		t.Fatalf("ApproveMinutes(quorate): %v", err)
	}
}

// SRS-QMS-009. A clause judged met with nothing filed against it is the
// entire failure mode of an evidence map.
func TestAClauseCannotBeJudgedMetWithNoEvidence(t *testing.T) {
	_, err := domain.ReviewClause("rv1", "t", "cl1", domain.VerdictMet,
		"looks fine", "", nil, "quality-1", at)
	refused(t, err, "a clause judged met with no evidence")

	evidence, err := domain.AddEvidence("e1", "t", "cl1",
		domain.EvidenceDocument, "v1", "", "", "quality-1", at)
	if err != nil {
		t.Fatalf("AddEvidence: %v", err)
	}
	if _, err := domain.ReviewClause("rv1", "t", "cl1", domain.VerdictMet,
		"", "", []domain.Evidence{evidence}, "quality-1", at); err != nil {
		t.Fatalf("ReviewClause: %v", err)
	}

	// Not met needs the action that will close it; not applicable needs a
	// reason, because it is the verdict that removes a clause from the
	// assessment.
	_, err = domain.ReviewClause("rv2", "t", "cl2", domain.VerdictNotMet,
		"no policy exists", "", nil, "quality-1", at)
	refused(t, err, "a clause found not met with no action")

	_, err = domain.ReviewClause("rv3", "t", "cl3", domain.VerdictNotApplicable,
		"", "", nil, "quality-1", at)
	refused(t, err, "a clause marked not applicable with no reason")
}

// SRS-QMS-009. Evidence is pinned to a document version, never a document: an
// SOP revised after the evidence was filed is a different document.
func TestExternalEvidenceSaysWhatItIsAndWhereItIs(t *testing.T) {
	_, err := domain.AddEvidence("e1", "t", "cl1", domain.EvidenceExternal,
		"", "", "", "quality-1", at)
	refused(t, err, "external evidence with no reference or description")

	if _, err := domain.AddEvidence("e1", "t", "cl1", domain.EvidenceExternal,
		"", "FIRE-NOC-2026/114", "fire no-objection certificate, in the safety office",
		"quality-1", at); err != nil {
		t.Fatalf("AddEvidence: %v", err)
	}

	// Internal evidence names the record it is.
	_, err = domain.AddEvidence("e2", "t", "cl1", domain.EvidenceDocument,
		"", "", "the hand hygiene policy", "quality-1", at)
	refused(t, err, "document evidence naming no version")
}

// SRS-QMS-014. A readiness screen is read from the top and stopped part-way,
// so the worst has to be at the top and the critical gaps counted apart.
func TestReadinessCountsCriticalGapsAndStaleReviewsApart(t *testing.T) {
	clauses := []domain.Clause{
		{ID: "cl1", Reference: "AAC.1.a", Critical: true},
		{ID: "cl2", Reference: "AAC.1.b"},
		{ID: "cl3", Reference: "AAC.2.a", Critical: true},
		{ID: "cl4", Reference: "AAC.3.a"},
	}
	evidence := map[string][]domain.Evidence{
		"cl1": {{ID: "e1"}},
		"cl3": {{ID: "e3"}},
		"cl4": {{ID: "e4", RemovedAt: at}},
	}
	reviews := map[string]domain.ClauseReview{
		"cl1": {Verdict: domain.VerdictNotMet, ReviewedAt: at.AddDate(0, -1, 0),
			CAPAID: "c1"},
		"cl3": {Verdict: domain.VerdictMet, ReviewedAt: at.AddDate(-3, 0, 0)},
		"cl4": {Verdict: domain.VerdictNotApplicable, ReviewedAt: at},
	}

	readiness := domain.AssessReadiness("s1", clauses, reviews, evidence,
		365*24*time.Hour, 7, at)

	if readiness.Total != 4 || readiness.NotMet != 1 || readiness.Met != 1 ||
		readiness.Unreviewed != 1 || readiness.NotApplicable != 1 {
		t.Fatalf("readiness = %+v, want one of each", readiness)
	}
	// cl1 is critical and not met; cl2 is not critical and unreviewed. Only
	// cl1 counts as a critical gap.
	if readiness.CriticalGaps != 1 {
		t.Fatalf("critical gaps = %d, want 1", readiness.CriticalGaps)
	}
	// cl3's judgement is three years old.
	if readiness.StaleReviews != 1 {
		t.Fatalf("stale reviews = %d, want 1", readiness.StaleReviews)
	}
	// cl2 has nothing filed; cl4's only evidence was withdrawn but the clause
	// does not apply, so it is not a gap.
	if readiness.EvidenceGaps != 1 {
		t.Fatalf("evidence gaps = %d, want 1", readiness.EvidenceGaps)
	}
	if readiness.OverdueActions != 7 {
		t.Fatalf("overdue actions = %d, want the 7 supplied",
			readiness.OverdueActions)
	}
	// Worst first, critical before ordinary.
	if readiness.Clauses[0].ClauseID != "cl1" {
		t.Fatalf("first clause = %q, want the critical not-met one",
			readiness.Clauses[0].ClauseID)
	}
}

func kpi(t *testing.T) domain.KPIDefinition {
	t.Helper()
	definition, err := domain.DefineKPI("k1", "t", domain.NewKPIInput{
		Code: "HH-COMP", Name: "Hand hygiene compliance", Revision: 1,
		Numerator:   "observed opportunities with hand hygiene performed",
		Denominator: "observed hand hygiene opportunities",
		Unit:        "percent", TargetPermille: 850,
		Direction: domain.DirectionHigherIsBetter,
		Frequency: domain.FrequencyMonthly, OwnerID: "ipc-1",
		EffectiveFrom: at.AddDate(-1, 0, 0),
	}, "quality-1", at)
	if err != nil {
		t.Fatalf("DefineKPI: %v", err)
	}
	return definition
}

// SRS-QMS-010. The value is derived and carries the revision it was computed
// under, and a month with no eligible cases is not a month of total failure.
func TestAKPIValueIsDerivedAndAZeroDenominatorIsUnanswerable(t *testing.T) {
	definition := kpi(t)

	value, err := domain.RecordKPIValue("v1", "t", definition,
		at.AddDate(0, -1, 0), at, 174, 200, "IPC observation register",
		"ipc-1", at)
	if err != nil {
		t.Fatalf("RecordKPIValue: %v", err)
	}
	if value.Permille != 870 {
		t.Fatalf("permille = %d, want 870", value.Permille)
	}
	if value.Revision != 1 {
		t.Fatalf("revision = %d, want the definition's", value.Revision)
	}
	met, measured := value.MeetsTarget(definition)
	if !measured || !met {
		t.Fatalf("87.0%% against a target of 85.0%% = %v/%v, want met",
			met, measured)
	}

	// No observations at all. Reported as unanswerable rather than as zero
	// compliance, because those are opposite facts.
	empty, err := domain.RecordKPIValue("v2", "t", definition,
		at.AddDate(0, -1, 0), at, 0, 0, "no rounds ran", "ipc-1", at)
	if err != nil {
		t.Fatalf("RecordKPIValue(empty): %v", err)
	}
	if !empty.Unanswerable || empty.Permille != 0 {
		t.Fatalf("empty period = %+v, want unanswerable", empty)
	}
	if _, measured := empty.MeetsTarget(definition); measured {
		t.Fatal("an unmeasured period was judged against the target")
	}

	// A rate above 100% is an arithmetic or definition mistake, not a
	// measurement.
	_, err = domain.RecordKPIValue("v3", "t", definition,
		at.AddDate(0, -1, 0), at, 210, 200, "register", "ipc-1", at)
	refused(t, err, "a numerator larger than its denominator")
}

// SRS-QMS-011. A complaint resolved without the complainant ever being spoken
// to is a file closed rather than a grievance handled.
func TestAComplaintIsAcknowledgedBeforeItIsResolved(t *testing.T) {
	in := domain.NewComplaintInput{
		Reference: "COMP-1", Kind: domain.ComplainantRelative,
		Category: "communication", Detail: "nobody explained the delay",
		ReceivedAt:        at,
		AcknowledgeWithin: 48 * time.Hour,
		ResolveWithin:     30 * 24 * time.Hour,
	}
	complaint, err := domain.ReceiveComplaint("cm1", "t", in, "pro-1", at)
	if err != nil {
		t.Fatalf("ReceiveComplaint: %v", err)
	}

	refused(t, complaint.Resolve(domain.OutcomeUpheld, "apologised", "pro-1",
		at.Add(time.Hour)), "a complaint resolved without acknowledgement")

	// Withdrawal is the exception: they went away before anybody got to them,
	// and recording that honestly beats forcing a false acknowledgement.
	withdrawn := complaint
	if err := withdrawn.Resolve(domain.OutcomeWithdrawn,
		"complainant withdrew before contact", "pro-1",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Resolve(withdrawn): %v", err)
	}

	if err := complaint.Acknowledge("pro-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Acknowledge: %v", err)
	}
	if err := complaint.Resolve(domain.OutcomeUpheld,
		"apologised, ward briefed", "pro-1", at.Add(48*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	refused(t, complaint.CloseComplaint("", "pro-1", at.Add(72*time.Hour)),
		"a complaint closed with no reason")
	if err := complaint.CloseComplaint("resolved to the family's satisfaction",
		"pro-1", at.Add(72*time.Hour)); err != nil {
		t.Fatalf("CloseComplaint: %v", err)
	}
}

// SRS-QMS-011. A hospital that acknowledges in a day and resolves in a month
// is behaving correctly; merging the clocks hides whichever is being missed.
func TestComplaintBreachesSeparateTheTwoClocks(t *testing.T) {
	in := domain.NewComplaintInput{
		Reference: "COMP-1", Kind: domain.ComplainantPatient,
		Category: "waiting", Detail: "four hours in the department",
		ReceivedAt:        at,
		AcknowledgeWithin: 48 * time.Hour,
		ResolveWithin:     30 * 24 * time.Hour,
	}
	complaint, err := domain.ReceiveComplaint("cm1", "t", in, "pro-1", at)
	if err != nil {
		t.Fatalf("ReceiveComplaint: %v", err)
	}

	// Three days on, unacknowledged: one clock missed, not both.
	breaches := domain.ComplaintBreaches([]domain.Complaint{complaint},
		at.Add(72*time.Hour))
	if len(breaches) != 1 || !breaches[0].Acknowledgement ||
		breaches[0].Resolution {
		t.Fatalf("breaches = %+v, want only the acknowledgement clock",
			breaches)
	}

	// Acknowledged but still open after forty days: the other one.
	if err := complaint.Acknowledge("pro-1", at.Add(24*time.Hour)); err != nil {
		t.Fatalf("Acknowledge: %v", err)
	}
	breaches = domain.ComplaintBreaches([]domain.Complaint{complaint},
		at.Add(40*24*time.Hour))
	if len(breaches) != 1 || breaches[0].Acknowledgement ||
		!breaches[0].Resolution {
		t.Fatalf("breaches = %+v, want only the resolution clock", breaches)
	}
}

// SRS-QMS-012. A classification of "potentially preventable" with nothing
// raised from it is a hospital that has written down that it could have done
// better and done nothing.
func TestAPreventableDeathMustRaiseAnAction(t *testing.T) {
	review, err := domain.StartMortalityReview("mr1", "t", "pat-1", "enc-1",
		"c1", at.AddDate(0, 0, -7), "quality-1", at)
	if err != nil {
		t.Fatalf("StartMortalityReview: %v", err)
	}

	refused(t, review.CompleteMortalityReview("m1",
		domain.DeathPotentiallyPreventable,
		"delay in escalating a deteriorating patient", "", nil,
		"chair-1", at),
		"a potentially preventable death with no action")

	// A peer review signed by one person is not a peer review.
	refused(t, review.CompleteMortalityReview("",
		domain.DeathExpected, "end-stage disease", "", nil, "chair-1", at),
		"a peer review naming no meeting")

	if err := review.CompleteMortalityReview("m1",
		domain.DeathPotentiallyPreventable,
		"delay in escalating a deteriorating patient",
		"the escalation protocol needs a hard trigger",
		[]string{"c1"}, "chair-1", at); err != nil {
		t.Fatalf("CompleteMortalityReview: %v", err)
	}
}

// SRS-QMS-013. Never trained, lapsed, and trained against superseded text
// need three different actions, so they are three different answers.
func TestCompetencyGapsDistinguishWhyTheyAreGaps(t *testing.T) {
	competencies := map[string]domain.Competency{
		"cp1": {ID: "cp1", Code: "HH", DocumentID: "d1", ValidMonths: 12},
	}
	required := map[string][]string{"nurse": {"cp1"}}
	people := map[string]string{
		"never": "nurse", "lapsed": "nurse",
		"old": "nurse", "fine": "nurse", "revoked": "nurse",
	}
	awards := []domain.Award{
		{CompetencyID: "cp1", PersonID: "lapsed", VersionID: "v2",
			AwardedAt: at.AddDate(-2, 0, 0), ExpiresAt: at.AddDate(-1, 0, 0)},
		{CompetencyID: "cp1", PersonID: "old", VersionID: "v1",
			AwardedAt: at.AddDate(0, -1, 0), ExpiresAt: at.AddDate(0, 11, 0)},
		{CompetencyID: "cp1", PersonID: "fine", VersionID: "v2",
			AwardedAt: at.AddDate(0, -1, 0), ExpiresAt: at.AddDate(0, 11, 0)},
		{CompetencyID: "cp1", PersonID: "revoked", VersionID: "v2",
			AwardedAt: at.AddDate(0, -1, 0), ExpiresAt: at.AddDate(0, 11, 0),
			RevokedAt: at.AddDate(0, 0, -1), RevokedWhy: "failed reassessment"},
	}
	// Version 2 of the policy required retraining, so training against v1 no
	// longer counts.
	retrained := map[string]string{"cp1": "v2"}

	gaps := domain.CompetencyGaps(required, people, awards, competencies,
		retrained, at)
	byPerson := map[string]string{}
	for _, gap := range gaps {
		byPerson[gap.PersonID] = gap.Reason
	}

	if byPerson["never"] != domain.GapNeverHeld {
		t.Fatalf("never = %q, want %q", byPerson["never"], domain.GapNeverHeld)
	}
	if byPerson["lapsed"] != domain.GapExpired {
		t.Fatalf("lapsed = %q, want %q", byPerson["lapsed"], domain.GapExpired)
	}
	if byPerson["old"] != domain.GapSuperseded {
		t.Fatalf("old = %q, want %q", byPerson["old"], domain.GapSuperseded)
	}
	if byPerson["revoked"] != domain.GapRevoked {
		t.Fatalf("revoked = %q, want %q", byPerson["revoked"], domain.GapRevoked)
	}
	if _, isGap := byPerson["fine"]; isGap {
		t.Fatalf("a valid award was reported as a gap: %v", byPerson)
	}
}
