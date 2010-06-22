DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
    name   CITEXT NOT NULL,
    server CITEXT NOT NULL REFERENCES servers(name)
            ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (name, server)
);

