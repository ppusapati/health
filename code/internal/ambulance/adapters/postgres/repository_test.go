package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/ambulance/adapters/postgres"
	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The ambulance persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost override turns a dispatch somebody authorised into an
// ordinary one; a lost amendment turns a corrected timeline into an original;
// a lost retention horizon turns a feed the deployment said it keeps for an
// hour into one it keeps forever.
//
// The assertions that bypass the adapter and write raw SQL are the rules that
// belong to the database rather than to Go: a rule the adapter is the only
// thing enforcing is one a migration, a backfill or the next context's
// repository can walk straight past. Two of them here span rows — a transport
// van answering an emergency, and a crew rostered to a different vehicle —
// and are held by composite foreign keys rather than by this package
// remembering.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

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
			SubjectID: "amb-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against
// a caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string, args ...any) {
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

func (f fixture) vehicle(t *testing.T, kind domain.VehicleKind,
	registration string) domain.Vehicle {

	t.Helper()
	v, err := domain.NewVehicle(uuid.NewString(), f.tenantID,
		domain.NewVehicleInput{
			Registration: registration, CallSign: registration,
			Kind: kind, Capabilities: []string{"monitor", "stretcher"},
		}, "fleet-1", at)
	if err != nil {
		t.Fatalf("NewVehicle: %v", err)
	}
	if err := f.repo.InsertVehicle(context.Background(), f.scope,
		v); err != nil {
		t.Fatalf("InsertVehicle: %v", err)
	}
	return v
}

func (f fixture) check(t *testing.T, vehicleID string,
	mutate func(*domain.NewCheckInput)) domain.ReadinessCheck {

	t.Helper()
	in := domain.NewCheckInput{
		VehicleID: vehicleID,
		Items: []domain.ReadinessItem{
			{Code: "defib", Label: "Defibrillator", Critical: true},
			{Code: "blankets", Label: "Blankets"},
		},
		Outcomes: []domain.ItemOutcome{
			{Code: "defib", Present: true},
			{Code: "blankets", Present: true},
		},
		OxygenBar: 180, OxygenMinimumBar: 100, ValidFor: 12 * time.Hour,
	}
	if mutate != nil {
		mutate(&in)
	}
	c, err := domain.RecordCheck(uuid.NewString(), f.tenantID, in,
		"crew-1", at)
	if err != nil {
		t.Fatalf("RecordCheck: %v", err)
	}
	if err := f.repo.InsertCheck(context.Background(), f.scope, c); err != nil {
		t.Fatalf("InsertCheck: %v", err)
	}
	return c
}

func (f fixture) shift(t *testing.T, vehicleID string) domain.Shift {
	t.Helper()
	s, err := domain.NewShift(uuid.NewString(), f.tenantID,
		domain.NewShiftInput{
			VehicleID: vehicleID,
			Crew: []domain.CrewMember{
				{SubjectID: "crew-1", Name: "A Driver",
					Role: domain.CrewDriver},
				{SubjectID: "crew-2", Name: "A Paramedic",
					Role: domain.CrewParamedic, RegistrationNumber: "P-1"},
			},
			StartsAt: at.Add(-time.Hour), EndsAt: at.Add(11 * time.Hour),
		}, "fleet-1", at)
	if err != nil {
		t.Fatalf("NewShift: %v", err)
	}
	if err := s.Start(at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := f.repo.InsertShift(context.Background(), f.scope,
		s); err != nil {
		t.Fatalf("InsertShift: %v", err)
	}
	return s
}

func (f fixture) request(t *testing.T,
	priority domain.Priority) domain.Request {

	t.Helper()
	r, err := domain.RaiseRequest(uuid.NewString(), f.tenantID,
		domain.NewRequestInput{
			Kind: domain.RequestEmergency, Priority: priority,
			OriginName: "12 Mount Road", ClinicalNeed: "chest pain",
			RequiredCapabilities: []string{"monitor"},
		}, "dispatch-1", at)
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}
	if err := f.repo.InsertRequest(context.Background(), f.scope,
		r); err != nil {
		t.Fatalf("InsertRequest: %v", err)
	}
	return r
}

func TestAVehicleAndItsReadinessSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")
	back, err := f.repo.Vehicle(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Vehicle: %v", err)
	}
	// A vehicle read back as available when it was registered off the run
	// is one a dispatcher can send before anybody looked inside it.
	if back.State != domain.VehicleOutOfService ||
		back.OutOfServiceReason == "" {
		t.Fatalf("the state did not survive: %+v", back)
	}
	if back.Kind != domain.VehicleALS || len(back.Capabilities) != 2 {
		t.Fatalf("the vehicle did not survive: %+v", back)
	}

	failed := f.check(t, stored.ID, func(in *domain.NewCheckInput) {
		in.Outcomes[0] = domain.ItemOutcome{
			Code: "defib", Present: false, Note: "away for service",
		}
	})
	latest, err := f.repo.LatestCheck(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("LatestCheck: %v", err)
	}
	// Which critical item was missing is the number that tells a service
	// what to buy, and it is lost if only the verdict is stored.
	if latest.State != domain.CheckFailed || len(latest.Missing) != 1 ||
		latest.Missing[0] != "defib" {
		t.Fatalf("the failure did not survive: %+v", latest)
	}
	critical := map[string]bool{}
	for _, item := range latest.Items {
		critical[item.Code] = item.Critical
	}
	// Which items were critical is pinned beside the answers, so a
	// checklist edited next month does not change what this check asked.
	if len(latest.Outcomes) != 2 || !critical["defib"] ||
		critical["blankets"] {
		t.Fatalf("the checklist did not survive: %+v", latest)
	}

	// An override is its own state, so a readiness report cannot count it
	// as a pass.
	overridden := failed
	if err := overridden.Override("no spare vehicle", "duty-officer",
		at); err != nil {
		t.Fatalf("Override: %v", err)
	}
	if err := f.repo.UpdateOverride(ctx, f.scope, overridden,
		failed.Version); err != nil {
		t.Fatalf("UpdateOverride: %v", err)
	}
	back2, err := f.repo.Check(ctx, f.scope, failed.ID)
	if err != nil {
		t.Fatalf("Check: %v", err)
	}
	if back2.State != domain.CheckOverridden ||
		back2.OverrideBy != "duty-officer" ||
		back2.OverrideReason == "" || back2.OverrideAt.IsZero() {
		t.Fatalf("the override did not survive: %+v", back2)
	}
	// The outcomes are what somebody found; an override does not rewrite
	// them into a pass.
	if len(back2.Missing) != 1 {
		t.Fatalf("the override rewrote the findings: %+v", back2)
	}

	// A stale write loses rather than silently overwriting somebody else's.
	if err := f.repo.UpdateOverride(ctx, f.scope, overridden,
		failed.Version); err != ports.ErrVersionConflict {
		t.Fatalf("want a version conflict, got %v", err)
	}
}

func TestTheDatabaseRefusesAVehicleAndCheckTheDomainWouldRefuse(
	t *testing.T) {

	f := newFixture(t)
	v := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")

	// A vehicle off the run for no recorded reason is one nobody can chase
	// back on.
	f.mustFail(t, "a_vehicle_off_the_run_says_why",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, created_by)
		 VALUES ($1, $2, 'KA-02', 'bls', 'out_of_service', 'fleet-1')`,
		uuid.NewString(), f.tenantID)

	// A vehicle "available" with no expiry never goes out of date, which is
	// the same thing as never being checked again.
	f.mustFail(t, "a_vehicle_on_the_run_is_in_date",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, created_by)
		 VALUES ($1, $2, 'KA-03', 'bls', 'available', 'fleet-1')`,
		uuid.NewString(), f.tenantID)

	// One plate is one vehicle: two rows are two readiness histories, and a
	// dispatcher reads whichever they opened.
	f.mustFail(t, "vehicle_registration_idx",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, out_of_service_reason, created_by)
		 VALUES ($1, $2, 'ka-01-ab-1234', 'bls', 'out_of_service', 'new',
		     'fleet-1')`,
		uuid.NewString(), f.tenantID)

	// Somebody who found the oxygen empty and then waved it through is one
	// person deciding both.
	f.mustFail(t, "a_check_is_overridden_by_somebody_else",
		`INSERT INTO ambulance.readiness_check (check_id, tenant_id,
		    vehicle_id, state, checked_by, override_by, override_reason,
		    override_at, valid_until, checked_at)
		 VALUES ($1, $2, $3, 'overridden', 'crew-1', 'crew-1', 'we are
		     short', $4, $5, $4)`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(time.Hour))

	// A check that never lapses is a vehicle checked once in March.
	f.mustFail(t, "a_check_holds_for_a_while",
		`INSERT INTO ambulance.readiness_check (check_id, tenant_id,
		    vehicle_id, state, checked_by, valid_until, checked_at)
		 VALUES ($1, $2, $3, 'passed', 'crew-1', $4, $4)`,
		uuid.NewString(), f.tenantID, v.ID, at)

	// A missing item with no note is indistinguishable from one nobody
	// looked for.
	check := f.check(t, v.ID, nil)
	f.mustFail(t, "a_missing_item_says_why",
		`INSERT INTO ambulance.readiness_outcome (check_id, item_code,
		    present) VALUES ($1, 'oxygen', false)`,
		check.ID)

	// A vehicle with no plate cannot be matched to anything a workshop, an
	// insurer or a police report says about it.
	f.mustFail(t, "a_vehicle_names_its_registration",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, out_of_service_reason, created_by)
		 VALUES ($1, $2, '', 'bls', 'out_of_service', 'new', 'fleet-1')`,
		uuid.NewString(), f.tenantID)
	f.mustFail(t, "a_vehicle_names_who_registered_it",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, out_of_service_reason, created_by)
		 VALUES ($1, $2, 'KA-04', 'bls', 'out_of_service', 'new', '')`,
		uuid.NewString(), f.tenantID)

	// A shift that ends before it starts covers no time at all, and every
	// on-duty test against it answers no.
	f.mustFail(t, "a_shift_ends_after_it_starts",
		`INSERT INTO ambulance.shift (shift_id, tenant_id, vehicle_id,
		    state, starts_at, ends_at, created_by)
		 VALUES ($1, $2, $3, 'planned', $4, $4, 'fleet-1')`,
		uuid.NewString(), f.tenantID, v.ID, at)
	// A crew "on duty" since nobody knows when is a crew whose hours
	// nobody can check against the drug they gave at four in the morning.
	f.mustFail(t, "a_shift_on_duty_says_when_it_started",
		`INSERT INTO ambulance.shift (shift_id, tenant_id, vehicle_id,
		    state, starts_at, ends_at, created_by)
		 VALUES ($1, $2, $3, 'on_duty', $4, $5, 'fleet-1')`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(8*time.Hour))
	f.mustFail(t, "a_shift_names_who_rostered_it",
		`INSERT INTO ambulance.shift (shift_id, tenant_id, vehicle_id,
		    state, starts_at, ends_at, created_by)
		 VALUES ($1, $2, $3, 'planned', $4, $5, '')`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(8*time.Hour))

	// One person twice is a crew of two that is really a crew of one.
	shift := f.shift(t, v.ID)
	f.mustFail(t, "shift_crew_pkey",
		`INSERT INTO ambulance.shift_crew (shift_id, subject_id, role)
		 VALUES ($1, 'crew-1', 'emt')`,
		shift.ID)
	// A crew member with no id is somebody the record cannot name later.
	f.mustFail(t, "a_crew_member_needs_an_id",
		`INSERT INTO ambulance.shift_crew (shift_id, subject_id, role)
		 VALUES ($1, '', 'emt')`,
		shift.ID)

	// An override with no name and no reason is a vehicle waved onto the
	// run by nobody.
	f.mustFail(t, "an_overridden_check_names_who_and_why",
		`INSERT INTO ambulance.readiness_check (check_id, tenant_id,
		    vehicle_id, state, checked_by, valid_until, checked_at)
		 VALUES ($1, $2, $3, 'overridden', 'crew-1', $5, $4)`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(time.Hour))
	// A check that passed has nothing to override, so an override recorded
	// against one is an override of something that never failed.
	f.mustFail(t, "only_a_failed_check_is_overridden",
		`INSERT INTO ambulance.readiness_check (check_id, tenant_id,
		    vehicle_id, state, checked_by, override_by, override_reason,
		    override_at, valid_until, checked_at)
		 VALUES ($1, $2, $3, 'passed', 'crew-1', 'duty-officer', 'why',
		     $4, $5, $4)`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(time.Hour))
	f.mustFail(t, "a_check_names_who_made_it",
		`INSERT INTO ambulance.readiness_check (check_id, tenant_id,
		    vehicle_id, state, checked_by, valid_until, checked_at)
		 VALUES ($1, $2, $3, 'passed', '', $5, $4)`,
		uuid.NewString(), f.tenantID, v.ID, at, at.Add(time.Hour))

	// An answer against no item is an answer to nothing.
	f.mustFail(t, "a_checklist_item_needs_a_code",
		`INSERT INTO ambulance.readiness_outcome (check_id, item_code,
		    present) VALUES ($1, '', true)`,
		check.ID)
	// One item, one answer. Two rows saying the defibrillator was and was
	// not there is a check that reads as a pass to whichever query sorted
	// first.
	f.mustFail(t, "readiness_outcome_pkey",
		`INSERT INTO ambulance.readiness_outcome (check_id, item_code,
		    present, note) VALUES ($1, 'defib', false, 'actually gone')`,
		check.ID)

	// A vehicle of a kind nobody defined is one the emergency check cannot
	// classify: "not a transport van" is true of a minibus.
	f.mustFail(t, "vehicle_kind_check",
		`INSERT INTO ambulance.vehicle (vehicle_id, tenant_id,
		    registration, kind, state, out_of_service_reason, created_by)
		 VALUES ($1, $2, 'KA-05', 'minibus', 'out_of_service', 'new',
		     'fleet-1')`,
		uuid.NewString(), f.tenantID)
}

func TestATripAndItsTimelineSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	vehicle := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")
	if err := vehicle.GoAvailable(f.check(t, vehicle.ID, nil),
		at); err != nil {
		t.Fatalf("GoAvailable: %v", err)
	}
	shift := f.shift(t, vehicle.ID)
	request := f.request(t, domain.PriorityImmediate)

	trip, err := domain.Dispatch(uuid.NewString(), f.tenantID, request,
		vehicle, shift, "", "", "dispatch-1", at)
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if err := f.repo.InsertTrip(ctx, f.scope, trip); err != nil {
		t.Fatalf("InsertTrip: %v", err)
	}

	back, err := f.repo.Trip(ctx, f.scope, trip.ID)
	if err != nil {
		t.Fatalf("Trip: %v", err)
	}
	// The crew pinned at dispatch. A list read back off the shift next
	// month is the crew the shift has then, not the crew who went.
	if len(back.CrewSubjects) != 2 {
		t.Fatalf("the crew did not survive: %+v", back)
	}
	if len(back.Milestones) != 1 ||
		back.Milestones[0].Milestone != domain.MilestoneDispatched {
		t.Fatalf("the dispatch milestone did not survive: %+v",
			back.Milestones)
	}

	if err := back.RecordMilestone(domain.MilestoneMobile, "", "crew-1",
		at.Add(time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
	if err := f.repo.AppendMilestone(ctx, f.scope, uuid.NewString(),
		back.ID, back.Milestones[len(back.Milestones)-1]); err != nil {
		t.Fatalf("AppendMilestone: %v", err)
	}
	if err := back.RecordMilestone(domain.MilestoneAtScene, "", "crew-1",
		at.Add(8*time.Minute)); err != nil {
		t.Fatalf("RecordMilestone: %v", err)
	}
	if err := f.repo.AppendMilestone(ctx, f.scope, uuid.NewString(),
		back.ID, back.Milestones[len(back.Milestones)-1]); err != nil {
		t.Fatalf("AppendMilestone: %v", err)
	}

	if err := back.AmendMilestone(domain.MilestoneAtScene,
		at.Add(6*time.Minute), "tablet clock was two minutes fast",
		"crew-2", at.Add(time.Hour)); err != nil {
		t.Fatalf("AmendMilestone: %v", err)
	}
	if err := f.repo.AppendMilestone(ctx, f.scope, uuid.NewString(),
		back.ID, back.Milestones[len(back.Milestones)-1]); err != nil {
		t.Fatalf("AppendMilestone: %v", err)
	}

	corrected, err := f.repo.Trip(ctx, f.scope, trip.ID)
	if err != nil {
		t.Fatalf("Trip: %v", err)
	}
	// "The arrival time was changed an hour after the job" is a question
	// somebody asks, and a timeline holding one value per point could not
	// answer it.
	arrival, found := corrected.MilestoneAt(domain.MilestoneAtScene)
	if !found || !arrival.Equal(at.Add(6*time.Minute)) {
		t.Fatalf("the correction did not survive: %v", arrival)
	}
	original := false
	for _, record := range corrected.Milestones {
		if record.Milestone == domain.MilestoneAtScene &&
			record.AmendsAt.IsZero() &&
			record.At.Equal(at.Add(8*time.Minute)) {
			original = true
		}
		if !record.AmendsAt.IsZero() &&
			(record.AmendReason == "" || record.AmendedAt.IsZero()) {
			t.Fatalf("the amendment lost its why or when: %+v", record)
		}
	}
	if !original {
		t.Fatalf("the original arrival time was erased: %+v",
			corrected.Milestones)
	}
}

func TestTheDatabaseRefusesADispatchTheDomainWouldRefuse(t *testing.T) {
	f := newFixture(t)

	als := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")
	van := f.vehicle(t, domain.VehicleTransport, "KA-09-ZZ-9999")
	alsShift := f.shift(t, als.ID)
	vanShift := f.shift(t, van.ID)
	urgent := f.request(t, domain.PriorityImmediate)
	routine := f.request(t, domain.PriorityRoutine)

	insert := `INSERT INTO ambulance.trip (trip_id, tenant_id, request_id,
	    vehicle_id, shift_id, priority, vehicle_kind, shift_vehicle_id,
	    state, started_by)
	 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'active', 'dispatch-1')`

	// A patient transport van sent to a cardiac arrest is a van with no
	// defibrillator in it, and no override makes one appear. The rule spans
	// two other rows and is held by composite foreign keys.
	f.mustFail(t, "a_transport_van_does_not_answer_an_emergency",
		insert, uuid.NewString(), f.tenantID, urgent.ID, van.ID,
		vanShift.ID, "immediate", "transport", van.ID)

	// The denormalised columns cannot be lied about: they are checked
	// against the rows they were copied from.
	f.mustFail(t, "trip_vehicle_id_vehicle_kind_fkey",
		insert, uuid.NewString(), f.tenantID, urgent.ID, van.ID,
		vanShift.ID, "immediate", "als", van.ID)
	f.mustFail(t, "trip_request_id_priority_fkey",
		insert, uuid.NewString(), f.tenantID, urgent.ID, van.ID,
		vanShift.ID, "routine", "transport", van.ID)

	// A trip naming Alpha 1 and the crew of Bravo 3 produces a prehospital
	// record naming people who were never in that vehicle.
	f.mustFail(t, "the_crew_is_rostered_to_the_trips_vehicle",
		insert, uuid.NewString(), f.tenantID, routine.ID, als.ID,
		vanShift.ID, "routine", "als", van.ID)
	f.mustFail(t, "trip_shift_id_shift_vehicle_id_fkey",
		insert, uuid.NewString(), f.tenantID, routine.ID, als.ID,
		vanShift.ID, "routine", "als", als.ID)

	// The van answers a routine discharge without complaint, so the rule
	// above is about the emergency and not about the van.
	f.mustExec(t, insert, uuid.NewString(), f.tenantID, routine.ID, van.ID,
		vanShift.ID, "routine", "transport", van.ID)

	// One running trip per call: a second active trip is two vehicles sent
	// to one patient. The index is partial, so an aborted attempt can be
	// followed by another — which is what a broken-down vehicle needs.
	f.mustFail(t, "trip_active_per_request_idx",
		insert, uuid.NewString(), f.tenantID, routine.ID, als.ID,
		alsShift.ID, "routine", "als", als.ID)
	f.mustExec(t,
		`UPDATE ambulance.trip SET state = 'aborted',
		     abort_reason = 'broke down', ended_at = now()
		 WHERE request_id = $1`, routine.ID)
	f.mustExec(t, insert, uuid.NewString(), f.tenantID, routine.ID, als.ID,
		alsShift.ID, "routine", "als", als.ID)

	// An override is a named person and a reason, together or not at all.
	trip := uuid.NewString()
	f.mustExec(t, insert, trip, f.tenantID, urgent.ID, als.ID, alsShift.ID,
		"immediate", "als", als.ID)
	f.mustFail(t, "an_override_is_a_name_and_a_reason",
		`UPDATE ambulance.trip SET override_by = 'duty-officer'
		 WHERE trip_id = $1`, trip)

	// Two "at scene" times is one response figure that is whichever the
	// report reached first.
	milestone := `INSERT INTO ambulance.trip_milestone (milestone_id,
	    tenant_id, trip_id, milestone, occurred_at, recorded_by)
	 VALUES ($1, $2, $3, 'at_scene', $4, 'crew-1')`
	f.mustExec(t, milestone, uuid.NewString(), f.tenantID, trip, at)
	f.mustFail(t, "trip_milestone_once_idx",
		milestone, uuid.NewString(), f.tenantID, trip, at.Add(time.Minute))

	// A correction with no reason is a timeline somebody rewrote.
	f.mustFail(t, "an_amendment_says_why_and_when",
		`INSERT INTO ambulance.trip_milestone (milestone_id, tenant_id,
		    trip_id, milestone, occurred_at, recorded_by, amends_at)
		 VALUES ($1, $2, $3, 'at_scene', $4, 'crew-1', $5)`,
		uuid.NewString(), f.tenantID, trip, at.Add(-time.Minute), at)
	// And a reason on a record that corrects nothing reads as an amendment
	// while sitting in the unique index as an original.
	f.mustFail(t, "an_original_record_amends_nothing",
		`INSERT INTO ambulance.trip_milestone (milestone_id, tenant_id,
		    trip_id, milestone, occurred_at, recorded_by, amend_reason)
		 VALUES ($1, $2, $3, 'mobile', $4, 'crew-1', 'clock wrong')`,
		uuid.NewString(), f.tenantID, trip, at)
	f.mustFail(t, "a_milestone_names_who_recorded_it",
		`INSERT INTO ambulance.trip_milestone (milestone_id, tenant_id,
		    trip_id, milestone, occurred_at, recorded_by)
		 VALUES ($1, $2, $3, 'mobile', $4, '')`,
		uuid.NewString(), f.tenantID, trip, at)

	// A trip stood down for no recorded reason is a call that looks like
	// an abandonment.
	f.mustFail(t, "an_aborted_trip_says_why",
		`UPDATE ambulance.trip SET state = 'aborted', ended_at = $2
		 WHERE trip_id = $1`, trip, at)
	// A finished trip with no end time has a turnaround nobody can compute
	// and a vehicle that never comes back on the board.
	f.mustFail(t, "a_finished_trip_says_when",
		`UPDATE ambulance.trip SET state = 'completed' WHERE trip_id = $1`,
		trip)
	f.mustFail(t, "a_trip_names_who_dispatched_it",
		`INSERT INTO ambulance.trip (trip_id, tenant_id, request_id,
		    vehicle_id, shift_id, priority, vehicle_kind,
		    shift_vehicle_id, state, started_by)
		 VALUES ($1, $2, $3, $4, $5, 'routine', 'als', $4, 'active', '')`,
		uuid.NewString(), f.tenantID, f.request(t,
			domain.PriorityRoutine).ID, als.ID, alsShift.ID)
}

func TestAPrehospitalRecordSurvivesTheRoundTripAndItsRulesHold(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	vehicle := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")
	if err := vehicle.GoAvailable(f.check(t, vehicle.ID, nil),
		at); err != nil {
		t.Fatalf("GoAvailable: %v", err)
	}
	shift := f.shift(t, vehicle.ID)
	request := f.request(t, domain.PriorityImmediate)
	trip, err := domain.Dispatch(uuid.NewString(), f.tenantID, request,
		vehicle, shift, "", "", "dispatch-1", at)
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if err := f.repo.InsertTrip(ctx, f.scope, trip); err != nil {
		t.Fatalf("InsertTrip: %v", err)
	}

	record, err := domain.OpenRecord(uuid.NewString(), f.tenantID,
		domain.NewRecordInput{
			TripID: trip.ID, RequestID: request.ID,
			PresentingComplaint: "chest pain",
			DocumentRefs:        []string{"referral-1"},
		}, "crew-2", at)
	if err != nil {
		t.Fatalf("OpenRecord: %v", err)
	}
	if err := f.repo.InsertRecord(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertRecord: %v", err)
	}

	paramedic := domain.CrewMember{
		SubjectID: "crew-2", Name: "A Paramedic",
		Role: domain.CrewParamedic, RegistrationNumber: "P-1",
	}
	if err := record.Record(uuid.NewString(), domain.NewEntryInput{
		Kind: domain.EntryMedication, Code: "MORPH", DoseAmount: 5,
		DoseUnit: "mg", Route: "iv", RecordedAt: at.Add(5 * time.Minute),
	}, paramedic, at.Add(10*time.Minute)); err != nil {
		t.Fatalf("Record: %v", err)
	}
	if err := f.repo.AppendEntry(ctx, f.scope, record.ID,
		record.Entries[0]); err != nil {
		t.Fatalf("AppendEntry: %v", err)
	}

	back, err := f.repo.RecordForTrip(ctx, f.scope, trip.ID)
	if err != nil {
		t.Fatalf("RecordForTrip: %v", err)
	}
	if len(back.Entries) != 1 {
		t.Fatalf("the entry did not survive: %+v", back)
	}
	entry := back.Entries[0]
	// A dose that reads back as zero is a drug nobody can check against
	// anything, and a role that reads back empty is a record that names a
	// login rather than a registrant.
	if entry.DoseAmount != 5 || entry.DoseUnit != "mg" ||
		entry.Route != "iv" {
		t.Fatalf("the dose did not survive: %+v", entry)
	}
	if entry.RecordedRole != domain.CrewParamedic {
		t.Fatalf("the role did not survive: %+v", entry)
	}
	// A record written up two hours later is a different thing from one
	// written at the time, and both moments are kept.
	if !entry.RecordedAt.Equal(at.Add(5*time.Minute)) ||
		!entry.EnteredAt.Equal(at.Add(10*time.Minute)) {
		t.Fatalf("the two times were collapsed: %+v", entry)
	}
	if len(back.DocumentRefs) != 1 || back.DocumentRefs[0] != "referral-1" {
		t.Fatalf("the document reference did not survive: %+v", back)
	}

	// A driver does not record a drug, and the database says so as well as
	// the domain.
	f.mustFail(t, "an_entry_is_recorded_by_a_clinician",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, code, dose_amount, dose_unit, route,
		    recorded_by, recorded_role, recorded_at)
		 VALUES ($1, $2, $3, 'medication', 'MORPH', 5, 'mg', 'iv',
		     'crew-1', 'driver', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)

	f.mustFail(t, "a_medication_says_how_much",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, code, route, recorded_by, recorded_role,
		    recorded_at)
		 VALUES ($1, $2, $3, 'medication', 'MORPH', 'iv', 'crew-2',
		     'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)

	// A handover accepted by the person who gave it is the same claim made
	// twice.
	f.mustFail(t, "a_handover_is_accepted_by_somebody_else",
		`UPDATE ambulance.prehospital_record
		 SET state = 'accepted', sending_summary = 'chest pain',
		     given_by = 'crew-2', given_role = 'paramedic', given_at = $2,
		     accepted_by = 'crew-2', accepted_at = $2,
		     encounter_id = $3
		 WHERE record_id = $1`,
		record.ID, at, uuid.NewString())

	// And an accepted handover that attaches to nothing is the one thing
	// SRS-AMB-004 asks for, missing.
	f.mustFail(t, "an_accepted_handover_attaches_to_an_encounter",
		`UPDATE ambulance.prehospital_record
		 SET state = 'accepted', sending_summary = 'chest pain',
		     given_by = 'crew-2', given_role = 'paramedic', given_at = $2,
		     accepted_by = 'ed-doctor', accepted_at = $2
		 WHERE record_id = $1`,
		record.ID, at)

	// A driver does not give a clinical handover either.
	f.mustFail(t, "a_handover_is_given_by_a_clinician",
		`UPDATE ambulance.prehospital_record
		 SET state = 'given', sending_summary = 'chest pain',
		     given_by = 'crew-1', given_role = 'driver', given_at = $2
		 WHERE record_id = $1`,
		record.ID, at)

	f.mustFail(t, "a_medication_names_the_drug",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, dose_amount, dose_unit, route, recorded_by,
		    recorded_role, recorded_at)
		 VALUES ($1, $2, $3, 'medication', 5, 'mg', 'iv', 'crew-2',
		     'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)
	// The same drug goes into a vein or into a muscle at very different
	// speeds; a record that does not say which is not a record of what
	// happened.
	f.mustFail(t, "a_medication_says_how_it_was_given",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, code, dose_amount, dose_unit, recorded_by,
		    recorded_role, recorded_at)
		 VALUES ($1, $2, $3, 'medication', 'MORPH', 5, 'mg', 'crew-2',
		     'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)
	// "120/80" with nothing saying what was measured is a number on a
	// screen. A label alone is enough — "pupils equal and reactive" has no
	// code and is still an observation — but neither is not.
	f.mustExec(t,
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, label, value, recorded_by, recorded_role,
		    recorded_at)
		 VALUES ($1, $2, $3, 'observation', 'Pupils', 'equal and
		     reactive', 'crew-2', 'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)
	f.mustFail(t, "an_observation_says_what_was_measured",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, value, recorded_by, recorded_role,
		    recorded_at)
		 VALUES ($1, $2, $3, 'observation', '120/80', 'crew-2',
		     'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)
	f.mustFail(t, "an_entry_names_who_recorded_it",
		`INSERT INTO ambulance.prehospital_entry (entry_id, tenant_id,
		    record_id, kind, narrative, recorded_by, recorded_role,
		    recorded_at)
		 VALUES ($1, $2, $3, 'note', 'walked out', '', 'paramedic', $4)`,
		uuid.NewString(), f.tenantID, record.ID, at)

	// A handover "given" with nothing in it is a patient arriving with a
	// wristband and a shrug.
	f.mustFail(t, "a_given_handover_says_what_happened",
		`UPDATE ambulance.prehospital_record SET state = 'given'
		 WHERE record_id = $1`, record.ID)
	// And one accepted by nobody at no time is a patient nobody took.
	f.mustFail(t, "an_accepted_handover_names_who_and_when",
		`UPDATE ambulance.prehospital_record
		 SET state = 'accepted', sending_summary = 'chest pain',
		     given_by = 'crew-2', given_role = 'paramedic', given_at = $2,
		     encounter_id = $3
		 WHERE record_id = $1`,
		record.ID, at, uuid.NewString())
	f.mustFail(t, "a_record_names_who_opened_it",
		`INSERT INTO ambulance.prehospital_record (record_id, tenant_id,
		    trip_id, state, created_by)
		 VALUES ($1, $2, $3, 'draft', '')`,
		uuid.NewString(), f.tenantID, uuid.NewString())

	// An empty reference points at nothing, and a reader would take it for
	// a document that exists.
	f.mustFail(t, "a_document_reference_is_not_empty",
		`INSERT INTO ambulance.prehospital_document (record_id,
		    document_ref) VALUES ($1, '')`,
		record.ID)
	// The same reference twice is two rows for one document.
	f.mustFail(t, "prehospital_document_pkey",
		`INSERT INTO ambulance.prehospital_document (record_id,
		    document_ref) VALUES ($1, 'referral-1')`,
		record.ID)

	// One record per trip: two accounts of one journey is two sets of
	// medications, and the receiving doctor reads one of them.
	f.mustFail(t, "prehospital_record_trip_id_key",
		`INSERT INTO ambulance.prehospital_record (record_id, tenant_id,
		    trip_id, state, created_by)
		 VALUES ($1, $2, $3, 'draft', 'crew-2')`,
		uuid.NewString(), f.tenantID, trip.ID)
}

func TestTheLocationFeedIsBoundedByItsOwnHorizon(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	vehicle := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")

	fresh, err := domain.RecordPing(uuid.NewString(), f.tenantID,
		domain.NewPingInput{
			VehicleID: vehicle.ID, LatitudeMicro: 13_082_680,
			LongitudeMicro: 80_270_718, SpeedKph: 48,
			HeadingDegrees: 270, AccuracyMetres: 8,
			Source: "fleet-telematics", At: at,
		}, 24*time.Hour, at)
	if err != nil {
		t.Fatalf("RecordPing: %v", err)
	}
	stale, err := domain.RecordPing(uuid.NewString(), f.tenantID,
		domain.NewPingInput{
			VehicleID: vehicle.ID, LatitudeMicro: 13_000_000,
			LongitudeMicro: 80_000_000, Source: "fleet-telematics",
			At: at.Add(-2 * time.Hour),
		}, time.Hour, at.Add(-2*time.Hour))
	if err != nil {
		t.Fatalf("RecordPing: %v", err)
	}
	for _, p := range []domain.Ping{fresh, stale} {
		if err := f.repo.InsertPing(ctx, f.scope, p); err != nil {
			t.Fatalf("InsertPing: %v", err)
		}
	}

	// The read drops the expired ping without waiting for the purge: a
	// trail must not come back because a job is behind.
	pings, err := f.repo.Pings(ctx, f.scope, ports.PingFilter{
		VehicleID: vehicle.ID, AsOf: at})
	if err != nil {
		t.Fatalf("Pings: %v", err)
	}
	if len(pings) != 1 || pings[0].ID != fresh.ID {
		t.Fatalf("an expired ping reached the read: %+v", pings)
	}
	// Micro-degrees as integers: a float here would come back as 13.08268
	// and compare badly against what was written.
	if pings[0].LatitudeMicro != 13_082_680 ||
		pings[0].LongitudeMicro != 80_270_718 {
		t.Fatalf("the position did not survive: %+v", pings[0])
	}
	if pings[0].SpeedKph != 48 || pings[0].HeadingDegrees != 270 ||
		pings[0].Source != "fleet-telematics" {
		t.Fatalf("the ping did not survive: %+v", pings[0])
	}

	latest, err := f.repo.LatestPing(ctx, f.scope, vehicle.ID, at)
	if err != nil {
		t.Fatalf("LatestPing: %v", err)
	}
	if latest.ID != fresh.ID {
		t.Fatalf("the latest ping is wrong: %+v", latest)
	}
	if _, err := f.repo.LatestPing(ctx, f.scope, vehicle.ID,
		at.Add(48*time.Hour)); err == nil {
		t.Fatal("an expired feed produced a position")
	}

	removed, err := f.repo.PurgeExpired(ctx, f.scope, at)
	if err != nil {
		t.Fatalf("PurgeExpired: %v", err)
	}
	if removed != 1 {
		t.Fatalf("want one ping purged, got %d", removed)
	}

	// A ping with no horizon is a map of somebody's illnesses kept forever.
	f.mustFail(t, "null value in column \"retain_until\"",
		`INSERT INTO ambulance.location_ping (ping_id, tenant_id,
		    vehicle_id, latitude_micro, longitude_micro, source,
		    occurred_at)
		 VALUES ($1, $2, $3, 0, 0, 'box', $4)`,
		uuid.NewString(), f.tenantID, vehicle.ID, at)
	f.mustFail(t, "a_ping_stops_being_kept",
		`INSERT INTO ambulance.location_ping (ping_id, tenant_id,
		    vehicle_id, latitude_micro, longitude_micro, source,
		    occurred_at, retain_until)
		 VALUES ($1, $2, $3, 0, 0, 'box', $4, $4)`,
		uuid.NewString(), f.tenantID, vehicle.ID, at)

	// A latitude of 400 degrees puts an ambulance nowhere, and a map drawn
	// from it silently drops the vehicle rather than saying so.
	f.mustFail(t, "a_ping_has_a_real_latitude",
		`INSERT INTO ambulance.location_ping (ping_id, tenant_id,
		    vehicle_id, latitude_micro, longitude_micro, source,
		    occurred_at, retain_until)
		 VALUES ($1, $2, $3, 400000000, 0, 'box', $4, $5)`,
		uuid.NewString(), f.tenantID, vehicle.ID, at, at.Add(time.Hour))
	f.mustFail(t, "a_ping_has_a_real_longitude",
		`INSERT INTO ambulance.location_ping (ping_id, tenant_id,
		    vehicle_id, latitude_micro, longitude_micro, source,
		    occurred_at, retain_until)
		 VALUES ($1, $2, $3, 0, -400000000, 'box', $4, $5)`,
		uuid.NewString(), f.tenantID, vehicle.ID, at, at.Add(time.Hour))
	// A position with no provenance is one nobody can question when it is
	// wrong.
	f.mustFail(t, "a_ping_names_where_it_came_from",
		`INSERT INTO ambulance.location_ping (ping_id, tenant_id,
		    vehicle_id, latitude_micro, longitude_micro, source,
		    occurred_at, retain_until)
		 VALUES ($1, $2, $3, 0, 0, '', $4, $5)`,
		uuid.NewString(), f.tenantID, vehicle.ID, at, at.Add(time.Hour))

	// An estimate with no provider is a straight-line guess that looks like
	// an ETA, and a dispatcher would hold a bed against it.
	f.mustFail(t, "an_estimate_names_where_it_came_from",
		`INSERT INTO ambulance.eta (eta_id, tenant_id, vehicle_id,
		    seconds, source) VALUES ($1, $2, $3, 420, '')`,
		uuid.NewString(), f.tenantID, vehicle.ID)

	// There is no patient column to write to. The link is through the trip,
	// which is behind its own permission.
	var columns int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM information_schema.columns
		 WHERE table_schema = 'ambulance'
		   AND table_name = 'location_ping'
		   AND column_name IN ('patient_id', 'encounter_id',
		       'patient_name')`).Scan(&columns); err != nil {
		t.Fatalf("columns: %v", err)
	}
	if columns != 0 {
		t.Fatalf("the location feed carries %d patient columns", columns)
	}
}

func TestARequestRoundTripsAndTheQueueRulesHold(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.request(t, domain.PriorityUrgent)
	back, err := f.repo.Request(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Request: %v", err)
	}
	// The queue timestamp is the clock every response-time figure is
	// measured from; a lost one is a response time of zero.
	if !back.RequestedAt.Equal(at) || back.State != domain.RequestQueued {
		t.Fatalf("the request did not survive: %+v", back)
	}
	if back.ClinicalNeed == "" || len(back.RequiredCapabilities) != 1 {
		t.Fatalf("the clinical detail did not survive: %+v", back)
	}

	cancelled := back
	if err := cancelled.Cancel("patient made own way", "dispatch-1",
		at.Add(time.Minute)); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if err := f.repo.UpdateRequest(ctx, f.scope, cancelled,
		back.Version); err != nil {
		t.Fatalf("UpdateRequest: %v", err)
	}
	back2, err := f.repo.Request(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Request: %v", err)
	}
	// The cancellation rate is only useful with the reasons beside it.
	if back2.CancelReason == "" || back2.CancelledBy == "" ||
		back2.CancelledAt.IsZero() {
		t.Fatalf("the cancellation did not survive: %+v", back2)
	}

	// The clinical need decides which vehicle goes; without it a dispatcher
	// is choosing at random.
	f.mustFail(t, "a_request_says_what_the_patient_needs",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, origin_name, clinical_need, state, requested_by)
		 VALUES ($1, $2, 'emergency', 'urgent', 'a street', '', 'queued',
		     'dispatch-1')`,
		uuid.NewString(), f.tenantID)
	f.mustFail(t, "a_request_names_who_raised_it",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, origin_name, clinical_need, state, requested_by)
		 VALUES ($1, $2, 'emergency', 'urgent', 'a street', 'a fall',
		     'queued', '')`,
		uuid.NewString(), f.tenantID)

	f.mustFail(t, "a_cancelled_request_says_who_and_why",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, origin_name, clinical_need, state, requested_by)
		 VALUES ($1, $2, 'emergency', 'urgent', 'a street', 'a fall',
		     'cancelled', 'dispatch-1')`,
		uuid.NewString(), f.tenantID)

	// A crew cannot be sent to nowhere.
	f.mustFail(t, "a_request_says_where_to_go",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, clinical_need, state, requested_by)
		 VALUES ($1, $2, 'emergency', 'urgent', 'a fall', 'queued',
		     'dispatch-1')`,
		uuid.NewString(), f.tenantID)

	// A transfer between two hospitals needs both ends named, and they are
	// not the same hospital.
	facility := uuid.NewString()
	f.mustFail(t, "a_transfer_names_both_ends",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, origin_facility_id, clinical_need, state,
		    requested_by)
		 VALUES ($1, $2, 'interfacility', 'routine', $3, 'transfer',
		     'queued', 'dispatch-1')`,
		uuid.NewString(), f.tenantID, facility)
	f.mustFail(t, "a_transfer_goes_somewhere_else",
		`INSERT INTO ambulance.request (request_id, tenant_id, kind,
		    priority, origin_facility_id, destination_facility_id,
		    clinical_need, state, requested_by)
		 VALUES ($1, $2, 'interfacility', 'routine', $3, $3, 'transfer',
		     'queued', 'dispatch-1')`,
		uuid.NewString(), f.tenantID, facility)
}

func TestAnotherTenantsFleetIsNotReachable(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.vehicle(t, domain.VehicleALS, "KA-01-AB-1234")
	other := authctx.NewSession(authctx.Session{
		SubjectID: "amb-2", TenantID: uuid.NewString(),
	}).TenantScope()

	// NOT_FOUND rather than PERMISSION_DENIED, so a probe cannot confirm
	// the identifier exists somewhere else.
	if _, err := f.repo.Vehicle(ctx, other, stored.ID); err == nil {
		t.Fatal("another tenant read the vehicle")
	}
	list, err := f.repo.Vehicles(ctx, other, ports.VehicleFilter{})
	if err != nil {
		t.Fatalf("Vehicles: %v", err)
	}
	if len(list) != 0 {
		t.Fatalf("another tenant listed %d vehicles", len(list))
	}
}
