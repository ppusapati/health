package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	bloodbankpostgres "github.com/ppusapati/health/code/internal/bloodbank/adapters/postgres"
	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The blood bank persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost Rh(D) turns an O-negative unit into an ungrouped one; a
// lost emergency flag hides a release nobody reconciled; a lost donor link
// breaks the look-back that a positive test result starts.
//
// Six of these bypass the adapter entirely and write raw SQL, because the rule
// under test belongs to the database rather than to Go.

var at = time.Date(2026, 9, 18, 9, 0, 0, 0, time.UTC)

type fixture struct {
	pool        *pgxpool.Pool
	donors      bloodbankpostgres.DonorRepo
	inventory   bloodbankpostgres.InventoryRepo
	crossmatch  bloodbankpostgres.CrossmatchRepo
	transfusion bloodbankpostgres.TransfusionRepo

	scope     authctx.TenantScope
	tenantID  string
	patientID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := bloodbankpostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:        pool,
		donors:      bloodbankpostgres.DonorRepo{Repository: repo},
		inventory:   bloodbankpostgres.InventoryRepo{Repository: repo},
		crossmatch:  bloodbankpostgres.CrossmatchRepo{Repository: repo},
		transfusion: bloodbankpostgres.TransfusionRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "scientist-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID:  tenantID,
		patientID: uuid.NewString(),
	}
}

func group(abo domain.ABO, rh domain.RhD) domain.Group {
	return domain.Group{ABO: abo, Rh: rh}
}

// donation registers a donor, screens and collects, returning the collection.
func (f fixture) donation(t *testing.T, number string) domain.Collection {
	t.Helper()
	ctx := context.Background()

	donor, err := domain.NewDonor(uuid.NewString(), f.tenantID,
		domain.NewDonorInput{
			DonorNumber: "D-" + number, Name: "Anita Rao",
			BirthDate: time.Date(1988, 4, 2, 0, 0, 0, 0, time.UTC),
			Group:     group(domain.ABOO, domain.RhNegative),
		}, "clerk-1", at)
	if err != nil {
		t.Fatalf("NewDonor: %v", err)
	}
	if err := f.donors.InsertDonor(ctx, f.scope, donor); err != nil {
		t.Fatalf("InsertDonor: %v", err)
	}

	screening, err := domain.Screen(uuid.NewString(), f.tenantID,
		domain.NewScreeningInput{
			DonorID:      donor.ID,
			Answers:      map[string]string{"recent_travel": "no"},
			Measurements: map[string]float64{"haemoglobin": 13.4, "weight_kg": 62},
			Consented:    true, Accepted: true,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("Screen: %v", err)
	}
	if err := f.donors.InsertScreening(ctx, f.scope, screening); err != nil {
		t.Fatalf("InsertScreening: %v", err)
	}

	collection, err := domain.Collect(uuid.NewString(), f.tenantID,
		domain.NewCollectionInput{
			DonationNumber: "DN-" + number, Kind: "whole_blood", VolumeML: 450,
		}, donor, screening, "nurse-1", at)
	if err != nil {
		t.Fatalf("Collect: %v", err)
	}
	if err := f.donors.InsertCollection(ctx, f.scope, collection); err != nil {
		t.Fatalf("InsertCollection: %v", err)
	}
	return collection
}

// unit makes one component from a donation and releases it.
func (f fixture) unit(t *testing.T, collection domain.Collection, number string,
	mutate func(*domain.NewComponentInput)) domain.Component {

	t.Helper()
	ctx := context.Background()

	in := domain.NewComponentInput{
		UnitNumber: number, CollectionID: collection.ID,
		DonorID: collection.DonorID, Class: domain.ClassRedCells,
		Group:    group(domain.ABOO, domain.RhNegative),
		VolumeML: 280, Attributes: []string{"leucodepleted"},
		Location: "fridge 2", CollectedAt: at,
		ExpiresAt: at.Add(35 * 24 * time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}

	component, err := domain.NewComponent(uuid.NewString(), f.tenantID, in,
		"scientist-1", at)
	if err != nil {
		t.Fatalf("NewComponent: %v", err)
	}
	if err := f.inventory.InsertComponent(ctx, f.scope, component); err != nil {
		t.Fatalf("InsertComponent: %v", err)
	}
	return component
}

func TestADonorAndTheirDonationSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0001")

	read, err := f.donors.Collection(ctx, f.scope, collection.ID)
	if err != nil {
		t.Fatalf("Collection: %v", err)
	}
	if read.DonationNumber != collection.DonationNumber {
		t.Errorf("donation number = %q, want %q",
			read.DonationNumber, collection.DonationNumber)
	}
	if read.ScreeningID != collection.ScreeningID {
		t.Error("the screening that authorised the collection was lost; " +
			"'a deferred donor cannot proceed' becomes unenforceable")
	}
	if !read.Group.Known() {
		t.Errorf("the collection's group was lost: %+v", read.Group)
	}

	screenings, err := f.donors.Screenings(ctx, f.scope, collection.DonorID, 10)
	if err != nil {
		t.Fatalf("Screenings: %v", err)
	}
	if len(screenings) != 1 {
		t.Fatalf("screenings = %d, want 1", len(screenings))
	}
	if screenings[0].Measurements["haemoglobin"] != 13.4 {
		t.Errorf("measurements = %v; the bedside numbers were lost",
			screenings[0].Measurements)
	}
	if screenings[0].Answers["recent_travel"] != "no" {
		t.Errorf("answers = %v; what the donor said was lost",
			screenings[0].Answers)
	}
}

// A donor whose group is not yet determined is an ordinary state, and must not
// be confused with one whose group is recorded.
func TestAnUngroupedDonorIsAnOrdinaryState(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	donor, err := domain.NewDonor(uuid.NewString(), f.tenantID,
		domain.NewDonorInput{DonorNumber: "D-0009", Name: "First Timer"},
		"clerk-1", at)
	if err != nil {
		t.Fatalf("NewDonor: %v", err)
	}
	if err := f.donors.InsertDonor(ctx, f.scope, donor); err != nil {
		t.Fatalf("InsertDonor with no group: %v", err)
	}

	read, err := f.donors.Donor(ctx, f.scope, donor.ID)
	if err != nil {
		t.Fatalf("Donor: %v", err)
	}
	if read.Group.Known() {
		t.Errorf("an ungrouped donor came back grouped: %+v", read.Group)
	}
	if read.Deferred(at) {
		t.Error("a donor with no deferral came back deferred")
	}
}

// SRS-BLD-002. The deferral survives the round trip and the deferred list
// finds it.
func TestADeferralIsReadableFromTheScreeningDesk(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0002")

	donor, err := f.donors.Donor(ctx, f.scope, collection.DonorID)
	if err != nil {
		t.Fatalf("Donor: %v", err)
	}
	if err := donor.Defer(domain.DeferralTemporary, "low_hb", "Hb 11.2",
		at.Add(90*24*time.Hour), "nurse-1", at); err != nil {
		t.Fatalf("Defer: %v", err)
	}
	if err := f.donors.UpdateDeferral(ctx, f.scope, donor, donor.Version); err != nil {
		t.Fatalf("UpdateDeferral: %v", err)
	}

	deferred, err := f.donors.Deferred(ctx, f.scope, at, 50)
	if err != nil {
		t.Fatalf("Deferred: %v", err)
	}
	if len(deferred) != 1 {
		t.Fatalf("deferred = %d, want 1", len(deferred))
	}
	if deferred[0].DeferralCode != "low_hb" {
		t.Errorf("code = %q; a deferral list nobody can group is one nobody "+
			"reviews", deferred[0].DeferralCode)
	}

	// It lapses on its own date rather than needing a job to clear it.
	later, err := f.donors.Deferred(ctx, f.scope, at.Add(91*24*time.Hour), 50)
	if err != nil {
		t.Fatalf("Deferred: %v", err)
	}
	if len(later) != 0 {
		t.Error("a temporary deferral was still current past its date")
	}

	// And the version check: a stale writer does not win.
	if err := f.donors.UpdateDeferral(ctx, f.scope, donor, donor.Version); err == nil {
		t.Error("a stale version overwrote the deferral")
	}
}

// SRS-BLD-004. The database defaults a component to quarantined, so a row
// inserted by any path that forgot to say otherwise is not issuable.
func TestTheDatabaseQuarantinesByDefault(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0003")

	var status string
	if err := f.pool.QueryRow(ctx, `
		INSERT INTO bloodbank.component (
		    component_id, tenant_id, unit_number, collection_id, donor_id,
		    component_class, abo, rhd, expires_at, created_at, created_by)
		VALUES ($1, $2, 'G-SNEAKY', $3, $4, 'red_cells', 'O', 'negative',
		        $5, now(), 'someone')
		RETURNING status`,
		uuid.New(), f.tenantID, collection.ID, collection.DonorID,
		at.Add(24*time.Hour)).Scan(&status); err != nil {
		t.Fatalf("insert: %v", err)
	}
	if status != "quarantined" {
		t.Fatalf("status = %q; a component whose testing is not recorded must "+
			"not be issuable", status)
	}
}

// A unit with no donor and no supplier is unprovenanced, and the database says
// so rather than the service.
func TestTheDatabaseRefusesAnUnprovenancedUnit(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0004")

	_, err := f.pool.Exec(ctx, `
		INSERT INTO bloodbank.component (
		    component_id, tenant_id, unit_number, collection_id,
		    component_class, abo, rhd, expires_at, created_at, created_by)
		VALUES ($1, $2, 'G-NOWHERE', $3, 'red_cells', 'O', 'negative',
		        $4, now(), 'someone')`,
		uuid.New(), f.tenantID, collection.ID, at.Add(24*time.Hour))
	if err == nil {
		t.Fatal("a unit with no donor and no supplier was accepted")
	}
}

func TestAComponentSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0005")
	component := f.unit(t, collection, "G100001", nil)

	read, err := f.inventory.Component(ctx, f.scope, component.ID)
	if err != nil {
		t.Fatalf("Component: %v", err)
	}
	if read.Group != group(domain.ABOO, domain.RhNegative) {
		t.Errorf("group = %+v, want O-", read.Group)
	}
	if read.Status != domain.UnitQuarantined {
		t.Errorf("status = %q, want quarantined", read.Status)
	}
	if !read.Has("leucodepleted") {
		t.Errorf("attributes = %v; a request naming it would not match",
			read.Attributes)
	}
	if read.CollectionID != collection.ID {
		t.Error("the parent collection was lost; a look-back cannot reach " +
			"the siblings")
	}

	// The read a bedside scan makes, by the number on the label.
	byNumber, err := f.inventory.ComponentByNumber(ctx, f.scope, "G100001")
	if err != nil {
		t.Fatalf("ComponentByNumber: %v", err)
	}
	if byNumber.ID != component.ID {
		t.Errorf("the label lookup found a different unit")
	}

	// Release, and it becomes allocatable.
	read.Release(at)
	if err := f.inventory.UpdateStatus(ctx, f.scope, read, read.Version); err != nil {
		t.Fatalf("UpdateStatus: %v", err)
	}
	allocatable, err := f.inventory.Allocatable(ctx, f.scope,
		domain.ClassRedCells, at, 50)
	if err != nil {
		t.Fatalf("Allocatable: %v", err)
	}
	if len(allocatable) != 1 {
		t.Fatalf("allocatable = %d, want 1", len(allocatable))
	}
}

// The allocation search hands back the unit that would otherwise be wasted
// first.
func TestAllocationOffersTheSoonestToExpireFirst(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0006")

	for i, expiry := range []time.Duration{
		30 * 24 * time.Hour, 2 * 24 * time.Hour, 10 * 24 * time.Hour,
	} {
		component := f.unit(t, collection, "G20000"+string(rune('1'+i)),
			func(in *domain.NewComponentInput) {
				in.ExpiresAt = at.Add(expiry)
			})
		component.Release(at)
		if err := f.inventory.UpdateStatus(
			ctx, f.scope, component, component.Version); err != nil {
			t.Fatalf("UpdateStatus: %v", err)
		}
	}

	allocatable, err := f.inventory.Allocatable(ctx, f.scope,
		domain.ClassRedCells, at, 50)
	if err != nil {
		t.Fatalf("Allocatable: %v", err)
	}
	if len(allocatable) != 3 {
		t.Fatalf("allocatable = %d, want 3", len(allocatable))
	}
	for i := 1; i < len(allocatable); i++ {
		if allocatable[i].ExpiresAt.Before(allocatable[i-1].ExpiresAt) {
			t.Fatalf("the shelf is not soonest-to-expire first: %v",
				[]time.Time{allocatable[i-1].ExpiresAt, allocatable[i].ExpiresAt})
		}
	}

	// And an expired unit is not offered, however available it says it is.
	expired := f.unit(t, collection, "G299999", func(in *domain.NewComponentInput) {
		in.ExpiresAt = at.Add(time.Hour)
	})
	expired.Release(at)
	if err := f.inventory.UpdateStatus(
		ctx, f.scope, expired, expired.Version); err != nil {
		t.Fatalf("UpdateStatus: %v", err)
	}
	later, err := f.inventory.Allocatable(ctx, f.scope, domain.ClassRedCells,
		at.Add(3*24*time.Hour), 50)
	if err != nil {
		t.Fatalf("Allocatable: %v", err)
	}
	for _, unit := range later {
		if unit.UnitNumber == "G299999" {
			t.Error("an expired unit was offered for allocation")
		}
	}
}

// SRS-BLD-008. The database holds "one live hold per unit", so two patients
// cannot both be promised the same blood.
func TestTheDatabaseRefusesTwoLiveHoldsOnOneUnit(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0007")
	component := f.unit(t, collection, "G300001", nil)

	first, err := domain.Reserve(uuid.NewString(), f.tenantID,
		domain.NewReservationInput{
			ComponentID: component.ID, PatientID: f.patientID,
			Crossmatched: true,
		}, domain.MatchDecision{}, "scientist-1", at)
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if err := f.crossmatch.InsertReservation(ctx, f.scope, first); err != nil {
		t.Fatalf("InsertReservation: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO bloodbank.reservation (
		    reservation_id, tenant_id, component_id, patient_id, status,
		    expires_at, reserved_at, reserved_by)
		VALUES ($1, $2, $3, $4, 'held', $5, now(), 'someone')`,
		uuid.New(), f.tenantID, component.ID, uuid.New(), at.Add(48*time.Hour))
	if err == nil {
		t.Fatal("two patients were promised the same unit")
	}

	// Releasing the first frees the unit for somebody else.
	released, err := f.crossmatch.CloseReservation(ctx, f.scope, first.ID,
		domain.ReservationReleased, "no longer needed")
	if err != nil {
		t.Fatalf("CloseReservation: %v", err)
	}
	if !released {
		t.Fatal("a live hold refused to release")
	}
	again, err := f.crossmatch.CloseReservation(ctx, f.scope, first.ID,
		domain.ReservationReleased, "again")
	if err != nil {
		t.Fatalf("CloseReservation: %v", err)
	}
	if again {
		t.Error("a released hold was released twice; the first reason is the " +
			"true one")
	}

	if _, err := f.pool.Exec(ctx, `
		INSERT INTO bloodbank.reservation (
		    reservation_id, tenant_id, component_id, patient_id, status,
		    expires_at, reserved_at, reserved_by)
		VALUES ($1, $2, $3, $4, 'held', $5, now(), 'someone')`,
		uuid.New(), f.tenantID, component.ID, uuid.New(),
		at.Add(48*time.Hour)); err != nil {
		t.Fatalf("a freed unit could not be re-reserved: %v", err)
	}
}

// SRS-BLD-009, SRS-BLD-016. A unit leaves by one of two routes and no other.
func TestTheDatabaseGivesAUnitExactlyTwoWaysOut(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0008")
	component := f.unit(t, collection, "G400001", nil)

	// Neither a reservation nor an emergency authorisation.
	_, err := f.pool.Exec(ctx, `
		INSERT INTO bloodbank.issue (
		    issue_id, tenant_id, component_id, patient_id, destination,
		    issued_at, issued_by, checked_by)
		VALUES ($1, $2, $3, $4, 'ward 7', now(), 'someone', 'someone')`,
		uuid.New(), f.tenantID, component.ID, f.patientID)
	if err == nil {
		t.Fatal("a unit left the bank with no crossmatch and no authorisation")
	}

	// An emergency with a name but no reason.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO bloodbank.issue (
		    issue_id, tenant_id, component_id, patient_id, destination,
		    emergency, emergency_authoriser, issued_at, issued_by, checked_by)
		VALUES ($1, $2, $3, $4, 'resus', true, 'consultant-1',
		        now(), 'someone', 'someone')`,
		uuid.New(), f.tenantID, component.ID, f.patientID)
	if err == nil {
		t.Fatal("an emergency release with no reason was accepted")
	}

	// And an ordinary issue cannot be marked reconciled: that would make the
	// outstanding list wrong in the safe-looking direction.
	reservation, err := domain.Reserve(uuid.NewString(), f.tenantID,
		domain.NewReservationInput{
			ComponentID: component.ID, PatientID: f.patientID, Crossmatched: true,
		}, domain.MatchDecision{}, "scientist-1", at)
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if err := f.crossmatch.InsertReservation(ctx, f.scope, reservation); err != nil {
		t.Fatalf("InsertReservation: %v", err)
	}
	_, err = f.pool.Exec(ctx, `
		INSERT INTO bloodbank.issue (
		    issue_id, tenant_id, component_id, reservation_id, patient_id,
		    destination, reconciled, issued_at, issued_by, checked_by)
		VALUES ($1, $2, $3, $4, $5, 'ward 7', true, now(), 'someone', 'someone')`,
		uuid.New(), f.tenantID, component.ID, reservation.ID, f.patientID)
	if err == nil {
		t.Fatal("an ordinary issue was marked reconciled")
	}
}

// SRS-BLD-016. The unreconciled list is what "later reconciled" is read
// against.
func TestAnEmergencyReleaseStaysOnTheListUntilItIsReconciled(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0009")
	component := f.unit(t, collection, "G500001", nil)

	issue, err := domain.IssueComponent(uuid.NewString(), f.tenantID,
		domain.NewIssueInput{
			ComponentID: component.ID, Destination: "resus",
			Emergency:           true,
			EmergencyAuthoriser: "consultant-1",
			EmergencyReason:     "massive haemorrhage protocol",
			Check: domain.IssueCheck{
				UnitNumber: component.UnitNumber, PatientID: f.patientID,
				CheckedBy: "scientist-1",
			},
		}, mustRelease(t, component), nil, "scientist-1", at)
	if err != nil {
		t.Fatalf("IssueComponent: %v", err)
	}
	if err := f.crossmatch.InsertIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("InsertIssue: %v", err)
	}

	outstanding, err := f.crossmatch.Unreconciled(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("Unreconciled: %v", err)
	}
	if len(outstanding) != 1 {
		t.Fatalf("outstanding = %d, want 1", len(outstanding))
	}
	if outstanding[0].EmergencyAuthoriser != "consultant-1" {
		t.Errorf("authoriser = %q; the release cannot be reviewed without it",
			outstanding[0].EmergencyAuthoriser)
	}

	done, err := f.crossmatch.Reconcile(ctx, f.scope, issue.ID,
		"retrospective crossmatch compatible", "scientist-2", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if !done {
		t.Fatal("an outstanding release refused to reconcile")
	}
	again, err := f.crossmatch.Reconcile(ctx, f.scope, issue.ID, "again",
		"scientist-2", at)
	if err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if again {
		t.Error("a release was reconciled twice")
	}

	outstanding, err = f.crossmatch.Unreconciled(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("Unreconciled: %v", err)
	}
	if len(outstanding) != 0 {
		t.Errorf("outstanding = %d after reconciliation", len(outstanding))
	}
}

func mustRelease(t *testing.T, c domain.Component) domain.Component {
	t.Helper()
	if err := c.Release(at); err != nil {
		t.Fatalf("Release: %v", err)
	}
	return c
}

// SRS-BLD-010. The database holds the two-person bedside check.
func TestTheDatabaseRefusesASoloBedsideCheck(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0010")
	component := f.unit(t, collection, "G600001", nil)

	for _, c := range []struct {
		name                   string
		checkedBy, checkedWith string
	}{
		{"one person", "nurse-1", "nurse-1"},
		{"the same person, differently cased", "Nurse-1", "nurse-1"},
	} {
		_, err := f.pool.Exec(ctx, `
			INSERT INTO bloodbank.episode (
			    episode_id, tenant_id, component_id, patient_id, status,
			    started_at, started_by, checked_by, checked_with)
			VALUES ($1, $2, $3, $4, 'running', now(), 'nurse-1', $5, $6)`,
			uuid.New(), f.tenantID, component.ID, f.patientID,
			c.checkedBy, c.checkedWith)
		if err == nil {
			t.Errorf("%s: a solo bedside check was accepted", c.name)
		}
	}
}

// SRS-BLD-011. One unit is transfused once. A second episode is the same
// transfusion recorded twice, and the two would disagree.
func TestTheDatabaseRefusesASecondTransfusionOfOneUnit(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0011")
	component := f.unit(t, collection, "G700001", nil)

	episode, err := domain.StartTransfusion(uuid.NewString(), f.tenantID,
		domain.StartTransfusionInput{
			ComponentID: component.ID, PatientID: f.patientID,
			Baseline: map[string]float64{"temperature": 36.8, "pulse": 88},
		}, nil, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	// The domain leaves the baseline observation without an id; the service
	// mints one. Here the test does it, so the adapter has something to write.
	episode.Observations[0].ID = uuid.NewString()

	check := domain.BedsideCheck{CheckedBy: "nurse-1", CheckedWith: "nurse-2"}
	if err := f.transfusion.InsertEpisode(ctx, f.scope, episode, check); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	second, err := domain.StartTransfusion(uuid.NewString(), f.tenantID,
		domain.StartTransfusionInput{
			ComponentID: component.ID, PatientID: uuid.NewString(),
			Baseline: map[string]float64{"temperature": 37.0},
		}, nil, "nurse-3", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	if err := f.transfusion.InsertEpisode(ctx, f.scope, second,
		domain.BedsideCheck{CheckedBy: "nurse-3", CheckedWith: "nurse-4"}); err == nil {
		t.Fatal("one unit was transfused into two patients")
	}

	read, err := f.transfusion.Episode(ctx, f.scope, episode.ID)
	if err != nil {
		t.Fatalf("Episode: %v", err)
	}
	if len(read.Observations) != 1 {
		t.Fatalf("observations = %d, want the baseline", len(read.Observations))
	}
	if read.Observations[0].Values["temperature"] != 36.8 {
		t.Errorf("baseline values = %v; there is nothing to compare a later "+
			"temperature against", read.Observations[0].Values)
	}
	if read.Observations[0].Timing != domain.TimingBaseline {
		t.Errorf("timing = %q, want baseline", read.Observations[0].Timing)
	}
}

// SRS-BLD-014. The look-back runs in both directions: from a component to its
// siblings, and from a donor to the patients who received their blood.
func TestTheLookBackRunsInBothDirections(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0012")

	cells := f.unit(t, collection, "G800001", nil)
	plasma := f.unit(t, collection, "G800002", func(in *domain.NewComponentInput) {
		in.Class = domain.ClassPlasma
	})

	siblings, err := f.inventory.Siblings(ctx, f.scope, cells.ID)
	if err != nil {
		t.Fatalf("Siblings: %v", err)
	}
	if len(siblings) != 1 || siblings[0].ID != plasma.ID {
		t.Fatalf("siblings = %d; a reactive result arriving late could not "+
			"reach the other components from this donation", len(siblings))
	}

	// Transfuse the red cells, then ask the donor question.
	episode, err := domain.StartTransfusion(uuid.NewString(), f.tenantID,
		domain.StartTransfusionInput{
			ComponentID: cells.ID, PatientID: f.patientID,
			Baseline: map[string]float64{"temperature": 36.7},
		}, nil, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	if err := f.transfusion.InsertEpisode(ctx, f.scope, episode,
		domain.BedsideCheck{CheckedBy: "nurse-1", CheckedWith: "nurse-2"}); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	recipients, err := f.transfusion.DonorRecipients(ctx, f.scope,
		collection.DonorID, 50)
	if err != nil {
		t.Fatalf("DonorRecipients: %v", err)
	}
	if len(recipients) != 1 {
		t.Fatalf("recipients = %d, want 1", len(recipients))
	}
	if recipients[0].PatientID != f.patientID {
		t.Errorf("recipient = %q, want %q", recipients[0].PatientID, f.patientID)
	}
	if recipients[0].UnitNumber != "G800001" {
		t.Errorf("unit = %q; a look-back list that cannot name the unit is one "+
			"nobody can act on", recipients[0].UnitNumber)
	}
}

// SRS-BLD-012. A reaction cannot exist without the component it implicates.
func TestTheDatabaseRefusesAReactionWithNoComponent(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO bloodbank.reaction (
		    reaction_id, tenant_id, patient_id, severity, features,
		    reported_at, reported_by, state)
		VALUES ($1, $2, $3, 'severe', ARRAY['rigors'], now(), 'doctor-1', 'open')`,
		uuid.New(), f.tenantID, f.patientID)
	if err == nil {
		t.Fatal("a reaction was recorded against no component; the siblings " +
			"could not be found")
	}

	// And one with nothing observed.
	collection := f.donation(t, "0013")
	component := f.unit(t, collection, "G900001", nil)
	_, err = f.pool.Exec(ctx, `
		INSERT INTO bloodbank.reaction (
		    reaction_id, tenant_id, component_id, patient_id, severity,
		    features, reported_at, reported_by, state)
		VALUES ($1, $2, $3, $4, 'severe', '{}', now(), 'doctor-1', 'open')`,
		uuid.New(), f.tenantID, component.ID, f.patientID)
	if err == nil {
		t.Fatal("a reaction with nothing observed was accepted")
	}

	// SRS-NUR-014. And one that does not say what was done about it. The
	// action runs from the bedside, and the report is where it is recorded.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO bloodbank.reaction (
		    reaction_id, tenant_id, component_id, patient_id, severity,
		    features, action_taken, reported_at, reported_by, state)
		VALUES ($1, $2, $3, $4, 'severe', ARRAY['rigors'], '', now(),
		    'doctor-1', 'open')`,
		uuid.New(), f.tenantID, component.ID, f.patientID)
	if err == nil {
		t.Fatal("a reaction was recorded with no account of what was done")
	}
}

// SRS-BLD-012. A reaction round-trips and concludes once.
func TestAReactionConcludesOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0014")
	component := f.unit(t, collection, "GA00001", nil)

	reaction, err := domain.ReportReaction(uuid.NewString(), f.tenantID,
		domain.NewReactionInput{
			ComponentID: component.ID, PatientID: f.patientID,
			Severity:    domain.ReactionSevere,
			Features:    []string{"rigors", "fever", "hypotension"},
			ActionTaken: "transfusion stopped, unit returned to the blood bank",
			Note:        "15 minutes in",
		}, "doctor-1", at)
	if err != nil {
		t.Fatalf("ReportReaction: %v", err)
	}
	if err := f.transfusion.InsertReaction(ctx, f.scope, reaction); err != nil {
		t.Fatalf("InsertReaction: %v", err)
	}

	open, err := f.transfusion.OpenReactions(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("OpenReactions: %v", err)
	}
	if len(open) != 1 || len(open[0].Features) != 3 {
		t.Fatalf("open reactions = %+v", open)
	}

	if err := reaction.Conclude("acute_haemolytic",
		"ABO incompatibility confirmed", "scientist-1",
		at.Add(24*time.Hour)); err != nil {
		t.Fatalf("Conclude: %v", err)
	}
	reaction.UnitReturned = true
	done, err := f.transfusion.ConcludeReaction(ctx, f.scope, reaction)
	if err != nil {
		t.Fatalf("ConcludeReaction: %v", err)
	}
	if !done {
		t.Fatal("an open investigation refused to conclude")
	}
	again, err := f.transfusion.ConcludeReaction(ctx, f.scope, reaction)
	if err != nil {
		t.Fatalf("ConcludeReaction: %v", err)
	}
	if again {
		t.Error("an investigation was concluded twice; reopening one is a new " +
			"decision, not an edit")
	}

	read, err := f.transfusion.Reaction(ctx, f.scope, reaction.ID)
	if err != nil {
		t.Fatalf("Reaction: %v", err)
	}
	if read.Classification != "acute_haemolytic" || !read.UnitReturned {
		t.Errorf("reaction = %+v", read)
	}
}

// Gate A2. Another tenant reaches none of it.
func TestAnotherTenantSeesNoBlood(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	collection := f.donation(t, "0015")
	component := f.unit(t, collection, "GB00001", nil)

	other := authctx.NewSession(authctx.Session{
		SubjectID: "scientist-9", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.inventory.Component(ctx, other, component.ID); err == nil {
		t.Error("another tenant read a unit")
	}
	if _, err := f.donors.Donor(ctx, other, collection.DonorID); err == nil {
		t.Error("another tenant read a donor")
	}
	if _, err := f.inventory.ComponentByNumber(ctx, other, "GB00001"); err == nil {
		t.Error("another tenant read a unit by its label")
	}
	stock, err := f.inventory.Inventory(ctx, other, 50)
	if err != nil {
		t.Fatalf("Inventory: %v", err)
	}
	if len(stock) != 0 {
		t.Errorf("another tenant counted %d units of stock", len(stock))
	}
}
