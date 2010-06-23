ALTER TABLE messages
ADD COLUMN tsv tsvector NOT NULL;

CREATE INDEX message_body_fti    ON messages USING gin(tsv);
