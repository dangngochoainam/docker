# Docker Stack

A collection of independent Docker Compose stacks for local/server infrastructure. All services share a single external network `docker_stack`.

## Quick Start

**1. Create the shared network (once)**
```bash
bash create-network.sh
```

**2. Start any stack**
```bash
cd <directory> && docker compose up -d
```

## Stacks

| Directory | Services | Ports |
|---|---|---|
| `postgres/` | PostgreSQL 18.3 | 5434 |
| `mongo/` | MongoDB 8.0 | 27018 |
| `redis/` | Redis 8.8.0 | 6381 |
| `rabbitmq/` | RabbitMQ 4.3.2 + management UI | 15673, 5673 |
| `minio/` | MinIO (S3-compatible storage) | 9000 (API), 9001 (console) |
| `nginx/` | Nginx 1.30.2 | 80 |
| `observability/` | Prometheus, Loki, Grafana | 9090, 3100, 3000 |
| `promtail/` | Promtail (log shipper → Loki) | — |
| `portainer/` | Portainer CE (container UI) | 8000, 9443 |
| `watchtower/` | Watchtower (auto-updater) | — |

## Default Credentials

All services use `root` / `Abc12345` by default.

| Service | Override env vars |
|---|---|
| PostgreSQL | `POSTGRES_USER`, `POSTGRES__PASSWORD` |
| All others | hardcoded in compose file |

## Notes

- **Grafana** first-run: login `admin` / `admin` at http://localhost:3000, then add data sources — Prometheus (`http://prometheus:9090`) and Loki (`http://loki:3100`).
- **Watchtower** watches all containers by default. To limit scope: `WATCHTOWER_CONTAINER_NAME="nginx postgres" docker compose up -d`
- **Promtail** container-ID paths in `promtail/promtail.yml` are deployment-specific — update them on a new host.
