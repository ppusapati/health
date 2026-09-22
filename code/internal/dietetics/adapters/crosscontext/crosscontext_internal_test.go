package crosscontext

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The rule is the wave specification's: "unavailable optional dependencies
// must degrade safely. A feature may not silently reinterpret a dependency
// outage as a valid negative business/clinical result."
//
// An internal test rather than one through OrderDirectory, because stubbing
// the orders and medication repositories would be twenty methods of
// boilerplate around one branch. The branch is the rule.
func TestOnlyAMissingOrderReadsAsAMissingOrder(t *testing.T) {
	// A reference nothing resolves is an answer to the question asked, and
	// the support plan is refused for the right reason.
	if err := absentOrFailed(
		rpcerr.NotFound("ORD_NOT_FOUND", "no such record")); err != nil {
		t.Fatalf("a missing order should read as absent, got %v", err)
	}

	// An outage is the failure it is. Reporting it as an absence would tell
	// a dietitian that the prescription pharmacy had just dispensed against
	// does not exist, and there is nothing they could do about that.
	if err := absentOrFailed(
		errors.New("dial tcp: connection refused")); err == nil {
		t.Fatal("a dependency outage was reported as a missing order")
	}

	// Nor is a permission refusal an absence: a deployment that had not
	// granted dietetics the read would see every reference rejected as
	// invalid.
	if err := absentOrFailed(
		rpcerr.PermissionDenied("ORD_FORBIDDEN", "not permitted")); err == nil {
		t.Fatal("a permission refusal was reported as a missing order")
	}
}
