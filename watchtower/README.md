# Watchtower - Automatic Docker Updates

Watchtower is a service that monitors your running Docker containers and automatically updates them whenever a new image is pushed to the Docker Hub or your private registry.

## Configuration in this project

- **Interval**: Set to `60` seconds (checks for updates every 30s).
- **Cleanup**: Set to `--cleanup` (automatically removes old images after updating to save disk space).
- **Network**: Connects to the external `docker_stack` network.

## How to use

### 1. Prerequisite
Ensure the `docker_stack` network exists:
```bash
docker network create docker_stack
```

### 2. Start Watchtower

#### Mode A: Monitor ALL containers
To watch every container running on your system, simply run:
```bash
docker compose up -d
```

#### Mode B: Monitor SPECIFIC containers
If you only want to watch specific containers (e.g., just `nginx` and `postgres`), use the `WATCHTOWER_CONTAINER_NAME` environment variable:
```bash
WATCHTOWER_CONTAINER_NAME="nginx postgres" docker compose up -d
```

### 3. Check Logs
To see if Watchtower is finding updates, check the logs:
```bash
docker logs -f watchtower
```

## How it works
Watchtower communicates with the Docker daemon via the `/var/run/docker.sock` volume mount. It inspects the images of running containers and compares them to the versions available in the registry. If a version mismatch is detected, it pulls the new image and restarts the container with its original configuration.

