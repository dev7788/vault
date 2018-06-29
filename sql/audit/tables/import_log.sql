CREATE TABLE audit.import_log
(
  id bigserial NOT NULL PRIMARY KEY,
  finish_time timestamp without time zone not null,
  attribute_count bigint not null,
  clinic_count bigint not null,
  entry_count bigint not null,
  entry_attribute_count bigint not null,
  patient_count bigint not null,
  patient_practitioner_count bigint not null,
  practitioner_count bigint not null,
  state_count bigint not null
);
