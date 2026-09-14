package app_test

import (
	"context"
	"net/http/httptest"
	"testing"

	"connectrpc.com/connect"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	commonv1 "github.com/ppusapati/health/code/gen/go/healthcare/common/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1/identityaccessv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1/platformapiv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

// harness is the assembled stack under test: a real HTTP server in front of the
// real composition root in front of a real PostgreSQL database. Nothing between
// the client and the database is a stub, which is the point — the milestone is
// to prove the whole path, not each layer separately.
type harness struct {
	pool   *pgxpool.Pool
	server *httptest.Server
	org    organizationv1connect.OrganizationServiceClient
	ident  identityaccessv1connect.IdentityServiceClient
	health platformapiv1connect.HealthServiceClient
}

func newHarness(t *testing.T) *harness {
	t.Helper()
	// A limit high enough not to interfere with ordinary tests; the rate-limit
	// tests supply their own.
	return newHarnessWithRateLimit(t, platformtransport.RateLimitConfig{
		RequestsPerSecond: 10000, Burst: 10000,
		UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
	})
}

func newHarnessWithRateLimit(t *testing.T, limit platformtransport.RateLimitConfig) *harness {
	t.Helper()

	pool := pgtest.New(t)

	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool:      pool,
		Verifier:  verifier,
		Blobs:     testBlobs(t),
		Build:     platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: limit,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	client := server.Client()
	return &harness{
		pool:   pool,
		server: server,
		org:    organizationv1connect.NewOrganizationServiceClient(client, server.URL),
		ident:  identityaccessv1connect.NewIdentityServiceClient(client, server.URL),
		health: platformapiv1connect.NewHealthServiceClient(client, server.URL),
	}
}

// as builds a request carrying the caller's bearer token.
func as[T any](token string, msg *T) *connect.Request[T] {
	req := connect.NewRequest(msg)
	req.Header().Set(platformtransport.HeaderAuthorization, "Bearer "+token)
	return req
}

// platformOperatorToken authenticates a cross-tenant provisioning operator.
// The tenant component is a real UUID because the audit trail stores it as one.
func platformOperatorToken() string {
	return uuid.NewString() + ":ops-1:platform_operator"
}

func tenantAdminToken(tenantID string) string {
	return tenantID + ":admin-" + tenantID[:8] + ":tenant_admin"
}

func viewerToken(tenantID string) string {
	return tenantID + ":viewer-" + tenantID[:8] + ":facility_viewer"
}

// provisionTenant creates a tenant and returns its ID.
func (h *harness) provisionTenant(t *testing.T, displayName string) string {
	t.Helper()

	resp, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName:       displayName,
			LegalJurisdiction: "IN",
			DefaultLocale:     "en-IN",
			TimeZone:          "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant(%q): %v", displayName, err)
	}
	return resp.Msg.GetTenant().GetTenantId()
}

// connectCode extracts the Connect status code from an error.
func connectCode(err error) connect.Code {
	return connect.CodeOf(err)
}

// errorDetail returns the first structured ErrorDetail on the error, if any.
func errorDetail(t *testing.T, err error) *commonv1.ErrorDetail {
	t.Helper()

	var connectErr *connect.Error
	if !errorAs(err, &connectErr) {
		t.Fatalf("not a connect error: %v", err)
	}
	for _, d := range connectErr.Details() {
		value, valueErr := d.Value()
		if valueErr != nil {
			continue
		}
		if detail, ok := value.(*commonv1.ErrorDetail); ok {
			return detail
		}
	}
	return nil
}

func errorAs(err error, target **connect.Error) bool {
	return errors.As(err, target)
}

// testBlobs is a real blob store on a filesystem backend under the test's own
// directory.
//
// A real one rather than a double: attaching a file and photographing a wound
// go through the same routing, class allowlists, tenant prefixing and digest
// check that production uses, so a change that breaks them fails here instead
// of in an environment.
func testBlobs(t *testing.T) *blobstore.Vault {
	t.Helper()

	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
		Name: "local", Root: t.TempDir(),
	})
	if err != nil {
		t.Fatalf("blobstore.NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("blobstore.NewVault: %v", err)
	}
	return vault
}
