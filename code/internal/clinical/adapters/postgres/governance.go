package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Provenance, attachments, consents, calculators, alerts, consults and
// registries (SRS-CLN-010, 013, 014, 020 … 023).

// GovernanceRepo implements the provenance, attachment and consent port.
type GovernanceRepo struct{ *Repository }

var _ ports.GovernanceRepository = GovernanceRepo{}

// InsertProvenance records where an imported record came from.
func (r GovernanceRepo) InsertProvenance(ctx context.Context, scope authctx.TenantScope,
	p domain.Provenance) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	provenanceID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("CLN_PROVENANCE_ID_INVALID",
			"provenance_id must be a UUID").WithCause(err)
	}
	recordID, err := uuid.Parse(p.RecordID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertProvenance(ctx, sqlcgen.InsertProvenanceParams{
		ProvenanceID: provenanceID, TenantID: tenantID,
		RecordType: p.RecordType, RecordID: recordID,
		SourceOrganization: p.SourceOrganization, SourceSystem: p.SourceSystem,
		SourceRecordID: p.SourceRecordID, IngestedAt: timestamptz(p.IngestedAt),
		AuthoredAt: timestamptz(p.AuthoredAt), AuthoredBy: p.AuthoredBy,
		Assertion: p.Assertion,
	})
}

// Provenance returns what is known about where a record came from.
func (r GovernanceRepo) Provenance(ctx context.Context, scope authctx.TenantScope,
	recordType, recordID string) ([]domain.Provenance, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(recordID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListProvenance(ctx, sqlcgen.ListProvenanceParams{
		TenantID: tenantID, RecordType: recordType, RecordID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Provenance, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Provenance{
			ID: row.ProvenanceID.String(), TenantID: row.TenantID.String(),
			RecordType: row.RecordType, RecordID: row.RecordID.String(),
			SourceOrganization: row.SourceOrganization,
			SourceSystem:       row.SourceSystem, SourceRecordID: row.SourceRecordID,
			IngestedAt: timeOrZero(row.IngestedAt),
			AuthoredAt: timeOrZero(row.AuthoredAt), AuthoredBy: row.AuthoredBy,
			Assertion: row.Assertion,
		})
	}
	return out, nil
}

// InsertAttachment stores the record of a file held against a clinical record.
func (r GovernanceRepo) InsertAttachment(ctx context.Context, scope authctx.TenantScope,
	a domain.Attachment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	attachmentID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Internal("CLN_ATTACHMENT_ID_INVALID",
			"attachment_id must be a UUID").WithCause(err)
	}
	parentID, err := uuid.Parse(a.ParentID)
	if err != nil {
		return notFound()
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}

	return r.queries(ctx).InsertAttachment(ctx, sqlcgen.InsertAttachmentParams{
		AttachmentID: attachmentID, TenantID: tenantID,
		ParentType: a.ParentType, ParentID: parentID, PatientID: patientID,
		Kind: string(a.Kind), ContentType: a.ContentType,
		StorageKey: a.StorageKey, SizeBytes: a.SizeBytes, Digest: a.Digest,
		Description: a.Description, Confidentiality: string(a.Confidentiality),
		CapturedAt: timestamptz(a.CapturedAt), SourceSystem: a.SourceSystem,
		UploadedBy: a.UploadedBy, UploadedAt: timestamptz(a.UploadedAt),
	})
}

// GetAttachment reads one attachment record.
func (r GovernanceRepo) GetAttachment(ctx context.Context, scope authctx.TenantScope,
	attachmentID string) (domain.Attachment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Attachment{}, err
	}
	id, err := uuid.Parse(attachmentID)
	if err != nil {
		return domain.Attachment{}, notFound()
	}

	row, err := r.queries(ctx).GetAttachment(ctx, sqlcgen.GetAttachmentParams{
		TenantID: tenantID, AttachmentID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Attachment{}, notFound()
	}
	if err != nil {
		return domain.Attachment{}, err
	}
	return attachmentFromRow(sqlcgen.ClinicalAttachment(row)), nil
}

// Attachments returns what is attached to one record.
func (r GovernanceRepo) Attachments(ctx context.Context, scope authctx.TenantScope,
	parentType, parentID string, limit int32) ([]domain.Attachment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parent, err := uuid.Parse(parentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListAttachments(ctx, sqlcgen.ListAttachmentsParams{
		TenantID: tenantID, ParentType: parentType, ParentID: parent,
		PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Attachment, 0, len(rows))
	for _, row := range rows {
		out = append(out, attachmentFromRow(sqlcgen.ClinicalAttachment(row)))
	}
	return out, nil
}

func attachmentFromRow(row sqlcgen.ClinicalAttachment) domain.Attachment {
	return domain.Attachment{
		ID: row.AttachmentID.String(), TenantID: row.TenantID.String(),
		ParentType: row.ParentType, ParentID: row.ParentID.String(),
		PatientID: row.PatientID.String(), Kind: domain.AttachmentKind(row.Kind),
		ContentType: row.ContentType, StorageKey: row.StorageKey,
		SizeBytes: row.SizeBytes, Digest: row.Digest, Description: row.Description,
		Confidentiality: domain.Confidentiality(row.Confidentiality),
		CapturedAt:      timeOrZero(row.CapturedAt), SourceSystem: row.SourceSystem,
		UploadedBy: row.UploadedBy, UploadedAt: timeOrZero(row.UploadedAt),
	}
}

// InsertConsent stores a recorded consent for a clinical act.
func (r GovernanceRepo) InsertConsent(ctx context.Context, scope authctx.TenantScope,
	c domain.ClinicalConsent) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	consentID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("CLN_CONSENT_ID_INVALID",
			"consent_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(c.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(c.EncounterID)
	if err != nil {
		return err
	}
	documentID, err := optionalUUID(c.DocumentID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertClinicalConsent(ctx, sqlcgen.InsertClinicalConsentParams{
		ConsentID: consentID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, Kind: string(c.Kind),
		ProcedureSystem: c.ProcedureCode.System, ProcedureCode: c.ProcedureCode.Code,
		ProcedureDisplay: c.ProcedureCode.Display, Status: string(c.Status),
		GivenBy: string(c.GivenBy), GivenByName: c.GivenByName,
		DocumentID: documentID, WitnessID: c.WitnessID,
		ValidFrom: timestamptz(c.ValidFrom), ValidUntil: timestamptz(c.ValidUntil),
		Note: c.Note, RecordedBy: c.RecordedBy,
		RecordedAt: timestamptz(c.RecordedAt), UpdatedAt: timestamptz(c.UpdatedAt),
	})
}

// SetConsentStatus records a patient changing their mind, or an expiry.
func (r GovernanceRepo) SetConsentStatus(ctx context.Context, scope authctx.TenantScope,
	consentID string, status domain.ConsentStatus, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(consentID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetConsentStatus(ctx, sqlcgen.SetConsentStatusParams{
		TenantID: tenantID, ConsentID: id, Status: string(status),
		UpdatedAt: timestamptz(now),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// Consents returns a patient's clinical consents.
func (r GovernanceRepo) Consents(ctx context.Context, scope authctx.TenantScope,
	patientID string, kind domain.ClinicalConsentKind, limit int32) (
	domain.ConsentSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListClinicalConsents(ctx,
		sqlcgen.ListClinicalConsentsParams{
			TenantID: tenantID, PatientID: patient,
			KindFilter: string(kind), PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make(domain.ConsentSet, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ClinicalConsent{
			ID: row.ConsentID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
			Kind: domain.ClinicalConsentKind(row.Kind),
			ProcedureCode: domain.Coding{
				System: row.ProcedureSystem, Code: row.ProcedureCode,
				Display: row.ProcedureDisplay,
			},
			Status:  domain.ConsentStatus(row.Status),
			GivenBy: domain.GivenBy(row.GivenBy), GivenByName: row.GivenByName,
			DocumentID: uuidOrEmpty(row.DocumentID), WitnessID: row.WitnessID,
			ValidFrom: timeOrZero(row.ValidFrom), ValidUntil: timeOrZero(row.ValidUntil),
			Note: row.Note, RecordedBy: row.RecordedBy,
			RecordedAt: timeOrZero(row.RecordedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		})
	}
	return out, nil
}

// DecisionRepo implements the calculator, alert, consult and registry port.
type DecisionRepo struct{ *Repository }

var _ ports.DecisionRepository = DecisionRepo{}

// InsertCalculatorResult stores one run of a clinical calculator.
func (r DecisionRepo) InsertCalculatorResult(ctx context.Context,
	scope authctx.TenantScope, result domain.CalculatorResult) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	resultID, err := uuid.Parse(result.ID)
	if err != nil {
		return rpcerr.Internal("CLN_RESULT_ID_INVALID",
			"result_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(result.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(result.EncounterID)
	if err != nil {
		return err
	}
	inputs, err := json.Marshal(result.Inputs)
	if err != nil {
		return encodeFailed(err)
	}

	return r.queries(ctx).InsertCalculatorResult(ctx,
		sqlcgen.InsertCalculatorResultParams{
			ResultID: resultID, TenantID: tenantID, PatientID: patientID,
			EncounterID: encounterID, CalculatorID: result.CalculatorID,
			FormulaVersion: result.Version, Name: result.Name, Inputs: inputs,
			Value: result.Value, Unit: result.Unit,
			Interpretation: result.Interpretation,
			CalculatedBy:   result.CalculatedBy,
			CalculatedAt:   timestamptz(result.CalculatedAt),
		})
}

// SupersedeCalculatorResult chains a rerun to the result it replaces.
func (r DecisionRepo) SupersedeCalculatorResult(ctx context.Context,
	scope authctx.TenantScope, resultID, supersededByID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(resultID)
	if err != nil {
		return notFound()
	}
	by, err := optionalUUID(supersededByID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).SupersedeCalculatorResult(ctx,
		sqlcgen.SupersedeCalculatorResultParams{
			TenantID: tenantID, ResultID: id, SupersededByID: by,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("CLN_RESULT_NOT_LIVE",
			"that calculation has already been superseded")
	}
	return nil
}

// CalculatorResults returns a patient's stored scores, newest first.
func (r DecisionRepo) CalculatorResults(ctx context.Context, scope authctx.TenantScope,
	patientID, calculatorID string, limit int32) ([]domain.CalculatorResult, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCalculatorResults(ctx,
		sqlcgen.ListCalculatorResultsParams{
			TenantID: tenantID, PatientID: patient,
			CalculatorFilter: calculatorID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CalculatorResult, 0, len(rows))
	for _, row := range rows {
		result := domain.CalculatorResult{
			ID: row.ResultID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
			CalculatorID: row.CalculatorID, Version: row.FormulaVersion,
			Name: row.Name, Value: row.Value, Unit: row.Unit,
			Interpretation: row.Interpretation,
			SupersededByID: uuidOrEmpty(row.SupersededByID),
			CalculatedBy:   row.CalculatedBy,
			CalculatedAt:   timeOrZero(row.CalculatedAt),
		}
		if err := json.Unmarshal(row.Inputs, &result.Inputs); err != nil {
			return nil, decodeFailed(err)
		}
		out = append(out, result)
	}
	return out, nil
}

// InsertAlert stores one firing of a decision-support rule.
func (r DecisionRepo) InsertAlert(ctx context.Context, scope authctx.TenantScope,
	a domain.CDSAlert) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	alertID, err := uuid.Parse(a.ID)
	if err != nil {
		return rpcerr.Internal("CLN_ALERT_ID_INVALID",
			"alert_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(a.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := optionalUUID(a.EncounterID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertCDSAlert(ctx, sqlcgen.InsertCDSAlertParams{
		AlertID: alertID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, RuleID: a.RuleID, RuleVersion: a.RuleVersion,
		Level: string(a.Level), Message: a.Message,
		ContextType: a.ContextType, ContextID: a.ContextID,
		FiredAt: timestamptz(a.FiredAt),
	})
}

// GetAlert reads one fired alert.
func (r DecisionRepo) GetAlert(ctx context.Context, scope authctx.TenantScope,
	alertID string) (domain.CDSAlert, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CDSAlert{}, err
	}
	id, err := uuid.Parse(alertID)
	if err != nil {
		return domain.CDSAlert{}, notFound()
	}

	row, err := r.queries(ctx).GetCDSAlert(ctx, sqlcgen.GetCDSAlertParams{
		TenantID: tenantID, AlertID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.CDSAlert{}, notFound()
	}
	if err != nil {
		return domain.CDSAlert{}, err
	}
	return alertFromRow(sqlcgen.ClinicalCdsAlert(row)), nil
}

// RespondToAlert records what the clinician did, guarded on still being
// pending.
func (r DecisionRepo) RespondToAlert(ctx context.Context, scope authctx.TenantScope,
	a domain.CDSAlert) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	alertID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).RespondToCDSAlert(ctx, sqlcgen.RespondToCDSAlertParams{
		TenantID: tenantID, AlertID: alertID, Outcome: string(a.Outcome),
		OverrideCode: a.OverrideCode, OverrideReason: a.OverrideReason,
		RespondedBy: a.RespondedBy, RespondedAt: timestamptz(a.RespondedAt),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Answering twice would let a second click rewrite the first
		// clinician's stated reason.
		return rpcerr.FailedPrecondition("CLN_ALERT_ALREADY_ANSWERED",
			"that alert has already been answered")
	}
	return nil
}

// Alerts returns fired alerts, which is also the override report.
func (r DecisionRepo) Alerts(ctx context.Context, scope authctx.TenantScope,
	q ports.AlertQuery) ([]domain.CDSAlert, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patientID, err := optionalUUID(q.PatientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListCDSAlerts(ctx, sqlcgen.ListCDSAlertsParams{
		TenantID: tenantID, PatientID: patientID,
		OutcomeFilter: string(q.Outcome), RuleFilter: q.RuleID, PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CDSAlert, 0, len(rows))
	for _, row := range rows {
		out = append(out, alertFromRow(sqlcgen.ClinicalCdsAlert(row)))
	}
	return out, nil
}

func alertFromRow(row sqlcgen.ClinicalCdsAlert) domain.CDSAlert {
	return domain.CDSAlert{
		ID: row.AlertID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: uuidOrEmpty(row.EncounterID),
		RuleID: row.RuleID, RuleVersion: row.RuleVersion,
		Level: domain.AlertSeverityLevel(row.Level), Message: row.Message,
		ContextType: row.ContextType, ContextID: row.ContextID,
		Outcome:      domain.CDSOutcome(row.Outcome),
		OverrideCode: row.OverrideCode, OverrideReason: row.OverrideReason,
		FiredAt: timeOrZero(row.FiredAt), RespondedBy: row.RespondedBy,
		RespondedAt: timeOrZero(row.RespondedAt),
	}
}

// InsertConsult stores a request for another service's opinion.
func (r DecisionRepo) InsertConsult(ctx context.Context, scope authctx.TenantScope,
	c domain.Consult) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	consultID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("CLN_CONSULT_ID_INVALID",
			"consult_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(c.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := uuid.Parse(c.EncounterID)
	if err != nil {
		return rpcerr.Invalid("CLN_ENCOUNTER_ID_INVALID", "encounter_id must be a UUID")
	}

	return r.queries(ctx).InsertConsult(ctx, sqlcgen.InsertConsultParams{
		ConsultID: consultID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, Specialty: c.Specialty,
		Urgency: string(c.Urgency), Reason: c.Reason, Question: c.Question,
		Status: string(c.Status), RequestedBy: c.RequestedBy,
		RequestedAt: timestamptz(c.RequestedAt), UpdatedAt: timestamptz(c.UpdatedAt),
	})
}

// GetConsult reads one request.
func (r DecisionRepo) GetConsult(ctx context.Context, scope authctx.TenantScope,
	consultID string) (domain.Consult, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Consult{}, err
	}
	id, err := uuid.Parse(consultID)
	if err != nil {
		return domain.Consult{}, notFound()
	}

	row, err := r.queries(ctx).GetConsult(ctx, sqlcgen.GetConsultParams{
		TenantID: tenantID, ConsultID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Consult{}, notFound()
	}
	if err != nil {
		return domain.Consult{}, err
	}
	return consultFromRow(sqlcgen.ClinicalConsult(row)), nil
}

// UpdateConsult writes an acceptance, an answer or a decline back.
func (r DecisionRepo) UpdateConsult(ctx context.Context, scope authctx.TenantScope,
	c domain.Consult, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	consultID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	documentID, err := optionalUUID(c.ResponseDocumentID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateConsult(ctx, sqlcgen.UpdateConsultParams{
		TenantID: tenantID, ConsultID: consultID, Status: string(c.Status),
		RespondingSubjectID: c.RespondingSubjectID, Response: c.Response,
		ResponseDocumentID: documentID, DeclineReason: c.DeclineReason,
		RespondedAt: timestamptz(c.RespondedAt),
		UpdatedAt:   timestamptz(c.UpdatedAt), ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Consults returns the receiving service's worklist, most urgent first.
func (r DecisionRepo) Consults(ctx context.Context, scope authctx.TenantScope,
	q ports.ConsultQuery) ([]domain.Consult, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patientID, err := optionalUUID(q.PatientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListConsults(ctx, sqlcgen.ListConsultsParams{
		TenantID: tenantID, PatientID: patientID,
		SpecialtyFilter: q.Specialty, OpenOnly: q.OpenOnly, PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Consult, 0, len(rows))
	for _, row := range rows {
		out = append(out, consultFromRow(sqlcgen.ClinicalConsult(row)))
	}
	return out, nil
}

func consultFromRow(row sqlcgen.ClinicalConsult) domain.Consult {
	return domain.Consult{
		ID: row.ConsultID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		Specialty: row.Specialty, Urgency: domain.ConsultUrgency(row.Urgency),
		Reason: row.Reason, Question: row.Question,
		Status:              domain.ConsultStatus(row.Status),
		RespondingSubjectID: row.RespondingSubjectID, Response: row.Response,
		ResponseDocumentID: uuidOrEmpty(row.ResponseDocumentID),
		DeclineReason:      row.DeclineReason, RequestedBy: row.RequestedBy,
		RequestedAt: timeOrZero(row.RequestedAt),
		RespondedAt: timeOrZero(row.RespondedAt),
		UpdatedAt:   timeOrZero(row.UpdatedAt), Version: row.Version,
	}
}

// InsertMembership enrols a patient in a registry.
func (r DecisionRepo) InsertMembership(ctx context.Context, scope authctx.TenantScope,
	m domain.RegistryMembership) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	membershipID, err := uuid.Parse(m.ID)
	if err != nil {
		return rpcerr.Internal("CLN_MEMBERSHIP_ID_INVALID",
			"membership_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(m.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	problemID, err := optionalUUID(m.ProblemID)
	if err != nil {
		return err
	}
	diagnosisID, err := optionalUUID(m.DiagnosisID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRegistryMembership(ctx,
		sqlcgen.InsertRegistryMembershipParams{
			MembershipID: membershipID, TenantID: tenantID, PatientID: patientID,
			RegistryID: m.RegistryID, ProblemID: problemID, DiagnosisID: diagnosisID,
			EnrolledAt: timestamptz(m.EnrolledAt), Consented: m.Consented,
			EnrolledBy: m.EnrolledBy, RecordedAt: timestamptz(m.RecordedAt),
		})
}

// ExitMembership records a patient leaving a registry.
func (r DecisionRepo) ExitMembership(ctx context.Context, scope authctx.TenantScope,
	membershipID string, at time.Time, reason string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(membershipID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ExitRegistryMembership(ctx,
		sqlcgen.ExitRegistryMembershipParams{
			TenantID: tenantID, MembershipID: id,
			ExitedAt: timestamptz(at), ExitReason: reason,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("CLN_MEMBERSHIP_NOT_CURRENT",
			"that membership has already ended")
	}
	return nil
}

// Memberships returns a patient's registry memberships.
func (r DecisionRepo) Memberships(ctx context.Context, scope authctx.TenantScope,
	patientID, registryID string, currentOnly bool, limit int32) (
	[]domain.RegistryMembership, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := optionalUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListRegistryMemberships(ctx,
		sqlcgen.ListRegistryMembershipsParams{
			TenantID: tenantID, PatientID: patient, RegistryFilter: registryID,
			CurrentOnly: currentOnly, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.RegistryMembership, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.RegistryMembership{
			ID: row.MembershipID.String(), TenantID: row.TenantID.String(),
			PatientID: row.PatientID.String(), RegistryID: row.RegistryID,
			ProblemID:   uuidOrEmpty(row.ProblemID),
			DiagnosisID: uuidOrEmpty(row.DiagnosisID),
			EnrolledAt:  timeOrZero(row.EnrolledAt),
			ExitedAt:    timeOrZero(row.ExitedAt), ExitReason: row.ExitReason,
			Consented: row.Consented, EnrolledBy: row.EnrolledBy,
			RecordedAt: timeOrZero(row.RecordedAt),
		})
	}
	return out, nil
}
