package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InsertRule stores a new revision of an MDRO alert rule (SRS-IPC-004).
func (r *Repository) InsertRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.AlertRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_RULE_ID_INVALID", "rule id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionAlertRule(ctx,
		sqlcgen.InsertInfectionAlertRuleParams{
			RuleID: ruleID, TenantID: tenantID, Code: rule.Code,
			Name: rule.Name, Revision: int32(rule.Revision),
			Organisms:    texts(rule.Organisms),
			LookbackDays: int32(rule.LookbackDays),
			Precaution:   string(rule.Precaution), Advice: rule.Advice,
			EffectiveFrom: stamp(rule.EffectiveFrom),
			CreatedAt:     stamp(rule.CreatedAt), CreatedBy: rule.CreatedBy,
		})
}

// Rule reads one alert rule revision.
func (r *Repository) Rule(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.AlertRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.AlertRule{}, err
	}
	ruleID, err := uuid.Parse(id)
	if err != nil {
		return domain.AlertRule{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionAlertRule(ctx,
		sqlcgen.GetInfectionAlertRuleParams{
			TenantID: tenantID, RuleID: ruleID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.AlertRule{}, notFound()
	}
	if err != nil {
		return domain.AlertRule{}, err
	}
	return alertRuleFrom(row), nil
}

// ApproveRule signs a rule off. Refused by the database for an author
// approving their own.
func (r *Repository) ApproveRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.AlertRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveInfectionAlertRule(ctx,
		sqlcgen.ApproveInfectionAlertRuleParams{
			ApprovedBy: rule.ApprovedBy, ApprovedAt: stamp(rule.ApprovedAt),
			EffectiveFrom: stamp(rule.EffectiveFrom),
			TenantID:      tenantID, RuleID: ruleID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("IPC_RULE_ALREADY_APPROVED",
			"this rule is already approved")
	}
	return nil
}

// SupersedeEarlier closes off every earlier revision of a rule code, so two
// revisions cannot be live at the same moment (SRS-IPC-004).
func (r *Repository) SupersedeEarlier(ctx context.Context,
	scope authctx.TenantScope, code string, revision int, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeInfectionAlertRule(ctx,
		sqlcgen.SupersedeInfectionAlertRuleParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// Rules lists rule revisions. A non-zero liveAt narrows to the ones in force
// at that moment.
func (r *Repository) Rules(ctx context.Context, scope authctx.TenantScope,
	code string, liveAt time.Time) ([]domain.AlertRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListInfectionAlertRules(ctx,
		sqlcgen.ListInfectionAlertRulesParams{
			TenantID: tenantID, Code: code,
			LiveOnly: !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.AlertRule, 0, len(rows))
	for _, row := range rows {
		out = append(out, alertRuleFrom(row))
	}
	return out, nil
}

func alertRuleFrom(row sqlcgen.InfectionAlertRule) domain.AlertRule {
	return domain.AlertRule{
		ID: row.RuleID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		Organisms: row.Organisms, LookbackDays: int(row.LookbackDays),
		Precaution: domain.Precaution(row.Precaution), Advice: row.Advice,
		Approved: row.Approved, ApprovedBy: row.ApprovedBy,
		ApprovedAt:    timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertAlert records a rule firing (SRS-IPC-004).
func (r *Repository) InsertAlert(ctx context.Context,
	scope authctx.TenantScope, a domain.Alert) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	alertID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_ALERT_ID_INVALID",
			"alert id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionAlert(ctx,
		sqlcgen.InsertInfectionAlertParams{
			AlertID: alertID, TenantID: tenantID, PatientID: a.PatientID,
			EncounterID: a.EncounterID, FacilityID: a.FacilityID,
			RuleID: optionalUUID(a.RuleID), RuleCode: a.RuleCode,
			RuleRevision: int32(a.RuleRevision),
			Organism:     a.Organism, OrganismCode: a.OrganismCode,
			LastPositiveAt: stamp(a.LastPositiveAt),
			Precaution:     string(a.Precaution), Advice: a.Advice,
			RaisedAt: stamp(a.RaisedAt),
		})
}

// Alert reads one alert.
func (r *Repository) Alert(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Alert, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Alert{}, err
	}
	alertID, err := uuid.Parse(id)
	if err != nil {
		return domain.Alert{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionAlert(ctx,
		sqlcgen.GetInfectionAlertParams{TenantID: tenantID, AlertID: alertID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Alert{}, notFound()
	}
	if err != nil {
		return domain.Alert{}, err
	}
	return alertFrom(row), nil
}

// UpdateAlert records an acknowledgement or an override.
func (r *Repository) UpdateAlert(ctx context.Context,
	scope authctx.TenantScope, a domain.Alert) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	alertID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionAlert(ctx,
		sqlcgen.UpdateInfectionAlertParams{
			AcknowledgedAt: stamp(a.AcknowledgedAt),
			AcknowledgedBy: a.AcknowledgedBy,
			Overridden:     a.Overridden, OverrideWhy: a.OverrideWhy,
			OverriddenBy: a.OverriddenBy,
			OverriddenAt: stamp(a.OverriddenAt),
			TenantID:     tenantID, AlertID: alertID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// Alerts lists what fired for a patient or an encounter.
func (r *Repository) Alerts(ctx context.Context, scope authctx.TenantScope,
	patientID, encounterID string, outstandingOnly bool, limit int32) (
	[]domain.Alert, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	size, offset := page(limit, 0)

	rows, err := r.queries(ctx).ListInfectionAlerts(ctx,
		sqlcgen.ListInfectionAlertsParams{
			TenantID: tenantID, EncounterID: encounterID,
			PatientID: patientID, OutstandingOnly: outstandingOnly,
			PageSize: size, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Alert, 0, len(rows))
	for _, row := range rows {
		out = append(out, alertFrom(row))
	}
	return out, nil
}

func alertFrom(row sqlcgen.InfectionAlert) domain.Alert {
	return domain.Alert{
		ID: row.AlertID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		FacilityID: row.FacilityID, RuleID: uuidString(row.RuleID),
		RuleCode: row.RuleCode, RuleRevision: int(row.RuleRevision),
		Organism: row.Organism, OrganismCode: row.OrganismCode,
		LastPositiveAt: timeOf(row.LastPositiveAt),
		Precaution:     domain.Precaution(row.Precaution), Advice: row.Advice,
		RaisedAt:       timeOf(row.RaisedAt),
		AcknowledgedAt: timeOf(row.AcknowledgedAt),
		AcknowledgedBy: row.AcknowledgedBy,
		Overridden:     row.Overridden, OverrideWhy: row.OverrideWhy,
		OverriddenBy: row.OverriddenBy,
		OverriddenAt: timeOf(row.OverriddenAt),
	}
}

// InsertOutbreak opens a cluster investigation (SRS-IPC-005).
func (r *Repository) InsertOutbreak(ctx context.Context,
	scope authctx.TenantScope, o domain.Outbreak) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	outbreakID, err := uuid.Parse(o.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_OUTBREAK_ID_INVALID",
			"outbreak id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionOutbreak(ctx,
		sqlcgen.InsertInfectionOutbreakParams{
			OutbreakID: outbreakID, TenantID: tenantID,
			Reference: o.Reference, Organism: o.Organism,
			CaseDefinition: o.CaseDefinition, Locations: texts(o.Locations),
			WindowFrom: stamp(o.WindowFrom), WindowTo: stamp(o.WindowTo),
			State:     string(o.State),
			CreatedAt: stamp(o.CreatedAt), CreatedBy: o.CreatedBy,
		})
}

// Outbreak reads one investigation.
func (r *Repository) Outbreak(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Outbreak, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Outbreak{}, err
	}
	outbreakID, err := uuid.Parse(id)
	if err != nil {
		return domain.Outbreak{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionOutbreak(ctx,
		sqlcgen.GetInfectionOutbreakParams{
			TenantID: tenantID, OutbreakID: outbreakID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Outbreak{}, notFound()
	}
	if err != nil {
		return domain.Outbreak{}, err
	}
	return outbreakFrom(row), nil
}

// UpdateOutbreak advances, contains or closes an investigation.
func (r *Repository) UpdateOutbreak(ctx context.Context,
	scope authctx.TenantScope, o domain.Outbreak,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	outbreakID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionOutbreak(ctx,
		sqlcgen.UpdateInfectionOutbreakParams{
			State: string(o.State), Findings: o.Findings,
			ControlMeasures: texts(o.ControlMeasures),
			ActionIds:       texts(o.ActionIDs),
			DeclaredAt:      stamp(o.DeclaredAt), DeclaredBy: o.DeclaredBy,
			ClosedAt: stamp(o.ClosedAt), ClosedBy: o.ClosedBy,
			ClosureWhy: o.ClosureWhy,
			TenantID:   tenantID, OutbreakID: outbreakID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Outbreaks lists investigations.
func (r *Repository) Outbreaks(ctx context.Context, scope authctx.TenantScope,
	state string, openOnly bool, limit int32) ([]domain.Outbreak, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	size, offset := page(limit, 0)

	rows, err := r.queries(ctx).ListInfectionOutbreaks(ctx,
		sqlcgen.ListInfectionOutbreaksParams{
			TenantID: tenantID, State: state, OpenOnly: openOnly,
			PageSize: size, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Outbreak, 0, len(rows))
	for _, row := range rows {
		out = append(out, outbreakFrom(row))
	}
	return out, nil
}

func outbreakFrom(row sqlcgen.InfectionOutbreak) domain.Outbreak {
	return domain.Outbreak{
		ID: row.OutbreakID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Organism: row.Organism,
		CaseDefinition: row.CaseDefinition, Locations: row.Locations,
		WindowFrom: timeOf(row.WindowFrom), WindowTo: timeOf(row.WindowTo),
		State: domain.OutbreakState(row.State), Findings: row.Findings,
		ControlMeasures: row.ControlMeasures, ActionIDs: row.ActionIds,
		DeclaredAt: timeOf(row.DeclaredAt), DeclaredBy: row.DeclaredBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureWhy: row.ClosureWhy,
		CreatedAt:  timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// AddMember records a membership decision (SRS-IPC-005).
func (r *Repository) AddMember(ctx context.Context, scope authctx.TenantScope,
	m domain.Membership) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	membershipID, err := uuid.Parse(m.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_MEMBERSHIP_ID_INVALID",
			"membership id must be a UUID")
	}
	outbreakID, err := uuid.Parse(m.OutbreakID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertInfectionOutbreakMember(ctx,
		sqlcgen.InsertInfectionOutbreakMemberParams{
			MembershipID: membershipID, TenantID: tenantID,
			OutbreakID: outbreakID, CaseID: m.CaseID,
			PatientID: m.PatientID, Reason: string(m.Reason), Note: m.Note,
			DecidedAt: stamp(m.DecidedAt), DecidedBy: m.DecidedBy,
		})
}

// Members lists a cluster's membership decisions.
func (r *Repository) Members(ctx context.Context, scope authctx.TenantScope,
	outbreakID string) ([]domain.Membership, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(outbreakID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListInfectionOutbreakMembers(ctx,
		sqlcgen.ListInfectionOutbreakMembersParams{
			TenantID: tenantID, OutbreakID: id,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Membership, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Membership{
			ID: row.MembershipID.String(), TenantID: row.TenantID.String(),
			OutbreakID: row.OutbreakID.String(), CaseID: row.CaseID,
			PatientID: row.PatientID,
			Reason:    domain.MembershipReason(row.Reason), Note: row.Note,
			DecidedAt: timeOf(row.DecidedAt), DecidedBy: row.DecidedBy,
		})
	}
	return out, nil
}

// InsertSession opens a hand hygiene observation period (SRS-IPC-006).
func (r *Repository) InsertSession(ctx context.Context,
	scope authctx.TenantScope, s domain.HygieneSession) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	sessionID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_SESSION_ID_INVALID",
			"session id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionHygieneSession(ctx,
		sqlcgen.InsertInfectionHygieneSessionParams{
			SessionID: sessionID, TenantID: tenantID,
			FacilityID: s.FacilityID, LocationID: s.LocationID,
			ObserverID: s.ObserverID, StartedAt: stamp(s.StartedAt),
			Notes: s.Notes, CreatedAt: stamp(s.CreatedAt),
		})
}

// Session reads one observation period.
func (r *Repository) Session(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.HygieneSession, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.HygieneSession{}, err
	}
	sessionID, err := uuid.Parse(id)
	if err != nil {
		return domain.HygieneSession{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionHygieneSession(ctx,
		sqlcgen.GetInfectionHygieneSessionParams{
			TenantID: tenantID, SessionID: sessionID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.HygieneSession{}, notFound()
	}
	if err != nil {
		return domain.HygieneSession{}, err
	}
	return domain.HygieneSession{
		ID: row.SessionID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID, LocationID: row.LocationID,
		ObserverID: row.ObserverID, StartedAt: timeOf(row.StartedAt),
		EndedAt: timeOf(row.EndedAt), Notes: row.Notes,
		CreatedAt: timeOf(row.CreatedAt), Version: row.Version,
	}, nil
}

// EndSession closes an observation period.
func (r *Repository) EndSession(ctx context.Context,
	scope authctx.TenantScope, s domain.HygieneSession,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	sessionID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).EndInfectionHygieneSession(ctx,
		sqlcgen.EndInfectionHygieneSessionParams{
			EndedAt: stamp(s.EndedAt), Notes: s.Notes,
			TenantID: tenantID, SessionID: sessionID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// InsertObservation records one opportunity. There is no parameter here
// naming the person observed, and no column to put one in (SRS-IPC-006).
func (r *Repository) InsertObservation(ctx context.Context,
	scope authctx.TenantScope, o domain.HygieneObservation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	observationID, err := uuid.Parse(o.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_OBSERVATION_ID_INVALID",
			"observation id must be a UUID")
	}
	sessionID, err := uuid.Parse(o.SessionID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertInfectionHygieneObservation(ctx,
		sqlcgen.InsertInfectionHygieneObservationParams{
			ObservationID: observationID, TenantID: tenantID,
			SessionID:  sessionID,
			Discipline: string(o.Discipline), Moment: string(o.Moment),
			Action: string(o.Action), GlovesWorn: o.GlovesWorn,
			ObservedAt: stamp(o.ObservedAt),
		})
}

// Observations lists what was seen, for the aggregate reports.
func (r *Repository) Observations(ctx context.Context,
	scope authctx.TenantScope, locationID, sessionID string,
	from, to time.Time) ([]domain.HygieneObservation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	start, end := window(from, to)

	rows, err := r.queries(ctx).ListInfectionHygieneObservations(ctx,
		sqlcgen.ListInfectionHygieneObservationsParams{
			TenantID: tenantID, LocationID: locationID,
			SessionID:    sessionID,
			ObservedFrom: stamp(start), ObservedTo: stamp(end),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.HygieneObservation, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.HygieneObservation{
			ID: row.ObservationID.String(), TenantID: row.TenantID.String(),
			SessionID:  row.SessionID.String(),
			Discipline: domain.Discipline(row.Discipline),
			Moment:     domain.Moment(row.Moment),
			Action:     domain.Action(row.Action),
			GlovesWorn: row.GlovesWorn, ObservedAt: timeOf(row.ObservedAt),
		})
	}
	return out, nil
}
