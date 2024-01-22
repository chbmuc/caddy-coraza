FROM caddy:2.7.6-builder AS builder

RUN xcaddy build \
    --with github.com/corazawaf/coraza-caddy@v2.0.0-rc.3

FROM caddy:2.7.6

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN mkdir /etc/coraza && \
    wget -qO /etc/coraza/coraza.conf \
         https://raw.githubusercontent.com/corazawaf/coraza/main/coraza.conf-recommended && \
    wget -qO /tmp/coreruleset.zip \
         https://github.com/coreruleset/coreruleset/archive/refs/heads/v4.0/dev.zip && \
    unzip -qd /etc/coraza /tmp/coreruleset.zip && \
    rm -f /tmp/coreruleset.zip && \
    mv /etc/coraza/coreruleset-4.0* /etc/coraza/coreruleset && \
    cp /etc/coraza/coreruleset/crs-setup.conf.example /etc/coraza/1_crs_setup.conf



