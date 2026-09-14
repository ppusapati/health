package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Order sets, favourites and configuration
// (SRS-ORD-003, SRS-ORD-009, SRS-ORD-012).

// PlaceFromSetInput is what placing from an order set needs.
type PlaceFromSetInput struct {
	SetID       string
	SetVersion  string
	PatientID   string
	EncounterID string
	Selections  []domain.Selection
	// AcknowledgeDuplicates answers SRS-ORD-009's warning for every component
	// at once. One reason for the basket rather than one per component: a
	// clinician working through a fifteen-item admission set who had to justify
	// each duplicate separately would stop reading the warnings.
	AcknowledgeDuplicates string
	EnteredByID           string
}

// PlaceFromSetResult is what an order-set placement returns.
type PlaceFromSetResult struct {
	Placed []*domain.Order
	// Warnings are the components that duplicate something live. Reported
	// together with what was placed, because a set is placed as a basket and a
	// clinician needs to see which two of the fifteen need a decision — not to
	// have the whole basket refused.
	Warnings map[string]*domain.DuplicateWarning
}

// PlaceFromSet expands a set and places the selected components
// (SRS-ORD-003).
//
// Each component goes through the same submit path as a hand-typed order, so
// the set cannot bypass the policy either: a component with no indication in a
// tenant that requires one is refused, and the refusal names it.
func (s *Service) PlaceFromSet(ctx context.Context, in PlaceFromSetInput) (
	PlaceFromSetResult, error) {

	session, scope, err := s.authorize(ctx, PermOrderPlace, "order_set",
		in.SetID, true)
	if err != nil {
		return PlaceFromSetResult{}, err
	}

	state, err := s.requireOpenEncounter(ctx, scope, in.EncounterID, in.PatientID)
	if err != nil {
		return PlaceFromSetResult{}, err
	}

	set, err := s.catalogue.GetSet(ctx, scope, in.SetID, in.SetVersion)
	if err != nil {
		return PlaceFromSetResult{}, err
	}

	base := domain.NewOrderInput{
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: state.FacilityID, RequesterID: session.SubjectID,
		EnteredByID: in.EnteredByID,
	}
	inputs, err := set.Expand(base, in.Selections)
	if err != nil {
		return PlaceFromSetResult{}, orderError(err)
	}
	if len(inputs) > MaxOrdersPerSet {
		return PlaceFromSetResult{}, rpcerr.Invalid("ORD_SET_TOO_LARGE",
			"an order set places at most "+itoa(MaxOrdersPerSet)+
				" orders at a time")
	}

	orderPolicy, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return PlaceFromSetResult{}, err
	}

	// SRS-ORD-002's requester privilege, checked for every type the set
	// contains before anything is placed: a basket that placed the first eight
	// and then refused the ninth would leave the clinician to work out what
	// happened.
	for _, componentInput := range inputs {
		privilege, needed := orderPolicy.RequiredPrivilege(componentInput.Type)
		if !needed || session.HasPermission(privilege) {
			continue
		}
		s.auditDenied(ctx, session, privilege, "order_set", in.SetID,
			"this order set contains a type needing "+privilege)
		return PlaceFromSetResult{}, rpcerr.PermissionDenied("ORD_DENIED",
			"this order set places a "+string(componentInput.Type)+
				" order, which needs "+privilege)
	}

	now := s.clock.Now()
	result := PlaceFromSetResult{Warnings: map[string]*domain.DuplicateWarning{}}
	for _, componentInput := range inputs {
		placed, err := s.place(ctx, session, scope, componentInput, state,
			in.AcknowledgeDuplicates, orderPolicy, now)
		if err != nil {
			return PlaceFromSetResult{}, err
		}
		if placed.Warning != nil {
			result.Warnings[componentInput.Code.Code] = placed.Warning
			continue
		}
		result.Placed = append(result.Placed, placed.Order)
	}
	if len(result.Warnings) == 0 {
		result.Warnings = nil
	}
	return result, nil
}

func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	var digits []byte
	for n > 0 {
		digits = append([]byte{byte('0' + n%10)}, digits...)
		n /= 10
	}
	return string(digits)
}

// DefineSet publishes a version of an order set (SRS-ORD-003).
func (s *Service) DefineSet(ctx context.Context, set domain.OrderSet) (
	domain.OrderSet, error) {

	session, scope, err := s.authorize(ctx, PermOrderConfigure, "order_set",
		set.ID, true)
	if err != nil {
		return domain.OrderSet{}, err
	}
	if set.ID == "" {
		set.ID = s.ids.NewID()
	}
	set.TenantID = session.TenantID
	set.CreatedBy = session.SubjectID
	set.CreatedAt = s.clock.Now()
	if err := set.Validate(); err != nil {
		return domain.OrderSet{}, orderError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.InsertSet(ctx, scope, set); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order_set.define", ResourceType: "order_set",
			ResourceID: set.ID, Outcome: audit.OutcomeSuccess,
			Reason: "version " + set.Version,
		}, set.CreatedAt)
	})
	if err != nil {
		return domain.OrderSet{}, mapConflict(err)
	}
	return set, nil
}

// ListSets lists what a clinician may choose from.
func (s *Service) ListSets(ctx context.Context, specialty string,
	includeRetired bool, limit int32) ([]domain.OrderSet, error) {

	_, scope, err := s.authorize(ctx, PermOrderRead, "order_set", "", false)
	if err != nil {
		return nil, err
	}
	return s.catalogue.ListSets(ctx, scope, specialty, includeRetired,
		clampPageSize(limit))
}

// RetireSet withdraws a version from new use.
//
// The orders already placed from it keep pointing at it: they recorded what was
// offered at the time, which is the point of versioning.
func (s *Service) RetireSet(ctx context.Context, setID, version string) error {
	session, scope, err := s.authorize(ctx, PermOrderConfigure, "order_set",
		setID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.RetireSet(ctx, scope, setID, version); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order_set.retire", ResourceType: "order_set",
			ResourceID: setID, Outcome: audit.OutcomeSuccess,
			Reason: "version " + version,
		}, now)
	}))
}

// SaveFavourite stores one clinician's shortcut (SRS-ORD-012).
//
// Always the caller's own: a favourite saved on somebody else's behalf is a
// shared shortcut, and a shared shortcut with no review is an order set that
// escaped governance.
func (s *Service) SaveFavourite(ctx context.Context, f domain.Favourite) (
	domain.Favourite, error) {

	session, scope, err := s.authorize(ctx, PermOrderPlace, "favourite", f.ID,
		true)
	if err != nil {
		return domain.Favourite{}, err
	}
	if f.ID == "" {
		f.ID = s.ids.NewID()
	}
	f.TenantID = session.TenantID
	f.OwnerID = session.SubjectID
	now := s.clock.Now()
	f.UpdatedAt = now
	if f.CreatedAt.IsZero() {
		f.CreatedAt = now
	}
	if err := f.Validate(); err != nil {
		return domain.Favourite{}, orderError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.UpsertFavourite(ctx, scope, f); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.favourite.save", ResourceType: "favourite",
			ResourceID: f.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.Favourite{}, mapConflict(err)
	}
	return f, nil
}

// ListFavourites reads the caller's own.
func (s *Service) ListFavourites(ctx context.Context, orderType domain.Type,
	limit int32) ([]domain.Favourite, error) {

	session, scope, err := s.authorize(ctx, PermOrderPlace, "favourite", "",
		false)
	if err != nil {
		return nil, err
	}
	// Scoped to the caller, never to a supplied owner: a client that could ask
	// for somebody else's favourites could read a consultant's practice.
	return s.catalogue.ListFavourites(ctx, scope, session.SubjectID, orderType,
		clampPageSize(limit))
}

// DeleteFavourite removes one of the caller's own.
func (s *Service) DeleteFavourite(ctx context.Context, favouriteID string) error {
	session, scope, err := s.authorize(ctx, PermOrderPlace, "favourite",
		favouriteID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.DeleteFavourite(ctx, scope, favouriteID,
			session.SubjectID); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.favourite.delete", ResourceType: "favourite",
			ResourceID: favouriteID, Outcome: audit.OutcomeSuccess,
		}, now)
	}))
}

// PlaceFromFavourite applies a favourite and places the order (SRS-ORD-012).
//
// The favourite supplies values and the policy still applies, so a shortcut
// saved before the tenant made indications mandatory is refused rather than
// quietly placed.
func (s *Service) PlaceFromFavourite(ctx context.Context, favouriteID string,
	in PlaceInput) (PlaceResult, error) {

	session, scope, err := s.authorize(ctx, PermOrderPlace, "favourite",
		favouriteID, true)
	if err != nil {
		return PlaceResult{}, err
	}

	favourite, err := s.catalogue.GetFavourite(ctx, scope, favouriteID)
	if err != nil {
		return PlaceResult{}, err
	}
	if favourite.OwnerID != session.SubjectID {
		// Somebody else's shortcut is not found rather than forbidden: a probe
		// must not be able to confirm that a colleague has one.
		return PlaceResult{}, rpcerr.NotFound("ORD_NOT_FOUND", "no such favourite")
	}

	applied := favourite.Apply(domain.NewOrderInput{
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		RequesterID: session.SubjectID, EnteredByID: in.EnteredByID,
	})
	// The caller may still override what the favourite suggests — it is a
	// starting point, not a template.
	if in.Indication != "" {
		applied.Indication = in.Indication
	}
	if in.Detail != "" {
		applied.Detail = in.Detail
	}
	if in.Priority != "" {
		applied.Priority = in.Priority
	}

	state, err := s.requireOpenEncounter(ctx, scope, in.EncounterID, in.PatientID)
	if err != nil {
		return PlaceResult{}, err
	}
	applied.FacilityID = state.FacilityID

	orderPolicy, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return PlaceResult{}, err
	}
	if privilege, needed := orderPolicy.RequiredPrivilege(applied.Type); needed {
		if !session.HasPermission(privilege) {
			s.auditDenied(ctx, session, privilege, "favourite", favouriteID,
				"this order type needs "+privilege)
			return PlaceResult{}, rpcerr.PermissionDenied("ORD_DENIED",
				"placing a "+string(applied.Type)+" order needs "+privilege)
		}
	}

	return s.place(ctx, session, scope, applied, state,
		in.AcknowledgeDuplicates, orderPolicy, s.clock.Now())
}

// SetPolicy configures what an order type requires
// (SRS-ORD-002, SRS-ORD-007).
func (s *Service) SetPolicy(ctx context.Context, orderType domain.Type,
	indicationRequired, structuredTimingRequired bool, privilege string) error {

	session, scope, err := s.authorize(ctx, PermOrderConfigure, "order_policy",
		string(orderType), true)
	if err != nil {
		return err
	}
	if orderType == "" {
		return rpcerr.Invalid("ORD_POLICY_NO_TYPE",
			"an order policy applies to one order type")
	}

	now := s.clock.Now()
	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.SetPolicy(ctx, scope, orderType,
			indicationRequired, structuredTimingRequired, privilege,
			session.SubjectID, now); err != nil {
			return err
		}
		// Audited as a configuration change: relaxing a mandatory indication is
		// a governance decision and the record must show who made it.
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.policy.set", ResourceType: "order_policy",
			ResourceID: string(orderType), Outcome: audit.OutcomeSuccess,
			Reason: policyReason(indicationRequired, structuredTimingRequired),
		}, now)
	}))
}

func policyReason(indication, timing bool) string {
	switch {
	case indication && timing:
		return "indication and structured timing required"
	case indication:
		return "indication required"
	case timing:
		return "structured timing required"
	}
	return "no additional requirements"
}

// SetDuplicateRule configures how two orders count as the same (SRS-ORD-009).
func (s *Service) SetDuplicateRule(ctx context.Context,
	rule domain.DuplicateRule) error {

	session, scope, err := s.authorize(ctx, PermOrderConfigure, "duplicate_rule",
		string(rule.Type), true)
	if err != nil {
		return err
	}
	if rule.Type == "" {
		return rpcerr.Invalid("ORD_RULE_NO_TYPE",
			"a duplicate rule applies to one order type")
	}
	if rule.Within < 0 {
		return rpcerr.Invalid("ORD_RULE_WINDOW",
			"a duplicate window cannot be negative")
	}

	now := s.clock.Now()
	return mapConflict(s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.catalogue.SetDuplicateRule(ctx, scope, rule,
			session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.duplicate_rule.set", ResourceType: "duplicate_rule",
			ResourceID: string(rule.Type), Outcome: audit.OutcomeSuccess,
			Reason: duplicateRuleReason(rule),
		}, now)
	}))
}

func duplicateRuleReason(rule domain.DuplicateRule) string {
	if rule.Within <= 0 {
		return "duplicate checking disabled"
	}
	if !rule.Overridable {
		return "duplicates refused outright"
	}
	return "duplicates warned within " + rule.Within.String()
}
