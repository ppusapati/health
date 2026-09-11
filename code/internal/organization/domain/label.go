package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Multilingual display labels (SRS-PLT-017).
//
// The verification clause draws the line this file exists to hold: "selected
// locale renders configured labels without altering canonical codes". A label
// is a rendering of a code, never a replacement for it. The system reasons
// with, stores and exchanges the code; the label is what one locale's users
// see. A design that localises the code itself cannot round-trip an interface
// message, cannot compare two records captured in different locales, and turns
// every report into a translation problem.

// DisplayLabel is one locale's rendering of a code.
type DisplayLabel struct {
	ID       string
	TenantID string
	// CodeSystem is the namespace of the code: "org_unit", a value set name,
	// "entitlement.module".
	CodeSystem string
	Code       string
	// Locale is a BCP 47 tag: "en", "en-IN", "hi", "ta".
	Locale  string
	Display string
	// ShortDisplay is a denser form for tables and chips; empty falls back to
	// Display.
	ShortDisplay string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// ErrInvalidLabel reports a label that must not be stored.
var ErrInvalidLabel = errors.New("organization: invalid display label")

// NewDisplayLabel validates and constructs a label.
func NewDisplayLabel(id, tenantID, codeSystem, code, locale, display, shortDisplay string,
	now time.Time) (DisplayLabel, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DisplayLabel{}, fmt.Errorf("%w: id is required", ErrInvalidLabel)
	case strings.TrimSpace(tenantID) == "":
		return DisplayLabel{}, fmt.Errorf("%w: tenant is required", ErrInvalidLabel)
	case strings.TrimSpace(codeSystem) == "" || strings.TrimSpace(code) == "":
		return DisplayLabel{}, fmt.Errorf("%w: code system and code are required", ErrInvalidLabel)
	case strings.TrimSpace(locale) == "":
		return DisplayLabel{}, fmt.Errorf("%w: locale is required", ErrInvalidLabel)
	case strings.TrimSpace(display) == "":
		return DisplayLabel{}, fmt.Errorf("%w: display text is required", ErrInvalidLabel)
	}

	return DisplayLabel{
		ID: id, TenantID: tenantID, CodeSystem: codeSystem, Code: code,
		// Normalised so "EN-in" and "en-IN" are one entry rather than two that
		// shadow each other depending on query order.
		Locale:       NormalizeLocale(locale),
		Display:      display,
		ShortDisplay: shortDisplay,
		CreatedAt:    now.UTC(),
		UpdatedAt:    now.UTC(),
	}, nil
}

// NormalizeLocale canonicalises a BCP 47 tag's case.
//
// Language subtag lowercase, region subtag uppercase: "en-IN". Not a full BCP
// 47 implementation — script and variant subtags are left as given — because
// the alternative is a dependency, and the failure this prevents is the one
// that actually happens: two rows for the same locale spelled differently.
func NormalizeLocale(locale string) string {
	parts := strings.Split(strings.TrimSpace(locale), "-")
	if len(parts) == 0 {
		return ""
	}
	parts[0] = strings.ToLower(parts[0])
	if len(parts) > 1 && len(parts[1]) == 2 {
		parts[1] = strings.ToUpper(parts[1])
	}
	return strings.Join(parts, "-")
}

// FallbackChain expands a locale into the sequence to try.
//
// "en-IN" yields ["en-IN", "en"]. A regional label is preferred where it
// exists and the base language is the fallback, so a tenant translating into
// Hindi need not also produce hi-IN to see any effect.
func FallbackChain(locale string) []string {
	normalized := NormalizeLocale(locale)
	if normalized == "" {
		return nil
	}
	chain := []string{normalized}
	if base, _, found := strings.Cut(normalized, "-"); found && base != normalized {
		chain = append(chain, base)
	}
	return chain
}

// Rendering is what a caller displays for a code.
type Rendering struct {
	// Code is always present and always the canonical value. It is first in
	// the struct because it is the part that must survive every layer: a
	// renderer that drops it turns a record into something that cannot be
	// looked up again.
	Code    string
	Display string
	Short   string
	// Locale is the locale actually used, which may be a fallback or empty
	// when nothing matched. A UI can mark an untranslated label rather than
	// presenting an English string as though it were Tamil.
	Locale string
	// Translated reports whether a configured label was found at all.
	Translated bool
}

// Render picks the best label for a locale.
//
// When nothing matches, the canonical code is returned as the display text.
// That is deliberate: an untranslated code on screen is ugly and unambiguous,
// whereas a blank label or a silently substituted default locale is a
// clinician reading the wrong thing without knowing it.
func Render(labels []DisplayLabel, code, locale string) Rendering {
	byLocale := make(map[string]DisplayLabel, len(labels))
	for _, l := range labels {
		byLocale[l.Locale] = l
	}

	for _, candidate := range FallbackChain(locale) {
		l, found := byLocale[candidate]
		if !found {
			continue
		}
		short := l.ShortDisplay
		if short == "" {
			short = l.Display
		}
		return Rendering{
			Code: code, Display: l.Display, Short: short,
			Locale: l.Locale, Translated: true,
		}
	}

	return Rendering{Code: code, Display: code, Short: code, Translated: false}
}
