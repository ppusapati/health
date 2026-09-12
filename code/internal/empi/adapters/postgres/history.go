package postgres

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/effective"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Demographic history, preferences and related persons (SRS-EMPI-007/009).

// HistoryRepo implements the history repository port.
type HistoryRepo struct{ *Repository }

var _ ports.HistoryRepository = HistoryRepo{}

func windowEnd(w effective.Window) pgtype.Timestamptz {
	if w.OpenEnded() {
		return pgtype.Timestamptz{}
	}
	return timestamptz(w.Until)
}

// RecordName opens a new name window, closing the previous one of the same kind.
//
// Both statements in the caller's transaction: a close without its open leaves
// a patient with no current name, and an open without its close leaves two.
func (r HistoryRepo) RecordName(ctx context.Context, scope authctx.TenantScope, n domain.PatientName) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	nameID, err := uuid.Parse(n.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_NAME_ID_INVALID", "name_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(n.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	q := r.queries(ctx)
	// Close first. The partial unique index permits one open window per kind,
	// so inserting before closing would be rejected by the database — which is
	// the right failure, but a confusing one to read in a log.
	if _, err := q.CloseOpenPatientName(ctx, sqlcgen.CloseOpenPatientNameParams{
		EffectiveUntil: timestamptz(n.Window.From),
		TenantID:       tenantID, PatientID: patientID, Kind: string(n.Kind),
	}); err != nil {
		return err
	}

	return q.InsertPatientName(ctx, sqlcgen.InsertPatientNameParams{
		NameID: nameID, TenantID: tenantID, PatientID: patientID, Kind: string(n.Kind),
		FamilyName: n.Name.Family, GivenNames: n.Name.Given,
		NamePrefix: n.Name.Prefix, NameSuffix: n.Name.Suffix,
		EffectiveFrom: timestamptz(n.Window.From), EffectiveUntil: windowEnd(n.Window),
		RecordedBy: n.RecordedBy, RecordedAt: timestamptz(n.RecordedAt), Source: n.Source,
	})
}

// Names returns every name a patient has been known by.
func (r HistoryRepo) Names(ctx context.Context, scope authctx.TenantScope,
	patientID string) (domain.NameHistory, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPatientNames(ctx, sqlcgen.ListPatientNamesParams{
		TenantID: tenantID, PatientID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.NameHistory, 0, len(rows))
	for _, row := range rows {
		n := domain.PatientName{
			ID: row.NameID.String(), PatientID: row.PatientID.String(),
			Kind: domain.NameKind(row.Kind),
			Name: domain.HumanName{
				Family: row.FamilyName, Given: row.GivenNames,
				Prefix: row.NamePrefix, Suffix: row.NameSuffix,
			},
			Window:     effective.Window{From: row.EffectiveFrom.Time.UTC()},
			RecordedBy: row.RecordedBy, RecordedAt: row.RecordedAt.Time.UTC(),
			Source: row.Source,
		}
		if row.EffectiveUntil.Valid {
			n.Window.Until = row.EffectiveUntil.Time.UTC()
		}
		out = append(out, n)
	}
	return out, nil
}

// MatchingFormerNames reports which closed name brought each patient into a
// name search.
//
// The query orders by effective_until descending, so the first row seen for a
// patient is the most recently held matching name — the one a clerk is most
// likely to recognise.
func (r HistoryRepo) MatchingFormerNames(ctx context.Context, scope authctx.TenantScope,
	patientIDs []string, prefix string) (map[string]domain.PatientName, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if len(patientIDs) == 0 || prefix == "" {
		return nil, nil
	}

	ids := make([]uuid.UUID, 0, len(patientIDs))
	for _, raw := range patientIDs {
		id, err := uuid.Parse(raw)
		if err != nil {
			// A caller-supplied identifier that is not a UUID cannot match
			// anything; skipping it keeps one bad value from failing the
			// whole search.
			continue
		}
		ids = append(ids, id)
	}
	if len(ids) == 0 {
		return nil, nil
	}

	rows, err := r.queries(ctx).MatchingFormerNames(ctx, sqlcgen.MatchingFormerNamesParams{
		TenantID: tenantID, PatientIds: ids, FamilyPrefix: prefix,
	})
	if err != nil {
		return nil, err
	}

	out := make(map[string]domain.PatientName, len(rows))
	for _, row := range rows {
		patientID := row.PatientID.String()
		if _, seen := out[patientID]; seen {
			continue
		}
		n := domain.PatientName{
			ID: row.NameID.String(), PatientID: patientID,
			Kind: domain.NameKind(row.Kind),
			Name: domain.HumanName{
				Family: row.FamilyName, Given: row.GivenNames,
				Prefix: row.NamePrefix, Suffix: row.NameSuffix,
			},
			Window:     effective.Window{From: row.EffectiveFrom.Time.UTC()},
			RecordedBy: row.RecordedBy, RecordedAt: row.RecordedAt.Time.UTC(),
			Source: row.Source,
		}
		if row.EffectiveUntil.Valid {
			n.Window.Until = row.EffectiveUntil.Time.UTC()
		}
		out[patientID] = n
	}
	return out, nil
}

// RecordPreference opens a preference window, closing the previous one.
func (r HistoryRepo) RecordPreference(ctx context.Context, scope authctx.TenantScope,
	p domain.CommunicationPreference) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	preferenceID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_PREFERENCE_ID_INVALID", "preference_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	q := r.queries(ctx)
	if _, err := q.CloseOpenCommunicationPreference(ctx, sqlcgen.CloseOpenCommunicationPreferenceParams{
		EffectiveUntil: timestamptz(p.Window.From),
		TenantID:       tenantID, PatientID: patientID,
		Channel: string(p.Channel), Purpose: string(p.Purpose),
	}); err != nil {
		return err
	}

	return q.InsertCommunicationPreference(ctx, sqlcgen.InsertCommunicationPreferenceParams{
		PreferenceID: preferenceID, TenantID: tenantID, PatientID: patientID,
		Channel: string(p.Channel), Purpose: string(p.Purpose), Allowed: p.Allowed,
		EffectiveFrom: timestamptz(p.Window.From), EffectiveUntil: windowEnd(p.Window),
		RecordedBy: p.RecordedBy, RecordedAt: timestamptz(p.RecordedAt),
	})
}

// Preferences returns a patient's communication preferences.
func (r HistoryRepo) Preferences(ctx context.Context, scope authctx.TenantScope,
	patientID string) (domain.PreferenceSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListCommunicationPreferences(ctx, sqlcgen.ListCommunicationPreferencesParams{
		TenantID: tenantID, PatientID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make(domain.PreferenceSet, 0, len(rows))
	for _, row := range rows {
		p := domain.CommunicationPreference{
			ID: row.PreferenceID.String(), PatientID: row.PatientID.String(),
			Channel:    domain.CommunicationChannel(row.Channel),
			Purpose:    domain.CommunicationPurpose(row.Purpose),
			Allowed:    row.Allowed,
			Window:     effective.Window{From: row.EffectiveFrom.Time.UTC()},
			RecordedBy: row.RecordedBy, RecordedAt: row.RecordedAt.Time.UTC(),
		}
		if row.EffectiveUntil.Valid {
			p.Window.Until = row.EffectiveUntil.Time.UTC()
		}
		out = append(out, p)
	}
	return out, nil
}

// RecordRelatedPerson stores a relationship.
func (r HistoryRepo) RecordRelatedPerson(ctx context.Context, scope authctx.TenantScope,
	p domain.RelatedPerson) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	relationshipID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("EMPI_RELATIONSHIP_ID_INVALID", "relationship_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(p.PatientID)
	if err != nil {
		return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "patient_id must be a UUID").WithCause(err)
	}

	var related pgtype.UUID
	if p.RelatedPatientID != "" {
		parsed, parseErr := uuid.Parse(p.RelatedPatientID)
		if parseErr != nil {
			return rpcerr.Internal("EMPI_PATIENT_ID_INVALID", "related_patient_id must be a UUID").WithCause(parseErr)
		}
		related = pgtype.UUID{Bytes: parsed, Valid: true}
	}

	contact := p.Contact
	if contact == nil {
		contact = []domain.ContactPoint{}
	}
	encodedContact, err := json.Marshal(contact)
	if err != nil {
		return rpcerr.Internal("EMPI_ENCODE_FAILED", "could not encode contact details").WithCause(err)
	}

	authorities := make([]string, 0, len(p.Authorities))
	for _, a := range p.Authorities {
		authorities = append(authorities, string(a))
	}

	var verifiedAt pgtype.Timestamptz
	if p.VerifiedAt != nil {
		verifiedAt = timestamptz(*p.VerifiedAt)
	}

	return r.queries(ctx).InsertRelatedPerson(ctx, sqlcgen.InsertRelatedPersonParams{
		RelationshipID: relationshipID, TenantID: tenantID, PatientID: patientID,
		RelatedPatientID: related,
		FamilyName:       p.Name.Family, GivenNames: p.Name.Given, Contact: encodedContact,
		Relationship: string(p.Relationship), Authorities: authorities,
		EffectiveFrom: timestamptz(p.Window.From), EffectiveUntil: windowEnd(p.Window),
		VerifiedBy: p.VerifiedBy, VerifiedAt: verifiedAt, VerificationNote: p.VerificationNote,
		RecordedBy: p.RecordedBy, RecordedAt: timestamptz(p.RecordedAt),
	})
}

// VerifyRelatedPerson records that somebody checked the claim.
func (r HistoryRepo) VerifyRelatedPerson(ctx context.Context, scope authctx.TenantScope,
	relationshipID, by, note string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(relationshipID)
	if err != nil {
		return relationshipNotFound()
	}

	rows, err := r.queries(ctx).VerifyRelatedPerson(ctx, sqlcgen.VerifyRelatedPersonParams{
		VerifiedBy: by, VerifiedAt: timestamptz(at), VerificationNote: note,
		TenantID: tenantID, RelationshipID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Missing, or already verified. Re-verifying would overwrite the note
		// saying what was originally checked, which is the part that holds up.
		return rpcerr.FailedPrecondition("EMPI_ALREADY_VERIFIED",
			"this relationship does not exist or has already been verified")
	}
	return nil
}

// EndRelatedPerson closes a relationship's window.
func (r HistoryRepo) EndRelatedPerson(ctx context.Context, scope authctx.TenantScope,
	relationshipID string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(relationshipID)
	if err != nil {
		return relationshipNotFound()
	}

	rows, err := r.queries(ctx).EndRelatedPerson(ctx, sqlcgen.EndRelatedPersonParams{
		EffectiveUntil: timestamptz(at), TenantID: tenantID, RelationshipID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("EMPI_RELATIONSHIP_NOT_OPEN",
			"this relationship does not exist or has already ended")
	}
	return nil
}

// RelatedPersons returns a patient's relationships.
func (r HistoryRepo) RelatedPersons(ctx context.Context, scope authctx.TenantScope,
	patientID string) (domain.RelatedPersonSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListRelatedPersons(ctx, sqlcgen.ListRelatedPersonsParams{
		TenantID: tenantID, PatientID: id,
	})
	if err != nil {
		return nil, err
	}
	return relatedFromRows(rows)
}

// AuthorityHeldBy returns the relationships one person holds over another.
func (r HistoryRepo) AuthorityHeldBy(ctx context.Context, scope authctx.TenantScope,
	holderPatientID, subjectPatientID string) (domain.RelatedPersonSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	holder, err := uuid.Parse(holderPatientID)
	if err != nil {
		return nil, nil
	}
	subject, err := uuid.Parse(subjectPatientID)
	if err != nil {
		return nil, nil
	}

	rows, err := r.queries(ctx).ListRelationshipsHeldBy(ctx, sqlcgen.ListRelationshipsHeldByParams{
		TenantID: tenantID, RelatedPatientID: pgtype.UUID{Bytes: holder, Valid: true},
		PatientID: subject,
	})
	if err != nil {
		return nil, err
	}
	return relatedFromRows(rows)
}

func relatedFromRows(rows []sqlcgen.EmpiRelatedPerson) (domain.RelatedPersonSet, error) {
	out := make(domain.RelatedPersonSet, 0, len(rows))
	for _, row := range rows {
		p := domain.RelatedPerson{
			ID: row.RelationshipID.String(), PatientID: row.PatientID.String(),
			Name:         domain.HumanName{Family: row.FamilyName, Given: row.GivenNames},
			Relationship: domain.RelationshipType(row.Relationship),
			Window:       effective.Window{From: row.EffectiveFrom.Time.UTC()},
			VerifiedBy:   row.VerifiedBy, VerificationNote: row.VerificationNote,
			RecordedBy: row.RecordedBy, RecordedAt: row.RecordedAt.Time.UTC(),
		}
		if row.RelatedPatientID.Valid {
			p.RelatedPatientID = uuid.UUID(row.RelatedPatientID.Bytes).String()
		}
		if row.EffectiveUntil.Valid {
			p.Window.Until = row.EffectiveUntil.Time.UTC()
		}
		if row.VerifiedAt.Valid {
			at := row.VerifiedAt.Time.UTC()
			p.VerifiedAt = &at
		}
		for _, a := range row.Authorities {
			p.Authorities = append(p.Authorities, domain.Authority(a))
		}
		if err := json.Unmarshal(row.Contact, &p.Contact); err != nil {
			return nil, rpcerr.Internal("EMPI_DECODE_FAILED", "could not decode contact details").WithCause(err)
		}
		out = append(out, p)
	}
	return out, nil
}

func relationshipNotFound() error {
	return rpcerr.NotFound("EMPI_RELATIONSHIP_NOT_FOUND", "relationship not found")
}
