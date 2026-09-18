package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// CrossmatchRepo implements ports.CrossmatchRepository.
type CrossmatchRepo struct{ *Repository }

var _ ports.CrossmatchRepository = CrossmatchRepo{}

// InsertRequest raises a request for blood.
func (r CrossmatchRepo) InsertRequest(ctx context.Context,
	scope authctx.TenantScope, req domain.Request) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	requestID, err := uuid.Parse(req.ID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(req.PatientID)
	if err != nil {
		return notFound()
	}
	encounterID, err := optionalUUID(req.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRequest(ctx, sqlcgen.InsertRequestParams{
		RequestID: requestID, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		FacilityID:     req.FacilityID,
		ComponentClass: string(req.Class), Quantity: int32(req.Quantity),
		Indication: req.Indication, Urgency: string(req.Urgency),
		Requirements: strings0(req.Requirements),
		RequiredBy:   stamp(req.RequiredBy),
		Status:       string(req.Status),
		RequestedBy:  req.RequestedBy, RequestedAt: stamp(req.RequestedAt),
	})
}

// Request reads one request.
func (r CrossmatchRepo) Request(ctx context.Context, scope authctx.TenantScope,
	requestID string) (domain.Request, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Request{}, err
	}
	id, err := uuid.Parse(requestID)
	if err != nil {
		return domain.Request{}, notFound()
	}

	row, err := r.queries(ctx).GetRequest(ctx, sqlcgen.GetRequestParams{
		TenantID: tenantID, RequestID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Request{}, notFound()
	}
	if err != nil {
		return domain.Request{}, err
	}
	return requestFrom(row), nil
}

// UpdateRequestStatus moves a request to fulfilled or cancelled.
func (r CrossmatchRepo) UpdateRequestStatus(ctx context.Context,
	scope authctx.TenantScope, requestID string, status domain.RequestStatus,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(requestID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRequestStatus(ctx,
		sqlcgen.UpdateRequestStatusParams{
			TenantID: tenantID, RequestID: id, Status: string(status),
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

// PatientRequests lists a patient's requests, most recent first.
func (r CrossmatchRepo) PatientRequests(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.Request, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientRequests(ctx,
		sqlcgen.ListPatientRequestsParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return requestsFrom(rows), nil
}

// OpenRequests is the blood bank's worklist.
func (r CrossmatchRepo) OpenRequests(ctx context.Context,
	scope authctx.TenantScope, facilityID string, limit int32) (
	[]domain.Request, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListOpenRequests(ctx,
		sqlcgen.ListOpenRequestsParams{
			TenantID: tenantID, FacilityID: facilityID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return requestsFrom(rows), nil
}

func requestsFrom(rows []sqlcgen.BloodbankRequest) []domain.Request {
	out := make([]domain.Request, 0, len(rows))
	for _, row := range rows {
		out = append(out, requestFrom(row))
	}
	return out
}

func requestFrom(row sqlcgen.BloodbankRequest) domain.Request {
	return domain.Request{
		ID: row.RequestID.String(), TenantID: row.TenantID.String(),
		PatientID:   row.PatientID.String(),
		EncounterID: uuidOrEmpty(row.EncounterID),
		FacilityID:  row.FacilityID,
		Class:       domain.ComponentClass(row.ComponentClass),
		Quantity:    int(row.Quantity), Indication: row.Indication,
		Urgency:      domain.RequestUrgency(row.Urgency),
		Requirements: row.Requirements, RequiredBy: timeOf(row.RequiredBy),
		Status:      domain.RequestStatus(row.Status),
		RequestedBy: row.RequestedBy, RequestedAt: timeOf(row.RequestedAt),
		Version: row.Version,
	}
}

// InsertSample records a patient's group and antibody screen.
func (r CrossmatchRepo) InsertSample(ctx context.Context,
	scope authctx.TenantScope, s domain.PatientSample) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	sampleID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(s.PatientID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPatientSample(ctx,
		sqlcgen.InsertPatientSampleParams{
			SampleID: sampleID, TenantID: tenantID, PatientID: patientID,
			SampleNumber: s.SampleNumber,
			Abo:          string(s.Group.ABO), Rhd: string(s.Group.Rh),
			AntibodyScreenPositive: s.AntibodyScreenPositive,
			AntibodyNote:           s.AntibodyNote,
			SecondCheck:            s.SecondCheck,
			CollectedAt:            stamp(s.CollectedAt),
			CollectedBy:            s.CollectedBy,
			ExpiresAt:              stamp(s.ExpiresAt),
			TestedAt:               stamp(s.TestedAt), TestedBy: s.TestedBy,
		})
}

// Sample reads one grouping sample.
func (r CrossmatchRepo) Sample(ctx context.Context, scope authctx.TenantScope,
	sampleID string) (domain.PatientSample, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PatientSample{}, err
	}
	id, err := uuid.Parse(sampleID)
	if err != nil {
		return domain.PatientSample{}, notFound()
	}

	row, err := r.queries(ctx).GetPatientSample(ctx,
		sqlcgen.GetPatientSampleParams{TenantID: tenantID, SampleID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PatientSample{}, notFound()
	}
	if err != nil {
		return domain.PatientSample{}, err
	}
	return sampleFrom(row), nil
}

// CurrentSample reads the patient's latest unexpired sample.
//
// False rather than an error where there is none: a patient nobody has grouped
// is an ordinary state, and it is the reason a match is refused rather than a
// fault.
func (r CrossmatchRepo) CurrentSample(ctx context.Context,
	scope authctx.TenantScope, patientID string, asOf time.Time) (
	domain.PatientSample, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PatientSample{}, false, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return domain.PatientSample{}, false, notFound()
	}

	row, err := r.queries(ctx).GetCurrentPatientSample(ctx,
		sqlcgen.GetCurrentPatientSampleParams{
			TenantID: tenantID, PatientID: id, AsOf: stamp(asOf),
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PatientSample{}, false, nil
	}
	if err != nil {
		return domain.PatientSample{}, false, err
	}
	return sampleFrom(row), true, nil
}

func sampleFrom(row sqlcgen.BloodbankPatientSample) domain.PatientSample {
	return domain.PatientSample{
		ID: row.SampleID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), SampleNumber: row.SampleNumber,
		Group:                  groupOf(row.Abo, row.Rhd),
		AntibodyScreenPositive: row.AntibodyScreenPositive,
		AntibodyNote:           row.AntibodyNote,
		SecondCheck:            row.SecondCheck,
		CollectedAt:            timeOf(row.CollectedAt),
		CollectedBy:            row.CollectedBy,
		ExpiresAt:              timeOf(row.ExpiresAt),
		TestedAt:               timeOf(row.TestedAt), TestedBy: row.TestedBy,
	}
}

// InsertReservation holds a unit for a patient.
func (r CrossmatchRepo) InsertReservation(ctx context.Context,
	scope authctx.TenantScope, res domain.Reservation) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reservationID, err := uuid.Parse(res.ID)
	if err != nil {
		return notFound()
	}
	componentID, err := uuid.Parse(res.ComponentID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(res.PatientID)
	if err != nil {
		return notFound()
	}
	requestID, err := optionalUUID(res.RequestID)
	if err != nil {
		return err
	}
	sampleID, err := optionalUUID(res.SampleID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertReservation(ctx, sqlcgen.InsertReservationParams{
		ReservationID: reservationID, TenantID: tenantID,
		ComponentID: componentID, RequestID: requestID,
		PatientID: patientID, SampleID: sampleID,
		Crossmatched: res.Crossmatched, CrossmatchNote: res.CrossmatchNote,
		Status: string(res.Status), ExpiresAt: stamp(res.ExpiresAt),
		ReservedAt: stamp(res.ReservedAt), ReservedBy: res.ReservedBy,
	})
}

// Reservation reads one hold.
func (r CrossmatchRepo) Reservation(ctx context.Context,
	scope authctx.TenantScope, reservationID string) (domain.Reservation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Reservation{}, err
	}
	id, err := uuid.Parse(reservationID)
	if err != nil {
		return domain.Reservation{}, notFound()
	}

	row, err := r.queries(ctx).GetReservation(ctx, sqlcgen.GetReservationParams{
		TenantID: tenantID, ReservationID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Reservation{}, notFound()
	}
	if err != nil {
		return domain.Reservation{}, err
	}
	return reservationFrom(row), nil
}

// CloseReservation ends a hold.
//
// False where somebody closed it first, so two callers releasing the same hold
// do not produce two release reasons for one event.
func (r CrossmatchRepo) CloseReservation(ctx context.Context,
	scope authctx.TenantScope, reservationID string,
	status domain.ReservationStatus, reason string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(reservationID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).UpdateReservationStatus(ctx,
		sqlcgen.UpdateReservationStatusParams{
			TenantID: tenantID, ReservationID: id,
			Status: string(status), ReleasedReason: reason,
		})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// ReservationsForComponent reads every hold ever placed on a unit.
func (r CrossmatchRepo) ReservationsForComponent(ctx context.Context,
	scope authctx.TenantScope, componentID string) ([]domain.Reservation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListReservationsForComponent(ctx,
		sqlcgen.ListReservationsForComponentParams{
			TenantID: tenantID, ComponentID: id,
		})
	if err != nil {
		return nil, err
	}
	return reservationsFrom(rows), nil
}

// PatientReservations reads a patient's holds.
func (r CrossmatchRepo) PatientReservations(ctx context.Context,
	scope authctx.TenantScope, patientID string, limit int32) (
	[]domain.Reservation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientReservations(ctx,
		sqlcgen.ListPatientReservationsParams{
			TenantID: tenantID, PatientID: id, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return reservationsFrom(rows), nil
}

// Lapsed reads holds past their window.
func (r CrossmatchRepo) Lapsed(ctx context.Context, scope authctx.TenantScope,
	asOf time.Time, limit int32) ([]domain.Reservation, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListLapsedReservations(ctx,
		sqlcgen.ListLapsedReservationsParams{
			TenantID: tenantID, AsOf: stamp(asOf), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return reservationsFrom(rows), nil
}

// CountReservations counts holds placed in a period, for the C:T ratio.
func (r CrossmatchRepo) CountReservations(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	count, err := r.queries(ctx).CountReservationsInPeriod(ctx,
		sqlcgen.CountReservationsInPeriodParams{
			TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return 0, err
	}
	return int(count), nil
}

func reservationsFrom(rows []sqlcgen.BloodbankReservation) []domain.Reservation {
	out := make([]domain.Reservation, 0, len(rows))
	for _, row := range rows {
		out = append(out, reservationFrom(row))
	}
	return out
}

func reservationFrom(row sqlcgen.BloodbankReservation) domain.Reservation {
	return domain.Reservation{
		ID: row.ReservationID.String(), TenantID: row.TenantID.String(),
		ComponentID:  row.ComponentID.String(),
		RequestID:    uuidOrEmpty(row.RequestID),
		PatientID:    row.PatientID.String(),
		SampleID:     uuidOrEmpty(row.SampleID),
		Crossmatched: row.Crossmatched, CrossmatchNote: row.CrossmatchNote,
		Status:     domain.ReservationStatus(row.Status),
		ExpiresAt:  timeOf(row.ExpiresAt),
		ReservedAt: timeOf(row.ReservedAt), ReservedBy: row.ReservedBy,
		ReleasedReason: row.ReleasedReason,
	}
}

// InsertIssue records a unit leaving the blood bank.
func (r CrossmatchRepo) InsertIssue(ctx context.Context,
	scope authctx.TenantScope, i domain.Issue) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	issueID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	componentID, err := uuid.Parse(i.ComponentID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(i.PatientID)
	if err != nil {
		return notFound()
	}
	reservationID, err := optionalUUID(i.ReservationID)
	if err != nil {
		return err
	}
	requestID, err := optionalUUID(i.RequestID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIssue(ctx, sqlcgen.InsertIssueParams{
		IssueID: issueID, TenantID: tenantID,
		ComponentID: componentID, ReservationID: reservationID,
		PatientID: patientID, RequestID: requestID,
		Destination:         i.Destination,
		Emergency:           i.Emergency,
		EmergencyAuthoriser: i.EmergencyAuthoriser,
		EmergencyReason:     i.EmergencyReason,
		IssuedAt:            stamp(i.IssuedAt), IssuedBy: i.IssuedBy,
		IssuedTo: i.IssuedTo, CheckedBy: i.CheckedBy,
	})
}

// Issue reads one issue.
func (r CrossmatchRepo) Issue(ctx context.Context, scope authctx.TenantScope,
	issueID string) (domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Issue{}, err
	}
	id, err := uuid.Parse(issueID)
	if err != nil {
		return domain.Issue{}, notFound()
	}

	row, err := r.queries(ctx).GetIssue(ctx, sqlcgen.GetIssueParams{
		TenantID: tenantID, IssueID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Issue{}, notFound()
	}
	if err != nil {
		return domain.Issue{}, err
	}
	return issueFrom(row), nil
}

// LatestIssue is what a bedside check verifies against.
func (r CrossmatchRepo) LatestIssue(ctx context.Context,
	scope authctx.TenantScope, componentID string) (domain.Issue, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Issue{}, false, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return domain.Issue{}, false, notFound()
	}

	row, err := r.queries(ctx).GetIssueForComponent(ctx,
		sqlcgen.GetIssueForComponentParams{TenantID: tenantID, ComponentID: id})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Issue{}, false, nil
	}
	if err != nil {
		return domain.Issue{}, false, err
	}
	return issueFrom(row), true, nil
}

// IssuesForComponent reads every issue of a unit, for the chain.
func (r CrossmatchRepo) IssuesForComponent(ctx context.Context,
	scope authctx.TenantScope, componentID string) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIssuesForComponent(ctx,
		sqlcgen.ListIssuesForComponentParams{TenantID: tenantID, ComponentID: id})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows), nil
}

// IssuesInPeriod reads the issues a utilisation report counts.
func (r CrossmatchRepo) IssuesInPeriod(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time, limit int32) (
	[]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListIssuesInPeriod(ctx,
		sqlcgen.ListIssuesInPeriodParams{
			TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows), nil
}

// Reconcile completes an emergency release's retrospective crossmatch.
func (r CrossmatchRepo) Reconcile(ctx context.Context, scope authctx.TenantScope,
	issueID, note, by string, at time.Time) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(issueID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).ReconcileIssue(ctx, sqlcgen.ReconcileIssueParams{
		TenantID: tenantID, IssueID: id,
		ReconciledAt: stamp(at), ReconciledBy: by, ReconcileNote: note,
	})
	if err != nil {
		return false, err
	}
	return rows == 1, nil
}

// Unreconciled reads the outstanding emergency releases.
func (r CrossmatchRepo) Unreconciled(ctx context.Context,
	scope authctx.TenantScope, limit int32) ([]domain.Issue, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListUnreconciledIssues(ctx,
		sqlcgen.ListUnreconciledIssuesParams{TenantID: tenantID, RowLimit: limit})
	if err != nil {
		return nil, err
	}
	return issuesFrom(rows), nil
}

func issuesFrom(rows []sqlcgen.BloodbankIssue) []domain.Issue {
	out := make([]domain.Issue, 0, len(rows))
	for _, row := range rows {
		out = append(out, issueFrom(row))
	}
	return out
}

func issueFrom(row sqlcgen.BloodbankIssue) domain.Issue {
	return domain.Issue{
		ID: row.IssueID.String(), TenantID: row.TenantID.String(),
		ComponentID:         row.ComponentID.String(),
		ReservationID:       uuidOrEmpty(row.ReservationID),
		PatientID:           row.PatientID.String(),
		RequestID:           uuidOrEmpty(row.RequestID),
		Destination:         row.Destination,
		Emergency:           row.Emergency,
		EmergencyAuthoriser: row.EmergencyAuthoriser,
		EmergencyReason:     row.EmergencyReason,
		Reconciled:          row.Reconciled,
		ReconciledAt:        timeOf(row.ReconciledAt),
		ReconciledBy:        row.ReconciledBy,
		ReconcileNote:       row.ReconcileNote,
		IssuedAt:            timeOf(row.IssuedAt), IssuedBy: row.IssuedBy,
		IssuedTo: row.IssuedTo, CheckedBy: row.CheckedBy,
	}
}
