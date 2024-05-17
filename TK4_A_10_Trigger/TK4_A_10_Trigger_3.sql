CREATE OR REPLACE FUNCTION check_delete_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.timestamp < NOW() - INTERVAL '1 day' THEN
        RAISE EXCEPTION 'Cannot delete rows older than 1 day!';
    ELSE
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_delete_check_timestamp
BEFORE DELETE ON tayangan_terunduh
FOR EACH ROW
EXECUTE FUNCTION check_delete_timestamp();
