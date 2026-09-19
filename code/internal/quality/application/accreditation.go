package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// ClauseInput is one requirement of a standard.
type ClauseInput struct {
	Reference string
	Chapter   string
	Text      string
	Critical  bool
}

// LoadStandardInput registers a standard and its clause tree.
type LoadStandardInput struct {
	Code    string
	Name    string
	Edition string
	Clauses []ClauseInput
}

// LoadStandard registers an accreditation standard (SRS-QMS-009).
//
// The standard and its clauses land in one transaction. A half-loaded standard
// is a readiness report that says the hospital is doing better than it is,
// because the clauses that did not load are clauses nobody is failing.
func (s *Service) LoadStandard(ctx context.Context, in LoadStandardInput) (
	domain.Standard, int, error) {

	session, scope, err := s.authorize(ctx, PermAccreditation)
	if err != nil {
		return domain.Standard{}, 0, err
	}
	if len(in.Clauses) == 0 {
		return domain.Standard{}, 0, rpcerr.Invalid("QMS_EMPTY_STANDARD",
			"a standard is loaded with its clauses")
	}
	now := s.clock.Now()

	standard := domain.Standard{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		Code: in.Code, Name: in.Name, Edition: in.Edition, Active: true,
		CreatedAt: now.UTC(), CreatedBy: session.SubjectID, Version: 1,
	}

	clauses := make([]domain.Clause, 0, len(in.Clauses))
	seen := map[string]bool{}
	for _, clause := range in.Clauses {
		if seen[clause.Reference] {
			return domain.Standard{}, 0, rpcerr.Invalid("QMS_DUPLICATE_CLAUSE",
				"clause "+clause.Reference+" appears twice")
		}
		seen[clause.Reference] = true
		clauses = append(clauses, domain.Clause{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			StandardID: standard.ID, Reference: clause.Reference,
			Chapter: clause.Chapter, Text: clause.Text,
			Critical: clause.Critical, CreatedAt: now.UTC(), Version: 1,
		})
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.accreditation.InsertStandard(ctx, scope,
			standard); err != nil {
			return err
		}
		if err := s.accreditation.InsertClauses(ctx, scope,
			clauses); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.standard.load", ResourceType: "qms_standard",
			ResourceID: standard.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Code + " " + in.Edition + ", " +
				itoa(len(clauses)) + " clause(s)",
		}, now)
	})
	if err != nil {
		return domain.Standard{}, 0, qualityError(err)
	}
	return standard, len(clauses), nil
}

// EvidenceInput files something against a clause.
type EvidenceInput struct {
	ClauseID    string
	Kind        domain.EvidenceKind
	RefID       string
	ExternalRef string
	Description string
}

// FileEvidence files something against a clause (SRS-QMS-009).
//
// Document evidence is pinned to a version, and the version is checked to
// exist. An SOP revised after the evidence was filed is a different document,
// and a survey asking "show me what you filed" must not be shown something
// else.
func (s *Service) FileEvidence(ctx context.Context, in EvidenceInput) (
	domain.Evidence, error) {

	session, scope, err := s.authorize(ctx, PermAccreditation)
	if err != nil {
		return domain.Evidence{}, err
	}
	now := s.clock.Now()

	evidence, err := domain.AddEvidence(s.ids.NewID(), session.TenantID,
		in.ClauseID, in.Kind, in.RefID, in.ExternalRef, in.Description,
		session.SubjectID, now)
	if err != nil {
		return domain.Evidence{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Evidence naming a record that does not exist is a tick in a box that
		// looks like a link.
		switch in.Kind {
		case domain.EvidenceDocument:
			if _, err := s.documents.Version(ctx, scope, in.RefID); err != nil {
				return err
			}
		case domain.EvidenceCAPA:
			if _, err := s.actions.CAPA(ctx, scope, in.RefID); err != nil {
				return err
			}
		case domain.EvidenceAudit:
			if _, err := s.audits.Audit(ctx, scope, in.RefID); err != nil {
				return err
			}
		case domain.EvidenceFinding:
			if _, err := s.audits.Finding(ctx, scope, in.RefID); err != nil {
				return err
			}
		case domain.EvidenceMeeting:
			if _, err := s.committees.Meeting(ctx, scope, in.RefID); err != nil {
				return err
			}
		}

		if err := s.accreditation.InsertEvidence(ctx, scope,
			evidence); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.evidence.file", ResourceType: "qms_evidence",
			ResourceID: evidence.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(in.Kind) + " against clause " + in.ClauseID,
		}, now)
	})
	if err != nil {
		return domain.Evidence{}, qualityError(err)
	}
	return evidence, nil
}

// WithdrawEvidence retires something without deleting it (SRS-QMS-009).
func (s *Service) WithdrawEvidence(ctx context.Context, evidenceID,
	reason string) error {

	session, scope, err := s.authorize(ctx, PermAccreditation)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return qualityError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.accreditation.WithdrawEvidence(ctx, scope, evidenceID,
			session.SubjectID, reason, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.evidence.withdraw", ResourceType: "qms_evidence",
			ResourceID: evidenceID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	}))
}

// ReviewClauseInput records a judgement.
type ReviewClauseInput struct {
	StandardID string
	ClauseID   string
	Verdict    domain.Verdict
	Note       string
	CAPAID     string
}

// ReviewClause records a judgement of one clause (SRS-QMS-009).
//
// The evidence is read here rather than supplied, so "judged met with evidence
// filed" means the evidence is actually there.
func (s *Service) ReviewClause(ctx context.Context, in ReviewClauseInput) (
	domain.ClauseReview, error) {

	session, scope, err := s.authorize(ctx, PermAccreditation)
	if err != nil {
		return domain.ClauseReview{}, err
	}
	now := s.clock.Now()

	var review domain.ClauseReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		byClause, err := s.accreditation.EvidenceForStandard(ctx, scope,
			in.StandardID, true)
		if err != nil {
			return err
		}
		if in.CAPAID != "" {
			if _, err := s.actions.CAPA(ctx, scope, in.CAPAID); err != nil {
				return err
			}
		}

		review, err = domain.ReviewClause(s.ids.NewID(), session.TenantID,
			in.ClauseID, in.Verdict, in.Note, in.CAPAID,
			byClause[in.ClauseID], session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.accreditation.InsertClauseReview(ctx, scope,
			review); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.clause.review", ResourceType: "qms_clause",
			ResourceID: in.ClauseID, Outcome: audit.OutcomeSuccess,
			Reason: string(in.Verdict) + ": " + in.Note,
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventClauseReviewed, "qms_clause",
			in.ClauseID, map[string]any{
				"clause_id":   in.ClauseID,
				"standard_id": in.StandardID,
				"verdict":     string(in.Verdict),
				"capa_id":     in.CAPAID,
			}, now)
	})
	if err != nil {
		return domain.ClauseReview{}, qualityError(err)
	}
	return review, nil
}

// Readiness builds the survey-preparation picture (SRS-QMS-014).
//
// Derived on read, every time. A stored readiness percentage is out of date
// the moment a document is revised or an action closes, and a hospital
// preparing for a survey looks at it daily.
func (s *Service) Readiness(ctx context.Context, standardID string) (
	domain.Readiness, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Readiness{}, err
	}
	now := s.clock.Now()

	clauses, err := s.accreditation.Clauses(ctx, scope, standardID)
	if err != nil {
		return domain.Readiness{}, qualityError(err)
	}
	reviews, err := s.accreditation.LatestReviews(ctx, scope, standardID)
	if err != nil {
		return domain.Readiness{}, qualityError(err)
	}
	evidence, err := s.accreditation.EvidenceForStandard(ctx, scope,
		standardID, true)
	if err != nil {
		return domain.Readiness{}, qualityError(err)
	}

	// The overdue actions are the hospital's, not this standard's: a survey
	// asks whether the quality system is working, and a backlog of overdue
	// corrective actions is the answer whatever clause they came from.
	actions, err := s.actions.CAPAs(ctx, scope, ports.CAPAFilter{
		LiveOnly: true, Limit: reportPageSize,
	})
	if err != nil {
		return domain.Readiness{}, qualityError(err)
	}
	overdue := len(domain.OverdueActions(actions, now))

	return domain.AssessReadiness(standardID, clauses, reviews, evidence,
		s.config.StaleReviewAfter, overdue, now), nil
}

// Standards lists what the hospital is assessed against.
func (s *Service) Standards(ctx context.Context, activeOnly bool) (
	[]domain.Standard, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	standards, err := s.accreditation.Standards(ctx, scope, activeOnly)
	if err != nil {
		return nil, qualityError(err)
	}
	return standards, nil
}

// Clauses lists a standard's requirements.
func (s *Service) Clauses(ctx context.Context, standardID string) (
	[]domain.Clause, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	clauses, err := s.accreditation.Clauses(ctx, scope, standardID)
	if err != nil {
		return nil, qualityError(err)
	}
	return clauses, nil
}

// DefineIndicator adds or revises a dictionary entry (SRS-QMS-010).
//
// The revision number is assigned here, one past whatever exists. A caller
// that chose its own could reuse a number and turn one indicator's history
// into two measurements on the same line.
func (s *Service) DefineIndicator(ctx context.Context, in domain.NewKPIInput) (
	domain.KPIDefinition, error) {

	session, scope, err := s.authorize(ctx, PermIndicator)
	if err != nil {
		return domain.KPIDefinition{}, err
	}
	now := s.clock.Now()

	var definition domain.KPIDefinition
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		current, found, err := s.indicators.CurrentDefinition(ctx, scope,
			in.Code)
		if err != nil {
			return err
		}
		in.Revision = 1
		if found {
			in.Revision = current.Revision + 1
		}
		if in.EffectiveFrom.IsZero() {
			in.EffectiveFrom = now
		}

		definition, err = domain.DefineKPI(s.ids.NewID(), session.TenantID, in,
			session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.indicators.InsertDefinition(ctx, scope,
			definition); err != nil {
			return err
		}
		if found {
			if err := s.indicators.Supersede(ctx, scope, in.Code,
				definition.Revision, now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.indicator.define", ResourceType: "qms_kpi",
			ResourceID: definition.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Code + " revision " + itoa(definition.Revision),
		}, now)
	})
	if err != nil {
		return domain.KPIDefinition{}, qualityError(err)
	}
	return definition, nil
}

// RecordIndicatorInput records a measurement.
type RecordIndicatorInput struct {
	Code        string
	PeriodFrom  time.Time
	PeriodTo    time.Time
	Numerator   int64
	Denominator int64
	SourceNote  string
}

// RecordIndicator records a measurement (SRS-QMS-010).
//
// Against the current definition, whose revision the value carries. A value
// recorded against a revision the caller named could be plotted against a
// target it was never measured for.
func (s *Service) RecordIndicator(ctx context.Context,
	in RecordIndicatorInput) (domain.KPIValue, error) {

	session, scope, err := s.authorize(ctx, PermIndicator)
	if err != nil {
		return domain.KPIValue{}, err
	}
	now := s.clock.Now()

	var value domain.KPIValue
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		definition, found, err := s.indicators.CurrentDefinition(ctx, scope,
			in.Code)
		if err != nil {
			return err
		}
		if !found {
			return rpcerr.NotFound("QMS_NOT_FOUND",
				"no such indicator in the dictionary")
		}

		value, err = domain.RecordKPIValue(s.ids.NewID(), session.TenantID,
			definition, in.PeriodFrom, in.PeriodTo, in.Numerator,
			in.Denominator, in.SourceNote, session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.indicators.InsertValue(ctx, scope, value); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.indicator.record", ResourceType: "qms_kpi_value",
			ResourceID: value.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.Code + " rev " + itoa(definition.Revision) + ": " +
				in.SourceNote,
		}, now)
	})
	if err != nil {
		return domain.KPIValue{}, qualityError(err)
	}
	return value, nil
}

// IndicatorLine is one dictionary entry with its latest measurement
// (SRS-QMS-010).
type IndicatorLine struct {
	Definition domain.KPIDefinition
	// Latest is the most recent value. Zero where nothing has been recorded,
	// and Measured says which — an indicator defined and never measured is a
	// gap, not a zero.
	Latest   domain.KPIValue
	Recorded bool
	// MetTarget is whether the latest value met its target, and Comparable is
	// whether the question could be asked at all. An unanswerable period is
	// not a failure.
	MetTarget  bool
	Comparable bool
}

// Dashboard lists the dictionary with each indicator's latest value
// (SRS-QMS-010).
func (s *Service) Dashboard(ctx context.Context, from, to time.Time) (
	[]IndicatorLine, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}

	definitions, err := s.indicators.Definitions(ctx, scope)
	if err != nil {
		return nil, qualityError(err)
	}

	out := make([]IndicatorLine, 0, len(definitions))
	for _, definition := range definitions {
		line := IndicatorLine{Definition: definition}
		values, err := s.indicators.Values(ctx, scope, definition.Code, from, to)
		if err != nil {
			return nil, qualityError(err)
		}
		if len(values) > 0 {
			line.Latest = values[len(values)-1]
			line.Recorded = true
			line.MetTarget, line.Comparable = line.Latest.MeetsTarget(definition)
		}
		out = append(out, line)
	}
	return out, nil
}

// IndicatorValues lists one indicator's history (SRS-QMS-010).
func (s *Service) IndicatorValues(ctx context.Context, code string,
	from, to time.Time) ([]domain.KPIValue, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	values, err := s.indicators.Values(ctx, scope, code, from, to)
	if err != nil {
		return nil, qualityError(err)
	}
	return values, nil
}
