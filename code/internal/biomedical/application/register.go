package application

import (
	"context"
	"encoding/json"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RegisterAsset records a piece of equipment (SRS-BIO-001).
func (s *Service) RegisterAsset(ctx context.Context, in domain.NewAssetInput) (
	domain.Asset, error) {

	session, scope, err := s.authorize(ctx, PermRegister)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	asset, err := domain.NewAsset(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The tag is unique per tenant in the schema. Asking first turns the
		// race into a message an engineer can act on, and the index still
		// refuses the one that slipped through.
		if _, taken, err := s.assets.AssetByTag(ctx, scope, asset.Tag); err != nil {
			return err
		} else if taken {
			return rpcerr.AlreadyExists("BIO_TAG_TAKEN",
				"asset tag "+asset.Tag+" is already in use")
		}
		if err := s.assets.InsertAsset(ctx, scope, asset); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.asset.register", ResourceType: "biomedical_asset",
			ResourceID: asset.ID, Outcome: audit.OutcomeSuccess,
			Reason: "registered " + asset.Tag,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventAssetRegistered,
			"biomedical_asset", asset.ID, map[string]any{
				"asset_id":    asset.ID,
				"tag":         asset.Tag,
				"category":    asset.Category,
				"criticality": string(asset.Criticality),
				"location_id": asset.LocationID,
			}, now); err != nil {
			return err
		}
		return s.publishCapabilities(ctx, session, scope, asset.LocationID, now)
	})
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	return asset, nil
}

// Asset reads one record.
func (s *Service) Asset(ctx context.Context, id string) (domain.Asset, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Asset{}, err
	}
	asset, err := s.assets.Asset(ctx, scope, id)
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	return asset, nil
}

// AssetByTag resolves the number on the sticker, which is what somebody
// reporting a fault reads out.
func (s *Service) AssetByTag(ctx context.Context, tag string) (
	domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Asset{}, err
	}
	asset, found, err := s.assets.AssetByTag(ctx, scope, tag)
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	if !found {
		return domain.Asset{}, rpcerr.NotFound("BIO_NOT_FOUND",
			"no asset carries that tag")
	}
	return asset, nil
}

// AssetFilter narrows the register.
type AssetFilter struct {
	Category string
	Status   string
	// ExcludeRetired drops decommissioned and disposed equipment, which is
	// what a working list wants and an audit does not.
	ExcludeRetired bool
	PageSize       int32
}

// Assets lists the register.
func (s *Service) Assets(ctx context.Context, f AssetFilter) (
	[]domain.Asset, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	assets, err := s.assets.Assets(ctx, scope, f.Category, f.Status,
		f.ExcludeRetired, clampPageSize(f.PageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return assets, nil
}

// MoveAssetInput changes an asset's status or where it stands.
type MoveAssetInput struct {
	AssetID string
	// Status is the new state. Empty leaves it alone, which is how a move
	// between rooms is recorded without implying the machine broke.
	Status domain.AssetStatus
	// LocationID is where it is now. Empty leaves it where it was; a
	// deliberate move to nowhere sets ClearLocation.
	LocationID      string
	ClearLocation   bool
	Department      string
	Note            string
	ExpectedVersion int64
}

// MoveAsset changes an asset's status, room or owning department
// (SRS-BIO-001).
//
// One use case rather than three, because all three change what a location
// can do and the capability read has to be republished exactly once whichever
// of them happened.
func (s *Service) MoveAsset(ctx context.Context, in MoveAssetInput) (
	domain.Asset, error) {

	session, scope, err := s.authorize(ctx, PermRegister)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	var updated domain.Asset
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		was := asset.Status
		wasAt := asset.LocationID
		wasUsable := asset.Usable(now, s.config.BlockOnCalibration)

		if in.Status != "" && in.Status != asset.Status {
			if err := asset.Move(in.Status, in.Note, now); err != nil {
				return err
			}
		}
		switch {
		case in.ClearLocation:
			asset.LocationID = ""
		case in.LocationID != "":
			asset.LocationID = in.LocationID
		}
		if in.Department != "" {
			asset.Department = in.Department
		}

		if err := s.assets.UpdateAsset(ctx, scope, asset,
			in.ExpectedVersion); err != nil {
			return err
		}
		asset.Version = in.ExpectedVersion + 1
		updated = asset

		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.asset.move", ResourceType: "biomedical_asset",
			ResourceID: asset.ID, Outcome: audit.OutcomeSuccess,
			Reason:  in.Note,
			Context: moveContext(was, asset.Status, wasAt, asset.LocationID),
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventAssetMoved,
			"biomedical_asset", asset.ID, map[string]any{
				"asset_id":    asset.ID,
				"tag":         asset.Tag,
				"from_status": string(was),
				"to_status":   string(asset.Status),
				"location_id": asset.LocationID,
			}, now); err != nil {
			return err
		}

		// Both rooms, because a machine leaving one and arriving in another
		// changes what each of them can do.
		if err := s.publishCapabilities(ctx, session, scope, wasAt, now); err != nil {
			return err
		}
		if asset.LocationID != wasAt {
			if err := s.publishCapabilities(ctx, session, scope,
				asset.LocationID, now); err != nil {
				return err
			}
		}

		// Escalate only on the transition into unusable. A second status
		// change on an already-broken machine is not news, and repeating the
		// notice is how people learn to acknowledge without reading.
		if wasUsable && !asset.Usable(now, s.config.BlockOnCalibration) {
			return s.escalateIfCritical(ctx, scope, asset,
				asset.Tag+" is "+string(asset.Status)+": "+in.Note, now)
		}
		return nil
	})
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	return updated, nil
}

func moveContext(fromStatus, toStatus domain.AssetStatus,
	fromLocation, toLocation string) json.RawMessage {

	encoded, err := json.Marshal(map[string]string{
		"from_status": string(fromStatus), "to_status": string(toStatus),
		"from_location": fromLocation, "to_location": toLocation,
	})
	if err != nil {
		return nil
	}
	return encoded
}

// CalibrationInput records a certificate and the next due date.
type CalibrationInput struct {
	AssetID         string
	Certificate     string
	NextDue         time.Time
	ExpectedVersion int64
}

// RecordCalibration records a calibration (SRS-BIO-004).
func (s *Service) RecordCalibration(ctx context.Context, in CalibrationInput) (
	domain.Asset, error) {

	session, scope, err := s.authorize(ctx, PermCalibrate)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	var updated domain.Asset
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		wasUsable := asset.Usable(now, s.config.BlockOnCalibration)
		if err := asset.Calibrate(in.Certificate, in.NextDue, now); err != nil {
			return err
		}
		if err := s.assets.UpdateAsset(ctx, scope, asset,
			in.ExpectedVersion); err != nil {
			return err
		}
		asset.Version = in.ExpectedVersion + 1
		updated = asset

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.calibration.record",
			ResourceType: "biomedical_asset", ResourceID: asset.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "certificate " + asset.CalibrationCertificate,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventAssetCalibrated,
			"biomedical_asset", asset.ID, map[string]any{
				"asset_id":    asset.ID,
				"tag":         asset.Tag,
				"certificate": asset.CalibrationCertificate,
				"due":         asset.CalibrationDue.UTC().Format(time.RFC3339),
			}, now); err != nil {
			return err
		}
		// A calibration can bring a machine back, where the deployment blocks
		// on one. The room gets to hear about that too.
		if !wasUsable && asset.Usable(now, s.config.BlockOnCalibration) {
			return s.publishCapabilities(ctx, session, scope,
				asset.LocationID, now)
		}
		return nil
	})
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	return updated, nil
}

// HoldInput stops an asset being used.
type HoldInput struct {
	AssetID         string
	Reason          string
	ExpectedVersion int64
}

// HoldAsset stops a machine being used without changing its status
// (SRS-BIO-008).
//
// Separate from status because a held asset may be perfectly serviceable and
// still must not be used — which is exactly what a safety notice means.
func (s *Service) HoldAsset(ctx context.Context, in HoldInput) (
	domain.Asset, error) {

	return s.setHold(ctx, PermNotice, in, true)
}

// ReleaseAsset lifts a safety hold (SRS-BIO-008).
func (s *Service) ReleaseAsset(ctx context.Context, in HoldInput) (
	domain.Asset, error) {

	return s.setHold(ctx, PermNotice, in, false)
}

func (s *Service) setHold(ctx context.Context, permission string, in HoldInput,
	hold bool) (domain.Asset, error) {

	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Asset{}, err
	}
	now := s.clock.Now()

	var updated domain.Asset
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return err
		}
		if hold {
			err = asset.Hold(in.Reason)
		} else {
			err = asset.Clear()
		}
		if err != nil {
			return err
		}
		if err := s.assets.UpdateAsset(ctx, scope, asset,
			in.ExpectedVersion); err != nil {
			return err
		}
		asset.Version = in.ExpectedVersion + 1
		updated = asset

		action, event := "biomedical.asset.hold", EventAssetHeld
		if !hold {
			action, event = "biomedical.asset.release", EventAssetReleased
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "biomedical_asset",
			ResourceID: asset.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Reason,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, event, "biomedical_asset",
			asset.ID, map[string]any{
				"asset_id":    asset.ID,
				"tag":         asset.Tag,
				"reason":      in.Reason,
				"location_id": asset.LocationID,
			}, now); err != nil {
			return err
		}
		if err := s.publishCapabilities(ctx, session, scope, asset.LocationID,
			now); err != nil {
			return err
		}
		if hold {
			return s.escalateIfCritical(ctx, scope, asset,
				asset.Tag+" is on safety hold: "+in.Reason, now)
		}
		return nil
	})
	if err != nil {
		return domain.Asset{}, biomedicalError(err)
	}
	return updated, nil
}

// Capability is what one location can and cannot do (SRS-BIO-009).
type Capability struct {
	LocationID string
	// Available counts working assets per capability rather than flagging it,
	// because a theatre with two intensifiers loses nothing when one goes for
	// service.
	Available map[string]int
	// Unavailable names what the room claims and cannot deliver.
	Unavailable []string
	// Unusable explains, per asset, why it is not counted — so a scheduler
	// asked "why can we not do this list" has the answer rather than a
	// missing capability.
	Unusable   map[string][]string
	ObservedAt time.Time
}

// LocationCapability reports what a room can do right now (SRS-BIO-009).
//
// Derived on read. The acceptance is that unavailable equipment cannot be
// falsely shown as schedulable, and a stored capability list is stale the
// moment a machine is wheeled out.
func (s *Service) LocationCapability(ctx context.Context, locationID string) (
	Capability, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return Capability{}, err
	}
	now := s.clock.Now()

	assets, err := s.assets.AtLocation(ctx, scope, locationID, MaxPageSize)
	if err != nil {
		return Capability{}, biomedicalError(err)
	}

	out := Capability{
		LocationID: locationID,
		Available: domain.AvailableCapabilities(assets, locationID, now,
			s.config.BlockOnCalibration),
		Unavailable: domain.UnavailableCapabilities(assets, locationID, now,
			s.config.BlockOnCalibration),
		Unusable:   map[string][]string{},
		ObservedAt: now.UTC(),
	}
	for _, asset := range assets {
		if reasons := asset.Unusable(now,
			s.config.BlockOnCalibration); len(reasons) > 0 {
			out.Unusable[asset.Tag] = reasons
		}
	}
	return out, nil
}
