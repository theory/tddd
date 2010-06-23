CREATE TRIGGER message_fti
BEFORE INSERT OR UPDATE ON messages
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(tsv, 'pg_catalog.english', body);
