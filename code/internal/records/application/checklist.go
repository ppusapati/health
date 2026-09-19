package application

import (
	"context"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// NewChecklistInput configures a chart completion checklist (SRS-MRD-001).
type NewChecklistInput struct {
	Code           string
	Name           string
	Revision       int
	EncounterClass string
	Specialty      string
	Items          []domain.ChecklistItem
	EffectiveFrom  time.Time
}

// DraftChecklist authors a checklist revision (SRS-MRD-001).
func (s *Service) DraftChecklist(ctx context.Context, in NewChecklistInput) (
	domain.ChartChecklist, error) {

	session, scope, err := s.authorize(ctx, PermChecklistWrite)
	if err != nil {
		return domain.ChartChecklist{}, err
	}
	now := s.clock.Now()

	checklist, err := domain.NewChecklist(s.ids.NewID(), session.TenantID,
		domain.NewChecklistInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			EncounterClass: in.EncounterClass, Specialty: in.Specialty,
			Items: in.Items, EffectiveFrom: in.EffectiveFrom,
		}, session.SubjectID, now)
	if err != nil {
		return domain.ChartChecklist{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.checklists.InsertChecklist(ctx, scope,
			checklist); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.checklist.drafted",
			ResourceType: "mrd_checklist", ResourceID: checklist.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": checklist.Code, "revision": itoa(checklist.Revision),
				"encounter_class": checklist.EncounterClass,
				"items":           itoa(len(checklist.Items)),
			}),
			Reason: "authored a chart completion checklist",
		}, now)
	})
	if err != nil {
		return domain.ChartChecklist{}, recordsError(err)
	}
	return checklist, nil
}

// ApproveChecklist puts a checklist in force (SRS-MRD-001).
//
// Approving a revision supersedes the ones before it, so a chart is judged
// against exactly one version. A deficiency already raised keeps the revision
// it was raised under: relaxing the checklist changes what happens next and
// nothing about what the hospital already asked for.
func (s *Service) ApproveChecklist(ctx context.Context, checklistID string,
	effectiveFrom time.Time) (domain.ChartChecklist, error) {

	session, scope, err := s.authorize(ctx, PermChecklistApprove)
	if err != nil {
		return domain.ChartChecklist{}, err
	}
	now := s.clock.Now()

	var approved domain.ChartChecklist
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		checklist, err := s.checklists.Checklist(ctx, scope, checklistID)
		if err != nil {
			return err
		}
		if err := checklist.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.checklists.ApproveChecklist(ctx, scope,
			checklist); err != nil {
			return err
		}
		if err := s.checklists.SupersedeEarlierChecklists(ctx, scope,
			checklist.Code, checklist.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = checklist
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.checklist.approved",
			ResourceType: "mrd_checklist", ResourceID: checklist.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": checklist.Code, "revision": itoa(checklist.Revision),
			}),
			Reason: "put a chart completion checklist in force",
		}, now)
	})
	if err != nil {
		return domain.ChartChecklist{}, recordsError(err)
	}
	return approved, nil
}

// Checklists lists the configured checklists (SRS-MRD-001).
func (s *Service) Checklists(ctx context.Context, encounterClass string,
	liveOnly bool) ([]domain.ChartChecklist, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	var liveAt time.Time
	if liveOnly {
		liveAt = s.clock.Now()
	}
	return s.checklists.Checklists(ctx, scope, encounterClass, liveAt)
}

// ChartStatus is what a chart is missing and against which checklist
// (SRS-MRD-001).
type ChartStatus struct {
	EncounterID string
	PatientID   string
	// ChecklistCode and ChecklistRevision pin the version the chart was
	// judged against, so an answer given today can be explained next year.
	ChecklistCode     string
	ChecklistRevision int
	Gaps              []domain.Gap
	// Documents counts what the chart holds, so "no gaps" and "no documents
	// and no checklist" are distinguishable to a reader.
	Documents int
}

// ChartGaps reports what a chart is missing (SRS-MRD-001).
//
// Derived rather than stored. A stored answer would be stale the moment a
// clinician signed something, and the question "is this chart complete" is
// asked precisely at the moments it is changing.
func (s *Service) ChartGaps(ctx context.Context, encounterID string) (
	ChartStatus, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return ChartStatus{}, err
	}
	now := s.clock.Now()

	status, _, err := s.chartStatus(ctx, scope, encounterID, now)
	if err != nil {
		return ChartStatus{}, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "records.chart.read", ResourceType: "mrd_chart",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"checklist": status.ChecklistCode,
			"revision":  itoa(status.ChecklistRevision),
			"gaps":      itoa(len(status.Gaps)),
		}),
		Reason: "read a chart's completion status",
	}, now); err != nil {
		return ChartStatus{}, err
	}
	return status, nil
}

// chartStatus derives a chart's gaps without deciding who may see them.
//
// Split out so the deficiency sweep does not have to hold the read permission
// as well as its own: a caller that may raise deficiencies is already
// authorised for the thing it is about to do, and requiring a second
// permission would mean either granting the records office more than it needs
// or a sweep that fails on a role nobody thought about.
func (s *Service) chartStatus(ctx context.Context, scope authctx.TenantScope,
	encounterID string, now time.Time) (ChartStatus, ports.EncounterFacts,
	error) {

	facts, documents, err := s.chartInputs(ctx, scope, encounterID)
	if err != nil {
		return ChartStatus{}, ports.EncounterFacts{}, err
	}

	checklists, err := s.checklists.Checklists(ctx, scope, facts.Class, now)
	if err != nil {
		return ChartStatus{}, ports.EncounterFacts{}, err
	}
	checklist, found := domain.ChecklistFor(checklists, facts.Class,
		facts.Specialty, now)
	if !found {
		// Named rather than reported as a complete chart. A hospital with no
		// checklist for a class of encounter has not decided what a complete
		// chart is, and "no gaps" would be the wrong way to say so.
		return ChartStatus{}, ports.EncounterFacts{}, rpcerr.FailedPrecondition(
			"MRD_NO_CHECKLIST",
			"no approved checklist covers this encounter class")
	}

	return ChartStatus{
		EncounterID: encounterID, PatientID: facts.PatientID,
		ChecklistCode: checklist.Code, ChecklistRevision: checklist.Revision,
		Documents: len(documents),
		Gaps: domain.ChartGaps(checklist, documents, facts.Conditions,
			facts.EndedAt),
	}, facts, nil
}

// chartInputs reads the two things outside this context that a chart is
// judged from (SRS-MRD-001).
//
// Both are refusals rather than empty answers when the seam is not wired. An
// encounter with no document list looks exactly like an encounter whose
// documents are all missing, and reporting the second when the truth is the
// first would put every clinician in the hospital on a deficiency worklist.
func (s *Service) chartInputs(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterFacts, []domain.ChartDocument,
	error) {

	if s.encounters == nil || s.documents == nil {
		return ports.EncounterFacts{}, nil, rpcerr.FailedPrecondition(
			"MRD_NO_CHART_SOURCE",
			"this deployment has no encounter or document source wired, so "+
				"chart completion cannot be answered")
	}
	facts, err := s.encounters.Describe(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterFacts{}, nil, err
	}
	documents, err := s.documents.ForEncounter(ctx, scope, facts.PatientID,
		encounterID)
	if err != nil {
		return ports.EncounterFacts{}, nil, err
	}
	return facts, documents, nil
}

func itoa(n int) string { return strconv.Itoa(n) }
