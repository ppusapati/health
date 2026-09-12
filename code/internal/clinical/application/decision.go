package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Consents, attachments, calculators, decision support, consults and
// registries (SRS-CLN-010, 013, 014, 020 … 023).

// RecordConsentInput records a consent for a clinical act.
type RecordConsentInput struct {
	PatientID     string
	EncounterID   string
	Kind          domain.ClinicalConsentKind
	ProcedureCode domain.Coding
	Status        domain.ConsentStatus
	GivenBy       domain.GivenBy
	GivenByName   string
	DocumentID    string
	WitnessID     string
	ValidFrom     time.Time
	ValidUntil    time.Time
	Note          string
}

// RecordConsent records a clinical consent (SRS-CLN-013).
//
// Deliberately not the privacy consent of SRS-EMPI-013. The two answer
// different questions, and conflating them produces a system where withdrawing
// a marketing preference cancels an operation.
func (s *Service) RecordConsent(ctx context.Context, in RecordConsentInput) (
	domain.ClinicalConsent, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "consent",
		in.PatientID, true)
	if err != nil {
		return domain.ClinicalConsent{}, err
	}

	now := s.clock.Now()
	status := in.Status
	if status == "" {
		status = domain.ConsentGiven
	}
	givenBy := in.GivenBy
	if givenBy == "" {
		givenBy = domain.GivenByPatient
	}

	var out domain.ClinicalConsent
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		consent, err := domain.NewClinicalConsent(s.ids.NewID(), scope.TenantID(),
			domain.NewConsentInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID, Kind: in.Kind,
				ProcedureCode: in.ProcedureCode, Status: status, GivenBy: givenBy,
				GivenByName: in.GivenByName, DocumentID: in.DocumentID,
				WitnessID: in.WitnessID, ValidFrom: in.ValidFrom,
				ValidUntil: in.ValidUntil, Note: in.Note,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.governance.InsertConsent(ctx, scope, consent); err != nil {
			return err
		}

		out = consent
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "consent", ResourceID: consent.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(consent.Kind) + " consent " + string(consent.Status),
		}, now)
	})
	if err != nil {
		return domain.ClinicalConsent{}, mapConflict(err)
	}
	return out, nil
}

// WithdrawConsent records a patient changing their mind (SRS-CLN-013).
func (s *Service) WithdrawConsent(ctx context.Context, consentID string) error {
	session, scope, err := s.authorize(ctx, PermClinicalWrite, "consent",
		consentID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.governance.SetConsentStatus(ctx, scope, consentID,
			domain.ConsentWithdrawn, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "consent", ResourceID: consentID,
			Outcome: audit.OutcomeSuccess, Reason: "consent withdrawn",
		}, now)
	})
}

// ListConsents returns a patient's clinical consents.
func (s *Service) ListConsents(ctx context.Context, patientID string,
	kind domain.ClinicalConsentKind, pageSize int32) (domain.ConsentSet, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "consent", patientID, false)
	if err != nil {
		return nil, err
	}

	var out domain.ConsentSet
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.governance.Consents(ctx, scope, patientID, kind,
			clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// AttachFileInput records a file held against a clinical record.
type AttachFileInput struct {
	ParentType      string
	ParentID        string
	PatientID       string
	Kind            domain.AttachmentKind
	ContentType     string
	StorageKey      string
	SizeBytes       int64
	Digest          string
	Description     string
	Confidentiality domain.Confidentiality
	CapturedAt      time.Time
	SourceSystem    string
	Provenance      *domain.ProvenanceInput
}

// AttachFile records an attachment (SRS-CLN-014).
//
// The bytes live in object storage; this records what they are and who may see
// them. Access follows the parent record *and* the attachment's own class: a
// photograph of an injury attached to an ordinary note can be more sensitive
// than the note.
func (s *Service) AttachFile(ctx context.Context, in AttachFileInput) (
	domain.Attachment, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "attachment",
		in.PatientID, true)
	if err != nil {
		return domain.Attachment{}, err
	}

	now := s.clock.Now()
	confidentiality := in.Confidentiality
	if confidentiality == "" {
		confidentiality = domain.ConfidentialityNormal
	}

	var out domain.Attachment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		attachment, err := domain.NewAttachment(s.ids.NewID(), scope.TenantID(),
			domain.NewAttachmentInput{
				ParentType: in.ParentType, ParentID: in.ParentID,
				PatientID: in.PatientID, Kind: in.Kind,
				ContentType: in.ContentType, StorageKey: in.StorageKey,
				SizeBytes: in.SizeBytes, Digest: in.Digest,
				Description: in.Description, Confidentiality: confidentiality,
				CapturedAt: in.CapturedAt, SourceSystem: in.SourceSystem,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.governance.InsertAttachment(ctx, scope, attachment); err != nil {
			return err
		}

		if in.Provenance != nil {
			provenance, err := domain.NewProvenance(s.ids.NewID(), scope.TenantID(),
				"attachment", attachment.ID, *in.Provenance, now)
			if err != nil {
				return clinicalError(err)
			}
			if err := s.governance.InsertProvenance(ctx, scope, provenance); err != nil {
				return err
			}
		}

		out = attachment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "attachment", ResourceID: attachment.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(attachment.Kind) + " attached to " + in.ParentType,
		}, now)
	})
	if err != nil {
		return domain.Attachment{}, mapConflict(err)
	}
	return out, nil
}

// ListAttachments returns what is attached to one record.
//
// Attachments the reader may not see are dropped: access follows the parent
// record and the attachment's own classification (SRS-CLN-014).
func (s *Service) ListAttachments(ctx context.Context, parentType, parentID string,
	pageSize int32) ([]domain.Attachment, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "attachment",
		parentID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.Attachment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		attachments, err := s.governance.Attachments(ctx, scope, parentType,
			parentID, clampPageSize(pageSize))
		if err != nil {
			return err
		}

		visibleFiles := make([]domain.Attachment, 0, len(attachments))
		withheld := 0
		for _, a := range attachments {
			if !visible(session, a.Confidentiality) {
				withheld++
				continue
			}
			visibleFiles = append(visibleFiles, a)
		}
		out = visibleFiles

		reason := "attachments read"
		if withheld > 0 {
			reason = "attachments read with restricted files withheld"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "attachment", ResourceID: parentID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// GetProvenance returns what is known about where a record came from
// (SRS-CLN-010).
func (s *Service) GetProvenance(ctx context.Context, recordType, recordID string) (
	[]domain.Provenance, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "provenance", recordID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.Provenance
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.governance.Provenance(ctx, scope, recordType, recordID)
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// StoreCalculationInput records one run of a clinical calculator.
type StoreCalculationInput struct {
	PatientID      string
	EncounterID    string
	CalculatorID   string
	Version        string
	Name           string
	Inputs         []domain.CalculatorInput
	Value          float64
	Unit           string
	Interpretation string
	// SupersedesID names an earlier result this rerun replaces. The earlier one
	// stays: recalculation never overwrites history (SRS-CLN-020).
	SupersedesID string
}

// StoreCalculation stores a clinical score (SRS-CLN-020).
//
// Stored rather than recomputed on read. A score rendered on demand changes
// meaning the day the formula is corrected, so a note saying "CHA2DS2-VASc 3"
// would silently become 4 and nobody would know which number the
// anticoagulation decision was made from.
func (s *Service) StoreCalculation(ctx context.Context, in StoreCalculationInput) (
	domain.CalculatorResult, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "calculation",
		in.PatientID, true)
	if err != nil {
		return domain.CalculatorResult{}, err
	}

	now := s.clock.Now()

	var out domain.CalculatorResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		result, err := domain.NewCalculatorResult(s.ids.NewID(), scope.TenantID(),
			domain.NewCalculatorResultInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID,
				CalculatorID: in.CalculatorID, Version: in.Version, Name: in.Name,
				Inputs: in.Inputs, Value: in.Value, Unit: in.Unit,
				Interpretation: in.Interpretation,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}

		// Superseded before the insert so the chain reads forwards and the
		// original is never briefly the only live result for two formulas.
		if in.SupersedesID != "" {
			if err := s.decisions.SupersedeCalculatorResult(ctx, scope,
				in.SupersedesID, result.ID); err != nil {
				return err
			}
		}
		if err := s.decisions.InsertCalculatorResult(ctx, scope, result); err != nil {
			return err
		}

		out = result
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "calculation", ResourceID: result.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  in.CalculatorID + " v" + in.Version,
		}, now)
	})
	if err != nil {
		return domain.CalculatorResult{}, mapConflict(err)
	}
	return out, nil
}

// ListCalculations returns a patient's stored scores, superseded ones included.
//
// Included deliberately: the superseded result is the number a decision was
// made from, and a list that hid it would make the decision inexplicable.
func (s *Service) ListCalculations(ctx context.Context, patientID, calculatorID string,
	pageSize int32) ([]domain.CalculatorResult, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "calculation",
		patientID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.CalculatorResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.decisions.CalculatorResults(ctx, scope, patientID, calculatorID,
			clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RaiseAlertInput records one firing of a decision-support rule.
type RaiseAlertInput struct {
	PatientID   string
	EncounterID string
	RuleID      string
	RuleVersion string
	Level       domain.AlertSeverityLevel
	Message     string
	ContextType string
	ContextID   string
}

// RaiseAlert records a fired decision-support alert (SRS-CLN-021).
func (s *Service) RaiseAlert(ctx context.Context, in RaiseAlertInput) (
	domain.CDSAlert, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "cds_alert",
		in.PatientID, true)
	if err != nil {
		return domain.CDSAlert{}, err
	}

	now := s.clock.Now()

	var out domain.CDSAlert
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		alert, err := domain.NewCDSAlert(s.ids.NewID(), scope.TenantID(),
			domain.NewCDSAlertInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID,
				RuleID: in.RuleID, RuleVersion: in.RuleVersion, Level: in.Level,
				Message: in.Message, ContextType: in.ContextType,
				ContextID: in.ContextID,
			}, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.decisions.InsertAlert(ctx, scope, alert); err != nil {
			return err
		}

		out = alert
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "cds_alert", ResourceID: alert.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  alert.RuleID + " v" + alert.RuleVersion + " fired",
		}, now)
	})
	if err != nil {
		return domain.CDSAlert{}, mapConflict(err)
	}
	return out, nil
}

// RespondToAlertInput records what the clinician did about an alert.
type RespondToAlertInput struct {
	AlertID string
	Outcome domain.CDSOutcome
	// OverrideCode is a chosen reason from the configured list, which is what
	// makes overrides reportable rather than a pile of free text.
	OverrideCode   string
	OverrideReason string
}

// RespondToAlert records the clinician's response (SRS-CLN-021).
func (s *Service) RespondToAlert(ctx context.Context, in RespondToAlertInput) (
	domain.CDSAlert, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "cds_alert",
		in.AlertID, true)
	if err != nil {
		return domain.CDSAlert{}, err
	}

	now := s.clock.Now()

	var out domain.CDSAlert
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		alert, err := s.decisions.GetAlert(ctx, scope, in.AlertID)
		if err != nil {
			return err
		}
		if err := alert.Respond(in.Outcome, in.OverrideCode, in.OverrideReason,
			session.SubjectID, now); err != nil {
			return clinicalError(err)
		}
		if err := s.decisions.RespondToAlert(ctx, scope, alert); err != nil {
			return err
		}

		out = alert
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "cds_alert", ResourceID: alert.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(alert.Outcome) + ": " + alert.OverrideCode,
		}, now)
	})
	if err != nil {
		return domain.CDSAlert{}, mapConflict(err)
	}
	return out, nil
}

// ListAlerts returns fired alerts, which is also the override report
// (SRS-CLN-021).
func (s *Service) ListAlerts(ctx context.Context, q ports.AlertQuery) (
	[]domain.CDSAlert, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "cds_alert",
		q.PatientID, false)
	if err != nil {
		return nil, err
	}
	q.Limit = clampPageSize(q.Limit)

	var out []domain.CDSAlert
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		alerts, err := s.decisions.Alerts(ctx, scope, q)
		if err != nil {
			return err
		}
		out = alerts
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "cds_alert", ResourceID: q.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: "alerts read",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RequestConsultInput asks another service for an opinion.
type RequestConsultInput struct {
	PatientID   string
	EncounterID string
	Specialty   string
	Urgency     domain.ConsultUrgency
	Reason      string
	Question    string
}

// RequestConsult raises a consult (SRS-CLN-022).
func (s *Service) RequestConsult(ctx context.Context, in RequestConsultInput) (
	domain.Consult, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "consult",
		in.PatientID, true)
	if err != nil {
		return domain.Consult{}, err
	}

	now := s.clock.Now()
	urgency := in.Urgency
	if urgency == "" {
		urgency = domain.UrgencyRoutine
	}

	var out domain.Consult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}

		consult, err := domain.NewConsult(s.ids.NewID(), scope.TenantID(),
			in.PatientID, in.EncounterID, in.Specialty, urgency, in.Reason,
			in.Question, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.decisions.InsertConsult(ctx, scope, consult); err != nil {
			return err
		}

		out = consult
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "consult", ResourceID: consult.ID,
			Outcome: audit.OutcomeSuccess,
			// The specialty and urgency, never the clinical question: an audit
			// trail carrying it would be a second copy of the chart.
			Reason: consult.Specialty + ", " + string(consult.Urgency),
		}, now)
	})
	if err != nil {
		return domain.Consult{}, mapConflict(err)
	}
	return out, nil
}

// RespondToConsultInput answers, accepts or declines a consult.
type RespondToConsultInput struct {
	ConsultID string
	// Accept picks the consult up without answering it yet, which is what tells
	// the requester somebody has it.
	Accept bool
	// Response and ResponseDocumentID close the loop.
	Response           string
	ResponseDocumentID string
	// DeclineReason refuses it.
	DeclineReason string
}

// RespondToConsult closes the loop on a consult (SRS-CLN-022).
func (s *Service) RespondToConsult(ctx context.Context, in RespondToConsultInput) (
	domain.Consult, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "consult",
		in.ConsultID, true)
	if err != nil {
		return domain.Consult{}, err
	}

	now := s.clock.Now()

	var out domain.Consult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		consult, err := s.decisions.GetConsult(ctx, scope, in.ConsultID)
		if err != nil {
			return err
		}

		before := consult.Version
		switch {
		case in.DeclineReason != "":
			err = consult.Decline(session.SubjectID, in.DeclineReason, now)
		case in.Accept:
			err = consult.Accept(session.SubjectID, now)
		default:
			err = consult.Answer(session.SubjectID, in.Response,
				in.ResponseDocumentID, now)
		}
		if err != nil {
			return clinicalError(err)
		}

		if err := s.decisions.UpdateConsult(ctx, scope, consult, before); err != nil {
			return err
		}

		if consult.Status == domain.ConsultAnswered {
			// A requester whose system had to poll for the reply is a requester
			// who finds it tomorrow.
			if err := s.appendEvent(ctx, session, EventConsultAnswered, "consult",
				consult.ID, map[string]any{
					"consult_id":   consult.ID,
					"patient_id":   consult.PatientID,
					"encounter_id": consult.EncounterID,
					"specialty":    consult.Specialty,
					"requested_by": consult.RequestedBy,
					"answered_by":  session.SubjectID,
					// The answer itself stays in the chart.
					"has_document": consult.ResponseDocumentID != "",
				}, now); err != nil {
				return err
			}
		}

		out = consult
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "consult", ResourceID: consult.ID,
			Outcome: audit.OutcomeSuccess, Reason: "consult " + string(consult.Status),
		}, now)
	})
	if err != nil {
		return domain.Consult{}, mapConflict(err)
	}
	return out, nil
}

// ListConsults returns the receiving service's worklist, most urgent first.
func (s *Service) ListConsults(ctx context.Context, q ports.ConsultQuery) (
	[]domain.Consult, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "consult", q.PatientID, false)
	if err != nil {
		return nil, err
	}
	q.Limit = clampPageSize(q.Limit)

	var out []domain.Consult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.decisions.Consults(ctx, scope, q)
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// EnrolInRegistryInput adds a patient to a disease registry.
type EnrolInRegistryInput struct {
	PatientID  string
	RegistryID string
	// ProblemID or DiagnosisID is the canonical fact the membership rests on.
	// At least one is required (SRS-CLN-023).
	ProblemID   string
	DiagnosisID string
	EnrolledAt  time.Time
	Consented   bool
}

// EnrolInRegistry adds a patient to a disease registry (SRS-CLN-023).
//
// A pointer, never a copy. A registry holding its own copy of a diagnosis is a
// second version of the patient's record that nobody updates.
func (s *Service) EnrolInRegistry(ctx context.Context, in EnrolInRegistryInput) (
	domain.RegistryMembership, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "registry",
		in.PatientID, true)
	if err != nil {
		return domain.RegistryMembership{}, err
	}

	now := s.clock.Now()

	var out domain.RegistryMembership
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The problem must exist and be this patient's, or the membership
		// points at a fact that is not theirs.
		if in.ProblemID != "" {
			problem, err := s.records.GetProblem(ctx, scope, in.ProblemID)
			if err != nil {
				return err
			}
			if problem.PatientID != in.PatientID {
				return rpcerr.Invalid("CLN_PROBLEM_PATIENT_MISMATCH",
					"that problem belongs to a different patient")
			}
		}

		membership, err := domain.NewRegistryMembership(s.ids.NewID(),
			scope.TenantID(), in.PatientID, in.RegistryID, in.ProblemID,
			in.DiagnosisID, in.EnrolledAt, in.Consented, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.decisions.InsertMembership(ctx, scope, membership); err != nil {
			return err
		}

		out = membership
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "registry", ResourceID: membership.ID,
			Outcome: audit.OutcomeSuccess, Reason: "enrolled in " + in.RegistryID,
		}, now)
	})
	if err != nil {
		return domain.RegistryMembership{}, mapConflict(err)
	}
	return out, nil
}

// ExitRegistry records a patient leaving a registry.
func (s *Service) ExitRegistry(ctx context.Context, membershipID string,
	at time.Time, reason string) error {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "registry",
		membershipID, true)
	if err != nil {
		return err
	}
	if reason == "" {
		return rpcerr.Invalid("CLN_EXIT_NEEDS_REASON", "leaving a registry needs a reason")
	}

	now := s.clock.Now()
	if at.IsZero() {
		at = now
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.decisions.ExitMembership(ctx, scope, membershipID, at,
			reason); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "registry", ResourceID: membershipID,
			Outcome: audit.OutcomeSuccess, Reason: "exited: " + reason,
		}, now)
	})
}

// ListRegistryMemberships returns a patient's registry memberships.
func (s *Service) ListRegistryMemberships(ctx context.Context, patientID,
	registryID string, currentOnly bool, pageSize int32) (
	[]domain.RegistryMembership, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "registry", patientID, false)
	if err != nil {
		return nil, err
	}

	var out []domain.RegistryMembership
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.decisions.Memberships(ctx, scope, patientID, registryID,
			currentOnly, clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// TimelineEntries supplies the clinical half of the longitudinal timeline
// (SRS-ENC-011).
//
// Called by the encounter context through a port. Unfiltered: the
// confidentiality filter is applied there, once, so one rule governs every
// contributing source.
func (s *Service) TimelineEntries(ctx context.Context, patientID string,
	from, until time.Time, pageSize int32) ([]ports.TimelineEntry, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "timeline", patientID, false)
	if err != nil {
		return nil, err
	}

	var out []ports.TimelineEntry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.timeline.Entries(ctx, scope, patientID, from, until,
			clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}
