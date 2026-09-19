-- Rollback for 0037.
--
-- Drops every asset record, service contract, maintenance plan, ticket, safety
-- notice, telemetry reading and disposal. The maintenance history is what an
-- accreditation inspection reads and what a recall is answered from. This is a
-- disaster-recovery action, never a deployment step.
DROP SCHEMA IF EXISTS biomedical CASCADE;
