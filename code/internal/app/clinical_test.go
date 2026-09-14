package app_test

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1/clinicalv1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
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

// The clinical record (SRS-CLN-001 … SRS-CLN-024).
//
// The rule this file exists to prove is SRS-CLN-008's: signed content cannot be
// edited in place. A clinical record is read by people making decisions and by
// people investigating decisions, and both need to see what was believed at the
// time rather than what somebody later wished had been written.

type clnHarness struct {
	pool       *pgxpool.Pool
	clinical   clinicalv1connect.ClinicalServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	tenantID   string
	facility   string
}

func newClnHarness(t *testing.T) *clnHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier, Blobs: testBlobs(t),
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &clnHarness{
		pool:       pool,
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
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "encounter", "clinical"} {
		h.entitle(t, module)
	}
	return h
}

func (h *clnHarness) entitle(t *testing.T, module string) {
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

func (h *clnHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *clnHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *clnHarness) otherClinicianToken() string {
	return h.tenantID + ":doctor-2:clinician:" + h.facility
}

// chart registers a patient, opens an encounter and returns both.
func (h *clnHarness) chart(t *testing.T, family, phone string) (string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			AttendingProviderId: "doctor-1", Reason: "chest pain",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

func clnCode(system, code, display string) *clinicalv1.Coding {
	return &clinicalv1.Coding{
		System: system, Version: "2019", Code: code, Display: display,
	}
}

func clnSections(text string) []*clinicalv1.Section {
	return []*clinicalv1.Section{{Heading: "Impression", Text: text}}
}

// draft writes a draft note and returns it.
func (h *clnHarness) draft(t *testing.T, patient, encounter, text string) *clinicalv1.Document {
	t.Helper()

	written, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			Title: "Ward round", Sections: clnSections(text),
			Confidentiality: clinicalv1.Confidentiality_CONFIDENTIALITY_NORMAL,
		}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}
	return written.Msg.GetDocument()
}

// SRS-CLN-008: "signed content cannot be edited in-place".
func TestASignedNoteCannotBeEditedInPlace(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	document := h.draft(t, patient, encounter, "Improving. Continue treatment.")

	// A draft is editable — that is what a draft is for.
	if _, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			DocumentId: document.GetDocumentId(), Title: "Ward round",
			Sections: clnSections("Improving, for discharge."),
		})); err != nil {
		t.Fatalf("revising a draft was refused: %v", err)
	}

	signed, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
			Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
		}))
	if err != nil {
		t.Fatalf("SignNote: %v", err)
	}
	if signed.Msg.GetDocument().GetStatus() !=
		clinicalv1.DocumentStatus_DOCUMENT_STATUS_SIGNED {
		t.Fatalf("status = %v, want signed", signed.Msg.GetDocument().GetStatus())
	}

	_, err = h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			DocumentId: document.GetDocumentId(), Title: "Ward round",
			Sections: clnSections("Actually deteriorating."),
		}))
	if err == nil {
		t.Fatal("a signed note was edited in place")
	}
}

// SRS-CLN-009: "signature metadata and content hash/version retained".
func TestASignaturePinsWhatWasSigned(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	document := h.draft(t, patient, encounter, "Improving. Continue treatment.")

	signed, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
			Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
		}))
	if err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	signatures := signed.Msg.GetDocument().GetSignatures()
	if len(signatures) != 1 {
		t.Fatalf("%d signatures, want 1", len(signatures))
	}
	if signatures[0].GetContentHash() == "" {
		t.Fatal("the signature pins nothing, so it says only that somebody signed " +
			"something called note 47")
	}
	if signatures[0].GetSubjectId() != "doctor-1" {
		t.Fatal("the signature is not attributed to the authenticated clinician")
	}
	if !signed.Msg.GetDocument().GetIntact() {
		t.Fatal("a freshly signed document does not match its own signature")
	}
}

// A trainee's note countersigned by a consultant is the commonest case and the
// one that matters in a complaint.
func TestASignatureRecordsWhatItAsserts(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	document := h.draft(t, patient, encounter, "Seen with the registrar.")

	if _, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
			Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
		})); err != nil {
		t.Fatalf("SignNote (author): %v", err)
	}

	cosigned, err := h.clinical.SignNote(context.Background(),
		withFacility(h.otherClinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
			Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_COSIGNER,
		}))
	if err != nil {
		t.Fatalf("SignNote (cosigner): %v", err)
	}

	meanings := map[string]clinicalv1.SignatureMeaning{}
	for _, s := range cosigned.Msg.GetDocument().GetSignatures() {
		meanings[s.GetSubjectId()] = s.GetMeaning()
	}
	if meanings["doctor-1"] != clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR ||
		meanings["doctor-2"] != clinicalv1.SignatureMeaning_SIGNATURE_MEANING_COSIGNER {
		t.Fatalf("signatures = %+v, want an author and a cosigner", meanings)
	}
}

// Signing asserts clinical responsibility rather than data entry: a ward clerk
// typing a dictated note saves the draft and must not be able to finalise it.
func TestAClerkCanTypeANoteButNotSignIt(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	written, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clerkToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			Title: "Dictated", Sections: clnSections("Transcribed from dictation."),
			Dictated: true,
		}))
	if err != nil {
		t.Fatalf("a clerk could not save a dictated draft: %v", err)
	}

	_, err = h.clinical.SignNote(context.Background(),
		withFacility(h.clerkToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: written.Msg.GetDocument().GetDocumentId(),
			Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
		}))
	if err == nil {
		t.Fatal("a registration clerk signed a clinical note")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "permission") {
		t.Fatalf("the refusal is not a permission one: %v", err)
	}
}

// SRS-CLN-008: an amendment replaces, an addendum extends. Collapsing the two
// would make every late result read as a correction.
func TestAnAmendmentAndAnAddendumAreDifferentThings(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	document := h.draft(t, patient, encounter, "Improving. Continue treatment.")

	if _, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
		})); err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	// An amendment with no reason is indistinguishable from a rewrite.
	if _, err := h.clinical.AmendNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.AmendNoteRequest{
			DocumentId: document.GetDocumentId(), Title: "Ward round",
			Sections: clnSections("Corrected."),
		})); err == nil {
		t.Fatal("a signed note was amended with no stated reason")
	}

	amended, err := h.clinical.AmendNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.AmendNoteRequest{
			DocumentId: document.GetDocumentId(), Title: "Ward round",
			Sections: clnSections("Corrected: troponin was normal."),
			Reason:   "the initial result was transcribed from the wrong patient",
		}))
	if err != nil {
		t.Fatalf("AmendNote: %v", err)
	}
	if amended.Msg.GetDocument().GetAmendsId() != document.GetDocumentId() {
		t.Fatal("the amendment does not chain back to the original")
	}

	addendum, err := h.clinical.AmendNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.AmendNoteRequest{
			DocumentId: document.GetDocumentId(), Title: "Ward round",
			Sections: clnSections("Blood culture positive, reported overnight."),
			Addendum: true,
		}))
	if err != nil {
		t.Fatalf("AmendNote (addendum): %v", err)
	}
	if addendum.Msg.GetDocument().GetAddsToId() != document.GetDocumentId() {
		t.Fatal("the addendum does not chain back to the original")
	}
	if addendum.Msg.GetDocument().GetStatus() !=
		clinicalv1.DocumentStatus_DOCUMENT_STATUS_ADDENDUM {
		t.Fatal("an addendum was recorded as an amendment, so a late result reads " +
			"as a correction")
	}

	// The original stays readable: somebody made a decision from it.
	original, err := h.clinical.GetNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.GetNoteRequest{
			DocumentId: document.GetDocumentId(),
		}))
	if err != nil {
		t.Fatalf("GetNote: %v", err)
	}
	if original.Msg.GetDocument().GetSections()[0].GetText() !=
		"Improving. Continue treatment." {
		t.Fatal("amending the note changed the version somebody already read")
	}
}

// SRS-CLN-002: "saved note references exact template version".
func TestANoteRecordsItsTemplateVersionAndARetiredOneCannotBeChosen(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	templateID := uuid.NewString()
	for _, version := range []string{"1", "2"} {
		if _, err := h.clinical.DefineTemplate(context.Background(),
			as(tenantAdminToken(h.tenantID), &clinicalv1.DefineTemplateRequest{
				Template: &clinicalv1.Template{
					TemplateId: templateID, Name: "Ward round", Version: version,
					Kind:     clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
					Sections: []string{"Impression", "Plan"},
				},
			})); err != nil {
			t.Fatalf("DefineTemplate v%s: %v", version, err)
		}
	}

	written, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			TemplateId: templateID, TemplateVersion: "2",
			Title: "Ward round", Sections: clnSections("Stable."),
		}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}
	if written.Msg.GetDocument().GetTemplateVersion() != "2" {
		t.Fatal("the note does not record which template version it answered")
	}

	// A version with no template reference is refused: a chart review that
	// assumed today's template would report omissions nobody was asked for.
	if _, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			TemplateId: templateID,
			Title:      "Ward round", Sections: clnSections("Stable."),
		})); err == nil {
		t.Fatal("a note referenced a template with no version")
	}

	if _, err := h.clinical.RetireTemplate(context.Background(),
		as(tenantAdminToken(h.tenantID), &clinicalv1.RetireTemplateRequest{
			TemplateId: templateID, Version: "1",
		})); err != nil {
		t.Fatalf("RetireTemplate: %v", err)
	}

	// A retired template asks questions the hospital has decided are the wrong
	// ones.
	_, err = h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:       clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			TemplateId: templateID, TemplateVersion: "1",
			Title: "Ward round", Sections: clnSections("Stable."),
		}))
	if err == nil {
		t.Fatal("a note was composed against a retired template version")
	}
	if !strings.Contains(err.Error(), "retired") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// SRS-CLN-015: "user-visible expansion and no hidden clinical text".
func TestSmartPhrasesAreExpandedIntoTheStoredNote(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	if _, err := h.clinical.DefineSmartPhrase(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.DefineSmartPhraseRequest{
				Shortcut:  "normalcvs",
				Expansion: "Heart sounds I and II, no murmur. Pulse regular.",
			})); err != nil {
		t.Fatalf("DefineSmartPhrase: %v", err)
	}

	// A shortcut stored with its marker would only ever match "..normalcvs".
	if _, err := h.clinical.DefineSmartPhrase(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&clinicalv1.DefineSmartPhraseRequest{
				Shortcut: ".normalresp", Expansion: "Chest clear.",
			})); err == nil {
		t.Fatal("a shortcut was stored with its leading dot")
	}

	written, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:     clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			Title:    "Ward round",
			Sections: clnSections("On examination: .normalcvs No oedema."),
		}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}

	stored := written.Msg.GetDocument().GetSections()[0].GetText()
	if strings.Contains(stored, ".normalcvs") {
		t.Fatalf("a shortcut survived into the stored note: %q", stored)
	}
	if !strings.Contains(stored, "no murmur") {
		t.Fatalf("the expansion is missing from the stored note: %q", stored)
	}
}

// SRS-CLN-019: an ordinary clinician does not see a restricted note, and its
// existence is not confirmed.
func TestARestrictedNoteIsNotVisibleWithoutThePermission(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	restricted, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_CONSULTATION_NOTE,
			Title: "Mental health review", Sections: clnSections("Confidential."),
			Confidentiality: clinicalv1.Confidentiality_CONFIDENTIALITY_VERY_RESTRICTED,
		}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}

	// A clerk holds cln.record.write but not cln.record.read, so they cannot
	// read anything back — restricted or not.
	if _, err := h.clinical.GetNote(context.Background(),
		withFacility(h.clerkToken(), h.facility, &clinicalv1.GetNoteRequest{
			DocumentId: restricted.Msg.GetDocument().GetDocumentId(),
		})); err == nil {
		t.Fatal("a registration clerk read a clinical note")
	}

	// The clinician who holds read_restricted can.
	if _, err := h.clinical.GetNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.GetNoteRequest{
			DocumentId: restricted.Msg.GetDocument().GetDocumentId(),
		})); err != nil {
		t.Fatalf("a clinician with read_restricted could not read it: %v", err)
	}

	// And the read is explicitly audited (SRS-CLN-019).
	var reason string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT reason FROM platform_data.audit_record
		 WHERE resource_id = $1 AND reason LIKE 'restricted note read%'`,
		restricted.Msg.GetDocument().GetDocumentId()).Scan(&reason); err != nil {
		t.Fatalf("the restricted read was not explicitly audited: %v", err)
	}
}

// SRS-CLN-017: four charts open, the wrong tab in front, a note for the patient
// in the next bed.
func TestThePatientContextLockCatchesTheWrongChart(t *testing.T) {
	h := newClnHarness(t)
	hers, herEncounter := h.chart(t, "Iyer", "9876543210")
	his, _ := h.chart(t, "Nair", "9876543211")

	_, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: hers, EncounterId: herEncounter,
			Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			Title: "Ward round", Sections: clnSections("Stable."),
			// The clinician believes they are in the other patient's chart.
			Context: &clinicalv1.PatientContext{
				PatientId: his, OpenedAt: timestamppb.New(time.Now()),
			},
		}))
	if err == nil {
		t.Fatal("a note landed on a different patient from the one the clinician " +
			"believed was on screen")
	}
	if !strings.Contains(err.Error(), "which chart you are in") {
		t.Fatalf("the refusal does not tell the clinician what to check: %v", err)
	}
	// The message must not leak the other patient's identifier onto a screen
	// belonging to this one.
	if strings.Contains(err.Error(), hers) || strings.Contains(err.Error(), his) {
		t.Fatalf("the refusal leaks a patient identifier: %v", err)
	}
}

// A note cannot be written into a closed encounter: the route is an amendment.
func TestAClosedEncounterTakesNoNewNote(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	// Complete and close the encounter.
	if _, err := h.encounters.RecordDiagnosis(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.RecordDiagnosisRequest{
			EncounterId: encounter,
			Code: &encounterv1.Coding{
				System: "icd-10", Version: "2019", Code: "I21.9",
				Display: "Acute myocardial infarction",
			},
			Certainty: encounterv1.DiagnosisCertainty_DIAGNOSIS_CERTAINTY_FINAL,
			Rank:      encounterv1.DiagnosisRank_DIAGNOSIS_RANK_PRIMARY,
		})); err != nil {
		t.Fatalf("RecordDiagnosis: %v", err)
	}
	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter,
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}
	if _, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter, Narrative: "Seen and treated.",
		})); err != nil {
		t.Fatalf("CloseEncounter: %v", err)
	}

	_, err := h.clinical.WriteNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.WriteNoteRequest{
			PatientId: patient, EncounterId: encounter,
			Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_PROGRESS_NOTE,
			Title: "Afterthought", Sections: clnSections("One more thing."),
		}))
	if err == nil {
		t.Fatal("a note was written into a closed encounter")
	}
	if !strings.Contains(err.Error(), "no longer accepts") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// SRS-ENC-008 across the seam: the closure gate reads the clinical record.
func TestTheClosureGateSeesASignedNote(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	// This facility requires a signed note for an outpatient encounter.
	if _, err := h.encounters.SetClosurePolicy(context.Background(),
		as(tenantAdminToken(h.tenantID), &encounterv1.SetClosurePolicyRequest{
			FacilityId: h.facility,
			Classes: []*encounterv1.ClosurePolicyForClass{{
				Class:         encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
				RequiredItems: []string{"signed_note", "end_time"},
			}},
		})); err != nil {
		t.Fatalf("SetClosurePolicy: %v", err)
	}

	if _, err := h.encounters.EndEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.EndEncounterRequest{
			EncounterId: encounter,
		})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	// No signed note, so the closure is blocked.
	_, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter, Narrative: "Seen.",
		}))
	if err == nil {
		t.Fatal("an encounter with no signed note was closed against a policy " +
			"that requires one")
	}
	if !strings.Contains(err.Error(), "sign a clinical note") {
		t.Fatalf("the refusal does not name the missing item: %v", err)
	}

	document := h.draft(t, patient, encounter, "Seen and reassured.")
	if _, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
		})); err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	if _, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter, Narrative: "Seen and reassured.",
		})); err != nil {
		t.Fatalf("the closure gate did not see the signed note: %v", err)
	}
}

// SRS-CLN-024: "clinical_document.signed ... contain minimum necessary data".
func TestSigningEmitsAnEventCarryingNoClinicalContent(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Venkataraghavan", "9876543210")
	document := h.draft(t, patient, encounter,
		"Troponin raised. Admit under cardiology.")

	if _, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
		})); err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'clinical_document.signed'`,
		document.GetDocumentId()).Scan(&payload); err != nil {
		t.Fatalf("no clinical_document.signed event was written: %v", err)
	}

	if strings.Contains(payload, "Troponin") ||
		strings.Contains(payload, "Venkataraghavan") {
		t.Fatalf("the event carries clinical or demographic content: %s", payload)
	}
	// The hash travels so a consumer can verify what was signed without
	// reading it.
	if !strings.Contains(payload, "content_hash") {
		t.Fatalf("the event does not carry the content hash: %s", payload)
	}
}

// A note cannot be read across a tenant boundary.
func TestANoteCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	document := h.draft(t, patient, encounter, "Stable. Discharge tomorrow.")

	if _, err := h.clinical.SignNote(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.SignNoteRequest{
			DocumentId: document.GetDocumentId(),
		})); err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	other := newClnHarness(t)
	_, err := other.clinical.GetNote(context.Background(),
		withFacility(other.clinicianToken(), other.facility, &clinicalv1.GetNoteRequest{
			DocumentId: document.GetDocumentId(),
		}))
	if err == nil {
		t.Fatal("another tenant's note is readable")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists in somebody else's tenant.
	if !strings.Contains(strings.ToLower(err.Error()), "not_found") &&
		!strings.Contains(strings.ToLower(err.Error()), "no such") {
		t.Fatalf("the refusal confirms the note exists elsewhere: %v", err)
	}
}

// SRS-CLN-014. The server holds the bytes and derives the metadata, so the
// attachment record describes content the server has actually seen. It used to
// take the storage key, the size and the digest from the caller — which made
// the digest, the one field a reader trusts to say the content has not been
// altered, an assertion by whoever supplied the content.
func TestAnAttachedFileIsStoredByTheServerAndDescribedByWhatItStored(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Rao", "9876500011")
	note := h.draft(t, patient, encounter, "outside imaging report received")

	pdf := []byte("%PDF-1.7 outside hospital discharge summary")
	attached, err := h.clinical.AttachFile(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.AttachFileRequest{
			ParentType: "document", ParentId: note.GetDocumentId(),
			PatientId: patient, Kind: clinicalv1.AttachmentKind_ATTACHMENT_KIND_DOCUMENT,
			ContentType: "application/pdf", Content: pdf,
			Description: "discharge summary, District Hospital",
		}))
	if err != nil {
		t.Fatalf("AttachFile: %v", err)
	}

	attachment := attached.Msg.GetAttachment()
	if attachment.GetSizeBytes() != int64(len(pdf)) {
		t.Errorf("size_bytes = %d, want %d", attachment.GetSizeBytes(), len(pdf))
	}
	sum := sha256.Sum256(pdf)
	if attachment.GetDigest() != hex.EncodeToString(sum[:]) {
		t.Errorf("digest = %q; it does not describe the content that was sent", attachment.GetDigest())
	}
	// The key is the store's, and it is not a filename, a patient identifier or
	// anything else that would be a disclosure in the log line that carries it.
	key := attachment.GetStorageKey()
	if key == "" {
		t.Fatal("no storage key was recorded")
	}
	if strings.Contains(key, patient) || strings.Contains(key, "discharge") {
		t.Errorf("the storage key leaks what it points at: %q", key)
	}

	listed, err := h.clinical.ListAttachments(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &clinicalv1.ListAttachmentsRequest{
			ParentType: "document", ParentId: note.GetDocumentId(),
		}))
	if err != nil {
		t.Fatalf("ListAttachments: %v", err)
	}
	if len(listed.Msg.GetAttachments()) != 1 {
		t.Fatalf("listed %d attachments, want 1", len(listed.Msg.GetAttachments()))
	}
	if listed.Msg.GetAttachments()[0].GetStorageKey() != key {
		t.Error("the attachment came back pointing somewhere else")
	}
}

// A caller-supplied storage key is a caller-supplied path: it can address
// another tenant's object, something outside the store, or nothing at all, and
// the record would still read as complete. Refused rather than ignored, so a
// client that still believes it placed the bytes itself is told.
func TestACallerCannotChooseWhereAnAttachmentPoints(t *testing.T) {
	h := newClnHarness(t)
	patient, encounter := h.chart(t, "Rao", "9876500011")
	note := h.draft(t, patient, encounter, "outside imaging report received")

	base := func() *clinicalv1.AttachFileRequest {
		return &clinicalv1.AttachFileRequest{
			ParentType: "document", ParentId: note.GetDocumentId(),
			PatientId: patient, Kind: clinicalv1.AttachmentKind_ATTACHMENT_KIND_DOCUMENT,
			ContentType: "application/pdf", Content: []byte("%PDF-1.7"),
		}
	}

	withKey := base()
	withKey.StorageKey = "local:other-tenant/clinical-attachment/aaaa/" + strings.Repeat("0", 64)
	if _, err := h.clinical.AttachFile(context.Background(),
		withFacility(h.clinicianToken(), h.facility, withKey)); err == nil {
		t.Fatal("a caller-supplied storage key was accepted")
	}

	withDigest := base()
	withDigest.Digest = strings.Repeat("0", 64)
	if _, err := h.clinical.AttachFile(context.Background(),
		withFacility(h.clinicianToken(), h.facility, withDigest)); err == nil {
		t.Fatal("a caller-supplied digest was accepted")
	}

	empty := base()
	empty.Content = nil
	if _, err := h.clinical.AttachFile(context.Background(),
		withFacility(h.clinicianToken(), h.facility, empty)); err == nil {
		t.Fatal("an attachment with no content was accepted")
	}

	// The class allowlist reaches this path too: an executable dressed as a
	// referral letter is not a referral letter.
	wrongType := base()
	wrongType.ContentType = "application/x-msdownload"
	if _, err := h.clinical.AttachFile(context.Background(),
		withFacility(h.clinicianToken(), h.facility, wrongType)); err == nil {
		t.Fatal("a content type outside the class allowlist was accepted")
	}
}
