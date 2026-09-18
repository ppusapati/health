package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RegisterDonor registers a donor (SRS-BLD-001).
func (s *Service) RegisterDonor(ctx context.Context, in domain.NewDonorInput) (
	domain.Donor, error) {

	session, scope, err := s.authorize(ctx, PermDonor)
	if err != nil {
		return domain.Donor{}, err
	}
	now := s.clock.Now()

	if in.PatientID != "" {
		// A donor who is also a patient here: the autologous and
		// directed-donation cases. The link has to resolve, or the two records
		// are about different people.
		if err := s.knownPatient(ctx, scope, in.PatientID); err != nil {
			return domain.Donor{}, err
		}
	}

	donor, err := domain.NewDonor(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Donor{}, bloodbankError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.donors.InsertDonor(ctx, scope, donor); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDonor,
			ResourceType: "bloodbank_donor", ResourceID: donor.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "donor registered",
		}, now)
	})
	if err != nil {
		return domain.Donor{}, err
	}
	return donor, nil
}

// Donor reads one donor.
func (s *Service) Donor(ctx context.Context, donorID string) (domain.Donor, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Donor{}, err
	}
	return s.donors.Donor(ctx, scope, donorID)
}

// DeferDonor stops a donor giving (SRS-BLD-002).
func (s *Service) DeferDonor(ctx context.Context, donorID string,
	kind domain.DeferralKind, code, note string, until time.Time) (
	domain.Donor, error) {

	session, scope, err := s.authorize(ctx, PermDefer)
	if err != nil {
		return domain.Donor{}, err
	}
	now := s.clock.Now()

	var out domain.Donor
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		donor, err := s.donors.Donor(ctx, scope, donorID)
		if err != nil {
			return err
		}
		if err := donor.Defer(kind, code, note, until,
			session.SubjectID, now); err != nil {
			return bloodbankError(err)
		}
		if err := s.donors.UpdateDeferral(
			ctx, scope, donor, donor.Version); err != nil {
			return bloodbankError(err)
		}
		out = donor

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDefer,
			ResourceType: "bloodbank_donor", ResourceID: donor.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(kind) + " deferral: " + code,
		}, now)
	})
	if err != nil {
		return domain.Donor{}, err
	}
	return out, nil
}

// ReinstateDonor lifts a temporary deferral (SRS-BLD-002).
//
// The requirement's clause is "unless policy-authorized correction", and this
// is that correction — deliberately narrow: a permanent deferral is not lifted
// here. Reversing one is a medical decision about somebody who was told they
// could never give again, and a screen that let a receptionist do it would be
// used.
func (s *Service) ReinstateDonor(ctx context.Context, donorID, reason string) (
	domain.Donor, error) {

	session, scope, err := s.authorize(ctx, PermDefer)
	if err != nil {
		return domain.Donor{}, err
	}
	now := s.clock.Now()

	var out domain.Donor
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		donor, err := s.donors.Donor(ctx, scope, donorID)
		if err != nil {
			return err
		}
		if err := donor.Reinstate(reason, session.SubjectID, now); err != nil {
			return bloodbankError(err)
		}
		if err := s.donors.UpdateDeferral(
			ctx, scope, donor, donor.Version); err != nil {
			return bloodbankError(err)
		}
		out = donor

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDefer,
			ResourceType: "bloodbank_donor", ResourceID: donor.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "deferral lifted: " + reason,
		}, now)
	})
	if err != nil {
		return domain.Donor{}, err
	}
	return out, nil
}

// DeferredDonors is the list a screening desk reads (SRS-BLD-002).
func (s *Service) DeferredDonors(ctx context.Context, limit int32) (
	[]domain.Donor, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.donors.Deferred(ctx, scope, s.clock.Now(), clampPageSize(limit))
}

// ScreenDonor records a donor screening (SRS-BLD-002).
func (s *Service) ScreenDonor(ctx context.Context, in domain.NewScreeningInput) (
	domain.Screening, error) {

	session, scope, err := s.authorize(ctx, PermDonor)
	if err != nil {
		return domain.Screening{}, err
	}
	now := s.clock.Now()

	var out domain.Screening
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		donor, err := s.donors.Donor(ctx, scope, in.DonorID)
		if err != nil {
			return err
		}

		screening, err := domain.Screen(
			s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.donors.InsertScreening(ctx, scope, screening); err != nil {
			return err
		}
		out = screening

		// A screening that deferred somebody applies the deferral to the
		// donor. Two records of one decision would diverge the first time
		// anybody read the donor rather than the screening.
		if screening.Deferral != domain.DeferralNone {
			until := time.Time{}
			if screening.Deferral == domain.DeferralTemporary {
				// A screening that defers temporarily without saying for how
				// long is caught here rather than producing a donor record
				// that says "deferred until the epoch".
				return rpcerr.Invalid("BLD_INVALID",
					"a temporary deferral from a screening needs an end date; "+
						"defer the donor directly")
			}
			if err := donor.Defer(screening.Deferral, screening.DeferralCode,
				"deferred at screening", until, session.SubjectID, now); err != nil {
				return bloodbankError(err)
			}
			if err := s.donors.UpdateDeferral(
				ctx, scope, donor, donor.Version); err != nil {
				return bloodbankError(err)
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDonor,
			ResourceType: "bloodbank_screening", ResourceID: screening.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  screeningReason(screening),
		}, now)
	})
	if err != nil {
		return domain.Screening{}, err
	}
	return out, nil
}

func screeningReason(s domain.Screening) string {
	if s.Accepted {
		return "donor accepted"
	}
	if s.Deferral != domain.DeferralNone {
		return "donor deferred: " + s.DeferralCode
	}
	return "donor not accepted"
}

// Collect records a donation (SRS-BLD-003).
//
// The deferral check lives in the domain and is given both the donor and the
// screening, so a deferred donor cannot donate however the call is made.
func (s *Service) Collect(ctx context.Context, in domain.NewCollectionInput,
	donorID, screeningID string) (domain.Collection, error) {

	session, scope, err := s.authorize(ctx, PermDonor)
	if err != nil {
		return domain.Collection{}, err
	}
	now := s.clock.Now()

	var out domain.Collection
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		donor, err := s.donors.Donor(ctx, scope, donorID)
		if err != nil {
			return err
		}
		screening, err := s.donors.Screening(ctx, scope, screeningID)
		if err != nil {
			return err
		}

		collection, err := domain.Collect(s.ids.NewID(), session.TenantID, in,
			donor, screening, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.donors.InsertCollection(ctx, scope, collection); err != nil {
			return err
		}
		out = collection

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermDonor,
			ResourceType: "bloodbank_collection", ResourceID: collection.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "donation " + collection.DonationNumber,
		}, now)
	})
	if err != nil {
		return domain.Collection{}, err
	}
	return out, nil
}

// RecordTest records one mandatory test result (SRS-BLD-004).
//
// A reactive result arriving late quarantines every component already made
// from the collection. The alternative — leaving them available until somebody
// notices — is how an infected unit reaches a patient.
func (s *Service) RecordTest(ctx context.Context, collectionID, code, display,
	value, method string, reactive bool) (domain.TestResult, error) {

	session, scope, err := s.authorize(ctx, PermTest)
	if err != nil {
		return domain.TestResult{}, err
	}
	now := s.clock.Now()

	result := domain.TestResult{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		CollectionID: collectionID,
		Code:         code, Display: display, Reactive: reactive,
		Value: value, Method: method,
		TestedAt: now.UTC(), TestedBy: session.SubjectID,
	}
	if code == "" {
		return domain.TestResult{}, rpcerr.Invalid("BLD_INVALID",
			"a test result names the assay")
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.donors.Collection(ctx, scope, collectionID); err != nil {
			return err
		}
		if err := s.donors.InsertTestResult(ctx, scope, result); err != nil {
			return err
		}

		if reactive {
			if err := s.quarantineCollection(
				ctx, session, scope, collectionID, now); err != nil {
				return err
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTest,
			ResourceType: "bloodbank_collection", ResourceID: collectionID,
			Outcome: audit.OutcomeSuccess,
			Reason:  code + " recorded" + reactiveSuffix(reactive),
		}, now)
	})
	if err != nil {
		return domain.TestResult{}, err
	}
	return result, nil
}

func reactiveSuffix(reactive bool) string {
	if reactive {
		return " (reactive)"
	}
	return ""
}

// quarantineCollection pulls every component made from one donation back off
// the shelf.
func (s *Service) quarantineCollection(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope, collectionID string,
	now time.Time) error {

	components, err := s.inventory.ComponentsForCollection(
		ctx, scope, collectionID)
	if err != nil {
		return err
	}
	for _, component := range components {
		if component.Status == domain.UnitTransfused ||
			component.Status == domain.UnitDiscarded {
			// The blood is already in a patient, or already gone. Neither can
			// be un-issued, and saying otherwise would make the look-back
			// report wrong. The look-back is what reaches those patients.
			continue
		}
		if err := component.Quarantine(); err != nil {
			return bloodbankError(err)
		}
		if err := s.inventory.UpdateStatus(
			ctx, scope, component, component.Version); err != nil {
			return bloodbankError(err)
		}
	}
	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermTest,
		ResourceType: "bloodbank_collection", ResourceID: collectionID,
		Outcome: audit.OutcomeSuccess,
		Reason: "reactive result: " + itoa(len(components)) +
			" component(s) quarantined",
	}, now)
}

// ReleaseDecision reports whether a collection's components may leave
// quarantine (SRS-BLD-004).
func (s *Service) ReleaseDecision(ctx context.Context, collectionID string) (
	domain.ReleaseDecision, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ReleaseDecision{}, err
	}
	results, err := s.donors.TestResults(ctx, scope, collectionID)
	if err != nil {
		return domain.ReleaseDecision{}, err
	}
	return domain.EvaluateRelease(s.config.MandatoryTests, results), nil
}

// ReleaseComponents moves a collection's components out of quarantine
// (SRS-BLD-004).
//
// The decision is recomputed here rather than trusted from the caller: this is
// the single step that makes a unit givable, and a client that could assert
// "testing is complete" would be the control.
func (s *Service) ReleaseComponents(ctx context.Context, collectionID string) (
	[]domain.Component, error) {

	session, scope, err := s.authorize(ctx, PermRelease)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	var released []domain.Component
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		results, err := s.donors.TestResults(ctx, scope, collectionID)
		if err != nil {
			return err
		}
		decision := domain.EvaluateRelease(s.config.MandatoryTests, results)
		if !decision.Releasable {
			return rpcerr.FailedPrecondition("BLD_NOT_RELEASABLE",
				releaseRefusal(decision))
		}

		components, err := s.inventory.ComponentsForCollection(
			ctx, scope, collectionID)
		if err != nil {
			return err
		}
		for _, component := range components {
			if component.Status != domain.UnitQuarantined {
				continue
			}
			if err := component.Release(now); err != nil {
				return bloodbankError(err)
			}
			if err := s.inventory.UpdateStatus(
				ctx, scope, component, component.Version); err != nil {
				return bloodbankError(err)
			}
			released = append(released, component)

			if err := s.appendEvent(ctx, session, EventComponentReleased,
				"bloodbank_component", component.ID, map[string]any{
					"unit_number": component.UnitNumber,
					"class":       string(component.Class),
					"group":       component.Group.String(),
					"expires_at":  component.ExpiresAt,
				}, now); err != nil {
				return err
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRelease,
			ResourceType: "bloodbank_collection", ResourceID: collectionID,
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(len(released)) + " component(s) released",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return released, nil
}

func releaseRefusal(d domain.ReleaseDecision) string {
	switch {
	case len(d.Reactive) > 0:
		return "this donation has reactive results: " + join(d.Reactive)
	case len(d.Missing) > 0:
		return "mandatory testing is incomplete: " + join(d.Missing)
	default:
		return "this donation may not be released"
	}
}

func join(values []string) string {
	out := ""
	for i, value := range values {
		if i > 0 {
			out += ", "
		}
		out += value
	}
	return out
}
