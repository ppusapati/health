-- Dietetics and kitchen operations (SRS-DIET-001 … 009).
--
-- Every statement is tenant-scoped in its WHERE clause as well as by the
-- caller's verified scope (FIT-03).
--
-- Nothing here deletes. A cancelled diet is a decision somebody made, a
-- withheld tray is the record of a patient who was about to be given food
-- they must not have, and a superseded census is what the kitchen cooked to
-- before the ward changed. All three are the answer to a question somebody
-- asks later.
--
-- Nothing here writes an order or a prescription. The support plan's
-- order_ref is a reference into the context that owns it, and this context
-- never follows it.

-- name: InsertDietAssessment :exec
INSERT INTO hospital_ops_diet.nutrition_assessment (
    assessment_id, tenant_id, patient_id, encounter_id, facility_id,
    height_mm, weight_g, mid_upper_arm_mm, estimated, measured_at,
    intake_summary, diagnosis_code, diagnosis, allergy_refs,
    energy_kcal, protein_g, fluid_ml, requirement_basis,
    risk_tool, risk_score, state, created_at, created_by
) VALUES (
    @assessment_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @height_mm, @weight_g, @mid_upper_arm_mm, @estimated, @measured_at,
    @intake_summary, @diagnosis_code, @diagnosis, @allergy_refs,
    @energy_kcal, @protein_g, @fluid_ml, @requirement_basis,
    @risk_tool, @risk_score, @state, @created_at, @created_by
);

-- name: GetDietAssessment :one
SELECT * FROM hospital_ops_diet.nutrition_assessment
WHERE tenant_id = @tenant_id AND assessment_id = @assessment_id;

-- name: SignDietAssessment :execrows
UPDATE hospital_ops_diet.nutrition_assessment
SET state = 'signed', signed_by = @signed_by, signed_at = @signed_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND assessment_id = @assessment_id
  AND state = 'draft' AND version = @expected_version;

-- name: ListDietAssessments :many
SELECT * FROM hospital_ops_diet.nutrition_assessment
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@encounter_id::text = '' OR encounter_id = @encounter_id)
  AND (NOT @signed_only::boolean OR state = 'signed')
ORDER BY created_at DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertDietOrder :exec
INSERT INTO hospital_ops_diet.diet_order (
    order_id, tenant_id, patient_id, encounter_id, facility_id, ward_id,
    bed_id, route, texture_code, texture_label, fluid_code, restrictions,
    supplements, instruction, effective_from, effective_to, state,
    placed_at, placed_by
) VALUES (
    @order_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @ward_id, @bed_id, @route, @texture_code, @texture_label, @fluid_code,
    @restrictions, @supplements, @instruction, @effective_from,
    @effective_to, @state, @placed_at, @placed_by
);

-- name: GetDietOrder :one
SELECT * FROM hospital_ops_diet.diet_order
WHERE tenant_id = @tenant_id AND order_id = @order_id;

-- name: UpdateDietOrder :execrows
UPDATE hospital_ops_diet.diet_order
SET state = @state, effective_to = @effective_to,
    cancelled_reason = @cancelled_reason, cancelled_by = @cancelled_by,
    cancelled_at = @cancelled_at, version = version + 1
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND version = @expected_version;

-- name: SupersedeDietOrders :execrows
UPDATE hospital_ops_diet.diet_order
SET state = 'superseded',
    effective_to = LEAST(COALESCE(effective_to, @at), @at::timestamptz),
    version = version + 1
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND order_id <> @keep_order_id
  AND state IN ('pending', 'active');

-- name: ListDietOrdersForPatient :many
SELECT * FROM hospital_ops_diet.diet_order
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY effective_from DESC, placed_at DESC
LIMIT @page_limit;

-- The kitchen's read: every order on a ward that could be in force, which
-- the domain then narrows to exactly one per patient.
-- name: ListDietOrdersForWard :many
SELECT * FROM hospital_ops_diet.diet_order
WHERE tenant_id = @tenant_id
  AND (@ward_id::text = '' OR ward_id = @ward_id)
  AND state IN ('pending', 'active')
ORDER BY patient_id, effective_from DESC
LIMIT @page_limit;

-- name: InsertDietConflict :exec
INSERT INTO hospital_ops_diet.order_conflict (
    conflict_id, tenant_id, order_id, allergy_ref, substance, item, severity
) VALUES (
    @conflict_id, @tenant_id, @order_id, @allergy_ref, @substance, @item,
    @severity
);

-- name: ListDietConflicts :many
SELECT * FROM hospital_ops_diet.order_conflict
WHERE tenant_id = @tenant_id AND order_id = @order_id
ORDER BY item, allergy_ref;

-- name: ResolveDietConflict :execrows
UPDATE hospital_ops_diet.order_conflict
SET resolved_by = @resolved_by, resolved_at = @resolved_at,
    resolution_note = @resolution_note
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND allergy_ref = @allergy_ref
  AND (@item::text = '' OR lower(item) = lower(@item))
  AND resolved_at IS NULL;

-- name: InsertDietCarePlan :exec
INSERT INTO hospital_ops_diet.care_plan (
    plan_id, tenant_id, patient_id, encounter_id, assessment_id, plan,
    review_due, state, created_at, created_by
) VALUES (
    @plan_id, @tenant_id, @patient_id, @encounter_id, @assessment_id, @plan,
    @review_due, @state, @created_at, @created_by
);

-- name: InsertDietCarePlanGoal :exec
INSERT INTO hospital_ops_diet.care_plan_goal (
    goal_id, tenant_id, plan_id, code, label, target, unit, direction,
    tolerance, target_by
) VALUES (
    @goal_id, @tenant_id, @plan_id, @code, @label, @target, @unit,
    @direction, @tolerance, @target_by
);

-- name: GetDietCarePlan :one
SELECT * FROM hospital_ops_diet.care_plan
WHERE tenant_id = @tenant_id AND plan_id = @plan_id;

-- name: ListDietCarePlanGoals :many
SELECT * FROM hospital_ops_diet.care_plan_goal
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
ORDER BY code;

-- name: CloseDietCarePlan :execrows
UPDATE hospital_ops_diet.care_plan
SET state = 'closed', closed_at = @closed_at, closed_by = @closed_by,
    closure_note = @closure_note, version = version + 1
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
  AND state = 'active' AND version = @expected_version;

-- name: ListDietCarePlans :many
SELECT * FROM hospital_ops_diet.care_plan
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (NOT @open_only::boolean OR state = 'active')
ORDER BY created_at DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertDietProgress :exec
INSERT INTO hospital_ops_diet.care_plan_progress (
    progress_id, tenant_id, plan_id, goal_code, value, unit, note,
    recorded_at, recorded_by
) VALUES (
    @progress_id, @tenant_id, @plan_id, @goal_code, @value, @unit, @note,
    @recorded_at, @recorded_by
);

-- name: ListDietProgress :many
SELECT * FROM hospital_ops_diet.care_plan_progress
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
  AND (@goal_code::text = '' OR goal_code = @goal_code)
ORDER BY recorded_at;

-- The freeze columns are written here as well as by FreezeDietCensus,
-- because a census handed to the adapter already frozen must land as the
-- caller gave it. An insert that silently dropped them would produce a row
-- claiming to be frozen with nobody's name on it, which the database refuses
-- outright rather than storing.
-- name: InsertDietCensus :exec
INSERT INTO hospital_ops_diet.meal_census (
    census_id, tenant_id, facility_id, ward_id, cycle, service_date,
    cutoff_at, state, census_version, supersedes_id, frozen_at, frozen_by,
    built_at, built_by
) VALUES (
    @census_id, @tenant_id, @facility_id, @ward_id, @cycle, @service_date,
    @cutoff_at, @state, @census_version, @supersedes_id, @frozen_at,
    @frozen_by, @built_at, @built_by
);

-- name: InsertDietCensusLine :exec
INSERT INTO hospital_ops_diet.census_line (
    line_id, tenant_id, census_id, patient_id, encounter_id, ward_id,
    bed_id, order_id, route, texture_code, texture_label, fluid_code,
    restrictions, supplements, instruction
) VALUES (
    @line_id, @tenant_id, @census_id, @patient_id, @encounter_id, @ward_id,
    @bed_id, @order_id, @route, @texture_code, @texture_label, @fluid_code,
    @restrictions, @supplements, @instruction
);

-- name: GetDietCensus :one
SELECT * FROM hospital_ops_diet.meal_census
WHERE tenant_id = @tenant_id AND census_id = @census_id;

-- name: ListDietCensusLines :many
SELECT * FROM hospital_ops_diet.census_line
WHERE tenant_id = @tenant_id AND census_id = @census_id
ORDER BY bed_id, patient_id;

-- name: FreezeDietCensus :execrows
UPDATE hospital_ops_diet.meal_census
SET state = 'frozen', frozen_at = @frozen_at, frozen_by = @frozen_by
WHERE tenant_id = @tenant_id AND census_id = @census_id AND state = 'draft';

-- name: SupersedeDietCensus :execrows
UPDATE hospital_ops_diet.meal_census
SET state = 'superseded'
WHERE tenant_id = @tenant_id AND census_id = @census_id AND state = 'frozen';

-- name: ListDietCensuses :many
SELECT * FROM hospital_ops_diet.meal_census
WHERE tenant_id = @tenant_id
  AND (@ward_id::text = '' OR ward_id = @ward_id)
  AND (@cycle::text = '' OR cycle = @cycle)
  AND (@from_date::timestamptz = '-infinity'::timestamptz
       OR service_date >= @from_date)
  AND (@to_date::timestamptz = 'infinity'::timestamptz
       OR service_date <= @to_date)
ORDER BY service_date DESC, cycle, ward_id, census_version DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertDietTray :exec
INSERT INTO hospital_ops_diet.meal_tray (
    tray_id, tenant_id, census_id, patient_id, ward_id, bed_id, cycle,
    order_id, state, due_by
) VALUES (
    @tray_id, @tenant_id, @census_id, @patient_id, @ward_id, @bed_id,
    @cycle, @order_id, @state, @due_by
);

-- name: GetDietTray :one
SELECT * FROM hospital_ops_diet.meal_tray
WHERE tenant_id = @tenant_id AND tray_id = @tray_id;

-- name: UpdateDietTray :execrows
UPDATE hospital_ops_diet.meal_tray
SET state = @state, reason = @reason,
    prepared_at = @prepared_at, prepared_by = @prepared_by,
    dispatched_at = @dispatched_at, dispatched_by = @dispatched_by,
    delivered_at = @delivered_at, delivered_by = @delivered_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND tray_id = @tray_id
  AND version = @expected_version;

-- name: ListDietTrays :many
SELECT * FROM hospital_ops_diet.meal_tray
WHERE tenant_id = @tenant_id
  AND (@census_id::uuid = '00000000-0000-0000-0000-000000000000'::uuid
       OR census_id = @census_id)
  AND (@ward_id::text = '' OR ward_id = @ward_id)
  AND (@state::text = '' OR state = @state)
ORDER BY bed_id, patient_id
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertDietSupportPlan :exec
INSERT INTO hospital_ops_diet.support_plan (
    plan_id, tenant_id, patient_id, encounter_id, kind, formula_code,
    formula_name, target_volume_ml, target_energy_kcal, target_protein_g,
    ramp_plan, state, created_at, created_by
) VALUES (
    @plan_id, @tenant_id, @patient_id, @encounter_id, @kind, @formula_code,
    @formula_name, @target_volume_ml, @target_energy_kcal,
    @target_protein_g, @ramp_plan, @state, @created_at, @created_by
);

-- name: GetDietSupportPlan :one
SELECT * FROM hospital_ops_diet.support_plan
WHERE tenant_id = @tenant_id AND plan_id = @plan_id;

-- name: UpdateDietSupportPlan :execrows
UPDATE hospital_ops_diet.support_plan
SET state = @state, order_ref = @order_ref, order_context = @order_context,
    stopped_at = @stopped_at, stopped_by = @stopped_by,
    stop_reason = @stop_reason, version = version + 1
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
  AND version = @expected_version;

-- name: ListDietSupportPlans :many
SELECT * FROM hospital_ops_diet.support_plan
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (NOT @active_only::boolean OR state = 'active')
ORDER BY created_at DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertDietRecipe :exec
INSERT INTO hospital_ops_diet.recipe (recipe_id, tenant_id, code, name)
VALUES (@recipe_id, @tenant_id, @code, @name);

-- name: InsertDietRecipeIngredient :exec
INSERT INTO hospital_ops_diet.recipe_ingredient (
    ingredient_id, tenant_id, recipe_id, code, name, grams
) VALUES (@ingredient_id, @tenant_id, @recipe_id, @code, @name, @grams);

-- name: InsertDietMenuItem :exec
INSERT INTO hospital_ops_diet.menu_item (
    menu_item_id, tenant_id, recipe_id, cycle, texture_code, portions
) VALUES (
    @menu_item_id, @tenant_id, @recipe_id, @cycle, @texture_code, @portions
);

-- name: ListDietMenu :many
SELECT m.menu_item_id, m.cycle, m.texture_code, m.portions,
       r.recipe_id, r.code AS recipe_code, r.name AS recipe_name
FROM hospital_ops_diet.menu_item m
JOIN hospital_ops_diet.recipe r
  ON r.recipe_id = m.recipe_id AND r.tenant_id = m.tenant_id
WHERE m.tenant_id = @tenant_id
  AND (@cycle::text = '' OR m.cycle = @cycle)
ORDER BY m.cycle, m.texture_code, r.code;

-- name: ListDietRecipeIngredients :many
SELECT * FROM hospital_ops_diet.recipe_ingredient
WHERE tenant_id = @tenant_id AND recipe_id = @recipe_id
ORDER BY code;

-- name: InsertDietConsumption :exec
INSERT INTO hospital_ops_diet.ingredient_consumption (
    consumption_id, tenant_id, census_id, ingredient_code, actual_g, note,
    recorded_at, recorded_by
) VALUES (
    @consumption_id, @tenant_id, @census_id, @ingredient_code, @actual_g,
    @note, @recorded_at, @recorded_by
);

-- name: ListDietConsumption :many
SELECT * FROM hospital_ops_diet.ingredient_consumption
WHERE tenant_id = @tenant_id AND census_id = @census_id
ORDER BY ingredient_code, recorded_at;

-- name: InsertDietItem :exec
INSERT INTO hospital_ops_diet.diet_item (
    item_id, tenant_id, code, name, kind, allergen_codes
) VALUES (@item_id, @tenant_id, @code, @name, @kind, @allergen_codes);

-- Everything the kitchen could put in front of a patient on this order: the
-- dishes the menu carries at this texture, whatever they are made of, and the
-- supplements the order names. Checked against the patient's documented
-- allergies before the order reaches the kitchen (SRS-DIET-003).
-- name: ListDietItemsForOrder :many
SELECT DISTINCT i.item_id, i.tenant_id, i.code, i.name, i.kind,
       i.allergen_codes
FROM hospital_ops_diet.diet_item i
WHERE i.tenant_id = @tenant_id
  AND (
    i.code = ANY (@supplements::text[])
    OR i.code IN (
      SELECT ri.code
      FROM hospital_ops_diet.recipe_ingredient ri
      JOIN hospital_ops_diet.menu_item m
        ON m.recipe_id = ri.recipe_id AND m.tenant_id = ri.tenant_id
      WHERE m.tenant_id = @tenant_id
        AND lower(m.texture_code) = lower(@texture_code)
    )
  )
ORDER BY i.code;
