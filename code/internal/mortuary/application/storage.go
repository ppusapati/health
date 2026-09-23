package application

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// AddLocationInput registers a storage space (SRS-MORT-002).
type AddLocationInput struct {
	Code       string
	Kind       string
	FacilityID string
	Zone       string
}

// AddLocation registers a storage space (SRS-MORT-002).
func (s *Service) AddLocation(ctx context.Context, in AddLocationInput) (
	domain.Location, error) {

	session, scope, err := s.authorize(ctx, PermStorageManage)
	if err != nil {
		return domain.Location{}, err
	}
	now := s.clock.Now()

	var out domain.Location
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		location, err := domain.NewLocation(s.ids.NewID(),
			session.TenantID, domain.NewLocationInput{
				Code: in.Code, Kind: domain.SpaceKind(in.Kind),
				FacilityID: in.FacilityID, Zone: in.Zone,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.storage.InsertLocation(ctx, scope,
			location); err != nil {
			return err
		}
		out = location
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.location.added",
			ResourceType: "mortuary.location", ResourceID: location.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": location.Code, "kind": string(location.Kind),
			}),
		}, now)
	})
	if err != nil {
		return domain.Location{}, err
	}
	return out, nil
}

// SetLocationServiceInput takes a space off the board or puts it back.
type SetLocationServiceInput struct {
	LocationID   string
	OutOfService bool
	Reason       string
	Version      int64
}

// SetLocationService moves a space on or off the board (SRS-MORT-002).
func (s *Service) SetLocationService(ctx context.Context,
	in SetLocationServiceInput) (domain.Location, error) {

	session, scope, err := s.authorize(ctx, PermStorageManage)
	if err != nil {
		return domain.Location{}, err
	}
	now := s.clock.Now()

	var out domain.Location
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		location, err := s.storage.Location(ctx, scope, in.LocationID)
		if err != nil {
			return err
		}
		if in.OutOfService {
			// A space taken off the board with a body still in it is a
			// body the board stops offering and nobody comes back for.
			occupied, err := s.storage.OccupiedLocations(ctx, scope)
			if err != nil {
				return err
			}
			if occupied[location.ID] {
				return rpcerr.FailedPrecondition("MORT_SPACE_OCCUPIED",
					"move the body out before taking the space off the "+
						"board")
			}
			if err := location.TakeOutOfService(in.Reason); err != nil {
				return mortuaryError(err)
			}
		} else {
			location.ReturnToService()
		}
		if err := s.storage.UpdateLocation(ctx, scope, location,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		location.Version = in.Version + 1
		out = location
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.location.service",
			ResourceType: "mortuary.location", ResourceID: location.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
			Context: auditContext(map[string]string{
				"out_of_service": boolText(in.OutOfService),
			}),
		}, now)
	})
	if err != nil {
		return domain.Location{}, err
	}
	return out, nil
}

// ListLocationsInput narrows a storage list.
type ListLocationsInput struct {
	FacilityID    string
	Kinds         []string
	InServiceOnly bool
	PageSize      int32
	Offset        int32
}

func (in ListLocationsInput) filter(limit int32) ports.LocationFilter {
	kinds := make([]domain.SpaceKind, 0, len(in.Kinds))
	for _, kind := range in.Kinds {
		kinds = append(kinds, domain.SpaceKind(kind))
	}
	return ports.LocationFilter{
		FacilityID: in.FacilityID, Kinds: kinds,
		InServiceOnly: in.InServiceOnly, Limit: limit, Offset: in.Offset,
	}
}

// ListLocations reads the storage spaces (SRS-MORT-002).
func (s *Service) ListLocations(ctx context.Context,
	in ListLocationsInput) ([]domain.Location, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.storage.Locations(ctx, scope,
		in.filter(clampPageSize(in.PageSize)))
}

// PlaceInput puts a body in a space (SRS-MORT-002).
type PlaceInput struct {
	CaseID     string
	LocationID string
	StorageTag string
	// CheckedNote is what was checked against what. The requirement asks
	// for positive identity checks, and a tick is not one.
	CheckedNote string
	// MoveReason closes the current placement where there is one. A body
	// that moved for no recorded reason is one nobody can follow.
	MoveReason string
	Version    int64
}

// Place puts a body in a space, ending wherever it was (SRS-MORT-002).
//
// Both halves in one transaction: a body recorded into its new drawer while
// still recorded in the old one is a mortuary that thinks it has two of
// somebody, and the unique index would refuse the second write anyway —
// leaving the move half done if the two were separate calls.
func (s *Service) Place(ctx context.Context, in PlaceInput) (
	domain.Placement, error) {

	session, scope, err := s.authorize(ctx, PermPlace)
	if err != nil {
		return domain.Placement{}, err
	}
	now := s.clock.Now()

	var out domain.Placement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		location, err := s.storage.Location(ctx, scope, in.LocationID)
		if err != nil {
			return err
		}

		from := ""
		current, err := s.storage.CurrentPlacement(ctx, scope, found.ID)
		switch {
		case err == nil:
			reason := in.MoveReason
			if reason == "" {
				reason = "moved to " + location.Code
			}
			if err := current.End(reason, session.SubjectID,
				now); err != nil {
				return mortuaryError(err)
			}
			if err := s.storage.EndPlacement(ctx, scope,
				current); err != nil {
				return mortuaryError(err)
			}
			from = current.LocationID
		case isNotFound(err):
			// The body is nowhere yet, which is where every case starts.
		default:
			return err
		}

		placed, err := domain.Place(s.ids.NewID(), session.TenantID,
			&found, location, in.StorageTag, in.CheckedNote,
			session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.storage.InsertPlacement(ctx, scope,
			placed); err != nil {
			return err
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		out = placed

		if err := s.appendCustody(ctx, scope, found.ID, "placed",
			"placed in "+location.Code, from, location.ID,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.body.placed",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location": location.Code, "tag": placed.StorageTag,
			}),
		}, now)
	})
	if err != nil {
		return domain.Placement{}, err
	}
	return out, nil
}

// PlacementHistory reads where a body has been (SRS-MORT-002).
func (s *Service) PlacementHistory(ctx context.Context, caseID string) (
	[]domain.Placement, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.storage.Placements(ctx, scope, []string{caseID})
	if err != nil {
		return nil, err
	}
	return domain.History(found, caseID), nil
}

// isNotFound distinguishes "this body is in no space" from "the store is
// down". A store that is down must not read as a body that is nowhere: the
// placement that follows would be the second one for a case that already has
// one, and the unique index would refuse it with a message nobody can act on.
func isNotFound(err error) bool {
	var refused *rpcerr.Error
	return errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound
}
