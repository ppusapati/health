package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Field-level masking (SRS-EMPI-003, SRS-EMPI-014).
//
// SRS-EMPI-003 requires potential duplicates to be shown with "protected fields
// masked"; SRS-EMPI-014 requires sensitive demographic data to be restricted
// "where configured", masked, and its reads audited. Masking is what makes the
// duplicate comparison possible without making the record readable: a clerk
// deciding whether two records are one person needs to compare, not to browse.
//
// Which fields count as protected is not decided here. It comes from the
// tenant's configured policy, resolved per facility with a jurisdiction
// fallback, exactly as the demographic minimum set is — because in a clinic
// treating people whose address is what endangers them the street address is
// the most restricted field on the record, and in an outpatient department it
// is what the receptionist reads back.
//
// Masking is applied in the application layer rather than the transport because
// a second read path would otherwise have to remember to do it, and the one
// that forgets is the leak.

// visibility is one caller's view of the restricted fields.
type visibility struct {
	policy domain.FieldAccessPolicy
	// hidden is what this caller may not see in full; revealed is what they
	// may. Both are computed once per request rather than per record, because
	// a page of twenty candidates would otherwise evaluate the policy twenty
	// times to reach the same answer.
	hidden   []domain.Field
	revealed []domain.Field
}

// visibilityFor resolves the caller's field-level access.
//
// Falls back to the built-in default when the tenant has configured nothing, so
// an unconfigured tenant still gets the masking a duplicate-review screen
// needs rather than an open record.
func (s *Service) visibilityFor(ctx context.Context, session authctx.Session) (visibility, error) {
	scope := session.TenantScope()

	jurisdiction, err := s.tenants.Jurisdiction(ctx, scope)
	if err != nil {
		return visibility{}, err
	}
	fieldPolicy, err := s.config.FieldAccessPolicy(ctx, scope, jurisdiction, session.ActiveFacilityID)
	if err != nil {
		return visibility{}, err
	}

	holds := session.HasPermission
	return visibility{
		policy:   fieldPolicy,
		hidden:   fieldPolicy.Hidden(holds),
		revealed: fieldPolicy.Revealed(holds),
	}, nil
}

// maskFor returns the patient as this caller may see them.
//
// Returns a copy when masking applies, so the caller cannot accidentally write
// the masked form back over the record.
func maskFor(p *domain.Patient, v visibility) (*domain.Patient, bool) {
	if p == nil || len(v.hidden) == 0 {
		return p, false
	}

	masked := *p
	masked.Demographics = p.Demographics.MaskFields(v.hidden)
	return domain.Restore(p.ID(), masked), true
}

// fieldNamesOf renders a field list for an audit entry.
func fieldNamesOf(fields []domain.Field) []string {
	out := make([]string, 0, len(fields))
	for _, f := range fields {
		out = append(out, string(f))
	}
	return out
}
