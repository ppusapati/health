// Package application holds the biomedical engineering use cases
// (SRS-BIO-001 … 011).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"sort"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Split along the jobs rather than along the tables. Four stand alone because
// they are the steps that change what the hospital may do with a machine:
// recording a calibration, closing a repair, running a recall, and disposing
// of an asset. Each is the one an inspection traces a failure back to.
const (
	// PermRead reads the register, the contracts, the plans and the tickets.
	PermRead = "bio.record.read"
	// PermRegister maintains the equipment register (SRS-BIO-001).
	PermRegister = "bio.asset.register"
	// PermContract maintains warranties, AMCs and CMCs (SRS-BIO-002). Its own
	// permission, because a contract is money and a renewal is a purchase.
	PermContract = "bio.contract.write"
	// PermPlan schedules preventive maintenance (SRS-BIO-003).
	PermPlan = "bio.plan.write"
	// PermCalibrate records a calibration certificate (SRS-BIO-004). Its own
	// permission, because a calibration is what makes a machine's readings
	// admissible and somebody who could record one could make an uncalibrated
	// analyser look fit to report on patients.
	PermCalibrate = "bio.calibration.record"
	// PermRaise raises a breakdown or service request (SRS-BIO-005). Held
	// widely: the person who finds a broken machine is whoever was using it.
	PermRaise = "bio.ticket.raise"
	// PermService assigns, starts and resolves work (SRS-BIO-006).
	PermService = "bio.ticket.work"
	// PermValidate closes a repair (SRS-BIO-006). Its own permission, because
	// closing is the validation — and holding it is necessary but not
	// sufficient, since the domain refuses the engineer who did the work.
	PermValidate = "bio.ticket.close"
	// PermNotice runs recalls and safety notices (SRS-BIO-008). Its own
	// permission, because raising one stops equipment across the hospital.
	PermNotice = "bio.notice.manage"
	// PermTelemetry appends device readings (SRS-BIO-010).
	PermTelemetry = "bio.telemetry.append"
	// PermAnalyse reads uptime, MTBF, MTTR and PM compliance (SRS-BIO-007).
	PermAnalyse = "bio.analysis.read"
	// PermDispose records an asset leaving the hospital (SRS-BIO-011). Its own
	// permission, because a disposal is the last thing that ever happens to a
	// record.
	PermDispose = "bio.asset.dispose"
)

// Events.
//
// Identifiers, tags, codes and counts. No patient identifiers at all — nothing
// here is about a patient — and no prices: an event stream is read by more
// systems and under fewer controls than the record it describes
// (SRS-API-009).
const (
	EventAssetRegistered = "biomedical_asset.registered"
	EventAssetMoved      = "biomedical_asset.status_changed"
	EventAssetCalibrated = "biomedical_asset.calibrated"
	EventAssetHeld       = "biomedical_asset.held"
	EventAssetReleased   = "biomedical_asset.released"
	EventTicketRaised    = "biomedical_ticket.raised"
	EventTicketResolved  = "biomedical_ticket.resolved"
	EventTicketClosed    = "biomedical_ticket.closed"
	EventNoticeRaised    = "biomedical_notice.raised"
	EventNoticeClosed    = "biomedical_notice.closed"
	EventAssetDisposed   = "biomedical_asset.disposed"
	// EventCapabilityChanged is SRS-BIO-009's link to scheduling. Published
	// whenever a location stops or starts being able to do something, so a
	// theatre list is not built on a capability that walked out of the room
	// this morning.
	EventCapabilityChanged = "biomedical_location.capability_changed"
)

// The escalations this context raises.
//
// Durable and acknowledged rather than a log line, for the two things here
// that cannot wait for somebody to open a screen.
const (
	// EscalationRecall has to reach the wards holding the equipment.
	EscalationRecall = "biomedical_recall"
	// EscalationCriticalDown is a life-support or critical asset going down.
	// A ward that does not know its ventilator is out finds out at the worst
	// possible moment.
	EscalationCriticalDown = "biomedical_critical_down"
)

// Config is what a deployment has decided about its equipment.
type Config struct {
	// BlockOnCalibration decides whether a lapsed calibration makes an asset
	// unusable rather than merely overdue. True for a hospital that treats a
	// calibration certificate as a condition of use, which is the stricter
	// reading of SRS-BIO-004 and the one an accreditation inspection expects.
	// False leaves it reported and not enforced, which is a deployment
	// decision and appears in the status document rather than being guessed
	// at here.
	BlockOnCalibration bool
	// SoonWindow is how far ahead the PM due list reaches for "due soon"
	// (SRS-BIO-003). Zero reports only what is due or overdue.
	SoonWindow time.Duration
	// ExpiryHorizon is how far ahead contract and calibration reminders look
	// (SRS-BIO-002, SRS-BIO-004). Zero reports only what has already lapsed —
	// which is a deployment that has not decided, not a deployment with
	// nothing to renew.
	ExpiryHorizon time.Duration
	// DefaultResponseHours and DefaultResolutionHours apply to an asset with
	// no live contract (SRS-BIO-005). Zero leaves such a ticket with no clock
	// except the cap its priority imposes.
	DefaultResponseHours   int
	DefaultResolutionHours int
	// EscalateAtCriticality is the level at or above which an asset going out
	// of service raises a notice. Empty escalates nothing, which is a
	// deployment that has not decided.
	EscalateAtCriticality domain.Criticality
}

// Service is the biomedical use-case façade.
type Service struct {
	uow       ports.UnitOfWork
	assets    ports.AssetRepository
	contracts ports.ContractRepository
	plans     ports.PlanRepository
	tickets   ports.TicketRepository
	notices   ports.NoticeRepository
	telemetry ports.TelemetryRepository
	disposals ports.DisposalRepository

	events      ports.EventAppender
	audits      ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Assets     ports.AssetRepository
	Contracts  ports.ContractRepository
	Plans      ports.PlanRepository
	Tickets    ports.TicketRepository
	Notices    ports.NoticeRepository
	Telemetry  ports.TelemetryRepository
	Disposals  ports.DisposalRepository

	Events ports.EventAppender
	Audits ports.AuditAppender
	// Escalations raises the notices a recall and a critical breakdown
	// produce. Nil records both and escalates neither, which is visible in
	// the status document rather than hidden here.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, assets: d.Assets, contracts: d.Contracts,
		plans: d.Plans, tickets: d.Tickets, notices: d.Notices,
		telemetry: d.Telemetry, disposals: d.Disposals,
		events: d.Events, audits: d.Audits, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// analysisPageSize bounds a reliability replay. An asset with a hundred
	// thousand tickets is a report somebody should narrow, not a query that
	// pulls the whole history into memory.
	analysisPageSize = 5000
	// recallCandidates bounds how many assets a notice is matched against in
	// one pass, so a recall naming a common make does not read the register
	// into memory.
	recallCandidates = 5000
)

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

func (s *Service) authorize(ctx context.Context, permission string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.Unauthenticated(
			"BIO_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"BIO_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// biomedicalError maps a domain refusal to the transport contract.
func biomedicalError(err error) error {
	if errors.Is(err, domain.ErrInvalidAsset) {
		return rpcerr.Invalid("BIO_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("BIO_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	if s.audits == nil {
		return nil
	}
	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	if r.TenantID == "" {
		r.TenantID = session.TenantID
	}
	return s.audits.Append(ctx, r)
}

const (
	eventSchemaVersion = 1
	eventSource        = "biomedical"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("BIO_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}
	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

// publishCapabilities reports what a location can and cannot do, after
// something changed for one of the assets standing in it (SRS-BIO-009).
//
// Published rather than pushed into the theatre's own tables: this context
// owns equipment, the theatre owns rooms, and a write across that line would
// make either one unable to change without the other. A subscriber that
// schedules on capability re-reads its room from the event.
//
// Silent where the asset stands nowhere, because a store has no list to
// protect.
func (s *Service) publishCapabilities(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope, locationID string,
	now time.Time) error {

	if s.events == nil || locationID == "" {
		return nil
	}
	assets, err := s.assets.AtLocation(ctx, scope, locationID, MaxPageSize)
	if err != nil {
		return err
	}

	available := domain.AvailableCapabilities(assets, locationID, now,
		s.config.BlockOnCalibration)
	names := make([]string, 0, len(available))
	for name := range available {
		names = append(names, name)
	}
	sort.Strings(names)

	return s.appendEvent(ctx, session, EventCapabilityChanged, "location",
		locationID, map[string]any{
			"location_id":   locationID,
			"available":     names,
			"counts":        available,
			"unavailable":   domain.UnavailableCapabilities(assets, locationID, now, s.config.BlockOnCalibration),
			"asset_count":   len(assets),
			"observed_at":   now.UTC().Format(time.RFC3339),
			"blocks_on_cal": s.config.BlockOnCalibration,
		}, now)
}

// escalateIfCritical raises a notice when an asset the hospital depends on
// stops being usable.
//
// Silent below the configured level, and silent where nobody configured one:
// escalating everything trains people to acknowledge without reading, which
// is the failure mode SRS-BIO-005's acceptance is trying to avoid.
func (s *Service) escalateIfCritical(ctx context.Context,
	scope authctx.TenantScope, asset domain.Asset, summary string,
	now time.Time) error {

	if s.escalations == nil || s.config.EscalateAtCriticality == "" {
		return nil
	}
	if asset.Criticality.Rank() < s.config.EscalateAtCriticality.Rank() {
		return nil
	}
	_, err := s.escalations.Raise(ctx, scope, ports.Notice{
		Kind: EscalationCriticalDown,
		// The asset, never a patient. Nothing in this context is about one,
		// and a notice that travels widely should carry the least it can.
		Subject:    asset.Tag,
		FacilityID: asset.LocationID,
		Summary:    summary,
	}, now)
	return err
}

func itoa(n int) string { return strconv.Itoa(n) }
