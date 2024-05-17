CREATE OR REPLACE FUNCTION func_check_username_exists()
RETURNS TRIGGER AS 
$$
BEGIN
    IF EXISTS (SELECT 1 FROM PENGGUNA WHERE username = NEW.username) THEN
        RAISE EXCEPTION 'Username % already exists! Please create a new one.', NEW.username;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_check_username_exists
BEFORE INSERT ON pengguna
FOR EACH ROW
EXECUTE FUNCTION func_check_username_exists();