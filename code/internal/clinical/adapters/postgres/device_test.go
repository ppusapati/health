package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"

	clinicalpostgres "github.com/ppusapati/health/code/internal/clinical/adapters/postgres"
	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// Device-sourced observations through storage (SRS-ICU-003).
//
// The domain tests pin the rule; these pin that the rule survives a round trip.
// A provenance model that is correct in memory and lost on the way to the
// database is a model that holds until the first time anybody reads a chart
// back, which is to say always.

type deviceFixture struct {
	records ports.RecordRepository
	tx      *pgtx.Manager
	scope   authctx.TenantScope
	patient string
}

func newDeviceFixture(t *testing.T) deviceFixture {
	t.Helper()
	pool := pgtest.New(t)
	manager := pgtx.NewManager(pool)
	repo := clinicalpostgres.New(manager)

	return deviceFixture{
		records: clinicalpostgres.RecordRepo{Repository: repo},
		tx:      manager,
		// The sweeper's grant, for the sweeper's reason: a test has no session.
		scope:   authctx.SystemScope(uuid.NewString()),
		patient: uuid.NewString(),
	}
}

func (f deviceFixture) within(t *testing.T, fn func(ctx context.Context) error) error {
	t.Helper()
	return f.tx.WithinTx(context.Background(), fn)
}

func (f deviceFixture) reading(t *testing.T, source domain.SourceKind,
	quality string) domain.Observation {

	t.Helper()
	in := domain.NewObservationInput{
		PatientID: f.patient,
		Code: domain.Coding{
			System: "http://loinc.org", Version: "2.74",
			Code: "59408-5", Display: "SpO2",
		},
		Value:          domain.Quantity{Value: 60, Unit: "%"},
		Interpretation: domain.InterpretationUnknown,
		Status:         domain.ObservationFinal,
		EffectiveAt:    devAt(9, 0),
		Source:         source,
	}
	if source == domain.SourceDevice {
		in.DeviceID = "monitor-7"
		in.Device = domain.DeviceSource{
			DeviceID: "monitor-7", Channel: "SpO2", Quality: quality,
			ObservedAt: devAt(9, 0), ReceivedAt: devAt(9, 0).Add(3 * time.Second),
		}
	}

	observation, err := domain.NewObservation(uuid.NewString(), f.scope.TenantID(),
		in, "nurse-1", devAt(9, 0))
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.InsertObservation(ctx, f.scope, observation)
	}); err != nil {
		t.Fatalf("InsertObservation: %v", err)
	}
	return observation
}

func (f deviceFixture) read(t *testing.T, id string) domain.Observation {
	t.Helper()
	var out domain.Observation
	if err := f.within(t, func(ctx context.Context) error {
		var err error
		out, err = f.records.GetObservation(ctx, f.scope, id)
		return err
	}); err != nil {
		t.Fatalf("GetObservation: %v", err)
	}
	return out
}

func devAt(hour, minute int) time.Time {
	return time.Date(2026, time.September, 17, hour, minute, 0, 0, time.UTC)
}

func TestDeviceProvenanceSurvivesStorage(t *testing.T) {
	f := newDeviceFixture(t)
	stored := f.reading(t, domain.SourceDevice, "searching")

	read := f.read(t, stored.ID)
	if read.Source != domain.SourceDevice {
		t.Fatalf("source came back %q", read.Source)
	}
	if read.Validation != domain.ValidationPending {
		t.Fatalf("validation came back %q, want pending", read.Validation)
	}
	if read.Validated() {
		t.Fatal("a stored device reading reads back as validated")
	}
	if read.Device.Channel != "SpO2" || read.Device.Quality != "searching" {
		t.Fatalf("device metadata came back as %+v", read.Device)
	}
	if !read.Device.ObservedAt.Equal(devAt(9, 0)) {
		t.Fatalf("the device's own timestamp came back as %v", read.Device.ObservedAt)
	}
	// The lag between the device's clock and ours is what makes a feed stale,
	// and one timestamp cannot show it.
	lag, known := read.Device.Lag()
	if !known || lag != 3*time.Second {
		t.Fatalf("lag came back as %v (known=%v)", lag, known)
	}
}

func TestATypedObservationStoresAsValidated(t *testing.T) {
	// Every Wave-1 path writes one of these, and the migration's default has
	// to agree with the domain's: a chart that went provisional overnight
	// would empty the ICU's scoring inputs.
	f := newDeviceFixture(t)
	stored := f.reading(t, domain.SourceManual, "")

	read := f.read(t, stored.ID)
	if read.Source != domain.SourceManual {
		t.Fatalf("source came back %q", read.Source)
	}
	if !read.Validated() {
		t.Fatal("a typed observation reads back as unvalidated")
	}
}

func TestAClinicianDecisionSurvivesStorage(t *testing.T) {
	f := newDeviceFixture(t)
	stored := f.reading(t, domain.SourceDevice, "good")

	if err := stored.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, stored)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	read := f.read(t, stored.ID)
	if !read.Validated() {
		t.Fatal("a confirmed reading reads back as unvalidated")
	}
	if read.ValidatedBy != "doctor-1" {
		t.Fatalf("confirmed by %q", read.ValidatedBy)
	}
}

func TestARejectionKeepsItsReason(t *testing.T) {
	f := newDeviceFixture(t)
	stored := f.reading(t, domain.SourceDevice, "artefact")

	if err := stored.Reject("nurse-1", "probe off the finger", devAt(9, 5)); err != nil {
		t.Fatalf("reject: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, stored)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	read := f.read(t, stored.ID)
	if read.Validated() {
		t.Fatal("a rejected reading reads back as validated")
	}
	if read.ValidationNote != "probe off the finger" {
		t.Fatalf("the reason came back as %q", read.ValidationNote)
	}
}

func TestASecondDecisionDoesNotOverwriteTheFirst(t *testing.T) {
	// Two clinicians deciding at once is an ordinary race on a busy unit. The
	// predicate in the UPDATE is what makes the first decision the one that
	// stands, and it is in SQL rather than only in the domain because the
	// domain object the second caller holds was read before the first wrote.
	f := newDeviceFixture(t)
	stored := f.reading(t, domain.SourceDevice, "good")

	first := stored
	if err := first.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, first)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	// The second caller is holding the copy it read before any of that.
	second := stored
	if err := second.Reject("nurse-1", "I think it was an artefact", devAt(9, 6)); err != nil {
		t.Fatalf("reject: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, second)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	read := f.read(t, stored.ID)
	if read.Validation != domain.ValidationConfirmed || read.ValidatedBy != "doctor-1" {
		t.Fatalf("the losing decision overwrote the first: %q by %q",
			read.Validation, read.ValidatedBy)
	}
}

func TestTheWorklistHoldsOnlyWhatNobodyHasDecided(t *testing.T) {
	f := newDeviceFixture(t)
	pending := f.reading(t, domain.SourceDevice, "good")
	decided := f.reading(t, domain.SourceDevice, "good")
	typed := f.reading(t, domain.SourceManual, "")

	if err := decided.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, decided)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	var worklist domain.ObservationList
	if err := f.within(t, func(ctx context.Context) error {
		var err error
		worklist, err = f.records.PendingValidation(ctx, f.scope, f.patient, 50)
		return err
	}); err != nil {
		t.Fatalf("PendingValidation: %v", err)
	}

	if len(worklist) != 1 || worklist[0].ID != pending.ID {
		ids := make([]string, 0, len(worklist))
		for _, o := range worklist {
			ids = append(ids, o.ID)
		}
		t.Fatalf("the worklist holds %v; want only %s (typed %s is not a device "+
			"reading and needs no decision)", ids, pending.ID, typed.ID)
	}
}

func TestOnlyValidatedReadingsSurviveIntoAScore(t *testing.T) {
	// SRS-ICU-009 read back out of storage rather than asserted in memory: the
	// list a score is computed from is the one the repository returns.
	f := newDeviceFixture(t)
	typed := f.reading(t, domain.SourceManual, "")
	confirmed := f.reading(t, domain.SourceDevice, "good")
	_ = f.reading(t, domain.SourceDevice, "searching") // stays pending

	if err := confirmed.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := f.within(t, func(ctx context.Context) error {
		return f.records.SetValidation(ctx, f.scope, confirmed)
	}); err != nil {
		t.Fatalf("SetValidation: %v", err)
	}

	var all domain.ObservationList
	if err := f.within(t, func(ctx context.Context) error {
		var err error
		all, err = f.records.Observations(ctx, f.scope, ports.ObservationQuery{
			PatientID: f.patient, Limit: 50,
		})
		return err
	}); err != nil {
		t.Fatalf("Observations: %v", err)
	}
	if len(all) != 3 {
		t.Fatalf("the chart shows %d readings, want all 3 — a provisional value "+
			"is visible, just not believed", len(all))
	}

	inputs := all.ValidatedInputs()
	if len(inputs) != 2 {
		t.Fatalf("a score would be computed from %d readings, want 2", len(inputs))
	}
	got := map[string]bool{}
	for _, o := range inputs {
		got[o.ID] = true
	}
	if !got[typed.ID] || !got[confirmed.ID] {
		t.Fatalf("the wrong readings reached the score: %v", got)
	}
}
