# Observability Stack (LGTM)

This directory contains a complete monitoring solution using the **LGTM** stack (Loki, Grafana, ...Promtail, Prometheus). It provides both **Metrics** (numbers/graphs) and **Logs** (searchable text) for your Docker environment.

## What is this?🦸

In your `docker-compose.yaml`, you have 4 services working together:

1.  **Prometheus** (The "Counter")
    *   **Role:** It collects **Metrics** (numbers).
    *   **How it works:** It constantly visits your apps (scrapes them) and asks "How much CPU are you using? How many requests?".
    *   **In your config:** Currently, it's just monitoring itself (`prometheus.yml`), but you will add your apps later.

2.  **Loki** (The "Log Archive")
    *   **Role:** It stores **Logs** (text).
    *   **Analogy:** Think of it like a database optimized for search text logs, specifically designed to work with Grafana. It's like "Prometheus but for logs".

3.  **Promtail** (The "Delivery Guy")
    *   **Role:** It reads log files and ships them to Loki.
    *   **How it works:** You've mounted `/var/lib/docker/containers` to it. Promtail reads the raw Docker log files from your host and pushes them to Loki.

4.  **Grafana** (The "TV Screen")
    *   **Role:** The Visualization Dashboard.
    *   **How it works:** It connects to **Prometheus** (to show graphs of CPU/Memory) and **Loki** (to show search logs). This is the only tool you actually look at as a human.



## 🚀 Quick Start

1.  **Start the stack:**
    ```bash
    docker-compose up -d
    ```

2.  **Access Grafana:**
    *   Open [http://localhost:3000](http://localhost:3000).
    *   Default login: `admin` / `admin`.

3.  **Connect Data Sources (First Time Only):**
    *   Go to **Configuration (Gear Icon)** -> **Data Sources**.
    *   **Add Prometheus:**
        *   Type: Prometheus
        *   URL: `http://prometheus:9090`
        *   Click "Save & Test".
    *   **Add Loki:**
        *   Type: Loki
        *   URL: `http://loki:3100`
        *   Click "Save & Test".

---

## 🛠️ Configuration Guide for New Services

When you add a new application (e.g., a Node.js API or Python script) to your system, here is how to monitor it.

### 1. Logs (Automatic) 📝
You typically **do not** need to change any configuration files for logs.

*   **How it works:** Promtail is configured to read standard Docker logs (`/var/lib/docker/containers`).
*   **Requirement:** Ensure your application writes logs to **Standard Output (stdout)** or **Standard Error (stderr)**.
    *   ✅ `console.log("User logged in")` (Node.js) -> **Works**
    *   ✅ `print("Processing request")` (Python) -> **Works**
    *   ❌ Writing to a file inside the container (e.g., `/var/log/app.log`) -> **Will NOT work** unless you mount that volume to Promtail.

### 2. Metrics (Requires Config) 📊
Prometheus needs to be explicitly told where to look for metrics.

**Step 1: Expose Metrics in your App**
Your app must have a `/metrics` endpoint (standard format).
*   *Node.js:* Use `prom-client`.
*   *Python:* Use `prometheus_client`.

**Step 2: Add Job to Prometheus**
1.  Open `observability/prometheus/prometheus.yml`.
2.  Add a new entry under `scrape_configs`.

```yaml
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["prometheus:9090"]

  # --- ADD YOUR NEW SERVICE HERE ---
  - job_name: "my-backend-app"
    metrics_path: "/metrics"      # Default is /metrics, optional if standard
    scrape_interval: 5s           # Optional, overrides global default
    static_configs:
      - targets: ["my-backend-container-name:8080"] # Container name and port
```

**Step 3: Apply Changes**
Restart the Prometheus container to load the new config:
```bash
docker-compose restart prometheus
```

---

## 🔍 Troubleshooting

*   **No Logs in Grafana?**
    *   Check if Promtail is running: `docker logs promtail`.
    *   Ensure your app container is actually printing logs: `docker logs <your-app-container>`.
    *   In Grafana Explore, make sure you selected "Loki" as the source.

*   **Target Down in Prometheus?**
    *   Go to `http://localhost:9090/targets`.
    *   If state is `DOWN`, Prometheus cannot reach your app. Check if they are on the same Docker network (`docker_stack` in this project).
