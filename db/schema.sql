CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS measurements (
  id UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  dataclip_reference TEXT NOT NULL,
  librato_base_name TEXT NOT NULL,
  librato_source TEXT,
  run_at TIMESTAMPTZ,
  run_interval INTEGER
);

CREATE TABLE IF NOT EXISTS metrics (
  id UUID PRIMARY KEY DEFAULT UUID_GENERATE_V4(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  name TEXT NOT NULL,
  duration FLOAT NOT NULL
);

CREATE INDEX measurements_run_at_run_interval ON measurements(run_at, run_interval);
CREATE UNIQUE INDEX measurements_unique_dataclip_reference ON measurements(dataclip_reference);

CREATE INDEX metrics_name ON metrics(name);
