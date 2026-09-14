package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// Configuration a tenant's finance department maintains (SRS-BIL-001,
// SRS-BIL-002, SRS-BIL-004, SRS-BIL-007).
//
// All behind one permission, and held by neither the desk that raises charges
// nor the one that takes money: deciding what a service costs is a governance
// act, and a cashier who could edit the tariff could decide what they collect.

// PublishService adds a version to the charge master (SRS-BIL-001).
//
// A version rather than an edit. A price list edited in April must not change
// what a March invoice says it charged for, and the only way to hold that
// without copying the master onto every line is to keep the versions.
func (s *Service) PublishService(ctx context.Context, item domain.ServiceItem) error {
	session, scope, err := s.authorize(ctx, PermBillingConfigure, "service_item",
		item.Code, true)
	if err != nil {
		return err
	}
	if err := item.Validate(); err != nil {
		return billingError(err)
	}

	now := s.clock.Now()
	item.TenantID = session.TenantID
	item.UpdatedBy = session.SubjectID
	item.UpdatedAt = now

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.PublishService(ctx, scope, item); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.catalogue.configure", ResourceType: "service_item",
			ResourceID: item.Code, Outcome: audit.OutcomeSuccess,
			Reason: "effective " + item.EffectiveFrom.UTC().Format("2006-01-02"),
		}, now)
	})
}

// Services lists the charge master.
func (s *Service) Services(ctx context.Context, limit int32) (
	[]domain.ServiceItem, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "service_item", "", false)
	if err != nil {
		return nil, err
	}
	return s.master.Services(ctx, scope, clampPageSize(limit))
}

// PublishTariff records a negotiated price (SRS-BIL-002).
func (s *Service) PublishTariff(ctx context.Context, lineID string,
	line domain.TariffLine) error {

	session, scope, err := s.authorize(ctx, PermBillingConfigure, "tariff",
		line.ContractID, true)
	if err != nil {
		return err
	}
	if err := line.Validate(); err != nil {
		return billingError(err)
	}

	now := s.clock.Now()
	line.TenantID = session.TenantID
	line.UpdatedBy = session.SubjectID
	line.UpdatedAt = now
	if lineID == "" {
		lineID = s.ids.NewID()
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.UpsertTariff(ctx, scope, lineID, line); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.catalogue.configure", ResourceType: "tariff",
			ResourceID: line.ContractID, Outcome: audit.OutcomeSuccess,
			Reason: line.Scope.ServiceCode + " at " + line.Price.String(),
		}, now)
	})
}

// Tariffs lists the contract lines.
func (s *Service) Tariffs(ctx context.Context, limit int32) (
	[]domain.TariffLine, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "tariff", "", false)
	if err != nil {
		return nil, err
	}
	return s.master.Tariffs(ctx, scope, clampPageSize(limit))
}

// Quote prices a service without charging for it (SRS-BIL-002, SRS-BIL-005).
//
// The same engine the charge path uses, so an estimate cannot quote a price a
// charge would not produce. Two implementations of "what does this cost" is two
// answers, and the one the patient was shown is the one they will hold the
// hospital to.
func (s *Service) Quote(ctx context.Context, accountID, serviceCode string) (
	domain.PricingResult, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "tariff", serviceCode, false)
	if err != nil {
		return domain.PricingResult{}, err
	}

	account, err := s.accounts.Get(ctx, scope, accountID)
	if err != nil {
		return domain.PricingResult{}, err
	}
	return s.resolvePrice(ctx, scope, account, serviceCode, s.clock.Now())
}

// PublishPackage records a bundle (SRS-BIL-004).
func (s *Service) PublishPackage(ctx context.Context, p domain.Package) error {
	session, scope, err := s.authorize(ctx, PermBillingConfigure, "package",
		p.Code, true)
	if err != nil {
		return err
	}
	if err := p.Validate(); err != nil {
		return billingError(err)
	}

	now := s.clock.Now()
	p.TenantID = session.TenantID
	p.UpdatedBy = session.SubjectID
	p.UpdatedAt = now

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.PublishPackage(ctx, scope, p); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.catalogue.configure", ResourceType: "package",
			ResourceID: p.Code, Outcome: audit.OutcomeSuccess,
			Reason: p.Name + " at " + p.Price.String(),
		}, now)
	})
}

// Packages lists the bundles.
func (s *Service) Packages(ctx context.Context, limit int32) (
	[]domain.Package, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "package", "", false)
	if err != nil {
		return nil, err
	}
	return s.master.Packages(ctx, scope, clampPageSize(limit))
}

// SetPolicy records the tenant's billing configuration.
func (s *Service) SetPolicy(ctx context.Context, p ports.Policy) error {
	session, scope, err := s.authorize(ctx, PermBillingConfigure, "policy", "", true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.policies.SetPolicy(ctx, scope, p, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.catalogue.configure", ResourceType: "policy",
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
}

// Policy reads the tenant's billing configuration.
func (s *Service) Policy(ctx context.Context) (ports.Policy, error) {
	_, scope, err := s.authorize(ctx, PermBillingRead, "policy", "", false)
	if err != nil {
		return ports.Policy{}, err
	}
	return s.policies.Policy(ctx, scope)
}

// Account reads one financial account.
func (s *Service) Account(ctx context.Context, accountID string) (
	*domain.Account, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "account", accountID, false)
	if err != nil {
		return nil, err
	}
	return s.accounts.Get(ctx, scope, accountID)
}

// AccountForEncounter reads a visit's account.
func (s *Service) AccountForEncounter(ctx context.Context, encounterID string) (
	*domain.Account, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "account", encounterID, false)
	if err != nil {
		return nil, err
	}
	return s.accounts.ForEncounter(ctx, scope, encounterID)
}
