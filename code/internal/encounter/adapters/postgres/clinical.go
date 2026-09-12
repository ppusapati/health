package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Episodes, care teams, diagnoses, closure policy and summaries
// (SRS-ENC-004 … SRS-ENC-009).

// EpisodeRepo implements the episode repository port.
type EpisodeRepo struct{ *Repository }

var _ ports.EpisodeRepository = EpisodeRepo{}

// Insert stores a course of care.
func (r EpisodeRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	e *domain.Episode) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(e.ID())
	if err != nil {
		return rpcerr.Internal("ENC_EPISODE_ID_INVALID",
			"episode_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(e.PatientID)
	if err != nil {
		return rpcerr.Invalid("ENC_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	facilityID, err := uuid.Parse(e.FacilityID)
	if err != nil {
		return rpcerr.Internal("ENC_FACILITY_ID_INVALID",
			"facility_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).InsertEpisode(ctx, sqlcgen.InsertEpisodeParams{
		EpisodeID: episodeID, TenantID: tenantID, PatientID: patientID,
		FacilityID: facilityID, EpisodeType: string(e.Type), Label: e.Label,
		CareManagerID: e.CareManagerID, Status: string(e.Status),
		StartedAt: timestamptz(e.StartedAt), EndedAt: timestamptz(e.EndedAt),
		CreatedBy: e.CreatedBy,
		CreatedAt: timestamptz(e.CreatedAt), UpdatedAt: timestamptz(e.UpdatedAt),
	})
}

// Get reads one episode.
func (r EpisodeRepo) Get(ctx context.Context, scope authctx.TenantScope,
	episodeID string) (*domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	row, err := r.queries(ctx).GetEpisode(ctx, sqlcgen.GetEpisodeParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	return episodeFromRow(sqlcgen.EncounterEpisode(row)), nil
}

// ForPatient returns a patient's courses of care, newest first.
func (r EpisodeRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string, openOnly bool, limit int32) ([]*domain.Episode, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListEpisodesForPatient(ctx,
		sqlcgen.ListEpisodesForPatientParams{
			TenantID: tenantID, PatientID: patient,
			OpenOnly: openOnly, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Episode, 0, len(rows))
	for _, row := range rows {
		out = append(out, episodeFromRow(sqlcgen.EncounterEpisode(row)))
	}
	return out, nil
}

// SetStatus moves an episode through its life, under optimistic concurrency.
func (r EpisodeRepo) SetStatus(ctx context.Context, scope authctx.TenantScope,
	e *domain.Episode, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	episodeID, err := uuid.Parse(e.ID())
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetEpisodeStatus(ctx, sqlcgen.SetEpisodeStatusParams{
		TenantID: tenantID, EpisodeID: episodeID, Status: string(e.Status),
		EndedAt: timestamptz(e.EndedAt), UpdatedAt: timestamptz(e.UpdatedAt),
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	e.Version = expectedVersion + 1
	return nil
}

func episodeFromRow(row sqlcgen.EncounterEpisode) *domain.Episode {
	return domain.RestoreEpisode(row.EpisodeID.String(), domain.Episode{
		TenantID: row.TenantID.String(), PatientID: row.PatientID.String(),
		FacilityID: row.FacilityID.String(), Type: domain.EpisodeType(row.EpisodeType),
		Label: row.Label, CareManagerID: row.CareManagerID,
		Status:    domain.EpisodeStatus(row.Status),
		StartedAt: timeOrZero(row.StartedAt), EndedAt: timeOrZero(row.EndedAt),
		CreatedBy: row.CreatedBy,
		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	})
}

// CareTeamRepo implements the care-team repository port (SRS-ENC-005).
type CareTeamRepo struct{ *Repository }

var _ ports.CareTeamRepository = CareTeamRepo{}

// Insert stores one person's involvement in one encounter.
func (r CareTeamRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	m domain.CareTeamMember) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	careTeamID, err := uuid.Parse(m.ID)
	if err != nil {
		return rpcerr.Internal("ENC_CARE_TEAM_ID_INVALID",
			"care_team_id must be a UUID").WithCause(err)
	}
	encounterID, err := uuid.Parse(m.EncounterID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertCareTeamMember(ctx, sqlcgen.InsertCareTeamMemberParams{
		CareTeamID: careTeamID, TenantID: tenantID, EncounterID: encounterID,
		SubjectID: m.SubjectID, Role: string(m.Role),
		EffectiveFrom: timestamptz(m.From), EffectiveUntil: timestamptz(m.Until),
		AssignedBy: m.AssignedBy, AssignedAt: timestamptz(m.AssignedAt),
	})
}

// ForEncounter returns an encounter's assignments, earliest first.
func (r CareTeamRepo) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (domain.CareTeam, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCareTeam(ctx, sqlcgen.ListCareTeamParams{
		TenantID: tenantID, EncounterID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.CareTeam, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.CareTeamMember{
			ID: row.CareTeamID.String(), TenantID: row.TenantID.String(),
			EncounterID: row.EncounterID.String(), SubjectID: row.SubjectID,
			Role: domain.CareTeamRole(row.Role),
			From: timeOrZero(row.EffectiveFrom), Until: timeOrZero(row.EffectiveUntil),
			AssignedBy: row.AssignedBy, AssignedAt: timeOrZero(row.AssignedAt),
		})
	}
	return out, nil
}

// End closes an involvement rather than deleting it.
func (r CareTeamRepo) End(ctx context.Context, scope authctx.TenantScope,
	careTeamID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(careTeamID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).EndCareTeamMember(ctx, sqlcgen.EndCareTeamMemberParams{
		TenantID: tenantID, CareTeamID: id, EffectiveUntil: timestamptz(at),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Either already ended, or the end date is not after the start. Both
		// are the caller asking for something the record cannot represent.
		return rpcerr.FailedPrecondition("ENC_CARE_TEAM_NOT_OPEN",
			"that assignment has already ended, or would end before it began")
	}
	return nil
}

// Includes answers the authorization question as of a time.
func (r CareTeamRepo) Includes(ctx context.Context, scope authctx.TenantScope,
	encounterID, subjectID string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return false, notFound()
	}

	return r.queries(ctx).IsOnCareTeamAt(ctx, sqlcgen.IsOnCareTeamAtParams{
		TenantID: tenantID, EncounterID: id, SubjectID: subjectID, At: timestamptz(at),
	})
}

// DiagnosisRepo implements the diagnosis repository port (SRS-ENC-007).
type DiagnosisRepo struct{ *Repository }

var _ ports.DiagnosisRepository = DiagnosisRepo{}

// Insert stores one diagnosis entry.
func (r DiagnosisRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	d domain.Diagnosis) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	diagnosisID, err := uuid.Parse(d.ID)
	if err != nil {
		return rpcerr.Internal("ENC_DIAGNOSIS_ID_INVALID",
			"diagnosis_id must be a UUID").WithCause(err)
	}
	encounterID, err := uuid.Parse(d.EncounterID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(d.PatientID)
	if err != nil {
		return rpcerr.Invalid("ENC_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}

	return r.queries(ctx).InsertDiagnosis(ctx, sqlcgen.InsertDiagnosisParams{
		DiagnosisID: diagnosisID, TenantID: tenantID, EncounterID: encounterID,
		PatientID: patientID, CodeSystem: d.Code.System, CodeVersion: d.Code.Version,
		Code: d.Code.Code, CodeDisplay: d.Code.Display,
		Certainty: string(d.Certainty), Rank: string(d.Rank), Note: d.Note,
		OnsetAt: timestamptz(d.OnsetAt), RecordedBy: d.RecordedBy,
		RecordedAt: timestamptz(d.RecordedAt),
	})
}

// Supersede chains an earlier entry to the one replacing it.
func (r DiagnosisRepo) Supersede(ctx context.Context, scope authctx.TenantScope,
	diagnosisID, supersededByID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(diagnosisID)
	if err != nil {
		return notFound()
	}
	by, err := optionalUUID(supersededByID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).SupersedeDiagnosis(ctx, sqlcgen.SupersedeDiagnosisParams{
		TenantID: tenantID, DiagnosisID: id, SupersededByID: by,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Already superseded or retracted. Two clinicians revising the same
		// diagnosis must produce one chain, not a fork nobody can read.
		return rpcerr.FailedPrecondition("ENC_DIAGNOSIS_NOT_LIVE",
			"that diagnosis has already been revised or retracted")
	}
	return nil
}

// Retract marks an entry that was never true of this patient.
func (r DiagnosisRepo) Retract(ctx context.Context, scope authctx.TenantScope,
	diagnosisID, reason string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(diagnosisID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).RetractDiagnosis(ctx, sqlcgen.RetractDiagnosisParams{
		TenantID: tenantID, DiagnosisID: id, RetractedReason: reason,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("ENC_DIAGNOSIS_NOT_LIVE",
			"that diagnosis has already been revised or retracted")
	}
	return nil
}

// ForEncounter returns every diagnosis recorded against an encounter, including
// superseded ones: the trail is the clinical reasoning.
func (r DiagnosisRepo) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (domain.DiagnosisList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListDiagnosesForEncounter(ctx,
		sqlcgen.ListDiagnosesForEncounterParams{TenantID: tenantID, EncounterID: id})
	if err != nil {
		return nil, err
	}

	out := make(domain.DiagnosisList, 0, len(rows))
	for _, row := range rows {
		out = append(out, diagnosisFromRow(sqlcgen.EncounterEncounterDiagnosis(row)))
	}
	return out, nil
}

// LiveForPatient returns the conditions that still stand across every
// encounter.
func (r DiagnosisRepo) LiveForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string, limit int32) (domain.DiagnosisList, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListLiveDiagnosesForPatient(ctx,
		sqlcgen.ListLiveDiagnosesForPatientParams{
			TenantID: tenantID, PatientID: patient, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make(domain.DiagnosisList, 0, len(rows))
	for _, row := range rows {
		out = append(out, diagnosisFromRow(sqlcgen.EncounterEncounterDiagnosis(row)))
	}
	return out, nil
}

func diagnosisFromRow(row sqlcgen.EncounterEncounterDiagnosis) domain.Diagnosis {
	return domain.Diagnosis{
		ID: row.DiagnosisID.String(), TenantID: row.TenantID.String(),
		EncounterID: row.EncounterID.String(), PatientID: row.PatientID.String(),
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Certainty: domain.DiagnosisCertainty(row.Certainty),
		Rank:      domain.DiagnosisRank(row.Rank),
		Note:      row.Note, OnsetAt: timeOrZero(row.OnsetAt),
		SupersededByID:  uuidOrEmpty(row.SupersededByID),
		RetractedReason: row.RetractedReason,
		RecordedBy:      row.RecordedBy, RecordedAt: timeOrZero(row.RecordedAt),
	}
}

// ClosurePolicyRepo implements the closure policy port (SRS-ENC-008).
type ClosurePolicyRepo struct{ *Repository }

var _ ports.ClosurePolicyRepository = ClosurePolicyRepo{}

// Resolve returns the finalisation rules in force.
func (r ClosurePolicyRepo) Resolve(ctx context.Context, scope authctx.TenantScope,
	facilityID string) (domain.ClosurePolicy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ClosurePolicy{}, err
	}
	facility, err := optionalUUID(facilityID)
	if err != nil {
		return domain.ClosurePolicy{}, err
	}

	rows, err := r.queries(ctx).ListClosurePolicy(ctx, sqlcgen.ListClosurePolicyParams{
		TenantID: tenantID, FacilityID: facility,
	})
	if err != nil {
		return domain.ClosurePolicy{}, err
	}
	if len(rows) == 0 {
		// A tenant that has configured nothing still gets a defensible gate
		// rather than none: no requirement at all would let a hospital run for
		// a year before discovering that half its discharge summaries have no
		// diagnosis.
		return domain.DefaultClosurePolicy(), nil
	}

	policy := domain.ClosurePolicy{
		Required:      map[domain.Class][]domain.DocumentationItem{},
		AllowOverride: map[domain.Class]bool{},
	}
	// Facility-specific rows sort first, so the first row seen for a class is
	// the most specific one.
	for _, row := range rows {
		class := domain.Class(row.EncounterClass)
		if _, taken := policy.Required[class]; taken {
			continue
		}
		items := make([]domain.DocumentationItem, 0, len(row.RequiredItems))
		for _, raw := range row.RequiredItems {
			items = append(items, domain.DocumentationItem(raw))
		}
		policy.Required[class] = items
		policy.AllowOverride[class] = row.AllowOverride
	}
	return policy, nil
}

// Set writes the finalisation rules for a facility, or tenant-wide when
// facilityID is empty.
func (r ClosurePolicyRepo) Set(ctx context.Context, scope authctx.TenantScope,
	facilityID string, p domain.ClosurePolicy, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	facility, err := optionalUUID(facilityID)
	if err != nil {
		return err
	}

	q := r.queries(ctx)
	for class, items := range p.Required {
		required := make([]string, 0, len(items))
		for _, item := range items {
			required = append(required, string(item))
		}
		if err := q.UpsertClosurePolicy(ctx, sqlcgen.UpsertClosurePolicyParams{
			PolicyID: uuid.New(), TenantID: tenantID, FacilityID: facility,
			EncounterClass: string(class), RequiredItems: orEmpty(required),
			AllowOverride: p.AllowOverride[class],
			CreatedAt:     timestamptz(now), UpdatedAt: timestamptz(now),
		}); err != nil {
			return err
		}
	}
	return nil
}

// RecordOverride stores a finalisation forced over an incomplete record.
func (r ClosurePolicyRepo) RecordOverride(ctx context.Context, scope authctx.TenantScope,
	o domain.ClosureOverride) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	overrideID, err := uuid.Parse(o.ID)
	if err != nil {
		return rpcerr.Internal("ENC_OVERRIDE_ID_INVALID",
			"override_id must be a UUID").WithCause(err)
	}
	encounterID, err := uuid.Parse(o.EncounterID)
	if err != nil {
		return notFound()
	}

	missing := make([]string, 0, len(o.Missing))
	for _, item := range o.Missing {
		missing = append(missing, string(item))
	}

	return r.queries(ctx).InsertClosureOverride(ctx, sqlcgen.InsertClosureOverrideParams{
		OverrideID: overrideID, TenantID: tenantID, EncounterID: encounterID,
		MissingItems: orEmpty(missing), Reason: o.Reason,
		OverriddenBy: o.OverriddenBy, OverriddenAt: timestamptz(o.OverriddenAt),
	})
}

// Overrides returns the forced closures, newest first.
func (r ClosurePolicyRepo) Overrides(ctx context.Context, scope authctx.TenantScope,
	encounterID string, limit int32) ([]domain.ClosureOverride, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(encounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListClosureOverrides(ctx, sqlcgen.ListClosureOverridesParams{
		TenantID: tenantID, EncounterID: encounter, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ClosureOverride, 0, len(rows))
	for _, row := range rows {
		missing := make([]domain.DocumentationItem, 0, len(row.MissingItems))
		for _, raw := range row.MissingItems {
			missing = append(missing, domain.DocumentationItem(raw))
		}
		out = append(out, domain.ClosureOverride{
			ID: row.OverrideID.String(), TenantID: row.TenantID.String(),
			EncounterID: row.EncounterID.String(), Missing: missing,
			Reason: row.Reason, OverriddenBy: row.OverriddenBy,
			OverriddenAt: timeOrZero(row.OverriddenAt),
		})
	}
	return out, nil
}

// SummaryRepo implements the visit summary port (SRS-ENC-009).
type SummaryRepo struct{ *Repository }

var _ ports.SummaryRepository = SummaryRepo{}

// Insert stores one version of a visit summary.
func (r SummaryRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	s domain.VisitSummary) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	summaryID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Internal("ENC_SUMMARY_ID_INVALID",
			"summary_id must be a UUID").WithCause(err)
	}
	encounterID, err := uuid.Parse(s.EncounterID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(s.PatientID)
	if err != nil {
		return rpcerr.Invalid("ENC_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	supersedes, err := optionalUUID(s.SupersedesID)
	if err != nil {
		return err
	}

	// Flattened rather than joined: the summary must survive a later edit of
	// its sources, which is the whole reason it is stored.
	diagnoses, err := json.Marshal(s.Diagnoses)
	if err != nil {
		return rpcerr.Internal("ENC_SUMMARY_ENCODE_FAILED",
			"could not encode the summary's diagnoses").WithCause(err)
	}

	return r.queries(ctx).InsertVisitSummary(ctx, sqlcgen.InsertVisitSummaryParams{
		SummaryID: summaryID, TenantID: tenantID, EncounterID: encounterID,
		PatientID: patientID, Version: int32(s.Version), SupersedesID: supersedes,
		AmendmentReason: s.AmendmentReason, EncounterClass: string(s.Class),
		StartedAt: timestamptz(s.StartedAt), EndedAt: timestamptz(s.EndedAt),
		Diagnoses: diagnoses, CareTeam: orEmpty(s.CareTeam),
		Narrative: s.Narrative, GeneratedBy: s.GeneratedBy,
		GeneratedAt: timestamptz(s.GeneratedAt),
	})
}

// ForEncounter returns every version, newest first. The superseded ones stay
// readable: somebody acted on them.
func (r SummaryRepo) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string) ([]domain.VisitSummary, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListVisitSummaries(ctx, sqlcgen.ListVisitSummariesParams{
		TenantID: tenantID, EncounterID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.VisitSummary, 0, len(rows))
	for _, row := range rows {
		var diagnoses []domain.Coding
		if len(row.Diagnoses) > 0 {
			if err := json.Unmarshal(row.Diagnoses, &diagnoses); err != nil {
				return nil, rpcerr.Internal("ENC_SUMMARY_DECODE_FAILED",
					"could not decode a stored summary").WithCause(err)
			}
		}
		out = append(out, domain.VisitSummary{
			ID: row.SummaryID.String(), TenantID: row.TenantID.String(),
			EncounterID: row.EncounterID.String(), PatientID: row.PatientID.String(),
			Version: int(row.Version), SupersedesID: uuidOrEmpty(row.SupersedesID),
			AmendmentReason: row.AmendmentReason, Class: domain.Class(row.EncounterClass),
			StartedAt: timeOrZero(row.StartedAt), EndedAt: timeOrZero(row.EndedAt),
			Diagnoses: diagnoses, CareTeam: row.CareTeam, Narrative: row.Narrative,
			GeneratedBy: row.GeneratedBy, GeneratedAt: timeOrZero(row.GeneratedAt),
		})
	}
	return out, nil
}
