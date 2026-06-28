# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A collection of independent Docker Compose stacks for local/server infrastructure. Every stack lives in its own subdirectory and can be started or stopped independently. All services communicate via a single external Docker network named `docker_stack`.

## Network Setup (Required First)

```bash
bash create-network.sh
# or
docker network create docker_stack
```

## Stacks and Their Ports

| Directory | Services | Ports |
|---|---|---|
| `postgres/` | PostgreSQL 18.3 | 5434 |
| `mongo/` | MongoDB 8.0 (single-node replica set `rs0`) | 27018 |
| `redis/` | Redis 8.8.0 | 6381 |
| `rabbitmq/` | RabbitMQ 4.3.2 + management UI | 15673, 5673 |
| `minio/` | MinIO `RELEASE.2025-09-07T16-13-09Z` | 9000 (API), 9001 (console) |
| `nginx/` | Nginx 1.30.2 | 80 |
| `observability/` | Prometheus v3.8.1, Loki 3.6.11, Grafana 12.3.7 | 9090, 3100, 3000 |
| `promtail/` | Promtail 3.6.11 (ships container logs → Loki) | internal |
| `portainer/` | Portainer CE 2.39.3 | 8000, 9443 |
| `watchtower/` | Watchtower 1.7.1 (auto-updater) | — |

## Common Commands

```bash
# Start a stack
cd <directory> && docker compose up -d

# Stop a stack
cd <directory> && docker compose down

# Tail logs
docker logs -f <container_name>

# Reload config without full restart
docker compose restart <service_name>
```

## Architecture Notes

### Redis
`redis/redis.conf` enables both RDB snapshots and AOF persistence with hybrid preamble (`aof-use-rdb-preamble yes`). Data is written to `/data` inside the container, mounted as `redis_data` volume.

### MongoDB
Runs as a **single-node replica set (`rs0`)** so multi-document transactions are supported (transactions require a replica set or sharded cluster — they fail on a standalone `mongod`). The stack is fully automated on `docker compose up -d` via three services:
- `mongo-keyfile` — one-shot init that generates the replica-set keyfile into the `mongo_keyfile` volume with the ownership/permissions mongod requires (uid/gid `999`, mode `400`).
- `mongo` — runs `mongod --replSet rs0 --keyFile ... --bind_ip_all`. Data persists in `mongo_data` at `/data/db` (not `/var/lib/mongodb/data`).
- `mongo-init` — one-shot, idempotent `rs.initiate()` (advertises the member as `mongo:27017`); exits after the replica set is configured.

Enabling a replica set together with auth forces MongoDB to require a keyfile for internal member authentication, even for a single node — hence the `mongo-keyfile` service.

**Connecting:**
- Internal (docker_stack apps): `mongodb://root:Abc12345@mongo:27017/?replicaSet=rs0&authSource=admin` — transactions supported.
- From the host (port 27018): `mongodb://root:Abc12345@localhost:27018/?directConnection=true&authSource=admin`. Use `directConnection=true` because the replica set advertises the internal host `mongo:27017`, which the host cannot resolve.

### RabbitMQ
Built from `rabbitmq/docker/Dockerfile` (extends the official image with the `rabbitmq_amqp1_0` plugin enabled).

### Observability stack (LGTM)
- **Promtail** reads raw Docker log files from `/var/lib/docker/containers` on the host and pushes them to Loki. No config change needed for new services as long as they log to stdout/stderr.
- **Prometheus** must be explicitly told about new services: add a job to `observability/prometheus/prometheus.yml`, then `docker compose restart prometheus`.
- The container-ID paths in `promtail/promtail.yml` (jobs `codebase-go-grpc-job` and `postgres-job`) are deployment-specific and must be updated on a new host.
- Default Grafana login: `admin` / `admin` at http://localhost:3000. Add Prometheus (`http://prometheus:9090`) and Loki (`http://loki:3100`) as data sources on first run.

### Watchtower
Watches all running containers by default. Scope with:
```bash
WATCHTOWER_CONTAINER_NAME="nginx postgres" docker compose up -d
```

### Default credentials
All services use `root` / `Abc12345`. PostgreSQL credentials can be overridden via `POSTGRES_USER` and `POSTGRES__PASSWORD` env vars.
