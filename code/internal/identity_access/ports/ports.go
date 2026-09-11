// Package ports declares the interfaces the identity & access context needs.
package ports

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
)

// FederationStore resolves which tenant an external issuer belongs to.
//
// This is the multi-tenant OIDC problem in one method. One deployment serves
// many hospitals, each with its own identity provider, so a token cannot be
// verified until its issuer has been matched to a federation — and the match
// decides both the tenant and the trust anchor. Looking it up by issuer rather
// than by a tenant hint in the request is what stops a caller choosing which
// tenant to be verified against.
type FederationStore interface {
	// ByIssuer returns the federation for an issuer. Not found is an error,
	// never a default: a token from an unknown issuer is untrusted, and any
	// fallback here would be a way in.
	ByIssuer(ctx context.Context, issuer string) (domain.Federation, error)
}

// AccountStore holds the local record of a federated user.
//
// A federated account carries no credential; what it carries is everything the
// external provider does not know about — which roles this tenant granted,
// which facilities, and the revocation watermark that lets an administrator
// end a session before its token expires (SRS-IAM-006).
type AccountStore interface {
	// BySubject returns the account for an external subject within a tenant.
	BySubject(ctx context.Context, tenantID, subjectID string) (domain.Account, error)
	// Upsert records an account resolved from a federated sign-in, returning
	// the stored version. First sign-in creates it; later ones refresh the
	// roles the provider now asserts without disturbing the revocation
	// watermark.
	Upsert(ctx context.Context, a domain.Account) (domain.Account, error)
	// RevocationWatermark returns the instant before which this subject's
	// credentials are void. Separated from BySubject because it is read on
	// every request and the rest of the account is not, so an implementation
	// can cache this alone.
	RevocationWatermark(ctx context.Context, tenantID, subjectID string) (time.Time, error)
}

// StepUpStore holds proofs of second-factor authentication (SRS-IAM-012).
type StepUpStore interface {
	// Record stores a completed step-up.
	Record(ctx context.Context, p domain.StepUpProof) error
	// Latest returns the most recent proof a subject obtained for an action,
	// or false when there is none. Scoped to the action because a proof for
	// one action must not authorise another.
	Latest(ctx context.Context, tenantID, subjectID, action string) (domain.StepUpProof, bool, error)
}

// RiskStore records sign-in risk assessments and raises alerts (SRS-IAM-015).
type RiskStore interface {
	RecordAssessment(ctx context.Context, tenantID, subjectID string, a domain.RiskAssessment, at time.Time) error
	RaiseAlert(ctx context.Context, alert domain.Alert) error
}

// Clock supplies the current time.
type Clock interface{ Now() time.Time }
