package application

import (
	"context"
	"encoding/json"
	"log/slog"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"time"
)

// Event and audit writing.
//
// Both run inside the caller's transaction. An applied change without its
// outbox event leaves every downstream projection wrong (SRS-API-008); an
// applied change without its audit entry is a compliance defect, and a patient
// record read without one is worse (SRS-SEC-004).

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload json.RawMessage, now time.Time) error {

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
		Payload:       payload,
	})
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

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

// auditDenied records a refusal on its own transaction.
//
// A denial is the row a security reviewer reaches for first, and it must
// survive the fact that the action it describes did not happen — so it cannot
// ride in the transaction that is about to be abandoned.
//
// A failure to write it is logged and swallowed: returning it would replace a
// PERMISSION_DENIED with an INTERNAL, telling the caller that something went
// wrong on the server rather than that they are not allowed.
func (s *Service) auditDenied(ctx context.Context, session authctx.Session,
	action, resourceType, resourceID, reason string) {

	now := s.clock.Now()
	err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: action,
			ResourceType: resourceType, ResourceID: resourceID,
			Outcome: audit.OutcomeDenied, Reason: reason,
		}, now)
	})
	if err != nil {
		slog.ErrorContext(ctx, "denied access was not audited",
			slog.String("action", action), slog.String("error", err.Error()))
	}
}

// auditRead records a successful patient read (SRS-SEC-004).
//
// Reads are audited in this context and not in most others, because who looked
// at a patient record is itself a regulated question — the celebrity-admission
// case is the one every hospital has a story about.
func (s *Service) auditRead(ctx context.Context, session authctx.Session,
	resourceID string, context json.RawMessage) error {

	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermPatientRead,
		ResourceType: "patient", ResourceID: resourceID,
		Outcome: audit.OutcomeSuccess, Context: context,
	}, s.clock.Now())
}
