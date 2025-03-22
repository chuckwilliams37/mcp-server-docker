# 🚀 MCP Server with Docker, Redis, and TimescaleDB

This repository sets up a **Model Context Protocol (MCP) Server** using Docker, integrating Redis and TimescaleDB for efficient data management.

## 🛠️ Features

- **FastAPI**: Serves as the web framework for the MCP server.
- **Redis**: Provides caching mechanisms.
- **TimescaleDB**: A time-series database built on PostgreSQL.
- **Docker Compose**: Orchestrates multi-container Docker applications.
- **Environment Variables**: Configurable via `.env` file.
- **Systemd Service**: Ensures the server auto-starts on reboot.

## 📋 Prerequisites

- **Docker** and **Docker Compose** installed on your system.
- **Git** for version control.
- **Zsh** with **Oh-My-Zsh** (optional, for enhanced shell experience).

## 📂 Repository Structure

```plaintext
mcp-server-docker/
├── app/
│   └── app.py
├── .env.example
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── scripts/
│   ├── bootstrap-mcp.sh
│   ├── full-bootstrap-mcp.sh
│   ├── init-repo.sh
│   ├── push-repo.sh
│   └── setup-mcpserver.sh
└── README.md
```

## 🚀 Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/chuckwilliams37/mcp-server-docker.git
   cd mcp-server-docker
   ```

2. **Configure Environment Variables**:

   ```bash
   cp .env.example .env
   ```

   Modify `.env` as needed.

3. **Build and Start the Containers**:

   ```bash
   docker compose build
   docker compose up -d
   ```

4. **Access the MCP Server**:

   ```bash
   http://localhost:8080
   ```

## 🔄 Auto-Restart on Reboot

Create a systemd service to keep your app alive:

```bash
sudo nano /etc/systemd/system/mcp-docker.service
```

Paste:

```ini
[Unit]
Description=MCP Docker Compose App
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=/home/youruser/mcp-server-docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
Restart=always
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

Enable it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable mcp-docker
sudo systemctl start mcp-docker
```

---

## 🧪 Scripts

The `scripts/` directory contains utility scripts to automate infrastructure tasks.

---

### 🛠️ `scripts/full-bootstrap-mcp.sh`

💡 **Use this on a fresh Ubuntu VM** to fully prepare it for MCP deployment. It:

- Installs system dependencies (Docker, Git, Zsh, UFW, Fail2Ban, etc.)
- Sets up `oh-my-zsh` with the `jonathan` theme
- Configures Remote Desktop with XFCE + XRDP
- Clones the MCP repo
- Builds and launches the app with `docker compose`
- Adds a systemd service to relaunch containers on reboot

```bash
chmod +x scripts/full-bootstrap-mcp.sh
./scripts/full-bootstrap-mcp.sh
```

---

### 📜 `scripts/init-repo.sh`

Initializes a new local Git repository and commits the current directory:

```bash
chmod +x scripts/init-repo.sh
./scripts/init-repo.sh
```

---

### 📤 `scripts/push-repo.sh`

Pushes your local repo to a remote (update URL first):

```bash
chmod +x scripts/push-repo.sh
./scripts/push-repo.sh
```

---

### 🧠 `scripts/setup-mcpserver.sh`

Configures your local SSH environment to access a remote MCP server:

- Pushes your public key
- Adds an SSH alias
- Prints a sample A-record

```bash
chmod +x scripts/setup-mcpserver.sh
./scripts/setup-mcpserver.sh
```

---

> ⚠️ Edit placeholder values (e.g., IPs, usernames, repo URLs) before executing.

---

## 🤝 Contributions

Feel free to fork this repository, submit issues, or create pull requests.

## 📄 License

This project is licensed under the MIT License.
