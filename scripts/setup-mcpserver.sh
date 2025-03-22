#!/bin/bash
# Configure local SSH environment for connecting to an MCP server
# Usage: ./setup-mcpserver.sh [server_ip] [server_name] [server_domain] [server_user]

set -e

# Default configuration - should be overridden with environment variables or arguments
DEFAULT_SERVER_IP="your-server-ip"
DEFAULT_SERVER_NAME="mcpserver"
DEFAULT_SERVER_DOMAIN="example.com"
DEFAULT_SERVER_USER="admin"
DEFAULT_SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# Accept parameters from command line or use defaults
SERVER_IP="${1:-${MCP_SERVER_IP:-$DEFAULT_SERVER_IP}}"
SERVER_NAME="${2:-${MCP_SERVER_NAME:-$DEFAULT_SERVER_NAME}}"
SERVER_DOMAIN="${3:-${MCP_SERVER_DOMAIN:-$DEFAULT_SERVER_DOMAIN}}"
SERVER_USER="${4:-${MCP_SERVER_USER:-$DEFAULT_SERVER_USER}}"
SSH_KEY_PATH="${MCP_SSH_KEY_PATH:-$DEFAULT_SSH_KEY_PATH}"

SERVER_HOSTNAME="${SERVER_NAME}.${SERVER_DOMAIN}"

# Prompt for missing values
if [ "$SERVER_IP" = "$DEFAULT_SERVER_IP" ]; then
  read -p "Enter server IP address: " SERVER_IP
fi

if [ "$SERVER_NAME" = "$DEFAULT_SERVER_NAME" ]; then
  read -p "Enter server name (e.g., mcp001): " SERVER_NAME
fi

if [ "$SERVER_DOMAIN" = "$DEFAULT_SERVER_DOMAIN" ]; then
  read -p "Enter server domain (e.g., example.com): " SERVER_DOMAIN
  SERVER_HOSTNAME="${SERVER_NAME}.${SERVER_DOMAIN}"
fi

if [ "$SERVER_USER" = "$DEFAULT_SERVER_USER" ]; then
  read -p "Enter server user (e.g., root): " SERVER_USER
fi

echo "🔧 Setting up SSH configuration for $SERVER_HOSTNAME ($SERVER_IP)..."

# Ensure SSH directory exists
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add SSH config entry if it doesn't exist
if ! grep -q "Host $SERVER_NAME" ~/.ssh/config 2>/dev/null; then
  echo "➕ Adding SSH config entry for $SERVER_NAME..."
  cat >> ~/.ssh/config << EOF
# MCP Server Configuration
Host $SERVER_NAME
    HostName $SERVER_HOSTNAME
    User $SERVER_USER
    IdentityFile $SSH_KEY_PATH
    ForwardAgent yes

EOF
  echo "✅ SSH config entry added."
else
  echo "✅ SSH config entry already exists."
fi

# Check if we need to generate SSH key
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "🔑 Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""
  echo "✅ SSH key generated."
else
  echo "✅ SSH key already exists."
fi

# Instructions for DNS and SSH key deployment
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Add this DNS A record to your domain:"
echo "   $SERVER_NAME.$SERVER_DOMAIN.  IN  A  $SERVER_IP"
echo ""
echo "2. To copy your SSH key to the server, run:"
echo "   ssh-copy-id -i $SSH_KEY_PATH $SERVER_USER@$SERVER_IP"
echo ""
echo "3. Once configured, you can connect with:"
echo "   ssh $SERVER_NAME"
echo ""
echo "4. If you want to use port forwarding for services, use:"
echo "   ssh -L 8080:localhost:8080 $SERVER_NAME"
echo "   (This forwards local port 8080 to the server's port 8080)"
echo ""
echo "✅ Setup complete!"
