package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Master persists the charge master, tariffs and packages (SRS-BIL-001,
// SRS-BIL-002, SRS-BIL-004).
type Master struct{ *Repository }

// NewMaster constructs the adapter.
func NewMaster(r *Repository) Master { return Master{r} }

var _ ports.MasterRepository = Master{}

// PublishService ends the current version and starts a new one (SRS-BIL-001).
//
// One act, so there is never a moment with two versions in force or none. The
// exclusion constraint on the table would refuse the overlap anyway; doing the
// close first means the caller sees an ordinary version-conflict rather than a
// constraint name.
func (m Master) PublishService(ctx context.Context, scope authctx.TenantScope,
	item domain.ServiceItem) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	q := m.queries(ctx)
	if _, err := q.CloseServiceVersion(ctx, sqlcgen.CloseServiceVersionParams{
		EffectiveTo: timestamptz(item.EffectiveFrom),
		UpdatedBy:   item.UpdatedBy, UpdatedAt: timestamptz(item.UpdatedAt),
		TenantID: tenantID, Code: item.Code,
	}); err != nil {
		return err
	}

	return q.UpsertServiceItem(ctx, sqlcgen.UpsertServiceItemParams{
		TenantID: tenantID, Code: item.Code, Description: item.Description,
		Department: item.Department, RevenueAccount: item.RevenueAccount,
		TaxCode: item.TaxCode, TaxRateBp: int32(item.TaxRate),
		TaxInclusive:  item.TaxInclusive,
		EffectiveFrom: timestamptz(item.EffectiveFrom),
		EffectiveTo:   timestamptz(item.EffectiveTo),
		UpdatedBy:     item.UpdatedBy, UpdatedAt: timestamptz(item.UpdatedAt),
	})
}

// ServiceVersions returns every version of a code, newest first.
func (m Master) ServiceVersions(ctx context.Context, scope authctx.TenantScope,
	code string) ([]domain.ServiceItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := m.queries(ctx).ListServiceVersions(ctx,
		sqlcgen.ListServiceVersionsParams{TenantID: tenantID, Code: code})
	if err != nil {
		return nil, err
	}
	return serviceItems(rows), nil
}

// Services lists the master.
func (m Master) Services(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.ServiceItem, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := m.queries(ctx).ListServiceItems(ctx, sqlcgen.ListServiceItemsParams{
		TenantID: tenantID, RowLimit: capLimit(limit),
	})
	if err != nil {
		return nil, err
	}
	return serviceItems(rows), nil
}

func serviceItems(rows []sqlcgen.BillingServiceItem) []domain.ServiceItem {
	out := make([]domain.ServiceItem, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ServiceItem{
			TenantID: row.TenantID.String(), Code: row.Code,
			Description: row.Description, Department: row.Department,
			RevenueAccount: row.RevenueAccount,
			TaxCode:        row.TaxCode, TaxRate: domain.BasisPoints(row.TaxRateBp),
			TaxInclusive:  row.TaxInclusive,
			EffectiveFrom: timeOrZero(row.EffectiveFrom),
			EffectiveTo:   timeOrZero(row.EffectiveTo),
			UpdatedBy:     row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
		})
	}
	return out
}

// UpsertTariff records a negotiated price (SRS-BIL-002).
func (m Master) UpsertTariff(ctx context.Context, scope authctx.TenantScope,
	lineID string, line domain.TariffLine) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(lineID)
	if err != nil {
		return err
	}

	return m.queries(ctx).UpsertTariffLine(ctx, sqlcgen.UpsertTariffLineParams{
		TariffLineID: id, TenantID: tenantID,
		ContractID: line.ContractID, Name: line.Name,
		PayerID: line.Scope.PayerID, CustomerID: line.Scope.CustomerID,
		FacilityID: line.Scope.FacilityID, RoomClass: line.Scope.RoomClass,
		ServiceCode: line.Scope.ServiceCode,
		PriceMinor:  line.Price.Minor, Currency: line.Price.Currency,
		Priority:      line.Priority,
		EffectiveFrom: timestamptz(line.EffectiveFrom),
		EffectiveTo:   timestamptz(line.EffectiveTo),
		UpdatedBy:     line.UpdatedBy, UpdatedAt: timestamptz(line.UpdatedAt),
	})
}

// TariffsFor returns everything that could price a service (SRS-BIL-002).
func (m Master) TariffsFor(ctx context.Context, scope authctx.TenantScope,
	serviceCode string) ([]domain.TariffLine, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := m.queries(ctx).ListTariffLinesForService(ctx,
		sqlcgen.ListTariffLinesForServiceParams{
			TenantID: tenantID, ServiceCode: serviceCode,
		})
	if err != nil {
		return nil, err
	}
	return tariffLines(rows), nil
}

// Tariffs lists every contract line.
func (m Master) Tariffs(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.TariffLine, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := m.queries(ctx).ListTariffLines(ctx, sqlcgen.ListTariffLinesParams{
		TenantID: tenantID, RowLimit: capLimit(limit),
	})
	if err != nil {
		return nil, err
	}
	return tariffLines(rows), nil
}

func tariffLines(rows []sqlcgen.BillingTariffLine) []domain.TariffLine {
	out := make([]domain.TariffLine, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.TariffLine{
			TenantID:   row.TenantID.String(),
			ContractID: row.ContractID, Name: row.Name,
			Scope: domain.TariffScope{
				PayerID: row.PayerID, CustomerID: row.CustomerID,
				FacilityID: row.FacilityID, RoomClass: row.RoomClass,
				ServiceCode: row.ServiceCode,
			},
			Price:         domain.Money{Minor: row.PriceMinor, Currency: row.Currency},
			Priority:      row.Priority,
			EffectiveFrom: timeOrZero(row.EffectiveFrom),
			EffectiveTo:   timeOrZero(row.EffectiveTo),
			UpdatedBy:     row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
		})
	}
	return out
}

// PublishPackage records a bundle (SRS-BIL-004).
func (m Master) PublishPackage(ctx context.Context, scope authctx.TenantScope,
	p domain.Package) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	inclusions, err := toJSON(p.Inclusions)
	if err != nil {
		return err
	}
	exclusions, err := toJSON(orEmptyString(p.Exclusions))
	if err != nil {
		return err
	}
	carveOuts, err := toJSON(p.CarveOuts)
	if err != nil {
		return err
	}

	return m.queries(ctx).UpsertPackage(ctx, sqlcgen.UpsertPackageParams{
		TenantID: tenantID, Code: p.Code, Name: p.Name,
		PriceMinor: p.Price.Minor, Currency: p.Price.Currency,
		RoomClass:  p.RoomClass,
		Inclusions: inclusions, Exclusions: exclusions, CarveOuts: carveOuts,
		EffectiveFrom: timestamptz(p.EffectiveFrom),
		EffectiveTo:   timestamptz(p.EffectiveTo),
		UpdatedBy:     p.UpdatedBy, UpdatedAt: timestamptz(p.UpdatedAt),
	})
}

// PackageAt reads the version of a package in force at a moment.
func (m Master) PackageAt(ctx context.Context, scope authctx.TenantScope,
	code string, at time.Time) (domain.Package, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Package{}, err
	}

	row, err := m.queries(ctx).GetPackage(ctx, sqlcgen.GetPackageParams{
		TenantID: tenantID, Code: code, At: timestamptz(at),
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return domain.Package{}, notFound()
		}
		return domain.Package{}, err
	}
	return packageFromRow(row)
}

// Packages lists the bundles.
func (m Master) Packages(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Package, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := m.queries(ctx).ListPackages(ctx, sqlcgen.ListPackagesParams{
		TenantID: tenantID, RowLimit: capLimit(limit),
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Package, 0, len(rows))
	for _, row := range rows {
		p, err := packageFromRow(row)
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	return out, nil
}

func packageFromRow(row sqlcgen.BillingPackage) (domain.Package, error) {
	p := domain.Package{
		TenantID: row.TenantID.String(), Code: row.Code, Name: row.Name,
		Price:         domain.Money{Minor: row.PriceMinor, Currency: row.Currency},
		RoomClass:     row.RoomClass,
		EffectiveFrom: timeOrZero(row.EffectiveFrom),
		EffectiveTo:   timeOrZero(row.EffectiveTo),
		UpdatedBy:     row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
	}
	if err := fromJSON(row.Inclusions, &p.Inclusions); err != nil {
		return domain.Package{}, err
	}
	if err := fromJSON(row.Exclusions, &p.Exclusions); err != nil {
		return domain.Package{}, err
	}
	if err := fromJSON(row.CarveOuts, &p.CarveOuts); err != nil {
		return domain.Package{}, err
	}
	return p, nil
}
