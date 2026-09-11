package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/effective"
)

// Feature and module entitlements (SRS-PLT-011).
//
// The verification clause is the design: "disabled module routes/RPCs are
// unavailable even if the URL is called directly". That rules out hiding the
// menu item, which is what entitlement systems usually end up being. The check
// has to run at the RPC boundary, before the handler, which is why resolution
// lives here as a pure function over rows rather than inside any one service.

// Entitlement grants or withholds a module for a scope and period.
type Entitlement struct {
	ID       string
	TenantID string
	// FacilityID empty means the whole tenant. A facility row overrides the
	// tenant row for that facility, which is how one ward pilots a module
	// without the rest of the hospital getting it.
	FacilityID string
	Module     string
	Enabled    bool

	EffectiveFrom  time.Time
	EffectiveUntil time.Time

	GrantedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// ErrInvalidEntitlement reports an entitlement that must not be stored.
var ErrInvalidEntitlement = errors.New("organization: invalid entitlement")

// NewEntitlement validates and constructs an entitlement.
func NewEntitlement(id, tenantID, facilityID, module string, enabled bool,
	from, until time.Time, grantedBy string, now time.Time) (Entitlement, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Entitlement{}, fmt.Errorf("%w: id is required", ErrInvalidEntitlement)
	case strings.TrimSpace(tenantID) == "":
		return Entitlement{}, fmt.Errorf("%w: tenant is required", ErrInvalidEntitlement)
	case strings.TrimSpace(module) == "":
		return Entitlement{}, fmt.Errorf("%w: module is required", ErrInvalidEntitlement)
	case strings.TrimSpace(grantedBy) == "":
		return Entitlement{}, fmt.Errorf("%w: granting user is required", ErrInvalidEntitlement)
	}

	window := effective.Window{From: from, Until: until}
	if err := window.Validate(); err != nil {
		return Entitlement{}, fmt.Errorf("%w: %v", ErrInvalidEntitlement, err)
	}

	return Entitlement{
		ID: id, TenantID: tenantID, FacilityID: facilityID, Module: module,
		Enabled: enabled, EffectiveFrom: from.UTC(), EffectiveUntil: until,
		GrantedBy: grantedBy, CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// EffectiveWindow satisfies effective.Versioned.
func (e Entitlement) EffectiveWindow() effective.Window {
	return effective.Window{From: e.EffectiveFrom, Until: e.EffectiveUntil}
}

// VersionNumber satisfies effective.Versioned.
func (e Entitlement) VersionNumber() int64 { return e.Version }

// TenantWide reports whether the entitlement covers every facility.
func (e Entitlement) TenantWide() bool { return e.FacilityID == "" }

// EntitlementDecision is the outcome of a check, with the reason.
type EntitlementDecision struct {
	Enabled bool
	// Reason is a stable code, never prose.
	Reason string
	// Source names the entitlement that decided, so an administrator asking
	// "why can this ward not see billing?" gets an answer rather than a
	// verdict.
	Source string
}

// Stable entitlement reason codes.
const (
	ReasonEntitled          = "MODULE_ENTITLED"
	ReasonModuleDisabled    = "MODULE_DISABLED"
	ReasonNotEntitled       = "MODULE_NOT_ENTITLED"
	ReasonEntitlementLapsed = "MODULE_ENTITLEMENT_LAPSED"
)

// ResolveEntitlement decides whether a module is available.
//
// Deny by default: a module with no entitlement row is off. The alternative —
// on unless switched off — means every new module ships enabled for every
// tenant on the day it merges, whether or not they bought it or are ready for
// it.
//
// Specificity wins over recency. A facility row decides for that facility even
// when a tenant row is newer, because the facility row is the more deliberate
// statement: somebody named that ward.
func ResolveEntitlement(candidates []Entitlement, facilityID string, at time.Time) EntitlementDecision {
	var facilityRows, tenantRows []Entitlement
	for _, e := range candidates {
		switch {
		case e.TenantWide():
			tenantRows = append(tenantRows, e)
		case e.FacilityID == facilityID:
			facilityRows = append(facilityRows, e)
		}
		// Another facility's row is not this facility's business.
	}

	// Within a scope the most recently effective row wins, which is how a
	// later grant replaces an earlier one without anybody closing the old
	// window by hand.
	if decision, found := resolveScope(facilityRows, at); found {
		return decision
	}
	if decision, found := resolveScope(tenantRows, at); found {
		return decision
	}

	// Nothing in force. Distinguish "never granted" from "granted and lapsed":
	// they need different actions from an administrator, and answering
	// "not entitled" to a lapsed licence sends them looking in the wrong place.
	if len(facilityRows)+len(tenantRows) > 0 {
		return EntitlementDecision{Enabled: false, Reason: ReasonEntitlementLapsed}
	}
	return EntitlementDecision{Enabled: false, Reason: ReasonNotEntitled}
}

func resolveScope(rows []Entitlement, at time.Time) (EntitlementDecision, bool) {
	inForce := make([]Entitlement, 0, len(rows))
	for _, e := range rows {
		if e.EffectiveWindow().Contains(at) {
			inForce = append(inForce, e)
		}
	}
	if len(inForce) == 0 {
		return EntitlementDecision{}, false
	}
	sort.SliceStable(inForce, func(i, j int) bool {
		if !inForce[i].EffectiveFrom.Equal(inForce[j].EffectiveFrom) {
			return inForce[i].EffectiveFrom.After(inForce[j].EffectiveFrom)
		}
		return inForce[i].Version > inForce[j].Version
	})

	winner := inForce[0]
	if winner.Enabled {
		return EntitlementDecision{Enabled: true, Reason: ReasonEntitled, Source: winner.ID}, true
	}
	return EntitlementDecision{Enabled: false, Reason: ReasonModuleDisabled, Source: winner.ID}, true
}
