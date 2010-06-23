DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id       BIGSERIAL   PRIMARY KEY,
    server   CITEXT      NOT NULL,
    channel  CITEXT      NOT NULL,
    nick     CITEXT      NOT NULL,
    command  CITEXT      NOT NULL DEFAULT 'say',
    body     TEXT        NOT NULL DEFAULT '',
    seen_at  TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    is_spam  BOOLEAN     NOT NULL DEFAULT FALSE,
    FOREIGN KEY (channel, server) REFERENCES channels(name, server)
            ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nick, server)    REFERENCES nicks(name, server)
            ON DELETE CASCADE ON UPDATE CASCADE
);
