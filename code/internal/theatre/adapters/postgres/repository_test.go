package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	theatrepostgres "github.com/ppusapati/health/code/internal/theatre/adapters/postgres"
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// The perioperative persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost laterality turns a right-sided case into a sideless one;
// a lost cycle id breaks the chain an infection investigation runs along; a
// lost serial number takes an implant off the recall list.

var at = time.Date(2026, 9, 18, 8, 0, 0, 0, time.UTC)

type fixture struct {
	pool     *pgxpool.Pool
	schedule theatrepostgres.ScheduleRepo
	cases    theatrepostgres.CaseRepo

	scope      authctx.TenantScope
	tenantID   string
	facilityID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := theatrepostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:     pool,
		schedule: theatrepostgres.ScheduleRepo{Repository: repo},
		cases:    theatrepostgres.CaseRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "nurse-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID:   tenantID,
		facilityID: "fac-1",
	}
}

func (f fixture) room(t *testing.T, code string) domain.Room {
	t.Helper()

	room := domain.Room{
		ID: uuid.NewString(), TenantID: f.tenantID, FacilityID: f.facilityID,
		Code: code, Name: "Theatre " + code,
		Specialties: []string{"general"}, Equipment: []string{"laminar flow"},
		Active: true,
	}
	if err := f.schedule.SaveRoom(context.Background(), f.scope, room); err != nil {
		t.Fatalf("SaveRoom: %v", err)
	}
	return room
}

func (f fixture) surgeryCase(t *testing.T) domain.Case {
	t.Helper()

	c, _, err := domain.NewCase(uuid.NewString(), f.tenantID, domain.NewCaseInput{
		EncounterID: uuid.NewString(), PatientID: uuid.NewString(),
		FacilityID:    f.facilityID,
		ProcedureCode: "M65.3", ProcedureDisplay: "Trigger finger release",
		DiagnosisCode: "M65.3", DiagnosisDisplay: "Trigger finger",
		Laterality: domain.LateralityRight, Site: "right ring finger",
		Urgency: domain.UrgencyElective, ExpectedDuration: 30 * time.Minute,
		SurgeonID: "surgeon-1", Team: []string{"scrub-1"},
		Requirements: []string{"tourniquet"}, SideRequired: true,
	}, "surgeon-1", at)
	if err != nil {
		t.Fatalf("NewCase: %v", err)
	}
	if err := f.schedule.InsertCase(context.Background(), f.scope, c); err != nil {
		t.Fatalf("InsertCase: %v", err)
	}
	return c
}

func TestACaseSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	want := f.surgeryCase(t)

	got, err := f.schedule.Case(context.Background(), f.scope, want.ID)
	if err != nil {
		t.Fatalf("Case: %v", err)
	}
	if got.ID != want.ID || got.EncounterID != want.EncounterID ||
		got.PatientID != want.PatientID || got.ProcedureCode != want.ProcedureCode ||
		got.Urgency != want.Urgency || got.Status != want.Status ||
		got.SurgeonID != want.SurgeonID || got.Version != want.Version {
		t.Fatalf("round trip lost data:\n got %+v\nwant %+v", got, want)
	}
	// The one field wrong-site surgery turns on.
	if got.Laterality != domain.LateralityRight || got.Site != want.Site {
		t.Fatalf("laterality = %q / site = %q", got.Laterality, got.Site)
	}
	if got.ExpectedDuration != 30*time.Minute {
		t.Fatalf("expected duration = %v; a list built from a lost duration overruns",
			got.ExpectedDuration)
	}
	if len(got.Requirements) != 1 || len(got.Team) != 1 {
		t.Fatalf("requirements = %v, team = %v", got.Requirements, got.Team)
	}
}

// Two schedulers booking the same slot is the ordinary case on a Monday
// morning, not the exotic one.
func TestAStaleCaseWriteIsRefused(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	room := f.room(t, "OT1")
	c := f.surgeryCase(t)
	stale := c.Version

	slot := domain.ScheduleRequest{
		RoomID: room.ID, Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
	}
	if err := c.Schedule(slot, nil, false, at); err != nil {
		t.Fatalf("Schedule: %v", err)
	}
	if err := f.schedule.UpdateCase(ctx, f.scope, c, stale); err != nil {
		t.Fatalf("UpdateCase: %v", err)
	}
	if err := f.schedule.UpdateCase(ctx, f.scope, c, stale); err != ports.ErrVersionConflict {
		t.Fatalf("second write returned %v, want a version conflict", err)
	}
}

// The adapter must refuse a case assembled for another tenant, even through a
// valid scope: FIT-03 makes the scope unforgeable and this is the other half.
func TestACaseFromAnotherTenantIsRefused(t *testing.T) {
	f := newFixture(t)

	foreign, _, err := domain.NewCase(uuid.NewString(), uuid.NewString(),
		domain.NewCaseInput{
			EncounterID: uuid.NewString(), PatientID: uuid.NewString(),
			ProcedureCode: "M65.3", Urgency: domain.UrgencyElective,
			ExpectedDuration: 30 * time.Minute, SurgeonID: "surgeon-1",
			DiagnosisCode: "M65.3",
		}, "surgeon-1", at)
	if err != nil {
		t.Fatalf("NewCase: %v", err)
	}
	if err := f.schedule.InsertCase(context.Background(), f.scope, foreign); err == nil {
		t.Fatal("a case belonging to another tenant was written")
	}
}

// A surgeon's diary is read across rooms, which is the check a room-only
// search misses.
func TestASurgeonsDiaryIsReadAcrossRooms(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	first := f.room(t, "OT1")
	second := f.room(t, "OT2")

	for _, room := range []domain.Room{first, second} {
		c := f.surgeryCase(t)
		expected := c.Version
		slot := domain.ScheduleRequest{
			RoomID: room.ID, Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
		}
		if err := c.Schedule(slot, nil, false, at); err != nil {
			t.Fatalf("Schedule: %v", err)
		}
		if err := f.schedule.UpdateCase(ctx, f.scope, c, expected); err != nil {
			t.Fatalf("UpdateCase: %v", err)
		}
	}

	diary, err := f.schedule.SurgeonCases(ctx, f.scope, "surgeon-1",
		at, at.Add(4*time.Hour))
	if err != nil {
		t.Fatalf("SurgeonCases: %v", err)
	}
	if len(diary) != 2 {
		t.Fatalf("%d cases in the diary, want both rooms", len(diary))
	}

	// One room's list sees only its own.
	inRoom, err := f.schedule.RoomCases(ctx, f.scope, first.ID, at, at.Add(4*time.Hour))
	if err != nil {
		t.Fatalf("RoomCases: %v", err)
	}
	if len(inRoom) != 1 {
		t.Fatalf("%d cases in one room, want 1", len(inRoom))
	}
}

// SRS-OT-006. A waiver's role and reason travel together, because the role is
// what entitled somebody to make it and the reason is what a review reads.
func TestAWaiverKeepsItsRoleAndReason(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	if err := f.cases.SavePreopEntry(ctx, f.scope, c.ID, domain.PreopEntry{
		Code: "fasting", State: domain.PreopWaived,
		Note:     "emergency laparotomy, rapid sequence induction planned",
		WaivedBy: "anaes-1", WaivedRole: "anaesthetist",
		RecordedBy: "anaes-1", RecordedAt: at,
	}); err != nil {
		t.Fatalf("SavePreopEntry: %v", err)
	}

	checklist, err := f.cases.PreopChecklist(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("PreopChecklist: %v", err)
	}
	if len(checklist.Entries) != 1 {
		t.Fatalf("%d entries", len(checklist.Entries))
	}
	entry := checklist.Entries[0]
	if entry.WaivedRole != "anaesthetist" || entry.Note == "" {
		t.Fatalf("waiver = %+v; the role and the reason are the record", entry)
	}

	// Recording the same item again replaces it rather than adding a second.
	if err := f.cases.SavePreopEntry(ctx, f.scope, c.ID, domain.PreopEntry{
		Code: "fasting", State: domain.PreopMet, RecordedBy: "nurse-1",
		RecordedAt: at.Add(time.Hour),
	}); err != nil {
		t.Fatalf("SavePreopEntry (replace): %v", err)
	}
	checklist, err = f.cases.PreopChecklist(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("PreopChecklist: %v", err)
	}
	if len(checklist.Entries) != 1 || checklist.Entries[0].State != domain.PreopMet {
		t.Fatalf("entries = %+v, want one, now met", checklist.Entries)
	}
}

// The database refuses a waiver with no role or no reason, so the guarantee is
// not the application layer's care.
func TestTheDatabaseRefusesAnUnexplainedWaiver(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO theatre.preop_entry (
		    case_id, tenant_id, code, state, note, waived_role,
		    recorded_by, recorded_at
		) VALUES ($1, $2, 'blood', 'waived', '', '', 'nurse-1', $3)`,
		c.ID, f.tenantID, at)
	if err == nil {
		t.Fatal("an unexplained waiver was accepted by the database")
	}
}

// SRS-OT-007. The phase and its answers are written together: a check that
// says a team stopped and cannot say what they agreed is not a record.
func TestASafetyCheckKeepsItsAnswersAndParticipants(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	items := domain.DefaultSafetyItems()
	var answers []domain.SafetyAnswer
	for _, item := range items {
		if item.Phase != domain.PhaseSignOut {
			continue
		}
		answer := domain.SafetyAnswer{Code: item.Code, Confirmed: true}
		if item.Code == "counts_correct" {
			answer.Confirmed = false
			answer.Exception = "counts disputed; imaging requested"
		}
		answers = append(answers, answer)
	}

	record, err := domain.PerformSafety(uuid.NewString(), f.tenantID, c.ID,
		domain.PhaseSignOut, items,
		[]string{"surgeon-1", "anaes-1", "nurse-1"}, answers, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformSafety: %v", err)
	}
	if err := f.cases.InsertSafetyCheck(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertSafetyCheck: %v", err)
	}

	checks, err := f.cases.SafetyChecks(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("SafetyChecks: %v", err)
	}
	if len(checks) != 1 {
		t.Fatalf("%d checks, want 1", len(checks))
	}
	if len(checks[0].Participants) != 3 {
		t.Fatalf("participants = %v", checks[0].Participants)
	}
	if len(checks[0].Answers) != len(answers) {
		t.Fatalf("%d answers stored, want %d", len(checks[0].Answers), len(answers))
	}
	exceptions := checks[0].Exceptions()
	if len(exceptions) != 1 || exceptions[0].Exception == "" {
		t.Fatalf("exceptions = %+v; the exception is the whole point of the row",
			exceptions)
	}
}

// A time-out with fewer than two people is refused by the database, not just
// by the domain.
func TestTheDatabaseRefusesASoloTimeOut(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO theatre.safety_check (
		    check_id, tenant_id, case_id, phase, participants,
		    performed_at, performed_by
		) VALUES ($1, $2, $3, 'time_out', ARRAY['nurse-1'], $4, 'nurse-1')`,
		uuid.NewString(), f.tenantID, c.ID, at)
	if err == nil {
		t.Fatal("a solo time-out was accepted by the database")
	}
}

// And a time-out naming nobody at all, which is the case the obvious spelling
// of the constraint lets through: array_length of an empty array is NULL, and
// a CHECK that evaluates to NULL passes.
func TestTheDatabaseRefusesATimeOutWithNobodyPresent(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO theatre.safety_check (
		    check_id, tenant_id, case_id, phase, participants,
		    performed_at, performed_by
		) VALUES ($1, $2, $3, 'time_out', '{}', $4, 'nurse-1')`,
		uuid.NewString(), f.tenantID, c.ID, at)
	if err == nil {
		t.Fatal("a time-out with no participants was accepted by the database")
	}
}

// SRS-OT-008 and SRS-OT-015. The board and the utilisation report read many
// cases at once, and both clocks on each milestone have to survive.
func TestMilestonesAreReadForManyCasesAtOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	first := f.surgeryCase(t)
	second := f.surgeryCase(t)

	for _, c := range []domain.Case{first, second} {
		record, err := domain.RecordMilestone(uuid.NewString(), f.tenantID, c.ID,
			domain.MilestoneTheatreIn, at.Add(-30*time.Minute), "nurse-1", "", at)
		if err != nil {
			t.Fatalf("RecordMilestone: %v", err)
		}
		if err := f.cases.InsertMilestone(ctx, f.scope, record); err != nil {
			t.Fatalf("InsertMilestone: %v", err)
		}
	}

	byCase, err := f.cases.MilestonesFor(ctx, f.scope, []string{first.ID, second.ID})
	if err != nil {
		t.Fatalf("MilestonesFor: %v", err)
	}
	if len(byCase) != 2 {
		t.Fatalf("%d cases came back, want 2", len(byCase))
	}
	record := byCase[first.ID][0]
	if !record.OccurredAt.Equal(at.Add(-30 * time.Minute)) {
		t.Fatalf("occurred at %v, want the recorded time", record.OccurredAt)
	}
	if !record.RecordedAt.Equal(at) {
		t.Fatalf("recorded at %v; the gap between the clocks is what says a "+
			"list was written up afterwards", record.RecordedAt)
	}

	// An empty request is not a query.
	empty, err := f.cases.MilestonesFor(ctx, f.scope, nil)
	if err != nil || len(empty) != 0 {
		t.Fatalf("MilestonesFor(nil) = %v / %v", empty, err)
	}
}

// SRS-OT-009. An amendment is a new version and the original is marked
// superseded: the document read in a claim cannot have had its history
// overwritten.
func TestAnAmendedNoteKeepsBothVersions(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	note, err := domain.NewOperativeNote(uuid.NewString(), f.tenantID,
		domain.NewNoteInput{
			CaseID: c.ID, ProcedurePerformed: "Right hemicolectomy",
			Findings: "Tumour at the hepatic flexure", EstimatedBloodLossML: 250,
			Complications: []string{"none"},
		}, "surgeon-1", at)
	if err != nil {
		t.Fatalf("NewOperativeNote: %v", err)
	}
	if err := f.cases.InsertNote(ctx, f.scope, note); err != nil {
		t.Fatalf("InsertNote: %v", err)
	}

	signed, err := f.cases.SignNote(ctx, f.scope, note.ID, "surgeon-1", at.Add(time.Hour))
	if err != nil || !signed {
		t.Fatalf("SignNote: %v (signed=%v)", err, signed)
	}
	// Signing twice is a race the repository settles.
	if again, _ := f.cases.SignNote(ctx, f.scope, note.ID, "surgeon-1",
		at.Add(2*time.Hour)); again {
		t.Fatal("a note was signed twice")
	}

	note.Status, note.SignedBy = domain.NoteSigned, "surgeon-1"
	amended, err := note.Amend(uuid.NewString(), domain.NewNoteInput{
		ProcedurePerformed:   "Extended right hemicolectomy",
		EstimatedBloodLossML: 250,
	}, "extent of resection recorded incorrectly", "surgeon-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	if err := f.cases.InsertNote(ctx, f.scope, amended); err != nil {
		t.Fatalf("InsertNote(amended): %v", err)
	}
	if _, err := f.cases.SupersedeNote(ctx, f.scope, note.ID); err != nil {
		t.Fatalf("SupersedeNote: %v", err)
	}

	notes, err := f.cases.Notes(ctx, f.scope, c.ID)
	if err != nil {
		t.Fatalf("Notes: %v", err)
	}
	if len(notes) != 2 {
		t.Fatalf("%d notes, want both versions kept", len(notes))
	}
	if notes[0].Status != domain.NoteSuperseded {
		t.Fatalf("version 1 status = %q, want superseded", notes[0].Status)
	}
	if notes[1].Version != 2 || notes[1].Supersedes != note.ID {
		t.Fatalf("version 2 = %+v", notes[1])
	}
	if notes[1].AmendmentReason == "" {
		t.Fatal("the amendment reason was lost; it is the entry a claim asks about")
	}
}

// SRS-OT-010. A recall is worked from the item and the lot, and the query has
// to reach the patient — which is the only direction that matters when a
// manufacturer writes.
func TestARecallFindsThePatientsWhoReceivedTheImplant(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	affected := f.surgeryCase(t)
	other := f.surgeryCase(t)

	for _, item := range []struct {
		c      domain.Case
		serial string
		lot    string
	}{
		{affected, "SN-1", "LOT-A"},
		{other, "SN-2", "LOT-B"},
	} {
		usage, err := domain.RecordUsage(uuid.NewString(), f.tenantID,
			domain.NewUsageInput{
				CaseID: item.c.ID, Kind: domain.UsageImplant,
				ItemCode: "HIP-001", ItemName: "Acetabular cup",
				SerialNumber: item.serial, LotNumber: item.lot, Quantity: 1,
				Scanned: true, ScanData: "01009...",
			}, "nurse-1", at)
		if err != nil {
			t.Fatalf("RecordUsage: %v", err)
		}
		if err := f.cases.InsertUsage(ctx, f.scope, usage); err != nil {
			t.Fatalf("InsertUsage: %v", err)
		}
	}

	all, err := f.cases.ImplantRecipients(ctx, f.scope, "HIP-001", "")
	if err != nil {
		t.Fatalf("ImplantRecipients: %v", err)
	}
	if len(all) != 2 {
		t.Fatalf("%d recipients of the item, want 2", len(all))
	}

	byLot, err := f.cases.ImplantRecipients(ctx, f.scope, "HIP-001", "LOT-A")
	if err != nil {
		t.Fatalf("ImplantRecipients(lot): %v", err)
	}
	if len(byLot) != 1 {
		t.Fatalf("%d recipients of the recalled lot, want 1", len(byLot))
	}
	if byLot[0].PatientID != affected.PatientID {
		t.Fatalf("recall reached patient %q, want %q",
			byLot[0].PatientID, affected.PatientID)
	}
	if byLot[0].Reference != "SN-1" {
		t.Fatalf("reference = %q, want the serial that identifies the device",
			byLot[0].Reference)
	}
}

// The database refuses an untraceable implant, so the guarantee does not
// depend on the application layer being careful.
func TestTheDatabaseRefusesAnUntraceableImplant(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO theatre.usage (
		    usage_id, tenant_id, case_id, kind, item_code, quantity,
		    recorded_at, recorded_by
		) VALUES ($1, $2, $3, 'implant', 'HIP-001', 1, $4, 'nurse-1')`,
		uuid.NewString(), f.tenantID, c.ID, at)
	if err == nil {
		t.Fatal("an implant with no serial and no lot was accepted by the database")
	}
}

// SRS-OT-011. A specimen with no order is the one found in a fridge on Monday,
// and accessioning it twice would let two orders claim one pot.
func TestASpecimenIsAccessionedOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	c := f.surgeryCase(t)

	specimen, err := domain.TakeSpecimen(uuid.NewString(), f.tenantID,
		domain.NewSpecimenInput{
			CaseID: c.ID, PatientID: c.PatientID, Label: "Pot 1",
			Site: "hepatic flexure", Laterality: domain.LateralityRight,
			Container: "formalin pot", Fixative: "10% formalin",
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("TakeSpecimen: %v", err)
	}
	if err := f.cases.InsertSpecimen(ctx, f.scope, specimen); err != nil {
		t.Fatalf("InsertSpecimen: %v", err)
	}

	outstanding, err := f.cases.UnaccessionedSpecimens(ctx, f.scope, f.facilityID, 50)
	if err != nil {
		t.Fatalf("UnaccessionedSpecimens: %v", err)
	}
	if len(outstanding) != 1 {
		t.Fatalf("%d outstanding specimens, want 1", len(outstanding))
	}
	// The site survives, which is half of every histology report.
	if outstanding[0].Site != "hepatic flexure" {
		t.Fatalf("site = %q", outstanding[0].Site)
	}

	orderID := uuid.NewString()
	linked, err := f.cases.Accession(ctx, f.scope, specimen.ID, orderID)
	if err != nil || !linked {
		t.Fatalf("Accession: %v (linked=%v)", err, linked)
	}
	if again, _ := f.cases.Accession(ctx, f.scope, specimen.ID,
		uuid.NewString()); again {
		t.Fatal("a specimen was accessioned twice")
	}

	after, err := f.cases.UnaccessionedSpecimens(ctx, f.scope, f.facilityID, 50)
	if err != nil {
		t.Fatalf("UnaccessionedSpecimens after: %v", err)
	}
	if len(after) != 0 {
		t.Fatalf("%d specimens still outstanding", len(after))
	}
}

// SRS-OT-012. An infection is investigated backwards from the patient, and the
// query has to run the other way too: from a cycle to the patients it touched.
func TestASterilisationCycleReachesThePatientsItTouched(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	first := f.surgeryCase(t)
	second := f.surgeryCase(t)

	for _, c := range []domain.Case{first, second} {
		use, err := domain.OpenTray(uuid.NewString(), f.tenantID, c.ID,
			"tray-9", "Major general set", "cycle-44", true, "", "nurse-1", at)
		if err != nil {
			t.Fatalf("OpenTray: %v", err)
		}
		if err := f.cases.InsertTrayUse(ctx, f.scope, use); err != nil {
			t.Fatalf("InsertTrayUse: %v", err)
		}
	}

	touched, err := f.cases.CycleRecipients(ctx, f.scope, "cycle-44")
	if err != nil {
		t.Fatalf("CycleRecipients: %v", err)
	}
	if len(touched) != 2 {
		t.Fatalf("%d patients reached by the cycle, want 2", len(touched))
	}

	// And the case's own view keeps the cycle, which is what is read the other
	// way round.
	uses, err := f.cases.TrayUses(ctx, f.scope, first.ID)
	if err != nil {
		t.Fatalf("TrayUses: %v", err)
	}
	if len(uses) != 1 || uses[0].CycleID != "cycle-44" {
		t.Fatalf("tray uses = %+v", uses)
	}
}

// SRS-OT-016. A card is upserted per surgeon and procedure, and its version
// counts up so a case seeded last month can be read against the card it was
// seeded from.
func TestAPreferenceCardIsUpsertedAndVersioned(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	card := domain.PreferenceCard{
		ID: uuid.NewString(), TenantID: f.tenantID,
		SurgeonID: "surgeon-1", ProcedureCode: "M65.3", Name: "Trigger finger",
		Equipment:   []string{"tourniquet"},
		Consumables: []domain.CardItem{{ItemCode: "SUT-1", ItemName: "Suture", Quantity: 2}},
		UpdatedAt:   at, UpdatedBy: "surgeon-1",
	}
	if err := f.cases.SaveCard(ctx, f.scope, card); err != nil {
		t.Fatalf("SaveCard: %v", err)
	}

	card.Equipment = []string{"tourniquet", "loupes"}
	card.UpdatedAt = at.Add(time.Hour)
	if err := f.cases.SaveCard(ctx, f.scope, card); err != nil {
		t.Fatalf("SaveCard (update): %v", err)
	}

	got, found, err := f.cases.Card(ctx, f.scope, "surgeon-1", "M65.3")
	if err != nil || !found {
		t.Fatalf("Card: %v (found=%v)", err, found)
	}
	if got.Version != 2 {
		t.Fatalf("version = %d, want 2", got.Version)
	}
	if len(got.Equipment) != 2 {
		t.Fatalf("equipment = %v", got.Equipment)
	}
	if len(got.Consumables) != 1 || got.Consumables[0].Quantity != 2 {
		t.Fatalf("consumables = %+v", got.Consumables)
	}

	// Most procedures have no card, and that is not an error.
	_, found, err = f.cases.Card(ctx, f.scope, "surgeon-2", "M65.3")
	if err != nil {
		t.Fatalf("Card (absent): %v", err)
	}
	if found {
		t.Fatal("a card was found for a surgeon who has none")
	}
}

// A case belonging to another tenant is not readable through this scope, and
// the refusal is not-found: a probe must not be able to confirm an identifier
// exists elsewhere.
func TestAnotherTenantsCaseIsNotFound(t *testing.T) {
	f := newFixture(t)
	c := f.surgeryCase(t)

	other := authctx.NewSession(authctx.Session{
		SubjectID: "nurse-2", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.schedule.Case(context.Background(), other, c.ID); err == nil {
		t.Fatal("a case was readable from another tenant's scope")
	}
}
