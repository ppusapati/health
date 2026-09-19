package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// AuditRepo implements ports.AuditRepository.
type AuditRepo struct{ *Repository }

var _ ports.AuditRepository = AuditRepo{}

// InsertAudit plans an internal audit (SRS-QMS-007).
func (r AuditRepo) InsertAudit(ctx context.Context, scope authctx.TenantScope,
	a domain.Audit) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	auditID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityAudit(ctx,
		sqlcgen.InsertQualityAuditParams{
			AuditID: auditID, TenantID: tenantID, Reference: a.Reference,
			Title: a.Title, Scope: a.Scope,
			StandardID: optionalUUID(a.StandardID),
			AuditorID:  a.AuditorID, AuditeeDepartment: a.AuditeeDepartment,
			PlannedFrom: stamp(a.PlannedFrom), PlannedTo: stamp(a.PlannedTo),
			State:     string(a.State),
			CreatedAt: stamp(a.CreatedAt), CreatedBy: a.CreatedBy,
		})
}

// Audit reads one.
func (r AuditRepo) Audit(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Audit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Audit{}, err
	}
	auditID, err := uuid.Parse(id)
	if err != nil {
		return domain.Audit{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityAudit(ctx,
		sqlcgen.GetQualityAuditParams{TenantID: tenantID, AuditID: auditID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Audit{}, notFound()
	}
	if err != nil {
		return domain.Audit{}, err
	}
	return auditFrom(row), nil
}

// UpdateAudit writes a report or a closure.
func (r AuditRepo) UpdateAudit(ctx context.Context, scope authctx.TenantScope,
	a domain.Audit, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	auditID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityAudit(ctx,
		sqlcgen.UpdateQualityAuditParams{
			TenantID: tenantID, AuditID: auditID, State: string(a.State),
			Summary: a.Summary, ClosedAt: stamp(a.ClosedAt),
			ClosedBy: a.ClosedBy, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Audits lists the programme.
func (r AuditRepo) Audits(ctx context.Context, scope authctx.TenantScope,
	state string, limit int32) ([]domain.Audit, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityAudits(ctx,
		sqlcgen.ListQualityAuditsParams{
			TenantID: tenantID, State: state, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Audit, 0, len(rows))
	for _, row := range rows {
		out = append(out, auditFrom(row))
	}
	return out, nil
}

// InsertFinding records what an audit found (SRS-QMS-007).
func (r AuditRepo) InsertFinding(ctx context.Context,
	scope authctx.TenantScope, f domain.Finding) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	findingID, err := uuid.Parse(f.ID)
	if err != nil {
		return notFound()
	}
	auditID, err := uuid.Parse(f.AuditID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityFinding(ctx,
		sqlcgen.InsertQualityFindingParams{
			FindingID: findingID, TenantID: tenantID, AuditID: auditID,
			ClauseID: optionalUUID(f.ClauseID), Severity: string(f.Severity),
			Detail: f.Detail, Evidence: f.Evidence,
			RaisedAt: stamp(f.RaisedAt), RaisedBy: f.RaisedBy,
		})
}

// Finding reads one.
func (r AuditRepo) Finding(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Finding, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Finding{}, err
	}
	findingID, err := uuid.Parse(id)
	if err != nil {
		return domain.Finding{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityFinding(ctx,
		sqlcgen.GetQualityFindingParams{TenantID: tenantID, FindingID: findingID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Finding{}, notFound()
	}
	if err != nil {
		return domain.Finding{}, err
	}
	return findingFrom(row), nil
}

// UpdateFinding links an action or closes the finding.
func (r AuditRepo) UpdateFinding(ctx context.Context,
	scope authctx.TenantScope, f domain.Finding) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	findingID, err := uuid.Parse(f.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpdateQualityFinding(ctx,
		sqlcgen.UpdateQualityFindingParams{
			TenantID: tenantID, FindingID: findingID,
			CapaID: optionalUUID(f.CAPAID), ClosedAt: stamp(f.ClosedAt),
			ClosedBy: f.ClosedBy, ClosureNote: f.ClosureNote,
		})
}

// Findings lists what an audit found, or everything still open.
func (r AuditRepo) Findings(ctx context.Context, scope authctx.TenantScope,
	auditID string, openOnly bool) ([]domain.Finding, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityFindings(ctx,
		sqlcgen.ListQualityFindingsParams{
			TenantID: tenantID, AuditID: auditID, OpenOnly: openOnly,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Finding, 0, len(rows))
	for _, row := range rows {
		out = append(out, findingFrom(row))
	}
	return out, nil
}

func auditFrom(row sqlcgen.QualityAudit) domain.Audit {
	return domain.Audit{
		ID: row.AuditID.String(), TenantID: row.TenantID.String(),
		Reference: row.Reference, Title: row.Title, Scope: row.Scope,
		StandardID: uuidString(row.StandardID),
		AuditorID:  row.AuditorID, AuditeeDepartment: row.AuditeeDepartment,
		PlannedFrom: timeOf(row.PlannedFrom), PlannedTo: timeOf(row.PlannedTo),
		State: domain.AuditState(row.State), Summary: row.Summary,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		Version: row.Version,
	}
}

func findingFrom(row sqlcgen.QualityAuditFinding) domain.Finding {
	return domain.Finding{
		ID: row.FindingID.String(), TenantID: row.TenantID.String(),
		AuditID: row.AuditID.String(), ClauseID: uuidString(row.ClauseID),
		Severity: domain.FindingSeverity(row.Severity),
		Detail:   row.Detail, Evidence: row.Evidence,
		CAPAID:   uuidString(row.CapaID),
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureNote: row.ClosureNote,
		RaisedAt:    timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
	}
}

// CommitteeRepo implements ports.CommitteeRepository.
type CommitteeRepo struct{ *Repository }

var _ ports.CommitteeRepository = CommitteeRepo{}

// InsertCommittee registers a standing group (SRS-QMS-008).
func (r CommitteeRepo) InsertCommittee(ctx context.Context,
	scope authctx.TenantScope, c domain.Committee) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	committeeID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityCommittee(ctx,
		sqlcgen.InsertQualityCommitteeParams{
			CommitteeID: committeeID, TenantID: tenantID,
			Code: c.Code, Name: c.Name, Terms: c.Terms,
			QuorumSize: int32(c.QuorumSize), Restricted: c.Restricted,
			Members: texts(c.Members), Active: c.Active,
			CreatedAt: stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
		})
}

// Committee reads one.
func (r CommitteeRepo) Committee(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Committee, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Committee{}, err
	}
	committeeID, err := uuid.Parse(id)
	if err != nil {
		return domain.Committee{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityCommittee(ctx,
		sqlcgen.GetQualityCommitteeParams{
			TenantID: tenantID, CommitteeID: committeeID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Committee{}, notFound()
	}
	if err != nil {
		return domain.Committee{}, err
	}
	return committeeFrom(row), nil
}

// UpdateCommittee writes a membership or quorum change.
func (r CommitteeRepo) UpdateCommittee(ctx context.Context,
	scope authctx.TenantScope, c domain.Committee,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	committeeID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateQualityCommittee(ctx,
		sqlcgen.UpdateQualityCommitteeParams{
			TenantID: tenantID, CommitteeID: committeeID,
			Name: c.Name, Terms: c.Terms, QuorumSize: int32(c.QuorumSize),
			Members: texts(c.Members), Active: c.Active,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Committees lists them.
func (r CommitteeRepo) Committees(ctx context.Context,
	scope authctx.TenantScope, activeOnly bool) ([]domain.Committee, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListQualityCommittees(ctx,
		sqlcgen.ListQualityCommitteesParams{
			TenantID: tenantID, ActiveOnly: activeOnly,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Committee, 0, len(rows))
	for _, row := range rows {
		out = append(out, committeeFrom(row))
	}
	return out, nil
}

// InsertMeeting schedules a sitting (SRS-QMS-008).
func (r CommitteeRepo) InsertMeeting(ctx context.Context,
	scope authctx.TenantScope, m domain.Meeting) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	meetingID, err := uuid.Parse(m.ID)
	if err != nil {
		return notFound()
	}
	committeeID, err := uuid.Parse(m.CommitteeID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertQualityMeeting(ctx,
		sqlcgen.InsertQualityMeetingParams{
			MeetingID: meetingID, TenantID: tenantID, CommitteeID: committeeID,
			ScheduledAt: stamp(m.ScheduledAt), Agenda: texts(m.Agenda),
			State: string(m.State), Restricted: m.Restricted,
			CreatedAt: stamp(m.CreatedAt), CreatedBy: m.CreatedBy,
		})
}

// Meeting reads one sitting.
func (r CommitteeRepo) Meeting(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Meeting, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Meeting{}, err
	}
	meetingID, err := uuid.Parse(id)
	if err != nil {
		return domain.Meeting{}, notFound()
	}

	row, err := r.queries(ctx).GetQualityMeeting(ctx,
		sqlcgen.GetQualityMeetingParams{TenantID: tenantID, MeetingID: meetingID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Meeting{}, notFound()
	}
	if err != nil {
		return domain.Meeting{}, err
	}
	return meetingFrom(row)
}

// UpdateMeeting writes attendance, minutes and decisions.
func (r CommitteeRepo) UpdateMeeting(ctx context.Context,
	scope authctx.TenantScope, m domain.Meeting, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	meetingID, err := uuid.Parse(m.ID)
	if err != nil {
		return notFound()
	}
	decisions, err := encode(m.Decisions)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateQualityMeeting(ctx,
		sqlcgen.UpdateQualityMeetingParams{
			TenantID: tenantID, MeetingID: meetingID,
			HeldAt: stamp(m.HeldAt), Attendees: texts(m.Attendees),
			Apologies: texts(m.Apologies), Minutes: m.Minutes,
			Decisions: decisions,
			State:     string(m.State), ApprovedBy: m.ApprovedBy,
			ApprovedAt: stamp(m.ApprovedAt), ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Meetings lists a committee's sittings.
func (r CommitteeRepo) Meetings(ctx context.Context,
	scope authctx.TenantScope, committeeID string, limit int32) (
	[]domain.Meeting, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(committeeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListQualityMeetings(ctx,
		sqlcgen.ListQualityMeetingsParams{
			TenantID: tenantID, CommitteeID: parsed, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Meeting, 0, len(rows))
	for _, row := range rows {
		meeting, err := meetingFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, meeting)
	}
	return out, nil
}

func committeeFrom(row sqlcgen.QualityCommittee) domain.Committee {
	return domain.Committee{
		ID: row.CommitteeID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Terms: row.Terms,
		QuorumSize: int(row.QuorumSize), Restricted: row.Restricted,
		Members: row.Members, Active: row.Active,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

func meetingFrom(row sqlcgen.QualityCommitteeMeeting) (domain.Meeting, error) {
	meeting := domain.Meeting{
		ID: row.MeetingID.String(), TenantID: row.TenantID.String(),
		CommitteeID: row.CommitteeID.String(),
		ScheduledAt: timeOf(row.ScheduledAt), HeldAt: timeOf(row.HeldAt),
		Agenda: row.Agenda, Attendees: row.Attendees,
		Apologies: row.Apologies, Minutes: row.Minutes,
		State: domain.MeetingState(row.State), ApprovedBy: row.ApprovedBy,
		ApprovedAt: timeOf(row.ApprovedAt), Restricted: row.Restricted,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
	if err := decode(row.Decisions, &meeting.Decisions); err != nil {
		return domain.Meeting{}, err
	}
	return meeting, nil
}
