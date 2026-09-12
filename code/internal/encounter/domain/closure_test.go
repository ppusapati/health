package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
)

// Episodes, care teams, diagnoses, the closure gate and the timeline
// (SRS-ENC-004 … SRS-ENC-011).

// SRS-ENC-004: encounters reference an episode without copying data.
func TestAnEpisodeGroupsEncountersWithoutCopyingThem(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	episode, err := domain.NewEpisode("ep-1", "t-1", "p-1", "f-1",
		domain.EpisodePregnancy, "second pregnancy", "doctor-1", now, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewEpisode: %v", err)
	}
	if !episode.Accepts() {
		t.Fatal("a new episode does not accept encounters")
	}

	// A finished course of care is not reopened: a pregnancy that resumes is a
	// different pregnancy.
	if err := episode.SetStatus(domain.EpisodeFinished, now, now); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}
	if err := episode.SetStatus(domain.EpisodeActive, now, now); err == nil {
		t.Fatal("a finished episode was reopened")
	}
	if episode.Accepts() {
		t.Fatal("a finished episode still accepts encounters")
	}
}

// A patient with two pregnancies has two, and an unlabelled one cannot be
// picked out of a list.
func TestAnEpisodeNeedsALabel(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewEpisode("ep-1", "t-1", "p-1", "f-1",
		domain.EpisodeOncology, "   ", "", now, "doctor-1", now); err == nil {
		t.Fatal("an unlabelled episode was accepted")
	}
}

// SRS-ENC-005: "authorization can evaluate active care-team relationship".
func TestCareTeamMembershipIsAnsweredAsOfATime(t *testing.T) {
	monday := at(2026, time.March, 2, 9)
	wednesday := at(2026, time.March, 4, 9)
	friday := at(2026, time.March, 6, 9)

	handedOver, err := domain.NewCareTeamMember("ct-1", "t-1", "e-1", "doctor-1",
		domain.RoleAttending, monday, wednesday, "admin-1", monday)
	if err != nil {
		t.Fatalf("NewCareTeamMember: %v", err)
	}
	tookOver, err := domain.NewCareTeamMember("ct-2", "t-1", "e-1", "doctor-2",
		domain.RoleAttending, wednesday, time.Time{}, "admin-1", wednesday)
	if err != nil {
		t.Fatalf("NewCareTeamMember: %v", err)
	}

	team := domain.CareTeam{handedOver, tookOver}

	// The question an investigation asks is about the past, not about today.
	if !team.Includes("doctor-1", monday) {
		t.Fatal("the consultant who was looking after this patient on Monday is not on " +
			"the team as of Monday")
	}
	if team.Includes("doctor-1", friday) {
		t.Fatal("a consultant who handed over on Wednesday is still on the team on Friday")
	}
	if !team.Includes("doctor-2", friday) {
		t.Fatal("the consultant who took over is not on the team")
	}

	if role, ok := team.RoleOf("doctor-2", friday); !ok || role != domain.RoleAttending {
		t.Fatalf("role = %q (found %v), want attending", role, ok)
	}
	if len(team.ActiveAt(friday)) != 1 {
		t.Fatalf("%d members active on Friday, want 1", len(team.ActiveAt(friday)))
	}
}

func TestACareTeamAssignmentMustEndAfterItBegins(t *testing.T) {
	monday := at(2026, time.March, 2, 9)

	if _, err := domain.NewCareTeamMember("ct-1", "t-1", "e-1", "doctor-1",
		domain.RoleAttending, monday, monday.Add(-time.Hour), "admin-1", monday); err == nil {
		t.Fatal("a care-team assignment ended before it began")
	}
}

// SRS-ENC-007: a code with no terminology is a number nobody can safely act on.
func TestADiagnosisNeedsItsTerminology(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	_, err := domain.NewDiagnosis("d-1", "t-1", "e-1", "p-1",
		domain.Coding{Code: "I21.9", Display: "Acute myocardial infarction"},
		domain.CertaintyFinal, domain.RankPrimary, "", time.Time{}, "doctor-1", now)
	if err == nil {
		t.Fatal("a diagnosis was recorded with a bare code and no terminology")
	}
	if !strings.Contains(err.Error(), "terminology") {
		t.Fatalf("the refusal does not say what is missing: %v", err)
	}
}

// A bare code on a screen is a screen clinicians stop reading.
func TestADiagnosisNeedsADisplayTerm(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewDiagnosis("d-1", "t-1", "e-1", "p-1",
		domain.Coding{System: "icd-10", Code: "I21.9"},
		domain.CertaintyFinal, domain.RankPrimary, "", time.Time{}, "doctor-1", now); err == nil {
		t.Fatal("a diagnosis was recorded with no display term")
	}
}

// SRS-ENC-007: "diagnosis history and author/time retained" — a change of mind
// supersedes rather than overwrites, because the trail is the clinical
// reasoning.
func TestSupersedingADiagnosisKeepsTheReasoningTrail(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	code := func(c, display string) domain.Coding {
		return domain.Coding{System: "icd-10", Version: "2019", Code: c, Display: display}
	}

	working, err := domain.NewDiagnosis("d-1", "t-1", "e-1", "p-1",
		code("R07.4", "Chest pain, unspecified"),
		domain.CertaintyProvisional, domain.RankPrimary, "", time.Time{}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewDiagnosis: %v", err)
	}

	confirmed, err := domain.NewDiagnosis("d-2", "t-1", "e-1", "p-1",
		code("I21.9", "Acute myocardial infarction"),
		domain.CertaintyFinal, domain.RankPrimary, "", time.Time{}, "doctor-1",
		now.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("NewDiagnosis: %v", err)
	}
	working.SupersededByID = confirmed.ID

	list := domain.DiagnosisList{working, confirmed}

	if len(list) != 2 {
		t.Fatal("the provisional diagnosis was lost, so the reasoning trail is gone")
	}
	live := list.Live()
	if len(live) != 1 || live[0].ID != "d-2" {
		t.Fatalf("live diagnoses = %d, want only the confirmed one", len(live))
	}
	primary, ok := list.Primary()
	if !ok || primary.Code.Code != "I21.9" {
		t.Fatalf("primary = %+v, want the confirmed infarction", primary)
	}
	if !list.HasFinal() {
		t.Fatal("a confirmed diagnosis does not count as final")
	}
}

// A diagnosis of an illness that started last month is not a diagnosis made
// last month — but it cannot have started next month either.
func TestAConditionCannotHaveBegunInTheFuture(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewDiagnosis("d-1", "t-1", "e-1", "p-1",
		domain.Coding{System: "icd-10", Code: "E11", Display: "Type 2 diabetes"},
		domain.CertaintyFinal, domain.RankSecondary, "", now.AddDate(0, 1, 0),
		"doctor-1", now); err == nil {
		t.Fatal("a condition was recorded as having begun next month")
	}
}

// SRS-ENC-008: "blocking items listed".
//
// Every one, not the first: a clinician told about one item, who fixes it and
// is then told about another, is a clinician who stops trusting the message.
func TestAnIncompleteClosureListsEverythingThatIsMissing(t *testing.T) {
	policy := domain.DefaultClosurePolicy()

	err := policy.CheckClosure(domain.ClassInpatient, domain.DocumentationState{
		HasAttendingProvider: true,
	})
	if err == nil {
		t.Fatal("an inpatient encounter with no diagnosis, note or discharge was closed")
	}

	var incomplete domain.ErrIncompleteDocumentation
	if !errors.As(err, &incomplete) {
		t.Fatalf("the refusal is not an incomplete-documentation error: %v", err)
	}
	if len(incomplete.Missing) != 4 {
		t.Fatalf("%d blocking items listed, want all four: %v",
			len(incomplete.Missing), incomplete.Missing)
	}
	// Written as the action to take rather than the rule that was broken.
	if !strings.Contains(err.Error(), "record a final diagnosis") {
		t.Fatalf("the message does not tell the clinician what to do: %v", err)
	}
}

// A complete record closes without ceremony.
func TestACompleteEncounterClosesCleanly(t *testing.T) {
	policy := domain.DefaultClosurePolicy()

	if err := policy.CheckClosure(domain.ClassOutpatient, domain.DocumentationState{
		HasFinalDiagnosis: true, HasEndTime: true, HasAttendingProvider: true,
	}); err != nil {
		t.Fatalf("a complete outpatient encounter was blocked: %v", err)
	}
}

// A walk-in for an X-ray has no consultation to document.
func TestADiagnosticOnlyVisitHasNothingToDocument(t *testing.T) {
	policy := domain.DefaultClosurePolicy()

	if err := policy.CheckClosure(domain.ClassDiagnosticOnly,
		domain.DocumentationState{}); err != nil {
		t.Fatalf("a diagnostic-only visit was blocked from closing: %v", err)
	}
}

// SRS-ENC-008: "emergency override where policy allows".
//
// An emergency department that cannot close a resuscitation until the notes are
// perfect will leave it open, and an open encounter reads as a patient still
// under care.
func TestOnlyEmergencyEncountersCanBeForcedClosedByDefault(t *testing.T) {
	policy := domain.DefaultClosurePolicy()

	if !policy.PermitsOverride(domain.ClassEmergency) {
		t.Fatal("an emergency encounter cannot be closed over an incomplete record")
	}
	if policy.PermitsOverride(domain.ClassOutpatient) {
		t.Fatal("a routine outpatient encounter can be force-closed by default")
	}

	// The error tells a UI which action to offer rather than leaving a dead
	// end.
	var incomplete domain.ErrIncompleteDocumentation
	err := policy.CheckClosure(domain.ClassEmergency, domain.DocumentationState{})
	if !errors.As(err, &incomplete) || !incomplete.Overridable {
		t.Fatalf("the emergency refusal does not offer the override: %v", err)
	}
}

// "ok" is not a reason, and an override that overrode nothing is a false entry
// in the report that exists to count real ones.
func TestAnOverrideNeedsASubstantiveReasonAndSomethingToOverride(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	missing := []domain.DocumentationItem{domain.DocFinalDiagnosis}

	if _, err := domain.NewClosureOverride("o-1", "t-1", "e-1", missing,
		"ok", "doctor-1", now); err == nil {
		t.Fatal("an override was recorded with a two-character reason")
	}
	if _, err := domain.NewClosureOverride("o-1", "t-1", "e-1", nil,
		"resuscitation in progress, documenting afterwards", "doctor-1", now); err == nil {
		t.Fatal("an override was recorded when nothing was blocking")
	}
	if _, err := domain.NewClosureOverride("o-1", "t-1", "e-1", missing,
		"resuscitation in progress, documenting afterwards", "doctor-1", now); err != nil {
		t.Fatalf("a stated override was refused: %v", err)
	}
}

// A documentation item this version does not recognise must not be reported
// present: blocking a closure is recoverable, waving one through is not.
func TestAnUnknownDocumentationRequirementBlocks(t *testing.T) {
	policy := domain.ClosurePolicy{
		Required: map[domain.Class][]domain.DocumentationItem{
			domain.ClassOutpatient: {"signed_by_a_druid"},
		},
	}

	if err := policy.CheckClosure(domain.ClassOutpatient, domain.DocumentationState{
		HasFinalDiagnosis: true, HasSignedNote: true, HasAttendingProvider: true,
		HasEndTime: true, HasDischargeDisposition: true,
	}); err == nil {
		t.Fatal("an unrecognised documentation requirement was treated as met")
	}
}

// SRS-ENC-009: a stored summary, amended rather than rewritten.
func TestAVisitSummaryIsAmendedRatherThanRewritten(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)
	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := e.End(now.Add(time.Hour), "doctor-1", now.Add(time.Hour)); err != nil {
		t.Fatalf("End: %v", err)
	}

	original, err := domain.NewVisitSummary("s-1", "t-1", e,
		[]domain.Coding{{System: "icd-10", Code: "I21.9", Display: "MI"}},
		[]string{"doctor-1"}, "Seen with chest pain. Troponin raised.", "doctor-1", now)
	if err != nil {
		t.Fatalf("NewVisitSummary: %v", err)
	}
	if original.Version != 1 {
		t.Fatalf("version = %d, want 1", original.Version)
	}

	if _, err := original.Amend("s-2", "Corrected narrative.", "", "doctor-1", now); err == nil {
		t.Fatal("a summary was amended with no stated reason, which is a rewrite")
	}

	amended, err := original.Amend("s-2", "Corrected: troponin was normal.",
		"initial result was transcribed from the wrong patient", "doctor-1",
		now.Add(24*time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	if amended.Version != 2 || amended.SupersedesID != "s-1" {
		t.Fatalf("amended = v%d superseding %q, want v2 superseding s-1",
			amended.Version, amended.SupersedesID)
	}
	// The original is untouched: somebody acted on it.
	if original.Narrative != "Seen with chest pain. Troponin raised." {
		t.Fatal("amending the summary changed the version somebody already read")
	}
}
