package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/infection/adapters/postgres"
	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The infection control persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost onset override makes a reclassification disappear; a
// lost limit revision makes a past pass unexplainable; a lost device-day count
// halves a rate.
//
// Sixteen of these bypass the adapter and write raw SQL, because the rule
// under test belongs to the database rather than to Go.

var at = time.Date(2026, 9, 19, 10, 0, 0, 0, time.UTC)

type fixture struct {
	pool     *pgxpool.Pool
	repo     *postgres.Repository
	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()

	return fixture{
		pool: pool,
		repo: postgres.New(pgtx.NewManager(pool)),
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "ipc-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against a
// caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string,
	args ...any) {

	t.Helper()
	_, err := f.pool.Exec(context.Background(), sql, args...)
	if err == nil {
		t.Fatalf("the database accepted a write %q should have refused",
			constraint)
	}
	if !strings.Contains(err.Error(), constraint) {
		t.Fatalf("want a violation of %q, got %v", constraint, err)
	}
}

func (f fixture) mustExec(t *testing.T, sql string, args ...any) {
	t.Helper()
	if _, err := f.pool.Exec(context.Background(), sql, args...); err != nil {
		t.Fatalf("exec: %v", err)
	}
}

func openCase(t *testing.T, f fixture,
	mutate func(*domain.NewCaseInput)) domain.SurveillanceCase {

	t.Helper()
	in := domain.NewCaseInput{
		Reference: "IPC-" + uuid.NewString()[:8],
		PatientID: "patient-1", EncounterID: "enc-1",
		FacilityID: "facility-1", LocationID: "icu",
		Organism: "Klebsiella pneumoniae", OrganismCode: "KPN",
		Site: domain.SiteCLABSI, AdmittedAt: at.AddDate(0, 0, -10),
		OnsetAt: at.AddDate(0, 0, -2), DeviceInSitu: true, DeviceDays: 8,
		Criteria: "CDC CLABSI definition", Notes: "line in situ 8 days",
	}
	if mutate != nil {
		mutate(&in)
	}
	one, err := domain.OpenCase(uuid.NewString(), f.tenantID, in, 48, true,
		"ipc-1", at)
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	if err := f.repo.InsertCase(context.Background(), f.scope, one); err != nil {
		t.Fatalf("InsertCase: %v", err)
	}
	return one
}

// SRS-IPC-001. Everything that makes a case defensible survives the round trip.
func TestACaseRoundTripsWithItsClassificationAndCriteria(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	one := openCase(t, f, nil)
	if one.Onset != domain.OnsetHealthcare {
		t.Fatalf("derived onset = %s, want healthcare", one.Onset)
	}

	back, err := f.repo.Case(ctx, f.scope, one.ID)
	if err != nil {
		t.Fatalf("Case: %v", err)
	}
	switch {
	case back.Onset != domain.OnsetHealthcare:
		t.Fatalf("onset = %s", back.Onset)
	case back.WindowHours != 48:
		t.Fatalf("window = %d hours, want the one it was judged under",
			back.WindowHours)
	case !back.MultidrugResistant:
		t.Fatal("the MDRO flag was lost")
	case !back.DeviceInSitu || back.DeviceDays != 8:
		t.Fatalf("device fields lost: %+v", back)
	case back.Criteria != "CDC CLABSI definition":
		t.Fatalf("criteria = %q", back.Criteria)
	case !back.OnsetAt.Equal(one.OnsetAt):
		t.Fatalf("onset date = %s, want %s", back.OnsetAt, one.OnsetAt)
	}

	// The override is a separate column, and both survive.
	if err := back.Review(domain.CaseConfirmed, "CDC CLABSI definition",
		"ipc-2", at); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if err := back.OverrideOnset(domain.OnsetCommunity,
		"positive blood culture on transfer", "ipc-2"); err != nil {
		t.Fatalf("OverrideOnset: %v", err)
	}
	if err := f.repo.UpdateCase(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("UpdateCase: %v", err)
	}

	after, err := f.repo.Case(ctx, f.scope, one.ID)
	if err != nil {
		t.Fatalf("Case: %v", err)
	}
	switch {
	case after.Onset != domain.OnsetHealthcare:
		t.Fatalf("the derivation was overwritten: %s", after.Onset)
	case after.OnsetOverride != domain.OnsetCommunity:
		t.Fatalf("override = %q", after.OnsetOverride)
	case after.OnsetOverrideWhy == "" || after.OnsetOverriddenBy != "ipc-2":
		t.Fatalf("override provenance lost: %+v", after)
	case after.Version != 2:
		t.Fatalf("version = %d, want 2", after.Version)
	}

	// A stale version is a lost update, not a silent overwrite.
	if err := f.repo.UpdateCase(ctx, f.scope, after, 1); err == nil {
		t.Fatal("a stale write was accepted")
	}
}

// Tenant isolation: another tenant's scope sees nothing (FIT-03, Gate A2).
func TestACaseIsInvisibleToAnotherTenant(t *testing.T) {
	f := newFixture(t)
	one := openCase(t, f, nil)

	other := authctx.NewSession(authctx.Session{
		SubjectID: "ipc-9", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.repo.Case(context.Background(), other, one.ID); err == nil {
		t.Fatal("another tenant read the case")
	}
}

// SRS-IPC-002. Recounting a day corrects it; it does not double it.
func TestRecountingADayCorrectsItRatherThanDoublingIt(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	first, err := domain.NewDeviceDayCount(uuid.NewString(), f.tenantID,
		"facility-1", "icu", domain.DeviceCentralLine, at, 20, 10,
		"nurse-1", at)
	if err != nil {
		t.Fatalf("NewDeviceDayCount: %v", err)
	}
	if err := f.repo.UpsertDeviceDays(ctx, f.scope, first); err != nil {
		t.Fatalf("UpsertDeviceDays: %v", err)
	}

	corrected, err := domain.NewDeviceDayCount(uuid.NewString(), f.tenantID,
		"facility-1", "icu", domain.DeviceCentralLine, at, 20, 12,
		"nurse-2", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("NewDeviceDayCount: %v", err)
	}
	if err := f.repo.UpsertDeviceDays(ctx, f.scope, corrected); err != nil {
		t.Fatalf("UpsertDeviceDays: %v", err)
	}

	rows, err := f.repo.DeviceDays(ctx, f.scope, ports.DeviceDayFilter{
		Device: domain.DeviceCentralLine, LocationID: "icu",
		From: at.AddDate(0, 0, -1), To: at.AddDate(0, 0, 1),
	})
	if err != nil {
		t.Fatalf("DeviceDays: %v", err)
	}
	if len(rows) != 1 {
		t.Fatalf("%d rows for one day: the denominator doubled", len(rows))
	}
	if rows[0].DeviceDays != 12 || rows[0].RecordedBy != "nurse-2" {
		t.Fatalf("correction lost: %+v", rows[0])
	}
}

// SRS-IPC-002. The database refuses a second row for the same day even from a
// caller that never went through the adapter.
func TestTheDatabaseKeepsOneCountPerDevicePerLocationPerDay(t *testing.T) {
	f := newFixture(t)
	insert := `INSERT INTO infection.device_day_count (
		count_id, tenant_id, facility_id, location_id, device, counted_on,
		patient_days, device_days, recorded_at, recorded_by
	) VALUES ($1, $2, 'f1', 'icu', 'ventilator', $3, 20, 10, $4, 'nurse-1')`

	f.mustExec(t, insert, uuid.New(), f.tenantID, at, at)
	f.mustFail(t, "device_day_count_unique_idx", insert,
		uuid.New(), f.tenantID, at, at)

	f.mustFail(t, "device_days_do_not_exceed_patient_days",
		`INSERT INTO infection.device_day_count (
			count_id, tenant_id, facility_id, location_id, device, counted_on,
			patient_days, device_days, recorded_at, recorded_by
		) VALUES ($1, $2, 'f1', 'ward-b', 'ventilator', $3, 5, 6, $4, 'n')`,
		uuid.New(), f.tenantID, at, at)
}

// SRS-IPC-001. The classification rules hold in the database.
func TestTheDatabaseHoldsTheClassificationRules(t *testing.T) {
	f := newFixture(t)

	base := `INSERT INTO infection.surveillance_case (
		case_id, tenant_id, patient_id, organism, site, onset,
		onset_override, onset_override_why, onset_overridden_by,
		onset_at, window_hours, criteria, reviewed_by, device_in_situ,
		state, reported_at, reported_by
	) VALUES ($1, $2, 'p1', 'MRSA', $3, $4, $5, $6, $7, $8, 48, $9, $10,
		$11, $12, $13, 'ipc-1')`

	// An override with no reason and no name is a rate somebody adjusted.
	f.mustFail(t, "an_override_says_who_and_why", base,
		uuid.New(), f.tenantID, "bloodstream", "healthcare_associated",
		"community_acquired", "", "", at, "", "", false, "suspected", at)

	// An "override" that agrees with the derivation is noise in the column
	// that exists to show disagreement.
	f.mustFail(t, "an_override_differs_from_the_derivation", base,
		uuid.New(), f.tenantID, "bloodstream", "healthcare_associated",
		"healthcare_associated", "agreed", "ipc-2", at, "", "", false,
		"suspected", at)

	// A ventilator-associated pneumonia in a patient who was never
	// ventilated.
	f.mustFail(t, "a_device_associated_case_had_the_device", base,
		uuid.New(), f.tenantID, "ventilator_associated_pneumonia",
		"healthcare_associated", "", "", "", at, "", "", false, "suspected",
		at)

	// A confirmed case with no record of what it was judged against.
	f.mustFail(t, "a_judged_case_retains_its_criteria", base,
		uuid.New(), f.tenantID, "bloodstream", "healthcare_associated",
		"", "", "", at, "", "", false, "confirmed", at)
}

// SRS-IPC-003. Precautions round-trip, and lifting them needs a reason.
func TestIsolationRoundTripsAndLiftingItNeedsAReason(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	one := openCase(t, f, nil)
	isolation, err := domain.StartIsolation(uuid.NewString(), f.tenantID,
		domain.NewIsolationInput{
			PatientID: "patient-1", EncounterID: "enc-1",
			FacilityID: "facility-1", LocationID: "icu", BedID: "bed-3",
			Precaution: domain.PrecautionContact,
			Reason:     "carbapenemase-producing Klebsiella",
			CaseID:     one.ID, StartedAt: at,
		}, 48*time.Hour, "ipc-1", at)
	if err != nil {
		t.Fatalf("StartIsolation: %v", err)
	}
	if err := f.repo.InsertIsolation(ctx, f.scope, isolation); err != nil {
		t.Fatalf("InsertIsolation: %v", err)
	}

	back, err := f.repo.Isolation(ctx, f.scope, isolation.ID)
	if err != nil {
		t.Fatalf("Isolation: %v", err)
	}
	switch {
	case back.Precaution != domain.PrecautionContact:
		t.Fatalf("precaution = %s", back.Precaution)
	case back.Reason == "":
		t.Fatal("the reason was lost, and a review needs it")
	case back.CaseID != one.ID:
		t.Fatalf("case link = %q, want %q", back.CaseID, one.ID)
	case !back.ReviewDue.Equal(at.Add(48 * time.Hour)):
		t.Fatalf("review due = %s", back.ReviewDue)
	}

	board := domain.Board([]domain.Isolation{back}, "icu", at)
	if len(board) != 1 || board[0].Precaution != domain.PrecautionContact {
		t.Fatalf("board = %+v", board)
	}

	f.mustFail(t, "lifting_precautions_says_why",
		`UPDATE infection.isolation SET ended_at = $1, ended_by = 'ipc-1'
		 WHERE isolation_id = $2`, at.Add(72*time.Hour), isolation.ID)
}

func liveAlertRule(t *testing.T, f fixture) domain.AlertRule {
	t.Helper()
	ctx := context.Background()

	rule, err := domain.NewAlertRule(uuid.NewString(), f.tenantID,
		domain.NewRuleInput{
			Code: "MDRO-CPE", Name: "Carbapenemase-producing organisms",
			Revision: 2, Organisms: []string{"CPE", "KPC"},
			LookbackDays: 365, Precaution: domain.PrecautionContact,
			Advice: "side room, contact precautions",
		}, "ipc-author", at)
	if err != nil {
		t.Fatalf("NewAlertRule: %v", err)
	}
	if err := f.repo.InsertRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("InsertRule: %v", err)
	}
	if err := rule.Approve("ipc-lead", at, at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("ApproveRule: %v", err)
	}
	return rule
}

// SRS-IPC-004. An alert pins the rule revision it fired under.
func TestAnAlertRoundTripsWithTheRuleRevisionItFiredUnder(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	rule := liveAlertRule(t, f)

	live, err := f.repo.Rules(ctx, f.scope, "MDRO-CPE", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Rules: %v", err)
	}
	if len(live) != 1 || live[0].Revision != 2 || !live[0].Approved {
		t.Fatalf("live rules = %+v", live)
	}
	if len(live[0].Organisms) != 2 {
		t.Fatalf("organisms = %v", live[0].Organisms)
	}

	alert, err := domain.RaiseAlert(uuid.NewString(), f.tenantID, live[0],
		"patient-1", "enc-1", "facility-1", "CPE Klebsiella", "CPE",
		at.AddDate(0, 0, -30), at.Add(time.Hour))
	if err != nil {
		t.Fatalf("RaiseAlert: %v", err)
	}
	if err := f.repo.InsertAlert(ctx, f.scope, alert); err != nil {
		t.Fatalf("InsertAlert: %v", err)
	}
	if err := alert.Override("decolonised, three negative screens", "dr-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Override: %v", err)
	}
	if err := f.repo.UpdateAlert(ctx, f.scope, alert); err != nil {
		t.Fatalf("UpdateAlert: %v", err)
	}

	back, err := f.repo.Alert(ctx, f.scope, alert.ID)
	if err != nil {
		t.Fatalf("Alert: %v", err)
	}
	switch {
	case back.RuleCode != "MDRO-CPE" || back.RuleRevision != 2:
		t.Fatalf("rule version not pinned: %+v", back)
	case !back.Overridden || back.OverrideWhy == "":
		t.Fatalf("override lost: %+v", back)
	case back.OverriddenBy != "dr-1" || back.OverriddenAt.IsZero():
		t.Fatalf("override provenance lost: %+v", back)
	case back.RuleID != rule.ID:
		t.Fatalf("rule link = %q", back.RuleID)
	}

	// A superseded revision stops being live without the row going anywhere.
	if err := f.repo.SupersedeEarlier(ctx, f.scope, "MDRO-CPE", 3,
		at.Add(3*time.Hour)); err != nil {
		t.Fatalf("SupersedeEarlier: %v", err)
	}
	after, err := f.repo.Rules(ctx, f.scope, "MDRO-CPE", at.Add(4*time.Hour))
	if err != nil {
		t.Fatalf("Rules: %v", err)
	}
	if len(after) != 0 {
		t.Fatalf("a superseded revision is still live: %+v", after)
	}
	all, err := f.repo.Rules(ctx, f.scope, "MDRO-CPE", time.Time{})
	if err != nil {
		t.Fatalf("Rules: %v", err)
	}
	if len(all) != 1 {
		t.Fatalf("the superseded revision was deleted: %+v", all)
	}
}

// SRS-IPC-004. The alerting rules hold in the database.
func TestTheDatabaseHoldsTheAlertRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO infection.alert_rule (
		rule_id, tenant_id, code, revision, organisms, lookback_days,
		precaution, approved, approved_by, effective_from,
		created_at, created_by
	) VALUES ($1, $2, 'R', 1, $3, 365, 'contact', $4, $5, $6, $7, 'author-1')`

	// array_length of an empty array is NULL, and a CHECK that evaluates to
	// NULL passes — which is why the constraint coalesces.
	f.mustFail(t, "a_rule_names_the_organisms_it_covers", insert,
		uuid.New(), f.tenantID, []string{}, false, "", nil, at)

	// One person writing and approving a rule is one person deciding what
	// every ward is told about every patient.
	f.mustFail(t, "a_rule_is_approved_by_somebody_else", insert,
		uuid.New(), f.tenantID, []string{"CPE"}, true, "author-1", at, at)

	// Approved with no effective date is a rule in force from never.
	f.mustFail(t, "a_rule_is_approved_by_somebody_else", insert,
		uuid.New(), f.tenantID, []string{"CPE"}, true, "lead-1", nil, at)

	rule := liveAlertRule(t, f)
	alert, err := domain.RaiseAlert(uuid.NewString(), f.tenantID, rule,
		"p1", "enc-1", "f1", "CPE", "CPE", at, at.Add(time.Hour))
	if err != nil {
		t.Fatalf("RaiseAlert: %v", err)
	}
	if err := f.repo.InsertAlert(context.Background(), f.scope,
		alert); err != nil {
		t.Fatalf("InsertAlert: %v", err)
	}
	f.mustFail(t, "an_overridden_alert_says_who_and_why",
		`UPDATE infection.alert SET overridden = true WHERE alert_id = $1`,
		alert.ID)
}

// SRS-IPC-005. A cluster round-trips, empty arrays included.
func TestAnOutbreakRoundTripsWithItsMembershipDecisions(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	outbreak, err := domain.OpenOutbreak(uuid.NewString(), f.tenantID,
		domain.NewOutbreakInput{
			Reference: "OB-2026-03", Organism: "Norovirus",
			CaseDefinition: "diarrhoea and vomiting on ward A",
			Locations:      []string{"ward-a"},
			WindowFrom:     at.AddDate(0, 0, -7), WindowTo: at.AddDate(0, 0, 7),
		}, "ipc-1", at)
	if err != nil {
		t.Fatalf("OpenOutbreak: %v", err)
	}
	// Control measures are empty at this point. A nil slice writes as NULL
	// against a NOT NULL column, so this is the insert that catches it.
	if err := f.repo.InsertOutbreak(ctx, f.scope, outbreak); err != nil {
		t.Fatalf("InsertOutbreak: %v", err)
	}

	member, err := domain.AddMember(uuid.NewString(), f.tenantID, outbreak.ID,
		"case-1", "patient-1", domain.MemberMeetsDefinition, "", true,
		"ipc-1", at)
	if err != nil {
		t.Fatalf("AddMember: %v", err)
	}
	linked, err := domain.AddMember(uuid.NewString(), f.tenantID, outbreak.ID,
		"case-2", "patient-2", domain.MemberEpidemiologicalLink,
		"transferred from ward A on day 2", false, "ipc-1", at)
	if err != nil {
		t.Fatalf("AddMember: %v", err)
	}
	for _, m := range []domain.Membership{member, linked} {
		if err := f.repo.AddMember(ctx, f.scope, m); err != nil {
			t.Fatalf("AddMember: %v", err)
		}
	}

	members, err := f.repo.Members(ctx, f.scope, outbreak.ID)
	if err != nil {
		t.Fatalf("Members: %v", err)
	}
	if len(members) != 2 {
		t.Fatalf("%d members, want 2", len(members))
	}
	if members[1].Note == "" {
		t.Fatal("the reason a linked case was added was lost")
	}

	if err := outbreak.Advance(domain.OutbreakDeclared, "six cases", "ipc-1",
		at); err != nil {
		t.Fatalf("Advance: %v", err)
	}
	outbreak.ControlMeasures = []string{"ward closed", "enhanced cleaning"}
	if err := outbreak.CloseOutbreak("six cases, one ward", "resolved",
		"ipc-1", at.AddDate(0, 0, 10)); err != nil {
		t.Fatalf("CloseOutbreak: %v", err)
	}
	if err := f.repo.UpdateOutbreak(ctx, f.scope, outbreak, 1); err != nil {
		t.Fatalf("UpdateOutbreak: %v", err)
	}

	back, err := f.repo.Outbreak(ctx, f.scope, outbreak.ID)
	if err != nil {
		t.Fatalf("Outbreak: %v", err)
	}
	if len(back.ControlMeasures) != 2 || back.Findings == "" {
		t.Fatalf("closure detail lost: %+v", back)
	}

	summary := domain.Summarise(back, members,
		map[string]domain.SurveillanceCase{})
	if summary.Included != 2 || summary.ByLink != 1 {
		t.Fatalf("summary = %+v", summary)
	}
}

// SRS-IPC-005. The outbreak rules hold in the database.
func TestTheDatabaseHoldsTheOutbreakRules(t *testing.T) {
	f := newFixture(t)

	id := uuid.New()
	f.mustExec(t, `INSERT INTO infection.outbreak (
		outbreak_id, tenant_id, case_definition, locations,
		window_from, window_to, state, created_at, created_by
	) VALUES ($1, $2, 'D&V on ward A', $3, $4, $5, 'declared', $6, 'ipc-1')`,
		id, f.tenantID, []string{"ward-a"}, at.AddDate(0, 0, -7),
		at.AddDate(0, 0, 7), at)

	// A cluster the hospital declared, investigated and closed having changed
	// nothing.
	f.mustFail(t, "a_closed_outbreak_changed_something",
		`UPDATE infection.outbreak
		 SET state = 'closed', findings = 'six cases',
		     closure_why = 'resolved', closed_by = 'ipc-1', closed_at = $1
		 WHERE outbreak_id = $2`, at, id)

	// Closing and refuting are both decisions somebody has to be able to
	// question later.
	f.mustFail(t, "a_finished_investigation_says_why",
		`UPDATE infection.outbreak
		 SET state = 'closed', findings = 'six cases',
		     control_measures = $1, closed_at = $2
		 WHERE outbreak_id = $3`, []string{"ward closed"}, at, id)

	f.mustFail(t, "an_investigation_has_a_window",
		`INSERT INTO infection.outbreak (
			outbreak_id, tenant_id, case_definition, locations,
			window_from, window_to, state, created_at, created_by
		) VALUES ($1, $2, 'D&V', $3, $4, $5, 'suspected', $6, 'ipc-1')`,
		uuid.New(), f.tenantID, []string{"ward-a"}, at, at.AddDate(0, 0, -1),
		at)

	// Adding a case that does not meet the definition, and removing one that
	// does, are the two directions a cluster's size gets quietly adjusted.
	f.mustFail(t, "an_unusual_membership_says_why",
		`INSERT INTO infection.outbreak_member (
			membership_id, tenant_id, outbreak_id, case_id, patient_id,
			reason, note, decided_at, decided_by
		) VALUES ($1, $2, $3, 'case-9', 'p9', 'excluded', '', $4, 'ipc-1')`,
		uuid.New(), f.tenantID, id, at)
}

// SRS-IPC-006. The observation table has no column naming the person observed.
func TestAHandHygieneObservationHasNobodyToName(t *testing.T) {
	f := newFixture(t)

	rows, err := f.pool.Query(context.Background(),
		`SELECT column_name FROM information_schema.columns
		 WHERE table_schema = 'infection'
		   AND table_name = 'hygiene_observation'`)
	if err != nil {
		t.Fatalf("query columns: %v", err)
	}
	defer rows.Close()

	var columns []string
	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			t.Fatalf("scan: %v", err)
		}
		columns = append(columns, name)
	}
	if len(columns) == 0 {
		t.Fatal("no columns found: the table is missing")
	}

	// Not a nullable column, not an optional one: absent, so a future screen
	// cannot start populating it and a future report cannot group by it.
	forbidden := []string{"staff", "person", "employee", "worker",
		"subject", "individual", "observed_by", "user"}
	for _, column := range columns {
		for _, word := range forbidden {
			if strings.Contains(column, word) {
				t.Fatalf("hygiene_observation.%s could name the person "+
					"observed", column)
			}
		}
	}
}

// SRS-IPC-006. Observations round-trip and aggregate.
func TestHygieneObservationsRoundTripAndAggregate(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	session, err := domain.NewSession(uuid.NewString(), f.tenantID,
		"facility-1", "ward-a", "auditor-1", at, "monthly audit", at)
	if err != nil {
		t.Fatalf("NewSession: %v", err)
	}
	if err := f.repo.InsertSession(ctx, f.scope, session); err != nil {
		t.Fatalf("InsertSession: %v", err)
	}

	seen := []struct {
		discipline domain.Discipline
		action     domain.Action
		gloves     bool
	}{
		{domain.DisciplineNurse, domain.ActionRub, false},
		{domain.DisciplineNurse, domain.ActionWash, false},
		{domain.DisciplineNurse, domain.ActionMissed, false},
		{domain.DisciplineNurse, domain.ActionGlovesOnly, true},
		{domain.DisciplineNurse, domain.ActionRub, false},
	}
	for i, one := range seen {
		observation, err := domain.NewObservation(uuid.NewString(),
			f.tenantID, session.ID, one.discipline,
			domain.MomentBeforePatient, one.action, one.gloves,
			at.Add(time.Duration(i)*time.Minute))
		if err != nil {
			t.Fatalf("NewObservation: %v", err)
		}
		if err := f.repo.InsertObservation(ctx, f.scope,
			observation); err != nil {
			t.Fatalf("InsertObservation: %v", err)
		}
	}

	back, err := f.repo.Observations(ctx, f.scope, "ward-a", "",
		at.AddDate(0, 0, -1), at.AddDate(0, 0, 1))
	if err != nil {
		t.Fatalf("Observations: %v", err)
	}
	if len(back) != 5 {
		t.Fatalf("%d observations, want 5", len(back))
	}

	report := domain.Compliances(domain.ComplianceInput{
		Observations: back, By: "discipline", MinimumOpportunities: 5,
	})
	if len(report) != 1 || report[0].Performed != 3 ||
		report[0].GlovesInsteadOf != 1 {
		t.Fatalf("report = %+v", report)
	}

	// Gloves recorded as the action with no gloves worn is a contradiction.
	f.mustFail(t, "gloves_only_wore_gloves",
		`INSERT INTO infection.hygiene_observation (
			observation_id, tenant_id, session_id, discipline, moment,
			action, gloves_worn, observed_at
		) VALUES ($1, $2, $3, 'nurse', 'before_patient_contact',
			'gloves_only', false, $4)`,
		uuid.New(), f.tenantID, session.ID, at)
}

// SRS-IPC-007. An exposure and its clocks round-trip, and the row is
// restricted whatever the caller says.
func TestAnExposureRoundTripsWithItsTasksAndStaysRestricted(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	exposure, err := domain.ReportExposure(uuid.NewString(), f.tenantID,
		domain.NewExposureInput{
			Reference: "EXP-1", StaffID: "staff-1",
			Discipline: domain.DisciplineNurse, FacilityID: "facility-1",
			LocationID: "ward-a", Kind: domain.ExposureNeedlestick,
			Device: "18G cannula", Circumstance: "recapping a cannula",
			DeepInjury: true, SourcePatientID: "patient-1",
			SourceKnown: true, SourceConsented: true,
			OccurredAt: at.Add(-30 * time.Hour),
		}, "staff-1", at)
	if err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}
	tasks := domain.ExposureTasks(exposure, uuid.NewString)
	if err := f.repo.InsertExposure(ctx, f.scope, exposure,
		tasks); err != nil {
		t.Fatalf("InsertExposure: %v", err)
	}

	back, err := f.repo.Exposure(ctx, f.scope, exposure.ID)
	if err != nil {
		t.Fatalf("Exposure: %v", err)
	}
	switch {
	case back.SourcePatientID != "patient-1" || !back.SourceConsented:
		t.Fatalf("source fields lost: %+v", back)
	case back.Circumstance == "" || back.Device == "":
		t.Fatal("what a prevention programme reads was lost")
	case !back.DeepInjury:
		t.Fatal("the deep-injury flag was lost")
	}

	stored, err := f.repo.Tasks(ctx, f.scope, exposure.ID)
	if err != nil {
		t.Fatalf("Tasks: %v", err)
	}
	if len(stored) != len(tasks) {
		t.Fatalf("%d tasks stored, want %d", len(stored), len(tasks))
	}
	for _, task := range stored {
		if task.Code != domain.TaskProphylaxis {
			continue
		}
		want := exposure.OccurredAt.Add(72 * time.Hour)
		if !task.DueBy.Equal(want) {
			t.Fatalf("prophylaxis due %s, want %s from the exposure",
				task.DueBy, want)
		}
	}

	// The restriction is not a configuration choice.
	f.mustFail(t, "exposure_restricted_check",
		`UPDATE infection.exposure SET restricted = false
		 WHERE exposure_id = $1`, exposure.ID)

	// Testing a source patient's blood without recorded consent.
	f.mustFail(t, "a_named_source_consented",
		`INSERT INTO infection.exposure (
			exposure_id, tenant_id, staff_id, kind, circumstance,
			source_patient_id, source_known, source_consented,
			occurred_at, reported_at, reported_by
		) VALUES ($1, $2, 'staff-2', 'sharps', 'suture needle',
			'patient-9', true, false, $3, $4, 'staff-2')`,
		uuid.New(), f.tenantID, at, at)

	// An exposure closed with no outcome is a member of staff whose
	// follow-up nobody can read.
	f.mustFail(t, "a_closed_exposure_records_its_outcome",
		`UPDATE infection.exposure SET closed_at = $1, closed_by = 'occ-1'
		 WHERE exposure_id = $2`, at.AddDate(0, 6, 0), exposure.ID)

	// An exposure reported before it happened is a clock running backwards.
	f.mustFail(t, "an_exposure_precedes_its_report",
		`INSERT INTO infection.exposure (
			exposure_id, tenant_id, staff_id, kind, circumstance,
			occurred_at, reported_at, reported_by
		) VALUES ($1, $2, 'staff-3', 'sharps', 'suture needle', $3, $4,
			'staff-3')`,
		uuid.New(), f.tenantID, at, at.Add(-time.Hour))

	// A declined prophylaxis and one nobody offered look identical without
	// the outcome.
	f.mustFail(t, "a_finished_step_says_what_happened",
		`UPDATE infection.exposure_task SET state = 'declined'
		 WHERE task_id = $1`, stored[0].ID)
}

func liveStewardshipRule(t *testing.T, f fixture) domain.StewardshipRule {
	t.Helper()
	ctx := context.Background()

	rule, err := domain.NewStewardshipRule(uuid.NewString(), f.tenantID,
		domain.NewStewardshipRuleInput{
			Code: "DAY3", Name: "Day three review", Revision: 1,
			Kind: domain.TriggerDuration, AllAgents: true, DayThreshold: 3,
			Prompt: "day three review: stop, narrow or continue?",
		}, "amt-author", at)
	if err != nil {
		t.Fatalf("NewStewardshipRule: %v", err)
	}
	if err := f.repo.InsertStewardshipRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("InsertStewardshipRule: %v", err)
	}
	if err := rule.Approve("amt-lead", at, at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveStewardshipRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("ApproveStewardshipRule: %v", err)
	}
	return rule
}

// SRS-IPC-008. A review round-trips, and the same trigger cannot sit on the
// worklist twice.
func TestAStewardshipReviewRoundTripsAndDoesNotDuplicate(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	rule := liveStewardshipRule(t, f)
	trigger := domain.Trigger{
		RuleID: rule.ID, RuleCode: rule.Code, RuleRevision: rule.Revision,
		Kind: rule.Kind, Agent: "Meropenem", OrderID: "order-1",
		Why: "meropenem is on day 4",
	}
	signal := domain.TherapySignal{
		PatientID: "patient-1", EncounterID: "enc-1", LocationID: "icu",
	}

	review, err := domain.RaiseReview(uuid.NewString(), f.tenantID, trigger,
		signal, at.Add(24*time.Hour), at)
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}
	if err := f.repo.InsertReview(ctx, f.scope, review); err != nil {
		t.Fatalf("InsertReview: %v", err)
	}

	// Re-evaluating the patient an hour later must not raise it again. The
	// index is on lower(agent), so a different capitalisation is the same
	// review.
	duplicate := review
	duplicate.ID = uuid.NewString()
	duplicate.Agent = "meropenem"
	if err := f.repo.InsertReview(ctx, f.scope, duplicate); err == nil {
		t.Fatal("the same trigger raised a second review")
	}

	if err := review.Advise(domain.RecommendStop,
		"stop on day 5, source controlled", "pharm-1",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Advise: %v", err)
	}
	if err := f.repo.UpdateReview(ctx, f.scope, review, 1); err != nil {
		t.Fatalf("UpdateReview: %v", err)
	}
	if err := review.RecordResponse(domain.ResponseDeclined,
		"treating a second organism", "dr-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("RecordResponse: %v", err)
	}
	if err := f.repo.UpdateReview(ctx, f.scope, review, 2); err != nil {
		t.Fatalf("UpdateReview: %v", err)
	}

	back, err := f.repo.Review(ctx, f.scope, review.ID)
	if err != nil {
		t.Fatalf("Review: %v", err)
	}
	switch {
	case back.RuleCode != "DAY3" || back.RuleRevision != 1:
		t.Fatalf("rule version not pinned: %+v", back)
	case back.Recommendation != domain.RecommendStop || back.Advice == "":
		t.Fatalf("advice lost: %+v", back)
	case back.Response != domain.ResponseDeclined ||
		back.ResponseReason == "":
		t.Fatalf("response lost: %+v", back)
	case back.ReviewedBy != "pharm-1" || back.RespondedBy != "dr-1":
		t.Fatalf("who advised and who decided: %+v", back)
	case back.OrderID != "order-1":
		t.Fatalf("order reference lost: %q", back.OrderID)
	}

	// A closed review is off the partial index, so the same trigger may be
	// raised again on a later day. Raised fresh rather than copied: a closed
	// review carries a response, and the insert writes an open one.
	again, err := domain.RaiseReview(uuid.NewString(), f.tenantID, trigger,
		signal, at.AddDate(0, 0, 1).Add(24*time.Hour), at.AddDate(0, 0, 1))
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}
	if err := f.repo.InsertReview(ctx, f.scope, again); err != nil {
		t.Fatalf("a closed review still blocks the worklist: %v", err)
	}
}

// SRS-IPC-008. The stewardship rules hold in the database.
func TestTheDatabaseHoldsTheStewardshipRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO infection.stewardship_rule (
		rule_id, tenant_id, code, revision, kind, agents, all_agents,
		day_threshold, prompt, created_at, created_by
	) VALUES ($1, $2, 'R', 1, $3, $4, $5, $6, 'review', $7, 'author-1')`

	f.mustFail(t, "a_rule_names_its_agents_or_says_all", insert,
		uuid.New(), f.tenantID, "restricted_agent", []string{}, false, 0, at)
	f.mustFail(t, "a_redundant_cover_rule_names_a_group", insert,
		uuid.New(), f.tenantID, "redundant_cover", []string{"metronidazole"},
		false, 0, at)
	f.mustFail(t, "a_day_based_rule_names_its_day", insert,
		uuid.New(), f.tenantID, "duration", []string{}, true, 0, at)

	rule := liveStewardshipRule(t, f)
	review, err := domain.RaiseReview(uuid.NewString(), f.tenantID,
		domain.Trigger{
			RuleID: rule.ID, RuleCode: rule.Code, RuleRevision: 1,
			Kind: rule.Kind, Agent: "meropenem",
		}, domain.TherapySignal{PatientID: "p1", EncounterID: "enc-1"},
		at.Add(24*time.Hour), at)
	if err != nil {
		t.Fatalf("RaiseReview: %v", err)
	}
	if err := f.repo.InsertReview(context.Background(), f.scope,
		review); err != nil {
		t.Fatalf("InsertReview: %v", err)
	}

	// The reviewer cannot answer for the prescriber. This is the one number a
	// stewardship programme is judged on.
	f.mustFail(t, "the_reviewer_does_not_answer_for_the_prescriber",
		`UPDATE infection.stewardship_review
		 SET state = 'closed', recommendation = 'stop', advice = 'stop it',
		     reviewed_by = 'pharm-1', reviewed_at = $1,
		     response = 'accepted', responded_by = 'pharm-1',
		     responded_at = $1
		 WHERE review_id = $2`, at, review.ID)

	// A closed review with nobody's answer on it is advice that went nowhere
	// and reads as though it did.
	f.mustFail(t, "a_closed_review_records_a_response",
		`UPDATE infection.stewardship_review
		 SET state = 'closed', recommendation = 'stop', advice = 'stop it',
		     reviewed_by = 'pharm-1', reviewed_at = $1
		 WHERE review_id = $2`, at, review.ID)

	f.mustFail(t, "a_withdrawn_review_says_why",
		`UPDATE infection.stewardship_review SET state = 'withdrawn'
		 WHERE review_id = $1`, review.ID)

	// Declining advice is a clinical decision and not a silent one.
	f.mustFail(t, "advice_not_taken_says_why",
		`UPDATE infection.stewardship_review
		 SET state = 'closed', recommendation = 'stop', advice = 'stop it',
		     reviewed_by = 'pharm-1', reviewed_at = $1,
		     response = 'declined', responded_by = 'dr-1',
		     responded_at = $1
		 WHERE review_id = $2`, at, review.ID)
}

func liveLimit(t *testing.T, f fixture) domain.EnvironmentalLimit {
	t.Helper()
	ctx := context.Background()

	limit, err := domain.NewEnvironmentalLimit(uuid.NewString(), f.tenantID,
		domain.NewLimitInput{
			Code: "WATER", Name: "Augmented care water", Revision: 1,
			SampleKind: domain.SampleWater, Unit: "cfu/ml",
			ActionLevel: 100, FailLevel: 1000,
			EffectiveFrom: at.AddDate(0, -1, 0),
		}, "ipc-author", at)
	if err != nil {
		t.Fatalf("NewEnvironmentalLimit: %v", err)
	}
	if err := f.repo.InsertLimit(ctx, f.scope, limit); err != nil {
		t.Fatalf("InsertLimit: %v", err)
	}
	if err := limit.Approve("ipc-lead", at.AddDate(0, -1, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveLimit(ctx, f.scope, limit); err != nil {
		t.Fatalf("ApproveLimit: %v", err)
	}
	return limit
}

// SRS-IPC-009. A result round-trips with the limit revision that judged it,
// and its corrective action with the repeat that verified it.
func TestAnEnvironmentalResultRoundTripsWithItsLimitAndAction(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	limit := liveLimit(t, f)
	limits, err := f.repo.Limits(ctx, f.scope, domain.SampleWater,
		at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Limits: %v", err)
	}
	if len(limits) != 1 {
		t.Fatalf("%d live limits, want 1", len(limits))
	}

	sample, err := domain.CollectSample(uuid.NewString(), f.tenantID,
		domain.NewSampleInput{
			Reference: "ENV-1", Kind: domain.SampleWater,
			FacilityID: "facility-1", LocationID: "ward-a",
			SamplePoint: "bay 3 hand basin", CollectedAt: at,
			Method: "pre-flush",
		}, "estates-1", at)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := f.repo.InsertSample(ctx, f.scope, sample); err != nil {
		t.Fatalf("InsertSample: %v", err)
	}
	if err := sample.RecordResult(domain.ResultInput{
		LabReference: "LAB-1", Value: 4000, Unit: "cfu/ml",
		Organism: "Pseudomonas aeruginosa", Detected: true,
		ResultedAt: at.AddDate(0, 0, 2),
	}, limits, "lab-1", at.AddDate(0, 0, 2)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if err := f.repo.UpdateSample(ctx, f.scope, sample, 1); err != nil {
		t.Fatalf("UpdateSample: %v", err)
	}

	back, err := f.repo.Sample(ctx, f.scope, sample.ID)
	if err != nil {
		t.Fatalf("Sample: %v", err)
	}
	switch {
	case back.Outcome != domain.OutcomeFail:
		t.Fatalf("outcome = %s, want fail", back.Outcome)
	case back.LimitCode != limit.Code || back.LimitRevision != 1:
		t.Fatalf("the limit revision was not pinned: %+v", back)
	case back.Value != 4000 || back.Unit != "cfu/ml":
		t.Fatalf("result lost: %+v", back)
	case back.LocationID != "ward-a" || back.SamplePoint == "":
		t.Fatal("the result no longer links to a place anybody can act on")
	}

	action, err := domain.RaiseCorrectiveAction(uuid.NewString(), f.tenantID,
		back, "replace the outlet and flush", "estates-1",
		at.AddDate(0, 0, 7), at.AddDate(0, 0, 3))
	if err != nil {
		t.Fatalf("RaiseCorrectiveAction: %v", err)
	}
	if err := f.repo.InsertAction(ctx, f.scope, action); err != nil {
		t.Fatalf("InsertAction: %v", err)
	}
	if err := action.MarkDone("outlet replaced", "estates-1",
		at.AddDate(0, 0, 4)); err != nil {
		t.Fatalf("MarkDone: %v", err)
	}
	if err := f.repo.UpdateAction(ctx, f.scope, action, 1); err != nil {
		t.Fatalf("UpdateAction: %v", err)
	}

	repeat, err := domain.CollectSample(uuid.NewString(), f.tenantID,
		domain.NewSampleInput{
			Kind: domain.SampleWater, LocationID: "ward-a",
			SamplePoint: "bay 3 hand basin", RepeatOfID: sample.ID,
			CollectedAt: at.AddDate(0, 0, 6),
		}, "estates-1", at.AddDate(0, 0, 6))
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	// Collected, then resulted: a sample row is written at collection and the
	// result is an update, which is what the "a resulted sample has an
	// outcome" constraint expects.
	if err := f.repo.InsertSample(ctx, f.scope, repeat); err != nil {
		t.Fatalf("InsertSample: %v", err)
	}
	if err := repeat.RecordResult(domain.ResultInput{
		Value: 10, Unit: "cfu/ml", ResultedAt: at.AddDate(0, 0, 8),
	}, limits, "lab-1", at.AddDate(0, 0, 8)); err != nil {
		t.Fatalf("RecordResult: %v", err)
	}
	if err := f.repo.UpdateSample(ctx, f.scope, repeat, 1); err != nil {
		t.Fatalf("UpdateSample: %v", err)
	}
	if err := action.Verify(repeat, "ipc-1",
		at.AddDate(0, 0, 9)); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if err := f.repo.UpdateAction(ctx, f.scope, action, 2); err != nil {
		t.Fatalf("UpdateAction: %v", err)
	}

	actions, err := f.repo.Actions(ctx, f.scope, sample.ID, false)
	if err != nil {
		t.Fatalf("Actions: %v", err)
	}
	if len(actions) != 1 {
		t.Fatalf("%d actions, want 1", len(actions))
	}
	if actions[0].State != domain.ActionVerified ||
		actions[0].RepeatSampleID != repeat.ID {
		t.Fatalf("verification lost: %+v", actions[0])
	}

	if err := sample.CloseSample(actions, "ipc-1",
		at.AddDate(0, 0, 9)); err != nil {
		t.Fatalf("CloseSample: %v", err)
	}
	if err := f.repo.UpdateSample(ctx, f.scope, sample, 2); err != nil {
		t.Fatalf("UpdateSample: %v", err)
	}
}

// SRS-IPC-009. The environmental rules hold in the database.
func TestTheDatabaseHoldsTheEnvironmentalRules(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	// A limit whose levels run the wrong way makes a reading a failure and an
	// action level at once.
	f.mustFail(t, "the_levels_run_in_the_limits_direction",
		`INSERT INTO infection.environmental_limit (
			limit_id, tenant_id, code, revision, sample_kind, unit,
			action_level, fail_level, created_at, created_by
		) VALUES ($1, $2, 'BACKWARDS', 1, 'water', 'cfu/ml', 1000, 100,
			$3, 'author-1')`, uuid.New(), f.tenantID, at)

	f.mustFail(t, "a_limit_is_approved_by_somebody_else",
		`INSERT INTO infection.environmental_limit (
			limit_id, tenant_id, code, revision, sample_kind, unit,
			action_level, fail_level, approved, approved_by, effective_from,
			created_at, created_by
		) VALUES ($1, $2, 'SELF', 1, 'water', 'cfu/ml', 100, 1000,
			true, 'author-1', $3, $3, 'author-1')`,
		uuid.New(), f.tenantID, at)

	sample, err := domain.CollectSample(uuid.NewString(), f.tenantID,
		domain.NewSampleInput{
			Kind: domain.SampleWater, LocationID: "ward-a",
			SamplePoint: "tap 1", CollectedAt: at,
		}, "ipc-1", at)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := f.repo.InsertSample(ctx, f.scope, sample); err != nil {
		t.Fatalf("InsertSample: %v", err)
	}

	// A pass that does not say which version of the limit passed it stops
	// being explicable the moment the limit moves.
	f.mustFail(t, "a_judged_result_pins_the_limit_revision",
		`UPDATE infection.environmental_sample
		 SET state = 'resulted', outcome = 'pass', resulted_at = $1,
		     resulted_by = 'lab-1'
		 WHERE sample_id = $2`, at, sample.ID)

	// A sample nobody judged, filed as resulted, is a result that quietly
	// disappears from every report that filters on an outcome.
	f.mustFail(t, "a_resulted_sample_has_an_outcome",
		`UPDATE infection.environmental_sample
		 SET state = 'resulted', resulted_at = $1, resulted_by = 'lab-1'
		 WHERE sample_id = $2`, at, sample.ID)

	f.mustFail(t, "a_repeat_is_not_its_own_original",
		`UPDATE infection.environmental_sample SET repeat_of_id = sample_id
		 WHERE sample_id = $1`, sample.ID)

	f.mustExec(t, `UPDATE infection.environmental_sample
		 SET state = 'resulted', outcome = 'fail', resulted_at = $1,
		     resulted_by = 'lab-1', limit_code = 'W', limit_revision = 1
		 WHERE sample_id = $2`, at, sample.ID)

	action, err := domain.RaiseCorrectiveAction(uuid.NewString(), f.tenantID,
		mustSample(t, f, sample.ID), "flush", "estates-1",
		at.AddDate(0, 0, 7), at)
	if err != nil {
		t.Fatalf("RaiseCorrectiveAction: %v", err)
	}
	if err := f.repo.InsertAction(ctx, f.scope, action); err != nil {
		t.Fatalf("InsertAction: %v", err)
	}

	// A verified action with nothing behind it.
	f.mustFail(t, "a_verified_action_names_its_repeat",
		`UPDATE infection.corrective_action
		 SET state = 'verified', done_at = $1, done_by = 'estates-1',
		     done_note = 'flushed', verified_at = $1, verified_by = 'ipc-1'
		 WHERE action_id = $2`, at, action.ID)

	f.mustFail(t, "a_done_action_says_what_was_done",
		`UPDATE infection.corrective_action SET state = 'done'
		 WHERE action_id = $1`, action.ID)
}

func mustSample(t *testing.T, f fixture, id string) domain.EnvironmentalSample {
	t.Helper()
	sample, err := f.repo.Sample(context.Background(), f.scope, id)
	if err != nil {
		t.Fatalf("Sample: %v", err)
	}
	return sample
}

// SRS-IPC-009. A point with a plan and no sample is reported, not assumed.
func TestSamplingPlansDriveTheDueList(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for _, point := range []string{"tap 1", "tap 2"} {
		plan, err := domain.NewSamplingPlan(uuid.NewString(), f.tenantID,
			"WATER-Q", domain.SampleWater, "facility-1", "ward-a", point,
			90, at.AddDate(0, -7, 0))
		if err != nil {
			t.Fatalf("NewSamplingPlan: %v", err)
		}
		if err := f.repo.InsertPlan(ctx, f.scope, plan); err != nil {
			t.Fatalf("InsertPlan: %v", err)
		}
	}

	sample, err := domain.CollectSample(uuid.NewString(), f.tenantID,
		domain.NewSampleInput{
			Kind: domain.SampleWater, LocationID: "ward-a",
			SamplePoint: "tap 1", CollectedAt: at.AddDate(0, 0, -7),
		}, "ipc-1", at)
	if err != nil {
		t.Fatalf("CollectSample: %v", err)
	}
	if err := f.repo.InsertSample(ctx, f.scope, sample); err != nil {
		t.Fatalf("InsertSample: %v", err)
	}

	plans, err := f.repo.Plans(ctx, f.scope, "ward-a", true)
	if err != nil {
		t.Fatalf("Plans: %v", err)
	}
	samples, err := f.repo.Samples(ctx, f.scope, ports.SampleFilter{
		LocationID: "ward-a",
	})
	if err != nil {
		t.Fatalf("Samples: %v", err)
	}

	due := domain.DueSampling(plans, samples, at)
	if len(due) != 1 {
		t.Fatalf("due = %+v, want tap 2 only", due)
	}
	if !due[0].NeverSampled || due[0].SamplePoint != "tap 2" {
		t.Fatalf("due[0] = %+v", due[0])
	}
}
