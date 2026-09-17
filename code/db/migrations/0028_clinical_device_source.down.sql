DROP INDEX IF EXISTS clinical.observation_pending_validation_idx;

ALTER TABLE clinical.observation
    DROP CONSTRAINT IF EXISTS rejections_carry_a_reason,
    DROP CONSTRAINT IF EXISTS validation_decisions_name_a_clinician,
    DROP CONSTRAINT IF EXISTS device_readings_name_their_device,
    DROP COLUMN IF EXISTS validation_note,
    DROP COLUMN IF EXISTS validated_at,
    DROP COLUMN IF EXISTS validated_by,
    DROP COLUMN IF EXISTS device_received_at,
    DROP COLUMN IF EXISTS device_observed_at,
    DROP COLUMN IF EXISTS device_quality,
    DROP COLUMN IF EXISTS device_channel,
    DROP COLUMN IF EXISTS validation,
    DROP COLUMN IF EXISTS source;
