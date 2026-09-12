-- 0019 Check-in, the queue and notifications (SRS-SCH-007 … SRS-SCH-012).
--
-- The queue is the part of scheduling patients actually experience. Everything
-- before it is arrangement; this is the hour they spend in a room wondering
-- whether they have been forgotten.
--
-- Trace: SRS-SCH-007 (check-in with token and arrival mode), SRS-SCH-008
--   (queue states), SRS-SCH-009 (wait estimate), SRS-SCH-010 (walk-ins),
--   SRS-SCH-011 (reprioritisation with reason, audited and visible),
--   SRS-SCH-012 (notifications with recorded delivery outcome).
-- Rollback: drops the notification table and the queue columns. Today's queue
--   is lost — tokens, priorities and the reasons behind them — so a clinic
--   mid-session would have to rebuild it verbally. Roll back between sessions.
--   The notification history is the record that answers a patient who says they
--   were never told; export it first.
-- Reconciliation: the queue columns are nullable or defaulted and read
--   correctly for every existing row: no appointment had been checked in.
--   Rows the previous version writes during the rollout window take the same
--   defaults, and a patient checked in by the old code simply has no token —
--   visible, and not wrong.

-- Walk-ins hold no rostered slot: by definition nobody set time aside
-- (SRS-SCH-010). Everything else about them is an ordinary appointment, so
-- every downstream context sees them without knowing about a second kind of
-- record.
ALTER TABLE scheduling.appointment
    ALTER COLUMN slot_id DROP NOT NULL;

-- What the patient is called by. Not the appointment id: that is a UUID nobody
-- can read out across a noisy waiting room.
ALTER TABLE scheduling.appointment
    ADD COLUMN token text NOT NULL DEFAULT '';

-- How they got here (SRS-SCH-007). It changes what happens next: somebody
-- brought in by ambulance is not joining the back of the queue.
ALTER TABLE scheduling.appointment
    ADD COLUMN arrival_mode text NOT NULL DEFAULT ''
        CHECK (arrival_mode IN (
            '', 'walk_in', 'scheduled', 'ambulance', 'referral', 'telehealth'));

ALTER TABLE scheduling.appointment
    ADD COLUMN checked_in_at timestamptz;

-- A five-band scale is what triage systems use and what staff can hold in their
-- heads. A numeric score would invite arithmetic, and arithmetic on clinical
-- urgency is how somebody ends up behind a spreadsheet.
ALTER TABLE scheduling.appointment
    ADD COLUMN priority text NOT NULL DEFAULT ''
        CHECK (priority IN (
            '', 'immediate', 'very_urgent', 'urgent', 'standard', 'non_urgent'));

-- Shown to queue users, not buried in an audit table. SRS-SCH-011 asks for
-- "audited and visible to queue users", and the second half is the one that
-- matters at the desk: a board showing that somebody went ahead without saying
-- why produces the argument the reason exists to prevent.
ALTER TABLE scheduling.appointment
    ADD COLUMN priority_reason text NOT NULL DEFAULT '';

-- A patient ahead of the queue with no stated reason is indistinguishable from
-- queue-jumping, and the people waiting can see the board.
ALTER TABLE scheduling.appointment
    ADD CONSTRAINT priority_above_standard_explains_itself CHECK (
        priority IN ('', 'standard') OR priority_reason <> ''
    );

-- A checked-in patient has a token and an arrival mode, or the board has a
-- blank row nobody can call.
ALTER TABLE scheduling.appointment
    ADD CONSTRAINT check_ins_are_complete CHECK (
        checked_in_at IS NULL
        OR (token <> '' AND arrival_mode <> '' AND priority <> '')
    );

-- One live token per facility per day.
--
-- Two patients holding "A12" in the same waiting room is a call nobody can
-- answer. Scoped to the calendar date in UTC rather than local: a token is a
-- within-session convenience, and the uniqueness only has to hold for as long
-- as the session does.
CREATE UNIQUE INDEX appointment_token_key
    ON scheduling.appointment (
        tenant_id, facility_id, token,
        -- Cast through UTC explicitly. A bare timestamptz::date depends on the
        -- session's TimeZone setting, which PostgreSQL will not index on, and
        -- which would silently mean different things to two connections.
        ((checked_in_at AT TIME ZONE 'UTC')::date)
    )
    WHERE token <> '' AND status NOT IN ('completed', 'no_show', 'cancelled');

-- The queue a board renders and a clerk works.
CREATE INDEX appointment_queue_idx
    ON scheduling.appointment (tenant_id, facility_id, priority, checked_in_at)
    WHERE checked_in_at IS NOT NULL
      AND status IN ('arrived', 'triaged', 'waiting_clinician');

-- One message about one appointment (SRS-SCH-012).
--
-- Scheduling does not send anything: channels, templates, retries and quiet
-- hours belong to a notification service. It decides that something notifiable
-- happened and records what came back — which is the acceptance criterion, and
-- the thing that distinguishes a patient who says they were never told from one
-- who was.
CREATE TABLE scheduling.appointment_notification (
    notification_id uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    -- One of appointment_id or waitlist_id. A waitlist offer is a message
    -- about an offer rather than about a booking — there is no appointment yet,
    -- and that message's delivery outcome is the one that matters most: an
    -- offer nobody received expires against a patient who never had the chance
    -- to answer.
    appointment_id  uuid        REFERENCES scheduling.appointment (appointment_id)
                        ON DELETE CASCADE,
    waitlist_id     uuid        REFERENCES scheduling.waitlist_entry (waitlist_id)
                        ON DELETE CASCADE,
    patient_id      uuid        NOT NULL,
    kind            text        NOT NULL CHECK (kind IN (
                        'booked', 'reminder', 'rescheduled', 'cancelled',
                        'waitlist_offer')),
    -- A string rather than an enum: the set of channels is the notification
    -- service's to know, and an enumeration here would need changing every time
    -- that service gains one.
    channel         text        NOT NULL CHECK (channel <> ''),
    outcome         text        NOT NULL CHECK (outcome IN (
                        'pending', 'sent', 'delivered', 'failed', 'suppressed')),
    -- Explains a failure or a suppression in a sentence somebody at a desk can
    -- act on. "Failed" alone tells them nothing.
    detail          text        NOT NULL DEFAULT '',
    -- When the message becomes due. Set for a reminder; NULL for anything that
    -- goes immediately.
    send_after      timestamptz,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,

    CONSTRAINT failures_explain_themselves CHECK (
        outcome NOT IN ('failed', 'suppressed') OR detail <> ''
    ),
    -- Exactly one subject. A message about neither is a row nobody can trace
    -- back to the patient it concerns; a message about both would be two.
    CONSTRAINT notifications_have_one_subject CHECK (
        (appointment_id IS NULL) <> (waitlist_id IS NULL)
    )
);

CREATE INDEX appointment_notification_appointment_idx
    ON scheduling.appointment_notification (tenant_id, appointment_id, created_at)
    WHERE appointment_id IS NOT NULL;

CREATE INDEX appointment_notification_waitlist_idx
    ON scheduling.appointment_notification (tenant_id, waitlist_id, created_at)
    WHERE waitlist_id IS NOT NULL;

-- The queue of messages waiting to go out. Partial: resolved ones are history.
CREATE INDEX appointment_notification_pending_idx
    ON scheduling.appointment_notification (tenant_id, send_after)
    WHERE outcome = 'pending';

-- The worklist somebody checks when a patient says they were never told.
CREATE INDEX appointment_notification_failed_idx
    ON scheduling.appointment_notification (tenant_id, updated_at)
    WHERE outcome IN ('failed', 'suppressed');

-- Which messages a facility sends (SRS-SCH-012). On the policy row that already
-- holds the cancellation and teleconsult rules, because all three are "what
-- this facility does" and a second table would be a second lookup.
ALTER TABLE scheduling.cancellation_policy
    ADD COLUMN notification_kinds text[] NOT NULL
        DEFAULT '{booked,reminder,rescheduled,cancelled,waitlist_offer}';

-- Zero disables reminders even where the kind is enabled: "remind them at the
-- appointment time" is not a reminder.
ALTER TABLE scheduling.cancellation_policy
    ADD COLUMN reminder_hours_before integer NOT NULL DEFAULT 24
        CHECK (reminder_hours_before BETWEEN 0 AND 720);

-- The queue number a patient is called by (SRS-SCH-007).
--
-- A counter rather than a random string, because "queue number" is what the
-- requirement says and what a waiting room understands: 014 is after 013, and a
-- board showing "K7QX" tells nobody how long they have left. One sequence per
-- facility per day, reset by the date rather than by a job — a clinic that
-- opens on a public holiday should not find yesterday's numbers still running.
CREATE TABLE scheduling.queue_counter (
    tenant_id   uuid        NOT NULL,
    facility_id uuid        NOT NULL,
    queue_date  date        NOT NULL,
    -- The next number to issue. Advanced by a guarded upsert that takes the row
    -- lock, so two clerks checking patients in at the same moment cannot both
    -- be handed 014.
    next_number integer     NOT NULL CHECK (next_number > 0),
    updated_at  timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, facility_id, queue_date)
);
