package projection_test

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/projection"
)

// hmacTokeniser is what a real one looks like: keyed, so the token cannot be
// reversed by anyone who does not hold the key, and deterministic, so
// downstream joins work across batches and restarts.
type hmacTokeniser struct{ key []byte }

func (h hmacTokeniser) Token(tenantID, fieldName, value string) string {
	mac := hmac.New(sha256.New, h.key)
	// The tenant and field are in the input so the same value under two
	// tenants, or in two fields, does not produce the same token — otherwise
	// downstream could link records across tenants without ever holding an
	// identifier.
	mac.Write([]byte(tenantID + "\x00" + fieldName + "\x00" + value))
	return hex.EncodeToString(mac.Sum(nil))[:32]
}

func analyticsContract() projection.Contract {
	return projection.Contract{
		Projection: "analytics.encounter_daily",
		Fields: []projection.Field{
			{Name: "encounter_id", Category: projection.CategoryPseudonymous},
			{Name: "patient_ref", Category: projection.CategoryPseudonymous},
			{Name: "patient_name", Category: projection.CategoryDirectIdentifier},
			{Name: "national_id", Category: projection.CategoryDirectIdentifier},
			{Name: "diagnosis_code", Category: projection.CategoryClinical},
			{Name: "facility_id", Category: projection.CategoryOperational},
			{Name: "status", Category: projection.CategoryOperational},
		},
		Approved:  []projection.DataCategory{projection.CategoryOperational},
		Tokenised: []projection.DataCategory{projection.CategoryPseudonymous},
	}
}

func newProjector(t *testing.T, c projection.Contract) *projection.Projector {
	t.Helper()
	p, err := projection.NewProjector(c, hmacTokeniser{key: []byte("test-key")})
	if err != nil {
		t.Fatalf("NewProjector: %v", err)
	}
	return p
}

func source() map[string]string {
	return map[string]string{
		"encounter_id":   "enc-1",
		"patient_ref":    "pat-1",
		"patient_name":   "Priya Ramaswamy",
		"national_id":    "ABCDE1234F",
		"diagnosis_code": "J18.9",
		"facility_id":    "fac-1",
		"status":         "closed",
	}
}

// SRS-DAT-014's verification clause: the analytics schema holds only approved
// categories. Asserted by what comes out, not by what the contract says.
func TestAnalyticsReceivesOnlyApprovedCategories(t *testing.T) {
	p := newProjector(t, analyticsContract())

	e, err := p.Project("tenant-a", "encounter", "enc-1", 3, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}

	for _, forbidden := range []string{"patient_name", "national_id", "diagnosis_code"} {
		if _, present := e.Attributes[forbidden]; present {
			t.Errorf("%s reached the analytics projection", forbidden)
		}
	}
	for _, expected := range []string{"facility_id", "status"} {
		if e.Attributes[expected] == "" {
			t.Errorf("%s is missing from the projection", expected)
		}
	}
	if e.Attributes["facility_id"] != "fac-1" {
		t.Errorf("operational data was altered: %q", e.Attributes["facility_id"])
	}
}

// Tokenised fields must still be usable for counting distinct subjects and
// joining rows — that is the whole reason they are not simply excluded.
func TestTokensAreStableAndNotReversible(t *testing.T) {
	p := newProjector(t, analyticsContract())

	first, err := p.Project("tenant-a", "encounter", "enc-1", 1, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}
	second, err := p.Project("tenant-a", "encounter", "enc-2", 1, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}

	token := first.Attributes["patient_ref"]
	if token == "" {
		t.Fatal("the pseudonymous field was dropped rather than tokenised")
	}
	if token == "pat-1" {
		t.Fatal("the field passed through in clear")
	}
	// The same patient in two encounters produces the same token, so
	// downstream can count them as one person.
	if second.Attributes["patient_ref"] != token {
		t.Fatal("the same subject tokenised differently; a downstream join would split them")
	}

	// A different tenant must not produce the same token, or downstream could
	// link records across tenants without holding any identifier.
	other, err := p.Project("tenant-b", "encounter", "enc-3", 1, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}
	if other.Attributes["patient_ref"] == token {
		t.Fatal("the same value tokenised identically across tenants")
	}
}

// The most important rule here: a field nobody classified is refused, not
// dropped. A silent drop is safe for that field and teaches the wrong habit —
// the next person adds a column, sees data flowing, and never learns that the
// contract decides what leaves.
func TestAnUnclassifiedFieldIsRefused(t *testing.T) {
	p := newProjector(t, analyticsContract())

	s := source()
	s["insurance_policy_number"] = "POL-99887766"

	_, err := p.Project("tenant-a", "encounter", "enc-1", 1, s)
	if !errors.Is(err, projection.ErrUnclassifiedField) {
		t.Fatalf("want ErrUnclassifiedField, got %v", err)
	}
}

// SRS-DAT-008: every indexed item carries the source record's id and version,
// so nothing in a derived store is an assertion that cannot be checked.
func TestEnvelopeMustBeTraceableToItsSource(t *testing.T) {
	p := newProjector(t, analyticsContract())

	if _, err := p.Project("tenant-a", "encounter", "", 1, source()); !errors.Is(err, projection.ErrInvalidEnvelope) {
		t.Errorf("missing source id: want ErrInvalidEnvelope, got %v", err)
	}
	if _, err := p.Project("tenant-a", "encounter", "enc-1", 0, source()); !errors.Is(err, projection.ErrInvalidEnvelope) {
		t.Errorf("missing source version: want ErrInvalidEnvelope, got %v", err)
	}
	if _, err := p.Project("", "encounter", "enc-1", 1, source()); !errors.Is(err, projection.ErrInvalidEnvelope) {
		t.Errorf("missing tenant: want ErrInvalidEnvelope, got %v", err)
	}
}

// Derived stores receive events out of order — a retry, a rebuild running
// alongside live traffic. Comparing versions is what stops a consumer
// overwriting new data with old, and it only works because the envelope
// carries one.
func TestStaleItemsAreDetectable(t *testing.T) {
	p := newProjector(t, analyticsContract())

	older, err := p.Project("tenant-a", "encounter", "enc-1", 2, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}
	newer, err := p.Project("tenant-a", "encounter", "enc-1", 5, source())
	if err != nil {
		t.Fatalf("Project: %v", err)
	}

	if !older.Stale(newer.SourceVersion) {
		t.Fatal("a replayed older version was not detected as stale")
	}
	if newer.Stale(newer.SourceVersion) {
		t.Fatal("the current version was reported stale; a rebuild would skip it")
	}
	// Re-emitting the same version is a no-op rather than a conflict, which is
	// what makes a rebuild safe to run twice.
	if newer.Stale(older.SourceVersion) {
		t.Fatal("a newer version was reported stale against an older one")
	}
}

// A search projection legitimately needs more than analytics does. The
// contract is per projection for exactly this reason, and the difference must
// be visible rather than implicit.
func TestSearchAndAnalyticsCarryDifferentCategories(t *testing.T) {
	search := newProjector(t, projection.Contract{
		Projection: "search.patient",
		Fields: []projection.Field{
			{Name: "patient_ref", Category: projection.CategoryPseudonymous},
			{Name: "patient_name", Category: projection.CategoryDirectIdentifier},
			{Name: "facility_id", Category: projection.CategoryOperational},
		},
		// Search has to match on a name; that is what search is for. It is
		// approved to hold one, and that approval is written down here rather
		// than assumed.
		Approved:  []projection.DataCategory{projection.CategoryOperational, projection.CategoryDirectIdentifier},
		Tokenised: []projection.DataCategory{projection.CategoryPseudonymous},
	})

	e, err := search.Project("tenant-a", "patient", "pat-1", 1, map[string]string{
		"patient_ref":  "pat-1",
		"patient_name": "Priya Ramaswamy",
		"facility_id":  "fac-1",
	})
	if err != nil {
		t.Fatalf("Project: %v", err)
	}
	if e.Attributes["patient_name"] != "Priya Ramaswamy" {
		t.Fatal("the search index cannot match a name it does not hold")
	}

	analytics := newProjector(t, analyticsContract())
	for _, cat := range analytics.CategoriesCarried() {
		if cat == projection.CategoryDirectIdentifier {
			t.Fatal("analytics is approved for direct identifiers")
		}
	}
}

func TestContractMistakesAreCaughtAtConstruction(t *testing.T) {
	tok := hmacTokeniser{key: []byte("k")}

	t.Run("no fields", func(t *testing.T) {
		if _, err := projection.NewProjector(projection.Contract{Projection: "p"}, tok); err == nil {
			t.Fatal("a contract classifying nothing was accepted")
		}
	})

	t.Run("duplicate field", func(t *testing.T) {
		_, err := projection.NewProjector(projection.Contract{
			Projection: "p",
			Fields: []projection.Field{
				{Name: "x", Category: projection.CategoryOperational},
				{Name: "x", Category: projection.CategoryDirectIdentifier},
			},
		}, tok)
		if err == nil {
			t.Fatal("a field classified twice was accepted; which classification wins is undefined")
		}
	})

	// Both approved and tokenised is ambiguous, and the ambiguity resolves the
	// wrong way under pressure: a reader sees the category approved and
	// assumes clear text was intended.
	t.Run("approved and tokenised", func(t *testing.T) {
		_, err := projection.NewProjector(projection.Contract{
			Projection: "p",
			Fields:     []projection.Field{{Name: "x", Category: projection.CategoryPseudonymous}},
			Approved:   []projection.DataCategory{projection.CategoryPseudonymous},
			Tokenised:  []projection.DataCategory{projection.CategoryPseudonymous},
		}, tok)
		if err == nil {
			t.Fatal("a category both approved and tokenised was accepted")
		}
	})

	t.Run("tokenised with no tokeniser", func(t *testing.T) {
		_, err := projection.NewProjector(projection.Contract{
			Projection: "p",
			Fields:     []projection.Field{{Name: "x", Category: projection.CategoryPseudonymous}},
			Tokenised:  []projection.DataCategory{projection.CategoryPseudonymous},
		}, nil)
		if err == nil {
			t.Fatal("a contract promising tokens with no tokeniser was accepted")
		}
	})
}

func TestDispositionReportsTheContractWithoutData(t *testing.T) {
	p := newProjector(t, analyticsContract())

	cases := map[string]projection.Disposition{
		"facility_id":    projection.Include,
		"patient_ref":    projection.Tokenise,
		"patient_name":   projection.Exclude,
		"diagnosis_code": projection.Exclude,
	}
	for field, want := range cases {
		got, err := p.Disposition(field)
		if err != nil {
			t.Fatalf("Disposition(%s): %v", field, err)
		}
		if got != want {
			t.Errorf("Disposition(%s) = %s, want %s", field, got, want)
		}
	}
	if _, err := p.Disposition("unknown_column"); !errors.Is(err, projection.ErrUnclassifiedField) {
		t.Fatalf("want ErrUnclassifiedField, got %v", err)
	}
}
