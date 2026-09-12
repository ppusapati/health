DROP TABLE IF EXISTS empi.patient_photo;
DROP TABLE IF EXISTS empi.field_access_policy;

DROP INDEX IF EXISTS empi.patient_unidentified_idx;

ALTER TABLE empi.patient
    DROP CONSTRAINT IF EXISTS apparent_age_is_an_estimate;
ALTER TABLE empi.patient
    DROP CONSTRAINT IF EXISTS identification_follows_a_designation;

ALTER TABLE empi.patient DROP COLUMN IF EXISTS identified_at;
ALTER TABLE empi.patient DROP COLUMN IF EXISTS designation_apparent_age;
ALTER TABLE empi.patient DROP COLUMN IF EXISTS designation_circumstance;
ALTER TABLE empi.patient DROP COLUMN IF EXISTS designation_label;
