package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	billingv1 "github.com/ppusapati/health/code/gen/go/healthcare/billing/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/billing/v1/billingv1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
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

// Billing, tariffs and patient revenue (SRS-BIL-001 … SRS-BIL-016).
//
// Four rules this file exists to prove end to end, because each is a control
// that only counts across the whole stack.
//
// SRS-BIL-001's: a historical invoice resolves the service version active at
// charge time. A price list edited in April must not change what a March
// invoice says it charged for.
//
// SRS-BIL-003's: a redelivered clinical event produces one charge. The bus is
// at-least-once and the biller must not be.
//
// SRS-BIL-010's: a finalised invoice is never edited. The patient is holding a
// copy, and a correction is a credit note that references it.
//
// SRS-BIL-012's: the balance is the sum of the ledger, and it comes out exact.

type bilHarness struct {
	pool       *pgxpool.Pool
	billing    billingv1connect.BillingServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	tenantID   string
	facility   string
}

func newBilHarness(t *testing.T) *bilHarness {
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
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &bilHarness{
		pool:       pool,
		billing:    billingv1connect.NewBillingServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "encounter", "billing"} {
		h.entitle(t, module)
	}
	return h
}

func (h *bilHarness) entitle(t *testing.T, module string) {
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

func (h *bilHarness) financeToken() string {
	return h.tenantID + ":finance-1:finance_admin:" + h.facility
}

func (h *bilHarness) billerToken() string {
	return h.tenantID + ":biller-1:billing_clerk:" + h.facility
}

func (h *bilHarness) cashierToken() string {
	return h.tenantID + ":cashier-1:cashier:" + h.facility
}

func (h *bilHarness) otherCashierToken() string {
	return h.tenantID + ":cashier-2:cashier:" + h.facility
}

func (h *bilHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *bilHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func inrProto(minor int64) *billingv1.Money {
	return &billingv1.Money{Minor: minor, Currency: "INR"}
}

// chart registers a patient, opens an encounter and opens the account.
func (h *bilHarness) chart(t *testing.T, family, phone string) (string, string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1971, 5, 9), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "elective surgery",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	encounter := opened.Msg.GetEncounter().GetEncounterId()

	account, err := h.billing.OpenAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.OpenAccountRequest{
			EncounterId: encounter, PatientId: patient, Currency: "INR",
		}))
	if err != nil {
		t.Fatalf("OpenAccount: %v", err)
	}
	return patient, encounter, account.Msg.GetAccount().GetAccountId()
}

// publishService adds a version to the charge master.
func (h *bilHarness) publishService(t *testing.T, code, description string,
	taxRateBp int32, from time.Time) {

	t.Helper()
	_, err := h.billing.PublishService(context.Background(),
		as(h.financeToken(), &billingv1.PublishServiceRequest{
			Item: &billingv1.ServiceItem{
				Code: code, Description: description,
				Department: "Surgery", RevenueAccount: "4300",
				TaxCode: "GST18", TaxRateBp: taxRateBp,
				EffectiveFrom: timestamppb.New(from),
			},
		}))
	if err != nil {
		t.Fatalf("PublishService(%s): %v", code, err)
	}
}

// publishTariff records a price.
func (h *bilHarness) publishTariff(t *testing.T, contract, code string,
	scope *billingv1.TariffScope, minor int64, from time.Time) {

	t.Helper()
	if scope == nil {
		scope = &billingv1.TariffScope{}
	}
	scope.ServiceCode = code
	_, err := h.billing.PublishTariff(context.Background(),
		as(h.financeToken(), &billingv1.PublishTariffRequest{
			Line: &billingv1.TariffLine{
				TariffLineId: uuid.NewString(),
				ContractId:   contract, Name: contract + " agreement",
				Scope: scope, Price: inrProto(minor),
				EffectiveFrom: timestamppb.New(from),
			},
		}))
	if err != nil {
		t.Fatalf("PublishTariff(%s): %v", contract, err)
	}
}

func (h *bilHarness) postCharge(t *testing.T, account, code, sourceID string,
	quantity int32, occurred time.Time) *billingv1.PostChargeResponse {

	t.Helper()
	posted, err := h.billing.PostCharge(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.PostChargeRequest{
			AccountId: account, ServiceCode: code, Quantity: quantity,
			Origin: billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT,
			Source: &billingv1.SourceReference{
				System: "orders", Id: sourceID, Detail: "ORD-" + sourceID,
			},
			OccurredAt: timestamppb.New(occurred),
		}))
	if err != nil {
		t.Fatalf("PostCharge(%s): %v", code, err)
	}
	return posted.Msg
}

// SRS-BIL-001: a charge resolves the service version active when the care
// happened, not the one in force now.
func TestAChargeUsesTheTaxRateInForceOnTheDayOfCare(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	old := time.Now().UTC().AddDate(0, -6, 0)
	recent := time.Now().UTC().AddDate(0, 0, -1)

	// 12% until yesterday, 18% from yesterday.
	h.publishService(t, "PROC-APP", "Appendicectomy", 1200, old)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, recent)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, old)

	// Care delivered three months ago, keyed now.
	backdated := h.postCharge(t, account, "PROC-APP", "back-1", 1,
		time.Now().UTC().AddDate(0, -3, 0))
	if got := backdated.GetCharge().GetTaxRateBp(); got != 1200 {
		t.Fatalf("a three-month-old charge used a rate of %d, want the 12%% then in force", got)
	}

	// Care delivered today.
	today := h.postCharge(t, account, "PROC-APP", "today-1", 1, time.Now().UTC())
	if got := today.GetCharge().GetTaxRateBp(); got != 1800 {
		t.Fatalf("today's charge used a rate of %d, want 18%%", got)
	}
}

// SRS-BIL-003: a redelivered clinical event produces one charge.
func TestARedeliveredClinicalEventProducesOneCharge(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, from)

	first := h.postCharge(t, account, "PROC-APP", "ord-1", 1, time.Now().UTC())
	if first.GetAlreadyPosted() {
		t.Fatal("the first delivery reported itself as a duplicate")
	}

	second := h.postCharge(t, account, "PROC-APP", "ord-1", 1, time.Now().UTC())
	if !second.GetAlreadyPosted() {
		t.Fatal("a redelivered event was not recognised as already posted")
	}
	if second.GetCharge().GetChargeId() != first.GetCharge().GetChargeId() {
		t.Fatalf("the redelivery produced charge %q, want the original %q",
			second.GetCharge().GetChargeId(), first.GetCharge().GetChargeId())
	}

	listed, err := h.billing.ListCharges(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.ListChargesRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("ListCharges: %v", err)
	}
	if len(listed.Msg.GetCharges()) != 1 {
		t.Fatalf("%d charges on the account, want 1", len(listed.Msg.GetCharges()))
	}
}

// SRS-BIL-002: the most specific tariff prices the charge, and the charge says
// which contract did it.
func TestAnInsurersTariffPricesTheirPatientAndSaysSo(t *testing.T) {
	h := newBilHarness(t)
	_, encounter, _ := h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, from)
	h.publishTariff(t, "INS-A", "PROC-APP",
		&billingv1.TariffScope{PayerId: "insurer-a"}, 8000000, from)

	// The account was opened without a payer, so it prices at the list.
	selfPaying := h.postCharge(t, h.accountFor(t, encounter), "PROC-APP",
		"ord-self", 1, time.Now().UTC())
	if got := selfPaying.GetCharge().GetPricing().GetContractId(); got != "STD" {
		t.Fatalf("a self-paying patient priced against %q, want the standard list", got)
	}
	if got := selfPaying.GetCharge().GetUnitPrice().GetMinor(); got != 10000000 {
		t.Fatalf("price = %d", got)
	}

	// A second patient, this one insured.
	_, insuredEncounter, _ := h.chartWithPayer(t, "Nair", "9876543211", "insurer-a")
	insured := h.postCharge(t, h.accountFor(t, insuredEncounter), "PROC-APP",
		"ord-ins", 1, time.Now().UTC())
	if got := insured.GetCharge().GetPricing().GetContractId(); got != "INS-A" {
		t.Fatalf("an insured patient priced against %q, want the insurer contract", got)
	}
	if got := insured.GetCharge().GetUnitPrice().GetMinor(); got != 8000000 {
		t.Fatalf("price = %d", got)
	}
}

func (h *bilHarness) accountFor(t *testing.T, encounter string) string {
	t.Helper()
	got, err := h.billing.GetAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.GetAccountRequest{
			EncounterId: encounter,
		}))
	if err != nil {
		t.Fatalf("GetAccount: %v", err)
	}
	return got.Msg.GetAccount().GetAccountId()
}

func (h *bilHarness) chartWithPayer(t *testing.T, family, phone, payer string) (
	string, string, string) {

	t.Helper()
	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Asha"},
				date(1980, 2, 3), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "elective surgery",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	encounter := opened.Msg.GetEncounter().GetEncounterId()

	account, err := h.billing.OpenAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.OpenAccountRequest{
			EncounterId: encounter, PatientId: patient,
			Currency: "INR", PayerId: payer,
		}))
	if err != nil {
		t.Fatalf("OpenAccount: %v", err)
	}
	return patient, encounter, account.Msg.GetAccount().GetAccountId()
}

// A service no tariff prices is refused at the moment it can still be fixed,
// rather than charged at zero.
func TestAServiceNoTariffPricesIsRefusedRatherThanChargedAtZero(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-RARE", "An unpriced procedure", 1800, from)
	// No tariff published.

	_, err := h.billing.PostCharge(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.PostChargeRequest{
			AccountId: account, ServiceCode: "PROC-RARE", Quantity: 1,
			Origin: billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT,
			Source: &billingv1.SourceReference{System: "orders", Id: "ord-rare"},
		}))
	if err == nil {
		t.Fatal("an unpriced service was charged")
	}
	if !strings.Contains(err.Error(), "tariff") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// stock publishes a master and a tariff and raises one charge.
func (h *bilHarness) stock(t *testing.T, account string, minor int64) string {
	t.Helper()
	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, minor, from)
	return h.postCharge(t, account, "PROC-APP", uuid.NewString(), 1,
		time.Now().UTC()).GetCharge().GetChargeId()
}

func (h *bilHarness) raise(t *testing.T, account string,
	req *billingv1.RaiseInvoiceRequest) *billingv1.Invoice {

	t.Helper()
	req.AccountId = account
	raised, err := h.billing.RaiseInvoice(context.Background(),
		withFacility(h.billerToken(), h.facility, req))
	if err != nil {
		t.Fatalf("RaiseInvoice: %v", err)
	}
	return raised.Msg.GetInvoice()
}

// SRS-BIL-006: the invoice carries its own arithmetic and a numbered identity.
func TestAnInvoiceCarriesItsOwnArithmeticAndANumber(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	invoice := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	if invoice.GetNumber() == "" {
		t.Fatal("the invoice has no number")
	}
	if invoice.GetStatus() != billingv1.InvoiceStatus_INVOICE_STATUS_ISSUED {
		t.Fatalf("status = %v", invoice.GetStatus())
	}
	if len(invoice.GetLines()) != 1 {
		t.Fatalf("%d lines", len(invoice.GetLines()))
	}
	// 100,000.00 plus 18% is 118,000.00, exactly.
	if got := invoice.GetSubtotal().GetMinor(); got != 10000000 {
		t.Fatalf("subtotal = %d", got)
	}
	if got := invoice.GetTax().GetMinor(); got != 1800000 {
		t.Fatalf("tax = %d", got)
	}
	if got := invoice.GetTotal().GetMinor(); got != 11800000 {
		t.Fatalf("total = %d", got)
	}
}

// SRS-BIL-006: a charge that reached an invoice leaves the unbilled worklist.
func TestIssuingAnInvoiceMarksItsChargesInvoiced(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	listed, err := h.billing.ListCharges(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.ListChargesRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("ListCharges: %v", err)
	}
	for _, charge := range listed.Msg.GetCharges() {
		if charge.GetStatus() != billingv1.ChargeStatus_CHARGE_STATUS_INVOICED {
			t.Fatalf("charge %s is %v after the invoice was issued",
				charge.GetChargeId(), charge.GetStatus())
		}
		if charge.GetInvoiceId() == "" {
			t.Fatal("an invoiced charge does not name its invoice")
		}
	}
}

// SRS-BIL-010: a finalised invoice is corrected by a credit note that
// references it, not edited.
func TestAFinalisedInvoiceIsCorrectedByACreditNote(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	invoice := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	corrected, err := h.billing.CorrectInvoice(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CorrectInvoiceRequest{
			InvoiceId: invoice.GetInvoiceId(),
			Kind:      billingv1.DocumentKind_DOCUMENT_KIND_CREDIT_NOTE,
			Lines: []*billingv1.InvoiceLine{{
				Description: "Appendicectomy charged in error",
				Quantity:    1, UnitPrice: inrProto(10000000),
				Net: inrProto(10000000), Tax: inrProto(1800000),
				Total: inrProto(11800000),
			}},
			Reason: "the procedure was cancelled before it was performed",
		}))
	if err != nil {
		t.Fatalf("CorrectInvoice: %v", err)
	}
	note := corrected.Msg.GetNote()

	if note.GetCorrectsInvoiceId() != invoice.GetInvoiceId() {
		t.Fatal("the credit note does not name the invoice it corrects")
	}
	if note.GetNumber() == invoice.GetNumber() {
		t.Fatal("the credit note reused the invoice's number")
	}

	// The original still says what it said.
	original, err := h.billing.GetInvoice(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.GetInvoiceRequest{
			InvoiceId: invoice.GetInvoiceId(),
		}))
	if err != nil {
		t.Fatalf("GetInvoice: %v", err)
	}
	if original.Msg.GetInvoice().GetTotal().GetMinor() != 11800000 {
		t.Fatal("correcting changed the original invoice")
	}

	// And the credit note cleared the balance.
	statement, err := h.billing.Statement(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.StatementRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("Statement: %v", err)
	}
	if got := statement.Msg.GetBalance().GetMinor(); got != 0 {
		t.Fatalf("balance = %d after a full credit note, want zero", got)
	}
}

// SRS-BIL-008 and SRS-BIL-012: money received reduces the balance, exactly.
func TestAPaymentReducesTheBalanceExactly(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	paid, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(5000000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
			ProviderRef: "auth-11", IdempotencyKey: "pay-1",
		}))
	if err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}
	if paid.Msg.GetEntry().GetReceiptNumber() == "" {
		t.Fatal("the payment has no receipt number")
	}
	if got := paid.Msg.GetBalance().GetMinor(); got != 6800000 {
		t.Fatalf("balance = %d, want 118,000.00 less 50,000.00", got)
	}

	// And the rest.
	rest, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(6800000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_UPI,
			ProviderRef: "upi-22", IdempotencyKey: "pay-2",
		}))
	if err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}
	if got := rest.Msg.GetBalance().GetMinor(); got != 0 {
		t.Fatalf("balance = %d after paying in full, want exactly zero", got)
	}
}

// SRS-BIL-008: a retried submission takes the money once.
func TestARetriedPaymentTakesTheMoneyOnce(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	pay := func() *billingv1.ReceivePaymentResponse {
		t.Helper()
		got, err := h.billing.ReceivePayment(context.Background(),
			withFacility(h.cashierToken(), h.facility,
				&billingv1.ReceivePaymentRequest{
					AccountId: account, Amount: inrProto(5000000),
					Method:      billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
					ProviderRef: "auth-11", IdempotencyKey: "pay-same",
				}))
		if err != nil {
			t.Fatalf("ReceivePayment: %v", err)
		}
		return got.Msg
	}

	first := pay()
	if first.GetAlreadyReceived() {
		t.Fatal("the first submission reported itself as a retry")
	}
	second := pay()
	if !second.GetAlreadyReceived() {
		t.Fatal("a retried submission was not recognised")
	}
	if second.GetEntry().GetEntryId() != first.GetEntry().GetEntryId() {
		t.Fatal("the retry created a second payment")
	}
	if got := second.GetBalance().GetMinor(); got != 6800000 {
		t.Fatalf("balance = %d, want the money taken once", got)
	}
}

// SRS-BIL-009: a refund references the original, is bounded by it, and the
// original stays.
func TestARefundReferencesTheOriginalAndCannotExceedIt(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	paid, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(5000000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
			ProviderRef: "auth-11", IdempotencyKey: "pay-1",
		}))
	if err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}
	paymentID := paid.Msg.GetEntry().GetEntryId()

	// A cashier cannot refund at all.
	if _, err := h.billing.Refund(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.RefundRequest{
			AccountId: account, PaymentId: paymentID,
			Amount: inrProto(1000000), Reason: "overpaid",
		})); err == nil {
		t.Fatal("a cashier refunded money on their own authority")
	}

	// More than was taken is refused.
	if _, err := h.billing.Refund(context.Background(),
		withFacility(h.financeToken(), h.facility, &billingv1.RefundRequest{
			AccountId: account, PaymentId: paymentID,
			Amount: inrProto(9000000), Reason: "overpaid",
		})); err == nil {
		t.Fatal("more was refunded than was ever received")
	}

	refunded, err := h.billing.Refund(context.Background(),
		withFacility(h.financeToken(), h.facility, &billingv1.RefundRequest{
			AccountId: account, PaymentId: paymentID,
			Amount: inrProto(1000000), Reason: "overpaid at the desk",
		}))
	if err != nil {
		t.Fatalf("Refund: %v", err)
	}
	if refunded.Msg.GetEntry().GetRefundOfPaymentId() != paymentID {
		t.Fatal("the refund does not name the payment it reverses")
	}
	if refunded.Msg.GetEntry().GetApprovedBy() == "" {
		t.Fatal("the refund carries no authorisation")
	}

	// The original payment is still there, unchanged.
	statement, err := h.billing.Statement(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.StatementRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("Statement: %v", err)
	}
	var sawPayment, sawRefund bool
	for _, entry := range statement.Msg.GetEntries() {
		switch entry.GetKind() {
		case billingv1.EntryKind_ENTRY_KIND_PAYMENT:
			sawPayment = true
			if entry.GetAmount().GetMinor() != -5000000 {
				t.Fatalf("the original payment reads %d", entry.GetAmount().GetMinor())
			}
		case billingv1.EntryKind_ENTRY_KIND_REFUND:
			sawRefund = true
		}
	}
	if !sawPayment || !sawRefund {
		t.Fatal("the ledger does not carry both the payment and the refund")
	}
	if got := statement.Msg.GetBalance().GetMinor(); got != 7800000 {
		t.Fatalf("balance = %d, want the refund added back", got)
	}
}

// SRS-BIL-012: deposits are reported apart from the balance.
func TestADepositIsReportedApartFromTheBalance(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(5000000),
			Method:  billingv1.PaymentMethod_PAYMENT_METHOD_CASH,
			Deposit: true, IdempotencyKey: "dep-1",
			Reason: "admission advance",
		})); err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}

	statement, err := h.billing.Statement(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.StatementRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("Statement: %v", err)
	}
	if got := statement.Msg.GetDeposits().GetMinor(); got != 5000000 {
		t.Fatalf("deposits = %d, want 50,000.00 held", got)
	}
	if got := statement.Msg.GetBalance().GetMinor(); got != -5000000 {
		t.Fatalf("balance = %d, want the advance in credit", got)
	}
}

// SRS-BIL-013: the close lists every blocking exception, and a settled account
// closes.
func TestClosingAnAccountListsEverythingInTheWay(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	chargeID := h.stock(t, account, 10000000)

	// Uninvoiced, so the close is blocked.
	readiness, err := h.billing.CloseReadiness(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CloseReadinessRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("CloseReadiness: %v", err)
	}
	if len(readiness.Msg.GetExceptions()) == 0 {
		t.Fatal("an account with an uninvoiced charge reported nothing in the way")
	}
	var named bool
	for _, exception := range readiness.Msg.GetExceptions() {
		for _, ref := range exception.GetReferences() {
			if ref == chargeID {
				named = true
			}
		}
	}
	if !named {
		t.Fatalf("no exception links to the uninvoiced charge: %+v",
			readiness.Msg.GetExceptions())
	}

	_, err = h.billing.CloseAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CloseAccountRequest{
			AccountId: account,
		}))
	if err == nil {
		t.Fatal("an account with an uninvoiced charge closed")
	}

	detail := errorDetail(t, err)
	if detail == nil || len(detail.GetFieldViolations()) == 0 {
		t.Fatalf("the refusal does not list the exceptions: %v", err)
	}

	// Invoice and settle it, and the account closes.
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})
	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(11800000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_UPI,
			ProviderRef: "upi-1", IdempotencyKey: "pay-full",
		})); err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}

	closed, err := h.billing.CloseAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CloseAccountRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("CloseAccount: %v", err)
	}
	if closed.Msg.GetAccount().GetStatus() !=
		billingv1.AccountStatus_ACCOUNT_STATUS_CLOSED {
		t.Fatalf("status = %v", closed.Msg.GetAccount().GetStatus())
	}
}

// A closed account takes no more charges: a correction goes on a note.
func TestAClosedAccountTakesNoMoreCharges(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	// Nothing on it, so it closes clean.
	if _, err := h.billing.CloseAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CloseAccountRequest{
			AccountId: account,
		})); err != nil {
		t.Fatalf("CloseAccount: %v", err)
	}

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, from)

	_, err := h.billing.PostCharge(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.PostChargeRequest{
			AccountId: account, ServiceCode: "PROC-APP", Quantity: 1,
			Origin: billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT,
			Source: &billingv1.SourceReference{System: "orders", Id: "late-1"},
		}))
	if err == nil {
		t.Fatal("a charge was raised against a closed account")
	}
	if !strings.Contains(err.Error(), "credit or debit note") {
		t.Fatalf("the refusal does not name the corrective workflow: %v", err)
	}
}

// SRS-BIL-004: the package ledger explains what was billed and what was not.
func TestThePackageLedgerExplainsBilledAndNotBilledItems(t *testing.T) {
	h := newBilHarness(t)
	h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	for _, item := range [][2]string{
		{"BED-GEN", "General ward bed day"},
		{"CONS-OB", "Obstetric consultation"},
		{"NICU-DAY", "Neonatal intensive care day"},
	} {
		h.publishService(t, item[0], item[1], 1800, from)
		h.publishTariff(t, "STD", item[0], nil, 500000, from)
	}

	if _, err := h.billing.PublishPackage(context.Background(),
		as(h.financeToken(), &billingv1.PublishPackageRequest{
			Package: &billingv1.Package{
				Code: "MAT-NORMAL", Name: "Normal delivery package",
				Price: inrProto(4500000),
				Inclusions: []*billingv1.PackageInclusion{
					{ServiceCode: "BED-GEN", Quantity: 2},
					{ServiceCode: "CONS-OB"},
				},
				Exclusions:    []string{"NICU-DAY"},
				EffectiveFrom: timestamppb.New(from),
			},
		})); err != nil {
		t.Fatalf("PublishPackage: %v", err)
	}

	// A second patient, admitted on the package.
	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Rao", []string{"Latha"},
				date(1992, 7, 4), empiv1.Sex_SEX_FEMALE, "9876543299"),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId:           registered.Msg.GetPatient().GetPatientId(),
				FacilityId:          h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "delivery",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	packaged, err := h.billing.OpenAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.OpenAccountRequest{
			EncounterId: opened.Msg.GetEncounter().GetEncounterId(),
			Currency:    "INR", PackageCode: "MAT-NORMAL",
		}))
	if err != nil {
		t.Fatalf("OpenAccount: %v", err)
	}
	account := packaged.Msg.GetAccount().GetAccountId()

	now := time.Now().UTC()
	h.postCharge(t, account, "BED-GEN", "bed-1", 1, now)
	h.postCharge(t, account, "BED-GEN", "bed-2", 1, now)
	// The third bed day is over the cap of two.
	third := h.postCharge(t, account, "BED-GEN", "bed-3", 1, now)
	h.postCharge(t, account, "CONS-OB", "cons-1", 1, now)
	excluded := h.postCharge(t, account, "NICU-DAY", "nicu-1", 1, now)

	if third.GetCharge().GetCovered() {
		t.Fatal("the third bed day was absorbed despite a cap of two")
	}
	if excluded.GetCharge().GetCovered() {
		t.Fatal("an excluded service was absorbed")
	}

	ledger, err := h.billing.PackageLedger(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.PackageLedgerRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("PackageLedger: %v", err)
	}
	if len(ledger.Msg.GetEntries()) != 5 {
		t.Fatalf("%d ledger entries, want one per charge",
			len(ledger.Msg.GetEntries()))
	}

	byOutcome := map[billingv1.CoverageOutcome]int{}
	for _, entry := range ledger.Msg.GetEntries() {
		byOutcome[entry.GetOutcome()]++
		if entry.GetExplanation() == "" {
			t.Fatalf("entry for charge %s has no explanation", entry.GetChargeId())
		}
	}
	if byOutcome[billingv1.CoverageOutcome_COVERAGE_OUTCOME_INCLUDED] != 3 {
		t.Fatalf("%d included, want two bed days and the consultation", byOutcome)
	}
	if byOutcome[billingv1.CoverageOutcome_COVERAGE_OUTCOME_OVER_CAP] != 1 {
		t.Fatalf("the over-cap bed day is not explained as such: %v", byOutcome)
	}
	if byOutcome[billingv1.CoverageOutcome_COVERAGE_OUTCOME_EXCLUDED] != 1 {
		t.Fatalf("the exclusion is not explained as such: %v", byOutcome)
	}

	// And the bill carries only what the package did not absorb.
	invoice := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})
	if len(invoice.GetLines()) != 2 {
		t.Fatalf("%d lines on the bill, want the over-cap bed day and the exclusion",
			len(invoice.GetLines()))
	}
}

// SRS-BIL-007: a concession beyond a role's limit needs an approval.
func TestAConcessionBeyondTheLimitNeedsAnApproval(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	// A clerk may give up to 10%.
	if _, err := h.billing.SetBillingPolicy(context.Background(),
		as(h.financeToken(), &billingv1.SetBillingPolicyRequest{
			Policy: &billingv1.BillingPolicy{
				DiscountLimits: map[string]*billingv1.DiscountLimit{
					"billing_clerk": {MaxRateBp: 1000},
				},
				AllowPayerBalance:      true,
				VarianceThresholdMinor: 100,
				Currency:               "INR",
			},
		})); err != nil {
		t.Fatalf("SetBillingPolicy: %v", err)
	}

	// 5% is within.
	within := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
		Discount: &billingv1.Discount{
			RateBp: 500, Reason: "long-stay goodwill",
		},
		Issue: true,
	})
	if got := within.GetDiscount().GetMinor(); got != 500000 {
		t.Fatalf("discount = %d, want 5%% of 100,000.00", got)
	}
	if len(within.GetDiscounts()) != 1 ||
		within.GetDiscounts()[0].GetAppliedBy() != "biller-1" {
		t.Fatalf("the discount does not name who applied it: %+v", within.GetDiscounts())
	}

	// 40% is not, and is refused without an approval.
	h.stock(t, account, 10000000)
	_, err := h.billing.RaiseInvoice(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.RaiseInvoiceRequest{
			AccountId: account,
			Kind:      billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
			Discount: &billingv1.Discount{
				RateBp: 4000, Reason: "hardship",
			},
			Issue: true,
		}))
	if err == nil {
		t.Fatal("a 40% concession went through on a 10% limit with no approval")
	}
	if !strings.Contains(err.Error(), "approval") {
		t.Fatalf("the refusal does not say what is needed: %v", err)
	}
}

// SRS-BIL-014: the split names a responsible party and a basis, and must add up.
func TestASplitLiabilityNamesEveryPartyAndAddsUp(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	// A split short of the total is refused.
	_, err := h.billing.RaiseInvoice(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.RaiseInvoiceRequest{
			AccountId: account, Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
			Liability: []*billingv1.LiabilityShare{{
				Party:   billingv1.LiabilityParty_LIABILITY_PARTY_PAYER,
				PartyId: "insurer-a", Amount: inrProto(1000000),
				Basis: "policy covers 90%", AdjudicationRef: "ADJ-1",
			}},
			Issue: true,
		}))
	if err == nil {
		t.Fatal("a split short of the total was accepted")
	}

	invoice := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
		Liability: []*billingv1.LiabilityShare{
			{
				Party:   billingv1.LiabilityParty_LIABILITY_PARTY_PAYER,
				PartyId: "insurer-a", Amount: inrProto(10620000),
				Basis: "policy covers 90%", AdjudicationRef: "ADJ-2026-114",
			},
			{
				Party:  billingv1.LiabilityParty_LIABILITY_PARTY_PATIENT,
				Amount: inrProto(1180000),
				Basis:  "10% co-payment per scheme rules",
			},
		},
		Issue: true,
	})

	if len(invoice.GetLiability()) != 2 {
		t.Fatalf("%d shares", len(invoice.GetLiability()))
	}
	for _, share := range invoice.GetLiability() {
		if share.GetBasis() == "" {
			t.Fatalf("share %v has no stated basis", share.GetParty())
		}
	}
}

// SRS-BIL-013 and SRS-BIL-014: an insurer's outstanding share does not keep a
// discharged patient's account open.
func TestAPayerBalanceDoesNotKeepTheAccountOpen(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL,
		Liability: []*billingv1.LiabilityShare{
			{
				Party:   billingv1.LiabilityParty_LIABILITY_PARTY_PAYER,
				PartyId: "insurer-a", Amount: inrProto(10620000),
				Basis: "policy covers 90%",
			},
			{
				Party:  billingv1.LiabilityParty_LIABILITY_PARTY_PATIENT,
				Amount: inrProto(1180000), Basis: "10% co-payment",
			},
		},
		Issue: true,
	})

	// The patient pays their share; the insurer has ninety days.
	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(1180000),
			Method:         billingv1.PaymentMethod_PAYMENT_METHOD_CASH,
			IdempotencyKey: "copay-1",
		})); err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}

	closed, err := h.billing.CloseAccount(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.CloseAccountRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("the account did not close with only the insurer outstanding: %v", err)
	}
	if closed.Msg.GetAccount().GetStatus() !=
		billingv1.AccountStatus_ACCOUNT_STATUS_CLOSED {
		t.Fatalf("status = %v", closed.Msg.GetAccount().GetStatus())
	}
}

// SRS-BIL-015: the drawer reconciles against the ledger, and a variance beyond
// the threshold needs a supervisor who is not the cashier.
func TestAShiftReconcilesAgainstTheLedgerAndEscalatesAVariance(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	opened, err := h.billing.OpenShift(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.OpenShiftRequest{
			FacilityId: h.facility, CounterId: "counter-1",
			OpeningFloat: inrProto(200000),
		}))
	if err != nil {
		t.Fatalf("OpenShift: %v", err)
	}
	shift := opened.Msg.GetShift().GetShiftId()

	// Cash into the drawer, and a card payment that does not go into it.
	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(500000),
			Method:  billingv1.PaymentMethod_PAYMENT_METHOD_CASH,
			ShiftId: shift, IdempotencyKey: "cash-1",
		})); err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}
	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(1000000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
			ProviderRef: "auth-9", ShiftId: shift, IdempotencyKey: "card-1",
		})); err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}

	// Count short by 500.00.
	closed, err := h.billing.CloseShift(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.CloseShiftRequest{
			ShiftId: shift, Counted: inrProto(650000),
			Reason: "a note is missing from the drawer",
		}))
	if err != nil {
		t.Fatalf("CloseShift: %v", err)
	}
	got := closed.Msg.GetShift()

	// The float plus the cash payment, and not the card payment.
	if got.GetExpectedCash().GetMinor() != 700000 {
		t.Fatalf("expected cash = %d, want the float plus the cash payment only",
			got.GetExpectedCash().GetMinor())
	}
	if got.GetVariance().GetMinor() != -50000 {
		t.Fatalf("variance = %d", got.GetVariance().GetMinor())
	}
	if got.GetStatus() != billingv1.ShiftStatus_SHIFT_STATUS_PENDING_APPROVAL {
		t.Fatalf("status = %v, want pending approval", got.GetStatus())
	}

	// The cashier cannot sign it off.
	if _, err := h.billing.ApproveShift(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ApproveShiftRequest{
			ShiftId: shift,
		})); err == nil {
		t.Fatal("a cashier approved their own variance")
	}

	approved, err := h.billing.ApproveShift(context.Background(),
		withFacility(h.financeToken(), h.facility, &billingv1.ApproveShiftRequest{
			ShiftId: shift,
		}))
	if err != nil {
		t.Fatalf("ApproveShift: %v", err)
	}
	if approved.Msg.GetShift().GetStatus() !=
		billingv1.ShiftStatus_SHIFT_STATUS_RECONCILED {
		t.Fatalf("status = %v after approval", approved.Msg.GetShift().GetStatus())
	}
	if approved.Msg.GetShift().GetApprovedBy() != "finance-1" {
		t.Fatalf("approved by %q", approved.Msg.GetShift().GetApprovedBy())
	}
}

// One drawer, one open shift. Two cashiers at one counter is how a variance
// becomes unattributable.
func TestTwoCashiersCannotShareOneCounter(t *testing.T) {
	h := newBilHarness(t)

	if _, err := h.billing.OpenShift(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.OpenShiftRequest{
			FacilityId: h.facility, CounterId: "counter-1",
			OpeningFloat: inrProto(200000),
		})); err != nil {
		t.Fatalf("OpenShift: %v", err)
	}

	if _, err := h.billing.OpenShift(context.Background(),
		withFacility(h.otherCashierToken(), h.facility,
			&billingv1.OpenShiftRequest{
				FacilityId: h.facility, CounterId: "counter-1",
				OpeningFloat: inrProto(200000),
			})); err == nil {
		t.Fatal("a second cashier opened a shift at an occupied counter")
	}
}

// SRS-BIL-011: what has not reached a bill is on the worklist, oldest first,
// and links back to the source record.
func TestTheRevenueWorklistLinksBackToTheSourceRecord(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, from)

	posted := h.postCharge(t, account, "PROC-APP", "ord-99", 1, time.Now().UTC())
	if _, err := h.billing.HoldCharge(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.HoldChargeRequest{
			Change: &billingv1.ChangeChargeRequest{
				ChargeId: posted.GetCharge().GetChargeId(),
				Reason:   "awaiting a coding query",
			},
		})); err != nil {
		t.Fatalf("HoldCharge: %v", err)
	}

	worklist, err := h.billing.RevenueIntegrity(context.Background(),
		withFacility(h.billerToken(), h.facility,
			&billingv1.RevenueIntegrityRequest{
				FacilityId: h.facility,
				Events: []*billingv1.BillableEvent{{
					Source: &billingv1.SourceReference{
						System: "orders", Id: "ord-never", Detail: "ORD-ord-never",
					},
					ServiceCode: "PROC-APP", AccountId: account,
					OccurredAt: timestamppb.New(from),
				}},
			}))
	if err != nil {
		t.Fatalf("RevenueIntegrity: %v", err)
	}

	byKind := map[billingv1.ExceptionKind]*billingv1.RevenueException{}
	for _, exception := range worklist.Msg.GetExceptions() {
		byKind[exception.GetKind()] = exception
	}

	held := byKind[billingv1.ExceptionKind_EXCEPTION_KIND_HELD_CHARGE]
	if held == nil {
		t.Fatalf("the held charge is not on the worklist: %+v",
			worklist.Msg.GetExceptions())
	}
	if held.GetSource().GetDetail() != "ORD-ord-99" {
		t.Fatalf("the held exception does not link to the source: %+v", held.GetSource())
	}

	unbilled := byKind[billingv1.ExceptionKind_EXCEPTION_KIND_UNBILLED_SERVICE]
	if unbilled == nil {
		t.Fatal("a completed service with no charge is not on the worklist")
	}
	if unbilled.GetSource().GetId() != "ord-never" {
		t.Fatalf("the wrong service is reported unbilled: %+v", unbilled.GetSource())
	}
	// Oldest first: the unbilled service is a month old, the held charge is
	// minutes old.
	if worklist.Msg.GetExceptions()[0].GetKind() !=
		billingv1.ExceptionKind_EXCEPTION_KIND_UNBILLED_SERVICE {
		t.Fatalf("the worklist is not oldest first: %+v", worklist.Msg.GetExceptions())
	}
}

// SRS-BIL-016: the events reference financial objects and expose no payment
// secrets.
func TestTheBillingEventsCarryNoPaymentSecrets(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)
	h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_FINAL, Issue: true,
	})

	paid, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(5000000),
			Method:      billingv1.PaymentMethod_PAYMENT_METHOD_CARD,
			ProviderRef: "gw-auth-4417", IdempotencyKey: "pay-1",
		}))
	if err != nil {
		t.Fatalf("ReceivePayment: %v", err)
	}
	if _, err := h.billing.Refund(context.Background(),
		withFacility(h.financeToken(), h.facility, &billingv1.RefundRequest{
			AccountId: account, PaymentId: paid.Msg.GetEntry().GetEntryId(),
			Amount: inrProto(1000000), Reason: "overpaid",
		})); err != nil {
		t.Fatalf("Refund: %v", err)
	}

	rows, err := h.pool.Query(context.Background(),
		`SELECT event_type, payload::text FROM platform_data.outbox_event
		 WHERE tenant_id = $1
		   AND event_type IN ('charge.posted', 'invoice.finalized',
		                      'payment.received', 'refund.completed')
		 ORDER BY occurred_at, event_id`, h.tenantID)
	if err != nil {
		t.Fatalf("query outbox: %v", err)
	}
	defer rows.Close()

	seen := map[string]bool{}
	for rows.Next() {
		var eventType, payload string
		if err := rows.Scan(&eventType, &payload); err != nil {
			t.Fatalf("scan: %v", err)
		}
		seen[eventType] = true
		// The gateway reference is what a reconciliation needs and is not a
		// secret; a card number would be.
		for _, secret := range []string{"4111", "cvv", "card_number", "pan"} {
			if strings.Contains(strings.ToLower(payload), secret) {
				t.Fatalf("%s leaks %q: %s", eventType, secret, payload)
			}
		}
	}
	if err := rows.Err(); err != nil {
		t.Fatalf("rows: %v", err)
	}

	for _, want := range []string{
		"charge.posted", "invoice.finalized", "payment.received", "refund.completed",
	} {
		if !seen[want] {
			t.Errorf("%s was never emitted", want)
		}
	}
}

// A cashier cannot raise a charge, and a biller cannot take money. The oldest
// control in finance, held as two permissions.
func TestTheOneWhoDecidesWhatIsOwedDoesNotCollectIt(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	from := time.Now().UTC().AddDate(0, -1, 0)
	h.publishService(t, "PROC-APP", "Appendicectomy", 1800, from)
	h.publishTariff(t, "STD", "PROC-APP", nil, 10000000, from)

	if _, err := h.billing.PostCharge(context.Background(),
		withFacility(h.cashierToken(), h.facility, &billingv1.PostChargeRequest{
			AccountId: account, ServiceCode: "PROC-APP", Quantity: 1,
			Origin: billingv1.ChargeOrigin_CHARGE_ORIGIN_CLINICAL_EVENT,
			Source: &billingv1.SourceReference{System: "orders", Id: "ord-x"},
		})); err == nil {
		t.Fatal("a cashier raised a charge")
	}

	if _, err := h.billing.ReceivePayment(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.ReceivePaymentRequest{
			AccountId: account, Amount: inrProto(100000),
			Method:         billingv1.PaymentMethod_PAYMENT_METHOD_CASH,
			IdempotencyKey: "pay-x",
		})); err == nil {
		t.Fatal("a billing clerk took money")
	}

	if _, err := h.billing.PublishService(context.Background(),
		as(h.billerToken(), &billingv1.PublishServiceRequest{
			Item: &billingv1.ServiceItem{
				Code: "PROC-NEW", Description: "x", Department: "y",
				RevenueAccount: "z",
				EffectiveFrom:  timestamppb.New(from),
			},
		})); err == nil {
		t.Fatal("a billing clerk edited the charge master")
	}
}

// An account cannot be reached from another tenant.
func TestAnAccountCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")

	other, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	otherTenant := other.Msg.GetTenant().GetTenantId()

	if _, err := h.billing.GetAccount(context.Background(),
		as(otherTenant+":biller-9:billing_clerk", &billingv1.GetAccountRequest{
			AccountId: account,
		})); err == nil {
		t.Fatal("an account was readable from another tenant")
	}
}

// SRS-BIL-005: an estimate is a quote and creates no balance.
func TestAnEstimateCreatesNoBalanceOverTheWire(t *testing.T) {
	h := newBilHarness(t)
	_, _, account := h.chart(t, "Iyer", "9876543210")
	h.stock(t, account, 10000000)

	estimate := h.raise(t, account, &billingv1.RaiseInvoiceRequest{
		Kind: billingv1.DocumentKind_DOCUMENT_KIND_ESTIMATE, Issue: true,
	})
	if estimate.GetKind() != billingv1.DocumentKind_DOCUMENT_KIND_ESTIMATE {
		t.Fatalf("kind = %v", estimate.GetKind())
	}
	if estimate.GetTotal().GetMinor() != 11800000 {
		t.Fatalf("the estimate does not quote a total: %d",
			estimate.GetTotal().GetMinor())
	}

	statement, err := h.billing.Statement(context.Background(),
		withFacility(h.billerToken(), h.facility, &billingv1.StatementRequest{
			AccountId: account,
		}))
	if err != nil {
		t.Fatalf("Statement: %v", err)
	}
	if got := statement.Msg.GetBalance().GetMinor(); got != 0 {
		t.Fatalf("balance = %d after an estimate, want zero", got)
	}
}
