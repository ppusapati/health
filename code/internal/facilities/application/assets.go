package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// RegisterAssetInput registers a piece of facilities plant (SRS-FAC-001).
type RegisterAssetInput struct {
	Tag            string
	Name           string
	System         string
	Criticality    string
	ParentID       string
	FacilityID     string
	LocationID     string
	LocationNote   string
	Manufacturer   string
	Model          string
	SerialNumber   string
	CommissionedAt string
}

// RegisterAsset registers a facilities asset (SRS-FAC-001).
func (s *Service) RegisterAsset(ctx context.Context, in RegisterAssetInput) (
	domain.Asset, error) {

	session, scope, err := s.authorize(ctx, PermAssetManage)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	commissioned, err := parseTime(in.CommissionedAt)
	if err != nil {
		return domain.Asset{}, err
	}

	var out domain.Asset
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.checkOrgUnit(ctx, scope, in.LocationID); err != nil {
			return err
		}
		if in.ParentID != "" {
			// A parent nobody can resolve makes a hierarchy with a
			// branch that leads nowhere, which is worse than a flat
			// list because it looks complete.
			if _, err := s.assets.Asset(ctx, scope,
				in.ParentID); err != nil {
				return err
			}
		}

		asset, err := domain.NewAsset(s.ids.NewID(), session.TenantID,
			domain.NewAssetInput{
				Tag: in.Tag, Name: in.Name,
				System:       domain.System(in.System),
				Criticality:  domain.Criticality(in.Criticality),
				ParentID:     in.ParentID,
				FacilityID:   in.FacilityID,
				LocationID:   in.LocationID,
				LocationNote: in.LocationNote,
				Manufacturer: in.Manufacturer, Model: in.Model,
				SerialNumber:   in.SerialNumber,
				CommissionedAt: commissioned,
			}, session.SubjectID, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.assets.InsertAsset(ctx, scope, asset); err != nil {
			return err
		}
		out = asset
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.asset.registered",
			ResourceType: "facilities.asset", ResourceID: asset.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"tag": asset.Tag, "system": string(asset.System),
				"criticality": string(asset.Criticality),
			}),
		}, now)
	})
	if err != nil {
		return domain.Asset{}, err
	}
	return out, nil
}

// SetAssetStatusInput moves an asset between service states.
type SetAssetStatusInput struct {
	AssetID string
	Status  string
	Reason  string
	Version int64
}

// SetAssetStatus records plant going down, degraded or back in service
// (SRS-FAC-001).
func (s *Service) SetAssetStatus(ctx context.Context,
	in SetAssetStatusInput) (domain.Asset, error) {

	session, scope, err := s.authorize(ctx, PermAssetManage)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	var out domain.Asset
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		before := asset.Status
		if err := asset.SetStatus(domain.AssetStatus(in.Status),
			in.Reason, now); err != nil {
			return facilitiesError(err)
		}
		versionSeen := expected(in.Version, asset.Version)
		if err := s.assets.UpdateAssetStatus(ctx, scope, asset,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		asset.Version = applied(versionSeen)
		out = asset
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.asset.status_changed",
			ResourceType: "facilities.asset", ResourceID: asset.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"from": string(before), "to": string(asset.Status),
			}),
			Reason: asset.StatusReason,
		}, now)
	})
	if err != nil {
		return domain.Asset{}, err
	}
	return out, nil
}

// AssetFilterInput narrows an asset list.
type AssetFilterInput struct {
	FacilityID string
	System     string
	Status     string
	ParentID   string
	PageSize   int32
}

// ListAssets reads the plant register (SRS-FAC-001).
func (s *Service) ListAssets(ctx context.Context, in AssetFilterInput) (
	[]domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.assets.Assets(ctx, scope, ports.AssetFilter{
		FacilityID: in.FacilityID,
		System:     domain.System(in.System),
		Status:     domain.AssetStatus(in.Status),
		ParentID:   in.ParentID,
		Limit:      clampPageSize(in.PageSize),
	})
}

// GetAsset reads one asset (SRS-FAC-001).
func (s *Service) GetAsset(ctx context.Context, assetID string) (
	domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Asset{}, err
	}
	return s.assets.Asset(ctx, scope, assetID)
}

// AssetTree reads an asset and everything under it (SRS-FAC-001).
//
// The hierarchy the requirement asks for, answered from the parent column
// rather than from a second structure that could disagree with it.
func (s *Service) AssetTree(ctx context.Context, rootID string) (
	[]domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	if _, err := s.assets.Asset(ctx, scope, rootID); err != nil {
		return nil, err
	}
	all, err := s.assets.Assets(ctx, scope,
		ports.AssetFilter{Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.Descendants(all, rootID), nil
}

// DownAssets lists plant that is not working, most critical first
// (SRS-FAC-001).
func (s *Service) DownAssets(ctx context.Context, facilityID string) (
	[]domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	all, err := s.assets.Assets(ctx, scope, ports.AssetFilter{
		FacilityID: facilityID, Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.CriticalDown(all), nil
}

// SetWorkClassInput configures a class of maintenance work (SRS-FAC-010).
type SetWorkClassInput struct {
	Code           string
	Name           string
	RequiresPermit bool
	RequiresLOTO   bool
	Active         bool
	Note           string
}

// SetWorkClass writes a work class (SRS-FAC-010).
//
// Held behind PermPermit rather than PermAssetManage, because deciding which
// work needs a permit is the same decision as being allowed to do that work
// — and a deployment that let the estates clerk turn the flag off would have
// no permit system at all.
func (s *Service) SetWorkClass(ctx context.Context, in SetWorkClassInput) (
	domain.WorkClass, error) {

	session, scope, err := s.authorize(ctx, PermPermit)
	if err != nil {
		return domain.WorkClass{}, err
	}
	now := s.clock.Now()

	class := domain.WorkClass{
		TenantID: session.TenantID, Code: in.Code, Name: in.Name,
		RequiresPermit: in.RequiresPermit, RequiresLOTO: in.RequiresLOTO,
		Active: in.Active, Note: in.Note,
	}
	if err := class.Validate(); err != nil {
		return domain.WorkClass{}, facilitiesError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.classes.UpsertWorkClass(ctx, scope, class); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.work_class.set",
			ResourceType: "facilities.work_class", ResourceID: class.Code,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"requires_permit": boolText(class.RequiresPermit),
				"requires_loto":   boolText(class.RequiresLOTO),
				"active":          boolText(class.Active),
			}),
			Reason: class.Note,
		}, now)
	})
	if err != nil {
		return domain.WorkClass{}, err
	}
	return class, nil
}

// ListWorkClasses reads the configured classes (SRS-FAC-010).
func (s *Service) ListWorkClasses(ctx context.Context) (
	[]domain.WorkClass, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.classes.WorkClasses(ctx, scope)
}
