-- 0048 A reaction records what was done at the bedside (SRS-NUR-014).
--
-- Trace: SRS-NUR-014, SRS-BLD-012.
--
-- 0047 left bloodbank.episode as the one record of a transfusion. Two of the
-- rules nursing held were not in this context: a transfusion may not start
-- without the observations it will be read against, and reporting a reaction
-- says what was done about it. The first is a refusal in the domain and needs
-- no column — the baseline set was already written as an observation. The
-- second needs somewhere to put the answer, and this is it.
--
-- The action belongs on the reaction rather than on the episode's stop_reason.
-- A reaction can be reported against a transfusion that has already finished —
-- a delayed one, or a retrospective report — and those have no stop to hang it
-- from, but the haemovigilance report still asks what was done.
--
-- Rollback: the down migration drops the column, which loses the actions
-- recorded while it existed. Nothing else reads it, so a rollback is otherwise
-- safe; re-applying it backfills the same sentinel below.
--
-- Reconciliation: the previous version of the service does not send an action
-- and would be refused by the domain before reaching this table, so there is
-- no window in which rows arrive without one. Rows written before this
-- migration carry the sentinel and are distinguishable from real answers.

ALTER TABLE bloodbank.reaction
    ADD COLUMN action_taken text NOT NULL DEFAULT '';

-- Reactions reported before this column existed have no answer to give. The
-- sentinel says so in the row rather than leaving an empty string that reads
-- as "nothing was done".
UPDATE bloodbank.reaction
   SET action_taken = 'not recorded: reported before the bedside action was captured'
 WHERE action_taken = '';

ALTER TABLE bloodbank.reaction
    ADD CONSTRAINT a_reaction_records_what_was_done CHECK (action_taken <> '');
