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
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	recordsv1 "github.com/ppusapati/health/code/gen/go/healthcare/records/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/records/v1/recordsv1connect"
	"github.com/ppusapati/health/code/internal/app"
	encounterdomain "github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	recordsapp "github.com/ppusapati/health/code/internal/records/application"
	recordsdomain "github.com/ppusapati/health/code/internal/records/domain"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Medical records and health information management (SRS-MRD-001 … 010), end
// to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a chart's gaps are
// derived from the documents a clinician actually signed rather than from a
// copy this context keeps, that the records office cannot waive the
// deficiencies it raises or approve the releases it requests, that a coding
// correction adds a revision the previous one survives, that a release
// package is exactly what the approved scope allowed and is answerable
// document by document afterwards, and — the one this family exists for —
// that nothing in health information management can alter what a clinician
// wrote.

type mrdHarness struct {
	pool       *pgxpool.Pool
	records    recordsv1connect.RecordsServiceClient
	clinical   clinicalv1connect.ClinicalServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newMrdHarness(t *testing.T) *mrdHarness {
	return newMrdHarnessWith(t, recordsapp.Config{
		DeficiencyGrace: 48 * time.Hour,
		AgingBands: []recordsdomain.AgeBucket{
			{From: 0, To: 7, Label: "0-7 days"},
			{From: 8, To: 30, Label: "8-30 days"},
			{From: 31, Label: "over 30 days"},
		},
		DefaultJurisdiction:     "IN",
		RestrictedDocumentKinds: []string{"psychiatry_note"},
		CodingSystems:           map[string]string{"icd-10": "2026"},
	})
}

func newMrdHarnessWith(t *testing.T, config recordsapp.Config) *mrdHarness {
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
		Records: config,
		// Every facility in this deployment follows one jurisdiction's
		// retention law, which is configuration rather than a fact the
		// encounter context holds.
		RecordsJurisdictions: map[string]string{},
		RecordsHeldClasses:   []string{"mrd_physical_record"},
		// No encounter in these tests had an operation, so the conditional
		// operation-note item never applies. That is the point of it being
		// conditional.
		RecordsConditions: func(encounterdomain.Encounter) map[string]bool {
			return map[string]bool{}
		},
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &mrdHarness{
		pool: pool,
		records: recordsv1connect.NewRecordsServiceClient(
			server.Client(), server.URL),
		clinical: clinicalv1connect.NewClinicalServiceClient(
			server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(
			server.Client(), server.URL),
		patients: empiv1connect.NewPatientServiceClient(
			server.Client(), server.URL),
		org: organizationv1connect.NewOrganizationServiceClient(
			server.Client(), server.URL),
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
		"records", "empi", "encounter", "clinical",
	} {
		h.entitleMrd(t, module)
	}
	return h
}

func (h *mrdHarness) entitleMrd(t *testing.T, module string) {
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

func (h *mrdHarness) officerToken() string {
	return h.tenantID + ":him-1:him_officer:" + h.facility
}

func (h *mrdHarness) managerToken() string {
	return h.tenantID + ":him-boss:him_manager:" + h.facility
}

// otherManagerToken is a second records manager. Two are needed wherever a
// rule is written and put in force, because the domain and the database each
// refuse a rule approved by its own author: holding both permissions is
// necessary and never sufficient.
func (h *mrdHarness) otherManagerToken() string {
	return h.tenantID + ":him-deputy:him_manager:" + h.facility
}

func (h *mrdHarness) coderToken() string {
	return h.tenantID + ":coder-1:clinical_coder:" + h.facility
}

func (h *mrdHarness) otherCoderToken() string {
	return h.tenantID + ":coder-2:clinical_coder:" + h.facility
}

func (h *mrdHarness) doctorToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *mrdHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// liveChecklist puts an outpatient checklist in force: a signed discharge
// summary, and an operation note only where there was an operation.
func (h *mrdHarness) liveChecklist(t *testing.T) *recordsv1.ChartChecklist {
	t.Helper()
	ctx := context.Background()

	drafted, err := h.records.DraftChecklist(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.DraftChecklistRequest{
				Code: "OUTPATIENT", Name: "Outpatient chart", Revision: 1,
				EncounterClass: "outpatient",
				Items: []*recordsv1.ChecklistItem{
					{
						Kind: "discharge_summary", Label: "Discharge summary",
						Requirement:      recordsv1.DocumentRequirement_DOCUMENT_REQUIREMENT_SIGNED,
						DueWithinSeconds: int64(24 * time.Hour / time.Second),
					},
					{
						Kind: "operation_note", Label: "Operation note",
						Requirement:   recordsv1.DocumentRequirement_DOCUMENT_REQUIREMENT_CONDITIONAL,
						ConditionCode: "had_operation",
					},
				},
			}))
	if err != nil {
		t.Fatalf("DraftChecklist: %v", err)
	}

	approved, err := h.records.ApproveChecklist(ctx,
		withFacility(h.otherManagerToken(), h.facility,
			&recordsv1.ApproveChecklistRequest{
				ChecklistId: drafted.Msg.GetChecklist().GetChecklistId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ApproveChecklist: %v", err)
	}
	return approved.Msg.GetChecklist()
}

// chart registers a patient and opens an outpatient encounter.
func (h *mrdHarness) chart(t *testing.T, family, phone string) (
	string, string) {

	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility,
			&empiv1.RegisterPatientRequest{
				Demographics: demographics(family, []string{"Meera"},
					date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
			}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.doctorToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
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

// note writes a discharge summary and optionally signs it.
func (h *mrdHarness) note(t *testing.T, patient, encounter string,
	sign bool) *clinicalv1.Document {

	t.Helper()
	ctx := context.Background()

	written, err := h.clinical.WriteNote(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.WriteNoteRequest{
				PatientId: patient, EncounterId: encounter,
				Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_DISCHARGE_SUMMARY,
				Title: "Discharge summary",
				Sections: []*clinicalv1.Section{
					{Heading: "Summary", Text: "Discharged well."},
				},
				Confidentiality: clinicalv1.Confidentiality_CONFIDENTIALITY_NORMAL,
			}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}
	document := written.Msg.GetDocument()
	if !sign {
		return document
	}

	signed, err := h.clinical.SignNote(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.SignNoteRequest{
				DocumentId: document.GetDocumentId(),
				Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
			}))
	if err != nil {
		t.Fatalf("SignNote: %v", err)
	}
	return signed.Msg.GetDocument()
}

// SRS-MRD-001. A chart's gaps are derived from what a clinician actually
// signed, and the version of the rules that judged it is on the answer.
func TestAChartIsJudgedAgainstTheChecklistInForce(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	h.liveChecklist(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	// Nothing written yet: the discharge summary is missing, and the
	// conditional operation note is not, because there was no operation.
	first, err := h.records.GetChartGaps(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.GetChartGapsRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("GetChartGaps: %v", err)
	}
	status := first.Msg.GetStatus()
	if status.GetChecklistCode() != "OUTPATIENT" ||
		status.GetChecklistRevision() != 1 {
		t.Fatalf("judged against %s revision %d",
			status.GetChecklistCode(), status.GetChecklistRevision())
	}
	if len(status.GetGaps()) != 1 {
		t.Fatalf("gaps = %+v, want only the discharge summary",
			status.GetGaps())
	}
	if !status.GetGaps()[0].GetMissing() {
		t.Fatal("a document nobody wrote reads as present but unsigned")
	}

	// Written and not signed: the same item, now a different gap. The two go
	// to different people and a report that conflated them would be wrong
	// about which.
	document := h.note(t, patient, encounter, false)
	second, err := h.records.GetChartGaps(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.GetChartGapsRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("GetChartGaps: %v", err)
	}
	gaps := second.Msg.GetStatus().GetGaps()
	if len(gaps) != 1 || gaps[0].GetMissing() {
		t.Fatalf("gaps = %+v, want one unsigned document", gaps)
	}
	if gaps[0].GetDocumentId() != document.GetDocumentId() {
		t.Fatalf("gap names document %q, want %q",
			gaps[0].GetDocumentId(), document.GetDocumentId())
	}
	if gaps[0].GetOwnerId() != "doctor-1" {
		t.Fatalf("owner = %q, want the author who has not signed",
			gaps[0].GetOwnerId())
	}

	// Signed: no gaps. Derived from the clinical context's own documents, so
	// signing a note is the whole of what closes a deficiency.
	h.note(t, patient, encounter, true)
	third, err := h.records.GetChartGaps(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.GetChartGapsRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("GetChartGaps: %v", err)
	}
	if len(third.Msg.GetStatus().GetGaps()) != 0 {
		t.Fatalf("a signed chart still has gaps: %+v",
			third.Msg.GetStatus().GetGaps())
	}
}

// SRS-MRD-002. The office that raises the worklist cannot empty it, and a
// waiver is never a completion.
func TestTheOfficeThatRaisesDeficienciesCannotWaiveThem(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	h.liveChecklist(t)
	_, encounter := h.chart(t, "Rao", "9876543211")

	raised, err := h.records.RaiseDeficiencies(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.RaiseDeficienciesRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("RaiseDeficiencies: %v", err)
	}
	if len(raised.Msg.GetRaised()) != 1 {
		t.Fatalf("raised %d deficiencies, want 1",
			len(raised.Msg.GetRaised()))
	}
	deficiency := raised.Msg.GetRaised()[0]

	// Running the sweep again raises nothing: a worklist that doubles every
	// time a job runs is one the clinicians it is sent to stop reading.
	again, err := h.records.RaiseDeficiencies(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.RaiseDeficienciesRequest{EncounterId: encounter}))
	if err != nil {
		t.Fatalf("RaiseDeficiencies: %v", err)
	}
	if len(again.Msg.GetRaised()) != 0 {
		t.Fatalf("the second sweep raised %d duplicates",
			len(again.Msg.GetRaised()))
	}

	// The records office cannot waive what it raised.
	_, err = h.records.WaiveDeficiency(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.WaiveDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				Reason:       "the consultant has left",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("a waiver by the records office = %v, want denied", err)
	}

	// Nor can the clinician who owes the document.
	_, err = h.records.WaiveDeficiency(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.WaiveDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				Reason:       "too busy",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("a waiver by the owner = %v, want denied", err)
	}

	waived, err := h.records.WaiveDeficiency(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.WaiveDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				Reason:       "the consultant has left the hospital",
			}))
	if err != nil {
		t.Fatalf("WaiveDeficiency: %v", err)
	}
	if waived.Msg.GetDeficiency().GetState() !=
		recordsv1.DeficiencyState_DEFICIENCY_STATE_WAIVED {
		t.Fatalf("state = %v", waived.Msg.GetDeficiency().GetState())
	}

	// And the encounter is incompletable, never complete. A hospital that
	// counted waivers as completions could reach a hundred per cent by
	// waiving.
	summary, err := h.records.GetCompletionSummary(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.GetCompletionSummaryRequest{
				EncounterIds: []string{encounter},
			}))
	if err != nil {
		t.Fatalf("GetCompletionSummary: %v", err)
	}
	got := summary.Msg.GetSummary()
	if got.GetComplete() != 0 || got.GetIncompletable() != 1 {
		t.Fatalf("complete=%d incompletable=%d, want 0 and 1",
			got.GetComplete(), got.GetIncompletable())
	}
	if got.GetWaived() != 1 {
		t.Fatalf("waived = %d", got.GetWaived())
	}
}

// SRS-MRD-008. A deficiency is answered by a new document, and nothing in
// this context can change the one complained about.
func TestSignedHistoryIsAnsweredAndNeverAltered(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	h.liveChecklist(t)
	patient, encounter := h.chart(t, "Nair", "9876543212")
	signed := h.note(t, patient, encounter, true)

	// A coder reads the signed summary and has a question about it. The only
	// thing coding may produce about somebody else's note is a question.
	query, err := h.records.RaiseCodingQuery(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.RaiseCodingQueryRequest{
				EncounterId: encounter,
				DocumentId:  signed.GetDocumentId(),
				OwnerId:     "doctor-1",
				Detail:      "which organism was cultured?",
				DueBy:       timestamppb.New(time.Now().UTC().Add(48 * time.Hour)),
			}))
	if err != nil {
		t.Fatalf("RaiseCodingQuery: %v", err)
	}
	deficiency := query.Msg.GetDeficiency()

	// The coder cannot answer their own query: that would be writing the
	// clinician's half of the requirement.
	_, err = h.records.ResolveDeficiency(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.ResolveDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				DocumentId:   "addendum-1",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("a coder answering their own query = %v, want denied", err)
	}

	// The clinician answers it with an addendum — a different document.
	addendum := h.note(t, patient, encounter, true)
	resolved, err := h.records.ResolveDeficiency(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.ResolveDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				DocumentId:   addendum.GetDocumentId(),
			}))
	if err != nil {
		t.Fatalf("ResolveDeficiency: %v", err)
	}
	if resolved.Msg.GetDeficiency().GetResolvedByDocumentId() !=
		addendum.GetDocumentId() {
		t.Fatalf("resolution names %q, want the addendum",
			resolved.Msg.GetDeficiency().GetResolvedByDocumentId())
	}

	// The document that was complained about is untouched: same version,
	// same content, still signed. There is no RPC in this whole contract that
	// could have changed it.
	read, err := h.clinical.GetNote(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.GetNoteRequest{
				DocumentId: signed.GetDocumentId(),
			}))
	if err != nil {
		t.Fatalf("GetNote: %v", err)
	}
	if read.Msg.GetDocument().GetVersion() != signed.GetVersion() {
		t.Fatalf("the signed document moved from version %d to %d",
			signed.GetVersion(), read.Msg.GetDocument().GetVersion())
	}
	if read.Msg.GetDocument().GetStatus() !=
		clinicalv1.DocumentStatus_DOCUMENT_STATUS_SIGNED {
		t.Fatalf("status = %v", read.Msg.GetDocument().GetStatus())
	}
}

// SRS-MRD-003. A correction adds a revision, the previous one survives, and
// the second read is a second person.
func TestCodingKeepsEveryRevisionAndNeedsASecondReader(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	_, encounter := h.chart(t, "Menon", "9876543213")

	first, err := h.records.AssignCodes(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.AssignCodesRequest{
				EncounterId: encounter,
				Codes: []*recordsv1.AssignedCode{
					{
						System: "icd-10", Version: "2026", Code: "J18.9",
						Role:               recordsv1.CodeRole_CODE_ROLE_PRINCIPAL_DIAGNOSIS,
						PresentOnAdmission: recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_YES,
					},
				},
			}))
	if err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	episode := first.Msg.GetEpisode()

	// A code in an edition this deployment does not use is refused. A grouper
	// reading the wrong edition produces a number rather than an error.
	_, err = h.records.AssignCodes(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.AssignCodesRequest{
				EncounterId: encounter, Reason: "wrong edition",
				Codes: []*recordsv1.AssignedCode{
					{
						System: "icd-10", Version: "2019", Code: "J18.9",
						Role:               recordsv1.CodeRole_CODE_ROLE_PRINCIPAL_DIAGNOSIS,
						PresentOnAdmission: recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_YES,
					},
				},
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("an out-of-edition code = %v, want invalid", err)
	}

	// The coder cannot sign off their own coding.
	_, err = h.records.FinaliseCoding(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.FinaliseCodingRequest{
				EpisodeId: episode.GetEpisodeId(),
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("self-finalised coding = %v, want refused", err)
	}

	// A correction adds a revision with its reason.
	corrected, err := h.records.AssignCodes(ctx,
		withFacility(h.coderToken(), h.facility,
			&recordsv1.AssignCodesRequest{
				EncounterId: encounter,
				Reason:      "culture confirmed Klebsiella",
				Codes: []*recordsv1.AssignedCode{
					{
						System: "icd-10", Version: "2026", Code: "J15.0",
						Role:               recordsv1.CodeRole_CODE_ROLE_PRINCIPAL_DIAGNOSIS,
						PresentOnAdmission: recordsv1.PresentOnAdmission_PRESENT_ON_ADMISSION_YES,
					},
				},
			}))
	if err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	revisions := corrected.Msg.GetEpisode().GetRevisions()
	if len(revisions) != 2 {
		t.Fatalf("%d revisions, want 2 — a correction must not edit the "+
			"coding that was billed on", len(revisions))
	}
	if revisions[0].GetCodes()[0].GetCode() != "J18.9" {
		t.Fatalf("the first revision changed: %+v", revisions[0].GetCodes())
	}

	// And the diff answers what a payer actually asks.
	diff, err := h.records.GetCodingDiff(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.GetCodingDiffRequest{
				EpisodeId:      episode.GetEpisodeId(),
				BeforeRevision: 1, AfterRevision: 2,
			}))
	if err != nil {
		t.Fatalf("GetCodingDiff: %v", err)
	}
	if len(diff.Msg.GetChanges()) != 2 {
		t.Fatalf("changes = %+v, want one removed and one added",
			diff.Msg.GetChanges())
	}

	// A second coder signs it off.
	final, err := h.records.FinaliseCoding(ctx,
		withFacility(h.otherCoderToken(), h.facility,
			&recordsv1.FinaliseCodingRequest{
				EpisodeId: episode.GetEpisodeId(),
			}))
	if err != nil {
		t.Fatalf("FinaliseCoding: %v", err)
	}
	if final.Msg.GetEpisode().GetState() !=
		recordsv1.CodingState_CODING_STATE_FINAL {
		t.Fatalf("state = %v", final.Msg.GetEpisode().GetState())
	}
}

// SRS-MRD-004, SRS-MRD-010. A release leaves under an authority somebody else
// approved, carries only what the scope allowed, and is answerable document
// by document afterwards.
func TestAReleaseIsApprovedBySomebodyElseAndAccountedFor(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	patient, encounter := h.chart(t, "Pillai", "9876543214")
	signed := h.note(t, patient, encounter, true)

	requested, err := h.records.RequestRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.RequestReleaseRequest{
				Reference: "MRD-" + uuid.NewString()[:8],
				PatientId: patient, Purpose: "insurance claim",
				Authorisation: &recordsv1.Authorisation{
					Kind:      recordsv1.AuthorityKind_AUTHORITY_KIND_PATIENT_CONSENT,
					Reference: "consent-form-91", SignedBy: patient,
					SignedAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
				},
				Recipient: &recordsv1.Recipient{
					Kind: recordsv1.RecipientKind_RECIPIENT_KIND_INSURER,
					Name: "Acme Health", Reference: "acme-1",
				},
				Scope: &recordsv1.ReleaseScope{
					EncounterIds: []string{encounter},
				},
			}))
	if err != nil {
		t.Fatalf("RequestRelease: %v", err)
	}
	release := requested.Msg.GetRelease()

	// The officer who logged it cannot approve it.
	_, err = h.records.ApproveRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.ApproveReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("self-approved release = %v, want denied", err)
	}

	if _, err := h.records.ApproveRelease(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.ApproveReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			})); err != nil {
		t.Fatalf("ApproveRelease: %v", err)
	}

	assembled, err := h.records.AssembleRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.AssembleReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			}))
	if err != nil {
		t.Fatalf("AssembleRelease: %v", err)
	}
	pkg := assembled.Msg.GetRelease().GetPackage()
	if len(pkg.GetItems()) != 1 ||
		pkg.GetItems()[0].GetDocumentId() != signed.GetDocumentId() {
		t.Fatalf("package = %+v, want the one signed summary",
			pkg.GetItems())
	}
	if pkg.GetContentHash() == "" {
		t.Fatal("a package with no content hash cannot be reproduced later")
	}

	sent, err := h.records.SendRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.SendReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			}))
	if err != nil {
		t.Fatalf("SendRelease: %v", err)
	}
	if sent.Msg.GetRelease().GetState() !=
		recordsv1.ReleaseState_RELEASE_STATE_RELEASED {
		t.Fatalf("state = %v", sent.Msg.GetRelease().GetState())
	}

	// And the patient can be told who has seen their record.
	accounting, err := h.records.ListDisclosures(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.ListDisclosuresRequest{PatientId: patient}))
	if err != nil {
		t.Fatalf("ListDisclosures: %v", err)
	}
	if len(accounting.Msg.GetDisclosures()) != 1 {
		t.Fatalf("%d disclosures, want 1",
			len(accounting.Msg.GetDisclosures()))
	}
	entry := accounting.Msg.GetDisclosures()[0]
	switch {
	case entry.GetActorId() != "him-1":
		t.Fatalf("actor = %q", entry.GetActorId())
	case entry.GetPurpose() != "insurance claim":
		t.Fatalf("purpose = %q", entry.GetPurpose())
	case entry.GetRecipientReference() != "acme-1":
		t.Fatalf("recipient = %q", entry.GetRecipientReference())
	case entry.GetScopeSummary() == "":
		t.Fatal("a disclosure with no scope does not answer what was seen")
	}

	// A clinician has no business reading the accounting of disclosures.
	_, err = h.records.ListDisclosures(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.ListDisclosuresRequest{PatientId: patient}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("a clinician read the accounting: %v", err)
	}
}

// SRS-MRD-004. Restricted material stays behind unless the approved scope
// asked for it.
func TestRestrictedMaterialIsNotSweptIntoAWholeRecordRelease(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	patient, encounter := h.chart(t, "Varma", "9876543215")
	h.note(t, patient, encounter, true)

	// A note of a kind the deployment has marked restricted.
	written, err := h.clinical.WriteNote(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.WriteNoteRequest{
				PatientId: patient, EncounterId: encounter,
				Kind:  clinicalv1.DocumentKind_DOCUMENT_KIND_CONSULTATION_NOTE,
				Title: "Psychiatry review",
				Sections: []*clinicalv1.Section{
					{Heading: "Impression", Text: "Reviewed."},
				},
				Confidentiality: clinicalv1.Confidentiality_CONFIDENTIALITY_RESTRICTED,
			}))
	if err != nil {
		t.Fatalf("WriteNote: %v", err)
	}
	if _, err := h.clinical.SignNote(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.SignNoteRequest{
				DocumentId: written.Msg.GetDocument().GetDocumentId(),
				Meaning:    clinicalv1.SignatureMeaning_SIGNATURE_MEANING_AUTHOR,
			})); err != nil {
		t.Fatalf("SignNote: %v", err)
	}

	// The scope names the discharge summary and nothing else, so a
	// consultation note is not in the package however the caller asks.
	requested, err := h.records.RequestRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.RequestReleaseRequest{
				PatientId: patient, Purpose: "continuity of care",
				Authorisation: &recordsv1.Authorisation{
					Kind:      recordsv1.AuthorityKind_AUTHORITY_KIND_CONTINUITY_OF_CARE,
					Reference: "transfer-note-4",
				},
				Recipient: &recordsv1.Recipient{
					Kind: recordsv1.RecipientKind_RECIPIENT_KIND_TREATING_CLINICIAN,
					Name: "Dr Gupta", Reference: "gupta-1",
				},
				Scope: &recordsv1.ReleaseScope{
					EncounterIds:  []string{encounter},
					DocumentKinds: []string{"discharge_summary"},
				},
			}))
	if err != nil {
		t.Fatalf("RequestRelease: %v", err)
	}
	release := requested.Msg.GetRelease()

	if _, err := h.records.ApproveRelease(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.ApproveReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			})); err != nil {
		t.Fatalf("ApproveRelease: %v", err)
	}
	assembled, err := h.records.AssembleRelease(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.AssembleReleaseRequest{
				ReleaseId: release.GetReleaseId(),
			}))
	if err != nil {
		t.Fatalf("AssembleRelease: %v", err)
	}
	for _, item := range assembled.Msg.GetRelease().GetPackage().GetItems() {
		if item.GetKind() != "discharge_summary" {
			t.Fatalf("the package carries a %s the scope did not ask for",
				item.GetKind())
		}
	}
}

// SRS-MRD-005, SRS-MRD-009. A held record is never destroyed, and the person
// who signs the list is not the person who shreds it.
func TestAHeldRecordSurvivesADispositionSomebodyElseApproved(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	// Two paper volumes whose retention has long run. Backdated directly,
	// because the only anchor a paper folder knows about itself is when it
	// was registered and there is no RPC that backdates one — correctly, but
	// it makes a legacy volume impossible to set up through the contract.
	held := h.paper(t, "MR-0001")
	loose := h.paper(t, "MR-0002")
	h.backdate(t, held.GetRecordId(), loose.GetRecordId())

	h.liveRetentionRule(t)

	// One of them is under a legal hold, placed by the manager.
	if _, err := h.records.PlaceHold(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.PlaceHoldRequest{
				RecordClass: "mrd_physical_record",
				RecordId:    held.GetRecordId(),
				Reason:      "coroner's request",
			})); err != nil {
		t.Fatalf("PlaceHold: %v", err)
	}

	sweep, err := h.records.SweepForDisposition(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.SweepForDispositionRequest{Jurisdiction: "IN"}))
	if err != nil {
		t.Fatalf("SweepForDisposition: %v", err)
	}
	if len(sweep.Msg.GetEligible()) != 1 ||
		sweep.Msg.GetEligible()[0].GetRecordId() != loose.GetRecordId() {
		t.Fatalf("eligible = %+v, want only the unheld record",
			sweep.Msg.GetEligible())
	}
	// And the sweep says why it passed the other one over, because "why is
	// this still here" is the question a records manager is actually asked.
	var reason string
	for _, passed := range sweep.Msg.GetIneligible() {
		if passed.GetRecordId() == held.GetRecordId() {
			reason = passed.GetReason()
		}
	}
	if !strings.Contains(reason, "hold") {
		t.Fatalf("the held record was passed over with reason %q", reason)
	}

	prepared, err := h.records.PrepareDisposition(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.PrepareDispositionRequest{
				Reference: "DL-1", Jurisdiction: "IN",
				Disposition: recordsv1.DispositionKind_DISPOSITION_KIND_DESTROY,
			}))
	if err != nil {
		t.Fatalf("PrepareDisposition: %v", err)
	}
	list := prepared.Msg.GetList()

	// The office that prepared it cannot approve it.
	_, err = h.records.ApproveDisposition(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.ApproveDispositionRequest{ListId: list.GetListId()}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("self-approved destruction = %v, want denied", err)
	}

	if _, err := h.records.ApproveDisposition(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.ApproveDispositionRequest{
				ListId: list.GetListId(),
			})); err != nil {
		t.Fatalf("ApproveDisposition: %v", err)
	}

	// And the manager who approved it cannot carry it out.
	_, err = h.records.ExecuteDisposition(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.ExecuteDispositionRequest{
				ListId: list.GetListId(), Certificate: "cert-1",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the approver shredded the records: %v", err)
	}

	executed, err := h.records.ExecuteDisposition(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.ExecuteDispositionRequest{
				ListId: list.GetListId(), Certificate: "cert-1",
			}))
	if err != nil {
		t.Fatalf("ExecuteDisposition: %v", err)
	}
	if executed.Msg.GetList().GetState() !=
		recordsv1.DispositionState_DISPOSITION_STATE_EXECUTED {
		t.Fatalf("state = %v", executed.Msg.GetList().GetState())
	}

	// The paper that was destroyed now reads as destroyed, and the held one
	// is still on the shelf. A record that was shredded and still reads as
	// filed sends somebody to look for it.
	states := h.paperStates(t)
	if states[loose.GetRecordId()] !=
		recordsv1.PhysicalState_PHYSICAL_STATE_DESTROYED {
		t.Fatalf("the destroyed volume reads as %v",
			states[loose.GetRecordId()])
	}
	if states[held.GetRecordId()] !=
		recordsv1.PhysicalState_PHYSICAL_STATE_FILED {
		t.Fatalf("the held volume reads as %v", states[held.GetRecordId()])
	}
}

// SRS-MRD-006. A paper record goes out to one named person and comes back.
func TestAPaperRecordGoesOutToOneNamedCustodian(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	record := h.paper(t, "MR-0003")

	out, err := h.records.CheckOutRecord(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.CheckOutRecordRequest{
				RecordId: record.GetRecordId(), Custodian: "doctor-1",
				Location: "cardiology clinic", Purpose: "follow-up",
				DueBack: timestamppb.New(time.Now().UTC().Add(48 * time.Hour)),
			}))
	if err != nil {
		t.Fatalf("CheckOutRecord: %v", err)
	}
	if out.Msg.GetRecord().GetCustodian() != "doctor-1" {
		t.Fatalf("custodian = %q", out.Msg.GetRecord().GetCustodian())
	}

	// A record already out cannot go out again: two answers to "who has it"
	// is the same as none.
	_, err = h.records.CheckOutRecord(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.CheckOutRecordRequest{
				RecordId: record.GetRecordId(), Custodian: "doctor-2",
				Location: "ward 4", Purpose: "review",
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a second check-out = %v, want refused", err)
	}

	back, err := h.records.CheckInRecord(ctx,
		withFacility(h.officerToken(), h.facility,
			&recordsv1.CheckInRecordRequest{
				RecordId: record.GetRecordId(), Location: "main file room",
			}))
	if err != nil {
		t.Fatalf("CheckInRecord: %v", err)
	}
	if back.Msg.GetRecord().GetCustodian() != "" {
		t.Fatalf("a filed record is with %q",
			back.Msg.GetRecord().GetCustodian())
	}
}

// SRS-MRD-007. A certificate is issued against the form in force by somebody
// with the standing it names, and a correction keeps the one that was issued.
func TestACorrectedCertificateKeepsTheOneThatWentToTheRegistrar(t *testing.T) {
	h := newMrdHarness(t)
	ctx := context.Background()

	drafted, err := h.records.DraftCertificateForm(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.DraftCertificateFormRequest{
				Code: "DEATH-IN", Name: "Form 4", Revision: 1,
				Kind:         recordsv1.CertificateKind_CERTIFICATE_KIND_DEATH,
				Jurisdiction: "IN", IssuerRole: "rmp",
				Fields: []*recordsv1.CertificateField{
					{
						Code: "cause_i_a", Label: "Immediate cause",
						Required: true, SourcePath: "encounter.death.cause",
					},
				},
			}))
	if err != nil {
		t.Fatalf("DraftCertificateForm: %v", err)
	}

	// Nothing is issued against a form nobody approved.
	_, err = h.records.IssueCertificate(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.IssueCertificateRequest{
				Kind:         recordsv1.CertificateKind_CERTIFICATE_KIND_DEATH,
				Jurisdiction: "IN", PatientId: "patient-9",
				Values:     map[string]string{"cause_i_a": "pneumonia"},
				SourceRefs: map[string]string{"cause_i_a": "doc-1"},
				IssuerRole: "rmp", IssuerName: "Dr Rao",
				SerialNumber: "SER-1",
			}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("issued against an unapproved form = %v", err)
	}

	if _, err := h.records.ApproveCertificateForm(ctx,
		withFacility(h.otherManagerToken(), h.facility,
			&recordsv1.ApproveCertificateFormRequest{
				FormId: drafted.Msg.GetForm().GetFormId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			})); err != nil {
		t.Fatalf("ApproveCertificateForm: %v", err)
	}

	// The records manager cannot sign a death certificate however senior
	// they are: who may sign is the form's statutory question.
	_, err = h.records.IssueCertificate(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.IssueCertificateRequest{
				Kind:         recordsv1.CertificateKind_CERTIFICATE_KIND_DEATH,
				Jurisdiction: "IN", PatientId: "patient-9",
				Values:     map[string]string{"cause_i_a": "pneumonia"},
				SourceRefs: map[string]string{"cause_i_a": "doc-1"},
				IssuerRole: "rmp", IssuerName: "Records Manager",
				SerialNumber: "SER-1",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the records manager certified a death: %v", err)
	}

	issued, err := h.records.IssueCertificate(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.IssueCertificateRequest{
				Kind:         recordsv1.CertificateKind_CERTIFICATE_KIND_DEATH,
				Jurisdiction: "IN", PatientId: "patient-9",
				Values:     map[string]string{"cause_i_a": "pneumonia"},
				SourceRefs: map[string]string{"cause_i_a": "doc-1"},
				IssuerRole: "rmp", IssuerName: "Dr Rao",
				SerialNumber: "SER-1",
			}))
	if err != nil {
		t.Fatalf("IssueCertificate: %v", err)
	}
	certificate := issued.Msg.GetCertificate()

	corrected, err := h.records.CorrectCertificate(ctx,
		withFacility(h.doctorToken(), h.facility,
			&recordsv1.CorrectCertificateRequest{
				CertificateId: certificate.GetCertificateId(),
				Values:        map[string]string{"cause_i_a": "sepsis"},
				SourceRefs:    map[string]string{"cause_i_a": "doc-2"},
				IssuerRole:    "rmp", IssuerName: "Dr Rao",
				Reason: "post-mortem findings", SerialNumber: "SER-1",
			}))
	if err != nil {
		t.Fatalf("CorrectCertificate: %v", err)
	}
	versions := corrected.Msg.GetCertificate().GetVersions()
	if len(versions) != 2 {
		t.Fatalf("%d versions, want 2", len(versions))
	}
	if versions[0].GetValues()["cause_i_a"] != "pneumonia" {
		t.Fatalf("the issued version changed: %+v", versions[0].GetValues())
	}
	if versions[0].GetSerialNumber() != "SER-1" {
		t.Fatalf("the first version lost the serial it was issued under")
	}
}

// paper registers a paper volume whose retention has long run.
func (h *mrdHarness) paper(t *testing.T,
	reference string) *recordsv1.PhysicalRecord {

	t.Helper()

	registered, err := h.records.RegisterPhysicalRecord(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&recordsv1.RegisterPhysicalRecordRequest{
				Reference: reference, PatientId: "patient-" + reference,
				Volume: 1, RecordClass: "inpatient", Jurisdiction: "IN",
				Description: "Legacy volume", HomeLocation: "main file room",
			}))
	if err != nil {
		t.Fatalf("RegisterPhysicalRecord: %v", err)
	}
	return registered.Msg.GetRecord()
}

// backdate ages a registered volume by thirty years.
func (h *mrdHarness) backdate(t *testing.T, recordIDs ...string) {
	t.Helper()

	for _, recordID := range recordIDs {
		if _, err := h.pool.Exec(context.Background(),
			`UPDATE records.physical_record
			 SET created_at = created_at - interval '30 years'
			 WHERE record_id = $1`, recordID); err != nil {
			t.Fatalf("backdate: %v", err)
		}
	}
}

// liveRetentionRule puts a rule in force that keeps inpatient records for
// nothing at all, so a record registered today is already due.
func (h *mrdHarness) liveRetentionRule(t *testing.T) {
	t.Helper()
	ctx := context.Background()

	drafted, err := h.records.DraftRetentionRule(ctx,
		withFacility(h.managerToken(), h.facility,
			&recordsv1.DraftRetentionRuleRequest{
				Code: "INPATIENT-IN", Name: "Inpatient records", Revision: 1,
				RecordClass: "inpatient", Jurisdiction: "IN",
				Anchor:      recordsv1.RetentionAnchor_RETENTION_ANCHOR_CREATION,
				RetainYears: 8,
				Disposition: recordsv1.DispositionKind_DISPOSITION_KIND_DESTROY,
				Authority:   "Medical Council of India regulation 1.3.1",
			}))
	if err != nil {
		t.Fatalf("DraftRetentionRule: %v", err)
	}
	if _, err := h.records.ApproveRetentionRule(ctx,
		withFacility(h.otherManagerToken(), h.facility,
			&recordsv1.ApproveRetentionRuleRequest{
				RuleId: drafted.Msg.GetRule().GetRuleId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			})); err != nil {
		t.Fatalf("ApproveRetentionRule: %v", err)
	}
}

func (h *mrdHarness) paperStates(t *testing.T) map[string]recordsv1.PhysicalState {
	t.Helper()

	listed, err := h.records.ListPhysicalRecords(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&recordsv1.ListPhysicalRecordsRequest{}))
	if err != nil {
		t.Fatalf("ListPhysicalRecords: %v", err)
	}
	states := map[string]recordsv1.PhysicalState{}
	for _, record := range listed.Msg.GetRecords() {
		states[record.GetRecordId()] = record.GetState()
	}
	return states
}
