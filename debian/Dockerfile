FROM snowdreamtech/debian:12.8.0

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

ARG GID=1000 \
    UID=1000  \
    USER=rust \
    WORKDIR=/home/rust

# Create a user with UID and GID
RUN set -eux \
    &&if [ "${USER}" != "root" ]; then \
    addgroup --gid ${GID} ${USER}; \
    adduser --home /home/${USER} --uid ${UID} --gid ${GID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    rustc=${RUST_VERSION} \
    libstd-rust-dev=${RUST_VERSION} \
    cargo=${CARGO_VERSION} \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Switch to the user
USER ${USER}

# Set the workdir
WORKDIR ${WORKDIR}

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]