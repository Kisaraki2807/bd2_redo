
DROP DATABASE IF EXISTS stars_db;

CREATE DATABASE stars_db;

\c stars_db;

--tabela para o teste
CREATE UNLOGGED TABLE stars(
    star_name TEXT PRIMARY KEY,
    tempK NUMERIC NOT NULL,
    radS NUMERIC NOT NULL
);

--tabela de log
CREATE TABLE stars_log(
    log_id SERIAL PRIMARY KEY,
    transaction_id INT NOT NULL,
    operation TEXT NOT NULL,
    changed_star_name TEXT,
    new_tempK NUMERIC,
    new_radS NUMERIC
);

-- transaction 1 id=101 com commit
BEGIN;
INSERT INTO stars_log (transaction_id, operation) VALUES (101, 'START');

INSERT INTO stars VALUES ('Sun', 5772, 1);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (101, 'INSERT', 'Sun', 5772, 1);

INSERT INTO stars VALUES ('Proxima Centauri', 3000, 0.3);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (101, 'INSERT', 'Proxima Centauri', 3000, 0.3);

INSERT INTO stars VALUES ('Antares', 3500, 680);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (101, 'INSERT', 'Antares', 3500, 680);

UPDATE stars SET radS = 0.3084 WHERE star_name = 'Proxima Centauri';
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (101, 'UPDATE', 'Proxima Centauri', 3000, 0.3084);

INSERT INTO stars VALUES ('Rigel', 11000, 78);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (101, 'INSERT', 'Rigel', 11000, 78);

INSERT INTO stars_log (transaction_id, operation) VALUES (101, 'COMMIT');
END;

-- transaction 2 id=102 com commit
BEGIN;
INSERT INTO stars_log (transaction_id, operation) VALUES (102, 'START');

INSERT INTO stars VALUES ('Sirius A', 9940, 1);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (102, 'INSERT', 'Sirius A', 9940, 1);

UPDATE stars SET radS = 1.71 WHERE star_name = 'Sirius A';
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (102, 'UPDATE', 'Sirius A', 9940, 1.71);

INSERT INTO stars VALUES ('Betelgeuse', 3600, 887);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (102, 'INSERT', 'Betelgeuse', 3600, 887);

UPDATE stars SET tempK = 3500 WHERE star_name = 'Betelgeuse';
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (102, 'UPDATE', 'Betelgeuse', 3500, 887);

INSERT INTO stars VALUES ('Vega', 9062, 2.36);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (102, 'INSERT', 'Vega', 9062, 2.36);

INSERT INTO stars_log (transaction_id, operation) VALUES (102, 'COMMIT');
END;

-- transaction 3 id=103 sem commit para simular crash nela
BEGIN;
INSERT INTO stars_log (transaction_id, operation) VALUES (103, 'START');

INSERT INTO stars VALUES ('Canopus', 7400, 71);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (103, 'INSERT', 'Canopus', 7400, 71);

INSERT INTO stars VALUES ('Arcturus', 4290, 25.4);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (103, 'INSERT', 'Arcturus', 4290, 25.4);

INSERT INTO stars VALUES ('Altair', 7650, 1.8);
INSERT INTO stars_log (transaction_id, operation, changed_star_name, new_tempK, new_radS)
VALUES (103, 'INSERT', 'Altair', 7650, 1.8);