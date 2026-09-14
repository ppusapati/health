package app_test

import (
	"context"
	"fmt"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	schedulingv1 "github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1/schedulingv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Scheduling (SRS-SCH-001 … 004, SRS-SCH-014, SRS-SCH-016).
//
// The requirement this file exists for is SRS-SCH-004: "book appointment
// atomically and prevent overbooking beyond configured capacity", with the
// acceptance criterion "concurrent booking test does not exceed capacity".
// Everything else here is the roster the booking has to respect.

type schedHarness struct {
	pool     *pgxpool.Pool
	sched    schedulingv1connect.AppointmentServiceClient
	patients empiv1connect.PatientServiceClient
	org      organizationv1connect.OrganizationServiceClient
	tenantID string
	facility string
	resource string
}

func newSchedHarness(t *testing.T) *schedHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &schedHarness{
		pool:     pool,
		sched:    schedulingv1connect.NewAppointmentServiceClient(server.Client(), server.URL),
		patients: empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:      organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
	}

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Apollo Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	h.tenantID = tenant.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(h.tenantID), &organizationv1.CreateFacilityRequest{
			Code: "main", DisplayName: "Main Hospital",
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	h.entitle(t, "empi")
	h.entitle(t, "scheduling")
	h.resource = h.defineResource(t, "Dr Rao")
	return h
}

// entitle grants a module. Without it every call is refused at the wire with
// MODULE_NOT_ENTITLED, which is SRS-PLT-011 working rather than a harness
// inconvenience.
func (h *schedHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID, "",
		module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

// Tokens. The fourth segment is the facility claim.
func (h *schedHarness) schedulerToken() string {
	return h.tenantID + ":scheduler-1:scheduler:" + h.facility
}

func (h *schedHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *schedHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *schedHarness) defineResource(t *testing.T, name string) string {
	t.Helper()

	resource, err := h.sched.DefineResource(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.DefineResourceRequest{
			FacilityId:  h.facility,
			Type:        schedulingv1.ResourceType_RESOURCE_TYPE_PRACTITIONER,
			SubjectId:   "doctor-1",
			DisplayName: name,
			TimeZone:    "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("DefineResource: %v", err)
	}
	return resource.Msg.GetResource().GetResourceId()
}

// nextWeekday returns the next occurrence of a weekday, in UTC date terms.
//
// Relative to now rather than a fixed date so the tests do not start failing
// when a hardcoded Tuesday drifts into the past.
// nextWeekday returns the next occurrence of a weekday, at least minDays away.
//
// The minimum is load-bearing rather than cosmetic. Some scheduling rules are
// expressed as a lead time — a 24-hour reminder, a notice period — and a test
// that books "the next Tuesday" gets an appointment anywhere from one to seven
// days out depending on which day the suite happens to run. A reminder test
// needs at least two days so the 24-hour lead fits; a late-cancellation test
// needs fewer than seven so the notice period is missed. Taking the immediate
// next occurrence for both made one of them fail on one day in seven, and a
// test whose outcome depends on the day it runs is a test nobody trusts the
// next time it goes red.
func nextWeekday(w time.Weekday, minDays int) time.Time {
	if minDays < 1 {
		minDays = 1
	}
	today := time.Now().UTC().Truncate(24 * time.Hour)
	for i := minDays; i < minDays+7; i++ {
		candidate := today.AddDate(0, 0, i)
		if candidate.Weekday() == w {
			return candidate
		}
	}
	return today.AddDate(0, 0, minDays)
}

// defineClinic rosters a four-hour clinic with the given slot length and
// capacity, on the next occurrence of a weekday.
func (h *schedHarness) defineClinic(t *testing.T, weekday time.Weekday,
	slotMinutes, capacity int32) time.Time {
	t.Helper()
	return h.defineClinicIn(t, weekday, slotMinutes, capacity, 1)
}

// defineClinicIn rosters a clinic on the next occurrence of a weekday that is
// at least minDays away, for the tests whose rule is a lead time.
func (h *schedHarness) defineClinicIn(t *testing.T, weekday time.Weekday,
	slotMinutes, capacity int32, minDays int) time.Time {
	t.Helper()

	day := nextWeekday(weekday, minDays)
	if _, err := h.sched.DefineSchedule(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.DefineScheduleRequest{
			ResourceId:    h.resource,
			VisitType:     schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			VisitMode:     schedulingv1.VisitMode_VISIT_MODE_IN_PERSON,
			Weekday:       int32(weekday),
			StartMinute:   9 * 60,
			EndMinute:     13 * 60,
			SlotMinutes:   slotMinutes,
			Capacity:      capacity,
			EffectiveFrom: timestamppb.New(day.AddDate(0, 0, -1)),
		})); err != nil {
		t.Fatalf("DefineSchedule: %v", err)
	}
	return day
}

func (h *schedHarness) searchSlots(t *testing.T, token string, day time.Time) []*schedulingv1.Slot {
	t.Helper()

	found, err := h.sched.SearchSlots(context.Background(),
		withFacility(token, h.facility, &schedulingv1.SearchSlotsRequest{
			ResourceId: h.resource,
			From:       timestamppb.New(day),
			Until:      timestamppb.New(day.AddDate(0, 0, 1)),
		}))
	if err != nil {
		t.Fatalf("SearchSlots: %v", err)
	}
	return found.Msg.GetSlots()
}

func (h *schedHarness) registerPatient(t *testing.T, family, given, phone string) string {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{given},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	return registered.Msg.GetPatient().GetPatientId()
}

// SRS-SCH-003: slot search reflects the active roster.
func TestSlotSearchReflectsTheRoster(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)

	slots := h.searchSlots(t, h.clerkToken(), day)
	// 09:00 to 13:00 at fifteen minutes is sixteen.
	if len(slots) != 16 {
		t.Fatalf("search returned %d slots for a four-hour clinic, want 16", len(slots))
	}
	for _, s := range slots {
		if s.GetRemaining() != 1 || s.GetCapacity() != 1 {
			t.Fatalf("slot reports capacity %d remaining %d, want 1 and 1",
				s.GetCapacity(), s.GetRemaining())
		}
	}
}

// An unfiltered search expands every diary in the tenant. That is a capacity
// report, not a booking screen.
func TestAnUnfilteredSlotSearchIsRefused(t *testing.T) {
	h := newSchedHarness(t)
	day := nextWeekday(time.Tuesday, 1)

	_, err := h.sched.SearchSlots(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.SearchSlotsRequest{
			From: timestamppb.New(day), Until: timestamppb.New(day.AddDate(0, 0, 1)),
		}))
	if err == nil {
		t.Fatal("a slot search with no filter at all was accepted")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_SEARCH_UNFILTERED" {
		t.Fatalf("error code = %+v, want SCH_SEARCH_UNFILTERED", detail)
	}
}

// The ordinary booking path, and the slot it consumes stops being offered.
func TestBookingConsumesTheSlot(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	first := slots[0]

	booked, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  first.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Reason:    "review",
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}
	if booked.Msg.GetAppointment().GetStatus() !=
		schedulingv1.AppointmentStatus_APPOINTMENT_STATUS_SCHEDULED {
		t.Fatalf("status = %v, want scheduled", booked.Msg.GetAppointment().GetStatus())
	}

	after := h.searchSlots(t, h.clerkToken(), day)
	if len(after) != len(slots)-1 {
		t.Fatalf("after booking the search returned %d slots, want %d — the booked "+
			"slot is still being offered", len(after), len(slots)-1)
	}
	for _, s := range after {
		if s.GetStartsAt().AsTime().Equal(first.GetStartsAt().AsTime()) {
			t.Fatal("the booked slot is still offered as available")
		}
	}
}

// SRS-SCH-004's acceptance criterion, stated as a test: "concurrent booking
// test does not exceed capacity".
//
// The failure this guards against is not theoretical. A check-then-insert
// passes every single-threaded test and fails under load, and the way it fails
// is two patients in one slot, both in the waiting room, with nothing in the
// record to say which booking was second.
func TestConcurrentBookingsCannotExceedCapacity(t *testing.T) {
	const capacity = 3
	const attempts = 12

	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 60, capacity)

	slots := h.searchSlots(t, h.clerkToken(), day)
	if len(slots) == 0 {
		t.Fatal("no slots were generated")
	}
	target := slots[0].GetStartsAt()

	// One patient each: a patient cannot hold two live bookings in one slot, so
	// reusing one would be refused by a different rule and prove nothing about
	// capacity.
	patients := make([]string, attempts)
	for i := range patients {
		patients[i] = h.registerPatient(t, fmt.Sprintf("Contender%d", i), "Test",
			fmt.Sprintf("98000000%02d", i))
	}

	var (
		wg        sync.WaitGroup
		mu        sync.Mutex
		succeeded int
		refusals  []string
	)
	start := make(chan struct{})

	for i := 0; i < attempts; i++ {
		wg.Add(1)
		go func(patientID string) {
			defer wg.Done()
			<-start

			_, err := h.sched.BookAppointment(context.Background(),
				withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
					PatientId: patientID, ResourceId: h.resource,
					StartsAt:  target,
					VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
				}))

			mu.Lock()
			defer mu.Unlock()
			if err == nil {
				succeeded++
				return
			}
			refusals = append(refusals, err.Error())
		}(patients[i])
	}

	close(start)
	wg.Wait()

	if succeeded != capacity {
		t.Fatalf("%d of %d concurrent bookings succeeded against a capacity of %d; "+
			"refusals were %v", succeeded, attempts, capacity, refusals)
	}

	// And the database agrees, which is the check that matters: a response
	// count could be right while the row is wrong.
	var booked, stored int
	if err := h.pool.QueryRow(context.Background(),
		`SELECT booked, capacity FROM scheduling.slot
		 WHERE tenant_id = $1 AND starts_at = $2`,
		h.tenantID, target.AsTime()).Scan(&booked, &stored); err != nil {
		t.Fatalf("read slot: %v", err)
	}
	if booked != capacity {
		t.Fatalf("the slot row records %d bookings against a capacity of %d",
			booked, stored)
	}

	// Every refusal says the slot is full, rather than surfacing a constraint
	// violation a client cannot act on.
	for _, refusal := range refusals {
		if !strings.Contains(refusal, "SCH_SLOT_FULL") &&
			!strings.Contains(refusal, "fully booked") {
			t.Fatalf("a losing booking was refused with %q, which a client cannot "+
				"tell from a server fault", refusal)
		}
	}
}

// SRS-SCH-002: blocked capacity cannot be booked unless override permission.
func TestABlockedPeriodIsNotOfferedOrBookable(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	target := slots[0]

	if _, err := h.sched.BlockPeriod(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BlockPeriodRequest{
			ResourceId: h.resource,
			Kind:       schedulingv1.ExceptionKind_EXCEPTION_KIND_LEAVE,
			StartsAt:   target.GetStartsAt(),
			EndsAt:     target.GetEndsAt(),
			Reason:     "annual leave",
		})); err != nil {
		t.Fatalf("BlockPeriod: %v", err)
	}

	after := h.searchSlots(t, h.clerkToken(), day)
	for _, s := range after {
		if s.GetStartsAt().AsTime().Equal(target.GetStartsAt().AsTime()) {
			t.Fatal("a slot under annual leave is still offered")
		}
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  target.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a patient was booked into a period of annual leave")
	}
}

// An overridable block is visible to a scheduler and bookable by one; annual
// leave is neither, whoever asks. The clinician is not there, and a permission
// that could conjure them up would be a permission to book a patient in to see
// nobody.
func TestOnlyAnOverridableBlockCanBeOverridden(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")
	other := h.registerPatient(t, "Rao", "Anil", "9876543211")

	slots := h.searchSlots(t, h.clerkToken(), day)
	provisional, leave := slots[0], slots[1]

	if _, err := h.sched.BlockPeriod(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BlockPeriodRequest{
			ResourceId: h.resource,
			Kind:       schedulingv1.ExceptionKind_EXCEPTION_KIND_THEATRE,
			StartsAt:   provisional.GetStartsAt(), EndsAt: provisional.GetEndsAt(),
			Reason: "provisional theatre list", Overridable: true,
		})); err != nil {
		t.Fatalf("BlockPeriod (provisional): %v", err)
	}
	if _, err := h.sched.BlockPeriod(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BlockPeriodRequest{
			ResourceId: h.resource,
			Kind:       schedulingv1.ExceptionKind_EXCEPTION_KIND_LEAVE,
			StartsAt:   leave.GetStartsAt(), EndsAt: leave.GetEndsAt(),
			Reason: "annual leave",
		})); err != nil {
		t.Fatalf("BlockPeriod (leave): %v", err)
	}

	// The scheduler sees the provisional block, marked, and not the leave.
	var sawProvisional, sawLeave bool
	for _, s := range h.searchSlots(t, h.schedulerToken(), day) {
		switch {
		case s.GetStartsAt().AsTime().Equal(provisional.GetStartsAt().AsTime()):
			sawProvisional = true
			if !s.GetBlocked() || s.GetBlockedReason() != "provisional theatre list" {
				t.Fatalf("the overridable slot does not say it is blocked or why: %+v", s)
			}
		case s.GetStartsAt().AsTime().Equal(leave.GetStartsAt().AsTime()):
			sawLeave = true
		}
	}
	if !sawProvisional {
		t.Fatal("a scheduler cannot see the provisional block they may override")
	}
	if sawLeave {
		t.Fatal("annual leave was offered to a scheduler; the clinician is not there")
	}

	// And booking follows the same rule.
	if _, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  provisional.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Override:  true,
		})); err != nil {
		t.Fatalf("a scheduler could not override a provisional block: %v", err)
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: other, ResourceId: h.resource,
			StartsAt:  leave.GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Override:  true,
		}))
	if err == nil {
		t.Fatal("annual leave was overridden")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_SLOT_NOT_OVERRIDABLE" {
		t.Fatalf("error code = %+v, want SCH_SLOT_NOT_OVERRIDABLE", detail)
	}
}

// Overriding needs the permission, not merely the intent.
func TestOverridingNeedsThePermission(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	if _, err := h.sched.BlockPeriod(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.BlockPeriodRequest{
			ResourceId: h.resource,
			Kind:       schedulingv1.ExceptionKind_EXCEPTION_KIND_THEATRE,
			StartsAt:   slots[0].GetStartsAt(), EndsAt: slots[0].GetEndsAt(),
			Reason: "provisional list", Overridable: true,
		})); err != nil {
		t.Fatalf("BlockPeriod: %v", err)
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  slots[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Override:  true,
		}))
	if err == nil {
		t.Fatal("a clerk overrode a block without the permission")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_OVERRIDE_DENIED" {
		t.Fatalf("error code = %+v, want SCH_OVERRIDE_DENIED", detail)
	}
}

// SRS-SCH-014: "API returns domain-specific unavailability error". A client
// that cannot tell "this clinician has left" from "the server is busy" retries
// the first forever.
func TestBookingAnInactiveResourceIsRefusedSpecifically(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	target := slots[0].GetStartsAt()

	if _, err := h.sched.SetResourceStatus(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &schedulingv1.SetResourceStatusRequest{
			ResourceId: h.resource,
			Status:     schedulingv1.ResourceStatus_RESOURCE_STATUS_INACTIVE,
		})); err != nil {
		t.Fatalf("SetResourceStatus: %v", err)
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt: target, VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a patient was booked with a resource that is out of service")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "SCH_NOT_BOOKABLE" {
		t.Fatalf("error code = %+v, want SCH_NOT_BOOKABLE", detail)
	}

	// And its slots stop being offered at all, which is the cheaper guarantee.
	if got := h.searchSlots(t, h.clerkToken(), day); len(got) != 0 {
		t.Fatalf("an inactive resource still offers %d slots", len(got))
	}
}

// A client holding a search result taken before a roster change must not be
// able to book a slot that no longer exists.
func TestASlotOutsideTheRosterCannotBeBooked(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	// 03:00 local, which no roster covers.
	midnightish := day.Add(3 * time.Hour)

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  timestamppb.New(midnightish),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a client named its own slot outside the roster and was booked")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "SCH_SLOT_NOT_FOUND" {
		t.Fatalf("error code = %+v, want SCH_SLOT_NOT_FOUND", detail)
	}
}

// SRS-EMPI-008's other half: the identity context says whether the patient is
// fit for a routine appointment, and scheduling blocks on the answer.
func TestADeceasedPatientCannotBeGivenARoutineAppointment(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)

	if _, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient,
			Date: &empiv1.PartialDate{
				Date:      timestamppb.New(time.Now().UTC().AddDate(0, 0, -1)),
				Precision: empiv1.DatePrecision_DATE_PRECISION_DAY,
			},
			Source: "attending clinician",
		})); err != nil {
		t.Fatalf("RecordDeceased: %v", err)
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  slots[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a routine appointment was booked for a patient recorded as deceased")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_PATIENT_NOT_SCHEDULABLE" {
		t.Fatalf("error code = %+v, want SCH_PATIENT_NOT_SCHEDULABLE", detail)
	}
}

// Defining when a clinic runs is configuration, deliberately not bundled with
// the ability to look inside the diary at who is coming.
func TestAClerkCannotRewriteTheRoster(t *testing.T) {
	h := newSchedHarness(t)

	_, err := h.sched.DefineSchedule(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.DefineScheduleRequest{
			ResourceId:  h.resource,
			VisitType:   schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			VisitMode:   schedulingv1.VisitMode_VISIT_MODE_IN_PERSON,
			Weekday:     int32(time.Tuesday),
			StartMinute: 9 * 60, EndMinute: 13 * 60,
			SlotMinutes: 15, Capacity: 1,
			EffectiveFrom: timestamppb.New(time.Now().UTC()),
		}))
	if err == nil {
		t.Fatal("a registration clerk rewrote the clinic's roster")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "SCH_CONFIGURE_DENIED" {
		t.Fatalf("error code = %+v, want SCH_CONFIGURE_DENIED", detail)
	}
}

// A clinician reads their diary but does not book: that is the desk's job.
func TestAClinicianCannotBook(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Iyer", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clinicianToken(), day)
	if len(slots) == 0 {
		t.Fatal("a clinician cannot see their own diary")
	}

	_, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  slots[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
		}))
	if err == nil {
		t.Fatal("a clinician booked an appointment")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "SCH_BOOK_DENIED" {
		t.Fatalf("error code = %+v, want SCH_BOOK_DENIED", detail)
	}
}

// SRS-SCH-016: the events downstream contexts wait for.
func TestBookingEmitsAnAppointmentBookedEvent(t *testing.T) {
	h := newSchedHarness(t)
	day := h.defineClinic(t, time.Tuesday, 15, 1)
	patient := h.registerPatient(t, "Venkataraghavan", "Meera", "9876543210")

	slots := h.searchSlots(t, h.clerkToken(), day)
	booked, err := h.sched.BookAppointment(context.Background(),
		withFacility(h.clerkToken(), h.facility, &schedulingv1.BookAppointmentRequest{
			PatientId: patient, ResourceId: h.resource,
			StartsAt:  slots[0].GetStartsAt(),
			VisitType: schedulingv1.VisitType_VISIT_TYPE_FOLLOW_UP,
			Reason:    "post-operative review",
		}))
	if err != nil {
		t.Fatalf("BookAppointment: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'appointment.booked'`,
		booked.Msg.GetAppointment().GetAppointmentId()).Scan(&payload); err != nil {
		t.Fatalf("no appointment.booked event was written: %v", err)
	}

	// The event carries identifiers and times, never the stated reason: an
	// event stream is read by more systems, by more people and under fewer
	// controls than the record it describes.
	if strings.Contains(payload, "post-operative") ||
		strings.Contains(payload, "Venkataraghavan") {
		t.Fatalf("the event carries clinical or demographic detail: %s", payload)
	}
	if !strings.Contains(payload, patient) {
		t.Fatalf("the event does not name the patient, so a downstream projection "+
			"cannot key on it: %s", payload)
	}
}

// A diary cannot be reached across a tenant boundary.
func TestASlotSearchCannotReachAnotherTenant(t *testing.T) {
	h := newSchedHarness(t)
	h.defineClinic(t, time.Tuesday, 15, 1)

	neighbour, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant (neighbour): %v", err)
	}
	neighbourID := neighbour.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(neighbourID), &organizationv1.CreateFacilityRequest{
			Code: "north", DisplayName: "North Hospital",
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility (neighbour): %v", err)
	}
	neighbourFacility := facility.Msg.GetFacility().GetFacilityId()

	// Entitle the neighbour so the refusal is tenant isolation rather than
	// SRS-PLT-011 declining the module.
	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: neighbourID,
	}).TenantScope()
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), neighbourID, "",
		"scheduling", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}

	day := nextWeekday(time.Tuesday, 1)
	found, err := h.sched.SearchSlots(context.Background(),
		withFacility(neighbourID+":scheduler-2:scheduler:"+neighbourFacility,
			neighbourFacility, &schedulingv1.SearchSlotsRequest{
				ResourceId: h.resource,
				From:       timestamppb.New(day), Until: timestamppb.New(day.AddDate(0, 0, 1)),
			}))
	if err != nil {
		t.Fatalf("SearchSlots (neighbour): %v", err)
	}
	if len(found.Msg.GetSlots()) != 0 {
		t.Fatalf("a neighbouring tenant saw %d slots from this tenant's diary",
			len(found.Msg.GetSlots()))
	}
}
