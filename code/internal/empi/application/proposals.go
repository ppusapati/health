package application

import (
	"context"
	"encoding/json"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Reconciliation and correction (SRS-EMPI-012, SRS-EMPI-017).

const (
	// EventPatientDemographicConflict is emitted when an external source
	// disagrees with the record. A data-quality dashboard needs to know a
	// conflict was raised; it does not need the values.
	EventPatientDemographicConflict = "patient.demographic_conflict_raised"
	// EventPatientCorrectionRequested is emitted when a person asks for a
	// correction (SRS-EMPI-017).
	EventPatientCorrectionRequested = "patient.correction_requested"
	// EventPatientProposalResolved is emitted on any decision.
	EventPatientProposalResolved = "patient.demographic_proposal_resolved"
)

// SubmitExternalDemographicsInput carries what an external source claims.
type SubmitExternalDemographicsInput struct {
	PatientID    string
	Demographics domain.Demographics
	// Source names the feed. SRS-EMPI-012 is about reconciling disagreements
	// between sources, and one with no source reconciles against nothing.
	Source string
	// FillBlanks also proposes values for fields the record leaves empty. A
	// registry offering a birth date the record lacks is filling a gap rather
	// than contradicting anything — still a proposal, because "usually
	// welcome" is not "always correct".
	FillBlanks bool
}

// SubmitExternalDemographicsResult reports what the comparison found.
type SubmitExternalDemographicsResult struct {
	// Proposal is set when the source disagreed. Zero when it agreed, which is
	// the common case and is not an error.
	Proposal domain.Proposal
	// Conflicted distinguishes "agreed" from "raised a proposal".
	Conflicted bool
	// Refreshed reports that an existing open proposal from this source was
	// updated rather than a second one added.
	Refreshed bool
}

// SubmitExternalDemographics compares an external source against the record
// and routes any disagreement to reconciliation (SRS-EMPI-012).
//
// It never writes to the patient. That is the entire requirement: a feed that
// can overwrite demographics will eventually overwrite the right value with the
// wrong one, and nothing will record what was lost.
func (s *Service) SubmitExternalDemographics(ctx context.Context,
	in SubmitExternalDemographicsInput) (SubmitExternalDemographicsResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return SubmitExternalDemographicsResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	// Manage rather than update: submitting a feed is an integration act, and
	// the caller is explicitly *not* being granted the ability to change
	// demographics — only to propose.
	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient", in.PatientID, decision.Reason)
		return SubmitExternalDemographicsResult{}, rpcerr.PermissionDenied("EMPI_SUBMIT_DENIED",
			decision.Reason)
	}

	if strings.TrimSpace(in.Source) == "" {
		return SubmitExternalDemographicsResult{}, rpcerr.Invalid("EMPI_SOURCE_REQUIRED",
			"an external submission must name its source")
	}

	fill := domain.ProposeOnlyConflicts
	if in.FillBlanks {
		fill = domain.ProposeFillingBlanks
	}

	var result SubmitExternalDemographicsResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		raised, err := s.raiseProposal(ctx, session, raiseInput{
			PatientID: in.PatientID, Incoming: in.Demographics,
			Origin: domain.OriginExternalSource, Source: in.Source,
			Fill: fill, EventType: EventPatientDemographicConflict,
		})
		if err != nil {
			return err
		}
		result = SubmitExternalDemographicsResult{
			Proposal: raised.proposal, Conflicted: raised.raised, Refreshed: raised.refreshed,
		}
		return nil
	})
	if err != nil {
		return SubmitExternalDemographicsResult{}, mapConflict(err)
	}
	return result, nil
}

// RequestCorrectionInput is a person asking for their record to be corrected.
type RequestCorrectionInput struct {
	PatientID    string
	Demographics domain.Demographics
	// Reason is what the reviewer is actually deciding on: "the spelling on my
	// passport" and "I would prefer a different name" are different requests
	// with the same proposed value.
	Reason string
}

// RequestCorrection raises a correction request (SRS-EMPI-017).
//
// Raising needs only read access. The person asking is often the patient or
// somebody acting for them, and requiring the authority to *make* the change in
// order to *ask* for it would collapse the request and the approval into one
// act — which is the workflow the requirement asks for, removed.
func (s *Service) RequestCorrection(ctx context.Context, in RequestCorrectionInput) (
	domain.Proposal, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Proposal{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient", in.PatientID, decision.Reason)
		return domain.Proposal{}, rpcerr.PermissionDenied("EMPI_CORRECTION_DENIED", decision.Reason)
	}

	if strings.TrimSpace(in.Reason) == "" {
		return domain.Proposal{}, rpcerr.Invalid("EMPI_CORRECTION_REASON_REQUIRED",
			"a correction request must say why the record is wrong")
	}

	var out domain.Proposal
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		raised, err := s.raiseProposal(ctx, session, raiseInput{
			PatientID: in.PatientID, Incoming: in.Demographics,
			Origin: domain.OriginCorrectionRequest,
			// The requester is the source: two people asking for different
			// corrections at once are two requests, not one that overwrites
			// the other.
			Source: "request:" + session.SubjectID,
			Reason: in.Reason,
			// A correction may fill a blank — "you never recorded my email" is
			// a correction.
			Fill: domain.ProposeFillingBlanks, EventType: EventPatientCorrectionRequested,
		})
		if err != nil {
			return err
		}
		if !raised.raised {
			return rpcerr.Invalid("EMPI_CORRECTION_CHANGES_NOTHING",
				"the record already says what this request asks for")
		}
		out = raised.proposal
		return nil
	})
	if err != nil {
		return domain.Proposal{}, mapConflict(err)
	}
	return out, nil
}

// raiseInput is the shared body of both proposal paths.
type raiseInput struct {
	PatientID string
	Incoming  domain.Demographics
	Origin    domain.ProposalOrigin
	Source    string
	Reason    string
	Fill      domain.FillMissing
	EventType string
}

type raiseResult struct {
	proposal  domain.Proposal
	raised    bool
	refreshed bool
}

// raiseProposal compares, stores and announces. Runs inside the caller's
// transaction.
func (s *Service) raiseProposal(ctx context.Context, session authctx.Session,
	in raiseInput) (raiseResult, error) {

	scope := session.TenantScope()
	now := s.clock.Now()

	patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
	if err != nil {
		return raiseResult{}, err
	}
	if patient.Status == domain.StatusMerged {
		return raiseResult{}, rpcerr.FailedPrecondition("EMPI_PATIENT_MERGED",
			"this record was merged; address the surviving patient")
	}

	fields := domain.DetectConflicts(patient.Demographics, in.Incoming, in.Fill)
	if len(fields) == 0 {
		// The source agrees. Raising an empty proposal would put an item in the
		// queue that says nothing and costs a reviewer a click.
		return raiseResult{}, nil
	}

	// A nightly feed that keeps disagreeing must refresh its one open item
	// rather than add another. Fifty identical items are not fifty conflicts;
	// they are one conflict and a reviewer who has stopped reading the queue.
	existing, found, err := s.proposals.OpenForSource(ctx, scope, patient.ID(), in.Source)
	if err != nil {
		return raiseResult{}, err
	}
	if found {
		if sameProposal(existing, fields) {
			return raiseResult{proposal: existing, raised: true, refreshed: true}, nil
		}
		// The source now disagrees about something else. Supersede rather than
		// edit: the reviewer who was shown the old comparison should be able to
		// see that it was replaced and by what.
		superseded := existing
		superseded.Status = domain.ProposalSuperseded
		superseded.ResolvedAt = now.UTC()
		superseded.ResolvedBy = session.SubjectID
		superseded.ResolutionNote = "the source submitted a different comparison"
		if err := s.proposals.Resolve(ctx, scope, superseded); err != nil {
			return raiseResult{}, err
		}
	}

	proposal, err := domain.NewProposal(s.ids.NewID(), patient.ID(), in.Origin,
		in.Source, session.SubjectID, in.Reason, fields, patient.Version, now)
	if err != nil {
		return raiseResult{}, registrationError(err)
	}
	if err := s.proposals.Raise(ctx, scope, proposal); err != nil {
		return raiseResult{}, err
	}

	payload, err := json.Marshal(map[string]any{
		"patient_id":  patient.ID(),
		"proposal_id": proposal.ID,
		"origin":      string(proposal.Origin),
		// Which fields disagree, never what they say. A conflict on the birth
		// date is what a data-quality dashboard needs; the two dates are not.
		"fields": fieldNames(proposal.Fields),
	})
	if err != nil {
		return raiseResult{}, rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}
	if err := s.appendEvent(ctx, session, in.EventType, "patient", patient.ID(), payload, now); err != nil {
		return raiseResult{}, err
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermPatientManage,
		ResourceType: "demographic_proposal", ResourceID: proposal.ID,
		Outcome: audit.OutcomeSuccess,
		Reason:  string(proposal.Origin) + " from " + proposal.Source,
	}, now); err != nil {
		return raiseResult{}, err
	}

	return raiseResult{proposal: proposal, raised: true}, nil
}

// sameProposal reports that a source is repeating a comparison it already has
// open.
func sameProposal(existing domain.Proposal, fields []domain.FieldProposal) bool {
	if len(existing.Fields) != len(fields) {
		return false
	}
	// Both sides are sorted by field: NewProposal sorts, and DetectConflicts
	// sorts.
	for i := range fields {
		if existing.Fields[i].Field != fields[i].Field ||
			existing.Fields[i].ProposedValue != fields[i].ProposedValue ||
			existing.Fields[i].CurrentValue != fields[i].CurrentValue {
			return false
		}
	}
	return true
}

func fieldNames(fields []domain.FieldProposal) []string {
	out := make([]string, 0, len(fields))
	for _, f := range fields {
		out = append(out, string(f.Field))
	}
	return out
}

// ResolveProposalInput is a reviewer's decision.
type ResolveProposalInput struct {
	ProposalID string
	// Accept names the fields to apply. Empty is a full rejection, which is a
	// real decision and is recorded as one.
	Accept []domain.Field
	Note   string
}

// ResolveProposalResult reports what the decision did.
type ResolveProposalResult struct {
	Proposal domain.Proposal
	// Patient is set when at least one field was applied.
	Patient *domain.Patient
}

// ResolveProposal applies or refuses a proposed change.
//
// This is where the authority actually lives. Raising a proposal needs little;
// deciding one needs the permission to change demographics, because that is
// what a decision does.
func (s *Service) ResolveProposal(ctx context.Context, in ResolveProposalInput) (
	ResolveProposalResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return ResolveProposalResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientUpdate,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientUpdate, "demographic_proposal",
			in.ProposalID, decision.Reason)
		return ResolveProposalResult{}, rpcerr.PermissionDenied("EMPI_RESOLVE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result ResolveProposalResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		proposal, err := s.proposals.Get(ctx, scope, in.ProposalID)
		if err != nil {
			return err
		}

		patient, err := s.patients.GetByID(ctx, scope, proposal.PatientID)
		if err != nil {
			return err
		}

		// The reviewer decided on the comparison they were shown. If the record
		// moved since, accepting would overwrite a value nobody reviewed —
		// which is the silent overwrite SRS-EMPI-012 exists to prevent,
		// arriving through the mechanism meant to prevent it.
		if proposal.Stale(patient.Version) {
			return rpcerr.FailedPrecondition("EMPI_PROPOSAL_STALE",
				"the record changed after this was raised; review it again against the current values")
		}

		if err := proposal.Resolve(in.Accept, session.SubjectID, in.Note, now); err != nil {
			return registrationError(err)
		}
		if err := s.proposals.Resolve(ctx, scope, proposal); err != nil {
			return err
		}

		accepted := proposal.AcceptedFields()
		if len(accepted) > 0 {
			applied, err := s.applyProposal(ctx, session, patient, proposal, now)
			if err != nil {
				return err
			}
			result.Patient = applied
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id":  proposal.PatientID,
			"proposal_id": proposal.ID,
			"status":      string(proposal.Status),
			"accepted":    fieldsAsStrings(accepted),
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientProposalResolved,
			"patient", proposal.PatientID, payload, now); err != nil {
			return err
		}

		result.Proposal = proposal
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientUpdate,
			ResourceType: "demographic_proposal", ResourceID: proposal.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(proposal.Status) + ": " + in.Note,
		}, now)
	})
	if err != nil {
		return ResolveProposalResult{}, mapConflict(err)
	}
	return result, nil
}

// applyProposal writes the accepted fields onto the patient.
//
// Goes through the same domain path as any other correction, so the demographic
// policy still applies and a changed legal name still opens a history window
// (SRS-EMPI-007). Writing columns directly would let a proposal do what a clerk
// cannot: leave a record without its required fields, or change a name with no
// record of the change.
func (s *Service) applyProposal(ctx context.Context, session authctx.Session,
	patient *domain.Patient, proposal domain.Proposal, now time.Time) (*domain.Patient, error) {

	scope := session.TenantScope()

	updated, err := patient.Demographics.Apply(proposal)
	if err != nil {
		return nil, registrationError(err)
	}

	jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
	if err != nil {
		return nil, err
	}
	registrationPolicy, err := s.config.DemographicPolicy(ctx, scope,
		jurisdiction, patient.RegisteredFacilityID)
	if err != nil {
		return nil, err
	}

	nameBefore := patient.Demographics.Name.Display()

	if err := patient.UpdateDemographics(updated, registrationPolicy, now); err != nil {
		return nil, registrationError(err)
	}
	if err := s.patients.UpdateDemographics(ctx, scope, patient); err != nil {
		return nil, err
	}

	// A name applied from a proposal closes the previous window and opens a new
	// one, exactly as a clerk's edit does. The source of the change belongs in
	// the history, so an investigator reading a name later can see that a
	// registry proposed it rather than a person typing at a desk.
	if patient.Demographics.Name.Display() != nameBefore {
		if err := s.openLegalName(ctx, scope, session, patient,
			string(proposal.Origin)+":"+proposal.Source, now); err != nil {
			return nil, err
		}
	}

	// Applying a proposal moves the version, so every other open proposal
	// against this patient now compares against values that have changed.
	// Leaving them open would show the next reviewer a stale comparison, and
	// accepting one would overwrite what this decision just applied.
	if _, err := s.proposals.SupersedeStale(ctx, scope, patient.ID(),
		patient.Version, session.SubjectID, now); err != nil {
		return nil, err
	}

	// The same event a manual correction emits. A downstream projection does
	// not care which path changed the record, only that it did.
	payload, err := json.Marshal(map[string]any{
		"patient_id": patient.ID(),
		"version":    patient.Version,
	})
	if err != nil {
		return nil, rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
	}
	if err := s.appendEvent(ctx, session, EventPatientDemographicsUpdated,
		"patient", patient.ID(), payload, now); err != nil {
		return nil, err
	}
	return patient, nil
}

func fieldsAsStrings(fields []domain.Field) []string {
	out := make([]string, 0, len(fields))
	for _, f := range fields {
		out = append(out, string(f))
	}
	return out
}

// ListOpenProposals returns the reconciliation worklist (SRS-EMPI-012).
//
// A read of proposed demographic values, so it is a read of demographics and is
// authorised and audited as one. Masking applies for the same reason it applies
// to a duplicate worklist: the reviewer is being shown records belonging to
// people who are not in front of them.
func (s *Service) ListOpenProposals(ctx context.Context, pageSize int32) ([]domain.Proposal, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "demographic_proposal", "", decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_PROPOSALS_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var out []domain.Proposal
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.proposals.ListOpen(ctx, scope, clampPageSize(pageSize))
		if err != nil {
			return err
		}
		out = found
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientRead,
			ResourceType: "demographic_proposal", ResourceID: "",
			Outcome: audit.OutcomeSuccess,
			Reason:  "reconciliation worklist",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// ProposalsForPatient returns everything ever proposed about one patient.
//
// Includes rejections and withdrawals. That a value was offered and refused is
// the answer when the same value arrives from the same feed again, and a list
// that hid them would make every repeat look like a new discovery.
func (s *Service) ProposalsForPatient(ctx context.Context, patientID string,
	pageSize int32) ([]domain.Proposal, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "demographic_proposal", patientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_PROPOSALS_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var out []domain.Proposal
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.proposals.ForPatient(ctx, scope, patientID, clampPageSize(pageSize))
		if err != nil {
			return err
		}
		out = found
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientRead,
			ResourceType: "demographic_proposal", ResourceID: patientID,
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// WithdrawProposal takes back a proposal the raiser no longer stands behind.
func (s *Service) WithdrawProposal(ctx context.Context, proposalID, note string) (
	domain.Proposal, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Proposal{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "demographic_proposal", proposalID, decision.Reason)
		return domain.Proposal{}, rpcerr.PermissionDenied("EMPI_WITHDRAW_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var out domain.Proposal
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		proposal, err := s.proposals.Get(ctx, scope, proposalID)
		if err != nil {
			return err
		}
		// Only the raiser withdraws. Anybody else refusing it is a rejection,
		// which is a reviewer's decision and is recorded as one — the two say
		// different things about who decided the record is correct.
		if proposal.ProposedBy != session.SubjectID {
			return rpcerr.PermissionDenied("EMPI_NOT_THE_REQUESTER",
				"only whoever raised a proposal may withdraw it; refusing it is a rejection")
		}
		if err := proposal.Withdraw(session.SubjectID, note, now); err != nil {
			return registrationError(err)
		}
		if err := s.proposals.Resolve(ctx, scope, proposal); err != nil {
			return err
		}
		out = proposal
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientRead,
			ResourceType: "demographic_proposal", ResourceID: proposal.ID,
			Outcome: audit.OutcomeSuccess, Reason: "withdrawn: " + note,
		}, now)
	})
	if err != nil {
		return domain.Proposal{}, mapConflict(err)
	}
	return out, nil
}
