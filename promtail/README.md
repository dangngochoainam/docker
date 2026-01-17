# Promtail Configuration for Docker Logging

This folder contains the configuration for **Promtail**, which is used to ship logs from Docker containers and the host system to **Loki**.

## Contents

- `promtail.yml`: The main configuration file for Promtail.
- `docker-compose.yaml`: Docker Compose file to deploy Promtail as a service.

## Configuration Details (`promtail.yml`)

### Server
Promtail listens on port `50060` (HTTP) and `50061` (gRPC) for health checks and internal metrics.

### Clients
Promtail is configured to push logs to a Loki instance. The current configuration points to:
`http://loki:3100/loki/api/v1/push`

**Important Notes:**
- **Local Network**: By default, it uses the service name `loki` which works within the `docker_stack` network.
- **External Address**: You can change this to any reachable HTTP address (e.g., a public IP, a domain name, or another container's IP) where your Loki server is listening.
- **Multiple Clients**: You can add multiple client URLs if you need to push logs to multiple Loki instances or other supported backends.

### Scrape Configs
The current configuration includes several jobs:
1. **docker-job-name**: Scrapes logs from all Docker containers on the host (`/var/lib/docker/containers/*/*.log`).
2. **Specific Container Jobs**: Examples of scraping specific containers by their ID (e.g., `codebase-go-grpc-job`, `postgres-job`). 
   > **Note**: These container IDs are specific to a previous deployment. For a new deployment, you should either use the generic docker job or update these paths with the correct container IDs.

## Deployment Guide

### 1. Prerequisites
- A Docker network named `docker_stack` must exist.
  ```bash
  docker network create docker_stack
  ```
- A **Loki** service should be running and accessible via the `docker_stack` network at the URL specified in `promtail.yml`.

### 2. Permissions
Promtail needs read access to `/var/lib/docker/containers` and `/var/log`. The `docker-compose.yaml` mounts these as volumes. On some systems, you might need to ensure the user running Promtail (usually root inside the container) has permissions to read these host directories.

### 3. Start Promtail
Navigate to this directory and run:
```bash
docker compose up -d
```

## How it works
1. **Volume Mounts**: Promtail mounts the host's Docker container log directory (`/var/lib/docker/containers`) to the same path inside the container.
2. **Log Discovery**: It uses the `__path__` directive in `promtail.yml` to find `.log` files.
3. **Labeling**: It attaches labels (like `job: docker-job`) to the logs before sending them to Loki, allowing for easy filtering in Grafana.

