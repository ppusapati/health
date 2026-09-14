package transport

import (
	"time"

	billingv1 "github.com/ppusapati/health/code/gen/go/healthcare/billing/v1"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Translation between the wire contract and the domain.
//
// Written out in both directions rather than generated, because the two
// vocabularies are deliberately not the same shape: the wire carries seconds
// where the domain carries durations, and an enum the wire does not know maps
// to the value that refuses rather than the one that permits.

func timestamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

func fromTimestamp(t *timestamppb.Timestamp) time.Time {
	if t == nil || !t.IsValid() {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

func moneyToProto(m domain.Money) *billingv1.Money {
	if m.Zero() {
		return nil
	}
	return &billingv1.Money{Minor: m.Minor, Currency: m.Currency}
}

func moneyFromProto(m *billingv1.Money) domain.Money {
	if m == nil {
		return domain.Money{}
	}
	return domain.Money{Minor: m.GetMinor(), Currency: m.GetCurrency()}
}

var chargeOriginFromProto = map[billingv1.ChargeOrigin]domain.ChargeOrigin{
	billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT: domain.OriginClinicalEvent,
	billingv1.ChargeOrigin_CHARGE_ORIGIN_MANUAL:         domain.OriginManual,
	billingv1.ChargeOrigin_CHARGE_ORIGIN_RECURRING:      domain.OriginRecurring,
	// Unspecified means a clinical event, which is the one that requires a
	// source reference — so an unlabelled request is refused for the missing
	// provenance rather than quietly accepted as a manual charge, which is the
	// path round every automated control.
	billingv1.ChargeOrigin_CHARGE_ORIGIN_UNSPECIFIED: domain.OriginClinicalEvent,
}

var chargeOriginToProto = map[domain.ChargeOrigin]billingv1.ChargeOrigin{
	domain.OriginClinicalEvent: billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT,
	domain.OriginManual:        billingv1.ChargeOrigin_CHARGE_ORIGIN_MANUAL,
	domain.OriginRecurring:     billingv1.ChargeOrigin_CHARGE_ORIGIN_RECURRING,
}

var chargeStatusToProto = map[domain.ChargeStatus]billingv1.ChargeStatus{
	domain.ChargePosted:   billingv1.ChargeStatus_CHARGE_STATUS_POSTED,
	domain.ChargeInvoiced: billingv1.ChargeStatus_CHARGE_STATUS_INVOICED,
	domain.ChargeVoided:   billingv1.ChargeStatus_CHARGE_STATUS_VOIDED,
	domain.ChargeHeld:     billingv1.ChargeStatus_CHARGE_STATUS_HELD,
}

var coverageToProto = map[domain.CoverageOutcome]billingv1.CoverageOutcome{
	domain.CoverageIncluded:       billingv1.CoverageOutcome_COVERAGE_OUTCOME_INCLUDED,
	domain.CoverageOverCap:        billingv1.CoverageOutcome_COVERAGE_OUTCOME_OVER_CAP,
	domain.CoverageExcluded:       billingv1.CoverageOutcome_COVERAGE_OUTCOME_EXCLUDED,
	domain.CoverageCarveOut:       billingv1.CoverageOutcome_COVERAGE_OUTCOME_CARVE_OUT,
	domain.CoverageOutsidePackage: billingv1.CoverageOutcome_COVERAGE_OUTCOME_OUTSIDE_PACKAGE,
}

var kindFromProto = map[billingv1.DocumentKind]domain.DocumentKind{
	billingv1.DocumentKind_DOCUMENT_KIND_ESTIMATE:    domain.KindEstimate,
	billingv1.DocumentKind_DOCUMENT_KIND_INTERIM:     domain.KindInterim,
	billingv1.DocumentKind_DOCUMENT_KIND_FINAL:       domain.KindFinal,
	billingv1.DocumentKind_DOCUMENT_KIND_CREDIT_NOTE: domain.KindCredit,
	billingv1.DocumentKind_DOCUMENT_KIND_DEBIT_NOTE:  domain.KindDebit,
}

var kindToProto = map[domain.DocumentKind]billingv1.DocumentKind{
	domain.KindEstimate: billingv1.DocumentKind_DOCUMENT_KIND_ESTIMATE,
	domain.KindInterim:  billingv1.DocumentKind_DOCUMENT_KIND_INTERIM,
	domain.KindFinal:    billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
	domain.KindCredit:   billingv1.DocumentKind_DOCUMENT_KIND_CREDIT_NOTE,
	domain.KindDebit:    billingv1.DocumentKind_DOCUMENT_KIND_DEBIT_NOTE,
}

var invoiceStatusToProto = map[domain.InvoiceStatus]billingv1.InvoiceStatus{
	domain.InvoiceDraft:      billingv1.InvoiceStatus_INVOICE_STATUS_DRAFT,
	domain.InvoiceIssued:     billingv1.InvoiceStatus_INVOICE_STATUS_ISSUED,
	domain.InvoiceSuperseded: billingv1.InvoiceStatus_INVOICE_STATUS_SUPERSEDED,
	domain.InvoiceCancelled:  billingv1.InvoiceStatus_INVOICE_STATUS_CANCELLED,
}

var partyFromProto = map[billingv1.LiabilityParty]domain.LiabilityParty{
	billingv1.LiabilityParty_LIABILITY_PARTY_PATIENT:   domain.LiabilityPatient,
	billingv1.LiabilityParty_LIABILITY_PARTY_PAYER:     domain.LiabilityPayer,
	billingv1.LiabilityParty_LIABILITY_PARTY_CORPORATE: domain.LiabilityCorporate,
	billingv1.LiabilityParty_LIABILITY_PARTY_SCHEME:    domain.LiabilityScheme,
}

var partyToProto = map[domain.LiabilityParty]billingv1.LiabilityParty{
	domain.LiabilityPatient:   billingv1.LiabilityParty_LIABILITY_PARTY_PATIENT,
	domain.LiabilityPayer:     billingv1.LiabilityParty_LIABILITY_PARTY_PAYER,
	domain.LiabilityCorporate: billingv1.LiabilityParty_LIABILITY_PARTY_CORPORATE,
	domain.LiabilityScheme:    billingv1.LiabilityParty_LIABILITY_PARTY_SCHEME,
}

var entryKindToProto = map[domain.EntryKind]billingv1.EntryKind{
	domain.EntryInvoice:        billingv1.EntryKind_ENTRY_KIND_INVOICE,
	domain.EntryPayment:        billingv1.EntryKind_ENTRY_KIND_PAYMENT,
	domain.EntryRefund:         billingv1.EntryKind_ENTRY_KIND_REFUND,
	domain.EntryDeposit:        billingv1.EntryKind_ENTRY_KIND_DEPOSIT,
	domain.EntryDepositApplied: billingv1.EntryKind_ENTRY_KIND_DEPOSIT_APPLIED,
	domain.EntryWriteOff:       billingv1.EntryKind_ENTRY_KIND_WRITE_OFF,
	domain.EntryAdjustment:     billingv1.EntryKind_ENTRY_KIND_ADJUSTMENT,
}

var methodFromProto = map[billingv1.PaymentMethod]domain.PaymentMethod{
	billingv1.PaymentMethod_PAYMENT_METHOD_CASH:             domain.MethodCash,
	billingv1.PaymentMethod_PAYMENT_METHOD_CARD:             domain.MethodCard,
	billingv1.PaymentMethod_PAYMENT_METHOD_UPI:              domain.MethodUPI,
	billingv1.PaymentMethod_PAYMENT_METHOD_BANK_TRANSFER:    domain.MethodTransfer,
	billingv1.PaymentMethod_PAYMENT_METHOD_CHEQUE:           domain.MethodCheque,
	billingv1.PaymentMethod_PAYMENT_METHOD_PAYER_SETTLEMENT: domain.MethodPayer,
}

var methodToProto = map[domain.PaymentMethod]billingv1.PaymentMethod{
	domain.MethodCash:     billingv1.PaymentMethod_PAYMENT_METHOD_CASH,
	domain.MethodCard:     billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
	domain.MethodUPI:      billingv1.PaymentMethod_PAYMENT_METHOD_UPI,
	domain.MethodTransfer: billingv1.PaymentMethod_PAYMENT_METHOD_BANK_TRANSFER,
	domain.MethodCheque:   billingv1.PaymentMethod_PAYMENT_METHOD_CHEQUE,
	domain.MethodPayer:    billingv1.PaymentMethod_PAYMENT_METHOD_PAYER_SETTLEMENT,
}

var accountStatusToProto = map[domain.AccountStatus]billingv1.AccountStatus{
	domain.AccountOpen:   billingv1.AccountStatus_ACCOUNT_STATUS_OPEN,
	domain.AccountClosed: billingv1.AccountStatus_ACCOUNT_STATUS_CLOSED,
}

var shiftStatusToProto = map[domain.ShiftStatus]billingv1.ShiftStatus{
	domain.ShiftOpen:            billingv1.ShiftStatus_SHIFT_STATUS_OPEN,
	domain.ShiftReconciled:      billingv1.ShiftStatus_SHIFT_STATUS_RECONCILED,
	domain.ShiftPendingApproval: billingv1.ShiftStatus_SHIFT_STATUS_PENDING_APPROVAL,
}

var exceptionKindToProto = map[domain.ExceptionKind]billingv1.ExceptionKind{
	domain.ExceptionUnbilled:        billingv1.ExceptionKind_EXCEPTION_KIND_UNBILLED_SERVICE,
	domain.ExceptionUninvoiced:      billingv1.ExceptionKind_EXCEPTION_KIND_UNINVOICED_CHARGE,
	domain.ExceptionHeld:            billingv1.ExceptionKind_EXCEPTION_KIND_HELD_CHARGE,
	domain.ExceptionNoTariff:        billingv1.ExceptionKind_EXCEPTION_KIND_NO_TARIFF,
	domain.ExceptionUnpricedPackage: billingv1.ExceptionKind_EXCEPTION_KIND_UNPRICED_PACKAGE,
}

func sourceToProto(s domain.SourceReference) *billingv1.SourceReference {
	if s.Empty() && s.Detail == "" {
		return nil
	}
	return &billingv1.SourceReference{System: s.System, Id: s.ID, Detail: s.Detail}
}

func sourceFromProto(s *billingv1.SourceReference) domain.SourceReference {
	if s == nil {
		return domain.SourceReference{}
	}
	return domain.SourceReference{
		System: s.GetSystem(), ID: s.GetId(), Detail: s.GetDetail(),
	}
}

func serviceItemToProto(item domain.ServiceItem) *billingv1.ServiceItem {
	return &billingv1.ServiceItem{
		Code: item.Code, Description: item.Description,
		Department: item.Department, RevenueAccount: item.RevenueAccount,
		TaxCode: item.TaxCode, TaxRateBp: int32(item.TaxRate),
		TaxInclusive:  item.TaxInclusive,
		EffectiveFrom: timestamp(item.EffectiveFrom),
		EffectiveTo:   timestamp(item.EffectiveTo),
	}
}

func serviceItemFromProto(item *billingv1.ServiceItem) domain.ServiceItem {
	if item == nil {
		return domain.ServiceItem{}
	}
	return domain.ServiceItem{
		Code: item.GetCode(), Description: item.GetDescription(),
		Department: item.GetDepartment(), RevenueAccount: item.GetRevenueAccount(),
		TaxCode: item.GetTaxCode(), TaxRate: domain.BasisPoints(item.GetTaxRateBp()),
		TaxInclusive:  item.GetTaxInclusive(),
		EffectiveFrom: fromTimestamp(item.GetEffectiveFrom()),
		EffectiveTo:   fromTimestamp(item.GetEffectiveTo()),
	}
}

func scopeToProto(s domain.TariffScope) *billingv1.TariffScope {
	return &billingv1.TariffScope{
		PayerId: s.PayerID, CustomerId: s.CustomerID, FacilityId: s.FacilityID,
		RoomClass: s.RoomClass, ServiceCode: s.ServiceCode,
	}
}

func scopeFromProto(s *billingv1.TariffScope) domain.TariffScope {
	if s == nil {
		return domain.TariffScope{}
	}
	return domain.TariffScope{
		PayerID: s.GetPayerId(), CustomerID: s.GetCustomerId(),
		FacilityID: s.GetFacilityId(), RoomClass: s.GetRoomClass(),
		ServiceCode: s.GetServiceCode(),
	}
}

func tariffToProto(line domain.TariffLine) *billingv1.TariffLine {
	return &billingv1.TariffLine{
		ContractId: line.ContractID, Name: line.Name,
		Scope: scopeToProto(line.Scope), Price: moneyToProto(line.Price),
		Priority:      line.Priority,
		EffectiveFrom: timestamp(line.EffectiveFrom),
		EffectiveTo:   timestamp(line.EffectiveTo),
	}
}

func tariffFromProto(line *billingv1.TariffLine) domain.TariffLine {
	if line == nil {
		return domain.TariffLine{}
	}
	return domain.TariffLine{
		ContractID: line.GetContractId(), Name: line.GetName(),
		Scope: scopeFromProto(line.GetScope()), Price: moneyFromProto(line.GetPrice()),
		Priority:      line.GetPriority(),
		EffectiveFrom: fromTimestamp(line.GetEffectiveFrom()),
		EffectiveTo:   fromTimestamp(line.GetEffectiveTo()),
	}
}

func pricingToProto(p domain.PricingResult) *billingv1.PricingResult {
	return &billingv1.PricingResult{
		Price: moneyToProto(p.Price), ContractId: p.ContractID,
		Contract: p.Contract, Scope: scopeToProto(p.Scope),
	}
}

func packageToProto(p domain.Package) *billingv1.Package {
	inclusions := make([]*billingv1.PackageInclusion, 0, len(p.Inclusions))
	for _, inclusion := range p.Inclusions {
		inclusions = append(inclusions, &billingv1.PackageInclusion{
			ServiceCode: inclusion.ServiceCode, Quantity: inclusion.Quantity,
		})
	}
	carveOuts := make([]*billingv1.PackageCarveOut, 0, len(p.CarveOuts))
	for _, carveOut := range p.CarveOuts {
		carveOuts = append(carveOuts, &billingv1.PackageCarveOut{
			ServiceCode: carveOut.ServiceCode,
			Price:       moneyToProto(carveOut.Price), Note: carveOut.Note,
		})
	}
	return &billingv1.Package{
		Code: p.Code, Name: p.Name, Price: moneyToProto(p.Price),
		Inclusions: inclusions, Exclusions: p.Exclusions, CarveOuts: carveOuts,
		RoomClass:     p.RoomClass,
		EffectiveFrom: timestamp(p.EffectiveFrom),
		EffectiveTo:   timestamp(p.EffectiveTo),
	}
}

func packageFromProto(p *billingv1.Package) domain.Package {
	if p == nil {
		return domain.Package{}
	}
	inclusions := make([]domain.PackageInclusion, 0, len(p.GetInclusions()))
	for _, inclusion := range p.GetInclusions() {
		inclusions = append(inclusions, domain.PackageInclusion{
			ServiceCode: inclusion.GetServiceCode(), Quantity: inclusion.GetQuantity(),
		})
	}
	carveOuts := make([]domain.PackageCarveOut, 0, len(p.GetCarveOuts()))
	for _, carveOut := range p.GetCarveOuts() {
		carveOuts = append(carveOuts, domain.PackageCarveOut{
			ServiceCode: carveOut.GetServiceCode(),
			Price:       moneyFromProto(carveOut.GetPrice()), Note: carveOut.GetNote(),
		})
	}
	return domain.Package{
		Code: p.GetCode(), Name: p.GetName(), Price: moneyFromProto(p.GetPrice()),
		Inclusions: inclusions, Exclusions: p.GetExclusions(), CarveOuts: carveOuts,
		RoomClass:     p.GetRoomClass(),
		EffectiveFrom: fromTimestamp(p.GetEffectiveFrom()),
		EffectiveTo:   fromTimestamp(p.GetEffectiveTo()),
	}
}

func chargeToProto(c *domain.Charge) *billingv1.Charge {
	if c == nil {
		return nil
	}
	return &billingv1.Charge{
		ChargeId: c.ID, AccountId: c.AccountID, PatientId: c.PatientID,
		EncounterId: c.EncounterID, FacilityId: c.FacilityID,
		ServiceCode: c.ServiceCode, Description: c.Description,
		Department: c.Department, Quantity: c.Quantity,
		UnitPrice: moneyToProto(c.UnitPrice), Pricing: pricingToProto(c.Pricing),
		TaxCode: c.TaxCode, TaxRateBp: int32(c.TaxRate),
		TaxInclusive: c.TaxInclusive,
		Net:          moneyToProto(c.Net()), Tax: moneyToProto(c.Tax()),
		Total:  moneyToProto(c.Total()),
		Origin: chargeOriginToProto[c.Origin], Source: sourceToProto(c.Source),
		EnteredBy: c.EnteredBy, Reason: c.Reason,
		OccurredAt: timestamp(c.OccurredAt), PostedAt: timestamp(c.PostedAt),
		Status:      chargeStatusToProto[c.Status],
		PackageCode: c.PackageID, Covered: c.Covered,
		CoverageNote: c.CoverageNote, InvoiceId: c.InvoiceID,
	}
}

func chargesToProto(in []*domain.Charge) []*billingv1.Charge {
	out := make([]*billingv1.Charge, 0, len(in))
	for _, c := range in {
		out = append(out, chargeToProto(c))
	}
	return out
}

func consumptionToProto(c domain.Consumption) *billingv1.Consumption {
	return &billingv1.Consumption{
		PackageCode: c.PackageCode, ChargeId: c.ChargeID,
		ServiceCode: c.ServiceCode, Quantity: c.Quantity,
		Outcome: coverageToProto[c.Outcome], Explanation: c.Explanation,
		Price: moneyToProto(c.Price), RecordedAt: timestamp(c.RecordedAt),
	}
}

func discountFromProto(d *billingv1.Discount) *domain.Discount {
	if d == nil {
		return nil
	}
	return &domain.Discount{
		Rate: domain.BasisPoints(d.GetRateBp()), Amount: moneyFromProto(d.GetAmount()),
		Reason: d.GetReason(), ApprovedBy: d.GetApprovedBy(),
		ApprovalRef: d.GetApprovalRef(),
	}
}

func discountToProto(d domain.Discount) *billingv1.Discount {
	return &billingv1.Discount{
		RateBp: int32(d.Rate), Amount: moneyToProto(d.Amount),
		Reason: d.Reason, AppliedBy: d.AppliedBy, ApprovedBy: d.ApprovedBy,
		AppliedAt: timestamp(d.AppliedAt), ApprovalRef: d.ApprovalRef,
	}
}

func liabilityFromProto(in []*billingv1.LiabilityShare) []domain.LiabilityShare {
	out := make([]domain.LiabilityShare, 0, len(in))
	for _, share := range in {
		out = append(out, domain.LiabilityShare{
			Party: partyFromProto[share.GetParty()], PartyID: share.GetPartyId(),
			Amount: moneyFromProto(share.GetAmount()), Basis: share.GetBasis(),
			AdjudicationRef: share.GetAdjudicationRef(),
		})
	}
	return out
}

func lineFromProto(line *billingv1.InvoiceLine) domain.InvoiceLine {
	return domain.InvoiceLine{
		Sequence: line.GetSequence(), ChargeID: line.GetChargeId(),
		ServiceCode: line.GetServiceCode(), Description: line.GetDescription(),
		Department: line.GetDepartment(), Quantity: line.GetQuantity(),
		UnitPrice: moneyFromProto(line.GetUnitPrice()),
		Net:       moneyFromProto(line.GetNet()),
		TaxCode:   line.GetTaxCode(), TaxRate: domain.BasisPoints(line.GetTaxRateBp()),
		Tax:         moneyFromProto(line.GetTax()),
		Discount:    moneyFromProto(line.GetDiscount()),
		Total:       moneyFromProto(line.GetTotal()),
		PackageCode: line.GetPackageCode(), CoverageNote: line.GetCoverageNote(),
	}
}

func invoiceToProto(i *domain.Invoice) *billingv1.Invoice {
	if i == nil {
		return nil
	}
	lines := make([]*billingv1.InvoiceLine, 0, len(i.Lines))
	for _, line := range i.Lines {
		lines = append(lines, &billingv1.InvoiceLine{
			Sequence: line.Sequence, ChargeId: line.ChargeID,
			ServiceCode: line.ServiceCode, Description: line.Description,
			Department: line.Department, Quantity: line.Quantity,
			UnitPrice: moneyToProto(line.UnitPrice), Net: moneyToProto(line.Net),
			TaxCode: line.TaxCode, TaxRateBp: int32(line.TaxRate),
			Tax: moneyToProto(line.Tax), Discount: moneyToProto(line.Discount),
			Total:       moneyToProto(line.Total),
			PackageCode: line.PackageCode, CoverageNote: line.CoverageNote,
		})
	}
	discounts := make([]*billingv1.Discount, 0, len(i.Discounts))
	for _, d := range i.Discounts {
		discounts = append(discounts, discountToProto(d))
	}
	shares := make([]*billingv1.LiabilityShare, 0, len(i.Liability))
	for _, share := range i.Liability {
		shares = append(shares, &billingv1.LiabilityShare{
			Party: partyToProto[share.Party], PartyId: share.PartyID,
			Amount: moneyToProto(share.Amount), Basis: share.Basis,
			AdjudicationRef: share.AdjudicationRef,
		})
	}

	return &billingv1.Invoice{
		InvoiceId: i.ID, Number: i.Number,
		Kind: kindToProto[i.Kind], Status: invoiceStatusToProto[i.Status],
		AccountId: i.AccountID, PatientId: i.PatientID,
		EncounterId: i.EncounterID, FacilityId: i.FacilityID,
		DocumentVersion: i.Version, SupersededBy: i.SupersededBy,
		CorrectsInvoiceId: i.CorrectsInvoiceID,
		Lines:             lines,
		Subtotal:          moneyToProto(i.Subtotal),
		Discount:          moneyToProto(i.Discount),
		Tax:               moneyToProto(i.Tax),
		Total:             moneyToProto(i.Total),
		Discounts:         discounts, Liability: shares,
		PayerId: i.PayerID, CustomerId: i.CustomerID, Notes: i.Notes,
		IssuedBy: i.IssuedBy, IssuedAt: timestamp(i.IssuedAt),
		CreatedBy: i.CreatedBy, CreatedAt: timestamp(i.CreatedAt),
	}
}

func ledgerEntryToProto(e domain.LedgerEntry) *billingv1.LedgerEntry {
	return &billingv1.LedgerEntry{
		EntryId: e.ID, AccountId: e.AccountID, PatientId: e.PatientID,
		EncounterId: e.EncounterID,
		Kind:        entryKindToProto[e.Kind], Amount: moneyToProto(e.Amount),
		InvoiceId: e.InvoiceID, PaymentId: e.PaymentID,
		RefundOfPaymentId: e.RefundOfPaymentID,
		Method:            methodToProto[e.Method], ProviderRef: e.ProviderRef,
		ReceiptNumber: e.ReceiptNumber, ShiftId: e.ShiftID,
		Reason: e.Reason, RecordedBy: e.RecordedBy, ApprovedBy: e.ApprovedBy,
		OccurredAt: timestamp(e.OccurredAt),
	}
}

func accountToProto(a *domain.Account) *billingv1.Account {
	if a == nil {
		return nil
	}
	return &billingv1.Account{
		AccountId: a.ID, PatientId: a.PatientID, EncounterId: a.EncounterID,
		FacilityId: a.FacilityID, Currency: a.Currency,
		PayerId: a.PayerID, CustomerId: a.CustomerID,
		RoomClass: a.RoomClass, PackageCode: a.PackageCode,
		Status:   accountStatusToProto[a.Status],
		ClosedBy: a.ClosedBy, ClosedAt: timestamp(a.ClosedAt),
	}
}

func exceptionsToProto(in []domain.CloseException) []*billingv1.CloseException {
	out := make([]*billingv1.CloseException, 0, len(in))
	for _, exception := range in {
		out = append(out, &billingv1.CloseException{
			Check: string(exception.Check), Detail: exception.Detail,
			Amount: moneyToProto(exception.Amount), References: exception.References,
		})
	}
	return out
}

func shiftToProto(s *domain.Shift) *billingv1.Shift {
	if s == nil {
		return nil
	}
	return &billingv1.Shift{
		ShiftId: s.ID, FacilityId: s.FacilityID,
		CounterId: s.CounterID, CashierId: s.CashierID,
		OpeningFloat: moneyToProto(s.OpeningFloat), OpenedAt: timestamp(s.OpenedAt),
		CountedCash:    moneyToProto(s.CountedCash),
		ExpectedCash:   moneyToProto(s.ExpectedCash),
		Variance:       moneyToProto(s.Variance),
		Status:         shiftStatusToProto[s.Status],
		VarianceReason: s.VarianceReason, ApprovedBy: s.ApprovedBy,
		ClosedAt: timestamp(s.ClosedAt),
	}
}

func revenueExceptionsToProto(in []domain.RevenueException) []*billingv1.RevenueException {
	out := make([]*billingv1.RevenueException, 0, len(in))
	for _, exception := range in {
		out = append(out, &billingv1.RevenueException{
			Kind:      exceptionKindToProto[exception.Kind],
			AccountId: exception.AccountID, PatientId: exception.PatientID,
			EncounterId: exception.EncounterID, ChargeId: exception.ChargeID,
			Source: sourceToProto(exception.Source), Detail: exception.Detail,
			Amount:     moneyToProto(exception.Amount),
			AgeSeconds: int64(exception.Age / time.Second),
		})
	}
	return out
}

func billableEventsFromProto(in []*billingv1.BillableEvent) []domain.BillableEvent {
	out := make([]domain.BillableEvent, 0, len(in))
	for _, event := range in {
		out = append(out, domain.BillableEvent{
			Source:      sourceFromProto(event.GetSource()),
			ServiceCode: event.GetServiceCode(), PatientID: event.GetPatientId(),
			EncounterID: event.GetEncounterId(), AccountID: event.GetAccountId(),
			OccurredAt: fromTimestamp(event.GetOccurredAt()),
		})
	}
	return out
}

func policyToProto(p ports.Policy) *billingv1.BillingPolicy {
	limits := make(map[string]*billingv1.DiscountLimit, len(p.DiscountLimits))
	for role, limit := range p.DiscountLimits {
		limits[role] = &billingv1.DiscountLimit{
			MaxRateBp: int32(limit.MaxRate), MaxAmount: moneyToProto(limit.MaxAmount),
		}
	}
	checks := make([]string, 0, len(p.Close.Required))
	for check, required := range p.Close.Required {
		if required {
			checks = append(checks, string(check))
		}
	}
	return &billingv1.BillingPolicy{
		DiscountLimits: limits, CloseChecks: checks,
		AllowPayerBalance:      p.Close.AllowPayerBalance,
		VarianceThresholdMinor: p.Variance.MaxMinor,
		Currency:               p.Currency,
	}
}

func policyFromProto(p *billingv1.BillingPolicy) ports.Policy {
	out := ports.DefaultPolicy()
	if p == nil {
		return out
	}
	if limits := p.GetDiscountLimits(); len(limits) > 0 {
		out.DiscountLimits = make(map[string]domain.DiscountLimit, len(limits))
		for role, limit := range limits {
			out.DiscountLimits[role] = domain.DiscountLimit{
				MaxRate:   domain.BasisPoints(limit.GetMaxRateBp()),
				MaxAmount: moneyFromProto(limit.GetMaxAmount()),
			}
		}
	}
	if checks := p.GetCloseChecks(); len(checks) > 0 {
		required := make(map[domain.CloseCheck]bool, len(checks))
		for _, check := range checks {
			required[domain.CloseCheck(check)] = true
		}
		out.Close.Required = required
	}
	out.Close.AllowPayerBalance = p.GetAllowPayerBalance()
	if threshold := p.GetVarianceThresholdMinor(); threshold > 0 {
		out.Variance = domain.VarianceThreshold{MaxMinor: threshold}
	}
	if currency := p.GetCurrency(); currency != "" {
		out.Currency = currency
	}
	return out
}
