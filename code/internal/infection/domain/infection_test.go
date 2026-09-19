package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
)

var (
	base     = time.Date(2026, 3, 2, 9, 0, 0, 0, time.UTC)
	admitted = time.Date(2026, 3, 1, 8, 0, 0, 0, time.UTC)
)

func mustCase(t *testing.T, id string, in domain.NewCaseInput) domain.SurveillanceCase {
	t.Helper()
	one, err := domain.OpenCase(id, "t1", in, 48, false, "ipc-1",
		base.AddDate(0, 0, 10))
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	return one
}

func wantRefused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !errors.Is(err, domain.ErrInvalidInfection) {
		t.Fatalf("want ErrInvalidInfection, got %v", err)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// SRS-IPC-001. The classification nobody types.
func TestOnsetIsDerivedFromTheDates(t *testing.T) {
	cases := []struct {
		name     string
		admitted time.Time
		onset    time.Time
		window   int
		want     domain.Onset
	}{
		{"symptoms before arrival", admitted, admitted.Add(-3 * time.Hour), 48,
			domain.OnsetCommunity},
		{"inside the window", admitted, admitted.Add(47 * time.Hour), 48,
			domain.OnsetCommunity},
		{"exactly at the window", admitted, admitted.Add(48 * time.Hour), 48,
			domain.OnsetHealthcare},
		{"past the window", admitted, admitted.Add(96 * time.Hour), 48,
			domain.OnsetHealthcare},
		{"a longer window moves the boundary", admitted,
			admitted.Add(96 * time.Hour), 120, domain.OnsetCommunity},
		{"no admission date", time.Time{}, admitted, 48,
			domain.OnsetIndeterminate},
		{"no window configured", admitted, admitted.Add(96 * time.Hour), 0,
			domain.OnsetIndeterminate},
	}

	for _, one := range cases {
		t.Run(one.name, func(t *testing.T) {
			got := domain.Classify(one.admitted, one.onset, one.window)
			if got != one.want {
				t.Fatalf("Classify = %s, want %s", got, one.want)
			}
		})
	}
}

// SRS-IPC-001. A reclassification stays visible as a reclassification.
func TestAnOverrideNeverReplacesTheDerivedClassification(t *testing.T) {
	one := mustCase(t, "case-1", domain.NewCaseInput{
		PatientID: "p1", Organism: "MRSA", Site: domain.SiteBloodstream,
		AdmittedAt: admitted, OnsetAt: admitted.Add(96 * time.Hour),
	})
	if one.Onset != domain.OnsetHealthcare {
		t.Fatalf("derived onset = %s, want healthcare", one.Onset)
	}

	if err := one.OverrideOnset(domain.OnsetCommunity, "", "ipc-1"); err == nil {
		t.Fatal("an override with no reason was accepted")
	}
	if err := one.OverrideOnset(domain.OnsetHealthcare, "agreed", "ipc-1"); err == nil {
		t.Fatal("an override that changes nothing was accepted")
	}

	if err := one.OverrideOnset(domain.OnsetCommunity,
		"transferred in already infected", "ipc-1"); err != nil {
		t.Fatalf("OverrideOnset: %v", err)
	}
	if one.Onset != domain.OnsetHealthcare {
		t.Fatalf("the derivation was overwritten: %s", one.Onset)
	}
	if one.EffectiveOnset() != domain.OnsetCommunity {
		t.Fatalf("EffectiveOnset = %s, want the override",
			one.EffectiveOnset())
	}

	summary := domain.SummariseOnset([]domain.SurveillanceCase{one})
	if summary.Overridden != 1 || summary.OverriddenToCommunity != 1 {
		t.Fatalf("summary hides the reclassification: %+v", summary)
	}
	if summary.Healthcare != 0 || summary.Community != 1 {
		t.Fatalf("summary counts = %+v, want the effective classification",
			summary)
	}
}

// SRS-IPC-001. A numerator whose denominator the case never entered.
func TestADeviceAssociatedCaseNeedsTheDeviceInSitu(t *testing.T) {
	_, err := domain.OpenCase("case-2", "t1", domain.NewCaseInput{
		PatientID: "p1", Organism: "Pseudomonas", Site: domain.SiteVAP,
		AdmittedAt: admitted, OnsetAt: admitted.Add(96 * time.Hour),
	}, 48, false, "ipc-1", base.AddDate(0, 0, 10))
	wantRefused(t, err, "device-associated")

	if _, err := domain.OpenCase("case-2", "t1", domain.NewCaseInput{
		PatientID: "p1", Organism: "Pseudomonas", Site: domain.SiteVAP,
		AdmittedAt: admitted, OnsetAt: admitted.Add(96 * time.Hour),
		DeviceInSitu: true, DeviceDays: 4,
	}, 48, false, "ipc-1", base.AddDate(0, 0, 10)); err != nil {
		t.Fatalf("a ventilated patient was refused: %v", err)
	}
}

// SRS-IPC-001. A rate nobody can defend is not a rate.
func TestAJudgedCaseRetainsItsCriteriaAndReviewer(t *testing.T) {
	one := mustCase(t, "case-3", domain.NewCaseInput{
		PatientID: "p1", Organism: "E. coli", Site: domain.SiteUrinary,
		AdmittedAt: admitted, OnsetAt: admitted.Add(96 * time.Hour),
	})

	err := one.Review(domain.CaseConfirmed, "", "ipc-1", base)
	wantRefused(t, err, "judged against")

	err = one.Review(domain.CaseConfirmed, "CDC definition met", "", base)
	wantRefused(t, err, "reviewer")

	if err := one.Review(domain.CaseConfirmed, "CDC definition met",
		"ipc-1", base); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if one.Criteria == "" || one.ReviewedBy != "ipc-1" {
		t.Fatalf("criteria and reviewer not retained: %+v", one)
	}
}

// SRS-IPC-002. Denominators are counted, not estimated.
func TestADayCannotHaveMoreDeviceDaysThanPatients(t *testing.T) {
	_, err := domain.NewDeviceDayCount("c1", "t1", "f1", "icu",
		domain.DeviceVentilator, base, 12, 14, "nurse-1", base)
	wantRefused(t, err, "exceeds")
}

// SRS-IPC-002, SRS-IPC-010. What a rate counts and what it refuses to claim.
func TestARateCountsConfirmedHealthcareAssociatedCasesOnly(t *testing.T) {
	from := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	to := from.AddDate(0, 1, 0)
	now := to.AddDate(0, 0, 1)

	open := func(id string, onset time.Time, state domain.CaseState,
		community bool) domain.SurveillanceCase {

		one, err := domain.OpenCase(id, "t1", domain.NewCaseInput{
			PatientID: id, LocationID: "icu", Organism: "Klebsiella",
			Site: domain.SiteCLABSI, AdmittedAt: from, OnsetAt: onset,
			DeviceInSitu: true,
		}, 48, false, "ipc-1", now)
		if err != nil {
			t.Fatalf("OpenCase: %v", err)
		}
		if state != domain.CaseSuspected {
			if err := one.Review(state, "definition", "ipc-1", now); err != nil {
				t.Fatalf("Review: %v", err)
			}
		}
		if community {
			if err := one.OverrideOnset(domain.OnsetCommunity,
				"known positive on transfer", "ipc-1"); err != nil {
				t.Fatalf("OverrideOnset: %v", err)
			}
		}
		return one
	}

	cases := []domain.SurveillanceCase{
		open("a", from.Add(96*time.Hour), domain.CaseConfirmed, false),
		open("b", from.Add(200*time.Hour), domain.CaseConfirmed, false),
		// Not counted: still suspected, reclassified, and out of period.
		open("c", from.Add(300*time.Hour), domain.CaseSuspected, false),
		open("d", from.Add(400*time.Hour), domain.CaseConfirmed, true),
		open("e", to.Add(24*time.Hour), domain.CaseConfirmed, false),
	}

	var counts []domain.DeviceDayCount
	for day := 0; day < 30; day++ {
		count, err := domain.NewDeviceDayCount("d", "t1", "f1", "icu",
			domain.DeviceCentralLine, from.AddDate(0, 0, day),
			20, 10, "nurse-1", now)
		if err != nil {
			t.Fatalf("NewDeviceDayCount: %v", err)
		}
		counts = append(counts, count)
	}

	rate := domain.ComputeRate(domain.RateInput{
		Site: domain.SiteCLABSI, Location: "icu", From: from, To: to,
		Cases: cases, Counts: counts,
	})

	if rate.Infections != 2 {
		t.Fatalf("infections = %d, want 2 (confirmed, healthcare, in period)",
			rate.Infections)
	}
	if rate.DeviceDays != 300 || rate.PatientDays != 600 {
		t.Fatalf("denominators = %d/%d, want 300/600",
			rate.DeviceDays, rate.PatientDays)
	}
	// 2 × 1000 / 300 = 6.67 per 1000 device days, in tenths.
	if rate.PerThousandDeviceDays != 67 {
		t.Fatalf("rate = %d tenths, want 67", rate.PerThousandDeviceDays)
	}
	if rate.UtilisationPermille != 500 {
		t.Fatalf("utilisation = %d permille, want 500",
			rate.UtilisationPermille)
	}
	if rate.Unanswerable {
		t.Fatal("a period with device days reported itself unanswerable")
	}
}

// SRS-IPC-002. "No ventilated patients" is not "no infections".
func TestAPeriodWithNoDeviceDaysHasNoRate(t *testing.T) {
	from := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	rate := domain.ComputeRate(domain.RateInput{
		Site: domain.SiteVAP, From: from, To: from.AddDate(0, 1, 0),
	})
	if !rate.Unanswerable {
		t.Fatal("a period with no denominator reported a rate")
	}
	if rate.PerThousandDeviceDays != 0 {
		t.Fatalf("rate = %d, want no rate at all",
			rate.PerThousandDeviceDays)
	}
}

// SRS-IPC-003, SRS-OPSSEC-006. The board says what to wear, never why.
func TestTheBedBoardCarriesThePrecautionAndNotTheReason(t *testing.T) {
	isolation, err := domain.StartIsolation("iso-1", "t1",
		domain.NewIsolationInput{
			PatientID: "p1", LocationID: "ward-a", BedID: "bed-3",
			Precaution: domain.PrecautionAirborne,
			Reason:     "sputum smear positive tuberculosis",
		}, 48*time.Hour, "ipc-1", base)
	if err != nil {
		t.Fatalf("StartIsolation: %v", err)
	}

	board := domain.Board([]domain.Isolation{isolation}, "ward-a", base)
	if len(board) != 1 {
		t.Fatalf("board = %d entries, want 1", len(board))
	}
	entry := board[0]
	if entry.Precaution != domain.PrecautionAirborne || !entry.RequiresSideRoom {
		t.Fatalf("board entry lost the precaution: %+v", entry)
	}
	if len(entry.PPE) == 0 {
		t.Fatal("board entry names no PPE")
	}
	// The reason is a diagnosis and the board is a screen on a wall.
	for _, field := range append([]string{entry.BedID, entry.LocationID,
		entry.PatientID, string(entry.Precaution)}, entry.PPE...) {
		if strings.Contains(strings.ToLower(field), "tuberculosis") {
			t.Fatalf("the board carries the reason: %q", field)
		}
	}
}

// SRS-IPC-003. Isolation that nobody reviews outlives its reason.
func TestIsolationCarriesAReviewDateAndLiftingItNeedsAReason(t *testing.T) {
	isolation, err := domain.StartIsolation("iso-2", "t1",
		domain.NewIsolationInput{
			PatientID: "p1", LocationID: "ward-a",
			Precaution: domain.PrecautionContact, Reason: "CPE colonised",
		}, 48*time.Hour, "ipc-1", base)
	if err != nil {
		t.Fatalf("StartIsolation: %v", err)
	}

	overdue := base.Add(72 * time.Hour)
	if board := domain.Board([]domain.Isolation{isolation}, "ward-a",
		overdue); !board[0].ReviewOverdue {
		t.Fatal("a precaution nobody reviewed for three days is not overdue")
	}

	if err := isolation.Extend(48*time.Hour, overdue); err != nil {
		t.Fatalf("Extend: %v", err)
	}
	if board := domain.Board([]domain.Isolation{isolation}, "ward-a",
		overdue); board[0].ReviewOverdue {
		t.Fatal("a reconsidered precaution is still overdue")
	}

	err = isolation.EndIsolation("", "ipc-1", overdue)
	wantRefused(t, err, "why")
	if err := isolation.EndIsolation("two negative screens", "ipc-1",
		overdue); err != nil {
		t.Fatalf("EndIsolation: %v", err)
	}
	if isolation.Active(overdue.Add(time.Hour)) {
		t.Fatal("precautions are still active after being lifted")
	}
}

// SRS-IPC-004. An alert has to stay explicable after the rule changes.
func TestAnAlertNamesTheRuleRevisionItFiredUnder(t *testing.T) {
	rule, err := domain.NewAlertRule("rule-1", "t1", domain.NewRuleInput{
		Code: "MDRO-CPE", Name: "Carbapenemase-producing organisms",
		Revision: 3, Organisms: []string{"CPE"}, LookbackDays: 365,
		Precaution: domain.PrecautionContact, Advice: "side room",
	}, "ipc-author", base)
	if err != nil {
		t.Fatalf("NewAlertRule: %v", err)
	}

	// An unapproved rule is not the hospital's alerting.
	_, err = domain.RaiseAlert("alert-1", "t1", rule, "p1", "enc-1", "f1",
		"CPE", "CPE", base.AddDate(0, 0, -30), base)
	wantRefused(t, err, "not approved")

	err = rule.Approve("ipc-author", base, base)
	wantRefused(t, err, "author")

	if err := rule.Approve("ipc-lead", base, base); err != nil {
		t.Fatalf("Approve: %v", err)
	}

	alert, err := domain.RaiseAlert("alert-1", "t1", rule, "p1", "enc-1", "f1",
		"CPE", "CPE", base.AddDate(0, 0, -30), base.Add(time.Hour))
	if err != nil {
		t.Fatalf("RaiseAlert: %v", err)
	}
	if alert.RuleCode != "MDRO-CPE" || alert.RuleRevision != 3 {
		t.Fatalf("alert does not pin its rule version: %+v", alert)
	}
	if alert.Precaution != domain.PrecautionContact {
		t.Fatalf("alert = %s, want the rule's precaution", alert.Precaution)
	}

	// Outside the rule's lookback is a patient the rule chose not to alert on.
	_, err = domain.RaiseAlert("alert-2", "t1", rule, "p1", "enc-1", "f1",
		"CPE", "CPE", base.AddDate(-3, 0, 0), base.Add(time.Hour))
	wantRefused(t, err, "lookback")
}

// SRS-IPC-004. An override is audited.
func TestAnOverriddenAlertSaysWhoAndWhy(t *testing.T) {
	rule, err := domain.NewAlertRule("rule-2", "t1", domain.NewRuleInput{
		Code: "MDRO-MRSA", Revision: 1, Organisms: []string{"MRSA"},
		LookbackDays: 180, Precaution: domain.PrecautionContact,
	}, "ipc-author", base)
	if err != nil {
		t.Fatalf("NewAlertRule: %v", err)
	}
	if err := rule.Approve("ipc-lead", base, base); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	alert, err := domain.RaiseAlert("alert-3", "t1", rule, "p1", "enc-1", "f1",
		"MRSA", "MRSA", base.AddDate(0, 0, -10), base.Add(time.Hour))
	if err != nil {
		t.Fatalf("RaiseAlert: %v", err)
	}

	err = alert.Override("", "nurse-1", base.Add(2*time.Hour))
	wantRefused(t, err, "why")

	if err := alert.Override("decolonised, three negative screens", "nurse-1",
		base.Add(2*time.Hour)); err != nil {
		t.Fatalf("Override: %v", err)
	}
	if !alert.Overridden || alert.OverriddenBy != "nurse-1" ||
		alert.OverrideWhy == "" {
		t.Fatalf("override not audited: %+v", alert)
	}
}

// SRS-IPC-005. A cluster's size is a set of decisions somebody made.
func TestClusterMembershipIsTraceableInBothDirections(t *testing.T) {
	from := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	outbreak, err := domain.OpenOutbreak("ob-1", "t1",
		domain.NewOutbreakInput{
			Reference: "OB-2026-01", Organism: "Norovirus",
			CaseDefinition: "diarrhoea and vomiting on ward A",
			Locations:      []string{"ward-a"},
			WindowFrom:     from, WindowTo: from.AddDate(0, 0, 14),
		}, "ipc-1", base)
	if err != nil {
		t.Fatalf("OpenOutbreak: %v", err)
	}

	inside := mustCase(t, "case-in", domain.NewCaseInput{
		PatientID: "p1", LocationID: "ward-a", Organism: "Norovirus",
		Site: domain.SiteGastro, AdmittedAt: from,
		OnsetAt: from.AddDate(0, 0, 3),
	})
	outside := mustCase(t, "case-out", domain.NewCaseInput{
		PatientID: "p2", LocationID: "ward-b", Organism: "Norovirus",
		Site: domain.SiteGastro, AdmittedAt: from,
		OnsetAt: from.AddDate(0, 0, 4),
	})

	if !outbreak.Matches(inside) {
		t.Fatal("a case inside the window and location does not match")
	}
	if outbreak.Matches(outside) {
		t.Fatal("a case on another ward matches the definition")
	}

	// A case that does not meet the definition cannot be waved in as one.
	_, err = domain.AddMember("m1", "t1", outbreak.ID, outside.ID, "p2",
		domain.MemberMeetsDefinition, "", false, "ipc-1", base)
	wantRefused(t, err, "outside the investigation")

	// It can be linked, with a reason.
	_, err = domain.AddMember("m1", "t1", outbreak.ID, outside.ID, "p2",
		domain.MemberEpidemiologicalLink, "", false, "ipc-1", base)
	wantRefused(t, err, "why")

	linked, err := domain.AddMember("m1", "t1", outbreak.ID, outside.ID, "p2",
		domain.MemberEpidemiologicalLink, "transferred from ward A on day 2",
		false, "ipc-1", base)
	if err != nil {
		t.Fatalf("AddMember: %v", err)
	}
	member, err := domain.AddMember("m2", "t1", outbreak.ID, inside.ID, "p1",
		domain.MemberMeetsDefinition, "", true, "ipc-1", base)
	if err != nil {
		t.Fatalf("AddMember: %v", err)
	}

	// Removing one that does meet the definition is also a judgement.
	_, err = domain.AddMember("m3", "t1", outbreak.ID, "case-third", "p3",
		domain.MemberExcluded, "", true, "ipc-1", base)
	wantRefused(t, err, "why")
	excluded, err := domain.AddMember("m3", "t1", outbreak.ID, "case-third",
		"p3", domain.MemberExcluded, "laboratory reported a different strain",
		true, "ipc-1", base)
	if err != nil {
		t.Fatalf("AddMember: %v", err)
	}

	summary := domain.Summarise(outbreak,
		[]domain.Membership{member, linked, excluded},
		map[string]domain.SurveillanceCase{
			inside.ID: inside, outside.ID: outside,
		})
	if summary.Included != 2 || summary.Excluded != 1 || summary.ByLink != 1 {
		t.Fatalf("cluster summary = %+v, want 2 in, 1 out, 1 by link", summary)
	}
}

// SRS-IPC-005. A declared outbreak that changed nothing is not closed.
func TestADeclaredOutbreakCannotCloseHavingChangedNothing(t *testing.T) {
	from := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	outbreak, err := domain.OpenOutbreak("ob-2", "t1",
		domain.NewOutbreakInput{
			Organism: "Norovirus", CaseDefinition: "D&V on ward A",
			Locations: []string{"ward-a"}, WindowFrom: from,
			WindowTo: from.AddDate(0, 0, 14),
		}, "ipc-1", base)
	if err != nil {
		t.Fatalf("OpenOutbreak: %v", err)
	}

	// Never declared: refuted, not closed.
	err = outbreak.CloseOutbreak("nothing found", "no cluster", "ipc-1", base)
	wantRefused(t, err, "never declared")

	if err := outbreak.Advance(domain.OutbreakDeclared, "six cases", "ipc-1",
		base); err != nil {
		t.Fatalf("Advance: %v", err)
	}
	err = outbreak.CloseOutbreak("six cases, one ward", "resolved", "ipc-1",
		base.AddDate(0, 0, 10))
	wantRefused(t, err, "changed nothing")

	outbreak.ControlMeasures = []string{"ward closed to admissions",
		"enhanced cleaning"}
	if err := outbreak.CloseOutbreak("six cases, one ward", "resolved",
		"ipc-1", base.AddDate(0, 0, 10)); err != nil {
		t.Fatalf("CloseOutbreak: %v", err)
	}
	if outbreak.State != domain.OutbreakClosed || outbreak.Findings == "" {
		t.Fatalf("outbreak not closed with findings: %+v", outbreak)
	}
}

// SRS-IPC-006. There is no person to aggregate by, and small groups are
// suppressed with their counts.
func TestHandHygieneReportsNameNobodyAndSuppressSmallGroups(t *testing.T) {
	session, err := domain.NewSession("s1", "t1", "f1", "ward-a", "auditor-1",
		base, "monthly audit", base)
	if err != nil {
		t.Fatalf("NewSession: %v", err)
	}

	observe := func(id string, discipline domain.Discipline,
		action domain.Action, gloves bool) domain.HygieneObservation {

		one, err := domain.NewObservation(id, "t1", session.ID, discipline,
			domain.MomentBeforePatient, action, gloves, base)
		if err != nil {
			t.Fatalf("NewObservation: %v", err)
		}
		return one
	}

	observations := []domain.HygieneObservation{
		observe("o1", domain.DisciplineNurse, domain.ActionRub, false),
		observe("o2", domain.DisciplineNurse, domain.ActionWash, false),
		observe("o3", domain.DisciplineNurse, domain.ActionRub, false),
		observe("o4", domain.DisciplineNurse, domain.ActionMissed, false),
		observe("o5", domain.DisciplineNurse, domain.ActionGlovesOnly, true),
		observe("o6", domain.DisciplineDoctor, domain.ActionMissed, false),
		observe("o7", domain.DisciplineDoctor, domain.ActionRub, false),
	}

	report := domain.Compliances(domain.ComplianceInput{
		Observations: observations, By: "discipline",
		MinimumOpportunities: 5,
	})
	if len(report) != 2 {
		t.Fatalf("report = %d groups, want 2", len(report))
	}

	byGroup := map[string]domain.Compliance{}
	for _, group := range report {
		byGroup[group.Group] = group
	}

	nurses := byGroup[string(domain.DisciplineNurse)]
	if nurses.Opportunities != 5 || nurses.Performed != 3 {
		t.Fatalf("nurses = %+v, want 3 of 5", nurses)
	}
	if nurses.Permille != 600 {
		t.Fatalf("nurse compliance = %d permille, want 600", nurses.Permille)
	}
	if nurses.GlovesInsteadOf != 1 {
		t.Fatalf("gloves-instead-of = %d, want 1 counted separately",
			nurses.GlovesInsteadOf)
	}

	doctors := byGroup[string(domain.DisciplineDoctor)]
	if !doctors.Suppressed {
		t.Fatal("a group of two was published")
	}
	if doctors.Opportunities != 0 || doctors.Performed != 0 ||
		doctors.Permille != 0 {
		t.Fatalf("suppressed group still carries its counts: %+v", doctors)
	}
}

// SRS-IPC-007. A source patient's blood is not tested on the hospital's say-so.
func TestAnExposureNamingASourcePatientNeedsRecordedConsent(t *testing.T) {
	in := domain.NewExposureInput{
		StaffID: "staff-1", Discipline: domain.DisciplineNurse,
		Kind: domain.ExposureNeedlestick, Circumstance: "recapping a cannula",
		SourcePatientID: "p1", SourceKnown: true, OccurredAt: base,
	}
	_, err := domain.ReportExposure("exp-1", "t1", in, "staff-1",
		base.Add(time.Hour))
	wantRefused(t, err, "consent")

	in.SourceConsented = true
	if _, err := domain.ReportExposure("exp-1", "t1", in, "staff-1",
		base.Add(time.Hour)); err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}
}

// SRS-IPC-007. The clock runs from the exposure, not from the report.
func TestTheProphylaxisClockRunsFromTheExposure(t *testing.T) {
	exposure, err := domain.ReportExposure("exp-2", "t1",
		domain.NewExposureInput{
			StaffID: "staff-1", Kind: domain.ExposureNeedlestick,
			Circumstance: "sharps bin overfull", OccurredAt: base,
			SourceKnown: true, SourcePatientID: "p1", SourceConsented: true,
		}, "staff-1", base.Add(30*time.Hour))
	if err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}

	next := 0
	tasks := domain.ExposureTasks(exposure, func() string {
		next++
		return "task"
	})

	byCode := map[string]domain.ExposureTask{}
	for _, task := range tasks {
		byCode[task.Code] = task
	}
	prophylaxis, ok := byCode[domain.TaskProphylaxis]
	if !ok {
		t.Fatalf("no prophylaxis step among %d tasks", len(tasks))
	}
	if want := base.Add(72 * time.Hour); !prophylaxis.DueBy.Equal(want) {
		t.Fatalf("prophylaxis due %s, want %s from the exposure",
			prophylaxis.DueBy, want)
	}
	// Reported a day and a bit late: the window is already 30 hours smaller,
	// not restarted.
	if !prophylaxis.DueBy.Before(exposure.ReportedAt.Add(72 * time.Hour)) {
		t.Fatal("a late report bought a fresh 72 hours")
	}
	if _, ok := byCode[domain.TaskSourceTesting]; !ok {
		t.Fatal("a known source raised no source-testing step")
	}

	// A splash to the eye is percutaneous risk; an airborne contact is not.
	airborne := exposure
	airborne.Kind = domain.ExposureAirborne
	if got := len(domain.ExposureTasks(airborne, func() string { return "t" })); got != 1 {
		t.Fatalf("airborne exposure raised %d tasks, want assessment only", got)
	}
}

// SRS-IPC-007. An exposure closed with prophylaxis outstanding is a member of
// staff nobody followed up.
func TestAnExposureCannotCloseWhileAStepIsStillInItsWindow(t *testing.T) {
	exposure, err := domain.ReportExposure("exp-3", "t1",
		domain.NewExposureInput{
			StaffID: "staff-1", Kind: domain.ExposureSharps,
			Circumstance: "blade passed hand to hand", OccurredAt: base,
		}, "staff-1", base.Add(time.Hour))
	if err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}
	next := 0
	tasks := domain.ExposureTasks(exposure, func() string {
		next++
		return string(rune('a' + next))
	})

	err = exposure.CloseExposure(tasks, "no seroconversion", "occ-health-1",
		base.Add(4*time.Hour))
	wantRefused(t, err, "still within their window")

	// Every step answered closes it.
	for i := range tasks {
		if err := tasks[i].Complete(domain.TaskDone, "done", "occ-health-1",
			base.Add(4*time.Hour)); err != nil {
			t.Fatalf("Complete: %v", err)
		}
	}
	if err := exposure.CloseExposure(tasks, "no seroconversion",
		"occ-health-1", base.Add(4*time.Hour)); err != nil {
		t.Fatalf("CloseExposure: %v", err)
	}

	// A step past its window does not hold an exposure open for ever.
	late, err := domain.ReportExposure("exp-4", "t1",
		domain.NewExposureInput{
			StaffID: "staff-2", Kind: domain.ExposureSharps,
			Circumstance: "suture needle", OccurredAt: base,
		}, "staff-2", base.Add(time.Hour))
	if err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}
	lateTasks := domain.ExposureTasks(late, func() string { return "t" })
	if err := late.CloseExposure(lateTasks, "declined follow-up, windows past",
		"occ-health-1", base.AddDate(1, 0, 0)); err != nil {
		t.Fatalf("CloseExposure over expired windows: %v", err)
	}
}

func liveStewardshipRule(t *testing.T, in domain.NewStewardshipRuleInput,
) domain.StewardshipRule {
	t.Helper()
	rule, err := domain.NewStewardshipRule("rule-"+in.Code, "t1", in,
		"amt-author", base)
	if err != nil {
		t.Fatalf("NewStewardshipRule(%s): %v", in.Code, err)
	}
	if err := rule.Approve("amt-lead", base, base); err != nil {
		t.Fatalf("Approve(%s): %v", in.Code, err)
	}
	return rule
}

// SRS-IPC-008. Each trigger fires on what it was configured for.
func TestStewardshipTriggersFireOnWhatTheyWereConfiguredFor(t *testing.T) {
	rules := []domain.StewardshipRule{
		liveStewardshipRule(t, domain.NewStewardshipRuleInput{
			Code: "RESTRICTED", Revision: 1,
			Kind: domain.TriggerRestrictedAgent, AllAgents: true,
			Prompt: "is the restricted agent still indicated?",
		}),
		liveStewardshipRule(t, domain.NewStewardshipRuleInput{
			Code: "DAY3", Revision: 1, Kind: domain.TriggerDuration,
			AllAgents: true, DayThreshold: 3,
			Prompt: "day three review: stop, narrow or continue?",
		}),
		liveStewardshipRule(t, domain.NewStewardshipRuleInput{
			Code: "MISMATCH", Revision: 1, Kind: domain.TriggerMismatch,
			AllAgents: true, Prompt: "the organism is resistant to this",
		}),
		liveStewardshipRule(t, domain.NewStewardshipRuleInput{
			Code: "IVPO", Revision: 1, Kind: domain.TriggerIVToOral,
			AllAgents: true, DayThreshold: 2,
			Prompt: "can this switch to oral?",
		}),
		liveStewardshipRule(t, domain.NewStewardshipRuleInput{
			Code: "ANAEROBES", Revision: 1,
			Kind:   domain.TriggerRedundantCover,
			Agents: []string{"metronidazole", "piperacillin-tazobactam"},
			Prompt: "two agents cover anaerobes here",
		}),
	}

	signal := domain.TherapySignal{
		PatientID: "p1", EncounterID: "enc-1", LocationID: "ward-a",
		Therapy: []domain.AgentInUse{
			{OrderID: "ord-1", Agent: "piperacillin-tazobactam", Route: "IV",
				DayOfTherapy: 4, Restricted: true},
			{OrderID: "ord-2", Agent: "metronidazole", Route: "IV",
				DayOfTherapy: 4},
		},
		Culture: &domain.CultureResult{
			Organism: "E. coli", Susceptible: []string{"co-amoxiclav"},
			Resistant: []string{"metronidazole"},
		},
		OralRouteAvailable: true,
	}

	fired := map[string]int{}
	for _, trigger := range domain.TriggeredRules(rules, signal,
		base.Add(time.Hour)) {
		fired[trigger.RuleCode]++
	}

	want := map[string]int{
		"RESTRICTED": 1, // only the one marked restricted
		"DAY3":       2, // both agents are on day 4
		"MISMATCH":   1, // the organism is resistant to metronidazole only
		"IVPO":       2, // both intravenous, patient taking oral
		"ANAEROBES":  1, // one trigger for the pair, not one each
	}
	for code, count := range want {
		if fired[code] != count {
			t.Fatalf("rule %s fired %d times, want %d (all: %v)",
				code, fired[code], count, fired)
		}
	}

	// A de-escalation rule with no culture back asks a question nobody can
	// answer, so it does not ask.
	deEscalation := liveStewardshipRule(t, domain.NewStewardshipRuleInput{
		Code: "DEESC", Revision: 1, Kind: domain.TriggerDeEscalation,
		AllAgents: true, DayThreshold: 3, Prompt: "narrow to the sensitivity",
	})
	blind := signal
	blind.Culture = nil
	if got := domain.TriggeredRules([]domain.StewardshipRule{deEscalation},
		blind, base.Add(time.Hour)); len(got) != 0 {
		t.Fatalf("de-escalation fired with no culture: %+v", got)
	}
	if got := domain.TriggeredRules([]domain.StewardshipRule{deEscalation},
		signal, base.Add(time.Hour)); len(got) != 2 {
		t.Fatalf("de-escalation fired %d times with a culture back, want 2",
			len(got))
	}
}

// SRS-IPC-008. A rule widens to everything only when it says so.
func TestAStewardshipRuleWatchesEverythingOnlyWhenItSaysSo(t *testing.T) {
	_, err := domain.NewStewardshipRule("rule-x", "t1",
		domain.NewStewardshipRuleInput{
			Code: "EMPTY", Revision: 1, Kind: domain.TriggerDuration,
			DayThreshold: 3, Prompt: "review",
		}, "amt-author", base)
	wantRefused(t, err, "watches all of them")

	_, err = domain.NewStewardshipRule("rule-y", "t1",
		domain.NewStewardshipRuleInput{
			Code: "PAIR", Revision: 1, Kind: domain.TriggerRedundantCover,
			Agents: []string{"metronidazole"}, Prompt: "double cover",
		}, "amt-author", base)
	wantRefused(t, err, "at least two agents")

	_, err = domain.NewStewardshipRule("rule-z", "t1",
		domain.NewStewardshipRuleInput{
			Code: "NODAY", Revision: 1, Kind: domain.TriggerDuration,
			AllAgents: true, Prompt: "review",
		}, "amt-author", base)
	wantRefused(t, err, "day it starts asking")

	narrow := liveStewardshipRule(t, domain.NewStewardshipRuleInput{
		Code: "MERO", Revision: 1, Kind: domain.TriggerRestrictedAgent,
		Agents: []string{"meropenem"}, Prompt: "still indicated?",
	})
	signal := domain.TherapySignal{
		PatientID: "p1",
		Therapy: []domain.AgentInUse{
			{Agent: "amoxicillin", Restricted: true},
		},
	}
	if got := domain.TriggeredRules([]domain.StewardshipRule{narrow}, signal,
		base.Add(time.Hour)); len(got) != 0 {
		t.Fatalf("a rule watching meropenem fired on amoxicillin: %+v", got)
	}
}

// SRS-IPC-008. Re-evaluating hourly must not raise the same review hourly.
func TestTheSameTriggerDoesNotRaiseASecondReview(t *testing.T) {
	trigger := domain.Trigger{
		RuleID: "rule-1", RuleCode: "DAY3", RuleRevision: 1,
		Kind: domain.TriggerDuration, Agent: "meropenem",
		Why: "meropenem is on day 3",
	}
	signal := domain.TherapySignal{PatientID: "p1", EncounterID: "enc-1"}

	review, err := domain.RaiseReview("rev-1", "t1", trigger, signal,
		base.Add(24*time.Hour), base)
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}
	if !domain.AlreadyOpen([]domain.StewardshipReview{review}, trigger,
		"enc-1") {
		t.Fatal("the same trigger would raise a second review")
	}
	if domain.AlreadyOpen([]domain.StewardshipReview{review}, trigger,
		"enc-2") {
		t.Fatal("a review on one encounter suppressed another patient's")
	}

	// A revised rule asks a new question, and that one is worth asking.
	revised := trigger
	revised.RuleRevision = 2
	if domain.AlreadyOpen([]domain.StewardshipReview{review}, revised,
		"enc-1") {
		t.Fatal("a revised rule was suppressed by the old revision's review")
	}
}

// SRS-IPC-008. The review advises; a prescriber decides.
func TestTheReviewerCannotRecordThePrescribersResponse(t *testing.T) {
	review, err := domain.RaiseReview("rev-2", "t1", domain.Trigger{
		RuleCode: "MISMATCH", RuleRevision: 1,
		Kind: domain.TriggerMismatch, Agent: "metronidazole",
	}, domain.TherapySignal{PatientID: "p1", EncounterID: "enc-1"},
		base.Add(4*time.Hour), base)
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}

	err = review.RecordResponse(domain.ResponseAccepted, "", "dr-1", base)
	wantRefused(t, err, "not been advised on")

	err = review.Advise(domain.RecommendNarrow, "", "pharm-1", base)
	wantRefused(t, err, "what the recommendation is")

	if err := review.Advise(domain.RecommendNarrow,
		"stop metronidazole, the organism is resistant", "pharm-1",
		base.Add(time.Hour)); err != nil {
		t.Fatalf("Advise: %v", err)
	}
	if review.State != domain.ReviewAdvised {
		t.Fatalf("state = %s, want advised", review.State)
	}

	err = review.RecordResponse(domain.ResponseAccepted, "", "pharm-1",
		base.Add(2*time.Hour))
	wantRefused(t, err, "reviewer cannot record")

	err = review.RecordResponse(domain.ResponseDeclined, "", "dr-1",
		base.Add(2*time.Hour))
	wantRefused(t, err, "why the advice was declined")

	if err := review.RecordResponse(domain.ResponseDeclined,
		"treating a second organism", "dr-1",
		base.Add(2*time.Hour)); err != nil {
		t.Fatalf("RecordResponse: %v", err)
	}
	if review.State != domain.ReviewClosed || review.RespondedBy != "dr-1" {
		t.Fatalf("response not recorded: %+v", review)
	}
}

// SRS-IPC-008, SRS-IPC-010. Modified advice is neither accepted nor refused.
func TestStewardshipIndicatorsDoNotFlatterThemselves(t *testing.T) {
	advise := func(id string, response domain.Response) domain.StewardshipReview {
		review, err := domain.RaiseReview(id, "t1", domain.Trigger{
			RuleCode: "DAY3", RuleRevision: 1, Kind: domain.TriggerDuration,
			Agent: "meropenem",
		}, domain.TherapySignal{PatientID: id, EncounterID: id},
			base.Add(24*time.Hour), base)
		if err != nil {
			t.Fatalf("RaiseReview: %v", err)
		}
		if err := review.Advise(domain.RecommendStop, "stop on day 5",
			"pharm-1", base.Add(time.Hour)); err != nil {
			t.Fatalf("Advise: %v", err)
		}
		if err := review.RecordResponse(response, "clinical judgement", "dr-1",
			base.Add(2*time.Hour)); err != nil {
			t.Fatalf("RecordResponse: %v", err)
		}
		return review
	}

	pending, err := domain.RaiseReview("rev-open", "t1", domain.Trigger{
		RuleCode: "DAY3", RuleRevision: 1, Kind: domain.TriggerDuration,
		Agent: "meropenem",
	}, domain.TherapySignal{PatientID: "p9", EncounterID: "enc-9"},
		base.Add(4*time.Hour), base)
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}

	reviews := []domain.StewardshipReview{
		advise("r1", domain.ResponseAccepted),
		advise("r2", domain.ResponseAccepted),
		advise("r3", domain.ResponseModified),
		advise("r4", domain.ResponseDeclined),
		pending,
	}

	summary := domain.SummariseStewardship(reviews, base.Add(6*time.Hour))
	if summary.Raised != 5 || summary.Awaiting != 1 || summary.Overdue != 1 {
		t.Fatalf("summary = %+v, want 5 raised, 1 awaiting and overdue",
			summary)
	}
	if summary.Accepted != 2 || summary.Modified != 1 || summary.Declined != 1 {
		t.Fatalf("summary responses = %+v", summary)
	}
	// Two accepted out of four responses, with "modified" in the denominator
	// and not the numerator.
	if summary.AcceptancePermille != 500 {
		t.Fatalf("acceptance = %d permille, want 500",
			summary.AcceptancePermille)
	}
	if summary.ByKind[domain.TriggerDuration] != 5 {
		t.Fatalf("by kind = %v", summary.ByKind)
	}
}

// SRS-IPC-008, SRS-IPC-010. No responses is not universal refusal.
func TestAProgrammeWithNoResponsesHasNoAcceptanceRate(t *testing.T) {
	summary := domain.SummariseStewardship(nil, base)
	if !summary.Unanswerable || summary.AcceptancePermille != 0 {
		t.Fatalf("summary = %+v, want unanswerable", summary)
	}

	rate, err := domain.ComputeTherapyRate(120, 0)
	if err != nil {
		t.Fatalf("ComputeTherapyRate: %v", err)
	}
	if !rate.Unanswerable {
		t.Fatal("a ward with no patient days reported a therapy rate")
	}

	rate, err = domain.ComputeTherapyRate(120, 400)
	if err != nil {
		t.Fatalf("ComputeTherapyRate: %v", err)
	}
	// 120 / 400 × 1000 = 300 days of therapy per 1000 patient days.
	if rate.PerThousandTenths != 3000 {
		t.Fatalf("therapy rate = %d tenths, want 3000",
			rate.PerThousandTenths)
	}
}

func liveLimit(t *testing.T, in domain.NewLimitInput) domain.EnvironmentalLimit {
	t.Helper()
	limit, err := domain.NewEnvironmentalLimit("limit-"+in.Code, "t1", in,
		"ipc-author", base)
	if err != nil {
		t.Fatalf("NewEnvironmentalLimit(%s): %v", in.Code, err)
	}
	if err := limit.Approve("ipc-lead", in.EffectiveFrom, base); err != nil {
		t.Fatalf("Approve(%s): %v", in.Code, err)
	}
	return limit
}

// SRS-IPC-009. The outcome comes from the limit in force when it was reported.
func TestAnEnvironmentalOutcomeIsDerivedFromTheLimitInForce(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	june := time.Date(2026, 6, 1, 0, 0, 0, 0, time.UTC)

	old := liveLimit(t, domain.NewLimitInput{
		Code: "WATER-1", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 100, FailLevel: 1000,
		EffectiveFrom: march,
	})
	loosened := liveLimit(t, domain.NewLimitInput{
		Code: "WATER-1", Revision: 2, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 5000, FailLevel: 10000,
		EffectiveFrom: june,
	})
	limits := []domain.EnvironmentalLimit{old, loosened}

	sample, err := domain.CollectSample("smp-1", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, FacilityID: "f1", LocationID: "ward-a",
		SamplePoint: "sluice tap", CollectedAt: march.AddDate(0, 0, 3),
	}, "estates-1", march.AddDate(0, 0, 3))
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := sample.RecordResult(domain.ResultInput{
		Value: 2000, Unit: "cfu/ml", ResultedAt: march.AddDate(0, 0, 5),
	}, limits, "lab-1", march.AddDate(0, 0, 5)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if sample.Outcome != domain.OutcomeFail {
		t.Fatalf("March sample = %s, want fail under March's limit",
			sample.Outcome)
	}
	if sample.LimitRevision != 1 {
		t.Fatalf("judged by revision %d, want the one in force",
			sample.LimitRevision)
	}

	// Same value after the limit was loosened: an action level, not a
	// failure — and the March result did not change with it.
	later, err := domain.CollectSample("smp-2", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: "ward-a",
		SamplePoint: "sluice tap", CollectedAt: june.AddDate(0, 0, 3),
	}, "estates-1", june.AddDate(0, 0, 3))
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := later.RecordResult(domain.ResultInput{
		Value: 6000, Unit: "cfu/ml", ResultedAt: june.AddDate(0, 0, 5),
	}, limits, "lab-1", june.AddDate(0, 0, 5)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if later.Outcome != domain.OutcomeAction || later.LimitRevision != 2 {
		t.Fatalf("June sample = %s under revision %d",
			later.Outcome, later.LimitRevision)
	}
	if sample.Outcome != domain.OutcomeFail {
		t.Fatal("the loosened limit rewrote a past failure")
	}
}

// SRS-IPC-009. Detection can fail on its own, and low can be the failure.
func TestALimitCanFailOnDetectionOrOnBeingTooLow(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)

	legionella := liveLimit(t, domain.NewLimitInput{
		Code: "LEGIONELLA", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/l", ActionLevel: 100, FailLevel: 1000,
		DetectionFails: true, EffectiveFrom: march,
	})
	if got := legionella.Assess(0, true); got != domain.OutcomeFail {
		t.Fatalf("a detection at zero count = %s, want fail", got)
	}
	if got := legionella.Assess(0, false); got != domain.OutcomePass {
		t.Fatalf("no detection = %s, want pass", got)
	}

	pressure := liveLimit(t, domain.NewLimitInput{
		Code: "NEG-PRESSURE", Revision: 1, SampleKind: domain.SamplePressure,
		Unit: "tenths_of_a_pascal", ActionLevel: -25, FailLevel: -50,
		BelowIsFailure: true, EffectiveFrom: march,
	})
	if got := pressure.Assess(-80, false); got != domain.OutcomeFail {
		t.Fatalf("a room at -8.0 Pa = %s, want fail", got)
	}
	if got := pressure.Assess(-30, false); got != domain.OutcomeAction {
		t.Fatalf("a room at -3.0 Pa = %s, want action level", got)
	}
	if got := pressure.Assess(-10, false); got != domain.OutcomePass {
		t.Fatalf("a room at -1.0 Pa = %s, want pass", got)
	}

	_, err := domain.NewEnvironmentalLimit("bad", "t1", domain.NewLimitInput{
		Code: "BACKWARDS", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 1000, FailLevel: 100,
	}, "ipc-author", base)
	wantRefused(t, err, "fail level sits above")

	// The same mistake in the other direction: where low is bad, a fail level
	// above the action level would make a reading both at once.
	_, err = domain.NewEnvironmentalLimit("bad-2", "t1", domain.NewLimitInput{
		Code: "BACKWARDS-LOW", Revision: 1, SampleKind: domain.SamplePressure,
		Unit: "tenths_of_a_pascal", ActionLevel: -50, FailLevel: -25,
		BelowIsFailure: true,
	}, "ipc-author", base)
	wantRefused(t, err, "below the action level")
}

// SRS-IPC-009. A sample nobody can judge is not a sample that passed.
func TestASampleWithNoLiveLimitIsUnassessable(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	sample, err := domain.CollectSample("smp-3", "t1", domain.NewSampleInput{
		Kind: domain.SampleAirSettle, LocationID: "theatre-1",
		SamplePoint: "table", CollectedAt: march,
	}, "ipc-1", march)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := sample.RecordResult(domain.ResultInput{
		Value: 4, Unit: "cfu/plate", ResultedAt: march.AddDate(0, 0, 1),
	}, nil, "lab-1", march.AddDate(0, 0, 1)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if sample.Outcome != domain.OutcomeUnassessable {
		t.Fatalf("outcome = %s, want unassessable", sample.Outcome)
	}

	summary := domain.SummariseEnvironment(
		[]domain.EnvironmentalSample{sample}, nil)
	if !summary.Unanswerable || summary.PassPermille != 0 {
		t.Fatalf("summary = %+v, want no pass rate at all", summary)
	}
	if summary.Unassessable != 1 {
		t.Fatalf("unassessable = %d, want 1", summary.Unassessable)
	}

	// A result in the wrong unit is not silently compared.
	other, err := domain.CollectSample("smp-4", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: "ward-a",
		SamplePoint: "tap", CollectedAt: march,
	}, "ipc-1", march)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	limit := liveLimit(t, domain.NewLimitInput{
		Code: "WATER-U", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 100, FailLevel: 1000,
		EffectiveFrom: march,
	})
	err = other.RecordResult(domain.ResultInput{
		Value: 500, Unit: "cfu/100ml", ResultedAt: march.AddDate(0, 0, 1),
	}, []domain.EnvironmentalLimit{limit}, "lab-1", march.AddDate(0, 0, 1))
	wantRefused(t, err, "cfu/100ml")
}

// SRS-IPC-009. Results link to location and corrective action.
func TestAFailingSampleClosesOnlyThroughAVerifiedAction(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	limit := liveLimit(t, domain.NewLimitInput{
		Code: "WATER-2", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 100, FailLevel: 1000,
		EffectiveFrom: march,
	})
	limits := []domain.EnvironmentalLimit{limit}

	// A sample needs a location and a point before anything else.
	_, err := domain.CollectSample("smp-x", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, SamplePoint: "tap", CollectedAt: march,
	}, "ipc-1", march)
	wantRefused(t, err, "location")
	_, err = domain.CollectSample("smp-x", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: "ward-a", CollectedAt: march,
	}, "ipc-1", march)
	wantRefused(t, err, "point")

	sample, err := domain.CollectSample("smp-5", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: "ward-a",
		SamplePoint: "bay 3 hand basin", CollectedAt: march,
	}, "ipc-1", march)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := sample.RecordResult(domain.ResultInput{
		Value: 4000, Unit: "cfu/ml", Organism: "Pseudomonas aeruginosa",
		Detected: true, ResultedAt: march.AddDate(0, 0, 2),
	}, limits, "lab-1", march.AddDate(0, 0, 2)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if sample.Outcome != domain.OutcomeFail {
		t.Fatalf("outcome = %s, want fail", sample.Outcome)
	}

	err = sample.CloseSample(nil, "ipc-1", march.AddDate(0, 0, 3))
	wantRefused(t, err, "corrective action")

	action, err := domain.RaiseCorrectiveAction("act-1", "t1", sample,
		"replace the tap outlet and flush", "estates-1",
		march.AddDate(0, 0, 7), march.AddDate(0, 0, 3))
	if err != nil {
		t.Fatalf("RaiseCorrectiveAction: %v", err)
	}

	err = sample.CloseSample([]domain.CorrectiveAction{action}, "ipc-1",
		march.AddDate(0, 0, 3))
	wantRefused(t, err, "still open")

	if err := action.MarkDone("outlet replaced", "estates-1",
		march.AddDate(0, 0, 4)); err != nil {
		t.Fatalf("MarkDone: %v", err)
	}
	err = sample.CloseSample([]domain.CorrectiveAction{action}, "ipc-1",
		march.AddDate(0, 0, 5))
	wantRefused(t, err, "still done")

	repeat := repeatSample(t, "smp-6", sample.ID, "ward-a",
		"bay 3 hand basin", 20, march.AddDate(0, 0, 6), limits)
	if err := action.Verify(repeat, "ipc-1",
		march.AddDate(0, 0, 8)); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if err := sample.CloseSample([]domain.CorrectiveAction{action}, "ipc-1",
		march.AddDate(0, 0, 8)); err != nil {
		t.Fatalf("CloseSample: %v", err)
	}
	if sample.State != domain.SampleClosed {
		t.Fatalf("state = %s, want closed", sample.State)
	}

	summary := domain.SummariseEnvironment(
		[]domain.EnvironmentalSample{sample, repeat},
		[]domain.CorrectiveAction{action})
	if summary.Failed != 1 || summary.Passed != 1 ||
		summary.ActionsVerified != 1 {
		t.Fatalf("summary = %+v", summary)
	}
	if summary.PassPermille != 500 {
		t.Fatalf("pass rate = %d permille, want 500", summary.PassPermille)
	}
}

func repeatSample(t *testing.T, id, repeatOf, location, point string,
	value int64, at time.Time,
	limits []domain.EnvironmentalLimit) domain.EnvironmentalSample {

	t.Helper()
	sample, err := domain.CollectSample(id, "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: location, SamplePoint: point,
		RepeatOfID: repeatOf, CollectedAt: at,
	}, "ipc-1", at)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := sample.RecordResult(domain.ResultInput{
		Value: value, Unit: "cfu/ml", ResultedAt: at.Add(48 * time.Hour),
	}, limits, "lab-1", at.Add(48*time.Hour)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	return sample
}

// SRS-IPC-009. Three years of "flushed and cleared" against the same outlet.
func TestAnActionIsVerifiedByTheRightRepeatTakenAfterTheWork(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	limits := []domain.EnvironmentalLimit{liveLimit(t, domain.NewLimitInput{
		Code: "WATER-3", Revision: 1, SampleKind: domain.SampleWater,
		Unit: "cfu/ml", ActionLevel: 100, FailLevel: 1000,
		EffectiveFrom: march,
	})}

	failed, err := domain.CollectSample("smp-7", "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: "ward-a", SamplePoint: "tap 1",
		CollectedAt: march,
	}, "ipc-1", march)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := failed.RecordResult(domain.ResultInput{
		Value: 4000, Unit: "cfu/ml", ResultedAt: march.AddDate(0, 0, 2),
	}, limits, "lab-1", march.AddDate(0, 0, 2)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}

	action, err := domain.RaiseCorrectiveAction("act-2", "t1", failed,
		"chlorinate the run", "estates-1", march.AddDate(0, 0, 7),
		march.AddDate(0, 0, 3))
	if err != nil {
		t.Fatalf("RaiseCorrectiveAction: %v", err)
	}
	if err := action.MarkDone("chlorinated", "estates-1",
		march.AddDate(0, 0, 5)); err != nil {
		t.Fatalf("MarkDone: %v", err)
	}

	// The tap next door.
	wrong := repeatSample(t, "smp-8", "another-sample", "ward-a", "tap 2",
		10, march.AddDate(0, 0, 6), limits)
	err = action.Verify(wrong, "ipc-1", march.AddDate(0, 0, 9))
	wantRefused(t, err, "not a repeat of this one")

	// Taken before the chlorination.
	early := repeatSample(t, "smp-9", failed.ID, "ward-a", "tap 1", 10,
		march.AddDate(0, 0, 4), limits)
	err = action.Verify(early, "ipc-1", march.AddDate(0, 0, 9))
	wantRefused(t, err, "before the work")

	// Failed again.
	stillBad := repeatSample(t, "smp-10", failed.ID, "ward-a", "tap 1", 3000,
		march.AddDate(0, 0, 6), limits)
	err = action.Verify(stillBad, "ipc-1", march.AddDate(0, 0, 9))
	wantRefused(t, err, "did not pass")

	// An action against a passing sample is noise on the estates worklist.
	_, err = domain.RaiseCorrectiveAction("act-3", "t1", early, "flush",
		"estates-1", march.AddDate(0, 0, 10), march.AddDate(0, 0, 9))
	wantRefused(t, err, "did not fail")
}

// SRS-IPC-009. A point with a plan and no sample is the worst case.
func TestAPointNobodyHasEverSampledIsDueImmediately(t *testing.T) {
	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	plans := []domain.SamplingPlan{}

	for _, point := range []string{"tap 1", "tap 2", "tap 3"} {
		plan, err := domain.NewSamplingPlan("plan-"+point, "t1", "WATER-Q",
			domain.SampleWater, "f1", "ward-a", point, 90, march)
		if err != nil {
			t.Fatalf("NewSamplingPlan: %v", err)
		}
		plans = append(plans, plan)
	}

	// Tap 1 sampled last week, tap 2 six months ago, tap 3 never.
	at := march.AddDate(0, 7, 0)
	samples := []domain.EnvironmentalSample{
		mustSample(t, "s-1", "ward-a", "tap 1", at.AddDate(0, 0, -7)),
		mustSample(t, "s-2", "ward-a", "tap 2", at.AddDate(0, -6, 0)),
	}

	due := domain.DueSampling(plans, samples, at)
	if len(due) != 2 {
		t.Fatalf("due = %d points, want tap 2 and tap 3: %+v", len(due), due)
	}
	if !due[0].NeverSampled || due[0].SamplePoint != "tap 3" {
		t.Fatalf("worst case is not first: %+v", due)
	}
	if due[1].SamplePoint != "tap 2" || due[1].OverdueDays < 80 {
		t.Fatalf("tap 2 = %+v, want roughly 90 days overdue", due[1])
	}

	_, err := domain.NewSamplingPlan("plan-x", "t1", "WATER-Q",
		domain.SampleWater, "f1", "ward-a", "tap 4", 0, march)
	wantRefused(t, err, "interval")
}

func mustSample(t *testing.T, id, location, point string,
	at time.Time) domain.EnvironmentalSample {

	t.Helper()
	sample, err := domain.CollectSample(id, "t1", domain.NewSampleInput{
		Kind: domain.SampleWater, LocationID: location, SamplePoint: point,
		CollectedAt: at,
	}, "ipc-1", at)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	return sample
}
