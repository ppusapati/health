package application

import (
	"context"
	"sort"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// RegisterDocument records a controlled document (SRS-QMS-006).
func (s *Service) RegisterDocument(ctx context.Context,
	in domain.NewDocumentInput) (domain.ControlledDocument, error) {

	session, scope, err := s.authorize(ctx, PermDocument)
	if err != nil {
		return domain.ControlledDocument{}, err
	}
	now := s.clock.Now()

	document, err := domain.NewControlledDocument(s.ids.NewID(),
		session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.ControlledDocument{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.documents.InsertDocument(ctx, scope, document); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.document.register", ResourceType: "qms_document",
			ResourceID: document.ID, Outcome: audit.OutcomeSuccess,
			Reason: document.Code + " " + document.Title,
		}, now)
	})
	if err != nil {
		return domain.ControlledDocument{}, qualityError(err)
	}
	return document, nil
}

// DraftVersion starts a revision (SRS-QMS-006).
//
// The ordinal is assigned here rather than supplied: two people drafting from
// the same screen would otherwise both pick the next number, and the unique
// index would refuse the second with an error about an index.
func (s *Service) DraftVersion(ctx context.Context,
	in domain.NewVersionInput) (domain.DocumentVersion, error) {

	session, scope, err := s.authorize(ctx, PermDocument)
	if err != nil {
		return domain.DocumentVersion{}, err
	}
	now := s.clock.Now()

	var version domain.DocumentVersion
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.documents.Document(ctx, scope,
			in.DocumentID); err != nil {
			return err
		}
		existing, err := s.documents.Versions(ctx, scope, in.DocumentID)
		if err != nil {
			return err
		}
		next := 1
		for _, one := range existing {
			if one.Ordinal >= next {
				next = one.Ordinal + 1
			}
		}
		in.Ordinal = next
		if in.Label == "" {
			in.Label = itoa(next) + ".0"
		}

		version, err = domain.DraftVersion(s.ids.NewID(), session.TenantID, in,
			session.SubjectID, now)
		if err != nil {
			return err
		}
		if err := s.documents.InsertVersion(ctx, scope, version); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.document.draft", ResourceType: "qms_document_version",
			ResourceID: version.ID, Outcome: audit.OutcomeSuccess,
			Reason: "version " + version.Label,
		}, now)
	})
	if err != nil {
		return domain.DocumentVersion{}, qualityError(err)
	}
	return version, nil
}

// ApproveVersionInput signs a revision off.
type ApproveVersionInput struct {
	VersionID       string
	EffectiveFrom   time.Time
	ExpectedVersion int64
}

// ApproveVersion makes a draft into policy (SRS-QMS-006).
//
// Approving supersedes whatever was in force from the new version's effective
// date, in the same transaction. Two versions both in force is the state the
// whole of document control exists to prevent, and a sweep that fixed it
// afterwards would leave a window in which the hospital had two hand hygiene
// policies.
func (s *Service) ApproveVersion(ctx context.Context,
	in ApproveVersionInput) (domain.DocumentVersion, error) {

	session, scope, err := s.authorize(ctx, PermApproveDocument)
	if err != nil {
		return domain.DocumentVersion{}, err
	}
	now := s.clock.Now()

	var updated domain.DocumentVersion
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		version, err := s.documents.Version(ctx, scope, in.VersionID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordDocumentVersion,
			version.ID); err != nil {
			return err
		}
		if err := version.ApproveVersion(session.SubjectID, in.EffectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.documents.UpdateVersion(ctx, scope, version,
			in.ExpectedVersion); err != nil {
			return err
		}
		version.Version = in.ExpectedVersion + 1
		updated = version

		superseded, err := s.supersedeOthers(ctx, scope, version)
		if err != nil {
			return err
		}

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.document.approve",
			ResourceType: "qms_document_version", ResourceID: version.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "effective " + version.EffectiveFrom.Format(time.RFC3339) +
				", superseding " + itoa(superseded),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventDocumentApproved,
			"qms_document", version.DocumentID, map[string]any{
				"document_id":              version.DocumentID,
				"version_id":               version.ID,
				"label":                    version.Label,
				"effective_from":           version.EffectiveFrom.Format(time.RFC3339),
				"requires_acknowledgement": version.RequiresAcknowledgement,
				"requires_retraining":      version.RequiresRetraining,
			}, now)
	})
	if err != nil {
		return domain.DocumentVersion{}, qualityError(err)
	}
	return updated, nil
}

// supersedeOthers retires every earlier version from the new one's effective
// date.
func (s *Service) supersedeOthers(ctx context.Context,
	scope authctx.TenantScope, incoming domain.DocumentVersion) (int, error) {

	versions, err := s.documents.Versions(ctx, scope, incoming.DocumentID)
	if err != nil {
		return 0, err
	}

	count := 0
	for _, version := range versions {
		if version.ID == incoming.ID || version.State == domain.VersionDraft {
			continue
		}
		if version.Ordinal >= incoming.Ordinal {
			continue
		}
		// Already ending no later than the new one starts.
		if !version.ObsoleteFrom.IsZero() &&
			!version.ObsoleteFrom.After(incoming.EffectiveFrom) {
			continue
		}
		version.ObsoleteFrom = incoming.EffectiveFrom
		version.State = domain.VersionObsolete
		if err := s.documents.UpdateVersion(ctx, scope, version,
			version.Version); err != nil {
			return 0, err
		}
		count++
	}
	return count, nil
}

// CurrentVersion is the revision in force right now (SRS-QMS-006).
func (s *Service) CurrentVersion(ctx context.Context, documentID string) (
	domain.DocumentVersion, bool, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.DocumentVersion{}, false, err
	}
	versions, err := s.documents.Versions(ctx, scope, documentID)
	if err != nil {
		return domain.DocumentVersion{}, false, qualityError(err)
	}
	current, found := domain.CurrentVersion(versions, s.clock.Now())
	return current, found, nil
}

// Versions lists every revision, which is the history the requirement says is
// retained (SRS-QMS-006).
func (s *Service) Versions(ctx context.Context, documentID string) (
	[]domain.DocumentVersion, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	versions, err := s.documents.Versions(ctx, scope, documentID)
	if err != nil {
		return nil, qualityError(err)
	}
	return versions, nil
}

// Documents lists the register.
func (s *Service) Documents(ctx context.Context, f ports.DocumentFilter) (
	[]domain.ControlledDocument, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)
	documents, err := s.documents.Documents(ctx, scope, f)
	if err != nil {
		return nil, qualityError(err)
	}
	return documents, nil
}

// Acknowledge confirms the caller has read the version in force
// (SRS-QMS-006).
//
// The caller acknowledges the current version, not one they name. A client
// that could choose which version it was confirming could confirm the old one
// for ever.
func (s *Service) Acknowledge(ctx context.Context, documentID, role string) (
	domain.Acknowledgement, error) {

	session, scope, err := s.authorize(ctx, PermAcknowledge)
	if err != nil {
		return domain.Acknowledgement{}, err
	}
	now := s.clock.Now()

	var ack domain.Acknowledgement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		versions, err := s.documents.Versions(ctx, scope, documentID)
		if err != nil {
			return err
		}
		current, found := domain.CurrentVersion(versions, now)
		if !found {
			return rpcerrNoEffectiveVersion()
		}

		ack = domain.Acknowledgement{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			VersionID: current.ID, DocumentID: documentID,
			PersonID: session.SubjectID, Role: role,
			AcknowledgedAt: now.UTC(),
		}
		if err := s.documents.Acknowledge(ctx, scope, ack); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.document.acknowledge",
			ResourceType: "qms_document_version", ResourceID: current.ID,
			Outcome: audit.OutcomeSuccess, Reason: "version " + current.Label,
		}, now)
	})
	if err != nil {
		return domain.Acknowledgement{}, qualityError(err)
	}
	return ack, nil
}

// OutstandingAcknowledgements lists who has not read what (SRS-QMS-006).
//
// Derived on read against the version in force, so a person who confirmed
// version 2 appears again the moment version 3 takes effect. That is what
// re-issuing a policy is for.
func (s *Service) OutstandingAcknowledgements(ctx context.Context,
	documentID string) ([]domain.AcknowledgementGap, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	document, err := s.documents.Document(ctx, scope, documentID)
	if err != nil {
		return nil, qualityError(err)
	}
	versions, err := s.documents.Versions(ctx, scope, documentID)
	if err != nil {
		return nil, qualityError(err)
	}
	current, found := domain.CurrentVersion(versions, now)
	if !found {
		return nil, nil
	}

	acknowledged, err := s.documents.Acknowledgements(ctx, scope, current.ID)
	if err != nil {
		return nil, qualityError(err)
	}

	// Who is expected to have read it. Nil where no directory is wired or no
	// roles are configured, which reports no gaps — a clean report that means
	// nothing, and one the status document names rather than this code
	// pretending the hospital is compliant.
	expected := map[string]string{}
	if s.staff != nil && len(s.config.AcknowledgementRoles) > 0 {
		expected, err = s.staff.RolesByPerson(ctx, scope,
			s.config.AcknowledgementRoles)
		if err != nil {
			return nil, qualityError(err)
		}
	}

	return domain.OutstandingAcknowledgements(document, versions, expected,
		acknowledged, now), nil
}

// ReviewsDue lists the controlled documents past their own review interval
// (SRS-QMS-006).
func (s *Service) ReviewsDue(ctx context.Context) ([]domain.ReviewDue, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	documents, err := s.documents.Documents(ctx, scope, ports.DocumentFilter{
		ExcludeWithdrawn: true, Limit: reportPageSize,
	})
	if err != nil {
		return nil, qualityError(err)
	}

	var out []domain.ReviewDue
	for _, document := range documents {
		versions, err := s.documents.Versions(ctx, scope, document.ID)
		if err != nil {
			return nil, qualityError(err)
		}
		if due, reported := domain.ReviewsDue(document, versions,
			now); reported {
			out = append(out, due)
		}
	}

	sort.Slice(out, func(a, b int) bool {
		// Nothing in force first, then the most overdue, then the ones nobody
		// set an interval for: worst-known before least-known.
		if out[a].NoEffectiveVersion != out[b].NoEffectiveVersion {
			return out[a].NoEffectiveVersion
		}
		if out[a].DaysOverdue != out[b].DaysOverdue {
			return out[a].DaysOverdue > out[b].DaysOverdue
		}
		return out[a].Code < out[b].Code
	})
	return out, nil
}

// DefineCompetency registers a skill (SRS-QMS-013).
func (s *Service) DefineCompetency(ctx context.Context, code, name,
	documentID string, validMonths int) (domain.Competency, error) {

	session, scope, err := s.authorize(ctx, PermCompetency)
	if err != nil {
		return domain.Competency{}, err
	}
	now := s.clock.Now()

	competency := domain.Competency{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		Code: code, Name: name, DocumentID: documentID,
		ValidMonths: validMonths, Active: true,
		CreatedAt: now.UTC(), CreatedBy: session.SubjectID, Version: 1,
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if documentID != "" {
			if _, err := s.documents.Document(ctx, scope,
				documentID); err != nil {
				return err
			}
		}
		if err := s.competencies.InsertCompetency(ctx, scope,
			competency); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.competency.define",
			ResourceType: "qms_competency", ResourceID: competency.ID,
			Outcome: audit.OutcomeSuccess, Reason: code,
		}, now)
	})
	if err != nil {
		return domain.Competency{}, qualityError(err)
	}
	return competency, nil
}

// RequireCompetency says a role needs a skill (SRS-QMS-013).
func (s *Service) RequireCompetency(ctx context.Context, role,
	competencyID string) error {

	session, scope, err := s.authorize(ctx, PermCompetency)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return qualityError(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.competencies.RequireForRole(ctx, scope, role,
			competencyID); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.competency.require",
			ResourceType: "qms_competency", ResourceID: competencyID,
			Outcome: audit.OutcomeSuccess, Reason: role,
		}, now)
	}))
}

// AwardInput records somebody holding a competency.
type AwardInput struct {
	CompetencyID string
	PersonID     string
	// VersionID is the document version they were trained against. Read from
	// the competency's document where the caller leaves it empty, so a
	// retraining rule has something to compare against rather than a blank.
	VersionID string
	Evidence  string
	AwardedAt time.Time
}

// AwardCompetency records training or assessment (SRS-QMS-013).
//
// The expiry is computed from the competency's own validity period rather than
// supplied. A caller that could set its own expiry could award a one-year
// certificate that lasts ten.
func (s *Service) AwardCompetency(ctx context.Context, in AwardInput) (
	domain.Award, error) {

	session, scope, err := s.authorize(ctx, PermCompetency)
	if err != nil {
		return domain.Award{}, err
	}
	now := s.clock.Now()

	var award domain.Award
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		competencies, err := s.competencies.Competencies(ctx, scope, false)
		if err != nil {
			return err
		}
		var competency domain.Competency
		for _, one := range competencies {
			if one.ID == in.CompetencyID {
				competency = one
				break
			}
		}
		if competency.ID == "" {
			return rpcerrUnknownCompetency()
		}

		versionID := in.VersionID
		if versionID == "" && competency.DocumentID != "" {
			versions, err := s.documents.Versions(ctx, scope,
				competency.DocumentID)
			if err != nil {
				return err
			}
			if current, found := domain.CurrentVersion(versions, now); found {
				versionID = current.ID
			}
		}

		awardedAt := in.AwardedAt
		if awardedAt.IsZero() {
			awardedAt = now
		}
		award = domain.Award{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			CompetencyID: competency.ID, PersonID: in.PersonID,
			VersionID: versionID, Evidence: in.Evidence,
			AwardedAt: awardedAt.UTC(), AwardedBy: session.SubjectID,
		}
		if competency.ValidMonths > 0 {
			award.ExpiresAt = awardedAt.AddDate(0, competency.ValidMonths, 0).UTC()
		}

		if err := s.competencies.InsertAward(ctx, scope, award); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.competency.award", ResourceType: "qms_competency",
			ResourceID: competency.ID, Outcome: audit.OutcomeSuccess,
			Reason: in.PersonID + ": " + in.Evidence,
		}, now)
	})
	if err != nil {
		return domain.Award{}, qualityError(err)
	}
	return award, nil
}

// CompetencyGaps lists who is missing what their role requires
// (SRS-QMS-013).
//
// Three different answers — never held, expired, and trained against
// superseded text — because they need three different actions: train them,
// re-assess them, or brief them on what changed.
func (s *Service) CompetencyGaps(ctx context.Context) ([]domain.CompetencyGap,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	competencies, err := s.competencies.Competencies(ctx, scope, true)
	if err != nil {
		return nil, qualityError(err)
	}
	required, err := s.competencies.RoleRequirements(ctx, scope)
	if err != nil {
		return nil, qualityError(err)
	}
	awards, err := s.competencies.Awards(ctx, scope, "", reportPageSize)
	if err != nil {
		return nil, qualityError(err)
	}

	people := map[string]string{}
	if s.staff != nil && len(s.config.CompetencyRoles) > 0 {
		people, err = s.staff.RolesByPerson(ctx, scope, s.config.CompetencyRoles)
		if err != nil {
			return nil, qualityError(err)
		}
	}

	index := make(map[string]domain.Competency, len(competencies))
	// retrainedFrom names, per competency, the document version that training
	// must now be against — the current one, where the current one asked for
	// retraining. A revision that did not ask expires nobody, which is what
	// keeps a typo correction from invalidating a ward's records.
	retrainedFrom := map[string]string{}
	for _, competency := range competencies {
		index[competency.ID] = competency
		if competency.DocumentID == "" {
			continue
		}
		versions, err := s.documents.Versions(ctx, scope, competency.DocumentID)
		if err != nil {
			return nil, qualityError(err)
		}
		if current, found := domain.CurrentVersion(versions,
			now); found && current.RequiresRetraining {
			retrainedFrom[competency.ID] = current.ID
		}
	}

	return domain.CompetencyGaps(required, people, awards, index,
		retrainedFrom, now), nil
}

func rpcerrNoEffectiveVersion() error {
	// A gap somebody has to see rather than an acknowledgement of a draft.
	return rpcerr.FailedPrecondition("QMS_NO_EFFECTIVE_VERSION",
		"this document has no version in force to acknowledge")
}

func rpcerrUnknownCompetency() error {
	return rpcerr.NotFound("QMS_NOT_FOUND", "no such competency")
}
