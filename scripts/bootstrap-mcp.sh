#!/bin/bash

set -e

REPO_URL="https://github.com/chuckwilliams37/mcp-server-docker.git"
REPO_DIR="mcp-server-docker"

echo "🚀 Updating and installing essentials..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl ca-certificates lsb-release gnupg unzip ufw

echo "🐳 Installing Docker..."
# Add Docker's official GPG key and repo
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker as a service
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "🔁 Logging out required to activate Docker group permissions."

echo "📁 Cloning repo..."
git clone "$REPO_URL"
cd "$REPO_DIR"

echo "🔧 Building Docker containers..."
docker compose build

echo "🚀 Starting containers..."
docker compose up -d

echo "🧠 Writing systemd service for auto-start..."
SERVICE_NAME="mcp-docker"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=MCP Docker Compose App
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=/home/$USER/$REPO_DIR
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
Restart=always
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

echo "📡 Enabling and starting $SERVICE_NAME service..."
sudo systemctl daemon-reexec
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "✅ Setup complete. Your MCP server is live and will restart on reboot."
