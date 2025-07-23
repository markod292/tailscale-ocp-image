#!/bin/bash

set -e

# Start Tailscale
mkdir -p /var/run/tailscale
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
sleep 3

tailscale up --authkey="${TAILSCALE_AUTH_KEY}" || {
  echo "Tailscale failed to start"; exit 1;
}

# Start Checkmk
omd start

# Keep container running
tail -f /omd/sites/*/var/log/nagios.log
