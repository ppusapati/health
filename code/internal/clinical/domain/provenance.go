package domain

import (
	"fmt"
	"strings"
	"time"
)

// Provenance, attachments and clinical consent
// (SRS-CLN-010, SRS-CLN-013, SRS-CLN-014).

// Provenance is where an imported record came from (SRS-CLN-010).
//
// The acceptance criterion is that "external data is distinguishable from
// locally authored data", and the reason is a clinical one: a clinician reading
// a result reasons differently about one their own laboratory produced and one
// that arrived in a summary from another hospital. Losing that distinction
// makes every imported value look like a local measurement, which is how a
// six-month-old creatinine from elsewhere gets treated as today's.
type Provenance struct {
	ID       string
	TenantID string
	// RecordType and RecordID name what this describes.
	RecordType string
	RecordID   string
	// SourceOrganization is the hospital, laboratory or registry it came from.
	SourceOrganization string
	// SourceSystem is the software that sent it, which is what an integration
	// team needs when the data is wrong.
	SourceSystem string
	// SourceRecordID is the identifier it had there, so a duplicate arriving
	// twice can be recognised.
	SourceRecordID string
	// IngestedAt is when it arrived here. Distinct from when it was true of
	// the patient, and both matter: a result from March that arrived in
	// September was not available to the clinician who saw the patient in June.
	IngestedAt time.Time
	// AuthoredAt is when the source says it was written.
	AuthoredAt time.Time
	// AuthoredBy is who the source says wrote it. A string rather than a
	// subject id: they are not a user of this system, and pretending otherwise
	// would make an external author indistinguishable from a local one in every
	// query that joins on identity.
	AuthoredBy string
	// Assertion is what the source claimed about the data's status.
	Assertion string
}

// NewProvenance validates and constructs a provenance record.
func NewProvenance(id, tenantID, recordType, recordID string, in ProvenanceInput,
	now time.Time) (Provenance, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Provenance{}, fmt.Errorf("%w: provenance id is required", ErrInvalidDocument)
	case strings.TrimSpace(recordType) == "" || strings.TrimSpace(recordID) == "":
		return Provenance{}, fmt.Errorf("%w: provenance needs the record it describes",
			ErrInvalidDocument)
	case strings.TrimSpace(in.SourceOrganization) == "":
		// Without the organisation this says "it came from outside", which
		// tells a clinician nothing they can weigh.
		return Provenance{}, fmt.Errorf("%w: provenance needs the organisation it came from",
			ErrInvalidDocument)
	}

	ingested := in.IngestedAt
	if ingested.IsZero() {
		ingested = now
	}

	return Provenance{
		ID: id, TenantID: tenantID, RecordType: recordType, RecordID: recordID,
		SourceOrganization: in.SourceOrganization, SourceSystem: in.SourceSystem,
		SourceRecordID: in.SourceRecordID, IngestedAt: ingested.UTC(),
		AuthoredAt: in.AuthoredAt.UTC(), AuthoredBy: in.AuthoredBy,
		Assertion: in.Assertion,
	}, nil
}

// ProvenanceInput is what recording provenance needs.
type ProvenanceInput struct {
	SourceOrganization string
	SourceSystem       string
	SourceRecordID     string
	IngestedAt         time.Time
	AuthoredAt         time.Time
	AuthoredBy         string
	Assertion          string
}

// AttachmentKind is what sort of file is attached (SRS-CLN-014).
type AttachmentKind string

const (
	AttachmentImage    AttachmentKind = "image"
	AttachmentDocument AttachmentKind = "document"
	AttachmentAudio    AttachmentKind = "audio"
	AttachmentVideo    AttachmentKind = "video"
	// AttachmentWaveform is an ECG trace or similar.
	AttachmentWaveform AttachmentKind = "waveform"
)

var knownAttachmentKinds = map[AttachmentKind]bool{
	AttachmentImage: true, AttachmentDocument: true, AttachmentAudio: true,
	AttachmentVideo: true, AttachmentWaveform: true,
}

// Attachment is a file held against a clinical record (SRS-CLN-014).
//
// The bytes live in object storage; this is the record that says what they are
// and who may see them. The acceptance criterion is that "attachment access
// follows parent record and classification", which is two rules: you need
// access to the thing it is attached to, *and* you need to clear its own
// confidentiality class — a photograph of an injury attached to an ordinary
// note can be more sensitive than the note.
type Attachment struct {
	ID       string
	TenantID string
	// ParentType and ParentID are what it is attached to.
	ParentType string
	ParentID   string
	PatientID  string
	Kind       AttachmentKind
	// ContentType is the media type, used to decide what a viewer may render.
	ContentType string
	// StorageKey locates the bytes. Opaque: a key that encoded the patient
	// would leak in every log line that carried it.
	StorageKey string
	SizeBytes  int64
	// Digest pins the bytes, so a viewer can tell that what it fetched is what
	// was attached.
	Digest string
	// Description is what a clinician sees in a list.
	Description string
	// Confidentiality is the attachment's own, which may be tighter than its
	// parent's.
	Confidentiality Confidentiality
	// CapturedAt is when the image or recording was made, which is not when it
	// was uploaded.
	CapturedAt time.Time
	// SourceSystem marks an imported attachment (SRS-CLN-010).
	SourceSystem string

	UploadedBy string
	UploadedAt time.Time
}

// MaxAttachmentBytes bounds one file. Large enough for a chest radiograph,
// small enough that one upload cannot exhaust a node's disk.
const MaxAttachmentBytes = 100 << 20

// NewAttachment validates and constructs an attachment record.
func NewAttachment(id, tenantID string, in NewAttachmentInput, uploadedBy string,
	now time.Time) (Attachment, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Attachment{}, fmt.Errorf("%w: attachment id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.ParentType) == "" || strings.TrimSpace(in.ParentID) == "":
		return Attachment{}, fmt.Errorf("%w: an attachment needs a record to attach to",
			ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return Attachment{}, fmt.Errorf("%w: an attachment needs a patient",
			ErrInvalidDocument)
	case !knownAttachmentKinds[in.Kind]:
		return Attachment{}, fmt.Errorf("%w: unknown attachment kind %q",
			ErrInvalidDocument, in.Kind)
	case strings.TrimSpace(in.ContentType) == "":
		return Attachment{}, fmt.Errorf("%w: an attachment needs a media type",
			ErrInvalidDocument)
	case strings.TrimSpace(in.StorageKey) == "":
		return Attachment{}, fmt.Errorf("%w: an attachment needs somewhere its bytes live",
			ErrInvalidDocument)
	case in.SizeBytes <= 0:
		return Attachment{}, fmt.Errorf("%w: an empty attachment is not an attachment",
			ErrInvalidDocument)
	case in.SizeBytes > MaxAttachmentBytes:
		return Attachment{}, fmt.Errorf("%w: the attachment is larger than %d bytes",
			ErrInvalidDocument, MaxAttachmentBytes)
	case !in.Confidentiality.Known():
		return Attachment{}, fmt.Errorf("%w: unknown confidentiality class %q",
			ErrInvalidDocument, in.Confidentiality)
	case strings.TrimSpace(uploadedBy) == "":
		return Attachment{}, fmt.Errorf("%w: an attachment must record who uploaded it",
			ErrInvalidDocument)
	}

	captured := in.CapturedAt
	if captured.IsZero() {
		captured = now
	}

	return Attachment{
		ID: id, TenantID: tenantID, ParentType: in.ParentType, ParentID: in.ParentID,
		PatientID: in.PatientID, Kind: in.Kind, ContentType: in.ContentType,
		StorageKey: in.StorageKey, SizeBytes: in.SizeBytes, Digest: in.Digest,
		Description:     strings.TrimSpace(in.Description),
		Confidentiality: in.Confidentiality, CapturedAt: captured.UTC(),
		SourceSystem: in.SourceSystem,
		UploadedBy:   uploadedBy, UploadedAt: now.UTC(),
	}, nil
}

// NewAttachmentInput is what attaching a file needs.
type NewAttachmentInput struct {
	ParentType      string
	ParentID        string
	PatientID       string
	Kind            AttachmentKind
	ContentType     string
	StorageKey      string
	SizeBytes       int64
	Digest          string
	Description     string
	Confidentiality Confidentiality
	CapturedAt      time.Time
	SourceSystem    string
}

// ClinicalConsentKind is what a clinical consent covers (SRS-CLN-013).
//
// Deliberately not the privacy consent of SRS-EMPI-013. The requirement is
// explicit that the two must not be conflated, and the reason is that they
// answer different questions: a privacy consent says who may see the record,
// and a clinical consent says whether a thing may be done to the patient.
// Conflating them produces a system where withdrawing a marketing preference
// cancels an operation.
type ClinicalConsentKind string

const (
	ConsentProcedure   ClinicalConsentKind = "procedure"
	ConsentAnaesthesia ClinicalConsentKind = "anaesthesia"
	ConsentTransfusion ClinicalConsentKind = "transfusion"
	ConsentPhotography ClinicalConsentKind = "photography"
	ConsentResearch    ClinicalConsentKind = "research"
	ConsentTreatment   ClinicalConsentKind = "treatment"
)

var knownConsentKinds = map[ClinicalConsentKind]bool{
	ConsentProcedure: true, ConsentAnaesthesia: true, ConsentTransfusion: true,
	ConsentPhotography: true, ConsentResearch: true, ConsentTreatment: true,
}

// ConsentStatus is where a consent stands.
type ConsentStatus string

const (
	ConsentGiven ConsentStatus = "given"
	// ConsentRefused is a recorded refusal, which is not the same as an absent
	// consent: one says the patient declined and the other says nobody asked.
	ConsentRefused   ConsentStatus = "refused"
	ConsentWithdrawn ConsentStatus = "withdrawn"
	ConsentExpired   ConsentStatus = "expired"
)

var knownConsentStatuses = map[ConsentStatus]bool{
	ConsentGiven: true, ConsentRefused: true,
	ConsentWithdrawn: true, ConsentExpired: true,
}

// GivenBy is who gave the consent.
//
// Recorded because a consent given by a parent for a child, or by a legal
// representative for somebody without capacity, is a different fact from one
// the patient gave, and the difference is what a court asks about.
type GivenBy string

const (
	GivenByPatient        GivenBy = "patient"
	GivenByParent         GivenBy = "parent"
	GivenByLegalGuardian  GivenBy = "legal_guardian"
	GivenByRepresentative GivenBy = "representative"
)

var knownGivenBy = map[GivenBy]bool{
	GivenByPatient: true, GivenByParent: true,
	GivenByLegalGuardian: true, GivenByRepresentative: true,
}

// ClinicalConsent is a recorded consent for a clinical act (SRS-CLN-013).
type ClinicalConsent struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Kind        ClinicalConsentKind
	// ProcedureCode narrows a procedure consent to the specific operation. A
	// consent for "a procedure" is not a consent for any procedure.
	ProcedureCode Coding
	Status        ConsentStatus
	GivenBy       GivenBy
	// GivenByName is the representative's name where the consent was not the
	// patient's own.
	GivenByName string
	// DocumentID links to the signed consent form.
	DocumentID string
	// WitnessID is who witnessed the discussion, where one did.
	WitnessID string
	// ValidFrom and ValidUntil bound it. A consent with no expiry for an
	// operation that happens two years later is a consent to something the
	// patient no longer remembers agreeing to.
	ValidFrom  time.Time
	ValidUntil time.Time
	Note       string

	RecordedBy string
	RecordedAt time.Time
	UpdatedAt  time.Time
}

// NewClinicalConsent validates and constructs a consent record.
func NewClinicalConsent(id, tenantID string, in NewConsentInput, recordedBy string,
	now time.Time) (ClinicalConsent, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ClinicalConsent{}, fmt.Errorf("%w: consent id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return ClinicalConsent{}, fmt.Errorf("%w: a consent needs a patient",
			ErrInvalidDocument)
	case !knownConsentKinds[in.Kind]:
		return ClinicalConsent{}, fmt.Errorf("%w: unknown consent kind %q",
			ErrInvalidDocument, in.Kind)
	case !knownConsentStatuses[in.Status]:
		return ClinicalConsent{}, fmt.Errorf("%w: unknown consent status %q",
			ErrInvalidDocument, in.Status)
	case !knownGivenBy[in.GivenBy]:
		return ClinicalConsent{}, fmt.Errorf("%w: unknown consent giver %q",
			ErrInvalidDocument, in.GivenBy)
	case in.GivenBy != GivenByPatient && strings.TrimSpace(in.GivenByName) == "":
		// A consent given on somebody's behalf must name who gave it, or the
		// record cannot answer the question a court asks first.
		return ClinicalConsent{}, fmt.Errorf(
			"%w: a consent given on the patient's behalf must name who gave it",
			ErrInvalidDocument)
	case strings.TrimSpace(recordedBy) == "":
		return ClinicalConsent{}, fmt.Errorf("%w: a consent must record who took it",
			ErrInvalidDocument)
	}

	if in.Kind == ConsentProcedure && in.ProcedureCode.Empty() {
		// A consent for "a procedure" is not a consent for any procedure.
		return ClinicalConsent{}, fmt.Errorf(
			"%w: a procedure consent must name the procedure", ErrInvalidDocument)
	}
	if !in.ProcedureCode.Empty() {
		if err := in.ProcedureCode.Validate(); err != nil {
			return ClinicalConsent{}, err
		}
	}

	validFrom := in.ValidFrom
	if validFrom.IsZero() {
		validFrom = now
	}
	if !in.ValidUntil.IsZero() && !in.ValidUntil.After(validFrom) {
		return ClinicalConsent{}, fmt.Errorf("%w: a consent must expire after it begins",
			ErrInvalidDocument)
	}

	return ClinicalConsent{
		ID: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, Kind: in.Kind, ProcedureCode: in.ProcedureCode,
		Status: in.Status, GivenBy: in.GivenBy, GivenByName: in.GivenByName,
		DocumentID: in.DocumentID, WitnessID: in.WitnessID,
		ValidFrom: validFrom.UTC(), ValidUntil: in.ValidUntil.UTC(),
		Note:       strings.TrimSpace(in.Note),
		RecordedBy: recordedBy, RecordedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// NewConsentInput is what recording a consent needs.
type NewConsentInput struct {
	PatientID     string
	EncounterID   string
	Kind          ClinicalConsentKind
	ProcedureCode Coding
	Status        ConsentStatus
	GivenBy       GivenBy
	GivenByName   string
	DocumentID    string
	WitnessID     string
	ValidFrom     time.Time
	ValidUntil    time.Time
	Note          string
}

// Permits reports whether this consent authorises an act at an instant.
func (c ClinicalConsent) Permits(at time.Time) bool {
	if c.Status != ConsentGiven {
		return false
	}
	if at.Before(c.ValidFrom) {
		return false
	}
	return c.ValidUntil.IsZero() || at.Before(c.ValidUntil)
}

// Withdraw records a patient changing their mind.
func (c *ClinicalConsent) Withdraw(now time.Time) {
	c.Status = ConsentWithdrawn
	c.UpdatedAt = now.UTC()
}

// ConsentSet is a patient's clinical consents.
type ConsentSet []ClinicalConsent

// Permits reports whether an act of a kind is consented at an instant
// (SRS-CLN-013).
//
// Deny by default, and a procedure consent must match the procedure: an absent
// consent means nobody asked, and proceeding on the grounds that the patient
// never said no is how an operation happens without agreement.
func (s ConsentSet) Permits(kind ClinicalConsentKind, procedure Coding,
	at time.Time) bool {

	for _, c := range s {
		if c.Kind != kind || !c.Permits(at) {
			continue
		}
		if kind == ConsentProcedure {
			if c.ProcedureCode.System != procedure.System ||
				c.ProcedureCode.Code != procedure.Code {
				continue
			}
		}
		return true
	}
	return false
}

// Refused reports a recorded refusal, which a UI must distinguish from nobody
// having asked.
func (s ConsentSet) Refused(kind ClinicalConsentKind, at time.Time) bool {
	for _, c := range s {
		if c.Kind == kind && c.Status == ConsentRefused {
			return true
		}
	}
	return false
}
