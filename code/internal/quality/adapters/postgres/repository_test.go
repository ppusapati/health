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
	"github.com/ppusapati/health/code/internal/quality/adapters/postgres"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// The quality persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost risk band makes an extreme incident read as low; a lost
// effectiveness check makes a corrective action closable that should not be; a
// lost effective date makes a superseded policy the current one.
//
// Nine of these bypass the adapter and write raw SQL, because the rule under
// test belongs to the database rather than to Go.

var at = time.Date(2026, 9, 19, 10, 0, 0, 0, time.UTC)

type fixture struct {
	pool *pgxpool.Pool

	incidents      postgres.IncidentRepo
	investigations postgres.InvestigationRepo
	actions        postgres.ActionRepo
	documents      postgres.DocumentRepo
	competencies   postgres.CompetencyRepo
	audits         postgres.AuditRepo
	committees     postgres.CommitteeRepo
	accreditation  postgres.AccreditationRepo
	indicators     postgres.IndicatorRepo
	complaints     postgres.ComplaintRepo
	peerReviews    postgres.PeerReviewRepo

	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := postgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:           pool,
		incidents:      postgres.IncidentRepo{Repository: repo},
		investigations: postgres.InvestigationRepo{Repository: repo},
		actions:        postgres.ActionRepo{Repository: repo},
		documents:      postgres.DocumentRepo{Repository: repo},
		competencies:   postgres.CompetencyRepo{Repository: repo},
		audits:         postgres.AuditRepo{Repository: repo},
		committees:     postgres.CommitteeRepo{Repository: repo},
		accreditation:  postgres.AccreditationRepo{Repository: repo},
		indicators:     postgres.IndicatorRepo{Repository: repo},
		complaints:     postgres.ComplaintRepo{Repository: repo},
		peerReviews:    postgres.PeerReviewRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "quality-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

func (f fixture) reportIncident(t *testing.T,
	mutate func(*domain.NewIncidentInput)) domain.Incident {

	t.Helper()
	in := domain.NewIncidentInput{
		Reference: "INC-" + uuid.NewString()[:8], Category: "medication",
		Reach: domain.ReachNearMiss, Harm: domain.HarmNone,
		Consequence: domain.ConsequenceMajor,
		Likelihood:  domain.LikelihoodPossible,
		Narrative:   "wrong dose drawn up, caught at the second check",
		Department:  "paediatrics", FacilityID: "main",
		OccurredAt: at.Add(-time.Hour),
	}
	if mutate != nil {
		mutate(&in)
	}
	incident, err := domain.ReportIncident(uuid.NewString(), f.tenantID, in,
		"nurse-1", at)
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	if err := f.incidents.InsertIncident(context.Background(), f.scope,
		incident); err != nil {
		t.Fatalf("InsertIncident: %v", err)
	}
	return incident
}

// SRS-QMS-001, SRS-QMS-002. The fields that decide whether an incident is
// escalated, restricted and counted all survive the round trip. A lost risk
// band reads as "low" and the incident is never looked at again.
func TestAnIncidentRoundTripsWithWhatDecidesItsHandling(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	written := f.reportIncident(t, func(in *domain.NewIncidentInput) {
		in.Reach = domain.ReachHarm
		in.Harm = domain.HarmSevere
		in.ImmediateAction = "returned to theatre"
		in.PatientID = "pat-1"
		in.Consequence = domain.ConsequenceCatastrophic
		in.Likelihood = domain.LikelihoodLikely
		in.Anonymous = true
		// Declared rather than derived: the domain auto-escalates a death and
		// nothing else, because which other outcomes a hospital reviews as
		// sentinel events is its own published list. What is under test here
		// is that the declaration and the restriction it forces survive.
		in.Sentinel = true
	})

	read, err := f.incidents.Incident(ctx, f.scope, written.ID)
	if err != nil {
		t.Fatalf("Incident: %v", err)
	}

	if read.Risk.Score != written.Risk.Score || read.Risk.Band != domain.RiskExtreme {
		t.Fatalf("risk = %+v, want %+v", read.Risk, written.Risk)
	}
	if read.Reach != domain.ReachHarm || read.Harm != domain.HarmSevere {
		t.Fatalf("reach/harm = %s/%s, want harm/severe", read.Reach, read.Harm)
	}
	if !read.Sentinel {
		t.Fatal("a declared sentinel event lost its flag")
	}
	if !read.Restricted {
		t.Fatal("a sentinel event read back unrestricted")
	}
	if !read.Anonymous || read.ReportedBy != "nurse-1" {
		t.Fatalf("anonymity = %v / reporter %q, want the trail to still know",
			read.Anonymous, read.ReportedBy)
	}
	if read.ImmediateAction != written.ImmediateAction {
		t.Fatalf("immediate action = %q, want it kept", read.ImmediateAction)
	}
}

// SRS-QMS-001. A near miss recorded with harm is a contradiction, and the
// database refuses both directions of it.
func TestTheDatabaseRefusesAContradictoryIncident(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, state, occurred_at, reported_at, reported_by)
		VALUES ($1, $2, 'INC-X', 'falls', 'near_miss', 'moderate',
		        'moderate', 'possible', 9, 'moderate', 'caught it',
		        '', 'reported', now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted harm on a near miss")
	}
	if !strings.Contains(err.Error(), "a_near_miss_harmed_nobody") {
		t.Fatalf("refused by %v, want the near-miss constraint", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, state, occurred_at, reported_at, reported_by)
		VALUES ($1, $2, 'INC-Y', 'falls', 'harm', 'none',
		        'moderate', 'possible', 9, 'moderate', 'fell',
		        'reviewed', 'reported', now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted an event classed as harm with no harm")
	}
	if !strings.Contains(err.Error(), "harm_records_its_level") {
		t.Fatalf("refused by %v, want the harm-level constraint", err)
	}
}

// SRS-QMS-005. A death recorded as a routine incident is how a sentinel event
// goes unreviewed, and a sentinel event that is not restricted is peer-review
// material anybody can read.
func TestTheDatabaseRefusesADeathThatIsNotASentinelEvent(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, sentinel, restricted, state, occurred_at,
		    reported_at, reported_by)
		VALUES ($1, $2, 'INC-X', 'falls', 'harm', 'death',
		        'catastrophic', 'rare', 5, 'moderate', 'fell',
		        'resuscitated', false, false, 'reported', now(), now(), 'n-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted a death as a routine incident")
	}
	if !strings.Contains(err.Error(), "a_death_is_a_sentinel_event") {
		t.Fatalf("refused by %v, want the sentinel constraint", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, sentinel, restricted, state, occurred_at,
		    reported_at, reported_by)
		VALUES ($1, $2, 'INC-Y', 'falls', 'harm', 'death',
		        'catastrophic', 'rare', 5, 'moderate', 'fell',
		        'resuscitated', true, false, 'reported', now(), now(), 'n-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted an unrestricted sentinel event")
	}
	if !strings.Contains(err.Error(), "a_sentinel_event_is_restricted") {
		t.Fatalf("refused by %v, want the restriction constraint", err)
	}
}

// SRS-QMS-002. The band is stored for the reports that filter on it, and held
// to the arithmetic so the two can never disagree.
func TestTheDatabaseRefusesABandThatDoesNotMatchItsScore(t *testing.T) {
	f := newFixture(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, state, occurred_at, reported_at, reported_by)
		VALUES ($1, $2, 'INC-X', 'falls', 'near_miss', 'none',
		        'catastrophic', 'almost_certain', 25, 'low', 'caught it',
		        '', 'reported', now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted a score of 25 banded as low")
	}
	if !strings.Contains(err.Error(), "the_band_matches_the_score") {
		t.Fatalf("refused by %v, want the band constraint", err)
	}
}

// SRS-QMS-001. An event that reached a patient and produced no action is
// either an incomplete report or a failure to respond.
func TestTheDatabaseRefusesAnUnansweredEvent(t *testing.T) {
	f := newFixture(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO quality.incident (
		    incident_id, tenant_id, reference, category, reach, harm,
		    consequence, likelihood, risk_score, risk_band, narrative,
		    immediate_action, state, occurred_at, reported_at, reported_by)
		VALUES ($1, $2, 'INC-X', 'falls', 'no_harm', 'none',
		        'minor', 'possible', 6, 'moderate', 'fell',
		        '', 'reported', now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted an event with no immediate action")
	}
	if !strings.Contains(err.Error(), "what_reached_a_patient_was_acted_on") {
		t.Fatalf("refused by %v, want the immediate-action constraint", err)
	}
}

// SRS-QMS-003. The analysis and its factors round-trip, and the root marking
// survives — an analysis that loses which factor was the cause has recorded a
// list of circumstances.
func TestAnAnalysisRoundTripsWithItsFactors(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	incident := f.reportIncident(t, nil)
	rca, err := domain.StartRCA(uuid.NewString(), f.tenantID, incident.ID,
		"london_protocol", true, "quality-1", at)
	if err != nil {
		t.Fatalf("StartRCA: %v", err)
	}
	if err := f.investigations.InsertRCA(ctx, f.scope, rca); err != nil {
		t.Fatalf("InsertRCA: %v", err)
	}

	for _, factor := range []domain.ContributingFactor{
		{Category: domain.FactorOrganisational,
			Detail: "two nurses covering four bays overnight", Root: true},
		{Category: domain.FactorEnvironment,
			Detail: "the drug room light was out"},
	} {
		if err := f.investigations.AddFactor(ctx, f.scope, rca.ID,
			uuid.NewString(), factor); err != nil {
			t.Fatalf("AddFactor: %v", err)
		}
	}

	factors, err := f.investigations.Factors(ctx, f.scope, rca.ID)
	if err != nil {
		t.Fatalf("Factors: %v", err)
	}
	if len(factors) != 2 {
		t.Fatalf("factors = %v, want two", factors)
	}
	// Root first, which is what a reader of a long analysis needs.
	if !factors[0].Root || factors[1].Root {
		t.Fatalf("factors = %+v, want the root cause first and marked", factors)
	}

	// And the analysis is reachable from the incident, which is how a reviewer
	// gets to it.
	found, ok, err := f.investigations.RCAForIncident(ctx, f.scope, incident.ID)
	if err != nil || !ok {
		t.Fatalf("RCAForIncident = %v, %v", ok, err)
	}
	if found.ID != rca.ID || !found.Restricted {
		t.Fatalf("analysis = %+v, want the restricted one", found)
	}
}

func (f fixture) raiseCAPA(t *testing.T,
	mutate func(*domain.NewCAPAInput)) domain.CAPA {

	t.Helper()
	in := domain.NewCAPAInput{
		Reference: "CAPA-" + uuid.NewString()[:8], Kind: domain.ActionPreventive,
		SourceKind: domain.SourceIncident, SourceID: uuid.NewString(),
		Action:  "second nurse rostered overnight",
		OwnerID: "matron-1",
		DueOn:   at.AddDate(0, 1, 0), EffectivenessDueOn: at.AddDate(0, 3, 0),
	}
	if mutate != nil {
		mutate(&in)
	}
	capa, err := domain.RaiseCAPA(uuid.NewString(), f.tenantID, in,
		"quality-1", at)
	if err != nil {
		t.Fatalf("RaiseCAPA: %v", err)
	}
	if err := f.actions.InsertCAPA(context.Background(), f.scope, capa); err != nil {
		t.Fatalf("InsertCAPA: %v", err)
	}
	return capa
}

// SRS-QMS-004. Every effectiveness check comes back, including the one that
// failed — and an action loaded without them would look unchecked, which is
// the one state that makes it closable when it should not be.
func TestAnActionRoundTripsWithEveryEffectivenessCheck(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	capa := f.raiseCAPA(t, nil)
	for _, check := range []domain.EffectivenessCheck{
		{CheckedAt: at.AddDate(0, 3, 0), CheckedBy: "quality-1",
			Effective: false, Evidence: "re-audit found the same gap"},
		{CheckedAt: at.AddDate(0, 4, 0), CheckedBy: "quality-1",
			Effective: true, Evidence: "re-audit clean over twenty nights"},
	} {
		if err := f.actions.AppendCheck(ctx, f.scope, capa.ID,
			uuid.NewString(), check); err != nil {
			t.Fatalf("AppendCheck: %v", err)
		}
	}

	read, err := f.actions.CAPA(ctx, f.scope, capa.ID)
	if err != nil {
		t.Fatalf("CAPA: %v", err)
	}
	if len(read.Checks) != 2 {
		t.Fatalf("checks = %d, want the failed one kept too", len(read.Checks))
	}
	if read.Checks[0].Effective || !read.Checks[1].Effective {
		t.Fatalf("checks = %+v, want them in order with the failure first",
			read.Checks)
	}
	if !read.Effective() {
		t.Fatal("the latest check passed and the action reads as ineffective")
	}

	// The list read carries them too: the overdue report calls Effective(),
	// and a list loaded without checks would escalate the whole hospital.
	listed, err := f.actions.CAPAs(ctx, f.scope, ports.CAPAFilter{
		LiveOnly: true, Limit: 50,
	})
	if err != nil {
		t.Fatalf("CAPAs: %v", err)
	}
	if len(listed) != 1 || len(listed[0].Checks) != 2 {
		t.Fatalf("listed = %+v, want the checks carried into the list", listed)
	}
}

// SRS-QMS-004. Two separations at the two ends of an action, both in the
// schema: the approver is not the raiser, and the closer is not the owner.
func TestTheDatabaseRefusesSelfApprovalAtBothEnds(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.capa (
		    capa_id, tenant_id, reference, kind, source_kind, source_id,
		    action, owner_id, due_on, state, approved_by, raised_at, raised_by)
		VALUES ($1, $2, 'CAPA-X', 'preventive', 'incident', 'i1',
		        'do the thing', 'matron-1', now(), 'approved',
		        'quality-1', now(), 'quality-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted an action approved by its raiser")
	}
	if !strings.Contains(err.Error(), "an_action_is_approved_by_somebody_else") {
		t.Fatalf("refused by %v, want the approval constraint", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.capa (
		    capa_id, tenant_id, reference, kind, source_kind, source_id,
		    action, owner_id, due_on, state, closed_by, raised_at, raised_by)
		VALUES ($1, $2, 'CAPA-Y', 'preventive', 'incident', 'i1',
		        'do the thing', 'matron-1', now(), 'closed',
		        'matron-1', now(), 'quality-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted an action closed by its owner")
	}
	if !strings.Contains(err.Error(),
		"the_owner_does_not_approve_their_own_closure") {
		t.Fatalf("refused by %v, want the closure constraint", err)
	}
}

// SRS-QMS-006. A version's effective date is what the current-version rule
// reads, and a version with one that nobody approved would be shown as policy.
func TestTheDatabaseRefusesAnUnapprovedEffectiveVersion(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	document := f.document(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.document_version (
		    version_id, tenant_id, document_id, label, ordinal, content_ref,
		    state, effective_from, created_at, created_by)
		VALUES ($1, $2, $3, 'v1', 1, 'blob://v1', 'draft', now(),
		        now(), 'author-1')`,
		uuid.New(), f.tenantID, document.ID)
	if err == nil {
		t.Fatal("the database accepted an effective date with no approval")
	}
	if !strings.Contains(err.Error(), "an_effective_date_implies_an_approval") {
		t.Fatalf("refused by %v, want the approval constraint", err)
	}

	// And the author cannot approve their own.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.document_version (
		    version_id, tenant_id, document_id, label, ordinal, content_ref,
		    state, approved_by, approved_at, effective_from, created_at,
		    created_by)
		VALUES ($1, $2, $3, 'v2', 2, 'blob://v2', 'approved', 'author-1',
		        now(), now(), now(), 'author-1')`,
		uuid.New(), f.tenantID, document.ID)
	if err == nil {
		t.Fatal("the database accepted a self-approved version")
	}
	if !strings.Contains(err.Error(),
		"the_author_does_not_approve_their_own_version") {
		t.Fatalf("refused by %v, want the self-approval constraint", err)
	}
}

func (f fixture) document(t *testing.T) domain.ControlledDocument {
	t.Helper()
	document, err := domain.NewControlledDocument(uuid.NewString(), f.tenantID,
		domain.NewDocumentInput{
			Code: "IPC-" + uuid.NewString()[:6], Title: "Hand hygiene policy",
			Kind: domain.DocumentSOP, OwnerID: "ipc-1", ReviewMonths: 24,
		}, "quality-1", at)
	if err != nil {
		t.Fatalf("NewControlledDocument: %v", err)
	}
	if err := f.documents.InsertDocument(context.Background(), f.scope,
		document); err != nil {
		t.Fatalf("InsertDocument: %v", err)
	}
	return document
}

// SRS-QMS-006. The versions round-trip with the two flags that decide what a
// revision costs the hospital: who has to read it again, and whose training
// lapses.
func TestDocumentVersionsRoundTripWithWhatARevisionCosts(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	document := f.document(t)

	version, err := domain.DraftVersion(uuid.NewString(), f.tenantID,
		domain.NewVersionInput{
			DocumentID: document.ID, Label: "3.1", Ordinal: 3,
			ContentRef: "blob://v3", ChangeSummary: "added the five moments",
			RequiresAcknowledgement: true, RequiresRetraining: true,
		}, "author-1", at)
	if err != nil {
		t.Fatalf("DraftVersion: %v", err)
	}
	if err := f.documents.InsertVersion(ctx, f.scope, version); err != nil {
		t.Fatalf("InsertVersion: %v", err)
	}
	if err := version.ApproveVersion("ipc-1", at.AddDate(0, 1, 0), at); err != nil {
		t.Fatalf("ApproveVersion: %v", err)
	}
	if err := f.documents.UpdateVersion(ctx, f.scope, version,
		version.Version); err != nil {
		t.Fatalf("UpdateVersion: %v", err)
	}

	versions, err := f.documents.Versions(ctx, f.scope, document.ID)
	if err != nil {
		t.Fatalf("Versions: %v", err)
	}
	if len(versions) != 1 {
		t.Fatalf("versions = %v, want one", versions)
	}
	read := versions[0]
	if !read.RequiresAcknowledgement || !read.RequiresRetraining {
		t.Fatalf("version = %+v, want both revision flags kept", read)
	}
	if !read.EffectiveFrom.Equal(at.AddDate(0, 1, 0)) {
		t.Fatalf("effective from = %v, want next month", read.EffectiveFrom)
	}
	// Not yet in force, because the date has not arrived — which is the whole
	// reason the date is stored rather than a current flag.
	if _, found := domain.CurrentVersion(versions, at); found {
		t.Fatal("a version effective next month is already the document")
	}
	if current, found := domain.CurrentVersion(versions,
		at.AddDate(0, 2, 0)); !found || current.ID != read.ID {
		t.Fatalf("current next month = %+v (%v), want this version",
			current, found)
	}
}

// SRS-QMS-006. A second acknowledgement from the same person must not make
// the compliance count look better than it is; and the acknowledgement is per
// version, so a revision reopens it.
func TestAcknowledgementIsOncePerPersonPerVersion(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	document := f.document(t)

	version, err := domain.DraftVersion(uuid.NewString(), f.tenantID,
		domain.NewVersionInput{
			DocumentID: document.ID, Label: "1.0", Ordinal: 1,
			ContentRef: "blob://v1", RequiresAcknowledgement: true,
		}, "author-1", at)
	if err != nil {
		t.Fatalf("DraftVersion: %v", err)
	}
	if err := f.documents.InsertVersion(ctx, f.scope, version); err != nil {
		t.Fatalf("InsertVersion: %v", err)
	}

	for i := 0; i < 2; i++ {
		if err := f.documents.Acknowledge(ctx, f.scope, domain.Acknowledgement{
			ID: uuid.NewString(), TenantID: f.tenantID,
			VersionID: version.ID, DocumentID: document.ID,
			PersonID: "nurse-1", Role: "nurse", AcknowledgedAt: at,
		}); err != nil {
			t.Fatalf("Acknowledge(%d): %v", i, err)
		}
	}

	acks, err := f.documents.Acknowledgements(ctx, f.scope, version.ID)
	if err != nil {
		t.Fatalf("Acknowledgements: %v", err)
	}
	if len(acks) != 1 {
		t.Fatalf("acknowledgements = %d, want one per person", len(acks))
	}
}

// SRS-QMS-007. The whole of "audit trail links finding to closure" in the
// schema: a non-conformity cannot be closed without an action.
func TestTheDatabaseRefusesANonConformityClosedWithoutAnAction(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	audit := f.audit(t)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.audit_finding (
		    finding_id, tenant_id, audit_id, severity, detail, evidence,
		    closed_at, closed_by, closure_note, raised_at, raised_by)
		VALUES ($1, $2, $3, 'major_nc', 'no audit run for eight months',
		        'audit register', now(), 'quality-1',
		        'discussed with the ward', now(), 'auditor-1')`,
		uuid.New(), f.tenantID, audit.ID)
	if err == nil {
		t.Fatal("the database accepted a major non-conformity closed with a note")
	}
	if !strings.Contains(err.Error(),
		"a_non_conformity_closes_through_an_action") {
		t.Fatalf("refused by %v, want the closure constraint", err)
	}

	// And a non-conformity with no evidence is an opinion.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.audit_finding (
		    finding_id, tenant_id, audit_id, severity, detail, evidence,
		    raised_at, raised_by)
		VALUES ($1, $2, $3, 'minor_nc', 'a gap', '', now(), 'auditor-1')`,
		uuid.New(), f.tenantID, audit.ID)
	if err == nil {
		t.Fatal("the database accepted a non-conformity with no evidence")
	}
	if !strings.Contains(err.Error(), "a_non_conformity_records_its_evidence") {
		t.Fatalf("refused by %v, want the evidence constraint", err)
	}
}

func (f fixture) audit(t *testing.T) domain.Audit {
	t.Helper()
	audit, err := domain.PlanAudit(uuid.NewString(), f.tenantID,
		domain.NewAuditInput{
			Reference: "AUD-" + uuid.NewString()[:8],
			Title:     "IPC audit", Scope: "hand hygiene",
			AuditorID: "auditor-1", AuditeeDepartment: "medicine",
			PlannedFrom: at, PlannedTo: at.AddDate(0, 0, 7),
		}, "quality-1", at)
	if err != nil {
		t.Fatalf("PlanAudit: %v", err)
	}
	if err := f.audits.InsertAudit(context.Background(), f.scope,
		audit); err != nil {
		t.Fatalf("InsertAudit: %v", err)
	}
	return audit
}

// SRS-QMS-008. Minutes and decisions round-trip, and approved minutes that
// record nobody present cannot be written.
func TestMeetingMinutesRoundTripAndCannotBeApprovedEmpty(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	committee := domain.Committee{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Code: "QC-" + uuid.NewString()[:6], Name: "Quality committee",
		QuorumSize: 4, Active: true,
		Members:   []string{"a", "b", "c", "d", "e", "f"},
		CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.committees.InsertCommittee(ctx, f.scope, committee); err != nil {
		t.Fatalf("InsertCommittee: %v", err)
	}

	meeting := domain.Meeting{
		ID: uuid.NewString(), TenantID: f.tenantID,
		CommitteeID: committee.ID, ScheduledAt: at,
		Agenda:    []string{"incident log", "CAPA review"},
		State:     domain.MeetingScheduled,
		CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.committees.InsertMeeting(ctx, f.scope, meeting); err != nil {
		t.Fatalf("InsertMeeting: %v", err)
	}

	if err := meeting.HoldMeeting([]string{"a", "b", "c", "d"}, []string{"e"},
		"reviewed the incident log",
		[]domain.Decision{{
			Text: "roster a second nurse overnight", ActionIDs: []string{"c1"},
		}}, at); err != nil {
		t.Fatalf("HoldMeeting: %v", err)
	}
	if err := meeting.ApproveMinutes(committee, "chair-1", at); err != nil {
		t.Fatalf("ApproveMinutes: %v", err)
	}
	if err := f.committees.UpdateMeeting(ctx, f.scope, meeting,
		meeting.Version); err != nil {
		t.Fatalf("UpdateMeeting: %v", err)
	}

	read, err := f.committees.Meeting(ctx, f.scope, meeting.ID)
	if err != nil {
		t.Fatalf("Meeting: %v", err)
	}
	if len(read.Decisions) != 1 ||
		read.Decisions[0].Text != "roster a second nurse overnight" {
		t.Fatalf("decisions = %+v, want the one taken", read.Decisions)
	}
	if len(read.Decisions[0].ActionIDs) != 1 {
		t.Fatalf("decision actions = %v, want the action it raised",
			read.Decisions[0].ActionIDs)
	}
	if len(read.Attendees) != 4 || len(read.Apologies) != 1 {
		t.Fatalf("attendance = %v / %v, want four present and one apology",
			read.Attendees, read.Apologies)
	}

	// Approved minutes recording nobody present cannot be checked for quorum
	// by anybody, ever.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.committee_meeting (
		    meeting_id, tenant_id, committee_id, scheduled_at, held_at,
		    minutes, state, created_at, created_by)
		VALUES ($1, $2, $3, now(), now(), 'we met', 'minutes_approved',
		        now(), 'quality-1')`,
		uuid.New(), f.tenantID, committee.ID)
	if err == nil {
		t.Fatal("the database accepted approved minutes with no attendance")
	}
	if !strings.Contains(err.Error(),
		"approved_minutes_record_who_was_there") {
		t.Fatalf("refused by %v, want the attendance constraint", err)
	}
}

// SRS-QMS-009. The evidence map reads by clause, and a clause found not met
// must name what will close it.
func TestTheEvidenceMapReadsByClauseAndNotMetNamesItsAction(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	standard := domain.Standard{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Code: "NABH-" + uuid.NewString()[:6], Name: "NABH", Edition: "5th",
		Active: true, CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.accreditation.InsertStandard(ctx, f.scope, standard); err != nil {
		t.Fatalf("InsertStandard: %v", err)
	}

	clauses := []domain.Clause{
		{ID: uuid.NewString(), TenantID: f.tenantID, StandardID: standard.ID,
			Reference: "AAC.1.a", Chapter: "AAC", Critical: true, CreatedAt: at},
		{ID: uuid.NewString(), TenantID: f.tenantID, StandardID: standard.ID,
			Reference: "AAC.1.b", Chapter: "AAC", CreatedAt: at},
	}
	if err := f.accreditation.InsertClauses(ctx, f.scope, clauses); err != nil {
		t.Fatalf("InsertClauses: %v", err)
	}

	evidence, err := domain.AddEvidence(uuid.NewString(), f.tenantID,
		clauses[0].ID, domain.EvidenceExternal, "", "FIRE-NOC-2026/114",
		"fire no-objection certificate, in the safety office", "quality-1", at)
	if err != nil {
		t.Fatalf("AddEvidence: %v", err)
	}
	if err := f.accreditation.InsertEvidence(ctx, f.scope, evidence); err != nil {
		t.Fatalf("InsertEvidence: %v", err)
	}

	byClause, err := f.accreditation.EvidenceForStandard(ctx, f.scope,
		standard.ID, true)
	if err != nil {
		t.Fatalf("EvidenceForStandard: %v", err)
	}
	if len(byClause[clauses[0].ID]) != 1 || len(byClause[clauses[1].ID]) != 0 {
		t.Fatalf("evidence = %v, want it filed against the first clause only",
			byClause)
	}
	if byClause[clauses[0].ID][0].ExternalRef != "FIRE-NOC-2026/114" {
		t.Fatalf("evidence = %+v, want the external reference kept",
			byClause[clauses[0].ID][0])
	}

	// A gap recorded with nothing to close it is a gap the survey finds in the
	// same state next year.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.clause_review (
		    review_id, tenant_id, clause_id, verdict, note, reviewed_at,
		    reviewed_by)
		VALUES ($1, $2, $3, 'not_met', 'no policy exists', now(), 'quality-1')`,
		uuid.New(), f.tenantID, clauses[1].ID)
	if err == nil {
		t.Fatal("the database accepted a not-met clause with no action")
	}
	if !strings.Contains(err.Error(), "a_clause_not_met_names_its_action") {
		t.Fatalf("refused by %v, want the action constraint", err)
	}
}

// SRS-QMS-009. Three reviews of one clause leave three judgements, and the
// readiness view reads the last of them.
func TestTheLatestReviewPerClauseIsWhatCounts(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	standard := domain.Standard{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Code: "NABH-" + uuid.NewString()[:6], Name: "NABH", Edition: "5th",
		Active: true, CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.accreditation.InsertStandard(ctx, f.scope, standard); err != nil {
		t.Fatalf("InsertStandard: %v", err)
	}
	clause := domain.Clause{
		ID: uuid.NewString(), TenantID: f.tenantID, StandardID: standard.ID,
		Reference: "AAC.1.a", Chapter: "AAC", CreatedAt: at,
	}
	if err := f.accreditation.InsertClauses(ctx, f.scope,
		[]domain.Clause{clause}); err != nil {
		t.Fatalf("InsertClauses: %v", err)
	}

	evidence, err := domain.AddEvidence(uuid.NewString(), f.tenantID, clause.ID,
		domain.EvidenceExternal, "", "REF-1", "a certificate", "quality-1", at)
	if err != nil {
		t.Fatalf("AddEvidence: %v", err)
	}
	if err := f.accreditation.InsertEvidence(ctx, f.scope, evidence); err != nil {
		t.Fatalf("InsertEvidence: %v", err)
	}

	for i, verdict := range []domain.Verdict{
		domain.VerdictPartiallyMet, domain.VerdictMet,
	} {
		review, err := domain.ReviewClause(uuid.NewString(), f.tenantID,
			clause.ID, verdict, "reviewed", "", []domain.Evidence{evidence},
			"quality-1", at.AddDate(0, i, 0))
		if err != nil {
			t.Fatalf("ReviewClause(%s): %v", verdict, err)
		}
		if err := f.accreditation.InsertClauseReview(ctx, f.scope,
			review); err != nil {
			t.Fatalf("InsertClauseReview: %v", err)
		}
	}

	latest, err := f.accreditation.LatestReviews(ctx, f.scope, standard.ID)
	if err != nil {
		t.Fatalf("LatestReviews: %v", err)
	}
	if len(latest) != 1 {
		t.Fatalf("reviews = %v, want one per clause", latest)
	}
	if latest[clause.ID].Verdict != domain.VerdictMet {
		t.Fatalf("verdict = %q, want the most recent", latest[clause.ID].Verdict)
	}
}

// SRS-QMS-010. An indicator's history is versioned by revision, and one
// period cannot carry two values.
func TestAnIndicatorIsVersionedAndAPeriodHasOneValue(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	code := "HH-" + uuid.NewString()[:6]

	first := f.defineKPI(t, code, 1, 850)
	value, err := domain.RecordKPIValue(uuid.NewString(), f.tenantID, first,
		at.AddDate(0, -1, 0), at, 174, 200, "IPC register", "ipc-1", at)
	if err != nil {
		t.Fatalf("RecordKPIValue: %v", err)
	}
	if err := f.indicators.InsertValue(ctx, f.scope, value); err != nil {
		t.Fatalf("InsertValue: %v", err)
	}

	// The same period again is refused: two points on the chart for one month
	// is an argument in a committee meeting.
	again := value
	again.ID = uuid.NewString()
	if err := f.indicators.InsertValue(ctx, f.scope, again); err == nil {
		t.Fatal("the database accepted two values for one period")
	}

	// A revision makes a new dictionary entry rather than editing the old one,
	// and the old value keeps pointing at the revision it was computed under.
	second := f.defineKPI(t, code, 2, 900)
	if err := f.indicators.Supersede(ctx, f.scope, code, 2, at); err != nil {
		t.Fatalf("Supersede: %v", err)
	}

	current, found, err := f.indicators.CurrentDefinition(ctx, f.scope, code)
	if err != nil || !found {
		t.Fatalf("CurrentDefinition = %v, %v", found, err)
	}
	if current.Revision != 2 || current.ID != second.ID {
		t.Fatalf("current = %+v, want revision 2", current)
	}

	values, err := f.indicators.Values(ctx, f.scope, code, time.Time{},
		time.Time{})
	if err != nil {
		t.Fatalf("Values: %v", err)
	}
	if len(values) != 1 || values[0].Revision != 1 {
		t.Fatalf("values = %+v, want the old value still naming revision 1",
			values)
	}
	if values[0].Permille != 870 {
		t.Fatalf("permille = %d, want 870", values[0].Permille)
	}
}

func (f fixture) defineKPI(t *testing.T, code string, revision,
	target int) domain.KPIDefinition {

	t.Helper()
	definition, err := domain.DefineKPI(uuid.NewString(), f.tenantID,
		domain.NewKPIInput{
			Code: code, Name: "Hand hygiene compliance", Revision: revision,
			Numerator:   "opportunities with hand hygiene performed",
			Denominator: "observed opportunities",
			Unit:        "percent", TargetPermille: target,
			Direction: domain.DirectionHigherIsBetter,
			Frequency: domain.FrequencyMonthly, OwnerID: "ipc-1",
			EffectiveFrom: at.AddDate(-1, 0, 0),
		}, "quality-1", at)
	if err != nil {
		t.Fatalf("DefineKPI: %v", err)
	}
	if err := f.indicators.InsertDefinition(context.Background(), f.scope,
		definition); err != nil {
		t.Fatalf("InsertDefinition: %v", err)
	}
	return definition
}

// SRS-QMS-010. "No eligible cases this month" and "we failed every case this
// month" are opposite facts, and the schema will not let a value say both.
func TestTheDatabaseRefusesAZeroDenominatorReportedAsMeasured(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	definition := f.defineKPI(t, "HH-"+uuid.NewString()[:6], 1, 850)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.kpi_value (
		    value_id, tenant_id, definition_id, code, revision, period_from,
		    period_to, numerator, denominator, permille, unanswerable,
		    source_note, recorded_at, recorded_by)
		VALUES ($1, $2, $3, $4, 1, now() - interval '30 days', now(),
		        0, 0, 0, false, 'register', now(), 'ipc-1')`,
		uuid.New(), f.tenantID, definition.ID, definition.Code)
	if err == nil {
		t.Fatal("the database accepted an unmeasured period reported as measured")
	}
	if !strings.Contains(err.Error(), "an_unmeasured_period_says_so") {
		t.Fatalf("refused by %v, want the unanswerable constraint", err)
	}

	// And a rate above 100% is not a measurement.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.kpi_value (
		    value_id, tenant_id, definition_id, code, revision, period_from,
		    period_to, numerator, denominator, permille, unanswerable,
		    source_note, recorded_at, recorded_by)
		VALUES ($1, $2, $3, $4, 1, now() - interval '30 days', now(),
		        210, 200, 1050, false, 'register', now(), 'ipc-1')`,
		uuid.New(), f.tenantID, definition.ID, definition.Code)
	if err == nil {
		t.Fatal("the database accepted a numerator larger than its denominator")
	}
	if !strings.Contains(err.Error(),
		"a_rate_does_not_exceed_its_denominator") {
		t.Fatalf("refused by %v, want the rate constraint", err)
	}
}

// SRS-QMS-011. Both clocks round-trip, and a complaint resolved without the
// complainant ever being spoken to cannot be written.
func TestAComplaintRoundTripsWithBothClocks(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	complaint, err := domain.ReceiveComplaint(uuid.NewString(), f.tenantID,
		domain.NewComplaintInput{
			Reference: "COMP-" + uuid.NewString()[:8],
			Kind:      domain.ComplainantRelative,
			Category:  "communication", Detail: "nobody explained the delay",
			ReceivedAt:        at,
			AcknowledgeWithin: 48 * time.Hour,
			ResolveWithin:     30 * 24 * time.Hour,
		}, "pro-1", at)
	if err != nil {
		t.Fatalf("ReceiveComplaint: %v", err)
	}
	if err := f.complaints.InsertComplaint(ctx, f.scope, complaint); err != nil {
		t.Fatalf("InsertComplaint: %v", err)
	}

	read, err := f.complaints.Complaint(ctx, f.scope, complaint.ID)
	if err != nil {
		t.Fatalf("Complaint: %v", err)
	}
	if !read.AcknowledgeBy.Equal(at.Add(48*time.Hour)) ||
		!read.ResolveBy.Equal(at.Add(30*24*time.Hour)) {
		t.Fatalf("clocks = %v / %v, want both kept",
			read.AcknowledgeBy, read.ResolveBy)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.complaint (
		    complaint_id, tenant_id, reference, kind, category, detail,
		    state, outcome, resolution, received_at, received_by)
		VALUES ($1, $2, 'COMP-X', 'patient', 'waiting', 'four hours',
		        'resolved', 'upheld', 'apologised', now(), 'pro-1')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("the database accepted a resolution with no acknowledgement")
	}
	if !strings.Contains(err.Error(), "a_resolution_was_acknowledged") {
		t.Fatalf("refused by %v, want the acknowledgement constraint", err)
	}
}

// SRS-QMS-012. A potentially preventable death classified with no action
// raised is a hospital that has written down that it could have done better
// and done nothing.
func TestTheDatabaseRefusesAPreventableDeathWithNoAction(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	committee := domain.Committee{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Code: "MM-" + uuid.NewString()[:6], Name: "M&M", Restricted: true,
		Active: true, Members: []string{"a", "b"},
		CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.committees.InsertCommittee(ctx, f.scope, committee); err != nil {
		t.Fatalf("InsertCommittee: %v", err)
	}
	meeting := domain.Meeting{
		ID: uuid.NewString(), TenantID: f.tenantID, CommitteeID: committee.ID,
		ScheduledAt: at, State: domain.MeetingScheduled, Restricted: true,
		CreatedAt: at, CreatedBy: "quality-1", Version: 1,
	}
	if err := f.committees.InsertMeeting(ctx, f.scope, meeting); err != nil {
		t.Fatalf("InsertMeeting: %v", err)
	}

	_, err := f.pool.Exec(ctx, `
		INSERT INTO quality.mortality_review (
		    review_id, tenant_id, patient_id, died_at, committee_id,
		    meeting_id, classification, findings, capa_ids, state,
		    opened_at, opened_by, completed_at, completed_by)
		VALUES ($1, $2, 'pat-1', now() - interval '7 days', $3, $4,
		        'potentially_preventable', 'delay in escalating', '{}',
		        'complete', now(), 'quality-1', now(), 'chair-1')`,
		uuid.New(), f.tenantID, committee.ID, meeting.ID)
	if err == nil {
		t.Fatal("the database accepted a preventable death with no action")
	}
	if !strings.Contains(err.Error(),
		"a_preventable_death_raises_an_action") {
		t.Fatalf("refused by %v, want the action constraint", err)
	}

	// And a peer review signed by one person, naming no meeting, is not a peer
	// review.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO quality.mortality_review (
		    review_id, tenant_id, patient_id, died_at, committee_id,
		    classification, findings, state, opened_at, opened_by,
		    completed_at, completed_by)
		VALUES ($1, $2, 'pat-2', now() - interval '7 days', $3,
		        'expected', 'end-stage disease', 'complete', now(),
		        'quality-1', now(), 'chair-1')`,
		uuid.New(), f.tenantID, committee.ID)
	if err == nil {
		t.Fatal("the database accepted a peer review naming no meeting")
	}
	if !strings.Contains(err.Error(), "a_peer_review_names_its_meeting") {
		t.Fatalf("refused by %v, want the meeting constraint", err)
	}
}

// Tenant isolation, at the adapter rather than at the RPC boundary: the
// predicate is in every statement, so another tenant's scope reads nothing
// even holding a correct identifier.
func TestAnotherTenantReachesNoQualityRecord(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	incident := f.reportIncident(t, nil)
	other := authctx.NewSession(authctx.Session{
		SubjectID: "quality-x", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.incidents.Incident(ctx, other, incident.ID); err == nil {
		t.Fatal("another tenant read this hospital's incident")
	}

	listed, err := f.incidents.Incidents(ctx, other, ports.IncidentFilter{
		Limit: 50,
	})
	if err != nil {
		t.Fatalf("Incidents: %v", err)
	}
	if len(listed) != 0 {
		t.Fatalf("another tenant listed %d incidents", len(listed))
	}
}
