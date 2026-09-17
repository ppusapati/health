package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	icupostgres "github.com/ppusapati/health/code/internal/icu/adapters/postgres"
	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The critical-care persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a field the domain sets and the adapter drops reads back as a zero
// value that looks like a decision nobody made. A lost `normalised` flag turns
// an unconverted number into a converted one; a lost device clock turns a
// stale feed into a current reading; a lost titration turns a dose timeline
// into a rate nobody can account for.

var at = time.Date(2026, 9, 17, 8, 0, 0, 0, time.UTC)

type fixture struct {
	pool      *pgxpool.Pool
	episodes  icupostgres.EpisodeRepo
	flowsheet icupostgres.FlowsheetRepo
	support   icupostgres.SupportRepo
	care      icupostgres.CareRepo

	scope    authctx.TenantScope
	tenantID string
	unitID   string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := icupostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:      pool,
		episodes:  icupostgres.EpisodeRepo{Repository: repo},
		flowsheet: icupostgres.FlowsheetRepo{Repository: repo},
		support:   icupostgres.SupportRepo{Repository: repo},
		care:      icupostgres.CareRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "nurse-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
		unitID:   "icu-general",
	}
}

func (f fixture) episode(t *testing.T) domain.Episode {
	t.Helper()

	e, err := domain.NewEpisode(uuid.NewString(), f.tenantID, domain.NewEpisodeInput{
		EncounterID: uuid.NewString(), PatientID: uuid.NewString(),
		FacilityID: "fac-1", UnitID: f.unitID, BedID: "bed-4",
		Source: domain.AdmissionWard, ResponsibleTeam: "icu_team",
		ResponsibleClinician: "consultant-1", AdmittedAt: at,
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewEpisode: %v", err)
	}
	if err := f.episodes.InsertEpisode(context.Background(), f.scope, e); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}
	return e
}

func TestAnEpisodeSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	want := f.episode(t)

	got, err := f.episodes.GetEpisode(context.Background(), f.scope, want.ID)
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	if got.ID != want.ID || got.EncounterID != want.EncounterID ||
		got.PatientID != want.PatientID || got.UnitID != want.UnitID ||
		got.BedID != want.BedID || got.Source != want.Source ||
		got.ResponsibleTeam != want.ResponsibleTeam ||
		got.ResponsibleClinician != want.ResponsibleClinician ||
		got.Status != want.Status || got.Version != want.Version {
		t.Fatalf("round trip lost data:\n got %+v\nwant %+v", got, want)
	}
	if !got.AdmittedAt.Equal(want.AdmittedAt) {
		t.Fatalf("AdmittedAt = %v, want %v", got.AdmittedAt, want.AdmittedAt)
	}
}

// Two clinicians discharging the same patient at once is the ordinary case in
// a unit under bed pressure, not the exotic one.
func TestAStaleEpisodeWriteIsRefused(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)
	stale := e.Version

	if err := e.DeclareReady(at.Add(20 * time.Hour)); err != nil {
		t.Fatalf("DeclareReady: %v", err)
	}
	if err := f.episodes.UpdateEpisode(ctx, f.scope, e, stale); err != nil {
		t.Fatalf("UpdateEpisode: %v", err)
	}

	e.BedID = "bed-5"
	if err := f.episodes.UpdateEpisode(ctx, f.scope, e, stale); err != ports.ErrVersionConflict {
		t.Fatalf("second write returned %v, want a version conflict", err)
	}
}

// The adapter must refuse an aggregate assembled for another tenant, even
// though the scope is valid: FIT-03 makes the scope unforgeable, and this is
// the other half — the row must belong to it.
func TestAnEpisodeFromAnotherTenantIsRefused(t *testing.T) {
	f := newFixture(t)

	foreign, err := domain.NewEpisode(uuid.NewString(), uuid.NewString(),
		domain.NewEpisodeInput{
			EncounterID: uuid.NewString(), PatientID: uuid.NewString(),
			UnitID: "icu", BedID: "bed-1", Source: domain.AdmissionWard,
		}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewEpisode: %v", err)
	}
	if err := f.episodes.InsertEpisode(context.Background(), f.scope, foreign); err == nil {
		t.Fatal("an episode belonging to another tenant was written")
	}
}

// The unit as it stands. A discharged patient has left it.
func TestOpenEpisodesExcludesTheDischarged(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	open := f.episode(t)
	gone := f.episode(t)

	expected := gone.Version
	outstanding, err := gone.Discharge(domain.OutcomeWard, "step down",
		domain.HandoverEvidence{
			MedicationsReconciled: true, DevicesListed: true,
			TasksHandedOver: true, SummaryWritten: true,
		}, at.Add(48*time.Hour))
	if err != nil || len(outstanding) != 0 {
		t.Fatalf("Discharge: %v / %v", err, outstanding)
	}
	if err := f.episodes.UpdateEpisode(ctx, f.scope, gone, expected); err != nil {
		t.Fatalf("UpdateEpisode: %v", err)
	}

	episodes, err := f.episodes.OpenEpisodes(ctx, f.scope, f.unitID, 50)
	if err != nil {
		t.Fatalf("OpenEpisodes: %v", err)
	}
	if len(episodes) != 1 || episodes[0].ID != open.ID {
		t.Fatalf("the unit shows %d open beds, want only the open one", len(episodes))
	}
}

// SRS-ICU-002 and SRS-ICU-003. The converted value, the value as it arrived,
// the provenance and the device's own clock all have to survive: each of them
// is something a reader would otherwise infer wrongly from a zero.
func TestAnObservationKeepsBothValuesAndItsProvenance(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	measured := at.Add(-45 * time.Second)
	want, err := domain.NewObservation(uuid.NewString(), f.tenantID,
		domain.NewObservationInput{
			EpisodeID: e.ID, CodeSystem: "http://loinc.org", Code: "8310-5",
			Display: "Body temperature", Dimension: "temperature",
			Value: 100.4, Unit: "F", Source: domain.SourceDevice,
			Device: domain.DeviceSource{
				DeviceID: "mon-3", Model: "Acme 9000", ChannelID: "temp",
				MeasuredAt: measured, Quality: "good",
			},
			ObservedAt: measured,
		}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := f.flowsheet.InsertObservation(ctx, f.scope, want); err != nil {
		t.Fatalf("InsertObservation: %v", err)
	}

	got, err := f.flowsheet.GetObservation(ctx, f.scope, want.ID)
	if err != nil {
		t.Fatalf("GetObservation: %v", err)
	}
	if got.Value != want.Value || got.Unit != "Cel" {
		t.Fatalf("normalised value = %v %q, want %v Cel", got.Value, got.Unit, want.Value)
	}
	if got.RawValue != 100.4 || got.RawUnit != "F" {
		t.Fatalf("raw = %v %q, want what the device sent", got.RawValue, got.RawUnit)
	}
	if !got.Normalised {
		t.Fatal("the normalised flag did not survive; an unconverted number would read as converted")
	}
	if got.Source != domain.SourceDevice || got.Validation != domain.ValidationPending {
		t.Fatalf("provenance = %q/%q", got.Source, got.Validation)
	}
	if got.Device.DeviceID != "mon-3" || got.Device.Quality != "good" {
		t.Fatalf("device = %+v", got.Device)
	}
	if !got.Device.MeasuredAt.Equal(measured) {
		t.Fatalf("device clock = %v, want %v: a lost clock reads as a stale feed",
			got.Device.MeasuredAt, measured)
	}
}

// A manual entry stores no device clock, and must not come back as a stale
// feed: a nurse who wrote a number an hour ago wrote it an hour ago on purpose.
func TestAManualObservationStoresNoDeviceClock(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	entry, err := domain.NewObservation(uuid.NewString(), f.tenantID,
		domain.NewObservationInput{
			EpisodeID: e.ID, Code: "pain_score", Value: 3, ObservedAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := f.flowsheet.InsertObservation(ctx, f.scope, entry); err != nil {
		t.Fatalf("InsertObservation: %v", err)
	}

	got, err := f.flowsheet.GetObservation(ctx, f.scope, entry.ID)
	if err != nil {
		t.Fatalf("GetObservation: %v", err)
	}
	if !got.Device.MeasuredAt.IsZero() {
		t.Fatalf("device clock = %v on a manual entry", got.Device.MeasuredAt)
	}
	if got.Device.Stale(at.Add(time.Hour), domain.DefaultStaleAfter) {
		t.Fatal("a manual entry came back as a stale feed")
	}
	if got.Validation != domain.ValidationNotRequired || !got.Chartable() {
		t.Fatalf("a nurse's own entry is %q and chartable=%v",
			got.Validation, got.Chartable())
	}
}

// Deciding a reading twice is a race, not an error: the second clinician needs
// to see the first one's decision rather than a failure.
func TestADeviceReadingIsDecidedOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	reading, err := domain.NewObservation(uuid.NewString(), f.tenantID,
		domain.NewObservationInput{
			EpisodeID: e.ID, Code: "spo2", Dimension: "fraction",
			Value: 60, Unit: "%", Source: domain.SourceDevice,
			Device:     domain.DeviceSource{DeviceID: "mon-3", MeasuredAt: at},
			ObservedAt: at,
		}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := f.flowsheet.InsertObservation(ctx, f.scope, reading); err != nil {
		t.Fatalf("InsertObservation: %v", err)
	}

	if err := reading.Reject("nurse-1", "probe off the finger", at); err != nil {
		t.Fatalf("Reject: %v", err)
	}
	decided, err := f.flowsheet.Decide(ctx, f.scope, reading)
	if err != nil || !decided {
		t.Fatalf("Decide: %v (decided=%v)", err, decided)
	}

	again, err := f.flowsheet.Decide(ctx, f.scope, reading)
	if err != nil {
		t.Fatalf("Decide (second): %v", err)
	}
	if again {
		t.Fatal("a reading was decided twice")
	}

	// And it is out of the worklist and out of the chart.
	pending, err := f.flowsheet.Pending(ctx, f.scope, e.ID, 50)
	if err != nil {
		t.Fatalf("Pending: %v", err)
	}
	if len(pending) != 0 {
		t.Fatalf("%d readings still pending", len(pending))
	}
	all, err := f.flowsheet.Observations(ctx, f.scope, e.ID, time.Time{}, 50)
	if err != nil {
		t.Fatalf("Observations: %v", err)
	}
	if len(all) != 1 {
		t.Fatalf("%d observations, want the rejected one kept", len(all))
	}
	if len(all.Chartable()) != 0 {
		t.Fatal("a rejected artefact is chartable")
	}
}

// SRS-ICU-007. The superseded entry stays, the totals recompute, and a second
// correction of the same entry does not also count.
func TestACorrectedBalanceEntryIsSupersededNotEdited(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	original := mustEntry(t, f, e.ID, domain.NewBalanceEntryInput{
		EpisodeID: e.ID, Direction: domain.BalanceIntake, Route: "iv",
		Volume: 1, Unit: "L", OccurredAt: at,
	})
	correction := mustEntry(t, f, e.ID, domain.NewBalanceEntryInput{
		EpisodeID: e.ID, Direction: domain.BalanceIntake, Route: "iv",
		Volume: 500, Unit: "mL", OccurredAt: at,
		Corrects: original.ID, CorrectionReason: "bag was 500 mL, not a litre",
	})

	superseded, err := f.flowsheet.Supersede(ctx, f.scope, original.ID, correction.ID)
	if err != nil || !superseded {
		t.Fatalf("Supersede: %v (superseded=%v)", err, superseded)
	}
	again, err := f.flowsheet.Supersede(ctx, f.scope, original.ID, correction.ID)
	if err != nil {
		t.Fatalf("Supersede (second): %v", err)
	}
	if again {
		t.Fatal("the same entry was superseded twice")
	}

	entries, err := f.flowsheet.BalanceEntries(ctx, f.scope, e.ID, at, at.Add(time.Hour))
	if err != nil {
		t.Fatalf("BalanceEntries: %v", err)
	}
	if len(entries) != 2 {
		t.Fatalf("%d entries, want the superseded one kept", len(entries))
	}

	totals := domain.Totals(entries, at, at.Add(time.Hour))
	if totals.IntakeML != 500 || totals.Corrections != 1 {
		t.Fatalf("totals = %+v, want 500 mL from one correction", totals)
	}
}

func mustEntry(t *testing.T, f fixture, episodeID string,
	in domain.NewBalanceEntryInput) domain.BalanceEntry {

	t.Helper()
	entry, err := domain.NewBalanceEntry(uuid.NewString(), f.tenantID, in, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewBalanceEntry: %v", err)
	}
	if err := f.flowsheet.InsertBalanceEntry(context.Background(), f.scope, entry); err != nil {
		t.Fatalf("InsertBalanceEntry: %v", err)
	}
	return entry
}

// SRS-ICU-005. The dose timeline is the record: an infusion read without its
// titrations is a rate nobody can account for.
func TestAnInfusionComesBackWithItsDoseTimeline(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	infusion, err := domain.StartInfusion(uuid.NewString(), f.tenantID,
		domain.NewInfusionInput{
			EpisodeID: e.ID, DrugCode: "noradrenaline", DrugDisplay: "Noradrenaline",
			ConcentrationAmount: 4, ConcentrationUnit: "mg", ConcentrationVolume: 50,
			DoseUnit: "mcg/kg/min", WeightKg: 72, StartedAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartInfusion: %v", err)
	}
	if err := f.support.InsertInfusion(ctx, f.scope, infusion); err != nil {
		t.Fatalf("InsertInfusion: %v", err)
	}

	if err := infusion.Titrate(uuid.NewString(), domain.NewTitrationInput{
		Rate: 5, RateUnit: "mL/h", Dose: 0.09, EffectiveAt: at,
	}, "nurse-1", at); err != nil {
		t.Fatalf("Titrate: %v", err)
	}
	if err := infusion.Titrate(uuid.NewString(), domain.NewTitrationInput{
		Rate: 8, RateUnit: "mL/h", Dose: 0.15, EffectiveAt: at.Add(time.Hour),
		DeviceID: "pump-9",
	}, "", at.Add(time.Hour)); err != nil {
		t.Fatalf("Titrate from a pump: %v", err)
	}
	for _, titration := range infusion.Titrations {
		if err := f.support.InsertTitration(ctx, f.scope, infusion.ID, titration); err != nil {
			t.Fatalf("InsertTitration: %v", err)
		}
	}

	got, err := f.support.GetInfusion(ctx, f.scope, infusion.ID)
	if err != nil {
		t.Fatalf("GetInfusion: %v", err)
	}
	if len(got.Titrations) != 2 {
		t.Fatalf("%d titrations, want 2", len(got.Titrations))
	}
	// The weight the dose was calculated from is frozen with the infusion.
	if got.WeightKg != 72 {
		t.Fatalf("weight = %v, want 72", got.WeightKg)
	}
	current, ok := got.CurrentDose()
	if !ok || current.Rate != 8 {
		t.Fatalf("current dose = %+v, want the later titration", current)
	}
	// Who or what made the change survives, which is the requirement.
	if current.DeviceID != "pump-9" {
		t.Fatalf("the pump that reported the change was lost: %+v", current)
	}
}

// SRS-ICU-004. Set and measured parameters are stored side by side, because
// the difference between them is the clinical finding.
func TestVentilatorSettingsKeepSetAndMeasuredApart(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	setting, err := domain.RecordVentSetting(uuid.NewString(), f.tenantID,
		domain.NewVentSettingInput{
			EpisodeID: e.ID, Mode: "PRVC",
			Parameters:  map[string]float64{"fio2": 60, "peep": 8, "tidal_volume": 450},
			Measured:    map[string]float64{"tidal_volume": 410, "peak_pressure": 28},
			Units:       map[string]string{"tidal_volume": "mL", "peep": "cm[H2O]"},
			EffectiveAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordVentSetting: %v", err)
	}
	if err := f.support.InsertVentSetting(ctx, f.scope, setting); err != nil {
		t.Fatalf("InsertVentSetting: %v", err)
	}

	timeline, err := f.support.VentSettings(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("VentSettings: %v", err)
	}
	if len(timeline) != 1 {
		t.Fatalf("%d ventilator records, want 1", len(timeline))
	}
	got := timeline[0]
	if got.Parameters["tidal_volume"] != 450 || got.Measured["tidal_volume"] != 410 {
		t.Fatalf("set %v, delivered %v — the difference is the finding",
			got.Parameters["tidal_volume"], got.Measured["tidal_volume"])
	}
	if got.Units["peep"] != "cm[H2O]" {
		t.Fatalf("units = %v", got.Units)
	}
	if got.Mode != "PRVC" {
		t.Fatalf("mode = %q", got.Mode)
	}
}

// SRS-ICU-006 and SRS-ICU-017. A review interval other than the default has to
// survive, or a unit that reviews twice daily silently reverts to daily.
func TestADevicesReviewIntervalSurvives(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	device, err := domain.InsertDevice(uuid.NewString(), f.tenantID,
		domain.NewDeviceInput{
			EpisodeID: e.ID, Kind: "central_line", Site: "right internal jugular",
			Lumens: 3, InsertedAt: at, ReviewEvery: 12 * time.Hour,
		}, "doctor-1", at)
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if err := f.support.InsertDevice(ctx, f.scope, device); err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}

	devices, err := f.support.Devices(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("Devices: %v", err)
	}
	if len(devices) != 1 {
		t.Fatalf("%d devices, want 1", len(devices))
	}
	if devices[0].ReviewEvery != 12*time.Hour {
		t.Fatalf("review interval = %v, want 12h", devices[0].ReviewEvery)
	}
	if devices[0].Lumens != 3 || devices[0].Site != "right internal jugular" {
		t.Fatalf("device = %+v", devices[0])
	}
	if !devices[0].ReviewOverdue(at.Add(13 * time.Hour)) {
		t.Fatal("a line on a twelve-hour review is not overdue at thirteen")
	}

	reviewed, err := f.support.ReviewDevice(ctx, f.scope, device.ID, "nurse-1",
		at.Add(13*time.Hour))
	if err != nil || !reviewed {
		t.Fatalf("ReviewDevice: %v (reviewed=%v)", err, reviewed)
	}

	removed, err := f.support.RemoveDevice(ctx, f.scope, device.ID, "doctor-1",
		"no longer needed", at.Add(30*time.Hour))
	if err != nil || !removed {
		t.Fatalf("RemoveDevice: %v (removed=%v)", err, removed)
	}
	// A line already out cannot be removed twice, and cannot be reviewed.
	if again, _ := f.support.RemoveDevice(ctx, f.scope, device.ID, "doctor-1", "",
		at.Add(31*time.Hour)); again {
		t.Fatal("a device was removed twice")
	}
	if again, _ := f.support.ReviewDevice(ctx, f.scope, device.ID, "nurse-1",
		at.Add(31*time.Hour)); again {
		t.Fatal("a device that is out was reviewed")
	}
}

// SRS-ICU-009. The inputs are the requirement: a total stored without them is
// a claim nobody can check.
func TestAScoreComesBackWithTheInputsItWasCalculatedFrom(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	platelets, err := domain.NewObservation(uuid.NewString(), f.tenantID,
		domain.NewObservationInput{
			EpisodeID: e.ID, Code: "platelets", Value: 45, ObservedAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := f.flowsheet.InsertObservation(ctx, f.scope, platelets); err != nil {
		t.Fatalf("InsertObservation: %v", err)
	}

	formula := domain.Formula{
		Name: "SOFA-like", Version: "1",
		Components: []domain.Component{
			{Name: "coagulation", Code: "platelets", Points: []domain.Band{
				{AtMost: 50, HasAtMost: true, Points: 3},
				{AtLeast: 50, HasAtLeast: true, Points: 0},
			}},
			{Name: "liver", Code: "bilirubin", Points: []domain.Band{
				{AtLeast: 0, HasAtLeast: true, Points: 0},
			}},
		},
	}
	score, err := formula.Calculate(uuid.NewString(), f.tenantID, e.ID,
		domain.ObservationList{platelets}, "doctor-1", at)
	if err != nil {
		t.Fatalf("Calculate: %v", err)
	}
	if err := f.care.InsertScore(ctx, f.scope, score); err != nil {
		t.Fatalf("InsertScore: %v", err)
	}

	scores, err := f.care.Scores(ctx, f.scope, e.ID, 10)
	if err != nil {
		t.Fatalf("Scores: %v", err)
	}
	if len(scores) != 1 {
		t.Fatalf("%d scores, want 1", len(scores))
	}
	got := scores[0]
	if len(got.Inputs) != 1 || got.Inputs[0].ObservationID != platelets.ID {
		t.Fatalf("inputs = %+v, want the platelet observation", got.Inputs)
	}
	// The missing component survives, so an incomplete score cannot be read as
	// a low one.
	if got.Complete() {
		t.Fatalf("the missing liver component was lost: %+v", got.Missing)
	}

	reproduced, err := formula.Reproduce(got)
	if err != nil {
		t.Fatalf("Reproduce from stored inputs: %v", err)
	}
	if reproduced != got.Total {
		t.Fatalf("stored total %d, reproduced %d", got.Total, reproduced)
	}
}

// SRS-ICU-010. An exception and its reason travel together, because an
// exception with no reason is a failure wearing a better name.
func TestABundleRunKeepsEveryElementAndItsReason(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	def := domain.BundleDefinition{
		Kind: domain.BundleVTE, Version: "2",
		Items: []domain.BundleItem{
			{Code: "pharmacological", Required: true},
			{Code: "mechanical", Required: true},
		},
	}
	run, err := domain.PerformBundle(uuid.NewString(), f.tenantID, e.ID, def,
		[]domain.BundleResult{
			{Code: "pharmacological", State: domain.ItemException,
				Reason: "therapeutic anticoagulation"},
			{Code: "mechanical", State: domain.ItemDone},
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformBundle: %v", err)
	}
	if err := f.care.InsertBundle(ctx, f.scope, run); err != nil {
		t.Fatalf("InsertBundle: %v", err)
	}

	bundles, err := f.care.Bundles(ctx, f.scope, e.ID, 10)
	if err != nil {
		t.Fatalf("Bundles: %v", err)
	}
	if len(bundles) != 1 || len(bundles[0].Results) != 2 {
		t.Fatalf("bundles = %+v", bundles)
	}
	compliance := bundles[0].Score(def)
	if compliance.Excepted != 1 || !compliance.Compliant {
		t.Fatalf("compliance = %+v", compliance)
	}
	for _, result := range bundles[0].Results {
		if result.State == domain.ItemException && result.Reason == "" {
			t.Fatal("an exception lost its reason on the way to the database")
		}
	}
}

// SRS-ICU-015. Recording a new ceiling supersedes the one in force in the same
// call, because a unit that briefly had two current ceilings is one where a
// resuscitation decision was ambiguous.
func TestANewCeilingSupersedesTheOneInForce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	first := mustCeiling(t, f, e.ID, domain.IntentFullEscalation, at)
	second := mustCeiling(t, f, e.ID, domain.IntentComfort, at.Add(12*time.Hour))

	all, err := f.care.GoalsOfCare(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("GoalsOfCare: %v", err)
	}
	if len(all) != 2 {
		t.Fatalf("%d ceilings, want the history kept", len(all))
	}

	current, ok := domain.CurrentGoalsOfCare(all)
	if !ok || current.ID != second.ID {
		t.Fatalf("current ceiling = %+v, want the second", current)
	}
	for _, ceiling := range all {
		if ceiling.ID == first.ID && ceiling.Current() {
			t.Fatal("the first ceiling is still current")
		}
	}
	if current.Intent != domain.IntentComfort || current.CPRStatus != "not for CPR" {
		t.Fatalf("ceiling = %q / %q", current.Intent, current.CPRStatus)
	}
}

func mustCeiling(t *testing.T, f fixture, episodeID string, intent domain.CareIntent,
	when time.Time) domain.GoalsOfCare {

	t.Helper()
	ceiling, err := domain.RecordGoalsOfCare(uuid.NewString(), f.tenantID,
		domain.NewGoalsOfCareInput{
			EpisodeID: episodeID, Intent: intent, CPRStatus: "not for CPR",
			Rationale: "agreed with the family", DiscussedWith: "patient and daughter",
			AuthorisedBy: "consultant-1", AuthorisedRole: "intensivist",
		}, "doctor-1", when)
	if err != nil {
		t.Fatalf("RecordGoalsOfCare: %v", err)
	}
	if err := f.care.InsertGoalsOfCare(context.Background(), f.scope, ceiling); err != nil {
		t.Fatalf("InsertGoalsOfCare: %v", err)
	}
	return ceiling
}

// SRS-ICU-008 and SRS-ICU-014: goals and assessments come back with what makes
// them actionable — the owner and the generated due time.
func TestGoalsAndAssessmentsKeepWhatMakesThemActionable(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	goal, err := domain.NewGoal(uuid.NewString(), f.tenantID, domain.NewGoalInput{
		EpisodeID: e.ID, Domain: "sedation", Text: "wean sedation to RASS -1",
		OwnerRole: "nursing",
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewGoal: %v", err)
	}
	if err := f.care.InsertGoal(ctx, f.scope, goal); err != nil {
		t.Fatalf("InsertGoal: %v", err)
	}

	assessment, err := domain.RecordAssessment(uuid.NewString(), f.tenantID,
		domain.NewAssessmentInput{
			EpisodeID: e.ID, Kind: domain.AssessmentRestraint,
			Note: "bilateral mitts", PerformedAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	if err := f.care.InsertAssessment(ctx, f.scope, assessment); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}

	goals, err := f.care.Goals(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("Goals: %v", err)
	}
	if len(goals) != 1 || goals[0].OwnerRole != "nursing" {
		t.Fatalf("goals = %+v; an unowned goal is one nobody does", goals)
	}

	assessments, err := f.care.Assessments(ctx, f.scope, e.ID, 10)
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	if len(assessments) != 1 {
		t.Fatalf("%d assessments, want 1", len(assessments))
	}
	if !assessments[0].NextDueAt.Equal(at.Add(time.Hour)) {
		t.Fatalf("next due = %v, want the hourly restraint interval",
			assessments[0].NextDueAt)
	}
	if len(domain.DueAssessments(assessments, at.Add(90*time.Minute))) != 1 {
		t.Fatal("an overdue restraint assessment is not on the due list")
	}

	// Closing a goal twice is a race the repository settles, not an error.
	if err := goals[0].Resolve(domain.GoalMet, "", "nurse-1", at.Add(8*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	resolved, err := f.care.ResolveGoal(ctx, f.scope, goals[0])
	if err != nil || !resolved {
		t.Fatalf("ResolveGoal: %v (resolved=%v)", err, resolved)
	}
	if again, _ := f.care.ResolveGoal(ctx, f.scope, goals[0]); again {
		t.Fatal("a goal was closed twice")
	}
}

// A record belonging to another tenant is not readable through this scope, and
// the refusal is not-found: a probe must not be able to confirm that an
// identifier exists elsewhere.
func TestAnotherTenantsEpisodeIsNotFound(t *testing.T) {
	f := newFixture(t)
	e := f.episode(t)

	other := authctx.NewSession(authctx.Session{
		SubjectID: "nurse-2", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.episodes.GetEpisode(context.Background(), other, e.ID); err == nil {
		t.Fatal("an episode was readable from another tenant's scope")
	}
}

// The one-current-ceiling rule is enforced by the database, not by the adapter
// being careful. This inserts a second current ceiling directly, bypassing the
// adapter entirely, and the index must refuse it — otherwise the guarantee is
// a convention, and conventions are what a future caller breaks.
func TestTwoCurrentCeilingsCannotExist(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := f.episode(t)

	mustCeiling(t, f, e.ID, domain.IntentFullEscalation, at)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO icu.goals_of_care (
		    goals_of_care_id, tenant_id, episode_id, intent, cpr_status,
		    rationale, authorised_by, recorded_at, recorded_by
		) VALUES ($1, $2, $3, 'comfort', 'not for CPR', 'second opinion',
		          'consultant-2', $4, 'doctor-2')`,
		uuid.NewString(), f.tenantID, e.ID, at.Add(time.Hour))
	if err == nil {
		t.Fatal("a second current ceiling of treatment was accepted")
	}
}
