DROP TABLE IF EXISTS users;
CREATE TABLE users (
    nickname  CITEXT      PRIMARY KEY,
    password  TEXT        NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
