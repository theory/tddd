DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id       BIGSERIAL   PRIMARY KEY,
    server   CITEXT      NOT NULL,
    channel  CITEXT      NOT NULL,
    FOREIGN KEY (channel, server) REFERENCES channels(name, server)
            ON DELETE CASCADE ON UPDATE CASCADE
);
