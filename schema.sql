CREATE TABLE measurements (id serial primary key, created_at timestamptz default (now()), dataclip_reference text, librato_base_name text, run_at timestamptz, run_every_seconds integer);
