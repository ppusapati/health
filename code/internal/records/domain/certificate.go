package domain

import (
	"fmt"
	"strings"
	"time"
)

// CertificateKind is which statutory document this is (SRS-MRD-007).
type CertificateKind string

const (
	CertificateBirth CertificateKind = "birth"
	CertificateDeath CertificateKind = "death"
	// CertificateStillbirth is its own kind and not a death certificate with
	// a flag. The form is different, the statutory route is different, and a
	// system that folded them together would produce the wrong document at
	// the worst possible moment.
	CertificateStillbirth CertificateKind = "stillbirth"
	// CertificateMedical is a fitness, sickness or disability certificate.
	CertificateMedical CertificateKind = "medical"
	// CertificateCauseOfDeath is the clinical cause statement that
	// accompanies a death certificate where the jurisdiction separates them.
	CertificateCauseOfDeath CertificateKind = "cause_of_death"
)

var knownCertificateKind = map[CertificateKind]bool{
	CertificateBirth: true, CertificateDeath: true,
	CertificateStillbirth: true, CertificateMedical: true,
	CertificateCauseOfDeath: true,
}

// CertificateField is one configured field of a statutory form
// (SRS-MRD-007).
//
// Configured rather than modelled, because the fields of a death certificate
// are set by a jurisdiction's registrar and differ between them. A hospital
// group operating in two states needs two forms, and hard-coding one of them
// means the other is wrong.
type CertificateField struct {
	Code     string
	Label    string
	Required bool
	// SourcePath names where the value comes from in the hospital's own
	// records — the patient's date of birth, the encounter's discharge
	// disposition. Recorded so a later question about a certificate can be
	// answered from the record rather than from memory.
	SourcePath string
}

// CertificateForm is a configured statutory document (SRS-MRD-007).
//
// Versioned by (code, revision). A form changed in place would make every
// certificate issued under the old one unexplainable, and these are documents
// that turn up in court a decade later.
type CertificateForm struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	Kind         CertificateKind
	Jurisdiction string
	Fields       []CertificateField

	// IssuerRole is who may sign this form — a registered medical
	// practitioner, a specified officer. Held because "who may issue this"
	// is a statutory question and not a permission the hospital invents.
	IssuerRole string

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a form in force at a moment.
func (f CertificateForm) Live(at time.Time) bool {
	if !f.Approved {
		return false
	}
	if f.EffectiveFrom.IsZero() || f.EffectiveFrom.After(at) {
		return false
	}
	return f.SupersededAt.IsZero() || f.SupersededAt.After(at)
}

// NewCertificateFormInput configures a statutory form.
type NewCertificateFormInput struct {
	Code          string
	Name          string
	Revision      int
	Kind          CertificateKind
	Jurisdiction  string
	Fields        []CertificateField
	IssuerRole    string
	EffectiveFrom time.Time
}

// NewCertificateForm configures a statutory document (SRS-MRD-007).
func NewCertificateForm(id, tenantID string, in NewCertificateFormInput,
	by string, now time.Time) (CertificateForm, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CertificateForm{}, fmt.Errorf("%w: a form needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Code) == "":
		return CertificateForm{}, fmt.Errorf("%w: a form needs a code",
			ErrInvalidRecord)
	case in.Revision <= 0:
		return CertificateForm{}, fmt.Errorf("%w: a form revision starts at 1",
			ErrInvalidRecord)
	case !knownCertificateKind[in.Kind]:
		return CertificateForm{}, fmt.Errorf("%w: unknown certificate kind %q",
			ErrInvalidRecord, in.Kind)
	case strings.TrimSpace(in.Jurisdiction) == "":
		return CertificateForm{}, fmt.Errorf(
			"%w: a statutory form names its jurisdiction", ErrInvalidRecord)
	case len(in.Fields) == 0:
		return CertificateForm{}, fmt.Errorf("%w: a form with no fields",
			ErrInvalidRecord)
	case strings.TrimSpace(in.IssuerRole) == "":
		// Who may sign is a statutory question, not one the hospital invents
		// at issue time.
		return CertificateForm{}, fmt.Errorf(
			"%w: a form names the role that may issue it", ErrInvalidRecord)
	}

	seen := map[string]bool{}
	fields := make([]CertificateField, 0, len(in.Fields))
	for _, field := range in.Fields {
		code := strings.TrimSpace(field.Code)
		switch {
		case code == "":
			return CertificateForm{}, fmt.Errorf("%w: a field needs a code",
				ErrInvalidRecord)
		case seen[strings.ToLower(code)]:
			return CertificateForm{}, fmt.Errorf(
				"%w: field %s appears twice", ErrInvalidRecord, code)
		}
		seen[strings.ToLower(code)] = true
		field.Code = code
		field.Label = strings.TrimSpace(field.Label)
		if field.Label == "" {
			field.Label = code
		}
		field.SourcePath = strings.TrimSpace(field.SourcePath)
		fields = append(fields, field)
	}

	return CertificateForm{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision: in.Revision, Kind: in.Kind,
		Jurisdiction: strings.TrimSpace(in.Jurisdiction), Fields: fields,
		IssuerRole:    strings.TrimSpace(in.IssuerRole),
		EffectiveFrom: utcOrZero(in.EffectiveFrom),
		CreatedAt:     now.UTC(), CreatedBy: by,
	}, nil
}

// Approve puts a statutory form in force (SRS-MRD-007).
func (f *CertificateForm) Approve(by string, effectiveFrom,
	now time.Time) error {

	switch {
	case f.Approved:
		return fmt.Errorf("%w: this form is already approved", ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidRecord)
	case by == f.CreatedBy:
		return fmt.Errorf("%w: the author of a form cannot approve it",
			ErrInvalidRecord)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved form names when it takes effect",
			ErrInvalidRecord)
	}
	f.Approved, f.ApprovedBy, f.ApprovedAt = true, by, now.UTC()
	f.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// CertificateVersion is one issued version of a certificate (SRS-MRD-007).
//
// Append-only. A death certificate corrected after issue is a new version
// that keeps the first: the first one went to a family and to a registrar,
// and a system that overwrote it could not say what they hold.
type CertificateVersion struct {
	Version int
	// Values are the completed fields, keyed by the form's field codes.
	Values map[string]string
	// SourceRefs record where the values came from — the encounter, the
	// patient record, the clinical document naming the cause. SRS-MRD-007's
	// acceptance requires source data, and a certificate whose facts cannot
	// be traced back is one nobody can defend.
	SourceRefs map[string]string

	// Reason is why this version exists. Required from version 2: the first
	// is the certificate and every one after it is a correction somebody has
	// to be able to question.
	Reason string

	IssuerID   string
	IssuerName string
	IssuerRole string
	IssuedAt   time.Time
	// SerialNumber is the statutory serial where the jurisdiction issues one.
	SerialNumber string
}

// CertificateState is where an issued certificate stands.
type CertificateState string

const (
	CertificateIssued CertificateState = "issued"
	// CertificateVoided was issued in error and withdrawn. The versions stay.
	CertificateVoided CertificateState = "voided"
)

// StatutoryCertificate is one issued certificate and its corrections
// (SRS-MRD-007).
type StatutoryCertificate struct {
	ID       string
	TenantID string

	Kind CertificateKind
	// FormCode and FormRevision pin the version of the form it was issued
	// against.
	FormCode     string
	FormRevision int
	Jurisdiction string

	PatientID   string
	EncounterID string

	Versions []CertificateVersion

	State      CertificateState
	VoidReason string
	VoidedBy   string
	VoidedAt   time.Time

	CreatedAt time.Time
	Version   int64
}

// Current is the version in force.
func (c StatutoryCertificate) Current() (CertificateVersion, bool) {
	if len(c.Versions) == 0 {
		return CertificateVersion{}, false
	}
	return c.Versions[len(c.Versions)-1], true
}

// Issuer is who the caller says signed the certificate.
type Issuer struct {
	SubjectID string
	Name      string
	// Role is checked against the form's IssuerRole. A hospital cannot make
	// somebody eligible to sign a death certificate by giving them a
	// permission.
	Role string
}

// IssueCertificate issues a statutory document (SRS-MRD-007).
//
// The form has to be in force, every required field has to be present, the
// issuer's role has to be the one the form names, and every value has to be
// traceable to a source. Each of those is a way a certificate is issued that
// a registrar later rejects, and the cost of the rejection falls on a family.
func IssueCertificate(id, tenantID string, form CertificateForm,
	patientID, encounterID string, values, sourceRefs map[string]string,
	issuer Issuer, serialNumber string, now time.Time) (
	StatutoryCertificate, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return StatutoryCertificate{}, fmt.Errorf(
			"%w: a certificate needs an id", ErrInvalidRecord)
	case !form.Live(now):
		return StatutoryCertificate{}, fmt.Errorf(
			"%w: form %s revision %d is not approved and in force",
			ErrInvalidRecord, form.Code, form.Revision)
	case strings.TrimSpace(patientID) == "":
		return StatutoryCertificate{}, fmt.Errorf(
			"%w: a certificate names its subject", ErrInvalidRecord)
	case strings.TrimSpace(issuer.SubjectID) == "":
		return StatutoryCertificate{}, fmt.Errorf(
			"%w: a certificate names who issued it", ErrInvalidRecord)
	case !strings.EqualFold(issuer.Role, form.IssuerRole):
		return StatutoryCertificate{}, fmt.Errorf(
			"%w: form %s is issued by a %s, not a %s",
			ErrInvalidRecord, form.Code, form.IssuerRole, issuer.Role)
	}

	completed, refs, err := completeForm(form, values, sourceRefs)
	if err != nil {
		return StatutoryCertificate{}, err
	}

	return StatutoryCertificate{
		ID: id, TenantID: tenantID, Kind: form.Kind,
		FormCode: form.Code, FormRevision: form.Revision,
		Jurisdiction: form.Jurisdiction,
		PatientID:    patientID, EncounterID: encounterID,
		Versions: []CertificateVersion{{
			Version: 1, Values: completed, SourceRefs: refs,
			IssuerID: issuer.SubjectID, IssuerName: issuer.Name,
			IssuerRole: issuer.Role, IssuedAt: now.UTC(),
			SerialNumber: strings.TrimSpace(serialNumber),
		}},
		State: CertificateIssued, CreatedAt: now.UTC(), Version: 1,
	}, nil
}

func completeForm(form CertificateForm, values,
	sourceRefs map[string]string) (map[string]string, map[string]string,
	error) {

	completed := map[string]string{}
	refs := map[string]string{}
	known := map[string]bool{}

	for _, field := range form.Fields {
		known[field.Code] = true
		value := strings.TrimSpace(values[field.Code])
		if field.Required && value == "" {
			return nil, nil, fmt.Errorf("%w: %s is required on form %s",
				ErrInvalidRecord, field.Label, form.Code)
		}
		if value == "" {
			continue
		}
		completed[field.Code] = value
		if ref := strings.TrimSpace(sourceRefs[field.Code]); ref != "" {
			refs[field.Code] = ref
		} else if field.SourcePath != "" {
			// The form says this field comes from the record, and the caller
			// did not say which record. A certificate whose facts cannot be
			// traced back is one nobody can defend at an inquest.
			return nil, nil, fmt.Errorf(
				"%w: %s comes from %s and no source was named",
				ErrInvalidRecord, field.Label, field.SourcePath)
		}
	}

	for code := range values {
		if !known[code] {
			// A value the form has no field for would be dropped silently,
			// and the person who typed it would believe it was on the
			// certificate.
			return nil, nil, fmt.Errorf("%w: form %s has no field %q",
				ErrInvalidRecord, form.Code, code)
		}
	}
	return completed, refs, nil
}

// Correct issues a corrected version (SRS-MRD-007).
//
// A new version, never an edit. The first version went to a family and to a
// registrar, and a hospital asked six months later what it issued has to be
// able to produce both.
func (c *StatutoryCertificate) Correct(form CertificateForm, values,
	sourceRefs map[string]string, issuer Issuer, reason, serialNumber string,
	now time.Time) error {

	current, ok := c.Current()
	switch {
	case !ok:
		return fmt.Errorf("%w: this certificate has not been issued",
			ErrInvalidRecord)
	case c.State == CertificateVoided:
		return fmt.Errorf("%w: this certificate has been voided",
			ErrInvalidRecord)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the certificate is being corrected",
			ErrInvalidRecord)
	case strings.TrimSpace(issuer.SubjectID) == "":
		return fmt.Errorf("%w: a correction names who issued it",
			ErrInvalidRecord)
	case !strings.EqualFold(issuer.Role, form.IssuerRole):
		return fmt.Errorf("%w: form %s is issued by a %s, not a %s",
			ErrInvalidRecord, form.Code, form.IssuerRole, issuer.Role)
	case !form.Live(now):
		return fmt.Errorf(
			"%w: form %s revision %d is not approved and in force",
			ErrInvalidRecord, form.Code, form.Revision)
	}

	completed, refs, err := completeForm(form, values, sourceRefs)
	if err != nil {
		return err
	}

	serial := strings.TrimSpace(serialNumber)
	if serial == "" {
		// A correction issued on the original serial is how a registrar ends
		// up holding two different documents with one number.
		serial = current.SerialNumber
	}

	c.FormCode, c.FormRevision = form.Code, form.Revision
	c.Versions = append(c.Versions, CertificateVersion{
		Version: len(c.Versions) + 1, Values: completed, SourceRefs: refs,
		Reason:   strings.TrimSpace(reason),
		IssuerID: issuer.SubjectID, IssuerName: issuer.Name,
		IssuerRole: issuer.Role, IssuedAt: now.UTC(),
		SerialNumber: serial,
	})
	return nil
}

// Void withdraws a certificate issued in error (SRS-MRD-007).
//
// The versions stay. A certificate that was issued and withdrawn is a fact
// about what a family and a registrar were given, and deleting it would make
// the hospital's account of itself untrue.
func (c *StatutoryCertificate) Void(reason, by string, now time.Time) error {
	switch {
	case c.State == CertificateVoided:
		return fmt.Errorf("%w: this certificate is already voided",
			ErrInvalidRecord)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the certificate was withdrawn",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a withdrawal names who made it",
			ErrInvalidRecord)
	}
	c.State, c.VoidReason = CertificateVoided, strings.TrimSpace(reason)
	c.VoidedBy, c.VoidedAt = by, now.UTC()
	return nil
}

// FormFor picks the form in force for a kind in a jurisdiction
// (SRS-MRD-007).
func FormFor(forms []CertificateForm, kind CertificateKind,
	jurisdiction string, at time.Time) (CertificateForm, bool) {

	var best CertificateForm
	found := false
	for _, form := range forms {
		if form.Kind != kind || !form.Live(at) {
			continue
		}
		if !strings.EqualFold(form.Jurisdiction, jurisdiction) {
			continue
		}
		if !found || form.EffectiveFrom.After(best.EffectiveFrom) ||
			(form.EffectiveFrom.Equal(best.EffectiveFrom) &&
				form.Revision > best.Revision) {
			best, found = form, true
		}
	}
	return best, found
}
