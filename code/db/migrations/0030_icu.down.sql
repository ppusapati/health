-- Reverses 0030. See the up migration's rollback note: this destroys every
-- flowsheet value, infusion titration, ventilator setting, device insertion,
-- severity score and ceiling of treatment the unit has recorded, and none of
-- it is recoverable from the encounter.
DROP SCHEMA IF EXISTS icu CASCADE;
