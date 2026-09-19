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

	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	qualityv1 "github.com/ppusapati/health/code/gen/go/healthcare/quality/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/quality/v1/qualityv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	identitypostgres "github.com/ppusapati/health/code/internal/identity_access/adapters/postgres"
	iamdomain "github.com/ppusapati/health/code/internal/identity_access/domain"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	qualityapp "github.com/ppusapati/health/code/internal/quality/application"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Quality management (SRS-QMS-001 … 015), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a restricted record is
// redacted for one caller and whole for another, that the separations of duty
// are permissions and domain rules stacked rather than either alone, that
// approving a document version supersedes the last one in the same call, and
// that a legal hold stops a write and not just a delete.

type qmsHarness struct {
	dbPool  *pgxpool.Pool
	quality qualityv1connect.QualityServiceClient
	org     organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newQmsHarness(t *testing.T) *qmsHarness {
	return newQmsHarnessWith(t, qualityapp.Config{
		RCAMethods:         []string{"london_protocol", "five_whys"},
		SentinelCategories: []string{"wrong_site_surgery"},
		EscalateAtBand:     domain.RiskHigh,
		RCARequiredAtBand:  domain.RiskHigh,
		StaleReviewAfter:   365 * 24 * time.Hour,
		DefaultComplaintSLA: qualityapp.ComplaintSLA{
			AcknowledgeWithin: 48 * time.Hour,
			ResolveWithin:     30 * 24 * time.Hour,
		},
		AcknowledgementRoles: []string{"nurse"},
		CompetencyRoles:      []string{"nurse"},
	})
}

func newQmsHarnessWith(t *testing.T, config qualityapp.Config) *qmsHarness {
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
		Quality: config,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &qmsHarness{
		dbPool:  pool,
		quality: qualityv1connect.NewQualityServiceClient(server.Client(), server.URL),
		org:     organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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
	h.entitle(t, "quality")
	return h
}

func (h *qmsHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.dbPool))
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

// employ puts somebody in the directory, which is what the acknowledgement
// and competency gap reports read.
func (h *qmsHarness) employ(t *testing.T, subject, role string) {
	t.Helper()

	repo := identitypostgres.New(pgtx.NewManager(h.dbPool))
	if _, err := repo.Upsert(context.Background(), iamdomain.Account{
		ID: uuid.NewString(), TenantID: h.tenantID, SubjectID: subject,
		IdentityProvider: "local", DisplayName: subject,
		Status:              iamdomain.AccountActive,
		Roles:               []iamdomain.Role{iamdomain.Role(role)},
		PermittedFacilities: []string{h.facility},
		Version:             1,
	}); err != nil {
		t.Fatalf("Upsert(%s): %v", subject, err)
	}
}

func (h *qmsHarness) officerToken() string {
	return h.tenantID + ":qms-1:quality_officer:" + h.facility
}

func (h *qmsHarness) otherOfficerToken() string {
	return h.tenantID + ":qms-2:quality_officer:" + h.facility
}

func (h *qmsHarness) managerToken() string {
	return h.tenantID + ":qms-boss:quality_manager:" + h.facility
}

func (h *qmsHarness) reviewerToken() string {
	return h.tenantID + ":mm-1:peer_reviewer:" + h.facility
}

func (h *qmsHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *qmsHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// report files an incident as the quality officer unless a token is given.
func (h *qmsHarness) report(t *testing.T, token string,
	mutate func(*qualityv1.ReportIncidentRequest)) *qualityv1.Incident {

	t.Helper()
	req := &qualityv1.ReportIncidentRequest{
		Reference: "INC-" + uuid.NewString()[:8], Category: "medication",
		Reach:       qualityv1.Reach_REACH_NEAR_MISS,
		Harm:        qualityv1.Harm_HARM_NONE,
		Consequence: qualityv1.Consequence_CONSEQUENCE_MODERATE,
		Likelihood:  qualityv1.Likelihood_LIKELIHOOD_POSSIBLE,
		Narrative:   "wrong dose drawn up, caught at the second check",
		Department:  "paediatrics", FacilityId: h.facility,
		OccurredAt: timestamppb.New(time.Now().UTC().Add(-time.Hour)),
	}
	if mutate != nil {
		mutate(req)
	}
	out, err := h.quality.ReportIncident(context.Background(),
		withFacility(token, h.facility, req))
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	return out.Msg.GetIncident()
}

// SRS-QMS-001. The contradiction the three-state reach exists to prevent,
// refused at the RPC boundary.
func TestANearMissWithHarmIsRefusedOverTheWire(t *testing.T) {
	h := newQmsHarness(t)

	_, err := h.quality.ReportIncident(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ReportIncidentRequest{
				Category:    "falls",
				Reach:       qualityv1.Reach_REACH_NEAR_MISS,
				Harm:        qualityv1.Harm_HARM_MODERATE,
				Consequence: qualityv1.Consequence_CONSEQUENCE_MODERATE,
				Likelihood:  qualityv1.Likelihood_LIKELIHOOD_POSSIBLE,
				Narrative:   "caught it",
				OccurredAt:  timestamppb.New(time.Now().UTC()),
			}))
	if err == nil {
		t.Fatal("a near miss with recorded harm was accepted")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("refusal returned %v, want InvalidArgument", got)
	}
}

// SRS-QMS-002, SRS-QMS-005. The score is derived, a death is a sentinel event
// whatever was ticked, and the hospital's own sentinel category is applied on
// top.
func TestTheScoreIsDerivedAndASentinelEventIsForced(t *testing.T) {
	h := newQmsHarness(t)

	// Catastrophic × likely is 20, which is extreme. Nothing on the wire
	// could have said so.
	scored := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Consequence = qualityv1.Consequence_CONSEQUENCE_CATASTROPHIC
			req.Likelihood = qualityv1.Likelihood_LIKELIHOOD_LIKELY
		})
	if scored.GetRisk().GetScore() != 20 ||
		scored.GetRisk().GetBand() != qualityv1.RiskBand_RISK_BAND_EXTREME {
		t.Fatalf("risk = %+v, want 20/extreme", scored.GetRisk())
	}

	// A death, filed as a routine incident.
	death := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Reach = qualityv1.Reach_REACH_HARM
			req.Harm = qualityv1.Harm_HARM_DEATH
			req.ImmediateAction = "resuscitation attempted"
			req.Sentinel = false
		})
	if !death.GetSentinel() || !death.GetRestricted() {
		t.Fatalf("a death read back sentinel=%v restricted=%v, want both",
			death.GetSentinel(), death.GetRestricted())
	}

	// And the hospital's own list, applied before the domain sees it.
	configured := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Category = "wrong_site_surgery"
			req.Sentinel = false
		})
	if !configured.GetSentinel() {
		t.Fatal("a configured sentinel category was filed as routine")
	}
}

// SRS-QMS-001, SRS-QMS-012. A ward may know an incident happened in it
// without reading the narrative, the patient and the people.
func TestARestrictedIncidentIsRedactedForOneCallerAndWholeForAnother(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Reach = qualityv1.Reach_REACH_HARM
			req.Harm = qualityv1.Harm_HARM_DEATH
			req.ImmediateAction = "resuscitation attempted"
			req.PatientId = "pat-1"
		})

	// The officer runs the quality system and still may not read this.
	limited, err := h.quality.GetIncident(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.GetIncidentRequest{
			IncidentId: incident.GetIncidentId(),
		}))
	if err != nil {
		t.Fatalf("GetIncident(officer): %v", err)
	}
	got := limited.Msg.GetIncident()
	if got.GetNarrative() != "" || got.GetPatientId() != "" ||
		got.GetImmediateAction() != "" {
		t.Fatalf("redaction left content behind: %+v", got)
	}
	if !got.GetRedacted() {
		t.Fatal("a redacted record did not say it was redacted")
	}
	// What the ward keeps.
	if got.GetCategory() == "" || got.GetDepartment() == "" {
		t.Fatalf("redaction removed what the ward needs: %+v", got)
	}
	if got.GetRisk().GetBand() == qualityv1.RiskBand_RISK_BAND_UNSPECIFIED {
		t.Fatal("the risk band was redacted away")
	}
	if got.GetRisk().GetScore() != 0 {
		t.Fatalf("score = %d, want the components withheld",
			got.GetRisk().GetScore())
	}

	// The manager holds qms.restricted.read.
	full, err := h.quality.GetIncident(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.GetIncidentRequest{
			IncidentId: incident.GetIncidentId(),
		}))
	if err != nil {
		t.Fatalf("GetIncident(manager): %v", err)
	}
	if full.Msg.GetIncident().GetNarrative() == "" ||
		full.Msg.GetIncident().GetRedacted() {
		t.Fatalf("the manager was given a redacted record: %+v",
			full.Msg.GetIncident())
	}
}

// SRS-QMS-001. Anonymous reporting is a hole in the record for readers and
// never for the trail.
func TestAnAnonymousReportHidesTheReporterFromReaders(t *testing.T) {
	h := newQmsHarness(t)

	incident := h.report(t, h.nurseToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Anonymous = true
		})
	if incident.GetReportedBy() != "" {
		t.Fatalf("reported by %q, want it hidden", incident.GetReportedBy())
	}
	if !incident.GetAnonymous() {
		t.Fatal("the anonymity flag was lost")
	}

	named := h.report(t, h.nurseToken(), nil)
	if named.GetReportedBy() != "nurse-1" {
		t.Fatalf("reported by %q, want the nurse named",
			named.GetReportedBy())
	}
}

// SRS-QMS-003. An analysis of a restricted incident is itself restricted, and
// withheld rather than redacted: it is the discussion, and there is nothing to
// redact to.
func TestAnAnalysisInheritsTheIncidentsRestrictionAndIsWithheld(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Reach = qualityv1.Reach_REACH_HARM
			req.Harm = qualityv1.Harm_HARM_DEATH
			req.ImmediateAction = "resuscitation attempted"
		})

	started, err := h.quality.StartRca(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.StartRcaRequest{
			IncidentId: incident.GetIncidentId(), Method: "london_protocol",
		}))
	if err != nil {
		t.Fatalf("StartRca: %v", err)
	}
	if !started.Msg.GetRca().GetRestricted() {
		t.Fatal("an analysis of a restricted incident is not restricted")
	}

	_, err = h.quality.GetRca(ctx, withFacility(h.officerToken(), h.facility,
		&qualityv1.GetRcaRequest{RcaId: started.Msg.GetRca().GetRcaId()}))
	if got := connectCode(err); got != connect.CodeNotFound {
		t.Fatalf("reading a restricted analysis returned %v, want NotFound",
			got)
	}

	if _, err := h.quality.GetRca(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.GetRcaRequest{
			RcaId: started.Msg.GetRca().GetRcaId(),
		})); err != nil {
		t.Fatalf("GetRca(manager): %v", err)
	}
}

// SRS-QMS-003. The hospital's approved method list, and the refusal to close
// an analysis that produced nothing and said nothing about why.
func TestAnAnalysisUsesAnApprovedMethodAndAccountsForItsActions(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.officerToken(), nil)

	_, err := h.quality.StartRca(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.StartRcaRequest{
			IncidentId: incident.GetIncidentId(), Method: "a chat over coffee",
		}))
	if err == nil {
		t.Fatal("an unapproved analysis method was accepted")
	}
	if !strings.Contains(err.Error(), "not approved") {
		t.Fatalf("refusal = %v, want it to name the approval", err)
	}

	rca := h.startRca(t, incident.GetIncidentId())

	_, err = h.quality.CompleteRca(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.CompleteRcaRequest{
			RcaId: rca.GetRcaId(), AccountableOwner: "matron-1",
			Findings: "staffing", ExpectedVersion: rca.GetVersion(),
		}))
	if err == nil {
		t.Fatal("an analysis closed with no action and no explanation")
	}

	if _, err := h.quality.CompleteRca(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.CompleteRcaRequest{
			RcaId: rca.GetRcaId(), AccountableOwner: "matron-1",
			Findings:        "staffing was the cause",
			NoActionReason:  "the ward establishment was already under review",
			ExpectedVersion: rca.GetVersion(),
		})); err != nil {
		t.Fatalf("CompleteRca: %v", err)
	}
}

func (h *qmsHarness) startRca(t *testing.T,
	incidentID string) *qualityv1.RootCauseAnalysis {

	t.Helper()
	ctx := context.Background()
	started, err := h.quality.StartRca(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.StartRcaRequest{
			IncidentId: incidentID, Method: "london_protocol",
		}))
	if err != nil {
		t.Fatalf("StartRca: %v", err)
	}
	rca := started.Msg.GetRca()

	added, err := h.quality.AddFactor(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.AddFactorRequest{
			RcaId: rca.GetRcaId(),
			Factor: &qualityv1.ContributingFactor{
				Category: qualityv1.FactorCategory_FACTOR_CATEGORY_ORGANISATIONAL,
				Detail:   "two nurses covering four bays overnight",
				Root:     true,
			},
		}))
	if err != nil {
		t.Fatalf("AddFactor: %v", err)
	}
	return added.Msg.GetRca()
}

// SRS-QMS-004. Approval is its own permission, and holding it is necessary
// and not sufficient — the domain refuses the person who raised the action
// whoever they are.
func TestApprovingAnActionIsAPermissionAndADomainRule(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	byOfficer := h.raiseAction(t, h.officerToken())

	// The officer does not hold qms.capa.approve.
	_, err := h.quality.ApproveAction(ctx, withFacility(h.otherOfficerToken(),
		h.facility, &qualityv1.ApproveActionRequest{
			CapaId:          byOfficer.GetCapaId(),
			ExpectedVersion: byOfficer.GetVersion(),
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("an officer approving returned %v, want PermissionDenied",
			got)
	}

	// The manager does, and this one did not raise it.
	if _, err := h.quality.ApproveAction(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.ApproveActionRequest{
			CapaId:          byOfficer.GetCapaId(),
			ExpectedVersion: byOfficer.GetVersion(),
		})); err != nil {
		t.Fatalf("ApproveAction: %v", err)
	}

	// A manager who raised one cannot approve it, permission or not.
	byManager := h.raiseAction(t, h.managerToken())
	_, err = h.quality.ApproveAction(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.ApproveActionRequest{
			CapaId:          byManager.GetCapaId(),
			ExpectedVersion: byManager.GetVersion(),
		}))
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("self-approval returned %v, want InvalidArgument", got)
	}
}

func (h *qmsHarness) raiseAction(t *testing.T,
	token string) *qualityv1.CorrectiveAction {

	t.Helper()
	now := time.Now().UTC()
	out, err := h.quality.RaiseAction(context.Background(),
		withFacility(token, h.facility, &qualityv1.RaiseActionRequest{
			Reference:          "CAPA-" + uuid.NewString()[:8],
			Kind:               qualityv1.ActionKind_ACTION_KIND_PREVENTIVE,
			SourceKind:         qualityv1.ActionSource_ACTION_SOURCE_INCIDENT,
			SourceId:           uuid.NewString(),
			Action:             "second nurse rostered overnight",
			OwnerId:            "matron-1",
			DueOn:              timestamppb.New(now.AddDate(0, 1, 0)),
			EffectivenessDueOn: timestamppb.New(now.AddDate(0, 3, 0)),
		}))
	if err != nil {
		t.Fatalf("RaiseAction: %v", err)
	}
	return out.Msg.GetAction()
}

// SRS-QMS-004. The check everybody skips, and the failure that must not close
// the loop.
func TestAnActionClosesOnlyOnACheckThatPassed(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	action := h.workingAction(t)

	_, err := h.quality.CloseAction(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.CloseActionRequest{
			CapaId: action.GetCapaId(), Note: "done",
			ExpectedVersion: action.GetVersion(),
		}))
	if err == nil {
		t.Fatal("an action closed with no effectiveness check")
	}
	if !strings.Contains(err.Error(), "has not been checked") {
		t.Fatalf("refusal = %v, want it to name the missing check", err)
	}

	failed, err := h.quality.RecordEffectiveness(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.RecordEffectivenessRequest{
				CapaId: action.GetCapaId(), Effective: false,
				Evidence:        "re-audit found the same gap",
				ExpectedVersion: action.GetVersion(),
			}))
	if err != nil {
		t.Fatalf("RecordEffectiveness: %v", err)
	}
	// Back to work, not closed.
	if failed.Msg.GetAction().GetState() !=
		qualityv1.ActionState_ACTION_STATE_IN_PROGRESS {
		t.Fatalf("state = %v, want the action returned to work",
			failed.Msg.GetAction().GetState())
	}

	passed, err := h.quality.RecordEffectiveness(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.RecordEffectivenessRequest{
				CapaId: action.GetCapaId(), Effective: true,
				Evidence:        "re-audit clean over twenty nights",
				ExpectedVersion: failed.Msg.GetAction().GetVersion(),
			}))
	if err != nil {
		t.Fatalf("RecordEffectiveness(passed): %v", err)
	}
	// The failure is kept: "fixed, checked, had not worked, fixed again" is
	// what tells a hospital whether its analysis was any good.
	if len(passed.Msg.GetAction().GetChecks()) != 2 {
		t.Fatalf("checks = %d, want the failed one kept",
			len(passed.Msg.GetAction().GetChecks()))
	}

	if _, err := h.quality.CloseAction(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.CloseActionRequest{
			CapaId: action.GetCapaId(), Note: "verified",
			ExpectedVersion: passed.Msg.GetAction().GetVersion(),
		})); err != nil {
		t.Fatalf("CloseAction: %v", err)
	}
}

func (h *qmsHarness) workingAction(t *testing.T) *qualityv1.CorrectiveAction {
	t.Helper()
	ctx := context.Background()

	action := h.raiseAction(t, h.officerToken())
	approved, err := h.quality.ApproveAction(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.ApproveActionRequest{
			CapaId: action.GetCapaId(), ExpectedVersion: action.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ApproveAction: %v", err)
	}
	advanced, err := h.quality.AdvanceAction(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.AdvanceActionRequest{
			CapaId:          action.GetCapaId(),
			State:           qualityv1.ActionState_ACTION_STATE_IN_PROGRESS,
			ExpectedVersion: approved.Msg.GetAction().GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AdvanceAction: %v", err)
	}
	return advanced.Msg.GetAction()
}

// SRS-QMS-006. Approving a version supersedes the last one in the same call.
// Two versions both in force is the state document control exists to prevent.
func TestApprovingAVersionSupersedesTheLastOne(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	document := h.document(t)
	now := time.Now().UTC()

	first := h.draft(t, document, false)
	h.approve(t, first, now.Add(-30*24*time.Hour))

	current, err := h.quality.GetCurrentVersion(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.GetCurrentVersionRequest{DocumentId: document}))
	if err != nil {
		t.Fatalf("GetCurrentVersion: %v", err)
	}
	if !current.Msg.GetFound() ||
		current.Msg.GetVersion().GetVersionId() != first.GetVersionId() {
		t.Fatalf("current = %+v, want the first version", current.Msg)
	}
	// The ordinal was assigned by the server.
	if first.GetOrdinal() != 1 {
		t.Fatalf("ordinal = %d, want 1", first.GetOrdinal())
	}

	second := h.draft(t, document, false)
	if second.GetOrdinal() != 2 {
		t.Fatalf("second ordinal = %d, want 2", second.GetOrdinal())
	}
	h.approve(t, second, now.Add(-time.Hour))

	versions, err := h.quality.ListVersions(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ListVersionsRequest{DocumentId: document}))
	if err != nil {
		t.Fatalf("ListVersions: %v", err)
	}
	if len(versions.Msg.GetVersions()) != 2 {
		t.Fatalf("versions = %d, want both retained",
			len(versions.Msg.GetVersions()))
	}
	for _, version := range versions.Msg.GetVersions() {
		if version.GetOrdinal() != 1 {
			continue
		}
		if version.GetState() != qualityv1.VersionState_VERSION_STATE_OBSOLETE {
			t.Fatalf("the first version is %v, want obsolete",
				version.GetState())
		}
		if version.GetObsoleteFrom() == nil {
			t.Fatal("the superseded version has no end date")
		}
	}

	current, err = h.quality.GetCurrentVersion(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.GetCurrentVersionRequest{DocumentId: document}))
	if err != nil {
		t.Fatalf("GetCurrentVersion: %v", err)
	}
	if current.Msg.GetVersion().GetVersionId() != second.GetVersionId() {
		t.Fatalf("current = %s, want the second version",
			current.Msg.GetVersion().GetVersionId())
	}
}

func (h *qmsHarness) document(t *testing.T) string {
	t.Helper()
	out, err := h.quality.RegisterDocument(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.RegisterDocumentRequest{
				Code:    "IPC-" + uuid.NewString()[:6],
				Title:   "Hand hygiene policy",
				Kind:    qualityv1.DocumentKind_DOCUMENT_KIND_SOP,
				OwnerId: "ipc-1", ReviewMonths: 24,
			}))
	if err != nil {
		t.Fatalf("RegisterDocument: %v", err)
	}
	return out.Msg.GetDocument().GetDocumentId()
}

func (h *qmsHarness) draft(t *testing.T, documentID string,
	requiresAck bool) *qualityv1.DocumentVersion {

	t.Helper()
	out, err := h.quality.DraftVersion(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.DraftVersionRequest{
				DocumentId:              documentID,
				ContentRef:              "blob://" + uuid.NewString(),
				ChangeSummary:           "revised",
				RequiresAcknowledgement: requiresAck,
			}))
	if err != nil {
		t.Fatalf("DraftVersion: %v", err)
	}
	return out.Msg.GetVersion()
}

func (h *qmsHarness) approve(t *testing.T, version *qualityv1.DocumentVersion,
	effective time.Time) *qualityv1.DocumentVersion {

	t.Helper()
	out, err := h.quality.ApproveVersion(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&qualityv1.ApproveVersionRequest{
				VersionId:       version.GetVersionId(),
				EffectiveFrom:   timestamppb.New(effective),
				ExpectedVersion: version.GetVersion(),
			}))
	if err != nil {
		t.Fatalf("ApproveVersion: %v", err)
	}
	return out.Msg.GetVersion()
}

// SRS-QMS-006. Approval is its own permission: the author of a revision
// should not be the person who makes it binding.
func TestAnOfficerCannotApproveTheirOwnRevision(t *testing.T) {
	h := newQmsHarness(t)

	document := h.document(t)
	version := h.draft(t, document, false)

	_, err := h.quality.ApproveVersion(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ApproveVersionRequest{
				VersionId:       version.GetVersionId(),
				EffectiveFrom:   timestamppb.New(time.Now().UTC()),
				ExpectedVersion: version.GetVersion(),
			}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("an officer approving returned %v, want PermissionDenied",
			got)
	}
}

// SRS-QMS-006. Acknowledging version 1 says nothing about version 2, and the
// caller cannot choose which version they are confirming.
func TestAcknowledgementReopensWhenAPolicyIsRevised(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	document := h.document(t)
	now := time.Now().UTC()
	first := h.draft(t, document, true)
	h.approve(t, first, now.Add(-30*24*time.Hour))

	acked, err := h.quality.AcknowledgeDocument(ctx,
		withFacility(h.nurseToken(), h.facility,
			&qualityv1.AcknowledgeDocumentRequest{
				DocumentId: document, Role: "nurse",
			}))
	if err != nil {
		t.Fatalf("AcknowledgeDocument: %v", err)
	}
	if acked.Msg.GetVersionId() != first.GetVersionId() {
		t.Fatalf("acknowledged %s, want the version in force",
			acked.Msg.GetVersionId())
	}

	// Pressing the button twice is not an error and does not double-count.
	if _, err := h.quality.AcknowledgeDocument(ctx,
		withFacility(h.nurseToken(), h.facility,
			&qualityv1.AcknowledgeDocumentRequest{
				DocumentId: document, Role: "nurse",
			})); err != nil {
		t.Fatalf("AcknowledgeDocument(again): %v", err)
	}

	// Who the hospital employs comes from identity and access, not from this
	// context. Without a directory entry the gap report is honestly empty —
	// nobody is expected to have read anything — so the establishment has to
	// exist before the report means anything.
	h.employ(t, "nurse-1", "nurse")

	// A revision comes into force and the nurse is outstanding again.
	second := h.draft(t, document, true)
	h.approve(t, second, now.Add(-time.Hour))

	gaps, err := h.quality.ListOutstandingAcknowledgements(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ListOutstandingAcknowledgementsRequest{
				DocumentId: document,
			}))
	if err != nil {
		t.Fatalf("ListOutstandingAcknowledgements: %v", err)
	}
	outstanding := false
	for _, gap := range gaps.Msg.GetGaps() {
		if gap.GetPersonId() == "nurse-1" &&
			gap.GetVersionId() == second.GetVersionId() {
			outstanding = true
		}
	}
	if !outstanding {
		t.Fatalf("gaps = %v, want the nurse outstanding on the new version",
			gaps.Msg.GetGaps())
	}
}

// SRS-QMS-007. A finding closed with a note is a finding somebody talked
// their way out of, and the next audit finds it again.
func TestAMajorNonConformityClosesOnlyThroughAClosedAction(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	audit := h.audit(t)
	finding, err := h.quality.RecordFinding(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.RecordFindingRequest{
			AuditId:  audit,
			Severity: qualityv1.FindingSeverity_FINDING_SEVERITY_MAJOR_NC,
			Detail:   "no hand hygiene audit run for eight months",
			Evidence: "audit register, last entry October",
		}))
	if err != nil {
		t.Fatalf("RecordFinding: %v", err)
	}

	_, err = h.quality.CloseFinding(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.CloseFindingRequest{
			FindingId: finding.Msg.GetFinding().GetFindingId(),
			Note:      "discussed with the ward",
		}))
	if err == nil {
		t.Fatal("a major non-conformity was closed with a note")
	}

	// Linked to an action that is still open: still refused.
	action := h.workingAction(t)
	if _, err := h.quality.LinkFindingAction(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.LinkFindingActionRequest{
				FindingId: finding.Msg.GetFinding().GetFindingId(),
				CapaId:    action.GetCapaId(),
			})); err != nil {
		t.Fatalf("LinkFindingAction: %v", err)
	}
	_, err = h.quality.CloseFinding(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.CloseFindingRequest{
			FindingId: finding.Msg.GetFinding().GetFindingId(),
		}))
	if err == nil {
		t.Fatal("a finding closed on an action that was still open")
	}

	// And the audit cannot close over it.
	if _, err := h.quality.ReportAudit(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ReportAuditRequest{
			AuditId: audit, Summary: "one non-conformity",
			ExpectedVersion: 1,
		})); err != nil {
		t.Fatalf("ReportAudit: %v", err)
	}
	_, err = h.quality.CloseAudit(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.CloseAuditRequest{
			AuditId: audit, ExpectedVersion: 2,
		}))
	if err == nil {
		t.Fatal("an audit closed over an open finding")
	}
}

func (h *qmsHarness) audit(t *testing.T) string {
	t.Helper()
	now := time.Now().UTC()
	out, err := h.quality.PlanAudit(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.PlanAuditRequest{
				Reference: "AUD-" + uuid.NewString()[:8],
				Title:     "IPC audit", Scope: "hand hygiene",
				AuditorId: "auditor-1", AuditeeDepartment: "medicine",
				PlannedFrom: timestamppb.New(now),
				PlannedTo:   timestamppb.New(now.AddDate(0, 0, 7)),
			}))
	if err != nil {
		t.Fatalf("PlanAudit: %v", err)
	}
	return out.Msg.GetAudit().GetAuditId()
}

// SRS-QMS-008. A decision taken by two people from a committee of nine is not
// the committee's decision, and the quorum is checked against the real
// membership rather than a number in the request.
func TestMinutesRecordingDecisionsNeedAQuorumOverTheWire(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	formed, err := h.quality.FormCommittee(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.FormCommitteeRequest{
			Code: "QC-" + uuid.NewString()[:6], Name: "Quality committee",
			QuorumSize: 4,
			Members:    []string{"a", "b", "c", "d", "e", "f"},
		}))
	if err != nil {
		t.Fatalf("FormCommittee: %v", err)
	}
	committee := formed.Msg.GetCommittee().GetCommitteeId()

	// A quorum larger than the membership is a committee that can never
	// decide anything.
	_, err = h.quality.FormCommittee(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.FormCommitteeRequest{
			Code: "QC-" + uuid.NewString()[:6], Name: "Impossible",
			QuorumSize: 9, Members: []string{"a", "b"},
		}))
	if err == nil {
		t.Fatal("a committee was formed with an unreachable quorum")
	}

	meeting := h.meeting(t, committee)
	_, err = h.quality.RecordMinutes(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.RecordMinutesRequest{
			MeetingId: meeting, Attendees: []string{"a", "b"},
			Minutes: "discussed the incident log",
			Decisions: []*qualityv1.Decision{
				{Text: "roster a second nurse overnight"},
			},
			Approve: true, ExpectedVersion: 1,
		}))
	if err == nil {
		t.Fatal("minutes recording decisions were approved below quorum")
	}

	quorate := h.meeting(t, committee)
	if _, err := h.quality.RecordMinutes(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.RecordMinutesRequest{
			MeetingId: quorate, Attendees: []string{"a", "b", "c", "d"},
			Apologies: []string{"e"},
			Minutes:   "discussed the incident log",
			Decisions: []*qualityv1.Decision{
				{Text: "roster a second nurse overnight"},
			},
			Approve: true, ExpectedVersion: 1,
		})); err != nil {
		t.Fatalf("RecordMinutes(quorate): %v", err)
	}
}

func (h *qmsHarness) meeting(t *testing.T, committeeID string) string {
	t.Helper()
	out, err := h.quality.ScheduleMeeting(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ScheduleMeetingRequest{
				CommitteeId: committeeID,
				ScheduledAt: timestamppb.New(time.Now().UTC()),
				Agenda:      []string{"incident log"},
			}))
	if err != nil {
		t.Fatalf("ScheduleMeeting: %v", err)
	}
	return out.Msg.GetMeeting().GetMeetingId()
}

// SRS-QMS-009, SRS-QMS-014. Evidence naming a record that does not exist is a
// tick in a box that looks like a link, and a clause judged met with nothing
// filed is the failure mode of an evidence map.
func TestEvidenceIsCheckedAndReadinessCountsTheGaps(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	loaded, err := h.quality.LoadStandard(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.LoadStandardRequest{
			Code: "NABH-" + uuid.NewString()[:6], Name: "NABH",
			Edition: "5th",
			Clauses: []*qualityv1.ClauseInput{
				{Reference: "AAC.1.a", Chapter: "AAC", Critical: true},
				{Reference: "AAC.1.b", Chapter: "AAC"},
			},
		}))
	if err != nil {
		t.Fatalf("LoadStandard: %v", err)
	}
	standard := loaded.Msg.GetStandard().GetStandardId()
	if loaded.Msg.GetClausesLoaded() != 2 {
		t.Fatalf("loaded %d clauses, want 2", loaded.Msg.GetClausesLoaded())
	}

	clauses, err := h.quality.ListClauses(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ListClausesRequest{StandardId: standard}))
	if err != nil {
		t.Fatalf("ListClauses: %v", err)
	}
	critical := clauses.Msg.GetClauses()[0]

	// A document version that does not exist.
	_, err = h.quality.FileEvidence(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.FileEvidenceRequest{
			ClauseId: critical.GetClauseId(),
			Kind:     qualityv1.EvidenceKind_EVIDENCE_KIND_DOCUMENT_VERSION,
			RefId:    uuid.NewString(),
		}))
	if err == nil {
		t.Fatal("evidence was filed against a version that does not exist")
	}

	// And a clause judged met with nothing filed.
	_, err = h.quality.ReviewClause(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ReviewClauseRequest{
			StandardId: standard, ClauseId: critical.GetClauseId(),
			Verdict: qualityv1.Verdict_VERDICT_MET, Note: "looks fine",
		}))
	if err == nil {
		t.Fatal("a clause was judged met with no evidence")
	}

	// File something real, then judge it.
	document := h.document(t)
	version := h.draft(t, document, false)
	h.approve(t, version, time.Now().UTC().Add(-time.Hour))
	if _, err := h.quality.FileEvidence(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.FileEvidenceRequest{
			ClauseId: critical.GetClauseId(),
			Kind:     qualityv1.EvidenceKind_EVIDENCE_KIND_DOCUMENT_VERSION,
			RefId:    version.GetVersionId(),
		})); err != nil {
		t.Fatalf("FileEvidence: %v", err)
	}
	if _, err := h.quality.ReviewClause(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ReviewClauseRequest{
			StandardId: standard, ClauseId: critical.GetClauseId(),
			Verdict: qualityv1.Verdict_VERDICT_MET,
		})); err != nil {
		t.Fatalf("ReviewClause: %v", err)
	}

	readiness, err := h.quality.GetReadiness(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.GetReadinessRequest{StandardId: standard}))
	if err != nil {
		t.Fatalf("GetReadiness: %v", err)
	}
	msg := readiness.Msg
	if msg.GetTotal() != 2 || msg.GetMet() != 1 || msg.GetUnreviewed() != 1 {
		t.Fatalf("readiness = %+v, want one met and one unreviewed", msg)
	}
	// The critical clause is met, so there is no critical gap; the ordinary
	// one has nothing filed against it.
	if msg.GetCriticalGaps() != 0 || msg.GetEvidenceGaps() != 1 {
		t.Fatalf("gaps = critical %d / evidence %d, want 0 and 1",
			msg.GetCriticalGaps(), msg.GetEvidenceGaps())
	}
	// Worst first: the unreviewed clause is above the met one.
	if msg.GetClauses()[0].GetVerdict() != qualityv1.Verdict_VERDICT_UNREVIEWED {
		t.Fatalf("first clause = %v, want the unreviewed one",
			msg.GetClauses()[0].GetVerdict())
	}
}

// SRS-QMS-010. The revision is assigned by the server, an old value keeps the
// revision it was measured under, and a period with no eligible cases is not
// a period of total failure.
func TestAnIndicatorRevisionIsServerAssignedAndOldValuesKeepTheirs(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()
	code := "HH-" + uuid.NewString()[:6]

	first := h.defineIndicator(t, code, 850)
	if first.GetRevision() != 1 {
		t.Fatalf("revision = %d, want 1", first.GetRevision())
	}

	now := time.Now().UTC()
	value, err := h.quality.RecordIndicatorValue(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.RecordIndicatorValueRequest{
				Code:       code,
				PeriodFrom: timestamppb.New(now.AddDate(0, -1, 0)),
				PeriodTo:   timestamppb.New(now),
				Numerator:  174, Denominator: 200,
				SourceNote: "IPC observation register",
			}))
	if err != nil {
		t.Fatalf("RecordIndicatorValue: %v", err)
	}
	if value.Msg.GetValue().GetPermille() != 870 {
		t.Fatalf("permille = %d, want 870",
			value.Msg.GetValue().GetPermille())
	}

	second := h.defineIndicator(t, code, 900)
	if second.GetRevision() != 2 {
		t.Fatalf("second revision = %d, want 2", second.GetRevision())
	}

	values, err := h.quality.ListIndicatorValues(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ListIndicatorValuesRequest{Code: code}))
	if err != nil {
		t.Fatalf("ListIndicatorValues: %v", err)
	}
	if len(values.Msg.GetValues()) != 1 ||
		values.Msg.GetValues()[0].GetRevision() != 1 {
		t.Fatalf("values = %+v, want the old one still naming revision 1",
			values.Msg.GetValues())
	}

	// No observations at all.
	empty, err := h.quality.RecordIndicatorValue(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.RecordIndicatorValueRequest{
				Code:       code,
				PeriodFrom: timestamppb.New(now),
				PeriodTo:   timestamppb.New(now.AddDate(0, 1, 0)),
				Numerator:  0, Denominator: 0,
				SourceNote: "no rounds ran",
			}))
	if err != nil {
		t.Fatalf("RecordIndicatorValue(empty): %v", err)
	}
	if !empty.Msg.GetValue().GetUnanswerable() {
		t.Fatal("a period with no eligible cases was reported as measured")
	}

	dashboard, err := h.quality.GetDashboard(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.GetDashboardRequest{}))
	if err != nil {
		t.Fatalf("GetDashboard: %v", err)
	}
	if len(dashboard.Msg.GetLines()) != 1 {
		t.Fatalf("dashboard = %d lines, want one per indicator",
			len(dashboard.Msg.GetLines()))
	}
	line := dashboard.Msg.GetLines()[0]
	if line.GetDefinition().GetRevision() != 2 {
		t.Fatalf("dashboard shows revision %d, want the current one",
			line.GetDefinition().GetRevision())
	}
	// The latest value is the unanswerable one, which is not a failure.
	if line.GetComparable() {
		t.Fatal("an unmeasured period was judged against the target")
	}
}

func (h *qmsHarness) defineIndicator(t *testing.T, code string,
	target int32) *qualityv1.IndicatorDefinition {

	t.Helper()
	out, err := h.quality.DefineIndicator(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.DefineIndicatorRequest{
				Code: code, Name: "Hand hygiene compliance",
				Numerator:   "opportunities with hand hygiene performed",
				Denominator: "observed opportunities",
				Unit:        "percent", TargetPermille: target,
				Direction: qualityv1.Direction_DIRECTION_HIGHER_IS_BETTER,
				Frequency: qualityv1.Frequency_FREQUENCY_MONTHLY,
				OwnerId:   "ipc-1",
			}))
	if err != nil {
		t.Fatalf("DefineIndicator: %v", err)
	}
	return out.Msg.GetDefinition()
}

// SRS-QMS-011. The clocks come from the deployment's configuration, not from
// the request, and a complaint resolved without the complainant ever being
// spoken to is a file closed rather than a grievance handled.
func TestComplaintClocksComeFromConfigurationNotTheRequest(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	received := time.Now().UTC().Add(-time.Hour)
	out, err := h.quality.ReceiveComplaint(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ReceiveComplaintRequest{
			Reference:  "COMP-" + uuid.NewString()[:8],
			Kind:       qualityv1.ComplainantKind_COMPLAINANT_KIND_RELATIVE,
			Category:   "communication",
			Detail:     "nobody explained the delay",
			ReceivedAt: timestamppb.New(received),
		}))
	if err != nil {
		t.Fatalf("ReceiveComplaint: %v", err)
	}
	complaint := out.Msg.GetComplaint()

	// 48 hours and 30 days, from the harness configuration. Nothing on the
	// wire could have said otherwise.
	ackIn := complaint.GetAcknowledgeBy().AsTime().Sub(received)
	resolveIn := complaint.GetResolveBy().AsTime().Sub(received)
	if ackIn.Round(time.Hour) != 48*time.Hour {
		t.Fatalf("acknowledge clock = %v, want 48h", ackIn)
	}
	if resolveIn.Round(time.Hour) != 30*24*time.Hour {
		t.Fatalf("resolve clock = %v, want 30 days", resolveIn)
	}

	_, err = h.quality.ResolveComplaint(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.ResolveComplaintRequest{
			ComplaintId:     complaint.GetComplaintId(),
			Outcome:         qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_UPHELD,
			Resolution:      "apologised",
			ExpectedVersion: complaint.GetVersion(),
		}))
	if err == nil {
		t.Fatal("a complaint was resolved without acknowledgement")
	}

	acked, err := h.quality.AcknowledgeComplaint(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.AcknowledgeComplaintRequest{
				ComplaintId:     complaint.GetComplaintId(),
				ExpectedVersion: complaint.GetVersion(),
			}))
	if err != nil {
		t.Fatalf("AcknowledgeComplaint: %v", err)
	}
	if _, err := h.quality.ResolveComplaint(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ResolveComplaintRequest{
				ComplaintId:     complaint.GetComplaintId(),
				Outcome:         qualityv1.ComplaintOutcome_COMPLAINT_OUTCOME_UPHELD,
				Resolution:      "apologised, ward briefed",
				ExpectedVersion: acked.Msg.GetComplaint().GetVersion(),
			})); err != nil {
		t.Fatalf("ResolveComplaint: %v", err)
	}
}

// SRS-QMS-012. Peer review is the narrowest access in this system: its own
// permission, a restricted committee, and a preventable death that must name
// actions that exist.
func TestPeerReviewIsNarrowAndAPreventableDeathNamesRealActions(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	open := h.restrictedCommittee(t, false)
	_, err := h.quality.StartMortalityReview(ctx,
		withFacility(h.reviewerToken(), h.facility,
			&qualityv1.StartMortalityReviewRequest{
				PatientId: "pat-1", CommitteeId: open,
				DiedAt: timestamppb.New(time.Now().UTC().AddDate(0, 0, -7)),
			}))
	if err == nil {
		t.Fatal("peer review was opened in an unrestricted committee")
	}

	committee := h.restrictedCommittee(t, true)

	// The quality manager runs the department and still may not sit on the
	// committee.
	_, err = h.quality.StartMortalityReview(ctx,
		withFacility(h.managerToken(), h.facility,
			&qualityv1.StartMortalityReviewRequest{
				PatientId: "pat-1", CommitteeId: committee,
				DiedAt: timestamppb.New(time.Now().UTC().AddDate(0, 0, -7)),
			}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("the manager starting a peer review returned %v, want PermissionDenied",
			got)
	}

	started, err := h.quality.StartMortalityReview(ctx,
		withFacility(h.reviewerToken(), h.facility,
			&qualityv1.StartMortalityReviewRequest{
				PatientId: "pat-1", CommitteeId: committee,
				DiedAt: timestamppb.New(time.Now().UTC().AddDate(0, 0, -7)),
			}))
	if err != nil {
		t.Fatalf("StartMortalityReview: %v", err)
	}
	review := started.Msg.GetReview()

	meeting := h.meeting(t, committee)

	// A potentially preventable death naming an action that does not exist.
	_, err = h.quality.CompleteMortalityReview(ctx,
		withFacility(h.reviewerToken(), h.facility,
			&qualityv1.CompleteMortalityReviewRequest{
				ReviewId: review.GetReviewId(), MeetingId: meeting,
				Classification:  qualityv1.DeathClassification_DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE,
				Findings:        "delay in escalating a deteriorating patient",
				ActionIds:       []string{uuid.NewString()},
				ExpectedVersion: review.GetVersion(),
			}))
	if err == nil {
		t.Fatal("a peer review was signed off naming an action that does not exist")
	}

	action := h.raiseAction(t, h.officerToken())
	if _, err := h.quality.CompleteMortalityReview(ctx,
		withFacility(h.reviewerToken(), h.facility,
			&qualityv1.CompleteMortalityReviewRequest{
				ReviewId: review.GetReviewId(), MeetingId: meeting,
				Classification:  qualityv1.DeathClassification_DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE,
				Findings:        "delay in escalating a deteriorating patient",
				LearningPoints:  "the escalation protocol needs a hard trigger",
				ActionIds:       []string{action.GetCapaId()},
				ExpectedVersion: review.GetVersion(),
			})); err != nil {
		t.Fatalf("CompleteMortalityReview: %v", err)
	}
}

func (h *qmsHarness) restrictedCommittee(t *testing.T,
	restricted bool) string {

	t.Helper()
	out, err := h.quality.FormCommittee(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.FormCommitteeRequest{
				Code: "MM-" + uuid.NewString()[:6], Name: "M&M",
				Restricted: restricted, Members: []string{"mm-1", "mm-2"},
			}))
	if err != nil {
		t.Fatalf("FormCommittee: %v", err)
	}
	return out.Msg.GetCommittee().GetCommitteeId()
}

// SRS-QMS-015. A hold stops destruction; this stops the other way a record is
// lost, which is a closure or a correction that rewrites what a court asked to
// see.
func TestALegalHoldStopsAWriteAndNotAread(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.officerToken(), nil)

	// The officer does not hold qms.record.hold.
	_, err := h.quality.PlaceHold(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.PlaceHoldRequest{
			RecordClass: "qms_incident", RecordId: incident.GetIncidentId(),
			Reason: "coroner's request",
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("an officer placing a hold returned %v, want PermissionDenied",
			got)
	}

	// A record class this context does not hold.
	_, err = h.quality.PlaceHold(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.PlaceHoldRequest{
			RecordClass: "some_other_table", RecordId: incident.GetIncidentId(),
			Reason: "coroner's request",
		}))
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("an unknown record class returned %v, want InvalidArgument",
			got)
	}

	if _, err := h.quality.PlaceHold(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.PlaceHoldRequest{
			RecordClass: "qms_incident", RecordId: incident.GetIncidentId(),
			Reason: "coroner's request",
		})); err != nil {
		t.Fatalf("PlaceHold: %v", err)
	}

	// The write is refused.
	_, err = h.quality.AdvanceIncident(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.AdvanceIncidentRequest{
			IncidentId:      incident.GetIncidentId(),
			State:           qualityv1.IncidentState_INCIDENT_STATE_CLOSED,
			Reason:          "no further action",
			ExpectedVersion: incident.GetVersion(),
		}))
	if err == nil {
		t.Fatal("a held record was closed")
	}
	if !strings.Contains(err.Error(), "legal hold") {
		t.Fatalf("refusal = %v, want it to name the hold", err)
	}

	// The read is not.
	if _, err := h.quality.GetIncident(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.GetIncidentRequest{
			IncidentId: incident.GetIncidentId(),
		})); err != nil {
		t.Fatalf("GetIncident under hold: %v", err)
	}

	// Lifted, the write goes through.
	if _, err := h.quality.ReleaseHold(ctx, withFacility(h.managerToken(),
		h.facility, &qualityv1.ReleaseHoldRequest{
			RecordClass: "qms_incident", RecordId: incident.GetIncidentId(),
			Reason: "the coroner's enquiry closed",
		})); err != nil {
		t.Fatalf("ReleaseHold: %v", err)
	}
	if _, err := h.quality.AdvanceIncident(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.AdvanceIncidentRequest{
			IncidentId:      incident.GetIncidentId(),
			State:           qualityv1.IncidentState_INCIDENT_STATE_CLOSED,
			Reason:          "no further action",
			ExpectedVersion: incident.GetVersion(),
		})); err != nil {
		t.Fatalf("AdvanceIncident after release: %v", err)
	}
}

// SRS-QMS-003. Closing an incident the hospital's policy says needs an
// analysis is allowed, reported, and not refused: a log that will not let
// anything close is a log work goes into and never comes out of.
func TestClosingWithoutAnAnalysisIsReportedRatherThanRefused(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	// High risk, which this deployment says calls for an analysis, and harm,
	// which calls for a corrective action.
	incident := h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Reach = qualityv1.Reach_REACH_HARM
			req.Harm = qualityv1.Harm_HARM_MODERATE
			req.ImmediateAction = "reviewed by the registrar"
			req.Consequence = qualityv1.Consequence_CONSEQUENCE_MAJOR
			req.Likelihood = qualityv1.Likelihood_LIKELIHOOD_POSSIBLE
		})

	closed, err := h.quality.AdvanceIncident(ctx, withFacility(h.officerToken(),
		h.facility, &qualityv1.AdvanceIncidentRequest{
			IncidentId:      incident.GetIncidentId(),
			State:           qualityv1.IncidentState_INCIDENT_STATE_CLOSED,
			Reason:          "reviewed at the safety huddle",
			ExpectedVersion: incident.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AdvanceIncident: %v", err)
	}
	if len(closed.Msg.GetConcerns()) != 2 {
		t.Fatalf("concerns = %v, want the missing analysis and the missing action",
			closed.Msg.GetConcerns())
	}
	if closed.Msg.GetIncident().GetState() !=
		qualityv1.IncidentState_INCIDENT_STATE_CLOSED {
		t.Fatal("the incident was not closed")
	}
}

// SRS-QMS-001, SRS-QMS-006. Everybody reports and acknowledges; a nurse does
// nothing else, and a clerk does neither.
func TestANurseReportsAndAcknowledgesAndNothingElse(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.nurseToken(), nil)

	// A nurse does not score, close or restrict what they reported.
	_, err := h.quality.RescoreIncident(ctx, withFacility(h.nurseToken(),
		h.facility, &qualityv1.RescoreIncidentRequest{
			IncidentId:      incident.GetIncidentId(),
			Consequence:     qualityv1.Consequence_CONSEQUENCE_NEGLIGIBLE,
			Likelihood:      qualityv1.Likelihood_LIKELIHOOD_RARE,
			ExpectedVersion: incident.GetVersion(),
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("a nurse rescoring returned %v, want PermissionDenied", got)
	}

	_, err = h.quality.SetIncidentRestriction(ctx, withFacility(h.nurseToken(),
		h.facility, &qualityv1.SetIncidentRestrictionRequest{
			IncidentId: incident.GetIncidentId(), Restricted: false,
			Reason: "no longer sensitive", ExpectedVersion: incident.GetVersion(),
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("a nurse unrestricting returned %v, want PermissionDenied",
			got)
	}

	// And a clerk reports nothing: the permission is wide, not universal.
	_, err = h.quality.ReportIncident(ctx, withFacility(h.clerkToken(),
		h.facility, &qualityv1.ReportIncidentRequest{
			Category: "falls", Reach: qualityv1.Reach_REACH_NEAR_MISS,
			Harm:        qualityv1.Harm_HARM_NONE,
			Consequence: qualityv1.Consequence_CONSEQUENCE_MINOR,
			Likelihood:  qualityv1.Likelihood_LIKELIHOOD_RARE,
			Narrative:   "saw something",
			OccurredAt:  timestamppb.New(time.Now().UTC()),
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("a clerk reporting returned %v, want PermissionDenied", got)
	}
}

// SRS-QMS-002. A category whose count is rising because people have started
// reporting near misses is getting safer, and a single total says the
// opposite.
func TestTrendsSeparateNearMissesFromHarm(t *testing.T) {
	h := newQmsHarness(t)

	for i := 0; i < 2; i++ {
		h.report(t, h.officerToken(),
			func(req *qualityv1.ReportIncidentRequest) {
				req.Category = "falls"
			})
	}
	h.report(t, h.officerToken(),
		func(req *qualityv1.ReportIncidentRequest) {
			req.Category = "falls"
			req.Reach = qualityv1.Reach_REACH_HARM
			req.Harm = qualityv1.Harm_HARM_MILD
			req.ImmediateAction = "x-rayed"
		})

	trends, err := h.quality.GetTrends(context.Background(),
		withFacility(h.officerToken(), h.facility,
			&qualityv1.GetTrendsRequest{}))
	if err != nil {
		t.Fatalf("GetTrends: %v", err)
	}

	var falls *qualityv1.Trend
	for _, trend := range trends.Msg.GetTrends() {
		if trend.GetCategory() == "falls" {
			falls = trend
		}
	}
	if falls == nil {
		t.Fatalf("trends = %v, want a falls line", trends.Msg.GetTrends())
	}
	if falls.GetCount() != 3 || falls.GetNearMisses() != 2 ||
		falls.GetHarmful() != 1 {
		t.Fatalf("falls = %+v, want 3 total, 2 near misses, 1 harmful", falls)
	}
	if falls.GetWorstHarm() != qualityv1.Harm_HARM_MILD {
		t.Fatalf("worst harm = %v, want mild", falls.GetWorstHarm())
	}
}

func TestAnotherTenantReachesNoQualityRecord(t *testing.T) {
	h := newQmsHarness(t)
	ctx := context.Background()

	incident := h.report(t, h.officerToken(), nil)

	other := h.provisionOtherQualityTenant(t)
	_, err := h.quality.GetIncident(ctx,
		as(other+":qms-x:quality_manager",
			&qualityv1.GetIncidentRequest{
				IncidentId: incident.GetIncidentId(),
			}))
	if err == nil {
		t.Fatal("another tenant read this hospital's incident")
	}
	if got := connectCode(err); got != connect.CodeNotFound &&
		got != connect.CodePermissionDenied {
		t.Fatalf("cross-tenant read returned %v", got)
	}
}

func (h *qmsHarness) provisionOtherQualityTenant(t *testing.T) string {
	t.Helper()

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant(other): %v", err)
	}
	id := tenant.Msg.GetTenant().GetTenantId()

	repo := orgpostgres.New(pgtx.NewManager(h.dbPool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: id,
	}).TenantScope()
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), id, "",
		"quality", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement(other): %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope,
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement(other): %v", err)
	}
	return id
}
