package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
)

func chestXRay() domain.Coding {
	return domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "399208008", Display: "Plain chest X-ray",
	}
}

// SRS-ORD-007: a required indication blocks submit.
func TestAnImagingOrderCannotBePlacedWithoutAnIndication(t *testing.T) {
	in := baseInput(domain.TypeImaging)
	in.Code = chestXRay()
	order := newOrder(t, in)

	err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1))
	var incomplete domain.ErrOrderIncomplete
	if !errors.As(err, &incomplete) {
		t.Fatalf("an imaging order with no indication was placed: %v", err)
	}
	// SRS-ORD-002's acceptance criterion is structured field errors, so the
	// failure travels as data rather than a sentence a client must parse to
	// highlight the right box.
	if len(incomplete.Violations) != 1 ||
		incomplete.Violations[0].Field != "indication" {
		t.Fatalf("the refusal does not name the field: %+v", incomplete.Violations)
	}
	// The order is still a draft: a refused submit leaves nothing half-placed.
	if order.Status != domain.StatusDraft {
		t.Fatalf("a refused submit moved the order to %s", order.Status)
	}

	in.Indication = "persistent cough, query pneumonia"
	withReason := newOrder(t, in)
	if err := withReason.Submit(domain.DefaultPolicy(), "doctor-1",
		at(9, 1)); err != nil {
		t.Fatalf("an imaging order with an indication was refused: %v", err)
	}
}

// Per type, not universal: an indication for a diet order is a field nobody
// fills in honestly once it is mandatory.
func TestALaboratoryOrderNeedsNoIndicationByDefault(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("a laboratory order was refused for having no indication: %v", err)
	}
}

// A clinician told about one missing field, who fills it in and is then told
// about another, stops reading the message.
func TestAnIncompleteOrderNamesEveryMissingField(t *testing.T) {
	in := baseInput(domain.TypeMedication)
	// No indication, no dose, no timing.
	order := newOrder(t, in)

	err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1))
	var incomplete domain.ErrOrderIncomplete
	if !errors.As(err, &incomplete) {
		t.Fatalf("an incomplete medication order was placed: %v", err)
	}
	if len(incomplete.Violations) != 3 {
		t.Fatalf("the refusal names %d fields, want 3: %+v",
			len(incomplete.Violations), incomplete.Violations)
	}
	for _, field := range []string{"detail", "indication", "timing"} {
		if !strings.Contains(err.Error(), field) {
			t.Fatalf("the refusal does not mention %q: %v", field, err)
		}
	}
}

// A one-off order with a start time is perfectly structured; what is refused is
// a scheduled type carrying nothing downstream could act on.
func TestAOneOffMedicationOrderWithAStartTimeIsStructuredEnough(t *testing.T) {
	in := baseInput(domain.TypeMedication)
	in.Indication = "post-operative pain"
	in.Detail = "1 g orally"
	in.Timing = domain.Timing{StartAt: at(10, 0)}

	order := newOrder(t, in)
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("a one-off medication order was refused: %v", err)
	}
}

// SRS-ORD-008: the expansion downstream receives.
func TestFourTimesDailyExpandsToWardRoundTimesNotEverySixHours(t *testing.T) {
	// Prescribed just before the ward's 06:00 round.
	start := at(0, 0)
	timing := domain.Timing{
		StartAt: start,
		// 06:00, 12:00, 18:00 and 22:00 on the ward, in the ward's own zone.
		TimesOfDay: []int32{6 * 60, 12 * 60, 18 * 60, 22 * 60},
		EndAt:      start.Add(24 * time.Hour),
	}
	occurrences := timing.Occurrences(start, start.Add(24*time.Hour), kolkata)

	if len(occurrences) != 4 {
		t.Fatalf("four-times-daily produced %d occurrences over a day, want 4: %v",
			len(occurrences), occurrences)
	}
	// The first is 06:00 in Kolkata, which is 00:30 UTC — not six hours after
	// whenever it was prescribed.
	first := occurrences[0].In(kolkata)
	if first.Hour() != 6 || first.Minute() != 0 {
		t.Fatalf("the first dose is at %s on the ward, want 06:00", first)
	}
}

// A dose already past on the day it is prescribed is not given retroactively.
func TestASchedulePicksUpFromWhenItWasPrescribed(t *testing.T) {
	// 08:30 on the ward: the 06:00 round has been and gone.
	prescribed := at(3, 0)
	timing := domain.Timing{
		StartAt:    prescribed,
		TimesOfDay: []int32{6 * 60, 12 * 60, 18 * 60, 22 * 60},
		EndAt:      prescribed.Add(24 * time.Hour),
	}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(24*time.Hour), kolkata)

	if len(occurrences) != 3 {
		t.Fatalf("a drug prescribed after the morning round produced %d doses, "+
			"want 3: %v", len(occurrences), occurrences)
	}
	if occurrences[0].In(kolkata).Hour() != 12 {
		t.Fatalf("the first dose is at %s on the ward; the 06:00 round had "+
			"already passed", occurrences[0].In(kolkata))
	}
}

// A schedule computed in UTC puts a four-times-daily drug an hour out twice a
// year, which is how a dose lands at 01:00.
func TestASchedulePinsToTheWardsClockNotUTC(t *testing.T) {
	timing := domain.Timing{
		StartAt: at(0, 0), TimesOfDay: []int32{6 * 60},
		EndAt: at(0, 0).Add(48 * time.Hour),
	}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(48*time.Hour), kolkata)
	if len(occurrences) == 0 {
		t.Fatal("no occurrences")
	}
	for _, o := range occurrences {
		local := o.In(kolkata)
		if local.Hour() != 6 {
			t.Fatalf("an occurrence falls at %s on the ward, want 06:00", local)
		}
		if o.UTC().Hour() == 6 {
			t.Fatal("the schedule was computed in UTC rather than the ward's zone")
		}
	}
}

// A period-based repeat runs from the start time.
func TestASixHourlyOrderRepeatsFromWhenItStarts(t *testing.T) {
	timing := domain.Timing{
		StartAt: at(9, 0), Frequency: 6 * time.Hour,
		EndAt: at(9, 0).Add(24 * time.Hour),
	}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(48*time.Hour), kolkata)
	if len(occurrences) != 4 {
		t.Fatalf("six-hourly over a day produced %d, want 4", len(occurrences))
	}
	if !occurrences[0].Equal(at(9, 0)) {
		t.Fatalf("the first occurrence is %s, want 09:00", occurrences[0])
	}
	if !occurrences[1].Equal(at(15, 0)) {
		t.Fatalf("the second occurrence is %s, want 15:00", occurrences[1])
	}
}

// A count bounds a repeat by number rather than by time: "three doses".
func TestACountBoundsARepeatingOrder(t *testing.T) {
	timing := domain.Timing{
		StartAt: at(9, 0), Frequency: 6 * time.Hour, Count: 3,
	}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(7*24*time.Hour),
		kolkata)
	if len(occurrences) != 3 {
		t.Fatalf("a three-dose order produced %d occurrences", len(occurrences))
	}
}

// A standing order with no end produces a bounded list rather than an infinite
// one.
func TestAnOpenEndedOrderIsBoundedRatherThanInfinite(t *testing.T) {
	timing := domain.Timing{StartAt: at(9, 0), Frequency: time.Minute}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(365*24*time.Hour),
		kolkata)
	if len(occurrences) != domain.MaxOccurrences {
		t.Fatalf("an open-ended order produced %d occurrences, want the cap of %d",
			len(occurrences), domain.MaxOccurrences)
	}
}

// An as-needed order has no schedule, and one with both is two instructions the
// ward will follow inconsistently.
func TestAnAsNeededOrderCannotAlsoHaveASchedule(t *testing.T) {
	timing := domain.Timing{PRN: true, Frequency: 6 * time.Hour}
	if err := timing.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an as-needed order with a schedule was accepted: %v", err)
	}

	prn := domain.Timing{PRN: true}
	if err := prn.Validate(); err != nil {
		t.Fatalf("a plain as-needed order was refused: %v", err)
	}
	if len(prn.Occurrences(at(0, 0), at(0, 0).Add(24*time.Hour), kolkata)) != 0 {
		t.Fatal("an as-needed order produced scheduled occurrences")
	}
}

func TestTimingCannotEndBeforeItBegins(t *testing.T) {
	timing := domain.Timing{StartAt: at(12, 0), EndAt: at(9, 0)}
	if err := timing.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("timing ending before it begins was accepted: %v", err)
	}
}

// Days of week narrow a repeat: dialysis on Mondays, Wednesdays and Fridays.
func TestARepeatCanBeNarrowedToParticularDays(t *testing.T) {
	// 12 March 2026 is a Thursday.
	timing := domain.Timing{
		StartAt: at(8, 0), TimesOfDay: []int32{8 * 60},
		DaysOfWeek: []time.Weekday{time.Monday, time.Wednesday, time.Friday},
		EndAt:      at(8, 0).Add(7 * 24 * time.Hour),
	}
	occurrences := timing.Occurrences(at(0, 0), at(0, 0).Add(8*24*time.Hour),
		kolkata)
	if len(occurrences) != 3 {
		t.Fatalf("a thrice-weekly order produced %d occurrences over a week, want 3",
			len(occurrences))
	}
	for _, o := range occurrences {
		switch o.In(kolkata).Weekday() {
		case time.Monday, time.Wednesday, time.Friday:
		default:
			t.Fatalf("an occurrence fell on %s", o.In(kolkata).Weekday())
		}
	}
}

func existingOrder(t *testing.T, id string, orderType domain.Type,
	code domain.Coding, created time.Time, status domain.Status) *domain.Order {

	t.Helper()
	in := baseInput(orderType)
	in.Code = code
	order, err := domain.NewOrder(id, "tenant-1", "ORD-"+id, in, created)
	if err != nil {
		t.Fatalf("NewOrder: %v", err)
	}
	order.Status = status
	return order
}

// SRS-ORD-009: a warning, with the existing orders shown.
func TestADuplicateProducesAWarningRatherThanARefusal(t *testing.T) {
	candidate := newOrder(t, baseInput(domain.TypeLaboratory))
	existing := existingOrder(t, "order-0", domain.TypeLaboratory, potassium(),
		at(5, 0), domain.StatusAccepted)

	warning := domain.DetectDuplicates(candidate,
		[]*domain.Order{existing}, domain.DefaultDuplicateRules(), at(9, 0))

	if !warning.Any() {
		t.Fatal("a repeat potassium four hours later produced no warning")
	}
	// "A duplicate exists" without saying which one is a warning nobody can act
	// on, so the existing orders come back in full.
	if len(warning.Existing) != 1 || warning.Existing[0].ID != "order-0" {
		t.Fatalf("the warning does not name the existing order: %+v",
			warning.Existing)
	}
	if !warning.Overridable {
		t.Fatal("the duplicate is not overridable; the requirement forbids " +
			"arbitrary suppression")
	}
	// Nothing was refused: the candidate is untouched.
	if candidate.Status != domain.StatusDraft {
		t.Fatal("the duplicate check changed the candidate order")
	}
}

// A completed order is not a duplicate: the patient may well need the test
// again, and warning about last week's bloods is how a warning becomes noise.
func TestAFinishedOrderIsNotADuplicate(t *testing.T) {
	candidate := newOrder(t, baseInput(domain.TypeLaboratory))
	for _, status := range []domain.Status{
		domain.StatusCompleted, domain.StatusCancelled,
		domain.StatusEnteredInError,
	} {
		existing := existingOrder(t, "order-0", domain.TypeLaboratory,
			potassium(), at(5, 0), status)
		warning := domain.DetectDuplicates(candidate,
			[]*domain.Order{existing}, domain.DefaultDuplicateRules(), at(9, 0))
		if warning.Any() {
			t.Fatalf("a %s order was reported as a duplicate", status)
		}
	}
}

// The window is per type, and an order outside it is not a duplicate.
func TestAnOrderOutsideTheWindowIsNotADuplicate(t *testing.T) {
	candidate := newOrder(t, baseInput(domain.TypeLaboratory))
	// The laboratory window is twelve hours.
	existing := existingOrder(t, "order-0", domain.TypeLaboratory, potassium(),
		at(9, 0).Add(-20*time.Hour), domain.StatusAccepted)

	warning := domain.DetectDuplicates(candidate,
		[]*domain.Order{existing}, domain.DefaultDuplicateRules(), at(9, 0))
	if warning.Any() {
		t.Fatal("a twenty-hour-old laboratory order was reported as a duplicate")
	}
}

// A different test is not a duplicate where the rule says same-code-only, and
// any diet order supersedes the last because a patient has one diet.
func TestTheDuplicateRuleDependsOnTheOrderType(t *testing.T) {
	sodium := domain.Coding{
		System: "http://loinc.org", Version: "2.76",
		Code: "2951-2", Display: "Sodium [Moles/volume] in Serum or Plasma",
	}
	labCandidate := newOrder(t, baseInput(domain.TypeLaboratory))
	differentTest := existingOrder(t, "order-0", domain.TypeLaboratory, sodium,
		at(5, 0), domain.StatusAccepted)
	if domain.DetectDuplicates(labCandidate, []*domain.Order{differentTest},
		domain.DefaultDuplicateRules(), at(9, 0)).Any() {
		t.Fatal("a sodium was reported as a duplicate of a potassium")
	}

	softDiet := domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "435801000124108", Display: "Soft diet",
	}
	dietIn := baseInput(domain.TypeDiet)
	dietIn.Code = softDiet
	dietCandidate := newOrder(t, dietIn)
	nilByMouth := existingOrder(t, "order-0", domain.TypeDiet, domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "182922004", Display: "Nil by mouth",
	}, at(5, 0), domain.StatusAccepted)

	if !domain.DetectDuplicates(dietCandidate, []*domain.Order{nilByMouth},
		domain.DefaultDuplicateRules(), at(9, 0)).Any() {
		t.Fatal("a second diet order produced no warning; a patient has one diet")
	}
}

// A type with no rule is not checked.
func TestATypeWithNoRuleIsNotChecked(t *testing.T) {
	candidate := newOrder(t, baseInput(domain.TypeReferral))
	existing := existingOrder(t, "order-0", domain.TypeReferral, potassium(),
		at(8, 0), domain.StatusAccepted)

	if domain.DetectDuplicates(candidate, []*domain.Order{existing},
		domain.DefaultDuplicateRules(), at(9, 0)).Any() {
		t.Fatal("a referral was checked against a rule that does not exist")
	}
}

// SRS-ORD-009: proceeding is recorded against what was shown.
func TestADuplicateOverrideRecordsWhatItOverrode(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))

	if err := order.RecordDuplicateOverride(nil, "clinically indicated",
		"doctor-1", at(9, 0)); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an override with nothing overridden was accepted: %v", err)
	}
	if err := order.RecordDuplicateOverride([]string{"order-0"}, "",
		"doctor-1", at(9, 0)); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an override with no reason was accepted: %v", err)
	}

	if err := order.RecordDuplicateOverride([]string{"order-0"},
		"repeat requested by the renal team", "doctor-1", at(9, 0)); err != nil {
		t.Fatalf("RecordDuplicateOverride: %v", err)
	}
	// Stored rather than recomputed: the existing orders usually complete
	// afterwards, and a recomputing report would show every override as having
	// overridden nothing.
	if len(order.DuplicateOverride.AgainstOrderIDs) != 1 {
		t.Fatalf("the override does not record what it overrode: %+v",
			order.DuplicateOverride)
	}
}

func orderSet() domain.OrderSet {
	return domain.OrderSet{
		ID: "set-1", TenantID: "tenant-1", Version: "4",
		Name: "Chest pain admission", Specialty: "cardiology",
		Components: []domain.Component{
			{
				ID: "c-troponin", Type: domain.TypeLaboratory,
				Code: domain.Coding{
					System: "http://loinc.org", Version: "2.76",
					Code: "42757-5", Display: "Troponin T",
				},
				Priority: domain.PriorityUrgent, SelectedByDefault: true,
			},
			{
				ID: "c-ecg", Type: domain.TypeProcedure,
				Code: domain.Coding{
					System: "http://snomed.info/sct", Version: "2024-03",
					Code: "29303009", Display: "Electrocardiogram",
				},
				Indication: "chest pain",
				Priority:   domain.PriorityStat,
				// A twelve-lead ECG in a chest-pain pathway is not optional.
				SelectedByDefault: true, Mandatory: true,
			},
			{
				ID: "c-cxr", Type: domain.TypeImaging,
				Code: chestXRay(), Indication: "chest pain",
				Priority: domain.PriorityRoutine,
			},
		},
		CreatedBy: "cardiology-committee", CreatedAt: at(8, 0),
	}
}

// SRS-ORD-003: individually selectable components with visible defaults.
func TestAnOrderSetPlacesOnlyWhatWasSelectedPlusWhatIsMandatory(t *testing.T) {
	set := orderSet()
	if err := set.Validate(); err != nil {
		t.Fatalf("Validate: %v", err)
	}

	// The clinician ticks only the troponin. The ECG is mandatory and comes
	// anyway; the chest X-ray does not.
	inputs, err := set.Expand(baseInput(domain.TypeLaboratory),
		[]domain.Selection{{ComponentID: "c-troponin"}})
	if err != nil {
		t.Fatalf("Expand: %v", err)
	}
	if len(inputs) != 2 {
		t.Fatalf("the set expanded to %d orders, want 2 (troponin + mandatory ECG)",
			len(inputs))
	}
	got := map[string]bool{}
	for _, in := range inputs {
		got[in.Code.Code] = true
	}
	if !got["42757-5"] || !got["29303009"] {
		t.Fatalf("the expansion is wrong: %v", got)
	}
	if got["399208008"] {
		t.Fatal("an unticked component was placed; a set that places everything " +
			"is a set clinicians stop using")
	}
}

// SRS-ORD-003: the set's version travels onto each order as provenance.
func TestAnOrderSetsVersionTravelsOntoEveryOrderItPlaces(t *testing.T) {
	inputs, err := orderSet().Expand(baseInput(domain.TypeLaboratory),
		[]domain.Selection{{ComponentID: "c-troponin"}})
	if err != nil {
		t.Fatalf("Expand: %v", err)
	}
	for _, in := range inputs {
		if in.OrderSetID != "set-1" || in.OrderSetVersion != "4" {
			t.Fatalf("an order carries provenance %q/%q",
				in.OrderSetID, in.OrderSetVersion)
		}
	}
}

// A clinician may change a default; the set records what it suggested rather
// than what was placed.
func TestAClinicianCanOverrideTheSetsDefaults(t *testing.T) {
	inputs, err := orderSet().Expand(baseInput(domain.TypeLaboratory),
		[]domain.Selection{{
			ComponentID: "c-cxr", Indication: "query pneumothorax",
			Priority: domain.PriorityStat,
		}, {ComponentID: "c-troponin"}})
	if err != nil {
		t.Fatalf("Expand: %v", err)
	}
	for _, in := range inputs {
		if in.Code.Code != "399208008" {
			continue
		}
		if in.Indication != "query pneumothorax" {
			t.Fatalf("the indication override was lost: %q", in.Indication)
		}
		if in.Priority != domain.PriorityStat {
			t.Fatalf("the priority override was lost: %q", in.Priority)
		}
		return
	}
	t.Fatal("the chest X-ray was not placed")
}

// A set that places everything or nothing is not a set.
func TestAnEmptySelectionFromASetIsRefused(t *testing.T) {
	set := orderSet()
	// Remove the mandatory component so nothing is forced.
	set.Components = set.Components[:1]
	set.Components[0].SelectedByDefault = false

	if _, err := set.Expand(baseInput(domain.TypeLaboratory), nil); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("an empty selection was accepted: %v", err)
	}
}

func TestAnOrderSetNeedsAVersionAndAComponent(t *testing.T) {
	noVersion := orderSet()
	noVersion.Version = ""
	if err := noVersion.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an unversioned set was accepted: %v", err)
	}

	empty := orderSet()
	empty.Components = nil
	if err := empty.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an empty set was accepted: %v", err)
	}
}

// A mandatory component that starts unticked is a contradiction the clinician
// resolves by not noticing it.
func TestAMandatoryComponentMustBeSelectedByDefault(t *testing.T) {
	set := orderSet()
	for i := range set.Components {
		if set.Components[i].Mandatory {
			set.Components[i].SelectedByDefault = false
		}
	}
	if err := set.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("a mandatory component starting unticked was accepted: %v", err)
	}
}

func TestARetiredOrderSetCannotBeUsed(t *testing.T) {
	set := orderSet()
	set.RetiredAt = at(8, 30)
	if _, err := set.Expand(baseInput(domain.TypeLaboratory),
		[]domain.Selection{{ComponentID: "c-troponin"}}); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a retired order set was used: %v", err)
	}
}

func TestSelectingAComponentThatDoesNotExistIsRefused(t *testing.T) {
	if _, err := orderSet().Expand(baseInput(domain.TypeLaboratory),
		[]domain.Selection{{ComponentID: "c-nonsense"}}); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("a component that does not exist was selected: %v", err)
	}
}

// SRS-ORD-012: a favourite is pre-filled values and nothing else, so it goes
// through the same policy.
func TestAFavouriteCannotBypassAMandatoryIndication(t *testing.T) {
	favourite := domain.Favourite{
		ID: "fav-1", TenantID: "tenant-1", OwnerID: "doctor-1",
		Name: "My routine chest film",
		Type: domain.TypeImaging, Code: chestXRay(),
		Priority: domain.PriorityRoutine,
		// Saved before the tenant made indications mandatory.
	}
	if err := favourite.Validate(); err != nil {
		t.Fatalf("Validate: %v", err)
	}

	in := favourite.Apply(baseInput(domain.TypeImaging))
	order, err := domain.NewOrder("order-1", "tenant-1", "ORD-0001", in, at(9, 0))
	if err != nil {
		t.Fatalf("NewOrder: %v", err)
	}

	err = order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1))
	var incomplete domain.ErrOrderIncomplete
	if !errors.As(err, &incomplete) {
		t.Fatalf("a favourite bypassed the mandatory indication: %v", err)
	}
	// The favourite is recorded on the draft either way, so a report can ask
	// whether a consultant's shortcut still matches the institutional set.
	if order.FavouriteID != "fav-1" {
		t.Fatalf("the favourite's provenance was lost: %q", order.FavouriteID)
	}
}

func TestAFavouriteBelongsToSomebodyAndNeedsAName(t *testing.T) {
	for name, mutate := range map[string]func(*domain.Favourite){
		"no owner": func(f *domain.Favourite) { f.OwnerID = "" },
		"no name":  func(f *domain.Favourite) { f.Name = "" },
	} {
		f := domain.Favourite{
			ID: "fav-1", OwnerID: "doctor-1", Name: "Routine bloods",
			Type: domain.TypeLaboratory, Code: potassium(),
		}
		mutate(&f)
		if err := f.Validate(); !errors.Is(err, domain.ErrInvalidOrder) {
			t.Fatalf("a favourite with %s was accepted: %v", name, err)
		}
	}
}

// A blood-product order is gated on a privilege the domain names, so the
// application layer and the domain cannot drift about which types are gated.
func TestThePolicyNamesWhichTypesNeedAPrivilege(t *testing.T) {
	privilege, ok := domain.DefaultPolicy().RequiredPrivilege(domain.TypeBloodProduct)
	if !ok || privilege == "" {
		t.Fatal("a blood-product order is not gated on any privilege")
	}
	if _, ok := domain.DefaultPolicy().RequiredPrivilege(
		domain.TypeLaboratory); ok {
		t.Fatal("a laboratory order is gated on a privilege")
	}
}
