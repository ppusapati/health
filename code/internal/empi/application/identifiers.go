package application

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Identifier lifecycle (SRS-EMPI-011).
//
// Linking an external identifier is not the same act as registering a patient,
// and separating them is what SRS-EMPI-011 means by "without making them
// database primary keys": a patient exists before the link and survives the
// unlink, and both directions are rows rather than edits.

const (
	// EventPatientIdentifierLinked is emitted when an identifier is attached.
	EventPatientIdentifierLinked = "patient.identifier_linked"
	// EventPatientIdentifierUnlinked is emitted when one is retired, whichever
	// way it left.
	EventPatientIdentifierUnlinked = "patient.identifier_unlinked"
)

// LinkIdentifierInput attaches an external identifier to a patient.
type LinkIdentifierInput struct {
	PatientID          string
	Type               domain.IdentifierType
	System             string
	Value              string
	AssigningAuthority string
	// Source is where this system learned the value — a registration desk, an
	// ABDM callback, a payer file. Required: SRS-EMPI-011 retains source, and a
	// link with no source cannot be unwound with confidence about what claimed
	// it.
	Source string
	// Verify asks the issuing authority to confirm the value before linking,
	// when a registry is configured for the system.
	Verify bool
	// RequireVerification refuses the link unless the authority confirms it.
	//
	// Separate from Verify because the two failures are different: a desk that
	// wants confirmation but will accept an asserted value during a registry
	// outage sets Verify alone, and one that must not record an unconfirmed
	// national identifier sets both.
	RequireVerification bool
}

// LinkIdentifierResult reports the link and what the authority said.
type LinkIdentifierResult struct {
	Identifier domain.Identifier
	// VerificationAttempted is false when no registry is configured for the
	// system, which is different from one that was asked and declined.
	VerificationAttempted bool
	// RegistryUnavailable reports that the authority could not be reached. The
	// identifier is linked as asserted; the caller decides what to do about it.
	RegistryUnavailable bool
	// VerificationReason carries a negative answer's explanation.
	VerificationReason string
	// AuthorityDemographics is what the issuing authority holds, when it
	// returned any and it differs from the record. Never applied here: a
	// difference is a conflict for reconciliation (SRS-EMPI-012), and
	// overwriting trusted data with a feed is the failure that requirement
	// exists to prevent.
	AuthorityDemographics    domain.Demographics
	HasAuthorityDemographics bool
}

// LinkIdentifier attaches an external identifier to an existing patient.
func (s *Service) LinkIdentifier(ctx context.Context, in LinkIdentifierInput) (LinkIdentifierResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return LinkIdentifierResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient_identifier", in.PatientID, decision.Reason)
		return LinkIdentifierResult{}, rpcerr.PermissionDenied("EMPI_LINK_DENIED", decision.Reason)
	}

	if in.Type == domain.IdentifierMRN {
		// The MRN is this system's own number, issued from the facility's
		// sequence. Accepting one from a caller would let a client choose a
		// value the sequence has not reached, and the next issue would collide
		// (SRS-EMPI-016).
		return LinkIdentifierResult{}, rpcerr.Invalid("EMPI_MRN_NOT_LINKABLE",
			"an MRN is issued by this system and cannot be linked from outside")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	// Verification happens before the transaction. It is a network call to
	// another organisation, and holding a database transaction open across one
	// makes a slow authority into database contention.
	verification, outcome, err := s.verifyIdentifier(ctx, in)
	if err != nil {
		return LinkIdentifierResult{}, err
	}

	var result LinkIdentifierResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if patient.Status == domain.StatusMerged {
			// Linking to the losing side of a merge puts the identifier on the
			// record nothing reads.
			return rpcerr.FailedPrecondition("EMPI_PATIENT_MERGED",
				"this record was merged; link the identifier to the surviving patient")
		}

		identifier, err := domain.NewIdentifier(s.ids.NewID(), patient.ID(), in.Type,
			in.System, in.Value, in.AssigningAuthority, in.Source, now)
		if err != nil {
			return registrationError(err)
		}
		if verification.Verified {
			if err := identifier.Verify(verification, now); err != nil {
				return registrationError(err)
			}
		}

		if err := s.identifiers.Link(ctx, scope, identifier); err != nil {
			var conflict domain.ErrIdentifierConflict
			if errors.As(err, &conflict) {
				// Deliberately does not name the holding patient. The caller
				// asked about a value, not about that patient, and confirming
				// who holds a national identifier to anybody who can guess one
				// is a disclosure.
				return rpcerr.AlreadyExists("EMPI_IDENTIFIER_IN_USE",
					"that identifier is already linked to another patient")
			}
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id":    patient.ID(),
			"identifier_id": identifier.ID,
			// The type and system are configuration, not patient data: knowing
			// an ABHA was linked is what a projection needs, and the number
			// itself is not (SRS-API-009).
			"identifier_type": string(identifier.Type),
			"assurance":       string(identifier.Assurance),
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientIdentifierLinked,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		result = LinkIdentifierResult{
			Identifier:               identifier,
			VerificationAttempted:    outcome.attempted,
			RegistryUnavailable:      outcome.unavailable,
			VerificationReason:       verification.Reason,
			AuthorityDemographics:    verification.Demographics,
			HasAuthorityDemographics: verification.HasDemographics,
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient_identifier", ResourceID: identifier.ID,
			Outcome: audit.OutcomeSuccess,
			// The identifier type and its assurance, never the value: an audit
			// trail that stores identifier values becomes a second index of
			// them, outside every access rule that protects the first.
			Reason: "linked " + string(in.Type) + " (" + string(identifier.Assurance) + ")",
		}, now)
	})
	if err != nil {
		return LinkIdentifierResult{}, mapConflict(err)
	}
	return result, nil
}

// verificationOutcome distinguishes "not configured" from "could not ask".
type verificationOutcome struct {
	attempted   bool
	unavailable bool
}

// verifyIdentifier asks the issuing authority, when one is configured.
func (s *Service) verifyIdentifier(ctx context.Context, in LinkIdentifierInput) (
	domain.Verification, verificationOutcome, error) {

	if !in.Verify && !in.RequireVerification {
		return domain.Verification{}, verificationOutcome{}, nil
	}
	if s.registries == nil {
		return domain.Verification{}, verificationOutcome{}, s.unverifiable(in,
			"no identifier registry is configured in this deployment")
	}
	registry, ok := s.registries.For(strings.TrimSpace(in.System))
	if !ok {
		return domain.Verification{}, verificationOutcome{}, s.unverifiable(in,
			"no registry is configured for identifier system "+in.System)
	}

	verification, err := registry.Verify(ctx, in.Value)
	var unavailable domain.ErrRegistryUnavailable
	if errors.As(err, &unavailable) {
		// An outage is not a refusal. A registration desk cannot stop admitting
		// patients because a national service is down, so unless the caller
		// insisted, the identifier links as asserted and says so.
		if in.RequireVerification {
			return domain.Verification{}, verificationOutcome{attempted: true, unavailable: true},
				rpcerr.FailedPrecondition("EMPI_REGISTRY_UNAVAILABLE",
					"the issuing authority could not be reached, and this link requires verification")
		}
		return domain.Verification{}, verificationOutcome{attempted: true, unavailable: true}, nil
	}
	if err != nil {
		return domain.Verification{}, verificationOutcome{attempted: true},
			rpcerr.Internal("EMPI_REGISTRY_FAILED", "the identifier registry failed").WithCause(err)
	}

	if !verification.Verified && in.RequireVerification {
		return verification, verificationOutcome{attempted: true},
			rpcerr.Invalid("EMPI_IDENTIFIER_NOT_VERIFIED",
				"the issuing authority did not confirm this identifier: "+verification.Reason)
	}
	return verification, verificationOutcome{attempted: true}, nil
}

// unverifiable answers a verification request no registry can serve.
func (s *Service) unverifiable(in LinkIdentifierInput, why string) error {
	if !in.RequireVerification {
		// Asked for verification, none available, and willing to proceed: the
		// identifier links as asserted and the result says it was not checked.
		return nil
	}
	return rpcerr.FailedPrecondition("EMPI_REGISTRY_NOT_CONFIGURED", why)
}

// UnlinkIdentifierInput retires an identifier.
type UnlinkIdentifierInput struct {
	IdentifierID string
	// Revoke says the identifier should never have pointed at this patient, as
	// opposed to having been correct and replaced.
	//
	// The difference decides whether a search on the value still resolves here,
	// so it is the caller's explicit choice rather than something inferred.
	Revoke bool
	Reason string
}

// UnlinkIdentifier retires an identifier, keeping the row (SRS-EMPI-011).
func (s *Service) UnlinkIdentifier(ctx context.Context, in UnlinkIdentifierInput) (domain.Identifier, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Identifier{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient_identifier", in.IdentifierID, decision.Reason)
		return domain.Identifier{}, rpcerr.PermissionDenied("EMPI_UNLINK_DENIED", decision.Reason)
	}

	if strings.TrimSpace(in.Reason) == "" {
		return domain.Identifier{}, rpcerr.Invalid("EMPI_UNLINK_REASON_REQUIRED",
			"unlinking an identifier needs a reason")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var retired domain.Identifier
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		identifier, err := s.identifiers.Get(ctx, scope, in.IdentifierID)
		if err != nil {
			return err
		}
		if identifier.Type == domain.IdentifierMRN {
			// An MRN leaves active use through a merge or a correction, both of
			// which supersede it in favour of a replacement. Unlinking one
			// directly would leave a patient with no number to print.
			return rpcerr.Invalid("EMPI_MRN_NOT_UNLINKABLE",
				"an MRN is retired by a merge or a correction, not by unlinking")
		}

		if in.Revoke {
			err = identifier.Revoke(in.Reason, now)
		} else {
			err = identifier.Supersede("", in.Reason, now)
		}
		if err != nil {
			return registrationError(err)
		}

		if err := s.identifiers.Retire(ctx, scope, identifier); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id":      identifier.PatientID,
			"identifier_id":   identifier.ID,
			"identifier_type": string(identifier.Type),
			"status":          string(identifier.Status),
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientIdentifierUnlinked,
			"patient", identifier.PatientID, payload, now); err != nil {
			return err
		}

		retired = identifier
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient_identifier", ResourceID: identifier.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(identifier.Status) + ": " + in.Reason,
		}, now)
	})
	if err != nil {
		return domain.Identifier{}, mapConflict(err)
	}
	return retired, nil
}

// VerifyIdentifierInput confirms an already-linked identifier.
type VerifyIdentifierInput struct{ IdentifierID string }

// VerifyIdentifier asks the issuing authority about an identifier that was
// linked as asserted.
//
// Separate from linking because the registry being down at the desk is exactly
// when this is needed: the identifier is on file, unverified, and somebody has
// to be able to come back to it.
func (s *Service) VerifyIdentifier(ctx context.Context, in VerifyIdentifierInput) (
	LinkIdentifierResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return LinkIdentifierResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient_identifier", in.IdentifierID, decision.Reason)
		return LinkIdentifierResult{}, rpcerr.PermissionDenied("EMPI_VERIFY_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	// Read outside the transaction: the registry call follows, and the write is
	// guarded on status = 'active' so a concurrent unlink is refused rather
	// than silently overwritten.
	identifier, err := s.identifiers.Get(ctx, scope, in.IdentifierID)
	if err != nil {
		return LinkIdentifierResult{}, err
	}

	verification, outcome, err := s.verifyIdentifier(ctx, LinkIdentifierInput{
		System: identifier.System, Value: identifier.Value,
		Verify: true, RequireVerification: true,
	})
	if err != nil {
		return LinkIdentifierResult{}, err
	}
	if err := identifier.Verify(verification, now); err != nil {
		return LinkIdentifierResult{}, registrationError(err)
	}

	var result LinkIdentifierResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.identifiers.RecordVerification(ctx, scope, identifier); err != nil {
			return err
		}
		result = LinkIdentifierResult{
			Identifier:               identifier,
			VerificationAttempted:    outcome.attempted,
			AuthorityDemographics:    verification.Demographics,
			HasAuthorityDemographics: verification.HasDemographics,
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient_identifier", ResourceID: identifier.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "verified by " + identifier.AssigningAuthority,
		}, now)
	})
	if err != nil {
		return LinkIdentifierResult{}, mapConflict(err)
	}
	return result, nil
}
