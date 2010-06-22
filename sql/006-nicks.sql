DROP TABLE IF EXISTS nicks;
CREATE TABLE nicks (
    name   CITEXT NOT NULL,
    server CITEXT NOT NULL REFERENCES servers(name)
            ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (name, server)
);
