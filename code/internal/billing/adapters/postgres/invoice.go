package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Invoices persists financial documents (SRS-BIL-005, SRS-BIL-006,
// SRS-BIL-010).
//
// Note what this type does not offer: no method edits an issued document's
// lines or totals. That absence is the mechanism behind SRS-BIL-010, and it is
// enforced by there being no such query rather than by a rule somebody has to
// remember.
type Invoices struct{ *Repository }

// NewInvoices constructs the adapter.
func NewInvoices(r *Repository) Invoices { return Invoices{r} }

var _ ports.InvoiceRepository = Invoices{}

// Insert stores a document with its lines.
func (i Invoices) Insert(ctx context.Context, scope authctx.TenantScope,
	inv *domain.Invoice) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(inv.ID)
	if err != nil {
		return err
	}
	accountID, err := lookupUUID(inv.AccountID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(inv.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(inv.EncounterID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(inv.FacilityID)
	if err != nil {
		return err
	}
	corrects, err := optionalUUID(inv.CorrectsInvoiceID)
	if err != nil {
		return err
	}
	discounts, err := toJSON(inv.Discounts)
	if err != nil {
		return err
	}
	liability, err := toJSON(inv.Liability)
	if err != nil {
		return err
	}

	currency := inv.Total.Currency
	if currency == "" {
		currency = inv.Subtotal.Currency
	}

	q := i.queries(ctx)
	if err := q.InsertInvoice(ctx, sqlcgen.InsertInvoiceParams{
		InvoiceID: id, TenantID: tenantID, Number: inv.Number,
		Kind: string(inv.Kind), Status: string(inv.Status),
		AccountID: accountID, PatientID: patientID,
		EncounterID: encounterID, FacilityID: facilityID,
		DocumentVersion: inv.Version, CorrectsInvoiceID: corrects,
		SubtotalMinor: inv.Subtotal.Minor, DiscountMinor: inv.Discount.Minor,
		TaxMinor: inv.Tax.Minor, TotalMinor: inv.Total.Minor, Currency: currency,
		Discounts: discounts, Liability: liability,
		PayerID: inv.PayerID, CustomerID: inv.CustomerID, Notes: inv.Notes,
		IssuedBy: inv.IssuedBy, IssuedAt: timestamptz(inv.IssuedAt),
		CreatedBy: inv.CreatedBy,
		CreatedAt: timestamptz(inv.CreatedAt), UpdatedAt: timestamptz(inv.UpdatedAt),
		RowVersion: inv.RowVersion,
	}); err != nil {
		return err
	}

	for _, line := range inv.Lines {
		chargeID, err := optionalUUID(line.ChargeID)
		if err != nil {
			return err
		}
		lineCurrency := line.Total.Currency
		if lineCurrency == "" {
			lineCurrency = currency
		}
		if err := q.InsertInvoiceLine(ctx, sqlcgen.InsertInvoiceLineParams{
			TenantID: tenantID, InvoiceID: id, Sequence: line.Sequence,
			ChargeID: chargeID, ServiceCode: line.ServiceCode,
			Description: line.Description, Department: line.Department,
			Quantity: line.Quantity, UnitPriceMinor: line.UnitPrice.Minor,
			NetMinor: line.Net.Minor, TaxCode: line.TaxCode,
			TaxRateBp: int32(line.TaxRate), TaxMinor: line.Tax.Minor,
			DiscountMinor: line.Discount.Minor, TotalMinor: line.Total.Minor,
			Currency: lineCurrency, PackageCode: line.PackageCode,
			CoverageNote: line.CoverageNote,
		}); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one document with its lines.
func (i Invoices) Get(ctx context.Context, scope authctx.TenantScope,
	invoiceID string) (*domain.Invoice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(invoiceID)
	if err != nil {
		return nil, err
	}

	row, err := i.queries(ctx).GetInvoice(ctx, sqlcgen.GetInvoiceParams{
		TenantID: tenantID, InvoiceID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return i.hydrate(ctx, tenantID, row)
}

func (i Invoices) hydrate(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.BillingInvoice) (*domain.Invoice, error) {

	inv, err := invoiceFromRow(row)
	if err != nil {
		return nil, err
	}

	lines, err := i.queries(ctx).ListInvoiceLines(ctx, sqlcgen.ListInvoiceLinesParams{
		TenantID: tenantID, InvoiceID: row.InvoiceID,
	})
	if err != nil {
		return nil, err
	}
	for _, line := range lines {
		inv.Lines = append(inv.Lines, domain.InvoiceLine{
			Sequence: line.Sequence, ChargeID: uuidOrEmpty(line.ChargeID),
			ServiceCode: line.ServiceCode, Description: line.Description,
			Department: line.Department, Quantity: line.Quantity,
			UnitPrice: domain.Money{Minor: line.UnitPriceMinor, Currency: line.Currency},
			Net:       domain.Money{Minor: line.NetMinor, Currency: line.Currency},
			TaxCode:   line.TaxCode, TaxRate: domain.BasisPoints(line.TaxRateBp),
			Tax:         domain.Money{Minor: line.TaxMinor, Currency: line.Currency},
			Discount:    domain.Money{Minor: line.DiscountMinor, Currency: line.Currency},
			Total:       domain.Money{Minor: line.TotalMinor, Currency: line.Currency},
			PackageCode: line.PackageCode, CoverageNote: line.CoverageNote,
		})
	}
	return inv, nil
}

func invoiceFromRow(row sqlcgen.BillingInvoice) (*domain.Invoice, error) {
	inv := &domain.Invoice{
		ID: row.InvoiceID.String(), TenantID: row.TenantID.String(),
		Number:    row.Number,
		Kind:      domain.DocumentKind(row.Kind),
		Status:    domain.InvoiceStatus(row.Status),
		AccountID: row.AccountID.String(), PatientID: row.PatientID.String(),
		EncounterID: row.EncounterID.String(), FacilityID: row.FacilityID.String(),
		Version:           row.DocumentVersion,
		SupersededBy:      uuidOrEmpty(row.SupersededBy),
		CorrectsInvoiceID: uuidOrEmpty(row.CorrectsInvoiceID),
		Subtotal:          domain.Money{Minor: row.SubtotalMinor, Currency: row.Currency},
		Discount:          domain.Money{Minor: row.DiscountMinor, Currency: row.Currency},
		Tax:               domain.Money{Minor: row.TaxMinor, Currency: row.Currency},
		Total:             domain.Money{Minor: row.TotalMinor, Currency: row.Currency},
		PayerID:           row.PayerID, CustomerID: row.CustomerID, Notes: row.Notes,
		IssuedBy: row.IssuedBy, IssuedAt: timeOrZero(row.IssuedAt),
		CreatedBy: row.CreatedBy,
		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		RowVersion: row.RowVersion,
	}
	if err := fromJSON(row.Discounts, &inv.Discounts); err != nil {
		return nil, err
	}
	if err := fromJSON(row.Liability, &inv.Liability); err != nil {
		return nil, err
	}
	return inv, nil
}

// ForAccount lists an account's documents.
func (i Invoices) ForAccount(ctx context.Context, scope authctx.TenantScope,
	accountID string, limit int32) ([]*domain.Invoice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := i.queries(ctx).ListInvoicesForAccount(ctx,
		sqlcgen.ListInvoicesForAccountParams{
			TenantID: tenantID, AccountID: id, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return i.hydrateAll(ctx, tenantID, rows)
}

// Drafts lists the unissued documents on an account (SRS-BIL-013).
func (i Invoices) Drafts(ctx context.Context, scope authctx.TenantScope,
	accountID string) ([]*domain.Invoice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := i.queries(ctx).ListDraftInvoices(ctx, sqlcgen.ListDraftInvoicesParams{
		TenantID: tenantID, AccountID: id,
	})
	if err != nil {
		return nil, err
	}
	return i.hydrateAll(ctx, tenantID, rows)
}

func (i Invoices) hydrateAll(ctx context.Context, tenantID uuid.UUID,
	rows []sqlcgen.BillingInvoice) ([]*domain.Invoice, error) {

	out := make([]*domain.Invoice, 0, len(rows))
	for _, row := range rows {
		inv, err := i.hydrate(ctx, tenantID, row)
		if err != nil {
			return nil, err
		}
		out = append(out, inv)
	}
	return out, nil
}

// Issue finalises a document (SRS-BIL-006, SRS-BIL-010).
//
// Guarded on the document still being a draft, so it cannot be issued twice and
// cannot be issued after it has been superseded. The lines are already stored
// and are not touched: what this writes is the status, the totals and the
// liability split, and after it nothing about the document changes again.
func (i Invoices) Issue(ctx context.Context, scope authctx.TenantScope,
	inv *domain.Invoice, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(inv.ID)
	if err != nil {
		return err
	}
	discounts, err := toJSON(inv.Discounts)
	if err != nil {
		return err
	}
	liability, err := toJSON(inv.Liability)
	if err != nil {
		return err
	}

	affected, err := i.queries(ctx).IssueInvoice(ctx, sqlcgen.IssueInvoiceParams{
		IssuedBy: inv.IssuedBy, IssuedAt: timestamptz(inv.IssuedAt),
		SubtotalMinor: inv.Subtotal.Minor, DiscountMinor: inv.Discount.Minor,
		TaxMinor: inv.Tax.Minor, TotalMinor: inv.Total.Minor,
		Discounts: discounts, Liability: liability,
		UpdatedAt: timestamptz(inv.UpdatedAt), RowVersion: inv.RowVersion,
		TenantID: tenantID, InvoiceID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// Supersede marks an estimate or interim bill replaced.
func (i Invoices) Supersede(ctx context.Context, scope authctx.TenantScope,
	inv *domain.Invoice, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(inv.ID)
	if err != nil {
		return err
	}
	supersededBy, err := optionalUUID(inv.SupersededBy)
	if err != nil {
		return err
	}

	affected, err := i.queries(ctx).SupersedeInvoice(ctx, sqlcgen.SupersedeInvoiceParams{
		SupersededBy: supersededBy,
		UpdatedAt:    timestamptz(inv.UpdatedAt), RowVersion: inv.RowVersion,
		TenantID: tenantID, InvoiceID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}
