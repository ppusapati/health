ALTER TABLE bloodbank.reaction
    DROP CONSTRAINT IF EXISTS a_reaction_records_what_was_done;
ALTER TABLE bloodbank.reaction DROP COLUMN IF EXISTS action_taken;
