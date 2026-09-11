package rpcerr_test

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

func TestAsExtractsFromWrappedChain(t *testing.T) {
	base := rpcerr.NotFound("ORG_FACILITY_NOT_FOUND", "facility not found")
	wrapped := errors.Join(errors.New("context"), base)

	got, ok := rpcerr.As(wrapped)
	if !ok {
		t.Fatal("As did not find the platform error")
	}
	if got.Code != "ORG_FACILITY_NOT_FOUND" {
		t.Fatalf("Code = %q", got.Code)
	}
}

// The cause must stay reachable for logs but must not mutate the shared
// sentinel that constructors return.
func TestWithCauseDoesNotMutateOriginal(t *testing.T) {
	base := rpcerr.Internal("ORG_WRITE_FAILED", "write failed")
	cause := errors.New("connection reset")

	withCause := base.WithCause(cause)

	if !errors.Is(withCause, cause) {
		t.Fatal("cause not reachable via errors.Is")
	}
	if errors.Unwrap(base) != nil {
		t.Fatal("WithCause mutated the original error")
	}
}

func TestCategoriesAreDistinct(t *testing.T) {
	if rpcerr.PermissionDenied("A", "a").Category == rpcerr.NotFound("B", "b").Category {
		t.Fatal("permission denied and not found must not share a category")
	}
}

func TestErrorsAreNotRetryableByDefault(t *testing.T) {
	for _, e := range []*rpcerr.Error{
		rpcerr.Invalid("A", "a"),
		rpcerr.PermissionDenied("B", "b"),
		rpcerr.Internal("C", "c"),
	} {
		if e.Retryable {
			t.Fatalf("%s must not be retryable by default", e.Code)
		}
	}
}
