package cloudstore_test

import (
	"context"
	"encoding/json"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/edge/cloudstore"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

var at = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

type fixture struct {
	pool       *pgxpool.Pool
	store      *cloudstore.Store
	scope      authctx.TenantScope
	tenantID   string
	facilityID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()
	facilityID := uuid.NewString()
	ctx := context.Background()

	// platform_edge.node has no FK to organization, but a realistic fixture
	// still needs a tenant row for the tenant to mean anything.
	if _, err := pool.Exec(ctx, `
		INSERT INTO organization.tenant (tenant_id, display_name, legal_jurisdiction,
			default_locale, time_zone, status, created_at, created_by, updated_at, updated_by, version)
		VALUES ($1, 'Apollo', 'IN', 'en-IN', 'Asia/Kolkata', 'active', $2, 'test', $2, 'test', 1)`,
		tenantID, at); err != nil {
		t.Fatalf("seed tenant: %v", err)
	}

	scope := authctx.NewSession(authctx.Session{SubjectID: "admin", TenantID: tenantID}).TenantScope()
	return fixture{
		pool:  pool,
		store: cloudstore.New(pgtx.NewManager(pool)),
		scope: scope, tenantID: tenantID, facilityID: facilityID,
	}
}

func (f fixture) registerAndEnroll(t *testing.T, token string) cloudstore.Node {
	t.Helper()
	ctx := context.Background()

	nodeID := uuid.NewString()
	if _, err := f.store.RegisterNode(ctx, f.scope, nodeID, f.facilityID, "ward-3-edge", at); err != nil {
		t.Fatalf("RegisterNode: %v", err)
	}
	if err := f.store.IssueEnrollmentToken(ctx, f.scope, nodeID, token, at.Add(time.Hour), at); err != nil {
		t.Fatalf("IssueEnrollmentToken: %v", err)
	}
	node, err := f.store.RedeemEnrollmentToken(ctx, token, "sha256:abc", at)
	if err != nil {
		t.Fatalf("RedeemEnrollmentToken: %v", err)
	}
	return node
}

func TestEnrollmentLifecycle(t *testing.T) {
	f := newFixture(t)
	node := f.registerAndEnroll(t, "one-time-token")

	if node.Status != cloudstore.NodeEnrolled {
		t.Fatalf("Status = %q, want enrolled", node.Status)
	}
	if node.TenantID != f.tenantID {
		t.Fatalf("TenantID = %q", node.TenantID)
	}
}

// The token is one-time. A reusable token is a permanent credential for anyone
// who reads a provisioning log.
func TestEnrollmentTokenCannotBeReused(t *testing.T) {
	f := newFixture(t)
	f.registerAndEnroll(t, "one-time-token")

	if _, err := f.store.RedeemEnrollmentToken(context.Background(), "one-time-token", "sha256:def", at); !errors.Is(err, cloudstore.ErrEnrollmentRejected) {
		t.Fatalf("token reuse accepted: %v", err)
	}
}

func TestExpiredEnrollmentTokenIsRejected(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	nodeID := uuid.NewString()
	if _, err := f.store.RegisterNode(ctx, f.scope, nodeID, f.facilityID, "ward-4-edge", at); err != nil {
		t.Fatalf("RegisterNode: %v", err)
	}
	if err := f.store.IssueEnrollmentToken(ctx, f.scope, nodeID, "expiring", at.Add(time.Minute), at); err != nil {
		t.Fatalf("IssueEnrollmentToken: %v", err)
	}

	if _, err := f.store.RedeemEnrollmentToken(ctx, "expiring", "sha256:abc", at.Add(time.Hour)); !errors.Is(err, cloudstore.ErrEnrollmentRejected) {
		t.Fatalf("expired token accepted: %v", err)
	}
}

// Only the hash is stored: a leaked row must not yield a usable credential.
func TestEnrollmentTokenIsStoredHashed(t *testing.T) {
	f := newFixture(t)
	f.registerAndEnroll(t, "secret-token-value")

	var stored string
	if err := f.pool.QueryRow(context.Background(),
		`SELECT token_hash FROM platform_edge.enrollment_token LIMIT 1`).Scan(&stored); err != nil {
		t.Fatalf("read token: %v", err)
	}
	if stored == "secret-token-value" {
		t.Fatal("enrollment token stored in clear")
	}
	if len(stored) != 64 {
		t.Fatalf("token_hash = %q, want a sha256 hex digest", stored)
	}
}

// The core reconciliation guarantee: redelivery produces no second effect.
func TestIngestIsIdempotentOnOperationID(t *testing.T) {
	f := newFixture(t)
	node := f.registerAndEnroll(t, "tok")
	ctx := context.Background()

	operationID := uuid.NewString()
	payload := json.RawMessage(`{"kind":"specimen","barcode":"ACC-1"}`)

	first, err := f.store.Ingest(ctx, f.scope, node.ID, operationID, "edge.label_printed", payload, at, at)
	if err != nil {
		t.Fatalf("first Ingest: %v", err)
	}
	if first.Outcome != cloudstore.OutcomeApplied {
		t.Fatalf("first outcome = %q", first.Outcome)
	}

	second, err := f.store.Ingest(ctx, f.scope, node.ID, operationID, "edge.label_printed", payload, at, at.Add(time.Minute))
	if err != nil {
		t.Fatalf("second Ingest: %v", err)
	}
	if second.Outcome != cloudstore.OutcomeDuplicate {
		t.Fatalf("second outcome = %q, want duplicate", second.Outcome)
	}

	var count int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_edge.forwarded_operation WHERE operation_id = $1`,
		operationID).Scan(&count); err != nil {
		t.Fatalf("count: %v", err)
	}
	if count != 1 {
		t.Fatalf("%d rows for one operation", count)
	}
}

// A revoked node's backlog must not be able to write after revocation.
func TestRevokedNodeCannotIngest(t *testing.T) {
	f := newFixture(t)
	node := f.registerAndEnroll(t, "tok")
	ctx := context.Background()

	if err := f.store.RevokeNode(ctx, f.scope, node.ID, at); err != nil {
		t.Fatalf("RevokeNode: %v", err)
	}

	result, err := f.store.Ingest(ctx, f.scope, node.ID, uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at)
	if err != nil {
		t.Fatalf("Ingest: %v", err)
	}
	if result.Outcome != cloudstore.OutcomeRejected {
		t.Fatalf("outcome = %q, want rejected", result.Outcome)
	}
	// The attempt is still recorded: an operator needs to see that a revoked
	// node tried to forward.
	if result.Reason != "NODE_revoked" {
		t.Fatalf("reason = %q", result.Reason)
	}
}

// A node that never enrolled must not be able to forward anything.
func TestPendingNodeCannotIngest(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	nodeID := uuid.NewString()
	if _, err := f.store.RegisterNode(ctx, f.scope, nodeID, f.facilityID, "unenrolled", at); err != nil {
		t.Fatalf("RegisterNode: %v", err)
	}

	result, err := f.store.Ingest(ctx, f.scope, nodeID, uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at)
	if err != nil {
		t.Fatalf("Ingest: %v", err)
	}
	if result.Outcome != cloudstore.OutcomeRejected {
		t.Fatalf("outcome = %q, want rejected", result.Outcome)
	}
}

// One tenant's edge node must not be able to forward into another tenant.
func TestIngestIsTenantScoped(t *testing.T) {
	f := newFixture(t)
	node := f.registerAndEnroll(t, "tok")

	otherScope := authctx.NewSession(authctx.Session{
		SubjectID: "attacker", TenantID: uuid.NewString(),
	}).TenantScope()

	_, err := f.store.Ingest(context.Background(), otherScope, node.ID, uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at)

	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryPermissionDenied {
		t.Fatalf("cross-tenant ingest was not denied: %v", err)
	}
}

// A successful ingest records when the operation happened at the edge, not when
// the cloud heard about it. Clinical and operational records need the former.
func TestIngestPreservesEdgeOccurrenceTime(t *testing.T) {
	f := newFixture(t)
	node := f.registerAndEnroll(t, "tok")
	ctx := context.Background()

	occurredAt := at.Add(-3 * time.Hour)
	receivedAt := at

	operationID := uuid.NewString()
	if _, err := f.store.Ingest(ctx, f.scope, node.ID, operationID,
		"edge.label_printed", json.RawMessage(`{}`), occurredAt, receivedAt); err != nil {
		t.Fatalf("Ingest: %v", err)
	}

	var storedOccurred, storedReceived time.Time
	if err := f.pool.QueryRow(ctx,
		`SELECT occurred_at, received_at FROM platform_edge.forwarded_operation WHERE operation_id = $1`,
		operationID).Scan(&storedOccurred, &storedReceived); err != nil {
		t.Fatalf("read row: %v", err)
	}
	if !storedOccurred.Equal(occurredAt) {
		t.Fatalf("occurred_at = %v, want %v", storedOccurred, occurredAt)
	}
	if !storedReceived.Equal(receivedAt) {
		t.Fatalf("received_at = %v, want %v", storedReceived, receivedAt)
	}
	if !storedOccurred.Before(storedReceived) {
		t.Fatal("the connectivity gap was lost")
	}
}

// Registering a node must be impossible without verified tenant scope.
func TestRegisterRequiresTenantScope(t *testing.T) {
	f := newFixture(t)
	var zero authctx.TenantScope

	if _, err := f.store.RegisterNode(context.Background(), zero, uuid.NewString(), f.facilityID, "x", at); err == nil {
		t.Fatal("node registered without tenant scope")
	}
}

// credential_fingerprint must be a control, not a decorative column: a caller
// holding only the node's non-secret identifiers must not be able to forward.
func TestIngestFromNodeRequiresTheCredential(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	nodeID := uuid.NewString()
	if _, err := f.store.RegisterNode(ctx, f.scope, nodeID, f.facilityID, "ward-3-edge", at); err != nil {
		t.Fatalf("RegisterNode: %v", err)
	}
	if err := f.store.IssueEnrollmentToken(ctx, f.scope, nodeID, "tok", at.Add(time.Hour), at); err != nil {
		t.Fatalf("IssueEnrollmentToken: %v", err)
	}
	if _, err := f.store.RedeemEnrollmentToken(ctx, "tok", "sha256:real-node-cert", at); err != nil {
		t.Fatalf("RedeemEnrollmentToken: %v", err)
	}

	// The genuine credential works and derives the tenant itself.
	result, err := f.store.IngestFromNode(ctx, "sha256:real-node-cert", uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at)
	if err != nil {
		t.Fatalf("IngestFromNode with the real credential: %v", err)
	}
	if result.Outcome != cloudstore.OutcomeApplied {
		t.Fatalf("outcome = %q", result.Outcome)
	}

	// Knowing the identifiers is not enough.
	if _, err := f.store.IngestFromNode(ctx, "sha256:attacker-cert", uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at); !errors.Is(err, cloudstore.ErrNodeNotAuthenticated) {
		t.Fatalf("an unknown credential was accepted: %v", err)
	}

	// An empty credential must not match the enrollment-pending rows, whose
	// fingerprint column is the empty string.
	if _, err := f.store.IngestFromNode(ctx, "", uuid.NewString(),
		"edge.label_printed", json.RawMessage(`{}`), at, at); !errors.Is(err, cloudstore.ErrNodeNotAuthenticated) {
		t.Fatalf("an empty credential was accepted: %v", err)
	}
}

// A revoked node's credential must stop working immediately, even though the
// row and its fingerprint remain for audit.
func TestRevokedNodeCredentialStopsAuthenticating(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	node := f.registerAndEnroll(t, "tok")

	// The fingerprint registerAndEnroll used.
	if _, err := f.store.AuthenticateNode(ctx, "sha256:abc"); err != nil {
		t.Fatalf("enrolled node failed to authenticate: %v", err)
	}

	if err := f.store.RevokeNode(ctx, f.scope, node.ID, at); err != nil {
		t.Fatalf("RevokeNode: %v", err)
	}

	if _, err := f.store.AuthenticateNode(ctx, "sha256:abc"); !errors.Is(err, cloudstore.ErrNodeNotAuthenticated) {
		t.Fatalf("a revoked credential still authenticates: %v", err)
	}
}

// A node authenticated by credential writes into its own tenant, whatever
// identifiers accompany the request.
func TestIngestFromNodeDerivesTenantFromTheCredential(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	node := f.registerAndEnroll(t, "tok")

	operationID := uuid.NewString()
	if _, err := f.store.IngestFromNode(ctx, "sha256:abc", operationID,
		"edge.label_printed", json.RawMessage(`{}`), at, at); err != nil {
		t.Fatalf("IngestFromNode: %v", err)
	}

	var storedTenant, storedNode string
	if err := f.pool.QueryRow(ctx,
		`SELECT tenant_id::text, node_id::text FROM platform_edge.forwarded_operation
		  WHERE operation_id = $1`, operationID).Scan(&storedTenant, &storedNode); err != nil {
		t.Fatalf("read row: %v", err)
	}
	if storedTenant != f.tenantID || storedNode != node.ID {
		t.Fatalf("stored (%s, %s), want (%s, %s)", storedTenant, storedNode, f.tenantID, node.ID)
	}
}
