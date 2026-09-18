// Package application holds the blood bank use cases (SRS-BLD-001 … 017).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Split along the jobs. The three that stand alone are the ones a hospital is
// most answerable for: releasing a unit from quarantine, authorising an
// uncrossmatched emergency release, and running a look-back across patients.
const (
	// PermRead reads inventory, requests and a patient's transfusion history.
	PermRead = "bld.record.read"
	// PermDonor registers donors, screens them and records collections
	// (SRS-BLD-001, SRS-BLD-002, SRS-BLD-003).
	PermDonor = "bld.donor.write"
	// PermDefer defers a donor or lifts a temporary deferral (SRS-BLD-002).
	PermDefer = "bld.donor.defer"
	// PermTest records mandatory testing (SRS-BLD-004).
	PermTest = "bld.testing.write"
	// PermRelease moves a component out of quarantine. Its own permission,
	// because it is the single decision that makes a unit givable and the one
	// a look-back is traced back to.
	PermRelease = "bld.component.release"
	// PermInventory brings components in, moves them and discards them
	// (SRS-BLD-005, SRS-BLD-013).
	PermInventory = "bld.inventory.write"
	// PermRequest places a request for blood (SRS-BLD-006). Held by
	// clinicians, not by the bank.
	PermRequest = "bld.request.place"
	// PermCrossmatch groups a patient, matches and reserves (SRS-BLD-007,
	// SRS-BLD-008).
	PermCrossmatch = "bld.crossmatch.write"
	// PermIssue releases a crossmatched unit from the bank (SRS-BLD-009).
	PermIssue = "bld.issue.write"
	// PermEmergencyIssue authorises an uncrossmatched release
	// (SRS-BLD-016). Its own permission because the whole control is that
	// somebody senior is named.
	PermEmergencyIssue = "bld.issue.emergency"
	// PermTransfuse runs the bedside check and the transfusion (SRS-BLD-010,
	// SRS-BLD-011). Held by nurses.
	PermTransfuse = "bld.transfusion.write"
	// PermReaction reports and investigates a reaction (SRS-BLD-012).
	PermReaction = "bld.reaction.write"
	// PermTrace runs a look-back across patients (SRS-BLD-014). Its own
	// permission because it reaches every patient who received blood from a
	// donation rather than one chart.
	PermTrace = "bld.trace.read"
	// PermConfigure sets stock thresholds (SRS-BLD-017).
	PermConfigure = "bld.stock.configure"
)

// Events.
//
// Identifiers, codes and times. No donor name, no indication, no reaction
// narrative: an event stream is read by more systems and under fewer controls
// than the record it describes (SRS-API-009).
const (
	EventComponentReleased  = "bloodbank_component.released"
	EventComponentDiscarded = "bloodbank_component.discarded"
	EventRequestPlaced      = "bloodbank_request.placed"
	EventUnitReserved       = "bloodbank_unit.reserved"
	EventUnitIssued         = "bloodbank_unit.issued"
	// EventEmergencyRelease is separate from an ordinary issue so a
	// haemovigilance system can subscribe to it alone.
	EventEmergencyRelease = "bloodbank_unit.emergency_release"
	// EventBedsideMismatch is SRS-BLD-010's critical exception.
	EventBedsideMismatch   = "bloodbank_bedside.mismatch"
	EventTransfusionStart  = "bloodbank_transfusion.started"
	EventTransfusionEnd    = "bloodbank_transfusion.ended"
	EventReactionReported  = "bloodbank_reaction.reported"
	EventLookBackRequested = "bloodbank_lookback.requested"
)

// EscalationKind is the notice a bedside mismatch raises.
//
// Durable and acknowledged rather than a log line, because SRS-BLD-010 calls
// it a critical exception: somebody at a bedside has a unit in their hand that
// does not match the patient in front of them, and the blood bank has to know
// before the next unit goes out.
const EscalationKind = "transfusion_mismatch"

// Config is what a deployment has decided about its blood bank.
type Config struct {
	// MandatoryTests is the panel a collection must clear before its
	// components leave quarantine (SRS-BLD-004). Empty releases nothing,
	// which is deliberate: a deployment that has not said what it tests for
	// has not decided, and releasing everything would be the wrong reading of
	// that silence.
	MandatoryTests domain.MandatoryTests
	// SampleValidity is how long a grouping sample supports a crossmatch.
	// Zero takes three days, the common protocol for a patient who has been
	// transfused or pregnant recently — which in a hospital is most of them.
	SampleValidity time.Duration
	// ReservationWindow is how long a crossmatched unit is held. Zero takes
	// two days.
	ReservationWindow time.Duration
	// ExpiryHorizon is how far ahead an expiry alert looks. Zero takes three
	// days.
	ExpiryHorizon time.Duration
	// RequiredObservations are the protocol sets a transfusion should have.
	// Empty takes baseline, fifteen minutes and completion.
	//
	// Who is told about a bedside mismatch is deliberately not here: that is
	// the tenant's escalation matrix, resolved at delivery. Configuring it in
	// two places is how a rota change stops reaching the blood bank.
	RequiredObservations []string
}

func (c Config) requiredObservations() []string {
	if len(c.RequiredObservations) == 0 {
		return []string{
			domain.TimingBaseline, domain.TimingFifteen, domain.TimingCompletion,
		}
	}
	return c.RequiredObservations
}

// Service is the blood bank use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	donors      ports.DonorRepository
	inventory   ports.InventoryRepository
	crossmatch  ports.CrossmatchRepository
	transfusion ports.TransfusionRepository
	patients    ports.Patients
	events      ports.EventAppender
	audits      ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork  ports.UnitOfWork
	Donors      ports.DonorRepository
	Inventory   ports.InventoryRepository
	Crossmatch  ports.CrossmatchRepository
	Transfusion ports.TransfusionRepository
	// Patients reports whether the index knows a patient. Nil skips the
	// check, which is visible in the status document rather than hidden here.
	Patients ports.Patients
	Events   ports.EventAppender
	Audits   ports.AuditAppender
	// Escalations raises the critical exception a bedside mismatch produces.
	// Nil leaves the mismatch recorded and unescalated, which is a
	// configuration rather than a defect — but a poor one, and the status
	// document says so.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, donors: d.Donors, inventory: d.Inventory,
		crossmatch: d.Crossmatch, transfusion: d.Transfusion,
		patients: d.Patients, events: d.Events, audits: d.Audits,
		escalations: d.Escalations,
		ids:         d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
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
			"BLD_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"BLD_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// bloodbankError maps a domain refusal to the transport contract.
func bloodbankError(err error) error {
	if errors.Is(err, domain.ErrInvalidUnit) {
		return rpcerr.Invalid("BLD_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("BLD_VERSION_CONFLICT",
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
	eventSource        = "bloodbank"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("BLD_EVENT_ENCODE_FAILED", "could not encode event").
			WithCause(err)
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

// knownPatient refuses a patient the index does not know.
//
// A blood bank that crossmatched against an identifier nobody could resolve
// would issue blood for a patient who does not exist, and the mismatch would
// surface at a bedside.
func (s *Service) knownPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) error {

	if s.patients == nil {
		return nil
	}
	exists, err := s.patients.Exists(ctx, scope, patientID)
	if err != nil {
		return err
	}
	if !exists {
		// Not found rather than invalid, so a probe cannot confirm that an
		// identifier is real in another tenant by the shape of the refusal.
		return rpcerr.NotFound("BLD_NOT_FOUND", "no such patient")
	}
	return nil
}

func itoa(n int) string { return strconv.Itoa(n) }
