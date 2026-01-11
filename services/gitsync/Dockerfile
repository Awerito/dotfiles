FROM alpine:3.19

RUN apk add --no-cache openssh-server rsync bash

# Create restricted user
RUN adduser -D -s /bin/bash gitsync && \
    passwd -u gitsync && \
    mkdir -p /home/gitsync/.ssh /home/gitsync/Git && \
    chown -R gitsync:gitsync /home/gitsync

# SSH config: only allow gitsync user, no password auth
RUN mkdir -p /etc/ssh && \
    ssh-keygen -A && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "AllowUsers gitsync" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding no" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config && \
    echo "AllowAgentForwarding no" >> /etc/ssh/sshd_config

# rrsync script for restricted rsync
COPY rrsync /usr/local/bin/rrsync
RUN chmod +x /usr/local/bin/rrsync

# Entrypoint to set up authorized_keys from env
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
