DROP TABLE IF EXISTS scheduling.appointment_policy_outcome;

DROP INDEX IF EXISTS scheduling.appointment_series_idx;

ALTER TABLE scheduling.appointment
    DROP CONSTRAINT IF EXISTS only_teleconsults_have_a_link;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS join_url;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS reschedule_count;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS occurrence;
ALTER TABLE scheduling.appointment DROP COLUMN IF EXISTS series_id;

DROP TABLE IF EXISTS scheduling.waitlist_entry;
DROP TABLE IF EXISTS scheduling.appointment_series;
DROP TABLE IF EXISTS scheduling.cancellation_policy;
