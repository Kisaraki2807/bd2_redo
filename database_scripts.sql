
DROP DATABASE IF EXISTS stars_db;

CREATE DATABASE stars_db;

CREATE UNLOGGED TABLE stars(
    id SERIAL PRIMARY KEY,
    star_name TEXT NOT NULL,
    tempK NUMERIC NOT NULL,
    radS NUMERIC NOT NULL
);

CREATE TABLE stars_log(
    log_id SERIAL PRIMARY KEY,
    transaction_id INT NOT NULL,
    operation TEXT NOT NULL,
    changed_data_id INT,
    new_star_name TEXT,
    new_tempK NUMERIC,
    new_radS NUMERIC
);


