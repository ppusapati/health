package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ------------------------------------------------- requests (SRS-AMB-001)

var _ ports.RequestRepository = (*Repository)(nil)

func requestFrom(row sqlcgen.AmbulanceRequest) domain.Request {
	return domain.Request{
		ID: row.RequestID.String(), TenantID: row.TenantID.String(),
		Kind:        domain.RequestKind(row.Kind),
		Priority:    domain.Priority(row.Priority),
		PatientID:   uuidString(row.PatientID),
		EncounterID: uuidString(row.EncounterID),
		OriginName:  row.OriginName, OriginAddress: row.OriginAddress,
		OriginFacilityID:      uuidString(row.OriginFacilityID),
		DestinationName:       row.DestinationName,
		DestinationAddress:    row.DestinationAddress,
		DestinationFacilityID: uuidString(row.DestinationFacilityID),
		ClinicalNeed:          row.ClinicalNeed,
		RequiredCapabilities:  row.RequiredCapabilities,
		State:                 domain.RequestState(row.State),
		TripID:                uuidString(row.TripID),
		CancelReason:          row.CancelReason,
		CancelledBy:           row.CancelledBy,
		CancelledAt:           timeOf(row.CancelledAt),
		RequestedAt:           timeOf(row.RequestedAt),
		RequestedBy:           row.RequestedBy, Version: row.Version,
	}
}

// InsertRequest implements ports.RequestRepository.
func (r *Repository) InsertRequest(ctx context.Context,
	scope authctx.TenantScope, req domain.Request) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(req.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertAmbulanceRequest(ctx,
		sqlcgen.InsertAmbulanceRequestParams{
			RequestID: id, TenantID: tenantID,
			Kind: string(req.Kind), Priority: string(req.Priority),
			PatientID:   optionalUUID(req.PatientID),
			EncounterID: optionalUUID(req.EncounterID),
			OriginName:  req.OriginName, OriginAddress: req.OriginAddress,
			OriginFacilityID:      optionalUUID(req.OriginFacilityID),
			DestinationName:       req.DestinationName,
			DestinationAddress:    req.DestinationAddress,
			DestinationFacilityID: optionalUUID(req.DestinationFacilityID),
			ClinicalNeed:          req.ClinicalNeed,
			RequiredCapabilities:  texts(req.RequiredCapabilities),
			State:                 string(req.State),
			TripID:                optionalUUID(req.TripID),
			CancelReason:          req.CancelReason,
			CancelledBy:           req.CancelledBy,
			CancelledAt:           stamp(req.CancelledAt),
			RequestedAt:           stamp(req.RequestedAt),
			RequestedBy:           req.RequestedBy, Version: req.Version,
		})
}

// Request implements ports.RequestRepository.
func (r *Repository) Request(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Request, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Request{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Request{}, notFound()
	}

	row, err := r.queries(ctx).GetAmbulanceRequest(ctx,
		sqlcgen.GetAmbulanceRequestParams{TenantID: tenantID,
			RequestID: parsed})
	if isNoRows(err) {
		return domain.Request{}, notFound()
	}
	if err != nil {
		return domain.Request{}, err
	}
	return requestFrom(row), nil
}

// UpdateRequest implements ports.RequestRepository.
func (r *Repository) UpdateRequest(ctx context.Context,
	scope authctx.TenantScope, req domain.Request,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(req.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateAmbulanceRequestState(ctx,
		sqlcgen.UpdateAmbulanceRequestStateParams{
			TenantID: tenantID, RequestID: id, State: string(req.State),
			TripID:       optionalUUID(req.TripID),
			CancelReason: req.CancelReason, CancelledBy: req.CancelledBy,
			CancelledAt:     stamp(req.CancelledAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Requests implements ports.RequestRepository.
func (r *Repository) Requests(ctx context.Context,
	scope authctx.TenantScope, f ports.RequestFilter) (
	[]domain.Request, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}
	priorities := make([]string, 0, len(f.Priorities))
	for _, p := range f.Priorities {
		priorities = append(priorities, string(p))
	}
	kinds := make([]string, 0, len(f.Kinds))
	for _, k := range f.Kinds {
		kinds = append(kinds, string(k))
	}

	rows, err := r.queries(ctx).ListAmbulanceRequests(ctx,
		sqlcgen.ListAmbulanceRequestsParams{
			TenantID: tenantID, States: texts(states),
			Priorities: texts(priorities), Kinds: texts(kinds),
			FacilityID: f.FacilityID,
			PatientID:  f.PatientID,
			WindowFrom: stamp(from), WindowTo: stamp(to),
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Request, 0, len(rows))
	for _, row := range rows {
		out = append(out, requestFrom(row))
	}
	return out, nil
}

// ---------------------------------------------------- trips (SRS-AMB-003)

var _ ports.TripRepository = (*Repository)(nil)

func tripFrom(row sqlcgen.AmbulanceTrip,
	milestones []sqlcgen.AmbulanceTripMilestone) domain.Trip {

	out := domain.Trip{
		ID: row.TripID.String(), TenantID: row.TenantID.String(),
		RequestID:      row.RequestID.String(),
		VehicleID:      row.VehicleID.String(),
		ShiftID:        row.ShiftID.String(),
		FacilityID:     uuidString(row.FacilityID),
		CrewSubjects:   row.CrewSubjects,
		OverrideBy:     row.OverrideBy,
		OverrideReason: row.OverrideReason,
		State:          domain.TripState(row.State),
		AbortReason:    row.AbortReason,
		StartedAt:      timeOf(row.StartedAt),
		StartedBy:      row.StartedBy,
		EndedAt:        timeOf(row.EndedAt), Version: row.Version,
	}
	for _, record := range milestones {
		if record.TripID != row.TripID {
			continue
		}
		out.Milestones = append(out.Milestones, domain.MilestoneRecord{
			Milestone: domain.Milestone(record.Milestone),
			At:        timeOf(record.OccurredAt),
			By:        record.RecordedBy, Note: record.Note,
			AmendsAt:    timeOf(record.AmendsAt),
			AmendReason: record.AmendReason,
			AmendedAt:   timeOf(record.AmendedAt),
		})
	}
	return out
}

// InsertTrip implements ports.TripRepository.
//
// The denormalised priority, vehicle kind and shift vehicle are what the
// composite foreign keys and the emergency-vehicle CHECK hang off: see the
// note at the head of migration 0044.
func (r *Repository) InsertTrip(ctx context.Context,
	scope authctx.TenantScope, t domain.Trip) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	requestID, err := uuid.Parse(t.RequestID)
	if err != nil {
		return notFound()
	}
	vehicleID, err := uuid.Parse(t.VehicleID)
	if err != nil {
		return notFound()
	}
	shiftID, err := uuid.Parse(t.ShiftID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	// Read back rather than trusting the caller: the values the keys are
	// checked against come from the rows they point at.
	request, err := q.GetAmbulanceRequest(ctx,
		sqlcgen.GetAmbulanceRequestParams{TenantID: tenantID,
			RequestID: requestID})
	if isNoRows(err) {
		return notFound()
	}
	if err != nil {
		return err
	}
	vehicle, err := q.GetVehicle(ctx, sqlcgen.GetVehicleParams{
		TenantID: tenantID, VehicleID: vehicleID})
	if isNoRows(err) {
		return notFound()
	}
	if err != nil {
		return err
	}

	if err := q.InsertTrip(ctx, sqlcgen.InsertTripParams{
		TripID: id, TenantID: tenantID, RequestID: requestID,
		VehicleID: vehicleID, ShiftID: shiftID,
		FacilityID: optionalUUID(t.FacilityID),
		Priority:   request.Priority, VehicleKind: vehicle.Kind,
		ShiftVehicleID: vehicleID,
		CrewSubjects:   texts(t.CrewSubjects),
		OverrideBy:     t.OverrideBy, OverrideReason: t.OverrideReason,
		State: string(t.State), AbortReason: t.AbortReason,
		StartedAt: stamp(t.StartedAt), StartedBy: t.StartedBy,
		EndedAt: stamp(t.EndedAt), Version: t.Version,
	}); err != nil {
		return err
	}

	for _, record := range t.Milestones {
		if err := r.AppendMilestone(ctx, scope, uuid.NewString(), t.ID,
			record); err != nil {
			return err
		}
	}
	return nil
}

// Trip implements ports.TripRepository.
func (r *Repository) Trip(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Trip, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Trip{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.Trip{}, notFound()
	}

	row, err := r.queries(ctx).GetTrip(ctx, sqlcgen.GetTripParams{
		TenantID: tenantID, TripID: parsed})
	if isNoRows(err) {
		return domain.Trip{}, notFound()
	}
	if err != nil {
		return domain.Trip{}, err
	}
	return r.tripWith(ctx, tenantID, row)
}

// TripForRequest implements ports.TripRepository.
func (r *Repository) TripForRequest(ctx context.Context,
	scope authctx.TenantScope, requestID string) (domain.Trip, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Trip{}, err
	}
	parsed, err := uuid.Parse(requestID)
	if err != nil {
		return domain.Trip{}, notFound()
	}

	row, err := r.queries(ctx).GetTripForRequest(ctx,
		sqlcgen.GetTripForRequestParams{TenantID: tenantID,
			RequestID: parsed})
	if isNoRows(err) {
		return domain.Trip{}, notFound()
	}
	if err != nil {
		return domain.Trip{}, err
	}
	return r.tripWith(ctx, tenantID, row)
}

func (r *Repository) tripWith(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.AmbulanceTrip) (domain.Trip, error) {

	milestones, err := r.queries(ctx).ListTripMilestones(ctx,
		sqlcgen.ListTripMilestonesParams{TenantID: tenantID,
			TripIds: []uuid.UUID{row.TripID}})
	if err != nil {
		return domain.Trip{}, err
	}
	return tripFrom(row, milestones), nil
}

// UpdateTrip implements ports.TripRepository.
func (r *Repository) UpdateTrip(ctx context.Context,
	scope authctx.TenantScope, t domain.Trip, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateTripState(ctx,
		sqlcgen.UpdateTripStateParams{
			TenantID: tenantID, TripID: id, State: string(t.State),
			AbortReason: t.AbortReason, EndedAt: stamp(t.EndedAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// AppendMilestone implements ports.TripRepository.
//
// An insert, always. A correction carries AmendsAt and lands beside what it
// corrected; the table takes no UPDATE and no DELETE (FIT-08).
func (r *Repository) AppendMilestone(ctx context.Context,
	scope authctx.TenantScope, id, tripID string,
	record domain.MilestoneRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	milestoneID, err := uuid.Parse(id)
	if err != nil {
		return notFound()
	}
	parsedTrip, err := uuid.Parse(tripID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertTripMilestone(ctx,
		sqlcgen.InsertTripMilestoneParams{
			MilestoneID: milestoneID, TenantID: tenantID,
			TripID: parsedTrip, Milestone: string(record.Milestone),
			OccurredAt: stamp(record.At), RecordedBy: record.By,
			Note: record.Note, AmendsAt: stamp(record.AmendsAt),
			AmendReason: record.AmendReason,
			AmendedAt:   stamp(record.AmendedAt),
		})
}

// Trips implements ports.TripRepository.
func (r *Repository) Trips(ctx context.Context, scope authctx.TenantScope,
	f ports.TripFilter) ([]domain.Trip, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}

	q := r.queries(ctx)
	rows, err := q.ListTrips(ctx, sqlcgen.ListTripsParams{
		TenantID: tenantID, States: texts(states),
		VehicleID:  f.VehicleID,
		FacilityID: f.FacilityID,
		WindowFrom: stamp(from), WindowTo: stamp(to),
		RowLimit: limit, RowOffset: offset,
	})
	if err != nil {
		return nil, err
	}
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		ids = append(ids, row.TripID)
	}
	var milestones []sqlcgen.AmbulanceTripMilestone
	if len(ids) > 0 {
		milestones, err = q.ListTripMilestones(ctx,
			sqlcgen.ListTripMilestonesParams{TenantID: tenantID,
				TripIds: ids})
		if err != nil {
			return nil, err
		}
	}
	out := make([]domain.Trip, 0, len(rows))
	for _, row := range rows {
		out = append(out, tripFrom(row, milestones))
	}
	return out, nil
}

// --------------------------------------- prehospital (SRS-AMB-004 and 007)

var _ ports.PrehospitalRepository = (*Repository)(nil)

func recordFrom(row sqlcgen.AmbulancePrehospitalRecord,
	entries []sqlcgen.AmbulancePrehospitalEntry,
	documents []sqlcgen.AmbulancePrehospitalDocument,
) domain.PrehospitalRecord {

	out := domain.PrehospitalRecord{
		ID: row.RecordID.String(), TenantID: row.TenantID.String(),
		TripID:              row.TripID.String(),
		RequestID:           uuidString(row.RequestID),
		PatientID:           uuidString(row.PatientID),
		EncounterID:         uuidString(row.EncounterID),
		FacilityID:          uuidString(row.FacilityID),
		PresentingComplaint: row.PresentingComplaint,
		Impression:          row.Impression,
		State:               domain.HandoverState(row.State),
		SendingSummary:      row.SendingSummary,
		GivenBy:             row.GivenBy,
		GivenRole:           domain.CrewRole(row.GivenRole),
		GivenAt:             timeOf(row.GivenAt),
		AcceptedBy:          row.AcceptedBy,
		AcceptedAt:          timeOf(row.AcceptedAt),
		AcceptedNote:        row.AcceptedNote,
		CreatedAt:           timeOf(row.CreatedAt),
		CreatedBy:           row.CreatedBy, Version: row.Version,
	}
	for _, entry := range entries {
		if entry.RecordID != row.RecordID {
			continue
		}
		out.Entries = append(out.Entries, domain.Entry{
			ID:   entry.EntryID.String(),
			Kind: domain.EntryKind(entry.Kind),
			Code: entry.Code, Label: entry.Label,
			Value: entry.Value, Unit: entry.Unit,
			DoseAmount: int(entry.DoseAmount), DoseUnit: entry.DoseUnit,
			Route: entry.Route, Narrative: entry.Narrative,
			RecordedBy:   entry.RecordedBy,
			RecordedRole: domain.CrewRole(entry.RecordedRole),
			RecordedAt:   timeOf(entry.RecordedAt),
			EnteredAt:    timeOf(entry.EnteredAt),
		})
	}
	for _, document := range documents {
		if document.RecordID != row.RecordID {
			continue
		}
		out.DocumentRefs = append(out.DocumentRefs, document.DocumentRef)
	}
	return out
}

// InsertRecord implements ports.PrehospitalRepository.
func (r *Repository) InsertRecord(ctx context.Context,
	scope authctx.TenantScope, rec domain.PrehospitalRecord) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(rec.ID)
	if err != nil {
		return notFound()
	}
	tripID, err := uuid.Parse(rec.TripID)
	if err != nil {
		return notFound()
	}

	q := r.queries(ctx)
	if err := q.InsertPrehospitalRecord(ctx,
		sqlcgen.InsertPrehospitalRecordParams{
			RecordID: id, TenantID: tenantID, TripID: tripID,
			RequestID:           optionalUUID(rec.RequestID),
			PatientID:           optionalUUID(rec.PatientID),
			EncounterID:         optionalUUID(rec.EncounterID),
			FacilityID:          optionalUUID(rec.FacilityID),
			PresentingComplaint: rec.PresentingComplaint,
			Impression:          rec.Impression,
			State:               string(rec.State),
			SendingSummary:      rec.SendingSummary,
			GivenBy:             rec.GivenBy,
			GivenRole:           string(rec.GivenRole),
			GivenAt:             stamp(rec.GivenAt),
			AcceptedBy:          rec.AcceptedBy,
			AcceptedAt:          stamp(rec.AcceptedAt),
			AcceptedNote:        rec.AcceptedNote,
			CreatedAt:           stamp(rec.CreatedAt),
			CreatedBy:           rec.CreatedBy, Version: rec.Version,
		}); err != nil {
		return err
	}
	for _, ref := range rec.DocumentRefs {
		if err := q.InsertPrehospitalDocument(ctx,
			sqlcgen.InsertPrehospitalDocumentParams{
				RecordID: id, DocumentRef: ref,
				AttachedAt: stamp(rec.CreatedAt),
			}); err != nil {
			return err
		}
	}
	return nil
}

// Record implements ports.PrehospitalRepository.
func (r *Repository) Record(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.PrehospitalRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.PrehospitalRecord{}, notFound()
	}

	row, err := r.queries(ctx).GetPrehospitalRecord(ctx,
		sqlcgen.GetPrehospitalRecordParams{TenantID: tenantID,
			RecordID: parsed})
	if isNoRows(err) {
		return domain.PrehospitalRecord{}, notFound()
	}
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return r.recordWith(ctx, tenantID, row)
}

// RecordForTrip implements ports.PrehospitalRepository.
func (r *Repository) RecordForTrip(ctx context.Context,
	scope authctx.TenantScope, tripID string) (
	domain.PrehospitalRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	parsed, err := uuid.Parse(tripID)
	if err != nil {
		return domain.PrehospitalRecord{}, notFound()
	}

	row, err := r.queries(ctx).GetPrehospitalRecordForTrip(ctx,
		sqlcgen.GetPrehospitalRecordForTripParams{TenantID: tenantID,
			TripID: parsed})
	if isNoRows(err) {
		return domain.PrehospitalRecord{}, notFound()
	}
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return r.recordWith(ctx, tenantID, row)
}

func (r *Repository) recordWith(ctx context.Context, tenantID uuid.UUID,
	row sqlcgen.AmbulancePrehospitalRecord) (
	domain.PrehospitalRecord, error) {

	q := r.queries(ctx)
	entries, err := q.ListPrehospitalEntries(ctx,
		sqlcgen.ListPrehospitalEntriesParams{TenantID: tenantID,
			RecordIds: []uuid.UUID{row.RecordID}})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	documents, err := q.ListPrehospitalDocuments(ctx,
		[]uuid.UUID{row.RecordID})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return recordFrom(row, entries, documents), nil
}

// UpdateRecord implements ports.PrehospitalRepository.
func (r *Repository) UpdateRecord(ctx context.Context,
	scope authctx.TenantScope, rec domain.PrehospitalRecord,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(rec.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdatePrehospitalRecord(ctx,
		sqlcgen.UpdatePrehospitalRecordParams{
			TenantID: tenantID, RecordID: id,
			Impression: rec.Impression, State: string(rec.State),
			SendingSummary: rec.SendingSummary, GivenBy: rec.GivenBy,
			GivenRole: string(rec.GivenRole), GivenAt: stamp(rec.GivenAt),
			AcceptedBy: rec.AcceptedBy, AcceptedAt: stamp(rec.AcceptedAt),
			AcceptedNote:    rec.AcceptedNote,
			EncounterID:     optionalUUID(rec.EncounterID),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// AppendEntry implements ports.PrehospitalRepository.
func (r *Repository) AppendEntry(ctx context.Context,
	scope authctx.TenantScope, recordID string, e domain.Entry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	parsedRecord, err := uuid.Parse(recordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPrehospitalEntry(ctx,
		sqlcgen.InsertPrehospitalEntryParams{
			EntryID: id, TenantID: tenantID, RecordID: parsedRecord,
			Kind: string(e.Kind), Code: e.Code, Label: e.Label,
			Value: e.Value, Unit: e.Unit,
			DoseAmount: int32(e.DoseAmount), DoseUnit: e.DoseUnit,
			Route: e.Route, Narrative: e.Narrative,
			RecordedBy: e.RecordedBy, RecordedRole: string(e.RecordedRole),
			RecordedAt: stamp(e.RecordedAt), EnteredAt: stamp(e.EnteredAt),
		})
}

// AttachDocument implements ports.PrehospitalRepository.
func (r *Repository) AttachDocument(ctx context.Context,
	scope authctx.TenantScope, recordID, documentRef string,
	at time.Time) error {

	if _, err := scopeTenantID(scope); err != nil {
		return err
	}
	parsed, err := uuid.Parse(recordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPrehospitalDocument(ctx,
		sqlcgen.InsertPrehospitalDocumentParams{
			RecordID: parsed, DocumentRef: documentRef,
			AttachedAt: stamp(at),
		})
}

// Records implements ports.PrehospitalRepository.
func (r *Repository) Records(ctx context.Context, scope authctx.TenantScope,
	f ports.RecordFilter) ([]domain.PrehospitalRecord, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	states := make([]string, 0, len(f.States))
	for _, s := range f.States {
		states = append(states, string(s))
	}

	q := r.queries(ctx)
	rows, err := q.ListPrehospitalRecords(ctx,
		sqlcgen.ListPrehospitalRecordsParams{
			TenantID: tenantID, States: texts(states),
			FacilityID: f.FacilityID,
			PatientID:  f.PatientID,
			WindowFrom: stamp(from), WindowTo: stamp(to),
			RowLimit: limit, RowOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	ids := make([]uuid.UUID, 0, len(rows))
	for _, row := range rows {
		ids = append(ids, row.RecordID)
	}
	var entries []sqlcgen.AmbulancePrehospitalEntry
	var documents []sqlcgen.AmbulancePrehospitalDocument
	if len(ids) > 0 {
		entries, err = q.ListPrehospitalEntries(ctx,
			sqlcgen.ListPrehospitalEntriesParams{TenantID: tenantID,
				RecordIds: ids})
		if err != nil {
			return nil, err
		}
		documents, err = q.ListPrehospitalDocuments(ctx, ids)
		if err != nil {
			return nil, err
		}
	}
	out := make([]domain.PrehospitalRecord, 0, len(rows))
	for _, row := range rows {
		out = append(out, recordFrom(row, entries, documents))
	}
	return out, nil
}

// ------------------------------------------------- location (SRS-AMB-005)

var _ ports.LocationRepository = (*Repository)(nil)

func pingFrom(row sqlcgen.AmbulanceLocationPing) domain.Ping {
	return domain.Ping{
		ID: row.PingID.String(), TenantID: row.TenantID.String(),
		VehicleID:      row.VehicleID.String(),
		TripID:         uuidString(row.TripID),
		LatitudeMicro:  int(row.LatitudeMicro),
		LongitudeMicro: int(row.LongitudeMicro),
		SpeedKph:       int(row.SpeedKph),
		HeadingDegrees: int(row.HeadingDegrees),
		AccuracyMetres: int(row.AccuracyMetres),
		Source:         row.Source,
		At:             timeOf(row.OccurredAt),
		RetainUntil:    timeOf(row.RetainUntil),
	}
}

// InsertPing implements ports.LocationRepository.
func (r *Repository) InsertPing(ctx context.Context,
	scope authctx.TenantScope, p domain.Ping) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	vehicleID, err := uuid.Parse(p.VehicleID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertLocationPing(ctx,
		sqlcgen.InsertLocationPingParams{
			PingID: id, TenantID: tenantID, VehicleID: vehicleID,
			TripID:         optionalUUID(p.TripID),
			LatitudeMicro:  int32(p.LatitudeMicro),
			LongitudeMicro: int32(p.LongitudeMicro),
			SpeedKph:       int32(p.SpeedKph),
			HeadingDegrees: int32(p.HeadingDegrees),
			AccuracyMetres: int32(p.AccuracyMetres),
			Source:         p.Source, OccurredAt: stamp(p.At),
			RetainUntil: stamp(p.RetainUntil),
		})
}

// Pings implements ports.LocationRepository.
//
// AsOf is not optional: the query drops anything past its own horizon, so a
// trail does not come back because the purge job is behind.
func (r *Repository) Pings(ctx context.Context, scope authctx.TenantScope,
	f ports.PingFilter) ([]domain.Ping, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, _ := page(f.Limit, 0)

	rows, err := r.queries(ctx).ListLocationPings(ctx,
		sqlcgen.ListLocationPingsParams{
			TenantID: tenantID, VehicleID: f.VehicleID,
			TripID:     f.TripID,
			WindowFrom: stamp(from), WindowTo: stamp(to),
			AsOf: stamp(f.AsOf), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Ping, 0, len(rows))
	for _, row := range rows {
		out = append(out, pingFrom(row))
	}
	return out, nil
}

// LatestPing implements ports.LocationRepository.
func (r *Repository) LatestPing(ctx context.Context,
	scope authctx.TenantScope, vehicleID string, asOf time.Time) (
	domain.Ping, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Ping{}, err
	}
	parsed, err := uuid.Parse(vehicleID)
	if err != nil {
		return domain.Ping{}, notFound()
	}

	row, err := r.queries(ctx).LatestLocationPing(ctx,
		sqlcgen.LatestLocationPingParams{TenantID: tenantID,
			VehicleID: parsed, AsOf: stamp(asOf)})
	if isNoRows(err) {
		return domain.Ping{}, notFound()
	}
	if err != nil {
		return domain.Ping{}, err
	}
	return pingFrom(row), nil
}

// PurgeExpired implements ports.LocationRepository.
func (r *Repository) PurgeExpired(ctx context.Context,
	scope authctx.TenantScope, asOf time.Time) (int64, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	return r.queries(ctx).PurgeExpiredLocationPings(ctx,
		sqlcgen.PurgeExpiredLocationPingsParams{TenantID: tenantID,
			AsOf: stamp(asOf)})
}

// InsertETA implements ports.LocationRepository.
func (r *Repository) InsertETA(ctx context.Context,
	scope authctx.TenantScope, id string, e domain.ETA) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return notFound()
	}
	vehicleID, err := uuid.Parse(e.VehicleID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertETA(ctx, sqlcgen.InsertETAParams{
		EtaID: parsed, TenantID: tenantID, VehicleID: vehicleID,
		TripID: optionalUUID(e.TripID), Seconds: int32(e.Seconds),
		DistanceMetres: int32(e.DistanceMetres), Source: e.Source,
		OccurredAt: stamp(e.At),
	})
}

// LatestETA implements ports.LocationRepository.
func (r *Repository) LatestETA(ctx context.Context,
	scope authctx.TenantScope, tripID string) (domain.ETA, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ETA{}, err
	}
	parsed, err := uuid.Parse(tripID)
	if err != nil {
		return domain.ETA{}, notFound()
	}

	row, err := r.queries(ctx).LatestETA(ctx, sqlcgen.LatestETAParams{
		TenantID: tenantID, TripID: optionalUUID(parsed.String())})
	if isNoRows(err) {
		// No provider, or none yet for this trip. An absent estimate,
		// which is a different thing from an estimate of zero: a
		// dispatcher holding a bed against "arriving now" would be acting
		// on a number nobody produced.
		return domain.ETA{}, nil
	}
	if err != nil {
		return domain.ETA{}, err
	}
	return domain.ETA{
		VehicleID: row.VehicleID.String(), TripID: uuidString(row.TripID),
		Seconds: int(row.Seconds), DistanceMetres: int(row.DistanceMetres),
		Source: row.Source, At: timeOf(row.OccurredAt), Known: true,
	}, nil
}
