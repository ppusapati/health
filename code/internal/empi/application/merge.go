package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Merge, unmerge and duplicate review (SRS-EMPI-004/005/006).
//
// Every use case here is behind PermPatientMerge, held only by him_officer.
// The Wave-1 backlog lists SRS-EMPI-005 under the read permission, which would
// give every clerk who can search the ability to fuse two people's charts; see
// docs/engineering/wave-1-status.md for why that is read as a transcription
// slip rather than followed.

// Event types for merge (SRS-EMPI-018).
const (
	// EventPatientMerged is emitted once a merge is committed.
	EventPatientMerged = "patient.merged"
	// EventPatientUnmerged is emitted when one is reversed.
	EventPatientUnmerged = "patient.unmerged"
)

// MergePatientsInput names the two records and why.
type MergePatientsInput struct {
	// SurvivorID keeps its own patient id and its own MRN. Choosing which
	// record survives is a decision the reviewer makes — usually the one with
	// the clinical history — and it is not inferred here.
	SurvivorID string
	MergedID   string
	Reason     string
	// CandidateID, when set, closes the review-queue entry this merge came
	// from.
	CandidateID string
}

// MergePatientsResult carries both records as they now stand.
type MergePatientsResult struct {
	Survivor    *domain.Patient
	Identifiers domain.IdentifierSet
	MergedID    string
	MergeID     string
}

// MergePatients fuses two records through the reviewed workflow (SRS-EMPI-005).
//
// The whole operation is one transaction. A merge that moved half the
// identifiers and then failed would leave a record pointing at a survivor that
// does not hold its MRN — and the next search for that MRN would find nobody.
func (s *Service) MergePatients(ctx context.Context, in MergePatientsInput) (MergePatientsResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return MergePatientsResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientMerge,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientMerge, "patient", in.MergedID, decision.Reason)
		return MergePatientsResult{}, rpcerr.PermissionDenied("EMPI_MERGE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var result MergePatientsResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		survivor, err := s.patients.GetByID(ctx, scope, in.SurvivorID)
		if err != nil {
			return err
		}
		merged, err := s.patients.GetByID(ctx, scope, in.MergedID)
		if err != nil {
			return err
		}

		survivorIdentifiers, err := s.identifiers.ForPatient(ctx, scope, survivor.ID())
		if err != nil {
			return err
		}
		mergedIdentifiers, err := s.identifiers.ForPatient(ctx, scope, merged.ID())
		if err != nil {
			return err
		}

		plan, err := domain.PlanMerge(survivor, merged, survivorIdentifiers, mergedIdentifiers)
		if err != nil {
			return mergeError(err)
		}

		record, err := plan.Apply(s.ids.NewID(), session.SubjectID, in.Reason, now)
		if err != nil {
			return mergeError(err)
		}

		// Identifiers move first. If this fails the transaction unwinds with
		// nothing merged, which is the safe direction — the alternative is a
		// record marked merged whose MRN still points at it.
		for _, move := range plan.MoveToSurvivor {
			reason := "merged from " + merged.ID()
			if err := s.merges.MoveIdentifier(ctx, scope, move.Identifier.ID,
				survivor.ID(), move.NewStatus, false, reason, now); err != nil {
				return err
			}
		}

		if plan.CarryDeceased {
			if err := s.merges.SetDeceased(ctx, scope, survivor); err != nil {
				return err
			}
		}
		if err := s.merges.SetMergedInto(ctx, scope, merged); err != nil {
			return err
		}
		if err := s.merges.RecordMerge(ctx, scope, record); err != nil {
			return err
		}

		if err := s.closeCandidate(ctx, scope, session, in.CandidateID, record.ID, now); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"survivor_patient_id": survivor.ID(),
			"merged_patient_id":   merged.ID(),
			"merge_id":            record.ID,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		// Emitted against the survivor: a downstream projection keyed on
		// patient id needs to know which record to keep, and the event is how
		// it finds out (SRS-EMPI-018).
		if err := s.appendEvent(ctx, session, EventPatientMerged,
			"patient", survivor.ID(), payload, now); err != nil {
			return err
		}

		refreshed, err := s.identifiers.ForPatient(ctx, scope, survivor.ID())
		if err != nil {
			return err
		}
		result = MergePatientsResult{
			Survivor: survivor, Identifiers: refreshed,
			MergedID: merged.ID(), MergeID: record.ID,
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientMerge,
			ResourceType: "patient", ResourceID: survivor.ID(),
			Outcome: audit.OutcomeSuccess, Reason: record.Reason,
		}, now)
	})
	if err != nil {
		return MergePatientsResult{}, mapConflict(err)
	}
	return result, nil
}

// closeCandidate resolves the review-queue entry a merge came from.
func (s *Service) closeCandidate(ctx context.Context, scope authctx.TenantScope,
	session authctx.Session, candidateID, mergeID string, now time.Time) error {

	if candidateID == "" {
		return nil
	}
	candidate, err := s.merges.Candidate(ctx, scope, candidateID)
	if err != nil {
		return err
	}
	candidate.Resolve(session.SubjectID, mergeID, now)
	return s.merges.CloseCandidate(ctx, scope, candidate)
}

// UnmergePatientsInput names the merge to reverse.
type UnmergePatientsInput struct {
	MergeID string
	Reason  string
}

// UnmergePatientsResult carries both records as they now stand.
type UnmergePatientsResult struct {
	Survivor *domain.Patient
	Restored *domain.Patient
}

// UnmergePatients reverses a merge when it is safe (SRS-EMPI-006).
func (s *Service) UnmergePatients(ctx context.Context, in UnmergePatientsInput) (UnmergePatientsResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return UnmergePatientsResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientMerge,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientMerge, "merge", in.MergeID, decision.Reason)
		return UnmergePatientsResult{}, rpcerr.PermissionDenied("EMPI_UNMERGE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var result UnmergePatientsResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.merges.MergeByID(ctx, scope, in.MergeID)
		if err != nil {
			return err
		}

		survivor, err := s.patients.GetByID(ctx, scope, record.SurvivorID)
		if err != nil {
			return err
		}
		merged, err := s.patients.GetByID(ctx, scope, record.MergedID)
		if err != nil {
			return err
		}

		later, err := s.merges.LaterMergesInto(ctx, scope, record.SurvivorID, record.PerformedAt)
		if err != nil {
			return err
		}

		check := domain.UnmergeCheck{
			SurvivorMergedAgain: survivor.Status == domain.StatusMerged,
			LaterMergeExists:    later > 0,
			// Zero until a clinical context exists. Wired here rather than
			// left out, so connecting it later is one call rather than a new
			// rule — and so the rule is already tested.
			ClinicalRecordsSinceMerge: 0,
		}
		if err := domain.PlanUnmerge(record, survivor, merged, check); err != nil {
			return unmergeError(err)
		}

		// Identifiers go back exactly as the journal recorded them. Re-deriving
		// the destination from current state is impossible once a second merge
		// has touched the same rows.
		for _, moved := range record.MovedIdentifiers {
			if err := s.merges.MoveIdentifier(ctx, scope, moved.IdentifierID,
				moved.FromPatientID, moved.PreviousStatus, moved.PreviousPrimary,
				"unmerged from "+record.SurvivorID, now); err != nil {
				return err
			}
		}

		if err := domain.ApplyUnmerge(&record, survivor, merged, session.SubjectID, in.Reason, now); err != nil {
			return unmergeError(err)
		}

		if record.CarriedDeceased {
			if err := s.merges.SetDeceased(ctx, scope, survivor); err != nil {
				return err
			}
		}
		if err := s.merges.SetMergedInto(ctx, scope, merged); err != nil {
			return err
		}
		if err := s.merges.MarkUndone(ctx, scope, record); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"survivor_patient_id": survivor.ID(),
			"restored_patient_id": merged.ID(),
			"merge_id":            record.ID,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientUnmerged,
			"patient", survivor.ID(), payload, now); err != nil {
			return err
		}

		result = UnmergePatientsResult{Survivor: survivor, Restored: merged}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientMerge,
			ResourceType: "patient", ResourceID: merged.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "unmerged: " + in.Reason,
		}, now)
	})
	if err != nil {
		return UnmergePatientsResult{}, mapConflict(err)
	}
	return result, nil
}

// ListDuplicateCandidates returns the review worklist (SRS-EMPI-004).
func (s *Service) ListDuplicateCandidates(ctx context.Context, limit int32) ([]domain.DuplicateCandidate, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientMerge,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientMerge, "duplicate_candidate", "", decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_REVIEW_DENIED", decision.Reason)
	}

	return s.merges.OpenCandidates(ctx, session.TenantScope(), clampPageSize(limit))
}

// DismissDuplicateCandidate records that a pair is two different people.
func (s *Service) DismissDuplicateCandidate(ctx context.Context, candidateID, reason string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientMerge,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientMerge, "duplicate_candidate", candidateID, decision.Reason)
		return rpcerr.PermissionDenied("EMPI_REVIEW_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		candidate, err := s.merges.Candidate(ctx, scope, candidateID)
		if err != nil {
			return err
		}
		if err := candidate.Dismiss(session.SubjectID, reason, now); err != nil {
			return rpcerr.FailedPrecondition("EMPI_DISMISS_REFUSED", err.Error())
		}
		if err := s.merges.CloseCandidate(ctx, scope, candidate); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientMerge,
			ResourceType: "duplicate_candidate", ResourceID: candidate.ID,
			Outcome: audit.OutcomeSuccess, Reason: candidate.Resolution,
		}, now)
	})
	return mapConflict(err)
}

// queueForReview records a pair a registration surfaced (SRS-EMPI-004).
//
// Called when a clerk acknowledges a probable duplicate and registers anyway.
// The clerk's judgement stands — they can see the patient — but the pair goes
// to HIM, because that decision was made at a busy desk with somebody waiting,
// and without this nobody ever looks at it again.
func (s *Service) queueForReview(ctx context.Context, scope authctx.TenantScope,
	newPatientID string, matched []MatchedPatient, detectedBy string, now time.Time) error {

	for _, m := range matched {
		if m.Match.Outcome != domain.OutcomeProbable && m.Match.Outcome != domain.OutcomeReview {
			continue
		}
		candidate, err := domain.NewDuplicateCandidate(s.ids.NewID(), scope.TenantID(),
			newPatientID, m.Patient.ID(), m.Match.Score, m.Match.Outcome, detectedBy, now)
		if err != nil {
			return err
		}
		if err := s.merges.QueueCandidate(ctx, scope, candidate); err != nil {
			return err
		}
	}
	return nil
}

// mergeError maps a domain refusal onto the wire contract.
//
// FAILED_PRECONDITION rather than INVALID_ARGUMENT: the request is well-formed
// and the records are in a state that forbids it, which is a different thing
// for a reviewer's screen to say.
func mergeError(err error) error {
	if errors.Is(err, domain.ErrMergeRefused) {
		return rpcerr.FailedPrecondition("EMPI_MERGE_REFUSED", err.Error())
	}
	return err
}

func unmergeError(err error) error {
	if errors.Is(err, domain.ErrUnmergeRefused) {
		return rpcerr.FailedPrecondition("EMPI_UNMERGE_REFUSED", err.Error())
	}
	return err
}
