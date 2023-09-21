CREATE TABLE clients_without_sharding (
    id bigint NOT NULL PRIMARY KEY,
    full_name text NOT NULL,
    birth_year integer NOT NULL
);

CREATE TABLE products_without_sharding (
    id bigint NOT NULL PRIMARY KEY,
    product_name text NOT NULL,
    max_summ integer NOT NULL
);

CREATE TABLE leads_without_sharding (
    id bigint NOT NULL PRIMARY KEY,
    client_id bigint REFERENCES clients_without_sharding (id),
    product_id bigint REFERENCES products_without_sharding (id),
    summ integer NOT NULL
);

CREATE INDEX clients_without_sharding_id_x ON clients_without_sharding USING btree(id);