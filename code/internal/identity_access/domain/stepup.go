package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Step-up authentication (SRS-IAM-012).
//
// The verification clause is "high-risk action fails without step-up proof",
// which puts the decision at the action rather than at the session. A session
// that was step-upped an hour ago is not a session that may delete a tenant
// now; the whole point is a deliberate re-authentication next to the
// consequential act.
//
// So a proof is bound to three things and checked against all three: the
// subject who performed it, the action it was performed for, and a short
// window. Binding to the action is what stops the pattern this control exists
// to prevent — a user stepping up for something innocuous and the application
// treating the session as elevated for everything afterwards.

// RiskLevel classifies how consequential an action is.
type RiskLevel string

const (
	// RiskNormal needs no step-up.
	RiskNormal RiskLevel = "normal"
	// RiskElevated needs a step-up proof.
	RiskElevated RiskLevel = "elevated"
	// RiskDestructive needs a step-up proof and is irreversible, so the proof
	// window is shorter.
	RiskDestructive RiskLevel = "destructive"
)

// Step-up proof lifetimes.
//
// Five minutes is long enough to complete a form after authenticating and
// short enough that a proof cannot be parked and reused later in the session.
// A destructive action gets a minute: there is no legitimate flow in which
// somebody authenticates, does other work, and then deletes a tenant.
const (
	ElevatedProofTTL    = 5 * time.Minute
	DestructiveProofTTL = time.Minute
)

// highRiskActions is the register of actions requiring step-up.
//
// Explicit rather than derived from a naming convention: a convention would
// silently stop covering an action somebody named differently, and the failure
// is invisible — the action simply stops requiring a step-up and nobody
// notices until it is used.
var highRiskActions = map[string]RiskLevel{
	// Bulk PHI leaving the system.
	"security.export.request":  RiskElevated,
	"security.export.approve":  RiskElevated,
	"security.export.download": RiskElevated,

	// Security posture changes.
	"security.policy.update":      RiskElevated,
	"security.emergency.review":   RiskElevated,
	"identity.account.deactivate": RiskElevated,
	"identity.role.grant":         RiskElevated,

	// Irreversible.
	"organization.tenant.delete":  RiskDestructive,
	"security.legal_hold.release": RiskDestructive,
	"data.retention.purge":        RiskDestructive,
}

// Errors returned by step-up checking.
var (
	// ErrStepUpRequired reports a high-risk action attempted without a proof.
	ErrStepUpRequired = errors.New("identity: step-up authentication required")
	// ErrStepUpInvalid reports a proof that does not cover this attempt.
	ErrStepUpInvalid = errors.New("identity: step-up proof does not authorize this action")
)

// StepUpProof records a completed second-factor authentication.
type StepUpProof struct {
	// Reference is what the verifier issued. It is recorded against the action
	// in the audit trail, which is what makes the step-up checkable after the
	// fact rather than merely enforced at the time.
	Reference string
	SubjectID string
	// Action the proof was obtained for. A proof for one action does not
	// authorise another.
	Action string
	// Method records what the user actually did — "totp", "webauthn",
	// "push" — because the strength of the control depends on it and an
	// incident review needs to know.
	Method     string
	ObtainedAt time.Time
}

// RiskOf reports an action's risk level.
func RiskOf(action string) RiskLevel {
	if level, found := highRiskActions[action]; found {
		return level
	}
	return RiskNormal
}

// RequiresStepUp reports whether an action needs a proof.
func RequiresStepUp(action string) bool { return RiskOf(action) != RiskNormal }

// ProofTTL is how long a proof for an action stays good.
func ProofTTL(action string) time.Duration {
	if RiskOf(action) == RiskDestructive {
		return DestructiveProofTTL
	}
	return ElevatedProofTTL
}

// AuthorizeStepUp decides whether an action may proceed.
//
// proof may be nil, which is the ordinary case for a normal-risk action. For a
// high-risk one it is the whole control, and every part of the binding is
// checked: a proof for another subject, for another action, or past its window
// authorises nothing.
func AuthorizeStepUp(action, subjectID string, proof *StepUpProof, now time.Time) error {
	if !RequiresStepUp(action) {
		return nil
	}
	if proof == nil {
		return fmt.Errorf("%w: %s", ErrStepUpRequired, action)
	}

	switch {
	case strings.TrimSpace(proof.Reference) == "":
		return fmt.Errorf("%w: the proof has no reference to record against the action", ErrStepUpInvalid)
	case proof.SubjectID != subjectID:
		// Somebody else's proof. Worth its own check rather than relying on
		// the caller to pass the right one: a proof passed by id from a
		// request field would otherwise let a caller borrow one.
		return fmt.Errorf("%w: the proof belongs to another subject", ErrStepUpInvalid)
	case proof.Action != action:
		// The pattern this control exists to prevent: stepping up for
		// something innocuous and treating the session as elevated afterwards.
		return fmt.Errorf("%w: the proof was obtained for %q, not %q",
			ErrStepUpInvalid, proof.Action, action)
	case strings.TrimSpace(proof.Method) == "":
		return fmt.Errorf("%w: the proof does not record how the user authenticated", ErrStepUpInvalid)
	case proof.ObtainedAt.IsZero():
		return fmt.Errorf("%w: the proof has no obtained-at time, so its age cannot be checked", ErrStepUpInvalid)
	}

	age := now.UTC().Sub(proof.ObtainedAt.UTC())
	if age < 0 {
		// A proof from the future is a clock problem or a forged timestamp.
		// Either way it cannot be aged, so it cannot be trusted.
		return fmt.Errorf("%w: the proof is dated in the future", ErrStepUpInvalid)
	}
	if ttl := ProofTTL(action); age > ttl {
		return fmt.Errorf("%w: the proof is %v old, past the %v window for %s",
			ErrStepUpInvalid, age.Round(time.Second), ttl, RiskOf(action))
	}
	return nil
}

// HighRiskActions lists the register, for a UI that wants to warn before the
// user starts rather than after they have filled in a form.
func HighRiskActions() map[string]RiskLevel {
	out := make(map[string]RiskLevel, len(highRiskActions))
	for action, level := range highRiskActions {
		out[action] = level
	}
	return out
}
