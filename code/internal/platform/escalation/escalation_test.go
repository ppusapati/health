package escalation_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/escalation"
)

func at(hour, minute int) time.Time {
	return time.Date(2026, time.September, 17, hour, minute, 0, 0, time.UTC)
}

func person(id string) escalation.Recipient { return escalation.Recipient{UserID: id} }

func onCall(role string) escalation.Recipient {
	return escalation.Recipient{Role: role, FacilityID: "f1"}
}

func chain() escalation.Matrix {
	return escalation.Matrix{
		FacilityID: "f1",
		Kind:       "critical_result",
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{person("ordering-clinician")}},
			{Level: 1, Recipients: []escalation.Recipient{onCall("ed_registrar")}},
			{Level: 2, Recipients: []escalation.Recipient{
				onCall("ed_consultant"), person("duty-manager"),
			}},
		},
	}
}

func subject() escalation.Subject {
	return escalation.Subject{
		Kind: "critical_result", ID: "obs-1",
		PatientID: "p1", FacilityID: "f1",
	}
}

func raised(t *testing.T) escalation.Notice {
	t.Helper()
	notice, err := escalation.Raise("n1", "t1", subject(),
		"Potassium 7.1 mmol/L — critically high", at(9, 0))
	if err != nil {
		t.Fatalf("raise: %v", err)
	}
	return notice
}

// --------------------------------------------------------------- the matrix

func TestAMatrixMustStartAtTheResponsiblePerson(t *testing.T) {
	// A chain that starts at level one begins by telling somebody else's boss,
	// which is both rude and slower than telling the person who ordered it.
	matrix := escalation.Matrix{
		FacilityID: "f1", Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 1, Recipients: []escalation.Recipient{onCall("ed_registrar")}},
		},
	}
	if err := matrix.Validate(); !errors.Is(err, escalation.ErrInvalidMatrix) {
		t.Fatalf("a matrix with no level 0 was accepted: %v", err)
	}
}

func TestAMatrixWithNoRungsIsRefused(t *testing.T) {
	matrix := escalation.Matrix{FacilityID: "f1", Kind: "critical_result"}
	if err := matrix.Validate(); !errors.Is(err, escalation.ErrInvalidMatrix) {
		t.Fatal("a matrix that tells nobody was accepted")
	}
}

func TestARungThatNamesNobodyIsRefused(t *testing.T) {
	// Distinct from a gap in the levels, which is tolerated. A rung that exists
	// and is empty would swallow an escalation step silently.
	matrix := chain()
	matrix.Rungs = append(matrix.Rungs, escalation.Rung{Level: 3})
	if err := matrix.Validate(); !errors.Is(err, escalation.ErrInvalidMatrix) {
		t.Fatal("an empty rung was accepted")
	}
}

func TestARecipientIsAPersonOrARoleAndNotBoth(t *testing.T) {
	// At three in the morning "the named consultant, who is not on duty"
	// and "whoever is on duty" are different people, and a rung naming both
	// cannot say which it meant.
	both := escalation.Recipient{UserID: "u1", Role: "ed_consultant"}
	if err := both.Validate(); !errors.Is(err, escalation.ErrInvalidMatrix) {
		t.Fatal("a recipient naming both a person and a role was accepted")
	}
	neither := escalation.Recipient{}
	if err := neither.Validate(); !errors.Is(err, escalation.ErrInvalidMatrix) {
		t.Fatal("a recipient naming nobody was accepted")
	}
}

func TestRungsAreWalkedInLevelOrderWhateverOrderTheyAreStoredIn(t *testing.T) {
	// Rows come back in whatever order the query returned them, and walking
	// that order would escalate to the chief executive before the registrar.
	matrix := escalation.Matrix{
		FacilityID: "f1", Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 2, Recipients: []escalation.Recipient{person("chief")}},
			{Level: 0, Recipients: []escalation.Recipient{person("clinician")}},
			{Level: 1, Recipients: []escalation.Recipient{person("registrar")}},
		},
	}
	sorted := matrix.Sorted()
	for i, rung := range sorted {
		if rung.Level != i {
			t.Fatalf("rung %d is at level %d", i, rung.Level)
		}
	}
}

func TestAGapInTheChainFallsThroughRatherThanStopping(t *testing.T) {
	// A matrix missing level 1 is a configuration mistake. The notice is still
	// unacknowledged, so the remedy is the next rung that exists, and the
	// level actually reached is reported so the record says who was really
	// told.
	matrix := escalation.Matrix{
		FacilityID: "f1", Kind: "critical_result",
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{person("clinician")}},
			{Level: 3, Recipients: []escalation.Recipient{person("consultant")}},
		},
	}
	recipients, level, ok := matrix.At(1)
	if !ok {
		t.Fatal("a gap stopped the chain")
	}
	if level != 3 {
		t.Fatalf("fell through to level %d, want 3", level)
	}
	if len(recipients) != 1 || recipients[0].UserID != "consultant" {
		t.Fatalf("wrong recipients: %+v", recipients)
	}
}

func TestPastTheTopRungTheChainIsExhaustedRatherThanRepeating(t *testing.T) {
	// Telling the top rung forever is how an escalation becomes background
	// noise, and it hides that the hospital's own chain has been walked out.
	if _, _, ok := chain().At(3); ok {
		t.Fatal("the chain answered past its top rung")
	}
}

// --------------------------------------------------------------- the notice

func TestANoticeNeedsSomethingToActOn(t *testing.T) {
	// An empty summary arrives on a phone as a row with a timestamp.
	if _, err := escalation.Raise("n1", "t1", subject(), "  ", at(9, 0)); !errors.Is(
		err, escalation.ErrInvalidNotice) {
		t.Fatal("a notice with no summary was accepted")
	}
}

func TestASubjectIsTheIdempotencyKey(t *testing.T) {
	// Raising the same notice twice happens on every retry, replay and
	// restart. Two chains racing each other to the same consultant is the
	// failure this key prevents.
	first := subject()
	second := escalation.Subject{
		Kind: "critical_result", ID: "obs-1",
		PatientID: "p2", FacilityID: "f9",
	}
	if first.Key() != second.Key() {
		t.Fatalf("the same subject produced two keys: %q and %q", first.Key(), second.Key())
	}
	other := escalation.Subject{Kind: "critical_result", ID: "obs-2"}
	if first.Key() == other.Key() {
		t.Fatal("two different subjects share a key")
	}
}

func TestANewNoticeIsPendingAtLevelZero(t *testing.T) {
	notice := raised(t)
	if notice.State != escalation.StatePending {
		t.Fatalf("state %q, want pending", notice.State)
	}
	if notice.Level != 0 {
		t.Fatalf("level %d, want 0", notice.Level)
	}
	if !notice.State.Open() {
		t.Fatal("a new notice is not open")
	}
}

func TestANoticeDoesNotEscalateBeforeItsInterval(t *testing.T) {
	notice := raised(t)
	policy := escalation.DefaultPolicy()
	if notice.Due(policy, at(9, 14)) {
		t.Fatal("escalated after fourteen minutes")
	}
	if !notice.Due(policy, at(9, 15)) {
		t.Fatal("did not escalate after fifteen minutes")
	}
}

func TestEscalationWalksTheChainOneRungAtATime(t *testing.T) {
	notice := raised(t)
	matrix, policy := chain(), escalation.DefaultPolicy()

	recipients, level, err := notice.Escalate(matrix, policy, at(9, 15))
	if err != nil {
		t.Fatalf("escalate: %v", err)
	}
	if level != 1 || len(recipients) != 1 || recipients[0].Role != "ed_registrar" {
		t.Fatalf("first escalation reached level %d, %+v", level, recipients)
	}

	// The second interval runs from the escalation, not from the raise.
	if notice.Due(policy, at(9, 29)) {
		t.Fatal("the second interval was measured from the raise")
	}
	if !notice.Due(policy, at(9, 30)) {
		t.Fatal("the second interval did not elapse")
	}

	recipients, level, err = notice.Escalate(matrix, policy, at(9, 30))
	if err != nil {
		t.Fatalf("escalate: %v", err)
	}
	if level != 2 || len(recipients) != 2 {
		t.Fatalf("second escalation reached level %d with %d recipients", level, len(recipients))
	}
}

func TestAChainWalkedToTheTopIsExhaustedAndSaysSo(t *testing.T) {
	// The loudest thing this mechanism can say: everybody in the hospital's own
	// chain was told and nobody answered. Silently stopping would leave it
	// looking pending forever, and repeating the top rung would make it noise.
	notice := raised(t)
	matrix, policy := chain(), escalation.DefaultPolicy()

	_, _, _ = notice.Escalate(matrix, policy, at(9, 15))
	_, _, _ = notice.Escalate(matrix, policy, at(9, 30))
	recipients, _, err := notice.Escalate(matrix, policy, at(9, 45))
	if err != nil {
		t.Fatalf("escalate: %v", err)
	}
	if recipients != nil {
		t.Fatalf("an exhausted chain returned recipients: %+v", recipients)
	}
	if notice.State != escalation.StateExhausted {
		t.Fatalf("state %q, want exhausted", notice.State)
	}
	if _, ok := notice.DueAt(policy); ok {
		t.Fatal("an exhausted notice is still due")
	}
}

func TestATenantCanStopShortOfTheTopRung(t *testing.T) {
	notice := raised(t)
	policy := escalation.DefaultPolicy()
	policy.MaxLevel = 1

	if _, level, _ := notice.Escalate(chain(), policy, at(9, 15)); level != 1 {
		t.Fatalf("reached level %d, want 1", level)
	}
	if _, _, err := notice.Escalate(chain(), policy, at(9, 30)); err != nil {
		t.Fatalf("escalate: %v", err)
	}
	if notice.State != escalation.StateExhausted {
		t.Fatalf("state %q, want exhausted at the tenant's ceiling", notice.State)
	}
}

func TestAnyoneMayAcknowledgeAndTheChainStops(t *testing.T) {
	// A registrar who sees a colleague's alert and deals with it has dealt
	// with it. Refusing their acknowledgement would keep escalating something
	// already in hand, which is how people learn to ignore escalations.
	notice := raised(t)
	policy := escalation.DefaultPolicy()

	if err := notice.Acknowledge("passing-registrar", at(9, 10)); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	if notice.State != escalation.StateAcknowledged {
		t.Fatalf("state %q, want acknowledged", notice.State)
	}
	if _, ok := notice.DueAt(policy); ok {
		t.Fatal("an acknowledged notice is still due to escalate")
	}
	if _, _, err := notice.Escalate(chain(), policy, at(9, 15)); err == nil {
		t.Fatal("an acknowledged notice escalated")
	}
}

func TestAcknowledgingTwiceKeepsTheFirstRecord(t *testing.T) {
	// Two people pressing the button at once is not a mistake.
	notice := raised(t)
	if err := notice.Acknowledge("first", at(9, 10)); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	if err := notice.Acknowledge("second", at(9, 11)); err != nil {
		t.Fatalf("second acknowledgement errored: %v", err)
	}
	if notice.AcknowledgedBy != "first" {
		t.Fatalf("acknowledged by %q, want the first", notice.AcknowledgedBy)
	}
	if !notice.AcknowledgedAt.Equal(at(9, 10)) {
		t.Fatalf("acknowledged at %v, want the first", notice.AcknowledgedAt)
	}
}

func TestAnAcknowledgementNamesWhoMadeIt(t *testing.T) {
	notice := raised(t)
	if err := notice.Acknowledge("  ", at(9, 10)); !errors.Is(err, escalation.ErrInvalidNotice) {
		t.Fatal("an anonymous acknowledgement was accepted")
	}
}

func TestClosingNeedsAReasonAndCannotEraseAnAcknowledgement(t *testing.T) {
	notice := raised(t)
	if err := notice.Close("", at(9, 20)); !errors.Is(err, escalation.ErrInvalidNotice) {
		t.Fatal("a notice was closed with no reason")
	}
	if err := notice.Close("result superseded by a repeat sample", at(9, 20)); err != nil {
		t.Fatalf("close: %v", err)
	}
	if notice.State != escalation.StateClosed {
		t.Fatalf("state %q, want closed", notice.State)
	}

	// And the other direction: an acknowledgement is the only evidence that
	// anybody took the notice, so closing must not overwrite it.
	acknowledged := raised(t)
	if err := acknowledged.Acknowledge("registrar", at(9, 10)); err != nil {
		t.Fatalf("acknowledge: %v", err)
	}
	if err := acknowledged.Close("no longer relevant", at(9, 20)); err == nil {
		t.Fatal("closing erased an acknowledgement")
	}
}

func TestAClosedNoticeCannotBeAcknowledgedAfterwards(t *testing.T) {
	notice := raised(t)
	if err := notice.Close("patient discharged", at(9, 20)); err != nil {
		t.Fatalf("close: %v", err)
	}
	if err := notice.Acknowledge("registrar", at(9, 25)); err == nil {
		t.Fatal("a closed notice was acknowledged")
	}
}

// ------------------------------------------------------------- the delivery

func TestAFailedDeliveryDoesNotStopTheChain(t *testing.T) {
	// The remedy for a recipient who cannot be reached is the next rung, not a
	// retry against a phone that is switched off.
	notice := raised(t)
	matrix, policy := chain(), escalation.DefaultPolicy()

	notice.Record(escalation.Delivery{
		Level: 0, Recipient: person("ordering-clinician"), At: at(9, 0),
		Channel: "task", Err: "no active session",
	})
	if notice.Reached() {
		t.Fatal("a failed delivery counted as reaching somebody")
	}
	if !notice.Due(policy, at(9, 15)) {
		t.Fatal("a failed delivery stopped the chain")
	}

	if _, level, err := notice.Escalate(matrix, policy, at(9, 15)); err != nil || level != 1 {
		t.Fatalf("escalate after a failed delivery: level %d, %v", level, err)
	}
}

func TestReachedAnswersTheQuestionAnIncidentReviewAsksFirst(t *testing.T) {
	notice := raised(t)
	notice.Record(escalation.Delivery{Level: 0, At: at(9, 0), Channel: "task", Err: "offline"})
	notice.Record(escalation.Delivery{Level: 1, At: at(9, 15), Channel: "task"})
	if !notice.Reached() {
		t.Fatal("a successful delivery was not reported")
	}
}

// -------------------------------------------------------------- the storage

func TestAStoredStateThisBuildDoesNotKnowIsNotTreatedAsTerminal(t *testing.T) {
	// The direction that matters. An unreadable state read as terminal is a
	// notice that silently stops escalating; read as unknown, it is one
	// somebody has to look at.
	if escalation.KnownState("snoozed") {
		t.Fatal("an unknown state was accepted")
	}
	for _, state := range []string{"pending", "acknowledged", "closed", "exhausted"} {
		if !escalation.KnownState(state) {
			t.Fatalf("%q is not recognised", state)
		}
	}
}

func TestPolicyValidationRejectsWhatCouldNotBeApplied(t *testing.T) {
	for name, policy := range map[string]escalation.Policy{
		"no delay":       {After: 0},
		"negative then":  {After: time.Minute, Then: -time.Minute},
		"negative level": {After: time.Minute, MaxLevel: -1},
	} {
		if err := policy.Validate(); err == nil {
			t.Fatalf("%s was accepted", name)
		}
	}
	if err := escalation.DefaultPolicy().Validate(); err != nil {
		t.Fatalf("the default policy is invalid: %v", err)
	}
}
