# Stage 1: install Tailscale
FROM debian:bullseye AS tailscale

RUN apt-get update && apt-get install -y curl gnupg2 && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list >/dev/null && \
    apt-get update && apt-get install -y tailscale

# Stage 2: Checkmk base image
FROM checkmk/check-mk-raw:2.2.0-latest

# Copy Tailscale from Debian stage
COPY --from=tailscale /usr/bin/tailscale /usr/bin/tailscale
COPY --from=tailscale /usr/sbin/tailscaled /usr/sbin/tailscaled
COPY --from=tailscale /var/lib/tailscale /var/lib/tailscale
COPY --from=tailscale /etc/default/tailscaled /etc/default/tailscaled

# Add your entrypoint script
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
