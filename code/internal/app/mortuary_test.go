package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	mortuaryv1 "github.com/ppusapati/health/code/gen/go/healthcare/mortuary/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/mortuary/v1/mortuaryv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	mortapp "github.com/ppusapati/health/code/internal/mortuary/application"
	mortdomain "github.com/ppusapati/health/code/internal/mortuary/domain"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// Mortuary operations (SRS-MORT-001 … 008), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a cause of death does
// not reach a caller who may not read it, that the person who puts a body in
// a drawer is not the person who releases it, that the clearance to release a
// medico-legal case comes from outside the mortuary — and, the one this
// family exists for, that no single role can take a body an authority has an
// interest in out of the building.

type mortHarness struct {
	pool     *pgxpool.Pool
	mortuary mortuaryv1connect.MortuaryServiceClient
	org      organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newMortHarness(t *testing.T) *mortHarness {
	return newMortHarnessWith(t, mortapp.Config{})
}

func newMortHarnessWith(t *testing.T,
	config mortapp.Config) *mortHarness {

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
		Mortuary: config,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler,
		&http2.Server{}))
	t.Cleanup(server.Close)

	h := &mortHarness{
		pool: pool,
		mortuary: mortuaryv1connect.NewMortuaryServiceClient(
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
		as(tenantAdminToken(h.tenantID),
			&organizationv1.CreateFacilityRequest{
				Code: "main", DisplayName: "Main Hospital",
				Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
				TimeZone: "Asia/Kolkata",
			}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"mortuary", "organization"} {
		h.entitleMort(t, module)
	}
	return h
}

func (h *mortHarness) entitleMort(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(),
		h.tenantID, "", module, true, now.Add(-time.Hour), time.Time{},
		"setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), h.mortScope(),
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *mortHarness) mortScope() authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()
}

func (h *mortHarness) attendantToken() string {
	return h.tenantID + ":mort-1:mortuary_attendant:" + h.facility
}

// otherAttendantToken is a second attendant. It exists so the two locks can
// be told apart: the domain refuses one person witnessing their own listing,
// and the permissions refuse anybody on the floor from releasing a body.
func (h *mortHarness) otherAttendantToken() string {
	return h.tenantID + ":mort-2:mortuary_attendant:" + h.facility
}

func (h *mortHarness) managerToken() string {
	return h.tenantID + ":mort-mgr:mortuary_manager:" + h.facility
}

func (h *mortHarness) coronerToken() string {
	return h.tenantID + ":coroner-1:coroners_officer:" + h.facility
}

func (h *mortHarness) openCase(t *testing.T, reference string,
	mutate func(*mortuaryv1.OpenCaseRequest)) *mortuaryv1.Case {

	t.Helper()
	req := &mortuaryv1.OpenCaseRequest{
		Reference:   reference,
		Source:      mortuaryv1.Source_SOURCE_IN_HOSPITAL,
		EncounterId: uuid.NewString(), PatientId: uuid.NewString(),
		Identity:           mortuaryv1.Identity_IDENTITY_CONFIRMED,
		IdentificationNote: "wristband checked against the notes",
		DisplayName:        "A Patient", FacilityId: h.facility,
		ReceivedFrom: "ward 3",
	}
	if mutate != nil {
		mutate(req)
	}
	out, err := h.mortuary.OpenCase(context.Background(),
		as(h.attendantToken(), req))
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	return out.Msg.GetMortuaryCase()
}

func (h *mortHarness) location(t *testing.T, code string,
	kind mortuaryv1.SpaceKind) *mortuaryv1.Location {

	t.Helper()
	out, err := h.mortuary.AddLocation(context.Background(),
		as(h.attendantToken(), &mortuaryv1.AddLocationRequest{
			Code: code, Kind: kind, FacilityId: h.facility, Zone: "main",
		}))
	if err != nil {
		t.Fatalf("AddLocation: %v", err)
	}
	return out.Msg.GetLocation()
}

// SRS-MORT-001 and SRS-MORT-003: the case is linked or plainly external, and
// the cause of death is written under one permission, read under another, and
// audited every time it is read.
func TestACaseIsLinkedOrPlainlyExternalAndTheCauseIsBehindItsOwnLock(
	t *testing.T) {

	h := newMortHarness(t)
	ctx := context.Background()

	// An in-hospital death names its encounter; there is no third state.
	if _, err := h.mortuary.OpenCase(ctx,
		as(h.attendantToken(), &mortuaryv1.OpenCaseRequest{
			Reference:  "M-X",
			Source:     mortuaryv1.Source_SOURCE_IN_HOSPITAL,
			Identity:   mortuaryv1.Identity_IDENTITY_UNIDENTIFIED,
			FacilityId: h.facility,
		})); err == nil {
		t.Fatal("an in-hospital case opened with no encounter")
	}

	// The attendant receives the body. The cause is not known yet, and
	// there is no field on the receipt to guess it into.
	opened, err := h.mortuary.OpenCase(ctx,
		as(h.attendantToken(), &mortuaryv1.OpenCaseRequest{
			Reference:      "M-2026-014",
			Source:         mortuaryv1.Source_SOURCE_BROUGHT_IN,
			ExternalSource: "city police",
			Identity:       mortuaryv1.Identity_IDENTITY_UNIDENTIFIED,
			MedicoLegal:    true, MlcReference: "PS-14/2026",
			FacilityId: h.facility, ReceivedFrom: "city police",
		}))
	if err != nil {
		t.Fatalf("OpenCase: %v", err)
	}
	body := opened.Msg.GetMortuaryCase()

	// Recording what somebody died of is its own act under its own
	// permission, and an attendant does not hold it.
	cause := &mortuaryv1.RecordCauseRequest{
		CaseId: body.GetCaseId(), Summary: "the sensitive line",
		Version: body.GetVersion(),
	}
	if _, err := h.mortuary.RecordCause(ctx,
		as(h.attendantToken(), cause)); err == nil {
		t.Fatal("an attendant wrote a cause of death")
	}
	// Nor does the manager, who releases bodies.
	if _, err := h.mortuary.RecordCause(ctx,
		as(h.managerToken(), cause)); err == nil {
		t.Fatal("a manager wrote a cause of death")
	}
	if _, err := h.mortuary.RecordCause(ctx,
		as(h.coronerToken(), cause)); err != nil {
		t.Fatalf("RecordCause: %v", err)
	}

	// The audit line records that a cause was written and never what it
	// says: an entry quoting it would be a second copy under weaker
	// controls.
	var reason, contextJSON string
	if err := h.pool.QueryRow(ctx,
		`SELECT coalesce(reason, ''), coalesce(context::text, '')
		 FROM platform_data.audit_record
		 WHERE tenant_id = $1
		   AND action = 'mortuary.case.cause_recorded'`,
		h.tenantID).Scan(&reason, &contextJSON); err != nil {
		t.Fatalf("audit: %v", err)
	}
	if strings.Contains(reason+contextJSON, "the sensitive line") {
		t.Fatalf("the audit trail quotes the cause: %q %q", reason,
			contextJSON)
	}

	// An attendant reading the case gets the reference and the flag, and
	// neither the cause nor the police number.
	plain, err := h.mortuary.GetCase(ctx,
		as(h.attendantToken(), &mortuaryv1.GetCaseRequest{
			CaseId: body.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetCase: %v", err)
	}
	if plain.Msg.GetMortuaryCase().GetCauseSummary() != "" ||
		plain.Msg.GetMortuaryCase().GetMlcReference() != "" {
		t.Fatalf("the sensitive detail reached an attendant: %+v",
			plain.Msg.GetMortuaryCase())
	}
	// It does not hide that the case is medico-legal: an attendant needs
	// to know before they move it.
	if !plain.Msg.GetMortuaryCase().GetMedicoLegal() {
		t.Fatal("the medico-legal flag was redacted")
	}

	// The coroner's officer reads it, and the read is audited.
	full, err := h.mortuary.GetCase(ctx,
		as(h.coronerToken(), &mortuaryv1.GetCaseRequest{
			CaseId: body.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetCase: %v", err)
	}
	if full.Msg.GetMortuaryCase().GetCauseSummary() !=
		"the sensitive line" {
		t.Fatalf("the cause did not reach the coroner's officer: %+v",
			full.Msg.GetMortuaryCase())
	}

	var reads int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.audit_record
		 WHERE tenant_id = $1 AND action = 'mortuary.case.sensitive_read'
		   AND resource_id = $2`,
		h.tenantID, body.GetCaseId()).Scan(&reads); err != nil {
		t.Fatalf("audit: %v", err)
	}
	if reads != 1 {
		t.Fatalf("want one audited sensitive read, got %d", reads)
	}

	// And the register list carries the sensitive detail for nobody, so a
	// caller cannot get by listing what they may not get by reading.
	listed, err := h.mortuary.ListCases(ctx,
		as(h.coronerToken(), &mortuaryv1.ListCasesRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListCases: %v", err)
	}
	for _, row := range listed.Msg.GetCases() {
		if row.GetCauseSummary() != "" || row.GetMlcReference() != "" {
			t.Fatalf("the register list carries the cause: %+v", row)
		}
	}
}

func TestOneBodyPerSpaceAndTheMoveIsOneAct(t *testing.T) {
	h := newMortHarness(t)
	ctx := context.Background()

	first := h.openCase(t, "M-1", nil)
	second := h.openCase(t, "M-2", nil)
	fridge := h.location(t, "F2-14",
		mortuaryv1.SpaceKind_SPACE_KIND_REFRIGERATED)
	viewing := h.location(t, "V-1",
		mortuaryv1.SpaceKind_SPACE_KIND_VIEWING)

	// "Identity checked" with nothing behind it is a tick.
	if _, err := h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId: first.GetCaseId(), LocationId: fridge.GetLocationId(),
			StorageTag: "TAG-1", Version: first.GetVersion(),
		})); err == nil {
		t.Fatal("a body was placed with no identity check")
	}

	placed, err := h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId: first.GetCaseId(), LocationId: fridge.GetLocationId(),
			StorageTag:  "TAG-1",
			CheckedNote: "wristband against the register",
			Version:     first.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("PlaceBody: %v", err)
	}
	if placed.Msg.GetPlacement().GetIdentityCheckedNote() == "" {
		t.Fatalf("the identity check was lost: %+v",
			placed.Msg.GetPlacement())
	}

	// Two cases in one refrigerated space is one body somebody will not
	// find, and the refusal says which of the three rules it broke rather
	// than that something went wrong.
	_, err = h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId: second.GetCaseId(), LocationId: fridge.GetLocationId(),
			StorageTag: "TAG-2", CheckedNote: "checked",
			Version: second.GetVersion(),
		}))
	if err == nil {
		t.Fatal("two bodies went into one space")
	}
	if !strings.Contains(err.Error(), "already a body in that space") {
		t.Fatalf("want a refusal naming the space, got %v", err)
	}

	// And one tag on two bodies cannot be told apart at the point where
	// telling them apart is the whole job.
	_, err = h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId:     second.GetCaseId(),
			LocationId: viewing.GetLocationId(), StorageTag: "TAG-1",
			CheckedNote: "checked", Version: second.GetVersion(),
		}))
	if err == nil {
		t.Fatal("one tag went on two bodies")
	}
	if !strings.Contains(err.Error(), "on another body") {
		t.Fatalf("want a refusal naming the tag, got %v", err)
	}

	// Moving is one act: the old placement closes and the new one opens
	// together, so the body is never in two drawers and never in none.
	moved, err := h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId:     first.GetCaseId(),
			LocationId: viewing.GetLocationId(), StorageTag: "TAG-1",
			CheckedNote: "checked against the tag",
			MoveReason:  "family viewing",
			Version:     first.GetVersion() + 1,
		}))
	if err != nil {
		t.Fatalf("PlaceBody: %v", err)
	}
	if moved.Msg.GetPlacement().GetLocationId() !=
		viewing.GetLocationId() {
		t.Fatalf("the body did not move: %+v", moved.Msg.GetPlacement())
	}

	// The fridge is free again, and the second body goes in.
	if _, err := h.mortuary.PlaceBody(ctx,
		as(h.attendantToken(), &mortuaryv1.PlaceBodyRequest{
			CaseId: second.GetCaseId(), LocationId: fridge.GetLocationId(),
			StorageTag: "TAG-2", CheckedNote: "checked",
			Version: second.GetVersion(),
		})); err != nil {
		t.Fatalf("PlaceBody: %v", err)
	}

	// "Where was it on Tuesday" is a question asked by a family who came
	// and were told the wrong thing.
	history, err := h.mortuary.GetPlacementHistory(ctx,
		as(h.attendantToken(), &mortuaryv1.GetPlacementHistoryRequest{
			CaseId: first.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetPlacementHistory: %v", err)
	}
	if len(history.Msg.GetPlacements()) != 2 {
		t.Fatalf("the history lost a move: %+v",
			history.Msg.GetPlacements())
	}
	if history.Msg.GetPlacements()[0].GetEndedReason() != "family viewing" {
		t.Fatalf("the move lost its why: %+v",
			history.Msg.GetPlacements()[0])
	}

	// A space cannot be taken off the board with a body still in it: the
	// board would stop offering it and nobody would come back for it.
	if _, err := h.mortuary.SetLocationService(ctx,
		as(h.attendantToken(), &mortuaryv1.SetLocationServiceRequest{
			LocationId: fridge.GetLocationId(), OutOfService: true,
			Reason: "refrigeration failed", Version: fridge.GetVersion(),
		})); err == nil {
		t.Fatal("an occupied space was taken off the board")
	}
}

func TestBelongingsNeedTwoPeopleAndWhatAnAuthorityTookIsNotHandedOver(
	t *testing.T) {

	h := newMortHarness(t)
	ctx := context.Background()

	body := h.openCase(t, "M-1", nil)

	// A list of what was in somebody's pockets, made by one person alone,
	// is a list nobody can stand behind.
	if _, err := h.mortuary.ListItem(ctx,
		as(h.attendantToken(), &mortuaryv1.ListItemRequest{
			CaseId:      body.GetCaseId(),
			Kind:        mortuaryv1.ItemKind_ITEM_KIND_VALUABLE,
			Description: "a gold ring", Quantity: 1,
			SealNumber: "SEAL-0091",
		})); err == nil {
		t.Fatal("a valuable was listed with no witness")
	}
	// And one person signing as both is the control not working.
	if _, err := h.mortuary.ListItem(ctx,
		as(h.attendantToken(), &mortuaryv1.ListItemRequest{
			CaseId:      body.GetCaseId(),
			Kind:        mortuaryv1.ItemKind_ITEM_KIND_VALUABLE,
			Description: "a gold ring", Quantity: 1,
			SealNumber: "SEAL-0091", WitnessedBy: "mort-1",
		})); err == nil {
		t.Fatal("one person witnessed their own listing")
	}

	ring, err := h.mortuary.ListItem(ctx,
		as(h.attendantToken(), &mortuaryv1.ListItemRequest{
			CaseId:      body.GetCaseId(),
			Kind:        mortuaryv1.ItemKind_ITEM_KIND_VALUABLE,
			Description: "a gold ring", Quantity: 1,
			SealNumber: "SEAL-0091", WitnessedBy: "mort-2",
		}))
	if err != nil {
		t.Fatalf("ListItem: %v", err)
	}
	jacket, err := h.mortuary.ListItem(ctx,
		as(h.attendantToken(), &mortuaryv1.ListItemRequest{
			CaseId:      body.GetCaseId(),
			Kind:        mortuaryv1.ItemKind_ITEM_KIND_CLOTHING,
			Description: "a jacket", Quantity: 1,
		}))
	if err != nil {
		t.Fatalf("ListItem: %v", err)
	}

	// The police take the ring. Its own state, because the family has not
	// got it and telling them it was handed over would be untrue.
	if _, err := h.mortuary.RetainItem(ctx,
		as(h.attendantToken(), &mortuaryv1.RetainItemRequest{
			ItemId:    ring.Msg.GetItem().GetItemId(),
			Authority: "city police", Reference: "PS-14/2026",
		})); err != nil {
		t.Fatalf("RetainItem: %v", err)
	}

	handover := &mortuaryv1.HandOverBelongingsRequest{
		CaseId: body.GetCaseId(),
		ItemIds: []string{
			jacket.Msg.GetItem().GetItemId(),
			ring.Msg.GetItem().GetItemId(),
		},
		RecipientName: "A Son", RecipientRelation: "son",
		RecipientIdType: "national id", RecipientIdRef: "XX-1234",
		SignatureRef: "reg-page-114", WitnessedBy: "mort-2",
	}
	// The family cannot be given what the coroner has.
	if _, err := h.mortuary.HandOverBelongings(ctx,
		as(h.attendantToken(), handover)); err == nil {
		t.Fatal("a retained item was handed to the family")
	}

	handover.ItemIds = []string{jacket.Msg.GetItem().GetItemId()}
	handed, err := h.mortuary.HandOverBelongings(ctx,
		as(h.attendantToken(), handover))
	if err != nil {
		t.Fatalf("HandOverBelongings: %v", err)
	}
	if handed.Msg.GetHandover().GetSignatureRef() == "" {
		t.Fatalf("the signature reference was lost: %+v",
			handed.Msg.GetHandover())
	}

	// A manager, who releases bodies, does not list or hand over the
	// belongings: the person who releases the body is not the person who
	// signs out what was in the pockets.
	if _, err := h.mortuary.ListItem(ctx,
		as(h.managerToken(), &mortuaryv1.ListItemRequest{
			CaseId:      body.GetCaseId(),
			Kind:        mortuaryv1.ItemKind_ITEM_KIND_CLOTHING,
			Description: "a scarf", Quantity: 1,
		})); err == nil {
		t.Fatal("a manager listed belongings")
	}

	// The chain of custody has a line for each act, and every line names
	// who recorded it.
	chain, err := h.mortuary.GetChainOfCustody(ctx,
		as(h.attendantToken(), &mortuaryv1.GetChainOfCustodyRequest{
			CaseId: body.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetChainOfCustody: %v", err)
	}
	events := map[string]bool{}
	for _, entry := range chain.Msg.GetEntries() {
		if entry.GetRecordedBy() == "" {
			t.Fatalf("a chain entry names nobody: %+v", entry)
		}
		events[entry.GetEvent()] = true
	}
	for _, want := range []string{
		"received", "listed", "retained", "belongings_handed_over",
	} {
		if !events[want] {
			t.Fatalf("the chain has no %q line: %+v", want, events)
		}
	}
}

// SRS-MORT-006 and SRS-MORT-007: the checks run whoever asks, and the floor
// no policy can lower — a medico-legal case needs a named authority's
// clearance — takes three people to satisfy.
func TestNoSingleRoleTakesAMedicoLegalBodyOutOfTheBuilding(t *testing.T) {
	h := newMortHarness(t)
	ctx := context.Background()

	body := h.openCase(t, "M-1", func(req *mortuaryv1.OpenCaseRequest) {
		req.MedicoLegal, req.MlcReference = true, "PS-14/2026"
	})

	release := &mortuaryv1.ReleaseBodyRequest{
		CaseId: body.GetCaseId(), RecipientName: "A Son",
		RecipientRelation: "son", RecipientIdType: "national id",
		RecipientIdRef:   "XX-1234",
		VerificationNote: "identity confirmed against the register",
		SignatureRef:     "reg-page-114",
		Destination:      "a funeral director",
		WitnessedBy:      "mort-2", Version: body.GetVersion(),
	}

	// The attendant who received the body cannot release it, and it is the
	// permission that stops them rather than the case's own rules: an
	// attendant refused only because this case is medico-legal would be
	// free to release the next one that is not.
	_, err := h.mortuary.ReleaseBody(ctx, as(h.attendantToken(), release))
	if err == nil {
		t.Fatal("an attendant released a body")
	}
	if !strings.Contains(err.Error(), "mort.release") {
		t.Fatalf("want a refusal naming the permission, got %v", err)
	}

	// The manager can, but not without the authority's clearance — and no
	// policy setting turns that off.
	_, err = h.mortuary.ReleaseBody(ctx, as(h.managerToken(), release))
	if err == nil {
		t.Fatal("a medico-legal body was released with no clearance")
	}
	if !strings.Contains(err.Error(), "authority") {
		t.Fatalf("want a refusal naming the authority, got %v", err)
	}

	// The checks come back as a list rather than one at a time.
	checks, err := h.mortuary.GetReleaseChecks(ctx,
		as(h.managerToken(), &mortuaryv1.GetReleaseChecksRequest{
			CaseId: body.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetReleaseChecks: %v", err)
	}
	found := false
	for _, check := range checks.Msg.GetChecks() {
		if check.GetCode() == "authority" && check.GetMandatory() {
			found = true
		}
	}
	if !found {
		t.Fatalf("the authority check is missing or optional: %+v",
			checks.Msg.GetChecks())
	}

	// And the manager cannot record the clearance themselves: it comes
	// from outside the mortuary.
	clearance := &mortuaryv1.RecordAuthorisationRequest{
		CaseId: body.GetCaseId(), Authority: "the coroner",
		Reference: "CO-2026-0044",
	}
	if _, err := h.mortuary.RecordAuthorisation(ctx,
		as(h.managerToken(), clearance)); err == nil {
		t.Fatal("a manager cleared their own release")
	}

	if _, err := h.mortuary.RecordAuthorisation(ctx,
		as(h.coronerToken(), clearance)); err != nil {
		t.Fatalf("RecordAuthorisation: %v", err)
	}

	// The coroner's officer, who took the clearance, still cannot release
	// the body: they decide what may happen and do not do it.
	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.coronerToken(), release)); err == nil {
		t.Fatal("the coroner's officer released a body")
	}

	released, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), release))
	if err != nil {
		t.Fatalf("ReleaseBody: %v", err)
	}
	// "Under whose authority" is answered by the record rather than by
	// somebody's memory.
	if released.Msg.GetRelease().GetAuthority() != "the coroner" ||
		released.Msg.GetRelease().GetAuthorityReference() !=
			"CO-2026-0044" {
		t.Fatalf("the clearance did not travel: %+v",
			released.Msg.GetRelease())
	}
	if !released.Msg.GetRelease().GetMedicoLegal() {
		t.Fatalf("the release lost the medico-legal flag: %+v",
			released.Msg.GetRelease())
	}

	// A body leaves once.
	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), release)); err == nil {
		t.Fatal("a body was released twice")
	}

	// And the same floor holds for a body nobody has named, whether or not
	// an authority has taken an interest. Handing an unidentified body to
	// somebody who says it is theirs is the other half of what this rule
	// is for.
	unknown := h.openCase(t, "M-2", func(req *mortuaryv1.OpenCaseRequest) {
		req.Source = mortuaryv1.Source_SOURCE_BROUGHT_IN
		req.EncounterId, req.PatientId = "", ""
		req.ExternalSource = "city police"
		req.Identity = mortuaryv1.Identity_IDENTITY_UNIDENTIFIED
		req.IdentificationNote, req.DisplayName = "", ""
	})
	if unknown.GetMedicoLegal() {
		t.Fatal("the unidentified case is medico-legal; the assertion " +
			"below would prove the wrong rule")
	}

	unknownRelease := &mortuaryv1.ReleaseBodyRequest{
		CaseId: unknown.GetCaseId(), RecipientName: "A Stranger",
		RecipientIdType: "national id", RecipientIdRef: "YY-9876",
		VerificationNote: "checked against the register",
		SignatureRef:     "reg-page-115", WitnessedBy: "mort-2",
		Version: unknown.GetVersion(),
	}
	_, err = h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), unknownRelease))
	if err == nil {
		t.Fatal("an unidentified body was released with no clearance")
	}
	if !strings.Contains(err.Error(), "unidentified body is released") {
		t.Fatalf("want a refusal naming the unidentified rule, got %v",
			err)
	}

	if _, err := h.mortuary.RecordAuthorisation(ctx,
		as(h.coronerToken(), &mortuaryv1.RecordAuthorisationRequest{
			CaseId: unknown.GetCaseId(), Authority: "the coroner",
			Reference: "CO-2026-0045",
		})); err != nil {
		t.Fatalf("RecordAuthorisation: %v", err)
	}
	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), unknownRelease)); err != nil {
		t.Fatalf("ReleaseBody: %v", err)
	}
}

func TestAnUnfinishedExaminationHoldsTheBodyAndAClearanceIsNotEnough(
	t *testing.T) {

	h := newMortHarness(t)
	ctx := context.Background()

	body := h.openCase(t, "M-1", func(req *mortuaryv1.OpenCaseRequest) {
		req.MedicoLegal, req.MlcReference = true, "PS-14/2026"
	})

	request, err := h.mortuary.RequestPostmortem(ctx,
		as(h.attendantToken(), &mortuaryv1.RequestPostmortemRequest{
			CaseId: body.GetCaseId(),
			Kind:   mortuaryv1.PostmortemKind_POSTMORTEM_KIND_MEDICO_LEGAL,
			Reason: "death in custody",
		}))
	if err != nil {
		t.Fatalf("RequestPostmortem: %v", err)
	}
	pm := request.Msg.GetPostmortem()

	// A body opened on a request alone is one somebody will answer for.
	if _, err := h.mortuary.AdvancePostmortem(ctx,
		as(h.coronerToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId: pm.GetPostmortemId(),
			To:           mortuaryv1.PostmortemState_POSTMORTEM_STATE_PERFORMED,
			Pathologist:  "path-1", Version: pm.GetVersion(),
		})); err == nil {
		t.Fatal("an examination was performed with no authorisation")
	}

	// "Authorised by the coroner" with no reference is a sentence.
	if _, err := h.mortuary.AdvancePostmortem(ctx,
		as(h.coronerToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId: pm.GetPostmortemId(),
			To:           mortuaryv1.PostmortemState_POSTMORTEM_STATE_AUTHORISED,
			Authority:    "the coroner", Version: pm.GetVersion(),
		})); err == nil {
		t.Fatal("a medico-legal examination was authorised with no " +
			"reference")
	}

	// An attendant cannot authorise one either, and it is the permission
	// that stops them: an attendant refused only because the reference was
	// missing would be free to authorise one that has it.
	_, err = h.mortuary.AdvancePostmortem(ctx,
		as(h.attendantToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId:       pm.GetPostmortemId(),
			To:                 mortuaryv1.PostmortemState_POSTMORTEM_STATE_AUTHORISED,
			Authority:          "the coroner",
			AuthorityReference: "CO-2026-0044",
			Version:            pm.GetVersion(),
		}))
	if err == nil {
		t.Fatal("an attendant authorised an examination")
	}
	if !strings.Contains(err.Error(), "mort.postmortem.manage") {
		t.Fatalf("want a refusal naming the permission, got %v", err)
	}

	authorised, err := h.mortuary.AdvancePostmortem(ctx,
		as(h.coronerToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId:       pm.GetPostmortemId(),
			To:                 mortuaryv1.PostmortemState_POSTMORTEM_STATE_AUTHORISED,
			Authority:          "the coroner",
			AuthorityReference: "CO-2026-0044",
			Version:            pm.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AdvancePostmortem: %v", err)
	}
	pm = authorised.Msg.GetPostmortem()

	if _, err := h.mortuary.RecordAuthorisation(ctx,
		as(h.coronerToken(), &mortuaryv1.RecordAuthorisationRequest{
			CaseId: body.GetCaseId(), Authority: "the coroner",
			Reference: "CO-2026-0044",
		})); err != nil {
		t.Fatalf("RecordAuthorisation: %v", err)
	}

	release := &mortuaryv1.ReleaseBodyRequest{
		CaseId: body.GetCaseId(), RecipientName: "A Son",
		RecipientIdType: "national id", RecipientIdRef: "XX-1234",
		VerificationNote: "checked against the register",
		SignatureRef:     "reg-page-114", WitnessedBy: "mort-2",
		Version: body.GetVersion(),
	}
	// A clearance is not enough while the examination is unfinished: the
	// body cannot go until the coroner has what they asked for.
	_, err = h.mortuary.ReleaseBody(ctx, as(h.managerToken(), release))
	if err == nil {
		t.Fatal("a body was released with an examination outstanding")
	}
	if !strings.Contains(err.Error(), "postmortem") {
		t.Fatalf("want a refusal naming the examination, got %v", err)
	}

	performed, err := h.mortuary.AdvancePostmortem(ctx,
		as(h.coronerToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId: pm.GetPostmortemId(),
			To:           mortuaryv1.PostmortemState_POSTMORTEM_STATE_PERFORMED,
			Pathologist:  "path-1", Version: pm.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AdvancePostmortem: %v", err)
	}
	pm = performed.Msg.GetPostmortem()

	// A medico-legal examination performed and not yet reported still
	// holds the body: the coroner's answer is the report.
	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), release)); err == nil {
		t.Fatal("a body was released before the report")
	}

	if _, err := h.mortuary.AdvancePostmortem(ctx,
		as(h.coronerToken(), &mortuaryv1.AdvancePostmortemRequest{
			PostmortemId: pm.GetPostmortemId(),
			To:           mortuaryv1.PostmortemState_POSTMORTEM_STATE_REPORTED,
			ReportRef:    "doc-9912", Version: pm.GetVersion(),
		})); err != nil {
		t.Fatalf("AdvancePostmortem: %v", err)
	}

	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), release)); err != nil {
		t.Fatalf("ReleaseBody: %v", err)
	}
}

// SRS-MORT-007 and SRS-MORT-008: the configurable checks tighten what the
// floor already holds, and the board carries no clinical detail.
func TestThePolicyTightensTheChecksAndTheBoardCarriesNoClinicalDetail(
	t *testing.T) {

	h := newMortHarnessWith(t, mortapp.Config{
		Release: mortdomain.ReleasePolicy{
			RequireConfirmedIdentity: true,
			RequireDeathCertificate:  true,
		},
	})
	ctx := context.Background()

	restricted := h.openCase(t, "M-1",
		func(req *mortuaryv1.OpenCaseRequest) {
			req.Restricted = true
			req.DisplayName = "A Public Figure"
			req.Identity = mortuaryv1.Identity_IDENTITY_PRESUMED
			req.IdentificationNote = ""
		})

	release := &mortuaryv1.ReleaseBodyRequest{
		CaseId: restricted.GetCaseId(), RecipientName: "A Son",
		RecipientIdType: "national id", RecipientIdRef: "XX-1234",
		VerificationNote: "checked", SignatureRef: "reg-page-114",
		WitnessedBy: "mort-2", Version: restricted.GetVersion(),
	}

	// The deployment asks for a confirmed identification and the death
	// certificate; neither is a floor rule, and both come back at once.
	checks, err := h.mortuary.GetReleaseChecks(ctx,
		as(h.managerToken(), &mortuaryv1.GetReleaseChecksRequest{
			CaseId: restricted.GetCaseId(),
		}))
	if err != nil {
		t.Fatalf("GetReleaseChecks: %v", err)
	}
	codes := map[string]bool{}
	for _, check := range checks.Msg.GetChecks() {
		codes[check.GetCode()] = true
	}
	if !codes["identity"] || !codes["death_certificate"] {
		t.Fatalf("the policy checks are missing: %+v",
			checks.Msg.GetChecks())
	}

	if _, err := h.mortuary.ReleaseBody(ctx,
		as(h.managerToken(), release)); err == nil {
		t.Fatal("a body was released on a presumed identification")
	}

	// The board shows the reference and no name for a restricted case, and
	// has no field for a cause at all.
	board, err := h.mortuary.GetBoard(ctx,
		as(h.managerToken(), &mortuaryv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if len(board.Msg.GetRows()) != 1 {
		t.Fatalf("want one row, got %+v", board.Msg.GetRows())
	}
	row := board.Msg.GetRows()[0]
	if row.GetDisplayName() != "" {
		t.Fatalf("a restricted case shows its name: %+v", row)
	}
	if row.GetReference() == "" {
		t.Fatalf("the board shows nothing to find the case by: %+v", row)
	}
	if row.GetPendingRelease() {
		t.Fatalf("a case with outstanding checks is pending: %+v", row)
	}

	// The occupancy counts the spaces that are actually usable.
	h.location(t, "F2-14", mortuaryv1.SpaceKind_SPACE_KIND_REFRIGERATED)
	board, err = h.mortuary.GetBoard(ctx,
		as(h.managerToken(), &mortuaryv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if board.Msg.GetOccupancy().GetFree() != 1 ||
		board.Msg.GetOccupancy().GetFreeByKind()["refrigerated"] != 1 {
		t.Fatalf("the occupancy is wrong: %+v", board.Msg.GetOccupancy())
	}

	// And an attendant cannot read the board: it is the management view,
	// and it carries every case in the building.
	if _, err := h.mortuary.GetBoard(ctx,
		as(h.attendantToken(), &mortuaryv1.GetBoardRequest{
			FacilityId: h.facility,
		})); err == nil {
		t.Fatal("an attendant read the occupancy board")
	}

	// Clearing the checks makes the case pending, computed rather than
	// flagged.
	identified, err := h.mortuary.Identify(ctx,
		as(h.attendantToken(), &mortuaryv1.IdentifyRequest{
			CaseId:   restricted.GetCaseId(),
			Identity: mortuaryv1.Identity_IDENTITY_CONFIRMED,
			Name:     "A Public Figure",
			Note:     "identified by his daughter, who knew him",
			Version:  restricted.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if _, err := h.mortuary.RecordDeathCertificate(ctx,
		as(h.attendantToken(),
			&mortuaryv1.RecordDeathCertificateRequest{
				CaseId:    restricted.GetCaseId(),
				Reference: "D-2026-0091",
				Version:   identified.Msg.GetMortuaryCase().GetVersion(),
			})); err != nil {
		t.Fatalf("RecordDeathCertificate: %v", err)
	}

	board, err = h.mortuary.GetBoard(ctx,
		as(h.managerToken(), &mortuaryv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if !board.Msg.GetRows()[0].GetPendingRelease() {
		t.Fatalf("a cleared case is not pending release: %+v",
			board.Msg.GetRows()[0])
	}
}

func TestABodyHeldTooLongIsEscalatedRatherThanLeftOnAScreen(t *testing.T) {
	h := newMortHarnessWith(t, mortapp.Config{
		LongStayAfter: 14 * 24 * time.Hour,
	})
	ctx := context.Background()

	body := h.openCase(t, "M-2026-014", nil)

	// Nothing is due yet.
	early, err := h.mortuary.SweepLongStay(ctx,
		as(h.managerToken(), &mortuaryv1.SweepLongStayRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("SweepLongStay: %v", err)
	}
	if early.Msg.GetRaised() != 0 {
		t.Fatalf("a fresh case was escalated: %d", early.Msg.GetRaised())
	}

	// Three weeks later. A body nobody has claimed becomes somebody's
	// legal problem and then nobody's.
	if _, err := h.pool.Exec(ctx,
		`UPDATE mortuary.case
		 SET received_at = received_at - interval '21 days'
		 WHERE case_id = $1`, body.GetCaseId()); err != nil {
		t.Fatalf("age the case: %v", err)
	}

	swept, err := h.mortuary.SweepLongStay(ctx,
		as(h.managerToken(), &mortuaryv1.SweepLongStayRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("SweepLongStay: %v", err)
	}
	if swept.Msg.GetRaised() != 1 {
		t.Fatalf("want one notice raised, got %d", swept.Msg.GetRaised())
	}

	var kind, summary string
	if err := h.pool.QueryRow(ctx,
		`SELECT subject_kind, summary FROM platform_escalation.notice
		 WHERE tenant_id = $1 AND subject_id = $2`,
		h.tenantID, body.GetCaseId()).Scan(&kind, &summary); err != nil {
		t.Fatalf("notice: %v", err)
	}
	if kind != "mortuary_long_stay" {
		t.Fatalf("the wrong notice was raised: %s", kind)
	}
	// The reference and the days, and nothing else. A notice goes further
	// and under fewer controls than the record that produced it, and this
	// one would otherwise carry a name.
	if !strings.Contains(summary, "M-2026-014") ||
		!strings.Contains(summary, "21 days") {
		t.Fatalf("the notice does not say what it should: %q", summary)
	}
	if strings.Contains(summary, "A Patient") {
		t.Fatalf("the notice carries the name: %q", summary)
	}

	// The board shows how long, which is the number a mortuary manages by.
	board, err := h.mortuary.GetBoard(ctx,
		as(h.managerToken(), &mortuaryv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if board.Msg.GetRows()[0].GetHeldHours() < 21*24 {
		t.Fatalf("the board understates how long: %+v",
			board.Msg.GetRows()[0])
	}
}
