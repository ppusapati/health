package transport_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/transport"
)

// stubRevoker answers from a per-subject watermark, which is what a real
// implementation reduces to.
type stubRevoker struct {
	notValidBefore map[string]time.Time
	calls          int
	err            error
}

func (s *stubRevoker) SessionRevoked(_ context.Context, session authctx.Session) (bool, string, error) {
	s.calls++
	if s.err != nil {
		return false, "", s.err
	}
	watermark, known := s.notValidBefore[session.SubjectID]
	if !known {
		return false, "", nil
	}
	if !session.IssuedAt.After(watermark) {
		return true, "SESSION_REVOKED", nil
	}
	return false, "", nil
}

func revocationHarness(t *testing.T, revoker transport.SessionRevoker,
	session *authctx.Session) (reached bool, err error) {
	t.Helper()

	interceptor := transport.NewRevocationInterceptor(revoker)
	handler := interceptor(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		reached = true
		return connect.NewResponse(&struct{}{}), nil
	})

	ctx := context.Background()
	if session != nil {
		ctx = authctx.WithSession(ctx, *session)
	}
	_, err = handler(ctx, connect.NewRequest(&struct{}{}))
	return reached, err
}

var revNow = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

// SRS-IAM-006's verification clause at the request path: a revoked session is
// refused, even though its own token is nowhere near expiry.
func TestRevokedSessionIsRefusedAtTheRequestPath(t *testing.T) {
	revoker := &stubRevoker{notValidBefore: map[string]time.Time{
		"disabled-user": revNow.Add(5 * time.Minute),
	}}

	stale := &authctx.Session{
		SubjectID: "disabled-user", TenantID: "tenant-a",
		IssuedAt: revNow, CorrelationID: "corr-1",
	}
	reached, err := revocationHarness(t, revoker, stale)
	if reached {
		t.Fatal("a revoked session reached the handler")
	}
	// UNAUTHENTICATED, so the client obtains a new credential rather than
	// retrying forever with the dead one.
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("want Unauthenticated, got %v (%v)", connect.CodeOf(err), err)
	}

	// A credential minted after the revocation passes.
	fresh := &authctx.Session{
		SubjectID: "disabled-user", TenantID: "tenant-a",
		IssuedAt: revNow.Add(10 * time.Minute), CorrelationID: "corr-2",
	}
	reached, err = revocationHarness(t, revoker, fresh)
	if err != nil {
		t.Fatalf("a freshly issued session was refused: %v", err)
	}
	if !reached {
		t.Fatal("a valid session did not reach the handler")
	}
}

func TestUnrevokedSessionPassesThrough(t *testing.T) {
	revoker := &stubRevoker{notValidBefore: map[string]time.Time{}}
	session := &authctx.Session{
		SubjectID: "user-1", TenantID: "tenant-a", IssuedAt: revNow, CorrelationID: "c",
	}
	reached, err := revocationHarness(t, revoker, session)
	if err != nil {
		t.Fatalf("an ordinary session was refused: %v", err)
	}
	if !reached {
		t.Fatal("the handler did not run")
	}
}

// A lookup failure must fail closed. Treating it as "not revoked" means a
// database blip silently restores access for every disabled account at once —
// the worst possible moment to be permissive.
func TestALookupFailureFailsClosed(t *testing.T) {
	revoker := &stubRevoker{err: errors.New("revocation store unavailable")}
	session := &authctx.Session{
		SubjectID: "user-1", TenantID: "tenant-a", IssuedAt: revNow, CorrelationID: "c",
	}

	reached, err := revocationHarness(t, revoker, session)
	if reached {
		t.Fatal("the handler ran despite a failed revocation check")
	}
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("want Unauthenticated, got %v", connect.CodeOf(err))
	}
}

// No session means a public procedure or a request the auth interceptor is
// about to refuse. Either way, not this interceptor's decision.
func TestNoSessionIsLeftAlone(t *testing.T) {
	revoker := &stubRevoker{notValidBefore: map[string]time.Time{}}
	reached, err := revocationHarness(t, revoker, nil)
	if err != nil {
		t.Fatalf("a request with no session was refused: %v", err)
	}
	if !reached {
		t.Fatal("the chain was interrupted")
	}
	if revoker.calls != 0 {
		t.Error("the revoker was consulted without a session")
	}
}
