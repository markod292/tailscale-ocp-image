# Stage 1: install tailscale on Debian
FROM debian:bullseye as tailscale

RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list >/dev/null && \
    apt-get update && \
    apt-get install -y tailscale

# Stage 2: final image with Checkmk + Tailscale
FROM checkmk/check-mk-raw:2.2.0-latest

COPY --from=tailscale /usr/bin/tailscale /usr/bin/tailscale
COPY --from=tailscale /usr/sbin/tailscaled /usr/sbin/tailscaled

COPY main/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
