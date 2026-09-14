package photostore_test

import (
	"testing"

	"github.com/ppusapati/health/code/internal/empi/adapters/photostore"
)

// A typed nil pointer in an interface is not a nil interface, so a store built
// from no vault has to come back as a genuinely nil ports.PhotoStore. Get this
// wrong and the application's "this deployment stores no photographs" branch
// is skipped, and the first capture panics on a nil pointer instead of saying
// what is wrong.
func TestNoVaultYieldsANilStore(t *testing.T) {
	if store := photostore.New(nil); store != nil {
		t.Fatalf("New(nil) returned a non-nil store (%T); the no-store branch will be skipped", store)
	}
}
