package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// OpenAccountInput opens an encounter's financial account.
type OpenAccountInput struct {
	EncounterID string
	PatientID   string
	Currency    string
	PayerID     string
	CustomerID  string
	RoomClass   string
	PackageCode string
}

// OpenAccount starts an encounter's financial record (SRS-BIL-013).
//
// Idempotent on the encounter: a second call returns the account that is
// already there rather than opening a second one. Two accounts on one visit
// would put a patient's bill in two places and neither total would be the
// answer.
func (s *Service) OpenAccount(ctx context.Context, in OpenAccountInput) (
	*domain.Account, error) {

	session, scope, err := s.authorize(ctx, PermChargePost, "account",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}

	if existing, err := s.accounts.ForEncounter(ctx, scope, in.EncounterID); err == nil {
		return existing, nil
	} else if !isNotFound(err) {
		return nil, err
	}

	state := ports.EncounterState{PatientID: in.PatientID}
	if s.encounters != nil && in.EncounterID != "" {
		state, err = s.encounters.Check(ctx, scope, in.EncounterID)
		if err != nil {
			return nil, err
		}
	}
	patientID := in.PatientID
	if patientID == "" {
		patientID = state.PatientID
	}

	currency := in.Currency
	if currency == "" {
		policySet, err := s.policies.Policy(ctx, scope)
		if err != nil {
			return nil, err
		}
		currency = policySet.Currency
	}

	now := s.clock.Now()
	account, err := domain.NewAccount(s.ids.NewID(), session.TenantID, patientID,
		in.EncounterID, state.FacilityID, currency, now)
	if err != nil {
		return nil, billingError(err)
	}
	account.PayerID, account.CustomerID = in.PayerID, in.CustomerID
	account.RoomClass, account.PackageCode = in.RoomClass, in.PackageCode

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.accounts.Insert(ctx, scope, account); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.account.open", ResourceType: "account",
			ResourceID: account.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return account, nil
}

// PostChargeInput raises a charge (SRS-BIL-003).
type PostChargeInput struct {
	AccountID   string
	EncounterID string
	ServiceCode string
	Quantity    int32

	Origin domain.ChargeOrigin
	Source domain.SourceReference
	Reason string

	// OccurredAt is when the service was delivered, which is what the master
	// and the tariff are resolved against. Zero means now.
	OccurredAt time.Time
}

// PostChargeResult is what raising a charge returns.
type PostChargeResult struct {
	Charge *domain.Charge
	// AlreadyPosted marks a redelivered clinical event: the charge that came
	// back is the one that was already there, and nothing was written.
	AlreadyPosted bool
	// Consumption is what a package did with it, where the account is on one
	// (SRS-BIL-004).
	Consumption *domain.Consumption
}

// PostCharge raises a charge and applies the account's package to it
// (SRS-BIL-003, SRS-BIL-004).
//
// The order of the steps is the argument. The service version and the tariff
// are resolved as of the moment of *care* rather than now, so a price list
// edited afterwards does not restate what was charged; the package decides
// coverage before anything is written, so a charge and the ledger entry
// explaining it land together; and the whole thing is idempotent on the source
// reference, so a redelivered clinical event produces one charge.
func (s *Service) PostCharge(ctx context.Context, in PostChargeInput) (
	PostChargeResult, error) {

	permission := PermChargePost
	if in.Origin == domain.OriginManual {
		// A manual charge is the path round every automated control, so it
		// takes a permission the desk raising four hundred automatic charges a
		// day does not need.
		permission = PermChargeManual
	}
	session, scope, err := s.authorize(ctx, permission, "charge", in.AccountID, true)
	if err != nil {
		return PostChargeResult{}, err
	}

	account, err := s.requireOpenAccount(ctx, scope, in.AccountID)
	if err != nil {
		return PostChargeResult{}, err
	}

	now := s.clock.Now()
	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}

	// Already charged? Answer with what is there rather than writing a second
	// one. Checked before the work as well as enforced at the table: the table
	// catches the concurrent case and this catches the ordinary retry without
	// burning a resolution.
	if !in.Source.Empty() {
		if existing, err := s.charges.BySource(ctx, scope, in.Source); err == nil {
			return PostChargeResult{Charge: existing, AlreadyPosted: true}, nil
		} else if !isNotFound(err) {
			return PostChargeResult{}, err
		}
	}

	item, err := s.resolveService(ctx, scope, in.ServiceCode, occurred)
	if err != nil {
		return PostChargeResult{}, err
	}
	price, err := s.resolvePrice(ctx, scope, account, in.ServiceCode, occurred)
	if err != nil {
		return PostChargeResult{}, err
	}

	charge, err := domain.NewCharge(s.ids.NewID(), session.TenantID,
		domain.NewChargeInput{
			PatientID: account.PatientID, EncounterID: account.EncounterID,
			FacilityID: account.FacilityID, AccountID: account.ID,
			Service: item, Quantity: in.Quantity, Pricing: price,
			Origin: in.Origin, Source: in.Source,
			EnteredBy: session.SubjectID, Reason: in.Reason,
			OccurredAt: occurred,
		}, now)
	if err != nil {
		return PostChargeResult{}, billingError(err)
	}

	consumption, err := s.applyPackage(ctx, scope, account, charge, now)
	if err != nil {
		return PostChargeResult{}, err
	}

	result := PostChargeResult{Charge: charge, Consumption: consumption}
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.charges.Insert(ctx, scope, charge); err != nil {
			if errors.Is(err, ports.ErrAlreadyRecorded) {
				// Two deliveries of one event raced and the other won. The
				// caller wants the charge that exists, not the news that theirs
				// lost.
				existing, lookupErr := s.charges.BySource(ctx, scope, in.Source)
				if lookupErr != nil {
					return lookupErr
				}
				result = PostChargeResult{Charge: existing, AlreadyPosted: true}
				return nil
			}
			return err
		}
		if consumption != nil {
			if err := s.charges.RecordConsumption(ctx, scope, *consumption); err != nil {
				return err
			}
		}
		if err := s.appendEvent(ctx, session, EventChargePosted, "charge", charge.ID,
			chargeEventPayload(charge), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.charge.post", ResourceType: "charge",
			ResourceID: charge.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(charge.Origin) + ": " + charge.Total().String(),
		}, now)
	})
	if err != nil {
		return PostChargeResult{}, mapConflict(err)
	}
	return result, nil
}

// resolveService picks the master version in force at the moment of care
// (SRS-BIL-001).
func (s *Service) resolveService(ctx context.Context, scope authctx.TenantScope,
	code string, at time.Time) (domain.ServiceItem, error) {

	versions, err := s.master.ServiceVersions(ctx, scope, code)
	if err != nil {
		return domain.ServiceItem{}, err
	}
	item, ok := domain.ResolveService(versions, code, at)
	if !ok {
		// Refused rather than priced from today's master. A charge against a
		// service that did not exist on the day is a charge nobody can defend,
		// and quietly pricing it is how that becomes invisible.
		return domain.ServiceItem{}, rpcerr.FailedPrecondition("BIL_NO_SERVICE_VERSION",
			"no version of service "+code+" was in force on "+
				at.UTC().Format("2006-01-02"))
	}
	return item, nil
}

// resolvePrice runs the pricing engine (SRS-BIL-002).
func (s *Service) resolvePrice(ctx context.Context, scope authctx.TenantScope,
	account *domain.Account, code string, at time.Time) (domain.PricingResult, error) {

	lines, err := s.master.TariffsFor(ctx, scope, code)
	if err != nil {
		return domain.PricingResult{}, err
	}
	price, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: code,
		PayerID:     account.PayerID, CustomerID: account.CustomerID,
		FacilityID: account.FacilityID, RoomClass: account.RoomClass,
		At: at,
	})
	if !ok {
		// SRS-BIL-011's "no tariff" exception, surfaced at the moment it can
		// still be fixed. A charge priced at zero because nothing matched is
		// revenue lost silently, which is the failure the worklist exists to
		// catch after the fact — better to catch it here.
		return domain.PricingResult{}, rpcerr.FailedPrecondition("BIL_NO_TARIFF",
			"no tariff prices "+code+" for this account")
	}
	return price, nil
}

// applyPackage decides what the account's package does with a charge
// (SRS-BIL-004).
func (s *Service) applyPackage(ctx context.Context, scope authctx.TenantScope,
	account *domain.Account, charge *domain.Charge, now time.Time) (
	*domain.Consumption, error) {

	if account.PackageCode == "" {
		return nil, nil
	}

	bundle, err := s.master.PackageAt(ctx, scope, account.PackageCode,
		charge.OccurredAt)
	if err != nil {
		if isNotFound(err) {
			// The account names a package no version of which was in force on
			// the day. Reported rather than silently billed at the standard
			// tariff: the patient was sold something, and which product is a
			// question finance has to answer.
			return nil, rpcerr.FailedPrecondition("BIL_NO_PACKAGE_VERSION",
				"no version of package "+account.PackageCode+
					" was in force on "+charge.OccurredAt.UTC().Format("2006-01-02"))
		}
		return nil, err
	}

	ledger, err := s.charges.Consumption(ctx, scope, account.ID)
	if err != nil {
		return nil, err
	}

	entry, billed := bundle.Apply(domain.NewPackageState(ledger), charge, now)
	charge.PackageID = bundle.Code
	charge.Covered = !billed
	charge.CoverageNote = entry.Explanation
	if entry.Outcome == domain.CoverageCarveOut {
		// A carve-out is billed at the contracted price rather than the
		// standard tariff, which is what both sides agreed.
		charge.UnitPrice = domain.Money{
			Minor:    entry.Price.Minor / int64(maxQuantity(charge.Quantity)),
			Currency: entry.Price.Currency,
		}
		charge.Pricing = domain.PricingResult{
			Price: charge.UnitPrice, ContractID: bundle.Code,
			Contract: bundle.Name + " carve-out",
		}
	}
	return &entry, nil
}

func maxQuantity(q int32) int32 {
	if q < 1 {
		return 1
	}
	return q
}

// chargeEventPayload is what charge.posted carries (SRS-BIL-016).
//
// Identifiers, the service, the amount and the provenance. Not the clinical
// reason a service was delivered, and not the patient's name: an event stream
// is read by more systems and under fewer controls than the ledger it
// describes.
func chargeEventPayload(c *domain.Charge) map[string]any {
	total := c.Total()
	return map[string]any{
		"charge_id": c.ID, "account_id": c.AccountID,
		"patient_id": c.PatientID, "encounter_id": c.EncounterID,
		"facility_id":  c.FacilityID,
		"service_code": c.ServiceCode, "department": c.Department,
		"quantity":     c.Quantity,
		"amount_minor": total.Minor, "currency": total.Currency,
		"origin": string(c.Origin), "source_system": c.Source.System,
		"covered": c.Covered, "package_code": c.PackageID,
	}
}

// VoidCharge marks a charge raised in error (SRS-BIL-010).
func (s *Service) VoidCharge(ctx context.Context, chargeID, reason string) (
	*domain.Charge, error) {

	return s.moveCharge(ctx, chargeID, reason,
		func(c *domain.Charge, by, reason string, now time.Time) error {
			return c.Void(by, reason, now)
		})
}

// HoldCharge parks a charge pending a query (SRS-BIL-011).
func (s *Service) HoldCharge(ctx context.Context, chargeID, reason string) (
	*domain.Charge, error) {

	return s.moveCharge(ctx, chargeID, reason,
		func(c *domain.Charge, _, reason string, _ time.Time) error {
			return c.Hold(reason)
		})
}

// ReleaseCharge returns a held charge to the billable set.
func (s *Service) ReleaseCharge(ctx context.Context, chargeID string) (
	*domain.Charge, error) {

	return s.moveCharge(ctx, chargeID, "",
		func(c *domain.Charge, _, _ string, _ time.Time) error {
			return c.Release()
		})
}

func (s *Service) moveCharge(ctx context.Context, chargeID, reason string,
	apply func(*domain.Charge, string, string, time.Time) error) (
	*domain.Charge, error) {

	session, scope, err := s.authorize(ctx, PermChargePost, "charge", chargeID, true)
	if err != nil {
		return nil, err
	}

	charge, err := s.charges.Get(ctx, scope, chargeID)
	if err != nil {
		return nil, err
	}

	expectedVersion, expectedStatus := charge.Version, charge.Status
	now := s.clock.Now()
	if err := apply(charge, session.SubjectID, reason, now); err != nil {
		return nil, billingError(err)
	}
	if charge.Status == expectedStatus {
		// Idempotent: nothing moved.
		return charge, nil
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.charges.UpdateStatus(ctx, scope, charge, expectedVersion,
			expectedStatus); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.charge.post", ResourceType: "charge",
			ResourceID: charge.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(expectedStatus) + " -> " + string(charge.Status) +
				": " + charge.Reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return charge, nil
}

// Charges lists an account's charges.
func (s *Service) Charges(ctx context.Context, accountID string, billableOnly bool,
	limit int32) ([]*domain.Charge, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "charge", accountID, false)
	if err != nil {
		return nil, err
	}
	return s.charges.ForAccount(ctx, scope, accountID, billableOnly,
		clampPageSize(limit))
}

// PackageLedger explains what a package billed and did not (SRS-BIL-004).
func (s *Service) PackageLedger(ctx context.Context, accountID string) (
	[]domain.Consumption, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "account", accountID, false)
	if err != nil {
		return nil, err
	}
	ledger, err := s.charges.Consumption(ctx, scope, accountID)
	if err != nil {
		return nil, err
	}
	return domain.Explain(ledger), nil
}

func isNotFound(err error) bool {
	var rpcErr *rpcerr.Error
	if !errors.As(err, &rpcErr) {
		return false
	}
	return rpcErr.Category == rpcerr.CategoryNotFound
}
