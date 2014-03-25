CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS measurements (
  id UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  dataclip_reference TEXT NOT NULL,
  librato_base_name TEXT NOT NULL,
  run_at TIMESTAMPTZ,
  run_every_seconds INTEGER
);

CREATE INDEX measurements_run_at_run_every_seconds ON measurements(run_at, run_every_seconds);
