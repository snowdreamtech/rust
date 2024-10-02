FROM snowdreamtech/debian:12.7.0

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Rust Image Based On Debian" \
    org.opencontainers.image.description="Docker Images for Rust on Debian. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/rust" \
    org.opencontainers.image.base.name="snowdreamtech/rust:debian" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/rust" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="1.63.0" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/rust"

ENV RUST_VERSION=1.63.0+dfsg1-2 \ 
    CARGO_VERSION=0.66.0+ds1-1 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    rust=${RUST_VERSION} \
    cargo=${CARGO_VERSION} \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]