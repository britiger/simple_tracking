-- running within database for user
-- CREATE DATABASE simple_tracking OWNER simple_tracking;
-- CREATE EXTENSION postgis;

CREATE SCHEMA simple_tracking;

CREATE TABLE simple_tracking.devices (
    id SERIAL PRIMARY KEY,
    identifier VARCHAR(255) UNIQUE,
    display_name VARCHAR(255),
    valid_identifier BOOLEAN DEFAULT false
);

CREATE TABLE simple_tracking.positions (
    id SERIAL PRIMARY KEY,
    devices_id INT,
    latest_position BOOLEAN DEFAULT true,
    data_ts TIMESTAMP with time zone,
    recieved_ts TIMESTAMP with time zone DEFAULT NOW(),
    position geometry,
    data jsonb,
    CONSTRAINT fk_devices
      FOREIGN KEY(devices_id) 
      REFERENCES simple_tracking.devices(id)
      ON DELETE CASCADE
);

CREATE INDEX positions_device ON simple_tracking.positions(devices_id);
CREATE INDEX positions_latest ON simple_tracking.positions(latest_position) WHERE latest_position;

CREATE OR REPLACE FUNCTION trigger_set_latest()
RETURNS TRIGGER 
AS $$
BEGIN
   UPDATE simple_tracking.positions SET latest_position = false WHERE latest_position AND devices_id = NEW.devices_id;

   RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER insert_new_position
    BEFORE INSERT ON simple_tracking.positions
    FOR EACH ROW
       EXECUTE PROCEDURE trigger_set_latest();

CREATE OR REPLACE FUNCTION get_device_id(ident VARCHAR)
RETURNS INTEGER
AS $$
DECLARE
    devices_id INTEGER;
BEGIN
    SELECT id INTO devices_id FROM simple_tracking.devices d WHERE identifier=ident;
    IF devices_id IS NULL THEN
        INSERT INTO simple_tracking.devices (identifier) VALUES (ident) RETURNING id INTO devices_id;
    END IF;
    RETURN devices_id;
END;
$$ LANGUAGE PLPGSQL;
