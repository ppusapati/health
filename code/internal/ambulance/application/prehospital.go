package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// OpenRecordInput starts the crew's account of a journey (SRS-AMB-004).
type OpenRecordInput struct {
	TripID              string
	PatientID           string
	FacilityID          string
	PresentingComplaint string
	DocumentRefs        []string
}

// OpenRecord starts a prehospital record against a trip (SRS-AMB-004).
func (s *Service) OpenRecord(ctx context.Context, in OpenRecordInput) (
	domain.PrehospitalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPrehospitalWrite)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PrehospitalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		trip, err := s.trips.Trip(ctx, scope, in.TripID)
		if err != nil {
			return err
		}
		if err := s.checkPatient(ctx, scope, in.PatientID); err != nil {
			return err
		}
		record, err := domain.OpenRecord(s.ids.NewID(), session.TenantID,
			domain.NewRecordInput{
				TripID: trip.ID, RequestID: trip.RequestID,
				PatientID: in.PatientID, FacilityID: in.FacilityID,
				PresentingComplaint: in.PresentingComplaint,
				DocumentRefs:        in.DocumentRefs,
			}, session.SubjectID, now)
		if err != nil {
			return ambulanceError(err)
		}
		if err := s.records.InsertRecord(ctx, scope, record); err != nil {
			return err
		}
		out = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.prehospital.opened",
			ResourceType: "ambulance.prehospital_record",
			ResourceID:   record.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"trip_id": record.TripID,
			}),
		}, now)
	})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return out, nil
}

// RecordEntryInput is one observation, intervention, drug or note
// (SRS-AMB-004).
type RecordEntryInput struct {
	RecordID   string
	Kind       string
	Code       string
	Label      string
	Value      string
	Unit       string
	DoseAmount int
	DoseUnit   string
	Route      string
	Narrative  string
	RecordedAt time.Time
}

// RecordEntry adds a line to the crew's account (SRS-AMB-004).
//
// The crew member is resolved from the trip's shift rather than taken from
// the call: a drug recorded as given by a paramedic who was not on the
// vehicle is a record of who typed it.
func (s *Service) RecordEntry(ctx context.Context, in RecordEntryInput) (
	domain.PrehospitalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPrehospitalWrite)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PrehospitalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.records.Record(ctx, scope, in.RecordID)
		if err != nil {
			return err
		}
		member, err := s.crewMember(ctx, scope, record.TripID,
			session.SubjectID)
		if err != nil {
			return err
		}
		if err := record.Record(s.ids.NewID(), domain.NewEntryInput{
			Kind: domain.EntryKind(in.Kind), Code: in.Code,
			Label: in.Label, Value: in.Value, Unit: in.Unit,
			DoseAmount: in.DoseAmount, DoseUnit: in.DoseUnit,
			Route: in.Route, Narrative: in.Narrative,
			RecordedAt: in.RecordedAt,
		}, member, now); err != nil {
			return ambulanceError(err)
		}
		entry := record.Entries[len(record.Entries)-1]
		if err := s.records.AppendEntry(ctx, scope, record.ID,
			entry); err != nil {
			return err
		}
		out = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.prehospital.entry",
			ResourceType: "ambulance.prehospital_record",
			ResourceID:   record.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind": in.Kind, "code": in.Code,
			}),
		}, now)
	})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return out, nil
}

// crewMember resolves the caller against the crew that went on the trip.
//
// Not against the roster as it stands now, and not against the call: the
// person recorded as having given a drug has to be somebody the service put
// on that vehicle for that job.
func (s *Service) crewMember(ctx context.Context, scope authctx.TenantScope,
	tripID, subjectID string) (domain.CrewMember, error) {

	trip, err := s.trips.Trip(ctx, scope, tripID)
	if err != nil {
		return domain.CrewMember{}, err
	}
	shift, err := s.shifts.Shift(ctx, scope, trip.ShiftID)
	if err != nil {
		return domain.CrewMember{}, err
	}
	for _, member := range shift.Crew {
		if member.SubjectID == subjectID {
			return member, nil
		}
	}
	return domain.CrewMember{}, rpcerr.PermissionDenied("AMB_NOT_ON_CREW",
		"this caller was not on the crew for this trip")
}

// AttachDocumentInput links a transfer document (SRS-AMB-007).
type AttachDocumentInput struct {
	RecordID    string
	DocumentRef string
}

// AttachDocument links a referral or transfer document by reference
// (SRS-AMB-007).
//
// A reference, not a copy: a second copy goes stale the first time somebody
// corrects one.
func (s *Service) AttachDocument(ctx context.Context,
	in AttachDocumentInput) (domain.PrehospitalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPrehospitalWrite)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PrehospitalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.records.Record(ctx, scope, in.RecordID)
		if err != nil {
			return err
		}
		if err := record.AttachDocument(in.DocumentRef); err != nil {
			return ambulanceError(err)
		}
		if err := s.records.AttachDocument(ctx, scope, record.ID,
			record.DocumentRefs[len(record.DocumentRefs)-1],
			now); err != nil {
			return err
		}
		out = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.prehospital.document_attached",
			ResourceType: "ambulance.prehospital_record",
			ResourceID:   record.ID,
			Outcome:      audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return out, nil
}

// GiveHandoverInput hands the patient over (SRS-AMB-004, SRS-AMB-007).
type GiveHandoverInput struct {
	RecordID   string
	Summary    string
	Impression string
	Version    int64
}

// GiveHandover records the crew's handover (SRS-AMB-004, SRS-AMB-007).
func (s *Service) GiveHandover(ctx context.Context, in GiveHandoverInput) (
	domain.PrehospitalRecord, error) {

	session, scope, err := s.authorize(ctx, PermPrehospitalWrite)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PrehospitalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.records.Record(ctx, scope, in.RecordID)
		if err != nil {
			return err
		}
		member, err := s.crewMember(ctx, scope, record.TripID,
			session.SubjectID)
		if err != nil {
			return err
		}
		if err := record.GiveHandover(in.Summary, in.Impression, member,
			now); err != nil {
			return ambulanceError(err)
		}
		if err := s.records.UpdateRecord(ctx, scope, record,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		record.Version = in.Version + 1
		out = record
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.prehospital.handover_given",
			ResourceType: "ambulance.prehospital_record",
			ResourceID:   record.ID,
			Outcome:      audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return out, nil
}

// AcceptHandoverInput takes the patient at the hospital (SRS-AMB-004).
type AcceptHandoverInput struct {
	RecordID    string
	EncounterID string
	Note        string
	Version     int64
}

// AcceptHandover attaches the crew's account to an encounter (SRS-AMB-004).
//
// The domain refuses whoever gave the handover, so holding the permission is
// still not enough to accept your own: a patient standing between two people
// neither of whom has taken responsibility is the failure this prevents.
func (s *Service) AcceptHandover(ctx context.Context,
	in AcceptHandoverInput) (domain.PrehospitalRecord, error) {

	session, scope, err := s.authorize(ctx, PermHandoverAccept)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	now := s.clock.Now()

	var out domain.PrehospitalRecord
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		record, err := s.records.Record(ctx, scope, in.RecordID)
		if err != nil {
			return err
		}
		if err := s.checkEncounter(ctx, scope,
			in.EncounterID); err != nil {
			return err
		}
		if err := record.Accept(in.EncounterID, in.Note,
			session.SubjectID, now); err != nil {
			return ambulanceError(err)
		}
		if err := s.records.UpdateRecord(ctx, scope, record,
			in.Version); err != nil {
			return ambulanceError(err)
		}
		record.Version = in.Version + 1
		out = record

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "ambulance.prehospital.handover_accepted",
			ResourceType: "ambulance.prehospital_record",
			ResourceID:   record.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"encounter_id": record.EncounterID,
			}),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventHandoverAccepted,
			"ambulance.prehospital_record", record.ID, map[string]any{
				"trip_id":      record.TripID,
				"encounter_id": record.EncounterID,
			}, now)
	})
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return out, nil
}

// Record reads one prehospital record (SRS-AMB-004).
//
// Behind its own permission rather than the fleet read: this is the
// patient's record, not the vehicle's.
func (s *Service) Record(ctx context.Context, id string) (
	domain.PrehospitalRecord, error) {

	_, scope, err := s.authorize(ctx, PermPrehospitalRead)
	if err != nil {
		return domain.PrehospitalRecord{}, err
	}
	return s.records.Record(ctx, scope, id)
}

// ListRecordsInput narrows a prehospital record list.
type ListRecordsInput struct {
	States     []string
	FacilityID string
	PatientID  string
	From       time.Time
	To         time.Time
	PageSize   int32
	Offset     int32
}

// ListRecords reads prehospital records (SRS-AMB-004).
func (s *Service) ListRecords(ctx context.Context, in ListRecordsInput) (
	[]domain.PrehospitalRecord, error) {

	_, scope, err := s.authorize(ctx, PermPrehospitalRead)
	if err != nil {
		return nil, err
	}
	states := make([]domain.HandoverState, 0, len(in.States))
	for _, state := range in.States {
		states = append(states, domain.HandoverState(state))
	}
	return s.records.Records(ctx, scope, ports.RecordFilter{
		States: states, FacilityID: in.FacilityID,
		PatientID: in.PatientID, From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}

// SweepWaitingHandovers escalates handovers nobody has accepted
// (SRS-AMB-004).
//
// A crew that handed over to nobody is a patient in a corridor and an
// ambulance that is not answering calls. Run on a schedule: nothing about it
// depends on somebody opening a screen, which is the point.
func (s *Service) SweepWaitingHandovers(ctx context.Context,
	facilityID string) (int, error) {

	session, scope, err := s.authorize(ctx, PermPrehospitalRead)
	if err != nil {
		return 0, err
	}
	if s.config.HandoverWaitBeforeEscalation <= 0 {
		return 0, nil
	}
	now := s.clock.Now()

	records, err := s.records.Records(ctx, scope, ports.RecordFilter{
		States:     []domain.HandoverState{domain.HandoverGiven},
		FacilityID: facilityID, Limit: reportPageSize,
	})
	if err != nil {
		return 0, err
	}

	raised := 0
	for _, record := range domain.Unaccepted(records) {
		if record.GivenAt.IsZero() ||
			now.Sub(record.GivenAt) < s.config.HandoverWaitBeforeEscalation {
			continue
		}
		waited := int(now.Sub(record.GivenAt).Minutes())
		if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
			return s.escalate(ctx, session, scope, ports.Notice{
				Kind: EscalationHandoverWaiting, Subject: record.ID,
				FacilityID: record.FacilityID,
				Summary: "handover from trip " + record.TripID +
					" unaccepted for " + itoa(waited) + " minutes",
			}, now)
		}); err != nil {
			return raised, err
		}
		raised++
	}
	return raised, nil
}
