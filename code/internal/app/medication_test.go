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
	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1/clinicalv1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	medicationv1 "github.com/ppusapati/health/code/gen/go/healthcare/medication/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/medication/v1/medicationv1connect"
	nursingv1 "github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1/nursingv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
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

// Medication management (SRS-MED-001 … SRS-MED-014).
//
// Three rules this file exists to prove end to end, because each of the three
// is a control that only counts if it holds across the whole stack rather than
// inside one layer.
//
// SRS-MED-002's: a recorded penicillin allergy stops a co-amoxiclav
// prescription. The match runs through the terminology map, because the chart
// and the prescription name the drug at different levels and matching on the
// prescribed code alone misses it. That miss is the one that kills people.
//
// SRS-MED-006's: a pharmacist's verification is a second pair of eyes, so the
// prescriber cannot supply it — and an unverified prescription produces no
// doses at all rather than doses a nurse discovers they may not give.
//
// SRS-MED-013's: a drug stopped on the ward round at 09:00 and typed at 11:00
// stopped at 09:00. The doses before that moment stay on the record exactly as
// they were and the ones after it disappear from the schedule.

type medHarness struct {
	pool       *pgxpool.Pool
	medication medicationv1connect.MedicationServiceClient
	nursing    nursingv1connect.NursingServiceClient
	clinical   clinicalv1connect.ClinicalServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	tenantID   string
	facility   string
}

func newMedHarness(t *testing.T) *medHarness {
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
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &medHarness{
		pool:       pool,
		medication: medicationv1connect.NewMedicationServiceClient(server.Client(), server.URL),
		nursing:    nursingv1connect.NewNursingServiceClient(server.Client(), server.URL),
		clinical:   clinicalv1connect.NewClinicalServiceClient(server.Client(), server.URL),
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

	for _, module := range []string{"empi", "encounter", "clinical", "orders", "medication"} {
		h.entitle(t, module)
	}
	return h
}

func (h *medHarness) entitle(t *testing.T, module string) {
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

func (h *medHarness) prescriberToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *medHarness) otherPrescriberToken() string {
	return h.tenantID + ":doctor-2:clinician:" + h.facility
}

func (h *medHarness) pharmacistToken() string {
	return h.tenantID + ":pharm-1:pharmacist:" + h.facility
}

func (h *medHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *medHarness) adminToken() string {
	return h.tenantID + ":admin-1:tenant_admin"
}

func (h *medHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// chart registers a patient and opens an encounter.
func (h *medHarness) chart(t *testing.T, family, phone string) (string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1971, 5, 9), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
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

func medCode(system, code, display string) *medicationv1.Coding {
	return &medicationv1.Coding{
		System: system, Version: "2026.01", Code: code, Display: display,
	}
}

func coAmoxiclav() *medicationv1.Coding {
	return medCode("rxnorm", "19711", "Co-amoxiclav 625mg tablet")
}

func penicillins() *medicationv1.Coding {
	return medCode("atc", "J01C", "Penicillins")
}

func amoxicillinIngredient() *medicationv1.Coding {
	return medCode("rxnorm", "723", "Amoxicillin")
}

// mapCoAmoxiclav publishes the terminology mapping SRS-MED-002's screen runs
// against: the prescription says co-amoxiclav and the chart says penicillin.
func (h *medHarness) mapCoAmoxiclav(t *testing.T) {
	t.Helper()
	_, err := h.medication.SetTerminologyMapping(context.Background(),
		as(h.adminToken(), &medicationv1.SetTerminologyMappingRequest{
			Mapping: &medicationv1.TerminologyMapping{
				Medication:        coAmoxiclav(),
				Ingredients:       []*medicationv1.Coding{amoxicillinIngredient()},
				Classes:           []*medicationv1.Coding{penicillins()},
				TherapeuticMoiety: medCode("atc", "J01CR02", "Co-amoxiclav"),
				MapVersion:        "2026.03",
			},
		}))
	if err != nil {
		t.Fatalf("SetTerminologyMapping: %v", err)
	}
}

// recordPenicillinAllergy puts a confirmed high-criticality allergy on the
// chart.
func (h *medHarness) recordPenicillinAllergy(t *testing.T, patient, encounter string) {
	t.Helper()
	_, err := h.clinical.RecordAllergy(context.Background(),
		withFacility(h.prescriberToken(), h.facility, &clinicalv1.RecordAllergyRequest{
			PatientId: patient, EncounterId: encounter,
			Substance: &clinicalv1.Coding{
				System: "atc", Version: "2026.01", Code: "J01C", Display: "Penicillins",
			},
			Kind:         clinicalv1.AllergyKind_ALLERGY_KIND_ALLERGY,
			Criticality:  clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_HIGH,
			Verification: clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_CONFIRMED,
		}))
	if err != nil {
		t.Fatalf("RecordAllergy: %v", err)
	}
}

// threeTimesDaily is the common prescription: co-amoxiclav, 500 mg, on the ward
// round.
func threeTimesDaily(startsAt time.Time) *medicationv1.PrescribeRequest {
	return &medicationv1.PrescribeRequest{
		Ingredient: coAmoxiclav(),
		Route:      "oral",
		Indication: "chest infection",
		Segments: []*medicationv1.DoseSegment{{
			Sequence: 1,
			Dose:     &medicationv1.Quantity{Value: 500, Unit: "mg"},
			Timing: &medicationv1.Timing{
				FrequencyText: "three times daily",
				TimesOfDay:    []int32{6 * 60, 14 * 60, 22 * 60},
			},
		}},
		StartsAt: timestamppb.New(startsAt),
		Stop: &medicationv1.StopCondition{
			Kind:  medicationv1.StopConditionKind_STOP_CONDITION_KIND_AFTER_DOSES,
			Doses: 15,
		},
	}
}

func (h *medHarness) prescribe(t *testing.T, token, patient, encounter string,
	req *medicationv1.PrescribeRequest) *medicationv1.Prescription {

	t.Helper()
	req.PatientId, req.EncounterId = patient, encounter
	prescribed, err := h.medication.Prescribe(context.Background(),
		withFacility(token, h.facility, req))
	if err != nil {
		t.Fatalf("Prescribe: %v", err)
	}
	return prescribed.Msg.GetPrescription()
}

// SRS-MED-001: the prescription is structured and reads as a sentence, and it
// carries the CPOE order it was placed as.
func TestAPrescriptionIsStructuredAndCarriesTheOrderItWasPlacedAs(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	if p.GetOrderId() == "" || p.GetOrderNumber() == "" {
		t.Fatal("the prescription did not raise a medication order")
	}
	if p.GetTherapyStatus() != medicationv1.TherapyStatus_THERAPY_STATUS_ACTIVE {
		t.Fatalf("therapy status = %v", p.GetTherapyStatus())
	}
	if len(p.GetSegments()) != 1 || p.GetSegments()[0].GetDose().GetValue() != 500 {
		t.Fatalf("segments = %+v", p.GetSegments())
	}
	for _, want := range []string{"Co-amoxiclav", "500 mg", "oral", "chest infection"} {
		if !strings.Contains(p.GetDescription(), want) {
			t.Errorf("description %q is missing %q", p.GetDescription(), want)
		}
	}
	if p.GetPrescriberId() != "doctor-1" {
		t.Fatalf("prescriber = %q", p.GetPrescriberId())
	}
}

// SRS-MED-002: the allergy screen runs through the terminology map, which is
// the only way a penicillin allergy catches a co-amoxiclav prescription.
func TestAPenicillinAllergyStopsACoAmoxiclavPrescription(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.mapCoAmoxiclav(t)
	h.recordPenicillinAllergy(t, patient, encounter)

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	_, err := h.medication.Prescribe(context.Background(),
		withFacility(h.prescriberToken(), h.facility, req))
	if err == nil {
		t.Fatal("a co-amoxiclav prescription went through over a penicillin allergy")
	}
	if !strings.Contains(err.Error(), "Penicillins") {
		t.Fatalf("the refusal does not name the allergen: %v", err)
	}
}

// SRS-MED-002: the warning names the rule and the version of the map that
// produced it.
func TestTheAllergyWarningNamesTheRuleAndTheMapVersion(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.mapCoAmoxiclav(t)
	h.recordPenicillinAllergy(t, patient, encounter)

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	_, err := h.medication.Prescribe(context.Background(),
		withFacility(h.prescriberToken(), h.facility, req))
	if err == nil {
		t.Fatal("the prescription was not refused")
	}
	detail := errorDetail(t, err)
	if detail == nil {
		t.Fatal("the refusal carries no error detail")
	}
	// The findings travel as field violations rather than concatenated into the
	// message, so a client shows each warning against the thing it is about.
	var named bool
	for _, v := range detail.GetFieldViolations() {
		if strings.Contains(v.GetReason(), "2026.03") {
			named = true
		}
	}
	if !named {
		t.Fatalf("no violation names the map version the warning fired from: %v",
			detail.GetFieldViolations())
	}
}

// Without the mapping, the same prescription is not caught — which is the
// narrower answer rather than a wrong one, and is why the map is the control.
func TestWithoutTheTerminologyMapTheClassLevelAllergyIsNotMatched(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.recordPenicillinAllergy(t, patient, encounter)

	// No SetTerminologyMapping. The prescription names co-amoxiclav and the
	// chart names the class, and nothing connects them.
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))
	if p.GetPrescriptionId() == "" {
		t.Fatal("the prescription was not written")
	}
}

// SRS-MED-002 and SRS-MED-003: a contraindication cannot be overridden.
func TestAContraindicatedAllergyCannotBeOverridden(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.mapCoAmoxiclav(t)
	h.recordPenicillinAllergy(t, patient, encounter)

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	req.Overrides = []*medicationv1.OverrideAnswer{{
		RuleId:  "allergy.ingredient-and-class-match",
		Subject: penicillins(),
		Reason:  "no alternative available",
	}}

	_, err := h.medication.Prescribe(context.Background(),
		withFacility(h.prescriberToken(), h.facility, req))
	if err == nil {
		t.Fatal("a documented high-criticality penicillin allergy was overridden")
	}
}

// SRS-MED-003: an interaction warns, names the other medication, and may be
// overridden with a reason that stays on the record.
func TestAnInteractionWarnsAndCanBeOverriddenWithAReasonOnTheRecord(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.mapCoAmoxiclav(t)

	warfarin := medCode("rxnorm", "11289", "Warfarin 3mg tablet")
	warfarinClass := medCode("atc", "B01AA03", "Warfarin")
	if _, err := h.medication.SetTerminologyMapping(context.Background(),
		as(h.adminToken(), &medicationv1.SetTerminologyMappingRequest{
			Mapping: &medicationv1.TerminologyMapping{
				Medication: warfarin,
				Classes:    []*medicationv1.Coding{warfarinClass},
				MapVersion: "2026.03",
			},
		})); err != nil {
		t.Fatalf("SetTerminologyMapping: %v", err)
	}

	if _, err := h.medication.SetInteractionRule(context.Background(),
		as(h.adminToken(), &medicationv1.SetInteractionRuleRequest{
			Rule: &medicationv1.InteractionRule{
				RuleId: "ddi.warfarin-penicillin", Version: "2026.02",
				Left: warfarinClass, Right: penicillins(),
				Severity: medicationv1.Severity_SEVERITY_SEVERE,
				Advice:   "monitor INR closely",
				Active:   true,
			},
		})); err != nil {
		t.Fatalf("SetInteractionRule: %v", err)
	}

	// The patient is already on warfarin.
	onWarfarin := &medicationv1.PrescribeRequest{
		Ingredient: warfarin, Route: "oral", Indication: "atrial fibrillation",
		Segments: []*medicationv1.DoseSegment{{
			Sequence: 1,
			Dose:     &medicationv1.Quantity{Value: 3, Unit: "mg"},
			Timing:   &medicationv1.Timing{TimesOfDay: []int32{18 * 60}},
		}},
		StartsAt: timestamppb.New(time.Now().UTC().Add(-24 * time.Hour)),
		Stop:     &medicationv1.StopCondition{Kind: medicationv1.StopConditionKind_STOP_CONDITION_KIND_NONE},
	}
	h.prescribe(t, h.prescriberToken(), patient, encounter, onWarfarin)

	// The antibiotic now interacts.
	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	_, err := h.medication.Prescribe(context.Background(),
		withFacility(h.prescriberToken(), h.facility, req))
	if err == nil {
		t.Fatal("the interaction did not stop the prescription")
	}
	if !strings.Contains(err.Error(), "Warfarin") {
		t.Fatalf("the warning does not name the interacting drug: %v", err)
	}
	if !strings.Contains(err.Error(), "monitor INR") {
		t.Fatalf("the warning does not say what to do: %v", err)
	}

	// Answered, it proceeds, and the answer stays on the record.
	req.Overrides = []*medicationv1.OverrideAnswer{{
		RuleId: "ddi.warfarin-penicillin", Subject: warfarin,
		Reason: "INR daily while on the antibiotic",
	}}
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, req)

	var overridden bool
	for _, f := range p.GetFindings() {
		if f.GetRuleId() != "ddi.warfarin-penicillin" {
			continue
		}
		if f.GetRuleVersion() != "2026.02" {
			t.Fatalf("the finding names version %q", f.GetRuleVersion())
		}
		if f.GetOverride().GetReason() == "" || f.GetOverride().GetBy() != "doctor-1" {
			t.Fatalf("the override is not on the record: %+v", f.GetOverride())
		}
		overridden = true
	}
	if !overridden {
		t.Fatal("the interaction finding is not stored with the prescription")
	}
}

// SRS-MED-006: verification is a second pair of eyes.
func TestAPrescriberCannotVerifyTheirOwnPrescription(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	// The prescriber does not hold the permission at all.
	if _, err := h.medication.VerifyPrescription(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.VerifyPrescriptionRequest{
				PrescriptionId: p.GetPrescriptionId(),
			})); err == nil {
		t.Fatal("a prescriber verified their own prescription")
	}

	verified, err := h.medication.VerifyPrescription(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerifyPrescriptionRequest{
				PrescriptionId: p.GetPrescriptionId(), Note: "checked against the chart",
			}))
	if err != nil {
		t.Fatalf("VerifyPrescription: %v", err)
	}
	if verified.Msg.GetPrescription().GetVerification().GetBy() != "pharm-1" {
		t.Fatalf("verified by %q", verified.Msg.GetPrescription().GetVerification().GetBy())
	}
}

// SRS-MED-006: the pharmacy worklist is what has not been checked.
func TestTheVerificationQueueShowsWhatNobodyHasChecked(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	queued, err := h.medication.VerificationQueue(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerificationQueueRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("VerificationQueue: %v", err)
	}
	if len(queued.Msg.GetPrescriptions()) != 1 {
		t.Fatalf("%d prescriptions queued, want 1", len(queued.Msg.GetPrescriptions()))
	}

	if _, err := h.medication.VerifyPrescription(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerifyPrescriptionRequest{
				PrescriptionId: p.GetPrescriptionId(),
			})); err != nil {
		t.Fatalf("VerifyPrescription: %v", err)
	}

	after, err := h.medication.VerificationQueue(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerificationQueueRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("VerificationQueue: %v", err)
	}
	if len(after.Msg.GetPrescriptions()) != 0 {
		t.Fatalf("a verified prescription is still on the worklist")
	}
}

// SRS-MED-007: an unverified prescription produces no doses at all.
func TestAnUnverifiedPrescriptionProducesNoDoses(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	start := time.Now().UTC().Add(-time.Hour)
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, threeTimesDaily(start))

	window := &medicationv1.DueDosesRequest{
		EncounterId: encounter,
		From:        timestamppb.New(start),
		To:          timestamppb.New(start.Add(48 * time.Hour)),
	}
	before, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, window))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}
	if len(before.Msg.GetDoses()) != 0 {
		t.Fatalf("an unverified prescription produced %d doses",
			len(before.Msg.GetDoses()))
	}

	if _, err := h.medication.VerifyPrescription(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerifyPrescriptionRequest{
				PrescriptionId: p.GetPrescriptionId(),
			})); err != nil {
		t.Fatalf("VerifyPrescription: %v", err)
	}

	after, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, window))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}
	if len(after.Msg.GetDoses()) == 0 {
		t.Fatal("a verified prescription produced no doses")
	}
}

// SRS-MED-001: the schedule is pinned to the ward's clock rather than UTC.
func TestTheScheduleLandsOnTheWardsClock(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	start := time.Now().UTC().Add(-time.Hour)
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, threeTimesDaily(start))
	h.verify(t, p.GetPrescriptionId())

	doses, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, &medicationv1.DueDosesRequest{
			EncounterId: encounter,
			From:        timestamppb.New(start),
			To:          timestamppb.New(start.Add(48 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}
	if len(doses.Msg.GetDoses()) == 0 {
		t.Fatal("no doses scheduled")
	}

	ward, err := time.LoadLocation("Asia/Kolkata")
	if err != nil {
		t.Fatalf("LoadLocation: %v", err)
	}
	for _, dose := range doses.Msg.GetDoses() {
		local := dose.GetScheduledAt().AsTime().In(ward)
		minutes := int32(local.Hour()*60 + local.Minute())
		if minutes != 6*60 && minutes != 14*60 && minutes != 22*60 {
			t.Fatalf("a dose landed at %s on the ward, want 06:00, 14:00 or 22:00",
				local.Format("15:04"))
		}
	}
}

func (h *medHarness) verify(t *testing.T, prescriptionID string) {
	t.Helper()
	if _, err := h.medication.VerifyPrescription(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.VerifyPrescriptionRequest{
				PrescriptionId: prescriptionID,
			})); err != nil {
		t.Fatalf("VerifyPrescription: %v", err)
	}
}

// SRS-MED-013 and SRS-MED-007: a hold takes effect when the clinician said, and
// doses before that moment are untouched.
func TestAHoldStopsFutureDosesFromWhenTheClinicianSaid(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	start := time.Now().UTC().Add(-36 * time.Hour)
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, threeTimesDaily(start))
	h.verify(t, p.GetPrescriptionId())

	window := &medicationv1.DueDosesRequest{
		EncounterId: encounter,
		From:        timestamppb.New(start),
		To:          timestamppb.New(start.Add(72 * time.Hour)),
	}
	before, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, window))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}
	if len(before.Msg.GetDoses()) < 3 {
		t.Fatalf("expected several doses before the hold, got %d",
			len(before.Msg.GetDoses()))
	}

	effective := time.Now().UTC().Add(-12 * time.Hour)
	held, err := h.medication.HoldTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.HoldTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(),
					Reason:         "nil by mouth before endoscopy",
					EffectiveAt:    timestamppb.New(effective),
				},
			}))
	if err != nil {
		t.Fatalf("HoldTherapy: %v", err)
	}
	if held.Msg.GetPrescription().GetTherapyStatus() !=
		medicationv1.TherapyStatus_THERAPY_STATUS_HELD {
		t.Fatalf("status = %v", held.Msg.GetPrescription().GetTherapyStatus())
	}

	after, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, window))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}
	for _, dose := range after.Msg.GetDoses() {
		if !dose.GetScheduledAt().AsTime().Before(effective) {
			t.Fatalf("a dose at %s survived a hold effective %s",
				dose.GetScheduledAt().AsTime(), effective)
		}
	}
	if len(after.Msg.GetDoses()) == 0 {
		t.Fatal("the hold removed doses that were already due before it")
	}
}

// SRS-MED-013: a held drug restarts, and the ledger carries all three moments.
func TestAHeldMedicationRestartsAndTheLedgerCarriesEveryChange(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(-36*time.Hour)))

	change := func(hours int, reason string) *medicationv1.ChangeTherapyRequest {
		return &medicationv1.ChangeTherapyRequest{
			PrescriptionId: p.GetPrescriptionId(), Reason: reason,
			EffectiveAt: timestamppb.New(time.Now().UTC().Add(time.Duration(hours) * time.Hour)),
		}
	}

	if _, err := h.medication.HoldTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.HoldTherapyRequest{Change: change(-12, "for endoscopy")})); err != nil {
		t.Fatalf("HoldTherapy: %v", err)
	}
	restarted, err := h.medication.RestartTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.RestartTherapyRequest{Change: change(-6, "back from theatre")}))
	if err != nil {
		t.Fatalf("RestartTherapy: %v", err)
	}

	if restarted.Msg.GetPrescription().GetTherapyStatus() !=
		medicationv1.TherapyStatus_THERAPY_STATUS_ACTIVE {
		t.Fatalf("status = %v", restarted.Msg.GetPrescription().GetTherapyStatus())
	}
	if got := len(restarted.Msg.GetPrescription().GetChanges()); got != 3 {
		t.Fatalf("ledger has %d entries, want prescribe, hold and restart", got)
	}
}

// SRS-MED-013: a discontinued medication does not come back.
func TestADiscontinuedMedicationCannotBeRestartedOverTheWire(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(-time.Hour)))

	if _, err := h.medication.DiscontinueTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DiscontinueTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(), Reason: "rash",
				},
			})); err != nil {
		t.Fatalf("DiscontinueTherapy: %v", err)
	}

	if _, err := h.medication.RestartTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.RestartTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(), Reason: "changed my mind",
				},
			})); err == nil {
		t.Fatal("a discontinued medication was restarted")
	}
}

// SRS-MED-013: stopping needs a reason.
func TestStoppingAMedicationNeedsAReason(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(-time.Hour)))

	if _, err := h.medication.DiscontinueTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DiscontinueTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(),
				},
			})); err == nil {
		t.Fatal("a medication was stopped with no recorded reason")
	}
}

// SRS-MED-005: a reconciliation is not complete while anything is undecided,
// and the refusal names what.
func TestAReconciliationIsNotCompleteWhileAMedicationIsUndecided(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	started, err := h.medication.StartReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.StartReconciliationRequest{
				PatientId: patient, EncounterId: encounter,
				Event: medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_ADMISSION,
				HomeMedications: []*medicationv1.ReconciliationItem{
					{
						Medication: medCode("rxnorm", "11289", "Warfarin"),
						DoseText:   "3 mg daily", Route: "oral",
						Source: medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_GP_RECORD,
					},
					{
						Medication: medCode("rxnorm", "6809", "Metformin"),
						DoseText:   "500 mg twice daily", Route: "oral",
						Source: medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_PATIENT,
					},
				},
			}))
	if err != nil {
		t.Fatalf("StartReconciliation: %v", err)
	}
	id := started.Msg.GetReconciliation().GetReconciliationId()

	if _, err := h.medication.DecideReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DecideReconciliationRequest{
				ReconciliationId: id, Sequence: 1,
				Disposition: medicationv1.Disposition_DISPOSITION_CONTINUE,
			})); err != nil {
		t.Fatalf("DecideReconciliation: %v", err)
	}

	_, err = h.medication.CompleteReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.CompleteReconciliationRequest{ReconciliationId: id}))
	if err == nil {
		t.Fatal("a reconciliation with an undecided medication was completed")
	}
	if !strings.Contains(err.Error(), "Metformin") {
		t.Fatalf("the refusal does not name the outstanding medication: %v", err)
	}

	// "Unknown" is a decision somebody made, and it completes.
	if _, err := h.medication.DecideReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DecideReconciliationRequest{
				ReconciliationId: id, Sequence: 2,
				Disposition: medicationv1.Disposition_DISPOSITION_UNKNOWN,
				Rationale:   "patient cannot remember the dose",
			})); err != nil {
		t.Fatalf("DecideReconciliation unknown: %v", err)
	}

	completed, err := h.medication.CompleteReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.CompleteReconciliationRequest{ReconciliationId: id}))
	if err != nil {
		t.Fatalf("CompleteReconciliation: %v", err)
	}
	if completed.Msg.GetReconciliation().GetCompletedBy() != "doctor-1" {
		t.Fatalf("completed by %q",
			completed.Msg.GetReconciliation().GetCompletedBy())
	}
}

// SRS-MED-005: stopping a home medication needs a rationale, because "why was
// my tablet stopped" is asked at every discharge.
func TestStoppingAHomeMedicationNeedsARationale(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	started, err := h.medication.StartReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.StartReconciliationRequest{
				PatientId: patient, EncounterId: encounter,
				Event: medicationv1.ReconciliationEvent_RECONCILIATION_EVENT_DISCHARGE,
				HomeMedications: []*medicationv1.ReconciliationItem{{
					Medication: medCode("rxnorm", "36567", "Simvastatin"),
					DoseText:   "40 mg at night", Route: "oral",
					Source: medicationv1.HomeMedicationSource_HOME_MEDICATION_SOURCE_MEDICATION_BAG,
				}},
			}))
	if err != nil {
		t.Fatalf("StartReconciliation: %v", err)
	}

	if _, err := h.medication.DecideReconciliation(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DecideReconciliationRequest{
				ReconciliationId: started.Msg.GetReconciliation().GetReconciliationId(),
				Sequence:         1,
				Disposition:      medicationv1.Disposition_DISPOSITION_STOP,
			})); err == nil {
		t.Fatal("a home medication was stopped with no rationale")
	}
}

// SRS-MED-011: the dispensed product is recorded beside the prescribed one, and
// a therapeutic swap needs somebody other than the pharmacist proposing it.
func TestATherapeuticSubstitutionNeedsASecondPersonAndLeavesThePrescriptionAlone(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	alternative := medCode("rxnorm", "21212", "Clarithromycin 500mg tablet")
	proposed, err := h.medication.ProposeSubstitution(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.ProposeSubstitutionRequest{
				PrescriptionId: p.GetPrescriptionId(), Dispensed: alternative,
				Kind:   medicationv1.SubstitutionKind_SUBSTITUTION_KIND_THERAPEUTIC,
				Reason: "co-amoxiclav unavailable",
			}))
	if err != nil {
		t.Fatalf("ProposeSubstitution: %v", err)
	}
	sub := proposed.Msg.GetSubstitution()
	if sub.GetPrescribed().GetCode() != "19711" {
		t.Fatalf("the substitution does not carry what was prescribed: %v",
			sub.GetPrescribed())
	}

	// The pharmacist cannot authorise their own therapeutic swap.
	if _, err := h.medication.AuthorizeSubstitution(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.AuthorizeSubstitutionRequest{
				Advance: &medicationv1.AdvanceSubstitutionRequest{
					SubstitutionId: sub.GetSubstitutionId(),
				},
			})); err == nil {
		t.Fatal("a pharmacist authorised their own therapeutic substitution")
	}

	// Nothing is dispensed on an unauthorised substitution.
	if _, err := h.medication.DispenseSubstitution(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.DispenseSubstitutionRequest{
				Advance: &medicationv1.AdvanceSubstitutionRequest{
					SubstitutionId: sub.GetSubstitutionId(),
				},
			})); err == nil {
		t.Fatal("an unauthorised substitution was dispensed")
	}

	// And the prescription still says what the prescriber wrote.
	read, err := h.medication.GetPrescription(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.GetPrescriptionRequest{
				PrescriptionId: p.GetPrescriptionId(),
			}))
	if err != nil {
		t.Fatalf("GetPrescription: %v", err)
	}
	if read.Msg.GetPrescription().GetIngredient().GetCode() != "19711" {
		t.Fatal("the substitution overwrote what was prescribed")
	}
}

// SRS-MED-012: a non-formulary medication shows its approval path rather than
// being refused.
func TestANonFormularyMedicationIsPrescribedWithItsApprovalPathAttached(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	if _, err := h.medication.SetFormularyEntry(context.Background(),
		as(h.adminToken(), &medicationv1.SetFormularyEntryRequest{
			Entry: &medicationv1.FormularyEntry{
				Medication: coAmoxiclav(), Scope: "tenant",
				Status:       medicationv1.FormularyStatus_FORMULARY_STATUS_NON_FORMULARY,
				ApprovalPath: "drugs and therapeutics committee, Wednesdays",
			},
		})); err != nil {
		t.Fatalf("SetFormularyEntry: %v", err)
	}

	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	if p.GetFormulary().GetStatus() !=
		medicationv1.FormularyStatus_FORMULARY_STATUS_NON_FORMULARY {
		t.Fatalf("formulary status = %v", p.GetFormulary().GetStatus())
	}
	if p.GetFormulary().GetApprovalPath() == "" {
		t.Fatal("a non-formulary prescription carries no approval path")
	}
}

// SRS-MED-010: a free-text dose is refused for a class the tenant has
// configured as needing structure.
func TestAFreeTextDoseIsRefusedForAClassThatMustBeStructured(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.mapCoAmoxiclav(t)

	if _, err := h.medication.SetMedicationPolicy(context.Background(),
		as(h.adminToken(), &medicationv1.SetMedicationPolicyRequest{
			Policy: &medicationv1.MedicationPolicy{
				MaxOverridable:       medicationv1.Severity_SEVERITY_SEVERE,
				VerificationRequired: true,
				// Keyed the way the domain keys a coding: system and code,
				// lowercased.
				StructuredDoseClasses: []string{"atc|j01c"},
			},
		})); err != nil {
		t.Fatalf("SetMedicationPolicy: %v", err)
	}

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.Segments[0].Dose = nil
	req.Segments[0].FreeTextDose = "one or two as required"
	req.PatientId, req.EncounterId = patient, encounter

	_, err := h.medication.Prescribe(context.Background(),
		withFacility(h.prescriberToken(), h.facility, req))
	if err == nil {
		t.Fatal("a free-text dose was accepted for a class that must be structured")
	}
	if !strings.Contains(err.Error(), "structured") {
		t.Fatalf("the refusal does not say why: %v", err)
	}

	// With a structured dose, the same prescription goes through.
	req.Segments[0].Dose = &medicationv1.Quantity{Value: 500, Unit: "mg"}
	req.Segments[0].FreeTextDose = ""
	h.prescribe(t, h.prescriberToken(), patient, encounter, req)
}

// SRS-MED-009: a taper is prescribed as explicit segments, and each one comes
// back with its own dose.
func TestATaperIsPrescribedAsExplicitSegments(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	start := time.Now().UTC().Truncate(time.Hour)

	prednisolone := medCode("rxnorm", "8640", "Prednisolone 5mg tablet")
	req := &medicationv1.PrescribeRequest{
		Ingredient: prednisolone, Route: "oral",
		Indication: "polymyalgia rheumatica",
		Segments: []*medicationv1.DoseSegment{
			{
				Sequence: 1, Dose: &medicationv1.Quantity{Value: 30, Unit: "mg"},
				Timing:   &medicationv1.Timing{TimesOfDay: []int32{8 * 60}},
				StartsAt: timestamppb.New(start),
				EndsAt:   timestamppb.New(start.Add(72 * time.Hour)),
			},
			{
				Sequence: 2, Dose: &medicationv1.Quantity{Value: 20, Unit: "mg"},
				Timing:   &medicationv1.Timing{TimesOfDay: []int32{8 * 60}},
				StartsAt: timestamppb.New(start.Add(72 * time.Hour)),
				EndsAt:   timestamppb.New(start.Add(144 * time.Hour)),
			},
			{
				Sequence: 3, Dose: &medicationv1.Quantity{Value: 10, Unit: "mg"},
				Timing:   &medicationv1.Timing{TimesOfDay: []int32{8 * 60}},
				StartsAt: timestamppb.New(start.Add(144 * time.Hour)),
				EndsAt:   timestamppb.New(start.Add(216 * time.Hour)),
			},
		},
		StartsAt: timestamppb.New(start),
		Stop:     &medicationv1.StopCondition{Kind: medicationv1.StopConditionKind_STOP_CONDITION_KIND_NONE},
	}

	p := h.prescribe(t, h.prescriberToken(), patient, encounter, req)
	if len(p.GetSegments()) != 3 {
		t.Fatalf("%d segments came back, want 3", len(p.GetSegments()))
	}
	h.verify(t, p.GetPrescriptionId())

	doses, err := h.medication.DueDoses(context.Background(),
		withFacility(h.nurseToken(), h.facility, &medicationv1.DueDosesRequest{
			EncounterId: encounter,
			From:        timestamppb.New(start.Add(-time.Hour)),
			To:          timestamppb.New(start.Add(216 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("DueDoses: %v", err)
	}

	seen := map[float64]bool{}
	for _, dose := range doses.Msg.GetDoses() {
		seen[dose.GetSegment().GetDose().GetValue()] = true
	}
	for _, want := range []float64{30, 20, 10} {
		if !seen[want] {
			t.Errorf("no %g mg dose in the taper; saw %v", want, seen)
		}
	}
}

// SRS-MED-014: the events carry identifiers and no clinical reasoning.
func TestTheMedicationEventsCarryNoClinicalReasoning(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.Indication = "suspected endocarditis"
	req.Instructions = "hold if systolic below 100"
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, req)

	if _, err := h.medication.DiscontinueTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DiscontinueTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(),
					Reason:         "blood cultures negative",
				},
			})); err != nil {
		t.Fatalf("DiscontinueTherapy: %v", err)
	}

	rows, err := h.pool.Query(context.Background(),
		`SELECT event_type, payload::text FROM platform_data.outbox_event
		 WHERE tenant_id = $1 AND event_type LIKE 'medication.%'
		 ORDER BY occurred_at, event_id`, h.tenantID)
	if err != nil {
		t.Fatalf("query outbox: %v", err)
	}
	defer rows.Close()

	var types []string
	for rows.Next() {
		var eventType, payload string
		if err := rows.Scan(&eventType, &payload); err != nil {
			t.Fatalf("scan: %v", err)
		}
		types = append(types, eventType)
		for _, leak := range []string{
			"suspected endocarditis", "hold if systolic", "blood cultures negative",
		} {
			if strings.Contains(payload, leak) {
				t.Fatalf("%s leaks clinical reasoning: %q", eventType, leak)
			}
		}
		if !strings.Contains(payload, p.GetPrescriptionId()) {
			t.Fatalf("%s does not identify the prescription: %s", eventType, payload)
		}
	}
	if err := rows.Err(); err != nil {
		t.Fatalf("rows: %v", err)
	}

	want := map[string]bool{"medication.prescribed": true, "medication.discontinued": true}
	for _, eventType := range types {
		delete(want, eventType)
	}
	if len(want) != 0 {
		t.Fatalf("events missing: %v (saw %v)", want, types)
	}
}

// A nurse reads the drug chart and does not prescribe.
func TestANurseReadsTheDrugChartAndDoesNotPrescribe(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	if _, err := h.medication.ListPrescriptions(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&medicationv1.ListPrescriptionsRequest{
				EncounterId: encounter,
			})); err != nil {
		t.Fatalf("a nurse could not read the drug chart: %v", err)
	}

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	if _, err := h.medication.Prescribe(context.Background(),
		withFacility(h.nurseToken(), h.facility, req)); err == nil {
		t.Fatal("a nurse prescribed a medication")
	}
}

// A pharmacist verifies and cannot prescribe or change what was prescribed.
func TestAPharmacistVerifiesAndCannotChangeThePrescription(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	req := threeTimesDaily(time.Now().UTC().Add(time.Hour))
	req.PatientId, req.EncounterId = patient, encounter
	if _, err := h.medication.Prescribe(context.Background(),
		withFacility(h.pharmacistToken(), h.facility, req)); err == nil {
		t.Fatal("a pharmacist wrote a prescription")
	}

	if _, err := h.medication.DiscontinueTherapy(context.Background(),
		withFacility(h.pharmacistToken(), h.facility,
			&medicationv1.DiscontinueTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(), Reason: "interaction",
				},
			})); err == nil {
		t.Fatal("a pharmacist discontinued a prescription")
	}
}

// A prescription cannot be reached from another tenant.
func TestAPrescriptionCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newMedHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	p := h.prescribe(t, h.prescriberToken(), patient, encounter,
		threeTimesDaily(time.Now().UTC().Add(time.Hour)))

	other, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	otherTenant := other.Msg.GetTenant().GetTenantId()

	_, err = h.medication.GetPrescription(context.Background(),
		as(otherTenant+":doctor-9:clinician", &medicationv1.GetPrescriptionRequest{
			PrescriptionId: p.GetPrescriptionId(),
		}))
	if err == nil {
		t.Fatal("a prescription was readable from another tenant")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists in somebody else's tenant.
	if got := connectCode(err); got != connect.CodeNotFound &&
		got != connect.CodePermissionDenied {
		t.Fatalf("code = %v", got)
	}
}

// SRS-NUR-007 and SRS-MED-007: the eMAR gives the dose the medication context
// scheduled.
//
// This is the seam Sprint 4C left as a port with no adapter. It is worth an
// end-to-end test rather than a unit one because the failure it guards against
// is a wiring failure: an eMAR built against an interface nobody implemented
// would pass every test in the nursing package and show a ward an empty drug
// round.
func TestTheEmarGivesTheDoseTheMedicationContextScheduled(t *testing.T) {
	h := newMedHarness(t)
	h.entitle(t, "nursing")
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	start := time.Now().UTC().Add(-2 * time.Hour)
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, threeTimesDaily(start))
	h.verify(t, p.GetPrescriptionId())

	round, err := h.nursing.GetMedicationRound(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetMedicationRoundRequest{
			EncounterId: encounter, FacilityId: h.facility,
			From: timestamppb.New(start.Add(-time.Hour)),
			To:   timestamppb.New(start.Add(48 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("GetMedicationRound: %v", err)
	}
	if len(round.Msg.GetDoses()) == 0 {
		t.Fatal("the drug round is empty; the eMAR is not reading the medication context")
	}

	first := round.Msg.GetDoses()[0]
	if first.GetOrder().GetOrderId() != p.GetOrderId() {
		t.Fatalf("the round names order %q, want the prescription's order %q",
			first.GetOrder().GetOrderId(), p.GetOrderId())
	}
	if first.GetOrder().GetDose().GetValue() != 500 {
		t.Fatalf("the round shows a dose of %v, want 500 mg",
			first.GetOrder().GetDose().GetValue())
	}
	if !first.GetOrder().GetVerified() {
		t.Fatal("the round does not carry the pharmacist's verification")
	}
}

// SRS-MED-007 through the eMAR: a discontinued prescription takes the future
// doses off the round and leaves the past ones alone.
func TestDiscontinuingAPrescriptionEmptiesTheFutureDrugRound(t *testing.T) {
	h := newMedHarness(t)
	h.entitle(t, "nursing")
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	start := time.Now().UTC().Add(-36 * time.Hour)
	p := h.prescribe(t, h.prescriberToken(), patient, encounter, threeTimesDaily(start))
	h.verify(t, p.GetPrescriptionId())

	round := func() int {
		t.Helper()
		got, err := h.nursing.GetMedicationRound(context.Background(),
			withFacility(h.nurseToken(), h.facility, &nursingv1.GetMedicationRoundRequest{
				EncounterId: encounter, FacilityId: h.facility,
				From: timestamppb.New(time.Now().UTC()),
				To:   timestamppb.New(time.Now().UTC().Add(48 * time.Hour)),
			}))
		if err != nil {
			t.Fatalf("GetMedicationRound: %v", err)
		}
		return len(got.Msg.GetDoses())
	}

	if round() == 0 {
		t.Fatal("nothing was due before the drug was stopped")
	}

	if _, err := h.medication.DiscontinueTherapy(context.Background(),
		withFacility(h.prescriberToken(), h.facility,
			&medicationv1.DiscontinueTherapyRequest{
				Change: &medicationv1.ChangeTherapyRequest{
					PrescriptionId: p.GetPrescriptionId(), Reason: "rash",
				},
			})); err != nil {
		t.Fatalf("DiscontinueTherapy: %v", err)
	}

	if got := round(); got != 0 {
		t.Fatalf("%d doses are still on the round after the drug was stopped", got)
	}
}
