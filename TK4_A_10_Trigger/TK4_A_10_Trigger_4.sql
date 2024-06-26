CREATE OR REPLACE FUNCTION manage_package()
RETURNS TRIGGER AS
$$
DECLARE
    is_active_package BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM TRANSACTION AS T
        JOIN PAKET AS P ON P.nama = T.nama_paket
        JOIN DUKUNGAN_PERANGKAT AS D ON D.nama_paket = P.nama
        WHERE T.nama_paket IS NOT NULL
          AND T.username = NEW.username
          AND CURRENT_DATE BETWEEN T.start_date_time AND T.end_date_time
    ) INTO is_active_package;

    IF is_active_package THEN
        DELETE FROM TRANSACTION
        WHERE nama_paket IS NOT NULL
          AND username = NEW.username
          AND CURRENT_DATE BETWEEN start_date_time AND end_date_time;

        INSERT INTO TRANSACTION (username, start_date_time, end_date_time, nama_paket, metode_pembayaran, timestamp_pembayaran)
        VALUES (NEW.username, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 month', NEW.nama_paket, NEW.metode_pembayaran, CURRENT_TIMESTAMP);

        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER validate_package_activation
BEFORE INSERT ON TRANSACTION
FOR EACH ROW EXECUTE FUNCTION manage_package();
