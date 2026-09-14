-- 0024 Medication management: prescriptions, safety findings, reconciliation,
-- pharmacist verification, substitution and formulary (SRS-MED).
--
-- A prescription is the clinical detail of a medication order, not a second
-- kind of order. The order framework in 0023 already owns identity, a number,
-- routing to the pharmacy, a lifecycle, an audit trail and an event contract;
-- what lives here is everything a prescription has that a chest X-ray does not.
--
-- Three shapes carry most of the weight.
--
-- The therapy ledger (medication.therapy_change) is append-only, because
-- SRS-MED-014 asks consumers to reconstruct the medication timeline "without
-- mutating source ledger" and SRS-MED-013 asks that a hold or a stop leave the
-- historical MAR unchanged. Both are the same requirement seen from two ends: a
-- status column that were overwritten would answer "is the patient on this now"
-- and would have destroyed the answer to "what were they on last Tuesday",
-- which is the question asked after an incident.
--
-- Safety findings (medication.safety_finding) store the rule *and its version*,
-- not null, because SRS-MED-002, SRS-MED-003 and SRS-MED-004 each require the
-- clinician to be shown which rule fired. A hospital that cannot say which
-- edition of its interaction table was in force last March cannot answer the
-- only question an investigation asks, and a nullable column is how that answer
-- gets lost one row at a time.
--
-- Substitutions (medication.substitution) are their own rows rather than an
-- edit to the prescription, which is SRS-MED-011's "separately from prescribed
-- product" read literally. A substitution written over the prescription would
-- leave the chart saying a named clinician chose a drug they never saw.
--
-- Trace: SRS-MED-001 (structured prescribing), SRS-MED-002 (allergy screen),
--   SRS-MED-003 (interactions and duplicate therapy), SRS-MED-004 (dose
--   support), SRS-MED-005 (reconciliation), SRS-MED-006 (verification),
--   SRS-MED-007 (eligible orders only), SRS-MED-008 (PRN constraints),
--   SRS-MED-009 (dose segments), SRS-MED-010 (structured dose required),
--   SRS-MED-011 (substitution), SRS-MED-012 (formulary), SRS-MED-013
--   (discontinue/hold/restart), SRS-MED-014 (events).
-- Rollback: drops the whole schema. Every live prescription goes with it and
--   the eMAR loses the orders its administrations point at. Export before
--   dropping and treat a rollback here as a disaster-recovery event.
-- Reconciliation: none for the forward direction; the schema is new. The
--   previous version writes nothing here during the rollout window because it
--   does not know these tables exist.

CREATE SCHEMA IF NOT EXISTS medication;

-- One medication a patient is on (SRS-MED-001).
CREATE TABLE medication.prescription (
    prescription_id uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    -- The CPOE order this is the clinical detail of. Not null: a prescription
    -- that reached no order would be invisible to the pharmacy worklist, the
    -- duplicate check and the order audit trail.
    order_id        uuid        NOT NULL,
    order_number    text        NOT NULL CHECK (order_number <> ''),

    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    -- Who is answerable, and who typed it. A verbal order taken by a nurse is
    -- the doctor's prescription.
    prescriber_id   text        NOT NULL CHECK (prescriber_id <> ''),
    entered_by_id   text        NOT NULL CHECK (entered_by_id <> ''),

    -- The substance, and the dispensable product where one was named. Kept
    -- apart because SRS-MED-011's substitution is only meaningful when they
    -- are: swapping a product is a different act from swapping a molecule.
    ingredient_system  text NOT NULL CHECK (ingredient_system <> ''),
    ingredient_code    text NOT NULL CHECK (ingredient_code <> ''),
    ingredient_display text NOT NULL CHECK (ingredient_display <> ''),
    ingredient_version text NOT NULL DEFAULT '',
    product_system     text NOT NULL DEFAULT '',
    product_code       text NOT NULL DEFAULT '',
    product_display    text NOT NULL DEFAULT '',

    route           text        NOT NULL CHECK (route <> ''),

    starts_at       timestamptz NOT NULL,
    stop_kind       text        NOT NULL CHECK (stop_kind IN (
                        'at_time', 'after_doses', 'on_condition', 'none')),
    stop_at         timestamptz,
    stop_doses      integer     NOT NULL DEFAULT 0 CHECK (stop_doses >= 0),
    stop_text       text        NOT NULL DEFAULT '',

    indication          text NOT NULL DEFAULT '',
    indication_system   text NOT NULL DEFAULT '',
    indication_code     text NOT NULL DEFAULT '',
    indication_display  text NOT NULL DEFAULT '',
    instructions        text NOT NULL DEFAULT '',

    -- As-needed constraints (SRS-MED-008). Null where the medication is
    -- scheduled. Structured columns rather than parsed from the instructions,
    -- because only what is structured can be enforced.
    prn                  boolean       NOT NULL DEFAULT false,
    prn_indication       text          NOT NULL DEFAULT '',
    prn_min_interval     interval,
    prn_max_doses        integer       NOT NULL DEFAULT 0 CHECK (prn_max_doses >= 0),
    prn_max_total_value  numeric(14,4),
    prn_max_total_unit   text          NOT NULL DEFAULT '',
    prn_period           interval,

    -- Is the patient on this drug right now (SRS-MED-013). Deliberately not the
    -- order status, which answers where the supply request has got to: a drug
    -- held for a procedure is a therapy that has stopped and a supply request
    -- that has not.
    therapy_status  text        NOT NULL CHECK (therapy_status IN (
                        'draft', 'active', 'held', 'discontinued', 'completed')),
    -- The moment after which no further dose may be given (SRS-MED-007). Null
    -- while the therapy is live.
    effective_stop  timestamptz,

    -- The pharmacist's check (SRS-MED-006).
    verified_by     text        NOT NULL DEFAULT '',
    verified_at     timestamptz,
    verification_note text      NOT NULL DEFAULT '',

    -- Where the medication stood with the formulary when it was prescribed
    -- (SRS-MED-012). Stored rather than recomputed, because the formulary is
    -- edited and a report that recomputed would misstate what the prescriber
    -- was shown.
    formulary_status       text NOT NULL DEFAULT 'unknown' CHECK (formulary_status IN (
                               'formulary', 'restricted', 'non_formulary', 'unknown')),
    formulary_scope        text NOT NULL DEFAULT '',
    formulary_scope_id     text NOT NULL DEFAULT '',
    formulary_restriction  text NOT NULL DEFAULT '',
    formulary_approval_path text NOT NULL DEFAULT '',

    screened_at     timestamptz,

    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL CHECK (version > 0),

    -- A verification that named nobody, or nobody at a time, is half a record.
    CONSTRAINT verification_is_whole CHECK (
        (verified_by = '' AND verified_at IS NULL) OR
        (verified_by <> '' AND verified_at IS NOT NULL)),
    -- A pharmacist may not verify their own prescription (SRS-MED-006). Held at
    -- the table as well as in the domain because it is the one control that
    -- makes verification a second pair of eyes rather than a checkbox.
    CONSTRAINT verification_is_a_second_person CHECK (
        verified_by = '' OR lower(verified_by) <> lower(prescriber_id)),
    CONSTRAINT stop_condition_is_complete CHECK (
        (stop_kind <> 'at_time'      OR stop_at IS NOT NULL) AND
        (stop_kind <> 'after_doses'  OR stop_doses > 0) AND
        (stop_kind <> 'on_condition' OR stop_text <> '')),
    -- An as-needed medication with no stated trigger is one a nurse decides
    -- about with nothing to decide against (SRS-MED-008).
    CONSTRAINT prn_has_an_indication CHECK (NOT prn OR prn_indication <> '')
);

CREATE INDEX prescription_by_patient
    ON medication.prescription (tenant_id, patient_id, starts_at DESC);
CREATE INDEX prescription_by_encounter
    ON medication.prescription (tenant_id, encounter_id, starts_at DESC);
-- The pharmacy's verification worklist: live prescriptions nobody has checked.
CREATE INDEX prescription_awaiting_verification
    ON medication.prescription (tenant_id, facility_id, created_at)
    WHERE therapy_status = 'active' AND verified_by = '';
-- One prescription per order. The order is the identity a prescription is known
-- by everywhere outside this schema, and two prescriptions behind one order
-- number would be two different answers to "what was ordered".
CREATE UNIQUE INDEX prescription_one_per_order
    ON medication.prescription (tenant_id, order_id);

-- One stretch of the schedule at one dose (SRS-MED-009).
CREATE TABLE medication.dose_segment (
    tenant_id       uuid        NOT NULL,
    prescription_id uuid        NOT NULL
                        REFERENCES medication.prescription (prescription_id)
                        ON DELETE CASCADE,
    sequence        integer     NOT NULL CHECK (sequence >= 1),

    dose_value      numeric(14,4),
    dose_unit       text        NOT NULL DEFAULT '',
    -- A dose that could not be structured. SRS-MED-010 lets a tenant configure
    -- classes where this is not allowed, and then submit is blocked.
    free_text_dose  text        NOT NULL DEFAULT '',

    frequency_text  text        NOT NULL DEFAULT '',
    interval_period interval,
    -- Minutes after midnight in the facility's zone. A four-times-daily drug is
    -- given on the ward round, not every six hours from whenever it was
    -- prescribed.
    times_of_day    integer[]   NOT NULL DEFAULT '{}',
    days_of_week    integer[]   NOT NULL DEFAULT '{}',
    prn             boolean     NOT NULL DEFAULT false,
    dose_duration   interval,

    starts_at       timestamptz NOT NULL,
    ends_at         timestamptz,
    note            text        NOT NULL DEFAULT '',
    -- The prescription version this segment was written at. SRS-MED-009 says
    -- each segment is "visible to nurse/pharmacist and versioned", and the
    -- version is what tells a nurse looking at a taper whether the step in front
    -- of them is the one the prescriber last edited.
    version         bigint      NOT NULL CHECK (version > 0),

    PRIMARY KEY (tenant_id, prescription_id, sequence),
    CONSTRAINT a_segment_has_a_dose CHECK (
        (dose_value IS NOT NULL AND dose_unit <> '') OR free_text_dose <> ''),
    CONSTRAINT a_segment_ends_after_it_begins CHECK (
        ends_at IS NULL OR ends_at > starts_at)
);

-- The therapy ledger (SRS-MED-013, SRS-MED-014). Append-only.
CREATE TABLE medication.therapy_change (
    change_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    prescription_id uuid        NOT NULL
                        REFERENCES medication.prescription (prescription_id)
                        ON DELETE CASCADE,
    from_status     text        NOT NULL,
    to_status       text        NOT NULL CHECK (to_status IN (
                        'draft', 'active', 'held', 'discontinued', 'completed')),
    -- When it took effect clinically, which is not when it was typed: a drug
    -- stopped on the ward round at 09:00 and recorded at 11:00 stopped at 09:00,
    -- and the dose at 10:00 should not have been given.
    effective_at    timestamptz NOT NULL,
    recorded_at     timestamptz NOT NULL,
    changed_by      text        NOT NULL CHECK (changed_by <> ''),
    reason          text        NOT NULL DEFAULT ''
);

CREATE INDEX therapy_change_timeline
    ON medication.therapy_change (tenant_id, prescription_id, effective_at);

-- What the safety rules said, with the rule versions that said it
-- (SRS-MED-002, SRS-MED-003, SRS-MED-004).
CREATE TABLE medication.safety_finding (
    finding_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    prescription_id uuid        NOT NULL
                        REFERENCES medication.prescription (prescription_id)
                        ON DELETE CASCADE,
    kind            text        NOT NULL CHECK (kind IN (
                        'allergy', 'interaction', 'duplicate_therapy', 'dose_support')),
    severity        text        NOT NULL CHECK (severity IN (
                        'contraindicated', 'severe', 'moderate', 'mild', 'informational')),
    -- Both not null. A finding that cannot say which edition of which rule
    -- produced it is one nobody can reproduce, defend or retire.
    rule_id         text        NOT NULL CHECK (rule_id <> ''),
    rule_version    text        NOT NULL CHECK (rule_version <> ''),
    summary         text        NOT NULL CHECK (summary <> ''),
    -- The medications or allergens the finding is about, and what the rule was
    -- evaluated against. JSON because their shape is the rule's rather than
    -- this schema's, and a column per input would need a migration every time a
    -- rule gained one.
    subjects        jsonb       NOT NULL DEFAULT '[]'::jsonb,
    inputs          jsonb       NOT NULL DEFAULT '{}'::jsonb,

    override_by     text        NOT NULL DEFAULT '',
    override_at     timestamptz,
    override_reason text        NOT NULL DEFAULT '',

    -- An override with no reason is a click, and a click is not a clinical
    -- decision anybody can review afterwards.
    CONSTRAINT an_override_is_whole CHECK (
        (override_by = '' AND override_at IS NULL AND override_reason = '') OR
        (override_by <> '' AND override_at IS NOT NULL AND override_reason <> '')),
    -- A contraindication may never be overridden. The domain refuses it and so
    -- does the table: this is the one control a configuration screen must not
    -- be able to unlock.
    CONSTRAINT a_contraindication_is_never_overridden CHECK (
        severity <> 'contraindicated' OR override_by = '')
);

CREATE INDEX safety_finding_by_prescription
    ON medication.safety_finding (tenant_id, prescription_id);
-- The governance report: which warnings were overridden, by whom, and against
-- which rule version.
CREATE INDEX safety_finding_overrides
    ON medication.safety_finding (tenant_id, rule_id, override_at)
    WHERE override_by <> '';

-- Medication reconciliation (SRS-MED-005).
CREATE TABLE medication.reconciliation (
    reconciliation_id uuid      PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    event           text        NOT NULL CHECK (event IN (
                        'admission', 'transfer', 'discharge')),
    started_by      text        NOT NULL CHECK (started_by <> ''),
    started_at      timestamptz NOT NULL,
    completed_by    text        NOT NULL DEFAULT '',
    completed_at    timestamptz,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL CHECK (version > 0),

    CONSTRAINT completion_is_whole CHECK (
        (completed_by = '' AND completed_at IS NULL) OR
        (completed_by <> '' AND completed_at IS NOT NULL))
);

CREATE INDEX reconciliation_by_encounter
    ON medication.reconciliation (tenant_id, encounter_id, started_at DESC);
-- One live reconciliation per encounter and event. Two open admission
-- reconciliations on one visit are two people working the same list and
-- overwriting each other's decisions.
CREATE UNIQUE INDEX reconciliation_one_open_per_event
    ON medication.reconciliation (tenant_id, encounter_id, event)
    WHERE completed_at IS NULL;

CREATE TABLE medication.reconciliation_item (
    tenant_id       uuid        NOT NULL,
    reconciliation_id uuid      NOT NULL
                        REFERENCES medication.reconciliation (reconciliation_id)
                        ON DELETE CASCADE,
    sequence        integer     NOT NULL CHECK (sequence >= 1),

    medication_system  text NOT NULL CHECK (medication_system <> ''),
    medication_code    text NOT NULL CHECK (medication_code <> ''),
    medication_display text NOT NULL CHECK (medication_display <> ''),
    dose_text       text        NOT NULL DEFAULT '',
    route           text        NOT NULL DEFAULT '',
    -- Where the list came from is how much it can be trusted: a printout from
    -- the GP system and a relative's recollection are both worth having and are
    -- not worth the same.
    source          text        NOT NULL CHECK (source IN (
                        'patient', 'carer', 'gp_record', 'pharmacy',
                        'previous_stay', 'medication_bag')),

    disposition     text        NOT NULL DEFAULT 'pending' CHECK (disposition IN (
                        'pending', 'continue', 'stop', 'change', 'unknown')),
    rationale       text        NOT NULL DEFAULT '',
    resulting_prescription_id uuid,
    decided_by      text        NOT NULL DEFAULT '',
    decided_at      timestamptz,

    PRIMARY KEY (tenant_id, reconciliation_id, sequence),
    -- Stopping and changing are the two that surprise whoever reads the chart
    -- next, and "why was my tablet stopped" is asked at every discharge.
    CONSTRAINT a_stop_or_change_has_a_rationale CHECK (
        disposition NOT IN ('stop', 'change') OR rationale <> '')
);

-- A dispensed product that differs from the prescribed one (SRS-MED-011).
CREATE TABLE medication.substitution (
    substitution_id uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    prescription_id uuid        NOT NULL
                        REFERENCES medication.prescription (prescription_id)
                        ON DELETE CASCADE,

    -- Both sides copied in, so the record stands alone: a reader should not
    -- have to fetch the prescription to know what was swapped.
    prescribed_system  text NOT NULL CHECK (prescribed_system <> ''),
    prescribed_code    text NOT NULL CHECK (prescribed_code <> ''),
    prescribed_display text NOT NULL CHECK (prescribed_display <> ''),
    dispensed_system   text NOT NULL CHECK (dispensed_system <> ''),
    dispensed_code     text NOT NULL CHECK (dispensed_code <> ''),
    dispensed_display  text NOT NULL CHECK (dispensed_display <> ''),

    kind            text        NOT NULL CHECK (kind IN (
                        'generic', 'therapeutic', 'formulary', 'stock')),
    status          text        NOT NULL CHECK (status IN (
                        'proposed', 'accepted', 'rejected', 'dispensed')),
    -- "Out of stock" and "cheaper" are different facts, and only one of them is
    -- a clinical governance question.
    reason          text        NOT NULL CHECK (reason <> ''),

    proposed_by     text        NOT NULL CHECK (proposed_by <> ''),
    proposed_at     timestamptz NOT NULL,
    authorized_by   text        NOT NULL DEFAULT '',
    authorized_at   timestamptz,
    dispensed_at    timestamptz,

    CONSTRAINT a_substitution_changes_something CHECK (
        prescribed_system <> dispensed_system OR prescribed_code <> dispensed_code),
    CONSTRAINT authorisation_is_whole CHECK (
        (authorized_by = '' AND authorized_at IS NULL) OR
        (authorized_by <> '' AND authorized_at IS NOT NULL)),
    -- Nothing is dispensed on an unauthorised substitution. This is the case
    -- SRS-MED-011 exists to make visible.
    CONSTRAINT nothing_dispensed_unauthorised CHECK (
        status <> 'dispensed' OR (authorized_by <> '' AND dispensed_at IS NOT NULL)),
    -- A therapeutic swap is a prescribing decision, so the pharmacist proposing
    -- it may not be the one who authorises it.
    CONSTRAINT a_therapeutic_swap_needs_a_second_person CHECK (
        kind <> 'therapeutic' OR authorized_by = ''
        OR lower(authorized_by) <> lower(proposed_by))
);

CREATE INDEX substitution_by_prescription
    ON medication.substitution (tenant_id, prescription_id, proposed_at DESC);

-- Formulary position by scope (SRS-MED-012).
CREATE TABLE medication.formulary_entry (
    tenant_id       uuid        NOT NULL,
    medication_system  text NOT NULL CHECK (medication_system <> ''),
    medication_code    text NOT NULL CHECK (medication_code <> ''),
    medication_display text NOT NULL CHECK (medication_display <> ''),
    scope           text        NOT NULL CHECK (scope IN (
                        'tenant', 'facility', 'department', 'payer')),
    -- The facility, department or payer. Empty at tenant scope, which is why it
    -- is part of the key rather than nullable: a null in a key is a row that
    -- can be inserted twice.
    scope_id        text        NOT NULL DEFAULT '',
    status          text        NOT NULL CHECK (status IN (
                        'formulary', 'restricted', 'non_formulary', 'unknown')),
    restriction     text        NOT NULL DEFAULT '',
    -- Where the clinician goes to get this approved. A non-formulary warning
    -- with no path is a dead end, and the prescriber's next move is a phone call
    -- to find out something the system already knew.
    approval_path   text        NOT NULL DEFAULT '',
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, medication_system, medication_code, scope, scope_id),
    CONSTRAINT a_scoped_entry_names_its_scope CHECK (
        scope = 'tenant' OR scope_id <> ''),
    CONSTRAINT a_restriction_says_what_it_is CHECK (
        status <> 'restricted' OR restriction <> ''),
    CONSTRAINT non_formulary_says_how_to_get_approval CHECK (
        status <> 'non_formulary' OR approval_path <> '')
);

-- Configured drug-drug interaction rules (SRS-MED-003).
CREATE TABLE medication.interaction_rule (
    tenant_id       uuid        NOT NULL,
    rule_id         text        NOT NULL CHECK (rule_id <> ''),
    -- Part of the key rather than a column, so publishing a new version leaves
    -- the old one readable: a finding recorded last March names a version, and
    -- a version edited in place is a finding nobody can explain.
    version         text        NOT NULL CHECK (version <> ''),

    left_system     text        NOT NULL CHECK (left_system <> ''),
    left_code       text        NOT NULL CHECK (left_code <> ''),
    left_display    text        NOT NULL CHECK (left_display <> ''),
    right_system    text        NOT NULL CHECK (right_system <> ''),
    right_code      text        NOT NULL CHECK (right_code <> ''),
    right_display   text        NOT NULL CHECK (right_display <> ''),

    severity        text        NOT NULL CHECK (severity IN (
                        'contraindicated', 'severe', 'moderate', 'mild', 'informational')),
    -- A warning that names a problem and no action is one clinicians learn to
    -- dismiss.
    advice          text        NOT NULL CHECK (advice <> ''),
    management      text        NOT NULL DEFAULT '',
    active          boolean     NOT NULL DEFAULT true,
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, rule_id, version)
);

CREATE INDEX interaction_rule_active
    ON medication.interaction_rule (tenant_id) WHERE active;

-- Configured dose-support rules (SRS-MED-004).
CREATE TABLE medication.dose_rule (
    tenant_id       uuid        NOT NULL,
    rule_id         text        NOT NULL CHECK (rule_id <> ''),
    version         text        NOT NULL CHECK (version <> ''),
    scope           text        NOT NULL CHECK (scope IN (
                        'renal', 'hepatic', 'paediatric')),

    medication_system  text NOT NULL CHECK (medication_system <> ''),
    medication_code    text NOT NULL CHECK (medication_code <> ''),
    medication_display text NOT NULL CHECK (medication_display <> ''),

    max_creatinine_clearance numeric(10,2) NOT NULL DEFAULT 0,
    max_age_years            numeric(10,2) NOT NULL DEFAULT 0,
    advice          text        NOT NULL CHECK (advice <> ''),
    -- SRS-MED-004 applies dose support "when configured and validated". An
    -- unvalidated rule is advice nobody has checked, so it does not run at all
    -- rather than running with a caveat.
    validated       boolean     NOT NULL DEFAULT false,
    validated_by    text        NOT NULL DEFAULT '',
    validated_at    timestamptz,
    active          boolean     NOT NULL DEFAULT true,
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, rule_id, version),
    CONSTRAINT validation_is_whole CHECK (
        NOT validated OR (validated_by <> '' AND validated_at IS NOT NULL))
);

CREATE INDEX dose_rule_runnable
    ON medication.dose_rule (tenant_id) WHERE active AND validated;

-- The tenant's medication policy (SRS-MED-003, SRS-MED-006, SRS-MED-010).
CREATE TABLE medication.policy (
    tenant_id       uuid        PRIMARY KEY,
    -- The most serious finding a clinician may override. Never
    -- 'contraindicated': the domain refuses it and so does this check, because
    -- a prescription for a drug the patient is documented as having had
    -- anaphylaxis to is not something a configuration screen should unlock.
    max_overridable text        NOT NULL DEFAULT 'severe' CHECK (max_overridable IN (
                        'severe', 'moderate', 'mild', 'informational')),
    verification_required boolean NOT NULL DEFAULT true,
    -- Classes that always need a pharmacist even when verification is otherwise
    -- off: a hospital that cannot staff overnight pharmacy still wants every
    -- cytotoxic checked.
    verification_classes  text[] NOT NULL DEFAULT '{}',
    -- Classes where a free-text dose is refused (SRS-MED-010).
    structured_dose_classes text[] NOT NULL DEFAULT '{}',
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL
);

-- The medication terminology mapping (SRS-MED-002).
--
-- SRS-MED-002 says the allergy evaluation runs "against medication terminology
-- mapping", and the reason is the case that actually kills people: a
-- prescription for co-amoxiclav must match a recorded allergy to penicillin.
-- Matching on the prescribed code alone misses it, because the chart and the
-- prescription name the drug at different levels of the terminology.
--
-- A table rather than a hard-coded map, because this is exactly what a hospital
-- licenses: a deployment with a real drug database supplies an adapter onto it
-- and never reads these rows, and a deployment without one gets what its
-- pharmacy has configured. What neither does is guess — a medication with no
-- mapping screens on its own code and nothing else, which is a narrower answer
-- rather than a wrong one.
CREATE TABLE medication.terminology_map (
    tenant_id       uuid        NOT NULL,
    medication_system text      NOT NULL CHECK (medication_system <> ''),
    medication_code   text      NOT NULL CHECK (medication_code <> ''),
    medication_display text     NOT NULL CHECK (medication_display <> ''),

    -- The active substances, which is what an allergy is to, and the groups the
    -- medication belongs to. Stored as "system|code|display" triples so a class
    -- keeps the terminology it came from: two coding systems both have a code
    -- "J01C" and they do not mean the same thing.
    ingredients     text[]      NOT NULL DEFAULT '{}',
    classes         text[]      NOT NULL DEFAULT '{}',
    -- What the medication does, for SRS-MED-003's duplicate-therapy check. Two
    -- brands of the same drug share this and share nothing else.
    moiety_system   text        NOT NULL DEFAULT '',
    moiety_code     text        NOT NULL DEFAULT '',
    moiety_display  text        NOT NULL DEFAULT '',

    -- The mapping edition, so an allergy finding recorded last March can name
    -- the version of the map that produced it. SRS-MED-002 requires the rule and
    -- version to be shown, and for an allergy check the map *is* the rule.
    map_version     text        NOT NULL CHECK (map_version <> ''),
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, medication_system, medication_code)
);
