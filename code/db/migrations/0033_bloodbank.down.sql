-- Rollback for 0033.
--
-- Drops every donor record, deferral, test result, inventory row, crossmatch,
-- issue, transfusion and reaction. A transfusion record is read in a coroner's
-- court and a deferral record is what keeps an infected donation out of the
-- supply. This is a disaster-recovery action, never a deployment step.
DROP SCHEMA IF EXISTS bloodbank CASCADE;
