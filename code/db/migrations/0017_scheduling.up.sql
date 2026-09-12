-- 0017 Scheduling: resources, rosters, slots and appointments
-- (SRS-SCH-001 … 004, SRS-SCH-008, SRS-SCH-014).
--
-- The shape here is one decision: a roster is a rule, and slots are generated
-- from it on every search rather than materialised in advance.
--
-- A materialised diary goes stale the instant a roster changes, and the stale
-- entries are indistinguishable from the good ones. A patient books a Tuesday
-- that no longer exists and nobody finds out until they arrive. Generating on
-- read makes SRS-SCH-003's criterion — "slot search reflects active roster and
-- exceptions" — true by construction rather than by a refresh job whose failure
-- nobody notices.
--
-- Slot rows exist anyway, but only where capacity is actually consumed, and for
-- exactly one purpose: to be the row a booking locks. SRS-SCH-004 requires
-- booking to be atomic and never to exceed capacity under concurrency, and the
-- only thing that reliably delivers that is a single statement taking a row
-- lock — the same reasoning as the numbering sequence behind SRS-EMPI-016. A
-- check-then-insert is a race two concurrent bookings both win.
--
-- Trace: SRS-SCH-001 (rosters with facility, department, visit type, slot
--   duration, capacity, effective dates), SRS-SCH-002 (exceptions),
--   SRS-SCH-003 (slot search), SRS-SCH-004 (atomic booking, no overbooking),
--   SRS-SCH-008 (queue states and history), SRS-SCH-014 (inactive resources).
-- Rollback: drops the whole schema. Every future appointment is lost, which is
--   a clinic that does not know who is coming tomorrow. Export the appointment
--   and slot tables before dropping, and note that the roster can be rebuilt
--   from configuration while the bookings cannot.
-- Reconciliation: none for the forward direction; the schema is new. Rows the
--   previous version writes during the rollout window are impossible — it does
--   not know these tables exist.

CREATE SCHEMA IF NOT EXISTS scheduling;

-- Something a patient can be booked with (SRS-SCH-001, SRS-SCH-014).
--
-- A clinician and an operating theatre are the same thing to a diary:
-- something with finite time that two people cannot have at once. A schedule
-- that could attach only to a person could not express "this scanner, forty
-- minutes, one patient at a time", and a hospital's scarcest resources are
-- usually not people.
--
-- Deliberately NOT a practitioner master. Registration numbers, credentials,
-- privileges and employment belong to an HR and credentialing context Wave 1
-- does not build; subject_id is the seam that names the identity a roster is
-- for.
CREATE TABLE scheduling.resource (
    resource_id   uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    facility_id   uuid        NOT NULL,
    -- The department or specialty, for the "search by specialty" half of
    -- SRS-SCH-003 — how a patient books without knowing a clinician's name.
    org_unit_id   uuid,
    resource_type text        NOT NULL CHECK (resource_type IN (
                      'practitioner', 'room', 'equipment')),
    -- Empty for a room or a machine, which are nobody.
    subject_id    text        NOT NULL DEFAULT '',
    display_name  text        NOT NULL CHECK (display_name <> ''),
    status        text        NOT NULL CHECK (status IN ('active', 'inactive')),
    -- The facility's zone, carried here so slot generation needs no second
    -- lookup per resource. A diary is written in local time and nothing else
    -- makes sense to the people reading it.
    time_zone     text        NOT NULL CHECK (time_zone <> ''),
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,

    -- A room is nobody, and a practitioner diary that cannot be tied to the
    -- practitioner leaves "my appointments" with no answer.
    CONSTRAINT only_practitioners_have_a_subject CHECK (
        (resource_type = 'practitioner' AND subject_id <> '')
        OR (resource_type <> 'practitioner' AND subject_id = '')
    )
);

CREATE INDEX resource_facility_idx
    ON scheduling.resource (tenant_id, facility_id, status);

-- Finding a clinician's own diary. Partial: rooms have no subject.
CREATE INDEX resource_subject_idx
    ON scheduling.resource (tenant_id, subject_id)
    WHERE subject_id <> '';

-- One recurring availability rule (SRS-SCH-001).
--
-- A row per weekday rather than a set, so "Thursdays move to the afternoon in
-- April" is one row changing rather than a rule that has to be split first.
CREATE TABLE scheduling.schedule (
    schedule_id  uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    resource_id  uuid        NOT NULL REFERENCES scheduling.resource (resource_id),
    facility_id  uuid        NOT NULL,
    visit_type   text        NOT NULL CHECK (visit_type IN (
                     'new', 'follow_up', 'procedure', 'teleconsult', 'walk_in')),
    visit_mode   text        NOT NULL CHECK (visit_mode IN ('in_person', 'teleconsult')),
    weekday      smallint    NOT NULL CHECK (weekday BETWEEN 0 AND 6),
    -- Minutes from local midnight. Minutes rather than a time, because a rule
    -- has no date and a zero date carrying a time reads as year 1 in every log.
    start_minute integer     NOT NULL CHECK (start_minute BETWEEN 0 AND 1439),
    end_minute   integer     NOT NULL CHECK (end_minute BETWEEN 1 AND 1440),
    slot_minutes integer     NOT NULL CHECK (slot_minutes BETWEEN 5 AND 480),
    capacity     integer     NOT NULL CHECK (capacity BETWEEN 1 AND 50),
    -- Local dates; until is exclusive and NULL means open-ended. A roster that
    -- changes in April is two rows, and a search for March must find the old.
    effective_from  date     NOT NULL,
    effective_until date,
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL,

    -- An empty or inverted session silently produces no slots, and a clinic
    -- that generates nothing looks exactly like one nobody has booked.
    CONSTRAINT sessions_have_a_usable_window CHECK (end_minute > start_minute),
    CONSTRAINT sessions_fit_one_slot CHECK (end_minute - start_minute >= slot_minutes),
    CONSTRAINT schedules_end_after_they_begin CHECK (
        effective_until IS NULL OR effective_until > effective_from
    )
);

-- The slot-search query: a resource's rules for a weekday over a date range.
CREATE INDEX schedule_lookup_idx
    ON scheduling.schedule (tenant_id, resource_id, weekday, effective_from);

-- Searching by department and visit type, which is how a patient who does not
-- know a clinician's name finds one.
CREATE INDEX schedule_facility_idx
    ON scheduling.schedule (tenant_id, facility_id, visit_type, weekday);

-- A period removed from a resource's availability (SRS-SCH-002).
CREATE TABLE scheduling.schedule_exception (
    exception_id uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    resource_id  uuid        NOT NULL REFERENCES scheduling.resource (resource_id),
    kind         text        NOT NULL CHECK (kind IN (
                     'leave', 'block', 'meeting', 'theatre', 'procedure')),
    -- Instants, half-open [starts_at, ends_at). Instants rather than local
    -- dates because "on leave from Friday evening" is a real interval that a
    -- date-only model rounds to a whole day in one direction or the other.
    starts_at    timestamptz NOT NULL,
    ends_at      timestamptz NOT NULL,
    -- What a colleague reads when deciding whether to ask for an override.
    -- "Blocked" with no reason gets overridden by default.
    reason       text        NOT NULL CHECK (reason <> ''),
    -- Annual leave is not overridable; a provisional theatre block often is.
    overridable  boolean     NOT NULL DEFAULT false,
    created_by   text        NOT NULL CHECK (created_by <> ''),
    created_at   timestamptz NOT NULL,

    CONSTRAINT exceptions_end_after_they_start CHECK (ends_at > starts_at)
);

CREATE INDEX schedule_exception_lookup_idx
    ON scheduling.schedule_exception (tenant_id, resource_id, starts_at, ends_at);

-- Consumed capacity (SRS-SCH-004).
--
-- Written only when a slot is first booked. The unique key is what makes two
-- concurrent first bookings converge on one row, and the capacity check in the
-- UPDATE is what stops the second exceeding it.
--
-- Keyed on the resource, the instant and the visit type rather than on the
-- schedule that generated it: a roster edited after a booking would otherwise
-- orphan the capacity it consumed, and the appointment would still exist while
-- the slot it sat in reported itself empty.
CREATE TABLE scheduling.slot (
    slot_id     uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    resource_id uuid        NOT NULL REFERENCES scheduling.resource (resource_id),
    starts_at   timestamptz NOT NULL,
    ends_at     timestamptz NOT NULL,
    visit_type  text        NOT NULL,
    capacity    integer     NOT NULL CHECK (capacity >= 1),
    booked      integer     NOT NULL DEFAULT 0 CHECK (booked >= 0),
    created_at  timestamptz NOT NULL,
    updated_at  timestamptz NOT NULL,

    -- The invariant SRS-SCH-004 is about, stated where it cannot be bypassed.
    -- The application's guarded UPDATE is what makes overbooking impossible
    -- under concurrency; this is what makes it impossible full stop, including
    -- from a migration, a fix-up script or a future code path that forgets.
    CONSTRAINT bookings_never_exceed_capacity CHECK (booked <= capacity)
);

CREATE UNIQUE INDEX slot_identity_key
    ON scheduling.slot (tenant_id, resource_id, starts_at, visit_type);

-- One booking (SRS-SCH-004, SRS-SCH-005, SRS-SCH-008).
CREATE TABLE scheduling.appointment (
    appointment_id uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    facility_id    uuid        NOT NULL,
    resource_id    uuid        NOT NULL REFERENCES scheduling.resource (resource_id),
    org_unit_id    uuid,
    -- The EMPI patient id. Not a foreign key: the patient index is a separate
    -- bounded context, and a cross-schema constraint would make a change to one
    -- a migration of both (Blueprint §4).
    patient_id     uuid        NOT NULL,
    slot_id        uuid        NOT NULL REFERENCES scheduling.slot (slot_id),

    visit_type     text        NOT NULL,
    visit_mode     text        NOT NULL CHECK (visit_mode IN ('in_person', 'teleconsult')),
    starts_at      timestamptz NOT NULL,
    ends_at        timestamptz NOT NULL,

    status         text        NOT NULL CHECK (status IN (
                       'scheduled', 'arrived', 'triaged', 'waiting_clinician',
                       'in_consultation', 'post_consultation', 'completed',
                       'no_show', 'cancelled')),

    booked_by      text        NOT NULL CHECK (booked_by <> ''),
    -- Why the patient is coming, as stated at booking. Short and non-clinical:
    -- a diagnosis belongs in the encounter, which far fewer people can see.
    reason         text        NOT NULL DEFAULT '',

    -- Chains an appointment to the one it replaced, so the chronology survives
    -- a reschedule (SRS-SCH-005).
    rescheduled_from_id uuid   REFERENCES scheduling.appointment (appointment_id),

    created_at     timestamptz NOT NULL,
    updated_at     timestamptz NOT NULL,
    version        bigint      NOT NULL DEFAULT 1,

    CONSTRAINT appointments_end_after_they_start CHECK (ends_at > starts_at)
);

-- A patient cannot hold two live appointments in the same slot.
--
-- Partial on the non-cancelled statuses: a patient who cancelled and rebooked
-- the same slot is doing something ordinary, and a total unique index would
-- refuse it.
CREATE UNIQUE INDEX appointment_one_live_per_patient_slot_key
    ON scheduling.appointment (tenant_id, patient_id, slot_id)
    WHERE status <> 'cancelled';

-- The clinic list: what is happening at this facility today.
CREATE INDEX appointment_facility_day_idx
    ON scheduling.appointment (tenant_id, facility_id, starts_at);

-- A clinician's own diary, and the capacity recount a cancellation needs.
CREATE INDEX appointment_resource_idx
    ON scheduling.appointment (tenant_id, resource_id, starts_at);

-- "What has this patient got coming up?"
CREATE INDEX appointment_patient_idx
    ON scheduling.appointment (tenant_id, patient_id, starts_at DESC);

-- Every status an appointment has held (SRS-SCH-005, SRS-SCH-008).
--
-- Append-only and never updated. SRS-SCH-005 requires the original appointment
-- to retain its status history, and the reason is a question asked months
-- later: a patient disputing a missed-appointment fee needs the record to show
-- when they were marked a no-show and by whom.
CREATE TABLE scheduling.appointment_status_history (
    history_id     uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    appointment_id uuid        NOT NULL
                       REFERENCES scheduling.appointment (appointment_id)
                       ON DELETE CASCADE,
    from_status    text        NOT NULL DEFAULT '',
    to_status      text        NOT NULL,
    changed_at     timestamptz NOT NULL,
    changed_by     text        NOT NULL CHECK (changed_by <> ''),
    reason         text        NOT NULL DEFAULT '',
    -- A transition the machine would otherwise refuse, made under the
    -- "unless authorized correction" clause of SRS-SCH-008.
    corrected      boolean     NOT NULL DEFAULT false,

    -- A correction with no reason is indistinguishable from the mistake it is
    -- correcting.
    CONSTRAINT corrections_explain_themselves CHECK (NOT corrected OR reason <> '')
);

CREATE INDEX appointment_status_history_idx
    ON scheduling.appointment_status_history (tenant_id, appointment_id, changed_at);
