CREATE DOMAIN body AS TEXT;

ALTER DOMAIN body ADD CONSTRAINT max_length CHECK ( length(value) <= 180 );

CREATE TABLE flips (
    id        TEXT        PRIMARY KEY,
    nickname  TEXT        NOT NULL REFERENCES users(nickname),
    body      BODY        NOT NULL DEFAULT '',
    timestamp TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    tsv       tsvector    NOT NULL
);

CREATE INDEX flip_body_fti      ON flips USING gin(tsv);
CREATE INDEX flip_timestamp_idx ON flips(timestamp);

CREATE TRIGGER flip_fti BEFORE INSERT OR UPDATE ON flips
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(tsv, 'pg_catalog.english', body);
