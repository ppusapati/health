package application

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"strconv"
	"strings"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Photographs, configured field access and emergency registration
// (SRS-EMPI-010, SRS-EMPI-014, SRS-EMPI-015).

const (
	// EventPatientRegisteredUnidentified is emitted for an emergency
	// admission. A bed-management or tracking board needs to know a patient
	// exists before anybody knows who they are.
	EventPatientRegisteredUnidentified = "patient.registered_unidentified"
	// EventPatientIdentified is emitted when a designation is replaced by real
	// demographics.
	EventPatientIdentified = "patient.identified"
	// EventPatientPhotoCaptured is emitted when a photograph is stored.
	EventPatientPhotoCaptured = "patient.photo_captured"
	// EventPatientPhotoWithdrawn is emitted when consent is withdrawn.
	EventPatientPhotoWithdrawn = "patient.photo_withdrawn"
)

// RegisterUnidentifiedInput is an emergency admission (SRS-EMPI-015).
type RegisterUnidentifiedInput struct {
	Designation domain.TemporaryDesignation
}

// RegisterUnidentifiedResult carries the record and the number to print on it.
//
// The identifiers are returned rather than left for a second call because the
// entire reason the MRN is issued during the resuscitation is that a specimen
// leaving the room in the next minute has to carry it. A caller that had to
// fetch it separately would print the band late or not at all.
type RegisterUnidentifiedResult struct {
	Patient     *domain.Patient
	Identifiers domain.IdentifierSet
}

// RegisterUnidentified creates the record an emergency admission writes
// against.
//
// Deliberately does not search for duplicates first. The search-before-create
// control exists because a clerk with a name in front of them should look for
// an existing record; there is no name here, and blocking a resuscitation on a
// probable match against every other unidentified patient would be both useless
// and dangerous. Reconciliation happens on identification instead.
func (s *Service) RegisterUnidentified(ctx context.Context, in RegisterUnidentifiedInput) (
	RegisterUnidentifiedResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return RegisterUnidentifiedResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientCreate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientCreate, "patient", "", decision.Reason)
		return RegisterUnidentifiedResult{}, rpcerr.PermissionDenied("EMPI_REGISTER_DENIED", decision.Reason)
	}
	if session.ActiveFacilityID == "" {
		return RegisterUnidentifiedResult{}, rpcerr.Invalid("EMPI_FACILITY_REQUIRED",
			"registration happens at a facility; none is in scope")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var created RegisterUnidentifiedResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
		if err != nil {
			return err
		}
		registrationPolicy, err := s.config.DemographicPolicy(ctx, scope,
			jurisdiction, session.ActiveFacilityID)
		if err != nil {
			return err
		}

		patient, err := domain.NewUnidentifiedPatient(s.ids.NewID(), scope.TenantID(),
			session.ActiveFacilityID, in.Designation, registrationPolicy, now)
		if err != nil {
			return registrationError(err)
		}
		if err := s.patients.Insert(ctx, scope, patient); err != nil {
			return err
		}

		// An MRN is issued immediately. Everything written during the
		// resuscitation has to be labelled with something, and a number issued
		// an hour later cannot be printed on a specimen taken now.
		mrnValue, err := s.numbers.IssueMRN(ctx, scope, session.ActiveFacilityID, now)
		if err != nil {
			return err
		}
		mrn, err := domain.NewIdentifier(s.ids.NewID(), patient.ID(), domain.IdentifierMRN,
			mrnSystem(session.ActiveFacilityID), mrnValue, session.ActiveFacilityID,
			"emergency registration", now)
		if err != nil {
			return registrationError(err)
		}
		mrn.Primary = true
		if err := s.identifiers.Link(ctx, scope, mrn); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(), "mrn": mrnValue,
			"facility_id": session.ActiveFacilityID,
			// The label, because a tracking board shows it and it is not a
			// patient's name — it is what the ward is calling somebody nobody
			// can name yet.
			"designation": in.Designation.Label,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientRegisteredUnidentified,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		created = RegisterUnidentifiedResult{
			Patient: patient, Identifiers: domain.IdentifierSet{mrn},
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientCreate,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  "unidentified: " + in.Designation.Label,
		}, now)
	})
	if err != nil {
		return RegisterUnidentifiedResult{}, mapConflict(err)
	}
	return created, nil
}

// IdentifyPatientInput names a patient who was registered unidentified.
type IdentifyPatientInput struct {
	PatientID       string
	Demographics    domain.Demographics
	ExpectedVersion int64
	// AcknowledgedDuplicates are records the caller has been shown and judged
	// to be different people. Identification is exactly when the duplicate
	// check that emergency registration skipped has to happen: the patient now
	// has a name, and an existing record for them is likely.
	AcknowledgedDuplicates []string
}

// IdentifyPatientResult carries the identified patient or what to review first.
type IdentifyPatientResult struct {
	Patient    *domain.Patient
	Duplicates []MatchedPatient
}

// IdentifyPatient replaces a temporary designation with real demographics
// (SRS-EMPI-015).
//
// The patient id does not change, so everything written during the emergency
// still points here. That is what "without losing encounter chronology" means
// in practice, and it falls out of SRS-EMPI-002 rather than needing machinery
// of its own.
func (s *Service) IdentifyPatient(ctx context.Context, in IdentifyPatientInput) (
	IdentifyPatientResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return IdentifyPatientResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientUpdate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientUpdate, "patient", in.PatientID, decision.Reason)
		return IdentifyPatientResult{}, rpcerr.PermissionDenied("EMPI_IDENTIFY_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result IdentifyPatientResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if in.ExpectedVersion != 0 && patient.Version != in.ExpectedVersion {
			return rpcerr.FailedPrecondition("EMPI_VERSION_CONFLICT",
				"the record changed since it was read")
		}

		// The duplicate check emergency registration could not do. A patient
		// brought in unconscious very often already has a record here, and
		// this is the first moment there is enough to find it.
		duplicates, err := s.findDuplicates(ctx, session, in.Demographics, nil, patient.ID())
		if err != nil {
			return err
		}
		acknowledged := map[string]bool{}
		for _, id := range in.AcknowledgedDuplicates {
			acknowledged[id] = true
		}
		var blocking []MatchedPatient
		for _, d := range duplicates {
			// Only the probable band blocks, as at registration. The clerk is
			// the one who can see the patient.
			if d.Match.Outcome == domain.OutcomeProbable && !acknowledged[d.Patient.ID()] {
				blocking = append(blocking, d)
			}
		}
		if len(blocking) > 0 {
			result.Duplicates = blocking
			return errDuplicatesPending
		}

		jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
		if err != nil {
			return err
		}
		registrationPolicy, err := s.config.DemographicPolicy(ctx, scope,
			jurisdiction, patient.RegisteredFacilityID)
		if err != nil {
			return err
		}

		if err := patient.Identify(in.Demographics, registrationPolicy, now); err != nil {
			return registrationError(err)
		}
		if err := s.patients.UpdateDemographics(ctx, scope, patient); err != nil {
			return err
		}
		if err := s.unidentified.MarkIdentified(ctx, scope, patient.ID(), now); err != nil {
			return err
		}

		// The name history opens here rather than at registration: there was
		// no name to open a window on, and a window whose value is a trauma
		// label would put that label in the name history for good.
		if err := s.openLegalName(ctx, scope, session, patient, "identification", now); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(), "version": patient.Version,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientIdentified,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		result.Patient = patient
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientUpdate,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "identified",
		}, now)
	})
	if err != nil {
		if strings.Contains(err.Error(), errDuplicatesPending.Error()) {
			// Duplicates found: a successful result carrying what to review,
			// and no patient. The transaction rolled back deliberately.
			return IdentifyPatientResult{Duplicates: result.Duplicates}, nil
		}
		return IdentifyPatientResult{}, mapConflict(err)
	}
	return result, nil
}

// ListUnidentified returns who is still unknown (SRS-EMPI-015).
func (s *Service) ListUnidentified(ctx context.Context, pageSize int32) ([]*domain.Patient, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient", "", decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_LIST_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var out []*domain.Patient
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.unidentified.ListUnidentified(ctx, scope, clampPageSize(pageSize))
		if err != nil {
			return err
		}
		out = found
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientRead,
			ResourceType: "patient", ResourceID: "",
			Outcome: audit.OutcomeSuccess, Reason: "unidentified worklist",
		}, now)
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CapturePhotoInput stores a patient photograph (SRS-EMPI-010).
type CapturePhotoInput struct {
	PatientID   string
	ContentType string
	Content     []byte
	Consent     domain.PhotoConsent
}

// CapturePhoto stores a photograph and the consent it was taken under.
func (s *Service) CapturePhoto(ctx context.Context, in CapturePhotoInput) (domain.Photo, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Photo{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient_photo", in.PatientID, decision.Reason)
		return domain.Photo{}, rpcerr.PermissionDenied("EMPI_PHOTO_DENIED", decision.Reason)
	}
	if s.photoStore == nil {
		// A deployment that has wired no store cannot hold photographs, and
		// saying so is better than recording a row pointing at nothing.
		return domain.Photo{}, rpcerr.FailedPrecondition("EMPI_PHOTO_STORE_NOT_CONFIGURED",
			"this deployment does not store patient photographs")
	}

	// Bounded before anything else. The bytes came from a ward tablet, and the
	// domain's check would run only after they were already in memory and
	// hashed.
	if len(in.Content) == 0 {
		return domain.Photo{}, rpcerr.Invalid("EMPI_PHOTO_EMPTY", "a photograph needs content")
	}
	if len(in.Content) > domain.MaxPhotoBytes {
		return domain.Photo{}, rpcerr.Invalid("EMPI_PHOTO_TOO_LARGE",
			"a photograph may be at most 2 MiB")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	consent := in.Consent
	if consent.GivenAt.IsZero() {
		consent.GivenAt = now
	}
	consent.RecordedBy = session.SubjectID

	digest := sha256.Sum256(in.Content)

	var stored domain.Photo
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}

		// One current photograph per patient, enforced by a partial unique
		// index. Checked here for a message that says what to do rather than a
		// constraint violation.
		if _, found, err := s.photos.Current(ctx, scope, patient.ID()); err != nil {
			return err
		} else if found {
			return rpcerr.AlreadyExists("EMPI_PHOTO_EXISTS",
				"this patient already has a photograph; withdraw it before taking another")
		}

		key, err := s.photoStore.Put(ctx, scope, in.ContentType, in.Content)
		if err != nil {
			return err
		}

		photo, err := domain.NewPhoto(s.ids.NewID(), patient.ID(), key, in.ContentType,
			int64(len(in.Content)), hex.EncodeToString(digest[:]), consent,
			session.SubjectID, now)
		if err != nil {
			// The bytes are already in the store. Removing them keeps a
			// rejected capture from leaving an orphan nothing references.
			_ = s.photoStore.Delete(ctx, scope, key)
			return registrationError(err)
		}
		if err := s.photos.Insert(ctx, scope, photo); err != nil {
			_ = s.photoStore.Delete(ctx, scope, key)
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(), "photo_id": photo.ID,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientPhotoCaptured,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		stored = photo
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient_photo", ResourceID: photo.ID,
			Outcome: audit.OutcomeSuccess,
			// The purpose, not the image. An audit trail that described the
			// photograph would be a second, less protected copy of it.
			Reason: "photograph captured for " + consent.Purpose,
		}, now)
	})
	if err != nil {
		return domain.Photo{}, mapConflict(err)
	}
	return stored, nil
}

// GetPhotoResult carries a photograph and its bytes.
type GetPhotoResult struct {
	Photo   domain.Photo
	Content []byte
	Found   bool
}

// GetPhoto returns the patient's current photograph.
//
// Reading a photograph is a read of the patient and is audited as one. A
// photograph is more identifying than most of the fields around it: a name can
// be shared, a face on a screen is the person.
func (s *Service) GetPhoto(ctx context.Context, patientID string) (GetPhotoResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return GetPhotoResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient_photo", patientID, decision.Reason)
		return GetPhotoResult{}, rpcerr.PermissionDenied("EMPI_PHOTO_READ_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result GetPhotoResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		photo, found, err := s.photos.Current(ctx, scope, patientID)
		if err != nil {
			return err
		}
		if !found {
			return s.appendAudit(ctx, session, audit.Record{
				TenantID: session.TenantID, Action: PermPatientRead,
				ResourceType: "patient_photo", ResourceID: patientID,
				Outcome: audit.OutcomeSuccess, Reason: "no photograph on file",
			}, now)
		}

		if s.photoStore == nil {
			return rpcerr.FailedPrecondition("EMPI_PHOTO_STORE_NOT_CONFIGURED",
				"this deployment cannot read patient photographs")
		}
		content, err := s.photoStore.Get(ctx, scope, photo.StorageKey)
		if err != nil {
			return err
		}

		// The digest proves the bytes are the ones this row describes. A store
		// that silently returned a different object would otherwise be
		// indistinguishable from one that returned the right one — and showing
		// a nurse the wrong patient's face is the failure this whole feature
		// is supposed to prevent.
		actual := sha256.Sum256(content)
		if hex.EncodeToString(actual[:]) != photo.Digest {
			return rpcerr.Internal("EMPI_PHOTO_CORRUPT",
				"the stored photograph does not match its record and was not returned")
		}

		result = GetPhotoResult{Photo: photo, Content: content, Found: true}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientRead,
			ResourceType: "patient_photo", ResourceID: photo.ID,
			Outcome: audit.OutcomeSuccess, Reason: "photograph viewed",
		}, now)
	})
	if err != nil {
		return GetPhotoResult{}, err
	}
	return result, nil
}

// WithdrawPhotoConsent removes a photograph's bytes, keeping the record.
func (s *Service) WithdrawPhotoConsent(ctx context.Context, photoID, reason string) (
	domain.Photo, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.Photo{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientManage,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientManage, "patient_photo", photoID, decision.Reason)
		return domain.Photo{}, rpcerr.PermissionDenied("EMPI_PHOTO_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var withdrawn domain.Photo
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		photo, err := s.photos.Get(ctx, scope, photoID)
		if err != nil {
			return err
		}
		if err := photo.Withdraw(reason, now); err != nil {
			return registrationError(err)
		}
		if err := s.photos.Withdraw(ctx, scope, photo); err != nil {
			return err
		}

		// The bytes go after the row is marked, not before. If deleting fails
		// the transaction rolls back and the photograph is still viewable,
		// which is recoverable; the other order leaves a record claiming a
		// photograph that is already gone.
		if s.photoStore != nil {
			if err := s.photoStore.Delete(ctx, scope, photo.StorageKey); err != nil {
				return err
			}
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": photo.PatientID, "photo_id": photo.ID,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientPhotoWithdrawn,
			"patient", photo.PatientID, payload, now); err != nil {
			return err
		}

		withdrawn = photo
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient_photo", ResourceID: photo.ID,
			Outcome: audit.OutcomeSuccess, Reason: "consent withdrawn: " + reason,
		}, now)
	})
	if err != nil {
		return domain.Photo{}, mapConflict(err)
	}
	return withdrawn, nil
}

// ConfigureFieldAccessInput restricts a demographic field (SRS-EMPI-014).
type ConfigureFieldAccessInput struct {
	FacilityID string
	Field      domain.Field
	// Permission that reveals the field in full.
	Permission string
}

// ConfigureFieldAccess sets which permission reveals a demographic field.
func (s *Service) ConfigureFieldAccess(ctx context.Context, in ConfigureFieldAccessInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientConfigure, "field_access_policy", "", decision.Reason)
		return rpcerr.PermissionDenied("EMPI_CONFIGURE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
		if err != nil {
			return err
		}

		proposed := domain.FieldAccessPolicy{
			Jurisdiction: jurisdiction, FacilityID: in.FacilityID,
			Restricted: map[domain.Field]string{in.Field: in.Permission},
		}
		if err := proposed.Validate(); err != nil {
			return registrationError(err)
		}
		if err := s.config.SetFieldAccess(ctx, scope, proposed, in.Field, in.Permission, now); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientConfigure,
			ResourceType: "field_access_policy", ResourceID: string(in.Field),
			Outcome: audit.OutcomeSuccess,
			Reason:  string(in.Field) + " requires " + in.Permission,
		}, now)
	})
}

// evidenceSummary renders what was checked, for the audit trail.
//
// Counts and kinds, never the identifier values: an audit trail that stored
// them would become a second index of identifiers, outside every access rule
// protecting the first.
func evidenceSummary(e domain.IdentityEvidence) string {
	parts := make([]string, 0, 3)
	if n := len(e.IdentifierIDs); n > 0 {
		parts = append(parts, itoa(n)+" sighted identifier(s)")
	}
	if e.PhotoMatched {
		parts = append(parts, "a photograph")
	}
	if e.VouchedForBy != "" {
		parts = append(parts, "a person vouching")
	}
	if len(parts) == 0 {
		return "nothing recorded"
	}
	return strings.Join(parts, ", ")
}

func itoa(n int) string { return strconv.Itoa(n) }
