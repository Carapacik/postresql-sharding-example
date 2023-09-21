CREATE EXTENSION postgres_fdw;

/* SHARD 1 */
CREATE SERVER clients_1_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host 'postgres_db1',
    port '5432',
    dbname 'clients'
);

CREATE USER MAPPING FOR "postgres" SERVER clients_1_server OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE clients_1 (
    id bigint NOT NULL,
    full_name text NOT NULL,
    birth_year integer NOT NULL
) SERVER clients_1_server OPTIONS (schema_name 'public', table_name 'clients');

CREATE FOREIGN TABLE leads_1 (
    id bigint NOT NULL,
    client_id bigint NOT NULL,
    product_id bigint NOT NULL,
    summ integer NOT NULL
) SERVER clients_1_server OPTIONS (schema_name 'public', table_name 'leads');

/* SHARD 2 */
CREATE SERVER clients_2_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host 'postgres_db2',
    port '5432',
    dbname 'clients'
);

CREATE USER MAPPING FOR "postgres" SERVER clients_2_server OPTIONS (user 'postgres', password 'postgres');

CREATE FOREIGN TABLE clients_2 (
    id bigint NOT NULL,
    full_name text NOT NULL,
    birth_year integer NOT NULL
) SERVER clients_2_server OPTIONS (schema_name 'public', table_name 'clients');

CREATE FOREIGN TABLE leads_2 (
    id bigint NOT NULL,
    client_id bigint NOT NULL,
    product_id bigint NOT NULL,
    summ integer NOT NULL
) SERVER clients_2_server OPTIONS (schema_name 'public', table_name 'leads');

/* SERVER */
CREATE VIEW clients AS
SELECT
    *
FROM
    clients_1
UNION
ALL
SELECT
    *
FROM
    clients_2;

CREATE VIEW leads AS
SELECT
    *
FROM
    leads_1
UNION
ALL
SELECT
    *
FROM
    leads_2;

CREATE RULE clients_insert AS ON
INSERT
    TO clients DO INSTEAD NOTHING;

CREATE RULE clients_update AS ON UPDATE TO clients DO INSTEAD NOTHING;

CREATE RULE clients_delete AS ON DELETE TO clients DO INSTEAD NOTHING;

CREATE RULE leads_insert AS ON
INSERT
    TO leads DO INSTEAD NOTHING;

CREATE RULE leads_update AS ON UPDATE TO leads DO INSTEAD NOTHING;

CREATE RULE leads_delete AS ON DELETE TO leads DO INSTEAD NOTHING;

CREATE RULE clients_insert_to_1 AS ON
INSERT
    TO clients
WHERE
    (id % 2 = 0) DO INSTEAD
INSERT INTO
    clients_1
VALUES
    (NEW.*);

CREATE RULE leads_insert_to_1 AS ON
INSERT
    TO leads
WHERE
    (client_id % 2 = 0) DO INSTEAD
INSERT INTO
    leads_1
VALUES
    (NEW.*);

CREATE RULE clients_insert_to_2 AS ON
INSERT
    TO clients
WHERE
    (id % 2 = 1) DO INSTEAD
INSERT INTO
    clients_2
VALUES
    (NEW.*);

CREATE RULE leads_insert_to_2 AS ON
INSERT
    TO leads
WHERE
    (client_id % 2 = 1) DO INSTEAD
INSERT INTO
    leads_2
VALUES
    (NEW.*);