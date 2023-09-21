CREATE TABLE clients (
    id bigint NOT NULL PRIMARY KEY,
    full_name text NOT NULL,
    CONSTRAINT id_check CHECK (id % 2 = 0),
    birth_year integer NOT NULL
);

CREATE SEQUENCE clients_seq start 0 increment 2 NO MAXVALUE CACHE 1 OWNED BY clients.id;

CREATE TABLE products (
    id bigint NOT NULL PRIMARY KEY,
    product_name text NOT NULL,
    max_summ integer NOT NULL
);

CREATE TABLE leads (
    id bigint NOT NULL PRIMARY KEY,
    client_id bigint NOT NULL REFERENCES clients (id),
    CONSTRAINT client_id_check CHECK (client_id % 2 = 0),
    product_id bigint NOT NULL REFERENCES products (id),
    summ integer NOT NULL
);

CREATE INDEX clients_id_x ON clients USING btree(id);

INSERT INTO
    products (id, product_name, max_summ)
SELECT
    generate_series(0, 50),
    'PRODUCT' || generate_series(0, 50) :: text as full_name,
    floor(generate_series(0, 50) * 100) :: int AS max_summ;