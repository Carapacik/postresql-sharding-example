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


```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -f /scripts/seed.sql
```
Add 5 000 000 rows
```shell
Time: 40321.847 ms (00:40.322)

Time: 9845.150 ms (00:09.845)
```

### Test insert performance without sharding(MacBook Pro M1 Pro)


```shell
docker exec -it postgres_db psql -U postgres -d clients -f /scripts/without_shards.sql -a
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -f /scripts/seed_without_shards.sql
```
Add 5 000 000 rows
```shell
Time: 1407.495 ms (00:01.407)

Time: 2355.717 ms (00:02.356)
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
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients_without_sharding"
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from clients_without_sharding where id % 2 = 1"
```

#### With join
With sharding
```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from leads left join clients on leads.client_id = clients.id where leads.summ > 50000 and leads.client_id % 2 = 1"
```

Without sharding
```shell
docker exec -it postgres_db psql -U postgres -d clients -c '\timing' -c "select count(*) from leads_without_sharding left join clients_without_sharding on leads_without_sharding.client_id = clients_without_sharding.id where leads_without_sharding.summ > 50000 and leads_without_sharding.client_id % 2 = 1"
```
