package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// BedsideInput is the check made at the patient's side (SRS-BLD-010).
type BedsideInput struct {
	// UnitNumber and PatientID as read aloud from the unit and the wristband.
	UnitNumber string
	PatientID  string
	// The groups as read from the two labels, which is a different check from
	// the one the database can make: it catches a label that does not match
	// the record.
	PatientGroup domain.Group
	UnitGroup    domain.Group
	// CheckedWith is the second person. The caller is the first.
	CheckedWith string

	EncounterID string
	Baseline    map[string]float64
}

// VerifyBedside runs the check without starting anything (SRS-BLD-010).
//
// Separate from StartTransfusion so a client can show the result before the
// nurse commits, and so a failed check is recorded as a critical exception
// whether or not anybody then tries to proceed.
func (s *Service) VerifyBedside(ctx context.Context, in BedsideInput) (
	[]domain.BedsideRefusal, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	refusals, _, _, err := s.checkBedside(ctx, scope, session, in, now)
	if err != nil {
		return nil, err
	}
	if err := s.escalateMismatch(ctx, session, scope, in, refusals, now); err != nil {
		return nil, err
	}
	return refusals, nil
}

// checkBedside resolves the unit and the issue and runs the domain check.
//
// It reports; it does not escalate. Escalating is the caller's, because the
// caller knows whether it is inside a transaction that is about to roll back —
// and the whole point of the critical exception is that it survives the
// refusal that produced it.
func (s *Service) checkBedside(ctx context.Context, scope authctx.TenantScope,
	session authctx.Session, in BedsideInput, now time.Time) (
	[]domain.BedsideRefusal, domain.Component, domain.Issue, error) {

	component, err := s.inventory.ComponentByNumber(ctx, scope, in.UnitNumber)
	if err != nil {
		// A unit number nobody can resolve is itself a mismatch, and the worst
		// kind: somebody is holding a bag this system has never seen. Reported
		// as a refusal rather than as a lookup error, so it escalates like any
		// other mismatch instead of reading as a bad request.
		return []domain.BedsideRefusal{domain.BedsideWrongUnit},
			domain.Component{}, domain.Issue{}, nil
	}

	issue, issued, err := s.crossmatch.LatestIssue(ctx, scope, component.ID)
	if err != nil {
		return nil, domain.Component{}, domain.Issue{}, err
	}
	if !issued {
		return []domain.BedsideRefusal{domain.BedsideNotIssued},
			component, domain.Issue{}, nil
	}

	check := domain.BedsideCheck{
		UnitNumber: in.UnitNumber, PatientID: in.PatientID,
		PatientGroup: in.PatientGroup, UnitGroup: in.UnitGroup,
		CheckedBy: session.SubjectID, CheckedWith: in.CheckedWith,
	}
	return domain.VerifyBedside(check, component, issue, now),
		component, issue, nil
}

// escalateMismatch records the critical exception SRS-BLD-010 asks for.
//
// Durable and acknowledged rather than a log line: somebody at a bedside has a
// unit that does not match the patient in front of them, and the blood bank
// has to know before the next unit goes out. A solo check is escalated too —
// it is a departure from the protocol, and the reason two people are required
// is that one person checking is how the published incidents happened.
func (s *Service) escalateMismatch(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, in BedsideInput,
	refusals []domain.BedsideRefusal, now time.Time) error {

	if len(refusals) == 0 {
		return nil
	}
	// Its own transaction, deliberately. The refusal that produced this
	// rolls back the transfusion the caller was attempting, and a critical
	// exception that rolled back with it would leave the blood bank knowing
	// nothing — which is the failure SRS-BLD-010 is written to prevent.
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.recordMismatch(ctx, session, scope, in, refusals, now)
	})
}

func (s *Service) recordMismatch(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, in BedsideInput,
	refusals []domain.BedsideRefusal, now time.Time) error {

	explanations := make([]string, 0, len(refusals))
	for _, refusal := range refusals {
		explanations = append(explanations, refusal.Explain())
	}

	if err := s.appendEvent(ctx, session, EventBedsideMismatch,
		"bloodbank_component", in.UnitNumber, map[string]any{
			"unit_number": in.UnitNumber,
			"patient_id":  in.PatientID,
			"refusals":    refusalCodes(refusals),
		}, now); err != nil {
		return err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermTransfuse,
		ResourceType: "bloodbank_component", ResourceID: in.UnitNumber,
		Outcome: audit.OutcomeDenied,
		Reason:  "bedside check failed: " + join(explanations),
	}, now); err != nil {
		return err
	}

	if s.escalations == nil {
		return nil
	}
	_, err := s.escalations.Raise(ctx, scope, ports.Notice{
		Kind:    EscalationKind,
		Subject: "unit " + in.UnitNumber,
		// The patient the check was made against, so a recipient sees who it
		// concerns without reaching into the blood bank.
		PatientID: in.PatientID,
		Summary:   "Bedside transfusion check failed. " + join(explanations),
	}, now)
	return err
}

func refusalCodes(in []domain.BedsideRefusal) []string {
	out := make([]string, 0, len(in))
	for _, refusal := range in {
		out = append(out, string(refusal))
	}
	return out
}

// StartTransfusion begins a transfusion at the bedside (SRS-BLD-010,
// SRS-BLD-011).
//
// The check runs here, from rows read here, inside the transaction. A client
// that had verified separately and then started cannot slip a different unit
// in between, and a failed check blocks the start rather than warning about
// it — which is SRS-BLD-010's "mismatch blocks digital completion".
func (s *Service) StartTransfusion(ctx context.Context, in BedsideInput) (
	domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse)
	if err != nil {
		return domain.Episode{}, err
	}
	now := s.clock.Now()

	// The check runs first, in its own read, so a failure can be escalated
	// before the transaction below rolls back. The check then runs again
	// inside that transaction, against rows read there: a client cannot slip
	// a different unit in between, and the second result is the one that
	// decides whether blood goes into a patient.
	if refusals, _, _, err := s.checkBedside(
		ctx, scope, session, in, now); err != nil {
		return domain.Episode{}, err
	} else if err := s.escalateMismatch(
		ctx, session, scope, in, refusals, now); err != nil {
		return domain.Episode{}, err
	}

	var out domain.Episode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		refusals, component, issue, err := s.checkBedside(
			ctx, scope, session, in, now)
		if err != nil {
			return err
		}

		check := domain.BedsideCheck{
			UnitNumber: in.UnitNumber, PatientID: in.PatientID,
			PatientGroup: in.PatientGroup, UnitGroup: in.UnitGroup,
			CheckedBy: session.SubjectID, CheckedWith: in.CheckedWith,
		}
		episode, err := domain.StartTransfusion(s.ids.NewID(), session.TenantID,
			domain.StartTransfusionInput{
				ComponentID: component.ID, IssueID: issue.ID,
				PatientID: issue.PatientID, EncounterID: in.EncounterID,
				Baseline: in.Baseline,
			}, refusals, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		// The domain attaches the baseline observation without an id, because
		// minting one is the service's job.
		for i := range episode.Observations {
			if episode.Observations[i].ID == "" {
				episode.Observations[i].ID = s.ids.NewID()
			}
		}

		if err := s.transfusion.InsertEpisode(
			ctx, scope, episode, check); err != nil {
			return err
		}
		out = episode

		component.Status = domain.UnitTransfused
		if err := s.inventory.UpdateStatus(
			ctx, scope, component, component.Version); err != nil {
			return bloodbankError(err)
		}

		if err := s.appendEvent(ctx, session, EventTransfusionStart,
			"bloodbank_component", component.ID, map[string]any{
				"unit_number": component.UnitNumber,
				"patient_id":  episode.PatientID,
				"class":       string(component.Class),
				"group":       component.Group.String(),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTransfuse,
			ResourceType: "bloodbank_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "transfusion of unit " + component.UnitNumber +
				" started, checked with " + in.CheckedWith,
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// Observe records a set of observations during a transfusion (SRS-BLD-011).
func (s *Service) Observe(ctx context.Context, episodeID, timing string,
	values map[string]float64, note string) (domain.Observation, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse)
	if err != nil {
		return domain.Observation{}, err
	}
	now := s.clock.Now()

	var out domain.Observation
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.transfusion.Episode(ctx, scope, episodeID)
		if err != nil {
			return err
		}
		observation, err := episode.Observe(s.ids.NewID(), timing, values, note,
			session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.transfusion.InsertObservation(
			ctx, scope, observation); err != nil {
			return err
		}
		out = observation
		return nil
	})
	if err != nil {
		return domain.Observation{}, err
	}
	return out, nil
}

// EndTransfusion completes or stops a transfusion (SRS-BLD-011).
func (s *Service) EndTransfusion(ctx context.Context, episodeID string,
	volumeML int, stopReason string) (domain.Episode, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse)
	if err != nil {
		return domain.Episode{}, err
	}
	now := s.clock.Now()

	var out domain.Episode
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.transfusion.Episode(ctx, scope, episodeID)
		if err != nil {
			return err
		}

		// A stop reason means it was abandoned; its absence means it ran to
		// the end. One call rather than two, because the ward does not think
		// of them as different actions and a client that picked wrong would
		// record a completed transfusion the patient did not finish.
		if stopReason != "" {
			err = episode.Stop(stopReason, volumeML, now)
		} else {
			err = episode.Complete(volumeML, now)
		}
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.transfusion.UpdateEpisode(ctx, scope, episode); err != nil {
			return err
		}
		out = episode

		if err := s.appendEvent(ctx, session, EventTransfusionEnd,
			"bloodbank_episode", episode.ID, map[string]any{
				"component_id":    episode.ComponentID,
				"patient_id":      episode.PatientID,
				"status":          string(episode.Status),
				"volume_given_ml": episode.VolumeGivenML,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTransfuse,
			ResourceType: "bloodbank_episode", ResourceID: episode.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "transfusion " + string(episode.Status),
		}, now)
	})
	if err != nil {
		return domain.Episode{}, err
	}
	return out, nil
}

// Episode reads one transfusion with its observations, and what the protocol
// says it still needs.
func (s *Service) Episode(ctx context.Context, episodeID string) (
	domain.Episode, []string, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Episode{}, nil, err
	}
	episode, err := s.transfusion.Episode(ctx, scope, episodeID)
	if err != nil {
		return domain.Episode{}, nil, err
	}
	// Named rather than blocking: a nurse who has not taken the fifteen-minute
	// set is a nurse who is fifteen minutes in.
	return episode, episode.MissingObservations(
		s.config.requiredObservations()), nil
}

// PatientTransfusions is the history across admissions (SRS-BLD-011).
func (s *Service) PatientTransfusions(ctx context.Context, patientID string,
	limit int32) ([]domain.Episode, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.transfusion.PatientEpisodes(
		ctx, scope, patientID, clampPageSize(limit))
}

// ReportReaction records a suspected transfusion reaction (SRS-BLD-012,
// SRS-NUR-014).
//
// Reporting does three things in one transaction, because they are one action
// at the bedside. It stops the transfusion the reaction was reported against.
// It quarantines the implicated unit's siblings — a reaction that might be
// bacterial contamination or a mislabelled donation implicates everything made
// from the same collection, and waiting for the investigation to conclude
// before pulling them is waiting while they are given to somebody else. And it
// opens the investigation.
func (s *Service) ReportReaction(ctx context.Context,
	in domain.NewReactionInput) (domain.Reaction, error) {

	session, scope, err := s.authorize(ctx, PermReaction)
	if err != nil {
		return domain.Reaction{}, err
	}
	now := s.clock.Now()

	var out domain.Reaction
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		component, err := s.inventory.Component(ctx, scope, in.ComponentID)
		if err != nil {
			return err
		}

		reaction, err := domain.ReportReaction(
			s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
		if err != nil {
			return bloodbankError(err)
		}
		if err := s.transfusion.InsertReaction(ctx, scope, reaction); err != nil {
			return err
		}
		out = reaction

		if err := s.stopForReaction(
			ctx, session, scope, reaction, in.VolumeGivenML, now); err != nil {
			return err
		}

		if err := s.quarantineSiblings(
			ctx, session, scope, component, now); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventReactionReported,
			"bloodbank_component", component.ID, map[string]any{
				"unit_number": component.UnitNumber,
				"patient_id":  reaction.PatientID,
				"severity":    string(reaction.Severity),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermReaction,
			ResourceType: "bloodbank_reaction", ResourceID: reaction.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: string(reaction.Severity) + " reaction to unit " +
				component.UnitNumber,
		}, now)
	})
	if err != nil {
		return domain.Reaction{}, err
	}
	return out, nil
}

// stopForReaction ends the transfusion the reaction was reported against.
//
// A reaction with no episode — reported against a unit rather than a running
// transfusion — has nothing to stop, and a transfusion that already ended is
// left as it ended.
//
// The episode and the component are not required to agree, and deliberately
// so. A patient who has had two units may react to the first while the second
// is running: the unit to stop is the one in the line, and the donation to
// investigate is the one suspected. Insisting they match would force the nurse
// to choose between stopping the wrong transfusion and quarantining the wrong
// siblings.
func (s *Service) stopForReaction(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, reaction domain.Reaction, volumeML int,
	now time.Time) error {

	if reaction.EpisodeID == "" {
		return nil
	}
	episode, err := s.transfusion.Episode(ctx, scope, reaction.EpisodeID)
	if err != nil {
		return err
	}
	stopped, err := episode.StopForReaction(reaction, volumeML, now)
	if err != nil {
		return bloodbankError(err)
	}
	if !stopped {
		return nil
	}
	if err := s.transfusion.UpdateEpisode(ctx, scope, episode); err != nil {
		return err
	}
	if err := s.appendEvent(ctx, session, EventTransfusionEnd,
		"bloodbank_episode", episode.ID, map[string]any{
			"component_id":    episode.ComponentID,
			"patient_id":      episode.PatientID,
			"status":          string(episode.Status),
			"volume_given_ml": episode.VolumeGivenML,
		}, now); err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermReaction,
		ResourceType: "bloodbank_episode", ResourceID: episode.ID,
		Outcome: audit.OutcomeSuccess,
		Reason:  "transfusion stopped: reaction reported",
	}, now)
}

func (s *Service) quarantineSiblings(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope,
	component domain.Component, now time.Time) error {

	siblings, err := s.inventory.Siblings(ctx, scope, component.ID)
	if err != nil {
		return err
	}
	held := 0
	for _, sibling := range siblings {
		if sibling.Status == domain.UnitTransfused ||
			sibling.Status == domain.UnitDiscarded {
			continue
		}
		if err := sibling.Quarantine(); err != nil {
			return bloodbankError(err)
		}
		if err := s.inventory.UpdateStatus(
			ctx, scope, sibling, sibling.Version); err != nil {
			return bloodbankError(err)
		}
		held++
	}
	if held == 0 {
		return nil
	}
	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermReaction,
		ResourceType: "bloodbank_collection", ResourceID: component.CollectionID,
		Outcome: audit.OutcomeSuccess,
		Reason: "reaction reported: " + itoa(held) +
			" sibling component(s) quarantined",
	}, now)
}

// ConcludeInvestigation closes a reaction investigation (SRS-BLD-012).
func (s *Service) ConcludeInvestigation(ctx context.Context, reactionID,
	classification, conclusion string, unitReturned bool) (
	domain.Reaction, error) {

	session, scope, err := s.authorize(ctx, PermReaction)
	if err != nil {
		return domain.Reaction{}, err
	}
	now := s.clock.Now()

	var out domain.Reaction
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		reaction, err := s.transfusion.Reaction(ctx, scope, reactionID)
		if err != nil {
			return err
		}
		if err := reaction.Conclude(classification, conclusion,
			session.SubjectID, now); err != nil {
			return bloodbankError(err)
		}
		reaction.UnitReturned = unitReturned

		done, err := s.transfusion.ConcludeReaction(ctx, scope, reaction)
		if err != nil {
			return err
		}
		if !done {
			return rpcerr.FailedPrecondition("BLD_INVESTIGATION_CLOSED",
				"this investigation is already concluded")
		}
		out = reaction

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermReaction,
			ResourceType: "bloodbank_reaction", ResourceID: reaction.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "concluded: " + classification,
		}, now)
	})
	if err != nil {
		return domain.Reaction{}, err
	}
	return out, nil
}

// OpenInvestigations is the haemovigilance officer's worklist (SRS-BLD-012).
func (s *Service) OpenInvestigations(ctx context.Context, limit int32) (
	[]domain.Reaction, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.transfusion.OpenReactions(ctx, scope, clampPageSize(limit))
}

// TraceUnit assembles a unit's vein-to-vein chain (SRS-BLD-014).
func (s *Service) TraceUnit(ctx context.Context, componentID string) (
	domain.Chain, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return domain.Chain{}, err
	}
	now := s.clock.Now()

	component, err := s.inventory.Component(ctx, scope, componentID)
	if err != nil {
		return domain.Chain{}, err
	}

	var donor *domain.Donor
	var collection *domain.Collection
	if found, err := s.donors.Collection(
		ctx, scope, component.CollectionID); err == nil {
		collection = &found
		if component.DonorID != "" {
			if d, err := s.donors.Donor(ctx, scope, component.DonorID); err == nil {
				donor = &d
			}
		}
	}

	tests, err := s.donors.TestResults(ctx, scope, component.CollectionID)
	if err != nil {
		return domain.Chain{}, err
	}
	reservations, err := s.crossmatch.ReservationsForComponent(
		ctx, scope, component.ID)
	if err != nil {
		return domain.Chain{}, err
	}
	issues, err := s.crossmatch.IssuesForComponent(ctx, scope, component.ID)
	if err != nil {
		return domain.Chain{}, err
	}
	episodes, err := s.transfusion.EpisodesForComponent(ctx, scope, component.ID)
	if err != nil {
		return domain.Chain{}, err
	}
	reactions, err := s.transfusion.ReactionsForComponent(
		ctx, scope, component.ID)
	if err != nil {
		return domain.Chain{}, err
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermTrace,
		ResourceType: "bloodbank_component", ResourceID: component.ID,
		Outcome: audit.OutcomeSuccess,
		Reason:  "vein-to-vein trace of unit " + component.UnitNumber,
	}, now); err != nil {
		return domain.Chain{}, err
	}

	return domain.BuildChain(component, donor, collection, tests,
		reservations, issues, episodes, reactions), nil
}

// LookBack finds every patient who received a donor's blood (SRS-BLD-014).
//
// The direction a positive look-back runs. Audited with the count, because a
// look-back and a fishing expedition look identical in the query log.
func (s *Service) LookBack(ctx context.Context, donorID string, limit int32) (
	[]ports.Recipient, error) {

	session, scope, err := s.authorize(ctx, PermTrace)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	recipients, err := s.transfusion.DonorRecipients(
		ctx, scope, donorID, clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	// The event and the audit row go together in one transaction: the outbox
	// requires an open one (ADR-0004), and a look-back announced but not
	// audited would be a search nobody can account for.
	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.appendEvent(ctx, session, EventLookBackRequested,
			"bloodbank_donor", donorID, map[string]any{
				"recipients": len(recipients),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTrace,
			ResourceType: "bloodbank_donor", ResourceID: donorID,
			Outcome: audit.OutcomeSuccess,
			Reason: "look-back reached " + itoa(len(recipients)) +
				" recipient(s)",
		}, now)
	}); err != nil {
		return nil, err
	}
	return recipients, nil
}
