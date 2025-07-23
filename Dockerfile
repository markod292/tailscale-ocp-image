FROM checkmk/check-mk-raw:2.2.0-latest

RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list >/dev/null && \
    apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

