package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Configuration a tenant's pharmacy committee maintains (SRS-MED-003,
// SRS-MED-004, SRS-MED-006, SRS-MED-010, SRS-MED-012).
//
// All behind one permission, held by neither prescribers nor pharmacists by
// default: deciding what the hospital's interaction table says is a governance
// act, and a prescriber who could edit the rule that is warning them has not
// been warned.

// SetFormularyEntry records a medication's position in one scope
// (SRS-MED-012).
func (s *Service) SetFormularyEntry(ctx context.Context, e domain.FormularyEntry) error {
	session, scope, err := s.authorize(ctx, PermConfigure, "formulary",
		e.Medication.Code, true)
	if err != nil {
		return err
	}
	if err := e.Validate(); err != nil {
		return medicationError(err)
	}

	now := s.clock.Now()
	e.TenantID = session.TenantID
	e.UpdatedBy = session.SubjectID
	e.UpdatedAt = now

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.UpsertFormularyEntry(ctx, scope, e); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.catalogue.configure", ResourceType: "formulary",
			ResourceID: e.Medication.System + "|" + e.Medication.Code,
			Outcome:    audit.OutcomeSuccess,
			Reason:     string(e.Scope) + " " + e.ScopeID + ": " + string(e.Status),
		}, now)
	})
}

// SetInteractionRule publishes an interaction rule version (SRS-MED-003).
//
// A version rather than an edit. A finding recorded last March names a version,
// and a rule changed in place is a finding nobody can explain — which is exactly
// the question asked when somebody wants to know why a warning did or did not
// fire.
func (s *Service) SetInteractionRule(ctx context.Context, r domain.InteractionRule,
	active bool) error {

	session, scope, err := s.authorize(ctx, PermConfigure, "interaction_rule", r.ID, true)
	if err != nil {
		return err
	}
	if err := r.Validate(); err != nil {
		return medicationError(err)
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.UpsertInteractionRule(ctx, scope, r, active,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.catalogue.configure", ResourceType: "interaction_rule",
			ResourceID: r.ID + "@" + r.Version, Outcome: audit.OutcomeSuccess,
			Reason: string(r.Severity),
		}, now)
	})
}

// InteractionRules lists the active rules.
func (s *Service) InteractionRules(ctx context.Context) ([]domain.InteractionRule, error) {
	_, scope, err := s.authorize(ctx, PermPrescriptionRead, "interaction_rule", "", false)
	if err != nil {
		return nil, err
	}
	return s.catalogue.InteractionRules(ctx, scope)
}

// SetDoseRule publishes a dose-support rule version (SRS-MED-004).
//
// Validation is recorded against the person who configured it, which is what
// SRS-MED-004's "configured and validated" is asking for: somebody is
// answerable for the advice a hospital gives its prescribers, and an
// unvalidated rule does not run at all.
func (s *Service) SetDoseRule(ctx context.Context, r domain.DoseRule, active bool) error {
	session, scope, err := s.authorize(ctx, PermConfigure, "dose_rule", r.ID, true)
	if err != nil {
		return err
	}
	if err := r.Validate(); err != nil {
		return medicationError(err)
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.UpsertDoseRule(ctx, scope, r, active,
			session.SubjectID, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.catalogue.configure", ResourceType: "dose_rule",
			ResourceID: r.ID + "@" + r.Version, Outcome: audit.OutcomeSuccess,
			Reason: string(r.Scope) + ", validated=" + boolText(r.Validated),
		}, now)
	})
}

func boolText(v bool) string {
	if v {
		return "true"
	}
	return "false"
}

// SetPolicy records the tenant's medication policy.
func (s *Service) SetPolicy(ctx context.Context, p ports.Policy) error {
	session, scope, err := s.authorize(ctx, PermConfigure, "policy", "", true)
	if err != nil {
		return err
	}
	if err := p.Override.Validate(); err != nil {
		// A policy that tried to make contraindications overridable is refused
		// here as well as in the domain and again at the table. Three times,
		// because it is the one control a configuration screen must never be
		// able to unlock.
		return medicationError(err)
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.SetPolicy(ctx, scope, p, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.catalogue.configure", ResourceType: "policy",
			Outcome: audit.OutcomeSuccess,
			Reason:  "override ceiling " + string(p.Override.MaxOverridable),
		}, now)
	})
}

// TerminologyWriter is the part of the terminology adapter that accepts a map.
//
// Separate from ports.Terminology because reading the map and publishing it are
// different jobs held by different people, and a deployment whose terminology
// comes from a licensed drug database implements the reader and has nothing to
// write.
type TerminologyWriter interface {
	UpsertMapping(ctx context.Context, scope authctx.TenantScope,
		medication domain.Coding, ingredients, classes []domain.Coding,
		moiety domain.Coding, mapVersion, updatedBy string, now time.Time) error
}

// SetTerminologyMapping records one medication's ingredients, classes and
// moiety (SRS-MED-002).
func (s *Service) SetTerminologyMapping(ctx context.Context, writer TerminologyWriter,
	medication domain.Coding, ingredients, classes []domain.Coding,
	moiety domain.Coding, mapVersion string) error {

	session, scope, err := s.authorize(ctx, PermConfigure, "terminology",
		medication.Code, true)
	if err != nil {
		return err
	}
	if writer == nil {
		return rpcerr.FailedPrecondition("MED_TERMINOLOGY_READ_ONLY",
			"this deployment's terminology mapping is supplied externally")
	}
	if err := medication.Validate(); err != nil {
		return medicationError(err)
	}
	if mapVersion == "" {
		return rpcerr.Invalid("MED_MAP_VERSION_REQUIRED",
			"a terminology mapping needs a version, so a finding can name the edition that produced it")
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := writer.UpsertMapping(ctx, scope, medication, ingredients, classes,
			moiety, mapVersion, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "med.catalogue.configure", ResourceType: "terminology",
			ResourceID: medication.System + "|" + medication.Code,
			Outcome:    audit.OutcomeSuccess, Reason: "map " + mapVersion,
		}, now)
	})
}
