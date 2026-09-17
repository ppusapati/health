// Package application holds the critical-care use cases (SRS-ICU-001 … 017).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Split along the jobs rather than the screens. Three of them exist because
// the act they guard is one a unit is answerable for in a way the others are
// not: validating a device reading into the chart, calculating a score that
// goes into a mortality review, and setting a ceiling of treatment.
const (
	// PermIcuRead reads the dashboard and an episode's record.
	PermIcuRead = "icu.episode.read"
	// PermIcuWrite admits, charts and records.
	PermIcuWrite = "icu.episode.write"
	// PermValidate confirms or rejects a device reading (SRS-ICU-003). Its own
	// permission because a confirmed artefact becomes a fact the trend and the
	// score are computed from.
	PermValidate = "icu.reading.validate"
	// PermDischarge decides that the patient no longer needs critical care
	// (SRS-ICU-016).
	PermDischarge = "icu.episode.discharge"
	// PermSetCeiling documents a ceiling of treatment (SRS-ICU-015's
	// "restricted authorization").
	PermSetCeiling = "icu.ceiling.set"
	// PermReadCeiling sees what the ceiling says. Separate from setting it,
	// and deliberately wider: a nurse who may not agree a ceiling still has to
	// know the patient is not for CPR.
	PermReadCeiling = "icu.ceiling.read"
)

// Events.
//
// Identifiers, codes and times; no free text and no values. An event stream is
// read by more systems and under fewer controls than the chart it describes
// (SRS-API-009), and a potassium on a broker is a result outside the chart's
// access rules.
const (
	EventEpisodeAdmitted   = "icu_episode.admitted"
	EventEpisodeReady      = "icu_episode.ready_for_transfer"
	EventEpisodeDischarged = "icu_episode.discharged"
	EventSupportStarted    = "icu_support.started"
	EventSupportStopped    = "icu_support.stopped"
	EventDeviceInserted    = "icu_device.inserted"
	EventDeviceRemoved     = "icu_device.removed"
	EventCeilingRecorded   = "icu_goals_of_care.recorded"
	EventReadingRejected   = "icu_observation.rejected"
)

// Config is what a deployment has decided about its units.
type Config struct {
	// Formulas are the severity scores this deployment calculates, by name.
	// Empty means the unit calculates none, which is a configuration rather
	// than a defect: a score nobody has agreed the definition of is one nobody
	// should be acting on.
	Formulas map[string]domain.Formula
	// Bundles are the care bundles this deployment runs, by kind.
	Bundles map[domain.BundleKind]domain.BundleDefinition
	// VitalCodes are the observation codes the dashboard summarises.
	VitalCodes []string
	// StaleAfter is how long a device feed may be silent before the dashboard
	// marks it. Zero takes domain.DefaultStaleAfter.
	StaleAfter time.Duration
}

func (c Config) vitalCodes() []string {
	if len(c.VitalCodes) == 0 {
		// A sensible default rather than an empty dashboard: a unit that has
		// configured nothing still has patients, and these are the codes every
		// critical-care chart has.
		return []string{"heart_rate", "systolic", "map", "spo2", "temperature"}
	}
	return c.VitalCodes
}

// Service is the critical-care use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	episodes    ports.EpisodeRepository
	flowsheet   ports.FlowsheetRepository
	support     ports.SupportRepository
	care        ports.CareRepository
	encounters  ports.Encounters
	escalations ports.Escalations
	events      ports.EventAppender
	audits      ports.AuditAppender
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Episodes   ports.EpisodeRepository
	Flowsheet  ports.FlowsheetRepository
	Support    ports.SupportRepository
	Care       ports.CareRepository
	// Encounters reports whether the Wave-1 encounter still accepts content.
	// Nil accepts everything, which is correct only where no encounter context
	// exists.
	Encounters ports.Encounters
	// Escalations carries an operational condition to somebody who can act on
	// it. Nil records the condition and tells nobody through this software —
	// a six-bed unit where the nurse in charge can see every bed.
	Escalations ports.Escalations
	Events      ports.EventAppender
	Audits      ports.AuditAppender
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, episodes: d.Episodes, flowsheet: d.Flowsheet,
		support: d.Support, care: d.Care, encounters: d.Encounters,
		escalations: d.Escalations, events: d.Events, audits: d.Audits,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 2000
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

// authorize resolves the session and checks one permission.
func (s *Service) authorize(ctx context.Context, permission string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.Unauthenticated(
			"ICU_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"ICU_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// icuError maps a domain refusal to the transport contract.
func icuError(err error) error {
	if errors.Is(err, domain.ErrInvalidEpisode) {
		return rpcerr.Invalid("ICU_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("ICU_VERSION_CONFLICT",
			"somebody else changed this episode; re-read it and try again")
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

// eventSchemaVersion and eventSource identify this context on the stream.
const (
	eventSchemaVersion = 1
	eventSource        = "icu"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ICU_EVENT_ENCODE_FAILED", "could not encode event").
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

// openEpisode reads an episode and refuses one that has closed.
//
// Almost every use case below needs both, and a unit that could chart into a
// discharged episode is one whose ward round reads yesterday's patient.
func (s *Service) openEpisode(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (domain.Episode, error) {

	episode, err := s.episodes.GetEpisode(ctx, scope, episodeID)
	if err != nil {
		return domain.Episode{}, err
	}
	if !episode.Status.Open() {
		return domain.Episode{}, rpcerr.FailedPrecondition("ICU_EPISODE_CLOSED",
			"this critical-care episode is closed")
	}
	return episode, nil
}

// requireWritableEncounter refuses content on a closed encounter, and reports
// the patient the encounter is for.
func (s *Service) requireWritableEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (string, error) {

	if s.encounters == nil {
		return "", nil
	}
	patientID, writable, err := s.encounters.Writable(ctx, scope, encounterID)
	if err != nil {
		return "", err
	}
	if !writable {
		return "", rpcerr.FailedPrecondition("ICU_ENCOUNTER_CLOSED",
			"this encounter no longer accepts content")
	}
	return patientID, nil
}

func trimmed(values ...string) string {
	for _, value := range values {
		if v := strings.TrimSpace(value); v != "" {
			return v
		}
	}
	return ""
}
