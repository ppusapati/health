package application

import (
	"context"
	"strings"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
)

// AssignCodesInput is one pass of coding on an encounter (SRS-MRD-003).
type AssignCodesInput struct {
	EncounterID string
	Codes       []domain.AssignedCode
	// Reason is required from the second revision onward: a coding that
	// changed with no reason is one nobody can defend to a payer.
	Reason string
}

// AssignCodes records a coding revision (SRS-MRD-003).
//
// Append-only. A correction adds a revision; it does not edit the one that
// was already billed on, because "what did we submit" has to stay answerable
// after somebody has re-coded the episode.
func (s *Service) AssignCodes(ctx context.Context, in AssignCodesInput) (
	domain.CodedEpisode, error) {

	session, scope, err := s.authorize(ctx, PermCodingWrite)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	now := s.clock.Now()

	if err := s.checkCodingSystems(in.Codes); err != nil {
		return domain.CodedEpisode{}, err
	}

	var episode domain.CodedEpisode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		existing, found, err := s.coding.EpisodeForEncounter(ctx, scope,
			in.EncounterID)
		if err != nil {
			return err
		}
		if !found {
			facts, _, err := s.chartInputs(ctx, scope, in.EncounterID)
			if err != nil {
				return err
			}
			existing, err = domain.StartCoding(s.ids.NewID(),
				session.TenantID, facts.PatientID, in.EncounterID,
				facts.FacilityID, session.SubjectID, now)
			if err != nil {
				return err
			}
			if err := s.coding.InsertEpisode(ctx, scope, existing); err != nil {
				return err
			}
		}

		expected := existing.Version
		if err := existing.AssignCodes(in.Codes, in.Reason,
			session.SubjectID, now); err != nil {
			return err
		}
		revision, _ := existing.Current()
		if err := s.coding.AppendRevision(ctx, scope, existing, revision,
			expected); err != nil {
			return err
		}
		episode = existing

		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.coding.assigned", ResourceType: "mrd_coding",
			ResourceID: existing.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"encounter_id": in.EncounterID,
				"revision":     itoa(revision.Revision),
				"codes":        itoa(len(revision.Codes)),
			}),
			Reason: in.Reason,
		}, now)
	})
	if err != nil {
		return domain.CodedEpisode{}, recordsError(err)
	}
	return episode, nil
}

// FinaliseCoding records the second read that makes a coding final
// (SRS-MRD-003).
//
// The domain refuses the coder whoever holds the permission. A coding signed
// off by the person who assigned it is a single read with two names on it,
// and the reason a second read exists is that the first one is wrong often
// enough to matter.
func (s *Service) FinaliseCoding(ctx context.Context, episodeID string) (
	domain.CodedEpisode, error) {

	session, scope, err := s.authorize(ctx, PermCodingFinalise)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	now := s.clock.Now()

	var episode domain.CodedEpisode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.coding.Episode(ctx, scope, episodeID)
		if err != nil {
			return err
		}
		if err := found.Finalise(session.SubjectID, now); err != nil {
			return err
		}
		revision, _ := found.Current()
		if err := s.coding.SetRevisionState(ctx, scope, found.ID,
			revision); err != nil {
			return err
		}
		episode = found

		if err := s.appendEvent(ctx, session, EventCodingFinal, "mrd_coding",
			found.ID, map[string]any{
				"encounter_id": found.EncounterID,
				"revision":     revision.Revision,
				"codes":        len(revision.Codes),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.coding.finalised", ResourceType: "mrd_coding",
			ResourceID: found.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"revision": itoa(revision.Revision),
			}),
			Reason: "second read: coding is final",
		}, now)
	})
	if err != nil {
		return domain.CodedEpisode{}, recordsError(err)
	}
	return episode, nil
}

// QueryCoding holds a coding open while a question goes back to the clinician
// (SRS-MRD-003).
//
// The state matters on its own: a queried episode cannot be finalised, so a
// question asked on Friday cannot be signed off on Monday by somebody who did
// not know it was outstanding.
func (s *Service) QueryCoding(ctx context.Context, episodeID string) (
	domain.CodedEpisode, error) {

	session, scope, err := s.authorize(ctx, PermCodingQuery)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	now := s.clock.Now()

	var episode domain.CodedEpisode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.coding.Episode(ctx, scope, episodeID)
		if err != nil {
			return err
		}
		if err := found.Query(session.SubjectID, now); err != nil {
			return err
		}
		revision, _ := found.Current()
		if err := s.coding.SetRevisionState(ctx, scope, found.ID,
			revision); err != nil {
			return err
		}
		episode = found

		if err := s.appendEvent(ctx, session, EventCodingQueried,
			"mrd_coding", found.ID, map[string]any{
				"encounter_id": found.EncounterID,
				"revision":     revision.Revision,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.coding.queried", ResourceType: "mrd_coding",
			ResourceID: found.ID, Outcome: audit.OutcomeSuccess,
			Reason: "a coding question is outstanding with the clinician",
		}, now)
	})
	if err != nil {
		return domain.CodedEpisode{}, recordsError(err)
	}
	return episode, nil
}

// CodedEpisode reads an episode with its whole revision history
// (SRS-MRD-003).
func (s *Service) CodedEpisode(ctx context.Context, episodeID string) (
	domain.CodedEpisode, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	now := s.clock.Now()

	episode, err := s.coding.Episode(ctx, scope, episodeID)
	if err != nil {
		return domain.CodedEpisode{}, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "records.coding.read", ResourceType: "mrd_coding",
		ResourceID: episodeID, Outcome: audit.OutcomeSuccess,
		Reason: "read a coded episode",
	}, now); err != nil {
		return domain.CodedEpisode{}, err
	}
	return episode, nil
}

// CodingDiff reports what changed between two revisions (SRS-MRD-003).
//
// SRS-MRD-003's acceptance is that coder changes retain provenance, and a
// list of two codings side by side is what somebody asking "why did the
// payment change" actually needs.
func (s *Service) CodingDiff(ctx context.Context, episodeID string,
	before, after int) ([]domain.CodingChange, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	episode, err := s.coding.Episode(ctx, scope, episodeID)
	if err != nil {
		return nil, err
	}

	find := func(n int) (domain.CodingRevision, bool) {
		for _, revision := range episode.Revisions {
			if revision.Revision == n {
				return revision, true
			}
		}
		return domain.CodingRevision{}, false
	}
	from, ok := find(before)
	if !ok {
		return nil, rpcerr.NotFound("MRD_NO_REVISION",
			"this episode has no revision "+itoa(before))
	}
	to, ok := find(after)
	if !ok {
		return nil, rpcerr.NotFound("MRD_NO_REVISION",
			"this episode has no revision "+itoa(after))
	}
	return domain.Diff(from, to), nil
}

// checkCodingSystems refuses a code in a terminology this deployment does not
// code in (SRS-MRD-003).
//
// Configured rather than hard-coded, because a hospital group runs ICD-10 in
// one country and ICD-11 in another. The check is here rather than in the
// domain because it is a deployment's decision; what the domain refuses is a
// code with no system or no edition at all, which is wrong everywhere.
func (s *Service) checkCodingSystems(codes []domain.AssignedCode) error {
	if len(s.config.CodingSystems) == 0 {
		return nil
	}
	for _, code := range codes {
		edition, known := s.config.CodingSystems[strings.ToLower(code.System)]
		if !known {
			return rpcerr.Invalid("MRD_UNKNOWN_CODE_SYSTEM",
				"this deployment does not code in "+code.System)
		}
		if edition != "" && !strings.EqualFold(edition, code.Version) {
			// A grouper reading the wrong edition produces a number rather
			// than an error, which is how a coding defect becomes a payment
			// defect nobody notices.
			return rpcerr.Invalid("MRD_WRONG_CODE_EDITION",
				code.System+" is coded here in edition "+edition+
					", not "+code.Version)
		}
	}
	return nil
}
