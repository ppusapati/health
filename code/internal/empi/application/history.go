package application

import (
	"context"
	"encoding/json"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/effective"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Demographic history, deceased status and related persons
// (SRS-EMPI-007/008/009).

// Event types for this slice (SRS-EMPI-018).
const (
	// EventPatientDeceased is emitted when a death is recorded. Scheduling and
	// billing both care, and both find out this way rather than by polling.
	EventPatientDeceased = "patient.deceased"
	// EventPatientDeceasedReversed is emitted when one is withdrawn.
	EventPatientDeceasedReversed = "patient.deceased_reversed"
)

// RecordNameInput adds a name to the history.
type RecordNameInput struct {
	PatientID string
	Kind      domain.NameKind
	Name      domain.HumanName
	// EffectiveFrom is when the name started applying — a marriage date, a
	// deed poll — not when somebody got round to typing it. Zero means now.
	EffectiveFrom time.Time
	Source        string
}

// RecordName adds a name and, for a legal name, makes it current
// (SRS-EMPI-007).
//
// A legal name change updates the patient's columns too, because those are what
// the matcher reads and the search index is built over. Both writes are in one
// transaction: a history row without the column update leaves the wristband
// printing the old name, and the reverse loses the interval the old one applied
// to.
func (s *Service) RecordName(ctx context.Context, in RecordNameInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientUpdate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientUpdate, "patient", in.PatientID, decision.Reason)
		return rpcerr.PermissionDenied("EMPI_UPDATE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	from := in.EffectiveFrom
	if from.IsZero() {
		from = now
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}

		recorded, err := domain.NewPatientName(s.ids.NewID(), patient.ID(), in.Kind, in.Name,
			effective.Window{From: from}, session.SubjectID, in.Source, now)
		if err != nil {
			return registrationError(err)
		}
		if err := s.history.RecordName(ctx, scope, recorded); err != nil {
			return err
		}

		if in.Kind == domain.NameLegal {
			demographics := patient.Demographics
			demographics.Name = recorded.Name

			jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
			if err != nil {
				return err
			}
			registrationPolicy, err := s.config.DemographicPolicy(ctx, scope,
				jurisdiction, patient.RegisteredFacilityID)
			if err != nil {
				return err
			}
			if err := patient.UpdateDemographics(demographics, registrationPolicy, now); err != nil {
				return registrationError(err)
			}
			if err := s.patients.UpdateDemographics(ctx, scope, patient); err != nil {
				return err
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientUpdate,
			ResourceType: "patient_name", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "recorded " + string(in.Kind) + " name",
		}, now)
	})
	return mapConflict(err)
}

// PatientHistory is everything effective-dated about one patient.
type PatientHistory struct {
	Names       domain.NameHistory
	Preferences domain.PreferenceSet
	Related     domain.RelatedPersonSet
}

// GetHistory reads a patient's demographic history.
func (s *Service) GetHistory(ctx context.Context, patientID string) (PatientHistory, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return PatientHistory{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient", patientID, decision.Reason)
		return PatientHistory{}, rpcerr.PermissionDenied("EMPI_READ_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	var out PatientHistory

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Existence is checked through the repository rather than assumed, so
		// asking for another tenant's patient answers NOT_FOUND here too.
		if _, err := s.patients.GetByID(ctx, scope, patientID); err != nil {
			return err
		}

		if out.Names, err = s.history.Names(ctx, scope, patientID); err != nil {
			return err
		}
		if out.Preferences, err = s.history.Preferences(ctx, scope, patientID); err != nil {
			return err
		}
		if out.Related, err = s.history.RelatedPersons(ctx, scope, patientID); err != nil {
			return err
		}

		context, err := json.Marshal(map[string]any{"scope": "history"})
		if err != nil {
			return rpcerr.Internal("EMPI_AUDIT_ENCODE_FAILED", "could not encode audit context").WithCause(err)
		}
		return s.auditRead(ctx, session, patientID, context)
	})
	if err != nil {
		return PatientHistory{}, err
	}
	return out, nil
}

// RecordPreferenceInput records a communication decision.
type RecordPreferenceInput struct {
	PatientID     string
	Channel       domain.CommunicationChannel
	Purpose       domain.CommunicationPurpose
	Allowed       bool
	EffectiveFrom time.Time
}

// RecordCommunicationPreference stores what the patient agreed to
// (SRS-EMPI-007, consumed by SRS-EMPI-013).
func (s *Service) RecordCommunicationPreference(ctx context.Context, in RecordPreferenceInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientUpdate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientUpdate, "patient", in.PatientID, decision.Reason)
		return rpcerr.PermissionDenied("EMPI_UPDATE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	from := in.EffectiveFrom
	if from.IsZero() {
		from = now
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}

		preference, err := domain.NewCommunicationPreference(s.ids.NewID(), patient.ID(),
			in.Channel, in.Purpose, in.Allowed, effective.Window{From: from}, session.SubjectID, now)
		if err != nil {
			return registrationError(err)
		}
		if err := s.history.RecordPreference(ctx, scope, preference); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientUpdate,
			ResourceType: "communication_preference", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  string(in.Channel) + "/" + string(in.Purpose) + "=" + boolText(in.Allowed),
		}, now)
	})
	return mapConflict(err)
}

func boolText(v bool) string {
	if v {
		return "allowed"
	}
	return "declined"
}

// RecordDeceasedInput records a death (SRS-EMPI-008).
type RecordDeceasedInput struct {
	PatientID string
	Date      domain.BirthDate
	// Source is who says so: a registrar, a clinician, a national death
	// registry feed. Required, because a feed can be wrong about the wrong
	// patient and reversing it needs to know what claimed it.
	Source string
}

// RecordDeceased records a death and stops routine scheduling (SRS-EMPI-008).
func (s *Service) RecordDeceased(ctx context.Context, in RecordDeceasedInput) (*domain.Patient, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient", in.PatientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_DECEASED_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var updated *domain.Patient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}

		record := domain.DeceasedRecord{
			Date: in.Date.Date, Precision: in.Date.Precision,
			Source: in.Source, RecordedAt: now, RecordedBy: session.SubjectID,
		}
		if err := record.Validate(); err != nil {
			return registrationError(err)
		}

		patient.Deceased = &record
		if err := s.merges.SetDeceased(ctx, scope, patient); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(),
			// The source travels with the event because a downstream system
			// deciding whether to cancel appointments on a registry feed wants
			// to weigh it differently from a clinician's entry.
			"source": record.Source,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientDeceased,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		updated = patient
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "deceased recorded from " + record.Source,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return updated, nil
}

// ReverseDeceased withdraws a death recorded against the wrong patient.
//
// The case this exists for is a national registry feed matching the wrong
// record. It is rare, it is distressing, and a system that cannot undo it
// leaves somebody unable to book an appointment because a computer believes
// they are dead.
func (s *Service) ReverseDeceased(ctx context.Context, patientID, reason string) (*domain.Patient, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient", patientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_DECEASED_DENIED", decision.Reason)
	}
	if reason == "" {
		return nil, rpcerr.Invalid("EMPI_REVERSAL_NEEDS_REASON",
			"withdrawing a recorded death needs a reason")
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var updated *domain.Patient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, patientID)
		if err != nil {
			return err
		}
		if patient.Deceased == nil {
			return rpcerr.FailedPrecondition("EMPI_NOT_DECEASED",
				"this patient is not recorded as deceased")
		}

		// What was withdrawn goes into the audit trail before it is cleared:
		// the row itself is about to stop saying it.
		withdrawn := patient.Deceased.Source
		patient.Deceased = nil
		if err := s.merges.SetDeceased(ctx, scope, patient); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{"patient_id": patient.ID()})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientDeceasedReversed,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		updated = patient
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  "withdrew death recorded from " + withdrawn + ": " + reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return updated, nil
}

// AddRelatedPersonInput records a relationship (SRS-EMPI-009).
type AddRelatedPersonInput struct {
	PatientID string
	// RelatedPatientID links to another record in this index, when the related
	// person is one — which a parent usually is.
	RelatedPatientID string
	Name             domain.HumanName
	Contact          []domain.ContactPoint
	Relationship     domain.RelationshipType
	Authorities      []domain.Authority
	EffectiveFrom    time.Time
	// EffectiveUntil is when the authority ends. A guardian's ends on a date
	// everybody can predict, and a relationship with no end is a standing grant
	// nobody revisits.
	EffectiveUntil time.Time
}

// AddRelatedPerson records a relationship. It carries no authority until it is
// verified.
func (s *Service) AddRelatedPerson(ctx context.Context, in AddRelatedPersonInput) (domain.RelatedPerson, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.RelatedPerson{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "related_person", in.PatientID, decision.Reason)
		return domain.RelatedPerson{}, rpcerr.PermissionDenied("EMPI_RELATIONSHIP_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	from := in.EffectiveFrom
	if from.IsZero() {
		from = now
	}

	var recorded domain.RelatedPerson
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if in.RelatedPatientID != "" {
			// The linked person must exist in this tenant. Without the check a
			// relationship could name a UUID from anywhere, and the reverse
			// authority lookup would silently find nothing.
			if _, err := s.patients.GetByID(ctx, scope, in.RelatedPatientID); err != nil {
				return err
			}
		}

		related, err := domain.NewRelatedPerson(s.ids.NewID(), patient.ID(), in.Relationship,
			in.Authorities, effective.Window{From: from, Until: in.EffectiveUntil},
			session.SubjectID, now)
		if err != nil {
			return registrationError(err)
		}
		if err := related.Identify(in.RelatedPatientID, in.Name, in.Contact); err != nil {
			return registrationError(err)
		}
		if err := s.history.RecordRelatedPerson(ctx, scope, related); err != nil {
			return err
		}

		recorded = related
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "related_person", ResourceID: related.ID,
			Outcome: audit.OutcomeSuccess, Reason: string(in.Relationship),
		}, now)
	})
	if err != nil {
		return domain.RelatedPerson{}, mapConflict(err)
	}
	return recorded, nil
}

// VerifyRelatedPerson records that somebody checked the claim.
func (s *Service) VerifyRelatedPerson(ctx context.Context, relationshipID, note string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "related_person", relationshipID, decision.Reason)
		return rpcerr.PermissionDenied("EMPI_RELATIONSHIP_DENIED", decision.Reason)
	}
	if note == "" {
		return rpcerr.Invalid("EMPI_VERIFICATION_NEEDS_A_NOTE",
			"verification must say what was checked")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.history.VerifyRelatedPerson(ctx, scope, relationshipID,
			session.SubjectID, note, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "related_person", ResourceID: relationshipID,
			Outcome: audit.OutcomeSuccess, Reason: "verified: " + note,
		}, now)
	}))
}

// EndRelatedPerson closes a relationship.
func (s *Service) EndRelatedPerson(ctx context.Context, relationshipID string) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "related_person", relationshipID, decision.Reason)
		return rpcerr.PermissionDenied("EMPI_RELATIONSHIP_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.history.EndRelatedPerson(ctx, scope, relationshipID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "related_person", ResourceID: relationshipID,
			Outcome: audit.OutcomeSuccess, Reason: "relationship ended",
		}, now)
	}))
}

// CaregiverAuthority reports what one person may do for another, right now.
//
// The question a scheduling or clinical context asks before letting a caregiver
// act. Answered here rather than by handing out the relationship rows, so that
// the three conditions — verified, in force, in scope — are applied once
// instead of by every caller.
func (s *Service) CaregiverAuthority(ctx context.Context,
	holderPatientID, subjectPatientID string) ([]domain.Authority, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "related_person", subjectPatientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_READ_DENIED", decision.Reason)
	}

	relationships, err := s.history.AuthorityHeldBy(ctx, session.TenantScope(),
		holderPatientID, subjectPatientID)
	if err != nil {
		return nil, err
	}
	return relationships.AuthorityFor(holderPatientID, s.clock.Now()), nil
}
