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
	RoleHIMOfficer Role = "him_officer"

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
		// Restraints and transfusion are nursing acts carried out under a
		// clinician's authorization, and the authorization is checked in the
		// record rather than in the permission (SRS-NUR-013, SRS-NUR-014).
		"nur.restraint.manage",
		"nur.transfusion.manage",
		// Declaring downtime and reconciling the paper chart afterwards is the
		// ward's job, and the ward is who knows the system has gone
		// (SRS-NUR-018).
		"nur.downtime.manage",

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
	RoleNurse:        {authctx.PurposeTreatment},
	RolePharmacist:   {authctx.PurposeTreatment},
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
