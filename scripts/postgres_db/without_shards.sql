CREATE TABLE clients_without_sharding (
    id bigint not null PRIMARY KEY,
    full_name text not null,
    birth_year integer not null
);

CREATE TABLE products_without_sharding (
    id bigint not null PRIMARY KEY,
    product_name text not null,
    max_summ integer not null
);

CREATE TABLE leads_without_sharding (
    id bigint not null PRIMARY KEY,
    FOREIGN KEY client_id REFERENCES clients_without_sharding (id),
    FOREIGN KEY product_id REFERENCES products_without_sharding (id),
    product_id bigint not null,
    summ integer not null
);

CREATE INDEX clients_without_sharding_id_x ON clients_without_sharding USING btree(id);