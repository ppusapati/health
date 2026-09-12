ALTER TABLE scheduling.cancellation_policy
    DROP COLUMN IF EXISTS reminder_hours_before;
ALTER TABLE scheduling.cancellation_policy
    DROP COLUMN IF EXISTS notification_kinds;

DROP TABLE IF EXISTS scheduling.appointment_notification;

DROP INDEX IF EXISTS scheduling.appointment_queue_idx;
DROP INDEX IF EXISTS scheduling.appointment_token_key;

ALTER TABLE scheduling.appointment
    DROP CONSTRAINT IF EXISTS check_ins_are_complete;
ALTER TABLE scheduling.appointment
    DROP CONSTRAINT IF EXISTS priority_above_standard_explains_itself;

ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS priority_reason;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS priority;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS checked_in_at;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS arrival_mode;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS token;

-- Restoring NOT NULL would fail against any walk-in row, which is correct:
-- walk-ins cannot exist under the previous schema, so they must be resolved
-- before rolling back.
ALTER TABLE scheduling.appointment
    ALTER COLUMN slot_id SET NOT NULL;

DROP TABLE IF EXISTS scheduling.queue_counter;
