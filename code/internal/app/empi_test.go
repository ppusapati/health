package app_test

import (
	"context"
	"errors"
	"fmt"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
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

// Patient identity end to end (SRS-EMPI-001, 002, 003).
//
// Through the real HTTP server, the real composition root and a real
// PostgreSQL. What is being proven is not that each layer works — the unit
// tests do that — but that the layers are connected the way the requirements
// assume: that the MRN comes from the facility's sequence, that the internal
// identifier survives everything, and that a clerk who has not been shown a
// duplicate cannot create one.

type empiHarness struct {
	pool     *pgxpool.Pool
	patients empiv1connect.PatientServiceClient
	org      organizationv1connect.OrganizationServiceClient
	tenantID string
	facility string
}

func newEmpiHarness(t *testing.T) *empiHarness {
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

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &empiHarness{
		pool:     pool,
		patients: empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:      organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
	}

	// A tenant and a facility, then the MRN sequence the facility issues from.
	resp, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Apollo Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	h.tenantID = resp.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(h.tenantID), &organizationv1.CreateFacilityRequest{
			Code: "main", DisplayName: "Main Hospital",
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	h.provision(t, h.tenantID, h.facility)
	return h
}

// provision gives a tenant what the patient index needs: the module
// entitlement and the facility's MRN sequence.
func (h *empiHarness) provision(t *testing.T, tenantID, facilityID string) {
	t.Helper()
	h.entitleEMPI(t, tenantID)
	h.ensureMRNSequence(t, tenantID, facilityID)
}

// entitleEMPI grants the tenant the patient-index module.
//
// Without it every call is refused with MODULE_NOT_ENTITLED, which is the
// SRS-PLT-011 control working rather than a test-harness inconvenience: a
// module a hospital has not bought is unreachable at the wire, not merely
// hidden in a menu. Provisioning grants it; the test does the same.
func (h *empiHarness) entitleEMPI(t *testing.T, tenantID string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), tenantID, "",
		"empi", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

// ensureMRNSequence provisions the facility's MRN series.
//
// Registration refuses with ORG_SEQUENCE_NOT_CONFIGURED until this exists, and
// that is the right behaviour: the format of a number printed on a wristband
// for the rest of a person's life is a decision a hospital makes, not one a
// default quietly makes for them. Facility commissioning should do this; until
// it does, the test does it explicitly.
func (h *empiHarness) ensureMRNSequence(t *testing.T, tenantID, facilityID string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: tenantID,
	}).TenantScope()

	sequence, err := orgdomain.NewNumberSequence(uuid.NewString(), tenantID, facilityID,
		orgdomain.ScopeMRN, "MRN-", 6, 1, "", time.Now().UTC())
	if err != nil {
		t.Fatalf("NewNumberSequence: %v", err)
	}
	if err := repo.EnsureSequence(context.Background(), scope, sequence); err != nil {
		t.Fatalf("EnsureSequence: %v", err)
	}
}

// tenantSetup is one provisioned tenant on the shared server.
type tenantSetup struct {
	tenantID string
	facility string
}

func (s tenantSetup) clerkToken() string {
	return s.tenantID + ":clerk-n:registration_clerk:" + s.facility
}

// provisionNeighbour stands up a second tenant on the same server.
func (h *empiHarness) provisionNeighbour(t *testing.T) tenantSetup {
	t.Helper()

	resp, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant (neighbour): %v", err)
	}
	tenantID := resp.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(tenantID), &organizationv1.CreateFacilityRequest{
			Code: "north", DisplayName: "North Hospital",
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility (neighbour): %v", err)
	}
	facilityID := facility.Msg.GetFacility().GetFacilityId()

	h.provision(t, tenantID, facilityID)
	return tenantSetup{tenantID: tenantID, facility: facilityID}
}

// Tokens. The fourth segment is the facility claim: registration happens at a
// desk in a building, and the MRN comes from that building's sequence.
func (h *empiHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *empiHarness) himToken() string {
	return h.tenantID + ":him-1:him_officer:" + h.facility
}

func (h *empiHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

// withFacility adds the active-facility header the interceptor narrows on.
func withFacility[T any](token, facilityID string, msg *T) *connect.Request[T] {
	req := as(token, msg)
	req.Header().Set(platformtransport.HeaderFacilityID, facilityID)
	return req
}

func demographics(family string, given []string, birth time.Time, sex empiv1.Sex, phone string) *empiv1.Demographics {
	d := &empiv1.Demographics{
		Name: &empiv1.HumanName{Family: family, Given: given},
		Sex:  sex,
	}
	if !birth.IsZero() {
		d.BirthDate = &empiv1.PartialDate{
			Date: timestamppb.New(birth), Precision: empiv1.DatePrecision_DATE_PRECISION_DAY,
		}
	}
	if phone != "" {
		d.Phones = []*empiv1.ContactPoint{{
			System: empiv1.ContactSystem_CONTACT_SYSTEM_PHONE, Value: phone,
		}}
	}
	return d
}

// register returns the created patient, or nil when the response asked for
// duplicates to be reviewed instead.
func (h *empiHarness) register(t *testing.T, token string, d *empiv1.Demographics,
	acknowledged ...string) (*empiv1.Patient, error) {

	t.Helper()
	resp, err := h.patients.RegisterPatient(context.Background(),
		withFacility(token, h.facility, &empiv1.RegisterPatientRequest{
			Demographics:                    d,
			AcknowledgedDuplicatePatientIds: acknowledged,
		}))
	if err != nil {
		return nil, err
	}
	return resp.Msg.GetPatient(), nil
}

// mustRegister fails the test if registration did not produce a patient.
func (h *empiHarness) mustRegister(t *testing.T, token string, d *empiv1.Demographics,
	acknowledged ...string) *empiv1.Patient {

	t.Helper()
	patient, err := h.register(t, token, d, acknowledged...)
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	if patient == nil {
		t.Fatal("registration returned duplicates to review rather than a patient")
	}
	return patient
}

// SRS-EMPI-001: a patient is created and an MRN is assigned from the
// registering facility's sequence.
func TestRegisteringAPatientIssuesAnMRN(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if patient.GetPatientId() == "" {
		t.Fatal("no internal patient identifier was minted")
	}
	// Candidate, not active. Identity is confirmed by somebody who has seen a
	// document; defaulting to active would make confirmation a step nobody has
	// to take.
	if patient.GetStatus() != empiv1.PatientStatus_PATIENT_STATUS_CANDIDATE {
		t.Fatalf("status = %v, want candidate", patient.GetStatus())
	}

	var mrn *empiv1.PatientIdentifier
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i
		}
	}
	if mrn == nil {
		t.Fatalf("no MRN was issued: %+v", patient.GetIdentifiers())
	}
	if !strings.HasPrefix(mrn.GetValue(), "MRN-") {
		t.Fatalf("MRN %q does not follow the facility's configured format", mrn.GetValue())
	}
	if !mrn.GetPrimary() {
		t.Fatal("the issued MRN is not flagged as the primary identifier")
	}
	// Namespaced by the facility that issued it: two sites both issuing
	// "MRN-000001" are two different patients.
	if !strings.Contains(mrn.GetSystem(), h.facility) {
		t.Fatalf("MRN system %q is not namespaced by the facility", mrn.GetSystem())
	}
}

// SRS-EMPI-002. The MRN is issued, superseded and reissued; the internal
// identifier is none of those things.
func TestTheInternalIdentifierIsNotTheMRN(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	var mrn string
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i.GetValue()
		}
	}
	if patient.GetPatientId() == mrn {
		t.Fatal("the internal identifier is the MRN")
	}
	if _, err := uuid.Parse(patient.GetPatientId()); err != nil {
		t.Fatalf("the internal identifier %q is not opaque", patient.GetPatientId())
	}

	// A correction changes the record and not its identity.
	updated, err := h.patients.UpdateDemographics(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.UpdateDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer-Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			ExpectedVersion: patient.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("UpdateDemographics: %v", err)
	}
	if updated.Msg.GetPatient().GetPatientId() != patient.GetPatientId() {
		t.Fatal("a demographic correction changed the internal identifier")
	}
}

// SRS-EMPI-016, which Sprint 2 owns but which is a property of this schema:
// concurrent registrations must not share an MRN.
func TestConcurrentRegistrationsGetDistinctMRNs(t *testing.T) {
	h := newEmpiHarness(t)

	const registrations = 12
	var (
		wg       sync.WaitGroup
		mu       sync.Mutex
		issued   []string
		failures []error
	)

	for i := range registrations {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// Distinct surnames AND distinct birth dates, so nothing scores
			// as a duplicate. What is under test is the sequence, not the
			// matcher — and a shared birth date is a blocking key, which is
			// exactly how twelve unrelated people become twelve candidates.
			patient, err := h.register(t, h.clerkToken(), demographics(
				fmt.Sprintf("Zylberstein%02d", i), []string{fmt.Sprintf("Given%02d", i)},
				date(1950+i, time.Month(1+i%12), 1+i%28), empiv1.Sex_SEX_FEMALE, ""))

			mu.Lock()
			defer mu.Unlock()
			if err != nil {
				failures = append(failures, err)
				return
			}
			if patient == nil {
				failures = append(failures, errors.New("registration asked for a duplicate review"))
				return
			}
			for _, id := range patient.GetIdentifiers() {
				if id.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
					issued = append(issued, id.GetValue())
				}
			}
		}()
	}
	wg.Wait()

	for _, err := range failures {
		t.Errorf("registration failed: %v", err)
	}
	if len(issued) != registrations {
		t.Fatalf("%d MRNs issued, want %d", len(issued), registrations)
	}

	seen := map[string]bool{}
	for _, mrn := range issued {
		if seen[mrn] {
			t.Fatalf("MRN %q was issued twice", mrn)
		}
		seen[mrn] = true
	}
}

// SRS-EMPI-003. The control is that a probable duplicate blocks registration
// until somebody has looked at it — otherwise search-before-create is a
// courtesy the busy desk skips.
func TestAProbableDuplicateBlocksRegistrationUntilAcknowledged(t *testing.T) {
	h := newEmpiHarness(t)
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	first := h.mustRegister(t, h.clerkToken(), d)

	again, err := h.register(t, h.clerkToken(), d)
	if err != nil {
		t.Fatalf("second registration: %v", err)
	}
	if again != nil {
		t.Fatal("the same patient was registered twice without review")
	}

	// Acknowledging it — the clerk has seen the candidate and says this is a
	// different person — lets it through. Twins exist.
	second := h.mustRegister(t, h.clerkToken(), d, first.GetPatientId())
	if second.GetPatientId() == first.GetPatientId() {
		t.Fatal("the second registration returned the first patient")
	}
}

// The refusal carries the candidates. A client cannot acknowledge what it has
// not been shown, and making it search again would be a second round trip for
// data the server already read.
func TestTheDuplicateRefusalShowsWhatToReview(t *testing.T) {
	h := newEmpiHarness(t)
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	first := h.mustRegister(t, h.clerkToken(), d)

	resp, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{Demographics: d}))
	if err != nil {
		t.Fatalf("the duplicate outcome came back as an error, which discards the body: %v", err)
	}
	if resp.Msg.GetPatient() != nil {
		t.Fatal("the duplicate was registered")
	}

	duplicates := resp.Msg.GetPotentialDuplicates()
	if len(duplicates) == 0 {
		t.Fatal("no candidates were returned with the refusal")
	}
	if duplicates[0].GetPatient().GetPatientId() != first.GetPatientId() {
		t.Fatalf("the candidate is not the existing patient: %+v", duplicates[0])
	}
	if duplicates[0].GetConfidence() <= 0 {
		t.Fatal("the candidate carries no confidence")
	}
	// SRS-EMPI-003 requires duplicates "shown with confidence". A bare number
	// is not reviewable: the clerk needs to see which fields agreed.
	if len(duplicates[0].GetFields()) == 0 {
		t.Fatal("the candidate carries no field breakdown")
	}
}

// "Protected fields masked by role". A clerk comparing duplicates is being
// shown somebody else's record — enough to compare, not enough to use the
// screen as a directory.
func TestDuplicateCandidatesAreMaskedForAClerkAndNotForHIM(t *testing.T) {
	h := newEmpiHarness(t)
	d := demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210")

	h.mustRegister(t, h.clerkToken(), d)

	clerkView, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{Name: "Iyer"}))
	if err != nil {
		t.Fatalf("SearchPatients as clerk: %v", err)
	}
	if len(clerkView.Msg.GetMatches()) == 0 {
		t.Fatal("the clerk found nobody")
	}
	match := clerkView.Msg.GetMatches()[0]
	if !match.GetMasked() {
		t.Fatal("the clerk's view is not marked as masked")
	}

	phones := match.GetPatient().GetDemographics().GetPhones()
	if len(phones) == 0 {
		t.Fatal("the phone was removed entirely; a clerk cannot confirm the number the patient read out")
	}
	if phones[0].GetValue() == "9876543210" {
		t.Fatal("the clerk sees the unmasked phone number")
	}
	if !strings.HasSuffix(phones[0].GetValue(), "3210") {
		t.Fatalf("the masked phone %q keeps nothing to compare against", phones[0].GetValue())
	}
	// The name stays: it is what the clerk is comparing, and masking it would
	// push them to open the full record instead — disclosing more, not less.
	if match.GetPatient().GetDemographics().GetName().GetFamily() != "Iyer" {
		t.Fatal("the name was masked, which makes the duplicate screen useless")
	}

	himView, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SearchPatientsRequest{Name: "Iyer"}))
	if err != nil {
		t.Fatalf("SearchPatients as HIM: %v", err)
	}
	himMatch := himView.Msg.GetMatches()[0]
	if himMatch.GetMasked() {
		t.Fatal("HIM sees a masked record, and cannot decide a merge on it")
	}
	if himMatch.GetPatient().GetDemographics().GetPhones()[0].GetValue() != "9876543210" {
		t.Fatal("HIM does not see the full phone number")
	}
}

// A clinician reads a chart to treat somebody and does not administer the
// index.
func TestAClinicianCannotRegisterAPatient(t *testing.T) {
	h := newEmpiHarness(t)

	_, err := h.register(t, h.clinicianToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))
	if err == nil {
		t.Fatal("a clinician registered a patient")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want PermissionDenied", got)
	}
}

// An unfiltered search is a request for the tenant's whole register. It has no
// legitimate caller.
func TestAnUnfilteredSearchIsRefused(t *testing.T) {
	h := newEmpiHarness(t)

	_, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{}))
	if err == nil {
		t.Fatal("an unfiltered search was accepted")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("code = %v, want InvalidArgument", got)
	}
}

// SRS-EMPI-001: the minimum demographic set is enforced, and the refusal says
// the data is incomplete rather than malformed — a different thing for a UI to
// show.
func TestRegistrationEnforcesTheDemographicMinimum(t *testing.T) {
	h := newEmpiHarness(t)

	_, err := h.register(t, h.clerkToken(), &empiv1.Demographics{
		Name: &empiv1.HumanName{Given: []string{"Meera"}},
		Sex:  empiv1.Sex_SEX_FEMALE,
	})
	if err == nil {
		t.Fatal("a patient with no family name was registered under the default policy")
	}
	if got := connectCode(err); got != connect.CodeFailedPrecondition {
		t.Fatalf("code = %v, want FailedPrecondition", got)
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_DEMOGRAPHICS_INCOMPLETE" {
		t.Fatalf("the error does not identify the incomplete field set: %v", err)
	}
}

// A client-supplied MRN would let a caller choose a value the facility's
// sequence never allocated, and two patients could then hold one number.
func TestAClientSuppliedMRNIsRefused(t *testing.T) {
	h := newEmpiHarness(t)

	_, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""),
			Identifiers: []*empiv1.PatientIdentifier{{
				Type:   empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
				System: "facility:" + h.facility, Value: "MRN-000001",
			}},
		}))
	if err == nil {
		t.Fatal("a client-supplied MRN was accepted")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("code = %v, want InvalidArgument", got)
	}
}

// Tenant isolation, at the patient index. Milestone 2 proved it for
// organization master data; a patient record is where it actually matters.
//
// The neighbour is a fully provisioned tenant — its own facility, its own
// module entitlement, its own MRN sequence — because a half-provisioned one
// would be refused by the entitlement interceptor before the isolation
// predicate was ever reached, and the test would pass without proving anything.
func TestPatientsAreInvisibleAcrossTenants(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	neighbour := h.provisionNeighbour(t)

	_, err := h.patients.GetPatient(context.Background(),
		withFacility(neighbour.clerkToken(), neighbour.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err == nil {
		t.Fatal("another tenant read this patient")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: the latter confirms the
	// identifier exists, which is a probe a neighbouring hospital can run
	// against a UUID it guessed or saw in a log.
	if got := connectCode(err); got != connect.CodeNotFound {
		t.Fatalf("code = %v, want NotFound — PermissionDenied would confirm the patient exists", got)
	}

	search, err := h.patients.SearchPatients(context.Background(),
		withFacility(neighbour.clerkToken(), neighbour.facility,
			&empiv1.SearchPatientsRequest{Name: "Iyer"}))
	if err != nil {
		t.Fatalf("SearchPatients as the neighbouring tenant: %v", err)
	}
	if len(search.Msg.GetMatches()) != 0 {
		t.Fatalf("another tenant's search returned %d patients", len(search.Msg.GetMatches()))
	}

	// And the neighbour's own register works, so the isolation above is the
	// tenant predicate rather than a broken second tenant.
	mine, err := h.patients.RegisterPatient(context.Background(),
		withFacility(neighbour.clerkToken(), neighbour.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
		}))
	if err != nil {
		t.Fatalf("the neighbouring tenant cannot register at all: %v", err)
	}
	// The identical patient is not a duplicate here: it is in another tenant,
	// and duplicate detection must not reach across one.
	if mine.Msg.GetPatient() == nil {
		t.Fatal("duplicate detection matched a patient in another tenant")
	}
}

// A correction against a stale version is refused rather than applied, because
// two clerks at one desk correcting the same record is routine and last-write
// -wins silently discards one of them.
func TestAStaleCorrectionIsRefused(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	update := func(version int64, family string) error {
		_, err := h.patients.UpdateDemographics(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.UpdateDemographicsRequest{
				PatientId: patient.GetPatientId(),
				Demographics: demographics(family, []string{"Meera"},
					date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""),
				ExpectedVersion: version,
			}))
		return err
	}

	if err := update(patient.GetVersion(), "Rao"); err != nil {
		t.Fatalf("first correction: %v", err)
	}
	if err := update(patient.GetVersion(), "Sharma"); err == nil {
		t.Fatal("a correction against a stale version was applied")
	} else if got := connectCode(err); got != connect.CodeFailedPrecondition {
		t.Fatalf("code = %v, want FailedPrecondition", got)
	}
}

// Search by MRN: the clerk types the number from a card and reaches the
// patient without fuzzy matching everyone who shares a surname.
func TestSearchByMRNFindsThePatient(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	var mrn string
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i.GetValue()
		}
	}

	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			IdentifierValue: mrn,
			IdentifierType:  empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}
	if len(found.Msg.GetMatches()) != 1 {
		t.Fatalf("MRN search returned %d matches, want 1", len(found.Msg.GetMatches()))
	}
	if found.Msg.GetMatches()[0].GetPatient().GetPatientId() != patient.GetPatientId() {
		t.Fatal("the MRN search returned the wrong patient")
	}
}

// Confirming identity is the step that turns a candidate into a confirmed
// record, and it belongs to somebody who saw a document.
func TestConfirmingIdentityActivatesTheRecord(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	confirmed, err := h.patients.ConfirmIdentity(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ConfirmIdentityRequest{
			PatientId: patient.GetPatientId(), ExpectedVersion: patient.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ConfirmIdentity: %v", err)
	}
	if confirmed.Msg.GetPatient().GetStatus() != empiv1.PatientStatus_PATIENT_STATUS_ACTIVE {
		t.Fatalf("status = %v, want active", confirmed.Msg.GetPatient().GetStatus())
	}
}

// Registration emits the event downstream contexts wait for (SRS-EMPI-018),
// and the event carries identifiers rather than demographics: an event stream
// is read by more systems than a record is.
func TestRegistrationEmitsAPatientCreatedEvent(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	var eventType, payload string
	err := h.pool.QueryRow(context.Background(),
		`SELECT event_type, payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'patient.created'`,
		patient.GetPatientId()).Scan(&eventType, &payload)
	if err != nil {
		t.Fatalf("no patient.created event was written: %v", err)
	}

	if strings.Contains(payload, "Iyer") || strings.Contains(payload, "9876543210") {
		t.Fatalf("the event carries demographics: %s", payload)
	}
	if !strings.Contains(payload, "MRN-") {
		t.Fatalf("the event carries no MRN, which downstream contexts print on labels: %s", payload)
	}
}

// Every read of a patient record is audited. Who looked at a chart is itself a
// regulated question (SRS-SEC-004).
func TestReadingAPatientIsAudited(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		})); err != nil {
		t.Fatalf("GetPatient: %v", err)
	}

	var actor, purpose string
	err := h.pool.QueryRow(context.Background(),
		`SELECT actor_id, purpose_of_use FROM platform_data.audit_record
		 WHERE resource_id = $1 AND action = 'empi.patient.read' AND outcome = 'success'`,
		patient.GetPatientId()).Scan(&actor, &purpose)
	if err != nil {
		t.Fatalf("the read was not audited: %v", err)
	}
	if actor != "doctor-1" {
		t.Fatalf("the audit names actor %q", actor)
	}
	// A clinician's purpose is treatment, and it lands in the trail — which is
	// what distinguishes a clinician reading a chart from an administrator
	// doing so.
	if purpose != string(authctx.PurposeTreatment) {
		t.Fatalf("purpose_of_use = %q, want treatment", purpose)
	}
}

// The search terms are NOT audited. A search for "Iyer" is a search for a
// person, and storing the query would make the audit trail a second copy of
// the patient index — outside every masking rule.
func TestSearchTermsAreNotWrittenToTheAuditTrail(t *testing.T) {
	h := newEmpiHarness(t)

	h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))
	if _, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			Name: "Iyer",
		})); err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}

	var auditContext string
	err := h.pool.QueryRow(context.Background(),
		`SELECT context::text FROM platform_data.audit_record
		 WHERE resource_type = 'patient_search' LIMIT 1`).Scan(&auditContext)
	if err != nil {
		t.Fatalf("the search was not audited at all: %v", err)
	}
	if strings.Contains(auditContext, "Iyer") {
		t.Fatalf("the audit trail stores the search terms: %s", auditContext)
	}
	if !strings.Contains(auditContext, "results") {
		t.Fatalf("the audit records no result count, so a reviewer cannot tell a lookup from an enumeration: %s", auditContext)
	}
}

func date(year int, month time.Month, day int) time.Time {
	return time.Date(year, month, day, 0, 0, 0, 0, time.UTC)
}
