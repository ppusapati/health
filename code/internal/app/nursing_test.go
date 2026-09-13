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
	nursingv1 "github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1/nursingv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	nursingdomain "github.com/ppusapati/health/code/internal/nursing/domain"
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

// Nursing (SRS-NUR-001 … SRS-NUR-018).
//
// Two rules this file exists to prove.
//
// SRS-NUR-003's: a late entry is identified as late and carries the actual
// observation time. A ward records observations at 06:00 and reaches a terminal
// at 08:40; a system that stamps 08:40 says the patient was stable two hours
// after they in fact were.
//
// SRS-NUR-018's: recovery reconciliation cannot produce a duplicate
// administration. A paper MAR re-keyed twice by two nurses must not show a
// patient given twice what they were given, and the guard has to hold at the
// table because the two submissions can be in flight at the same moment.

// stubOrders is the medication seam until Sprint 5 delivers SRS-MED.
//
// A test double rather than a production stub: the composition root leaves the
// port nil, so a deployment without a medication service refuses every
// administration instead of accepting one unverified.
type stubOrders struct {
	orders map[string]nursingdomain.MedicationOrder
}

func (s *stubOrders) Get(_ context.Context, _ authctx.TenantScope,
	orderID string) (nursingdomain.MedicationOrder, error) {

	order, ok := s.orders[orderID]
	if !ok {
		return nursingdomain.MedicationOrder{}, errNoSuchOrder
	}
	return order, nil
}

func (s *stubOrders) Due(_ context.Context, _ authctx.TenantScope,
	encounterID string, from, to time.Time) ([]nursingdomain.DueDose, error) {

	var out []nursingdomain.DueDose
	for _, order := range s.orders {
		if order.EncounterID != encounterID {
			continue
		}
		// Only active, pharmacist-verified orders produce work (SRS-NUR-007).
		for at := from; at.Before(to); at = at.Add(6 * time.Hour) {
			if !order.Administrable(at) {
				continue
			}
			out = append(out, nursingdomain.DueDose{
				Order: order, ScheduledAt: at.UTC(),
			})
		}
	}
	return out, nil
}

type orderError struct{ message string }

func (e orderError) Error() string { return e.message }

var errNoSuchOrder = orderError{message: "no such medication order"}

type nurHarness struct {
	pool       *pgxpool.Pool
	nursing    nursingv1connect.NursingServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	orders     *stubOrders
	tenantID   string
	facility   string
}

func newNurHarness(t *testing.T) *nurHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	orders := &stubOrders{orders: map[string]nursingdomain.MedicationOrder{}}
	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
		MedicationOrders: orders,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &nurHarness{
		pool:       pool,
		nursing:    nursingv1connect.NewNursingServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
		orders:     orders,
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
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "encounter", "clinical", "nursing"} {
		h.entitle(t, module)
	}
	return h
}

func (h *nurHarness) entitle(t *testing.T, module string) {
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

func (h *nurHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *nurHarness) otherNurseToken() string {
	return h.tenantID + ":nurse-2:nurse:" + h.facility
}

// managerToken is the nurse in charge: assignment and the acuity dashboard.
func (h *nurHarness) managerToken() string {
	return h.tenantID + ":manager-1:nurse_manager:" + h.facility
}

func (h *nurHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *nurHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// ward registers a patient and opens an encounter.
func (h *nurHarness) ward(t *testing.T, family, phone string) (string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1962, 7, 4), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
			AttendingProviderId: "doctor-1", Reason: "abdominal pain",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

func nurCode(system, code, display string) *nursingv1.Coding {
	return &nursingv1.Coding{
		System: system, Version: "2.76", Code: code, Display: display,
	}
}

func pulseCode() *nursingv1.Coding {
	return nurCode("http://loinc.org", "8867-4", "Heart rate")
}

// SRS-NUR-003: the observation time is the bedside time, not the typing time,
// and a catch-up entry is identified as late.
func TestACatchUpEntryIsChartedAsLateWithItsRealObservationTime(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	observed := time.Now().UTC().Add(-3 * time.Hour)
	charted, err := h.nursing.ChartObservation(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ChartObservationRequest{
			PatientId: patient, EncounterId: encounter,
			Code:  pulseCode(),
			Value: &nursingv1.Quantity{Value: 118, Unit: "/min"},
			// Taken three hours ago, on the round.
			ObservedAt:      timestamppb.New(observed),
			Source:          nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
			LateEntryReason: "charted at the end of the round",
		}))
	if err != nil {
		t.Fatalf("ChartObservation: %v", err)
	}

	entry := charted.Msg.GetEntry()
	if !entry.GetLate() {
		t.Fatal("an observation charted three hours late is not marked late")
	}
	if !entry.GetObservedAt().AsTime().Truncate(time.Second).
		Equal(observed.Truncate(time.Second)) {
		t.Fatalf("the observation time was rewritten to %s, want %s",
			entry.GetObservedAt().AsTime(), observed)
	}
	// The recording time is the server's, not the caller's: the one thing a
	// late entry must not be able to do is claim it was on time.
	if !entry.GetRecordedAt().AsTime().After(observed.Add(time.Hour)) {
		t.Fatalf("the recording time is %s; it should be now",
			entry.GetRecordedAt().AsTime())
	}
}

// A late entry with no explanation is refused: the flag without the reason says
// a record is weak without saying why.
func TestALateEntryIsRefusedWithoutAnExplanation(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	_, err := h.nursing.ChartObservation(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ChartObservationRequest{
			PatientId: patient, EncounterId: encounter,
			Code:       pulseCode(),
			Value:      &nursingv1.Quantity{Value: 118, Unit: "/min"},
			ObservedAt: timestamppb.New(time.Now().UTC().Add(-3 * time.Hour)),
			Source:     nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
		}))
	if err == nil {
		t.Fatal("a late entry with no reason was accepted")
	}
}

// The chart is a picture of the patient, so it reads by observation time.
func TestTheFlowsheetReadsByObservationTime(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	now := time.Now().UTC()
	// Charted second, observed first.
	chart := func(observedAgo time.Duration, value float64, reason string) {
		t.Helper()
		if _, err := h.nursing.ChartObservation(context.Background(),
			withFacility(h.nurseToken(), h.facility,
				&nursingv1.ChartObservationRequest{
					PatientId: patient, EncounterId: encounter,
					Code:            pulseCode(),
					Value:           &nursingv1.Quantity{Value: value, Unit: "/min"},
					ObservedAt:      timestamppb.New(now.Add(-observedAgo)),
					Source:          nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
					LateEntryReason: reason,
				})); err != nil {
			t.Fatalf("ChartObservation: %v", err)
		}
	}
	chart(time.Minute, 96, "")
	chart(4*time.Hour, 118, "charted at the end of the round")

	read, err := h.nursing.GetFlowsheet(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetFlowsheetRequest{
			EncounterId: encounter, PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("GetFlowsheet: %v", err)
	}
	entries := read.Msg.GetEntries()
	if len(entries) != 2 {
		t.Fatalf("read %d entries, want 2", len(entries))
	}
	// The 4-hours-ago reading of 118 comes first, even though it was typed
	// second. A chart sorted by typing order says the patient improved and
	// then deteriorated.
	if entries[0].GetValue().GetValue() != 118 {
		t.Fatalf("the first entry is %v; the chart is sorted by typing order",
			entries[0].GetValue().GetValue())
	}
}

// SRS-NUR-004: corrections use an amendment trail, and the balance moves.
func TestCorrectingAVolumeKeepsTheOriginalAndMovesTheBalance(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	now := time.Now().UTC()
	record := func(direction nursingv1.FluidDirection, category string,
		volume float64) string {

		t.Helper()
		out, err := h.nursing.RecordFluid(context.Background(),
			withFacility(h.nurseToken(), h.facility, &nursingv1.RecordFluidRequest{
				PatientId: patient, EncounterId: encounter,
				Direction: direction, Category: category, VolumeMl: volume,
				ObservedAt: timestamppb.New(now.Add(-time.Hour)),
			}))
		if err != nil {
			t.Fatalf("RecordFluid: %v", err)
		}
		return out.Msg.GetEntry().GetFluidId()
	}

	record(nursingv1.FluidDirection_FLUID_DIRECTION_INTAKE, "oral", 200)
	urine := record(nursingv1.FluidDirection_FLUID_DIRECTION_OUTPUT, "urine", 750)

	if _, err := h.nursing.CorrectFluid(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CorrectFluidRequest{
			FluidId: urine, VolumeMl: 450, Reason: "misread the measuring jug",
		})); err != nil {
		t.Fatalf("CorrectFluid: %v", err)
	}

	balance, err := h.nursing.GetFluidBalance(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetFluidBalanceRequest{
			EncounterId: encounter, PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("GetFluidBalance: %v", err)
	}
	if balance.Msg.GetBalance().GetOutputMl() != 450 {
		t.Fatalf("output is %v, want 450; a superseded entry is still counted",
			balance.Msg.GetBalance().GetOutputMl())
	}
	if balance.Msg.GetBalance().GetNetMl() != -250 {
		t.Fatalf("net is %v, want -250", balance.Msg.GetBalance().GetNetMl())
	}

	// The original is still readable: the shift total that was handed over was
	// computed from it.
	trail, err := h.nursing.GetFluidTrail(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetFluidTrailRequest{
			EncounterId: encounter, PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("GetFluidTrail: %v", err)
	}
	var original *nursingv1.FluidEntry
	for _, e := range trail.Msg.GetEntries() {
		if e.GetFluidId() == urine {
			original = e
		}
	}
	if original == nil {
		t.Fatal("the corrected entry is gone from the trail")
	}
	if original.GetVolumeMl() != 750 {
		t.Fatalf("the original was edited to %v", original.GetVolumeMl())
	}
	if original.GetSupersededById() == "" {
		t.Fatal("the original does not point at its correction")
	}
}

// verifiedOrderFor registers a verified medication order with the seam.
func (h *nurHarness) verifiedOrderFor(patient, encounter string,
	prn bool) nursingdomain.MedicationOrder {

	order := nursingdomain.MedicationOrder{
		OrderID: uuid.NewString(), PatientID: patient, EncounterID: encounter,
		Medication: nursingdomain.Coding{
			System: "http://snomed.info/sct", Version: "2024-03",
			Code: "387517004", Display: "Paracetamol",
		},
		Dose:  nursingdomain.Quantity{Value: 1000, Unit: "mg"},
		Route: "oral", Frequency: "qds",
		Status: nursingdomain.OrderActive, Verified: true,
		VerifiedBy: "pharmacist-1", VerifiedAt: time.Now().UTC().Add(-time.Hour),
		PRN:      prn,
		StartsAt: time.Now().UTC().Add(-2 * time.Hour),
	}
	h.orders.orders[order.OrderID] = order
	return order
}

func goodScanFor(order nursingdomain.MedicationOrder) *nursingv1.Verification {
	return &nursingv1.Verification{
		Performed: true, PatientScanned: order.PatientID,
		MedicationScanned: order.Medication.Code,
		ScannedAt:         timestamppb.New(time.Now().UTC()),
	}
}

// SRS-NUR-007: an unverified order produces no administration.
func TestADoseCannotBeGivenAgainstAnUnverifiedOrder(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	order.Verified = false
	h.orders.orders[order.OrderID] = order

	_, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(time.Now().UTC().Add(-30 * time.Minute)),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(time.Now().UTC()),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: goodScanFor(order),
		}))
	if err == nil {
		t.Fatal("a dose was given against an order no pharmacist had verified")
	}
}

// SRS-NUR-008: a barcode mismatch prevents completion.
func TestTheWrongWristbandStopsTheAdministration(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")
	other, _ := h.ward(t, "Venkataraghavan", "9876500000")

	order := h.verifiedOrderFor(patient, encounter, false)
	scan := goodScanFor(order)
	// Scanned the wristband of the patient in the next bed.
	scan.PatientScanned = other

	_, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(time.Now().UTC().Add(-30 * time.Minute)),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(time.Now().UTC()),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: scan,
		}))
	if err == nil {
		t.Fatal("a dose was given to the wrong wristband")
	}
	if !strings.Contains(err.Error(), "wristband") {
		t.Fatalf("the refusal does not say what failed: %v", err)
	}

	// Nothing was written: a refused administration leaves no partial record.
	listed, err := h.nursing.ListAdministrations(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ListAdministrationsRequest{
				EncounterId: encounter, PatientId: patient,
			}))
	if err != nil {
		t.Fatalf("ListAdministrations: %v", err)
	}
	if len(listed.Msg.GetAdministrations()) != 0 {
		t.Fatal("a refused administration left a record behind")
	}
}

// SRS-NUR-008: an override is allowed, documented and reportable.
func TestAnOverrideIsRecordedAndReportable(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	scan := goodScanFor(order)
	scan.MedicationScanned = "000000"

	given, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(time.Now().UTC().Add(-30 * time.Minute)),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(time.Now().UTC()),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: scan,
			OverrideReason: "pharmacy relabelled the pack; checked against the chart " +
				"with the ward pharmacist",
		}))
	if err != nil {
		t.Fatalf("a documented override was refused: %v", err)
	}
	override := given.Msg.GetAdministration().GetOverride()
	if override == nil {
		t.Fatal("the override was not stored on the administration")
	}
	if !override.GetMedicationMismatch() || override.GetPatientMismatch() {
		t.Fatalf("the stored override misdescribes what failed: %+v", override)
	}

	// The report, not the permission, is what makes the override a control: an
	// override nobody counts changes nothing.
	report, err := h.nursing.GetOverrideReport(context.Background(),
		as(tenantAdminToken(h.tenantID),
			&nursingv1.GetOverrideReportRequest{
				From: timestamppb.New(time.Now().UTC().Add(-24 * time.Hour)),
				To:   timestamppb.New(time.Now().UTC().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("GetOverrideReport: %v", err)
	}
	if len(report.Msg.GetAdministrations()) != 1 {
		t.Fatalf("the override report holds %d entries, want 1",
			len(report.Msg.GetAdministrations()))
	}
}

// SRS-NUR-018: the same dose re-keyed twice produces one administration.
func TestRekeyingAPaperChartTwiceCannotDuplicateADose(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	scheduled := time.Now().UTC().Truncate(time.Hour).Add(-2 * time.Hour)

	// The first nurse types in the paper chart.
	if _, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(scheduled),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(scheduled.Add(5 * time.Minute)),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: goodScanFor(order), Offline: true,
		})); err != nil {
		t.Fatalf("Administer: %v", err)
	}

	// The second nurse, working the other half of the pile, types the same
	// entry — different session, different time read off the chart.
	_, err := h.nursing.Administer(context.Background(),
		withFacility(h.otherNurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(scheduled),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(scheduled.Add(8 * time.Minute)),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: goodScanFor(order), Offline: true,
		}))
	if err == nil {
		t.Fatal("the same dose was recorded twice")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "already") {
		t.Fatalf("the refusal does not name the existing record: %v", err)
	}

	listed, err := h.nursing.ListAdministrations(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ListAdministrationsRequest{
				EncounterId: encounter, PatientId: patient,
			}))
	if err != nil {
		t.Fatalf("ListAdministrations: %v", err)
	}
	if len(listed.Msg.GetAdministrations()) != 1 {
		t.Fatalf("the MAR holds %d doses of one scheduled dose",
			len(listed.Msg.GetAdministrations()))
	}
	// The one that survived is marked as reconstructed from paper.
	if !listed.Msg.GetAdministrations()[0].GetRecordedOffline() {
		t.Fatal("the transcribed dose is not marked as recorded offline")
	}
}

// A PRN dose genuinely given twice is a clinical judgement that may be correct,
// so it is flagged rather than refused.
func TestTwoPRNDosesCloseTogetherAreFlaggedRatherThanRefused(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, true)
	give := func(ago time.Duration) {
		t.Helper()
		if _, err := h.nursing.Administer(context.Background(),
			withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
				OrderId: order.OrderID, FacilityId: h.facility,
				GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
				GivenAt:      timestamppb.New(time.Now().UTC().Add(-ago)),
				Route:        "oral",
				Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
				Verification: goodScanFor(order),
			})); err != nil {
			t.Fatalf("a PRN dose was refused: %v", err)
		}
	}
	give(20 * time.Minute)
	give(12 * time.Minute)

	report, err := h.nursing.GetSuspectedDuplicates(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.GetSuspectedDuplicatesRequest{
				EncounterId: encounter, PatientId: patient,
			}))
	if err != nil {
		t.Fatalf("GetSuspectedDuplicates: %v", err)
	}
	if len(report.Msg.GetDuplicates()) != 1 {
		t.Fatalf("the report flags %d pairs, want 1",
			len(report.Msg.GetDuplicates()))
	}
}

// SRS-NUR-009: the MAR retains scheduled versus actual.
func TestTheMARKeepsScheduledAndActualApart(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	scheduled := time.Now().UTC().Add(-3 * time.Hour)
	actual := time.Now().UTC().Add(-30 * time.Minute)

	given, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt: timestamppb.New(scheduled),
			// Half the ordered dose, two and a half hours late.
			GivenDose:    &nursingv1.Quantity{Value: 500, Unit: "mg"},
			GivenAt:      timestamppb.New(actual),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_DELAYED,
			Reason:       "patient at radiology",
			Verification: goodScanFor(order),
		}))
	if err != nil {
		t.Fatalf("Administer: %v", err)
	}

	a := given.Msg.GetAdministration()
	if a.GetScheduledDose().GetValue() != 1000 {
		t.Fatalf("the scheduled dose was overwritten: %v", a.GetScheduledDose())
	}
	if a.GetGivenDose().GetValue() != 500 {
		t.Fatalf("the dose given is %v, want 500", a.GetGivenDose())
	}
	// Without both, "was it late" is unanswerable.
	if !a.GetLate() {
		t.Fatal("a dose given two and a half hours late is not reported late")
	}
}

// A dose not given needs a reason, because "why" is the only part that is
// useful later.
func TestARefusedDoseNeedsAReason(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	_, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			Outcome:     nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_REFUSED,
		}))
	if err == nil {
		t.Fatal("a refusal with no reason was accepted")
	}
}

// A clerk cannot give a drug, and nor can a doctor under this role: giving is
// the nurse's act and prescribing is the doctor's.
func TestOnlyANurseCanChartAnAdministration(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	for name, token := range map[string]string{
		"clerk": h.clerkToken(), "clinician": h.clinicianToken(),
	} {
		_, err := h.nursing.Administer(context.Background(),
			withFacility(token, h.facility, &nursingv1.AdministerRequest{
				OrderId: order.OrderID, FacilityId: h.facility,
				ScheduledAt:  timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
				GivenAt:      timestamppb.New(time.Now().UTC()),
				Route:        "oral",
				Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
				Verification: goodScanFor(order),
			}))
		if err == nil {
			t.Fatalf("a %s charted a medication administration", name)
		}
	}
}

// SRS-NUR-002: care-plan tasks appear in the nursing worklist.
func TestACarePlansInterventionsAppearInTheWorklist(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	if _, err := h.nursing.CreateCarePlan(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CreateCarePlanRequest{
			PatientId: patient, EncounterId: encounter,
			Title: "Post-operative nursing plan",
			Problems: []*nursingv1.PlanProblem{{
				ProblemId:   uuid.NewString(),
				Description: "Risk of pressure injury",
				Goals: []*nursingv1.PlanGoal{{
					GoalId: uuid.NewString(), Description: "Skin remains intact",
				}},
				Interventions: []*nursingv1.Intervention{{
					InterventionId: uuid.NewString(),
					Description:    "Reposition the patient",
					EverySeconds:   int64((2 * time.Hour).Seconds()),
					Priority:       nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE,
					Owner:          "nurse-1",
				}},
			}},
			ScheduleUntil: timestamppb.New(time.Now().UTC().Add(8 * time.Hour)),
		})); err != nil {
		t.Fatalf("CreateCarePlan: %v", err)
	}

	worklist, err := h.nursing.GetWorklist(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetWorklistRequest{
			EncounterId: encounter, PendingOnly: true,
		}))
	if err != nil {
		t.Fatalf("GetWorklist: %v", err)
	}
	tasks := worklist.Msg.GetTasks()
	if len(tasks) != 4 {
		t.Fatalf("two-hourly repositioning over eight hours produced %d tasks, "+
			"want 4", len(tasks))
	}
	if tasks[0].GetSourceKind() != "care_plan" {
		t.Fatalf("the task does not trace back to the plan: %q",
			tasks[0].GetSourceKind())
	}
}

// SRS-NUR-011: completing a task needs evidence, and a recurring task does not
// drift later each round.
func TestCompletingRecurringWorkNeedsEvidenceAndDoesNotDrift(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	due := time.Now().UTC().Add(-time.Hour)
	created, err := h.nursing.CreateTask(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CreateTaskRequest{
			PatientId: patient, EncounterId: encounter,
			Description:       "Four-hourly neurological observations",
			Priority:          nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE,
			DueAt:             timestamppb.New(due),
			RecurEverySeconds: int64((4 * time.Hour).Seconds()),
		}))
	if err != nil {
		t.Fatalf("CreateTask: %v", err)
	}
	task := created.Msg.GetTask()
	if !task.GetOverdue() {
		t.Fatal("a task due an hour ago is not reported overdue")
	}

	if _, err := h.nursing.CompleteTask(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CompleteTaskRequest{
			TaskId: task.GetTaskId(),
		})); err == nil {
		t.Fatal("a task was ticked with no evidence")
	}

	completed, err := h.nursing.CompleteTask(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CompleteTaskRequest{
			TaskId:   task.GetTaskId(),
			Evidence: "GCS 15, pupils equal and reactive",
		}))
	if err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}
	next := completed.Msg.GetNext()
	if next == nil {
		t.Fatal("a recurring task produced no next occurrence")
	}
	// Four hours after it was *due*, not after it was completed: otherwise
	// four-hourly observations drift to once a shift.
	want := due.Add(4 * time.Hour).Truncate(time.Second)
	if !next.GetDueAt().AsTime().Truncate(time.Second).Equal(want) {
		t.Fatalf("the next occurrence is due %s, want %s",
			next.GetDueAt().AsTime(), want)
	}
}

// SRS-NUR-011: overdue critical work escalates, and routine work does not.
func TestOnlyOverdueCriticalWorkEscalates(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	create := func(priority nursingv1.TaskPriority, description string) {
		t.Helper()
		if _, err := h.nursing.CreateTask(context.Background(),
			withFacility(h.nurseToken(), h.facility, &nursingv1.CreateTaskRequest{
				PatientId: patient, EncounterId: encounter,
				Description: description, Priority: priority,
				DueAt: timestamppb.New(time.Now().UTC().Add(-2 * time.Hour)),
			})); err != nil {
			t.Fatalf("CreateTask: %v", err)
		}
	}
	create(nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE, "Reposition the patient")
	create(nursingv1.TaskPriority_TASK_PRIORITY_CRITICAL,
		"Repeat potassium before the next insulin dose")

	escalated, err := h.nursing.EscalateOverdueWork(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.EscalateOverdueWorkRequest{EscalateTo: "nurse-in-charge"}))
	if err != nil {
		t.Fatalf("EscalateOverdueWork: %v", err)
	}
	if len(escalated.Msg.GetEscalated()) != 1 {
		t.Fatalf("%d tasks escalated, want 1 — a stream nobody reads loses the "+
			"critical one first", len(escalated.Msg.GetEscalated()))
	}
	if escalated.Msg.GetEscalated()[0].GetPriority() !=
		nursingv1.TaskPriority_TASK_PRIORITY_CRITICAL {
		t.Fatal("the escalated task is not the critical one")
	}

	// Escalated once, not repeatedly.
	again, err := h.nursing.EscalateOverdueWork(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.EscalateOverdueWorkRequest{EscalateTo: "nurse-in-charge"}))
	if err != nil {
		t.Fatalf("EscalateOverdueWork: %v", err)
	}
	if len(again.Msg.GetEscalated()) != 0 {
		t.Fatal("an already-escalated task escalated again")
	}
}

// SRS-NUR-010: a handover is acknowledged by somebody else, and captures the
// ward's state rather than trusting the caller for it.
func TestAHandoverCapturesTheWardAndIsAcceptedBySomebodyElse(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	// A line in place for two days and an outstanding task.
	if _, err := h.nursing.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.InsertDeviceRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
			Site:       "right internal jugular",
			Laterality: nursingv1.Laterality_LATERALITY_RIGHT,
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-48 * time.Hour)),
		})); err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if _, err := h.nursing.CreateTask(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CreateTaskRequest{
			PatientId: patient, EncounterId: encounter,
			Description: "Repeat potassium",
			Priority:    nursingv1.TaskPriority_TASK_PRIORITY_URGENT,
			DueAt:       timestamppb.New(time.Now().UTC().Add(2 * time.Hour)),
		})); err != nil {
		t.Fatalf("CreateTask: %v", err)
	}

	composed, err := h.nursing.ComposeHandover(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ComposeHandoverRequest{
			PatientId: patient, EncounterId: encounter, UnitId: "ward-3",
			FromShift: &nursingv1.Shift{Code: "day"},
			ToShift:   &nursingv1.Shift{Code: "night"},
			Situation: "Day two post laparotomy, pain controlled on oral analgesia",
			Recommendation: "Continue four-hourly observations; mobilise with " +
				"physiotherapy in the morning",
		}))
	if err != nil {
		t.Fatalf("ComposeHandover: %v", err)
	}
	handover := composed.Msg.GetHandover()

	// The server captured them: a handover cannot quietly omit the line that
	// has been in for two days.
	if len(handover.GetDevices()) != 1 {
		t.Fatalf("the handover carries %d devices, want 1",
			len(handover.GetDevices()))
	}
	if handover.GetDevices()[0].GetDeviceDays() != 3 {
		t.Fatalf("the handover reports %d device-days for a line inserted 48 "+
			"hours ago, want 3", handover.GetDevices()[0].GetDeviceDays())
	}
	if len(handover.GetPendingTasks()) != 1 {
		t.Fatalf("the handover carries %d pending tasks, want 1",
			len(handover.GetPendingTasks()))
	}

	// A nurse acknowledging their own handover is not a handover.
	if _, err := h.nursing.AcknowledgeHandover(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.AcknowledgeHandoverRequest{
				HandoverId: handover.GetHandoverId(),
			})); err == nil {
		t.Fatal("a nurse acknowledged their own handover")
	}

	accepted, err := h.nursing.AcknowledgeHandover(context.Background(),
		withFacility(h.otherNurseToken(), h.facility,
			&nursingv1.AcknowledgeHandoverRequest{
				HandoverId: handover.GetHandoverId(),
				Questions:  "who is covering the central line dressing?",
			}))
	if err != nil {
		t.Fatalf("AcknowledgeHandover: %v", err)
	}
	if accepted.Msg.GetHandover().GetAcknowledgedBy() != "nurse-2" {
		t.Fatalf("acknowledged by %q",
			accepted.Msg.GetHandover().GetAcknowledgedBy())
	}

	// Responsibility moves once.
	if _, err := h.nursing.AcknowledgeHandover(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&nursingv1.AcknowledgeHandoverRequest{
				HandoverId: handover.GetHandoverId(),
			})); err == nil {
		t.Fatal("a handover was acknowledged twice")
	}
}

// SRS-NUR-006: device-days come from the canonical dates, and documenting care
// does not change them.
func TestDeviceDaysComeFromTheCanonicalDates(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	inserted, err := h.nursing.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.InsertDeviceRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.DeviceKind_DEVICE_KIND_URINARY_CATHETER,
			Site:       "urethral",
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-72 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	device := inserted.Msg.GetDevice()
	if device.GetDeviceDays() != 4 {
		t.Fatalf("device-days is %d for a catheter in for 72 hours, want 4",
			device.GetDeviceDays())
	}
	if !device.GetSurveillanceDevice() {
		t.Fatal("a urinary catheter does not count towards surveillance")
	}

	if _, err := h.nursing.RecordDeviceCare(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.RecordDeviceCareRequest{
				DeviceId: device.GetDeviceId(), Kind: "meatal care",
				Finding:     "clean",
				PerformedAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			})); err != nil {
		t.Fatalf("RecordDeviceCare: %v", err)
	}

	listed, err := h.nursing.ListDevices(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListDevicesRequest{
			EncounterId: encounter, PatientId: patient, InPlaceOnly: true,
		}))
	if err != nil {
		t.Fatalf("ListDevices: %v", err)
	}
	if listed.Msg.GetDevices()[0].GetDeviceDays() != 4 {
		t.Fatalf("documenting care changed the device-day count to %d — a "+
			"denominator that falls when the ward is busy makes the infection "+
			"rate rise", listed.Msg.GetDevices()[0].GetDeviceDays())
	}
}

// SRS-NUR-005: the score's scale version and inputs are stored, and a rescore
// supersedes rather than overwrites.
func TestARiskScoreStoresItsInputsAndARescoreSupersedes(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	defined, err := h.nursing.DefineRiskScale(context.Background(),
		as(tenantAdminToken(h.tenantID),
			&nursingv1.DefineRiskScaleRequest{
				Scale: &nursingv1.RiskScale{
					Version: "1988", Name: "Braden scale",
					Domain: nursingv1.RiskDomain_RISK_DOMAIN_PRESSURE_INJURY,
					Inputs: []*nursingv1.RiskInput{
						{Key: "sensory", Label: "Sensory perception", Min: 1, Max: 4},
						{Key: "mobility", Label: "Mobility", Min: 1, Max: 4},
					},
					Bands: []*nursingv1.RiskBand{
						{From: 2, To: 4, Label: "high", Escalate: true},
						{From: 5, To: 8, Label: "low"},
					},
					ReassessAfterSeconds: int64((24 * time.Hour).Seconds()),
				},
			}))
	if err != nil {
		t.Fatalf("DefineRiskScale: %v", err)
	}
	scale := defined.Msg.GetScale()

	scored, err := h.nursing.ScoreRisk(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ScoreRiskRequest{
			PatientId: patient, EncounterId: encounter,
			ScaleId: scale.GetScaleId(), ScaleVersion: "1988",
			Inputs:     map[string]int32{"sensory": 2, "mobility": 2},
			AssessedAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		}))
	if err != nil {
		t.Fatalf("ScoreRisk: %v", err)
	}
	first := scored.Msg.GetAssessment()
	if first.GetTotal() != 4 || first.GetBand() != "high" {
		t.Fatalf("total %d band %q, want 4/high", first.GetTotal(), first.GetBand())
	}
	// The inputs travel with the total: a score on its own cannot be checked or
	// explained.
	if first.GetInputs()["mobility"] != 2 {
		t.Fatalf("the inputs were not stored: %v", first.GetInputs())
	}

	// A missing factor is refused rather than scored zero.
	if _, err := h.nursing.ScoreRisk(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ScoreRiskRequest{
			PatientId: patient, EncounterId: encounter,
			ScaleId: scale.GetScaleId(), ScaleVersion: "1988",
			Inputs:     map[string]int32{"sensory": 2},
			AssessedAt: timestamppb.New(time.Now().UTC()),
		})); err == nil {
		t.Fatal("a score with a missing factor was accepted")
	}

	rescored, err := h.nursing.ScoreRisk(context.Background(),
		withFacility(h.otherNurseToken(), h.facility, &nursingv1.ScoreRiskRequest{
			PatientId: patient, EncounterId: encounter,
			ScaleId: scale.GetScaleId(), ScaleVersion: "1988",
			Inputs:     map[string]int32{"sensory": 4, "mobility": 4},
			AssessedAt: timestamppb.New(time.Now().UTC()),
		}))
	if err != nil {
		t.Fatalf("ScoreRisk: %v", err)
	}

	listed, err := h.nursing.ListRiskAssessments(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ListRiskAssessmentsRequest{
				PatientId: patient,
				Domain:    nursingv1.RiskDomain_RISK_DOMAIN_PRESSURE_INJURY,
			}))
	if err != nil {
		t.Fatalf("ListRiskAssessments: %v", err)
	}
	if len(listed.Msg.GetAssessments()) != 2 {
		t.Fatalf("%d scores stored, want 2 — the nurse acted on the old number",
			len(listed.Msg.GetAssessments()))
	}
	for _, a := range listed.Msg.GetAssessments() {
		if a.GetRiskId() == first.GetRiskId() &&
			a.GetSupersededById() != rescored.Msg.GetAssessment().GetRiskId() {
			t.Fatal("the original score was not superseded by the rescore")
		}
	}
}

// SRS-NUR-013: an expired authorization alerts, and does not free the patient.
func TestAnExpiredRestraintAuthorizationAlertsWithoutFreeingThePatient(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	authorized := time.Now().UTC().Add(-5 * time.Hour)
	applied, err := h.nursing.ApplyRestraint(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ApplyRestraintRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:        nursingv1.RestraintKind_RESTRAINT_KIND_PHYSICAL,
			Description: "bilateral soft wrist limiters",
			Authorization: &nursingv1.RestraintAuthorization{
				AuthorizedBy: "doctor-1",
				AuthorizedAt: timestamppb.New(authorized),
				// Ran out an hour ago.
				ExpiresAt:  timestamppb.New(authorized.Add(4 * time.Hour)),
				Indication: "pulling at the endotracheal tube; risk of self-extubation",
			},
			StartedAt:           timestamppb.New(authorized.Add(5 * time.Minute)),
			MonitorEverySeconds: int64((15 * time.Minute).Seconds()),
		}))
	if err != nil {
		t.Fatalf("ApplyRestraint: %v", err)
	}
	restraint := applied.Msg.GetRestraint()
	if !restraint.GetAuthorizationExpired() {
		t.Fatal("a lapsed authorization is not reported expired")
	}
	// The patient is still restrained. A system that "removed" the restraint at
	// expiry would show a patient free while they were tied to a bed.
	if restraint.GetDiscontinuedAt() != nil {
		t.Fatal("the restraint ended itself when its authorization lapsed")
	}

	alerts, err := h.nursing.GetRestraintAlerts(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.GetRestraintAlertsRequest{}))
	if err != nil {
		t.Fatalf("GetRestraintAlerts: %v", err)
	}
	if len(alerts.Msg.GetRestraints()) != 1 {
		t.Fatalf("%d restraints alerting, want 1",
			len(alerts.Msg.GetRestraints()))
	}

	// A check must say why the restraint is still needed.
	if _, err := h.nursing.CheckRestraint(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.CheckRestraintRequest{
			RestraintId: restraint.GetRestraintId(),
			ObservedAt:  timestamppb.New(time.Now().UTC()),
			Findings:    "circulation intact, skin unmarked",
		})); err == nil {
		t.Fatal("a check with no continuation reason was accepted")
	}
}

// SRS-NUR-014: reporting a reaction stops the transfusion.
func TestReportingATransfusionReactionStopsIt(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	started := time.Now().UTC().Add(-30 * time.Minute)
	begun, err := h.nursing.StartTransfusion(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.StartTransfusionRequest{
			PatientId: patient, EncounterId: encounter,
			UnitNumber: "G123456789012",
			Product: nurCode("http://snomed.info/sct", "256395009",
				"Packed red blood cells"),
			AboGroup: "O", Rhd: "positive", VolumeMl: 280,
			StartedAt: timestamppb.New(started),
			// The second person at the bedside check.
			CheckedBy: "nurse-2",
			Baseline: &nursingv1.TransfusionObservation{
				ObservedAt:   timestamppb.New(started.Add(-15 * time.Minute)),
				ObservedBy:   "nurse-1",
				TemperatureC: 36.8, Pulse: 82, SystolicBp: 118,
				RespiratoryRate: 16,
			},
		}))
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	transfusion := begun.Msg.GetTransfusion()

	stopped, err := h.nursing.ReportTransfusionReaction(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ReportTransfusionReactionRequest{
				TransfusionId: transfusion.GetTransfusionId(),
				Features:      "rigors, temperature 38.9, loin pain",
				ActionTaken: "transfusion stopped, line kept open with saline, " +
					"medical staff called",
				UnitReturned: true,
			}))
	if err != nil {
		t.Fatalf("ReportTransfusionReaction: %v", err)
	}
	if stopped.Msg.GetTransfusion().GetStatus() !=
		nursingv1.TransfusionStatus_TRANSFUSION_STATUS_STOPPED {
		t.Fatalf("status is %v, want stopped",
			stopped.Msg.GetTransfusion().GetStatus())
	}

	// A stopped transfusion takes no more observations.
	if _, err := h.nursing.ObserveTransfusion(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ObserveTransfusionRequest{
				TransfusionId: transfusion.GetTransfusionId(),
				Observation: &nursingv1.TransfusionObservation{
					ObservedAt: timestamppb.New(time.Now().UTC()),
					ObservedBy: "nurse-1", TemperatureC: 38.4,
				},
			})); err == nil {
		t.Fatal("a stopped transfusion accepted an observation")
	}
}

// SRS-NUR-012: a photograph needs a consent that covers it.
func TestAWoundPhotographIsRefusedWithoutConsent(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	assessed, err := h.nursing.AssessWound(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AssessWoundRequest{
			PatientId: patient, EncounterId: encounter,
			WoundId: "wound-1", Location: "sacrum",
			Kind: nursingv1.WoundKind_WOUND_KIND_PRESSURE_INJURY, Stage: "2",
			LengthMm: 40, WidthMm: 25, DepthMm: 3,
			Appearance: "shallow open ulcer, pink wound bed",
			AssessedAt: timestamppb.New(time.Now().UTC().Add(-10 * time.Minute)),
		}))
	if err != nil {
		t.Fatalf("AssessWound: %v", err)
	}
	assessment := assessed.Msg.GetAssessment()
	if assessment.GetAreaMm2() != 1000 {
		t.Fatalf("area is %v, want 1000", assessment.GetAreaMm2())
	}

	// No consent reference at all.
	if _, err := h.nursing.AttachWoundImage(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.AttachWoundImageRequest{
				WoundAssessmentId: assessment.GetWoundAssessmentId(),
				StorageKey:        "s3://wounds/image-1",
				ContentType:       "image/jpeg",
				CapturedAt:        timestamppb.New(time.Now().UTC()),
			})); err == nil {
		t.Fatal("an unconsented photograph of a patient was attached")
	}

	// A consent identifier the caller made up is not a consent.
	if _, err := h.nursing.AttachWoundImage(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.AttachWoundImageRequest{
				WoundAssessmentId: assessment.GetWoundAssessmentId(),
				ConsentId:         uuid.NewString(),
				StorageKey:        "s3://wounds/image-1",
				ContentType:       "image/jpeg",
				CapturedAt:        timestamppb.New(time.Now().UTC()),
			})); err == nil {
		t.Fatal("a photograph was attached under a consent that does not exist")
	}
}

// A pressure injury charted without a stage is one nobody reports.
func TestAPressureInjuryNeedsItsStage(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	if _, err := h.nursing.AssessWound(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AssessWoundRequest{
			PatientId: patient, EncounterId: encounter,
			WoundId: "wound-1", Location: "sacrum",
			Kind:       nursingv1.WoundKind_WOUND_KIND_PRESSURE_INJURY,
			Appearance: "shallow open ulcer",
			AssessedAt: timestamppb.New(time.Now().UTC()),
		})); err == nil {
		t.Fatal("a pressure injury with no stage was accepted")
	}
}

// SRS-NUR-017: the question is always about the past.
func TestWhoWasLookingAfterThePatientIsAnsweredAsOfATime(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")
	_ = encounter

	from := time.Now().UTC().Add(-8 * time.Hour)
	assigned, err := h.nursing.AssignNurse(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&nursingv1.AssignNurseRequest{
				UnitId: "ward-3", BedId: "bed-4", PatientId: patient,
				NurseId:       "nurse-1",
				Relationship:  nursingv1.CareRelationship_CARE_RELATIONSHIP_PRIMARY,
				EffectiveFrom: timestamppb.New(from),
			}))
	if err != nil {
		t.Fatalf("AssignNurse: %v", err)
	}

	// Two live primary nurses for one patient is no answer at all.
	if _, err := h.nursing.AssignNurse(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&nursingv1.AssignNurseRequest{
				UnitId: "ward-3", BedId: "bed-4", PatientId: patient,
				NurseId:      "nurse-2",
				Relationship: nursingv1.CareRelationship_CARE_RELATIONSHIP_PRIMARY,
			})); err == nil {
		t.Fatal("a second live primary nurse was assigned to one patient")
	}

	if _, err := h.nursing.EndAssignment(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&nursingv1.EndAssignmentRequest{
				AssignmentId: assigned.Msg.GetAssignment().GetAssignmentId(),
				EffectiveTo:  timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				Reason:       "shift end",
			})); err != nil {
		t.Fatalf("EndAssignment: %v", err)
	}

	// Nobody now.
	now, err := h.nursing.ListAssignments(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListAssignmentsRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListAssignments: %v", err)
	}
	if len(now.Msg.GetAssignments()) != 0 {
		t.Fatalf("%d live assignments after the shift ended",
			len(now.Msg.GetAssignments()))
	}

	// But the answer to "who held this patient four hours ago" survives.
	earlier, err := h.nursing.ListAssignments(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListAssignmentsRequest{
			PatientId: patient,
			AsOf:      timestamppb.New(time.Now().UTC().Add(-4 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("ListAssignments: %v", err)
	}
	if len(earlier.Msg.GetAssignments()) != 1 {
		t.Fatal("ending the assignment erased who held the patient four hours ago")
	}
	if earlier.Msg.GetAssignments()[0].GetNurseId() != "nurse-1" {
		t.Fatalf("held by %q", earlier.Msg.GetAssignments()[0].GetNurseId())
	}
}

// SRS-NUR-016: the dashboard reports and does not decide.
func TestTheAcuityDashboardReportsAndNeverStaffsTheWard(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	// Two overdue tasks and a line, which is what the figure is built from.
	for i, description := range []string{"Reposition", "Repeat potassium"} {
		if _, err := h.nursing.CreateTask(context.Background(),
			withFacility(h.nurseToken(), h.facility, &nursingv1.CreateTaskRequest{
				PatientId: patient, EncounterId: encounter,
				Description: description,
				Priority:    nursingv1.TaskPriority_TASK_PRIORITY_ROUTINE,
				DueAt: timestamppb.New(
					time.Now().UTC().Add(-time.Duration(i+1) * time.Hour)),
			})); err != nil {
			t.Fatalf("CreateTask: %v", err)
		}
	}
	if _, err := h.nursing.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.InsertDeviceRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.DeviceKind_DEVICE_KIND_CENTRAL_LINE,
			Site:       "right internal jugular",
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		})); err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}

	// Nobody assigned yet.
	empty, err := h.nursing.GetUnitAcuity(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetUnitAcuityRequest{
			UnitId: "ward-3",
			Patients: []*nursingv1.AcuityPatientInput{{
				PatientId: patient, EncounterId: encounter,
				DependencyScore: 4, Isolation: true,
			}},
		}))
	if err != nil {
		t.Fatalf("GetUnitAcuity: %v", err)
	}
	acuity := empty.Msg.GetAcuity()
	// A ward with no nurses assigned is not a ward with zero workload per
	// nurse.
	if acuity.GetPerNurseAvailable() {
		t.Fatal("a unit with nobody on duty reported a per-nurse figure")
	}
	if acuity.GetTotal() == 0 {
		t.Fatal("the acuity figure is zero for a patient with work outstanding")
	}
	// The weights travel with the score, so a retune does not rewrite history.
	if acuity.GetPatients()[0].GetWeights().GetIsolation() == 0 {
		t.Fatal("the score does not carry the weights it was computed with")
	}
	// The inputs are named and stored, so the figure can be challenged.
	if acuity.GetPatients()[0].GetInputs().GetOverdueTasks() != 2 {
		t.Fatalf("overdue tasks counted as %d, want 2",
			acuity.GetPatients()[0].GetInputs().GetOverdueTasks())
	}

	// Assigning a nurse changes the denominator, and nothing the dashboard did
	// assigned one.
	if _, err := h.nursing.AssignNurse(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&nursingv1.AssignNurseRequest{
				UnitId: "ward-3", BedId: "bed-4", PatientId: patient,
				NurseId:      "nurse-1",
				Relationship: nursingv1.CareRelationship_CARE_RELATIONSHIP_PRIMARY,
			})); err != nil {
		t.Fatalf("AssignNurse: %v", err)
	}
	staffed, err := h.nursing.GetUnitAcuity(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.GetUnitAcuityRequest{
			UnitId: "ward-3",
			Patients: []*nursingv1.AcuityPatientInput{{
				PatientId: patient, EncounterId: encounter,
				DependencyScore: 4, Isolation: true,
			}},
		}))
	if err != nil {
		t.Fatalf("GetUnitAcuity: %v", err)
	}
	if !staffed.Msg.GetAcuity().GetPerNurseAvailable() {
		t.Fatal("a staffed unit reports no per-nurse figure")
	}
	if staffed.Msg.GetAcuity().GetNursesOnDuty() != 1 {
		t.Fatalf("nurses on duty is %d, want 1 — counted from live "+
			"assignments, not from a roster",
			staffed.Msg.GetAcuity().GetNursesOnDuty())
	}
}

// SRS-NUR-001: the assessment stores the template version and lists every
// missing required section.
func TestAnAssessmentRecordsItsTemplateVersionAndNamesEveryGap(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	defined, err := h.nursing.DefineAssessmentTemplate(context.Background(),
		as(tenantAdminToken(h.tenantID),
			&nursingv1.DefineAssessmentTemplateRequest{
				Template: &nursingv1.AssessmentTemplate{
					Version: "3", Name: "Adult medical admission",
					MinAgeYears: 16, ServiceCode: "medicine",
					Sections: []*nursingv1.TemplateSection{
						{Heading: "Mobility", Required: true},
						{Heading: "Skin", Required: true},
						{Heading: "Social"},
					},
				},
			}))
	if err != nil {
		t.Fatalf("DefineAssessmentTemplate: %v", err)
	}
	template := defined.Msg.GetTemplate()

	// Both required sections missing, and the refusal names both: a nurse told
	// about one, who answers it and is then told about another, stops reading.
	_, err = h.nursing.RecordAssessment(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.RecordAssessmentRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.AssessmentKind_ASSESSMENT_KIND_ADMISSION,
			TemplateId: template.GetTemplateId(), TemplateVersion: "3",
			Answers: []*nursingv1.Answer{
				{Heading: "Social", Value: "Lives alone"},
			},
			AssessedAt: timestamppb.New(time.Now().UTC()),
		}))
	if err == nil {
		t.Fatal("an incomplete admission assessment was accepted")
	}
	if !strings.Contains(err.Error(), "Mobility") ||
		!strings.Contains(err.Error(), "Skin") {
		t.Fatalf("the refusal does not name both gaps: %v", err)
	}

	recorded, err := h.nursing.RecordAssessment(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.RecordAssessmentRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.AssessmentKind_ASSESSMENT_KIND_ADMISSION,
			TemplateId: template.GetTemplateId(), TemplateVersion: "3",
			Answers: []*nursingv1.Answer{
				{Heading: "Mobility", Value: "Independent"},
				{Heading: "Skin", Value: "Intact"},
			},
			AssessedAt: timestamppb.New(time.Now().UTC().Add(-20 * time.Minute)),
		}))
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	if recorded.Msg.GetAssessment().GetTemplateVersion() != "3" {
		t.Fatalf("template version is %q",
			recorded.Msg.GetAssessment().GetTemplateVersion())
	}

	// Retiring the template does not invalidate what was already answered
	// against it, and stops it being chosen for a new one.
	if _, err := h.nursing.RetireAssessmentTemplate(context.Background(),
		as(tenantAdminToken(h.tenantID),
			&nursingv1.RetireAssessmentTemplateRequest{
				TemplateId: template.GetTemplateId(), Version: "3",
			})); err != nil {
		t.Fatalf("RetireAssessmentTemplate: %v", err)
	}
	if _, err := h.nursing.RecordAssessment(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.RecordAssessmentRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.AssessmentKind_ASSESSMENT_KIND_SHIFT,
			TemplateId: template.GetTemplateId(), TemplateVersion: "3",
			Answers: []*nursingv1.Answer{
				{Heading: "Mobility", Value: "Independent"},
				{Heading: "Skin", Value: "Intact"},
			},
			AssessedAt: timestamppb.New(time.Now().UTC()),
		})); err == nil {
		t.Fatal("a retired template was used for a new assessment")
	}
	listed, err := h.nursing.ListAssessments(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListAssessmentsRequest{
			EncounterId: encounter, PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListAssessments: %v", err)
	}
	if len(listed.Msg.GetAssessments()) != 1 {
		t.Fatal("retiring the template invalidated the assessment answered " +
			"against it")
	}
}

// SRS-NUR-015: discharge readiness names what is outstanding.
func TestDischargeReadinessNamesWhatIsOutstanding(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	// A line still in and teaching that needs another session.
	if _, err := h.nursing.InsertDevice(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.InsertDeviceRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       nursingv1.DeviceKind_DEVICE_KIND_PERIPHERAL_LINE,
			Site:       "left forearm",
			InsertedAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		})); err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if _, err := h.nursing.RecordEducation(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.RecordEducationRequest{
			PatientId: patient, EncounterId: encounter,
			Topic: nurCode("http://snomed.info/sct", "410293004",
				"Stoma care education"),
			Learner: nursingv1.Learner_LEARNER_CARER, LearnerName: "daughter",
			Method: "return demonstration with a spare appliance",
			// Teaching delivered is not teaching received.
			Understanding: nursingv1.Understanding_UNDERSTANDING_NEEDS_REINFORCEMENT,
			Barriers:      "tired; second session arranged",
			TaughtAt:      timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		})); err != nil {
		t.Fatalf("RecordEducation: %v", err)
	}

	readiness, err := h.nursing.GetDischargeReadiness(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.GetDischargeReadinessRequest{
				EncounterId: encounter, PatientId: patient,
			}))
	if err != nil {
		t.Fatalf("GetDischargeReadiness: %v", err)
	}
	if readiness.Msg.GetReadiness().GetReady() {
		t.Fatal("a patient with a line in and teaching outstanding is ready")
	}

	unmet := map[string]string{}
	for _, c := range readiness.Msg.GetReadiness().GetCriteria() {
		if !c.GetMet() {
			unmet[c.GetKey()] = c.GetNote()
		}
	}
	// All of them, not the first: a nurse told about one blocker, who clears it
	// and is then told about another, stops planning discharges in advance.
	for _, key := range []string{"a_discharge_assessment", "b_education", "c_devices"} {
		if _, ok := unmet[key]; !ok {
			t.Fatalf("criterion %q is not reported outstanding: %v", key, unmet)
		}
	}
	if !strings.Contains(unmet["c_devices"], "peripheral_line") {
		t.Fatalf("the device criterion does not say what is in place: %q",
			unmet["c_devices"])
	}
}

// SRS-NUR-018: ending downtime and reconciling it are different facts.
func TestEndingDowntimeIsNotTheSameAsReconcilingIt(t *testing.T) {
	h := newNurHarness(t)

	declared, err := h.nursing.DeclareDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.DeclareDowntimeRequest{
			UnitId: "ward-3", Reason: "network outage",
			StartedAt: timestamppb.New(time.Now().UTC().Add(-3 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("DeclareDowntime: %v", err)
	}
	episode := declared.Msg.GetEpisode()

	// Two open episodes on one unit would make "are we on paper" depend on
	// which row a query found.
	if _, err := h.nursing.DeclareDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.DeclareDowntimeRequest{
			UnitId: "ward-3", Reason: "network outage again",
		})); err == nil {
		t.Fatal("a second open downtime episode was declared on one unit")
	}

	// Reconciling an open episode would claim the paper is fully entered while
	// the ward is still writing on it.
	if _, err := h.nursing.ReconcileDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ReconcileDowntimeRequest{
				EpisodeId: episode.GetEpisodeId(),
			})); err == nil {
		t.Fatal("an open downtime episode was reconciled")
	}

	if _, err := h.nursing.EndDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.EndDowntimeRequest{
			EpisodeId: episode.GetEpisodeId(),
			EndedAt:   timestamppb.New(time.Now().UTC().Add(-time.Hour)),
		})); err != nil {
		t.Fatalf("EndDowntime: %v", err)
	}

	// Ended and not yet reconciled is a gap in the record, and it is visible.
	outstanding, err := h.nursing.ListDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListDowntimeRequest{
			UnitId: "ward-3", UnreconciledOnly: true,
		}))
	if err != nil {
		t.Fatalf("ListDowntime: %v", err)
	}
	if len(outstanding.Msg.GetEpisodes()) != 1 {
		t.Fatal("an ended but unreconciled episode is not surfaced")
	}

	if _, err := h.nursing.ReconcileDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&nursingv1.ReconcileDowntimeRequest{
				EpisodeId: episode.GetEpisodeId(),
			})); err != nil {
		t.Fatalf("ReconcileDowntime: %v", err)
	}
	after, err := h.nursing.ListDowntime(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ListDowntimeRequest{
			UnitId: "ward-3", UnreconciledOnly: true,
		}))
	if err != nil {
		t.Fatalf("ListDowntime: %v", err)
	}
	if len(after.Msg.GetEpisodes()) != 0 {
		t.Fatal("a reconciled episode still shows as outstanding")
	}
}

// A closed encounter takes no new nursing content.
func TestAClosedEncounterTakesNoNewObservations(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	if _, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.CancelEncounterRequest{
				EncounterId: encounter, Reason: "opened against the wrong patient",
			})); err != nil {
		t.Fatalf("CancelEncounter: %v", err)
	}

	if _, err := h.nursing.ChartObservation(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ChartObservationRequest{
			PatientId: patient, EncounterId: encounter,
			Code:       pulseCode(),
			Value:      &nursingv1.Quantity{Value: 88, Unit: "/min"},
			ObservedAt: timestamppb.New(time.Now().UTC()),
			Source:     nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
		})); err == nil {
		t.Fatal("a cancelled encounter accepted new observations")
	}
}

// Nursing content cannot be read across a tenant boundary.
func TestANursingRecordCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Iyer", "9876543210")

	if _, err := h.nursing.ChartObservation(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.ChartObservationRequest{
			PatientId: patient, EncounterId: encounter,
			Code:       pulseCode(),
			Value:      &nursingv1.Quantity{Value: 88, Unit: "/min"},
			ObservedAt: timestamppb.New(time.Now().UTC()),
			Source:     nursingv1.EntrySource_ENTRY_SOURCE_MANUAL,
		})); err != nil {
		t.Fatalf("ChartObservation: %v", err)
	}

	other := newNurHarness(t)
	_, err := other.nursing.GetFlowsheet(context.Background(),
		withFacility(other.nurseToken(), other.facility,
			&nursingv1.GetFlowsheetRequest{
				EncounterId: encounter, PatientId: patient,
			}))
	if err == nil {
		t.Fatal("another tenant's flowsheet is readable")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists in somebody else's tenant.
	if !strings.Contains(strings.ToLower(err.Error()), "not_found") &&
		!strings.Contains(strings.ToLower(err.Error()), "no such") {
		t.Fatalf("the refusal confirms the record exists elsewhere: %v", err)
	}
}

// The medication event carries identifiers, never what the drug was for.
func TestAdministeringEmitsAnEventCarryingNoClinicalReasoning(t *testing.T) {
	h := newNurHarness(t)
	patient, encounter := h.ward(t, "Venkataraghavan", "9876543210")

	order := h.verifiedOrderFor(patient, encounter, false)
	given, err := h.nursing.Administer(context.Background(),
		withFacility(h.nurseToken(), h.facility, &nursingv1.AdministerRequest{
			OrderId: order.OrderID, FacilityId: h.facility,
			ScheduledAt:  timestamppb.New(time.Now().UTC().Add(-time.Hour)),
			GivenDose:    &nursingv1.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:      timestamppb.New(time.Now().UTC()),
			Route:        "oral",
			Outcome:      nursingv1.AdministrationOutcome_ADMINISTRATION_OUTCOME_ADMINISTERED,
			Verification: goodScanFor(order),
		}))
	if err != nil {
		t.Fatalf("Administer: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'medication.administered'`,
		given.Msg.GetAdministration().GetAdministrationId()).Scan(&payload); err != nil {
		t.Fatalf("no medication.administered event was written: %v", err)
	}
	if strings.Contains(payload, "Venkataraghavan") ||
		strings.Contains(payload, "Paracetamol") {
		t.Fatalf("the event carries demographic or product detail: %s", payload)
	}
	if !strings.Contains(payload, "order_id") {
		t.Fatalf("the event does not reference the order: %s", payload)
	}
}
