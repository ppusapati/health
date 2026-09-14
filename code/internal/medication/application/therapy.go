package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ChangeInput is what holding, restarting or discontinuing needs
// (SRS-MED-013).
type ChangeInput struct {
	PrescriptionID string
	// Reason is mandatory. A drug that stopped for no recorded reason is one
	// nobody can decide whether to restart, and the person who knows has gone
	// off shift.
	Reason string
	// EffectiveAt is when the change takes effect clinically, which is not
	// always when it was typed: a drug stopped on the ward round at 09:00 and
	// recorded at 11:00 stopped at 09:00. Zero means now.
	EffectiveAt time.Time
}

// Hold suspends a therapy (SRS-MED-013).
func (s *Service) Hold(ctx context.Context, in ChangeInput) (
	*domain.Prescription, error) {

	return s.changeTherapy(ctx, in, domain.TherapyHeld, EventHeld,
		func(p *domain.Prescription, by string, effectiveAt, now time.Time) error {
			return p.Hold(by, in.Reason, effectiveAt, now)
		})
}

// Restart resumes a held therapy (SRS-MED-013).
func (s *Service) Restart(ctx context.Context, in ChangeInput) (
	*domain.Prescription, error) {

	return s.changeTherapy(ctx, in, domain.TherapyActive, EventRestarted,
		func(p *domain.Prescription, by string, effectiveAt, now time.Time) error {
			return p.Restart(by, in.Reason, effectiveAt, now)
		})
}

// Discontinue stops a therapy for good (SRS-MED-013).
//
// The supply request behind it is cancelled too, best-effort: a therapy that
// stopped while a pharmacy went on dispensing is how a discontinued drug ends up
// in a ward cupboard. Best-effort because an order the pharmacy has already
// started refuses, and the therapy must stop regardless — the patient not
// getting the drug is the part that matters, and the supply request catches up
// through SRS-ORD-004's own corrective workflow.
func (s *Service) Discontinue(ctx context.Context, in ChangeInput) (
	*domain.Prescription, error) {

	p, err := s.changeTherapy(ctx, in, domain.TherapyDiscontinued, EventDiscontinued,
		func(p *domain.Prescription, by string, effectiveAt, now time.Time) error {
			return p.Discontinue(by, in.Reason, effectiveAt, now)
		})
	if err != nil {
		return nil, err
	}

	if s.orders != nil && p.OrderID != "" {
		_, scope, authErr := s.authorize(ctx, PermPrescriptionChange, "prescription",
			p.ID, true)
		if authErr == nil {
			// Deliberately unexamined. The cancellation is a courtesy to the
			// pharmacy, and a refusal from the order context means the supply
			// request has already been acted on — which SRS-ORD-004 handles as
			// a corrective workflow rather than as this call's failure.
			_ = s.orders.Cancel(ctx, scope, p.OrderID, in.Reason)
		}
	}
	return p, nil
}

// changeTherapy is the shared path every therapy change takes.
//
// One path, so the ledger entry, the version guard, the event and the audit
// record cannot be forgotten on one of the three and remembered on the other
// two. The transition itself is the caller's, because the domain's rules about
// which change may follow which are the domain's.
func (s *Service) changeTherapy(ctx context.Context, in ChangeInput,
	to domain.TherapyStatus, eventType string,
	apply func(*domain.Prescription, string, time.Time, time.Time) error) (
	*domain.Prescription, error) {

	session, scope, err := s.authorize(ctx, PermPrescriptionChange, "prescription",
		in.PrescriptionID, true)
	if err != nil {
		return nil, err
	}

	p, err := s.prescriptions.Get(ctx, scope, in.PrescriptionID)
	if err != nil {
		return nil, err
	}

	expectedVersion, expectedStatus := p.Version, p.Status
	now := s.clock.Now()
	effectiveAt := in.EffectiveAt
	if effectiveAt.IsZero() {
		effectiveAt = now
	}

	if err := apply(p, session.SubjectID, effectiveAt, now); err != nil {
		return nil, medicationError(err)
	}
	if p.Status != to {
		// The domain treats a repeat as a no-op, so the status is already what
		// was asked for and there is nothing to write. Returning the
		// prescription unchanged keeps a retried request idempotent rather than
		// appending a second ledger entry.
		return p, nil
	}

	change := p.Changes[len(p.Changes)-1]
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.prescriptions.ChangeTherapy(ctx, scope, p, change,
			expectedVersion, expectedStatus); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, eventType, p.ID,
			therapyEventPayload(p, change), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.prescription.change", ResourceType: "prescription",
			ResourceID: p.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(change.From) + " -> " + string(change.To),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return p, nil
}

// therapyEventPayload carries the change and the identifiers, and not the
// reason.
//
// The reason a drug was stopped is clinical — "rash", "for endoscopy",
// "bleeding" — and belongs on the record rather than on a bus that more systems
// read under fewer controls (SRS-API-009). What a consumer rebuilding the
// timeline needs is the transition and when it took effect, and both are here.
func therapyEventPayload(p *domain.Prescription, c domain.TherapyChange) map[string]any {
	payload := prescriptionEventPayload(p)
	payload["from_status"] = string(c.From)
	payload["to_status"] = string(c.To)
	payload["effective_at"] = c.EffectiveAt.UTC().Format(time.RFC3339)
	return payload
}

// Verify records a pharmacist's check (SRS-MED-006).
func (s *Service) Verify(ctx context.Context, prescriptionID, note string) (
	*domain.Prescription, error) {

	session, scope, err := s.authorize(ctx, PermVerify, "prescription",
		prescriptionID, true)
	if err != nil {
		return nil, err
	}

	p, err := s.prescriptions.Get(ctx, scope, prescriptionID)
	if err != nil {
		return nil, err
	}
	if p.Verification.Done() {
		// Already checked. Idempotent rather than an error: a retried request
		// must not move the timestamp, which is evidence about when the check
		// happened.
		return p, nil
	}

	expectedVersion := p.Version
	now := s.clock.Now()
	if err := p.Verify(session.SubjectID, note, now); err != nil {
		return nil, medicationError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.prescriptions.Verify(ctx, scope, p, expectedVersion); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventVerified, p.ID,
			prescriptionEventPayload(p), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.prescription.verify", ResourceType: "prescription",
			ResourceID: p.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return p, nil
}

// VerificationQueue is the pharmacy worklist (SRS-MED-006).
func (s *Service) VerificationQueue(ctx context.Context, facilityID string,
	limit int32) ([]*domain.Prescription, error) {

	_, scope, err := s.authorize(ctx, PermVerify, "prescription", facilityID, false)
	if err != nil {
		return nil, err
	}
	return s.prescriptions.AwaitingVerification(ctx, scope, facilityID,
		clampPageSize(limit))
}

// CheckPRN answers whether an as-needed dose may be given now (SRS-MED-008).
//
// given is the times of the doses already administered, supplied by the caller
// rather than read here: the administration record belongs to the nursing
// context, and this is the rule rather than the ledger. The eMAR asks this
// question at the bedside, which is the only moment at which the answer is
// worth anything.
func (s *Service) CheckPRN(ctx context.Context, prescriptionID string,
	given []time.Time, at time.Time) error {

	_, scope, err := s.authorize(ctx, PermPrescriptionRead, "prescription",
		prescriptionID, false)
	if err != nil {
		return err
	}

	p, err := s.prescriptions.Get(ctx, scope, prescriptionID)
	if err != nil {
		return err
	}
	if !p.PRNScheduled() {
		return rpcerr.Invalid("MED_NOT_AS_NEEDED",
			"that prescription is scheduled rather than as-needed")
	}
	if !p.Administrable(at, s.verificationRequired(ctx, scope, p)) {
		return rpcerr.FailedPrecondition("MED_NOT_ADMINISTRABLE",
			"that prescription is not administrable at that time")
	}

	dose := domain.Quantity{}
	if len(p.Segments) > 0 {
		dose = p.Segments[0].Dose
	}
	if err := p.PRN.CheckPRN(given, dose, at); err != nil {
		return medicationError(err)
	}
	return nil
}

// verificationRequired reports whether this tenant gates this medication behind
// a pharmacist.
//
// Errors resolve to "required", which is the safe direction: a policy lookup
// that failed must not be the reason an unverified drug becomes giveable.
func (s *Service) verificationRequired(ctx context.Context, scope authctx.TenantScope,
	p *domain.Prescription) bool {

	policySet, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return true
	}
	profile, err := s.profileOf(ctx, scope, p)
	if err != nil {
		return true
	}
	return policySet.Verification.RequiresVerification(profile)
}
