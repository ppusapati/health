-- 0028 Device-sourced observations (SRS-ICU-003, SRS-ICU-002, SRS-ICU-009).
--
-- SRS-ICU-003's acceptance criterion is one sentence: "raw/device-derived
-- values are distinguishable from manually validated chart values". These
-- columns are that distinction.
--
-- It is not bookkeeping. A bedside monitor produces a reading every few seconds
-- and a great many are wrong in ways a human reads past: a saturation probe off
-- a finger reads 60%, an arterial line being flushed reads a systolic of 300, a
-- patient turning over reads asystole. A nurse at the bedside sees a patient
-- who is fine and ignores it. A chart that absorbed those numbers would carry
-- every one of them as fact, and the two consumers that read a chart rather
-- than a patient — the trend and the score — would be computed from artefacts.
-- SRS-ICU-009 says scores are calculated "only from explicit validated inputs",
-- which is what makes this load-bearing.
--
-- Trace: SRS-ICU-002, SRS-ICU-003, SRS-ICU-009, SRS-ICU-012, SRS-CLN-010.
--
-- Rollback: drops the columns, and with them every record of which values a
-- clinician accepted into the chart and which they rejected as artefacts.
-- After a rollback the previous version treats all of them alike, so a
-- rejected probe reading becomes indistinguishable from a confirmed one and
-- any score computed afterwards silently includes both. Safe only where no
-- device feed has ever been ingested: `SELECT count(*) FROM
-- clinical.observation WHERE source <> 'manual'` must be zero first.
--
-- Reconciliation: the default makes the rollout window safe in the direction
-- that matters. Every existing row, and every row the previous version writes
-- during the window, is 'manual'/'not_required' — which is what they are: a
-- person typed them. The new version reads those as validated and includes
-- them in scores exactly as before. The reverse is the constrained direction:
-- a device reading written by the new version and then read by an old replica
-- loses its provisional marking and looks like a chart value, so device
-- ingestion must not be enabled for a tenant until every replica is new.

ALTER TABLE clinical.observation
    -- 'manual' rather than 'unknown' as the default. Every existing row was
    -- typed by a person, and defaulting to a state that excludes them from
    -- scores would make the entire Wave-1 chart provisional overnight — a
    -- migration that empties the ICU's scoring inputs is worse than the gap it
    -- closes.
    ADD COLUMN source text NOT NULL DEFAULT 'manual'
        CHECK (source IN ('manual', 'device', 'imported', 'unknown')),

    ADD COLUMN validation text NOT NULL DEFAULT 'not_required'
        CHECK (validation IN ('not_required', 'pending', 'confirmed', 'rejected')),

    -- Device identity and quality metadata (SRS-ICU-003). device_id already
    -- exists on this table and keeps its meaning — the analyser or monitor;
    -- these describe the stream it came from and what the device said about
    -- its own signal.
    ADD COLUMN device_channel text NOT NULL DEFAULT '',
    ADD COLUMN device_quality text NOT NULL DEFAULT '',
    -- The device's own clock, and ours. Two columns because the gap between
    -- them is what makes a feed stale, and one timestamp cannot show it.
    ADD COLUMN device_observed_at timestamptz,
    ADD COLUMN device_received_at timestamptz,

    ADD COLUMN validated_by text NOT NULL DEFAULT '',
    ADD COLUMN validated_at timestamptz,
    ADD COLUMN validation_note text NOT NULL DEFAULT '';

-- A device reading names its device and carries the device's own timestamp.
-- In the schema rather than only in Go: a reading that cannot be traced to a
-- probe is one nobody can use to find the probe that caused a run of nonsense.
ALTER TABLE clinical.observation
    ADD CONSTRAINT device_readings_name_their_device CHECK (
        source <> 'device' OR (device_id <> '' AND device_observed_at IS NOT NULL)
    );

-- A validated-or-rejected reading names the clinician who decided. The
-- decision is the only evidence a human looked at it at all.
ALTER TABLE clinical.observation
    ADD CONSTRAINT validation_decisions_name_a_clinician CHECK (
        validation NOT IN ('confirmed', 'rejected')
        OR (validated_by <> '' AND validated_at IS NOT NULL)
    );

-- A rejection carries its reason. A run of rejections with reasons is how a
-- failing probe is found; without them it is a column of the word "artefact".
ALTER TABLE clinical.observation
    ADD CONSTRAINT rejections_carry_a_reason CHECK (
        validation <> 'rejected' OR validation_note <> ''
    );

-- What the ICU dashboard sweeps: the readings still waiting for somebody to
-- look at them. Partial, so the index is the size of the outstanding work
-- rather than of every reading a monitor has ever produced — which, at one
-- every few seconds per bed, is the difference that matters.
CREATE INDEX observation_pending_validation_idx
    ON clinical.observation (tenant_id, patient_id, effective_at)
    WHERE validation = 'pending';
