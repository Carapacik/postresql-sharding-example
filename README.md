PostgreSQL sharding example

### Setup the first shard
```shell
docker-compose up -d postgres_db1
docker exec -it postgres_db1 psql -U postgres -d clients -f /scripts/shards.sql -a
```

### Setup the second shard
```shell
docker-compose up -d postgres_db2
docker exec -it postgres_db2 psql -U postgres -d clients -f /scripts/shards.sql -a
```

### Setup the main server
```shell
docker-compose up -d postgres_db
docker exec -it postgres_db psql -U postgres -d clients -f /scripts/shards.sql -a
```

### Test insert performance with sharding(MacBook Pro M1 Pro)
Add 500 000 000 rows

```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -f /scripts/seed.sql
```
```shell
Time: 3986041.002 ms (01:06:26.041)
```

### Test insert performance without sharding(MacBook Pro M1 Pro)
Add 500 000 000 rows

```shell
docker exec -it postgres_db psql -U postgres -d clients -f /scripts/without_shards.sql -a
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -f /scripts/seed_without_shards.sql
```
```shell
Time: 24046.858 ms (00:24.047)
```

### Test select performance
#### From single table
Shard 1 with constraint `id % 2 = 0`
```shell
docker exec -it postgres_db1 psql -U postgres -d clients -c '\timing' -c "select count(*) from clients"
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients where id % 2 = 0"
```

Shard 2 with constraint `id % 2 = 1`
```shell
docker exec -it postgres_db2 psql -U postgres -d clients -c '\timing' -c "select count(*) from clients"
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients where id % 2 = 1"
```

Without sharding
```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients_without_shards"
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients_without_shards where id % 2 = 1"
```

#### With join
With sharding
```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from leads left join clients on leads.client_id = clients.id where leads.summ > 50000 and leads.client_id % 2 = 1"
```

Without sharding
```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from leads left join clients_without_sharding on leads_without_sharding.client_id = clients_without_sharding.id where leads_without_sharding.summ > 50000 and leads_without_sharding.client_id % 2 = 1"
```
