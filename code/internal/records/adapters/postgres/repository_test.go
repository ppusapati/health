package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/records/adapters/postgres"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// The medical records persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost checklist revision makes a deficiency unexplainable; a
// lost release item makes "what did we release" unanswerable; a lost
// certificate version makes the hospital's account of what it issued untrue.
//
// Fifty-one assertions here bypass the adapter and write raw SQL, because
// the rule under test belongs to the database rather than to Go: a rule the
// adapter is the only thing enforcing is one a migration, a backfill or the
// next context's repository can walk straight past.

var at = time.Date(2026, 9, 19, 10, 0, 0, 0, time.UTC)

type fixture struct {
	pool     *pgxpool.Pool
	repo     *postgres.Repository
	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()

	return fixture{
		pool: pool,
		repo: postgres.New(pgtx.NewManager(pool)),
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "mrd-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against
// a caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string,
	args ...any) {

	t.Helper()
	_, err := f.pool.Exec(context.Background(), sql, args...)
	if err == nil {
		t.Fatalf("the database accepted a write %q should have refused",
			constraint)
	}
	if !strings.Contains(err.Error(), constraint) {
		t.Fatalf("want a violation of %q, got %v", constraint, err)
	}
}

func (f fixture) mustExec(t *testing.T, sql string, args ...any) {
	t.Helper()
	if _, err := f.pool.Exec(context.Background(), sql, args...); err != nil {
		t.Fatalf("exec: %v", err)
	}
}

// SRS-MRD-001. A checklist and its items survive the round trip, and the
// items are what a chart is judged against.
func TestAChecklistRoundTripsWithItsItems(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	checklist, err := domain.NewChecklist(uuid.NewString(), f.tenantID,
		domain.NewChecklistInput{
			Code: "INPATIENT", Name: "Inpatient chart", Revision: 2,
			EncounterClass: "inpatient", Specialty: "obstetrics",
			Items: []domain.ChecklistItem{
				{Kind: "discharge_summary", Label: "Discharge summary",
					Requirement: domain.RequirementSigned,
					DueWithin:   24 * time.Hour},
				{Kind: "operation_note", Label: "Operation note",
					Requirement:   domain.RequirementConditional,
					ConditionCode: "had_operation"},
			},
		}, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewChecklist: %v", err)
	}
	if err := f.repo.InsertChecklist(ctx, f.scope, checklist); err != nil {
		t.Fatalf("InsertChecklist: %v", err)
	}

	back, err := f.repo.Checklist(ctx, f.scope, checklist.ID)
	if err != nil {
		t.Fatalf("Checklist: %v", err)
	}
	switch {
	case back.Revision != 2:
		t.Fatalf("revision = %d", back.Revision)
	case back.Specialty != "obstetrics":
		t.Fatalf("specialty = %q", back.Specialty)
	case len(back.Items) != 2:
		t.Fatalf("%d items, want 2", len(back.Items))
	}

	byKind := map[string]domain.ChecklistItem{}
	for _, item := range back.Items {
		byKind[item.Kind] = item
	}
	if byKind["discharge_summary"].DueWithin != 24*time.Hour {
		t.Fatalf("due within = %s, want the configured 24 hours",
			byKind["discharge_summary"].DueWithin)
	}
	if byKind["operation_note"].ConditionCode != "had_operation" {
		t.Fatalf("condition lost: %+v", byKind["operation_note"])
	}

	// Not live until somebody other than its author approves it.
	if live, err := f.repo.Checklists(ctx, f.scope, "inpatient",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Checklists: %v", err)
	} else if len(live) != 0 {
		t.Fatalf("an unapproved checklist is in force: %+v", live)
	}

	if err := back.Approve("mrd-lead", at, at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveChecklist(ctx, f.scope, back); err != nil {
		t.Fatalf("ApproveChecklist: %v", err)
	}
	live, err := f.repo.Checklists(ctx, f.scope, "inpatient",
		at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Checklists: %v", err)
	}
	if len(live) != 1 || len(live[0].Items) != 2 {
		t.Fatalf("live = %+v", live)
	}
}

// SRS-MRD-001. The database holds the checklist rules.
func TestTheDatabaseHoldsTheChecklistRules(t *testing.T) {
	f := newFixture(t)

	id := uuid.New()
	f.mustExec(t, `INSERT INTO records.chart_checklist (
		checklist_id, tenant_id, code, revision, encounter_class,
		created_at, created_by
	) VALUES ($1, $2, 'C', 1, 'inpatient', $3, 'author-1')`,
		id, f.tenantID, at)

	// The same code and revision twice: a deficiency raised against version
	// 1 of the inpatient checklist would have two versions to mean.
	f.mustFail(t, "chart_checklist_revision_idx",
		`INSERT INTO records.chart_checklist (
			checklist_id, tenant_id, code, revision, encounter_class,
			created_at, created_by
		) VALUES ($1, $2, 'C', 1, 'inpatient', $3, 'author-2')`,
		uuid.New(), f.tenantID, at)

	// One person writing and approving a checklist is one person deciding
	// which consultants get a deficiency letter.
	f.mustFail(t, "a_checklist_is_approved_by_somebody_else",
		`UPDATE records.chart_checklist
		 SET approved = true, approved_by = 'author-1', effective_from = $1
		 WHERE checklist_id = $2`, at, id)

	// Approved with no effective date is a checklist in force from never.
	f.mustFail(t, "a_checklist_is_approved_by_somebody_else",
		`UPDATE records.chart_checklist
		 SET approved = true, approved_by = 'lead-1'
		 WHERE checklist_id = $1`, id)

	insertItem := `INSERT INTO records.checklist_item (
		item_id, tenant_id, checklist_id, document_kind, requirement,
		condition_code
	) VALUES ($1, $2, $3, $4, $5, $6)`

	f.mustFail(t, "a_conditional_item_names_its_condition", insertItem,
		uuid.New(), f.tenantID, id, "operation_note", "conditional", "")

	f.mustExec(t, insertItem, uuid.New(), f.tenantID, id,
		"discharge_summary", "signed", "")
	// The same kind twice is two deficiencies for one gap.
	f.mustFail(t, "checklist_item_kind_idx", insertItem,
		uuid.New(), f.tenantID, id, "Discharge_Summary", "present", "")
}

func openDeficiency(t *testing.T, f fixture,
	mutate func(*domain.NewDeficiencyInput)) domain.Deficiency {

	t.Helper()
	in := domain.NewDeficiencyInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		Kind: domain.DeficiencyUnsigned, DocumentKind: "discharge_summary",
		Label: "Discharge summary", DocumentID: "doc-1", OwnerID: "reg-1",
		ChecklistCode: "INPATIENT", ChecklistRevision: 2,
		DueBy: at.Add(24 * time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}
	deficiency, err := domain.RaiseDeficiency(uuid.NewString(), f.tenantID,
		in, "mrd-1", at)
	if err != nil {
		t.Fatalf("RaiseDeficiency: %v", err)
	}
	if err := f.repo.InsertDeficiency(context.Background(), f.scope,
		deficiency); err != nil {
		t.Fatalf("InsertDeficiency: %v", err)
	}
	return deficiency
}

// SRS-MRD-002. A deficiency round-trips with the checklist version that
// raised it, and a stale write is a lost update.
func TestADeficiencyRoundTripsWithTheChecklistThatRaisedIt(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	deficiency := openDeficiency(t, f, nil)

	back, err := f.repo.Deficiency(ctx, f.scope, deficiency.ID)
	if err != nil {
		t.Fatalf("Deficiency: %v", err)
	}
	switch {
	case back.ChecklistCode != "INPATIENT" || back.ChecklistRevision != 2:
		t.Fatalf("the checklist version was not pinned: %+v", back)
	case back.OwnerID != "reg-1":
		t.Fatalf("owner = %q", back.OwnerID)
	case back.DocumentID != "doc-1":
		t.Fatalf("document = %q", back.DocumentID)
	case !back.DueBy.Equal(at.Add(24 * time.Hour)):
		t.Fatalf("due %s", back.DueBy)
	}

	if err := back.Resolve("doc-1", "consultant-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if err := f.repo.UpdateDeficiency(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("UpdateDeficiency: %v", err)
	}
	if err := f.repo.UpdateDeficiency(ctx, f.scope, back, 1); err == nil {
		t.Fatal("a stale write was accepted")
	}

	after, err := f.repo.Deficiency(ctx, f.scope, deficiency.ID)
	if err != nil {
		t.Fatalf("Deficiency: %v", err)
	}
	if after.State != domain.DeficiencyResolved ||
		after.ResolvedByDocumentID != "doc-1" {
		t.Fatalf("resolution lost: %+v", after)
	}

	// Another tenant sees nothing (FIT-03, Gate A2).
	other := authctx.NewSession(authctx.Session{
		SubjectID: "mrd-9", TenantID: uuid.NewString(),
	}).TenantScope()
	if _, err := f.repo.Deficiency(ctx, other, deficiency.ID); err == nil {
		t.Fatal("another tenant read the deficiency")
	}
}

// SRS-MRD-002, SRS-MRD-008. The database holds the deficiency rules,
// including the one that stops a signed note being answered by itself.
func TestTheDatabaseHoldsTheDeficiencyRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO records.deficiency (
		deficiency_id, tenant_id, encounter_id, kind, document_kind,
		document_id, detail, owner_id, state, raised_at, raised_by
	) VALUES ($1, $2, 'enc-1', $3, 'discharge_summary', $4, $5, $6,
		'open', $7, 'mrd-1')`

	// A deficiency owned by nobody is still open when a coroner asks.
	f.mustFail(t, "deficiency_owner_id_check", insert,
		uuid.New(), f.tenantID, "missing_document", "", "", "", at)

	// A missing document has no document to name; an unsigned one does.
	f.mustFail(t, "a_missing_document_names_no_document", insert,
		uuid.New(), f.tenantID, "missing_document", "doc-1", "", "reg-1", at)
	f.mustFail(t, "a_document_deficiency_names_its_document", insert,
		uuid.New(), f.tenantID, "unsigned_document", "", "", "reg-1", at)

	// "Inadequate" with no detail is a deficiency nobody can answer.
	f.mustFail(t, "an_inadequate_document_says_what_is_inadequate", insert,
		uuid.New(), f.tenantID, "incomplete_document", "doc-1", "", "reg-1",
		at)

	inadequate := openDeficiency(t, f, func(in *domain.NewDeficiencyInput) {
		in.Kind = domain.DeficiencyIncomplete
		in.Detail = "no medication list on discharge"
	})

	// A deficiency closed with nothing to point at is one somebody ticked.
	f.mustFail(t, "a_resolution_names_what_answered_it",
		`UPDATE records.deficiency SET state = 'resolved'
		 WHERE deficiency_id = $1`, inadequate.ID)

	// SRS-MRD-008 at the table: an inadequate signed document is answered by
	// an addendum, not by itself.
	f.mustFail(t, "signed_history_is_answered_not_altered",
		`UPDATE records.deficiency
		 SET state = 'resolved', resolved_by_document_id = document_id,
		     resolved_by = 'reg-1', resolved_at = $1
		 WHERE deficiency_id = $2`, at, inadequate.ID)

	f.mustFail(t, "a_waiver_says_why",
		`UPDATE records.deficiency SET state = 'waived', resolved_by = 'mrd-1'
		 WHERE deficiency_id = $1`, inadequate.ID)
}

// SRS-MRD-002. The escalation read is the sweep's worklist.
func TestTheEscalationReadSkipsWhatHasAlreadyBeenEscalated(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	overdue := openDeficiency(t, f, func(in *domain.NewDeficiencyInput) {
		in.DueBy = at.AddDate(0, 0, -30)
	})
	openDeficiency(t, f, func(in *domain.NewDeficiencyInput) {
		in.DocumentID, in.DueBy = "doc-2", at.AddDate(0, 0, 30)
	})

	candidates, err := f.repo.EscalationCandidates(ctx, f.scope, at, 100)
	if err != nil {
		t.Fatalf("EscalationCandidates: %v", err)
	}
	if len(candidates) != 1 || candidates[0].ID != overdue.ID {
		t.Fatalf("candidates = %+v, want the overdue one", candidates)
	}

	overdue.MarkEscalated(at)
	if err := f.repo.UpdateDeficiency(ctx, f.scope, overdue, 1); err != nil {
		t.Fatalf("UpdateDeficiency: %v", err)
	}
	candidates, err = f.repo.EscalationCandidates(ctx, f.scope, at, 100)
	if err != nil {
		t.Fatalf("EscalationCandidates: %v", err)
	}
	if len(candidates) != 0 {
		t.Fatalf("candidates = %+v, want none: it has been escalated",
			candidates)
	}
}

func icdCode(code string, role domain.CodeRole,
	poa domain.PresentOnAdmission) domain.AssignedCode {

	return domain.AssignedCode{
		System: "icd-10", Version: "2026", Code: code, Display: code,
		Role: role, POA: poa, SourceDocumentID: "doc-1",
	}
}

// SRS-MRD-003. Coding keeps every revision, and the codes come back with the
// revision they belong to.
func TestCodingRoundTripsAsAppendOnlyRevisions(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	episode, err := domain.StartCoding(uuid.NewString(), f.tenantID, "p1",
		"enc-1", "f1", "coder-1", at)
	if err != nil {
		t.Fatalf("StartCoding: %v", err)
	}
	if err := f.repo.InsertEpisode(ctx, f.scope, episode); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	first := []domain.AssignedCode{
		icdCode("J18.9", domain.CodePrincipalDiagnosis, domain.POAYes),
		icdCode("E11.9", domain.CodeSecondaryDiagnosis, domain.POAYes),
	}
	if err := episode.AssignCodes(first, "", "coder-1", at); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	revision, _ := episode.Current()
	if err := f.repo.AppendRevision(ctx, f.scope, episode, revision,
		1); err != nil {
		t.Fatalf("AppendRevision: %v", err)
	}

	back, err := f.repo.Episode(ctx, f.scope, episode.ID)
	if err != nil {
		t.Fatalf("Episode: %v", err)
	}
	if len(back.Revisions) != 1 || len(back.Revisions[0].Codes) != 2 {
		t.Fatalf("episode = %+v", back)
	}
	if back.Revisions[0].Codes[0].POA != domain.POAYes ||
		back.Revisions[0].Codes[0].Version != "2026" {
		t.Fatalf("code detail lost: %+v", back.Revisions[0].Codes[0])
	}
	if back.Revisions[0].Codes[0].SourceDocumentID != "doc-1" {
		t.Fatal("the document the code was read from was lost")
	}

	if err := back.Finalise("coder-2", at.Add(time.Hour)); err != nil {
		t.Fatalf("Finalise: %v", err)
	}
	finalised, _ := back.Current()
	if err := f.repo.SetRevisionState(ctx, f.scope, back.ID,
		finalised); err != nil {
		t.Fatalf("SetRevisionState: %v", err)
	}

	// Re-coding keeps the first revision whole.
	reread, err := f.repo.Episode(ctx, f.scope, episode.ID)
	if err != nil {
		t.Fatalf("Episode: %v", err)
	}
	second := []domain.AssignedCode{
		icdCode("A41.9", domain.CodePrincipalDiagnosis, domain.POANo),
	}
	if err := reread.AssignCodes(second, "audit: sepsis was the reason",
		"coder-3", at.AddDate(0, 1, 0)); err != nil {
		t.Fatalf("AssignCodes: %v", err)
	}
	next, _ := reread.Current()
	if err := f.repo.AppendRevision(ctx, f.scope, reread, next,
		reread.Version); err != nil {
		t.Fatalf("AppendRevision: %v", err)
	}

	after, err := f.repo.Episode(ctx, f.scope, episode.ID)
	if err != nil {
		t.Fatalf("Episode: %v", err)
	}
	if len(after.Revisions) != 2 {
		t.Fatalf("%d revisions: the first coding was overwritten",
			len(after.Revisions))
	}
	if after.Revisions[0].Codes[0].Code != "J18.9" {
		t.Fatalf("the first revision changed: %+v", after.Revisions[0])
	}
	if after.Revisions[0].ReviewedBy != "coder-2" {
		t.Fatalf("the second read was lost: %+v", after.Revisions[0])
	}
	if after.Revisions[1].Reason == "" {
		t.Fatal("the re-coding does not say why")
	}

	// Two coders racing to re-code the same episode: one wins.
	if err := f.repo.AppendRevision(ctx, f.scope, reread, next,
		reread.Version); err == nil {
		t.Fatal("a stale re-code was accepted")
	}

	// The encounter reaches its coding.
	found, ok, err := f.repo.EpisodeForEncounter(ctx, f.scope, "enc-1")
	if err != nil || !ok {
		t.Fatalf("EpisodeForEncounter: %v ok=%v", err, ok)
	}
	if found.ID != episode.ID {
		t.Fatalf("episode = %q", found.ID)
	}
	if _, ok, err := f.repo.EpisodeForEncounter(ctx, f.scope,
		"enc-none"); err != nil || ok {
		t.Fatalf("an uncoded encounter reported an episode: ok=%v err=%v",
			ok, err)
	}
}

// SRS-MRD-003. The database holds the coding rules.
func TestTheDatabaseHoldsTheCodingRules(t *testing.T) {
	f := newFixture(t)

	episodeID := uuid.New()
	f.mustExec(t, `INSERT INTO records.coded_episode (
		episode_id, tenant_id, patient_id, encounter_id, created_at,
		created_by
	) VALUES ($1, $2, 'p1', 'enc-1', $3, 'coder-1')`,
		episodeID, f.tenantID, at)

	// One coded episode per encounter: two would be two answers to what the
	// hospital reported for this admission.
	f.mustFail(t, "coded_episode_encounter_idx",
		`INSERT INTO records.coded_episode (
			episode_id, tenant_id, patient_id, encounter_id, created_at,
			created_by
		) VALUES ($1, $2, 'p1', 'enc-1', $3, 'coder-2')`,
		uuid.New(), f.tenantID, at)

	revisionID := uuid.New()
	insertRevision := `INSERT INTO records.coding_revision (
		revision_id, tenant_id, episode_id, revision, reason, state,
		coded_by, coded_at, reviewed_by, reviewed_at
	) VALUES ($1, $2, $3, $4, $5, $6, 'coder-1', $7, $8, $9)`

	f.mustExec(t, insertRevision, revisionID, f.tenantID, episodeID, 1, "",
		"coded", at, "", nil)

	// The same revision number twice: a query answered against revision 1
	// would have two codings to have been answered against.
	f.mustFail(t, "coding_revision_number_idx", insertRevision,
		uuid.New(), f.tenantID, episodeID, 1, "", "coded", at, "", nil)

	// A changed coding that does not say why.
	f.mustFail(t, "a_changed_coding_says_why", insertRevision,
		uuid.New(), f.tenantID, episodeID, 2, "", "coded", at, "", nil)

	// A second read by the same person is the same read.
	f.mustFail(t, "the_second_read_is_a_second_person",
		`UPDATE records.coding_revision
		 SET state = 'final', reviewed_by = 'coder-1', reviewed_at = $1
		 WHERE revision_id = $2`, at, revisionID)

	insertCode := `INSERT INTO records.assigned_code (
		code_id, tenant_id, revision_id, code_system, code_version,
		code_value, role, present_on_admission
	) VALUES ($1, $2, $3, 'icd-10', '2026', $4, $5, $6)`

	// A diagnosis that does not say whether it was there on arrival.
	f.mustFail(t, "a_diagnosis_says_whether_it_was_present_on_admission",
		insertCode, uuid.New(), f.tenantID, revisionID, "J18.9",
		"principal_diagnosis", "not_applicable")
	// Present-on-admission has no meaning for a procedure.
	f.mustFail(t, "a_procedure_has_no_admission_status", insertCode,
		uuid.New(), f.tenantID, revisionID, "E85.2",
		"principal_procedure", "yes")

	f.mustExec(t, insertCode, uuid.New(), f.tenantID, revisionID, "J18.9",
		"principal_diagnosis", "yes")
	// Two principal diagnoses is two answers to why the patient was
	// admitted.
	f.mustFail(t, "assigned_code_principal_diagnosis_idx", insertCode,
		uuid.New(), f.tenantID, revisionID, "A41.9", "principal_diagnosis",
		"no")
	// Two principal procedures is two answers to what was done.
	f.mustExec(t, insertCode, uuid.New(), f.tenantID, revisionID, "E85.2",
		"principal_procedure", "not_applicable")
	f.mustFail(t, "assigned_code_principal_procedure_idx", insertCode,
		uuid.New(), f.tenantID, revisionID, "E85.3", "principal_procedure",
		"not_applicable")

	// The same code twice in one role, in a role the principal index does
	// not already cover.
	f.mustExec(t, insertCode, uuid.New(), f.tenantID, revisionID, "E11.9",
		"secondary_diagnosis", "yes")
	f.mustFail(t, "assigned_code_unique_idx", insertCode,
		uuid.New(), f.tenantID, revisionID, "e11.9", "secondary_diagnosis",
		"yes")
}

func consentedRelease(t *testing.T, f fixture,
	mutate func(*domain.NewReleaseInput)) domain.ReleaseRequest {

	t.Helper()
	in := domain.NewReleaseInput{
		Reference: "REL-" + uuid.NewString()[:8], PatientID: "p1",
		Purpose: "insurance claim",
		Authorisation: domain.Authorisation{
			Kind: domain.AuthorityPatientConsent, Reference: "CONSENT-77",
			SignedBy: "p1", SignedAt: at.AddDate(0, 0, -1),
			ExpiresAt: at.AddDate(0, 3, 0),
		},
		Recipient: domain.Recipient{
			Kind: domain.RecipientInsurer, Name: "Acme Health",
			Reference: "CLAIM-2026-4412", DeliveryMethod: "secure transfer",
		},
		Scope: domain.ReleaseScope{EncounterIDs: []string{"enc-1"}},
	}
	if mutate != nil {
		mutate(&in)
	}
	request, err := domain.RequestRelease(uuid.NewString(), f.tenantID, in,
		"mrd-1", at)
	if err != nil {
		t.Fatalf("RequestRelease: %v", err)
	}
	if err := f.repo.InsertRelease(context.Background(), f.scope,
		request); err != nil {
		t.Fatalf("InsertRelease: %v", err)
	}
	return request
}

// SRS-MRD-004. The package is retained item by item, which is what answers
// "what did we release".
func TestAReleasePackageIsRetainedItemByItem(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	request := consentedRelease(t, f, nil)
	if err := request.Approve("mrd-lead", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.UpdateRelease(ctx, f.scope, request, 1); err != nil {
		t.Fatalf("UpdateRelease: %v", err)
	}

	items := []domain.ReleaseItem{
		{DocumentID: "doc-1", EncounterID: "enc-1",
			Kind: "discharge_summary", RecordClass: "inpatient",
			OccurredAt: at.AddDate(0, -1, 0), Pages: 3},
		{DocumentID: "doc-2", EncounterID: "enc-1",
			Kind: "operation_note", RecordClass: "inpatient",
			OccurredAt: at.AddDate(0, -1, 1), Pages: 2},
	}
	if err := request.Assemble(items, "sha256:abc", "mrd-1",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if err := f.repo.UpdateRelease(ctx, f.scope, request, 2); err != nil {
		t.Fatalf("UpdateRelease: %v", err)
	}
	if err := request.Release("mrd-1", at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if err := f.repo.UpdateRelease(ctx, f.scope, request, 3); err != nil {
		t.Fatalf("UpdateRelease: %v", err)
	}

	back, err := f.repo.Release(ctx, f.scope, request.ID)
	if err != nil {
		t.Fatalf("Release: %v", err)
	}
	switch {
	case back.State != domain.ReleaseReleased:
		t.Fatalf("state = %s", back.State)
	case back.Package == nil:
		t.Fatal("the package was lost, and with it what was released")
	case len(back.Package.Items) != 2:
		t.Fatalf("%d items, want 2", len(back.Package.Items))
	case back.Package.Pages != 5:
		t.Fatalf("pages = %d, want 5", back.Package.Pages)
	case back.Package.ContentHash != "sha256:abc":
		t.Fatalf("content hash = %q", back.Package.ContentHash)
	case back.Package.ReleasedBy != "mrd-1":
		t.Fatalf("released by %q", back.Package.ReleasedBy)
	case back.Authorisation.Reference != "CONSENT-77":
		t.Fatalf("the authority was lost: %+v", back.Authorisation)
	case back.Recipient.Reference != "CLAIM-2026-4412":
		t.Fatalf("the recipient reference was lost: %+v", back.Recipient)
	case len(back.Scope.EncounterIDs) != 1:
		t.Fatalf("the scope was lost: %+v", back.Scope)
	}
}

// SRS-MRD-004, SRS-MRD-010. The database holds the release and disclosure
// rules.
func TestTheDatabaseHoldsTheReleaseAndDisclosureRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO records.release_request (
		release_id, tenant_id, patient_id, purpose, authority_kind,
		authority_reference, recipient_kind, recipient_name,
		recipient_reference, encounter_ids, whole_record, state,
		requested_at, requested_by
	) VALUES ($1, $2, 'p1', 'claim', 'patient_consent', 'C-1', 'insurer',
		'Acme', 'R-1', $3, $4, 'requested', $5, 'mrd-1')`

	// A scope with nothing in it is a request for everything ever recorded
	// about a person. array_length of an empty array is NULL and a CHECK
	// evaluating to NULL passes, so the COALESCE is what catches this.
	f.mustFail(t, "a_scope_says_what_it_wants", insert,
		uuid.New(), f.tenantID, []string{}, false, at)

	// A period that ends before it starts selects nothing, and a release
	// that assembles nothing is one nobody notices went wrong.
	f.mustFail(t, "a_scope_period_ends_after_it_starts",
		`INSERT INTO records.release_request (
			release_id, tenant_id, patient_id, purpose, authority_kind,
			authority_reference, recipient_kind, recipient_name,
			recipient_reference, scope_from, scope_to, state, requested_at,
			requested_by
		) VALUES ($1, $2, 'p1', 'claim', 'patient_consent', 'C-1', 'insurer',
			'Acme', 'R-1', $3, $4, 'requested', $5, 'mrd-1')`,
		uuid.New(), f.tenantID, at, at.Add(-24*time.Hour), at)

	// Two releases under one reference is a correspondence file where the
	// letter quoting MRD-1 has two packages behind it.
	insertReferenced := `INSERT INTO records.release_request (
		release_id, tenant_id, reference, patient_id, purpose,
		authority_kind, authority_reference, recipient_kind, recipient_name,
		recipient_reference, whole_record, state, requested_at, requested_by
	) VALUES ($1, $2, 'MRD-1', 'p1', 'claim', 'patient_consent', 'C-1',
		'insurer', 'Acme', 'R-1', true, 'requested', $3, 'mrd-1')`
	f.mustExec(t, insertReferenced, uuid.New(), f.tenantID, at)
	f.mustFail(t, "release_reference_idx", insertReferenced,
		uuid.New(), f.tenantID, at)

	request := consentedRelease(t, f, nil)

	// A records officer who requested a release cannot approve it.
	f.mustFail(t, "a_release_is_approved_by_somebody_else",
		`UPDATE records.release_request
		 SET state = 'approved', approved_by = 'mrd-1', approved_at = $1
		 WHERE release_id = $2`, at, request.ID)

	f.mustFail(t, "a_refusal_says_why",
		`UPDATE records.release_request SET state = 'refused'
		 WHERE release_id = $1`, request.ID)

	f.mustExec(t, `UPDATE records.release_request
		 SET state = 'approved', approved_by = 'mrd-lead', approved_at = $1
		 WHERE release_id = $2`, at, request.ID)

	f.mustFail(t, "a_released_package_says_when_it_went",
		`UPDATE records.release_request SET state = 'released'
		 WHERE release_id = $1`, request.ID)

	// The same document twice in one package.
	insertItem := `INSERT INTO records.release_item (
		item_id, tenant_id, release_id, document_id
	) VALUES ($1, $2, $3, 'doc-1')`
	f.mustExec(t, insertItem, uuid.New(), f.tenantID, request.ID)
	f.mustFail(t, "release_item_document_idx", insertItem,
		uuid.New(), f.tenantID, request.ID)

	// The four things SRS-MRD-010 names are required.
	insertDisclosure := `INSERT INTO records.disclosure (
		disclosure_id, tenant_id, patient_id, kind, actor_id, purpose,
		scope_summary, recipient_reference, occurred_at
	) VALUES ($1, $2, 'p1', 'export', $3, $4, $5, $6, $7)`

	f.mustFail(t, "disclosure_actor_id_check", insertDisclosure,
		uuid.New(), f.tenantID, "", "claim", "one encounter", "R-1", at)
	f.mustFail(t, "disclosure_purpose_check", insertDisclosure,
		uuid.New(), f.tenantID, "mrd-1", "", "one encounter", "R-1", at)
	f.mustFail(t, "disclosure_scope_summary_check", insertDisclosure,
		uuid.New(), f.tenantID, "mrd-1", "claim", "", "R-1", at)
	f.mustFail(t, "disclosure_recipient_reference_check", insertDisclosure,
		uuid.New(), f.tenantID, "mrd-1", "claim", "one encounter", "", at)
}

// SRS-MRD-010. The accounting of disclosures answers "who has seen my
// record".
func TestTheAccountingOfDisclosuresIsReadableByPatient(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for i, patient := range []string{"p1", "p1", "p2"} {
		disclosure, err := domain.RecordDisclosure(uuid.NewString(),
			f.tenantID, patient, domain.DisclosureExport, "", "mrd-1",
			"insurance claim", "the admission of 3 March 2026",
			domain.Recipient{
				Kind: domain.RecipientInsurer, Name: "Acme Health",
				Reference: "CLAIM-2026-4412",
			}, 1, 3, at.Add(time.Duration(i)*time.Minute))
		if err != nil {
			t.Fatalf("RecordDisclosure: %v", err)
		}
		if err := f.repo.InsertDisclosure(ctx, f.scope,
			disclosure); err != nil {
			t.Fatalf("InsertDisclosure: %v", err)
		}
	}

	mine, err := f.repo.Disclosures(ctx, f.scope, ports.DisclosureFilter{
		PatientID: "p1",
	})
	if err != nil {
		t.Fatalf("Disclosures: %v", err)
	}
	if len(mine) != 2 {
		t.Fatalf("%d disclosures for p1, want 2", len(mine))
	}
	if mine[0].RecipientReference != "CLAIM-2026-4412" ||
		mine[0].ScopeSummary == "" {
		t.Fatalf("disclosure = %+v", mine[0])
	}
}

func liveRule(t *testing.T, f fixture,
	mutate func(*domain.NewRetentionRuleInput)) domain.RetentionRule {

	t.Helper()
	ctx := context.Background()
	in := domain.NewRetentionRuleInput{
		Code: "INPATIENT-8Y", Name: "Inpatient episodes", Revision: 1,
		RecordClass: "inpatient", Jurisdiction: "IN",
		Anchor: domain.AnchorCreation, RetainYears: 8,
		Disposition: domain.DispositionDestroy,
		Authority:   "Medical Council of India regulations",
	}
	if mutate != nil {
		mutate(&in)
	}
	rule, err := domain.NewRetentionRule(uuid.NewString(), f.tenantID, in,
		"mrd-author", at)
	if err != nil {
		t.Fatalf("NewRetentionRule: %v", err)
	}
	if err := f.repo.InsertRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("InsertRule: %v", err)
	}
	if err := rule.Approve("mrd-lead", at.AddDate(-1, 0, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveRule(ctx, f.scope, rule); err != nil {
		t.Fatalf("ApproveRule: %v", err)
	}
	return rule
}

// SRS-MRD-005, SRS-MRD-009. The paper inventory feeds the sweep, and a
// disposition list keeps the rule that made each record eligible.
func TestTheInventoryFeedsTheSweepAndTheListPinsItsRules(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	rule := liveRule(t, f, nil)

	for _, reference := range []string{"MRN-1/1", "MRN-2/1"} {
		record, err := domain.RegisterPhysicalRecord(uuid.NewString(),
			f.tenantID, domain.NewPhysicalRecordInput{
				Reference: reference, PatientID: "p1",
				RecordClass: "inpatient", Jurisdiction: "IN",
				HomeLocation: "library bay 4",
			}, "mrd-1", at.AddDate(-10, 0, 0))
		if err != nil {
			t.Fatalf("RegisterPhysicalRecord: %v", err)
		}
		if err := f.repo.InsertPhysicalRecord(ctx, f.scope,
			record); err != nil {
			t.Fatalf("InsertPhysicalRecord: %v", err)
		}
	}

	retained, err := f.repo.Retained(ctx, f.scope, "IN", 100)
	if err != nil {
		t.Fatalf("Retained: %v", err)
	}
	if len(retained) != 2 {
		t.Fatalf("%d retained records, want 2", len(retained))
	}

	rules, err := f.repo.Rules(ctx, f.scope, "IN", "", at)
	if err != nil {
		t.Fatalf("Rules: %v", err)
	}
	held := map[string]bool{retained[0].RecordID: true}
	candidates, passed := domain.EligibleForDisposition(retained, rules,
		func(id string) bool { return held[id] }, at)

	if len(candidates) != 1 {
		t.Fatalf("candidates = %+v, want the one not held", candidates)
	}
	if len(passed) != 1 || passed[0].Reason != domain.IneligibleHeld {
		t.Fatalf("passed over = %+v, want the held one named", passed)
	}
	if candidates[0].RuleCode != rule.Code || candidates[0].Authority == "" {
		t.Fatalf("candidate does not name its rule: %+v", candidates[0])
	}

	list, err := domain.PrepareDisposition(uuid.NewString(), f.tenantID,
		"DL-1", "IN", domain.DispositionDestroy, candidates, "mrd-1", at)
	if err != nil {
		t.Fatalf("PrepareDisposition: %v", err)
	}
	if err := f.repo.InsertList(ctx, f.scope, list); err != nil {
		t.Fatalf("InsertList: %v", err)
	}

	back, err := f.repo.List(ctx, f.scope, list.ID)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(back.Items) != 1 {
		t.Fatalf("%d items, want 1", len(back.Items))
	}
	if back.Items[0].RuleCode != rule.Code ||
		back.Items[0].RuleRevision != 1 {
		t.Fatalf("the rule was not pinned to the item: %+v", back.Items[0])
	}

	if err := back.ApproveDisposition("mrd-lead", at); err != nil {
		t.Fatalf("ApproveDisposition: %v", err)
	}
	if err := f.repo.UpdateList(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("UpdateList: %v", err)
	}
	if err := back.Execute(func(string) bool { return false }, "CERT-1",
		"mrd-1", at.AddDate(0, 0, 1)); err != nil {
		t.Fatalf("Execute: %v", err)
	}
	if err := f.repo.UpdateList(ctx, f.scope, back, 2); err != nil {
		t.Fatalf("UpdateList: %v", err)
	}

	after, err := f.repo.List(ctx, f.scope, list.ID)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if after.State != domain.DispositionExecuted ||
		after.Certificate != "CERT-1" {
		t.Fatalf("list = %+v", after)
	}
}

// SRS-MRD-009. The database holds the retention and disposition rules.
func TestTheDatabaseHoldsTheRetentionRules(t *testing.T) {
	f := newFixture(t)

	insertRule := `INSERT INTO records.retention_rule (
		rule_id, tenant_id, code, revision, record_class, jurisdiction,
		anchor, retain_years, disposition, authority, approved, approved_by,
		effective_from, created_at, created_by
	) VALUES ($1, $2, 'R', 1, 'inpatient', 'IN', 'discharge', $3, $4,
		'a statute', $5, $6, $7, $8, 'author-1')`

	// Zero years with a destroy disposition destroys on the anchor date.
	f.mustFail(t, "a_rule_that_disposes_keeps_the_record_first", insertRule,
		uuid.New(), f.tenantID, 0, "destroy", false, "", nil, at)

	f.mustFail(t, "a_retention_rule_is_approved_by_somebody_else",
		insertRule, uuid.New(), f.tenantID, 8, "destroy", true, "author-1",
		at, at)

	// The same code and revision twice: a disposition item pinned to R
	// revision 1 would have two rules to have been made eligible by.
	f.mustExec(t, insertRule, uuid.New(), f.tenantID, 8, "destroy", true,
		"mrd-lead", at, at)
	f.mustFail(t, "retention_rule_revision_idx", insertRule,
		uuid.New(), f.tenantID, 8, "destroy", true, "mrd-lead", at, at)

	listID := uuid.New()
	f.mustExec(t, `INSERT INTO records.disposition_list (
		list_id, tenant_id, jurisdiction, disposition, state, prepared_at,
		prepared_by
	) VALUES ($1, $2, 'IN', 'destroy', 'draft', $3, 'mrd-1')`,
		listID, f.tenantID, at)

	// The last check before records stop existing.
	f.mustFail(t, "a_disposition_list_is_approved_by_somebody_else",
		`UPDATE records.disposition_list
		 SET state = 'approved', approved_by = 'mrd-1', approved_at = $1
		 WHERE list_id = $2`, at, listID)

	f.mustExec(t, `UPDATE records.disposition_list
		 SET state = 'approved', approved_by = 'mrd-lead', approved_at = $1
		 WHERE list_id = $2`, at, listID)
	f.mustFail(t, "an_executed_list_says_who_carried_it_out",
		`UPDATE records.disposition_list SET state = 'executed'
		 WHERE list_id = $1`, listID)

	// A cancelled list with no reason is a destruction called off that
	// nobody can account for.
	f.mustFail(t, "a_cancelled_list_says_why",
		`UPDATE records.disposition_list SET state = 'cancelled'
		 WHERE list_id = $1`, listID)

	// Two lists under one reference is a destruction certificate naming two
	// different sets of records.
	insertReferencedList := `INSERT INTO records.disposition_list (
		list_id, tenant_id, reference, jurisdiction, disposition, state,
		prepared_at, prepared_by
	) VALUES ($1, $2, 'DL-1', 'IN', 'destroy', 'draft', $3, 'mrd-1')`
	f.mustExec(t, insertReferencedList, uuid.New(), f.tenantID, at)
	f.mustFail(t, "disposition_list_reference_idx", insertReferencedList,
		uuid.New(), f.tenantID, at)

	// The same record twice on one list is a count of what the hospital
	// destroyed that is wrong.
	insertItem := `INSERT INTO records.disposition_item (
		item_id, tenant_id, list_id, record_id, rule_code, rule_revision,
		eligible_from
	) VALUES ($1, $2, $3, 'r-1', 'R', 1, $4)`
	f.mustExec(t, insertItem, uuid.New(), f.tenantID, listID, at)
	f.mustFail(t, "disposition_item_record_idx", insertItem,
		uuid.New(), f.tenantID, listID, at)

	// The first question about a destruction is which rule allowed it.
	f.mustFail(t, "disposition_item_rule_code_check",
		`INSERT INTO records.disposition_item (
			item_id, tenant_id, list_id, record_id, rule_code, rule_revision,
			eligible_from
		) VALUES ($1, $2, $3, 'r-1', '', 1, $4)`,
		uuid.New(), f.tenantID, listID, at)
}

// SRS-MRD-006. A paper record's location and custodian round-trip, and the
// database refuses a record out to nobody.
func TestAPhysicalRecordRoundTripsWithItsCustodian(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	record, err := domain.RegisterPhysicalRecord(uuid.NewString(),
		f.tenantID, domain.NewPhysicalRecordInput{
			Reference: "MRN-4412", PatientID: "p1", Volume: 2,
			RecordClass: "inpatient", Jurisdiction: "IN",
			HomeLocation: "library bay 4",
		}, "mrd-1", at)
	if err != nil {
		t.Fatalf("RegisterPhysicalRecord: %v", err)
	}
	if err := f.repo.InsertPhysicalRecord(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertPhysicalRecord: %v", err)
	}

	if err := record.CheckOut("dr-1", "ward A", "clinic review",
		at.AddDate(0, 0, 7), "mrd-1", at); err != nil {
		t.Fatalf("CheckOut: %v", err)
	}
	if err := f.repo.UpdatePhysicalRecord(ctx, f.scope, record,
		1); err != nil {
		t.Fatalf("UpdatePhysicalRecord: %v", err)
	}

	back, err := f.repo.PhysicalRecord(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("PhysicalRecord: %v", err)
	}
	switch {
	case back.Custodian != "dr-1":
		t.Fatalf("custodian = %q", back.Custodian)
	case back.CurrentLocation != "ward A":
		t.Fatalf("location = %q", back.CurrentLocation)
	case back.Volume != 2:
		t.Fatalf("volume = %d", back.Volume)
	case back.Purpose == "":
		t.Fatal("what the record was wanted for was lost")
	}

	out, err := f.repo.PhysicalRecords(ctx, f.scope, ports.PhysicalFilter{
		OverdueOnly: true,
	}, at.AddDate(0, 0, 10))
	if err != nil {
		t.Fatalf("PhysicalRecords: %v", err)
	}
	if len(out) != 1 {
		t.Fatalf("%d overdue, want 1", len(out))
	}

	// The same folder and volume twice.
	f.mustFail(t, "physical_record_reference_idx",
		`INSERT INTO records.physical_record (
			record_id, tenant_id, reference, patient_id, volume, state,
			home_location, created_at, created_by
		) VALUES ($1, $2, 'MRN-4412', 'p1', 2, 'filed', 'bay 4', $3,
			'mrd-1')`, uuid.New(), f.tenantID, at)

	// A record out to "the ward" is a record nobody has to give back.
	f.mustFail(t, "a_record_out_names_its_custodian",
		`UPDATE records.physical_record
		 SET state = 'checked_out', custodian = '', current_location = '',
		     purpose = '', checked_out_at = $1
		 WHERE record_id = $2`, at, record.ID)

	// A filed record is with nobody.
	f.mustFail(t, "a_filed_record_is_with_nobody",
		`UPDATE records.physical_record
		 SET state = 'filed', custodian = 'dr-1'
		 WHERE record_id = $1`, record.ID)
}

func deathForm(t *testing.T, f fixture) domain.CertificateForm {
	t.Helper()
	ctx := context.Background()

	form, err := domain.NewCertificateForm(uuid.NewString(), f.tenantID,
		domain.NewCertificateFormInput{
			Code: "DEATH-IN", Name: "Cause of death", Revision: 1,
			Kind: domain.CertificateDeath, Jurisdiction: "IN",
			IssuerRole: "registered_medical_practitioner",
			Fields: []domain.CertificateField{
				{Code: "deceased_name", Label: "Name of deceased",
					Required: true, SourcePath: "patient.name"},
				{Code: "cause_i_a", Label: "Immediate cause", Required: true,
					SourcePath: "document.cause_of_death"},
			},
		}, "mrd-author", at)
	if err != nil {
		t.Fatalf("NewCertificateForm: %v", err)
	}
	if err := f.repo.InsertForm(ctx, f.scope, form); err != nil {
		t.Fatalf("InsertForm: %v", err)
	}
	if err := form.Approve("mrd-lead", at.AddDate(0, -1, 0), at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApproveForm(ctx, f.scope, form); err != nil {
		t.Fatalf("ApproveForm: %v", err)
	}
	return form
}

// SRS-MRD-007. A certificate's versions, values and sources survive, and a
// correction keeps the one that was issued.
func TestACertificateKeepsEveryVersionItIssued(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	form := deathForm(t, f)
	live, err := f.repo.Forms(ctx, f.scope, domain.CertificateDeath, "IN", at)
	if err != nil {
		t.Fatalf("Forms: %v", err)
	}
	if len(live) != 1 || len(live[0].Fields) != 2 {
		t.Fatalf("live forms = %+v", live)
	}

	values := map[string]string{
		"deceased_name": "Meera Iyer",
		"cause_i_a":     "acute myocardial infarction",
	}
	sources := map[string]string{
		"deceased_name": "patient:p1", "cause_i_a": "document:doc-7",
	}
	practitioner := domain.Issuer{
		SubjectID: "dr-1", Name: "Dr Rao",
		Role: "registered_medical_practitioner",
	}

	certificate, err := domain.IssueCertificate(uuid.NewString(), f.tenantID,
		live[0], "p1", "enc-1", values, sources, practitioner, "SERIAL-9",
		at)
	if err != nil {
		t.Fatalf("IssueCertificate: %v", err)
	}
	if err := f.repo.InsertCertificate(ctx, f.scope,
		certificate); err != nil {
		t.Fatalf("InsertCertificate: %v", err)
	}

	back, err := f.repo.Certificate(ctx, f.scope, certificate.ID)
	if err != nil {
		t.Fatalf("Certificate: %v", err)
	}
	current, _ := back.Current()
	switch {
	case len(back.Versions) != 1:
		t.Fatalf("%d versions, want 1", len(back.Versions))
	case current.Values["cause_i_a"] != "acute myocardial infarction":
		t.Fatalf("values lost: %+v", current.Values)
	case current.SourceRefs["cause_i_a"] != "document:doc-7":
		t.Fatalf("sources lost: %+v", current.SourceRefs)
	case current.SerialNumber != "SERIAL-9":
		t.Fatalf("serial = %q", current.SerialNumber)
	case back.FormRevision != 1:
		t.Fatalf("the form revision was not pinned: %+v", back)
	}

	corrected := map[string]string{
		"deceased_name": "Meera Iyer", "cause_i_a": "pulmonary embolism",
	}
	if err := back.Correct(live[0], corrected, sources, practitioner,
		"post-mortem findings", "", at.AddDate(0, 0, 3)); err != nil {
		t.Fatalf("Correct: %v", err)
	}
	next := back.Versions[len(back.Versions)-1]
	if err := f.repo.AppendVersion(ctx, f.scope, back, next, 1); err != nil {
		t.Fatalf("AppendVersion: %v", err)
	}

	after, err := f.repo.Certificate(ctx, f.scope, certificate.ID)
	if err != nil {
		t.Fatalf("Certificate: %v", err)
	}
	if len(after.Versions) != 2 {
		t.Fatalf("%d versions: the issued certificate was overwritten",
			len(after.Versions))
	}
	if after.Versions[0].Values["cause_i_a"] !=
		"acute myocardial infarction" {
		t.Fatalf("the first version changed: %+v", after.Versions[0])
	}
	if after.Versions[1].Reason == "" {
		t.Fatal("the correction does not say why")
	}

	_ = form
}

// SRS-MRD-007. The database holds the certificate rules.
func TestTheDatabaseHoldsTheCertificateRules(t *testing.T) {
	f := newFixture(t)

	formID := uuid.New()
	f.mustExec(t, `INSERT INTO records.certificate_form (
		form_id, tenant_id, code, revision, kind, jurisdiction, issuer_role,
		created_at, created_by
	) VALUES ($1, $2, 'F', 1, 'death', 'IN', 'rmp', $3, 'author-1')`,
		formID, f.tenantID, at)

	// The same code and revision twice: a certificate pinned to F revision 1
	// would have two forms to have been issued on.
	f.mustFail(t, "certificate_form_revision_idx",
		`INSERT INTO records.certificate_form (
			form_id, tenant_id, code, revision, kind, jurisdiction,
			issuer_role, created_at, created_by
		) VALUES ($1, $2, 'F', 1, 'death', 'IN', 'rmp', $3, 'author-2')`,
		uuid.New(), f.tenantID, at)

	f.mustFail(t, "a_form_is_approved_by_somebody_else",
		`UPDATE records.certificate_form
		 SET approved = true, approved_by = 'author-1', effective_from = $1
		 WHERE form_id = $2`, at, formID)

	insertField := `INSERT INTO records.certificate_field (
		field_id, tenant_id, form_id, code
	) VALUES ($1, $2, $3, $4)`
	f.mustExec(t, insertField, uuid.New(), f.tenantID, formID, "cause_i_a")
	f.mustFail(t, "certificate_field_code_idx", insertField,
		uuid.New(), f.tenantID, formID, "Cause_I_A")

	certificateID := uuid.New()
	f.mustExec(t, `INSERT INTO records.certificate (
		certificate_id, tenant_id, kind, form_code, form_revision,
		patient_id, state, created_at
	) VALUES ($1, $2, 'death', 'F', 1, 'p1', 'issued', $3)`,
		certificateID, f.tenantID, at)

	f.mustFail(t, "a_voided_certificate_says_why",
		`UPDATE records.certificate SET state = 'voided'
		 WHERE certificate_id = $1`, certificateID)

	insertVersion := `INSERT INTO records.certificate_version (
		version_id, tenant_id, certificate_id, version, reason, issuer_id,
		issuer_role, issued_at, serial_number
	) VALUES ($1, $2, $3, $4, $5, 'dr-1', 'rmp', $6, $7)`

	f.mustExec(t, insertVersion, uuid.New(), f.tenantID, certificateID, 1,
		"", at, "SERIAL-1")
	// A correction that does not say why.
	f.mustFail(t, "a_corrected_certificate_says_why", insertVersion,
		uuid.New(), f.tenantID, certificateID, 2, "", at, "SERIAL-1")
	// The same version number twice.
	f.mustFail(t, "certificate_version_number_idx", insertVersion,
		uuid.New(), f.tenantID, certificateID, 1, "", at, "SERIAL-1")
	// A correction reissued on the same serial is the ordinary case: the
	// registrar holds one document under that number.
	f.mustExec(t, insertVersion, uuid.New(), f.tenantID, certificateID, 2,
		"post-mortem findings", at, "SERIAL-1")

	// Two certificates sharing one statutory serial is how a registrar ends
	// up holding two different documents with one number. The serial belongs
	// to the certificate, so that is where the index is.
	f.mustExec(t, `UPDATE records.certificate SET serial_number = 'SERIAL-1'
		 WHERE certificate_id = $1`, certificateID)
	f.mustFail(t, "certificate_serial_idx",
		`INSERT INTO records.certificate (
			certificate_id, tenant_id, kind, form_code, form_revision,
			patient_id, serial_number, state, created_at
		) VALUES ($1, $2, 'death', 'F', 1, 'p2', 'SERIAL-1', 'issued', $3)`,
		uuid.New(), f.tenantID, at)
}
