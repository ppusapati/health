package application

import (
	"context"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Restraints, transfusion, wounds, education, assignment and acuity
// (SRS-NUR-012 … SRS-NUR-017).

// ApplyRestraint records the start of a restraint episode (SRS-NUR-013).
func (s *Service) ApplyRestraint(ctx context.Context,
	in domain.NewRestraintInput) (*domain.Restraint, error) {

	session, scope, err := s.authorize(ctx, PermRestrain, "restraint",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	restraint, err := domain.NewRestraint(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.InsertRestraint(ctx, scope, restraint); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.restraint.apply", ResourceType: "restraint",
			ResourceID: restraint.ID, Outcome: audit.OutcomeSuccess,
			Reason: restraint.Authorization.Indication,
		}, now); err != nil {
			return err
		}
		// Emitted because restraint use is reported and reviewed outside the
		// ward that applied it, and a count that has to be assembled from the
		// chart is a count nobody assembles.
		return s.appendEvent(ctx, session, EventRestraintApplied, "restraint",
			restraint.ID, map[string]any{
				"restraint_id":  restraint.ID,
				"patient_id":    restraint.PatientID,
				"encounter_id":  restraint.EncounterID,
				"kind":          string(restraint.Kind),
				"authorized_by": restraint.Authorization.AuthorizedBy,
				"expires_at":    timeOrNil(restraint.Authorization.ExpiresAt),
			}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return restraint, nil
}

// RenewRestraint extends a restraint with a fresh authorization
// (SRS-NUR-013).
func (s *Service) RenewRestraint(ctx context.Context, restraintID string,
	a domain.RestraintAuthorization) (*domain.Restraint, error) {

	session, scope, err := s.authorize(ctx, PermRestrain, "restraint",
		restraintID, true)
	if err != nil {
		return nil, err
	}

	restraint, err := s.safety.GetRestraint(ctx, scope, restraintID)
	if err != nil {
		return nil, err
	}
	expected := restraint.Version

	now := s.clock.Now()
	if err := restraint.Renew(a, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.UpdateRestraint(ctx, scope, restraint,
			expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.restraint.renew", ResourceType: "restraint",
			ResourceID: restraint.ID, Outcome: audit.OutcomeSuccess,
			Reason: a.Indication,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return restraint, nil
}

// CheckRestraint records an observation of a restrained patient
// (SRS-NUR-013).
func (s *Service) CheckRestraint(ctx context.Context, restraintID string,
	c domain.RestraintCheck) error {

	session, scope, err := s.authorize(ctx, PermRestrain, "restraint",
		restraintID, true)
	if err != nil {
		return err
	}

	restraint, err := s.safety.GetRestraint(ctx, scope, restraintID)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	c.ID = s.ids.NewID()
	if c.ObservedBy == "" {
		c.ObservedBy = session.SubjectID
	}
	if err := restraint.Check(c, now); err != nil {
		return nursingError(err)
	}

	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.InsertRestraintCheck(ctx, scope, restraintID,
			c); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.restraint.check", ResourceType: "restraint",
			ResourceID: restraintID, Outcome: audit.OutcomeSuccess,
		}, now)
	}))
}

// DiscontinueRestraint ends a restraint episode (SRS-NUR-013).
func (s *Service) DiscontinueRestraint(ctx context.Context, restraintID string,
	at time.Time, reason string) (*domain.Restraint, error) {

	session, scope, err := s.authorize(ctx, PermRestrain, "restraint",
		restraintID, true)
	if err != nil {
		return nil, err
	}

	restraint, err := s.safety.GetRestraint(ctx, scope, restraintID)
	if err != nil {
		return nil, err
	}
	expected := restraint.Version

	now := s.clock.Now()
	if err := restraint.Discontinue(at, reason, session.SubjectID, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.UpdateRestraint(ctx, scope, restraint,
			expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.restraint.discontinue", ResourceType: "restraint",
			ResourceID: restraint.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return restraint, nil
}

// RestraintAlert is a restraint needing attention (SRS-NUR-013).
type RestraintAlert struct {
	Restraint *domain.Restraint
	// AuthorizationExpired is the requirement's alert. The restraint is still
	// active: the patient is restrained, and what has lapsed is the permission.
	AuthorizationExpired bool
	MonitoringOverdue    bool
}

// RestraintAlerts lists restraints whose authorization has lapsed
// (SRS-NUR-013).
func (s *Service) RestraintAlerts(ctx context.Context, limit int32) (
	[]RestraintAlert, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "restraint", "",
		false)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	expired, err := s.safety.ExpiredAuthorizations(ctx, scope, now,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	out := make([]RestraintAlert, 0, len(expired))
	for _, r := range expired {
		out = append(out, RestraintAlert{
			Restraint: r, AuthorizationExpired: true,
			MonitoringOverdue: r.MonitoringOverdue(now),
		})
	}

	// One event per lapsed authorization, so an alert reaches the nurse in
	// charge rather than waiting for somebody to open this screen. Inside a
	// transaction because the outbox requires one (ADR-004): a read that
	// publishes is still a write.
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		for _, alert := range out {
			r := alert.Restraint
			if err := s.appendEvent(ctx, session,
				EventRestraintAuthorizationExpired, "restraint", r.ID,
				map[string]any{
					"restraint_id": r.ID,
					"patient_id":   r.PatientID,
					"encounter_id": r.EncounterID,
					"expired_at":   timeOrNil(r.Current().ExpiresAt),
					// The patient is still restrained. What has lapsed is the
					// permission (SRS-NUR-013).
					"still_active": r.Active(),
				}, now); err != nil {
				return err
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.restraint_alerts.read", ResourceType: "restraint",
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// ListRestraints reads an encounter's restraint episodes.
func (s *Service) ListRestraints(ctx context.Context, encounterID string,
	activeOnly bool, limit int32) ([]*domain.Restraint, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "restraint",
		encounterID, false)
	if err != nil {
		return nil, err
	}

	out, err := s.safety.ListRestraints(ctx, scope, encounterID, activeOnly,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.restraint.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// StartTransfusion begins a blood-product episode (SRS-NUR-014).
func (s *Service) StartTransfusion(ctx context.Context,
	in domain.NewTransfusionInput) (*domain.Transfusion, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse, "transfusion",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	in.Baseline.ID = s.ids.NewID()
	transfusion, err := domain.NewTransfusion(s.ids.NewID(), session.TenantID,
		in, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.InsertTransfusion(ctx, scope, transfusion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.transfusion.start", ResourceType: "transfusion",
			ResourceID: transfusion.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return transfusion, nil
}

// ObserveTransfusion records a monitoring set (SRS-NUR-014).
func (s *Service) ObserveTransfusion(ctx context.Context, transfusionID string,
	o domain.TransfusionObservation) (*domain.Transfusion, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse, "transfusion",
		transfusionID, true)
	if err != nil {
		return nil, err
	}

	transfusion, err := s.safety.GetTransfusion(ctx, scope, transfusionID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	o.ID = s.ids.NewID()
	if o.ObservedBy == "" {
		o.ObservedBy = session.SubjectID
	}
	if err := transfusion.Observe(o, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.InsertTransfusionObservation(ctx, scope,
			transfusionID, o); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.transfusion.observe", ResourceType: "transfusion",
			ResourceID: transfusionID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return transfusion, nil
}

// ReportTransfusionReaction stops a transfusion and records a suspected
// reaction (SRS-NUR-014).
//
// Stopping and reporting are one operation, because they are one act at the
// bedside and splitting them creates a window in which the system believes
// blood is still running into a patient having a reaction.
func (s *Service) ReportTransfusionReaction(ctx context.Context,
	transfusionID string, r domain.TransfusionReaction) (
	*domain.Transfusion, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse, "transfusion",
		transfusionID, true)
	if err != nil {
		return nil, err
	}

	transfusion, err := s.safety.GetTransfusion(ctx, scope, transfusionID)
	if err != nil {
		return nil, err
	}
	expected := transfusion.Version

	now := s.clock.Now()
	if r.ReportedBy == "" {
		r.ReportedBy = session.SubjectID
	}
	if err := transfusion.ReportReaction(r, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.EndTransfusion(ctx, scope, transfusion,
			expected); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.transfusion.reaction", ResourceType: "transfusion",
			ResourceID: transfusion.ID, Outcome: audit.OutcomeSuccess,
			Reason: r.Features,
		}, now); err != nil {
			return err
		}
		// The blood bank and the haemovigilance scheme both need this, and
		// neither reads the ward's chart.
		return s.appendEvent(ctx, session, EventTransfusionReaction,
			"transfusion", transfusion.ID, map[string]any{
				"transfusion_id": transfusion.ID,
				"patient_id":     transfusion.PatientID,
				"encounter_id":   transfusion.EncounterID,
				"unit_number":    transfusion.UnitNumber,
				"product_code":   transfusion.Product.Code,
				"unit_returned":  r.UnitReturned,
			}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return transfusion, nil
}

// CompleteTransfusion ends a transfusion that finished normally.
func (s *Service) CompleteTransfusion(ctx context.Context, transfusionID string,
	at time.Time) (*domain.Transfusion, error) {

	session, scope, err := s.authorize(ctx, PermTransfuse, "transfusion",
		transfusionID, true)
	if err != nil {
		return nil, err
	}

	transfusion, err := s.safety.GetTransfusion(ctx, scope, transfusionID)
	if err != nil {
		return nil, err
	}
	expected := transfusion.Version

	now := s.clock.Now()
	if err := transfusion.Complete(at, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.safety.EndTransfusion(ctx, scope, transfusion,
			expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.transfusion.complete", ResourceType: "transfusion",
			ResourceID: transfusion.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return transfusion, nil
}

// AssessWound records a wound assessment (SRS-NUR-012).
func (s *Service) AssessWound(ctx context.Context,
	in domain.NewWoundAssessmentInput) (*domain.WoundAssessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "wound_assessment",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	assessment, err := domain.NewWoundAssessment(s.ids.NewID(),
		session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ward.InsertWound(ctx, scope, assessment); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.wound.assess", ResourceType: "wound_assessment",
			ResourceID: assessment.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return assessment, nil
}

// AttachWoundImage adds a photograph where consent covers it (SRS-NUR-012).
//
// The consent is checked against the clinical context rather than taken on
// trust: a photograph of a wound is a photograph of a patient, and a consent
// identifier a caller made up is not a consent.
func (s *Service) AttachWoundImage(ctx context.Context, assessmentID string,
	img domain.WoundImage, content []byte) (*domain.WoundAssessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "wound_assessment",
		assessmentID, true)
	if err != nil {
		return nil, err
	}
	if strings.TrimSpace(img.StorageKey) != "" {
		// Refused rather than ignored. A client sending a key believes this
		// assessment will point at bytes it placed itself, and quietly
		// substituting the server's own key would leave it believing that
		// while the record pointed somewhere else.
		return nil, rpcerr.Invalid("NURSING_WOUND_IMAGE_KEY_NOT_ACCEPTED",
			"send the photograph in content; the server stores it and records where")
	}
	if s.images == nil {
		return nil, rpcerr.FailedPrecondition("NURSING_WOUND_IMAGE_STORE_NOT_CONFIGURED",
			"this deployment does not store wound photographs")
	}
	if len(content) == 0 {
		return nil, rpcerr.Invalid("NURSING_WOUND_IMAGE_EMPTY", "a photograph needs content")
	}

	assessment, err := s.ward.GetWound(ctx, scope, assessmentID)
	if err != nil {
		return nil, err
	}

	covers := false
	if s.consents != nil && img.ConsentID != "" {
		covers, err = s.consents.CoversPhotography(ctx, scope, img.ConsentID,
			assessment.PatientID)
		if err != nil {
			return nil, err
		}
	}

	now := s.clock.Now()
	img.ImageID = s.ids.NewID()
	if img.CapturedBy == "" {
		img.CapturedBy = session.SubjectID
	}

	// Everything but the storage key is checked before the bytes are written.
	// A photograph of a patient taken without consent must not reach the store
	// even briefly: writing it and deleting it again on refusal leaves the
	// bytes on a disk, in a bucket's version history or in a replica, which is
	// precisely what the consent was about.
	if err := assessment.CanAttachImage(img, covers, now); err != nil {
		return nil, nursingError(err)
	}

	storageKey, err := s.images.Put(ctx, scope, img.ContentType, content)
	if err != nil {
		return nil, err
	}
	img.StorageKey = storageKey

	if err := assessment.AttachImage(img, covers, now); err != nil {
		_ = s.images.Delete(ctx, scope, storageKey)
		return nil, nursingError(err)
	}
	stored := assessment.Images[len(assessment.Images)-1]

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ward.InsertWoundImage(ctx, scope, assessmentID,
			stored); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.wound.photograph", ResourceType: "wound_assessment",
			ResourceID: assessmentID, Outcome: audit.OutcomeSuccess,
			Reason: "consent " + img.ConsentID,
		}, now)
	})
	if err != nil {
		_ = s.images.Delete(ctx, scope, storageKey)
		return nil, mapConflict(err)
	}
	return assessment, nil
}

// WoundHistory reads a wound's assessments over time (SRS-NUR-012).
func (s *Service) WoundHistory(ctx context.Context, patientID, woundID string,
	limit int32) ([]*domain.WoundAssessment, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "wound_assessment",
		patientID, false)
	if err != nil {
		return nil, err
	}

	out, err := s.ward.ListWounds(ctx, scope, patientID, woundID,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.wound.read", ResourceType: "patient",
		ResourceID: patientID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// TeachInput is what recording a teaching episode needs.
type TeachInput struct {
	PatientID     string
	EncounterID   string
	Topic         domain.Coding
	Learner       domain.Learner
	LearnerName   string
	Method        string
	Understanding domain.Understanding
	Barriers      string
	TaughtAt      time.Time
}

// Teach records patient or family education (SRS-NUR-015).
func (s *Service) Teach(ctx context.Context, in TeachInput) (
	*domain.EducationRecord, error) {

	session, scope, err := s.authorize(ctx, PermNursingWrite, "education",
		in.EncounterID, true)
	if err != nil {
		return nil, err
	}
	if _, err := s.requireOpenEncounter(ctx, scope, in.EncounterID,
		in.PatientID); err != nil {
		return nil, err
	}

	now := s.clock.Now()
	record, err := domain.NewEducationRecord(s.ids.NewID(), session.TenantID,
		in.PatientID, in.EncounterID, in.Topic, in.Learner, in.LearnerName,
		in.Method, in.Understanding, in.Barriers, in.TaughtAt,
		session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ward.InsertEducation(ctx, scope, record); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.education.record", ResourceType: "education",
			ResourceID: record.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return record, nil
}

// DischargeReadiness assembles the nursing view of whether a patient can go
// home (SRS-NUR-015).
//
// Assembled from what the record already holds rather than from a checklist
// somebody ticks, so a criterion cannot be marked met by asserting it.
func (s *Service) DischargeReadiness(ctx context.Context, encounterID,
	patientID string) (domain.DischargeReadiness, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "encounter",
		encounterID, false)
	if err != nil {
		return domain.DischargeReadiness{}, err
	}
	if _, err := s.requireOpenEncounterForRead(ctx, scope, encounterID,
		patientID); err != nil {
		return domain.DischargeReadiness{}, err
	}

	now := s.clock.Now()
	readiness := domain.DischargeReadiness{
		AssessedAt: now.UTC(), AssessedBy: session.SubjectID,
	}

	assessments, err := s.assessments.List(ctx, scope, encounterID,
		domain.AssessmentDischarge, 1)
	if err != nil {
		return domain.DischargeReadiness{}, err
	}
	readiness.Criteria = append(readiness.Criteria, domain.ReadinessCriterion{
		Key: "a_discharge_assessment", Label: "Complete the discharge assessment",
		Met: len(assessments) > 0,
	})

	education, err := s.ward.ListEducation(ctx, scope, patientID, MaxPageSize)
	if err != nil {
		return domain.DischargeReadiness{}, err
	}
	outstandingTeaching := ""
	for _, e := range education {
		if e.Understanding == domain.UnderstandingNeedsReinforcement ||
			e.Understanding == domain.UnderstandingUnableToAssess {
			outstandingTeaching = e.Topic.Display
			break
		}
	}
	readiness.Criteria = append(readiness.Criteria, domain.ReadinessCriterion{
		Key: "b_education", Label: "Complete the patient's teaching",
		// Teaching delivered is not teaching received: an episode recorded as
		// needing reinforcement is an open criterion.
		Met:  len(education) > 0 && outstandingTeaching == "",
		Note: outstandingTeaching,
	})

	devices, err := s.devices.List(ctx, scope, encounterID, true, MaxPageSize)
	if err != nil {
		return domain.DischargeReadiness{}, err
	}
	deviceNote := ""
	if len(devices) > 0 {
		deviceNote = string(devices[0].Kind) + " still in place"
	}
	readiness.Criteria = append(readiness.Criteria, domain.ReadinessCriterion{
		Key: "c_devices", Label: "Remove or hand over every device",
		Met: len(devices) == 0, Note: deviceNote,
	})

	tasks, err := s.tasks.Worklist(ctx, scope, ports.WorklistQuery{
		EncounterID: encounterID, PendingOnly: true, Limit: MaxPageSize,
	})
	if err != nil {
		return domain.DischargeReadiness{}, err
	}
	taskNote := ""
	if len(tasks) > 0 {
		taskNote = tasks[0].Description
	}
	readiness.Criteria = append(readiness.Criteria, domain.ReadinessCriterion{
		Key: "d_tasks", Label: "Complete or close outstanding nursing work",
		Met: len(tasks) == 0, Note: taskNote,
	})

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.discharge_readiness.read", ResourceType: "encounter",
		ResourceID: encounterID, Outcome: audit.OutcomeSuccess,
	}, now); err != nil {
		return domain.DischargeReadiness{}, err
	}
	return readiness, nil
}

// AssignNurseInput is what an assignment needs.
type AssignNurseInput struct {
	UnitID       string
	BedID        string
	PatientID    string
	NurseID      string
	Relationship domain.CareRelationship
	From         time.Time
}

// AssignNurse assigns a nurse to a patient or a bed (SRS-NUR-017).
func (s *Service) AssignNurse(ctx context.Context, in AssignNurseInput) (
	*domain.NurseAssignment, error) {

	session, scope, err := s.authorize(ctx, PermAssign, "assignment",
		in.PatientID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	from := in.From
	if from.IsZero() {
		from = now
	}
	assignment, err := domain.NewAssignment(s.ids.NewID(), session.TenantID,
		in.UnitID, in.BedID, in.PatientID, in.NurseID, in.Relationship, from,
		session.SubjectID)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// One live primary per patient is held by a partial unique index, so a
		// second primary assignment is refused at the table rather than
		// producing two answers to "who is responsible".
		if err := s.ward.InsertAssignment(ctx, scope, assignment); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.assignment.create", ResourceType: "assignment",
			ResourceID: assignment.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return assignment, nil
}

// EndAssignment closes an assignment (SRS-NUR-017).
func (s *Service) EndAssignment(ctx context.Context, assignmentID string,
	at time.Time, reason string) error {

	session, scope, err := s.authorize(ctx, PermAssign, "assignment",
		assignmentID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	if at.IsZero() {
		at = now
	}

	// Read through the as-of listing rather than a get: the assignment is
	// identified by the caller and must be one this tenant holds.
	assignments, err := s.ward.Assignments(ctx, scope, ports.AssignmentQuery{
		AsOf: now, Limit: MaxPageSize,
	})
	if err != nil {
		return err
	}
	var assignment *domain.NurseAssignment
	for _, a := range assignments {
		if a.ID == assignmentID {
			assignment = a
			break
		}
	}
	if assignment == nil {
		return rpcerr.NotFound("NUR_NOT_FOUND", "no such nursing record")
	}
	if err := assignment.End(at, reason); err != nil {
		return nursingError(err)
	}

	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ward.EndAssignment(ctx, scope, assignment); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.assignment.end", ResourceType: "assignment",
			ResourceID: assignment.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	}))
}

// WhoWasCaring answers "who was looking after this patient at this time"
// (SRS-NUR-017).
func (s *Service) WhoWasCaring(ctx context.Context, q ports.AssignmentQuery) (
	[]*domain.NurseAssignment, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "assignment",
		q.PatientID, false)
	if err != nil {
		return nil, err
	}
	if q.AsOf.IsZero() {
		q.AsOf = s.clock.Now()
	}
	q.Limit = clampPageSize(q.Limit)

	out, err := s.ward.Assignments(ctx, scope, q)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.assignment.read", ResourceType: "patient",
		ResourceID: q.PatientID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// AcuityInput is one patient's contribution to a unit's workload picture.
type AcuityInput struct {
	PatientID   string
	EncounterID string
	// DependencyScore and Isolation are assessed rather than derived, so the
	// caller supplies them; everything else is counted from the record.
	DependencyScore int32
	Isolation       bool
}

// UnitAcuity reports a ward's workload picture (SRS-NUR-016).
//
// A report, and nothing more. It changes no assignment and triggers no
// staffing action: SRS-NUR-016's acceptance criterion is that the dashboard
// "never silently alters staffing decisions", and the way to hold that is for
// it to have no mechanism by which it could.
func (s *Service) UnitAcuity(ctx context.Context, unitID string,
	patients []AcuityInput) (domain.UnitAcuity, error) {

	session, scope, err := s.authorize(ctx, PermNursingRead, "unit", unitID,
		false)
	if err != nil {
		return domain.UnitAcuity{}, err
	}
	if unitID == "" {
		return domain.UnitAcuity{}, rpcerr.Invalid("NUR_ACUITY_NO_UNIT",
			"an acuity report is about a unit")
	}

	now := s.clock.Now()
	weights, err := s.ward.AcuityWeights(ctx, scope, unitID)
	if err != nil {
		return domain.UnitAcuity{}, err
	}

	computed := make([]domain.PatientAcuity, 0, len(patients))
	for _, p := range patients {
		inputs := domain.AcuityInputs{
			DependencyScore: p.DependencyScore, Isolation: p.Isolation,
		}

		tasks, err := s.tasks.Worklist(ctx, scope, ports.WorklistQuery{
			EncounterID: p.EncounterID, PendingOnly: true, Limit: MaxPageSize,
		})
		if err != nil {
			return domain.UnitAcuity{}, err
		}
		inputs.OpenTasks = int32(len(tasks))
		for _, t := range tasks {
			if t.Overdue(now) {
				inputs.OverdueTasks++
			}
		}

		devices, err := s.devices.List(ctx, scope, p.EncounterID, true,
			MaxPageSize)
		if err != nil {
			return domain.UnitAcuity{}, err
		}
		inputs.Devices = int32(len(devices))

		due, err := s.risks.Due(ctx, scope, p.EncounterID, now, MaxPageSize)
		if err != nil {
			return domain.UnitAcuity{}, err
		}
		for _, r := range due {
			if r.Escalate {
				inputs.HighRisk++
			}
		}

		computed = append(computed, domain.Acuity(p.PatientID, inputs, weights,
			now))
	}

	// Counted from live assignments, not from a roster: a roster says who was
	// meant to be there.
	onDuty, err := s.ward.NursesOnDuty(ctx, scope, unitID, now)
	if err != nil {
		return domain.UnitAcuity{}, err
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "nursing.acuity.read", ResourceType: "unit",
		ResourceID: unitID, Outcome: audit.OutcomeSuccess,
	}, now); err != nil {
		return domain.UnitAcuity{}, err
	}
	return domain.SummariseUnit(unitID, computed, onDuty, now), nil
}

// SetAcuityWeights configures a unit's multipliers (SRS-NUR-016).
func (s *Service) SetAcuityWeights(ctx context.Context, unitID string,
	w domain.AcuityWeights) error {

	session, scope, err := s.authorize(ctx, PermNursingConfigure,
		"acuity_weights", unitID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ward.SetAcuityWeights(ctx, scope, unitID, w,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.acuity_weights.set", ResourceType: "acuity_weights",
			ResourceID: unitID, Outcome: audit.OutcomeSuccess,
		}, now)
	}))
}

// DeclareDowntime opens a downtime period (SRS-NUR-018).
func (s *Service) DeclareDowntime(ctx context.Context, unitID, reason string,
	startedAt time.Time) (*domain.DowntimeEpisode, error) {

	session, scope, err := s.authorize(ctx, PermDowntime, "downtime_episode",
		unitID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	if startedAt.IsZero() {
		startedAt = now
	}
	episode, err := domain.NewDowntimeEpisode(s.ids.NewID(), session.TenantID,
		unitID, reason, startedAt, session.SubjectID, now)
	if err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.downtime.Insert(ctx, scope, episode); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.downtime.declare", ResourceType: "downtime_episode",
			ResourceID: episode.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return episode, nil
}

// EndDowntime closes a downtime period (SRS-NUR-018).
func (s *Service) EndDowntime(ctx context.Context, episodeID string,
	endedAt time.Time) (*domain.DowntimeEpisode, error) {

	session, scope, err := s.authorize(ctx, PermDowntime, "downtime_episode",
		episodeID, true)
	if err != nil {
		return nil, err
	}

	episode, err := s.downtime.Get(ctx, scope, episodeID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	if endedAt.IsZero() {
		endedAt = now
	}
	if err := episode.End(endedAt, session.SubjectID, now); err != nil {
		return nil, nursingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.downtime.End(ctx, scope, episode); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "nursing.downtime.end", ResourceType: "downtime_episode",
			ResourceID: episode.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return episode, nil
}

// ListDowntime reads downtime episodes, optionally only unreconciled ones.
//
// An unreconciled episode is one where somebody never finished typing in the
// paper chart, which is a gap in the record rather than a tidiness problem.
func (s *Service) ListDowntime(ctx context.Context, unitID string,
	unreconciledOnly bool, limit int32) ([]*domain.DowntimeEpisode, error) {

	_, scope, err := s.authorize(ctx, PermNursingRead, "downtime_episode",
		unitID, false)
	if err != nil {
		return nil, err
	}
	return s.downtime.List(ctx, scope, unitID, unreconciledOnly,
		clampPageSize(limit))
}
