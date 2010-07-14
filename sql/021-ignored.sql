CREATE TABLE ignored (
    user_nick    TEXT NOT NULL REFERENCES users(nickname),
    ignored_nick TEXT NOT NULL REFERENCES users(nickname),
    PRIMARY KEY (user_nick, ignored_nick)
);

CREATE INDEX ignored_user_nick_idx ON ignored(user_nick);
CREATE INDEX ignored_ignored_nick_idx ON ignored(ignored_nick);
