-- Rollback for 0034.
--
-- Drops every instrument record, packing list version, reprocessing run,
-- sterilizer cycle, indicator result, issue and recall. The cycle record is
-- what an infection investigation runs along and what a recall is announced
-- by. This is a disaster-recovery action, never a deployment step.
DROP SCHEMA IF EXISTS sterile CASCADE;
