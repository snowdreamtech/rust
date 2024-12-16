FROM snowdreamtech/build-essential:alpine3.20

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Rust Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for Rust on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/rust" \
    org.opencontainers.image.base.name="snowdreamtech/rust:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/rust" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="1.83.0" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/rust"

ENV RUST_VERSION=1.83.0-r0 \ 
    CARGO_HOME=/usr/local/.cargo \
    PATH=$PATH:/usr/local/.cargo/bin

RUN apk add --no-cache \
    rust=${RUST_VERSION} \
    cargo=${RUST_VERSION} 

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]