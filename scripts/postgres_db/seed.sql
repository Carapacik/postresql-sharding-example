INSERT INTO
    clients (id, full_name, birth_year)
SELECT
    generate_series(0, 500000),
    md5(random() :: text) as full_name,
    floor(random() * 80 + 1940) :: int AS birth_year;

INSERT INTO
    leads (id, client_id, product_id, summ)
SELECT
    generate_series(0, 100000),
    floor(random() * 500000) :: int AS client_id,
    floor(random() * 50) :: int AS product_id,
    floor(random() * 100000 + 5000) :: int AS summ;