DROP INDEX IF EXISTS empi.patient_identifier_unverified_idx;

ALTER TABLE empi.patient_identifier
    DROP CONSTRAINT IF EXISTS verified_identifiers_say_when_and_by_whom;

ALTER TABLE empi.patient_identifier
    DROP COLUMN IF EXISTS verified_at,
    DROP COLUMN IF EXISTS assurance;
