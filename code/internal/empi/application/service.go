package application

import (
	"context"
	"encoding/json"
	"errors"
	"sort"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/effective"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Service is the patient index use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	patients    ports.PatientRepository
	identifiers ports.IdentifierRepository
	config      ports.ConfigRepository
	merges      ports.MergeRepository
	history     ports.HistoryRepository
	registries  ports.IdentifierRegistries
	numbers     ports.NumberIssuer
	tenants     ports.TenantProfile
	events      ports.EventAppender
	audits      ports.AuditAppender
	ids         ports.IDGenerator
	clock       ports.Clock
}

// Deps are the collaborators the service needs.
//
// A struct rather than nine positional parameters: the constructor would
// otherwise take four repositories of similar shape in an order nothing but
// convention protects.
type Deps struct {
	UnitOfWork  ports.UnitOfWork
	Patients    ports.PatientRepository
	Identifiers ports.IdentifierRepository
	Config      ports.ConfigRepository
	Merges      ports.MergeRepository
	History     ports.HistoryRepository
	// Registries is optional. A deployment with no national identifier
	// adapter links every identifier as asserted, which is the honest record
	// of what it knows.
	Registries ports.IdentifierRegistries
	Numbers    ports.NumberIssuer
	Tenants    ports.TenantProfile
	Events     ports.EventAppender
	Audits     ports.AuditAppender
	IDs        ports.IDGenerator
	Clock      ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, patients: d.Patients, identifiers: d.Identifiers,
		config: d.Config, merges: d.Merges, history: d.History,
		registries: d.Registries,
		numbers:    d.Numbers, tenants: d.Tenants,
		events: d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	// DefaultPageSize for a search.
	DefaultPageSize = 20
	// MaxPageSize caps a listing regardless of what the client asks for, so one
	// caller cannot pull a tenant's whole patient index in a round trip.
	MaxPageSize = 50
	// maxCandidates bounds the blocking query. Scoring is cheap per record and
	// the blocking index is selective; this is a backstop against a surname
	// that half the catchment shares.
	maxCandidates = 200
)

// mrnSystem namespaces MRNs by the facility that issued them. Two facilities
// both issuing "MRN 1001" are two different patients.
func mrnSystem(facilityID string) string { return "facility:" + facilityID }

// RegisterPatientInput is the command payload (SRS-EMPI-001).
type RegisterPatientInput struct {
	Demographics domain.Demographics
	// Identifiers the patient already holds. The MRN is issued here and must
	// not appear: accepting a caller-supplied MRN would let a client choose a
	// value the facility's sequence never allocated.
	Identifiers []domain.Identifier
	// AcknowledgedDuplicates are candidates the user has already been shown.
	// Registration refuses a probable duplicate unless it appears here, which
	// is what makes search-before-create a control rather than a courtesy
	// (SRS-EMPI-003).
	AcknowledgedDuplicates []string
}

// RegisterPatientResult carries either the patient or the reason it was
// refused.
type RegisterPatientResult struct {
	Patient     *domain.Patient
	Identifiers domain.IdentifierSet
	// Duplicates is populated only when registration was refused.
	Duplicates []MatchedPatient
}

// MatchedPatient is a scored candidate.
type MatchedPatient struct {
	Patient     *domain.Patient
	Identifiers domain.IdentifierSet
	Match       domain.MatchResult
	// Masked reports that protected fields were hidden for this caller, so a
	// UI can say so rather than showing blanks that read as missing data.
	Masked bool
	// MatchedFormerName is set when the search reached this patient through a
	// name they no longer hold (SRS-EMPI-007). Zero otherwise.
	MatchedFormerName domain.PatientName
}

// errDuplicatesPending unwinds the registration transaction when a probable
// duplicate needs review.
//
// An error internally because the transaction must roll back, and not an error
// to the caller: finding a duplicate is the expected outcome of
// search-before-create. RegisterPatient converts it into a result with
// candidates and no patient.
var errDuplicatesPending = errors.New("empi: probable duplicate has not been acknowledged")

// RegisterPatient creates a patient and issues its MRN (SRS-EMPI-001).
//
// The duplicate check happens before the write and inside the transaction that
// performs it. Outside, two clerks registering the same walk-in patient
// simultaneously would each find no duplicate and each create a record.
func (s *Service) RegisterPatient(ctx context.Context, in RegisterPatientInput) (RegisterPatientResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return RegisterPatientResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientCreate,
		Mutating:   true,
		// Registration happens at a desk in a building, and the MRN comes from
		// that building's sequence. A caller with no active facility has no
		// defensible answer to "which MRN series".
		RequireFacilityMatch: true,
		ResourceFacilityID:   session.ActiveFacilityID,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientCreate, "patient", "", decision.Reason)
		return RegisterPatientResult{}, rpcerr.PermissionDenied("EMPI_REGISTER_DENIED", decision.Reason)
	}

	for _, i := range in.Identifiers {
		if i.Type == domain.IdentifierMRN {
			return RegisterPatientResult{}, rpcerr.Invalid("EMPI_MRN_NOT_ACCEPTED",
				"the MRN is issued by the registering facility and must not be supplied")
		}
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
	if err != nil {
		return RegisterPatientResult{}, err
	}
	registrationPolicy, err := s.config.DemographicPolicy(ctx, scope, jurisdiction, session.ActiveFacilityID)
	if err != nil {
		return RegisterPatientResult{}, err
	}

	patient, err := domain.NewPatient(s.ids.NewID(), session.TenantID,
		session.ActiveFacilityID, in.Demographics, registrationPolicy, now)
	if err != nil {
		return RegisterPatientResult{}, registrationError(err)
	}

	var result RegisterPatientResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		duplicates, err := s.findDuplicates(ctx, session, patient.Demographics, in.Identifiers, "")
		if err != nil {
			return err
		}

		acknowledged := map[string]bool{}
		for _, id := range in.AcknowledgedDuplicates {
			acknowledged[id] = true
		}

		var unacknowledged []MatchedPatient
		for _, d := range duplicates {
			// Only the probable band blocks. A warning is shown and stepped
			// past, because refusing on every possible duplicate would make a
			// busy desk unable to register twins, and the clerk is the one who
			// can see the patient.
			if d.Match.Outcome == domain.OutcomeProbable && !acknowledged[d.Patient.ID()] {
				unacknowledged = append(unacknowledged, d)
			}
		}
		if len(unacknowledged) > 0 {
			result.Duplicates = unacknowledged
			return errDuplicatesPending
		}

		if err := s.patients.Insert(ctx, scope, patient); err != nil {
			return err
		}

		// The MRN comes from the platform's numbering sequence, whose
		// statement takes a row lock. That is what makes SRS-EMPI-016 hold
		// under concurrent registration; a value minted here would not.
		mrnValue, err := s.numbers.IssueMRN(ctx, scope, session.ActiveFacilityID, now)
		if err != nil {
			return err
		}
		mrn, err := domain.NewIdentifier(s.ids.NewID(), patient.ID(), domain.IdentifierMRN,
			mrnSystem(session.ActiveFacilityID), mrnValue, session.ActiveFacilityID, "registration", now)
		if err != nil {
			return err
		}
		mrn.Primary = true
		if err := s.identifiers.Link(ctx, scope, mrn); err != nil {
			return err
		}
		result.Identifiers = domain.IdentifierSet{mrn}

		for _, supplied := range in.Identifiers {
			i, err := domain.NewIdentifier(s.ids.NewID(), patient.ID(), supplied.Type,
				supplied.System, supplied.Value, supplied.AssigningAuthority,
				firstNonEmpty(supplied.Source, "registration"), now)
			if err != nil {
				return err
			}
			if err := s.identifiers.Link(ctx, scope, i); err != nil {
				return err
			}
			result.Identifiers = append(result.Identifiers, i)
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id":  patient.ID(),
			"facility_id": patient.RegisteredFacilityID,
			"status":      string(patient.Status),
			// The MRN is in the event because downstream contexts print it on
			// wristbands and labels. No name, no birth date, no contact
			// details: an event stream is read by more systems than a record
			// is (SRS-API-009).
			"mrn": mrnValue,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientCreated, "patient", patient.ID(), payload, now); err != nil {
			return err
		}

		// The first legal name opens the history. Without it, the first rename
		// would have nothing to close and the name the patient registered under
		// would never have been recorded as applying to any interval
		// (SRS-EMPI-007).
		if err := s.openLegalName(ctx, scope, session, patient, "registration", now); err != nil {
			return err
		}

		// The clerk said these are different people and their judgement
		// stands — they can see the patient. But that call was made at a busy
		// desk with somebody waiting, so the pair goes to HIM. Without this,
		// nobody ever looks at it again (SRS-EMPI-004).
		if err := s.queueForReview(ctx, scope, patient.ID(), duplicates, "registration", now); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientCreate,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		if errors.Is(err, errDuplicatesPending) {
			// Not an error to the caller. Patient is nil and Duplicates is
			// populated, which is the "review these" outcome.
			return result, nil
		}
		return RegisterPatientResult{}, err
	}

	result.Patient = patient
	return result, nil
}

// openLegalName records the patient's current legal name as a history window.
//
// Called on registration and on every name change, so that a result addressed
// to a previous name still finds this patient rather than becoming a second
// record.
func (s *Service) openLegalName(ctx context.Context, scope authctx.TenantScope,
	session authctx.Session, patient *domain.Patient, source string, now time.Time) error {

	recorded, err := domain.NewPatientName(s.ids.NewID(), patient.ID(), domain.NameLegal,
		patient.Demographics.Name, effective.Window{From: now}, session.SubjectID, source, now)
	if err != nil {
		return registrationError(err)
	}
	return s.history.RecordName(ctx, scope, recorded)
}

// findDuplicates blocks, scores and ranks candidates (SRS-EMPI-003/004).
func (s *Service) findDuplicates(ctx context.Context, session authctx.Session,
	d domain.Demographics, identifiers domain.IdentifierSet, excludeID string) ([]MatchedPatient, error) {

	scope := session.TenantScope()

	weights, thresholds, err := s.config.MatchConfig(ctx, scope)
	if err != nil {
		return nil, err
	}

	keys := ports.BlockingKeys{
		FamilyPrefix:     blockingPrefix(d.Name.Family),
		ExcludePatientID: excludeID,
	}
	if !d.BirthDate.IsZero() {
		date := d.BirthDate.Date
		keys.BirthDate = &date
	}
	if len(d.Phones) > 0 {
		keys.Phone = d.Phones[0].Value
	}

	candidates, err := s.patients.Candidates(ctx, scope, keys, maxCandidates)
	if err != nil {
		return nil, err
	}
	if len(candidates) == 0 {
		return nil, nil
	}

	ids := make([]string, 0, len(candidates))
	for _, c := range candidates {
		ids = append(ids, c.ID())
	}
	identifiersByPatient, err := s.identifiers.ForPatients(ctx, scope, ids)
	if err != nil {
		return nil, err
	}

	restricted := session.HasPermission(PermPatientReadRestricted)

	out := make([]MatchedPatient, 0, len(candidates))
	for _, c := range candidates {
		held := identifiersByPatient[c.ID()]
		match := domain.Score(d, identifiers, domain.MatchCandidate{
			PatientID: c.ID(), Demographics: c.Demographics, Identifiers: held,
		}, weights, thresholds)

		// A conflict is evidence these are different people. Showing it as a
		// duplicate would invite exactly the merge it argues against.
		if match.Outcome == domain.OutcomeDistinct || match.Outcome == domain.OutcomeConflict {
			continue
		}

		shown, masked := maskFor(c, restricted)
		out = append(out, MatchedPatient{
			Patient: shown, Identifiers: held, Match: match, Masked: masked,
		})
	}

	// Strongest first: the clerk scanning the list should see the candidate
	// most likely to be the same person at the top.
	sort.SliceStable(out, func(i, j int) bool { return out[i].Match.Score > out[j].Match.Score })
	return out, nil
}

// blockingPrefix is the indexable part of a surname.
//
// Four characters: long enough to be selective, short enough to survive the
// misspelling at the end of a name that is exactly what fuzzy matching is for.
// Blocking on the whole surname would find only records that already match.
func blockingPrefix(family string) string {
	folded := strings.ToLower(strings.TrimSpace(family))
	if folded == "" {
		return ""
	}
	runes := []rune(folded)
	if len(runes) > 4 {
		runes = runes[:4]
	}
	return string(runes)
}

func firstNonEmpty(values ...string) string {
	for _, v := range values {
		if strings.TrimSpace(v) != "" {
			return v
		}
	}
	return ""
}

// registrationError maps a domain refusal onto the wire contract.
//
// Incomplete demographics are a FAILED_PRECONDITION rather than an
// INVALID_ARGUMENT: the data is well-formed and this facility wants more of it,
// which is a different thing for a UI to say than "that is not a valid date".
func registrationError(err error) error {
	var incomplete domain.ErrDemographicsIncomplete
	if errors.As(err, &incomplete) {
		return rpcerr.FailedPrecondition("EMPI_DEMOGRAPHICS_INCOMPLETE", incomplete.Error())
	}
	if errors.Is(err, domain.ErrInvalidPatient) {
		return rpcerr.Invalid("EMPI_PATIENT_INVALID", err.Error())
	}
	return err
}
