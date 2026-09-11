// Package projection builds the derived views — search indexes, analytics
// tables, caches — that are rebuilt from the record rather than being it.
//
// Two requirements shape this package and they pull in the same direction:
//
//	SRS-DAT-008  derived stores are rebuildable and are never the legal source
//	             of truth; every indexed item carries the source record's id
//	             and version.
//	SRS-DAT-014  replication to analytics excludes or tokenises fields not
//	             required downstream, so the analytics schema holds only
//	             approved categories.
//
// The id-and-version rule is what makes the rest possible. With it, a stale
// index entry is detectable (its version is behind), a rebuild is idempotent
// (re-emitting a version that is already present is a no-op), and an answer
// from the index can always be re-read from the source before being acted on.
// Without it, a search hit is an assertion nobody can check, and the index
// quietly becomes a second source of truth that disagrees with the first.
package projection

import (
	"errors"
	"fmt"
	"sort"
	"strings"
)

// DataCategory classifies what a field carries, which is what decides whether
// it may leave the transactional store.
type DataCategory string

const (
	// CategoryOperational is non-identifying operational data: statuses,
	// counts, timestamps, facility identifiers. Safe downstream as is.
	CategoryOperational DataCategory = "operational"
	// CategoryPseudonymous identifies a subject only via a key that means
	// nothing outside the transactional store. Safe downstream as a token.
	CategoryPseudonymous DataCategory = "pseudonymous"
	// CategoryDirectIdentifier names a person: name, contact details, national
	// identifier. Never leaves in clear.
	CategoryDirectIdentifier DataCategory = "direct_identifier"
	// CategoryClinical is health information about an identifiable person.
	// Leaves only when the projection is explicitly approved for it.
	CategoryClinical DataCategory = "clinical"
)

// Disposition is what happens to a field on its way out.
type Disposition string

const (
	// Include copies the value unchanged.
	Include Disposition = "include"
	// Tokenise replaces the value with a stable, non-reversible token, so
	// downstream can still count distinct subjects and join across rows
	// without holding an identifier.
	Tokenise Disposition = "tokenise"
	// Exclude drops the field entirely.
	Exclude Disposition = "exclude"
)

// Errors returned by this package.
var (
	// ErrUnclassifiedField reports a field the contract does not mention. It
	// is the most important error here: a new column added upstream must not
	// flow downstream because nobody thought about it. Unknown means excluded
	// and loud, not excluded and silent.
	ErrUnclassifiedField = errors.New("projection: field is not classified")
	// ErrDisallowedCategory reports a field whose category this projection is
	// not approved to receive.
	ErrDisallowedCategory = errors.New("projection: category not approved for this projection")
	// ErrInvalidEnvelope reports a projected item that could not be traced
	// back to its source.
	ErrInvalidEnvelope = errors.New("projection: item cannot be traced to a source record")
)

// Field is one classified attribute of a source record.
type Field struct {
	Name     string
	Category DataCategory
}

// Contract declares what a named projection may receive.
//
// It is explicit in both directions — which fields exist and which categories
// are approved — because the failure mode being designed against is a field
// arriving downstream that nobody decided about.
type Contract struct {
	// Projection names the downstream store, e.g. "search.facility" or
	// "analytics.encounter_daily".
	Projection string
	// Fields classifies every attribute the source may offer. A field absent
	// from this list is refused rather than dropped quietly.
	Fields []Field
	// Approved lists the categories this projection may hold in clear.
	// CategoryDirectIdentifier being absent is the normal case.
	Approved []DataCategory
	// Tokenised lists categories that pass through as tokens rather than being
	// excluded. Typically CategoryPseudonymous, sometimes CategoryDirectIdentifier
	// where downstream must count distinct people without knowing who they are.
	Tokenised []DataCategory
}

// Tokeniser produces a stable non-reversible token for a value.
//
// An interface rather than a function in this package because the token must
// be stable across processes and restarts — an analytics join fails if the
// same patient tokenises differently in two batches — which means a keyed
// construction and a key that lives in KMS.
type Tokeniser interface {
	Token(tenantID, fieldName, value string) string
}

// Envelope is one item on its way to a derived store.
//
// SourceID and SourceVersion are what make the derived store safely derived:
// a consumer can always ask the transactional store what the current version
// is, and discard an item that is behind.
type Envelope struct {
	Projection    string
	TenantID      string
	SourceType    string
	SourceID      string
	SourceVersion int64
	Attributes    map[string]string
}

// Validate refuses an envelope that cannot be traced back.
//
// This is SRS-DAT-008's verification clause expressed as a guard: an indexed
// item without a source id and version is an assertion nobody can check.
func (e Envelope) Validate() error {
	switch {
	case strings.TrimSpace(e.Projection) == "":
		return fmt.Errorf("%w: no projection name", ErrInvalidEnvelope)
	case strings.TrimSpace(e.TenantID) == "":
		return fmt.Errorf("%w: no tenant", ErrInvalidEnvelope)
	case strings.TrimSpace(e.SourceType) == "":
		return fmt.Errorf("%w: no source type", ErrInvalidEnvelope)
	case strings.TrimSpace(e.SourceID) == "":
		return fmt.Errorf("%w: no source id", ErrInvalidEnvelope)
	case e.SourceVersion <= 0:
		return fmt.Errorf("%w: source version must be positive, got %d",
			ErrInvalidEnvelope, e.SourceVersion)
	}
	return nil
}

// Stale reports whether this envelope is behind the source's current version.
//
// Derived stores receive events out of order — a retry, a rebuild running
// alongside live traffic — so a consumer that writes whatever arrives last
// will sometimes overwrite new data with old. Comparing versions is the whole
// defence, and it only works because the envelope carries one.
func (e Envelope) Stale(currentVersion int64) bool { return e.SourceVersion < currentVersion }

// Projector applies a contract to source records.
type Projector struct {
	contract  Contract
	tokeniser Tokeniser
	byName    map[string]Field
	approved  map[DataCategory]bool
	tokenised map[DataCategory]bool
}

// NewProjector prepares a projector for a contract.
func NewProjector(c Contract, tokeniser Tokeniser) (*Projector, error) {
	if strings.TrimSpace(c.Projection) == "" {
		return nil, errors.New("projection: contract needs a projection name")
	}
	if len(c.Fields) == 0 {
		return nil, errors.New("projection: contract classifies no fields")
	}

	p := &Projector{
		contract:  c,
		tokeniser: tokeniser,
		byName:    make(map[string]Field, len(c.Fields)),
		approved:  map[DataCategory]bool{},
		tokenised: map[DataCategory]bool{},
	}
	for _, f := range c.Fields {
		if _, dup := p.byName[f.Name]; dup {
			return nil, fmt.Errorf("projection: field %q classified twice", f.Name)
		}
		p.byName[f.Name] = f
	}
	for _, cat := range c.Approved {
		p.approved[cat] = true
	}
	for _, cat := range c.Tokenised {
		if p.approved[cat] {
			// Both would be ambiguous, and the ambiguity resolves the wrong
			// way under pressure: someone reads the contract, sees the
			// category approved, and assumes clear text is intended.
			return nil, fmt.Errorf("projection: category %q is both approved and tokenised", cat)
		}
		if tokeniser == nil {
			return nil, fmt.Errorf("projection: category %q is tokenised but no tokeniser was supplied", cat)
		}
		p.tokenised[cat] = true
	}
	return p, nil
}

// Disposition reports what would happen to a field, without a value. Useful to
// a schema test that wants to assert a contract's shape rather than run data
// through it.
func (p *Projector) Disposition(field string) (Disposition, error) {
	f, known := p.byName[field]
	if !known {
		return Exclude, fmt.Errorf("%w: %q in projection %q",
			ErrUnclassifiedField, field, p.contract.Projection)
	}
	switch {
	case p.approved[f.Category]:
		return Include, nil
	case p.tokenised[f.Category]:
		return Tokenise, nil
	default:
		return Exclude, nil
	}
}

// Project builds the envelope a derived store should receive.
//
// An unclassified field is an error rather than a silent drop. Dropping it
// quietly would be safe for that field and dangerous as a habit: the next
// person adds a column, sees data flowing, and never learns that the contract
// decides what leaves.
func (p *Projector) Project(tenantID, sourceType, sourceID string, sourceVersion int64,
	source map[string]string) (Envelope, error) {

	attributes := make(map[string]string, len(source))

	// Sorted, so an error names the first offending field deterministically
	// rather than whichever the map iteration reached first.
	names := make([]string, 0, len(source))
	for name := range source {
		names = append(names, name)
	}
	sort.Strings(names)

	for _, name := range names {
		f, known := p.byName[name]
		if !known {
			return Envelope{}, fmt.Errorf("%w: %q offered to projection %q",
				ErrUnclassifiedField, name, p.contract.Projection)
		}
		switch {
		case p.approved[f.Category]:
			attributes[name] = source[name]
		case p.tokenised[f.Category]:
			if value := source[name]; value != "" {
				attributes[name] = p.tokeniser.Token(tenantID, name, value)
			}
		default:
			// Excluded: the category is not approved for this projection.
		}
	}

	e := Envelope{
		Projection:    p.contract.Projection,
		TenantID:      tenantID,
		SourceType:    sourceType,
		SourceID:      sourceID,
		SourceVersion: sourceVersion,
		Attributes:    attributes,
	}
	if err := e.Validate(); err != nil {
		return Envelope{}, err
	}
	return e, nil
}

// CategoriesCarried reports which categories this contract lets through in
// clear. A schema test asserts against this rather than against a data sample,
// because a sample proves only what happened to be in it.
func (p *Projector) CategoriesCarried() []DataCategory {
	out := make([]DataCategory, 0, len(p.approved))
	for cat := range p.approved {
		out = append(out, cat)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}
