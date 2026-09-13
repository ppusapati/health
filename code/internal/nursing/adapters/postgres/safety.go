package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// SafetyRepo persists restraints and transfusions
// (SRS-NUR-013, SRS-NUR-014).
type SafetyRepo struct{ *Repository }

var _ ports.SafetyRepository = SafetyRepo{}

// NewSafety constructs the safety adapter.
func NewSafety(r *Repository) SafetyRepo { return SafetyRepo{r} }

// InsertRestraint records the start of a restraint episode.
func (r SafetyRepo) InsertRestraint(ctx context.Context,
	scope authctx.TenantScope, rest *domain.Restraint) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	restraintID, err := mustUUID(rest.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(rest.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(rest.EncounterID)
	if err != nil {
		return err
	}
	renewals, err := toJSON(rest.Renewals)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRestraint(ctx, sqlcgen.InsertRestraintParams{
		RestraintID: restraintID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Kind: string(rest.Kind), Description: rest.Description,
		AuthorizedBy: rest.Authorization.AuthorizedBy,
		AuthorizedAt: timestamptz(rest.Authorization.AuthorizedAt),
		// NOT NULL at the table. An authorization with no expiry is the failure
		// the requirement exists to prevent (SRS-NUR-013).
		ExpiresAt:  timestamptz(rest.Authorization.ExpiresAt),
		Indication: rest.Authorization.Indication,
		Renewals:   renewals,
		StartedAt:  timestamptz(rest.StartedAt), StartedBy: rest.StartedBy,
		MonitorEverySeconds: int64(rest.MonitorEvery / time.Second),
	})
}

// GetRestraint reads one episode with its checks.
func (r SafetyRepo) GetRestraint(ctx context.Context, scope authctx.TenantScope,
	restraintID string) (*domain.Restraint, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(restraintID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetRestraint(ctx, sqlcgen.GetRestraintParams{
		TenantID: tenantID, RestraintID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	restraint, err := restraintFromRow(sqlcgen.NursingRestraint(row))
	if err != nil {
		return nil, err
	}

	checks, err := r.queries(ctx).ListRestraintChecks(ctx,
		sqlcgen.ListRestraintChecksParams{
			TenantID: tenantID, RestraintID: id, PageLimit: 500,
		})
	if err != nil {
		return nil, err
	}
	for _, c := range checks {
		restraint.Monitoring = append(restraint.Monitoring, domain.RestraintCheck{
			ID: c.CheckID.String(), ObservedAt: timeOrZero(c.ObservedAt),
			ObservedBy: c.ObservedBy, Findings: c.Findings,
			ContinuedReason: c.ContinuedReason,
		})
	}
	return restraint, nil
}

// UpdateRestraint stores a renewal or a discontinuation.
func (r SafetyRepo) UpdateRestraint(ctx context.Context,
	scope authctx.TenantScope, rest *domain.Restraint,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(rest.ID)
	if err != nil {
		return err
	}

	if rest.Active() {
		renewals, err := toJSON(rest.Renewals)
		if err != nil {
			return err
		}
		rows, err := r.queries(ctx).RenewRestraint(ctx, sqlcgen.RenewRestraintParams{
			TenantID: tenantID, RestraintID: id,
			Renewals: renewals, ExpectedVersion: expectedVersion,
		})
		if err != nil {
			return err
		}
		if rows == 0 {
			return conflict()
		}
		return nil
	}

	rows, err := r.queries(ctx).DiscontinueRestraint(ctx,
		sqlcgen.DiscontinueRestraintParams{
			TenantID: tenantID, RestraintID: id,
			DiscontinuedAt:     timestamptz(rest.DiscontinuedAt),
			DiscontinuedBy:     rest.DiscontinuedBy,
			DiscontinuedReason: rest.DiscontinuedReason,
			ExpectedVersion:    expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// ListRestraints reads an encounter's restraint episodes.
func (r SafetyRepo) ListRestraints(ctx context.Context,
	scope authctx.TenantScope, encounterID string, activeOnly bool,
	limit int32) ([]*domain.Restraint, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListRestraints(ctx, sqlcgen.ListRestraintsParams{
		TenantID: tenantID, EncounterFilter: encounter,
		ActiveOnly: activeOnly, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Restraint, 0, len(rows))
	for _, row := range rows {
		restraint, err := restraintFromRow(sqlcgen.NursingRestraint(row))
		if err != nil {
			return nil, err
		}
		out = append(out, restraint)
	}
	return out, nil
}

// ExpiredAuthorizations lists live restraints whose authorization has lapsed.
//
// Still active restraints: the patient is restrained, and what has expired is
// the permission (SRS-NUR-013).
func (r SafetyRepo) ExpiredAuthorizations(ctx context.Context,
	scope authctx.TenantScope, asOf time.Time, limit int32) (
	[]*domain.Restraint, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListExpiredRestraints(ctx,
		sqlcgen.ListExpiredRestraintsParams{
			TenantID: tenantID, AsOf: timestamptz(asOf), PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Restraint, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.Restraint{
			ID: row.RestraintID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
			Kind: domain.RestraintKind(row.Kind), Description: row.Description,
			Authorization: domain.RestraintAuthorization{
				AuthorizedBy: row.AuthorizedBy,
				ExpiresAt:    timeOrZero(row.ExpiresAt),
				Indication:   row.Indication,
			},
			StartedAt:    timeOrZero(row.StartedAt),
			MonitorEvery: time.Duration(row.MonitorEverySeconds) * time.Second,
			Version:      row.Version,
		})
	}
	return out, nil
}

// InsertRestraintCheck records an observation of a restrained patient.
func (r SafetyRepo) InsertRestraintCheck(ctx context.Context,
	scope authctx.TenantScope, restraintID string,
	c domain.RestraintCheck) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	restraint, err := lookupUUID(restraintID)
	if err != nil {
		return err
	}
	checkID, err := mustUUID(c.ID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRestraintCheck(ctx,
		sqlcgen.InsertRestraintCheckParams{
			CheckID: checkID, TenantID: tenantID, RestraintID: restraint,
			ObservedAt: timestamptz(c.ObservedAt), ObservedBy: c.ObservedBy,
			Findings: c.Findings,
			// NOT NULL and non-empty at the table: a check that never asks
			// whether the restraint is still needed keeps patients restrained.
			ContinuedReason: c.ContinuedReason,
		})
}

func restraintFromRow(row sqlcgen.NursingRestraint) (*domain.Restraint, error) {
	rest := &domain.Restraint{
		ID: row.RestraintID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Kind: domain.RestraintKind(row.Kind), Description: row.Description,
		Authorization: domain.RestraintAuthorization{
			AuthorizedBy: row.AuthorizedBy,
			AuthorizedAt: timeOrZero(row.AuthorizedAt),
			ExpiresAt:    timeOrZero(row.ExpiresAt),
			Indication:   row.Indication,
		},
		StartedAt: timeOrZero(row.StartedAt), StartedBy: row.StartedBy,
		MonitorEvery:       time.Duration(row.MonitorEverySeconds) * time.Second,
		DiscontinuedAt:     timeOrZero(row.DiscontinuedAt),
		DiscontinuedBy:     row.DiscontinuedBy,
		DiscontinuedReason: row.DiscontinuedReason,
		Version:            row.Version,
	}
	if err := fromJSON(row.Renewals, &rest.Renewals); err != nil {
		return nil, err
	}
	return rest, nil
}

// InsertTransfusion starts a transfusion episode.
func (r SafetyRepo) InsertTransfusion(ctx context.Context,
	scope authctx.TenantScope, t *domain.Transfusion) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	transfusionID, err := mustUUID(t.ID)
	if err != nil {
		return err
	}
	patientID, err := mustUUID(t.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := mustUUID(t.EncounterID)
	if err != nil {
		return err
	}

	if err := r.queries(ctx).InsertTransfusion(ctx,
		sqlcgen.InsertTransfusionParams{
			TransfusionID: transfusionID, TenantID: tenantID,
			PatientID: patientID, EncounterID: encounterID,
			// The pack's own identifier: what links this record to the blood
			// bank and forward to a look-back investigation.
			UnitNumber:     t.UnitNumber,
			ProductSystem:  t.Product.System,
			ProductVersion: t.Product.Version,
			ProductCode:    t.Product.Code,
			ProductDisplay: t.Product.Display,
			AboGroup:       t.ABOGroup, Rhd: t.RhD, VolumeMl: t.VolumeML,
			StartedAt: timestamptz(t.StartedAt), StartedBy: t.StartedBy,
			CheckedBy: t.CheckedBy,
		}); err != nil {
		return err
	}

	// The baseline goes in with the episode: without it, a temperature of 38.1
	// twenty minutes in cannot be read as a rise or as where the patient
	// already was (SRS-NUR-014).
	for _, o := range t.Observations {
		if err := r.InsertTransfusionObservation(ctx, scope, t.ID, o); err != nil {
			return err
		}
	}
	return nil
}

// GetTransfusion reads one episode with its observations.
func (r SafetyRepo) GetTransfusion(ctx context.Context,
	scope authctx.TenantScope, transfusionID string) (*domain.Transfusion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(transfusionID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetTransfusion(ctx, sqlcgen.GetTransfusionParams{
		TenantID: tenantID, TransfusionID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	transfusion := transfusionFromRow(sqlcgen.NursingTransfusion(row))

	observations, err := r.queries(ctx).ListTransfusionObservations(ctx,
		sqlcgen.ListTransfusionObservationsParams{
			TenantID: tenantID, TransfusionID: id, PageLimit: 500,
		})
	if err != nil {
		return nil, err
	}
	for _, o := range observations {
		transfusion.Observations = append(transfusion.Observations,
			domain.TransfusionObservation{
				ID: o.ObservationID.String(), ObservedAt: timeOrZero(o.ObservedAt),
				ObservedBy: o.ObservedBy, TemperatureC: o.TemperatureC,
				Pulse: o.Pulse, SystolicBP: o.SystolicBp,
				RespiratoryRate: o.RespiratoryRate,
				Baseline:        o.Baseline, Notes: o.Notes,
			})
	}
	return transfusion, nil
}

// EndTransfusion completes or stops an episode.
func (r SafetyRepo) EndTransfusion(ctx context.Context,
	scope authctx.TenantScope, t *domain.Transfusion,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(t.ID)
	if err != nil {
		return err
	}

	params := sqlcgen.EndTransfusionParams{
		TenantID: tenantID, TransfusionID: id,
		Status: string(t.Status), EndedAt: timestamptz(t.EndedAt),
		ExpectedVersion: expectedVersion,
	}
	if t.Reaction != nil {
		params.ReactionReportedAt = timestamptz(t.Reaction.ReportedAt)
		params.ReactionReportedBy = t.Reaction.ReportedBy
		params.ReactionFeatures = t.Reaction.Features
		params.ReactionAction = t.Reaction.ActionTaken
		params.ReactionUnitReturned = t.Reaction.UnitReturned
	}

	rows, err := r.queries(ctx).EndTransfusion(ctx, params)
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// ListTransfusions reads an encounter's episodes.
func (r SafetyRepo) ListTransfusions(ctx context.Context,
	scope authctx.TenantScope, encounterID string, limit int32) (
	[]*domain.Transfusion, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListTransfusions(ctx, sqlcgen.ListTransfusionsParams{
		TenantID: tenantID, EncounterID: encounter, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Transfusion, 0, len(rows))
	for _, row := range rows {
		out = append(out, transfusionFromRow(sqlcgen.NursingTransfusion(row)))
	}
	return out, nil
}

// InsertTransfusionObservation records a monitoring set.
func (r SafetyRepo) InsertTransfusionObservation(ctx context.Context,
	scope authctx.TenantScope, transfusionID string,
	o domain.TransfusionObservation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	transfusion, err := lookupUUID(transfusionID)
	if err != nil {
		return err
	}
	observationID, err := mustUUID(o.ID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertTransfusionObservation(ctx,
		sqlcgen.InsertTransfusionObservationParams{
			ObservationID: observationID, TenantID: tenantID,
			TransfusionID: transfusion,
			ObservedAt:    timestamptz(o.ObservedAt), ObservedBy: o.ObservedBy,
			TemperatureC: o.TemperatureC, Pulse: o.Pulse,
			SystolicBp: o.SystolicBP, RespiratoryRate: o.RespiratoryRate,
			Baseline: o.Baseline, Notes: o.Notes,
		})
}

func transfusionFromRow(row sqlcgen.NursingTransfusion) *domain.Transfusion {
	t := &domain.Transfusion{
		ID: row.TransfusionID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		UnitNumber: row.UnitNumber,
		Product: domain.Coding{
			System: row.ProductSystem, Version: row.ProductVersion,
			Code: row.ProductCode, Display: row.ProductDisplay,
		},
		ABOGroup: row.AboGroup, RhD: row.Rhd, VolumeML: row.VolumeMl,
		StartedAt: timeOrZero(row.StartedAt), StartedBy: row.StartedBy,
		CheckedBy: row.CheckedBy,
		Status:    domain.TransfusionStatus(row.Status),
		EndedAt:   timeOrZero(row.EndedAt),
		Version:   row.Version,
	}
	if row.ReactionReportedBy != "" {
		t.Reaction = &domain.TransfusionReaction{
			ReportedAt:   timeOrZero(row.ReactionReportedAt),
			ReportedBy:   row.ReactionReportedBy,
			Features:     row.ReactionFeatures,
			ActionTaken:  row.ReactionAction,
			UnitReturned: row.ReactionUnitReturned,
		}
	}
	return t
}

// DowntimeRepo persists downtime episodes (SRS-NUR-018).
type DowntimeRepo struct{ *Repository }

var _ ports.DowntimeRepository = DowntimeRepo{}

// NewDowntime constructs the downtime adapter.
func NewDowntime(r *Repository) DowntimeRepo { return DowntimeRepo{r} }

// openEpisodeConstraint holds one open downtime episode per unit. Two would
// make "are we on paper" depend on which row a query found.
const openEpisodeConstraint = "downtime_one_open_per_unit"

// Insert opens a downtime period.
func (r DowntimeRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	e *domain.DowntimeEpisode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := mustUUID(e.ID)
	if err != nil {
		return err
	}

	err = r.queries(ctx).InsertNursingDowntime(ctx,
		sqlcgen.InsertNursingDowntimeParams{
			EpisodeID: episodeID, TenantID: tenantID,
			UnitID: e.UnitID, Reason: e.Reason,
			StartedAt: timestamptz(e.StartedAt), StartedBy: e.StartedBy,
		})
	if uniqueViolation(err, openEpisodeConstraint) {
		// A second declaration on a unit already on paper is somebody
		// re-declaring what is already true, not an error to investigate.
		return rpcerr.AlreadyExists("NUR_DOWNTIME_ALREADY_OPEN",
			"this unit is already working on paper")
	}
	return err
}

// Get reads one episode.
func (r DowntimeRepo) Get(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (*domain.DowntimeEpisode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(episodeID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetNursingDowntime(ctx,
		sqlcgen.GetNursingDowntimeParams{TenantID: tenantID, EpisodeID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return downtimeFromRow(sqlcgen.NursingDowntimeEpisode(row)), nil
}

// End closes the downtime period.
func (r DowntimeRepo) End(ctx context.Context, scope authctx.TenantScope,
	e *domain.DowntimeEpisode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(e.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).EndNursingDowntime(ctx,
		sqlcgen.EndNursingDowntimeParams{
			TenantID: tenantID, EpisodeID: id,
			EndedAt: timestamptz(e.EndedAt), EndedBy: e.EndedBy,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// Reconcile marks the paper record fully entered.
func (r DowntimeRepo) Reconcile(ctx context.Context, scope authctx.TenantScope,
	e *domain.DowntimeEpisode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(e.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).ReconcileNursingDowntime(ctx,
		sqlcgen.ReconcileNursingDowntimeParams{
			TenantID: tenantID, EpisodeID: id,
			ReconciledAt: timestamptz(e.ReconciledAt), ReconciledBy: e.ReconciledBy,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// List reads downtime episodes.
func (r DowntimeRepo) List(ctx context.Context, scope authctx.TenantScope,
	unitID string, unreconciledOnly bool, limit int32) (
	[]*domain.DowntimeEpisode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListNursingDowntime(ctx,
		sqlcgen.ListNursingDowntimeParams{
			TenantID: tenantID, UnitFilter: unitID,
			UnreconciledOnly: unreconciledOnly, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.DowntimeEpisode, 0, len(rows))
	for _, row := range rows {
		out = append(out, downtimeFromRow(sqlcgen.NursingDowntimeEpisode(row)))
	}
	return out, nil
}

func downtimeFromRow(row sqlcgen.NursingDowntimeEpisode) *domain.DowntimeEpisode {
	return &domain.DowntimeEpisode{
		ID: row.EpisodeID.String(), TenantID: row.TenantID.String(),
		UnitID: row.UnitID, Reason: row.Reason,
		StartedAt: timeOrZero(row.StartedAt), StartedBy: row.StartedBy,
		EndedAt: timeOrZero(row.EndedAt), EndedBy: row.EndedBy,
		ReconciledAt: timeOrZero(row.ReconciledAt), ReconciledBy: row.ReconciledBy,
		Version: row.Version,
	}
}
