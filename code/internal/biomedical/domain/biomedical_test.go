package domain_test

import (
	"errors"
	"strconv"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
)

// The biomedical engineering rules (SRS-BIO-001 … 011).
//
// The ones worth asserting directly are the refusals and the arithmetic: that
// a disposed asset is a state the record cannot leave, that a room's
// capabilities are the assets working in it rather than the ones standing in
// it, that an SLA comes from the contract the hospital actually bought, that a
// repair is validated by somebody other than the engineer who made it, and
// that the reliability figures reconcile to the service events they are
// derived from.

var at = time.Date(2026, 9, 19, 9, 0, 0, 0, time.UTC)

func mustAsset(t *testing.T, in domain.NewAssetInput) domain.Asset {
	t.Helper()
	asset, err := domain.NewAsset("asset-"+in.Tag, "tenant-1", in, "bme-1", at)
	if err != nil {
		t.Fatalf("NewAsset(%s): %v", in.Tag, err)
	}
	return asset
}

func intensifier(t *testing.T) domain.Asset {
	return mustAsset(t, domain.NewAssetInput{
		Tag: "BME-001", Make: "Siemens", Model: "Cios Alpha",
		Category: "imaging", Criticality: domain.CriticalityCritical,
		LocationID: "theatre-2", Capabilities: []string{"image_intensifier"},
	})
}

// SRS-BIO-011. Disposal is a state the record cannot leave, which is what
// "disposed asset cannot be assigned for use" means when it is a property
// rather than a check somebody has to remember.
func TestADisposedAssetIsUnreachableFromEverywhere(t *testing.T) {
	asset := intensifier(t)

	disposal, disposed, err := domain.Dispose("disp-1", "tenant-1",
		domain.DisposalInput{
			AssetID: asset.ID, Method: "returned to manufacturer",
			Reason: "end of life", RequestedBy: "bme-1",
		}, asset, "bme-manager-1", at)
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if disposal.ApprovedBy != "bme-manager-1" {
		t.Errorf("approved by %q", disposal.ApprovedBy)
	}

	// It cannot be moved back into service.
	back := disposed
	if err := back.Move(domain.AssetInService, "", at.Add(time.Hour)); err == nil {
		t.Error("a disposed asset was moved back into service")
	}

	// No work can be raised against it.
	if _, err := domain.RaiseTicket("tkt-1", "tenant-1", domain.NewTicketInput{
		Symptom: "will not power on",
	}, disposed, domain.SLA{}, "nurse-1", at); err == nil {
		t.Error("a ticket was raised against a disposed asset")
	}

	// And it stops contributing capability to the room it stood in, the
	// moment it goes.
	working := domain.AvailableCapabilities(
		[]domain.Asset{disposed}, "theatre-2", at, false)
	if len(working) != 0 {
		t.Errorf("a disposed asset still offers %v to its old room", working)
	}

	// Disposing twice is refused.
	if _, _, err := domain.Dispose("disp-2", "tenant-1", domain.DisposalInput{
		AssetID: disposed.ID, Method: "skip", Reason: "again",
		RequestedBy: "bme-1",
	}, disposed, "bme-manager-1", at); err == nil {
		t.Error("an asset was disposed of twice")
	}
}

// SRS-BIO-011. A disposal is approved by somebody other than the requester,
// and sanitisation evidence is required where sanitisation is.
func TestADisposalNeedsAnIndependentApprovalAndItsEvidence(t *testing.T) {
	asset := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-050", Make: "GE", Model: "Carescape",
		Category: "monitoring", LocationID: "icu-1",
	})

	if _, _, err := domain.Dispose("disp-1", "tenant-1", domain.DisposalInput{
		Method: "recycler", Reason: "obsolete", RequestedBy: "bme-1",
	}, asset, "bme-1", at); err == nil {
		t.Error("the person who requested a disposal approved it")
	}

	// A monitor holds patient data, so the evidence is required.
	holding := domain.DisposalInput{
		Method: "recycler", Reason: "obsolete", RequestedBy: "bme-1",
		SanitisationRequired: true,
	}
	for _, missing := range []string{"method", "certificate", "who"} {
		in := holding
		in.SanitisationMethod = "NIST 800-88 purge"
		in.SanitisationCertificate = "CERT-991"
		in.SanitisedBy = "it-sec-1"
		switch missing {
		case "method":
			in.SanitisationMethod = ""
		case "certificate":
			in.SanitisationCertificate = ""
		case "who":
			in.SanitisedBy = ""
		}
		if _, _, err := domain.Dispose("disp-1", "tenant-1", in, asset,
			"bme-manager-1", at); err == nil {
			t.Errorf("a disposal was recorded with no sanitisation %s; the "+
				"machine is a hard drive in a skip", missing)
		}
	}

	complete := holding
	complete.SanitisationMethod = "NIST 800-88 purge"
	complete.SanitisationCertificate = "CERT-991"
	complete.SanitisedBy = "it-sec-1"
	if _, _, err := domain.Dispose("disp-1", "tenant-1", complete, asset,
		"bme-manager-1", at); err != nil {
		t.Fatalf("a complete disposal was refused: %v", err)
	}
}

// SRS-BIO-009. A room's capabilities are the assets working in it, not the
// ones standing in it. This is the whole of "unavailable equipment cannot be
// falsely shown as schedulable".
func TestARoomOffersOnlyTheCapabilitiesThatAreActuallyWorking(t *testing.T) {
	working := intensifier(t)

	broken := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-002", Make: "Stryker", Model: "Neptune",
		LocationID: "theatre-2", Capabilities: []string{"laminar_flow"},
	})
	if err := broken.Move(domain.AssetAwaitingParts, "fan motor failed",
		at); err != nil {
		t.Fatalf("Move: %v", err)
	}

	held := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-003", Make: "Olympus", Model: "CV-190",
		LocationID: "theatre-2", Capabilities: []string{"endoscopy_stack"},
	})
	if err := held.Hold("recall R-2026-11"); err != nil {
		t.Fatalf("Hold: %v", err)
	}

	lapsed := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-004", Make: "Drager", Model: "Primus",
		LocationID: "theatre-2", Capabilities: []string{"anaesthesia_machine"},
		CalibrationRequired: true, CalibrationDue: at.AddDate(0, 0, -1),
	})

	assets := []domain.Asset{working, broken, held, lapsed}

	// Without the calibration policy the anaesthesia machine still counts.
	permissive := domain.AvailableCapabilities(assets, "theatre-2", at, false)
	if permissive["image_intensifier"] != 1 ||
		permissive["anaesthesia_machine"] != 1 {
		t.Errorf("permissive capabilities = %v", permissive)
	}
	if permissive["laminar_flow"] != 0 || permissive["endoscopy_stack"] != 0 {
		t.Errorf("a broken or held asset was offered: %v", permissive)
	}

	// With it, the lapsed certificate takes the machine out too.
	strict := domain.AvailableCapabilities(assets, "theatre-2", at, true)
	if strict["anaesthesia_machine"] != 0 {
		t.Error("an uncalibrated machine was offered under a blocking policy")
	}

	unavailable := domain.UnavailableCapabilities(assets, "theatre-2", at, true)
	if len(unavailable) != 3 {
		t.Fatalf("unavailable = %v, want three", unavailable)
	}

	// Two of a kind: one going for service loses the room nothing.
	second := working
	second.ID, second.Tag = "asset-BME-005", "BME-005"
	pair := []domain.Asset{working, second}
	if err := working.Move(domain.AssetUnderMaintenance, "annual service",
		at); err != nil {
		t.Fatalf("Move: %v", err)
	}
	pair[0] = working
	if got := domain.AvailableCapabilities(pair, "theatre-2", at, false); got["image_intensifier"] != 1 {
		t.Errorf("a room with two intensifiers lost the capability when one "+
			"went for service: %v", got)
	}
	if left := domain.UnavailableCapabilities(pair, "theatre-2", at, false); len(left) != 0 {
		t.Errorf("unavailable = %v, want none; the spare covers it", left)
	}
}

// SRS-BIO-004, SRS-BIO-008, SRS-BIO-011. Every reason an asset cannot be used,
// not the first.
func TestUnusableNamesEveryReasonAtOnce(t *testing.T) {
	asset := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-010", Make: "Drager", Model: "Evita",
		Criticality: domain.CriticalityLifeSupport, LocationID: "icu-1",
		CalibrationRequired: true, CalibrationDue: at.AddDate(0, 0, -7),
	})
	if err := asset.Move(domain.AssetAwaitingParts, "expiry valve", at); err != nil {
		t.Fatalf("Move: %v", err)
	}
	if err := asset.Hold("field safety notice FSN-44"); err != nil {
		t.Fatalf("Hold: %v", err)
	}

	reasons := asset.Unusable(at, true)
	if len(reasons) != 3 {
		t.Fatalf("reasons = %v, want three; an engineer told one at a time "+
			"fixes the calibration and then finds the safety notice", reasons)
	}
	if asset.Usable(at, true) {
		t.Error("an asset with three problems reported itself usable")
	}
}

// SRS-BIO-001, SRS-BIO-004. An asset that needs calibrating and has no due
// date never comes due.
func TestCalibrationRequiresADateAndADateRequiresCalibration(t *testing.T) {
	_, err := domain.NewAsset("asset-x", "tenant-1", domain.NewAssetInput{
		Tag: "BME-020", Make: "Fluke", Model: "ProSim",
		CalibrationRequired: true,
	}, "bme-1", at)
	if !errors.Is(err, domain.ErrInvalidAsset) {
		t.Error("an asset requiring calibration was registered with no due " +
			"date; it would never come due")
	}

	_, err = domain.NewAsset("asset-y", "tenant-1", domain.NewAssetInput{
		Tag: "BME-021", Make: "Fluke", Model: "ProSim",
		CalibrationDue: at.AddDate(1, 0, 0),
	}, "bme-1", at)
	if !errors.Is(err, domain.ErrInvalidAsset) {
		t.Error("a calibration date was set on an asset nobody calibrates; " +
			"the reminder would be dismissed every month")
	}

	asset := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-022", Make: "Fluke", Model: "ProSim",
		CalibrationRequired: true, CalibrationDue: at.AddDate(0, 0, -1),
	})
	if !asset.CalibrationExpired(at) {
		t.Fatal("a lapsed certificate did not read as expired")
	}

	// A calibration dated in the past would expire the moment it was
	// recorded.
	if err := asset.Calibrate("CERT-1", at.AddDate(0, 0, -1), at); err == nil {
		t.Error("a calibration was recorded as already due")
	}
	if err := asset.Calibrate("", at.AddDate(1, 0, 0), at); err == nil {
		t.Error("a calibration was recorded with no certificate")
	}
	if err := asset.Calibrate("CERT-2", at.AddDate(1, 0, 0), at); err != nil {
		t.Fatalf("Calibrate: %v", err)
	}
	if asset.CalibrationExpired(at) {
		t.Error("a freshly calibrated asset still reads as expired")
	}
}

func contract(t *testing.T, kind domain.ContractKind, assetID string,
	response, resolution int, ends time.Time) domain.ServiceContract {

	t.Helper()
	out, err := domain.NewServiceContract("con-"+string(kind), "tenant-1",
		domain.NewContractInput{
			AssetID: assetID, Kind: kind, Reference: "REF-" + string(kind),
			VendorName: "Vendor " + string(kind),
			StartsOn:   at.AddDate(-1, 0, 0), EndsOn: ends,
			ResponseHours: response, ResolutionHours: resolution,
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewServiceContract(%s): %v", kind, err)
	}
	return out
}

// SRS-BIO-002. The most protective live contract applies, because a hospital
// holding both a warranty and an AMC pays nothing under the warranty.
func TestTheMostProtectiveLiveContractApplies(t *testing.T) {
	asset := intensifier(t)

	amc := contract(t, domain.ContractAMC, asset.ID, 8, 48, at.AddDate(1, 0, 0))
	warranty := contract(t, domain.ContractWarranty, asset.ID, 24, 72,
		at.AddDate(0, 6, 0))
	lapsed := contract(t, domain.ContractCMC, asset.ID, 2, 8,
		at.AddDate(0, 0, -1))

	cover, found := domain.CoverFor(
		[]domain.ServiceContract{amc, warranty, lapsed}, asset.ID, at)
	if !found || cover.Kind != domain.ContractWarranty {
		t.Fatalf("cover = %+v, want the warranty", cover)
	}
	if !cover.Kind.CoversParts() {
		t.Error("a warranty was reported as not covering parts")
	}

	// Once the warranty lapses, the AMC applies.
	later := at.AddDate(0, 7, 0)
	cover, found = domain.CoverFor(
		[]domain.ServiceContract{amc, warranty, lapsed}, asset.ID, later)
	if !found || cover.Kind != domain.ContractAMC {
		t.Fatalf("cover after the warranty = %+v, want the AMC", cover)
	}
	if cover.Kind.CoversParts() {
		t.Error("an AMC was reported as covering parts; the hospital pays " +
			"for the board")
	}

	// A contract with no end date never expires and never reminds.
	if _, err := domain.NewServiceContract("con-x", "tenant-1",
		domain.NewContractInput{
			AssetID: asset.ID, Kind: domain.ContractAMC, VendorName: "Acme",
		}, "bme-1", at); err == nil {
		t.Error("a contract with no end date was recorded")
	}
}

// SRS-BIO-002, SRS-BIO-004. Expiry reminders are derived, and an asset that
// has left the hospital does not generate them.
func TestExpiriesAreDerivedAndSkipRetiredAssets(t *testing.T) {
	live := intensifier(t)
	live.CalibrationRequired, live.CalibrationDue = true, at.AddDate(0, 0, 20)

	gone := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-099", Make: "Old", Model: "Thing",
		CalibrationRequired: true, CalibrationDue: at.AddDate(0, 0, 5),
	})
	if err := gone.Move(domain.AssetDecommissioned, "condemned", at); err != nil {
		t.Fatalf("Move: %v", err)
	}

	contracts := []domain.ServiceContract{
		contract(t, domain.ContractAMC, live.ID, 8, 48, at.AddDate(0, 0, 10)),
		contract(t, domain.ContractCMC, gone.ID, 2, 8, at.AddDate(0, 0, 3)),
	}
	assets := []domain.Asset{live, gone}

	out := domain.Expiries(assets, contracts, 30*24*time.Hour, at)
	if len(out) != 2 {
		t.Fatalf("expiries = %+v, want two (the live asset's contract and "+
			"calibration)", out)
	}
	for _, expiry := range out {
		if expiry.AssetID == gone.ID {
			t.Error("a decommissioned asset generated a renewal reminder")
		}
		if expiry.AssetTag == "" {
			t.Error("a reminder names a UUID rather than the machine")
		}
	}
	// Soonest first.
	if out[0].Kind != domain.ExpiryContract {
		t.Errorf("first = %s, want the contract at ten days", out[0].Kind)
	}

	// A zero horizon reports only what has already lapsed, and hides nothing.
	live.CalibrationDue = at.AddDate(0, 0, -3)
	lapsedOnly := domain.Expiries([]domain.Asset{live}, nil, 0, at)
	if len(lapsedOnly) != 1 || lapsedOnly[0].DaysRemaining >= 0 {
		t.Errorf("zero horizon = %+v, want the lapsed certificate", lapsedOnly)
	}
}

// SRS-BIO-003. The due list is derived, and a runtime plan with no meter
// reading says so rather than reading as not due.
func TestTheDueListDistinguishesNotDueFromUnanswerable(t *testing.T) {
	asset := intensifier(t)
	pump := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-030", Make: "Baxter", Model: "Sigma",
		Criticality: domain.CriticalityImportant, LocationID: "ward-7",
	})

	overdue, err := domain.NewPMPlan("plan-1", "tenant-1", domain.NewPlanInput{
		AssetID: asset.ID, Basis: domain.BasisInterval, IntervalDays: 90,
		Procedure:       "annual electrical safety and image quality",
		LastPerformedAt: at.AddDate(0, 0, -100),
	}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}

	runtime, err := domain.NewPMPlan("plan-2", "tenant-1", domain.NewPlanInput{
		AssetID: pump.ID, Basis: domain.BasisRuntime, RuntimeHours: 2000,
		Procedure: "pump mechanism service", LastRuntimeHours: 1000,
	}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}

	assets := []domain.Asset{asset, pump}
	plans := []domain.PMPlan{overdue, runtime}

	// No meter reading at all.
	silent := domain.DueList(plans, assets, nil, 7*24*time.Hour, at)
	var unanswerable int
	for _, due := range silent {
		if due.Unanswerable {
			unanswerable++
		}
	}
	if unanswerable != 1 {
		t.Errorf("unanswerable = %d, want 1; a runtime plan reported as not "+
			"due because nobody read the meter is a service that never happens",
			unanswerable)
	}

	// With a reading that puts it past its interval.
	withMeter := domain.DueList(plans, assets,
		map[string]int{pump.ID: 3200}, 7*24*time.Hour, at)
	var pumpDue domain.Due
	for _, due := range withMeter {
		if due.AssetID == pump.ID {
			pumpDue = due
		}
	}
	if pumpDue.State != domain.DueOverdue || pumpDue.HoursRemaining != -200 {
		t.Errorf("runtime plan = %s with %d hours remaining, want overdue by 200",
			pumpDue.State, pumpDue.HoursRemaining)
	}

	// The interval plan is ten days overdue and sorts first.
	if withMeter[0].AssetID != asset.ID || withMeter[0].State != domain.DueOverdue {
		t.Errorf("first = %+v, want the most overdue interval plan", withMeter[0])
	}

	// A plan against a decommissioned asset is not work anybody is sent to do.
	if err := pump.Move(domain.AssetDecommissioned, "condemned", at); err != nil {
		t.Fatalf("Move: %v", err)
	}
	after := domain.DueList(plans, []domain.Asset{asset, pump},
		map[string]int{pump.ID: 3200}, 7*24*time.Hour, at)
	for _, due := range after {
		if due.AssetID == pump.ID {
			t.Error("a decommissioned asset was still on the due list")
		}
	}
}

// SRS-BIO-003. A newly registered plan is due one interval from now, not
// immediately.
func TestANewPlanIsNotImmediatelyOverdue(t *testing.T) {
	asset := intensifier(t)
	plan, err := domain.NewPMPlan("plan-1", "tenant-1", domain.NewPlanInput{
		AssetID: asset.ID, Basis: domain.BasisInterval, IntervalDays: 90,
		Procedure: "electrical safety",
	}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}

	due := domain.DueList([]domain.PMPlan{plan}, []domain.Asset{asset}, nil,
		7*24*time.Hour, at)
	if len(due) != 0 {
		t.Errorf("a plan registered today is already %s; a hospital that "+
			"registered fifty assets on Monday would find fifty overdue "+
			"services on Tuesday", due[0].State)
	}
}

// SRS-BIO-005. The SLA comes from the contract the hospital bought, and
// priority only tightens it.
func TestTheSlaComesFromTheContractAndPriorityOnlyTightensIt(t *testing.T) {
	asset := intensifier(t)
	slow := contract(t, domain.ContractAMC, asset.ID, 24, 72, at.AddDate(1, 0, 0))
	contracts := []domain.ServiceContract{slow}
	defaults := domain.SLA{ResponseHours: 8, ResolutionHours: 48}

	// A normal ticket takes the contract's hours, even though they are worse
	// than the deployment's defaults: that is the promise that was bought.
	normal := domain.SLAFor(contracts, asset.ID, domain.PriorityNormal,
		defaults, at)
	if normal.ResponseHours != 24 || normal.ResolutionHours != 72 {
		t.Errorf("normal SLA = %+v, want the contract's 24/72", normal)
	}
	if normal.ContractID != slow.ID {
		t.Error("the SLA does not name the contract that set it; a breach " +
			"could not be taken to the right vendor")
	}

	// An emergency is capped tighter, whatever the vendor agreed.
	emergency := domain.SLAFor(contracts, asset.ID, domain.PriorityEmergency,
		defaults, at)
	if emergency.ResponseHours != 1 || emergency.ResolutionHours != 4 {
		t.Errorf("emergency SLA = %+v, want 1/4; an emergency is still an "+
			"emergency to the hospital", emergency)
	}

	// With no contract, the deployment's defaults apply.
	none := domain.SLAFor(nil, asset.ID, domain.PriorityNormal, defaults, at)
	if none.ResponseHours != 8 || none.ContractID != "" {
		t.Errorf("uncovered SLA = %+v, want the defaults and no contract", none)
	}
}

func ticket(t *testing.T, asset domain.Asset, in domain.NewTicketInput,
	sla domain.SLA) domain.Ticket {

	t.Helper()
	out, err := domain.RaiseTicket("tkt-1", "tenant-1", in, asset, sla,
		"nurse-1", at)
	if err != nil {
		t.Fatalf("RaiseTicket: %v", err)
	}
	return out
}

// SRS-BIO-006. A repair is validated by somebody other than the engineer who
// made it.
func TestARepairIsValidatedBySomebodyElse(t *testing.T) {
	asset := intensifier(t)
	tkt := ticket(t, asset, domain.NewTicketInput{
		Symptom: "image drifts after ten minutes", Priority: domain.PriorityHigh,
		Impact: domain.ImpactServiceStopped,
	}, domain.SLA{ResponseHours: 4, ResolutionHours: 24})

	if err := tkt.Assign("engineer-1", at.Add(30*time.Minute)); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := tkt.Start(at.Add(time.Hour)); err != nil {
		t.Fatalf("Start: %v", err)
	}

	// A resolution with no diagnosis says a machine was fixed and nothing
	// about whether it is the same fault as last time.
	if err := tkt.Resolve(domain.ResolveInput{
		WorkPerformed: "replaced board",
	}, "engineer-1", at.Add(2*time.Hour)); err == nil {
		t.Error("a repair was recorded with no diagnosis")
	}

	if err := tkt.Resolve(domain.ResolveInput{
		Diagnosis:     "thermal drift in the detector board",
		WorkPerformed: "replaced detector board, ran image quality check",
		Parts: []domain.PartUsed{{
			Code: "DET-77", Description: "detector board", Quantity: 1,
			CoveredByContract: true,
		}},
	}, "engineer-1", at.Add(3*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	if err := tkt.Close("engineer-1", "", at.Add(4*time.Hour)); err == nil {
		t.Fatal("the engineer who did the work validated it; that is the " +
			"same claim twice, not a validation")
	}
	if err := tkt.Close("bme-manager-1", "image quality verified",
		at.Add(4*time.Hour)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if tkt.State != domain.TicketClosed {
		t.Errorf("state = %s, want closed", tkt.State)
	}

	// A part cannot be both covered and costed.
	var second domain.Ticket = ticket(t, asset, domain.NewTicketInput{
		Symptom: "again",
	}, domain.SLA{})
	if err := second.Assign("engineer-1", at); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := second.Resolve(domain.ResolveInput{
		Diagnosis: "same", WorkPerformed: "same",
		Parts: []domain.PartUsed{{
			Code: "DET-77", Quantity: 1, CostMinor: 50_000_00,
			CoveredByContract: true,
		}},
	}, "engineer-1", at.Add(time.Hour)); err == nil {
		t.Error("a part was both covered by contract and charged for; the " +
			"difference is what a renewal is argued with")
	}
}

// SRS-BIO-005, SRS-BIO-007. The parts wait stops the resolution clock, because
// the wait is the vendor's.
func TestAwaitingPartsStopsTheResolutionClock(t *testing.T) {
	asset := intensifier(t)
	tkt := ticket(t, asset, domain.NewTicketInput{
		Symptom: "tube failure", Priority: domain.PriorityHigh,
	}, domain.SLA{ResponseHours: 4, ResolutionHours: 24})

	if err := tkt.Assign("engineer-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := tkt.AwaitParts("X-ray tube on order, 5 days",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("AwaitParts: %v", err)
	}

	// Five days later the resolution deadline has passed on the wall clock.
	backInStock := at.Add(2 * time.Hour).Add(5 * 24 * time.Hour)
	if err := tkt.Start(backInStock); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := tkt.Resolve(domain.ResolveInput{
		Diagnosis: "tube at end of life", WorkPerformed: "tube replaced",
	}, "engineer-1", backInStock.Add(3*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	_, resolutionBreach := tkt.Breached(backInStock.Add(4 * time.Hour))
	if resolutionBreach {
		t.Error("the engineer was charged with the vendor's five-day wait; a " +
			"department judged on that learns to leave tickets open rather " +
			"than order the part")
	}

	// The wait itself is recorded, so it is visible rather than erased.
	if tkt.AwaitingPartsMinutes < 5*24*60 {
		t.Errorf("awaiting parts = %d minutes, want at least five days",
			tkt.AwaitingPartsMinutes)
	}
}

// SRS-BIO-007. Downtime is measured from when the machine stopped, not from
// when somebody noticed.
func TestDowntimeIsMeasuredFromFailureNotFromReport(t *testing.T) {
	asset := intensifier(t)
	failed := at.AddDate(0, 0, -3)

	tkt := ticket(t, asset, domain.NewTicketInput{
		Symptom: "found dead on Monday", DownFrom: failed,
	}, domain.SLA{})
	if err := tkt.Assign("engineer-1", at); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := tkt.Resolve(domain.ResolveInput{
		Diagnosis: "power supply", WorkPerformed: "replaced",
	}, "engineer-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	minutes := tkt.DowntimeMinutes(at.Add(time.Hour))
	want := int(at.Add(time.Hour).Sub(failed).Minutes())
	if minutes != want {
		t.Errorf("downtime = %d minutes, want %d; a metric measured from the "+
			"report would reward late reporting", minutes, want)
	}

	// A machine cannot come back before it stopped.
	var backwards domain.Ticket = ticket(t, asset, domain.NewTicketInput{
		Symptom: "x", DownFrom: at,
	}, domain.SLA{})
	if err := backwards.Assign("engineer-1", at); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := backwards.Resolve(domain.ResolveInput{
		Diagnosis: "y", WorkPerformed: "z",
		BackInServiceAt: at.AddDate(0, 0, -1),
	}, "engineer-1", at.Add(time.Hour)); err == nil {
		t.Error("a machine came back before it stopped")
	}

	// A cancelled ticket records no downtime.
	var mistaken domain.Ticket = ticket(t, asset, domain.NewTicketInput{
		Symptom: "thought it was broken", DownFrom: failed,
	}, domain.SLA{})
	if err := mistaken.Cancel("user error, machine is fine", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if got := mistaken.DowntimeMinutes(at); got != 0 {
		t.Errorf("a cancelled ticket recorded %d minutes of downtime; uptime "+
			"would measure how often somebody mis-reported a machine", got)
	}
}

// SRS-BIO-008. A notice reaches the assets it names, and is inclusive where it
// is vague.
func TestASafetyNoticeReachesTheAssetsItNames(t *testing.T) {
	matching := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-100", Make: "Acme", Model: "Vent-9", Serial: "SN-0500",
		LocationID: "icu-1",
	})
	outOfRange := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-101", Make: "Acme", Model: "Vent-9", Serial: "SN-9000",
		LocationID: "icu-1",
	})
	noSerial := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-102", Make: "Acme", Model: "Vent-9", LocationID: "icu-2",
	})
	otherModel := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-103", Make: "Acme", Model: "Vent-7", Serial: "SN-0400",
	})
	otherMake := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-104", Make: "Beta", Model: "Vent-9", Serial: "SN-0400",
	})

	notice, err := domain.NewSafetyNotice("not-1", "tenant-1",
		domain.NewNoticeInput{
			Reference: "FSN-2026-44", Kind: domain.NoticeRecall,
			Issuer: "Acme", Summary: "expiry valve may stick",
			Make: "Acme", Model: "Vent-9",
			SerialFrom: "SN-0001", SerialTo: "SN-1000",
			RequiredAction: "inspect and replace valve assembly",
			DueBy:          at.AddDate(0, 0, 30),
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewSafetyNotice: %v", err)
	}
	if !notice.HoldAffected {
		t.Error("a recall did not hold its assets; that is the one direction " +
			"that must not be configurable")
	}

	assets := []domain.Asset{
		matching, outOfRange, noSerial, otherModel, otherMake,
	}
	n := 0
	tasks := notice.Match(assets, func() string {
		n++
		return "task-" + strconv.Itoa(n)
	})

	reached := map[string]bool{}
	for _, task := range tasks {
		reached[task.AssetTag] = true
	}
	if !reached["BME-100"] {
		t.Error("the in-range asset was missed")
	}
	if !reached["BME-102"] {
		t.Error("an asset with no serial was dropped from a recall on the " +
			"strength of a missing field")
	}
	if reached["BME-101"] || reached["BME-103"] || reached["BME-104"] {
		t.Errorf("the notice reached assets it does not name: %v", reached)
	}

	// A UDI match is exact and wins outright.
	udi := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-105", Make: "Gamma", Model: "Other", UDI: "(01)0761234",
	})
	byUDI, err := domain.NewSafetyNotice("not-2", "tenant-1",
		domain.NewNoticeInput{
			Reference: "FSN-45", Kind: domain.NoticeFieldSafety,
			Summary: "software update", AffectedUDI: "(01)0761234",
			RequiredAction: "apply firmware 4.2",
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewSafetyNotice: %v", err)
	}
	if !byUDI.Covers(udi) {
		t.Error("a UDI notice missed its exact match")
	}
	if byUDI.Covers(matching) {
		t.Error("a UDI notice reached an asset with a different UDI")
	}

	// A notice naming nothing reaches nothing, so it is refused.
	if _, err := domain.NewSafetyNotice("not-3", "tenant-1",
		domain.NewNoticeInput{
			Reference: "FSN-46", Kind: domain.NoticeAdvisory,
			Summary: "vague", RequiredAction: "read it",
		}, "bme-1", at); err == nil {
		t.Error("a notice naming no equipment was recorded; it reaches nothing")
	}
}

// SRS-BIO-008. A notice cannot be closed with work outstanding.
func TestANoticeCannotBeClosedWithWorkOutstanding(t *testing.T) {
	asset := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-110", Make: "Acme", Model: "Vent-9", LocationID: "icu-1",
	})
	other := mustAsset(t, domain.NewAssetInput{
		Tag: "BME-111", Make: "Acme", Model: "Vent-9", LocationID: "icu-2",
	})

	notice, err := domain.NewSafetyNotice("not-1", "tenant-1",
		domain.NewNoticeInput{
			Reference: "FSN-50", Kind: domain.NoticeFieldSafety,
			Summary: "valve", Make: "Acme", Model: "Vent-9",
			RequiredAction: "inspect", DueBy: at.AddDate(0, 0, -1),
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewSafetyNotice: %v", err)
	}

	n := 0
	tasks := notice.Match([]domain.Asset{asset, other}, func() string {
		n++
		return "task-" + strconv.Itoa(n)
	})
	if len(tasks) != 2 {
		t.Fatalf("tasks = %d, want 2", len(tasks))
	}

	progress := domain.Track(notice, tasks, at)
	if progress.Outstanding != 2 || !progress.Overdue {
		t.Fatalf("progress = %+v, want two outstanding and overdue", progress)
	}

	if err := notice.CloseNotice(progress, "bme-manager-1", "", at); err == nil {
		t.Fatal("a notice was closed with work outstanding; the hospital has " +
			"told itself it dealt with a recall")
	}

	// "Not affected" is the one verdict that ends the enquiry, so it needs a
	// reason.
	if err := tasks[0].Advance(domain.TaskNotAffected, "", "bme-1", at); err == nil {
		t.Error("an asset was declared unaffected with no reason")
	}
	if err := tasks[0].Advance(domain.TaskNotAffected,
		"serial predates the affected batch", "bme-1", at); err != nil {
		t.Fatalf("Advance: %v", err)
	}
	if err := tasks[1].Advance(domain.TaskCorrected, "valve replaced",
		"engineer-1", at); err != nil {
		t.Fatalf("Advance: %v", err)
	}

	// A completed task does not move again.
	if err := tasks[1].Advance(domain.TaskInspected, "", "engineer-1", at); err == nil {
		t.Error("a completed task was advanced again")
	}

	progress = domain.Track(notice, tasks, at)
	if progress.Outstanding != 0 || progress.Complete != 2 {
		t.Fatalf("progress = %+v, want all complete", progress)
	}
	if err := notice.CloseNotice(progress, "bme-manager-1", "all inspected",
		at); err != nil {
		t.Fatalf("CloseNotice: %v", err)
	}
}

// SRS-BIO-010. Telemetry is its own record and never reaches a maintenance
// one. Latest is by observation, because a backlog uploads out of order.
func TestTelemetryIsSeparateAndLatestIsByObservation(t *testing.T) {
	asset := intensifier(t)

	newest, err := domain.NewReading("read-1", "tenant-1",
		domain.NewReadingInput{
			AssetID: asset.ID, Metric: domain.MetricRuntimeHours,
			Value: 4200, Unit: "h", Source: "gateway-1", Ingested: true,
			ObservedAt: at.Add(-time.Hour),
		}, "ingest", at)
	if err != nil {
		t.Fatalf("NewReading: %v", err)
	}

	// Recorded later, observed earlier: a backlog flushing after an outage.
	stale, err := domain.NewReading("read-2", "tenant-1",
		domain.NewReadingInput{
			AssetID: asset.ID, Metric: domain.MetricRuntimeHours,
			Value: 4100, Unit: "h", ObservedAt: at.Add(-24 * time.Hour),
		}, "ingest", at.Add(time.Minute))
	if err != nil {
		t.Fatalf("NewReading: %v", err)
	}

	latest := domain.LatestRuntime([]domain.Reading{stale, newest})
	if latest[asset.ID] != 4200 {
		t.Errorf("latest runtime = %d, want 4200; a backlog flushing after an "+
			"outage arrives out of order", latest[asset.ID])
	}

	// A reading from the future is a device with the wrong clock, and it
	// would make a service look not due.
	if _, err := domain.NewReading("read-3", "tenant-1",
		domain.NewReadingInput{
			AssetID: asset.ID, Metric: domain.MetricRuntimeHours,
			Value: 9999, ObservedAt: at.Add(48 * time.Hour),
		}, "ingest", at); err == nil {
		t.Error("a reading dated two days in the future was accepted")
	}

	// A reading with no metric is a number.
	if _, err := domain.NewReading("read-4", "tenant-1",
		domain.NewReadingInput{AssetID: asset.ID, Value: 1},
		"ingest", at); err == nil {
		t.Error("a reading with no metric was accepted")
	}
}

// SRS-BIO-007. The reliability figures reconcile to the service events they
// come from, and the formulas are restated here rather than only asserted.
func TestTheReliabilityFiguresReconcileToTheServiceEvents(t *testing.T) {
	asset := intensifier(t)
	from, to := at.AddDate(0, 0, -30), at

	// Two failures: one of 6 hours, one of 18.
	first := ticket(t, asset, domain.NewTicketInput{
		Symptom: "first", DownFrom: from.AddDate(0, 0, 5),
	}, domain.SLA{})
	if err := first.Assign("engineer-1", from.AddDate(0, 0, 5)); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := first.Resolve(domain.ResolveInput{
		Diagnosis: "a", WorkPerformed: "b",
		BackInServiceAt: from.AddDate(0, 0, 5).Add(6 * time.Hour),
	}, "engineer-1", from.AddDate(0, 0, 5).Add(6*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	second := ticket(t, asset, domain.NewTicketInput{
		Symptom: "second", DownFrom: from.AddDate(0, 0, 20),
	}, domain.SLA{})
	if err := second.Assign("engineer-1", from.AddDate(0, 0, 20)); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := second.Resolve(domain.ResolveInput{
		Diagnosis: "c", WorkPerformed: "d",
		BackInServiceAt: from.AddDate(0, 0, 20).Add(18 * time.Hour),
	}, "engineer-1", from.AddDate(0, 0, 20).Add(18*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	metrics := domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to,
		Tickets: []domain.Ticket{first, second},
	})

	period := int(to.Sub(from).Minutes())
	if metrics.PeriodMinutes != period {
		t.Fatalf("period = %d, want %d", metrics.PeriodMinutes, period)
	}
	// 6 + 18 = 24 hours down.
	if metrics.DowntimeMinutes != 24*60 {
		t.Fatalf("downtime = %d minutes, want %d", metrics.DowntimeMinutes, 24*60)
	}
	if metrics.Failures != 2 {
		t.Fatalf("failures = %d, want 2", metrics.Failures)
	}

	// uptime% = uptime / period.
	wantUptime := float64(period-24*60) / float64(period) * 100
	if diff := metrics.UptimePercent - wantUptime; diff > 0.001 || diff < -0.001 {
		t.Errorf("uptime = %f%%, want %f%%", metrics.UptimePercent, wantUptime)
	}
	// MTBF = uptime / failures.
	wantMTBF := float64(period-24*60) / 2 / 60
	if diff := metrics.MTBFHours - wantMTBF; diff > 0.001 || diff < -0.001 {
		t.Errorf("MTBF = %f h, want %f h", metrics.MTBFHours, wantMTBF)
	}
	// MTTR = total repair time / repairs = 24 / 2.
	if diff := metrics.MTTRHours - 12; diff > 0.001 || diff < -0.001 {
		t.Errorf("MTTR = %f h, want 12 h", metrics.MTTRHours)
	}

	// A machine still down counts to the end of the window rather than
	// reporting no downtime at all.
	open := ticket(t, asset, domain.NewTicketInput{
		Symptom: "still broken", DownFrom: to.Add(-4 * time.Hour),
	}, domain.SLA{})
	withOpen := domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to,
		Tickets: []domain.Ticket{open},
	})
	if withOpen.DowntimeMinutes != 4*60 {
		t.Errorf("an open ticket contributed %d minutes, want 240",
			withOpen.DowntimeMinutes)
	}
}

// SRS-BIO-007. Overlapping tickets are clamped and the oddity is named, so a
// reader knows the data is strange rather than the machine.
func TestOverlappingTicketsAreClampedAndSaidSo(t *testing.T) {
	asset := intensifier(t)
	from, to := at.AddDate(0, 0, -2), at

	var tickets []domain.Ticket
	for i := 0; i < 3; i++ {
		tkt := ticket(t, asset, domain.NewTicketInput{
			Symptom: "overlapping " + strconv.Itoa(i), DownFrom: from,
		}, domain.SLA{})
		tickets = append(tickets, tkt)
	}

	metrics := domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to, Tickets: tickets,
	})
	if metrics.DowntimeMinutes != metrics.PeriodMinutes {
		t.Errorf("downtime = %d, want it clamped to the period %d",
			metrics.DowntimeMinutes, metrics.PeriodMinutes)
	}
	if metrics.UptimePercent != 0 {
		t.Errorf("uptime = %f%%, want 0", metrics.UptimePercent)
	}
	if len(metrics.Incomplete) == 0 {
		t.Error("three overlapping tickets produced no complaint; a reader " +
			"would think the machine was down rather than the data odd")
	}
}

// SRS-BIO-007. PM compliance counts what fell due in the window against what
// was done.
func TestPmComplianceCountsIntervalsInTheWindow(t *testing.T) {
	asset := intensifier(t)
	from, to := at.AddDate(0, 0, -100), at

	plan, err := domain.NewPMPlan("plan-1", "tenant-1", domain.NewPlanInput{
		AssetID: asset.ID, Basis: domain.BasisInterval, IntervalDays: 30,
		Procedure: "quarterly service", LastPerformedAt: from,
	}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}

	// Three intervals fall inside a hundred days; two were done.
	var done []domain.Ticket
	for i, day := range []int{30, 60} {
		when := from.AddDate(0, 0, day)
		tkt, err := domain.RaiseTicket("pm-"+strconv.Itoa(i), "tenant-1",
			domain.NewTicketInput{
				Kind: domain.KindPreventive, PlanID: plan.ID,
				Symptom: "planned service", DownFrom: when,
			}, asset, domain.SLA{}, "bme-1", when)
		if err != nil {
			t.Fatalf("RaiseTicket: %v", err)
		}
		if err := tkt.Assign("engineer-1", when); err != nil {
			t.Fatalf("Assign: %v", err)
		}
		if err := tkt.Resolve(domain.ResolveInput{
			Diagnosis: "planned", WorkPerformed: "serviced",
			BackInServiceAt: when.Add(2 * time.Hour),
		}, "engineer-1", when.Add(2*time.Hour)); err != nil {
			t.Fatalf("Resolve: %v", err)
		}
		if err := tkt.Close("bme-manager-1", "", when.Add(3*time.Hour)); err != nil {
			t.Fatalf("Close: %v", err)
		}
		done = append(done, tkt)
	}

	metrics := domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to, Tickets: done,
		Plans: []domain.PMPlan{plan}, CompletedPM: done,
	})

	// Four hours out for two scheduled services, and not one failure: a
	// machine serviced properly is not an unreliable machine.
	if metrics.Failures != 0 {
		t.Errorf("failures = %d, want 0; counting a scheduled service as a "+
			"failure is an argument for skipping the service", metrics.Failures)
	}
	if metrics.DowntimeMinutes != 0 {
		t.Errorf("unplanned downtime = %d, want 0", metrics.DowntimeMinutes)
	}
	if metrics.PlannedDowntimeMinutes != 4*60 {
		t.Errorf("planned downtime = %d minutes, want 240; it is real and it "+
			"is reported beside the unplanned kind, not mixed into it",
			metrics.PlannedDowntimeMinutes)
	}

	if metrics.PMDue != 3 {
		t.Errorf("due = %d, want 3 intervals in a hundred days", metrics.PMDue)
	}
	if metrics.PMDone != 2 {
		t.Errorf("done = %d, want 2", metrics.PMDone)
	}
	wantCompliance := 2.0 / 3.0 * 100
	if diff := metrics.PMCompliance - wantCompliance; diff > 0.001 || diff < -0.001 {
		t.Errorf("compliance = %f%%, want %f%%",
			metrics.PMCompliance, wantCompliance)
	}

	// Preventive work naming no plan is refused, so compliance cannot become
	// whatever anybody happened to label preventive.
	if _, err := domain.RaiseTicket("pm-x", "tenant-1", domain.NewTicketInput{
		Kind: domain.KindPreventive, Symptom: "service",
	}, asset, domain.SLA{}, "bme-1", at); err == nil {
		t.Error("preventive work was raised against no plan")
	}

	// And a closed ticket against a different plan does not count towards
	// this one.
	other := done[0]
	other.PlanID = "plan-somewhere-else"
	stray := domain.ComputeMetrics(domain.MetricsInput{
		Asset: asset, From: from, To: to,
		Plans: []domain.PMPlan{plan}, CompletedPM: []domain.Ticket{other},
	})
	if stray.PMDone != 0 {
		t.Errorf("a service against another plan counted towards this one "+
			"(%d done)", stray.PMDone)
	}
}

// SRS-BIO-007. The fleet is ordered by uptime, because one long outage is a
// worse problem than five short ones.
func TestTheFleetIsOrderedByUptimeNotByFailureCount(t *testing.T) {
	longOutage := domain.FleetLine{
		AssetID: "a", AssetTag: "BME-A",
		Criticality: domain.CriticalityImportant,
		Metrics:     domain.Metrics{UptimePercent: 80, Failures: 1},
	}
	manyShort := domain.FleetLine{
		AssetID: "b", AssetTag: "BME-B",
		Criticality: domain.CriticalityImportant,
		Metrics:     domain.Metrics{UptimePercent: 99, Failures: 5},
	}

	out := domain.Fleet([]domain.FleetLine{manyShort, longOutage})
	if out[0].AssetTag != "BME-A" {
		t.Errorf("first = %s, want the one with the worst uptime", out[0].AssetTag)
	}
}
