-- 0018 Reschedule and cancel policy, recurring series, waitlist, teleconsult
-- (SRS-SCH-005, SRS-SCH-006, SRS-SCH-013, SRS-SCH-015).
--
-- Trace: SRS-SCH-005 (policy-driven cutoff, reason, fee/refund seam, status
--   history retained), SRS-SCH-006 (waitlist with expiring offers and no
--   duplicate confirmed bookings), SRS-SCH-013 (recurring series),
--   SRS-SCH-015 (teleconsult rules driving link and eligibility).
-- Rollback: drops the policy, series and waitlist tables and the appointment
--   columns. Appointments survive, but a series becomes twelve unrelated
--   bookings nobody can change together, and the notice recorded against past
--   cancellations is lost — which is the evidence a disputed fee turns on.
--   Export before dropping.
-- Reconciliation: the new appointment columns are nullable or defaulted, which
--   reads correctly for every existing row: no appointment was part of a
--   series, none has been rescheduled, and none is a teleconsult. Rows the
--   previous version writes during the rollout window take the same defaults.

-- What notice a facility requires (SRS-SCH-005).
--
-- The policy is data, resolved per facility, because "twenty-four hours" is a
-- decision a hospital makes and not one this system should make for them. It is
-- captured onto each cancellation as it happens, so a policy changed in March
-- cannot retroactively make a February cancellation late.
CREATE TABLE scheduling.cancellation_policy (
    policy_id   uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    -- NULL means every facility in the tenant; a row naming one overrides.
    facility_id uuid,
    notice_hours            integer NOT NULL DEFAULT 24
                                CHECK (notice_hours BETWEEN 0 AND 720),
    -- Usually shorter than cancellation notice: moving an appointment leaves
    -- the clinic able to refill the slot, while cancelling on the day does not.
    reschedule_notice_hours integer NOT NULL DEFAULT 4
                                CHECK (reschedule_notice_hours BETWEEN 0 AND 720),
    -- A booking rescheduled eleven times is a patient who is not coming, and
    -- each move costs a slot somebody else could have used. 0 means unlimited.
    max_reschedules         integer NOT NULL DEFAULT 3
                                CHECK (max_reschedules BETWEEN 0 AND 50),
    -- Whether a late cancellation is referred to billing at all. This system
    -- never charges anybody: SRS-BIL owns what it costs.
    chargeable_when_late    boolean NOT NULL DEFAULT false,

    -- Teleconsult rules (SRS-SCH-015). On the same row because both are
    -- "what this facility permits", and a second table would be a second
    -- lookup for one boolean.
    teleconsult_enabled     boolean NOT NULL DEFAULT false,
    -- Empty means every visit type the roster offers remotely. A procedure
    -- that needs the patient in the room is what this restricts.
    teleconsult_visit_types text[]  NOT NULL DEFAULT '{}',
    -- Identifying somebody over video is materially harder than at a desk.
    teleconsult_requires_confirmed_identity boolean NOT NULL DEFAULT false,

    created_at  timestamptz NOT NULL,
    updated_at  timestamptz NOT NULL
);

CREATE UNIQUE INDEX cancellation_policy_scope_key
    ON scheduling.cancellation_policy (
        tenant_id,
        COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid)
    );

-- A recurring course of appointments (SRS-SCH-013).
CREATE TABLE scheduling.appointment_series (
    series_id     uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    patient_id    uuid        NOT NULL,
    resource_id   uuid        NOT NULL REFERENCES scheduling.resource (resource_id),
    visit_type    text        NOT NULL,
    -- Daily at the shortest; beyond a quarter between sessions is two separate
    -- referrals rather than one course.
    interval_days integer     NOT NULL CHECK (interval_days BETWEEN 1 AND 90),
    occurrences   integer     NOT NULL CHECK (occurrences BETWEEN 2 AND 52),
    starts_at     timestamptz NOT NULL,
    created_by    text        NOT NULL CHECK (created_by <> ''),
    created_at    timestamptz NOT NULL,
    -- A course stopped after four sessions is four sessions of treatment, not
    -- none: the appointments already attended stay.
    cancelled     boolean     NOT NULL DEFAULT false
);

CREATE INDEX appointment_series_patient_idx
    ON scheduling.appointment_series (tenant_id, patient_id, starts_at DESC);

-- Patients waiting for an earlier slot (SRS-SCH-006).
CREATE TABLE scheduling.waitlist_entry (
    waitlist_id  uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    patient_id   uuid        NOT NULL,
    resource_id  uuid        REFERENCES scheduling.resource (resource_id),
    facility_id  uuid,
    org_unit_id  uuid,
    visit_type   text        NOT NULL DEFAULT '',
    -- A patient who cannot come before Thursday should not be offered
    -- Wednesday.
    not_before   timestamptz,
    not_after    timestamptz,
    -- The booking this patient already holds, if any. An earlier slot accepted
    -- becomes a reschedule of it rather than a second booking, which is the
    -- "cannot create duplicate confirmed bookings" half of the criterion.
    appointment_id uuid      REFERENCES scheduling.appointment (appointment_id),
    status       text        NOT NULL CHECK (status IN (
                     'waiting', 'offered', 'accepted', 'declined',
                     'expired', 'withdrawn')),

    -- The live offer. A slot promised to somebody who has stopped reading
    -- their messages is capacity nobody can use, so it expires.
    offered_slot_at  timestamptz,
    offer_expires_at timestamptz,

    created_by   text        NOT NULL CHECK (created_by <> ''),
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL,

    -- Waiting for nothing in particular produces an offer for anything at all.
    CONSTRAINT waitlist_entries_wait_for_something CHECK (
        resource_id IS NOT NULL OR org_unit_id IS NOT NULL OR facility_id IS NOT NULL
    ),
    -- An offered entry without an expiry is a slot held forever.
    CONSTRAINT offers_expire CHECK (
        status <> 'offered'
        OR (offered_slot_at IS NOT NULL AND offer_expires_at IS NOT NULL)
    )
);

-- The list a scheduler works when a slot frees up, and the sweep that expires
-- stale offers. Partial: settled entries are history.
CREATE INDEX waitlist_open_idx
    ON scheduling.waitlist_entry (tenant_id, created_at)
    WHERE status IN ('waiting', 'offered');

CREATE INDEX waitlist_patient_idx
    ON scheduling.waitlist_entry (tenant_id, patient_id, created_at DESC);

-- One live waitlist entry per patient per resource.
--
-- A patient added to the same list twice is offered the same slot twice, and
-- the second offer is one nobody can honour.
CREATE UNIQUE INDEX waitlist_one_live_per_patient_key
    ON scheduling.waitlist_entry (
        tenant_id, patient_id,
        COALESCE(resource_id, '00000000-0000-0000-0000-000000000000'::uuid),
        COALESCE(org_unit_id, '00000000-0000-0000-0000-000000000000'::uuid)
    )
    WHERE status IN ('waiting', 'offered');

-- Series membership and reschedule history on the appointment.
ALTER TABLE scheduling.appointment
    ADD COLUMN series_id uuid REFERENCES scheduling.appointment_series (series_id);

ALTER TABLE scheduling.appointment
    ADD COLUMN occurrence integer;

-- Carried forward across a reschedule chain, because a policy capping
-- reschedules is about the patient rather than about any one row.
ALTER TABLE scheduling.appointment
    ADD COLUMN reschedule_count integer NOT NULL DEFAULT 0
        CHECK (reschedule_count >= 0);

-- Where a teleconsult happens (SRS-SCH-015). Empty for an in-person
-- appointment: one carrying a link invites a patient to stay home.
ALTER TABLE scheduling.appointment
    ADD COLUMN join_url text NOT NULL DEFAULT '';

ALTER TABLE scheduling.appointment
    ADD CONSTRAINT only_teleconsults_have_a_link CHECK (
        visit_mode = 'teleconsult' OR join_url = ''
    );

CREATE INDEX appointment_series_idx
    ON scheduling.appointment (tenant_id, series_id, starts_at)
    WHERE series_id IS NOT NULL;

-- What the policy made of a cancellation or a reschedule, captured at the
-- moment of the decision (SRS-SCH-005).
--
-- Its own table rather than columns on the appointment, because one booking can
-- be rescheduled several times and each move has its own notice. Append-only:
-- the record a disputed fee turns on is the one written at the time.
CREATE TABLE scheduling.appointment_policy_outcome (
    outcome_id     uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    appointment_id uuid        NOT NULL
                       REFERENCES scheduling.appointment (appointment_id)
                       ON DELETE CASCADE,
    kind           text        NOT NULL CHECK (kind IN ('cancellation', 'reschedule')),
    timely         boolean     NOT NULL,
    -- Stored rather than derived later: "cancelled 23 hours before" is the fact
    -- a dispute turns on, and recomputing it from two timestamps months later
    -- invites a rounding argument.
    notice_given_minutes    integer NOT NULL CHECK (notice_given_minutes >= 0),
    notice_required_minutes integer NOT NULL CHECK (notice_required_minutes >= 0),
    -- Referred to billing. This system never charges: SRS-BIL owns what it
    -- costs, and this row is what it reads.
    chargeable     boolean     NOT NULL DEFAULT false,
    decided_by     text        NOT NULL CHECK (decided_by <> ''),
    decided_at     timestamptz NOT NULL,
    reason         text        NOT NULL DEFAULT ''
);

CREATE INDEX appointment_policy_outcome_idx
    ON scheduling.appointment_policy_outcome (tenant_id, appointment_id, decided_at);

-- The billing worklist: late cancellations awaiting a decision on a fee.
CREATE INDEX appointment_policy_outcome_chargeable_idx
    ON scheduling.appointment_policy_outcome (tenant_id, decided_at)
    WHERE chargeable;
