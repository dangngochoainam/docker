# Run Setup with Docker Compose

To run the setup using **Docker Compose**, follow the steps below:

## Steps

1. **Create network**  
   Create a Docker network to allow services to communicate with each other:
   ```bash
   docker network create docker_stack
   ```
2. **Run docker compose**  
   Start all services in the background:
   ```bash
   docker compose up -d
   ```
