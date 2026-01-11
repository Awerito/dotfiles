#!/bin/bash
set -e

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
