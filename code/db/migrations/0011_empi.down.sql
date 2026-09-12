-- Reverses 0011.
--
-- Dropping these tables destroys the link between every clinical record and the
-- person it belongs to. Nothing downstream can reconstruct it: an order row
-- holds a patient_id and no demographics, by design. This file exists for a
-- failed deploy against an empty database. Anywhere with data, restore from
-- backup instead.

DROP TABLE IF EXISTS empi.patient_identifier;
DROP TABLE IF EXISTS empi.patient;
DROP TABLE IF EXISTS empi.match_config;
DROP TABLE IF EXISTS empi.demographic_policy;
DROP SCHEMA IF EXISTS empi;
