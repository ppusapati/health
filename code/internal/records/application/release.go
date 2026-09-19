package application

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"sort"
	"strconv"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// NewReleaseInput logs a request for a copy of a record (SRS-MRD-004).
type NewReleaseInput struct {
	Reference     string
	PatientID     string
	Purpose       string
	Authorisation domain.Authorisation
	Recipient     domain.Recipient
	Scope         domain.ReleaseScope
}

// RequestRelease logs a request (SRS-MRD-004).
func (s *Service) RequestRelease(ctx context.Context, in NewReleaseInput) (
	domain.ReleaseRequest, error) {

	session, scope, err := s.authorize(ctx, PermReleaseRequest)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	now := s.clock.Now()

	request, err := domain.RequestRelease(s.ids.NewID(), session.TenantID,
		domain.NewReleaseInput{
			Reference: in.Reference, PatientID: in.PatientID,
			Purpose: in.Purpose, Authorisation: in.Authorisation,
			Recipient: in.Recipient, Scope: in.Scope,
		}, session.SubjectID, now)
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.releases.InsertRelease(ctx, scope, request); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.release.requested", ResourceType: "mrd_release",
			ResourceID: request.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"authority": string(request.Authorisation.Kind),
				"recipient": string(request.Recipient.Kind),
				"scope":     request.Scope.ScopeSummary(),
			}),
			Reason: request.Purpose,
		}, now)
	})
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}
	return request, nil
}

// ApproveRelease decides a patient's record may leave the hospital
// (SRS-MRD-004).
//
// The authority is re-checked at approval rather than trusted from the
// request: a consent that expired between the two is a consent that does not
// authorise anything, and the gap between asking and sending is where that
// happens.
func (s *Service) ApproveRelease(ctx context.Context, releaseID string) (
	domain.ReleaseRequest, error) {

	session, scope, err := s.authorize(ctx, PermReleaseApprove)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	now := s.clock.Now()

	var approved domain.ReleaseRequest
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.releases.Release(ctx, scope, releaseID)
		if err != nil {
			return err
		}
		expected := request.Version
		if err := request.Approve(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.releases.UpdateRelease(ctx, scope, request,
			expected); err != nil {
			return err
		}
		approved = request

		if err := s.appendEvent(ctx, session, EventReleaseApproved,
			"mrd_release", request.ID, map[string]any{
				"authority": string(request.Authorisation.Kind),
				"recipient": string(request.Recipient.Kind),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.release.approved", ResourceType: "mrd_release",
			ResourceID: request.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"authority_reference": request.Authorisation.Reference,
			}),
			Reason: "approved a record release",
		}, now)
	})
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}
	return approved, nil
}

// RefuseRelease turns a request down with its reason (SRS-MRD-004).
func (s *Service) RefuseRelease(ctx context.Context, releaseID,
	reason string) (domain.ReleaseRequest, error) {

	session, scope, err := s.authorize(ctx, PermReleaseApprove)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	now := s.clock.Now()

	var refused domain.ReleaseRequest
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.releases.Release(ctx, scope, releaseID)
		if err != nil {
			return err
		}
		expected := request.Version
		if err := request.Refuse(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.releases.UpdateRelease(ctx, scope, request,
			expected); err != nil {
			return err
		}
		refused = request
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.release.refused", ResourceType: "mrd_release",
			ResourceID: request.ID, Outcome: audit.OutcomeSuccess,
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}
	return refused, nil
}

// AssembleRelease builds the package from the approved scope (SRS-MRD-004).
//
// Every candidate is checked against the scope by the domain, and restricted
// material is held back unless the scope asked for it. The manifest is hashed
// so "what exactly did we send" has one answer: a package described only by
// its scope is one that cannot be reproduced after the documents change.
func (s *Service) AssembleRelease(ctx context.Context, releaseID string) (
	domain.ReleaseRequest, error) {

	session, scope, err := s.authorize(ctx, PermReleaseAssemble)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	now := s.clock.Now()

	var assembled domain.ReleaseRequest
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.releases.Release(ctx, scope, releaseID)
		if err != nil {
			return err
		}
		items, err := s.candidateItems(ctx, scope, request)
		if err != nil {
			return err
		}
		expected := request.Version
		if err := request.Assemble(items, manifestHash(items),
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.releases.UpdateRelease(ctx, scope, request,
			expected); err != nil {
			return err
		}
		assembled = request

		pages := 0
		if request.Package != nil {
			pages = request.Package.Pages
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.release.assembled", ResourceType: "mrd_release",
			ResourceID: request.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"items": itoa(len(items)), "pages": itoa(pages),
				"content_hash": manifestHash(items),
			}),
			Reason: "assembled a release package",
		}, now)
	})
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}
	return assembled, nil
}

// SendRelease records the package leaving the hospital and files the
// disclosure (SRS-MRD-004, SRS-MRD-010).
//
// One transaction, because the accounting of disclosures is the patient's
// answer to "who has seen my record". A release that went out and a
// disclosure that did not get written is a release the patient cannot find
// out about.
func (s *Service) SendRelease(ctx context.Context, releaseID string) (
	domain.ReleaseRequest, error) {

	session, scope, err := s.authorize(ctx, PermReleaseAssemble)
	if err != nil {
		return domain.ReleaseRequest{}, err
	}
	now := s.clock.Now()

	var sent domain.ReleaseRequest
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.releases.Release(ctx, scope, releaseID)
		if err != nil {
			return err
		}
		expected := request.Version
		if err := request.Release(session.SubjectID, now); err != nil {
			return err
		}
		if err := s.releases.UpdateRelease(ctx, scope, request,
			expected); err != nil {
			return err
		}
		sent = request

		items, pages := 0, 0
		if request.Package != nil {
			items, pages = len(request.Package.Items), request.Package.Pages
		}
		disclosure, err := domain.RecordDisclosure(s.ids.NewID(),
			session.TenantID, request.PatientID, domain.DisclosureRelease,
			request.ID, session.SubjectID, request.Purpose,
			request.Scope.ScopeSummary(), request.Recipient, items, pages,
			now)
		if err != nil {
			return err
		}
		if err := s.releases.InsertDisclosure(ctx, scope,
			disclosure); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventReleaseSent,
			"mrd_release", request.ID, map[string]any{
				"recipient": string(request.Recipient.Kind),
				"items":     items, "pages": pages,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.release.sent", ResourceType: "mrd_release",
			ResourceID: request.ID, Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"disclosure_id": disclosure.ID,
				"recipient":     request.Recipient.Reference,
			}),
			Reason: "a record left the hospital",
		}, now)
	})
	if err != nil {
		return domain.ReleaseRequest{}, recordsError(err)
	}
	return sent, nil
}

// RecordDisclosure files a disclosure that did not go through a release —
// an export, a print (SRS-MRD-010).
//
// Here because the accounting has to cover them. A patient asking who has
// seen their record is not asking only about the copies the records office
// posted, and an accounting that answers only for those is one that
// understates itself by however much the rest of the hospital prints.
func (s *Service) RecordDisclosure(ctx context.Context, patientID string,
	kind domain.DisclosureKind, purpose, scopeSummary string,
	recipient domain.Recipient, items, pages int) (domain.Disclosure, error) {

	session, scope, err := s.authorize(ctx, PermReleaseAssemble)
	if err != nil {
		return domain.Disclosure{}, err
	}
	now := s.clock.Now()

	disclosure, err := domain.RecordDisclosure(s.ids.NewID(),
		session.TenantID, patientID, kind, "", session.SubjectID, purpose,
		scopeSummary, recipient, items, pages, now)
	if err != nil {
		return domain.Disclosure{}, recordsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.releases.InsertDisclosure(ctx, scope,
			disclosure); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "records.disclosure.recorded",
			ResourceType: "mrd_disclosure", ResourceID: disclosure.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"kind": string(kind), "recipient": recipient.Reference,
			}),
			Reason: purpose,
		}, now)
	})
	if err != nil {
		return domain.Disclosure{}, recordsError(err)
	}
	return disclosure, nil
}

// Disclosures answers "who has seen my record" (SRS-MRD-010).
//
// Its own permission, and reading it is itself audited: an accounting of
// disclosures that can be read without leaving a trace has a hole in exactly
// the shape of the thing it exists to record.
func (s *Service) Disclosures(ctx context.Context,
	filter ports.DisclosureFilter) ([]domain.Disclosure, error) {

	session, scope, err := s.authorize(ctx, PermDisclosureRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	filter.Limit = clampPageSize(filter.Limit)
	disclosures, err := s.releases.Disclosures(ctx, scope, filter)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "records.disclosures.read", ResourceType: "mrd_disclosure",
		ResourceID: filter.PatientID, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"rows": itoa(len(disclosures)),
		}),
		Reason: "read the accounting of disclosures",
	}, now); err != nil {
		return nil, err
	}
	return disclosures, nil
}

// Releases lists release requests (SRS-MRD-004).
func (s *Service) Releases(ctx context.Context, filter ports.ReleaseFilter) (
	[]domain.ReleaseRequest, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	filter.Limit = clampPageSize(filter.Limit)
	return s.releases.Releases(ctx, scope, filter)
}

// candidateItems lists what the approved scope could cover (SRS-MRD-004).
//
// Built from the encounters the scope names, or from the patient's whole
// record where the request asked for that. A retracted document is never a
// candidate: it was withdrawn from the chart, and sending it because it is
// still in the table would be releasing something the hospital has said is
// not part of the record.
//
// Restriction is decided here, from the deployment's configured list, and the
// domain holds the restricted items back unless the approved scope asked for
// them. Marking them at assembly rather than at request time means a kind
// added to the list today is restricted in tomorrow's packages without
// anybody re-approving yesterday's.
func (s *Service) candidateItems(ctx context.Context,
	scope authctx.TenantScope, request domain.ReleaseRequest) (
	[]domain.ReleaseItem, error) {

	if s.encounters == nil || s.documents == nil {
		return nil, rpcerr.FailedPrecondition("MRD_NO_CHART_SOURCE",
			"this deployment has no document source wired, so a release "+
				"cannot be assembled")
	}

	encounterIDs := request.Scope.EncounterIDs
	if len(encounterIDs) == 0 {
		if !request.Scope.WholeRecord {
			// Unreachable through the domain, which refuses a scope that
			// asks for nothing, and through the database, which refuses it
			// again. Named rather than assumed away.
			return nil, rpcerr.FailedPrecondition("MRD_EMPTY_SCOPE",
				"this release names no encounters and is not a whole-record "+
					"request")
		}
		found, err := s.encounters.ForPatient(ctx, scope, request.PatientID)
		if err != nil {
			return nil, err
		}
		for _, facts := range found {
			encounterIDs = append(encounterIDs, facts.EncounterID)
		}
	}

	var items []domain.ReleaseItem
	for _, encounterID := range encounterIDs {
		facts, err := s.encounters.Describe(ctx, scope, encounterID)
		if err != nil {
			return nil, err
		}
		documents, err := s.documents.ForEncounter(ctx, scope,
			facts.PatientID, encounterID)
		if err != nil {
			return nil, err
		}
		for _, document := range documents {
			if document.Retracted {
				continue
			}
			item := domain.ReleaseItem{
				DocumentID: document.DocumentID, EncounterID: encounterID,
				Kind: document.Kind, RecordClass: facts.Class,
				OccurredAt: document.CreatedAt,
				Restricted: s.restricted(document.Kind),
			}
			// Filtered here rather than offered and refused. The domain
			// checks every item against the scope again, which is the guard
			// against a caller that supplies its own list; this is what
			// decides that a whole-record release does not quietly pick up
			// the psychiatry notes.
			if !request.Scope.Covers(item) {
				continue
			}
			items = append(items, item)
		}
	}
	return items, nil
}

// manifestHash pins exactly what went out (SRS-MRD-004).
//
// Over the document identifiers in a fixed order, so the same package hashes
// the same twice and a different one never does. Not over the content: this
// context does not hold the content, and a hash of what it does hold is what
// makes the manifest checkable a year later.
func manifestHash(items []domain.ReleaseItem) string {
	ids := make([]string, 0, len(items))
	for _, item := range items {
		ids = append(ids, item.DocumentID+"\x00"+strconv.Itoa(item.Pages))
	}
	sort.Strings(ids)

	digest := sha256.New()
	for _, id := range ids {
		digest.Write([]byte(id))
		digest.Write([]byte{0})
	}
	return hex.EncodeToString(digest.Sum(nil))
}
