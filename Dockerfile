FROM tailscale/k8s-operator:v1.70.0

RUN mkdir /.config && \
    chgrp -R 0 /.config && \
    chmod -R g=u /.config

USER 1001
