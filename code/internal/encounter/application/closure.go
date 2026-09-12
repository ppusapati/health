package application

import (
	"context"
	"errors"
	"strconv"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Finalisation, the visit summary and the timeline
// (SRS-ENC-008, SRS-ENC-009, SRS-ENC-011).

// CloseEncounterInput finalises an encounter.
type CloseEncounterInput struct {
	EncounterID string
	// Narrative is the summary text. Assembled by the caller from signed
	// content; this context stores it rather than rendering it, so the document
	// survives a later edit of its sources.
	Narrative string
	// OverrideReason forces closure over an incomplete record where the policy
	// allows it (SRS-ENC-008). Needs the override permission as well.
	OverrideReason string
}

// CloseEncounterResult reports the closure and the document it produced.
type CloseEncounterResult struct {
	Encounter *domain.Encounter
	Summary   domain.VisitSummary
	// Overridden reports a closure forced over an incomplete record, and what
	// was outstanding at the time.
	Overridden bool
	Missing    []domain.DocumentationItem
}

// CloseEncounter finalises an encounter and issues its visit summary
// (SRS-ENC-008, SRS-ENC-009).
//
// The gate and the summary are in one transaction on purpose. A closure that
// committed without its summary would leave an encounter the record says is
// closed and a patient with nothing to take away, and the repair is manual.
func (s *Service) CloseEncounter(ctx context.Context, in CloseEncounterInput) (
	CloseEncounterResult, error) {

	session, scope, err := s.authorize(ctx, PermEncounterClose, "encounter",
		in.EncounterID, true)
	if err != nil {
		return CloseEncounterResult{}, err
	}

	forcing := strings.TrimSpace(in.OverrideReason) != ""
	if forcing && !session.HasPermission(PermEncounterOverride) {
		// The override is what a quality committee reports on. An authority
		// everybody holds is not an authority.
		return CloseEncounterResult{}, rpcerr.PermissionDenied("ENC_OVERRIDE_DENIED",
			"closing an incomplete encounter needs the override permission")
	}

	now := s.clock.Now()

	var result CloseEncounterResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		encounter, err := s.encounters.Get(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}

		closurePolicy, err := s.policies.Resolve(ctx, scope, encounter.FacilityID)
		if err != nil {
			return err
		}

		state, err := s.documentationState(ctx, scope, encounter)
		if err != nil {
			return err
		}

		var missing []domain.DocumentationItem
		if err := closurePolicy.CheckClosure(encounter.Class, state); err != nil {
			var incomplete domain.ErrIncompleteDocumentation
			if !errors.As(err, &incomplete) {
				return encounterError(err)
			}
			if !forcing {
				return encounterError(err)
			}
			if !incomplete.Overridable {
				// Policy decided this class cannot be forced. Saying so
				// plainly beats a permission error the caller cannot act on.
				return rpcerr.FailedPrecondition("ENC_OVERRIDE_NOT_PERMITTED",
					"this facility does not allow a "+string(encounter.Class)+
						" encounter to be closed over an incomplete record")
			}
			missing = incomplete.Missing
		}

		if forcing && len(missing) == 0 {
			// Nothing was blocking, so there is nothing to override. Recording
			// one anyway would put a false entry in the report that exists to
			// count real ones.
			return rpcerr.FailedPrecondition("ENC_NOTHING_TO_OVERRIDE",
				"this encounter is complete; no override is needed")
		}

		before := encounter.Version
		if err := encounter.Close(session.SubjectID, now); err != nil {
			return encounterError(err)
		}

		change := encounter.History[len(encounter.History)-1]
		if err := s.encounters.SetState(ctx, scope, encounter, change, before); err != nil {
			return err
		}

		if len(missing) > 0 {
			override, err := domain.NewClosureOverride(s.ids.NewID(), scope.TenantID(),
				encounter.ID(), missing, in.OverrideReason, session.SubjectID, now)
			if err != nil {
				return encounterError(err)
			}
			if err := s.policies.RecordOverride(ctx, scope, override); err != nil {
				return err
			}
		}

		summary, err := s.generateSummary(ctx, scope, session, encounter, in.Narrative, now)
		if err != nil {
			return err
		}

		if err := s.emitEncounterEvent(ctx, session, EventEncounterCompleted,
			encounter, now, map[string]any{
				"closed":     true,
				"summary_id": summary.ID,
				// Whether documentation was forced, never what was missing: the
				// detail is in the override record, which has the access rules
				// the event stream does not.
				"overridden": len(missing) > 0,
			}); err != nil {
			return err
		}

		result = CloseEncounterResult{
			Encounter: encounter, Summary: summary,
			Overridden: len(missing) > 0, Missing: missing,
		}

		reason := "closed"
		if len(missing) > 0 {
			reason = "closed over incomplete documentation: " + in.OverrideReason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterClose,
			ResourceType: "encounter", ResourceID: encounter.ID(),
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return CloseEncounterResult{}, mapConflict(err)
	}
	return result, nil
}

// documentationState gathers what the encounter actually has.
//
// The facts this context owns are answered here; the clinical ones come from
// the clinical context through a port. A nil port answers "nothing documented",
// which correctly blocks a closure that requires a signed note rather than
// silently passing it: a deployment with no clinical documentation should not
// be able to satisfy a rule about clinical documentation.
func (s *Service) documentationState(ctx context.Context, scope authctx.TenantScope,
	e *domain.Encounter) (domain.DocumentationState, error) {

	state := domain.DocumentationState{
		HasAttendingProvider: e.AttendingProviderID != "",
		HasEndTime:           !e.EndedAt.IsZero(),
	}

	diagnoses, err := s.diagnoses.ForEncounter(ctx, scope, e.ID())
	if err != nil {
		return domain.DocumentationState{}, err
	}
	state.HasFinalDiagnosis = diagnoses.HasFinal()

	if s.clinical == nil {
		return state, nil
	}

	clinical, err := s.clinical.DocumentationFor(ctx, scope, e.ID())
	if err != nil {
		return domain.DocumentationState{}, err
	}
	state.HasSignedNote = clinical.HasSignedNote
	state.HasDischargeDisposition = clinical.HasDischargeDisposition
	// The clinical context may also have seen a final diagnosis this context
	// does not know about — one recorded on a signed note rather than as a
	// coded entry. Either counts.
	state.HasFinalDiagnosis = state.HasFinalDiagnosis || clinical.HasFinalDiagnosis
	return state, nil
}

// generateSummary builds and stores the visit summary (SRS-ENC-009).
func (s *Service) generateSummary(ctx context.Context, scope authctx.TenantScope,
	session authctx.Session, e *domain.Encounter, narrative string, now time.Time) (
	domain.VisitSummary, error) {

	diagnoses, err := s.diagnoses.ForEncounter(ctx, scope, e.ID())
	if err != nil {
		return domain.VisitSummary{}, err
	}
	codes := make([]domain.Coding, 0, len(diagnoses))
	for _, d := range diagnoses.Live() {
		codes = append(codes, d.Code)
	}

	team, err := s.careTeams.ForEncounter(ctx, scope, e.ID())
	if err != nil {
		return domain.VisitSummary{}, err
	}
	members := make([]string, 0, len(team))
	for _, m := range team {
		members = append(members, m.SubjectID)
	}

	summary, err := domain.NewVisitSummary(s.ids.NewID(), scope.TenantID(), e,
		codes, members, narrative, session.SubjectID, now)
	if err != nil {
		return domain.VisitSummary{}, encounterError(err)
	}
	if err := s.summaries.Insert(ctx, scope, summary); err != nil {
		return domain.VisitSummary{}, err
	}
	return summary, nil
}

// AmendSummaryInput produces the next version of a visit summary.
type AmendSummaryInput struct {
	EncounterID string
	Narrative   string
	Reason      string
}

// AmendSummary amends a closed encounter's summary (SRS-ENC-009).
//
// A new version rather than an edit. The previous one stays readable and says
// what was believed at the time, which is the whole point: somebody acted on
// it.
func (s *Service) AmendSummary(ctx context.Context, in AmendSummaryInput) (
	domain.VisitSummary, error) {

	session, scope, err := s.authorize(ctx, PermEncounterClose, "visit_summary",
		in.EncounterID, true)
	if err != nil {
		return domain.VisitSummary{}, err
	}

	now := s.clock.Now()

	var amended domain.VisitSummary
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		versions, err := s.summaries.ForEncounter(ctx, scope, in.EncounterID)
		if err != nil {
			return err
		}
		if len(versions) == 0 {
			return rpcerr.NotFound("ENC_SUMMARY_NOT_FOUND",
				"that encounter has no visit summary to amend")
		}

		// Newest first, so the head of the list is the current version.
		next, err := versions[0].Amend(s.ids.NewID(), in.Narrative, in.Reason,
			session.SubjectID, now)
		if err != nil {
			return encounterError(err)
		}
		if err := s.summaries.Insert(ctx, scope, next); err != nil {
			return err
		}

		amended = next
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterClose,
			ResourceType: "visit_summary", ResourceID: next.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "amended to v" + strconv.Itoa(next.Version) + ": " + in.Reason,
		}, now)
	})
	if err != nil {
		return domain.VisitSummary{}, mapConflict(err)
	}
	return amended, nil
}

// GetSummaries returns every version of an encounter's summary, newest first.
func (s *Service) GetSummaries(ctx context.Context, encounterID string) (
	[]domain.VisitSummary, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "visit_summary",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.VisitSummary
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.summaries.ForEncounter(ctx, scope, encounterID)
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "visit_summary", ResourceID: encounterID,
			Outcome: audit.OutcomeSuccess,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// SetClosurePolicy configures the finalisation rules (SRS-ENC-008).
func (s *Service) SetClosurePolicy(ctx context.Context, facilityID string,
	p domain.ClosurePolicy) error {

	session, scope, err := s.authorize(ctx, PermEncounterConfigure, "closure_policy",
		facilityID, true)
	if err != nil {
		return err
	}
	if err := p.Validate(); err != nil {
		return encounterError(err)
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.policies.Set(ctx, scope, facilityID, p, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterConfigure,
			ResourceType: "closure_policy", ResourceID: facilityID,
			Outcome: audit.OutcomeSuccess, Reason: "closure policy set",
		}, now)
	})
}

// GetClosurePolicy returns the finalisation rules in force.
func (s *Service) GetClosurePolicy(ctx context.Context, facilityID string) (
	domain.ClosurePolicy, error) {

	_, scope, err := s.authorize(ctx, PermEncounterRead, "closure_policy",
		facilityID, false)
	if err != nil {
		return domain.ClosurePolicy{}, err
	}

	var out domain.ClosurePolicy
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.policies.Resolve(ctx, scope, facilityID)
		return err
	})
	if err != nil {
		return domain.ClosurePolicy{}, err
	}
	return out, nil
}

// ListClosureOverrides returns forced closures, which is the report
// SRS-ENC-008 exists to make possible.
func (s *Service) ListClosureOverrides(ctx context.Context, encounterID string,
	pageSize int32) ([]domain.ClosureOverride, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "closure_override",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.ClosureOverride
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.policies.Overrides(ctx, scope, encounterID, clampPageSize(pageSize))
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "closure_override", ResourceID: encounterID,
			Outcome: audit.OutcomeSuccess, Reason: "override report",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// GetTimelineInput asks for a patient's longitudinal record.
type GetTimelineInput struct {
	PatientID string
	From      time.Time
	Until     time.Time
	Kinds     []domain.EntryKind
	PageSize  int32
}

// GetTimeline returns a patient's chronology with confidentiality applied
// (SRS-ENC-011).
//
// The filter runs here, on the way out, rather than in each contributing
// context. A timeline is the screen where every context's output meets, which
// makes it the screen where a confidentiality mistake reaches the most people;
// one rule applied in one place is the only version of this that stays correct
// as contexts are added.
func (s *Service) GetTimeline(ctx context.Context, in GetTimelineInput) (
	[]domain.Entry, error) {

	session, scope, err := s.authorize(ctx, PermEncounterRead, "timeline",
		in.PatientID, false)
	if err != nil {
		return nil, err
	}
	if in.PatientID == "" {
		return nil, rpcerr.Invalid("ENC_TIMELINE_NEEDS_PATIENT",
			"a timeline needs a patient")
	}

	now := s.clock.Now()
	from, until := in.From, in.Until
	if until.IsZero() {
		until = now
	}
	if from.IsZero() {
		// A whole record by default. A timeline that silently showed the last
		// month would make a chart look empty for a patient seen annually.
		from = time.Unix(0, 0).UTC()
	}
	limit := clampPageSize(in.PageSize)

	var out []domain.Entry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		entries, err := s.encounterEntries(ctx, scope, in.PatientID, from, until, limit)
		if err != nil {
			return err
		}

		if s.clinical != nil {
			clinical, err := s.clinical.TimelineFor(ctx, scope, in.PatientID,
				from, until, limit)
			if err != nil {
				return err
			}
			entries = append(entries, clinical...)
		}

		entries = domain.FilterKinds(entries, in.Kinds)
		domain.SortTimeline(entries)
		visible := domain.FilterTimeline(entries, s.timelineAccess(session))

		out = visible

		// SRS-CLN-019: a restricted read is explicitly audited. The entry that
		// was withheld is named so the trail shows what was asked for as well
		// as what was given.
		withheld := domain.Restricted(visible)
		reason := "timeline read"
		if len(withheld) > 0 {
			reason = "timeline read with " + strconv.Itoa(len(withheld)) + " restricted entries masked"
		}
		if session.BreakGlass {
			reason += " (break-glass)"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEncounterRead,
			ResourceType: "timeline", ResourceID: in.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// timelineAccess turns the session into the access the filter applies.
func (s *Service) timelineAccess(session authctx.Session) domain.TimelineAccess {
	access := domain.TimelineAccess{
		SubjectID:          session.SubjectID,
		MaxConfidentiality: domain.ConfidentialityNormal,
		BreakGlass:         session.BreakGlass,
		// Masking rather than omitting, for restricted entries: a clinician who
		// can see that a note exists knows to ask, while an omitted note
		// produces a chart that silently claims to be complete. The
		// very-restricted tier is still omitted — its existence is itself the
		// disclosure — and the domain enforces that distinction.
		MaskRatherThanOmit: true,
	}
	if session.HasPermission(PermRestrictedRead) {
		access.MaxConfidentiality = domain.ConfidentialityRestricted
	}
	return access
}

// encounterEntries projects this context's own records onto the timeline.
func (s *Service) encounterEntries(ctx context.Context, scope authctx.TenantScope,
	patientID string, from, until time.Time, limit int32) ([]domain.Entry, error) {

	encounters, err := s.encounters.ForPatient(ctx, scope, ports.PatientQuery{
		PatientID: patientID, Limit: limit,
	})
	if err != nil {
		return nil, err
	}

	entries := make([]domain.Entry, 0, len(encounters))
	for _, e := range encounters {
		at := e.StartedAt
		if at.IsZero() {
			at = e.CreatedAt
		}
		if at.Before(from) || at.After(until) {
			continue
		}
		entries = append(entries, domain.Entry{
			ID: e.ID(), Kind: domain.EntryEncounter, At: at, EncounterID: e.ID(),
			// The class and status, never the reason for the visit: a title is
			// rendered in list views that a masked entry still appears in.
			Title:           string(e.Class) + " encounter (" + string(e.Status) + ")",
			Confidentiality: domain.ConfidentialityNormal,
			AuthorID:        e.CreatedBy,
		})
	}

	diagnoses, err := s.diagnoses.LiveForPatient(ctx, scope, patientID, limit)
	if err != nil {
		return nil, err
	}
	for _, d := range diagnoses {
		if d.RecordedAt.Before(from) || d.RecordedAt.After(until) {
			continue
		}
		entries = append(entries, domain.Entry{
			ID: d.ID, Kind: domain.EntryDiagnosis, At: d.RecordedAt,
			EncounterID: d.EncounterID, Title: d.Code.Display,
			Confidentiality: domain.ConfidentialityNormal, AuthorID: d.RecordedBy,
		})
	}
	return entries, nil
}
