#!/bin/bash

# === CONFIG ===
IP="192.0.2.123"  # Sample IP for documentation
HOST_ALIAS="mcp001"
FQDN="mcp001.example.com"
SSH_USER="root"
KEY_PATH="$HOME/.ssh/id_rsa.pub"

# === CHECK SSH KEY ===
if [ ! -f "$KEY_PATH" ]; then
    echo "No SSH public key found at $KEY_PATH. Generating one..."
    ssh-keygen -t rsa -b 4096 -f "${KEY_PATH%.*}" -N ""
fi

# === PUSH SSH KEY ===
echo "Pushing SSH key to $SSH_USER@$IP..."
ssh-copy-id -i "$KEY_PATH" "$SSH_USER@$IP"

# === ADD SSH CONFIG ALIAS ===
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "$HOST_ALIAS" "$SSH_CONFIG" 2>/dev/null; then
    echo "Adding SSH config alias for $HOST_ALIAS..."
    cat <<EOF >> "$SSH_CONFIG"

# MCP Server Shortcut
Host $HOST_ALIAS
    HostName $IP
    User $SSH_USER
    IdentityFile ${KEY_PATH%.*}
EOF
    echo "Alias '$HOST_ALIAS' added to SSH config."
else
    echo "Alias '$HOST_ALIAS' already exists in SSH config."
fi

# === OUTPUT DNS A RECORD ===
echo -e "\n📡 Add the following A record to your DNS provider:"
echo "$FQDN.    IN    A    $IP"

# === TEST CONNECTION ===
echo -e "\n🔗 Testing connection: ssh $HOST_ALIAS\n"
ssh "$HOST_ALIAS"
