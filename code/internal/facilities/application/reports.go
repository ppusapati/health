package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// AddMeterInput registers a measuring point (SRS-FAC-009).
type AddMeterInput struct {
	Code        string
	Name        string
	Utility     string
	Unit        string
	FacilityID  string
	LocationID  string
	AssetID     string
	Source      string
	SourceRef   string
	Cumulative  bool
	RegisterMax int32
}

// AddMeter registers a meter (SRS-FAC-009).
func (s *Service) AddMeter(ctx context.Context, in AddMeterInput) (
	domain.Meter, error) {

	session, scope, err := s.authorize(ctx, PermMeterWrite)
	if err != nil {
		return domain.Meter{}, err
	}
	now := s.clock.Now()

	meter := domain.Meter{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		Code: in.Code, Name: in.Name,
		Utility: domain.Utility(in.Utility), Unit: in.Unit,
		FacilityID: in.FacilityID, LocationID: in.LocationID,
		AssetID: in.AssetID,
		Source:  domain.Source(in.Source), SourceRef: in.SourceRef,
		Cumulative: in.Cumulative, RegisterMax: int(in.RegisterMax),
		Active:    true,
		CreatedAt: now.UTC(), CreatedBy: session.SubjectID, Version: 1,
	}
	if err := meter.Validate(); err != nil {
		return domain.Meter{}, facilitiesError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if meter.AssetID != "" {
			if _, err := s.assets.Asset(ctx, scope,
				meter.AssetID); err != nil {
				return err
			}
		}
		if err := s.meters.InsertMeter(ctx, scope, meter); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.meter.added",
			ResourceType: "facilities.meter", ResourceID: meter.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": meter.Code, "utility": string(meter.Utility),
				"unit": meter.Unit, "source": string(meter.Source),
			}),
		}, now)
	})
	if err != nil {
		return domain.Meter{}, err
	}
	return meter, nil
}

// RecordMeterReadingInput records one reading (SRS-FAC-009).
type RecordMeterReadingInput struct {
	MeterID    string
	Value      int32
	ReadAt     string
	Source     string
	SourceRef  string
	RolledOver bool
	Note       string
}

// RecordMeterReading records a meter reading (SRS-FAC-009).
func (s *Service) RecordMeterReading(ctx context.Context,
	in RecordMeterReadingInput) (domain.Reading, error) {

	session, scope, err := s.authorize(ctx, PermMeterWrite)
	if err != nil {
		return domain.Reading{}, err
	}
	now := s.clock.Now()

	readAt, err := parseTime(in.ReadAt)
	if err != nil {
		return domain.Reading{}, err
	}
	if readAt.IsZero() {
		readAt = now
	}

	var out domain.Reading
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		meter, err := s.meters.Meter(ctx, scope, in.MeterID)
		if err != nil {
			return err
		}
		source := domain.Source(in.Source)
		if source == "" {
			// The meter's usual source, so an automated poller that
			// does not repeat itself every reading still produces a
			// figure with provenance.
			source = meter.Source
		}
		sourceRef := in.SourceRef
		if sourceRef == "" && source == meter.Source {
			sourceRef = meter.SourceRef
		}

		reading, err := domain.RecordReading(s.ids.NewID(),
			session.TenantID, meter, int(in.Value), readAt, source,
			sourceRef, in.RolledOver, in.Note, session.SubjectID,
			now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.meters.InsertReading(ctx, scope, reading); err != nil {
			return err
		}
		out = reading
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.meter_reading.recorded",
			ResourceType: "facilities.meter", ResourceID: meter.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"value": itoa(reading.Value), "unit": meter.Unit,
				"source":      string(reading.Source),
				"rolled_over": boolText(reading.RolledOver),
			}),
		}, now)
	})
	if err != nil {
		return domain.Reading{}, err
	}
	return out, nil
}

// ListMeters reads the measuring points (SRS-FAC-009).
func (s *Service) ListMeters(ctx context.Context, facilityID, utility string,
	pageSize int32) ([]domain.Meter, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.meters.Meters(ctx, scope, ports.MeterFilter{
		FacilityID: facilityID, Utility: domain.Utility(utility),
		ActiveOnly: true, Limit: clampPageSize(pageSize),
	})
}

// ConsumptionInput asks what a meter recorded over a window.
type ConsumptionInput struct {
	MeterID string
	From    string
	To      string
}

// Consumption derives what a meter recorded over a window (SRS-FAC-009).
//
// The figure carries its meter, its unit and the provenances behind it,
// which is the acceptance. A caller that wanted only the number would still
// get them, because a number without them is one nobody can check.
func (s *Service) Consumption(ctx context.Context, in ConsumptionInput) (
	domain.Consumption, bool, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return domain.Consumption{}, false, err
	}
	from, err := parseTime(in.From)
	if err != nil {
		return domain.Consumption{}, false, err
	}
	to, err := parseTime(in.To)
	if err != nil {
		return domain.Consumption{}, false, err
	}
	if to.IsZero() {
		to = s.clock.Now()
	}

	meter, err := s.meters.Meter(ctx, scope, in.MeterID)
	if err != nil {
		return domain.Consumption{}, false, err
	}
	readings, err := s.meters.Readings(ctx, scope, meter.ID, from, to,
		reportPageSize)
	if err != nil {
		return domain.Consumption{}, false, err
	}
	got, isOK := domain.Consume(meter, readings, from, to)
	return got, isOK, nil
}

// DowntimeInput asks how long each system was unavailable.
type DowntimeInput struct {
	FacilityID string
	From       string
	To         string
}

// Downtime totals recorded downtime by system (SRS-FAC-009).
func (s *Service) Downtime(ctx context.Context, in DowntimeInput) (
	[]domain.Downtime, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return nil, err
	}
	from, err := parseTime(in.From)
	if err != nil {
		return nil, err
	}
	to, err := parseTime(in.To)
	if err != nil {
		return nil, err
	}
	if to.IsZero() {
		to = s.clock.Now()
	}

	orders, err := s.work.WorkOrders(ctx, scope, ports.WorkOrderFilter{
		FacilityID: in.FacilityID, From: from, To: to,
		Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.SummariseDowntime(orders, from, to), nil
}

// SLAPerformance is how facilities is doing against its targets
// (SRS-FAC-002, SRS-FAC-009).
type SLAPerformance struct {
	Open               int
	ResponseBreaches   int
	ResolutionBreaches int
	// WorstOpen is the open work furthest past its target, which is the
	// one somebody should look at rather than a percentage nobody acts on.
	WorstOpen []domain.WorkOrder
}

// Performance reports SLA attainment (SRS-FAC-002, SRS-FAC-009).
func (s *Service) Performance(ctx context.Context, facilityID string) (
	SLAPerformance, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return SLAPerformance{}, err
	}
	now := s.clock.Now()

	open, err := s.work.WorkOrders(ctx, scope, ports.WorkOrderFilter{
		FacilityID: facilityID, OpenOnly: true, Limit: reportPageSize})
	if err != nil {
		return SLAPerformance{}, err
	}

	out := SLAPerformance{Open: len(open)}
	for _, order := range open {
		breach := order.Breached(now)
		if breach.Response {
			out.ResponseBreaches++
		}
		if breach.Resolution {
			out.ResolutionBreaches++
		}
	}
	ranked := domain.OpenWork(open, now)
	if len(ranked) > 20 {
		ranked = ranked[:20]
	}
	out.WorstOpen = ranked
	return out, nil
}
