package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// DistributionRepo implements ports.DistributionRepository.
type DistributionRepo struct{ *Repository }

var _ ports.DistributionRepository = DistributionRepo{}

// InsertIssue sends a sterile pack out.
func (r DistributionRepo) InsertIssue(ctx context.Context,
	scope authctx.TenantScope, i domain.Issue) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	issueID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	runID, err := uuid.Parse(i.RunID)
	if err != nil {
		return notFound()
	}
	cycleID, err := optionalUUID(i.CycleID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertSterileIssue(ctx,
		sqlcgen.InsertSterileIssueParams{
			IssueID: issueID, TenantID: tenantID, RunID: runID,
			SetCode: i.SetCode, CycleID: cycleID,
			Destination: i.Destination, IssuedTo: i.IssuedTo,
			State:    string(i.State),
			IssuedAt: stamp(i.IssuedAt), IssuedBy: i.IssuedBy,
		})
}

// Issue reads one issued pack.
func (r DistributionRepo) Issue(ctx context.Context, scope authctx.TenantScope,
	issueID string) (domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Issue{}, err
	}
	id, err := uuid.Parse(issueID)
	if err != nil {
		return domain.Issue{}, notFound()
	}

	row, err := r.queries(ctx).GetSterileIssue(ctx,
		sqlcgen.GetSterileIssueParams{TenantID: tenantID, IssueID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Issue{}, notFound()
	}
	if err != nil {
		return domain.Issue{}, err
	}
	return issueFrom(row)
}

// UpdateIssue records a use, a return or a recall.
func (r DistributionRepo) UpdateIssue(ctx context.Context,
	scope authctx.TenantScope, i domain.Issue) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	issueID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	usedCaseID, err := optionalUUID(i.UsedCaseID)
	if err != nil {
		return err
	}
	returned, err := counts0(i.ReturnCount)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateSterileIssue(ctx,
		sqlcgen.UpdateSterileIssueParams{
			TenantID: tenantID, IssueID: issueID,
			State: string(i.State), UsedCaseID: usedCaseID,
			ReturnCount: returned, ReturnNote: i.ReturnNote,
			ClosedAt: stamp(i.ClosedAt), ClosedBy: i.ClosedBy,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// IssuesForRun reads every issue of one pack.
func (r DistributionRepo) IssuesForRun(ctx context.Context,
	scope authctx.TenantScope, runID string) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(runID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIssuesForRun(ctx,
		sqlcgen.ListIssuesForRunParams{TenantID: tenantID, RunID: id})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows)
}

// IssuesForCase runs SRS-CSSD-010's direction: from a patient's operation back
// to every set it used.
func (r DistributionRepo) IssuesForCase(ctx context.Context,
	scope authctx.TenantScope, caseID string) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(caseID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIssuesForCase(ctx,
		sqlcgen.ListIssuesForCaseParams{
			TenantID: tenantID, UsedCaseID: pgtypeUUID(id),
		})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows)
}

// IssuesForCycle is the recall's reach: every issue of every pack in one load.
func (r DistributionRepo) IssuesForCycle(ctx context.Context,
	scope authctx.TenantScope, cycleID string) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(cycleID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIssuesForCycle(ctx,
		sqlcgen.ListIssuesForCycleParams{
			TenantID: tenantID, CycleID: pgtypeUUID(id),
		})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows)
}

// Outstanding reads what is out, so a recall knows where to go.
func (r DistributionRepo) Outstanding(ctx context.Context,
	scope authctx.TenantScope, destination string, limit int32) (
	[]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOutstandingIssues(ctx,
		sqlcgen.ListOutstandingIssuesParams{
			TenantID: tenantID, Destination: destination, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows)
}

func issuesFrom(rows []sqlcgen.SterileIssue) ([]domain.Issue, error) {
	out := make([]domain.Issue, 0, len(rows))
	for _, row := range rows {
		issue, err := issueFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, issue)
	}
	return out, nil
}

func issueFrom(row sqlcgen.SterileIssue) (domain.Issue, error) {
	returned, err := countsFrom(row.ReturnCount)
	if err != nil {
		return domain.Issue{}, err
	}
	return domain.Issue{
		ID: row.IssueID.String(), TenantID: row.TenantID.String(),
		RunID: row.RunID.String(), SetCode: row.SetCode,
		CycleID:     uuidOrEmpty(row.CycleID),
		Destination: row.Destination, IssuedTo: row.IssuedTo,
		State:       domain.IssueState(row.State),
		UsedCaseID:  uuidOrEmpty(row.UsedCaseID),
		ReturnCount: returned, ReturnNote: row.ReturnNote,
		IssuedAt: timeOf(row.IssuedAt), IssuedBy: row.IssuedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
	}, nil
}

// InsertRecall raises a recall.
func (r DistributionRepo) InsertRecall(ctx context.Context,
	scope authctx.TenantScope, recall ports.Recall) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	recallID, err := uuid.Parse(recall.ID)
	if err != nil {
		return notFound()
	}
	cycleID, err := uuid.Parse(recall.CycleID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertRecall(ctx, sqlcgen.InsertRecallParams{
		RecallID: recallID, TenantID: tenantID, CycleID: cycleID,
		Reason: recall.Reason,
		// Frozen at the moment it was raised, because the packs move
		// afterwards and a recall report has to say what it found.
		PacksAffected: int32(recall.PacksAffected),
		CasesAffected: int32(recall.CasesAffected),
		RaisedAt:      stamp(recall.RaisedAt), RaisedBy: recall.RaisedBy,
	})
}

// Recall reads one raised recall.
func (r DistributionRepo) Recall(ctx context.Context, scope authctx.TenantScope,
	recallID string) (ports.Recall, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return ports.Recall{}, err
	}
	id, err := uuid.Parse(recallID)
	if err != nil {
		return ports.Recall{}, notFound()
	}

	row, err := r.queries(ctx).GetRecall(ctx, sqlcgen.GetRecallParams{
		TenantID: tenantID, RecallID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return ports.Recall{}, notFound()
	}
	if err != nil {
		return ports.Recall{}, err
	}
	return recallFrom(row), nil
}

// CloseRecall ends a recall.
//
// False where somebody closed it first, so two people finishing the same
// recall do not produce two closing notes for one event.
func (r DistributionRepo) CloseRecall(ctx context.Context,
	scope authctx.TenantScope, recallID, note, by string, at time.Time) (
	bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(recallID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).CloseRecall(ctx, sqlcgen.CloseRecallParams{
		TenantID: tenantID, RecallID: id,
		ClosedAt: stamp(at), ClosedBy: by, ClosingNote: note,
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// OpenRecalls is the department's outstanding list.
func (r DistributionRepo) OpenRecalls(ctx context.Context,
	scope authctx.TenantScope, limit int32) ([]ports.Recall, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOpenRecalls(ctx, sqlcgen.ListOpenRecallsParams{
		TenantID: tenantID, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]ports.Recall, 0, len(rows))
	for _, row := range rows {
		out = append(out, recallFrom(row))
	}
	return out, nil
}

func recallFrom(row sqlcgen.SterileRecall) ports.Recall {
	return ports.Recall{
		ID: row.RecallID.String(), TenantID: row.TenantID.String(),
		CycleID: row.CycleID.String(), Reason: row.Reason,
		PacksAffected: int(row.PacksAffected),
		CasesAffected: int(row.CasesAffected),
		RaisedAt:      timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosingNote: row.ClosingNote,
	}
}
