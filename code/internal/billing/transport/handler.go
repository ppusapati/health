// Package transport serves healthcare.billing.v1.BillingService.
package transport

import (
	"context"

	"connectrpc.com/connect"
	billingv1 "github.com/ppusapati/health/code/gen/go/healthcare/billing/v1"
	"github.com/ppusapati/health/code/internal/billing/application"
	"github.com/ppusapati/health/code/internal/billing/domain"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.billing.v1.BillingService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err,
		platformtransport.CorrelationIDFromContext(ctx))
}

// OpenAccount starts an encounter's financial record (SRS-BIL-013).
func (h *Handler) OpenAccount(
	ctx context.Context,
	req *connect.Request[billingv1.OpenAccountRequest],
) (*connect.Response[billingv1.OpenAccountResponse], error) {
	msg := req.Msg
	account, err := h.svc.OpenAccount(ctx, application.OpenAccountInput{
		EncounterID: msg.GetEncounterId(), PatientID: msg.GetPatientId(),
		Currency: msg.GetCurrency(),
		PayerID:  msg.GetPayerId(), CustomerID: msg.GetCustomerId(),
		RoomClass: msg.GetRoomClass(), PackageCode: msg.GetPackageCode(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.OpenAccountResponse{
		Account: accountToProto(account),
	}), nil
}

// GetAccount reads one account by either identifier.
func (h *Handler) GetAccount(
	ctx context.Context,
	req *connect.Request[billingv1.GetAccountRequest],
) (*connect.Response[billingv1.GetAccountResponse], error) {
	msg := req.Msg

	var account *domain.Account
	var err error
	if msg.GetAccountId() != "" {
		account, err = h.svc.Account(ctx, msg.GetAccountId())
	} else {
		account, err = h.svc.AccountForEncounter(ctx, msg.GetEncounterId())
	}
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.GetAccountResponse{
		Account: accountToProto(account),
	}), nil
}

// PostCharge raises a charge (SRS-BIL-003, SRS-BIL-004).
//
// Idempotent on the source reference: a redelivered clinical event comes back
// with already_posted and the charge that was already there.
func (h *Handler) PostCharge(
	ctx context.Context,
	req *connect.Request[billingv1.PostChargeRequest],
) (*connect.Response[billingv1.PostChargeResponse], error) {
	msg := req.Msg
	result, err := h.svc.PostCharge(ctx, application.PostChargeInput{
		AccountID: msg.GetAccountId(), ServiceCode: msg.GetServiceCode(),
		Quantity:   msg.GetQuantity(),
		Origin:     chargeOriginFromProto[msg.GetOrigin()],
		Source:     sourceFromProto(msg.GetSource()),
		Reason:     msg.GetReason(),
		OccurredAt: fromTimestamp(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}

	out := &billingv1.PostChargeResponse{
		Charge: chargeToProto(result.Charge), AlreadyPosted: result.AlreadyPosted,
	}
	if result.Consumption != nil {
		out.Consumption = consumptionToProto(*result.Consumption)
	}
	return connect.NewResponse(out), nil
}

// VoidCharge marks a charge raised in error (SRS-BIL-010).
func (h *Handler) VoidCharge(
	ctx context.Context,
	req *connect.Request[billingv1.VoidChargeRequest],
) (*connect.Response[billingv1.VoidChargeResponse], error) {
	change := req.Msg.GetChange()
	charge, err := h.svc.VoidCharge(ctx, change.GetChargeId(), change.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.VoidChargeResponse{
		Charge: chargeToProto(charge),
	}), nil
}

// HoldCharge parks a charge pending a query (SRS-BIL-011).
func (h *Handler) HoldCharge(
	ctx context.Context,
	req *connect.Request[billingv1.HoldChargeRequest],
) (*connect.Response[billingv1.HoldChargeResponse], error) {
	change := req.Msg.GetChange()
	charge, err := h.svc.HoldCharge(ctx, change.GetChargeId(), change.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.HoldChargeResponse{
		Charge: chargeToProto(charge),
	}), nil
}

// ReleaseCharge returns a held charge to the billable set.
func (h *Handler) ReleaseCharge(
	ctx context.Context,
	req *connect.Request[billingv1.ReleaseChargeRequest],
) (*connect.Response[billingv1.ReleaseChargeResponse], error) {
	charge, err := h.svc.ReleaseCharge(ctx, req.Msg.GetChange().GetChargeId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.ReleaseChargeResponse{
		Charge: chargeToProto(charge),
	}), nil
}

// ListCharges reads an account's charges.
func (h *Handler) ListCharges(
	ctx context.Context,
	req *connect.Request[billingv1.ListChargesRequest],
) (*connect.Response[billingv1.ListChargesResponse], error) {
	msg := req.Msg
	list, err := h.svc.Charges(ctx, msg.GetAccountId(), msg.GetBillableOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.ListChargesResponse{
		Charges: chargesToProto(list),
	}), nil
}

// PackageLedger explains what a package billed and did not (SRS-BIL-004).
func (h *Handler) PackageLedger(
	ctx context.Context,
	req *connect.Request[billingv1.PackageLedgerRequest],
) (*connect.Response[billingv1.PackageLedgerResponse], error) {
	entries, err := h.svc.PackageLedger(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.Consumption, 0, len(entries))
	for _, entry := range entries {
		out = append(out, consumptionToProto(entry))
	}
	return connect.NewResponse(&billingv1.PackageLedgerResponse{Entries: out}), nil
}

// RaiseInvoice builds a document from the charge ledger (SRS-BIL-005,
// SRS-BIL-006, SRS-BIL-007, SRS-BIL-014).
func (h *Handler) RaiseInvoice(
	ctx context.Context,
	req *connect.Request[billingv1.RaiseInvoiceRequest],
) (*connect.Response[billingv1.RaiseInvoiceResponse], error) {
	msg := req.Msg
	invoice, err := h.svc.RaiseInvoice(ctx, application.RaiseInvoiceInput{
		AccountID: msg.GetAccountId(), Kind: kindFromProto[msg.GetKind()],
		Discount:  discountFromProto(msg.GetDiscount()),
		Liability: liabilityFromProto(msg.GetLiability()),
		Notes:     msg.GetNotes(), Issue: msg.GetIssue(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.RaiseInvoiceResponse{
		Invoice: invoiceToProto(invoice),
	}), nil
}

// CorrectInvoice raises a credit or debit note (SRS-BIL-010).
func (h *Handler) CorrectInvoice(
	ctx context.Context,
	req *connect.Request[billingv1.CorrectInvoiceRequest],
) (*connect.Response[billingv1.CorrectInvoiceResponse], error) {
	msg := req.Msg
	lines := make([]domain.InvoiceLine, 0, len(msg.GetLines()))
	for _, line := range msg.GetLines() {
		lines = append(lines, lineFromProto(line))
	}

	note, err := h.svc.CorrectInvoice(ctx, application.CorrectInvoiceInput{
		InvoiceID: msg.GetInvoiceId(), Kind: kindFromProto[msg.GetKind()],
		Lines: lines, Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.CorrectInvoiceResponse{
		Note: invoiceToProto(note),
	}), nil
}

// GetInvoice reads one document.
func (h *Handler) GetInvoice(
	ctx context.Context,
	req *connect.Request[billingv1.GetInvoiceRequest],
) (*connect.Response[billingv1.GetInvoiceResponse], error) {
	invoice, err := h.svc.Invoice(ctx, req.Msg.GetInvoiceId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.GetInvoiceResponse{
		Invoice: invoiceToProto(invoice),
	}), nil
}

// ListInvoices reads an account's documents.
func (h *Handler) ListInvoices(
	ctx context.Context,
	req *connect.Request[billingv1.ListInvoicesRequest],
) (*connect.Response[billingv1.ListInvoicesResponse], error) {
	list, err := h.svc.Invoices(ctx, req.Msg.GetAccountId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.Invoice, 0, len(list))
	for _, invoice := range list {
		out = append(out, invoiceToProto(invoice))
	}
	return connect.NewResponse(&billingv1.ListInvoicesResponse{Invoices: out}), nil
}

// ReceivePayment takes money (SRS-BIL-008).
func (h *Handler) ReceivePayment(
	ctx context.Context,
	req *connect.Request[billingv1.ReceivePaymentRequest],
) (*connect.Response[billingv1.ReceivePaymentResponse], error) {
	msg := req.Msg
	result, err := h.svc.ReceivePayment(ctx, application.ReceivePaymentInput{
		AccountID: msg.GetAccountId(), Amount: moneyFromProto(msg.GetAmount()),
		Method:      methodFromProto[msg.GetMethod()],
		ProviderRef: msg.GetProviderRef(), InvoiceID: msg.GetInvoiceId(),
		ShiftID: msg.GetShiftId(), IdempotencyKey: msg.GetIdempotencyKey(),
		Deposit: msg.GetDeposit(), Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.ReceivePaymentResponse{
		Entry:           ledgerEntryToProto(result.Entry),
		AlreadyReceived: result.AlreadyReceived,
		Balance:         moneyToProto(result.Balance),
	}), nil
}

// Refund returns money against an original payment (SRS-BIL-009).
func (h *Handler) Refund(
	ctx context.Context,
	req *connect.Request[billingv1.RefundRequest],
) (*connect.Response[billingv1.RefundResponse], error) {
	msg := req.Msg
	entry, err := h.svc.Refund(ctx, application.RefundInput{
		AccountID: msg.GetAccountId(), PaymentID: msg.GetPaymentId(),
		Amount: moneyFromProto(msg.GetAmount()), Reason: msg.GetReason(),
		ShiftID: msg.GetShiftId(), ApprovedBy: msg.GetApprovedBy(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.RefundResponse{
		Entry: ledgerEntryToProto(entry),
	}), nil
}

// Statement reads an account's ledger and its derived balance (SRS-BIL-012).
func (h *Handler) Statement(
	ctx context.Context,
	req *connect.Request[billingv1.StatementRequest],
) (*connect.Response[billingv1.StatementResponse], error) {
	statement, err := h.svc.Statement(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, fail(ctx, err)
	}

	entries := make([]*billingv1.LedgerEntry, 0, len(statement.Entries))
	for _, entry := range statement.Entries {
		entries = append(entries, ledgerEntryToProto(entry))
	}
	return connect.NewResponse(&billingv1.StatementResponse{
		Account: accountToProto(statement.Account), Entries: entries,
		Balance:  moneyToProto(statement.Balance),
		Deposits: moneyToProto(statement.Deposits),
	}), nil
}

// CloseAccount settles an account (SRS-BIL-013).
//
// A refusal comes back as a FAILED_PRECONDITION whose field violations carry
// every exception, so a biller sees the whole list rather than fixing one thing
// and being told about the next.
func (h *Handler) CloseAccount(
	ctx context.Context,
	req *connect.Request[billingv1.CloseAccountRequest],
) (*connect.Response[billingv1.CloseAccountResponse], error) {
	account, err := h.svc.CloseAccount(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.CloseAccountResponse{
		Account: accountToProto(account),
	}), nil
}

// CloseReadiness reports what stands in the way without attempting the close
// (SRS-BIL-013).
func (h *Handler) CloseReadiness(
	ctx context.Context,
	req *connect.Request[billingv1.CloseReadinessRequest],
) (*connect.Response[billingv1.CloseReadinessResponse], error) {
	exceptions, err := h.svc.CloseReadiness(ctx, req.Msg.GetAccountId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.CloseReadinessResponse{
		Exceptions: exceptionsToProto(exceptions),
	}), nil
}

// RevenueIntegrity is the worklist of what has not been billed (SRS-BIL-011).
func (h *Handler) RevenueIntegrity(
	ctx context.Context,
	req *connect.Request[billingv1.RevenueIntegrityRequest],
) (*connect.Response[billingv1.RevenueIntegrityResponse], error) {
	msg := req.Msg
	exceptions, err := h.svc.RevenueIntegrity(ctx, msg.GetFacilityId(),
		billableEventsFromProto(msg.GetEvents()), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.RevenueIntegrityResponse{
		Exceptions: revenueExceptionsToProto(exceptions),
	}), nil
}

// OpenShift starts a cashier's session (SRS-BIL-015).
func (h *Handler) OpenShift(
	ctx context.Context,
	req *connect.Request[billingv1.OpenShiftRequest],
) (*connect.Response[billingv1.OpenShiftResponse], error) {
	msg := req.Msg
	shift, err := h.svc.OpenShift(ctx, msg.GetFacilityId(), msg.GetCounterId(),
		moneyFromProto(msg.GetOpeningFloat()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.OpenShiftResponse{
		Shift: shiftToProto(shift),
	}), nil
}

// CloseShift counts a drawer (SRS-BIL-015).
func (h *Handler) CloseShift(
	ctx context.Context,
	req *connect.Request[billingv1.CloseShiftRequest],
) (*connect.Response[billingv1.CloseShiftResponse], error) {
	msg := req.Msg
	shift, err := h.svc.CloseShift(ctx, msg.GetShiftId(),
		moneyFromProto(msg.GetCounted()), msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.CloseShiftResponse{
		Shift: shiftToProto(shift),
	}), nil
}

// ApproveShift signs off a variance beyond the threshold (SRS-BIL-015).
func (h *Handler) ApproveShift(
	ctx context.Context,
	req *connect.Request[billingv1.ApproveShiftRequest],
) (*connect.Response[billingv1.ApproveShiftResponse], error) {
	shift, err := h.svc.ApproveShift(ctx, req.Msg.GetShiftId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.ApproveShiftResponse{
		Shift: shiftToProto(shift),
	}), nil
}

// ListShifts reads a facility's cashier sessions.
func (h *Handler) ListShifts(
	ctx context.Context,
	req *connect.Request[billingv1.ListShiftsRequest],
) (*connect.Response[billingv1.ListShiftsResponse], error) {
	list, err := h.svc.Shifts(ctx, req.Msg.GetFacilityId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.Shift, 0, len(list))
	for _, shift := range list {
		out = append(out, shiftToProto(shift))
	}
	return connect.NewResponse(&billingv1.ListShiftsResponse{Shifts: out}), nil
}

// PublishService adds a version to the charge master (SRS-BIL-001).
func (h *Handler) PublishService(
	ctx context.Context,
	req *connect.Request[billingv1.PublishServiceRequest],
) (*connect.Response[billingv1.PublishServiceResponse], error) {
	if err := h.svc.PublishService(ctx,
		serviceItemFromProto(req.Msg.GetItem())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.PublishServiceResponse{}), nil
}

// ListServices reads the charge master.
func (h *Handler) ListServices(
	ctx context.Context,
	req *connect.Request[billingv1.ListServicesRequest],
) (*connect.Response[billingv1.ListServicesResponse], error) {
	items, err := h.svc.Services(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.ServiceItem, 0, len(items))
	for _, item := range items {
		out = append(out, serviceItemToProto(item))
	}
	return connect.NewResponse(&billingv1.ListServicesResponse{Items: out}), nil
}

// PublishTariff records a negotiated price (SRS-BIL-002).
func (h *Handler) PublishTariff(
	ctx context.Context,
	req *connect.Request[billingv1.PublishTariffRequest],
) (*connect.Response[billingv1.PublishTariffResponse], error) {
	line := req.Msg.GetLine()
	if err := h.svc.PublishTariff(ctx, line.GetTariffLineId(),
		tariffFromProto(line)); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.PublishTariffResponse{}), nil
}

// ListTariffs reads the contract lines.
func (h *Handler) ListTariffs(
	ctx context.Context,
	req *connect.Request[billingv1.ListTariffsRequest],
) (*connect.Response[billingv1.ListTariffsResponse], error) {
	lines, err := h.svc.Tariffs(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.TariffLine, 0, len(lines))
	for _, line := range lines {
		out = append(out, tariffToProto(line))
	}
	return connect.NewResponse(&billingv1.ListTariffsResponse{Lines: out}), nil
}

// Quote prices a service without charging for it (SRS-BIL-002, SRS-BIL-005).
func (h *Handler) Quote(
	ctx context.Context,
	req *connect.Request[billingv1.QuoteRequest],
) (*connect.Response[billingv1.QuoteResponse], error) {
	pricing, err := h.svc.Quote(ctx, req.Msg.GetAccountId(),
		req.Msg.GetServiceCode())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.QuoteResponse{
		Pricing: pricingToProto(pricing),
	}), nil
}

// PublishPackage records a bundle (SRS-BIL-004).
func (h *Handler) PublishPackage(
	ctx context.Context,
	req *connect.Request[billingv1.PublishPackageRequest],
) (*connect.Response[billingv1.PublishPackageResponse], error) {
	if err := h.svc.PublishPackage(ctx,
		packageFromProto(req.Msg.GetPackage())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.PublishPackageResponse{}), nil
}

// ListPackages reads the bundles.
func (h *Handler) ListPackages(
	ctx context.Context,
	req *connect.Request[billingv1.ListPackagesRequest],
) (*connect.Response[billingv1.ListPackagesResponse], error) {
	packages, err := h.svc.Packages(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*billingv1.Package, 0, len(packages))
	for _, p := range packages {
		out = append(out, packageToProto(p))
	}
	return connect.NewResponse(&billingv1.ListPackagesResponse{Packages: out}), nil
}

// SetBillingPolicy records the tenant's configuration.
func (h *Handler) SetBillingPolicy(
	ctx context.Context,
	req *connect.Request[billingv1.SetBillingPolicyRequest],
) (*connect.Response[billingv1.SetBillingPolicyResponse], error) {
	if err := h.svc.SetPolicy(ctx, policyFromProto(req.Msg.GetPolicy())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.SetBillingPolicyResponse{}), nil
}

// GetBillingPolicy reads the tenant's configuration.
func (h *Handler) GetBillingPolicy(
	ctx context.Context,
	req *connect.Request[billingv1.GetBillingPolicyRequest],
) (*connect.Response[billingv1.GetBillingPolicyResponse], error) {
	p, err := h.svc.Policy(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&billingv1.GetBillingPolicyResponse{
		Policy: policyToProto(p),
	}), nil
}
