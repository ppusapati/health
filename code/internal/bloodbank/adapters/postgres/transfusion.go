package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// TransfusionRepo implements ports.TransfusionRepository.
type TransfusionRepo struct{ *Repository }

var _ ports.TransfusionRepository = TransfusionRepo{}

// InsertEpisode begins a transfusion.
//
// The bedside check travels with it rather than being a separate row: the two
// people who checked are part of what makes this transfusion legitimate, and a
// check stored separately is one that can be missing.
func (r TransfusionRepo) InsertEpisode(ctx context.Context,
	scope authctx.TenantScope, e domain.Episode,
	check domain.BedsideCheck) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	componentID, err := uuid.Parse(e.ComponentID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(e.PatientID)
	if err != nil {
		return notFound()
	}
	issueID, err := optionalUUID(e.IssueID)
	if err != nil {
		return err
	}
	encounterID, err := optionalUUID(e.EncounterID)
	if err != nil {
		return err
	}

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		if err := r.queries(ctx).InsertTransfusionEpisode(ctx,
			sqlcgen.InsertTransfusionEpisodeParams{
				EpisodeID: episodeID, TenantID: tenantID,
				ComponentID: componentID, IssueID: issueID,
				PatientID: patientID, EncounterID: encounterID,
				Status:    string(e.Status),
				StartedAt: stamp(e.StartedAt), StartedBy: e.StartedBy,
				VolumeGivenMl: int32(e.VolumeGivenML),
				CheckedBy:     check.CheckedBy, CheckedWith: check.CheckedWith,
			}); err != nil {
			return err
		}
		// The baseline observations the domain attached at the start. Written
		// in the same transaction, because a transfusion whose baseline
		// observations went missing is one nobody can compare against.
		for _, observation := range e.Observations {
			if observation.ID == "" {
				continue
			}
			if err := r.insertObservation(
				ctx, tenantID, episodeID, observation); err != nil {
				return err
			}
		}
		return nil
	})
}

// Episode reads one transfusion with its observations.
func (r TransfusionRepo) Episode(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Episode{}, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return domain.Episode{}, notFound()
	}

	row, err := r.queries(ctx).GetTransfusionEpisode(ctx,
		sqlcgen.GetTransfusionEpisodeParams{TenantID: tenantID, EpisodeID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Episode{}, notFound()
	}
	if err != nil {
		return domain.Episode{}, err
	}

	episode := episodeFrom(row)
	observations, err := r.Observations(ctx, scope, episode.ID)
	if err != nil {
		return domain.Episode{}, err
	}
	episode.Observations = observations
	return episode, nil
}

// UpdateEpisode records an interruption, a completion or a stop.
func (r TransfusionRepo) UpdateEpisode(ctx context.Context,
	scope authctx.TenantScope, e domain.Episode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateTransfusionEpisode(ctx,
		sqlcgen.UpdateTransfusionEpisodeParams{
			TenantID: tenantID, EpisodeID: id,
			Status: string(e.Status), EndedAt: stamp(e.EndedAt),
			VolumeGivenMl: int32(e.VolumeGivenML), StopReason: e.StopReason,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// EpisodesForComponent reads a unit's transfusions, for the chain.
func (r TransfusionRepo) EpisodesForComponent(ctx context.Context,
	scope authctx.TenantScope, componentID string) ([]domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListEpisodesForComponent(ctx,
		sqlcgen.ListEpisodesForComponentParams{TenantID: tenantID, ComponentID: id})
	if err != nil {
		return nil, err
	}
	return episodesFrom(rows), nil
}

// PatientEpisodes is the transfusion history across admissions.
func (r TransfusionRepo) PatientEpisodes(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientEpisodes(ctx,
		sqlcgen.ListPatientEpisodesParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return episodesFrom(rows), nil
}

// EpisodesInPeriod reads what a utilisation report counts.
func (r TransfusionRepo) EpisodesInPeriod(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time, limit int32) (
	[]domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListEpisodesInPeriod(ctx,
		sqlcgen.ListEpisodesInPeriodParams{
			TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return episodesFrom(rows), nil
}

func episodesFrom(rows []sqlcgen.BloodbankEpisode) []domain.Episode {
	out := make([]domain.Episode, 0, len(rows))
	for _, row := range rows {
		out = append(out, episodeFrom(row))
	}
	return out
}

func episodeFrom(row sqlcgen.BloodbankEpisode) domain.Episode {
	return domain.Episode{
		ID: row.EpisodeID.String(), TenantID: row.TenantID.String(),
		ComponentID: row.ComponentID.String(),
		IssueID:     uuidOrEmpty(row.IssueID),
		PatientID:   row.PatientID.String(),
		EncounterID: uuidOrEmpty(row.EncounterID),
		Status:      domain.EpisodeStatus(row.Status),
		StartedAt:   timeOf(row.StartedAt), StartedBy: row.StartedBy,
		EndedAt:       timeOf(row.EndedAt),
		VolumeGivenML: int(row.VolumeGivenMl),
		StopReason:    row.StopReason,
	}
}

func (r TransfusionRepo) insertObservation(ctx context.Context,
	tenantID, episodeID uuid.UUID, o domain.Observation) error {

	observationID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}
	// An empty map is an object, not a NULL: a set with nothing in it is
	// refused by the domain, so this only ever carries real values.
	values := o.Values
	if values == nil {
		values = map[string]float64{}
	}
	encoded, err := json.Marshal(values)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertBloodBankObservation(ctx,
		sqlcgen.InsertBloodBankObservationParams{
			ObservationID: observationID, TenantID: tenantID,
			EpisodeID: episodeID, Timing: o.Timing, Values: encoded,
			Note: o.Note, ObservedAt: stamp(o.ObservedAt),
			ObservedBy: o.ObservedBy,
		})
}

// InsertObservation records a set of observations during a transfusion.
func (r TransfusionRepo) InsertObservation(ctx context.Context,
	scope authctx.TenantScope, o domain.Observation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(o.EpisodeID)
	if err != nil {
		return notFound()
	}
	return r.insertObservation(ctx, tenantID, episodeID, o)
}

// Observations reads a transfusion's observations, in order.
func (r TransfusionRepo) Observations(ctx context.Context,
	scope authctx.TenantScope, episodeID string) ([]domain.Observation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListBloodBankObservations(ctx,
		sqlcgen.ListBloodBankObservationsParams{TenantID: tenantID, EpisodeID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Observation, 0, len(rows))
	for _, row := range rows {
		values := map[string]float64{}
		if len(row.Values) > 0 {
			if err := json.Unmarshal(row.Values, &values); err != nil {
				return nil, err
			}
		}
		out = append(out, domain.Observation{
			ID: row.ObservationID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(),
			Timing:    row.Timing, Values: values, Note: row.Note,
			ObservedAt: timeOf(row.ObservedAt), ObservedBy: row.ObservedBy,
		})
	}
	return out, nil
}

// InsertReaction reports a suspected transfusion reaction.
func (r TransfusionRepo) InsertReaction(ctx context.Context,
	scope authctx.TenantScope, reaction domain.Reaction) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reactionID, err := uuid.Parse(reaction.ID)
	if err != nil {
		return notFound()
	}
	componentID, err := uuid.Parse(reaction.ComponentID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(reaction.PatientID)
	if err != nil {
		return notFound()
	}
	episodeID, err := optionalUUID(reaction.EpisodeID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertReaction(ctx, sqlcgen.InsertReactionParams{
		ReactionID: reactionID, TenantID: tenantID,
		EpisodeID: episodeID, ComponentID: componentID, PatientID: patientID,
		Severity: string(reaction.Severity),
		Features: strings0(reaction.Features), Note: reaction.Note,
		ReportedAt: stamp(reaction.ReportedAt), ReportedBy: reaction.ReportedBy,
		State: string(reaction.State),
	})
}

// Reaction reads one reaction.
func (r TransfusionRepo) Reaction(ctx context.Context, scope authctx.TenantScope,
	reactionID string) (domain.Reaction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Reaction{}, err
	}
	id, err := uuid.Parse(reactionID)
	if err != nil {
		return domain.Reaction{}, notFound()
	}

	row, err := r.queries(ctx).GetReaction(ctx, sqlcgen.GetReactionParams{
		TenantID: tenantID, ReactionID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Reaction{}, notFound()
	}
	if err != nil {
		return domain.Reaction{}, err
	}
	return reactionFrom(row), nil
}

// ConcludeReaction closes an investigation.
//
// False where it was already closed, so a second conclusion does not overwrite
// the first: an investigation reopened is a new decision, not an edit.
func (r TransfusionRepo) ConcludeReaction(ctx context.Context,
	scope authctx.TenantScope, reaction domain.Reaction) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(reaction.ID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).ConcludeReaction(ctx, sqlcgen.ConcludeReactionParams{
		TenantID: tenantID, ReactionID: id,
		Classification: reaction.Classification, Conclusion: reaction.Conclusion,
		ConcludedAt:  stamp(reaction.ConcludedAt),
		ConcludedBy:  reaction.ConcludedBy,
		UnitReturned: reaction.UnitReturned,
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// ReactionsForComponent reads a unit's reactions, for the chain.
func (r TransfusionRepo) ReactionsForComponent(ctx context.Context,
	scope authctx.TenantScope, componentID string) ([]domain.Reaction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListReactionsForComponent(ctx,
		sqlcgen.ListReactionsForComponentParams{TenantID: tenantID, ComponentID: id})
	if err != nil {
		return nil, err
	}
	return reactionsFrom(rows), nil
}

// OpenReactions is the haemovigilance officer's worklist.
func (r TransfusionRepo) OpenReactions(ctx context.Context,
	scope authctx.TenantScope, limit int32) ([]domain.Reaction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOpenReactions(ctx,
		sqlcgen.ListOpenReactionsParams{TenantID: tenantID, RowLimit: limit})
	if err != nil {
		return nil, err
	}
	return reactionsFrom(rows), nil
}

// ReactionsInPeriod reads what a haemovigilance report counts.
func (r TransfusionRepo) ReactionsInPeriod(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time, limit int32) (
	[]domain.Reaction, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListReactionsInPeriod(ctx,
		sqlcgen.ListReactionsInPeriodParams{
			TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return reactionsFrom(rows), nil
}

func reactionsFrom(rows []sqlcgen.BloodbankReaction) []domain.Reaction {
	out := make([]domain.Reaction, 0, len(rows))
	for _, row := range rows {
		out = append(out, reactionFrom(row))
	}
	return out
}

func reactionFrom(row sqlcgen.BloodbankReaction) domain.Reaction {
	return domain.Reaction{
		ID: row.ReactionID.String(), TenantID: row.TenantID.String(),
		EpisodeID:   uuidOrEmpty(row.EpisodeID),
		ComponentID: row.ComponentID.String(),
		PatientID:   row.PatientID.String(),
		Severity:    domain.ReactionSeverity(row.Severity),
		Features:    row.Features, Note: row.Note,
		ReportedAt: timeOf(row.ReportedAt), ReportedBy: row.ReportedBy,
		State:          domain.InvestigationState(row.State),
		Classification: row.Classification, Conclusion: row.Conclusion,
		ConcludedAt: timeOf(row.ConcludedAt), ConcludedBy: row.ConcludedBy,
		UnitReturned: row.UnitReturned,
	}
}

// DonorRecipients runs the look-back from a donor to every patient who
// received their blood.
func (r TransfusionRepo) DonorRecipients(ctx context.Context,
	scope authctx.TenantScope, donorID string, limit int32) (
	[]ports.Recipient, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(donorID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListDonorRecipients(ctx,
		sqlcgen.ListDonorRecipientsParams{
			TenantID: tenantID, DonorID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]ports.Recipient, 0, len(rows))
	for _, row := range rows {
		out = append(out, ports.Recipient{
			PatientID:   row.PatientID.String(),
			EpisodeID:   row.EpisodeID.String(),
			ComponentID: row.ComponentID.String(),
			UnitNumber:  row.UnitNumber,
			At:          timeOf(row.StartedAt),
		})
	}
	return out, nil
}
