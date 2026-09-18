package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// OpenRecord opens the intraoperative anaesthetic record (SRS-ANE-003).
//
// An imported record — one transcribed from paper after a downtime — needs its
// own permission, because it is backdated by construction (SRS-ANE-011).
func (s *Service) OpenRecord(ctx context.Context, in domain.NewRecordInput) (
	domain.Record, error) {

	permission := PermChart
	if in.Origin == domain.SourceImported {
		permission = PermImport
	}
	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.Record{}, err
	}
	now := s.clock.Now()

	patientID, encounterID, err := s.openCase(ctx, scope, in.CaseID,
		in.PatientID, in.EncounterID)
	if err != nil {
		return domain.Record{}, err
	}
	in.PatientID, in.EncounterID = patientID, encounterID

	record, err := domain.NewRecord(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Record{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// One record per case, which the database also holds. A second is not
		// a second anaesthetic; it is the same one charted twice, and the two
		// would disagree.
		if existing, ok, err := s.records.RecordForCase(
			ctx, scope, record.CaseID); err != nil {
			return err
		} else if ok {
			return rpcerr.FailedPrecondition("ANE_RECORD_EXISTS",
				"this case already has an anaesthetic record ("+existing.ID+")")
		}
		if err := s.records.InsertRecord(ctx, scope, record); err != nil {
			return err
		}

		eventType := EventRecordOpened
		if record.Origin == domain.SourceImported {
			eventType = EventRecordImported
		}
		if err := s.appendEvent(ctx, session, eventType, "anaesthesia_record",
			record.ID, map[string]any{
				"case_id":    record.CaseID,
				"patient_id": record.PatientID,
				"technique":  string(record.Technique),
				"origin":     string(record.Origin),
				"started_at": record.StartedAt,
			}, now); err != nil {
			return err
		}

		reason := "anaesthetic record opened"
		if record.Origin == domain.SourceImported {
			reason = "record transcribed from paper: " + record.ImportNote
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "anaesthesia_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Record{}, err
	}
	return record, nil
}

// Record returns one anaesthetic record.
func (s *Service) Record(ctx context.Context, recordID string) (
	domain.Record, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Record{}, err
	}
	return s.records.Record(ctx, scope, recordID)
}

// RecordForCase returns the anaesthetic record for an operation.
func (s *Service) RecordForCase(ctx context.Context, caseID string) (
	domain.Record, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Record{}, err
	}
	record, ok, err := s.records.RecordForCase(ctx, scope, caseID)
	if err != nil {
		return domain.Record{}, err
	}
	if !ok {
		return domain.Record{}, rpcerr.NotFound("ANE_NOT_FOUND",
			"this case has no anaesthetic record")
	}
	return record, nil
}

// ChartVital records one intraoperative value (SRS-ANE-003, SRS-ANE-005).
//
// A device value carries its device and the connection state at the moment of
// the reading. Nobody should trend a value taken while the monitor was
// detached, and the only way for anybody downstream to exclude it is for the
// state to be on the row.
func (s *Service) ChartVital(ctx context.Context, in domain.NewVitalInput) (
	domain.VitalEntry, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.VitalEntry{}, err
	}
	now := s.clock.Now()

	if _, err := s.openRecord(ctx, scope, in.RecordID); err != nil {
		return domain.VitalEntry{}, err
	}

	entry, err := domain.RecordVital(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.VitalEntry{}, anaesthesiaError(err)
	}
	if err := s.records.InsertVital(ctx, scope, entry); err != nil {
		return domain.VitalEntry{}, err
	}
	return entry, nil
}

// Vitals reads the intraoperative chart. An empty code returns every series.
func (s *Service) Vitals(ctx context.Context, recordID, code string) (
	[]domain.VitalEntry, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.records.Vitals(ctx, scope, recordID, code)
}

// ChartDrug documents a drug given during a case (SRS-ANE-004).
//
// The unit check is the domain's: a dose in a unit family the formulary does
// not dose in is refused unless the anaesthetist says explicitly that they
// meant it, and the record keeps that they said so.
func (s *Service) ChartDrug(ctx context.Context, in domain.NewDrugInput) (
	domain.DrugEntry, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.DrugEntry{}, err
	}
	now := s.clock.Now()

	if _, err := s.openRecord(ctx, scope, in.RecordID); err != nil {
		return domain.DrugEntry{}, err
	}

	entry, err := domain.RecordDrug(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.DrugEntry{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.records.InsertDrug(ctx, scope, entry); err != nil {
			return err
		}
		if !in.AcknowledgedMismatch {
			return nil
		}
		// An acknowledged unit mismatch is the one drug entry worth an audit
		// row of its own: it is a deliberate departure from how the formulary
		// doses the drug, and a review would otherwise have to infer it.
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermChart,
			ResourceType: "anaesthesia_drug", ResourceID: entry.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "unit mismatch acknowledged: " + entry.DrugCode +
				" charted in " + entry.DoseUnit +
				", formulary doses in " + in.ExpectedUnit,
		}, now)
	})
	if err != nil {
		return domain.DrugEntry{}, err
	}
	return entry, nil
}

// Drugs reads the drug chart.
func (s *Service) Drugs(ctx context.Context, recordID string) (
	[]domain.DrugEntry, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.records.Drugs(ctx, scope, recordID)
}

// StopInfusion records the time a running infusion was stopped.
func (s *Service) StopInfusion(ctx context.Context, drugID string,
	at time.Time) error {

	_, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return err
	}
	if at.IsZero() {
		at = s.clock.Now()
	}

	stopped, err := s.records.StopInfusion(ctx, scope, drugID, at)
	if err != nil {
		return err
	}
	if !stopped {
		// Already stopped, which is ordinary at the end of a case: two people
		// reach for the pump. The first stop time is the true one, so this
		// says so rather than moving it.
		return rpcerr.FailedPrecondition("ANE_INFUSION_STOPPED",
			"this infusion was already stopped")
	}
	return nil
}

// RecordAirway records one airway attempt (SRS-ANE-006).
//
// An attempt that makes the airway difficult publishes an event. The next
// anaesthetist needs it and is frequently not in this system, which is how a
// difficult airway gets discovered twice.
func (s *Service) RecordAirway(ctx context.Context, in domain.NewAirwayInput) (
	domain.AirwayEvent, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.AirwayEvent{}, err
	}
	now := s.clock.Now()

	record, err := s.openRecord(ctx, scope, in.RecordID)
	if err != nil {
		return domain.AirwayEvent{}, err
	}

	event, err := domain.RecordAirway(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.AirwayEvent{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.records.InsertAirwayEvent(ctx, scope, event); err != nil {
			return err
		}

		all, err := s.records.AirwayEvents(ctx, scope, record.ID)
		if err != nil {
			return err
		}
		summary := domain.SummariseAirway(all)
		if !summary.Difficult {
			return nil
		}
		return s.appendEvent(ctx, session, EventDifficultAirway,
			"anaesthesia_record", record.ID, map[string]any{
				"patient_id":    record.PatientID,
				"case_id":       record.CaseID,
				"attempts":      summary.Attempts,
				"final_device":  summary.FinalDevice,
				"reasons":       summary.Reasons,
				"complications": summary.Complications,
			}, now)
	})
	if err != nil {
		return domain.AirwayEvent{}, err
	}
	return event, nil
}

// Airway summarises one record's airway management (SRS-ANE-006).
func (s *Service) Airway(ctx context.Context, recordID string) (
	domain.DifficultAirway, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.DifficultAirway{}, err
	}
	events, err := s.records.AirwayEvents(ctx, scope, recordID)
	if err != nil {
		return domain.DifficultAirway{}, err
	}
	return domain.SummariseAirway(events), nil
}

// PatientAirway summarises a patient's airway history across admissions
// (SRS-ANE-006).
//
// The read the next anaesthetist makes, and the one this whole record exists
// for. Its own permission, because it reaches back through operations outside
// the admission in front of the caller.
func (s *Service) PatientAirway(ctx context.Context, patientID string,
	limit int32) (domain.DifficultAirway, error) {

	session, scope, err := s.authorize(ctx, PermHistory)
	if err != nil {
		return domain.DifficultAirway{}, err
	}
	now := s.clock.Now()

	events, err := s.records.PatientAirwayEvents(
		ctx, scope, patientID, clampPageSize(limit))
	if err != nil {
		return domain.DifficultAirway{}, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermHistory,
		ResourceType: "patient", ResourceID: patientID,
		Outcome: audit.OutcomeSuccess,
		Reason:  "airway history read across admissions",
	}, now); err != nil {
		return domain.DifficultAirway{}, err
	}
	return domain.SummariseAirway(events), nil
}

// ChartFluid records one fluid in or out (SRS-ANE-007).
func (s *Service) ChartFluid(ctx context.Context, in domain.NewFluidInput) (
	domain.FluidEntry, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.FluidEntry{}, err
	}
	now := s.clock.Now()

	if _, err := s.openRecord(ctx, scope, in.RecordID); err != nil {
		return domain.FluidEntry{}, err
	}

	entry, err := domain.RecordFluid(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.FluidEntry{}, anaesthesiaError(err)
	}
	if err := s.records.InsertFluid(ctx, scope, entry); err != nil {
		return domain.FluidEntry{}, err
	}
	return entry, nil
}

// Balance is the running fluid balance for a record (SRS-ANE-007).
func (s *Service) Balance(ctx context.Context, recordID string) (
	domain.FluidBalance, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.FluidBalance{}, err
	}
	entries, err := s.records.Fluids(ctx, scope, recordID)
	if err != nil {
		return domain.FluidBalance{}, err
	}
	return domain.Balance(entries), nil
}

// EndAnaesthesia closes the anaesthetic and moves the record into recovery.
//
// Not the same moment as the end of the operation: emergence takes time and it
// is the anaesthetist's.
func (s *Service) EndAnaesthesia(ctx context.Context, recordID string,
	at time.Time) (domain.Record, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.Record{}, err
	}
	now := s.clock.Now()
	if at.IsZero() {
		at = now
	}

	record, err := s.openRecord(ctx, scope, recordID)
	if err != nil {
		return domain.Record{}, err
	}
	if err := record.End(at); err != nil {
		return domain.Record{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.records.UpdateStatus(
			ctx, scope, record.ID, record.Status, record.EndedAt); err != nil {
			return err
		}
		duration, _ := record.Duration()
		if err := s.appendEvent(ctx, session, EventAnaesthesiaEnded,
			"anaesthesia_record", record.ID, map[string]any{
				"case_id":          record.CaseID,
				"patient_id":       record.PatientID,
				"ended_at":         record.EndedAt,
				"duration_seconds": int64(duration / time.Second),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermChart,
			ResourceType: "anaesthesia_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess, Reason: "anaesthetic ended",
		}, now)
	})
	if err != nil {
		return domain.Record{}, err
	}
	return record, nil
}

// HandOver records the theatre-to-recovery handover (SRS-ANE-008).
//
// Recovery cannot discharge a patient nobody handed over, so this is the step
// that unlocks the rest: the analgesia already given, what to watch, and who
// gave it.
func (s *Service) HandOver(ctx context.Context, in domain.NewHandoverInput) (
	domain.Handover, error) {

	session, scope, err := s.authorize(ctx, PermChart)
	if err != nil {
		return domain.Handover{}, err
	}
	now := s.clock.Now()

	record, err := s.openRecord(ctx, scope, in.RecordID)
	if err != nil {
		return domain.Handover{}, err
	}

	handover, err := domain.HandOver(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Handover{}, anaesthesiaError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.records.InsertHandover(ctx, scope, handover); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventHandedOver,
			"anaesthesia_record", record.ID, map[string]any{
				"case_id":        record.CaseID,
				"patient_id":     record.PatientID,
				"to_clinician":   handover.ToClinician,
				"handed_over_at": handover.HandedOverAt,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermChart,
			ResourceType: "anaesthesia_handover", ResourceID: handover.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "handed over to " + handover.ToClinician,
		}, now)
	})
	if err != nil {
		return domain.Handover{}, err
	}
	return handover, nil
}

// Handovers reads a record's handovers.
func (s *Service) Handovers(ctx context.Context, recordID string) (
	[]domain.Handover, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.records.Handovers(ctx, scope, recordID)
}

// AirwayEvents reads one record's airway attempts, in order.
func (s *Service) AirwayEvents(ctx context.Context, recordID string) (
	[]domain.AirwayEvent, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.records.AirwayEvents(ctx, scope, recordID)
}

// Fluids reads the fluid chart behind the balance.
func (s *Service) Fluids(ctx context.Context, recordID string) (
	[]domain.FluidEntry, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.records.Fluids(ctx, scope, recordID)
}
