# Run Setup with Docker Compose

To run the setup using **Docker Compose**, follow the steps below:

## Steps

1. **Create network**  
   Create a Docker network to allow services to communicate with each other:
   ```bash
   docker network create docker_stack
   ```
2. **Run docker compose for docker stack**  
   Start all services in the background:
   ```bash
   docker compose up -d
   ```
3. **Run docker compose for portainer**  
   To manage container, the same docker-desktop ui:
   ```bash
   cd ./portainer
   docker compose up -d
   ```
   Then create username & password