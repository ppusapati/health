package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	infectionv1 "github.com/ppusapati/health/code/gen/go/healthcare/infection/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/infection/v1/infectionv1connect"
	medicationv1 "github.com/ppusapati/health/code/gen/go/healthcare/medication/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/medication/v1/medicationv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	qualityv1 "github.com/ppusapati/health/code/gen/go/healthcare/quality/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/quality/v1/qualityv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	infectiontherapy "github.com/ppusapati/health/code/internal/infection/adapters/therapy"
	infectionapp "github.com/ppusapati/health/code/internal/infection/application"
	infectiondomain "github.com/ppusapati/health/code/internal/infection/domain"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Infection prevention and control (SRS-IPC-001 … 010), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that the classification a
// hospital's infection rate depends on cannot be typed by the person who
// reports the case, that the bed board a ward reads carries no diagnosis,
// that an occupational exposure is readable only by occupational health and
// every read is written to the audit trail, and — the one this family exists
// for — that a stewardship review raised against a live prescription leaves
// that prescription exactly as it was.

type ipcHarness struct {
	pool       *pgxpool.Pool
	infection  infectionv1connect.InfectionServiceClient
	quality    qualityv1connect.QualityServiceClient
	medication medicationv1connect.MedicationServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newIpcHarness(t *testing.T) *ipcHarness {
	return newIpcHarnessWith(t, infectionapp.Config{
		SurveillanceWindowHours:    48,
		MDROOrganismCodes:          []string{"CPE", "MRSA"},
		IsolationReviewAfter:       48 * time.Hour,
		MinimumHygieneObservations: 5,
		StewardshipDueWithin:       24 * time.Hour,
		AugmentedCareLocations:     []string{"icu"},
	}, infectiontherapy.Config{})
}

func newIpcHarnessWith(t *testing.T, config infectionapp.Config,
	therapy infectiontherapy.Config) *ipcHarness {

	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{
			Version: "test", Commit: "test", BuiltAt: "test",
		},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000,
			UnauthenticatedBurst:             10000,
		},
		Infection: config, InfectionTherapy: therapy,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &ipcHarness{
		pool:      pool,
		infection: infectionv1connect.NewInfectionServiceClient(server.Client(), server.URL),
		quality:   qualityv1connect.NewQualityServiceClient(server.Client(), server.URL),
		medication: medicationv1connect.NewMedicationServiceClient(
			server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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

	for _, module := range []string{
		"infection", "quality", "empi", "encounter", "clinical", "orders",
		"medication",
	} {
		h.entitleIpc(t, module)
	}
	return h
}

func (h *ipcHarness) entitleIpc(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID,
		"", module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope,
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *ipcHarness) nurseIpcToken() string {
	return h.tenantID + ":ipc-1:infection_control_nurse:" + h.facility
}

func (h *ipcHarness) otherNurseIpcToken() string {
	return h.tenantID + ":ipc-2:infection_control_nurse:" + h.facility
}

func (h *ipcHarness) leadToken() string {
	return h.tenantID + ":ipc-lead:infection_control_lead:" + h.facility
}

func (h *ipcHarness) occHealthToken() string {
	return h.tenantID + ":occ-1:occupational_health:" + h.facility
}

func (h *ipcHarness) wardNurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *ipcHarness) doctorToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *ipcHarness) pharmacistToken() string {
	return h.tenantID + ":pharm-1:pharmacist:" + h.facility
}

func (h *ipcHarness) qualityManagerToken() string {
	return h.tenantID + ":qms-boss:quality_manager:" + h.facility
}

// openCase reports a ventilator-associated pneumonia that appeared four days
// into an admission, which the 48-hour window classifies as healthcare
// associated.
func (h *ipcHarness) openCase(t *testing.T, token string,
	mutate func(*infectionv1.OpenCaseRequest)) *infectionv1.SurveillanceCase {

	t.Helper()
	admitted := time.Now().UTC().Add(-10 * 24 * time.Hour)
	req := &infectionv1.OpenCaseRequest{
		Reference: "IPC-" + uuid.NewString()[:8],
		PatientId: "patient-1", EncounterId: "enc-1",
		FacilityId: h.facility, LocationId: "icu",
		Organism: "Klebsiella pneumoniae", OrganismCode: "CPE",
		Site:         infectionv1.InfectionSite_INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM,
		AdmittedAt:   timestamppb.New(admitted),
		OnsetAt:      timestamppb.New(admitted.Add(4 * 24 * time.Hour)),
		DeviceInSitu: true, DeviceDays: 4,
		Criteria: "CDC CLABSI definition",
	}
	if mutate != nil {
		mutate(req)
	}
	opened, err := h.infection.OpenCase(context.Background(),
		withFacility(token, h.facility, req))
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	return opened.Msg.GetSurveillanceCase()
}

// SRS-IPC-001. The classification nobody types, and the override that stays
// visible as one.
func TestAnOnsetClassificationIsDerivedAndAnOverrideIsVisible(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	one := h.openCase(t, h.nurseIpcToken(), nil)
	if one.GetOnset() != infectionv1.Onset_ONSET_HEALTHCARE_ASSOCIATED {
		t.Fatalf("onset = %v, want healthcare associated", one.GetOnset())
	}
	if one.GetWindowHours() != 48 {
		t.Fatalf("window = %d hours", one.GetWindowHours())
	}
	if !one.GetMultidrugResistant() {
		t.Fatal("CPE is on the configured MDRO list and was not flagged")
	}

	// The practitioner who reported the case cannot reclassify it.
	_, err := h.infection.OverrideOnset(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.OverrideOnsetRequest{
				CaseId: one.GetCaseId(),
				Onset:  infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED,
				Reason: "positive on transfer",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("override by a practitioner = %v, want permission denied",
			err)
	}

	// The lead can, and has to say why.
	_, err = h.infection.OverrideOnset(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.OverrideOnsetRequest{
				CaseId: one.GetCaseId(),
				Onset:  infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED,
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("override with no reason = %v, want invalid argument", err)
	}

	overridden, err := h.infection.OverrideOnset(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.OverrideOnsetRequest{
				CaseId: one.GetCaseId(),
				Onset:  infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED,
				Reason: "blood culture positive on transfer from another unit",
			}))
	if err != nil {
		t.Fatalf("OverrideOnset: %v", err)
	}

	after := overridden.Msg.GetSurveillanceCase()
	if after.GetOnset() != infectionv1.Onset_ONSET_HEALTHCARE_ASSOCIATED {
		t.Fatalf("the derivation was overwritten: %v", after.GetOnset())
	}
	if after.GetOnsetOverride() != infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED {
		t.Fatalf("override = %v", after.GetOnsetOverride())
	}
	if after.GetOnsetOverriddenBy() != "ipc-lead" ||
		after.GetOnsetOverrideWhy() == "" {
		t.Fatalf("override provenance lost: %+v", after)
	}
}

// SRS-IPC-002, SRS-IPC-010. A rate counts what it says it counts, reports its
// reclassifications beside it, and refuses to invent one with no denominator.
func TestARateCountsConfirmedCasesAndNamesItsReclassifications(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	from := time.Now().UTC().Add(-30 * 24 * time.Hour)
	to := time.Now().UTC().Add(24 * time.Hour)

	// A period with no device days has no rate at all.
	empty, err := h.infection.GetRate(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.GetRateRequest{
				Site:       infectionv1.InfectionSite_INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM,
				LocationId: "icu",
				PeriodFrom: timestamppb.New(from), PeriodTo: timestamppb.New(to),
			}))
	if err != nil {
		t.Fatalf("GetRate: %v", err)
	}
	if !empty.Msg.GetRate().GetUnanswerable() {
		t.Fatal("a period with no device days reported a rate")
	}

	// Ten days of census, ten line days a day: a counted denominator.
	for day := 0; day < 10; day++ {
		_, err := h.infection.RecordDeviceDays(ctx,
			withFacility(h.wardNurseToken(), h.facility,
				&infectionv1.RecordDeviceDaysRequest{
					FacilityId: h.facility, LocationId: "icu",
					Device:      infectionv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
					CountedOn:   timestamppb.New(from.AddDate(0, 0, day)),
					PatientDays: 20, DeviceDays: 10,
				}))
		if err != nil {
			t.Fatalf("RecordDeviceDays: %v", err)
		}
	}

	// More devices than patients is a counting mistake.
	_, err = h.infection.RecordDeviceDays(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.RecordDeviceDaysRequest{
				FacilityId: h.facility, LocationId: "ward-b",
				Device:      infectionv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
				CountedOn:   timestamppb.New(from),
				PatientDays: 5, DeviceDays: 6,
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("more devices than patients = %v, want invalid argument", err)
	}

	confirm := func(one *infectionv1.SurveillanceCase) {
		t.Helper()
		if _, err := h.infection.ReviewCase(ctx,
			withFacility(h.nurseIpcToken(), h.facility,
				&infectionv1.ReviewCaseRequest{
					CaseId:   one.GetCaseId(),
					State:    infectionv1.CaseState_CASE_STATE_CONFIRMED,
					Criteria: "CDC CLABSI definition",
				})); err != nil {
			t.Fatalf("ReviewCase: %v", err)
		}
	}

	onsetAt := from.AddDate(0, 0, 4)
	counted := h.openCase(t, h.nurseIpcToken(),
		func(r *infectionv1.OpenCaseRequest) {
			r.AdmittedAt = timestamppb.New(from)
			r.OnsetAt = timestamppb.New(onsetAt)
		})
	confirm(counted)

	// Still suspected: not an infection yet, and not in the numerator.
	h.openCase(t, h.nurseIpcToken(), func(r *infectionv1.OpenCaseRequest) {
		r.PatientId = "patient-2"
		r.AdmittedAt = timestamppb.New(from)
		r.OnsetAt = timestamppb.New(onsetAt.Add(time.Hour))
	})

	// Confirmed and then reclassified: out of the numerator, and counted in
	// the summary so the reclassification stays visible.
	reclassified := h.openCase(t, h.nurseIpcToken(),
		func(r *infectionv1.OpenCaseRequest) {
			r.PatientId = "patient-3"
			r.AdmittedAt = timestamppb.New(from)
			r.OnsetAt = timestamppb.New(onsetAt.Add(2 * time.Hour))
		})
	confirm(reclassified)
	if _, err := h.infection.OverrideOnset(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.OverrideOnsetRequest{
				CaseId: reclassified.GetCaseId(),
				Onset:  infectionv1.Onset_ONSET_COMMUNITY_ACQUIRED,
				Reason: "known positive before admission",
			})); err != nil {
		t.Fatalf("OverrideOnset: %v", err)
	}

	got, err := h.infection.GetRate(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.GetRateRequest{
				Site:       infectionv1.InfectionSite_INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM,
				LocationId: "icu",
				PeriodFrom: timestamppb.New(from), PeriodTo: timestamppb.New(to),
			}))
	if err != nil {
		t.Fatalf("GetRate: %v", err)
	}
	rate := got.Msg.GetRate()
	if rate.GetInfections() != 1 {
		t.Fatalf("infections = %d, want 1 confirmed and healthcare "+
			"associated", rate.GetInfections())
	}
	if rate.GetDeviceDays() != 100 || rate.GetPatientDays() != 200 {
		t.Fatalf("denominators = %d/%d, want 100/200",
			rate.GetDeviceDays(), rate.GetPatientDays())
	}
	// 1 × 1000 / 100 = 10.0 per 1000 device days.
	if rate.GetPerThousandDeviceDaysTenths() != 100 {
		t.Fatalf("rate = %d tenths, want 100",
			rate.GetPerThousandDeviceDaysTenths())
	}
	if rate.GetUtilisationPermille() != 500 {
		t.Fatalf("utilisation = %d permille", rate.GetUtilisationPermille())
	}
	if rate.GetOnsets().GetOverriddenToCommunity() != 1 {
		t.Fatalf("the summary hides the reclassification: %+v",
			rate.GetOnsets())
	}
}

// SRS-IPC-010, SRS-QMS-010. The rate is filed against one versioned
// dictionary, and a code with no definition is refused rather than invented.
func TestARateIsFiledAgainstTheVersionedIndicatorDictionary(t *testing.T) {
	h := newIpcHarnessWith(t, infectionapp.Config{
		SurveillanceWindowHours: 48,
		IndicatorForSite: map[infectiondomain.InfectionSite]string{
			infectiondomain.SiteCLABSI: "CLABSI-RATE",
		},
	}, infectiontherapy.Config{})
	ctx := context.Background()

	from := time.Now().UTC().Add(-30 * 24 * time.Hour)
	to := time.Now().UTC().Add(24 * time.Hour)

	rateRequest := func() *connect.Request[infectionv1.GetRateRequest] {
		return withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.GetRateRequest{
				Site:       infectionv1.InfectionSite_INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM,
				LocationId: "icu",
				PeriodFrom: timestamppb.New(from),
				PeriodTo:   timestamppb.New(to),
			})
	}

	// Nobody has written the definition down yet.
	_, err := h.infection.GetRate(ctx, rateRequest())
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("rate with no indicator definition = %v, "+
			"want failed precondition", err)
	}

	if _, err := h.quality.DefineIndicator(ctx,
		withFacility(h.qualityManagerToken(), h.facility,
			&qualityv1.DefineIndicatorRequest{
				Code: "CLABSI-RATE", Name: "CLABSI rate",
				Numerator:     "confirmed healthcare-associated CLABSI",
				Denominator:   "central line days",
				Unit:          "per 1000 line days",
				Direction:     qualityv1.Direction_DIRECTION_LOWER_IS_BETTER,
				Frequency:     qualityv1.Frequency_FREQUENCY_MONTHLY,
				OwnerId:       "ipc-lead",
				EffectiveFrom: timestamppb.New(from),
			})); err != nil {
		t.Fatalf("DefineIndicator: %v", err)
	}

	if _, err := h.infection.RecordDeviceDays(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.RecordDeviceDaysRequest{
				FacilityId: h.facility, LocationId: "icu",
				Device:      infectionv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
				CountedOn:   timestamppb.New(from),
				PatientDays: 20, DeviceDays: 10,
			})); err != nil {
		t.Fatalf("RecordDeviceDays: %v", err)
	}

	got, err := h.infection.GetRate(ctx, rateRequest())
	if err != nil {
		t.Fatalf("GetRate: %v", err)
	}
	rate := got.Msg.GetRate()
	if rate.GetIndicatorCode() != "CLABSI-RATE" {
		t.Fatalf("indicator code = %q", rate.GetIndicatorCode())
	}
	if rate.GetIndicatorRevision() < 1 {
		t.Fatalf("indicator revision = %d, want the dictionary's",
			rate.GetIndicatorRevision())
	}

	// The value landed in the quality dictionary rather than a second one
	// here.
	values, err := h.quality.ListIndicatorValues(ctx,
		withFacility(h.qualityManagerToken(), h.facility,
			&qualityv1.ListIndicatorValuesRequest{
				Code: "CLABSI-RATE",
				From: timestamppb.New(from.Add(-time.Hour)),
				To:   timestamppb.New(to.Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ListIndicatorValues: %v", err)
	}
	if len(values.Msg.GetValues()) != 1 {
		t.Fatalf("%d indicator values in the quality dictionary, want 1",
			len(values.Msg.GetValues()))
	}
}

// SRS-IPC-003, SRS-OPSSEC-006. The board says what to wear and never why.
func TestTheBedBoardCarriesThePrecautionAndNotTheDiagnosis(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	// A ward nurse may read the board and may not place precautions.
	_, err := h.infection.StartIsolation(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.StartIsolationRequest{
				PatientId: "patient-1", LocationId: "ward-a",
				Precaution: infectionv1.Precaution_PRECAUTION_AIRBORNE,
				Reason:     "sputum smear positive tuberculosis",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("isolation by a ward nurse = %v, want permission denied",
			err)
	}

	started, err := h.infection.StartIsolation(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.StartIsolationRequest{
				PatientId: "patient-1", FacilityId: h.facility,
				LocationId: "ward-a", BedId: "bed-3",
				Precaution: infectionv1.Precaution_PRECAUTION_AIRBORNE,
				Reason:     "sputum smear positive tuberculosis",
			}))
	if err != nil {
		t.Fatalf("StartIsolation: %v", err)
	}
	isolation := started.Msg.GetIsolation()
	if isolation.GetReason() == "" {
		t.Fatal("infection control lost the reason it needs to review")
	}

	board, err := h.infection.GetBoard(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.GetBoardRequest{LocationId: "ward-a"}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	entries := board.Msg.GetEntries()
	if len(entries) != 1 {
		t.Fatalf("%d board entries, want 1", len(entries))
	}
	entry := entries[0]
	if entry.GetPrecaution() != infectionv1.Precaution_PRECAUTION_AIRBORNE ||
		!entry.GetRequiresSideRoom() || len(entry.GetPpe()) == 0 {
		t.Fatalf("the board lost what a nurse acts on: %+v", entry)
	}
	if strings.Contains(strings.ToLower(entry.String()), "tuberculosis") {
		t.Fatalf("the board carries the diagnosis: %s", entry.String())
	}

	// Lifting precautions is a clinical decision and an explained one.
	_, err = h.infection.EndIsolation(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.EndIsolationRequest{
				IsolationId: isolation.GetIsolationId(),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("lifting with no reason = %v, want invalid argument", err)
	}
}

// SRS-IPC-004. An alert uses the current approved rule, the author cannot
// approve their own, and an override is audited.
func TestAnAlertUsesAnApprovedRuleAndAnOverrideIsAudited(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	drafted, err := h.infection.DraftAlertRule(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.DraftAlertRuleRequest{
				Code: "MDRO-CPE", Name: "Carbapenemase-producing organisms",
				Revision: 1, Organisms: []string{"CPE"}, LookbackDays: 365,
				Precaution: infectionv1.Precaution_PRECAUTION_CONTACT,
				Advice:     "side room, contact precautions",
			}))
	if err != nil {
		t.Fatalf("DraftAlertRule: %v", err)
	}
	rule := drafted.Msg.GetRule()

	// An unapproved rule fires for nobody.
	screened, err := h.infection.ScreenEncounter(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.ScreenEncounterRequest{
				PatientId: "patient-1", EncounterId: "enc-1",
				FacilityId: h.facility, Organism: "CPE Klebsiella",
				OrganismCode:   "CPE",
				LastPositiveAt: timestamppb.New(time.Now().UTC().AddDate(0, 0, -30)),
			}))
	if err != nil {
		t.Fatalf("ScreenEncounter: %v", err)
	}
	if len(screened.Msg.GetAlerts()) != 0 {
		t.Fatal("an unapproved rule fired")
	}

	// Its author cannot put it in force.
	_, err = h.infection.ApproveAlertRule(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.ApproveAlertRuleRequest{RuleId: rule.GetRuleId()}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("self-approval = %v, want invalid argument", err)
	}

	otherLead := h.tenantID + ":ipc-lead-2:infection_control_lead:" + h.facility
	if _, err := h.infection.ApproveAlertRule(ctx,
		withFacility(otherLead, h.facility,
			&infectionv1.ApproveAlertRuleRequest{
				RuleId:        rule.GetRuleId(),
				EffectiveFrom: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			})); err != nil {
		t.Fatalf("ApproveAlertRule: %v", err)
	}

	screened, err = h.infection.ScreenEncounter(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.ScreenEncounterRequest{
				PatientId: "patient-1", EncounterId: "enc-1",
				FacilityId: h.facility, Organism: "CPE Klebsiella",
				OrganismCode:   "CPE",
				LastPositiveAt: timestamppb.New(time.Now().UTC().AddDate(0, 0, -30)),
			}))
	if err != nil {
		t.Fatalf("ScreenEncounter: %v", err)
	}
	alerts := screened.Msg.GetAlerts()
	if len(alerts) != 1 {
		t.Fatalf("%d alerts, want 1", len(alerts))
	}
	if alerts[0].GetRuleCode() != "MDRO-CPE" ||
		alerts[0].GetRuleRevision() != 1 {
		t.Fatalf("the alert does not pin its rule version: %+v", alerts[0])
	}

	// A ward nurse may not dismiss it.
	_, err = h.infection.OverrideAlert(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.OverrideAlertRequest{
				AlertId: alerts[0].GetAlertId(), Reason: "seems fine",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("override by a ward nurse = %v, want permission denied", err)
	}

	overridden, err := h.infection.OverrideAlert(ctx,
		withFacility(h.doctorToken(), h.facility,
			&infectionv1.OverrideAlertRequest{
				AlertId: alerts[0].GetAlertId(),
				Reason:  "decolonised, three negative screens",
			}))
	if err != nil {
		t.Fatalf("OverrideAlert: %v", err)
	}
	if !overridden.Msg.GetAlert().GetOverridden() ||
		overridden.Msg.GetAlert().GetOverriddenBy() != "doctor-1" {
		t.Fatalf("override not recorded: %+v", overridden.Msg.GetAlert())
	}

	var audited int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.audit_record
		 WHERE tenant_id = $1 AND action = 'infection.alert.overridden'`,
		h.tenantID).Scan(&audited); err != nil {
		t.Fatalf("count audit: %v", err)
	}
	if audited != 1 {
		t.Fatalf("%d audit records for the override, want 1", audited)
	}
}

// SRS-IPC-006. Aggregate by category, suppress the small groups, name
// nobody.
func TestHandHygieneReportsAggregateAndSuppressSmallGroups(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	started, err := h.infection.StartHygieneSession(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.StartHygieneSessionRequest{
				FacilityId: h.facility, LocationId: "ward-a",
				Notes: "monthly audit",
			}))
	if err != nil {
		t.Fatalf("StartHygieneSession: %v", err)
	}
	session := started.Msg.GetSession()
	if session.GetObserverId() != "nurse-1" {
		t.Fatalf("observer = %q, want the caller", session.GetObserverId())
	}

	observe := func(discipline infectionv1.Discipline,
		action infectionv1.HygieneAction, gloves bool) {

		t.Helper()
		if _, err := h.infection.RecordObservation(ctx,
			withFacility(h.wardNurseToken(), h.facility,
				&infectionv1.RecordObservationRequest{
					SessionId: session.GetSessionId(), Discipline: discipline,
					Moment: infectionv1.Moment_MOMENT_BEFORE_PATIENT_CONTACT,
					Action: action, GlovesWorn: gloves,
				})); err != nil {
			t.Fatalf("RecordObservation: %v", err)
		}
	}

	observe(infectionv1.Discipline_DISCIPLINE_NURSE,
		infectionv1.HygieneAction_HYGIENE_ACTION_ALCOHOL_RUB, false)
	observe(infectionv1.Discipline_DISCIPLINE_NURSE,
		infectionv1.HygieneAction_HYGIENE_ACTION_SOAP_AND_WATER, false)
	observe(infectionv1.Discipline_DISCIPLINE_NURSE,
		infectionv1.HygieneAction_HYGIENE_ACTION_ALCOHOL_RUB, false)
	observe(infectionv1.Discipline_DISCIPLINE_NURSE,
		infectionv1.HygieneAction_HYGIENE_ACTION_MISSED, false)
	observe(infectionv1.Discipline_DISCIPLINE_NURSE,
		infectionv1.HygieneAction_HYGIENE_ACTION_GLOVES_ONLY, true)
	observe(infectionv1.Discipline_DISCIPLINE_DOCTOR,
		infectionv1.HygieneAction_HYGIENE_ACTION_MISSED, false)

	report, err := h.infection.GetHygieneCompliance(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.GetHygieneComplianceRequest{
				LocationId: "ward-a", GroupBy: "discipline",
				PeriodFrom: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				PeriodTo:   timestamppb.New(time.Now().UTC().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("GetHygieneCompliance: %v", err)
	}
	if report.Msg.GetSuppressionThreshold() != 5 {
		t.Fatalf("threshold = %d, want the configured 5",
			report.Msg.GetSuppressionThreshold())
	}

	byGroup := map[string]*infectionv1.Compliance{}
	for _, group := range report.Msg.GetGroups() {
		byGroup[group.GetGroup()] = group
	}
	nurses := byGroup["nurse"]
	if nurses.GetOpportunities() != 5 || nurses.GetPerformed() != 3 {
		t.Fatalf("nurses = %+v, want 3 of 5", nurses)
	}
	if nurses.GetPermille() != 600 {
		t.Fatalf("nurse compliance = %d permille, want 600",
			nurses.GetPermille())
	}
	if nurses.GetGlovesInsteadOf() != 1 {
		t.Fatalf("gloves-instead-of = %d, want it counted separately",
			nurses.GetGlovesInsteadOf())
	}

	doctors := byGroup["doctor"]
	if !doctors.GetSuppressed() {
		t.Fatal("a group of one was published")
	}
	if doctors.GetOpportunities() != 0 || doctors.GetPerformed() != 0 {
		t.Fatalf("a suppressed group still carries its counts: %+v", doctors)
	}
}

// SRS-IPC-007. A staff health record readable only by occupational health,
// with every read written to the trail.
func TestAnExposureIsRestrictedAndEveryReadIsAudited(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	occurred := time.Now().UTC().Add(-30 * time.Hour)

	// A source patient named without recorded consent is refused.
	_, err := h.infection.ReportExposure(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.ReportExposureRequest{
				Kind:            infectionv1.ExposureKind_EXPOSURE_KIND_NEEDLESTICK,
				Circumstance:    "recapping a cannula",
				SourcePatientId: "patient-1", SourceKnown: true,
				OccurredAt: timestamppb.New(occurred),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a named source with no consent = %v, want invalid argument",
			err)
	}

	reported, err := h.infection.ReportExposure(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.ReportExposureRequest{
				Reference: "EXP-1", FacilityId: h.facility,
				LocationId:   "ward-a",
				Kind:         infectionv1.ExposureKind_EXPOSURE_KIND_NEEDLESTICK,
				Device:       "18G cannula",
				Circumstance: "recapping a cannula", DeepInjury: true,
				SourcePatientId: "patient-1", SourceKnown: true,
				SourceConsented: true,
				OccurredAt:      timestamppb.New(occurred),
			}))
	if err != nil {
		t.Fatalf("ReportExposure: %v", err)
	}
	exposure := reported.Msg.GetExposure()
	if exposure.GetStaffId() != "nurse-1" {
		t.Fatalf("staff = %q, want the reporter", exposure.GetStaffId())
	}

	// The prophylaxis clock runs from the exposure, not from the report.
	var prophylaxis *infectionv1.ExposureTask
	for _, task := range reported.Msg.GetTasks() {
		if task.GetCode() == infectiondomain.TaskProphylaxis {
			prophylaxis = task
		}
	}
	if prophylaxis == nil {
		t.Fatalf("%d tasks and no prophylaxis step",
			len(reported.Msg.GetTasks()))
	}
	want := occurred.Add(72 * time.Hour)
	if got := prophylaxis.GetDueBy().AsTime(); !got.Equal(want) {
		t.Fatalf("prophylaxis due %s, want %s from the exposure", got, want)
	}

	// The nurse who reported it cannot read it back: following up is
	// occupational health's, and the record is theirs.
	_, err = h.infection.GetExposure(ctx,
		withFacility(h.wardNurseToken(), h.facility,
			&infectionv1.GetExposureRequest{
				ExposureId: exposure.GetExposureId(),
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("read by the reporter = %v, want permission denied", err)
	}
	_, err = h.infection.GetExposure(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.GetExposureRequest{
				ExposureId: exposure.GetExposureId(),
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("read by infection control = %v, want permission denied",
			err)
	}

	read, err := h.infection.GetExposure(ctx,
		withFacility(h.occHealthToken(), h.facility,
			&infectionv1.GetExposureRequest{
				ExposureId: exposure.GetExposureId(),
			}))
	if err != nil {
		t.Fatalf("GetExposure: %v", err)
	}
	if read.Msg.GetExposure().GetSourcePatientId() != "patient-1" {
		t.Fatal("occupational health cannot see what it needs")
	}

	var reads int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.audit_record
		 WHERE tenant_id = $1 AND action = 'infection.exposure.read'
		   AND resource_id = $2`,
		h.tenantID, exposure.GetExposureId()).Scan(&reads); err != nil {
		t.Fatalf("count audit: %v", err)
	}
	if reads != 1 {
		t.Fatalf("%d audited reads, want 1", reads)
	}

	// An exposure cannot close with a step still inside its window.
	_, err = h.infection.CloseExposure(ctx,
		withFacility(h.occHealthToken(), h.facility,
			&infectionv1.CloseExposureRequest{
				ExposureId: exposure.GetExposureId(),
				Outcome:    "no seroconversion",
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("closing over a live step = %v, want invalid argument", err)
	}
}

// SRS-IPC-008. The requirement this family exists for: a review appears in
// the worklist and the prescription is exactly as it was.
func TestAStewardshipReviewNeverChangesThePrescription(t *testing.T) {
	h := newIpcHarnessWith(t, infectionapp.Config{
		SurveillanceWindowHours: 48,
		StewardshipDueWithin:    24 * time.Hour,
	}, infectiontherapy.Config{
		// The prescription below is written against this ingredient code.
		AntimicrobialCodes: []string{"19711"},
		RestrictedCodes:    []string{"19711"},
	})
	ctx := context.Background()

	patient, encounter := h.chartForIpc(t)
	prescribed, err := h.medication.Prescribe(ctx,
		withFacility(h.doctorToken(), h.facility,
			&medicationv1.PrescribeRequest{
				PatientId: patient, EncounterId: encounter,
				Ingredient: &medicationv1.Coding{
					System: "rxnorm", Version: "2026.01", Code: "19711",
					Display: "Co-amoxiclav 625mg tablet",
				},
				Route: "IV", Indication: "chest infection",
				Segments: []*medicationv1.DoseSegment{{
					Sequence: 1,
					Dose:     &medicationv1.Quantity{Value: 1200, Unit: "mg"},
					Timing: &medicationv1.Timing{
						FrequencyText: "three times daily",
						TimesOfDay:    []int32{6 * 60, 14 * 60, 22 * 60},
					},
				}},
				StartsAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				Stop: &medicationv1.StopCondition{
					Kind:  medicationv1.StopConditionKind_STOP_CONDITION_KIND_AFTER_DOSES,
					Doses: 21,
				},
			}))
	if err != nil {
		t.Fatalf("Prescribe: %v", err)
	}
	prescription := prescribed.Msg.GetPrescription()

	// A restricted agent in use, so the trigger fires.
	drafted, err := h.infection.DraftStewardshipRule(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.DraftStewardshipRuleRequest{
				Code: "RESTRICTED", Revision: 1,
				Kind:      infectionv1.TriggerKind_TRIGGER_KIND_RESTRICTED_AGENT,
				AllAgents: true,
				Prompt:    "is the restricted agent still indicated?",
			}))
	if err != nil {
		t.Fatalf("DraftStewardshipRule: %v", err)
	}
	otherLead := h.tenantID + ":ipc-lead-2:infection_control_lead:" + h.facility
	if _, err := h.infection.ApproveStewardshipRule(ctx,
		withFacility(otherLead, h.facility,
			&infectionv1.ApproveStewardshipRuleRequest{
				RuleId:        drafted.Msg.GetRule().GetRuleId(),
				EffectiveFrom: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			})); err != nil {
		t.Fatalf("ApproveStewardshipRule: %v", err)
	}

	raised, err := h.infection.ReviewEncounter(ctx,
		withFacility(h.pharmacistToken(), h.facility,
			&infectionv1.ReviewEncounterRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("ReviewEncounter: %v", err)
	}
	reviews := raised.Msg.GetReviews()
	if len(reviews) != 1 {
		t.Fatalf("%d reviews raised, want 1", len(reviews))
	}
	review := reviews[0]
	if review.GetOrderId() != prescription.GetOrderId() {
		t.Fatalf("the review does not point at the order: %q",
			review.GetOrderId())
	}

	// Running it again raises nothing: the same question, already asked.
	again, err := h.infection.ReviewEncounter(ctx,
		withFacility(h.pharmacistToken(), h.facility,
			&infectionv1.ReviewEncounterRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("ReviewEncounter: %v", err)
	}
	if len(again.Msg.GetReviews()) != 0 {
		t.Fatalf("%d duplicate reviews raised",
			len(again.Msg.GetReviews()))
	}

	advised, err := h.infection.AdviseReview(ctx,
		withFacility(h.pharmacistToken(), h.facility,
			&infectionv1.AdviseReviewRequest{
				ReviewId:       review.GetReviewId(),
				Recommendation: infectionv1.Recommendation_RECOMMENDATION_SWITCH_TO_ORAL,
				Advice:         "switch to oral co-amoxiclav, patient eating",
			}))
	if err != nil {
		t.Fatalf("AdviseReview: %v", err)
	}
	if advised.Msg.GetReview().GetState() !=
		infectionv1.ReviewState_REVIEW_STATE_ADVISED {
		t.Fatalf("state = %v", advised.Msg.GetReview().GetState())
	}

	// This is the whole requirement: advice given, prescription untouched.
	after, err := h.medication.GetPrescription(ctx,
		withFacility(h.doctorToken(), h.facility,
			&medicationv1.GetPrescriptionRequest{
				PrescriptionId: prescription.GetPrescriptionId(),
			}))
	if err != nil {
		t.Fatalf("GetPrescription: %v", err)
	}
	unchanged := after.Msg.GetPrescription()
	switch {
	case unchanged.GetTherapyStatus() != prescription.GetTherapyStatus():
		t.Fatalf("the stewardship review changed the therapy status: %v -> %v",
			prescription.GetTherapyStatus(), unchanged.GetTherapyStatus())
	case unchanged.GetRoute() != "IV":
		t.Fatalf("the route changed to %q", unchanged.GetRoute())
	case unchanged.GetVersion() != prescription.GetVersion():
		t.Fatalf("the prescription was written to: version %d -> %d",
			prescription.GetVersion(), unchanged.GetVersion())
	}

	// The reviewer cannot record the prescriber's answer.
	_, err = h.infection.RespondToReview(ctx,
		withFacility(h.pharmacistToken(), h.facility,
			&infectionv1.RespondToReviewRequest{
				ReviewId: review.GetReviewId(),
				Response: infectionv1.Response_RESPONSE_ACCEPTED,
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("response by the reviewer = %v, want permission denied", err)
	}

	answered, err := h.infection.RespondToReview(ctx,
		withFacility(h.doctorToken(), h.facility,
			&infectionv1.RespondToReviewRequest{
				ReviewId: review.GetReviewId(),
				Response: infectionv1.Response_RESPONSE_MODIFIED,
				Reason:   "switched to oral amoxicillin instead",
			}))
	if err != nil {
		t.Fatalf("RespondToReview: %v", err)
	}
	if answered.Msg.GetReview().GetRespondedBy() != "doctor-1" {
		t.Fatalf("responded by %q",
			answered.Msg.GetReview().GetRespondedBy())
	}

	// Modified advice is neither accepted nor refused.
	indicators, err := h.infection.GetStewardshipIndicators(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.GetStewardshipIndicatorsRequest{
				PeriodFrom: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				PeriodTo:   timestamppb.New(time.Now().UTC().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("GetStewardshipIndicators: %v", err)
	}
	summary := indicators.Msg.GetSummary()
	if summary.GetModified() != 1 || summary.GetAccepted() != 0 {
		t.Fatalf("summary = %+v, want the modified response counted apart",
			summary)
	}
	if summary.GetAcceptancePermille() != 0 || summary.GetUnanswerable() {
		t.Fatalf("acceptance = %d permille (unanswerable %v), want nought "+
			"of one answered", summary.GetAcceptancePermille(),
			summary.GetUnanswerable())
	}
}

// chartForIpc registers a patient and opens an inpatient encounter.
func (h *ipcHarness) chartForIpc(t *testing.T) (string, string) {
	t.Helper()

	clerk := h.tenantID + ":clerk-1:registration_clerk:" + h.facility
	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(clerk, h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1971, 5, 9), empiv1.Sex_SEX_FEMALE, "9876543210"),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.doctorToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "chest infection",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

// SRS-IPC-009. A failing result closes only through an action verified by a
// repeat that passed, and the limit that judged it is pinned to the result.
func TestAFailingEnvironmentalResultClosesThroughAVerifiedAction(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	drafted, err := h.infection.DraftLimit(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.DraftLimitRequest{
				Code: "WATER", Name: "Augmented care water", Revision: 1,
				SampleKind:  infectionv1.SampleKind_SAMPLE_KIND_WATER,
				Unit:        "cfu/ml",
				ActionLevel: 100, FailLevel: 1000,
			}))
	if err != nil {
		t.Fatalf("DraftLimit: %v", err)
	}
	otherLead := h.tenantID + ":ipc-lead-2:infection_control_lead:" + h.facility
	if _, err := h.infection.ApproveLimit(ctx,
		withFacility(otherLead, h.facility,
			&infectionv1.ApproveLimitRequest{
				LimitId:       drafted.Msg.GetLimit().GetLimitId(),
				EffectiveFrom: timestamppb.New(time.Now().UTC().AddDate(0, -1, 0)),
			})); err != nil {
		t.Fatalf("ApproveLimit: %v", err)
	}

	// A sample has to name the point it came from: a ward's forty taps do
	// not fail together.
	_, err = h.infection.CollectSample(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.CollectSampleRequest{
				SampleKind: infectionv1.SampleKind_SAMPLE_KIND_WATER,
				LocationId: "icu",
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a sample with no point = %v, want invalid argument", err)
	}

	collect := func(point, repeatOf string) *infectionv1.EnvironmentalSample {
		t.Helper()
		collected, err := h.infection.CollectSample(ctx,
			withFacility(h.nurseIpcToken(), h.facility,
				&infectionv1.CollectSampleRequest{
					SampleKind: infectionv1.SampleKind_SAMPLE_KIND_WATER,
					FacilityId: h.facility, LocationId: "icu",
					SamplePoint: point, RepeatOfId: repeatOf,
					Method: "pre-flush",
				}))
		if err != nil {
			t.Fatalf("CollectSample: %v", err)
		}
		return collected.Msg.GetSample()
	}

	result := func(id string, value int64) *infectionv1.EnvironmentalSample {
		t.Helper()
		resulted, err := h.infection.RecordSampleResult(ctx,
			withFacility(h.nurseIpcToken(), h.facility,
				&infectionv1.RecordSampleResultRequest{
					SampleId: id, LabReference: "LAB-" + uuid.NewString()[:6],
					Value: value, Unit: "cfu/ml",
					Organism: "Pseudomonas aeruginosa", Detected: value > 0,
				}))
		if err != nil {
			t.Fatalf("RecordSampleResult: %v", err)
		}
		return resulted.Msg.GetSample()
	}

	sample := collect("bay 3 hand basin", "")
	failed := result(sample.GetSampleId(), 4000)
	if failed.GetOutcome() != infectionv1.Outcome_OUTCOME_FAIL {
		t.Fatalf("outcome = %v, want fail", failed.GetOutcome())
	}
	if failed.GetLimitCode() != "WATER" || failed.GetLimitRevision() != 1 {
		t.Fatalf("the limit revision was not pinned: %+v", failed)
	}

	// It cannot be closed on its own.
	_, err = h.infection.CloseSample(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.CloseSampleRequest{
				SampleId: sample.GetSampleId(),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("closing a failure with no action = %v, "+
			"want invalid argument", err)
	}

	// The practitioner cannot raise the estates action; the lead can.
	_, err = h.infection.RaiseCorrectiveAction(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.RaiseCorrectiveActionRequest{
				SampleId: sample.GetSampleId(), Action: "replace the outlet",
				Owner: "estates-1",
				DueBy: timestamppb.New(time.Now().UTC().AddDate(0, 0, 7)),
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("action by a practitioner = %v, want permission denied", err)
	}

	raised, err := h.infection.RaiseCorrectiveAction(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.RaiseCorrectiveActionRequest{
				SampleId: sample.GetSampleId(),
				Action:   "replace the outlet and flush the run",
				Owner:    "estates-1",
				DueBy:    timestamppb.New(time.Now().UTC().AddDate(0, 0, 7)),
			}))
	if err != nil {
		t.Fatalf("RaiseCorrectiveAction: %v", err)
	}
	action := raised.Msg.GetAction()

	if _, err := h.infection.CompleteCorrectiveAction(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.CompleteCorrectiveActionRequest{
				ActionId: action.GetActionId(), Note: "outlet replaced",
			})); err != nil {
		t.Fatalf("CompleteCorrectiveAction: %v", err)
	}

	// A repeat from the tap next door does not verify it.
	wrong := collect("bay 4 hand basin", "")
	result(wrong.GetSampleId(), 10)
	_, err = h.infection.VerifyCorrectiveAction(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.VerifyCorrectiveActionRequest{
				ActionId:       action.GetActionId(),
				RepeatSampleId: wrong.GetSampleId(),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("verification by the wrong repeat = %v, "+
			"want invalid argument", err)
	}

	// A repeat that failed again does not verify it either.
	stillBad := collect("bay 3 hand basin", sample.GetSampleId())
	result(stillBad.GetSampleId(), 3000)
	_, err = h.infection.VerifyCorrectiveAction(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.VerifyCorrectiveActionRequest{
				ActionId:       action.GetActionId(),
				RepeatSampleId: stillBad.GetSampleId(),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("verification by a failed repeat = %v, "+
			"want invalid argument", err)
	}

	repeat := collect("bay 3 hand basin", sample.GetSampleId())
	passed := result(repeat.GetSampleId(), 10)
	if passed.GetOutcome() != infectionv1.Outcome_OUTCOME_PASS {
		t.Fatalf("the repeat = %v, want pass", passed.GetOutcome())
	}
	if _, err := h.infection.VerifyCorrectiveAction(ctx,
		withFacility(h.leadToken(), h.facility,
			&infectionv1.VerifyCorrectiveActionRequest{
				ActionId:       action.GetActionId(),
				RepeatSampleId: repeat.GetSampleId(),
			})); err != nil {
		t.Fatalf("VerifyCorrectiveAction: %v", err)
	}

	closed, err := h.infection.CloseSample(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.CloseSampleRequest{
				SampleId: sample.GetSampleId(),
			}))
	if err != nil {
		t.Fatalf("CloseSample: %v", err)
	}
	if closed.Msg.GetSample().GetState() !=
		infectionv1.SampleState_SAMPLE_STATE_CLOSED {
		t.Fatalf("state = %v", closed.Msg.GetSample().GetState())
	}

	// A failure in augmented care does not wait for the next estates round.
	var escalated int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_escalation.notice
		 WHERE tenant_id = $1 AND subject_kind = $2`,
		h.tenantID, infectionapp.EscalationEnvironment).Scan(&escalated); err != nil {
		t.Fatalf("count notices: %v", err)
	}
	if escalated != 2 {
		t.Fatalf("%d environmental escalations, want one per failure",
			escalated)
	}
}

// SRS-IPC-005. A declared outbreak escalates and cannot close having changed
// nothing.
func TestADeclaredOutbreakEscalatesAndClosesOnlyWithWhatChanged(t *testing.T) {
	h := newIpcHarness(t)
	ctx := context.Background()

	from := time.Now().UTC().AddDate(0, 0, -7)
	opened, err := h.infection.OpenOutbreak(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.OpenOutbreakRequest{
				Reference: "OB-2026-03", Organism: "Norovirus",
				CaseDefinition: "diarrhoea and vomiting on ward A",
				Locations:      []string{"ward-a"},
				WindowFrom:     timestamppb.New(from),
				WindowTo:       timestamppb.New(from.AddDate(0, 0, 14)),
			}))
	if err != nil {
		t.Fatalf("OpenOutbreak: %v", err)
	}
	outbreak := opened.Msg.GetOutbreak()

	if _, err := h.infection.AdvanceOutbreak(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.AdvanceOutbreakRequest{
				OutbreakId: outbreak.GetOutbreakId(),
				State:      infectionv1.OutbreakState_OUTBREAK_STATE_DECLARED,
				Reason:     "six cases in four days",
			})); err != nil {
		t.Fatalf("AdvanceOutbreak: %v", err)
	}

	var escalated int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_escalation.notice
		 WHERE tenant_id = $1 AND subject_kind = $2 AND subject_id = $3`,
		h.tenantID, infectionapp.EscalationOutbreak,
		outbreak.GetOutbreakId()).Scan(&escalated); err != nil {
		t.Fatalf("count notices: %v", err)
	}
	if escalated != 1 {
		t.Fatalf("%d notices for a declared outbreak, want 1", escalated)
	}

	_, err = h.infection.CloseOutbreak(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.CloseOutbreakRequest{
				OutbreakId: outbreak.GetOutbreakId(),
				Findings:   "six cases, one ward", Reason: "resolved",
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("closing having changed nothing = %v, "+
			"want invalid argument", err)
	}

	closed, err := h.infection.CloseOutbreak(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.CloseOutbreakRequest{
				OutbreakId: outbreak.GetOutbreakId(),
				Findings:   "six cases, one ward, point source not found",
				Reason:     "no new cases for seven days",
				ControlMeasures: []string{
					"ward closed to admissions", "enhanced cleaning",
				},
			}))
	if err != nil {
		t.Fatalf("CloseOutbreak: %v", err)
	}
	if closed.Msg.GetOutbreak().GetState() !=
		infectionv1.OutbreakState_OUTBREAK_STATE_CLOSED {
		t.Fatalf("state = %v", closed.Msg.GetOutbreak().GetState())
	}

	// A case that does not meet the definition cannot be waved in as one.
	one := h.openCase(t, h.nurseIpcToken(),
		func(r *infectionv1.OpenCaseRequest) {
			r.LocationId = "ward-b"
			r.Site = infectionv1.InfectionSite_INFECTION_SITE_GASTROINTESTINAL
			r.DeviceInSitu, r.DeviceDays = false, 0
		})
	_, err = h.infection.AddOutbreakMember(ctx,
		withFacility(h.nurseIpcToken(), h.facility,
			&infectionv1.AddOutbreakMemberRequest{
				OutbreakId: outbreak.GetOutbreakId(),
				CaseId:     one.GetCaseId(),
				Reason:     infectionv1.MembershipReason_MEMBERSHIP_REASON_MEETS_DEFINITION,
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a case outside the cluster waved in = %v, "+
			"want invalid argument", err)
	}
}
