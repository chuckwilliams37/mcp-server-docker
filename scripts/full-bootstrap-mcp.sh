#!full-bootstrap-mcp.sh

#!/bin/bash
set -e

REPO_URL="https://github.com/chuckwilliams37/mcp-server-docker.git"
REPO_DIR="mcp-server-docker"

echo "🚀 Updating system and installing essentials..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget vim zsh ufw fail2ban net-tools unzip \
                    ca-certificates gnupg lsb-release build-essential

echo "🐚 Installing Oh-My-Zsh with 'jonathan' theme..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="jonathan"/g' "$HOME/.zshrc"
    echo "export TERM=xterm-256color" >> "$HOME/.zshrc"
fi

echo "🐳 Installing Docker and Compose..."
# Docker GPG and repo
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker engine & plugin-based compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "🔥 Enabling UFW firewall and Fail2Ban..."
sudo ufw allow OpenSSH
sudo ufw allow 8080/tcp
sudo ufw --force enable
sudo systemctl enable --now fail2ban

echo "📁 Cloning MCP repo..."
cd "$HOME"
git clone "$REPO_URL"
cd "$REPO_DIR"

echo "🔧 Building and launching containers..."
docker compose build
docker compose up -d

echo "🧠 Creating systemd service for reboot resilience..."
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

sudo systemctl daemon-reexec
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "✅ MCP setup complete. Server will auto-start on reboot."
echo "💡 You may need to reboot or log out and back in for Docker group to take effect."

