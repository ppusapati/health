package postgres

import (
	"context"
	"time"

	identityports "github.com/ppusapati/health/code/internal/identity_access/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/quality/ports"
	securitydomain "github.com/ppusapati/health/code/internal/security/domain"
	securityports "github.com/ppusapati/health/code/internal/security/ports"
)

// Holds adapts the platform's legal-hold store (SRS-QMS-015).
//
// An adapter rather than a second hold table here. SRS-DAT and SRS-MRD-005
// place holds through the same mechanism, and a hold placed in one place with
// a purge that reads another is a hold that does nothing — which nobody finds
// out until the records are gone.
type Holds struct {
	store securityports.LegalHoldStore
	ids   ports.IDGenerator
}

// NewHolds constructs the adapter.
func NewHolds(store securityports.LegalHoldStore, ids ports.IDGenerator) Holds {
	return Holds{store: store, ids: ids}
}

var _ ports.LegalHolds = Holds{}

// Held reports whether a record may not be destroyed.
//
// A failure propagates rather than answering "not held". Treating a database
// error as "no hold applies" is how a purge deletes the one record a court
// asked for.
func (h Holds) Held(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID string) (bool, error) {

	if h.store == nil {
		return false, nil
	}
	return h.store.IsHeld(ctx, scope, recordClass, recordID)
}

// Place puts a record beyond deletion (SRS-QMS-015).
func (h Holds) Place(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID, reason, by string, at time.Time) error {

	if h.store == nil {
		return nil
	}
	hold, err := securitydomain.NewLegalHold(h.ids.NewID(), scope.TenantID(),
		recordClass, recordID, reason, by, at)
	if err != nil {
		return err
	}
	_, err = h.store.Place(ctx, scope, hold)
	return err
}

// Release lifts a hold.
func (h Holds) Release(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID, by string, at time.Time) error {

	if h.store == nil {
		return nil
	}
	_, err := h.store.Release(ctx, scope, recordClass, recordID, by, at)
	return err
}

// StaffDirectory adapts identity and access (SRS-QMS-006, SRS-QMS-013).
//
// Who works here belongs to identity and access, and the gap reports read it
// without owning it. A second copy would drift the first time somebody changed
// job, and the report that says "eleven nurses have not read the policy" would
// be counting people who left.
type StaffDirectory struct {
	directory identityports.Directory
}

// NewStaffDirectory constructs the adapter.
func NewStaffDirectory(directory identityports.Directory) StaffDirectory {
	return StaffDirectory{directory: directory}
}

var _ ports.Staff = StaffDirectory{}

// staffPageSize bounds one establishment read. A hospital with more staff in
// one role than this is a report somebody should narrow.
const staffPageSize = 5000

// RolesByPerson implements ports.Staff.
func (s StaffDirectory) RolesByPerson(ctx context.Context,
	scope authctx.TenantScope, roles []string) (map[string]string, error) {

	if s.directory == nil || len(roles) == 0 {
		return map[string]string{}, nil
	}
	return s.directory.AccountsByRoles(ctx, scope, roles, staffPageSize)
}
