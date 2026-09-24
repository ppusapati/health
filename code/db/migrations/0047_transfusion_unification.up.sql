-- 0047 One record of a transfusion (SRS-NUR-014, SRS-BLD-010).
--
-- Trace: SRS-NUR-014, SRS-BLD-010, SRS-BLD-011, SRS-BLD-016.
--
-- SRS-NUR-014 built nursing.transfusion in Wave 1, before the blood bank
-- context existed. SRS-BLD-010 built bloodbank.episode in Wave 2. Both record
-- the same clinical event — a unit number, a two-person bedside check,
-- monitoring observations, a reaction — and two records of one transfusion
-- will disagree. This migration leaves one.
--
-- bloodbank.episode is the one that survives, because it is the only one
-- linked to the issue, the component and the collection, and therefore the
-- only one a look-back can run along. Asked "who else received blood from this
-- donation", nursing.transfusion cannot answer: it holds the unit number as
-- free text and nothing behind it.
--
-- Three things happen here, in order.
--
-- Every nursing row whose unit number resolves to a component becomes an
-- episode, with its observations. The bedside pair maps across intact —
-- nursing's started_by and checked_by become the episode's checked_by and
-- checked_with, which the database already refuses to let be the same person.
--
-- A component that already has an episode is skipped. That is the duplication
-- in the flesh: two records of one transfusion, and the episode wins. The
-- nursing row stays behind rather than overwriting it.
--
-- The components that received a migrated episode are marked transfused,
-- unless they were already discarded or found unsuitable. A unit with a
-- completed transfusion against it and a status of 'available' is a unit the
-- shelf will offer to a second patient.
--
-- What is left in nursing.transfusion afterwards is exactly the set that could
-- not be linked: transfusions recorded with no blood-product record behind
-- them, and the duplicates the episode won. The tables are kept and commented
-- rather than dropped, because a transfusion that happened is a transfusion
-- that happened, and losing it to tidy a schema would be the worse defect.
-- Nothing writes them from this release on; the nursing transfusion RPCs are
-- deprecated on the wire and refuse, naming BloodBankService.
--
-- Rollback: irreversible in the sense that matters. The down migration drops
-- the comments and nothing else. Episodes created here are indistinguishable
-- from episodes recorded directly, which is the point of unifying them, and a
-- rollback that tried to split them again would have to guess. A deployment
-- that needs the previous shape restores from backup.
--
-- Reconciliation: the previous version of the service writes
-- nursing.transfusion, and rows it writes after this migration runs are
-- unlinked by construction — they appear in the leftover set and are
-- reconciled by hand. The release notes say to deploy this migration and the
-- service together. Nothing here depends on the order.

-- Every linkable nursing transfusion becomes an episode.
INSERT INTO bloodbank.episode (
    episode_id, tenant_id, component_id, patient_id, encounter_id,
    status, started_at, started_by, ended_at, volume_given_ml,
    stop_reason, checked_by, checked_with
)
SELECT
    t.transfusion_id,
    t.tenant_id,
    c.component_id,
    t.patient_id,
    t.encounter_id,
    CASE t.status
        WHEN 'in_progress' THEN 'running'
        WHEN 'completed'   THEN 'completed'
        ELSE 'stopped'
    END,
    t.started_at,
    t.started_by,
    t.ended_at,
    GREATEST(round(t.volume_ml)::integer, 0),
    -- An abandoned transfusion says why, and nursing's own CHECK guarantees
    -- a stopped row has these.
    CASE WHEN t.status = 'stopped'
        THEN left(coalesce(nullif(t.reaction_features, ''), 'reaction'), 200)
        ELSE '' END,
    t.started_by,
    t.checked_by
FROM nursing.transfusion t
JOIN bloodbank.component c
  ON c.tenant_id = t.tenant_id
 AND c.unit_number = t.unit_number
WHERE NOT EXISTS (
    SELECT 1 FROM bloodbank.episode e
     WHERE e.tenant_id = t.tenant_id
       AND e.component_id = c.component_id
);

-- And their observations.
INSERT INTO bloodbank.observation (
    observation_id, tenant_id, episode_id, timing, values, note,
    observed_at, observed_by
)
SELECT
    o.observation_id,
    o.tenant_id,
    o.transfusion_id,
    CASE WHEN o.baseline THEN 'baseline' ELSE 'monitoring' END,
    jsonb_strip_nulls(jsonb_build_object(
        'temperature_c', nullif(o.temperature_c, 0),
        'pulse',         nullif(o.pulse, 0),
        'systolic_bp',   nullif(o.systolic_bp, 0),
        'respiratory_rate', nullif(o.respiratory_rate, 0)
    )),
    o.notes,
    o.observed_at,
    o.observed_by
FROM nursing.transfusion_observation o
JOIN bloodbank.episode e ON e.episode_id = o.transfusion_id;

-- A unit with a transfusion against it is not on the shelf.
UPDATE bloodbank.component c
   SET status = 'transfused'
  FROM bloodbank.episode e
 WHERE e.component_id = c.component_id
   AND e.episode_id IN (SELECT transfusion_id FROM nursing.transfusion)
   AND c.status NOT IN ('discarded', 'unsuitable', 'transfused');

-- The migrated rows leave nursing, so nothing is recorded twice.
DELETE FROM nursing.transfusion_observation o
 WHERE EXISTS (SELECT 1 FROM bloodbank.episode e
                WHERE e.episode_id = o.transfusion_id);

DELETE FROM nursing.transfusion t
 WHERE EXISTS (SELECT 1 FROM bloodbank.episode e
                WHERE e.episode_id = t.transfusion_id);

COMMENT ON TABLE nursing.transfusion IS
    'Closed to new writes at migration 0047. bloodbank.episode is the record '
    'of a transfusion (SRS-NUR-014, SRS-BLD-010). What remains here is the '
    'set that could not be linked to a blood-product record: units this '
    'deployment never registered, and rows superseded by an episode that '
    'already existed. Kept because a transfusion that happened is a '
    'transfusion that happened; reconcile by registering the component and '
    'recording the episode.';

COMMENT ON TABLE nursing.transfusion_observation IS
    'Closed to new writes at migration 0047. See nursing.transfusion.';
