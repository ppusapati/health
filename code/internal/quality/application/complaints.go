package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// ReceiveComplaint records a grievance (SRS-QMS-011).
//
// The clocks come from the deployment's SLA configuration, not from the
// request. A complainant-facing clock the person taking the complaint can set
// is a clock that will be set generously for the complaints that most need it.
func (s *Service) ReceiveComplaint(ctx context.Context,
	in domain.NewComplaintInput) (domain.Complaint, error) {

	session, scope, err := s.authorize(ctx, PermComplaint)
	if err != nil {
		return domain.Complaint{}, err
	}
	now := s.clock.Now()

	sla := s.config.DefaultComplaintSLA
	if configured, found := s.config.ComplaintSLAByCategory[in.Category]; found {
		sla = configured
	}
	in.AcknowledgeWithin = sla.AcknowledgeWithin
	in.ResolveWithin = sla.ResolveWithin

	complaint, err := domain.ReceiveComplaint(s.ids.NewID(), session.TenantID,
		in, session.SubjectID, now)
	if err != nil {
		return domain.Complaint{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.complaints.InsertComplaint(ctx, scope,
			complaint); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "quality.complaint.receive", ResourceType: "qms_complaint",
			ResourceID: complaint.ID, Outcome: audit.OutcomeSuccess,
			Reason: complaint.Category + " from a " + string(complaint.Kind),
		}, now); err != nil {
			return err
		}
		// Category and department, never the substance and never the
		// complainant. A grievance stream carrying what people said about
		// their care would be the most widely readable copy of it.
		return s.appendEvent(ctx, session, EventComplaintReceived,
			"qms_complaint", complaint.ID, map[string]any{
				"complaint_id": complaint.ID,
				"reference":    complaint.Reference,
				"category":     complaint.Category,
				"department":   complaint.Department,
				"facility_id":  complaint.FacilityID,
			}, now)
	})
	if err != nil {
		return domain.Complaint{}, qualityError(err)
	}
	return complaint, nil
}

// AcknowledgeComplaint records that the complainant has been spoken to
// (SRS-QMS-011).
func (s *Service) AcknowledgeComplaint(ctx context.Context, complaintID string,
	expectedVersion int64) (domain.Complaint, error) {

	return s.mutateComplaint(ctx, complaintID, expectedVersion,
		"quality.complaint.acknowledge", "",
		func(c *domain.Complaint, by string, now time.Time) error {
			return c.Acknowledge(by, now)
		})
}

// ResolveComplaintInput records what was decided.
type ResolveComplaintInput struct {
	ComplaintID     string
	Outcome         domain.Outcome
	Resolution      string
	ExpectedVersion int64
}

// ResolveComplaint records the decision (SRS-QMS-011).
func (s *Service) ResolveComplaint(ctx context.Context,
	in ResolveComplaintInput) (domain.Complaint, error) {

	return s.mutateComplaint(ctx, in.ComplaintID, in.ExpectedVersion,
		"quality.complaint.resolve", string(in.Outcome),
		func(c *domain.Complaint, by string, now time.Time) error {
			return c.Resolve(in.Outcome, in.Resolution, by, now)
		})
}

// CloseComplaint signs a grievance off (SRS-QMS-011).
func (s *Service) CloseComplaint(ctx context.Context, complaintID,
	reason string, expectedVersion int64) (domain.Complaint, error) {

	return s.mutateComplaint(ctx, complaintID, expectedVersion,
		"quality.complaint.close", reason,
		func(c *domain.Complaint, by string, now time.Time) error {
			return c.CloseComplaint(reason, by, now)
		})
}

func (s *Service) mutateComplaint(ctx context.Context, complaintID string,
	expectedVersion int64, action, reason string,
	apply func(*domain.Complaint, string, time.Time) error) (
	domain.Complaint, error) {

	session, scope, err := s.authorize(ctx, PermComplaint)
	if err != nil {
		return domain.Complaint{}, err
	}
	now := s.clock.Now()

	var updated domain.Complaint
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		complaint, err := s.complaints.Complaint(ctx, scope, complaintID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordComplaint,
			complaint.ID); err != nil {
			return err
		}
		if err := apply(&complaint, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.complaints.UpdateComplaint(ctx, scope, complaint,
			expectedVersion); err != nil {
			return err
		}
		complaint.Version = expectedVersion + 1
		updated = complaint
		return s.appendAudit(ctx, session, audit.Record{
			Action: action, ResourceType: "qms_complaint",
			ResourceID: complaint.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Complaint{}, qualityError(err)
	}
	return updated, nil
}

// Complaint reads one grievance.
func (s *Service) Complaint(ctx context.Context, id string) (domain.Complaint,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Complaint{}, err
	}
	complaint, err := s.complaints.Complaint(ctx, scope, id)
	if err != nil {
		return domain.Complaint{}, qualityError(err)
	}
	return complaint, nil
}

// Complaints lists grievances.
func (s *Service) Complaints(ctx context.Context, category string,
	openOnly bool, pageSize int32) ([]domain.Complaint, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	complaints, err := s.complaints.Complaints(ctx, scope, category, openOnly,
		clampPageSize(pageSize))
	if err != nil {
		return nil, qualityError(err)
	}
	return complaints, nil
}

// ComplaintBreaches lists what has run past a clock (SRS-QMS-011).
func (s *Service) ComplaintBreaches(ctx context.Context) (
	[]domain.ComplaintBreach, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	complaints, err := s.complaints.Complaints(ctx, scope, "", true,
		reportPageSize)
	if err != nil {
		return nil, qualityError(err)
	}
	return domain.ComplaintBreaches(complaints, s.clock.Now()), nil
}

// EscalateComplaintBreaches raises a notice for every grievance past a clock
// and marks it escalated (SRS-QMS-011).
//
// The mark is written as well as derived, because the requirement's acceptance
// is that the escalation is retained: a derived-only view loses that it ever
// happened once the complaint is resolved.
func (s *Service) EscalateComplaintBreaches(ctx context.Context) (int, error) {
	session, scope, err := s.authorize(ctx, PermComplaint)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	complaints, err := s.complaints.Complaints(ctx, scope, "", true,
		reportPageSize)
	if err != nil {
		return 0, qualityError(err)
	}
	breaches := domain.ComplaintBreaches(complaints, now)

	raised := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		for _, breach := range breaches {
			complaint := breach.Complaint
			if complaint.Escalated {
				// Already raised. Repeating a notice every time a report runs
				// is how people learn to acknowledge without reading.
				continue
			}

			var missed []string
			if breach.Acknowledgement {
				missed = append(missed, "not acknowledged")
			}
			if breach.Resolution {
				missed = append(missed, "not resolved")
			}

			if s.escalations != nil {
				if _, err := s.escalations.Raise(ctx, scope, ports.Notice{
					Kind: EscalationComplaintBreach,
					// The reference and the category. Never the substance:
					// what somebody said about their care is the last thing
					// that should travel on a pager.
					Subject:    complaint.Reference,
					FacilityID: complaint.FacilityID,
					Summary: complaint.Category + " complaint " +
						strings.Join(missed, " and "),
				}, now); err != nil {
					return err
				}
			}

			complaint.Escalate(now)
			if err := s.complaints.UpdateComplaint(ctx, scope, complaint,
				complaint.Version); err != nil {
				return err
			}
			raised++
		}
		if raised == 0 {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "quality.complaint.escalate", ResourceType: "qms_complaint",
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(raised) + " complaint(s) escalated",
		}, now)
	})
	if err != nil {
		return 0, qualityError(err)
	}
	return raised, nil
}

// StartMortalityReviewInput opens a peer review.
type StartMortalityReviewInput struct {
	PatientID   string
	EncounterID string
	CommitteeID string
	DiedAt      time.Time
}

// StartMortalityReview opens a peer review of a death (SRS-QMS-012).
func (s *Service) StartMortalityReview(ctx context.Context,
	in StartMortalityReviewInput) (domain.MortalityReview, error) {

	session, scope, err := s.authorize(ctx, PermPeerReview)
	if err != nil {
		return domain.MortalityReview{}, err
	}
	now := s.clock.Now()

	review, err := domain.StartMortalityReview(s.ids.NewID(), session.TenantID,
		in.PatientID, in.EncounterID, in.CommitteeID, in.DiedAt,
		session.SubjectID, now)
	if err != nil {
		return domain.MortalityReview{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if in.CommitteeID != "" {
			committee, err := s.committees.Committee(ctx, scope,
				in.CommitteeID)
			if err != nil {
				return err
			}
			if !committee.Restricted {
				// Peer review in an unrestricted committee is peer review in
				// public, which is peer review nobody is honest in.
				return rpcerr.FailedPrecondition("QMS_COMMITTEE_NOT_RESTRICTED",
					"peer review belongs to a restricted committee")
			}
		}
		if err := s.peerReviews.InsertReview(ctx, scope, review); err != nil {
			return err
		}
		// Opening a peer review is itself an access to restricted material
		// about an identified patient, and is audited as one.
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.peerreview.start",
			ResourceType: "qms_mortality_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "mortality review opened",
		}, now)
	})
	if err != nil {
		return domain.MortalityReview{}, qualityError(err)
	}
	return review, nil
}

// CompleteMortalityReviewInput records the committee's verdict.
type CompleteMortalityReviewInput struct {
	ReviewID        string
	MeetingID       string
	Classification  domain.DeathClassification
	Findings        string
	LearningPoints  string
	ActionIDs       []string
	ExpectedVersion int64
}

// CompleteMortalityReview records the committee's verdict (SRS-QMS-012).
//
// The actions are read here rather than trusted, so a preventable death cannot
// be signed off against identifiers that point at nothing.
func (s *Service) CompleteMortalityReview(ctx context.Context,
	in CompleteMortalityReviewInput) (domain.MortalityReview, error) {

	session, scope, err := s.authorize(ctx, PermPeerReview)
	if err != nil {
		return domain.MortalityReview{}, err
	}
	now := s.clock.Now()

	var updated domain.MortalityReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		review, err := s.peerReviews.Review(ctx, scope, in.ReviewID)
		if err != nil {
			return err
		}
		if err := s.heldBack(ctx, scope, domain.RecordMortalityReview,
			review.ID); err != nil {
			return err
		}
		if in.MeetingID != "" {
			if _, err := s.committees.Meeting(ctx, scope,
				in.MeetingID); err != nil {
				return err
			}
		}
		for _, actionID := range in.ActionIDs {
			if _, err := s.actions.CAPA(ctx, scope, actionID); err != nil {
				return err
			}
		}

		if err := review.CompleteMortalityReview(in.MeetingID,
			in.Classification, in.Findings, in.LearningPoints, in.ActionIDs,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.peerReviews.UpdateReview(ctx, scope, review,
			in.ExpectedVersion); err != nil {
			return err
		}
		review.Version = in.ExpectedVersion + 1
		updated = review

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.peerreview.complete",
			ResourceType: "qms_mortality_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: string(in.Classification) + ", " +
				itoa(len(in.ActionIDs)) + " action(s)",
		}, now)
	})
	if err != nil {
		return domain.MortalityReview{}, qualityError(err)
	}
	return updated, nil
}

// MortalityReview reads one peer review (SRS-QMS-012).
//
// Behind the peer-review permission and audited on every read, which is the
// requirement's acceptance: access limited to the authorised committee and
// logged.
func (s *Service) MortalityReview(ctx context.Context, id string) (
	domain.MortalityReview, error) {

	session, scope, err := s.authorize(ctx, PermPeerReview)
	if err != nil {
		return domain.MortalityReview{}, err
	}
	now := s.clock.Now()

	review, err := s.peerReviews.Review(ctx, scope, id)
	if err != nil {
		return domain.MortalityReview{}, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.peerreview.read",
			ResourceType: "qms_mortality_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "read a peer review",
		}, now)
	})
	if err != nil {
		return domain.MortalityReview{}, qualityError(err)
	}
	return review, nil
}

// MortalityReviews lists peer reviews over a period (SRS-QMS-012).
func (s *Service) MortalityReviews(ctx context.Context, openOnly bool,
	from, to time.Time, pageSize int32) ([]domain.MortalityReview, error) {

	session, scope, err := s.authorize(ctx, PermPeerReview)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	reviews, err := s.peerReviews.Reviews(ctx, scope, openOnly, from, to,
		clampPageSize(pageSize))
	if err != nil {
		return nil, qualityError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "quality.peerreview.list",
			ResourceType: "qms_mortality_review",
			Outcome:      audit.OutcomeSuccess,
			Reason:       itoa(len(reviews)) + " peer review(s) read",
		}, now)
	})
	if err != nil {
		return nil, qualityError(err)
	}
	return reviews, nil
}
