-- 0044 Ambulance and fleet operations (SRS-AMB-001 … 008).
--
-- Trace: SRS-AMB-001 … SRS-AMB-008.
--
-- Four shapes here are unusual and deliberate.
--
-- A patient transport van cannot be dispatched to an emergency, and no
-- override makes one possible. ambulance.trip carries vehicle_kind beside
-- vehicle_id and priority beside request_id, each held by a composite foreign
-- key ON UPDATE CASCADE onto ambulance.vehicle (vehicle_id, kind) and
-- ambulance.request (request_id, priority), with a CHECK that an emergency
-- priority is not answered by a 'transport' vehicle. Every other dispatch
-- blocker — a vehicle off the run, a lapsed check, an off-duty crew, a
-- missing capability — is overridable by a named person with a reason,
-- because on a bad night the alternative is nothing at all. This one is not:
-- a van with no defibrillator in it does not acquire one because a duty
-- officer typed a sentence. The cascade is what keeps the denormalised
-- columns honest; an attempt to reclassify a vehicle as 'transport' while it
-- holds emergency trips fails against the CHECK rather than quietly leaving
-- those trips attached to a van.
--
-- The crew on a trip is the crew rostered to its vehicle. ambulance.trip
-- carries shift_vehicle_id with a composite foreign key onto ambulance.shift
-- (shift_id, vehicle_id) and a CHECK that it equals the trip's own
-- vehicle_id. Without it a trip can name Alpha 1 and the crew of Bravo 3, and
-- the prehospital record that hangs off the trip names people who were never
-- in that vehicle.
--
-- A trip's timeline is append-only. ambulance.trip_milestone takes inserts
-- only (the append-only trigger, FIT-08) and a partial unique index allows
-- exactly one original record per point — a correction is a further row
-- carrying amends_at, amend_reason and amended_at, so "the arrival time was
-- changed three weeks after the complaint" is a question the table answers.
-- A timeline somebody can rewrite is one nobody can audit.
--
-- And ambulance.location_ping has no patient column. A map of an ambulance's
-- day is a list of the addresses somebody was ill at; the link to a patient
-- is through the trip, behind its own permission. Every ping carries
-- retain_until as a NOT NULL column rather than a deployment-wide setting a
-- purge job consults, so the horizon is a property of the row and a read that
-- respects it cannot return yesterday's trail because the purge is behind.
--
-- Rollback: drops the schema. Every vehicle, shift and readiness check, every
-- request and trip timeline, every prehospital record and handover, and every
-- location ping goes with it. Prehospital records accepted into an encounter
-- leave that encounter's own documents in place; what is lost is the crew's
-- account of the journey, which is not recoverable from the encounter.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and there is nothing to reconcile on the way back. Forward, a trip
-- whose vehicle or shift predates this migration cannot exist: both are
-- created here.

CREATE SCHEMA IF NOT EXISTS ambulance;

-- ----------------------------------------------------------------- fleet

CREATE TABLE ambulance.vehicle (
    vehicle_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    registration text NOT NULL
        CONSTRAINT a_vehicle_names_its_registration
        CHECK (registration <> ''),
    call_sign text NOT NULL DEFAULT '',
    kind      text NOT NULL
        CHECK (kind IN ('als', 'bls', 'transport', 'neonatal')),
    facility_id uuid,
    base_id     text NOT NULL DEFAULT '',
    -- What the vehicle carries, matched against a request's required
    -- capabilities at dispatch.
    capabilities text[] NOT NULL DEFAULT '{}',

    state text NOT NULL
        CHECK (state IN ('out_of_service', 'available', 'on_trip',
                         'retired')),
    -- Derived from the readiness check rather than set by hand, and cleared
    -- when the vehicle comes off the run. A check that lapsed overnight makes
    -- the vehicle unready without anybody remembering to say so.
    ready_until timestamptz,
    -- A vehicle off the run for no recorded reason is one nobody can chase
    -- back on.
    out_of_service_reason text NOT NULL DEFAULT ''
        CONSTRAINT a_vehicle_off_the_run_says_why
        CHECK (state NOT IN ('out_of_service', 'retired')
               OR out_of_service_reason <> ''),
    CONSTRAINT a_vehicle_on_the_run_is_in_date
        CHECK (state <> 'available' OR ready_until IS NOT NULL),

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text NOT NULL
        CONSTRAINT a_vehicle_names_who_registered_it
        CHECK (created_by <> ''),
    version bigint NOT NULL DEFAULT 1,

    -- The composite key the trip's kind check hangs off.
    UNIQUE (vehicle_id, kind)
);

-- One plate is one vehicle. Two rows for one ambulance means two readiness
-- histories, and a dispatcher reading whichever they opened.
CREATE UNIQUE INDEX vehicle_registration_idx
    ON ambulance.vehicle (tenant_id, upper(registration));

CREATE INDEX vehicle_state_idx
    ON ambulance.vehicle (tenant_id, state, kind);

CREATE TABLE ambulance.shift (
    shift_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    vehicle_id uuid NOT NULL
        REFERENCES ambulance.vehicle (vehicle_id),
    facility_id uuid,

    state text NOT NULL
        CHECK (state IN ('planned', 'on_duty', 'ended')),
    starts_at timestamptz NOT NULL,
    ends_at   timestamptz NOT NULL,
    CONSTRAINT a_shift_ends_after_it_starts CHECK (ends_at > starts_at),
    started_at timestamptz,
    ended_at   timestamptz,
    CONSTRAINT a_shift_on_duty_says_when_it_started
        CHECK (state = 'planned' OR started_at IS NOT NULL),

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text NOT NULL
        CONSTRAINT a_shift_names_who_rostered_it
        CHECK (created_by <> ''),
    version bigint NOT NULL DEFAULT 1,

    -- The composite key that binds a trip's crew to the trip's vehicle.
    UNIQUE (shift_id, vehicle_id)
);

CREATE INDEX shift_vehicle_idx
    ON ambulance.shift (tenant_id, vehicle_id, starts_at DESC);

CREATE TABLE ambulance.shift_crew (
    shift_id uuid NOT NULL
        REFERENCES ambulance.shift (shift_id) ON DELETE CASCADE,
    subject_id text NOT NULL
        CONSTRAINT a_crew_member_needs_an_id CHECK (subject_id <> ''),

    display_name text NOT NULL DEFAULT '',
    role         text NOT NULL
        CHECK (role IN ('driver', 'emt', 'paramedic', 'nurse', 'doctor')),
    -- Carried so a prehospital record names a registrant rather than a
    -- login. Empty for a role that has no registration.
    registration_number text NOT NULL DEFAULT '',

    -- One person twice is a crew of two that is really a crew of one, and a
    -- vehicle that looks staffed and is not.
    PRIMARY KEY (shift_id, subject_id)
);

-- ------------------------------------------------------------- readiness

CREATE TABLE ambulance.readiness_check (
    check_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    vehicle_id uuid NOT NULL
        REFERENCES ambulance.vehicle (vehicle_id),
    shift_id uuid
        REFERENCES ambulance.shift (shift_id),
    facility_id uuid,

    -- Oxygen is a level rather than a tick: "present" is true of a cylinder
    -- with forty bar left in it, and that cylinder will not finish a long
    -- transfer.
    oxygen_bar int NOT NULL DEFAULT 0 CHECK (oxygen_bar >= 0),
    oxygen_minimum_bar int NOT NULL DEFAULT 0
        CHECK (oxygen_minimum_bar >= 0),

    state text NOT NULL
        CHECK (state IN ('passed', 'failed', 'overridden')),
    -- The critical items that were not there, so a service can see what to
    -- buy rather than only that a vehicle failed.
    missing text[] NOT NULL DEFAULT '{}',

    override_by     text NOT NULL DEFAULT '',
    override_reason text NOT NULL DEFAULT '',
    override_at     timestamptz,
    CONSTRAINT an_overridden_check_names_who_and_why
        CHECK (state <> 'overridden'
               OR (override_by <> '' AND override_reason <> ''
                   AND override_at IS NOT NULL)),
    CONSTRAINT only_a_failed_check_is_overridden
        CHECK (state = 'overridden' OR override_by = ''),
    -- Somebody who found the oxygen empty and then waved it through is one
    -- person deciding both, and "requires override" means a second pair of
    -- eyes rather than a second click.
    checked_by text NOT NULL
        CONSTRAINT a_check_names_who_made_it CHECK (checked_by <> ''),
    CONSTRAINT a_check_is_overridden_by_somebody_else
        CHECK (override_by = '' OR override_by <> checked_by),

    -- A check that never lapses is a vehicle checked once in March.
    valid_until timestamptz NOT NULL,
    checked_at  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT a_check_holds_for_a_while CHECK (valid_until > checked_at),
    version bigint NOT NULL DEFAULT 1
);

CREATE INDEX readiness_check_vehicle_idx
    ON ambulance.readiness_check (tenant_id, vehicle_id, checked_at DESC);

CREATE TABLE ambulance.readiness_outcome (
    check_id uuid NOT NULL
        REFERENCES ambulance.readiness_check (check_id) ON DELETE CASCADE,
    item_code text NOT NULL
        CONSTRAINT a_checklist_item_needs_a_code CHECK (item_code <> ''),

    label    text NOT NULL DEFAULT '',
    critical boolean NOT NULL DEFAULT false,
    present  boolean NOT NULL,
    -- A missing item with no note is indistinguishable from one nobody
    -- looked for.
    note text NOT NULL DEFAULT ''
        CONSTRAINT a_missing_item_says_why CHECK (present OR note <> ''),

    PRIMARY KEY (check_id, item_code)
);

-- -------------------------------------------------------------- requests

CREATE TABLE ambulance.request (
    request_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    kind text NOT NULL
        CHECK (kind IN ('emergency', 'interfacility', 'discharge')),
    priority text NOT NULL
        CHECK (priority IN ('immediate', 'urgent', 'routine')),

    -- Absent for a call to a street with nobody identified yet, which is
    -- most emergency calls at the moment they are taken.
    patient_id   uuid,
    encounter_id uuid,

    origin_name    text NOT NULL DEFAULT '',
    origin_address text NOT NULL DEFAULT '',
    origin_facility_id uuid,
    CONSTRAINT a_request_says_where_to_go
        CHECK (origin_name <> '' OR origin_address <> ''
               OR origin_facility_id IS NOT NULL),

    destination_name    text NOT NULL DEFAULT '',
    destination_address text NOT NULL DEFAULT '',
    destination_facility_id uuid,

    -- A transfer between two hospitals needs both ends named, and they are
    -- not the same hospital.
    CONSTRAINT a_transfer_names_both_ends
        CHECK (kind <> 'interfacility'
               OR (origin_facility_id IS NOT NULL
                   AND destination_facility_id IS NOT NULL)),
    CONSTRAINT a_transfer_goes_somewhere_else
        CHECK (kind <> 'interfacility'
               OR origin_facility_id <> destination_facility_id),

    -- The clinical need decides which vehicle goes.
    clinical_need text NOT NULL
        CONSTRAINT a_request_says_what_the_patient_needs
        CHECK (clinical_need <> ''),
    required_capabilities text[] NOT NULL DEFAULT '{}',

    state text NOT NULL
        CHECK (state IN ('queued', 'assigned', 'completed', 'cancelled')),
    trip_id uuid,

    -- The cancellation rate SRS-AMB-008 asks for is only useful with the
    -- reasons beside it: a service cancelling a fifth of its calls because
    -- nobody was there is a different problem from one cancelling them
    -- because no vehicle came.
    cancel_reason text NOT NULL DEFAULT '',
    cancelled_by  text NOT NULL DEFAULT '',
    cancelled_at  timestamptz,
    CONSTRAINT a_cancelled_request_says_who_and_why
        CHECK (state <> 'cancelled'
               OR (cancel_reason <> '' AND cancelled_by <> ''
                   AND cancelled_at IS NOT NULL)),

    -- The clock every response-time figure is measured from.
    requested_at timestamptz NOT NULL DEFAULT now(),
    requested_by text NOT NULL
        CONSTRAINT a_request_names_who_raised_it CHECK (requested_by <> ''),
    version bigint NOT NULL DEFAULT 1,

    -- The composite key the trip's emergency-vehicle check hangs off.
    UNIQUE (request_id, priority)
);

-- The dispatch queue: priority first, then the oldest call waiting.
CREATE INDEX request_queue_idx
    ON ambulance.request (tenant_id, priority, requested_at)
    WHERE state = 'queued';

CREATE INDEX request_patient_idx
    ON ambulance.request (tenant_id, patient_id, requested_at DESC)
    WHERE patient_id IS NOT NULL;

-- ----------------------------------------------------------------- trips

CREATE TABLE ambulance.trip (
    trip_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    request_id uuid NOT NULL,
    vehicle_id uuid NOT NULL,
    shift_id   uuid NOT NULL,
    facility_id uuid,

    -- Denormalised and held by composite foreign keys. See the note at the
    -- top of this file: this is what makes "a van is never sent to a cardiac
    -- arrest" a rule the database keeps rather than one the application
    -- remembers.
    priority     text NOT NULL,
    vehicle_kind text NOT NULL,
    shift_vehicle_id uuid NOT NULL,

    FOREIGN KEY (request_id, priority)
        REFERENCES ambulance.request (request_id, priority)
        ON UPDATE CASCADE,
    FOREIGN KEY (vehicle_id, vehicle_kind)
        REFERENCES ambulance.vehicle (vehicle_id, kind)
        ON UPDATE CASCADE,
    FOREIGN KEY (shift_id, shift_vehicle_id)
        REFERENCES ambulance.shift (shift_id, vehicle_id)
        ON UPDATE CASCADE,
    CONSTRAINT a_transport_van_does_not_answer_an_emergency
        CHECK (priority NOT IN ('immediate', 'urgent')
               OR vehicle_kind <> 'transport'),
    CONSTRAINT the_crew_is_rostered_to_the_trips_vehicle
        CHECK (shift_vehicle_id = vehicle_id),

    -- Who was actually on board, pinned at dispatch. A crew list read back
    -- from the shift next month is the crew the shift has now.
    crew_subjects text[] NOT NULL DEFAULT '{}',

    -- An override is one thing rather than two flags: a named person and a
    -- reason, together or not at all.
    override_by     text NOT NULL DEFAULT '',
    override_reason text NOT NULL DEFAULT '',
    CONSTRAINT an_override_is_a_name_and_a_reason
        CHECK ((override_by <> '') = (override_reason <> '')),

    state text NOT NULL
        CHECK (state IN ('active', 'completed', 'aborted')),
    abort_reason text NOT NULL DEFAULT ''
        CONSTRAINT an_aborted_trip_says_why
        CHECK (state <> 'aborted' OR abort_reason <> ''),

    started_at timestamptz NOT NULL DEFAULT now(),
    started_by text NOT NULL
        CONSTRAINT a_trip_names_who_dispatched_it CHECK (started_by <> ''),
    ended_at timestamptz,
    CONSTRAINT a_finished_trip_says_when
        CHECK (state = 'active' OR ended_at IS NOT NULL),
    version bigint NOT NULL DEFAULT 1
);

-- One running trip per call. Two active trips against the same call is two
-- vehicles sent to one patient and two response times for the report to
-- choose between.
--
-- Partial rather than absolute, because a call can legitimately be answered
-- twice over its life: a crew stood down with a broken-down vehicle puts the
-- call back in the queue, and the next vehicle's trip is a second trip for
-- the same call. Both are kept — the first one happened.
CREATE UNIQUE INDEX trip_active_per_request_idx
    ON ambulance.trip (request_id)
    WHERE state = 'active';

CREATE INDEX trip_vehicle_idx
    ON ambulance.trip (tenant_id, vehicle_id, started_at DESC);

CREATE INDEX trip_open_idx
    ON ambulance.trip (tenant_id, started_at)
    WHERE state = 'active';

-- Append-only (FIT-08). A timeline somebody can rewrite is one nobody can
-- audit, so a correction is a further row rather than an UPDATE.
CREATE TABLE ambulance.trip_milestone (
    milestone_id uuid PRIMARY KEY,
    -- Insertion order, which is not the order the points claim to have
    -- happened in: a correction carries an earlier time than the record it
    -- supersedes. Reading a timeline back by occurred_at would put the
    -- correction first and the superseded value last, and the value a report
    -- takes as current would be the one that was corrected away.
    seq bigserial NOT NULL,
    tenant_id    uuid NOT NULL,
    trip_id      uuid NOT NULL
        REFERENCES ambulance.trip (trip_id) ON DELETE CASCADE,

    milestone text NOT NULL
        CHECK (milestone IN ('dispatched', 'mobile', 'at_scene',
                             'with_patient', 'left_scene', 'at_destination',
                             'handover', 'clear')),
    occurred_at timestamptz NOT NULL,
    recorded_by text NOT NULL
        CONSTRAINT a_milestone_names_who_recorded_it
        CHECK (recorded_by <> ''),
    note text NOT NULL DEFAULT '',

    -- Set on a correction: the value this row supersedes, why, and when the
    -- correction was made. "The arrival time was changed three weeks after
    -- the complaint" is not derivable from the corrected value.
    amends_at     timestamptz,
    amend_reason  text NOT NULL DEFAULT '',
    amended_at    timestamptz,
    CONSTRAINT an_amendment_says_why_and_when
        CHECK (amends_at IS NULL
               OR (amend_reason <> '' AND amended_at IS NOT NULL)),
    CONSTRAINT an_original_record_amends_nothing
        CHECK (amends_at IS NOT NULL OR amend_reason = '')
);

-- Exactly one original per point. Two "at scene" times is one response
-- figure that is whichever the report reached first; the corrections are the
-- rows carrying amends_at, and there may be several.
CREATE UNIQUE INDEX trip_milestone_once_idx
    ON ambulance.trip_milestone (trip_id, milestone)
    WHERE amends_at IS NULL;

CREATE INDEX trip_milestone_trip_idx
    ON ambulance.trip_milestone (tenant_id, trip_id, occurred_at);

-- ---------------------------------------------------------- prehospital

CREATE TABLE ambulance.prehospital_record (
    record_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    trip_id uuid NOT NULL
        REFERENCES ambulance.trip (trip_id),
    request_id uuid,
    patient_id uuid,
    -- Set when the receiving clinician accepts the handover: this is the
    -- attachment SRS-AMB-004 asks for.
    encounter_id uuid,
    facility_id  uuid,

    presenting_complaint text NOT NULL DEFAULT '',
    impression           text NOT NULL DEFAULT '',

    state text NOT NULL
        CHECK (state IN ('draft', 'given', 'accepted')),

    -- A handover with nothing in it is a patient arriving with a wristband
    -- and a shrug.
    sending_summary text NOT NULL DEFAULT '',
    given_by        text NOT NULL DEFAULT '',
    given_role      text NOT NULL DEFAULT '',
    given_at        timestamptz,
    CONSTRAINT a_given_handover_says_what_happened
        CHECK (state = 'draft'
               OR (sending_summary <> '' AND given_by <> ''
                   AND given_at IS NOT NULL)),
    -- A driver does not give a clinical handover: the person recorded as
    -- handing the patient over has to be somebody the service says may.
    CONSTRAINT a_handover_is_given_by_a_clinician
        CHECK (given_role = ''
               OR given_role IN ('emt', 'paramedic', 'nurse', 'doctor')),

    accepted_by   text NOT NULL DEFAULT '',
    accepted_at   timestamptz,
    accepted_note text NOT NULL DEFAULT '',
    CONSTRAINT an_accepted_handover_names_who_and_when
        CHECK (state <> 'accepted'
               OR (accepted_by <> '' AND accepted_at IS NOT NULL)),
    -- A handover accepted by the person who gave it is the same claim made
    -- twice, and the patient is standing between two people neither of whom
    -- has taken responsibility.
    CONSTRAINT a_handover_is_accepted_by_somebody_else
        CHECK (accepted_by = '' OR accepted_by <> given_by),
    CONSTRAINT an_accepted_handover_attaches_to_an_encounter
        CHECK (state <> 'accepted' OR encounter_id IS NOT NULL),

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text NOT NULL
        CONSTRAINT a_record_names_who_opened_it CHECK (created_by <> ''),
    version bigint NOT NULL DEFAULT 1,

    -- One record per trip. Two accounts of one journey is two sets of
    -- medications, and the receiving doctor reads one of them.
    UNIQUE (trip_id)
);

CREATE INDEX prehospital_record_waiting_idx
    ON ambulance.prehospital_record (tenant_id, given_at)
    WHERE state = 'given';

CREATE INDEX prehospital_record_encounter_idx
    ON ambulance.prehospital_record (tenant_id, encounter_id)
    WHERE encounter_id IS NOT NULL;

CREATE TABLE ambulance.prehospital_entry (
    entry_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    record_id uuid NOT NULL
        REFERENCES ambulance.prehospital_record (record_id)
        ON DELETE CASCADE,

    kind text NOT NULL
        CHECK (kind IN ('observation', 'intervention', 'medication',
                        'note')),
    code  text NOT NULL DEFAULT '',
    label text NOT NULL DEFAULT '',
    value text NOT NULL DEFAULT '',
    unit  text NOT NULL DEFAULT '',

    -- Integers, not floats: a dose in the smallest unit the drug is given
    -- in, so 5 mg is 5 and not 4.999999.
    dose_amount int NOT NULL DEFAULT 0 CHECK (dose_amount >= 0),
    dose_unit   text NOT NULL DEFAULT '',
    route       text NOT NULL DEFAULT '',
    narrative   text NOT NULL DEFAULT '',

    -- A drug with no dose is a line in a record that cannot be checked
    -- against anything.
    CONSTRAINT a_medication_names_the_drug
        CHECK (kind <> 'medication' OR code <> ''),
    CONSTRAINT a_medication_says_how_much
        CHECK (kind <> 'medication'
               OR (dose_amount > 0 AND dose_unit <> '')),
    CONSTRAINT a_medication_says_how_it_was_given
        CHECK (kind <> 'medication' OR route <> ''),
    -- A code or a name for it. Not both, because plenty of what a crew
    -- records on the way in has no code — "pupils equal and reactive" is an
    -- observation and is not in any dictionary the vehicle carries.
    CONSTRAINT an_observation_says_what_was_measured
        CHECK (kind <> 'observation' OR code <> '' OR label <> ''),

    recorded_by text NOT NULL
        CONSTRAINT an_entry_names_who_recorded_it CHECK (recorded_by <> ''),
    -- Pinned at the time. A paramedic who becomes a manager next year still
    -- gave that drug as a paramedic, and a driver never did.
    recorded_role text NOT NULL
        CONSTRAINT an_entry_is_recorded_by_a_clinician
        CHECK (recorded_role IN ('emt', 'paramedic', 'nurse', 'doctor')),

    -- When it happened, and when somebody typed it. A record written up two
    -- hours later is a different thing from one written at the time.
    recorded_at timestamptz NOT NULL,
    entered_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX prehospital_entry_record_idx
    ON ambulance.prehospital_entry (tenant_id, record_id, recorded_at);

CREATE TABLE ambulance.prehospital_document (
    record_id uuid NOT NULL
        REFERENCES ambulance.prehospital_record (record_id)
        ON DELETE CASCADE,
    -- A reference, not a copy. A second copy of a referral goes stale the
    -- first time somebody corrects one.
    document_ref text NOT NULL
        CONSTRAINT a_document_reference_is_not_empty
        CHECK (document_ref <> ''),
    attached_at timestamptz NOT NULL DEFAULT now(),

    PRIMARY KEY (record_id, document_ref)
);

-- -------------------------------------------------------------- location

-- No patient column, deliberately: see the note at the top of this file.
CREATE TABLE ambulance.location_ping (
    ping_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    vehicle_id uuid NOT NULL
        REFERENCES ambulance.vehicle (vehicle_id) ON DELETE CASCADE,
    -- The only link to a patient, and it is a link rather than an
    -- identifier: reading it needs the trip, which needs its own permission.
    trip_id uuid
        REFERENCES ambulance.trip (trip_id) ON DELETE SET NULL,

    -- Micro-degrees as integers. A float here accumulates error over a long
    -- trail and compares badly; 13.082680 is 13082680 and stays that way.
    latitude_micro int NOT NULL
        CONSTRAINT a_ping_has_a_real_latitude
        CHECK (latitude_micro BETWEEN -90000000 AND 90000000),
    longitude_micro int NOT NULL
        CONSTRAINT a_ping_has_a_real_longitude
        CHECK (longitude_micro BETWEEN -180000000 AND 180000000),
    speed_kph int NOT NULL DEFAULT 0 CHECK (speed_kph >= 0),
    heading_degrees int NOT NULL DEFAULT 0
        CHECK (heading_degrees BETWEEN 0 AND 359),
    accuracy_metres int NOT NULL DEFAULT 0 CHECK (accuracy_metres >= 0),

    -- Which box or provider said so. A position with no provenance is one
    -- nobody can question when it is wrong.
    source text NOT NULL
        CONSTRAINT a_ping_names_where_it_came_from CHECK (source <> ''),
    occurred_at timestamptz NOT NULL,

    -- The horizon is a property of the row rather than of whatever the purge
    -- job was last told.
    retain_until timestamptz NOT NULL
        CONSTRAINT a_ping_stops_being_kept
        CHECK (retain_until > occurred_at)
);

CREATE INDEX location_ping_vehicle_idx
    ON ambulance.location_ping (tenant_id, vehicle_id, occurred_at DESC);

CREATE INDEX location_ping_retention_idx
    ON ambulance.location_ping (retain_until);

CREATE TABLE ambulance.eta (
    eta_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    vehicle_id uuid NOT NULL
        REFERENCES ambulance.vehicle (vehicle_id) ON DELETE CASCADE,
    trip_id uuid
        REFERENCES ambulance.trip (trip_id) ON DELETE CASCADE,

    seconds int NOT NULL CHECK (seconds >= 0),
    distance_metres int NOT NULL DEFAULT 0 CHECK (distance_metres >= 0),
    -- Provider-supplied and never computed here. A straight-line guess
    -- looks like an ETA and is not one, and a dispatcher would hold a bed
    -- against it.
    source text NOT NULL
        CONSTRAINT an_estimate_names_where_it_came_from
        CHECK (source <> ''),
    occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX eta_trip_idx
    ON ambulance.eta (tenant_id, trip_id, occurred_at DESC);
