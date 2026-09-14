package postgres

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Terminology is the configured medication terminology mapping (SRS-MED-002).
//
// The tenant's own map. A deployment that licenses a drug database supplies a
// different implementation of ports.Terminology and never reads these rows;
// the port exists precisely so that swap is an adapter change rather than a
// rewrite of the screen.
type Terminology struct{ *Repository }

// NewTerminology constructs the adapter.
func NewTerminology(r *Repository) Terminology { return Terminology{r} }

var _ ports.Terminology = Terminology{}

// UnmappedVersion is what an allergy finding names when the tenant has
// configured no map at all.
//
// Named rather than blank, because a finding must always be able to say what
// produced it — and "this hospital has no terminology map" is a genuine answer
// to that question, and one a pharmacy reading the report should see.
const UnmappedVersion = "unmapped"

// Profile maps a medication onto its ingredients, classes and moiety.
//
// A medication with no mapping comes back carrying only itself. That is
// deliberate: the alternative is guessing from the display term, which fires on
// every brand pair that shares a word and trains prescribers to dismiss the
// warnings that matter.
func (t Terminology) Profile(ctx context.Context, scope authctx.TenantScope,
	medication domain.Coding) (domain.MedicationProfile, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MedicationProfile{}, err
	}

	row, err := t.queries(ctx).GetTerminologyMapping(ctx,
		sqlcgen.GetTerminologyMappingParams{
			TenantID:         tenantID,
			MedicationSystem: medication.System, MedicationCode: medication.Code,
		})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return domain.MedicationProfile{
				Ingredients: []domain.Coding{medication},
			}, nil
		}
		return domain.MedicationProfile{}, err
	}

	profile := domain.MedicationProfile{
		Ingredients: decodeCodings(row.Ingredients),
		Classes:     decodeCodings(row.Classes),
	}
	// The medication's own code is always in the profile, so a formulary entry
	// or an interaction rule written against the product still matches even
	// where the map only lists ingredients.
	profile.Ingredients = append(profile.Ingredients, medication)
	if row.MoietyCode != "" {
		profile.TherapeuticMoiety = domain.Coding{
			System: row.MoietySystem, Code: row.MoietyCode, Display: row.MoietyDisplay,
		}
	}
	return profile, nil
}

// AllergyRule identifies the mapping in force (SRS-MED-002).
func (t Terminology) AllergyRule(ctx context.Context, scope authctx.TenantScope) (
	domain.AllergyRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.AllergyRule{}, err
	}

	version, err := t.queries(ctx).LatestTerminologyMapVersion(ctx, tenantID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return domain.AllergyRule{
				ID: "allergy.ingredient-and-class-match", Version: UnmappedVersion,
			}, nil
		}
		return domain.AllergyRule{}, err
	}
	return domain.AllergyRule{
		ID: "allergy.ingredient-and-class-match", Version: version,
	}, nil
}

// UpsertMapping records one medication's terminology (SRS-MED-002).
func (t Terminology) UpsertMapping(ctx context.Context, scope authctx.TenantScope,
	medication domain.Coding, ingredients, classes []domain.Coding,
	moiety domain.Coding, mapVersion, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return t.queries(ctx).UpsertTerminologyMapping(ctx,
		sqlcgen.UpsertTerminologyMappingParams{
			TenantID:         tenantID,
			MedicationSystem: medication.System, MedicationCode: medication.Code,
			MedicationDisplay: medication.Display,
			Ingredients:       encodeCodings(ingredients),
			Classes:           encodeCodings(classes),
			MoietySystem:      moiety.System, MoietyCode: moiety.Code,
			MoietyDisplay: moiety.Display,
			MapVersion:    mapVersion, UpdatedBy: updatedBy, UpdatedAt: timestamptz(now),
		})
}

// Codings travel as "system|code|display" triples.
//
// The terminology is part of the identity: two coding systems both have a code
// "J01C" and they do not mean the same thing, so a class stored as a bare code
// would match across systems and warn about the wrong drug.
const codingSeparator = "|"

func encodeCodings(in []domain.Coding) []string {
	out := make([]string, 0, len(in))
	for _, c := range in {
		if c.Empty() {
			continue
		}
		out = append(out, strings.Join(
			[]string{c.System, c.Code, c.Display}, codingSeparator))
	}
	return out
}

func decodeCodings(in []string) []domain.Coding {
	out := make([]domain.Coding, 0, len(in))
	for _, raw := range in {
		parts := strings.SplitN(raw, codingSeparator, 3)
		if len(parts) < 2 || parts[0] == "" || parts[1] == "" {
			// A row that cannot be read back is dropped rather than carried as a
			// half-coding: a class with no system would match across
			// terminologies, which is worse than not matching at all.
			continue
		}
		coding := domain.Coding{System: parts[0], Code: parts[1]}
		if len(parts) == 3 {
			coding.Display = parts[2]
		}
		if coding.Display == "" {
			coding.Display = coding.Code
		}
		out = append(out, coding)
	}
	return out
}
