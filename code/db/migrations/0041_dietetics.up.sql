-- 0041 Dietetics and kitchen operations (SRS-DIET-001 … 009).
--
-- Trace: SRS-DIET-001 … SRS-DIET-009.
--
-- Four shapes here are unusual and deliberate.
--
-- There is no column in this schema a feed could be administered from. No
-- dose, no rate, no bag, no administration record. SRS-DIET-007 is explicit
-- that nutrition support planning must not replace medication and order
-- controls, and the way to mean it is to have nowhere to put the thing that
-- would. hospital_ops_diet.support_plan holds the dietitian's targets and the
-- identifier of the order or prescription carrying them out, and a CHECK
-- refuses an active plan with no such identifier: a hospital where a plan
-- alone starts parenteral nutrition is one where it bypasses pharmacy.
--
-- A tray cannot be delivered without having been dispatched, held by a CHECK.
-- That is SRS-DIET-009's fasting rule at the table. The dispatch is where the
-- order in force is re-read — the census was taken before the production
-- cutoff and the tray leaves afterwards, and in between is where a patient is
-- made nil by mouth for a theatre list. A row that reads as delivered with no
-- dispatch behind it is a meal that reached a patient without that check, and
-- the database will not hold one.
--
-- A meal census is versioned rather than edited. One row per
-- (ward, cycle, service date, version), with a version above one required to
-- name the census it superseded. The frozen census is what the kitchen cooked
-- to, and the question after a wrong tray is always what the count said at
-- the time.
--
-- Allergy conflicts live in their own table and are never a copy of the
-- allergy. hospital_ops_diet.order_conflict carries the clinical record's own
-- reference; the substance beside it is for the dietitian reading the screen
-- and a later question is answered against the reference. A second copy of
-- what a patient is allergic to would go stale the first time somebody
-- corrected one, which is the correction that matters most.
--
-- Rollback: drops the schema. Every nutrition assessment, diet order and its
-- allergy conflicts, care plan and its measurements, meal census, tray,
-- nutrition support plan and ingredient count goes with it. A hospital that
-- rolls this back mid-service loses the record of which patients are nil by
-- mouth, which is the one thing the kitchen must not guess at. Treat it as a
-- disaster-recovery action, never a deployment step, and take the ward's
-- fasting list on paper first.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS hospital_ops_diet;

-- Nutrition assessment (SRS-DIET-001).
CREATE TABLE hospital_ops_diet.nutrition_assessment (
    assessment_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    -- SRS-DIET-001's acceptance. An assessment floating free of an encounter
    -- cannot be found by the team looking after the patient.
    encounter_id text NOT NULL CHECK (encounter_id <> ''),
    facility_id  text NOT NULL DEFAULT '',

    -- Base units as integers. A weight recorded as 72.3 and read back as
    -- 72.30000000000001 fails an equality check in a report nobody expected
    -- to be about floating point.
    height_mm        integer NOT NULL DEFAULT 0 CHECK (height_mm >= 0),
    weight_g         integer NOT NULL DEFAULT 0 CHECK (weight_g >= 0),
    mid_upper_arm_mm integer NOT NULL DEFAULT 0
        CHECK (mid_upper_arm_mm >= 0),
    -- A requirement computed from an estimate is an estimate, and a chart
    -- that cannot tell the two apart hides that.
    estimated   boolean NOT NULL DEFAULT false,
    measured_at timestamptz,

    -- There is no body_mass_index column. It is derived from the height and
    -- the weight beside it, because a stored index that no longer agrees
    -- with them is a third number nobody can explain.

    intake_summary text NOT NULL DEFAULT '',
    diagnosis_code text NOT NULL DEFAULT '',
    diagnosis      text NOT NULL DEFAULT '',
    -- Which entries of the clinical record's allergy list the dietitian saw.
    -- References, never a copy of what the patient is allergic to.
    allergy_refs text[] NOT NULL DEFAULT '{}',

    energy_kcal integer NOT NULL DEFAULT 0 CHECK (energy_kcal >= 0),
    protein_g   integer NOT NULL DEFAULT 0 CHECK (protein_g >= 0),
    fluid_ml    integer NOT NULL DEFAULT 0 CHECK (fluid_ml >= 0),
    requirement_basis text NOT NULL DEFAULT '',

    risk_tool  text    NOT NULL DEFAULT '',
    risk_score integer NOT NULL DEFAULT 0,

    state text NOT NULL CHECK (state IN ('draft', 'signed')),
    signed_by text NOT NULL DEFAULT '',
    signed_at timestamptz,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- A score of 3 means malnourished in one tool and at risk in another.
    CONSTRAINT a_risk_score_names_its_tool CHECK (
        risk_score = 0 OR risk_tool <> ''
    ),
    -- A requirement nobody can reproduce is a number, and the next dietitian
    -- has to decide whether to believe it.
    CONSTRAINT a_requirement_says_how_it_was_calculated CHECK (
        energy_kcal = 0 OR requirement_basis <> ''
    ),
    CONSTRAINT a_signed_assessment_names_who_signed_it CHECK (
        state <> 'signed' OR (signed_by <> '' AND signed_at IS NOT NULL)
    ),
    -- Signed with nothing measured at all is an assessment of nobody. A
    -- mid-upper arm circumference alone counts: in critical care it is often
    -- the only measurement there is.
    CONSTRAINT a_signed_assessment_measured_something CHECK (
        state <> 'signed'
        OR (height_mm > 0 AND weight_g > 0) OR mid_upper_arm_mm > 0
    )
);

CREATE INDEX nutrition_assessment_patient_idx
    ON hospital_ops_diet.nutrition_assessment
       (tenant_id, patient_id, created_at DESC);
CREATE INDEX nutrition_assessment_encounter_idx
    ON hospital_ops_diet.nutrition_assessment (tenant_id, encounter_id);

-- Diet orders (SRS-DIET-002, SRS-DIET-003, SRS-DIET-009).
CREATE TABLE hospital_ops_diet.diet_order (
    order_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    facility_id  text NOT NULL DEFAULT '',
    ward_id      text NOT NULL DEFAULT '',
    bed_id       text NOT NULL DEFAULT '',

    route text NOT NULL CHECK (route IN (
        'oral', 'enteral', 'parenteral', 'npo')),
    -- Configured codes rather than an enum: the national texture descriptor
    -- frameworks differ and a hospital using one should not be forced
    -- through another's vocabulary.
    texture_code  text NOT NULL DEFAULT '',
    texture_label text NOT NULL DEFAULT '',
    fluid_code    text NOT NULL DEFAULT '',
    restrictions  text[] NOT NULL DEFAULT '{}',
    supplements   text[] NOT NULL DEFAULT '{}',
    instruction   text NOT NULL DEFAULT '',

    -- There is no dose column, and no route of administration beyond the four
    -- above. An enteral or parenteral regimen is an order in the context that
    -- owns it; this row records that the patient is fed that way.

    effective_from timestamptz NOT NULL,
    effective_to   timestamptz,

    state text NOT NULL CHECK (state IN (
        'pending', 'active', 'superseded', 'cancelled')),
    cancelled_reason text NOT NULL DEFAULT '',
    cancelled_by     text NOT NULL DEFAULT '',
    cancelled_at     timestamptz,

    placed_at timestamptz NOT NULL,
    placed_by text        NOT NULL CHECK (placed_by <> ''),
    version   bigint      NOT NULL DEFAULT 1,

    -- A dysphagic patient sent a normal tray is an aspiration.
    CONSTRAINT an_oral_order_names_its_texture CHECK (
        route <> 'oral' OR texture_code <> ''
    ),
    -- Nil by mouth with a renal restriction and two supplements attached is
    -- an order two people read two ways, and one of them sends a tray.
    CONSTRAINT nil_by_mouth_carries_nothing_to_eat CHECK (
        route <> 'npo'
        OR (COALESCE(array_length(restrictions, 1), 0) = 0
            AND COALESCE(array_length(supplements, 1), 0) = 0)
    ),
    CONSTRAINT an_order_ends_after_it_starts CHECK (
        effective_to IS NULL OR effective_to > effective_from
    ),
    CONSTRAINT a_cancelled_order_says_why CHECK (
        state <> 'cancelled'
        OR (cancelled_reason <> '' AND cancelled_by <> ''
            AND cancelled_at IS NOT NULL)
    ),
    -- A cancellation that leaves the order in force until midnight is a
    -- cancellation that sends supper.
    CONSTRAINT a_cancelled_order_stops CHECK (
        state <> 'cancelled' OR effective_to IS NOT NULL
    )
);

CREATE INDEX diet_order_patient_idx
    ON hospital_ops_diet.diet_order
       (tenant_id, patient_id, effective_from DESC);
-- The kitchen's read: what is in force on a ward right now.
CREATE INDEX diet_order_live_idx
    ON hospital_ops_diet.diet_order (tenant_id, ward_id, effective_from DESC)
    WHERE state = 'active';

-- Allergy conflicts against a diet order (SRS-DIET-003).
CREATE TABLE hospital_ops_diet.order_conflict (
    conflict_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    order_id    uuid NOT NULL
        REFERENCES hospital_ops_diet.diet_order (order_id) ON DELETE CASCADE,

    -- The clinical record's own reference. What the patient is allergic to
    -- belongs there; a copy here would go stale the first time somebody
    -- corrected one, which is the correction that matters most.
    allergy_ref text NOT NULL CHECK (allergy_ref <> ''),
    -- For the dietitian reading the screen, never for answering a later
    -- question.
    substance text NOT NULL DEFAULT '',
    item      text NOT NULL DEFAULT '',
    -- A conflict against an anaphylaxis is not the same decision as one
    -- against an intolerance, and the person resolving it needs to know.
    severity text NOT NULL DEFAULT '',

    resolved_by     text NOT NULL DEFAULT '',
    resolved_at     timestamptz,
    resolution_note text NOT NULL DEFAULT '',

    -- "Resolved by Dr Rao" is not an answer to why a patient with a
    -- documented peanut allergy is being given a peanut supplement.
    CONSTRAINT a_resolved_conflict_says_why CHECK (
        resolved_at IS NULL
        OR (resolved_by <> '' AND resolution_note <> '')
    )
);

CREATE UNIQUE INDEX order_conflict_unique_idx
    ON hospital_ops_diet.order_conflict
       (tenant_id, order_id, allergy_ref, lower(item));
CREATE INDEX order_conflict_open_idx
    ON hospital_ops_diet.order_conflict (tenant_id, order_id)
    WHERE resolved_at IS NULL;

-- Nutrition care plans (SRS-DIET-004).
CREATE TABLE hospital_ops_diet.care_plan (
    plan_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    -- A plan whose assessment cannot be produced is one nobody can review,
    -- and reviewing it is the whole of the follow-up.
    assessment_id uuid NOT NULL
        REFERENCES hospital_ops_diet.nutrition_assessment (assessment_id),

    plan       text NOT NULL DEFAULT '',
    review_due timestamptz,

    state text NOT NULL CHECK (state IN ('active', 'closed')),
    closed_at    timestamptz,
    closed_by    text NOT NULL DEFAULT '',
    closure_note text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_closed_plan_says_how_it_ended CHECK (
        state <> 'closed'
        OR (closure_note <> '' AND closed_at IS NOT NULL)
    )
);

CREATE INDEX care_plan_patient_idx
    ON hospital_ops_diet.care_plan (tenant_id, patient_id, created_at DESC);

CREATE TABLE hospital_ops_diet.care_plan_goal (
    goal_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    plan_id   uuid NOT NULL
        REFERENCES hospital_ops_diet.care_plan (plan_id) ON DELETE CASCADE,

    code  text NOT NULL CHECK (code <> ''),
    label text NOT NULL DEFAULT '',
    target integer NOT NULL DEFAULT 0,
    unit   text    NOT NULL CHECK (unit <> ''),
    -- "Target 60" is gain for an underweight patient and loss for another,
    -- and a trend that assumed one would report the other as deteriorating.
    direction text NOT NULL CHECK (direction IN (
        'increase', 'decrease', 'maintain')),
    -- Exactly the target is almost never what anybody means about a body
    -- weight.
    tolerance integer NOT NULL DEFAULT 0 CHECK (tolerance >= 0),
    target_by timestamptz
);

-- The same measure twice is two targets, and progress against it is
-- whichever the reader picked.
CREATE UNIQUE INDEX care_plan_goal_code_idx
    ON hospital_ops_diet.care_plan_goal (tenant_id, plan_id, lower(code));

-- Append-only. A trend built from measurements somebody corrected in place is
-- a trend that shows whatever the last editor believed.
CREATE TABLE hospital_ops_diet.care_plan_progress (
    progress_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    plan_id     uuid NOT NULL
        REFERENCES hospital_ops_diet.care_plan (plan_id) ON DELETE CASCADE,

    goal_code text NOT NULL CHECK (goal_code <> ''),
    value     integer NOT NULL,
    unit      text    NOT NULL DEFAULT '',
    note      text    NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> '')
);

CREATE INDEX care_plan_progress_trend_idx
    ON hospital_ops_diet.care_plan_progress
       (tenant_id, plan_id, goal_code, recorded_at);

-- Meal census (SRS-DIET-005).
CREATE TABLE hospital_ops_diet.meal_census (
    census_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    facility_id  text NOT NULL DEFAULT '',
    ward_id      text NOT NULL CHECK (ward_id <> ''),
    cycle text NOT NULL CHECK (cycle IN (
        'breakfast', 'lunch', 'dinner', 'snack')),
    service_date timestamptz NOT NULL,
    -- A census with no cutoff never freezes, and a census that never freezes
    -- is a count nobody can be held to.
    cutoff_at timestamptz NOT NULL,

    state text NOT NULL CHECK (state IN (
        'draft', 'frozen', 'superseded')),
    census_version integer NOT NULL DEFAULT 1 CHECK (census_version > 0),
    supersedes_id  uuid
        REFERENCES hospital_ops_diet.meal_census (census_id),

    frozen_at timestamptz,
    frozen_by text NOT NULL DEFAULT '',

    built_at timestamptz NOT NULL,
    built_by text        NOT NULL CHECK (built_by <> ''),

    CONSTRAINT a_frozen_census_says_who_froze_it CHECK (
        state = 'draft' OR (frozen_by <> '' AND frozen_at IS NOT NULL)
    ),
    -- A reissue that does not name what it replaced leaves two counts for one
    -- service and no way to tell which came first.
    CONSTRAINT a_reissue_names_what_it_replaced CHECK (
        census_version = 1 OR supersedes_id IS NOT NULL
    )
);

-- One version of one service. Two rows for the same version are two answers
-- to what the kitchen cooked to.
CREATE UNIQUE INDEX meal_census_version_idx
    ON hospital_ops_diet.meal_census
       (tenant_id, ward_id, cycle, service_date, census_version);
CREATE INDEX meal_census_service_idx
    ON hospital_ops_diet.meal_census
       (tenant_id, service_date, cycle, ward_id);

CREATE TABLE hospital_ops_diet.census_line (
    line_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    census_id uuid NOT NULL
        REFERENCES hospital_ops_diet.meal_census (census_id)
        ON DELETE CASCADE,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    ward_id      text NOT NULL DEFAULT '',
    bed_id       text NOT NULL DEFAULT '',

    -- The order this line was built from. After a wrong tray that is the
    -- first thing anybody asks.
    order_id uuid NOT NULL
        REFERENCES hospital_ops_diet.diet_order (order_id),
    route         text NOT NULL DEFAULT '',
    texture_code  text NOT NULL DEFAULT '',
    texture_label text NOT NULL DEFAULT '',
    fluid_code    text NOT NULL DEFAULT '',
    restrictions  text[] NOT NULL DEFAULT '{}',
    supplements   text[] NOT NULL DEFAULT '{}',
    instruction   text NOT NULL DEFAULT '',

    -- A census line for a patient who is nil by mouth is a tray plated for
    -- somebody who must not eat.
    CONSTRAINT a_census_line_is_someone_who_eats CHECK (route = 'oral')
);

-- One line per patient per service. Two is two trays for one patient, and a
-- ward count that never reconciles.
CREATE UNIQUE INDEX census_line_patient_idx
    ON hospital_ops_diet.census_line (tenant_id, census_id, patient_id);

-- Meal trays (SRS-DIET-006, SRS-DIET-009).
CREATE TABLE hospital_ops_diet.meal_tray (
    tray_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    census_id uuid NOT NULL
        REFERENCES hospital_ops_diet.meal_census (census_id),

    patient_id text NOT NULL CHECK (patient_id <> ''),
    ward_id    text NOT NULL DEFAULT '',
    bed_id     text NOT NULL DEFAULT '',
    cycle      text NOT NULL DEFAULT '',
    order_id   uuid NOT NULL
        REFERENCES hospital_ops_diet.diet_order (order_id),

    state text NOT NULL CHECK (state IN (
        'planned', 'prepared', 'dispatched', 'delivered',
        'refused', 'missed', 'withheld')),
    reason text NOT NULL DEFAULT '',

    prepared_at   timestamptz,
    prepared_by   text NOT NULL DEFAULT '',
    dispatched_at timestamptz,
    dispatched_by text NOT NULL DEFAULT '',
    delivered_at  timestamptz,
    delivered_by  text NOT NULL DEFAULT '',
    due_by        timestamptz,

    version bigint NOT NULL DEFAULT 1,

    -- SRS-DIET-009 at the table. The dispatch is where the order in force is
    -- re-read, and a row that reads as delivered with no dispatch behind it
    -- is a meal that reached a patient without that check.
    CONSTRAINT a_delivered_tray_was_dispatched CHECK (
        state <> 'delivered'
        OR (dispatched_at IS NOT NULL AND delivered_at IS NOT NULL)
    ),
    CONSTRAINT a_dispatched_tray_says_who_sent_it CHECK (
        state NOT IN ('dispatched', 'delivered')
        OR (dispatched_at IS NOT NULL AND dispatched_by <> '')
    ),
    -- The ward needs to know the meal was held back rather than that it
    -- simply went astray.
    CONSTRAINT a_withheld_tray_says_why CHECK (
        state <> 'withheld' OR reason <> ''
    ),
    -- A patient who has not eaten needs a reason recorded: three of these in
    -- a row is a referral rather than a logistics note.
    CONSTRAINT an_uneaten_meal_says_why CHECK (
        state NOT IN ('refused', 'missed') OR reason <> ''
    )
);

-- One tray per patient per service.
CREATE UNIQUE INDEX meal_tray_patient_idx
    ON hospital_ops_diet.meal_tray (tenant_id, census_id, patient_id);
CREATE INDEX meal_tray_ward_idx
    ON hospital_ops_diet.meal_tray (tenant_id, ward_id, state);

-- Nutrition support plans (SRS-DIET-007).
--
-- There is no dose, rate, bag or administration column here, and that absence
-- is the requirement rather than an omission.
CREATE TABLE hospital_ops_diet.support_plan (
    plan_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    kind text NOT NULL CHECK (kind IN ('enteral', 'parenteral')),

    formula_code text NOT NULL CHECK (formula_code <> ''),
    formula_name text NOT NULL DEFAULT '',
    target_volume_ml   integer NOT NULL DEFAULT 0
        CHECK (target_volume_ml >= 0),
    target_energy_kcal integer NOT NULL DEFAULT 0
        CHECK (target_energy_kcal >= 0),
    target_protein_g   integer NOT NULL DEFAULT 0
        CHECK (target_protein_g >= 0),
    ramp_plan text NOT NULL DEFAULT '',

    -- The order or prescription carrying the plan out, and which context owns
    -- it. "Order 4471" means one thing in orders and another in medication.
    order_ref     text NOT NULL DEFAULT '',
    order_context text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN ('planned', 'active', 'stopped')),
    stopped_at  timestamptz,
    stopped_by  text NOT NULL DEFAULT '',
    stop_reason text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- A hospital where a dietitian's plan alone starts a feed is one where
    -- parenteral nutrition bypasses pharmacy, and the refeeding syndrome
    -- that follows is the reason those checks exist.
    CONSTRAINT an_active_plan_names_its_order CHECK (
        state <> 'active' OR (order_ref <> '' AND order_context <> '')
    ),
    CONSTRAINT a_stopped_plan_says_why CHECK (
        state <> 'stopped'
        OR (stop_reason <> '' AND stopped_at IS NOT NULL)
    )
);

CREATE INDEX support_plan_patient_idx
    ON hospital_ops_diet.support_plan
       (tenant_id, patient_id, created_at DESC);

-- What the kitchen can put on a tray, and what is in it (SRS-DIET-003,
-- SRS-DIET-008).
--
-- The allergen codes live here rather than on the allergy. The clinical
-- record says what the patient reacts to; this says what the food contains,
-- and the conflict check matches the two on codes. Matching on names is how
-- "groundnut oil" gets past a peanut allergy.
CREATE TABLE hospital_ops_diet.diet_item (
    item_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code text NOT NULL CHECK (code <> ''),
    name text NOT NULL DEFAULT '',
    kind text NOT NULL CHECK (kind IN (
        'ingredient', 'supplement', 'dish')),
    allergen_codes text[] NOT NULL DEFAULT '{}'
);

CREATE UNIQUE INDEX diet_item_code_idx
    ON hospital_ops_diet.diet_item (tenant_id, lower(code));

-- Recipes and the menu (SRS-DIET-008).
CREATE TABLE hospital_ops_diet.recipe (
    recipe_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code text NOT NULL CHECK (code <> ''),
    name text NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX recipe_code_idx
    ON hospital_ops_diet.recipe (tenant_id, lower(code));

CREATE TABLE hospital_ops_diet.recipe_ingredient (
    ingredient_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    recipe_id     uuid NOT NULL
        REFERENCES hospital_ops_diet.recipe (recipe_id) ON DELETE CASCADE,

    code text NOT NULL CHECK (code <> ''),
    name text NOT NULL DEFAULT '',
    -- Grams. A recipe in kilograms to two decimal places is one whose
    -- hundred-portion forecast is out by a few hundred grams for no reason
    -- anybody can find.
    grams integer NOT NULL DEFAULT 0 CHECK (grams >= 0)
);

CREATE UNIQUE INDEX recipe_ingredient_code_idx
    ON hospital_ops_diet.recipe_ingredient
       (tenant_id, recipe_id, lower(code));

CREATE TABLE hospital_ops_diet.menu_item (
    menu_item_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    recipe_id    uuid NOT NULL
        REFERENCES hospital_ops_diet.recipe (recipe_id) ON DELETE CASCADE,

    cycle text NOT NULL CHECK (cycle IN (
        'breakfast', 'lunch', 'dinner', 'snack')),
    -- A pureed lunch and a normal lunch are different dishes with different
    -- ingredients, and a forecast that ignored texture would order the wrong
    -- things for the patients least able to eat them.
    texture_code text NOT NULL CHECK (texture_code <> ''),
    portions     integer NOT NULL DEFAULT 1 CHECK (portions > 0)
);

CREATE UNIQUE INDEX menu_item_unique_idx
    ON hospital_ops_diet.menu_item
       (tenant_id, cycle, lower(texture_code), recipe_id);

-- What the kitchen actually used (SRS-DIET-008).
--
-- Append-only and separate from the forecast. A single variance figure cannot
-- say whether the kitchen over-ordered or over-served.
CREATE TABLE hospital_ops_diet.ingredient_consumption (
    consumption_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,
    census_id      uuid NOT NULL
        REFERENCES hospital_ops_diet.meal_census (census_id),

    ingredient_code text NOT NULL CHECK (ingredient_code <> ''),
    actual_g        integer NOT NULL CHECK (actual_g >= 0),
    note            text NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> '')
);

CREATE INDEX ingredient_consumption_census_idx
    ON hospital_ops_diet.ingredient_consumption (tenant_id, census_id);
