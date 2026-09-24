-- 0049 The bed and room master (SRS-PLT-006, SRS-PLT-002).
--
-- Trace: SRS-PLT-002, SRS-PLT-006, SRS-PLT-007, SRS-PLT-015.
--
-- Three contexts shipped against beds that had no master. Critical care,
-- infection control, dietetics and housekeeping each hold a bed_id as free
-- text, and billing holds a room_class as free text, because there was nothing
-- to hold instead. Each of them therefore has its own idea of what a bed is,
-- and none of them can say what a bed costs, who may occupy it, or whether it
-- is fit to use.
--
-- Three tables, in the order they depend on each other.
--
-- bed_class is the tenant's own catalogue of accommodation and the charge each
-- one maps to. A catalogue rather than an enumeration: "deluxe" and "twin
-- sharing" are commercial decisions. The charge code is NOT NULL and non-empty
-- because a class that maps to nothing is a stay nobody can bill.
--
-- room is the physical space. It carries the class, so every bed in it is
-- charged the same way and two beds in one room cannot be at two tariffs. It
-- also carries the gender policy and the isolation capability, which are
-- properties of a space with a door rather than of the bed inside it.
--
-- bed is the physical bed, and it carries two independent states. status is
-- whether the hospital has the bed at all; availability is whether it can be
-- used right now. SRS-PLT-006's verification clause is exactly that these are
-- separate, so they are separate columns with separate constraints rather than
-- one column with 'retired' among its values. A hospital that conflated them
-- would lose a bed permanently the first time somebody took one out of service
-- to fix a castor.
--
-- Rollback: 0049_bed_master.down.sql drops the three tables. Safe while no
--   other context has been repointed at them, which is the state this
--   migration leaves: every existing bed_id stays the free text it was, and
--   reconciling those onto this master is its own change.
-- Reconciliation: none. The previous version of the service does not know
--   these tables exist and writes nothing to them, so there is no row it can
--   have written that needs reconciling. The masters start empty; a tenant
--   without them behaves exactly as it did before.

CREATE TABLE organization.bed_class (
    class_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES organization.tenant (tenant_id),

    -- The key. It appears in tariff imports and on printed estimates, so it is
    -- stable and the display name is not (SRS-PLT-007).
    code         text NOT NULL CHECK (code ~ '^[A-Z0-9][A-Z0-9_-]{1,31}$'),
    display_name text NOT NULL CHECK (length(btrim(display_name)) > 0),

    -- SRS-PLT-006's charge mapping. The database holds it too, because a class
    -- inserted around the domain would otherwise bill for nothing.
    charge_code text NOT NULL CONSTRAINT a_class_names_its_charge
        CHECK (length(btrim(charge_code)) > 0),

    status     text        NOT NULL CHECK (status IN ('active', 'retired')),
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    version    bigint      NOT NULL CHECK (version > 0)
);

-- Codes are unique per tenant, not globally: two hospitals both have a
-- "DELUXE" and they are not the same thing.
CREATE UNIQUE INDEX bed_class_tenant_code_key
    ON organization.bed_class (tenant_id, code);

CREATE TABLE organization.room (
    room_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES organization.tenant (tenant_id),

    facility_id uuid NOT NULL REFERENCES organization.facility (facility_id),
    -- The ward or department. Without it a room floats between the facility
    -- and its beds, and no ward can list what it is responsible for.
    unit_id uuid NOT NULL REFERENCES organization.org_unit (unit_id),

    code         text NOT NULL CHECK (code ~ '^[A-Z0-9][A-Z0-9_-]{1,31}$'),
    display_name text NOT NULL CHECK (length(btrim(display_name)) > 0),

    -- By code rather than by id, so a tariff import can name it. The composite
    -- foreign key below carries the tenant, which is what stops a room in one
    -- tenant referencing a class in another.
    class_code text NOT NULL,

    gender_policy text NOT NULL CHECK (
        gender_policy IN ('any', 'male_only', 'female_only')),
    -- Ordered by what it can contain: airborne implies droplet implies
    -- contact. Infection control asks where a case can go, and a set with no
    -- order cannot answer it.
    isolation text NOT NULL CHECK (
        isolation IN ('none', 'contact', 'droplet', 'airborne')),

    status     text        NOT NULL CHECK (status IN ('active', 'retired')),
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    version    bigint      NOT NULL CHECK (version > 0),

    -- The class must belong to the same tenant as the room. A plain foreign
    -- key on class_code alone could not say that, so the tenant travels with
    -- it.
    CONSTRAINT a_room_is_classed_within_its_own_tenant
        FOREIGN KEY (tenant_id, class_code)
        REFERENCES organization.bed_class (tenant_id, code)
);

CREATE UNIQUE INDEX room_tenant_code_key ON organization.room (tenant_id, code);
CREATE INDEX room_unit_idx ON organization.room (tenant_id, unit_id);
CREATE INDEX room_facility_idx ON organization.room (tenant_id, facility_id);

-- The target of the bed's composite key below: a bed's facility is its room's,
-- held by the database rather than by whoever writes the row.
CREATE UNIQUE INDEX room_identity_within_facility
    ON organization.room (room_id, facility_id);

CREATE TABLE organization.bed (
    bed_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL REFERENCES organization.tenant (tenant_id),

    room_id     uuid NOT NULL REFERENCES organization.room (room_id),
    -- Denormalised from the room so a bed can be listed and scoped by facility
    -- without a join, and so the composite key below can hold the rule that a
    -- bed and its room are in the same facility.
    facility_id uuid NOT NULL REFERENCES organization.facility (facility_id),

    code         text NOT NULL CHECK (code ~ '^[A-Z0-9][A-Z0-9_-]{1,31}$'),
    display_name text NOT NULL CHECK (length(btrim(display_name)) > 0),

    -- Physical existence. Retirement is terminal; there is no delete
    -- (SRS-PLT-015).
    status text NOT NULL CHECK (status IN ('active', 'retired')),
    -- Whether it can be used, which moves many times a day and says nothing
    -- about whether the hospital has the bed. SRS-PLT-006's verification
    -- clause is that these two are independent, which is why they are two
    -- columns.
    availability text NOT NULL CHECK (availability IN (
        'available', 'occupied', 'cleaning', 'blocked', 'out_of_service')),
    unavailable_reason text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    version    bigint      NOT NULL CHECK (version > 0),

    -- Blocking a bed and taking it out of service are decisions somebody
    -- makes. Occupancy and cleaning are recorded by the systems that cause
    -- them, so they need no typed reason.
    CONSTRAINT a_bed_out_of_use_says_why CHECK (
        availability NOT IN ('blocked', 'out_of_service')
        OR length(btrim(unavailable_reason)) > 0
    ),
    -- A retired bed is not available. Without this a retired row could still
    -- read as free and the ward would admit into a bed the hospital no longer
    -- has.
    CONSTRAINT a_retired_bed_is_not_available CHECK (
        status <> 'retired' OR availability <> 'available'
    ),
    -- A bed is in its room's facility. The composite key makes that a
    -- single-row check rather than a rule somebody has to remember.
    CONSTRAINT a_bed_is_in_its_rooms_facility
        FOREIGN KEY (room_id, facility_id)
        REFERENCES organization.room (room_id, facility_id)
);

CREATE UNIQUE INDEX bed_tenant_code_key ON organization.bed (tenant_id, code);
CREATE INDEX bed_room_idx ON organization.bed (tenant_id, room_id);
-- The ward board's query: the free beds in a facility.
CREATE INDEX bed_available_idx
    ON organization.bed (tenant_id, facility_id)
    WHERE status = 'active' AND availability = 'available';
