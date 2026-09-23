package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RecordPingInput is one position from a telematics box (SRS-AMB-005).
type RecordPingInput struct {
	VehicleID      string
	TripID         string
	LatitudeMicro  int
	LongitudeMicro int
	SpeedKph       int
	HeadingDegrees int
	AccuracyMetres int
	Source         string
	At             time.Time
}

// RecordPing records where a vehicle is (SRS-AMB-005).
//
// The retention horizon comes from the deployment's configuration and is
// written onto the row. A deployment that has not set one records no feed at
// all: a map of where patients were collected from, kept for as long as
// somebody forgets to think about it, is the failure mode this refuses.
func (s *Service) RecordPing(ctx context.Context, in RecordPingInput) (
	domain.Ping, error) {

	_, scope, err := s.authorize(ctx, PermLocationWrite)
	if err != nil {
		return domain.Ping{}, err
	}
	if s.config.LocationRetention <= 0 {
		return domain.Ping{}, rpcerr.FailedPrecondition(
			"AMB_NO_LOCATION_RETENTION",
			"this deployment has not set how long vehicle positions are "+
				"kept, so none are recorded")
	}
	now := s.clock.Now()

	ping, err := domain.RecordPing(s.ids.NewID(), scope.TenantID(),
		domain.NewPingInput{
			VehicleID: in.VehicleID, TripID: in.TripID,
			LatitudeMicro:  in.LatitudeMicro,
			LongitudeMicro: in.LongitudeMicro,
			SpeedKph:       in.SpeedKph,
			HeadingDegrees: in.HeadingDegrees,
			AccuracyMetres: in.AccuracyMetres,
			Source:         in.Source, At: in.At,
		}, s.config.LocationRetention, now)
	if err != nil {
		return domain.Ping{}, ambulanceError(err)
	}

	// No audit entry per ping, deliberately: a box reporting every ten
	// seconds would produce a trail nobody can read and a table larger
	// than the one it describes. Reads of the feed are audited instead,
	// which is where the privacy question is.
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.locations.InsertPing(ctx, scope, ping)
	})
	if err != nil {
		return domain.Ping{}, err
	}
	return ping, nil
}

// VehiclePosition is where a vehicle is, and how much to trust it.
type VehiclePosition struct {
	Position domain.Position
	ETA      domain.ETA
}

// Position reads where a vehicle is (SRS-AMB-005).
//
// Behind its own permission and audited on every read: this is the question
// "where has this ambulance been", and the answer is a list of addresses
// where people were ill.
func (s *Service) Position(ctx context.Context, vehicleID, tripID string) (
	VehiclePosition, error) {

	session, scope, err := s.authorize(ctx, PermLocationRead)
	if err != nil {
		return VehiclePosition{}, err
	}
	now := s.clock.Now()

	ping, err := s.locations.LatestPing(ctx, scope, vehicleID, now)
	out := VehiclePosition{}
	if err == nil {
		out.Position = domain.Latest([]domain.Ping{ping}, vehicleID,
			s.config.PositionStaleAfter, now)
	} else if !isNotFound(err) {
		return VehiclePosition{}, err
	}
	// A vehicle with nothing in retention reports that, rather than
	// defaulting to its base — which would put an ambulance somewhere it
	// is not.

	if tripID != "" {
		eta, err := s.locations.LatestETA(ctx, scope, tripID)
		if err != nil {
			return VehiclePosition{}, err
		}
		out.ETA = eta
	}

	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.location.read",
			ResourceType: "ambulance.vehicle", ResourceID: vehicleID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"trip_id": tripID,
				"known":   boolText(out.Position.Known),
			}),
		}, now)
	}); err != nil {
		return VehiclePosition{}, err
	}
	return out, nil
}

// ListPingsInput narrows a feed read.
type ListPingsInput struct {
	VehicleID string
	TripID    string
	From      time.Time
	To        time.Time
	PageSize  int32
}

// ListPings reads a vehicle's trail (SRS-AMB-005).
//
// Bounded by each ping's own retention horizon, so the trail a caller gets
// back is the trail the deployment said it keeps — whether or not the purge
// job has run.
func (s *Service) ListPings(ctx context.Context, in ListPingsInput) (
	[]domain.Ping, error) {

	session, scope, err := s.authorize(ctx, PermLocationRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	pings, err := s.locations.Pings(ctx, scope, ports.PingFilter{
		VehicleID: in.VehicleID, TripID: in.TripID,
		From: in.From, To: in.To, AsOf: now,
		Limit: clampPageSize(in.PageSize),
	})
	if err != nil {
		return nil, err
	}
	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.location.trail_read",
			ResourceType: "ambulance.vehicle",
			ResourceID:   in.VehicleID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"trip_id": in.TripID, "pings": itoa(len(pings)),
			}),
		}, now)
	}); err != nil {
		return nil, err
	}
	return pings, nil
}

// RecordETAInput is a provider's estimate (SRS-AMB-005).
type RecordETAInput struct {
	VehicleID      string
	TripID         string
	Seconds        int
	DistanceMetres int
	Source         string
}

// RecordETA stores a provider's estimate (SRS-AMB-005).
//
// Never computed here. A road network, live traffic and a blue-light routing
// model are the provider's job; a straight-line guess would produce a number
// that looks like an ETA and is not one, and a dispatcher would hold a bed
// against it.
func (s *Service) RecordETA(ctx context.Context, in RecordETAInput) (
	domain.ETA, error) {

	_, scope, err := s.authorize(ctx, PermLocationWrite)
	if err != nil {
		return domain.ETA{}, err
	}
	now := s.clock.Now()

	eta, err := domain.NewETA(in.VehicleID, in.TripID, in.Seconds,
		in.DistanceMetres, in.Source, now)
	if err != nil {
		return domain.ETA{}, ambulanceError(err)
	}
	id := s.ids.NewID()
	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.locations.InsertETA(ctx, scope, id, eta)
	}); err != nil {
		return domain.ETA{}, err
	}
	return eta, nil
}

// PurgeExpiredPings removes positions past their horizon (SRS-AMB-005).
//
// Run on a schedule. The reads do not depend on it having run — they apply
// the horizon themselves — which is what makes it safe to run out of band
// rather than in the request path.
func (s *Service) PurgeExpiredPings(ctx context.Context) (int64, error) {
	session, scope, err := s.authorize(ctx, PermLocationWrite)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	var removed int64
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		count, err := s.locations.PurgeExpired(ctx, scope, now)
		if err != nil {
			return err
		}
		removed = count
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.location.purged",
			ResourceType: "ambulance.location_ping",
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"removed": itoa(int(count)),
			}),
		}, now)
	})
	if err != nil {
		return 0, err
	}
	return removed, nil
}

// isNotFound distinguishes "this vehicle has nothing in retention" from "the
// store is down". A directory that is down must not read as a vehicle with no
// position: a blank dispatch board is a different thing from an empty one.
func isNotFound(err error) bool {
	var refused *rpcerr.Error
	return errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound
}
