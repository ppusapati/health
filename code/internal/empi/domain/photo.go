package domain

import (
	"fmt"
	"strings"
	"time"
)

// Patient photograph (SRS-EMPI-010).
//
// The requirement has two halves and the second is the one that matters:
// "support patient photo with consent/configuration" and "prohibit using photo
// as sole identity proof", with the acceptance criterion that the identity
// workflow always includes configured positive identifiers.
//
// The prohibition is not squeamishness about biometrics. A photo is a genuinely
// useful safety check — a nurse glancing at a screen before a transfusion
// catches a wrong-patient error that a matching name would not. What it cannot
// do is *establish* identity, for a reason that is specific rather than
// general: the failure mode of face comparison is systematically worse for the
// people a hospital is already most likely to misidentify. Siblings, twins, a
// photo taken four years and one illness ago, and — measurably — accuracy that
// varies by skin tone and age. A system that lets a photo alone confirm
// identity concentrates its errors on exactly the populations least able to
// contest them.
//
// So the photo is evidence a human uses, never evidence the system accepts.
// ConfirmIdentity requires a verified identifier whatever else was checked.

// PhotoConsent records the patient's agreement to be photographed.
//
// Its own type because consent has a shape: somebody gave it, at a time, for a
// stated purpose, and it can be withdrawn. A boolean would record none of that,
// and "did this patient agree to their photograph being kept" is a question
// somebody will eventually be asked to answer with evidence.
type PhotoConsent struct {
	// GivenBy is who consented — the patient, or a related person holding the
	// authority to consent for them (SRS-EMPI-009).
	GivenBy string
	// OnBehalf is set when somebody consented for the patient, naming the
	// relationship that permitted it.
	OnBehalf string
	// Purpose is what the photograph may be used for. Free text, because the
	// legitimate purposes differ by jurisdiction and an enumeration written
	// here would be wrong somewhere.
	Purpose    string
	GivenAt    time.Time
	RecordedBy string
}

// MaxPhotoBytes bounds a stored photograph.
//
// Two megabytes is a generous identification photo and far below anything that
// could be a scanned document set. The bound exists because this endpoint
// accepts bytes from a ward tablet, and an unbounded one is a way to fill a
// disk from the registration desk.
const MaxPhotoBytes = 2 << 20

// allowedPhotoTypes is an allowlist, not a blocklist.
//
// A blocklist here would accept SVG, which is a script container, and HTML
// renamed to .jpg. The set is small on purpose: these are the formats a camera
// produces and a browser renders without interpreting.
var allowedPhotoTypes = map[string]bool{
	"image/jpeg": true,
	"image/png":  true,
	"image/webp": true,
}

// Photo is a patient photograph held by reference.
//
// The bytes live in an object store behind a port; this is the record that one
// exists, what it is, and on what basis it was taken. The digest is kept so a
// stored object can be shown to be the one this record describes.
type Photo struct {
	ID        string
	PatientID string
	// StorageKey locates the bytes in whatever store this deployment uses.
	StorageKey  string
	ContentType string
	ByteSize    int64
	// Digest is the SHA-256 of the bytes, hex-encoded.
	Digest     string
	Consent    PhotoConsent
	CapturedAt time.Time
	CapturedBy string
	// WithdrawnAt is set when consent is withdrawn. The record stays; the
	// bytes are deleted. Keeping the row is what lets somebody answer "was
	// there a photograph, and what happened to it" — which a deletion that
	// leaves nothing behind cannot.
	WithdrawnAt     *time.Time
	WithdrawnReason string
}

// NewPhoto validates and constructs a photo record.
func NewPhoto(id, patientID, storageKey, contentType string, byteSize int64,
	digest string, consent PhotoConsent, capturedBy string, now time.Time) (Photo, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Photo{}, fmt.Errorf("%w: photo id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return Photo{}, fmt.Errorf("%w: a photo needs a patient", ErrInvalidPatient)
	case strings.TrimSpace(storageKey) == "":
		return Photo{}, fmt.Errorf("%w: a photo record with no storage key points at nothing",
			ErrInvalidPatient)
	case !allowedPhotoTypes[contentType]:
		return Photo{}, fmt.Errorf("%w: %q is not a photograph format this system stores",
			ErrInvalidPatient, contentType)
	case byteSize <= 0:
		return Photo{}, fmt.Errorf("%w: a photo needs content", ErrInvalidPatient)
	case byteSize > MaxPhotoBytes:
		return Photo{}, fmt.Errorf("%w: a photo may be at most %d bytes", ErrInvalidPatient, MaxPhotoBytes)
	case strings.TrimSpace(digest) == "":
		return Photo{}, fmt.Errorf("%w: a photo needs a digest", ErrInvalidPatient)
	case strings.TrimSpace(capturedBy) == "":
		return Photo{}, fmt.Errorf("%w: a photo must record who took it", ErrInvalidPatient)
	}

	if err := consent.validate(); err != nil {
		return Photo{}, err
	}

	return Photo{
		ID: id, PatientID: patientID, StorageKey: storageKey,
		ContentType: contentType, ByteSize: byteSize, Digest: digest,
		Consent: consent, CapturedAt: now.UTC(), CapturedBy: capturedBy,
	}, nil
}

func (c PhotoConsent) validate() error {
	switch {
	case strings.TrimSpace(c.GivenBy) == "":
		// A photograph with no recorded consent is one nobody can show was
		// agreed to, which is the same position as having taken it without
		// asking.
		return fmt.Errorf("%w: a photograph needs recorded consent naming who gave it",
			ErrInvalidPatient)
	case strings.TrimSpace(c.Purpose) == "":
		// "They agreed to a photo" is not consent to anything in particular.
		// Identification at the bedside and publication in a case report are
		// both photographs of a patient.
		return fmt.Errorf("%w: consent must state what the photograph is for", ErrInvalidPatient)
	case c.GivenAt.IsZero():
		return fmt.Errorf("%w: consent must record when it was given", ErrInvalidPatient)
	case strings.TrimSpace(c.RecordedBy) == "":
		return fmt.Errorf("%w: consent must name who recorded it", ErrInvalidPatient)
	}
	return nil
}

// Withdraw marks consent as withdrawn.
//
// The record stays and the bytes go. A withdrawal that deleted the row too
// would leave nobody able to answer whether a photograph ever existed, which is
// the question an audit asks after a complaint.
func (p *Photo) Withdraw(reason string, now time.Time) error {
	if p.WithdrawnAt != nil {
		return fmt.Errorf("%w: consent for photo %s was already withdrawn", ErrInvalidPatient, p.ID)
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: withdrawing consent needs a reason", ErrInvalidPatient)
	}
	at := now.UTC()
	p.WithdrawnAt = &at
	p.WithdrawnReason = normaliseText(reason)
	return nil
}

// Viewable reports whether the photograph may still be shown.
func (p Photo) Viewable() bool { return p.WithdrawnAt == nil }

// IdentityEvidence is what was checked before confirming a patient's identity
// (SRS-EMPI-010).
//
// Recorded rather than inferred. "The system confirmed identity" is not a
// defensible answer to "on what basis"; this is.
type IdentityEvidence struct {
	// IdentifierIDs are the identifiers that were sighted and checked.
	IdentifierIDs []string
	// PhotoMatched records that a human compared the patient with the stored
	// photograph. Useful and never sufficient.
	PhotoMatched bool
	// VouchedForBy is a related person who identified the patient. Also never
	// sufficient on its own.
	VouchedForBy string
	Note         string
}

// ErrPhotoIsNotProof reports an identity confirmation resting on no verified
// identifier.
type ErrPhotoIsNotProof struct {
	// Offered names what the caller did present, so the error can say what is
	// missing rather than merely that something is.
	Offered []string
}

func (e ErrPhotoIsNotProof) Error() string {
	offered := "nothing"
	if len(e.Offered) > 0 {
		offered = strings.Join(e.Offered, ", ")
	}
	return "empi: identity cannot be confirmed on " + offered +
		"; a verified identifier is required (SRS-EMPI-010)"
}

// CheckIdentityEvidence enforces that identity rests on a positive identifier.
//
// held is the patient's identifier set. The evidence may name identifiers, a
// photo match and a person vouching; only a *verified* identifier counts, and
// at least one is required.
//
// An asserted identifier is deliberately not enough. A number somebody read off
// a photocopy carries no more assurance than the photograph does, and admitting
// it would let the prohibition be satisfied by typing.
func CheckIdentityEvidence(e IdentityEvidence, held IdentifierSet) error {
	sighted := map[string]bool{}
	for _, id := range e.IdentifierIDs {
		sighted[id] = true
	}

	for _, identifier := range held {
		if identifier.Status != IdentifierActive {
			continue
		}
		if !identifier.Assurance.IsPositive() {
			continue
		}
		// A verified identifier the caller did not claim to have checked is
		// not evidence that it was checked. Requiring it to be named keeps
		// this an assertion about what happened at the bedside rather than a
		// property of the record.
		if sighted[identifier.ID] {
			return nil
		}
	}

	var offered []string
	if len(e.IdentifierIDs) > 0 {
		offered = append(offered, "unverified identifiers")
	}
	if e.PhotoMatched {
		offered = append(offered, "a photograph")
	}
	if e.VouchedForBy != "" {
		offered = append(offered, "a person vouching")
	}
	return ErrPhotoIsNotProof{Offered: offered}
}
