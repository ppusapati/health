package application

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"strings"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Search, read and correct (SRS-EMPI-003).

// SearchPatientsInput narrows a search.
type SearchPatientsInput struct {
	Name      string
	BirthDate domain.BirthDate
	Phone     string
	// IdentifierValue is an exact lookup. It finds superseded identifiers too,
	// because a patient quoting an old card must still be found.
	IdentifierValue string
	IdentifierType  domain.IdentifierType
	// IdentifierSystem namespaces the value. Required for every type except
	// MRN, which is namespaced by the facility that issued it — two insurers
	// both issue membership numbers, and without the namespace they collide.
	IdentifierSystem string
	PageSize         int32
	PageToken        string
}

// SearchPatientsResult is one page of scored matches.
type SearchPatientsResult struct {
	Matches       []MatchedPatient
	NextPageToken string
}

// SearchPatients is the search-before-create path (SRS-EMPI-003).
//
// Every result is scored and every result may be masked, because the caller is
// being shown records belonging to people who are not in front of them.
func (s *Service) SearchPatients(ctx context.Context, in SearchPatientsInput) (SearchPatientsResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return SearchPatientsResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient", "", decision.Reason)
		return SearchPatientsResult{}, rpcerr.PermissionDenied("EMPI_SEARCH_DENIED", decision.Reason)
	}

	if in.Name == "" && in.BirthDate.IsZero() && in.Phone == "" && in.IdentifierValue == "" {
		// An unfiltered search is a request for the tenant's whole patient
		// index. Refusing is not pedantry: that is the query somebody runs
		// when they want a list of everybody, and it has no legitimate caller.
		return SearchPatientsResult{}, rpcerr.Invalid("EMPI_SEARCH_UNFILTERED",
			"a search needs at least one of name, birth date, phone or identifier")
	}

	scope := session.TenantScope()
	pageSize := clampPageSize(in.PageSize)
	restricted := session.HasPermission(PermPatientReadRestricted)

	var result SearchPatientsResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// An identifier lookup is exact and conclusive, so it short-circuits
		// the demographic path: a patient who quoted their MRN does not need
		// to be fuzzy-matched against everyone who shares their surname.
		if in.IdentifierValue != "" {
			matches, err := s.searchByIdentifier(ctx, session, in, pageSize, restricted)
			if err != nil {
				return err
			}
			result.Matches = matches
			return s.auditSearch(ctx, session, "identifier", len(matches))
		}

		if in.Name != "" {
			matches, next, err := s.searchByName(ctx, scope, session, in, pageSize, restricted)
			if err != nil {
				return err
			}
			result.Matches, result.NextPageToken = matches, next
			return s.auditSearch(ctx, session, "name", len(matches))
		}

		// Birth date or phone alone: the blocking path, scored.
		matches, err := s.findDuplicates(ctx, session, domain.Demographics{
			BirthDate: in.BirthDate,
			Phones:    phoneOrNone(in.Phone),
		}, nil, "")
		if err != nil {
			return err
		}
		result.Matches = truncate(matches, pageSize)
		return s.auditSearch(ctx, session, "demographics", len(result.Matches))
	})
	if err != nil {
		return SearchPatientsResult{}, err
	}
	return result, nil
}

func (s *Service) searchByIdentifier(ctx context.Context, session authctx.Session,
	in SearchPatientsInput, pageSize int32, restricted bool) ([]MatchedPatient, error) {

	scope := session.TenantScope()
	identifierType := in.IdentifierType
	if identifierType == "" {
		identifierType = domain.IdentifierMRN
	}

	system := ""
	if identifierType == domain.IdentifierMRN {
		// An MRN is namespaced by the facility that issued it. Searching
		// without the namespace would return another site's patient who
		// happens to hold the same number.
		system = mrnSystem(session.ActiveFacilityID)
	} else if in.IdentifierSystem == "" {
		return nil, rpcerr.Invalid("EMPI_IDENTIFIER_SYSTEM_REQUIRED",
			"an identifier search needs the system that issued the value")
	} else {
		system = in.IdentifierSystem
	}

	found, err := s.patients.ByIdentifier(ctx, scope, identifierType, system, in.IdentifierValue, pageSize)
	if err != nil {
		return nil, err
	}

	out := make([]MatchedPatient, 0, len(found))
	for _, p := range found {
		held, err := s.identifiers.ForPatient(ctx, scope, p.ID())
		if err != nil {
			return nil, err
		}
		shown, masked := maskFor(p, restricted)
		out = append(out, MatchedPatient{
			Patient: shown, Identifiers: held, Masked: masked,
			// An exact identifier hit is not a fuzzy score. Reporting a
			// confidence would imply a judgement the system did not make.
			Match: domain.MatchResult{Score: 1, Outcome: domain.OutcomeProbable},
		})
	}
	return out, nil
}

func (s *Service) searchByName(ctx context.Context, scope authctx.TenantScope,
	session authctx.Session, in SearchPatientsInput, pageSize int32, restricted bool) (
	[]MatchedPatient, string, error) {

	cursor, err := decodeCursor(in.PageToken)
	if err != nil {
		return nil, "", err
	}

	// One extra row decides whether there is a next page, without a second
	// count query that would disagree with the page under concurrent writes.
	found, err := s.patients.ByName(ctx, scope, strings.ToLower(in.Name), cursor, pageSize+1)
	if err != nil {
		return nil, "", err
	}

	nextToken := ""
	if int32(len(found)) > pageSize {
		last := found[pageSize-1]
		nextToken = encodeCursor(ports.Cursor{
			FamilyName: strings.ToLower(last.Demographics.Name.Family),
			PatientID:  last.ID(),
		})
		found = found[:pageSize]
	}

	weights, thresholds, err := s.config.MatchConfig(ctx, scope)
	if err != nil {
		return nil, "", err
	}

	ids := make([]string, 0, len(found))
	for _, p := range found {
		ids = append(ids, p.ID())
	}
	identifiersByPatient, err := s.identifiers.ForPatients(ctx, scope, ids)
	if err != nil {
		return nil, "", err
	}

	proposed := domain.Demographics{
		Name:      domain.HumanName{Family: in.Name},
		BirthDate: in.BirthDate,
		Phones:    phoneOrNone(in.Phone),
	}

	out := make([]MatchedPatient, 0, len(found))
	for _, p := range found {
		held := identifiersByPatient[p.ID()]
		// Scored even on a plain name search, so the clerk sees which of five
		// people called Iyer is most likely to be the one at the desk.
		match := domain.Score(proposed, nil, domain.MatchCandidate{
			PatientID: p.ID(), Demographics: p.Demographics, Identifiers: held,
		}, weights, thresholds)

		shown, masked := maskFor(p, restricted)
		out = append(out, MatchedPatient{
			Patient: shown, Identifiers: held, Match: match, Masked: masked,
		})
	}
	return out, nextToken, nil
}

// GetPatientResult is one patient as the caller may see them.
type GetPatientResult struct {
	Patient     *domain.Patient
	Identifiers domain.IdentifierSet
	// ResolvedFrom names the record that was asked for, when a merge was
	// followed.
	ResolvedFrom string
	Masked       bool
}

// GetPatient reads one patient, optionally following a merge.
func (s *Service) GetPatient(ctx context.Context, patientID string, resolveMerged bool) (GetPatientResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return GetPatientResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientRead,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientRead, "patient", patientID, decision.Reason)
		return GetPatientResult{}, rpcerr.PermissionDenied("EMPI_READ_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	var result GetPatientResult

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, patientID)
		if err != nil {
			return err
		}

		if resolveMerged && patient.Status == domain.StatusMerged {
			survivor, err := s.resolveSurvivor(ctx, scope, patient)
			if err != nil {
				return err
			}
			result.ResolvedFrom = patient.ID()
			patient = survivor
		}

		held, err := s.identifiers.ForPatient(ctx, scope, patient.ID())
		if err != nil {
			return err
		}

		shown, masked := maskFor(patient, session.HasPermission(PermPatientReadRestricted))
		result.Patient, result.Identifiers, result.Masked = shown, held, masked

		context, err := json.Marshal(map[string]any{"masked": masked, "resolved": result.ResolvedFrom != ""})
		if err != nil {
			return rpcerr.Internal("EMPI_AUDIT_ENCODE_FAILED", "could not encode audit context").WithCause(err)
		}
		return s.auditRead(ctx, session, patient.ID(), context)
	})
	if err != nil {
		return GetPatientResult{}, err
	}
	return result, nil
}

// maxMergeDepth bounds the walk from a merged record to its survivor.
//
// A merged into B into C is normal — two merges on different days. A cycle is
// not, and the database forbids the one-step case; this is the backstop for a
// longer one, so a corrupted chain answers with an error rather than hanging
// the request.
const maxMergeDepth = 10

func (s *Service) resolveSurvivor(ctx context.Context, scope authctx.TenantScope,
	p *domain.Patient) (*domain.Patient, error) {

	seen := map[string]bool{p.ID(): true}
	current := p

	for range maxMergeDepth {
		if current.Status != domain.StatusMerged || current.MergedIntoPatientID == "" {
			return current, nil
		}
		if seen[current.MergedIntoPatientID] {
			return nil, rpcerr.Internal("EMPI_MERGE_CYCLE",
				"the merge chain for this patient loops")
		}
		seen[current.MergedIntoPatientID] = true

		next, err := s.patients.GetByID(ctx, scope, current.MergedIntoPatientID)
		if err != nil {
			return nil, err
		}
		current = next
	}
	return nil, rpcerr.Internal("EMPI_MERGE_CHAIN_TOO_LONG",
		"the merge chain for this patient is longer than the resolver follows")
}

// UpdateDemographicsInput corrects a patient's demographics.
type UpdateDemographicsInput struct {
	PatientID       string
	Demographics    domain.Demographics
	ExpectedVersion int64
}

// UpdateDemographics applies a correction.
func (s *Service) UpdateDemographics(ctx context.Context, in UpdateDemographicsInput) (*domain.Patient, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermPatientUpdate,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermPatientUpdate, "patient", in.PatientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("EMPI_UPDATE_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var updated *domain.Patient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if in.ExpectedVersion != 0 && patient.Version != in.ExpectedVersion {
			return rpcerr.FailedPrecondition("EMPI_VERSION_CONFLICT",
				"the record changed since it was read")
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

		if err := patient.UpdateDemographics(in.Demographics, registrationPolicy, now); err != nil {
			return registrationError(err)
		}
		if err := s.patients.UpdateDemographics(ctx, scope, patient); err != nil {
			return err
		}

		// The event carries no demographic values. A correction is interesting
		// downstream — a projection has to refresh — and what changed is not
		// something every subscriber needs a copy of (SRS-API-009).
		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(),
			"version":    patient.Version,
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientDemographicsUpdated,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		updated = patient
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientUpdate,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return updated, nil
}

// ConfirmIdentity moves a candidate to active.
func (s *Service) ConfirmIdentity(ctx context.Context, patientID string, expectedVersion int64) (*domain.Patient, error) {
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
		return nil, rpcerr.PermissionDenied("EMPI_CONFIRM_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()
	var confirmed *domain.Patient

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		patient, err := s.patients.GetByID(ctx, scope, patientID)
		if err != nil {
			return err
		}
		if expectedVersion != 0 && patient.Version != expectedVersion {
			return rpcerr.FailedPrecondition("EMPI_VERSION_CONFLICT",
				"the record changed since it was read")
		}
		if err := patient.Confirm(now); err != nil {
			return rpcerr.FailedPrecondition("EMPI_CONFIRM_REFUSED", err.Error())
		}
		if err := s.patients.SetStatus(ctx, scope, patient); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"patient_id": patient.ID(), "status": string(patient.Status),
		})
		if err != nil {
			return rpcerr.Internal("EMPI_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventPatientIdentityConfirmed,
			"patient", patient.ID(), payload, now); err != nil {
			return err
		}

		confirmed = patient
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPatientManage,
			ResourceType: "patient", ResourceID: patient.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "identity confirmed",
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return confirmed, nil
}

// auditSearch records that a search happened and how many records it touched.
//
// The terms are NOT recorded. A search for "Iyer" is a search for a person,
// and an audit trail that stores the query becomes a second copy of the
// patient index — searchable by everyone with audit access, and outside every
// masking rule (SRS-API-009). The count is what a reviewer needs: it
// distinguishes a clerk looking somebody up from a script enumerating the
// register.
func (s *Service) auditSearch(ctx context.Context, session authctx.Session, mode string, results int) error {
	context, err := json.Marshal(map[string]any{"mode": mode, "results": results})
	if err != nil {
		return rpcerr.Internal("EMPI_AUDIT_ENCODE_FAILED", "could not encode audit context").WithCause(err)
	}
	return s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermPatientRead,
		ResourceType: "patient_search", Outcome: audit.OutcomeSuccess,
		Context: context,
	}, s.clock.Now())
}

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

func truncate(in []MatchedPatient, limit int32) []MatchedPatient {
	if int32(len(in)) <= limit {
		return in
	}
	return in[:limit]
}

func phoneOrNone(phone string) []domain.ContactPoint {
	if strings.TrimSpace(phone) == "" {
		return nil
	}
	normalised, err := domain.Demographics{
		Phones: []domain.ContactPoint{{System: domain.ContactPhone, Value: phone}},
	}.Normalise()
	if err != nil {
		return nil
	}
	return normalised.Phones
}

// encodeCursor renders a keyset position as an opaque token.
//
// Opaque because a client that can read it will eventually construct one, and
// then the cursor's shape is part of the API contract (Domain/Data §6).
func encodeCursor(c ports.Cursor) string {
	raw, err := json.Marshal(c)
	if err != nil {
		return ""
	}
	return base64.RawURLEncoding.EncodeToString(raw)
}

func decodeCursor(token string) (ports.Cursor, error) {
	if token == "" {
		return ports.Cursor{}, nil
	}
	raw, err := base64.RawURLEncoding.DecodeString(token)
	if err != nil {
		return ports.Cursor{}, rpcerr.Invalid("EMPI_PAGE_TOKEN_INVALID", "page token is not valid")
	}
	var c ports.Cursor
	if err := json.Unmarshal(raw, &c); err != nil {
		return ports.Cursor{}, rpcerr.Invalid("EMPI_PAGE_TOKEN_INVALID", "page token is not valid")
	}
	return c, nil
}

// mapConflict turns a repository concurrency failure into the wire contract.
//
// The repository's error says the row moved; the caller needs to know to
// re-read rather than that something broke.
func mapConflict(err error) error {
	if err == nil {
		return nil
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("EMPI_VERSION_CONFLICT", "the record changed since it was read")
	}
	var conflict domain.ErrIdentifierConflict
	if errors.As(err, &conflict) {
		return rpcerr.AlreadyExists("EMPI_IDENTIFIER_IN_USE", conflict.Error())
	}
	return err
}
