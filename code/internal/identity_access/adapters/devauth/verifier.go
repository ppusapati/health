// Package devauth provides a non-production TokenVerifier.
//
// ADR-008 (enterprise identity provider) is still open and is marked as
// blocking, so Wave 0 deliberately does not hard-wire a vendor. This verifier
// satisfies the same transport.TokenVerifier seam the OIDC verifier will, which
// keeps every downstream layer — interceptor, policy engine, use cases —
// identical once the ADR closes.
//
// It refuses to start unless explicitly enabled, so it cannot be reached in a
// production build by configuration drift alone.
package devauth

import (
	"context"
	"errors"
	"strings"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ErrDisabled is returned when the verifier is constructed without an explicit
// opt-in.
var ErrDisabled = errors.New("devauth: development verifier is not enabled")

// Verifier turns a structured development token into a session.
//
// Token format: "<tenant_id>:<subject_id>:<role>[,<role>...][:<facility_id>[,...]]".
//
// The optional fourth segment is the facility claim. A token with no facility
// claim grants no facility scope, so a request that asserts one through
// X-Facility-Id is refused rather than honoured.
type Verifier struct{}

// New returns the verifier only when enabled is true.
func New(enabled bool) (*Verifier, error) {
	if !enabled {
		return nil, ErrDisabled
	}
	return &Verifier{}, nil
}

// Verify parses the token and resolves its permissions from the role
// catalogue. The caller cannot inject permissions directly: it names roles, and
// the catalogue decides what those mean.
func (v *Verifier) Verify(_ context.Context, token string) (authctx.Session, error) {
	parts := strings.Split(token, ":")
	if len(parts) != 3 && len(parts) != 4 {
		return authctx.Session{}, rpcerr.Unauthenticated("AUTH_TOKEN_MALFORMED", "invalid credentials")
	}

	tenantID := strings.TrimSpace(parts[0])
	subjectID := strings.TrimSpace(parts[1])
	if tenantID == "" || subjectID == "" {
		return authctx.Session{}, rpcerr.Unauthenticated("AUTH_TOKEN_MALFORMED", "invalid credentials")
	}

	var roles []domain.Role
	var roleNames []string
	for _, name := range strings.Split(parts[2], ",") {
		name = strings.TrimSpace(name)
		if name == "" {
			continue
		}
		role := domain.Role(name)
		// An unrecognised role is rejected rather than ignored: silently
		// dropping it would produce a session with fewer rights than the
		// operator believes they granted.
		if !domain.KnownRole(role) {
			return authctx.Session{}, rpcerr.Unauthenticated("AUTH_UNKNOWN_ROLE", "invalid credentials")
		}
		roles = append(roles, role)
		roleNames = append(roleNames, name)
	}
	if len(roles) == 0 {
		return authctx.Session{}, rpcerr.Unauthenticated("AUTH_NO_ROLES", "invalid credentials")
	}

	var facilities []string
	if len(parts) == 4 {
		for _, id := range strings.Split(parts[3], ",") {
			if id = strings.TrimSpace(id); id != "" {
				facilities = append(facilities, id)
			}
		}
	}

	// Purposes come from the role catalogue, never from the token. A token
	// that could name its own purpose-of-use would let a caller write
	// "treatment" into the regulated audit trail for a query they ran out of
	// curiosity.
	permittedPurposes := domain.PurposesFor(roles)

	return authctx.Session{
		SubjectID:   subjectID,
		TenantID:    tenantID,
		Roles:       roleNames,
		Permissions: domain.PermissionsFor(roles),
		// The default is the narrowest purpose the credential holds, and the
		// X-Purpose-Of-Use header narrows further. Defaulting to treatment
		// would put the strongest clinical justification on every request
		// nobody bothered to label.
		Purpose: defaultPurpose(permittedPurposes),

		PermittedFacilities: facilities,
		PermittedPurposes:   permittedPurposes,
	}, nil
}

// defaultPurpose picks the purpose a request carries when it states none.
//
// Operations where the credential holds it, because an unlabelled request is
// administrative until somebody says otherwise. A credential that cannot assert
// operations — a clinician — falls back to its first permitted purpose, which
// PurposesFor returns in a stable order.
func defaultPurpose(permitted []authctx.PurposeOfUse) authctx.PurposeOfUse {
	for _, p := range permitted {
		if p == authctx.PurposeOperations {
			return authctx.PurposeOperations
		}
	}
	if len(permitted) > 0 {
		return permitted[0]
	}
	return authctx.PurposeUnspecified
}
