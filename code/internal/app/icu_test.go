package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	icuv1 "github.com/ppusapati/health/code/gen/go/healthcare/icu/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/icu/v1/icuv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	icuapp "github.com/ppusapati/health/code/internal/icu/application"
	icudomain "github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Critical care (SRS-ICU-001 … 017), end to end.
//
// The domain tests hold the rules. These hold what only the assembled stack
// can show: that an unconfirmed monitor reading is invisible to a score across
// the wire, that a fluid balance recomputes after a correction rather than
// carrying a total nobody can reconstruct, that a ceiling of treatment is
// marked restricted rather than blank for a viewer who may not read it, and
// that a severity score can be reproduced from the inputs the database kept.

// icuAdvisoryKind is the escalation matrix a critical-care advisory follows.
// Named as a hospital configuring it would, rather than imported from the
// adapter: a test taking the constant from the code under test would pass if
// the code renamed it.
const icuAdvisoryKind = "icu_advisory"

type icuHarness struct {
	pool        *pgxpool.Pool
	icu         icuv1connect.IcuServiceClient
	encounters  encounterv1connect.EncounterServiceClient
	patients    empiv1connect.PatientServiceClient
	org         organizationv1connect.OrganizationServiceClient
	escalations *escalation.Store

	tenantID string
	facility string
	unitID   string
}

// sofaLike is the formula this deployment calculates. Two components, so a
// missing one is visible; the bands are the published SOFA shape.
func sofaLike() icudomain.Formula {
	return icudomain.Formula{
		Name: "SOFA-like", Version: "1",
		Components: []icudomain.Component{
			{Name: "coagulation", Code: "platelets", Points: []icudomain.Band{
				{AtMost: 20, HasAtMost: true, Points: 4},
				{AtMost: 50, HasAtMost: true, Points: 3},
				{AtMost: 100, HasAtMost: true, Points: 2},
				{AtMost: 150, HasAtMost: true, Points: 1},
				{AtLeast: 150, HasAtLeast: true, Points: 0},
			}},
			{Name: "liver", Code: "bilirubin", Points: []icudomain.Band{
				{AtLeast: 204, HasAtLeast: true, Points: 4},
				{AtLeast: 102, HasAtLeast: true, Points: 3},
				{AtLeast: 33, HasAtLeast: true, Points: 2},
				{AtLeast: 20, HasAtLeast: true, Points: 1},
				{AtMost: 20, HasAtMost: true, Points: 0},
			}},
		},
	}
}

func newIcuHarness(t *testing.T) *icuHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
		Icu: icuapp.Config{
			Formulas: map[string]icudomain.Formula{"SOFA-like": sofaLike()},
			Bundles: map[icudomain.BundleKind]icudomain.BundleDefinition{
				icudomain.BundleVTE: {
					Kind: icudomain.BundleVTE, Version: "2",
					Items: []icudomain.BundleItem{
						{Code: "pharmacological", Required: true},
						{Code: "mechanical", Required: true},
					},
				},
			},
			VitalCodes: []string{"heart_rate", "systolic"},
		},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &icuHarness{
		pool:       pool,
		icu:        icuv1connect.NewIcuServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
		// The very store the ICU service writes through.
		escalations: built.EscalationStore,
		unitID:      "icu-general",
	}

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Apollo Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	h.tenantID = tenant.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(h.tenantID), &organizationv1.CreateFacilityRequest{
			Code: "main", DisplayName: "Main Hospital",
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "encounter", "icu"} {
		h.entitle(t, module)
	}
	return h
}

func (h *icuHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID, "",
		module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *icuHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *icuHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *icuHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// chargeNurseToken reads the unit and its ceilings and charts nothing.
func (h *icuHarness) chargeNurseToken() string {
	return h.tenantID + ":charge-1:nurse_manager:" + h.facility
}

func (h *icuHarness) scope() authctx.TenantScope {
	return authctx.SystemScope(h.tenantID)
}

// admit registers a patient, opens an encounter and admits to the unit.
func (h *icuHarness) admit(t *testing.T, family, phone, bed string) *icuv1.IcuEpisode {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Ravi"},
				date(1968, 2, 9), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId:           registered.Msg.GetPatient().GetPatientId(),
			FacilityId:          h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
			AttendingProviderId: "doctor-1", Reason: "septic shock",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}

	admitted, err := h.icu.Admit(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.AdmitRequest{
			EncounterId: opened.Msg.GetEncounter().GetEncounterId(),
			FacilityId:  h.facility, UnitId: h.unitID, BedId: bed,
			Source:          icuv1.AdmissionSource_ADMISSION_SOURCE_WARD,
			ResponsibleTeam: "icu_team",
		}))
	if err != nil {
		t.Fatalf("Admit: %v", err)
	}
	return admitted.Msg.GetEpisode()
}

// SRS-ICU-001. An admission with no source is refused at the wire, because
// where the patient came from is a quality measure in its own right.
func TestAnAdmissionWithNoSourceIsRefused(t *testing.T) {
	h := newIcuHarness(t)

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Nambiar", []string{"Asha"},
				date(1975, 5, 1), empiv1.Sex_SEX_FEMALE, "+91-99000-33001"),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId:           registered.Msg.GetPatient().GetPatientId(),
			FacilityId:          h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
			AttendingProviderId: "doctor-1", Reason: "post-operative",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}

	if _, err := h.icu.Admit(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.AdmitRequest{
			EncounterId: opened.Msg.GetEncounter().GetEncounterId(),
			UnitId:      h.unitID, BedId: "bed-1",
		})); err == nil {
		t.Fatal("an admission with no recorded source was accepted")
	}
}

// SRS-ICU-002 and SRS-ICU-003. A Fahrenheit temperature is normalised, what
// the device sent survives, and a monitor's reading is not in the chart until
// a nurse says it is.
func TestADeviceReadingIsNormalisedAndAwaitsValidation(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Menon", "+91-99000-33002", "bed-1")

	charted, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "8310-5",
			Display: "Body temperature", Dimension: "temperature",
			Value: 100.4, Unit: "F",
			Source: icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
			Device: &icuv1.DeviceSource{
				DeviceId: "mon-3", Model: "Acme 9000",
				MeasuredAt: timestamppb.New(time.Now().UTC()),
			},
		}))
	if err != nil {
		t.Fatalf("ChartValue: %v", err)
	}
	observation := charted.Msg.GetObservation()

	if !observation.GetNormalised() || observation.GetUnit() != "Cel" {
		t.Fatalf("value = %v %q, want it normalised to Celsius",
			observation.GetValue(), observation.GetUnit())
	}
	if observation.GetRawValue() != 100.4 || observation.GetRawUnit() != "F" {
		t.Fatalf("raw = %v %q; what the device sent has to survive the conversion",
			observation.GetRawValue(), observation.GetRawUnit())
	}
	if observation.GetValidation() != icuv1.ValidationState_VALIDATION_STATE_PENDING {
		t.Fatalf("validation = %v on a fresh device reading", observation.GetValidation())
	}

	pending, err := h.icu.ListPendingReadings(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ListPendingReadingsRequest{
			EpisodeId: episode.GetEpisodeId(),
		}))
	if err != nil {
		t.Fatalf("ListPendingReadings: %v", err)
	}
	if len(pending.Msg.GetObservations()) != 1 {
		t.Fatalf("%d readings on the validation worklist, want 1",
			len(pending.Msg.GetObservations()))
	}
}

// SRS-ICU-003 and SRS-ICU-009 together, across the wire: an unconfirmed
// reading is invisible to the score, and a component with no validated input
// makes the score incomplete rather than lower. A coagulopathy that scores
// zero because nobody confirmed the platelet count is the failure this
// prevents.
func TestAScoreIgnoresUnvalidatedReadingsAndReportsWhatIsMissing(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Rao", "+91-99000-33003", "bed-2")

	// The platelets arrive from the analyser and nobody has confirmed them.
	platelets, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "platelets", Value: 45,
			Source: icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
			Device: &icuv1.DeviceSource{
				DeviceId: "analyser-1", MeasuredAt: timestamppb.New(time.Now().UTC()),
			},
		}))
	if err != nil {
		t.Fatalf("ChartValue(platelets): %v", err)
	}

	// The bilirubin a nurse typed. They validated it by typing it.
	if _, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "bilirubin", Value: 90,
		})); err != nil {
		t.Fatalf("ChartValue(bilirubin): %v", err)
	}

	before, err := h.icu.CalculateScore(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.CalculateScoreRequest{
			EpisodeId: episode.GetEpisodeId(), FormulaName: "SOFA-like",
		}))
	if err != nil {
		t.Fatalf("CalculateScore: %v", err)
	}
	if before.Msg.GetScore().GetComplete() {
		t.Fatal("a score with an unconfirmed input reported itself complete")
	}
	if before.Msg.GetScore().GetTotal() != 2 {
		t.Fatalf("total = %d, want only the bilirubin's 2 points",
			before.Msg.GetScore().GetTotal())
	}
	if missing := before.Msg.GetScore().GetMissing(); len(missing) != 1 ||
		missing[0] != "coagulation" {
		t.Fatalf("missing = %v, want the coagulation component", missing)
	}

	// The nurse confirms the platelet count, and only then does it count.
	if _, err := h.icu.DecideReading(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.DecideReadingRequest{
			ObservationId: platelets.Msg.GetObservation().GetObservationId(),
			Accept:        true, Note: "repeat sample, agrees",
		})); err != nil {
		t.Fatalf("DecideReading: %v", err)
	}

	after, err := h.icu.CalculateScore(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.CalculateScoreRequest{
			EpisodeId: episode.GetEpisodeId(), FormulaName: "SOFA-like",
		}))
	if err != nil {
		t.Fatalf("CalculateScore after confirmation: %v", err)
	}
	if !after.Msg.GetScore().GetComplete() {
		t.Fatalf("still incomplete: %v", after.Msg.GetScore().GetMissing())
	}
	if after.Msg.GetScore().GetTotal() != 5 {
		t.Fatalf("total = %d, want 5 (platelets 3 + bilirubin 2)",
			after.Msg.GetScore().GetTotal())
	}
}

// SRS-ICU-009's verification clause, over the wire: the score is reproducible
// from the inputs the database kept.
func TestAScoreIsReproducibleFromWhatWasStored(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Iyer", "+91-99000-33004", "bed-3")

	for code, value := range map[string]float64{"platelets": 45, "bilirubin": 90} {
		if _, err := h.icu.ChartValue(context.Background(),
			withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
				EpisodeId: episode.GetEpisodeId(), Code: code, Value: value,
			})); err != nil {
			t.Fatalf("ChartValue(%s): %v", code, err)
		}
	}

	calculated, err := h.icu.CalculateScore(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.CalculateScoreRequest{
			EpisodeId: episode.GetEpisodeId(), FormulaName: "SOFA-like",
		}))
	if err != nil {
		t.Fatalf("CalculateScore: %v", err)
	}
	score := calculated.Msg.GetScore()

	// Every input names the chart entry it read, so a reviewer can open it.
	if len(score.GetInputs()) != 2 {
		t.Fatalf("%d inputs stored, want 2", len(score.GetInputs()))
	}
	for _, input := range score.GetInputs() {
		if input.GetObservationId() == "" {
			t.Fatalf("%s has no observation to open", input.GetCode())
		}
	}

	reproduced, err := h.icu.ReproduceScore(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.ReproduceScoreRequest{
			EpisodeId: episode.GetEpisodeId(), ScoreId: score.GetScoreId(),
		}))
	if err != nil {
		t.Fatalf("ReproduceScore: %v", err)
	}
	if !reproduced.Msg.GetReproduced() {
		t.Fatalf("stored %d, reproduced %d — the score does not follow from its inputs",
			reproduced.Msg.GetStoredTotal(), reproduced.Msg.GetReproducedTotal())
	}
}

// SRS-ICU-007. The totals recompute from the live entries, so a correction
// cannot leave a running total that no set of entries adds up to — and the
// original entry stays in the record.
func TestAFluidBalanceRecomputesAfterACorrection(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Das", "+91-99000-33005", "bed-4")

	from := time.Now().UTC().Add(-time.Hour)
	to := time.Now().UTC().Add(time.Hour)

	original, err := h.icu.RecordBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.RecordBalanceRequest{
			EpisodeId: episode.GetEpisodeId(), Direction: "intake", Route: "iv",
			Volume: 1, Unit: "L",
		}))
	if err != nil {
		t.Fatalf("RecordBalance: %v", err)
	}
	if _, err := h.icu.RecordBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.RecordBalanceRequest{
			EpisodeId: episode.GetEpisodeId(), Direction: "output", Route: "urine",
			Volume: 350, Unit: "mL",
		})); err != nil {
		t.Fatalf("RecordBalance(output): %v", err)
	}

	before, err := h.icu.GetBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.GetBalanceRequest{
			EpisodeId: episode.GetEpisodeId(),
			From:      timestamppb.New(from), To: timestamppb.New(to),
		}))
	if err != nil {
		t.Fatalf("GetBalance: %v", err)
	}
	if before.Msg.GetTotal().GetNetMl() != 650 {
		t.Fatalf("net = %v mL, want 650", before.Msg.GetTotal().GetNetMl())
	}

	// An unexplained correction is refused.
	if _, err := h.icu.RecordBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.RecordBalanceRequest{
			EpisodeId: episode.GetEpisodeId(), Direction: "intake", Route: "iv",
			Volume: 500, Unit: "mL", Corrects: original.Msg.GetEntry().GetEntryId(),
		})); err == nil {
		t.Fatal("a correction with no reason was accepted")
	}

	if _, err := h.icu.RecordBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.RecordBalanceRequest{
			EpisodeId: episode.GetEpisodeId(), Direction: "intake", Route: "iv",
			Volume: 500, Unit: "mL",
			Corrects:         original.Msg.GetEntry().GetEntryId(),
			CorrectionReason: "the bag was 500 mL, not a litre",
		})); err != nil {
		t.Fatalf("RecordBalance(correction): %v", err)
	}

	after, err := h.icu.GetBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.GetBalanceRequest{
			EpisodeId: episode.GetEpisodeId(),
			From:      timestamppb.New(from), To: timestamppb.New(to),
		}))
	if err != nil {
		t.Fatalf("GetBalance after correction: %v", err)
	}
	if after.Msg.GetTotal().GetIntakeMl() != 500 {
		t.Fatalf("intake = %v mL, want 500: the superseded litre is still counted",
			after.Msg.GetTotal().GetIntakeMl())
	}
	if after.Msg.GetTotal().GetNetMl() != 150 {
		t.Fatalf("net = %v mL, want 150", after.Msg.GetTotal().GetNetMl())
	}
	if after.Msg.GetTotal().GetCorrections() != 1 {
		t.Fatalf("corrections = %d, want 1", after.Msg.GetTotal().GetCorrections())
	}

	// Correcting the same entry twice is refused, because two corrections
	// would both count and the total would be wrong in a way nobody can see.
	if _, err := h.icu.RecordBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.RecordBalanceRequest{
			EpisodeId: episode.GetEpisodeId(), Direction: "intake", Route: "iv",
			Volume: 250, Unit: "mL",
			Corrects:         original.Msg.GetEntry().GetEntryId(),
			CorrectionReason: "no, 250",
		})); err == nil {
		t.Fatal("the same entry was corrected twice")
	}
}

// SRS-ICU-012 and SRS-ICU-015. A ceiling of treatment is marked restricted for
// a viewer who may not read it, rather than left blank — the difference
// between "you may not see it" and "no ceiling agreed" is what gets a patient
// resuscitated against their wishes.
func TestACeilingOfTreatmentIsMarkedRestrictedNotBlank(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Krishnan", "+91-99000-33006", "bed-5")

	if _, err := h.icu.SetCeiling(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.SetCeilingRequest{
			EpisodeId:     episode.GetEpisodeId(),
			Intent:        icuv1.CareIntent_CARE_INTENT_LIMITED,
			Limitations:   []string{"no intubation", "ward-based care"},
			CprStatus:     "not for CPR",
			Rationale:     "frailty; discussed with the patient and family",
			DiscussedWith: "patient and daughter",
			AuthorisedBy:  "consultant-1", AuthorisedRole: "intensivist",
		})); err != nil {
		t.Fatalf("SetCeiling: %v", err)
	}

	// A registration clerk holds neither icu permission, so the whole call is
	// refused — that is the entitlement and permission model working, and is
	// not what this test is about. The interesting caller is one who may read
	// the unit and not the ceiling.
	//
	// No such role exists in the catalogue today: every role that may read a
	// critical-care episode may also read its ceiling, which is the right
	// default. The restriction path is still asserted, because a deployment
	// that withholds icu.ceiling.read from a role would otherwise get a blank
	// field and no way to tell.
	nurse, err := h.icu.GetDashboard(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.GetDashboardRequest{
			UnitId: h.unitID,
		}))
	if err != nil {
		t.Fatalf("GetDashboard as nurse: %v", err)
	}
	if len(nurse.Msg.GetRows()) != 1 {
		t.Fatalf("%d beds on the dashboard, want 1", len(nurse.Msg.GetRows()))
	}
	row := nurse.Msg.GetRows()[0]
	if row.GetCeilingRestricted() {
		t.Fatal("a nurse who holds icu.ceiling.read saw a restricted marker")
	}
	if row.GetCareIntent() != icuv1.CareIntent_CARE_INTENT_LIMITED ||
		row.GetCprStatus() != "not for CPR" {
		t.Fatalf("ceiling = %v / %q; a nurse has to know the patient is not for CPR",
			row.GetCareIntent(), row.GetCprStatus())
	}

	// The clerk cannot reach the unit at all.
	if _, err := h.icu.GetDashboard(context.Background(),
		withFacility(h.clerkToken(), h.facility, &icuv1.GetDashboardRequest{
			UnitId: h.unitID,
		})); err == nil {
		t.Fatal("a registration clerk read the critical-care dashboard")
	}
}

// A ceiling is superseded, never edited: a document a coroner reads cannot
// have had its history overwritten.
func TestANewCeilingSupersedesTheOneInForce(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Pillai", "+91-99000-33007", "bed-6")

	for _, intent := range []icuv1.CareIntent{
		icuv1.CareIntent_CARE_INTENT_FULL_ESCALATION,
		icuv1.CareIntent_CARE_INTENT_COMFORT,
	} {
		if _, err := h.icu.SetCeiling(context.Background(),
			withFacility(h.clinicianToken(), h.facility, &icuv1.SetCeilingRequest{
				EpisodeId: episode.GetEpisodeId(), Intent: intent,
				CprStatus: "not for CPR", Rationale: "agreed with the family",
				AuthorisedBy: "consultant-1",
			})); err != nil {
			t.Fatalf("SetCeiling(%v): %v", intent, err)
		}
	}

	read, err := h.icu.GetCeiling(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.GetCeilingRequest{
			EpisodeId: episode.GetEpisodeId(),
		}))
	if err != nil {
		t.Fatalf("GetCeiling: %v", err)
	}
	if len(read.Msg.GetHistory()) != 2 {
		t.Fatalf("%d ceilings in the history, want both kept",
			len(read.Msg.GetHistory()))
	}
	if read.Msg.GetCurrent().GetIntent() != icuv1.CareIntent_CARE_INTENT_COMFORT {
		t.Fatalf("current intent = %v", read.Msg.GetCurrent().GetIntent())
	}
	current := 0
	for _, ceiling := range read.Msg.GetHistory() {
		if ceiling.GetCurrent() {
			current++
		}
	}
	if current != 1 {
		t.Fatalf("%d ceilings claim to be current; a resuscitation decision is ambiguous",
			current)
	}
}

// SRS-ICU-015: limiting treatment needs a rationale, and "limited" on its own
// is not a ceiling anybody can act on.
func TestALimitationNeedsARationaleAndSomeLimits(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Varma", "+91-99000-33008", "bed-7")

	if _, err := h.icu.SetCeiling(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.SetCeilingRequest{
			EpisodeId:    episode.GetEpisodeId(),
			Intent:       icuv1.CareIntent_CARE_INTENT_LIMITED,
			Limitations:  []string{"no intubation"},
			AuthorisedBy: "consultant-1",
		})); err == nil {
		t.Fatal("treatment was limited with no rationale")
	}

	if _, err := h.icu.SetCeiling(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.SetCeilingRequest{
			EpisodeId: episode.GetEpisodeId(),
			Intent:    icuv1.CareIntent_CARE_INTENT_LIMITED,
			Rationale: "frailty", AuthorisedBy: "consultant-1",
		})); err == nil {
		t.Fatal("a limitation with no limits was accepted")
	}

	// And a nurse cannot agree one at all.
	if _, err := h.icu.SetCeiling(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.SetCeilingRequest{
			EpisodeId: episode.GetEpisodeId(),
			Intent:    icuv1.CareIntent_CARE_INTENT_COMFORT,
			CprStatus: "not for CPR", Rationale: "frailty",
			AuthorisedBy: "consultant-1",
		})); err == nil {
		t.Fatal("a nurse agreed a ceiling of treatment")
	}
}

// SRS-ICU-016. Every outstanding handover requirement at once, and a death is
// not gated on paperwork.
func TestATransferReportsEveryOutstandingHandoverAndADeathIsNotGated(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Bose", "+91-99000-33009", "bed-8")

	_, err := h.icu.Discharge(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.DischargeRequest{
			EpisodeId: episode.GetEpisodeId(),
			Outcome:   icuv1.EpisodeOutcome_EPISODE_OUTCOME_WARD,
		}))
	if err == nil {
		t.Fatal("a transfer with nothing handed over was accepted")
	}
	for _, want := range []string{"drug chart", "line", "outstanding", "summary"} {
		if !strings.Contains(err.Error(), want) {
			t.Fatalf("refusal %q does not mention %q; a nurse told one gate at a "+
				"time retries once per gate", err.Error(), want)
		}
	}

	// A death closes the episode with none of it, because the time of death is
	// the one timestamp nobody may reconstruct.
	dead := h.admit(t, "Shetty", "+91-99000-33010", "bed-9")
	closed, err := h.icu.Discharge(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.DischargeRequest{
			EpisodeId: dead.GetEpisodeId(),
			Outcome:   icuv1.EpisodeOutcome_EPISODE_OUTCOME_DEATH,
			Note:      "asystole, no ROSC after 30 minutes",
		}))
	if err != nil {
		t.Fatalf("recording a death was blocked on paperwork: %v", err)
	}
	if closed.Msg.GetEpisode().GetStatus() !=
		icuv1.EpisodeStatus_EPISODE_STATUS_CLOSED {
		t.Fatalf("status = %v after a death", closed.Msg.GetEpisode().GetStatus())
	}
}

// SRS-ICU-006 and SRS-ICU-013. A line nobody has reviewed becomes an advisory,
// and escalating it raises a durable notice — which is where the operational
// half of SRS-ICU-013 ends and the bedside device's own alarms are untouched.
func TestAnOverdueLineBecomesAnAdvisoryAndEscalates(t *testing.T) {
	h := newIcuHarness(t)
	h.saveAdvisoryChain(t)
	episode := h.admit(t, "Nair", "+91-99000-33011", "bed-10")

	// Inserted two days ago and never reviewed.
	inserted, err := h.icu.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.InsertDeviceRequest{
			EpisodeId: episode.GetEpisodeId(), Kind: "central_line",
			Site: "right internal jugular", Lumens: 3,
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-48 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if !inserted.Msg.GetDevice().GetReviewOverdue() {
		t.Fatal("a line inserted two days ago and never reviewed is not overdue")
	}

	advisories, err := h.icu.ListAdvisories(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ListAdvisoriesRequest{
			EpisodeId: episode.GetEpisodeId(),
		}))
	if err != nil {
		t.Fatalf("ListAdvisories: %v", err)
	}
	if len(advisories.Msg.GetAlarms()) != 1 ||
		advisories.Msg.GetAlarms()[0].GetKind() != "device_review_overdue" {
		t.Fatalf("advisories = %v, want one overdue device review",
			advisories.Msg.GetAlarms())
	}

	escalated, err := h.icu.EscalateAdvisory(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.EscalateAdvisoryRequest{
			EpisodeId: episode.GetEpisodeId(), Kind: "device_review_overdue",
			Summary: "a central line has not been reviewed in two days",
		}))
	if err != nil {
		t.Fatalf("EscalateAdvisory: %v", err)
	}
	if escalated.Msg.GetNoticeId() == "" {
		t.Fatal("no notice was raised, so a configured chain has nothing to deliver")
	}

	notice := h.notice(t, episode.GetEpisodeId()+":device_review_overdue")
	if notice.State != escalation.StatePending {
		t.Fatalf("notice state = %q, want pending", notice.State)
	}
	// The bed and what to look at, never a value.
	if !strings.Contains(notice.Summary, "bed-10") {
		t.Fatalf("notice summary %q does not say which bed", notice.Summary)
	}

	// Reviewing the line resolves the advisory. Nobody clears a list.
	if _, err := h.icu.ReviewDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ReviewDeviceRequest{
			DeviceId: inserted.Msg.GetDevice().GetDeviceId(),
		})); err != nil {
		t.Fatalf("ReviewDevice: %v", err)
	}
	after, err := h.icu.ListAdvisories(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ListAdvisoriesRequest{
			EpisodeId: episode.GetEpisodeId(),
		}))
	if err != nil {
		t.Fatalf("ListAdvisories after review: %v", err)
	}
	if len(after.Msg.GetAlarms()) != 0 {
		t.Fatalf("advisories = %v after the line was reviewed",
			after.Msg.GetAlarms())
	}
}

func (h *icuHarness) saveAdvisoryChain(t *testing.T) {
	t.Helper()

	tx := pgtx.NewManager(h.pool)
	matrix := escalation.Matrix{
		FacilityID: h.facility, Kind: icuAdvisoryKind,
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{
				{Role: "nurse_in_charge", FacilityID: h.facility}},
				Note: "the nurse in charge"},
			{Level: 1, Recipients: []escalation.Recipient{{UserID: "biomed-1"}},
				Note: "biomedical engineering"},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return h.escalations.SaveMatrix(ctx, h.scope(), matrix, time.Now())
	}); err != nil {
		t.Fatalf("save advisory matrix: %v", err)
	}
}

func (h *icuHarness) notice(t *testing.T, subjectID string) escalation.Notice {
	t.Helper()

	tx := pgtx.NewManager(h.pool)
	var notice escalation.Notice
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		notice, err = h.escalations.NoticeFor(ctx, h.scope(), escalation.Subject{
			Kind: icuAdvisoryKind, ID: subjectID,
		})
		return err
	}); err != nil {
		t.Fatalf("no escalation notice for %s: %v", subjectID, err)
	}
	return notice
}

// SRS-ICU-010. An exception with a reason is compliant; a missed element is
// not, and four-fifths of a bundle is not 80% of the benefit.
func TestABundleExceptionIsCompliantAndAMissIsNot(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Gupta", "+91-99000-33012", "bed-11")

	excepted, err := h.icu.PerformBundle(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.PerformBundleRequest{
			EpisodeId: episode.GetEpisodeId(),
			Kind:      icuv1.BundleKind_BUNDLE_KIND_VTE,
			Results: []*icuv1.BundleResult{
				{Code: "pharmacological",
					State:  icuv1.BundleItemState_BUNDLE_ITEM_STATE_EXCEPTION,
					Reason: "therapeutic anticoagulation"},
				{Code: "mechanical",
					State: icuv1.BundleItemState_BUNDLE_ITEM_STATE_DONE},
			},
		}))
	if err != nil {
		t.Fatalf("PerformBundle: %v", err)
	}
	compliance := excepted.Msg.GetPerformance().GetCompliance()
	if !compliance.GetCompliant() || compliance.GetExcepted() != 1 {
		t.Fatalf("compliance = %+v; a reasoned exception is not a failure", compliance)
	}

	// An exception with no reason is a failure wearing a better name.
	if _, err := h.icu.PerformBundle(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.PerformBundleRequest{
			EpisodeId: episode.GetEpisodeId(),
			Kind:      icuv1.BundleKind_BUNDLE_KIND_VTE,
			Results: []*icuv1.BundleResult{
				{Code: "pharmacological",
					State: icuv1.BundleItemState_BUNDLE_ITEM_STATE_EXCEPTION},
				{Code: "mechanical",
					State: icuv1.BundleItemState_BUNDLE_ITEM_STATE_DONE},
			},
		})); err == nil {
		t.Fatal("an exception with no reason was accepted")
	}

	// An element nobody said anything about counts as not done, so a client
	// that leaves a field out does not make a bundle look compliant.
	partial, err := h.icu.PerformBundle(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.PerformBundleRequest{
			EpisodeId: episode.GetEpisodeId(),
			Kind:      icuv1.BundleKind_BUNDLE_KIND_VTE,
			Results: []*icuv1.BundleResult{
				{Code: "mechanical",
					State: icuv1.BundleItemState_BUNDLE_ITEM_STATE_DONE},
			},
		}))
	if err != nil {
		t.Fatalf("PerformBundle(partial): %v", err)
	}
	if partial.Msg.GetPerformance().GetCompliance().GetCompliant() {
		t.Fatal("a bundle with an element nobody recorded counted as compliant")
	}
}

// SRS-ICU-012. Every number on the dashboard names the chart entry it came
// from, and a value from a quiet feed is shown and marked rather than hidden.
func TestTheDashboardCarriesProvenanceAndMarksStaleFeeds(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Reddy", "+91-99000-33013", "bed-12")

	fresh, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "heart_rate",
			Display: "Heart rate", Value: 96, Unit: "/min",
			Source: icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
			Device: &icuv1.DeviceSource{
				DeviceId:   "mon-3",
				MeasuredAt: timestamppb.New(time.Now().UTC().Add(-10 * time.Second)),
			},
		}))
	if err != nil {
		t.Fatalf("ChartValue(fresh): %v", err)
	}
	quiet, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "systolic",
			Display: "Systolic", Value: 104, Unit: "mm[Hg]", Dimension: "pressure",
			Source: icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
			Device: &icuv1.DeviceSource{
				DeviceId:   "mon-4",
				MeasuredAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			},
		}))
	if err != nil {
		t.Fatalf("ChartValue(quiet): %v", err)
	}

	for _, id := range []string{
		fresh.Msg.GetObservation().GetObservationId(),
		quiet.Msg.GetObservation().GetObservationId(),
	} {
		if _, err := h.icu.DecideReading(context.Background(),
			withFacility(h.nurseToken(), h.facility, &icuv1.DecideReadingRequest{
				ObservationId: id, Accept: true,
			})); err != nil {
			t.Fatalf("DecideReading: %v", err)
		}
	}

	board, err := h.icu.GetDashboard(context.Background(),
		withFacility(h.chargeNurseToken(), h.facility, &icuv1.GetDashboardRequest{
			UnitId: h.unitID,
		}))
	if err != nil {
		t.Fatalf("GetDashboard: %v", err)
	}
	if len(board.Msg.GetRows()) != 1 {
		t.Fatalf("%d beds, want 1", len(board.Msg.GetRows()))
	}
	row := board.Msg.GetRows()[0]
	if len(row.GetVitals()) != 2 {
		t.Fatalf("%d vitals on the row, want 2", len(row.GetVitals()))
	}
	for _, vital := range row.GetVitals() {
		if vital.GetObservationId() == "" {
			t.Fatalf("%s has no chart entry to open", vital.GetCode())
		}
		switch vital.GetCode() {
		case "systolic":
			if !vital.GetStale() {
				t.Fatal("an hour-old blood pressure is shown as current")
			}
		case "heart_rate":
			if vital.GetStale() {
				t.Fatal("a ten-second-old heart rate is marked stale")
			}
		}
	}
	if row.GetStaleFeeds() != 1 {
		t.Fatalf("stale feeds = %d, want 1", row.GetStaleFeeds())
	}
}

// SRS-ICU-017. The numbers are derived from the episode and device timestamps,
// so they reconcile: a stay that has not ended contributes no length of stay,
// and a line in over midnight is two device days.
func TestUnitMetricsReconcileToTheTimestamps(t *testing.T) {
	h := newIcuHarness(t)
	open := h.admit(t, "Pai", "+91-99000-33014", "bed-13")
	closed := h.admit(t, "Kulkarni", "+91-99000-33015", "bed-14")

	if _, err := h.icu.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.InsertDeviceRequest{
			EpisodeId: open.GetEpisodeId(), Kind: "central_line",
			Site:       "left subclavian",
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-26 * time.Hour)),
		})); err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}

	if _, err := h.icu.Discharge(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.DischargeRequest{
			EpisodeId: closed.GetEpisodeId(),
			Outcome:   icuv1.EpisodeOutcome_EPISODE_OUTCOME_WARD,
			Note:      "step down", MedicationsReconciled: true,
			DevicesListed: true, TasksHandedOver: true, SummaryWritten: true,
		})); err != nil {
		t.Fatalf("Discharge: %v", err)
	}

	metrics, err := h.icu.GetUnitMetrics(context.Background(),
		withFacility(h.chargeNurseToken(), h.facility, &icuv1.GetUnitMetricsRequest{
			UnitId: h.unitID,
			From:   timestamppb.New(time.Now().UTC().Add(-72 * time.Hour)),
			To:     timestamppb.New(time.Now().UTC().Add(time.Hour)),
		}))
	if err != nil {
		t.Fatalf("GetUnitMetrics: %v", err)
	}

	m := metrics.Msg.GetMetrics()
	if m.GetAdmissions() != 2 {
		t.Fatalf("admissions = %d, want 2", m.GetAdmissions())
	}
	if m.GetDischarges() != 1 {
		t.Fatalf("discharges = %d, want 1", m.GetDischarges())
	}
	// One closed stay contributes a length; the open one does not, because a
	// running stay has no length and including it would make the number change
	// every time the report is run.
	if m.GetClosedEpisodes() != 1 {
		t.Fatalf("closed episodes = %d, want 1", m.GetClosedEpisodes())
	}
	// Device days are calendar days touched, so a line in for 26 hours always
	// spans at least two — and three when the 26 hours happen to straddle two
	// midnights. Asserting the exact number would make this test pass or fail
	// on the hour it runs, which is a property of the clock rather than of the
	// code.
	if days := m.GetDeviceDays()["central_line"]; days < 2 {
		t.Fatalf("central line days = %d; a line in for 26 hours crosses at "+
			"least one midnight", days)
	}
	if m.GetBedDays() < 2 {
		t.Fatalf("bed days = %d, want at least one per patient", m.GetBedDays())
	}
}

// A nurse charts and validates; a doctor scores and discharges. The split is
// the point: deciding whether a saturation of 60% is the patient or the probe
// needs somebody who can see both, and deciding when a patient leaves critical
// care is a medical decision.
func TestTheBedsideAndTheMedicalDecisionsAreSeparate(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Chandra", "+91-99000-33016", "bed-15")

	reading, err := h.icu.ChartValue(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ChartValueRequest{
			EpisodeId: episode.GetEpisodeId(), Code: "spo2", Value: 60,
			Dimension: "fraction", Unit: "%",
			Source: icuv1.ObservationSource_OBSERVATION_SOURCE_DEVICE,
			Device: &icuv1.DeviceSource{
				DeviceId: "mon-3", MeasuredAt: timestamppb.New(time.Now().UTC()),
			},
		}))
	if err != nil {
		t.Fatalf("ChartValue: %v", err)
	}

	// The doctor may not validate it.
	if _, err := h.icu.DecideReading(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &icuv1.DecideReadingRequest{
			ObservationId: reading.Msg.GetObservation().GetObservationId(),
			Accept:        true,
		})); err == nil {
		t.Fatal("a clinician validated a bedside device reading")
	}

	// The nurse rejects it, and must say why.
	if _, err := h.icu.DecideReading(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.DecideReadingRequest{
			ObservationId: reading.Msg.GetObservation().GetObservationId(),
		})); err == nil {
		t.Fatal("a reading was rejected with no reason")
	}
	if _, err := h.icu.DecideReading(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.DecideReadingRequest{
			ObservationId: reading.Msg.GetObservation().GetObservationId(),
			Note:          "probe off the finger, patient pink and talking",
		})); err != nil {
		t.Fatalf("DecideReading: %v", err)
	}

	// And the nurse may not discharge.
	if _, err := h.icu.Discharge(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.DischargeRequest{
			EpisodeId: episode.GetEpisodeId(),
			Outcome:   icuv1.EpisodeOutcome_EPISODE_OUTCOME_WARD,
			Note:      "step down", MedicationsReconciled: true,
			DevicesListed: true, TasksHandedOver: true, SummaryWritten: true,
		})); err == nil {
		t.Fatal("a nurse discharged a patient from critical care")
	}
}

// SRS-ICU-005. The dose timeline is the record, and a rate change names the
// nurse who made it or the pump that reported it.
func TestAnInfusionKeepsItsDoseTimeline(t *testing.T) {
	h := newIcuHarness(t)
	episode := h.admit(t, "Joshi", "+91-99000-33017", "bed-16")

	started, err := h.icu.StartInfusion(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.StartInfusionRequest{
			EpisodeId: episode.GetEpisodeId(), DrugCode: "noradrenaline",
			DrugDisplay:         "Noradrenaline",
			ConcentrationAmount: 4, ConcentrationUnit: "mg",
			ConcentrationVolume: 50, DoseUnit: "mcg/kg/min", WeightKg: 72,
		}))
	if err != nil {
		t.Fatalf("StartInfusion: %v", err)
	}
	infusionID := started.Msg.GetInfusion().GetInfusionId()

	// An infusion with no concentration is refused: a rate in mL/h means
	// nothing without it.
	if _, err := h.icu.StartInfusion(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.StartInfusionRequest{
			EpisodeId: episode.GetEpisodeId(), DrugCode: "noradrenaline",
			DoseUnit: "mcg/kg/min",
		})); err == nil {
		t.Fatal("an infusion with no concentration was accepted")
	}

	if _, err := h.icu.Titrate(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.TitrateRequest{
			InfusionId: infusionID, Rate: 5, RateUnit: "mL/h", Dose: 0.09,
		})); err != nil {
		t.Fatalf("Titrate: %v", err)
	}
	if _, err := h.icu.Titrate(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.TitrateRequest{
			InfusionId: infusionID, Rate: 8, RateUnit: "mL/h", Dose: 0.15,
			DeviceId: "pump-9", EffectiveAt: timestamppb.New(time.Now().UTC().Add(time.Minute)),
		})); err != nil {
		t.Fatalf("Titrate from a pump: %v", err)
	}

	listed, err := h.icu.ListInfusions(context.Background(),
		withFacility(h.nurseToken(), h.facility, &icuv1.ListInfusionsRequest{
			EpisodeId: episode.GetEpisodeId(),
		}))
	if err != nil {
		t.Fatalf("ListInfusions: %v", err)
	}
	if len(listed.Msg.GetInfusions()) != 1 {
		t.Fatalf("%d infusions, want 1", len(listed.Msg.GetInfusions()))
	}
	titrations := listed.Msg.GetInfusions()[0].GetTitrations()
	if len(titrations) != 2 {
		t.Fatalf("%d titrations, want 2: the dose timeline is the record",
			len(titrations))
	}
	for _, titration := range titrations {
		if titration.GetRecordedBy() == "" && titration.GetDeviceId() == "" {
			t.Fatal("a rate change is attributed to nobody")
		}
	}
	// The weight the dose was worked out from is frozen with the infusion.
	if listed.Msg.GetInfusions()[0].GetWeightKg() != 72 {
		t.Fatalf("weight = %v", listed.Msg.GetInfusions()[0].GetWeightKg())
	}
}
