// Package domain holds the identity & access context's authorization model.
//
// Roles map to permissions over bounded-context actions, not to menus
// (SRS-IAM-003). The catalogue lives in code for Wave 0 and moves to
// tenant-configurable storage in Wave 7 alongside SRS-CFG; the shape of the
// lookup is deliberately the same either way.
package domain

import (
	"sort"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Role is a named bundle of permissions.
type Role string

const (
	// RolePlatformOperator provisions tenants. Deliberately separate from any
	// tenant-level admin role: provisioning is cross-tenant authority and must
	// not be reachable by escalating inside a tenant.
	RolePlatformOperator Role = "platform_operator"

	// RoleTenantAdmin configures one tenant's organization master data.
	RoleTenantAdmin Role = "tenant_admin"

	// RoleFacilityViewer reads organization master data.
	RoleFacilityViewer Role = "facility_viewer"

	// RoleAuditor reads audit trails and cannot mutate clinical or financial
	// records (SRS-IAM-014).
	RoleAuditor Role = "auditor"

	// RoleRegistrationClerk registers patients and corrects their details at a
	// front desk (Wave-1 actor "Registration").
	RoleRegistrationClerk Role = "registration_clerk"

	// RoleHIMOfficer is health information management: the people who resolve
	// duplicate identities. The Wave-1 backlog names them "Authorized HIM", and
	// merge authority is theirs alone.
	//
	// From SRS-MRD this is also the records office's day-to-day work: raising
	// and chasing chart deficiencies, logging and assembling record releases,
	// tracking the paper, and preparing and carrying out a disposition batch.
	//
	// What it deliberately does not hold is every decision a second person
	// should make: waiving a deficiency, approving a release, putting a
	// checklist or a retention rule in force, placing a legal hold, and
	// approving the disposition list it prepares and will itself execute.
	RoleHIMOfficer Role = "him_officer"

	// RoleHIMManager runs the records office rather than working in it
	// (SRS-MRD-001, SRS-MRD-002, SRS-MRD-004, SRS-MRD-005, SRS-MRD-007,
	// SRS-MRD-009).
	//
	// The decisions that make something disappear or leave the hospital. A
	// waiver takes an encounter out of the completion figures; an approval
	// sends a patient's record to an insurer; an approved disposition list is
	// the last check before records stop existing. Each sits above the person
	// who proposed it.
	//
	// Holding both mrd.checklist.write and mrd.checklist.approve, and both
	// mrd.retention.write and mrd.retention.approve, is necessary and not
	// sufficient: the domain and the database each refuse a rule approved by
	// its own author, whoever they are. The same holds for a release this
	// role both requested and approved.
	//
	// Deliberately no mrd.disposition.execute: the person who signs the list
	// and the person who shreds the records are not the same person in any
	// records office that has been audited. And deliberately no
	// mrd.certificate.issue: a statutory certificate is signed by a clinician
	// with the standing the form names, and a records manager who could issue
	// one would be certifying a cause of death.
	RoleHIMManager Role = "him_manager"

	// RoleDietitian assesses patients, writes nutrition care plans, orders
	// diets and proposes tube or intravenous feeding (SRS-DIET-001 … 004,
	// SRS-DIET-007).
	//
	// What it deliberately does not hold is diet.conflict.resolve. A
	// conflict is a diet item against an allergy on the patient's clinical
	// record, and deciding that the allergy does not apply to this food is a
	// clinical judgement about the record rather than about the meal. The
	// dietitian who placed the order raising the conflict is also the person
	// least well placed to overrule it.
	//
	// And no diet.support.link: the plan is not the prescription, which is
	// the whole of SRS-DIET-007.
	RoleDietitian Role = "dietitian"

	// RoleKitchenStaff runs the meal service (SRS-DIET-005, SRS-DIET-006,
	// SRS-DIET-008).
	//
	// Deliberately no diet.record.read. The kitchen needs the tray card — a
	// texture, a restriction, a bed — and has no business reading a
	// nutrition assessment, which carries a diagnosis. diet.service.read is
	// the narrower read that gives it the census and the trays.
	RoleKitchenStaff Role = "kitchen_staff"

	// RoleHousekeeper cleans (SRS-HKP-002, SRS-HKP-004, SRS-HKP-007).
	//
	// It holds hkp.spill.read, because somebody sent to a biohazard task
	// needs to know what was spilled before they decide what to wear.
	//
	// What it deliberately does not hold is hkp.task.verify. A clean signed
	// off by the cleaner is the same claim made twice, and supervisor
	// verification is SRS-HKP-004's own word for what this is. Nor
	// hkp.bed.override: putting a patient into an uncleaned bed is a
	// decision about the ward, not about the cleaning.
	RoleHousekeeper Role = "housekeeper"

	// RoleHousekeepingSupervisor runs the cleaning and checks the work
	// (SRS-HKP-001, SRS-HKP-004, SRS-HKP-005, SRS-HKP-008).
	//
	// Deliberately no hkp.location.approve. The supervisor writes the
	// cleaning standard; somebody else puts it in force, because a standard
	// decides how often a theatre is cleaned and what counts as cleaning it.
	// The domain also refuses the author their own approval, so this is the
	// second lock rather than the only one.
	//
	// And deliberately no hkp.bed.override, for the reason above.
	RoleHousekeepingSupervisor Role = "housekeeping_supervisor"

	// RoleLaundryOperator runs the machines (SRS-LND-002, SRS-LND-003,
	// SRS-LND-004).
	//
	// What it deliberately does not hold is lnd.receive: a delivery signed
	// for by whoever brought it is the same claim made twice, and a ward
	// that never got its linen would have no way to say so.
	//
	// And no lnd.loss.approve: an operator who could write off the linen
	// they lost is an operator whose losses are always nil.
	RoleLaundryOperator Role = "laundry_operator"

	// RoleLaundryManager runs the laundry and decides its write-offs
	// (SRS-LND-001, SRS-LND-006, SRS-LND-007).
	//
	// Deliberately no lnd.par.approve. The manager drafts the par — how much
	// linen each ward may hold, and therefore what the laundry buys — and
	// somebody else puts it in force. The domain refuses the author their
	// own approval either way, so this is the second lock rather than the
	// only one.
	RoleLaundryManager Role = "laundry_manager"

	// RoleAmbulanceCrew is the people on the vehicle (SRS-AMB-003,
	// SRS-AMB-004, SRS-AMB-006).
	//
	// They check the vehicle, record the timeline and write the clinical
	// account, because they are the only people who know when they arrived
	// and what they gave.
	//
	// What it deliberately does not hold is amb.check.override: somebody
	// who found the oxygen empty and then waved it through is one person
	// deciding both. The domain refuses whoever made the check either way,
	// so this is the second lock rather than the only one.
	//
	// And no amb.handover.accept: a handover accepted by the crew who gave
	// it is the same claim made twice, and the patient is standing between
	// two people neither of whom has taken responsibility.
	RoleAmbulanceCrew Role = "ambulance_crew"

	// RoleAmbulanceDispatcher takes the calls and sends the vehicles
	// (SRS-AMB-001, SRS-AMB-003).
	//
	// Deliberately no amb.dispatch.override. Sending a vehicle that failed
	// its check, whose crew is off duty or that does not carry what the
	// call needs is a decision somebody is accountable for, not a busy
	// dispatcher's fourth click.
	//
	// And no amb.prehospital.read or amb.prehospital.write: a dispatch
	// board is read in a room full of people, and what the crew gave the
	// patient is not on it.
	RoleAmbulanceDispatcher Role = "ambulance_dispatcher"

	// RoleAmbulanceManager runs the fleet and carries the overrides
	// (SRS-AMB-002, SRS-AMB-006, SRS-AMB-008).
	//
	// Deliberately no amb.dispatch. The person who may wave a failed
	// vehicle onto the run is not the person sending it, so an override is
	// a second pair of eyes on a decision somebody else has to make.
	RoleAmbulanceManager Role = "ambulance_manager"

	// RoleMortuaryAttendant runs the mortuary day to day (SRS-MORT-001,
	// SRS-MORT-002, SRS-MORT-004).
	//
	// They receive bodies, put them in spaces, list belongings and keep
	// the chain of custody. What they deliberately do not hold is
	// mort.release: a body leaves once, and the person who put it in the
	// drawer is not the only person involved in taking it out.
	//
	// And no mort.authorise: recording a coroner's clearance is not the
	// same act as doing the work it clears, and a mortuary where one
	// person does both is one where the clearance is whatever that person
	// typed.
	RoleMortuaryAttendant Role = "mortuary_attendant"

	// RoleMortuaryManager releases bodies and takes the clearances
	// (SRS-MORT-006, SRS-MORT-007, SRS-MORT-008).
	//
	// Deliberately no mort.sensitive.read. Running a mortuary does not
	// require reading a cause of death: the manager needs to know a case
	// is medico-legal, which the board shows, and not what it says.
	RoleMortuaryManager Role = "mortuary_manager"

	// RoleCoronersOfficer is the authority's own officer working inside
	// the hospital (SRS-MORT-003, SRS-MORT-005).
	//
	// The one role that reads the cause and the medico-legal reference as
	// a matter of course, and the one that authorises a medico-legal
	// examination. Deliberately no mort.release and no mort.custody: the
	// coroner's officer decides what may happen and does not do it.
	RoleCoronersOfficer Role = "coroners_officer"

	// RoleFacilitiesTechnician does the estates work (SRS-FAC-002,
	// SRS-FAC-003, SRS-FAC-007, SRS-FAC-009).
	//
	// Deliberately no fac.work.close: a repair signed off by the person
	// who made it is the same claim twice, and the domain refuses it
	// anyway — holding the permission would only make the refusal look
	// like a bug.
	//
	// Deliberately no fac.permit: "may do maintenance" and "may isolate
	// an eleven-kilovolt panel" are different questions with different
	// answers, and a hospital that conflates them has a permit system on
	// paper only.
	RoleFacilitiesTechnician Role = "facilities_technician"

	// RoleFacilitiesManager runs the estates function (SRS-FAC-001,
	// SRS-FAC-004, SRS-FAC-010, SRS-FAC-011).
	//
	// Holds both fac.outage.request and fac.outage.approve, which is safe
	// because the control is per-record rather than per-role: the domain
	// refuses an outage approved by whoever asked for it, so two managers
	// are needed for one shutdown and one manager cannot sign their own.
	//
	// Deliberately no fac.safety.close: certifying a fire door repaired
	// is the fire safety officer's act, and a facilities manager under
	// pressure to clear a backlog is exactly the person it should not be.
	RoleFacilitiesManager Role = "facilities_manager"

	// RoleFireSafetyOfficer inspects and signs off life safety
	// (SRS-FAC-008).
	//
	// Holds both fac.safety.raise and fac.safety.close for the same
	// reason the facilities manager holds both outage permissions: the
	// domain refuses a critical finding closed by whoever raised it, so
	// the pair means two officers rather than one doing both.
	//
	// Deliberately no fac.work.close and no fac.permit: the officer says
	// what is wrong and whether it is fixed, and does not run the work.
	RoleFireSafetyOfficer Role = "fire_safety_officer"

	// RolePlantGateway is the integration that reports facility alarms
	// (SRS-FAC-005).
	//
	// A machine account, and it holds exactly one permission. It cannot
	// read the alarms it writes and cannot raise, assign or close work:
	// a gateway that could close a work order is a gateway that will,
	// when somebody restarts it.
	RolePlantGateway Role = "plant_gateway"

	// RoleFleetTelematics is the integration that reports vehicle
	// positions (SRS-AMB-005).
	//
	// A machine account, and it holds exactly one permission. It cannot
	// read the feed it writes: a box that could ask where every ambulance
	// has been is a box somebody can ask.
	RoleFleetTelematics Role = "fleet_telematics"

	// RoleClinicalCoder assigns the codes the hospital is paid and measured
	// on (SRS-MRD-003).
	//
	// Narrow on purpose. A coder reads the chart, assigns codes, sends
	// questions back to the clinician who wrote it, and performs the second
	// read on somebody else's coding — the domain refuses the coder their
	// own, so holding mrd.coding.finalise is how a second coder signs off
	// rather than a way to sign off alone.
	//
	// Deliberately nothing that writes a clinical document, and nothing that
	// resolves a deficiency: a coder who could answer their own query would
	// be writing the clinician's half of SRS-MRD-008.
	RoleClinicalCoder Role = "clinical_coder"

	// RoleClinician reads patient identity in the course of care.
	RoleClinician Role = "clinician"

	// RolePerformingService is a downstream context's service account
	// (SRS-ORD-006).
	//
	// A role rather than an exemption, because a laboratory information system
	// advancing an order is a subject like any other and its actions belong in
	// the same audit trail. Note what it cannot do: place an order. A
	// performing service that could place one could manufacture the work it
	// then bills for.
	RolePerformingService Role = "performing_service"

	// RoleNurse delivers and records nursing care (SRS-NUR, Wave-1 actor
	// "Nurse").
	//
	// A role of its own rather than a variant of clinician, because the two
	// permission sets are genuinely different in both directions. A nurse gives
	// medication and a doctor prescribes it; a nurse charts observations hourly
	// and a doctor rarely does; a doctor records diagnoses and signs clinical
	// documents and a nurse does not. Folding nursing into clinician would give
	// every junior doctor the restraint and administration permissions and
	// every nurse the diagnosis one, and both directions are wrong.
	RoleNurse Role = "nurse"

	// RoleNurseManager runs a ward: assignment and the acuity dashboard
	// (SRS-NUR-016, SRS-NUR-017, Wave-1 actor "Nurse Manager").
	RoleNurseManager Role = "nurse_manager"

	// RoleAnaesthetist assesses, plans, gives and records an anaesthetic, and
	// decides when a patient may leave recovery (SRS-ANE).
	//
	// A role of its own rather than a variant of clinician, and the reason is
	// the two controls only it holds. Discharging a patient from recovery
	// below the agreed score is the decision a complaint is traced back to;
	// transcribing a record from paper after a downtime writes a backdated
	// record by construction. Folding either into the clinician role would
	// give both to every junior doctor in the hospital, and neither belongs
	// to somebody who was not in the theatre.
	RoleAnaesthetist Role = "anaesthetist"

	// RoleBloodBankScientist runs the blood bank: donors, testing, inventory,
	// compatibility and issue (SRS-BLD).
	//
	// A role of its own because the blood bank is a laboratory, not a ward.
	// It groups patients, crossmatches and decides what leaves the fridge, and
	// it does none of the things a clinician does: it does not request blood,
	// and it does not transfuse.
	RoleBloodBankScientist Role = "blood_bank_scientist"

	// RoleBloodBankManager holds the two blood bank decisions a hospital is
	// most answerable for: releasing a donation from quarantine, and
	// authorising an uncrossmatched emergency release (SRS-BLD-004,
	// SRS-BLD-016).
	//
	// Separate from the scientist for the reason every laboratory separates
	// them: release is the step that makes an untested unit givable, and the
	// person who ran the assay should not also be the person who declares it
	// clear. The manager holds the scientist's permissions too — a manager
	// works the bench — so this is an addition rather than a different job.
	RoleBloodBankManager Role = "blood_bank_manager"

	// RoleHaemovigilanceOfficer investigates transfusion reactions and runs
	// look-backs (SRS-BLD-012, SRS-BLD-014, SRS-BLD-015).
	//
	// A role of its own because of what a look-back reaches: every patient who
	// received blood from one donation, across admissions and departments.
	// That is a different kind of access from reading the chart in front of
	// you, and it belongs to somebody whose job is to use it.
	RoleHaemovigilanceOfficer Role = "haemovigilance_officer"

	// RoleSterileTechnician works the CSSD bench: receiving dirty sets,
	// moving them through the stages, assembling against the packing list,
	// running the sterilizer and issuing packs (SRS-CSSD-002 … 009).
	//
	// A role of its own because the department is not a ward and not a
	// laboratory. What it deliberately does not hold is the three decisions
	// below: it cannot skip a reprocessing stage, cannot release a load, and
	// cannot raise a recall.
	RoleSterileTechnician Role = "sterile_technician"

	// RoleSterileSupervisor runs the department and holds the decisions a
	// hospital is answerable for: authorising a skipped stage, releasing a
	// sterilizer load, and raising a recall (SRS-CSSD-003, SRS-CSSD-007,
	// SRS-CSSD-011).
	//
	// Separate from the technician for the reason every department separates
	// them: release is the step that makes an untested pack usable, and the
	// person who ran the load should not also be the person who declares it
	// clear. The supervisor holds the technician's permissions too — a
	// supervisor works the bench — so this is an addition rather than a
	// different job.
	RoleSterileSupervisor Role = "sterile_supervisor"

	// RoleStorekeeper works the stores: receiving deliveries, issuing to
	// departments, moving stock between stores and counting shelves
	// (SRS-MAT-005, SRS-MAT-008, SRS-MAT-010, SRS-MAT-011).
	//
	// What it deliberately does not hold is the four decisions below. A
	// storekeeper who could accept their own delivery out of quarantine,
	// approve the adjustment from their own count, and block a lot would be
	// the only check on the stores, and there would be none.
	RoleStorekeeper Role = "storekeeper"

	// RoleMaterialsManager runs the stores and holds the controls a hospital
	// is answerable for: accepting stock out of quarantine, approving a
	// count's adjustment, and blocking a lot (SRS-MAT-006, SRS-MAT-011,
	// SRS-MAT-013).
	//
	// Separate from the storekeeper for the reason every stores function
	// separates them: the person who counted the shelf should not be the
	// person who signs off what the count changed. The manager holds the
	// storekeeper's permissions too — a manager works the counter — so this
	// is an addition rather than a different job.
	RoleMaterialsManager Role = "materials_manager"

	// RoleBuyer runs procurement: quotations, comparison, purchase orders and
	// their amendments, and the three-way match (SRS-MAT-003, SRS-MAT-004,
	// SRS-MAT-014).
	//
	// A role of its own because of the oldest separation in purchasing: the
	// person who commits the hospital's money should not also be the person
	// who receives the goods and confirms they arrived. A buyer never touches
	// the ledger.
	RoleBuyer Role = "buyer"

	// RoleQualityOfficer runs the quality system day to day: incidents, root
	// cause analysis, corrective actions, internal audits, the accreditation
	// evidence map, the indicator dictionary and complaints (SRS-QMS-001 …
	// 011, SRS-QMS-014).
	//
	// A role of its own because quality is not a clinical function and not an
	// administrative one. What it deliberately does not hold is the five
	// decisions below: it cannot read restricted material, approve a
	// corrective action, approve a document version, sit on a peer review, or
	// place a legal hold.
	RoleQualityOfficer Role = "quality_officer"

	// RoleQualityManager runs the department and holds the decisions the
	// hospital is answerable for: reading restricted material, approving a
	// corrective action, approving a controlled document, and placing a legal
	// hold (SRS-QMS-004, SRS-QMS-005, SRS-QMS-006, SRS-QMS-015).
	//
	// Separate from the officer for the reason every quality function
	// separates them: approving a corrective action and closing it are the two
	// ends the separation of duties is at, and the person who raised it should
	// not also be the person who signs it off. The manager holds the officer's
	// permissions too — a manager works the caseload — so this is an addition
	// rather than a different job.
	//
	// Deliberately no qms.peerreview.conduct: reading a committee's
	// conclusions and sitting on the committee are different things, and a
	// mortality review belongs to clinicians.
	RoleQualityManager Role = "quality_manager"

	// RolePeerReviewer sits on the mortality and morbidity committee
	// (SRS-QMS-012).
	//
	// Its own role and nothing else, because peer review is the narrowest
	// access in this system: a discussion between clinicians about whether a
	// colleague's care was adequate, which only happens honestly if it is not
	// readable by everybody with a clinical login. Every read under it is
	// audited.
	RolePeerReviewer Role = "peer_reviewer"

	// RoleInfectionControlNurse runs surveillance, isolation, outbreak
	// investigation, hand hygiene audit and environmental sampling
	// (SRS-IPC-001 … 003, SRS-IPC-005, SRS-IPC-006, SRS-IPC-009).
	//
	// A role of its own because infection control is neither a ward function
	// nor a laboratory one: it counts the hospital's own harms and reports
	// them. What it deliberately does not hold is the four decisions below —
	// it cannot override an onset classification, approve a rule, read an
	// occupational exposure, or sign off an environmental corrective action.
	RoleInfectionControlNurse Role = "infection_control_nurse"

	// RoleInfectionControlLead holds the decisions the hospital's reported
	// infection rates depend on: overriding a derived onset classification,
	// and putting an alert rule, a stewardship trigger or an environmental
	// limit in force (SRS-IPC-001, SRS-IPC-004, SRS-IPC-008, SRS-IPC-009).
	//
	// Separate from the practitioner because of what an override does: a
	// healthcare-associated infection reclassified as community-acquired
	// leaves the rate entirely, and that decision should sit with the person
	// answerable for the rate. The lead holds the practitioner's permissions
	// too — a lead works the caseload — so this is an addition rather than a
	// different job.
	//
	// Holding both ipc.rule.write and ipc.rule.approve is necessary and not
	// sufficient: the domain and the database each refuse a rule approved by
	// its own author, whoever they are.
	//
	// Deliberately no ipc.exposure.manage: a staff health record belongs to
	// occupational health, and no ipc.stewardship.respond, because answering
	// stewardship advice is a prescriber's decision.
	RoleInfectionControlLead Role = "infection_control_lead"

	// RoleOccupationalHealth works staff exposure records and their
	// time-sensitive follow-up (SRS-IPC-007).
	//
	// Its own role and almost nothing else, because these are health records
	// about members of staff held by their employer, with a source patient's
	// serology attached. Every read under it is audited. A hospital whose
	// exposure records are readable by the ward is a hospital whose staff
	// stop reporting exposures, and an unreported needlestick is an untreated
	// one.
	RoleOccupationalHealth Role = "occupational_health"

	// RoleBiomedicalEngineer maintains the equipment: the register, the
	// maintenance schedules, the service work and the device telemetry
	// (SRS-BIO-001, SRS-BIO-003, SRS-BIO-005, SRS-BIO-006, SRS-BIO-010).
	//
	// A role of its own because the department is not a ward and not a store.
	// What it deliberately does not hold is the four decisions below: it
	// cannot validate its own repair, cannot record a calibration, cannot run
	// a recall, and cannot dispose of an asset.
	RoleBiomedicalEngineer Role = "biomedical_engineer"

	// RoleBiomedicalManager runs the department and holds the decisions a
	// hospital is answerable for: validating a repair, recording a
	// calibration, running a recall, and disposing of an asset (SRS-BIO-004,
	// SRS-BIO-006, SRS-BIO-008, SRS-BIO-011).
	//
	// Separate from the engineer for the reason every engineering function
	// separates them: closing a ticket is the validation, and the person who
	// made the repair should not be the person who declares it good. The
	// manager holds the engineer's permissions too — a manager works the
	// bench — so this is an addition rather than a different job.
	//
	// Holding bio.ticket.close is necessary and not sufficient: the domain
	// refuses the engineer who did the work whoever they are, so a manager who
	// fixed a machine still cannot sign it off.
	RoleBiomedicalManager Role = "biomedical_manager"

	// RolePharmacist verifies prescriptions and dispenses (SRS-MED-006,
	// SRS-MED-011, Wave-1 actor "Pharmacist").
	//
	// A role of its own, and the reason is the one control it holds: a
	// pharmacist verifying a prescription is a second person reading it. Folding
	// verification into the clinician role would give the prescriber the
	// permission to verify their own work, and while the domain refuses a
	// self-verification anyway, a permission model that has to be rescued by an
	// aggregate invariant is a permission model that will be wrong somewhere
	// else too.
	RolePharmacist Role = "pharmacist"

	// RoleBillingClerk raises charges, builds invoices and works the
	// revenue-integrity list (SRS-BIL, Wave-1 actor "Billing User").
	RoleBillingClerk Role = "billing_clerk"

	// RoleCashier takes money and reconciles a drawer (SRS-BIL-008,
	// SRS-BIL-015, Wave-1 actor "Cashier").
	//
	// A role of its own rather than a variant of the billing clerk, and the
	// reason is the oldest control in finance: the person who decides what is
	// owed should not be the person who collects it. A cashier takes payments
	// and cannot raise a charge, apply a concession or issue a refund
	// unapproved.
	RoleCashier Role = "cashier"

	// RoleFinanceAdmin maintains the charge master, the tariffs, the packages
	// and the policy, and approves what exceeds a clerk's limit (SRS-BIL-001,
	// SRS-BIL-002, SRS-BIL-007, Wave-1 actor "Finance Admin").
	RoleFinanceAdmin Role = "finance_admin"

	// RoleScheduler runs the diary: rosters, leave, theatre blocks, and the
	// authority to book into a provisional block when the list is agreed
	// (SRS-SCH-002). The Wave-1 backlog actor is "Scheduler".
	RoleScheduler Role = "scheduler"
)

// rolePermissions is the catalogue. A role absent from this table grants
// nothing, which keeps an unknown or retired role fail-closed.
var rolePermissions = map[Role][]string{
	RolePlatformOperator: {
		"organization.tenant.create",
		"organization.tenant.read",
	},
	RoleTenantAdmin: {
		"organization.tenant.read",
		"organization.facility.create",
		"organization.facility.read",
		// The hierarchy below a facility: wards, departments, specialties and
		// cost centres (SRS-PLT-005, SRS-PLT-002). The use case existed and
		// was checked, but no role held the permission, so nothing could
		// reach it — a ward could only be created by writing to the database.
		"organization.unit.manage",
		// Commissioning the estate: accommodation classes, rooms and beds,
		// and retiring a bed out of it (SRS-PLT-006). Note what is absent:
		// no organization.bed.state. Deciding what beds a hospital has is
		// estate work; moving one in and out of use is ward work, and a role
		// that held both would let an administrator block a bed without the
		// ward knowing and a ward lose one permanently.
		"organization.bed_master.manage",
		"organization.bed.read",
		// Configuring the demographic minimum set and the duplicate-matching
		// thresholds is tenant administration. Note what is absent: no
		// empi.patient.read. Tuning how the register behaves and looking
		// inside it are different jobs, and bundling them would put every
		// tenant admin in the patient index.
		"empi.patient.configure",
		// Note templates, shared smart phrases and the escalation policy are
		// configuration (SRS-CLN-002, SRS-CLN-012, SRS-CLN-015). Note what is
		// absent: no cln.record.read. Deciding what a note asks and reading
		// what it says are different jobs.
		"cln.record.configure",
		// Order sets, the order policy and the duplicate rules (SRS-ORD-003,
		// SRS-ORD-007, SRS-ORD-009). Institutional governance, and again not
		// bundled with reading the orders themselves: deciding what a set
		// offers and looking at who was ordered what are different jobs.
		"ord.order.configure",
		// The formulary, the interaction and dose-support rules, the
		// terminology map and the override ceiling (SRS-MED-003, SRS-MED-004,
		// SRS-MED-010, SRS-MED-012). Not with the prescriber, deliberately: a
		// clinician who could edit the rule that is warning them has not been
		// warned.
		"med.catalogue.configure",
		// Assessment templates, risk scales, the administration policy and the
		// acuity weights (SRS-NUR-001, SRS-NUR-005, SRS-NUR-008, SRS-NUR-016).
		// Note what is absent again: no nur.record.read. Deciding what a ward
		// measures and reading what it measured are different jobs.
		"nur.record.configure",
		// Rosters are tenant administration for the same reason: deciding when
		// a clinic runs is configuration, and it is deliberately not bundled
		// with the ability to look inside the diary at who is coming.
		"sch.schedule.configure",
		// What a facility requires before an encounter can be closed
		// (SRS-ENC-008). Configuration, and again not bundled with reading the
		// encounters themselves.
		"enc.encounter.configure",
	},
	RoleScheduler: {
		"organization.facility.read",
		"empi.patient.read",
		"sch.schedule.configure",
		"sch.schedule.read",
		"sch.appointment.book",
		"sch.appointment.manage",
		// Booking into a provisional block, which is what a scheduler does
		// when a theatre list is agreed. It never reaches annual leave: that
		// block is not overridable at all, whoever asks.
		"sch.schedule.override",

		// The operating theatre's list (SRS-OT-001, SRS-OT-004). Rooms,
		// blocks, preference cards and the booking itself.
		"ot.case.read",
		"ot.case.schedule",
		"ot.case.cancel",
		"ot.theatre.configure",
		// Booking into a slot with a soft conflict — a room without a piece of
		// equipment that can be wheeled in (SRS-OT-004). Its own permission
		// and a mandatory reason, because a list that overran is traced back
		// to this decision. It never reaches a hard conflict: another case in
		// the room, or a surgeon already operating, is refused whoever asks.
		"ot.schedule.override",
		// Deliberately no ot.case.record and no ot.preop.waive: a scheduler
		// builds the list and does not record what happened in the room.
	},
	RoleFacilityViewer: {
		"organization.facility.read",
	},
	RoleAuditor: {
		"platform.audit.read",
		"organization.tenant.read",
		"organization.facility.read",
	},

	// A clerk registers, searches and corrects. Deliberately no merge: merging
	// fuses two people's records, and the person who created a duplicate at a
	// busy desk is the last one who should resolve it unreviewed.
	//
	// Also no read_restricted. A clerk comparing duplicates sees a masked
	// candidate — enough to confirm the phone number the patient just read out,
	// not enough to use the screen as a directory (SRS-EMPI-003).
	RoleRegistrationClerk: {
		"empi.patient.create",
		"empi.patient.read",
		"empi.patient.update",
		"empi.patient.manage",
		"organization.facility.read",
		// The front desk books, reschedules and checks patients in. It does
		// not define rosters: a receptionist who could rewrite the clinic's
		// availability is one mis-click from a clinician's Tuesday vanishing.
		"sch.schedule.read",
		"sch.appointment.book",
		"sch.appointment.manage",
		// The desk opens the visit when the patient arrives and reads the list
		// of who is in. It never records a diagnosis: what is wrong with the
		// patient is a clinical act, and behind one permission every
		// receptionist could enter one under their own name.
		"enc.encounter.read",
		"enc.encounter.manage",
		// Typing a dictated note is data entry, and a ward clerk does it.
		// Signing it is not: that is the clinician's assertion, and it is a
		// separate permission the desk does not hold (SRS-CLN-009).
		//
		// Deliberately no cln.record.read: a clerk who could read the chart
		// would have the whole clinical record of every patient they book.
		"cln.record.write",
		// The emergency desk books an arrival and sees who is in the
		// department (SRS-ER-001). Deliberately no er.triage.assign: deciding
		// how sick somebody is, is the triage nurse's assessment, and a
		// receptionist holding it is how a chest pain waits behind a sprain.
		"er.visit.read",
		"er.visit.write",
	},

	// HIM resolves identities. They hold merge and unrestricted read, because
	// deciding whether two records are one person needs the unmasked detail
	// that a clerk is deliberately denied.
	RoleHIMOfficer: {
		// Running a recall or an infection investigation (SRS-OT-010,
		// SRS-OT-012). Its own permission because it reaches every patient who
		// received an item rather than one chart, and it sits with HIM for the
		// same reason merge does: the people whose job is to reason across
		// records rather than to treat one patient. Every search is audited
		// with the item and how many patients it reached.
		"ot.trace.read",
		"empi.patient.read",
		"empi.patient.read_restricted",
		"empi.patient.update",
		"empi.patient.manage",
		"empi.patient.merge",
		"organization.facility.read",
		// Marking an order entered-in-error (SRS-ORD-005). Health information
		// management's, not the ward's: saying a record was never true is a
		// statement about the record rather than about the patient, and it is
		// the same authority that resolves a merge.
		"ord.order.read",
		"ord.order.retract",

		// Medical records and health information management (SRS-MRD-002,
		// SRS-MRD-004, SRS-MRD-006, SRS-MRD-009, SRS-MRD-010).
		"mrd.record.read",
		"mrd.deficiency.manage",
		"mrd.release.request",
		"mrd.release.assemble",
		"mrd.disclosure.read",
		"mrd.physical.manage",
		"mrd.disposition.prepare",
		// Preparing a list and carrying it out, with somebody else's approval
		// in between. That is the two-person control the requirement asks
		// for, and it is why this role holds the shredding and not the
		// signature.
		"mrd.disposition.execute",
		// Deliberately no mrd.deficiency.waive: a waiver is the one way a
		// chart leaves the worklist without the document ever arriving, and
		// the office that chases the worklist should not be able to empty it.
		//
		// Deliberately no mrd.release.approve and no
		// mrd.disposition.approve: this role requests the release and
		// prepares the list.
		//
		// Deliberately no mrd.hold.manage: a hold is what stops a
		// destruction, and the person running the destruction should not be
		// able to lift one.
		//
		// Deliberately no mrd.coding.write: coding is a coder's.
	},

	// A clinician reads identity to confirm they have the right patient in
	// front of them, unmasked, and does not administer it.
	RoleClinician: {
		"empi.patient.read",
		"empi.patient.read_restricted",
		"organization.facility.read",
		// A clinician reads their own diary and drives the queue in front of
		// them — calling the next patient in, ending a consultation. They do
		// not book: that is the desk's job and the patient's.
		"sch.schedule.read",
		"sch.appointment.manage",
		// Reprioritising a queue on medical grounds is theirs alone
		// (SRS-SCH-011), and a correction to a status recorded in error is a
		// clinical judgement about what actually happened.
		"sch.appointment.correct",
		// The consultation itself: run the encounter, record what is wrong,
		// and close it with a summary.
		"enc.encounter.read",
		"enc.encounter.manage",
		"enc.diagnosis.record",
		"enc.encounter.close",
		// Closing over an incomplete record where policy allows it
		// (SRS-ENC-008). A separate permission so a hospital can withhold it
		// from junior staff, but the control that actually bites is the
		// mandatory reason and the report it feeds: an emergency department
		// that cannot close a resuscitation until the notes are perfect will
		// leave it open, and an open encounter reads as a patient still under
		// care.
		"enc.encounter.override",
		// Restricted clinical entries — mental health, sexual health,
		// safeguarding (SRS-CLN-019). A clinician treating the patient needs
		// them; the read is separately audited every time.
		"enc.restricted.read",

		// Ambulance (SRS-AMB-004, SRS-AMB-007). The receiving clinician
		// takes the patient at the door, which is the moment
		// responsibility moves and the crew's account attaches to the
		// encounter. Reading that account is the point of it: it says
		// what the patient was given on the way in.
		"amb.prehospital.read",
		"amb.handover.accept",
		"amb.read",
		"amb.request",

		// The clinical record: write it, sign it, read it back.
		"cln.record.read",
		"cln.record.write",
		// Signing asserts clinical responsibility rather than data entry
		// (SRS-CLN-009). A ward clerk typing a dictated note saves the draft
		// and must not be able to finalise it.
		"cln.document.sign",
		"cln.record.read_restricted",
		// Acknowledging a critical result means somebody has taken clinical
		// action (SRS-CLN-012). A permission the whole hospital held would let
		// the desk clear the safety worklist by clicking through it.
		"cln.result.acknowledge",

		// Orders (SRS-ORD). Placing is the clinical act the whole CPOE
		// framework exists to record, and cancelling one's own mistake comes
		// with it.
		"ord.order.read",
		"ord.order.place",
		"ord.order.cancel",
		// Blood products are gated separately (SRS-ORD-002's requester
		// privilege): a unit of blood is traced unit by unit, and a hospital
		// that wants the authority restricted to senior staff must be able to
		// say so. Granted here because a consultant is who orders one; a
		// tenant that disagrees withholds it from the role.
		"ord.blood_product.order",

		// Prescribing, and changing what was prescribed (SRS-MED-001,
		// SRS-MED-013). Reconciliation is here too: deciding what a patient
		// continues on admission is a prescribing decision made about
		// medications somebody else started.
		"med.prescription.read",
		"med.prescription.write",
		"med.prescription.change",
		"med.reconciliation.perform",
		// Answering a safety warning (SRS-MED-003). Granted to clinicians and
		// separable from prescribing on purpose: a hospital that wants junior
		// staff to escalate rather than click through an interaction alert
		// withholds this one and keeps the rest.
		"med.safety.override",
		// Deliberately no med.prescription.verify: that is the pharmacist's
		// second reading, and a prescriber who held it could verify their own
		// prescription.

		// Nursing content is readable by the medical team — a ward round is
		// read from the flowsheet — but a doctor does not chart observations,
		// give medication or apply restraints, so only the read is here.
		"nur.record.read",

		// The emergency department (SRS-ER). An ED physician runs the visit,
		// calls the trauma, stroke or STEMI team, and decides where the
		// patient goes.
		"er.visit.read",
		"er.visit.write",
		"er.pathway.activate",
		// Disposition is the decision to admit, discharge or transfer
		// (SRS-ER-013), and it is a medical one.
		"er.visit.dispose",
		// Moving a patient up the queue overrules the triage nurse's
		// assessment (SRS-ER-003). Held by the doctor who has seen the
		// patient, and by the charge nurse running the floor; not by everyone
		// who may record a dressing change.
		"er.queue.override",
		// A medico-legal case's detail — the assault, the poisoning, the
		// police reference (SRS-ER-011). The read is separately audited every
		// time.
		"er.visit.read_restricted",
		// Deliberately no er.triage.assign: triage is a nursing assessment
		// against a published scale, and a department where anybody may
		// restate an acuity has no scale.

		// Critical care (SRS-ICU). An intensivist admits, charts, runs organ
		// support, calculates the scores and decides when the patient can go.
		"icu.episode.read",
		"icu.episode.write",
		"icu.episode.discharge",
		// Agreeing a ceiling of treatment is SRS-ICU-015's "restricted
		// authorization" (SRS-ICU-015). Held by the medical team, and the
		// record names the senior clinician who authorised it separately from
		// whoever typed it.
		"icu.ceiling.set",
		"icu.ceiling.read",
		// Deliberately no icu.reading.validate: deciding whether a monitor's
		// reading is real is a bedside judgement made by the person who can
		// see the patient and the probe, and a doctor confirming a saturation
		// from the doctors' office is confirming a number rather than a
		// patient.

		// The operating theatre (SRS-OT). A surgeon raises the request,
		// changes its priority, records what was done and signs it.
		"ot.case.read",
		"ot.case.request",
		"ot.case.reprioritise",
		"ot.case.cancel",
		"ot.case.record",
		// Signing the operative note asserts clinical responsibility for what
		// was done (SRS-OT-009). A separate permission from writing it, so a
		// scribe typing a dictated note cannot finalise it — the same split
		// SRS-CLN-009 makes for a clinical document.
		"ot.note.sign",
		// Waiving a pre-operative blocker (SRS-OT-006). The domain still
		// checks the role against the item, so this grants the ability to
		// waive the surgeon's items and nothing else; consent and site marking
		// are unwaivable by anybody.
		"ot.preop.waive",
		// Deliberately no ot.case.schedule: building a list is the
		// scheduler's job, and a surgeon who could book their own cases is a
		// surgeon whose list nobody else can plan around.

		// Anaesthesia (SRS-ANE). A surgeon reads the assessment, the plan and
		// the summary of an anaesthetic given to their patient.
		"ane.record.read",
		// And the airway history, which is the one fact worth reaching across
		// admissions for: a difficult airway discovered twice is a difficult
		// airway that was recorded and not read.
		"ane.history.read",
		// Deliberately nothing that writes: assessing, planning and charting
		// an anaesthetic are the anaesthetist's, and a surgeon who could
		// record the assessment could declare their own patient fit.

		// The blood bank (SRS-BLD). A clinician asks for blood, reads what is
		// happening to their patient, and reports a reaction.
		"bld.record.read",
		"bld.request.place",
		"bld.reaction.write",
		// Deliberately no bld.crossmatch.write, no bld.issue.write and no
		// bld.component.release: deciding what leaves the fridge is the
		// laboratory's, and a clinician who could crossmatch their own
		// patient's blood would be both the request and the check on it.

		// Infection control (SRS-IPC). A doctor reads the bed board to know
		// what to wear, answers an MDRO alert on a patient they have
		// assessed, records what they did about stewardship advice, and
		// reports their own needlestick.
		"ipc.board.read",
		"ipc.alert.override",
		"ipc.stewardship.respond",
		"ipc.exposure.report",
		// Deliberately no ipc.case.write and no ipc.onset.override: a
		// surveillance case is counted against the hospital, and a clinician
		// who could reclassify an infection acquired on their own ward would
		// be marking their own homework.

		// Medical records (SRS-MRD-002, SRS-MRD-007, SRS-MRD-008). A doctor
		// answers the deficiencies raised against their own documentation
		// and signs the statutory certificates a jurisdiction lets a
		// registered practitioner sign.
		"mrd.record.read",
		"mrd.deficiency.resolve",
		"mrd.certificate.issue",
		// Deliberately no mrd.deficiency.waive: waiving the deficiency
		// raised against your own discharge summary is marking your own
		// homework, and it is the fastest way to a completion figure that
		// means nothing.
		//
		// Deliberately no mrd.certificate.void: withdrawing a certificate
		// that has gone to a family and a registrar is the records office's
		// decision, not the signer's.

		// Dietetics (SRS-DIET-002, SRS-DIET-003, SRS-DIET-007). A doctor
		// makes a patient nil by mouth for theatre, decides whether a
		// documented allergy applies to a particular food, and confirms the
		// order a nutrition support plan runs against.
		"diet.record.read",
		"diet.order.write",
		"diet.conflict.resolve",
		"diet.support.link",
		// Deliberately nothing in the kitchen's work: a clinician who could
		// dispatch a tray could send the meal they ordered without the
		// dispatch check being made by anybody else.
	},

	// A pharmacist checks what was prescribed and decides what is dispensed
	// (SRS-MED-006, SRS-MED-011, SRS-MED-012).
	RolePharmacist: {
		"empi.patient.read",
		"enc.encounter.read",
		// The pharmacy worklist is an order worklist.
		"ord.order.read",
		// Reading the whole drug chart, because verifying one prescription
		// against the patient's other medications is the job.
		"med.prescription.read",
		"med.prescription.verify",
		"med.substitution.record",
		// Deliberately no med.prescription.write and no
		// med.prescription.change: a pharmacist who disagrees with a
		// prescription proposes a substitution or telephones the prescriber,
		// and both leave a record naming who decided. A pharmacist who could
		// edit the prescription would leave the chart saying the doctor chose
		// something they never saw.
		//
		// And no med.safety.override: the warning is shown to the prescriber,
		// and a pharmacist answering it would be answering on their behalf.

		// Antimicrobial stewardship (SRS-IPC-008). The review is a
		// pharmacist's job and the recommendation is all it produces.
		// Deliberately no ipc.stewardship.respond: the whole requirement is
		// that the team advises and somebody with prescribing authority
		// decides, and a programme that could record acceptance of its own
		// advice would be writing the one number it is judged on.
		"ipc.record.read",
		"ipc.stewardship.review",
	},

	// A billing user works out what is owed (SRS-BIL-003, SRS-BIL-006,
	// SRS-BIL-007, SRS-BIL-011, SRS-BIL-013).
	RoleBillingClerk: {
		"empi.patient.read",
		"enc.encounter.read",
		"bil.account.read",
		"bil.charge.post",
		"bil.charge.manual",
		"bil.invoice.issue",
		"bil.discount.apply",
		"bil.account.close",
		// Deliberately no bil.payment.receive and no bil.refund.issue: the
		// person who decides what is owed should not be the person who collects
		// it, which is the oldest control in finance and the one a small
		// hospital is most tempted to collapse.
		//
		// And no bil.discount.approve: a limit a person can approve for
		// themselves is not a limit.
		//
		// And no bil.catalogue.configure: a clerk who could edit the tariff
		// could decide what they invoice.
	},

	// A cashier takes money and reconciles a drawer (SRS-BIL-008,
	// SRS-BIL-015).
	RoleCashier: {
		"empi.patient.read",
		"bil.account.read",
		"bil.payment.receive",
		"bil.shift.manage",
		// Deliberately no bil.charge.post: a cashier who could raise a charge
		// could raise one against the money they are holding. And no
		// bil.refund.issue: money leaving needs a second person, which is what
		// makes a refund different from a payment.
	},

	// Finance decides what things cost and signs off what exceeds a limit
	// (SRS-BIL-001, SRS-BIL-002, SRS-BIL-007, SRS-BIL-009, SRS-BIL-015).
	RoleFinanceAdmin: {
		// The top of a materials approval route: anything over the threshold
		// a hospital sets also needs finance (SRS-MAT-002). Reading the
		// requisition is part of deciding it.
		"mat.record.read",
		"mat.requisition.approve",
		"bil.account.read",
		"bil.catalogue.configure",
		"bil.discount.approve",
		// Refunds sit here rather than with the cashier, so money leaving
		// carries a second name (SRS-BIL-009).
		"bil.refund.issue",
		"bil.shift.approve",
		// Deliberately no bil.charge.post, no bil.invoice.issue and no
		// bil.payment.receive: the role that sets the prices does not also
		// raise the bills or take the money.
	},

	// A nurse delivers care. Note what is absent: no cln.document.sign and no
	// enc.diagnosis.record. Signing a clinical document and recording a
	// diagnosis are the medical team's assertions, and a nurse writing a
	// nursing note does neither.
	RoleNurse: {
		"empi.patient.read",
		// Nursing happens inside an encounter and needs to know it is open.
		"enc.encounter.read",
		// Anybody who can see a leak should be able to report it
		// (SRS-FAC-002). Held very widely, which is why the work order
		// records impact and priority rather than assuming them.
		"fac.read",
		"fac.work.raise",
		// The nursing note is a clinical document; writing one is nursing work
		// and signing it is not the same act (SRS-CLN-009).
		"cln.record.read",
		"cln.record.write",
		// A nurse takes the observations a critical result is acted on by, and
		// acknowledging one means somebody has taken clinical action
		// (SRS-CLN-012).
		"cln.result.acknowledge",

		// A nurse reads the order list — it is what the ward round works
		// from — and does not place orders. Deliberately no ord.order.place:
		// a nurse taking a verbal order records it under the doctor's name
		// through the entered-by field, which keeps who is answerable separate
		// from who typed it.
		"ord.order.read",
		// The drug chart, which is what a medication round is worked from
		// (SRS-NUR-007). Read only: a nurse gives what was prescribed and does
		// not prescribe, hold or discontinue it.
		"med.prescription.read",

		"nur.record.read",
		"nur.record.write",
		// Giving a drug is the act the whole eMAR exists to record
		// (SRS-NUR-009). Its own permission, so the ward clerk who transcribes
		// a note cannot chart a dose under their own name.
		"nur.medication.administer",
		// Completing an administration past a failed barcode check
		// (SRS-NUR-008). Granted, because a scanner breaks at 03:00 and a
		// medication round that stops is worse than one that is documented;
		// the control that bites is the mandatory reason and the stored report,
		// not scarcity of the permission.
		"nur.medication.override",
		// The ward's own beds: seeing the board and moving a bed in and out of
		// use (SRS-PLT-006). Not organization.bed_master.manage — a nurse who
		// could retire a bed could lose one permanently by reaching for the
		// wrong control, and what a hospital owns is not a ward decision.
		"organization.bed.read",
		"organization.bed.state",
		// A restraint is a nursing act carried out under a clinician's
		// authorization, and the authorization is checked in the record
		// rather than in the permission (SRS-NUR-013). Transfusion is not
		// here: it is bld.transfusion.write below, granted to this same role,
		// because the transfusion record lives in the blood bank
		// (SRS-NUR-014, migration 0047).
		"nur.restraint.manage",
		// Declaring downtime and reconciling the paper chart afterwards is the
		// ward's job, and the ward is who knows the system has gone
		// (SRS-NUR-018).
		"nur.downtime.manage",

		// Reporting a broken machine (SRS-BIO-005). Granted because the person
		// who finds one is whoever was using it, and a ward that has to ask
		// somebody else to raise the ticket is a ward that writes it on a
		// sticky note instead. Read alongside it, so the nurse can see the
		// asset they are reporting and whether it is already held.
		// Deliberately nothing else: a nurse does not close the repair,
		// calibrate the machine, or lift a safety hold.
		"bio.record.read",
		"bio.ticket.raise",

		// Reporting an incident or near miss, and confirming a policy has
		// been read (SRS-QMS-001, SRS-QMS-006). Both held as widely as any
		// permission in this system: a reporting system only the quality
		// department can write to receives nothing, and an acknowledgement
		// somebody else can give on your behalf is not an acknowledgement.
		// Deliberately nothing else: a nurse does not score, close or
		// restrict what they reported.
		"qms.incident.report",
		"qms.document.acknowledge",

		// The emergency department (SRS-ER). Triage is nursing work and this
		// is the role that holds it: a nurse assigns acuity against the
		// department's published scale (SRS-ER-002), records the timeline, and
		// activates a pathway — a triage nurse who recognises a stroke calls
		// the team rather than waiting to be given permission (SRS-ER-005).
		"er.visit.read",
		"er.visit.write",
		"er.triage.assign",
		"er.pathway.activate",
		// Deliberately no er.visit.dispose: whether a patient is admitted,
		// discharged or transferred is a medical decision, and a nurse who
		// held it could discharge a patient nobody had seen.

		// Critical care (SRS-ICU). The bedside nurse charts the flowsheet,
		// titrates the infusions, records the lines and runs the bundles.
		"icu.episode.read",
		"icu.episode.write",
		// Validating a device reading into the chart (SRS-ICU-003) is the
		// nurse's, and deliberately only the nurse's: deciding whether a
		// saturation of 60% is the patient or the probe needs somebody who can
		// see both.
		"icu.reading.validate",
		// A nurse has to know the patient is not for CPR. Reading a ceiling is
		// separate from agreeing one, and deliberately wider.
		"icu.ceiling.read",
		// Deliberately no icu.episode.discharge and no icu.ceiling.set: when a
		// patient leaves critical care and how far treatment goes are both
		// medical decisions.

		// The operating theatre (SRS-OT). The scrub and circulating nurses run
		// the checklists, time the patient's movement, scan the consumables
		// and implants, label the specimens and open the sets.
		"ot.case.read",
		"ot.case.record",
		// Deliberately no ot.note.sign: the operative note is the surgeon's
		// assertion about what they did.
		//
		// And deliberately no ot.preop.waive: a nurse who found a blocker
		// escalates it to the surgeon or the anaesthetist, which is what the
		// per-item role check exists to make happen.

		// Recovery (SRS-ANE-008). The recovery nurse scores the patient and
		// discharges one who meets the agreed bar.
		"ane.record.read",
		"ane.recovery.write",
		// Deliberately no ane.recovery.override: a patient below the score
		// leaves recovery on an anaesthetist's decision, which is the whole
		// point of having a bar. And deliberately no ane.record.import: a
		// record transcribed from paper is backdated by construction, and it
		// is signed by the person who gave the anaesthetic.

		// Transfusion (SRS-BLD-010, SRS-BLD-011, SRS-BLD-012). The bedside
		// check, the transfusion, its observations, and reporting a reaction.
		"bld.record.read",
		"bld.transfusion.write",
		"bld.reaction.write",
		// Deliberately no bld.issue.write: a nurse collects a unit from the
		// bank, and the person who releases it is on the other side of the
		// counter. That counter is the second check.

		// Infection control (SRS-IPC). The bed board says what to wear
		// outside a bay and never why the patient is in it; the device
		// census is a count somebody takes at the bedside, and a rate whose
		// denominator was estimated is a rate that moves when somebody
		// changes their estimate; hand hygiene observation is ward work; and
		// reporting a needlestick has to be as easy as this or it does not
		// happen.
		"ipc.board.read",
		"ipc.denominator.record",
		"ipc.hygiene.observe",
		"ipc.exposure.report",
		// Deliberately no ipc.case.write, no ipc.isolation.write and no
		// ipc.alert.override: placing and lifting precautions is an infection
		// control decision, and an alert a ward could dismiss is an alert.

		// Medical records (SRS-MRD-002, SRS-MRD-008). A nursing note that
		// nobody signed is a chart deficiency owned by the nurse who wrote
		// it, and the person who answers it is that nurse.
		"mrd.record.read",
		"mrd.deficiency.resolve",

		// Dietetics (SRS-DIET-006). The last few metres of a meal are a
		// nurse's: delivering the tray, and recording the ones the patient
		// refused or never got. A patient who has missed three meals has not
		// eaten for a day, and the ward is where that is noticed.
		"diet.record.read",
		"diet.service.read",
		"diet.write",
		// Deliberately no mrd.deficiency.waive, for the same reason a
		// clinician does not hold it.

		// Laundry (SRS-LND-002, SRS-LND-004, SRS-LND-006). The ward counts
		// and bags its own soiled linen — for infected linen that count is
		// made at the bedside and never made again — signs for what comes
		// back, and reports what is torn or missing. Deliberately no
		// lnd.wash and no lnd.issue: a ward that could sign a delivery it
		// also issued is a ward whose linen always arrives.
		"lnd.read",
		"lnd.collect",
		"lnd.receive",
		"lnd.loss.report",
		"lnd.track.scan",

		// Ambulance (SRS-AMB-001). The ward books the transfer and the
		// discharge transport, and watches the queue it put the patient
		// in. Deliberately no amb.dispatch: a ward that could send the
		// vehicle to its own call is a ward whose patients always go
		// first.
		"amb.read",
		"amb.request",

		// Housekeeping (SRS-HKP-003, SRS-HKP-006). The ward is where a
		// discharge happens and where a spill is found, so a nurse triggers
		// the terminal clean that takes the bed out of service and calls the
		// clean for the spill. Reading the board comes with it: the nurse
		// about to admit somebody needs to know whether the bed is clear.
		"hkp.read",
		"hkp.task.raise",
		"hkp.bed.hold",
		// Deliberately no hkp.bed.override: the nurse holding the bed is the
		// one under pressure to release it, and releasing it uncleaned is a
		// decision the ward manager makes and the system escalates.
		//
		// Deliberately no hkp.task.work and no hkp.task.verify: a ward that
		// could close its own cleaning tasks is a ward whose compliance
		// figure means nothing.
	},

	// An anaesthetist assesses, plans, gives and records the anaesthetic, and
	// decides when the patient may leave recovery (SRS-ANE).
	RoleAnaesthetist: {
		"ane.record.read",
		"ane.assessment.write",
		"ane.plan.write",
		"ane.record.chart",
		"ane.recovery.write",
		// Discharging a patient who does not meet the bar. The domain still
		// requires a reason, and refuses it outright for a patient nobody has
		// handed over: the override exists for one who is clinically ready and
		// scores below a threshold, not for one nobody has taken
		// responsibility for.
		"ane.recovery.override",
		"ane.pain.write",
		// Transcribing a record made on paper during a downtime
		// (SRS-ANE-011). Backdated by construction, which is why it is a
		// permission of its own rather than part of charting.
		"ane.record.import",
		"ane.history.read",

		// The theatre case the anaesthetic hangs off (SRS-OT). An
		// anaesthetist reads the list, records against the case — the
		// anaesthetic entries on the checklists are theirs — and may
		// postpone one.
		"ot.case.read",
		"ot.case.record",
		"ot.case.cancel",
		// Waiving a pre-operative blocker. The domain checks the role against
		// the item, so this waives the anaesthetist's items and nothing else;
		// consent and site marking are unwaivable by anybody.
		"ot.preop.waive",
		// Deliberately no ot.note.sign: the operative note is the surgeon's
		// assertion about what they did, and the anaesthetic record is a
		// separate document with a separate author.

		// Reading the chart of the patient they are about to anaesthetise:
		// the allergies, the problems, the observations and the drug chart.
		"cln.record.read",
		"med.prescription.read",
		"ord.order.read",
		"enc.encounter.read",
		"empi.patient.read",
	},

	// A blood bank scientist groups patients, crossmatches, and decides what
	// leaves the fridge (SRS-BLD).
	RoleBloodBankScientist: {
		"bld.record.read",
		"bld.donor.write",
		"bld.donor.defer",
		"bld.testing.write",
		"bld.inventory.write",
		"bld.crossmatch.write",
		"bld.issue.write",
		"bld.reaction.write",
		// Reading the patient the crossmatch is for.
		"empi.patient.read",
		"enc.encounter.read",
		// Deliberately no bld.component.release: the person who ran the assay
		// should not also be the person who declares the donation clear.
		// Deliberately no bld.issue.emergency: an uncrossmatched release is
		// authorised by somebody senior, and "somebody senior" is not
		// whoever is on the bench at 3am.
		// Deliberately no bld.request.place: the bank does not ask itself for
		// blood, and a laboratory that could raise the request it then fills
		// has no clinical check on it at all.
		// And deliberately no bld.trace.read: a look-back reaches every
		// patient who received blood from a donation, which is the
		// haemovigilance officer's access rather than the bench's.
	},

	// A blood bank manager works the bench and holds the two decisions a
	// hospital is most answerable for (SRS-BLD-004, SRS-BLD-016).
	RoleBloodBankManager: {
		"bld.record.read",
		"bld.donor.write",
		"bld.donor.defer",
		"bld.testing.write",
		"bld.inventory.write",
		"bld.crossmatch.write",
		"bld.issue.write",
		"bld.reaction.write",
		// Reading the patient the crossmatch is for.
		"empi.patient.read",
		"enc.encounter.read",
		// The release that makes a donation givable, and the uncrossmatched
		// release that skips the crossmatch. Both are decisions a review is
		// traced back to, and both are why this role exists.
		"bld.component.release",
		"bld.issue.emergency",
		"bld.stock.configure",
		// A manager sees the reaction worklist but does not conclude the
		// investigations: that is the haemovigilance officer's, and the bank
		// investigating its own issue is not an investigation.
	},

	// A haemovigilance officer investigates reactions and runs look-backs
	// (SRS-BLD-012, SRS-BLD-014, SRS-BLD-015).
	RoleHaemovigilanceOfficer: {
		"bld.record.read",
		"bld.reaction.write",
		// The access that defines the role: from a donation to every patient
		// who received it, across admissions and departments. Its own
		// permission, and audited with the count, because a look-back and a
		// fishing expedition look identical in the query log.
		"bld.trace.read",
		"empi.patient.read",
		"enc.encounter.read",
		// Deliberately nothing that touches inventory or issue: an
		// investigator who could quarantine and release the units they are
		// investigating is investigating their own decisions.
	},

	// A sterile services technician receives, reprocesses, sterilises and
	// issues (SRS-CSSD-002 … 009).
	RoleSterileTechnician: {
		"cssd.record.read",
		"cssd.run.process",
		"cssd.cycle.write",
		"cssd.issue.write",
		// Deliberately no cssd.stage.skip: the stage sequence is the
		// department's safety property, and the person who may step round it
		// should not be whoever is at the bench.
		// Deliberately no cssd.cycle.release: a load that ran is not a load
		// that passed, and release is what makes an untested pack usable.
		// Deliberately no cssd.recall.raise and no cssd.trace.read: raising a
		// recall tells wards to stop using what they have, and a case trace
		// reaches every patient a load touched.
		// Deliberately no cssd.master.configure: what belongs in a tray is a
		// decision the department makes once, not one a technician makes
		// while packing.
	},

	// A storekeeper receives, issues, transfers and counts (SRS-MAT-005,
	// SRS-MAT-008, SRS-MAT-010, SRS-MAT-011).
	RoleStorekeeper: {
		"mat.record.read",
		"mat.requisition.raise",
		// The storekeeper is the first step of a typical approval route. The
		// permission says only that this caller may take a step in a chain;
		// the route says which role is required where, and the domain refuses
		// a requester approving their own request.
		"mat.requisition.approve",
		"mat.receipt.write",
		"mat.stock.issue",
		"mat.transfer.write",
		"mat.count.record",
		// Reading the patient a consumption is charged to.
		"empi.patient.read",
		// Deliberately no mat.inspection.decide: accepting stock out of
		// quarantine is the step that makes an uninspected delivery usable,
		// and the person who took the delivery in should not be the one who
		// declares it fit.
		// Deliberately no mat.count.approve: a storekeeper who could count
		// their own store and sign off the difference can make any shortfall
		// disappear, and the variance report becomes a record of nothing.
		// Deliberately no mat.lot.block: blocking tells every ward to stop
		// using what they have, and the recall list names the patients it
		// reached.
		// Deliberately no mat.purchase.write: the person who receives the
		// goods does not also commit the money for them.
		// Deliberately no mat.master.configure: what an item is and what it
		// costs to reorder is decided once, not at the counter.
	},

	// A materials manager works the counter and holds the controls the
	// hospital is answerable for (SRS-MAT-006, SRS-MAT-011, SRS-MAT-013).
	RoleMaterialsManager: {
		"mat.record.read",
		"mat.requisition.raise",
		"mat.requisition.approve",
		"mat.receipt.write",
		"mat.stock.issue",
		"mat.transfer.write",
		"mat.count.record",
		"empi.patient.read",
		// The item, supplier and stock-level masters, and the approval
		// routes: the configuration every other decision here is measured
		// against.
		"mat.master.configure",
		// The step that makes uninspected stock usable.
		"mat.inspection.decide",
		// The signature on an adjustment. The domain refuses it where the
		// approver is the counter, so a manager who counted a store still
		// cannot sign off their own variance.
		"mat.count.approve",
		// A linen par is a standing purchasing commitment — how much of
		// each item every ward may hold — so it is signed off where the
		// buying is. Laundry drafts it, materials puts it in force
		// (SRS-LND-001).
		"lnd.read",
		"lnd.par.approve",
		"lnd.report.read",
		// Deliberately no lnd.master.manage: the approver does not write
		// what they approve, and the domain refuses the author their own
		// approval either way.

		// The block that stops a lot being issued anywhere, and the recall
		// list that names who it reached.
		"mat.lot.block",
		// The utilisation and expiry figures a stores review reads.
		"mat.analysis.read",
		// Deliberately no mat.purchase.write and no mat.invoice.match: a
		// stores function that could also raise the order and clear the
		// invoice has no separation from procurement at all.
	},

	// A buyer runs procurement and clears the invoice (SRS-MAT-003,
	// SRS-MAT-004, SRS-MAT-014).
	RoleBuyer: {
		"mat.record.read",
		"mat.purchase.write",
		"mat.invoice.match",
		"mat.analysis.read",
		// Deliberately nothing that touches the ledger: no receipt, no issue,
		// no transfer, no count. The person who commits the hospital's money
		// does not also confirm that the goods arrived.
		// Deliberately no mat.requisition.approve: a buyer approving the
		// request they are about to fill is the request and the check on it
		// in one pair of hands.
	},

	// A quality officer runs the quality system day to day (SRS-QMS-001 …
	// 011, SRS-QMS-014).
	RoleQualityOfficer: {
		"qms.record.read",
		"qms.incident.report",
		"qms.incident.review",
		"qms.rca.conduct",
		"qms.capa.write",
		"qms.document.write",
		"qms.document.acknowledge",
		"qms.competency.write",
		"qms.audit.conduct",
		"qms.committee.manage",
		"qms.accreditation.write",
		"qms.indicator.write",
		"qms.complaint.handle",
		// Deliberately no qms.restricted.read: a sentinel event's review and
		// a serious-incident analysis name identifiable staff, and the people
		// who may read them are a shorter list than the people who run the
		// system.
		// Deliberately no qms.capa.approve: approving an action and closing it
		// are the two ends the separation of duties is at, and this is the
		// role that raises them.
		// Deliberately no qms.document.approve: approval is what makes a draft
		// into policy, and the author of a revision should not be the person
		// who makes it binding.
		// Deliberately no qms.peerreview.conduct: a mortality review belongs
		// to clinicians.
		// Deliberately no qms.record.hold: a legal hold is what stops a record
		// being destroyed, and lifting one is the step nobody takes casually.
	},

	// A quality manager runs the department and holds the four decisions the
	// hospital is answerable for (SRS-QMS-004, SRS-QMS-005, SRS-QMS-006,
	// SRS-QMS-015).
	RoleQualityManager: {
		"qms.record.read",
		"qms.incident.report",
		"qms.incident.review",
		"qms.rca.conduct",
		"qms.capa.write",
		"qms.document.write",
		"qms.document.acknowledge",
		"qms.competency.write",
		"qms.audit.conduct",
		"qms.committee.manage",
		"qms.accreditation.write",
		"qms.indicator.write",
		"qms.complaint.handle",
		// The four the officer does not hold. Holding qms.capa.approve is
		// necessary and not sufficient: the domain refuses the raiser and the
		// owner whoever they are, so a manager who raised an action still
		// cannot approve it and one who owns it still cannot close it.
		"qms.restricted.read",
		"qms.capa.approve",
		"qms.document.approve",
		"qms.record.hold",
		// Still no qms.peerreview.conduct.
	},

	// A peer reviewer sits on the mortality and morbidity committee
	// (SRS-QMS-012). The narrowest access in this system, and every read
	// under it is audited.
	RolePeerReviewer: {
		"qms.record.read",
		"qms.incident.report",
		"qms.restricted.read",
		"qms.peerreview.conduct",
		// Deliberately nothing else. Sitting on the committee is not running
		// the quality system.
	},

	// An infection control practitioner runs surveillance, isolation,
	// outbreaks, hand hygiene audit and environmental sampling
	// (SRS-IPC-001 … 003, SRS-IPC-005, SRS-IPC-006, SRS-IPC-009).
	RoleInfectionControlNurse: {
		"ipc.record.read",
		"ipc.board.read",
		"ipc.case.write",
		"ipc.denominator.record",
		"ipc.isolation.write",
		"ipc.outbreak.manage",
		"ipc.hygiene.observe",
		"ipc.exposure.report",
		"ipc.environment.sample",
		// Deliberately no ipc.onset.override: reclassifying a
		// healthcare-associated infection as community-acquired removes it
		// from the rate this role is measured by.
		//
		// Deliberately no ipc.rule.write or ipc.rule.approve: an alert rule
		// decides what every ward is told about every patient.
		//
		// Deliberately no ipc.exposure.manage: a staff health record belongs
		// to occupational health.
		//
		// Deliberately no ipc.environment.act: raising a corrective action
		// and verifying it are estates work, and the verification is what
		// stops "flushed and cleared" standing in for a repeat that passed.
	},

	// The lead holds the practitioner's caseload and the decisions the
	// hospital's reported rates depend on (SRS-IPC-001, SRS-IPC-004,
	// SRS-IPC-008, SRS-IPC-009).
	RoleInfectionControlLead: {
		"ipc.record.read",
		"ipc.board.read",
		"ipc.case.write",
		"ipc.denominator.record",
		"ipc.isolation.write",
		"ipc.outbreak.manage",
		"ipc.hygiene.observe",
		"ipc.exposure.report",
		"ipc.environment.sample",
		// The four the practitioner does not hold.
		"ipc.onset.override",
		"ipc.rule.write",
		"ipc.rule.approve",
		"ipc.environment.act",
		// Still no ipc.exposure.manage and no ipc.stewardship.respond.

		// A cleaning standard's risk class decides how often a theatre is
		// cleaned and whether an overdue clean is escalated, which is an
		// infection-control judgement rather than a housekeeping one. This
		// is the second signature on SRS-HKP-001: housekeeping writes the
		// standard, infection control puts it in force.
		"hkp.read",
		"hkp.location.approve",
		"hkp.report.read",
		// Deliberately no hkp.location.manage: the approver does not write
		// what they approve, and the domain refuses the author their own
		// approval either way.
	},

	// Occupational health works staff exposure records (SRS-IPC-007). Every
	// read under ipc.exposure.manage is written to the audit trail.
	RoleOccupationalHealth: {
		"ipc.exposure.report",
		"ipc.exposure.manage",
		// Deliberately nothing else. Following up a needlestick is not
		// running infection control, and this role has no reason to read a
		// surveillance case or a bed board.
	},

	// The records manager holds the decisions that make something disappear
	// or leave the hospital (SRS-MRD-001, SRS-MRD-002, SRS-MRD-004,
	// SRS-MRD-005, SRS-MRD-007, SRS-MRD-009).
	RoleHIMManager: {
		"mrd.record.read",
		"mrd.disclosure.read",
		// What a complete chart is, and what happens when the retention
		// period runs out. Writing and approving are both here and neither
		// lets one person do both: the domain and the database refuse a rule
		// approved by its own author.
		"mrd.checklist.write",
		"mrd.checklist.approve",
		"mrd.retention.write",
		"mrd.retention.approve",
		"mrd.certificate.form.write",
		"mrd.certificate.form.approve",
		// The second signature on each of the three decisions the office
		// proposes.
		"mrd.deficiency.waive",
		"mrd.release.approve",
		"mrd.disposition.approve",
		// What stops a destruction. Held here rather than by the office that
		// runs the destruction.
		"mrd.hold.manage",
		// Withdrawing a certificate that should not have been issued. The
		// versions stay: a voided certificate the hospital cannot produce is
		// one it cannot explain to the registrar holding a copy.
		"mrd.certificate.void",
		// Deliberately no mrd.disposition.execute: the person who signs the
		// list and the person who shreds the records are not the same.
		//
		// Deliberately no mrd.certificate.issue: a statutory certificate is
		// signed by a clinician with the standing the form names.
		//
		// Deliberately no mrd.coding.write and no mrd.deficiency.resolve:
		// running the records office is not writing the record.
	},

	// A clinical coder assigns the codes the hospital is paid and measured on
	// (SRS-MRD-003).
	RoleClinicalCoder: {
		"mrd.record.read",
		"mrd.coding.write",
		// The second read. The domain refuses the coder their own coding, so
		// this is how a second coder signs off rather than a way to sign off
		// alone.
		"mrd.coding.finalise",
		// A question back to the clinician, which is the only thing coding
		// may produce about somebody else's note.
		"mrd.coding.query",
		// Deliberately no mrd.deficiency.resolve: a coder who could answer
		// their own query would be writing the clinician's half of
		// SRS-MRD-008.
		//
		// Deliberately nothing in release, retention or disposition: coding
		// an episode is not deciding what leaves the hospital or what stops
		// existing.
	},

	// A dietitian assesses, plans and orders (SRS-DIET-001 … 004,
	// SRS-DIET-007).
	RoleDietitian: {
		"empi.patient.read",
		"enc.encounter.read",
		"diet.record.read",
		// The census and the trays, so a dietitian can see whether the
		// patient they are worried about actually got fed.
		"diet.service.read",
		"diet.create",
		"diet.order.write",
		"diet.support.plan",
		// Deliberately no diet.conflict.resolve: deciding that a documented
		// allergy does not apply to this food is a clinical judgement about
		// the record, and the person who placed the order that raised the
		// conflict is the one least well placed to overrule it.
		//
		// Deliberately no diet.support.link: the plan is not the
		// prescription.
		//
		// Deliberately nothing in the kitchen's own work — the census, the
		// trays, the menu. A dietitian who could plate and dispatch could
		// send the meal they ordered without anybody checking the order
		// again, which is the check SRS-DIET-009 exists for.
	},

	// The kitchen builds the census, cooks to it and sends the trays
	// (SRS-DIET-005, SRS-DIET-006, SRS-DIET-008).
	RoleKitchenStaff: {
		"diet.service.read",
		"diet.manage",
		"diet.write",
		"diet.menu.manage",
		"diet.count.record",
		// Deliberately no diet.record.read: a tray card carries a texture
		// and a restriction, and a nutrition assessment carries a diagnosis.
		//
		// Deliberately no diet.order.write and no diet.conflict.resolve: the
		// kitchen cooks to the order and never writes one, and the dispatch
		// check is only a check if the person dispatching cannot change what
		// it checks against.
	},

	// A housekeeper does the cleaning and records it (SRS-HKP-002,
	// SRS-HKP-004, SRS-HKP-006, SRS-HKP-007).
	RoleHousekeeper: {
		"hkp.read",
		// Somebody sent to a biohazard task needs to know what was spilled
		// before they decide what to wear.
		"hkp.spill.read",
		// A cleaner who walks past a spill can raise the task for it.
		"hkp.task.raise",
		"hkp.task.work",
		// Deliberately no hkp.task.verify: a clean signed off by the cleaner
		// is the same claim made twice.
		//
		// Deliberately no hkp.bed.override: putting a patient into an
		// uncleaned bed is a decision about the ward.
		//
		// Deliberately no hkp.location.manage: the person judged against the
		// checklist does not write it.
	},

	// A housekeeping supervisor runs the cleaning, checks the work and
	// reports on it (SRS-HKP-001, SRS-HKP-004, SRS-HKP-005, SRS-HKP-008).
	RoleHousekeepingSupervisor: {
		"hkp.read",
		"hkp.spill.read",
		"hkp.task.raise",
		"hkp.task.work",
		"hkp.task.verify",
		"hkp.location.manage",
		"hkp.bed.hold",
		"hkp.report.read",
		// Deliberately no hkp.location.approve: the supervisor writes the
		// cleaning standard and somebody else puts it in force.
		//
		// Deliberately no hkp.bed.override.
	},

	// A laundry operator collects, washes and sends the linen back
	// (SRS-LND-002 … 004).
	RoleLaundryOperator: {
		"lnd.read",
		"lnd.collect",
		"lnd.wash",
		"lnd.issue",
		// Reporting a torn sheet has to be as easy as this or it does not
		// happen, and the linen quietly disappears instead.
		"lnd.loss.report",
		// Every reader in the building records a movement.
		"lnd.track.scan",
		// Deliberately no lnd.receive: a delivery signed for by whoever
		// brought it is the same claim made twice.
		//
		// Deliberately no lnd.loss.approve: an operator who could write off
		// the linen they lost is an operator whose losses are always nil.
		//
		// Deliberately no lnd.master.manage: the person judged against the
		// par does not write it.
	},

	// A laundry manager runs the service and decides its write-offs
	// (SRS-LND-001, SRS-LND-006, SRS-LND-007).
	RoleLaundryManager: {
		"lnd.read",
		"lnd.master.manage",
		"lnd.collect",
		"lnd.wash",
		"lnd.issue",
		"lnd.loss.report",
		"lnd.loss.approve",
		"lnd.track.manage",
		"lnd.track.scan",
		"lnd.report.read",
		// Deliberately no lnd.par.approve: the manager drafts the par and
		// somebody else puts it in force.
		//
		// Deliberately no lnd.receive, for the same reason the operator
		// does not hold it.
	},

	// An ambulance crew checks the vehicle, runs the job and writes up what
	// they did (SRS-AMB-003, SRS-AMB-004, SRS-AMB-006).
	RoleAmbulanceCrew: {
		"amb.read",
		// The person who looks in the vehicle is the person who records
		// what they found.
		"amb.check",
		// A call raised by a crew who found somebody in the street has to
		// be as easy as this or it goes unrecorded.
		"amb.request",
		"amb.timeline",
		"amb.prehospital.write",
		"amb.prehospital.read",
		// Deliberately no amb.check.override: whoever found the oxygen
		// empty does not wave it through.
		//
		// Deliberately no amb.handover.accept: a handover accepted by the
		// crew who gave it is the same claim made twice.
		//
		// Deliberately no amb.location.read: a crew does not need the map
		// of where every other vehicle has been.
	},

	// A dispatcher takes the calls and sends the vehicles (SRS-AMB-001,
	// SRS-AMB-003).
	RoleAmbulanceDispatcher: {
		"amb.read",
		"amb.request",
		"amb.dispatch",
		// A dispatcher marks a vehicle mobile when the crew radios it in,
		// which is how most timelines are actually filled.
		"amb.timeline",
		// Where the vehicles are is the dispatch board's whole job.
		"amb.location.read",
		"amb.report.read",
		// Deliberately no amb.dispatch.override: sending a vehicle a rule
		// would have refused is somebody else's decision.
		//
		// Deliberately no amb.prehospital.read: a dispatch board is read
		// in a room full of people.
	},

	// An ambulance manager runs the fleet and carries the overrides
	// (SRS-AMB-002, SRS-AMB-006, SRS-AMB-008).
	RoleAmbulanceManager: {
		"amb.read",
		"amb.fleet.manage",
		"amb.check",
		"amb.check.override",
		"amb.dispatch.override",
		"amb.location.read",
		"amb.report.read",
		// Deliberately no amb.dispatch: the person who may wave a failed
		// vehicle onto the run is not the person sending it.
		//
		// Deliberately no amb.prehospital.read: running a fleet does not
		// require reading what a paramedic gave a patient.
	},

	// The telematics integration reports where the vehicles are
	// (SRS-AMB-005).
	RoleFleetTelematics: {
		"amb.location.write",
		// And nothing else. A box that could read the feed it writes is a
		// box somebody can ask where an ambulance has been.
	},

	// A mortuary attendant receives bodies, stores them and keeps the chain
	// of custody (SRS-MORT-001, SRS-MORT-002, SRS-MORT-004).
	RoleMortuaryAttendant: {
		"mort.read",
		"mort.case.manage",
		"mort.storage.manage",
		"mort.place",
		"mort.custody",
		// Handing a family their father's belongings has to be something
		// the person on the desk at four in the morning can do.
		"mort.handover",
		"mort.postmortem.request",
		// Deliberately no mort.release: a body leaves once, and the
		// person who put it in the drawer is not the only person involved
		// in taking it out.
		//
		// Deliberately no mort.authorise: recording a clearance is not
		// the same act as doing the work it clears.
		//
		// Deliberately no mort.sensitive.read: an attendant needs to know
		// a case is medico-legal, which the board shows, and not what the
		// cause says.
	},

	// A mortuary manager releases bodies and reads the board
	// (SRS-MORT-006, SRS-MORT-007, SRS-MORT-008).
	RoleMortuaryManager: {
		"mort.read",
		"mort.case.manage",
		"mort.storage.manage",
		"mort.release",
		"mort.postmortem.manage",
		"mort.report.read",
		// Deliberately no mort.authorise: the clearance to release a
		// medico-legal case comes from outside the mortuary, and a
		// manager who could record their own would be the whole control.
		//
		// Deliberately no mort.sensitive.read: running a mortuary does
		// not require reading a cause of death.
		//
		// Deliberately no mort.custody and no mort.handover: the person
		// who releases the body is not the person who lists and hands
		// over what was in the pockets.
	},

	// A coroner's officer authorises examinations and reads the sensitive
	// detail (SRS-MORT-003, SRS-MORT-005, SRS-MORT-007).
	RoleCoronersOfficer: {
		"mort.read",
		// The one role that reads the cause and the medico-legal
		// reference as a matter of course. Every read is audited.
		"mort.sensitive.read",
		// The officer certifies what the examination found.
		"mort.cause.record",
		"mort.postmortem.request",
		"mort.postmortem.manage",
		// The clearance that lets a medico-legal or unidentified case
		// leave. This is the authority's act, recorded by their officer.
		"mort.authorise",
		"mort.report.read",
		// Deliberately no mort.release: the officer decides what may
		// happen and does not do it.
		//
		// Deliberately no mort.custody: evidence is retained by a
		// recorded act of the mortuary's, not taken off the list by the
		// person taking it.
	},

	// A facilities technician does the estates work (SRS-FAC-002,
	// SRS-FAC-003, SRS-FAC-007, SRS-FAC-009, SRS-FAC-011).
	RoleFacilitiesTechnician: {
		"fac.read",
		"fac.work.raise",
		"fac.work.manage",
		"fac.maintenance.complete",
		"fac.runtime.write",
		"fac.meter.write",
		"fac.alarm.manage",
		// Requests a shutdown; somebody else signs it.
		"fac.outage.request",
		"fac.vendor.manage",
		// An engineer who finds a wedged fire door reports it. Closing
		// it is somebody else's.
		"fac.safety.raise",
		// Deliberately no fac.work.close: the engineer who did the work
		// does not also certify it was done.
		//
		// Deliberately no fac.permit: isolating high-voltage switchgear
		// is a shorter list of people than "may do maintenance".
		//
		// Deliberately no fac.asset.manage: registering plant and
		// deciding how critical it is is a decision about the hospital,
		// not about today's job.
	},

	// A facilities manager runs the estates function (SRS-FAC-001,
	// SRS-FAC-002, SRS-FAC-004, SRS-FAC-010, SRS-FAC-011).
	RoleFacilitiesManager: {
		"fac.read",
		"fac.asset.manage",
		"fac.work.raise",
		"fac.work.manage",
		// Signs work off. The domain refuses it to whoever did the work.
		"fac.work.close",
		// Decides which classes of work need a permit, and may start
		// that work. Both, because the two are one decision: somebody
		// who can turn the flag off has no permit system either way.
		"fac.permit",
		"fac.maintenance.manage",
		"fac.outage.request",
		// The domain refuses an outage approved by its requester, so
		// holding both is two managers per shutdown, not one.
		"fac.outage.approve",
		"fac.alarm.manage",
		"fac.vendor.manage",
		"fac.meter.write",
		"fac.report.read",
		// Deliberately no fac.safety.close: certifying a fire door
		// repaired belongs to the fire safety officer, not to the person
		// whose backlog it is.
		//
		// Deliberately no fac.alarm.ingest: alarms come from plant.
	},

	// A fire safety officer inspects and certifies life safety
	// (SRS-FAC-003, SRS-FAC-008).
	RoleFireSafetyOfficer: {
		"fac.read",
		// Does the fire and life-safety inspections.
		"fac.maintenance.complete",
		"fac.safety.raise",
		// The domain refuses a critical finding closed by whoever raised
		// it, so holding both means two officers rather than one.
		"fac.safety.close",
		// A deficiency needs work raised against it.
		"fac.work.raise",
		"fac.report.read",
		// Deliberately no fac.work.close and no fac.permit: the officer
		// says what is wrong and whether it is fixed, and does not run
		// the work that fixes it.
	},

	// A plant gateway reports facility alarms (SRS-FAC-005).
	RolePlantGateway: {
		"fac.alarm.ingest",
		// And nothing else. A gateway that could read its own alarms is
		// a gateway somebody can ask what the hospital's plant has been
		// doing, and one that could close work is one that will.
	},

	// A biomedical engineer maintains the equipment and does the service work
	// (SRS-BIO-001, SRS-BIO-003, SRS-BIO-005, SRS-BIO-006, SRS-BIO-010).
	RoleBiomedicalEngineer: {
		"bio.record.read",
		"bio.asset.register",
		"bio.plan.write",
		"bio.ticket.raise",
		"bio.ticket.work",
		"bio.telemetry.append",
		"bio.analysis.read",
		// Deliberately no bio.ticket.close: closing is the validation, and a
		// repair signed off by the person who made it is the same claim twice.
		// Deliberately no bio.calibration.record: a calibration is what makes
		// a machine's readings admissible, and somebody who could record one
		// could make an uncalibrated analyser look fit to report on patients.
		// Deliberately no bio.notice.manage: raising a recall stops equipment
		// across the hospital, and lifting a hold puts it back into use.
		// Deliberately no bio.asset.dispose: a disposal is the last thing that
		// ever happens to a record, and anything missing at that point is
		// missing for ever.
		// Deliberately no bio.contract.write: a contract is money, and a
		// renewal is a purchase.
	},

	// A biomedical manager works the bench and holds the four decisions the
	// department is answerable for (SRS-BIO-004, SRS-BIO-006, SRS-BIO-008,
	// SRS-BIO-011).
	RoleBiomedicalManager: {
		"bio.record.read",
		"bio.asset.register",
		"bio.plan.write",
		"bio.ticket.raise",
		"bio.ticket.work",
		"bio.telemetry.append",
		"bio.analysis.read",
		// The four the engineer does not hold.
		"bio.ticket.close",
		"bio.calibration.record",
		"bio.notice.manage",
		"bio.asset.dispose",
		// Renewals and their money.
		"bio.contract.write",
	},

	// A sterile services supervisor works the bench and holds the three
	// decisions the department is answerable for (SRS-CSSD-003, SRS-CSSD-007,
	// SRS-CSSD-011).
	RoleSterileSupervisor: {
		"cssd.record.read",
		"cssd.run.process",
		"cssd.cycle.write",
		"cssd.issue.write",
		// The packing lists, which are what every assembly and every count
		// after a case is checked against.
		"cssd.master.configure",
		// The authorised exception SRS-CSSD-003 allows. The authoriser is the
		// caller, so holding this permission is the whole of the sign-off.
		"cssd.stage.skip",
		// The step that makes a pack distributable, and the recall that pulls
		// one back. Both are what this role exists for.
		"cssd.cycle.release",
		"cssd.recall.raise",
		// From a patient's operation back to every set and every sterilizer
		// cycle it was exposed to. Its own permission and audited, because a
		// trace and a fishing expedition look identical in the query log.
		"cssd.trace.read",
	},

	// A downstream service moves orders through their lifecycle and does
	// nothing else (SRS-ORD-006).
	RolePerformingService: {
		"ord.order.read",
		"ord.order.acknowledge",
		// Deliberately no ord.order.place and no patient read: a laboratory
		// system needs to know what was asked of it, not who the patient is.
		// The dispatch carries the identifiers it needs.
	},

	// A nurse manager runs the ward rather than the bedside.
	RoleNurseManager: {
		"empi.patient.read",
		"enc.encounter.read",
		"nur.record.read",
		// The person who runs a ward answers for it when estates want to
		// take the power off (SRS-FAC-004). Held here rather than by
		// facilities on purpose: the acceptance is that the impacted
		// department receives the notification and answers it, and a
		// facilities manager acknowledging on the ward's behalf is the
		// notification not happening.
		"fac.outage.acknowledge",
		// And a ward manager reports a fault like anybody else.
		"fac.read",
		"fac.work.raise",
		// Assignment and the acuity dashboard (SRS-NUR-016, SRS-NUR-017).
		"nur.assignment.manage",
		// Note what is absent: no nur.medication.administer. A manager who is
		// also rostered to give medication holds the nurse role as well; the
		// management role does not carry it, so "who may give a drug" stays
		// answerable from the roles alone.

		// The charge nurse runs the emergency floor: they read the board and
		// move a patient up the queue (SRS-ER-003, SRS-ER-004). They do not
		// triage and do not dispose — a manager who is also rostered to triage
		// holds the nurse role too.
		"er.visit.read",
		"er.queue.override",

		// The critical-care dashboard and its numbers (SRS-ICU-012,
		// SRS-ICU-017). Reading the ceiling comes with it: the person deciding
		// which bed the next admission goes into has to know which patients
		// are for escalation.
		"icu.episode.read",
		"icu.ceiling.read",

		// The theatre command board and its numbers (SRS-OT-013, SRS-OT-015).
		"ot.case.read",

		// A ward manager decides whether a bed comes back uncleaned when the
		// hospital is full (SRS-HKP-003). Its own permission, every use
		// audited and escalated, and deliberately not held by anybody in
		// housekeeping: the person who would benefit from the bed looking
		// clean is not the person who decides it is.
		"hkp.read",
		"hkp.task.raise",
		"hkp.bed.hold",
		"hkp.bed.override",
		"hkp.report.read",
	},
}

// PermissionsFor flattens the union of permissions for the given roles,
// deduplicated and sorted so the result is stable for caching and comparison.
func PermissionsFor(roles []Role) []string {
	set := make(map[string]struct{})
	for _, r := range roles {
		for _, p := range rolePermissions[r] {
			set[p] = struct{}{}
		}
	}

	out := make([]string, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Strings(out)
	return out
}

// KnownRole reports whether a role exists in the catalogue.
func KnownRole(r Role) bool {
	_, ok := rolePermissions[r]
	return ok
}

// rolePurposes is the purpose-of-use catalogue (SRS-IAM-004, SRS-SEC-009).
//
// Deliberately separate from permissions and deliberately *not* asserted by
// the identity provider. A customer's directory says who somebody is and what
// they do; what they may use patient data *for* is this system's policy, and
// letting a provider claim a purpose would let a customer's IdP grant research
// access by adding a group.
//
// A role absent here permits no purpose, so a caller holding it can assert
// none through the X-Purpose-Of-Use header. That is the fail-closed direction:
// an unstated purpose narrows nothing and reaches nothing that requires one.
var rolePurposes = map[Role][]authctx.PurposeOfUse{
	// Operational roles act on configuration, never on a clinical record, so
	// "operations" is the only purpose that makes sense for them. Granting
	// treatment here would let a platform operator read a chart with a purpose
	// that looks clinical in the audit trail.
	RolePlatformOperator: {authctx.PurposeOperations},
	RoleTenantAdmin:      {authctx.PurposeOperations},
	RoleFacilityViewer:   {authctx.PurposeOperations},
	// An auditor reviews the trail rather than delivering care. Support rather
	// than treatment, so their reads are distinguishable in the audit trail
	// from a clinician's.
	RoleAuditor: {authctx.PurposeOperations, authctx.PurposeSupport},

	// Registration and HIM act on the identity record in the course of
	// delivering and administering care. Treatment because a clerk registering
	// a patient is part of that patient receiving care; payment because the
	// same desk resolves the identity an invoice is raised against.
	RoleRegistrationClerk: {authctx.PurposeTreatment, authctx.PurposePayment},
	RoleHIMOfficer:        {authctx.PurposeTreatment, authctx.PurposeOperations},
	// A clinician reads a chart to treat somebody. Nothing else.
	RoleClinician: {authctx.PurposeTreatment},
	// The bedside roles, for the same reason: a nurse charting an observation
	// and a pharmacist verifying a prescription are both delivering care, and
	// their reads should be distinguishable in the audit trail from an
	// administrator's. A nurse manager runs the ward as well as working on it,
	// so operations is theirs too.
	RoleNurse:      {authctx.PurposeTreatment},
	RolePharmacist: {authctx.PurposeTreatment},
	// The records office reasons across records rather than treating one
	// patient, and a coder reads a chart to code the episode. Operations for
	// both, and treatment for the manager too because a release for
	// continuity of care is care.
	RoleHIMManager:    {authctx.PurposeTreatment, authctx.PurposeOperations},
	RoleClinicalCoder: {authctx.PurposeOperations},
	// A dietitian is delivering care. The kitchen is not: it is running a
	// service, and an audit trail that recorded a catering read as treatment
	// would be wrong about the one thing it exists to record.
	RoleDietitian:    {authctx.PurposeTreatment},
	RoleKitchenStaff: {authctx.PurposeOperations},
	RoleNurseManager: {authctx.PurposeTreatment, authctx.PurposeOperations},
	// Billing acts on the financial record. Payment because that is what they
	// are doing, and operations because a revenue-integrity report is
	// administration rather than a bill. Never treatment: a billing read of a
	// chart is not care, and an audit trail that said it was would be wrong
	// about the one thing it exists to record.
	RoleBillingClerk: {authctx.PurposePayment, authctx.PurposeOperations},
	RoleCashier:      {authctx.PurposePayment},
	RoleFinanceAdmin: {authctx.PurposePayment, authctx.PurposeOperations},
	RoleScheduler:    {authctx.PurposeTreatment, authctx.PurposeOperations},
}

// PurposesFor returns the purposes-of-use the given roles may assert,
// deduplicated and in a stable order.
func PurposesFor(roles []Role) []authctx.PurposeOfUse {
	set := map[authctx.PurposeOfUse]bool{}
	for _, r := range roles {
		for _, p := range rolePurposes[r] {
			set[p] = true
		}
	}

	out := make([]authctx.PurposeOfUse, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}
