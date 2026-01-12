#!/bin/bash
set -e

# Generate SSH host keys if they don't exist (persisted in volume)
SSH_KEY_DIR="/etc/ssh/keys"
mkdir -p "$SSH_KEY_DIR"
if [ ! -f "$SSH_KEY_DIR/ssh_host_ed25519_key" ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -t ed25519 -f "$SSH_KEY_DIR/ssh_host_ed25519_key" -N ""
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_DIR/ssh_host_rsa_key" -N ""
fi
# Symlink keys to expected location
ln -sf "$SSH_KEY_DIR/ssh_host_ed25519_key" /etc/ssh/ssh_host_ed25519_key
ln -sf "$SSH_KEY_DIR/ssh_host_ed25519_key.pub" /etc/ssh/ssh_host_ed25519_key.pub
ln -sf "$SSH_KEY_DIR/ssh_host_rsa_key" /etc/ssh/ssh_host_rsa_key
ln -sf "$SSH_KEY_DIR/ssh_host_rsa_key.pub" /etc/ssh/ssh_host_rsa_key.pub

AUTH_KEYS="/home/gitsync/.ssh/authorized_keys"

# Clear and recreate authorized_keys
> "$AUTH_KEYS"

# Add each SSH_KEY_* environment variable as an authorized key
# Restricted to rrsync (only rsync allowed, only to /home/gitsync/Git)
for var in $(env | grep '^SSH_KEY_' | cut -d= -f1); do
    key="${!var}"
    if [ -n "$key" ]; then
        echo "command=\"/usr/local/bin/rrsync /home/gitsync/Git\",restrict $key" >> "$AUTH_KEYS"
        echo "Added key from $var"
    fi
done

# Set permissions
chown gitsync:gitsync "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

echo "Starting SSH server..."
exec /usr/sbin/sshd -D -e
