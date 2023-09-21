INSERT INTO
    clients_without_sharding (id, full_name, birth_year)
SELECT
    generate_series(0, 5000000),
    md5(random() :: text) as full_name,
    floor(random() * 80 + 1940) :: int AS birth_year;

INSERT INTO
    products_without_sharding (id, product_name, max_summ)
SELECT
    generate_series(0, 50),
    'PRODUCT' || generate_series(0, 50) :: text as full_name,
    floor(generate_series(0, 50) * 100) :: int AS max_summ;

INSERT INTO
    leads_without_sharding (id, client_id, product_id, summ)
SELECT
    generate_series(0, 100000),
    floor(random() * 5000000) :: int AS client_id,
    floor(random() * 50) :: int AS product_id,
    floor(random() * 100000 + 5000) :: int AS summ;