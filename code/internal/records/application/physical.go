package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// NewPhysicalRecordInput registers a paper volume (SRS-MRD-006).
type NewPhysicalRecordInput struct {
	Reference    string
	PatientID    string
	Volume       int
	RecordClass  string
	Jurisdiction string
	Description  string
	HomeLocation string
}

// RegisterPhysicalRecord records a paper volume the hospital holds
// (SRS-MRD-006).
func (s *Service) RegisterPhysicalRecord(ctx context.Context,
	in NewPhysicalRecordInput) (domain.PhysicalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPhysicalManage)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	now := s.clock.Now()

	record, err := domain.RegisterPhysicalRecord(s.ids.NewID(),
		session.TenantID, domain.NewPhysicalRecordInput{
			Reference: in.Reference, PatientID: in.PatientID,
			Volume: in.Volume, RecordClass: in.RecordClass,
			Jurisdiction: in.Jurisdiction, Description: in.Description,
			HomeLocation: in.HomeLocation,
		}, session.SubjectID, now)
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.physical.InsertPhysicalRecord(ctx, scope,
			record); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.physical.registered",
			ResourceType: "mrd_physical_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"reference": record.Reference,
				"volume":    itoa(record.Volume),
				"home":      record.HomeLocation,
			}),
			Reason: "registered a paper record",
		}, now)
	})
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}
	return record, nil
}

// CheckOutRecord sends a paper volume somewhere with one named custodian
// (SRS-MRD-006).
//
// One at a time. A record already out cannot be checked out again, because
// the question the tracking answers is "who has it", and two answers is the
// same as none.
func (s *Service) CheckOutRecord(ctx context.Context, recordID, custodian,
	location, purpose string, dueBack time.Time) (domain.PhysicalRecord,
	error) {

	session, scope, err := s.authorize(ctx, PermPhysicalManage)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PhysicalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.physical.PhysicalRecord(ctx, scope, recordID)
		if err != nil {
			return err
		}
		expected := record.Version
		if err := record.CheckOut(custodian, location, purpose, dueBack,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.physical.UpdatePhysicalRecord(ctx, scope, record,
			expected); err != nil {
			return err
		}
		out = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.physical.checked_out",
			ResourceType: "mrd_physical_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"custodian": custodian, "location": location,
			}),
			Reason: purpose,
		}, now)
	})
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}
	return out, nil
}

// CheckInRecord brings a paper volume back (SRS-MRD-006).
func (s *Service) CheckInRecord(ctx context.Context, recordID,
	location string) (domain.PhysicalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPhysicalManage)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	now := s.clock.Now()

	var back domain.PhysicalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.physical.PhysicalRecord(ctx, scope, recordID)
		if err != nil {
			return err
		}
		expected := record.Version
		if err := record.CheckIn(location, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.physical.UpdatePhysicalRecord(ctx, scope, record,
			expected); err != nil {
			return err
		}
		back = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.physical.checked_in",
			ResourceType: "mrd_physical_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location": record.CurrentLocation,
			}),
			Reason: "a paper record came back",
		}, now)
	})
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}
	return back, nil
}

// MarkRecordMissing records a paper volume nobody can find (SRS-MRD-006).
//
// Escalated rather than queued. A missing record is a clinic appointment
// without a history and a coroner's request nobody can answer, and the window
// in which it turns up is the first day.
func (s *Service) MarkRecordMissing(ctx context.Context, recordID,
	reason string) (domain.PhysicalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPhysicalManage)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	now := s.clock.Now()

	var missing domain.PhysicalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.physical.PhysicalRecord(ctx, scope, recordID)
		if err != nil {
			return err
		}
		expected := record.Version
		lastSeen := record.Custodian
		if err := record.MarkMissing(reason, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.physical.UpdatePhysicalRecord(ctx, scope, record,
			expected); err != nil {
			return err
		}
		missing = record

		if err := s.appendEvent(ctx, session, EventRecordMissing,
			"mrd_physical_record", record.ID, map[string]any{
				"reference": record.Reference,
			}, now); err != nil {
			return err
		}
		if err := s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationMissingRecord, Subject: record.ID,
			Summary: "paper record " + record.Reference + " is missing",
		}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.physical.missing",
			ResourceType: "mrd_physical_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"last_custodian": lastSeen,
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}
	return missing, nil
}

// ArchiveRecord moves a paper volume to off-site storage (SRS-MRD-006).
func (s *Service) ArchiveRecord(ctx context.Context, recordID,
	location string) (domain.PhysicalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPhysicalManage)
	if err != nil {
		return domain.PhysicalRecord{}, err
	}
	now := s.clock.Now()

	var archived domain.PhysicalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.physical.PhysicalRecord(ctx, scope, recordID)
		if err != nil {
			return err
		}
		expected := record.Version
		if err := record.Archive(location, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.physical.UpdatePhysicalRecord(ctx, scope, record,
			expected); err != nil {
			return err
		}
		archived = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.physical.archived",
			ResourceType: "mrd_physical_record", ResourceID: record.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{"location": location}),
			Reason:  "moved a paper record to storage",
		}, now)
	})
	if err != nil {
		return domain.PhysicalRecord{}, recordsError(err)
	}
	return archived, nil
}

// PhysicalRecords lists paper volumes (SRS-MRD-006).
func (s *Service) PhysicalRecords(ctx context.Context,
	filter ports.PhysicalFilter) ([]domain.PhysicalRecord, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.physical.PhysicalRecords(ctx, scope, filter, s.clock.Now())
}
