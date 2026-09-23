package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// RequestPostmortemInput asks for an examination (SRS-MORT-005).
type RequestPostmortemInput struct {
	CaseID string
	Kind   string
	Reason string
}

// RequestPostmortem records the ask (SRS-MORT-005).
func (s *Service) RequestPostmortem(ctx context.Context,
	in RequestPostmortemInput) (domain.Postmortem, error) {

	session, scope, err := s.authorize(ctx, PermPostmortemRequest)
	if err != nil {
		return domain.Postmortem{}, err
	}
	now := s.clock.Now()

	var out domain.Postmortem
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		request, err := domain.RequestPostmortem(s.ids.NewID(),
			session.TenantID, found, domain.NewPostmortemInput{
				Kind: domain.PostmortemKind(in.Kind), Reason: in.Reason,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}
		if err := s.postmortems.InsertPostmortem(ctx, scope,
			request); err != nil {
			return err
		}
		out = request
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.postmortem.requested",
			ResourceType: "mortuary.postmortem", ResourceID: request.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
			Context: auditContext(map[string]string{
				"case_id": found.ID, "kind": string(request.Kind),
			}),
		}, now)
	})
	if err != nil {
		return domain.Postmortem{}, err
	}
	return out, nil
}

// AdvancePostmortemInput moves a request along (SRS-MORT-005).
type AdvancePostmortemInput struct {
	PostmortemID string
	// To is authorised, performed, reported or declined.
	To                 string
	Authority          string
	AuthorityReference string
	Pathologist        string
	ReportRef          string
	Reason             string
	Version            int64
}

// AdvancePostmortem records an authorisation, an examination, a report or a
// decline (SRS-MORT-005).
//
// One use case rather than four, because the workflow is a sequence and the
// domain holds which step may follow which: four entry points would each have
// to remember, and the fourth one added later would not.
func (s *Service) AdvancePostmortem(ctx context.Context,
	in AdvancePostmortemInput) (domain.Postmortem, error) {

	session, scope, err := s.authorize(ctx, PermPostmortemManage)
	if err != nil {
		return domain.Postmortem{}, err
	}
	now := s.clock.Now()

	var out domain.Postmortem
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		request, err := s.postmortems.Postmortem(ctx, scope,
			in.PostmortemID)
		if err != nil {
			return err
		}

		switch domain.PostmortemState(in.To) {
		case domain.PostmortemAuthorised:
			err = request.Authorise(in.Authority, in.AuthorityReference,
				session.SubjectID, now)
		case domain.PostmortemPerformed:
			err = request.Perform(in.Pathologist, now)
		case domain.PostmortemReported:
			err = request.Report(in.ReportRef, now)
		case domain.PostmortemDeclined:
			err = request.Decline(in.Reason, session.SubjectID, now)
		default:
			return mortuaryError(errUnknownStep(in.To))
		}
		if err != nil {
			return mortuaryError(err)
		}

		if err := s.postmortems.UpdatePostmortem(ctx, scope, request,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		request.Version = in.Version + 1
		out = request

		if err := s.appendCustody(ctx, scope, request.CaseID,
			"postmortem_"+in.To, string(request.Kind)+
				" examination "+in.To, "", "", session.SubjectID,
			now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.postmortem." + in.To,
			ResourceType: "mortuary.postmortem", ResourceID: request.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Reason,
			Context: auditContext(map[string]string{
				"authority": request.Authority,
				"reference": request.AuthorityReference,
			}),
		}, now)
	})
	if err != nil {
		return domain.Postmortem{}, err
	}
	return out, nil
}

// Postmortems reads a case's examination requests (SRS-MORT-005).
func (s *Service) Postmortems(ctx context.Context, caseID string) (
	[]domain.Postmortem, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.postmortems.Postmortems(ctx, scope, []string{caseID})
}

// RecordAuthorisationInput takes an authority's clearance to release
// (SRS-MORT-006, SRS-MORT-007).
type RecordAuthorisationInput struct {
	CaseID    string
	Authority string
	Reference string
	Note      string
}

// RecordAuthorisation records an authority's clearance (SRS-MORT-006).
//
// Its own permission, because this is the thing standing between a
// medico-legal or unidentified case and the door.
func (s *Service) RecordAuthorisation(ctx context.Context,
	in RecordAuthorisationInput) (domain.Authorisation, error) {

	session, scope, err := s.authorize(ctx, PermAuthorise)
	if err != nil {
		return domain.Authorisation{}, err
	}
	now := s.clock.Now()

	auth := domain.Authorisation{
		Authority: in.Authority, Reference: in.Reference,
		RecordedBy: session.SubjectID, RecordedAt: now.UTC(),
		Note: in.Note,
	}
	if !auth.Held() {
		return domain.Authorisation{}, mortuaryError(
			errClearanceIncomplete())
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		if err := s.releases.InsertAuthorisation(ctx, scope,
			s.ids.NewID(), found.ID, auth); err != nil {
			return err
		}
		if err := s.appendCustody(ctx, scope, found.ID, "authorised",
			"release cleared by "+auth.Authority, auth.Authority,
			session.SubjectID, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.release.authorised",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess, Reason: in.Note,
			Context: auditContext(map[string]string{
				"authority": auth.Authority,
				"reference": auth.Reference,
			}),
		}, now)
	})
	if err != nil {
		return domain.Authorisation{}, err
	}
	return auth, nil
}

// ReleaseInput hands a body over (SRS-MORT-006).
type ReleaseInput struct {
	CaseID              string
	RecipientName       string
	RecipientRelation   string
	RecipientIDType     string
	RecipientIDRef      string
	VerificationNote    string
	SignatureRef        string
	DeathCertificateRef string
	Destination         string
	WitnessedBy         string
	Note                string
	Version             int64
}

// Release hands a body over and closes the case (SRS-MORT-006,
// SRS-MORT-007).
//
// Everything the checks need is read inside the transaction: the clearance,
// what the mortuary still holds, and the examinations that are not finished.
// There is no parameter that skips a check and no other method that releases.
func (s *Service) Release(ctx context.Context, in ReleaseInput) (
	domain.Release, error) {

	session, scope, err := s.authorize(ctx, PermRelease)
	if err != nil {
		return domain.Release{}, err
	}
	now := s.clock.Now()

	var out domain.Release
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.cases.Case(ctx, scope, in.CaseID)
		if err != nil {
			return err
		}
		auth, outstanding, blocking, err := s.releaseContext(ctx, scope,
			found.ID)
		if err != nil {
			return err
		}

		release, err := domain.ReleaseBody(s.ids.NewID(),
			session.TenantID, &found, s.config.Release, auth,
			outstanding, blocking, domain.ReleaseInput{
				RecipientName:       in.RecipientName,
				RecipientRelation:   in.RecipientRelation,
				RecipientIDType:     in.RecipientIDType,
				RecipientIDRef:      in.RecipientIDRef,
				VerificationNote:    in.VerificationNote,
				SignatureRef:        in.SignatureRef,
				DeathCertificateRef: in.DeathCertificateRef,
				Destination:         in.Destination,
				WitnessedBy:         in.WitnessedBy, Note: in.Note,
			}, session.SubjectID, now)
		if err != nil {
			return mortuaryError(err)
		}

		// The body leaves its space in the same transaction. A placement
		// left open is a drawer the board never offers again.
		current, err := s.storage.CurrentPlacement(ctx, scope, found.ID)
		switch {
		case err == nil:
			if err := current.End("released", session.SubjectID,
				now); err != nil {
				return mortuaryError(err)
			}
			if err := s.storage.EndPlacement(ctx, scope,
				current); err != nil {
				return mortuaryError(err)
			}
		case isNotFound(err):
		default:
			return err
		}

		if err := s.releases.InsertRelease(ctx, scope,
			release); err != nil {
			return err
		}
		if err := s.cases.UpdateCase(ctx, scope, found,
			in.Version); err != nil {
			return mortuaryError(err)
		}
		out = release

		if err := s.appendCustody(ctx, scope, found.ID, "released",
			"body released to "+release.RecipientName,
			session.SubjectID, release.RecipientName, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "mortuary.case.released",
			ResourceType: "mortuary.case", ResourceID: found.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"recipient":     release.RecipientName,
				"authority":     release.Authority,
				"signature_ref": release.SignatureRef,
			}),
		}, now); err != nil {
			return err
		}
		// Identifiers and a flag. Never the recipient's name: a release
		// event naming the family is a bereavement on a message bus.
		return s.appendEvent(ctx, session, EventCaseReleased,
			"mortuary.case", found.ID, map[string]any{
				"medico_legal": release.MedicoLegal,
				"authorised":   release.Authority != "",
			}, now)
	})
	if err != nil {
		return domain.Release{}, err
	}
	return out, nil
}

// ReleaseChecks reports what stands between a case and the door
// (SRS-MORT-006, SRS-MORT-007).
//
// The whole list at once, so a mortuary can clear it in one pass rather than
// discovering it an item at a time.
func (s *Service) ReleaseChecks(ctx context.Context, caseID string) (
	[]domain.ReleaseCheck, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.cases.Case(ctx, scope, caseID)
	if err != nil {
		return nil, err
	}
	auth, outstanding, blocking, err := s.releaseContext(ctx, scope,
		found.ID)
	if err != nil {
		return nil, err
	}
	// Probed with the recipient fields filled, because the question here
	// is what the mortuary still has to do rather than whether somebody
	// has typed the family's name yet.
	return domain.ReleaseChecks(found, s.config.Release, auth, outstanding,
		blocking, domain.ReleaseInput{
			RecipientName: "pending", SignatureRef: "pending",
			VerificationNote: "pending", RecipientIDType: "pending",
			RecipientIDRef: "pending",
		}), nil
}

// releaseContext reads the three things the checks depend on.
func (s *Service) releaseContext(ctx context.Context,
	scope authctx.TenantScope, caseID string) (domain.Authorisation,
	[]domain.Item, []domain.Postmortem, error) {

	auth, err := s.releases.LatestAuthorisation(ctx, scope, caseID)
	if err != nil {
		return domain.Authorisation{}, nil, nil, err
	}
	items, err := s.custody.Items(ctx, scope, []string{caseID})
	if err != nil {
		return domain.Authorisation{}, nil, nil, err
	}
	requests, err := s.postmortems.Postmortems(ctx, scope,
		[]string{caseID})
	if err != nil {
		return domain.Authorisation{}, nil, nil, err
	}
	return auth, domain.Outstanding(items, caseID),
		domain.Blocking(requests, caseID), nil
}

// Release reads how a body left (SRS-MORT-006).
func (s *Service) ReleaseRecord(ctx context.Context, caseID string) (
	domain.Release, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Release{}, err
	}
	return s.releases.Release(ctx, scope, caseID)
}

// ListReleasesInput narrows a release list.
type ListReleasesInput struct {
	From     time.Time
	To       time.Time
	PageSize int32
	Offset   int32
}

// ListReleases reads recent releases (SRS-MORT-006).
func (s *Service) ListReleases(ctx context.Context,
	in ListReleasesInput) ([]domain.Release, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return nil, err
	}
	return s.releases.Releases(ctx, scope, ports.ReleaseFilter{
		From: in.From, To: in.To,
		Limit: clampPageSize(in.PageSize), Offset: in.Offset,
	})
}
