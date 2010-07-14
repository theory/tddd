CREATE DOMAIN body AS TEXT;

ALTER DOMAIN body ADD CONSTRAINT max_length CHECK ( length(value) <= 180 );

CREATE TABLE flyps (
    id        TEXT        PRIMARY KEY,
    nickname  TEXT        NOT NULL REFERENCES users(nickname),
    body      BODY        NOT NULL DEFAULT '',
    timestamp TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    tsv       tsvector    NOT NULL
);

CREATE INDEX flyp_body_fti      ON flyps USING gin(tsv);
CREATE INDEX flyp_timestamp_idx ON flyps(timestamp);

CREATE TRIGGER flyp_fti BEFORE INSERT OR UPDATE ON flyps
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(tsv, 'pg_catalog.english', body);
