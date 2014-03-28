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
  duration REAL NOT NULL
);

CREATE INDEX measurements_run_at_run_interval ON measurements(run_at, run_interval);
CREATE UNIQUE INDEX measurements_unique_dataclip_reference ON measurements(dataclip_reference);

CREATE INDEX metrics_name ON metrics(name);

-- Found on https://stackoverflow.com/questions/14300004/postgresql-equivalent-of-oracles-percentile-cont-function/14309370#14309370

CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
RETURNS ANYARRAY LANGUAGE SQL
AS $$
SELECT ARRAY(
  SELECT $1[s.i] AS "foo"
  FROM
  generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
  ORDER BY foo
);
$$;

CREATE OR REPLACE FUNCTION percentile_cont(myarray real[], percentile real)
RETURNS real AS
$$

DECLARE
ary_cnt INTEGER;
row_num real;
crn real;
frn real;
calc_result real;
new_array real[];
BEGIN
  ary_cnt = array_length(myarray,1);
  row_num = 1 + ( percentile * ( ary_cnt - 1 ));
  new_array = array_sort(myarray);

  crn = ceiling(row_num);
  frn = floor(row_num);

  if crn = frn and frn = row_num then
    calc_result = new_array[row_num];
  else
    calc_result = (crn - row_num) * new_array[frn]
    + (row_num - frn) * new_array[crn];
  end if;

  RETURN calc_result;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;
