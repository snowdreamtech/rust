FROM snowdreamtech/debian:13.1.0

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

# Switch to the user
USER root

# Set the workdir
WORKDIR /root

# keep the docker container running
ARG DEBIAN_FRONTEND=noninteractive \
    KEEPALIVE=0 \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=C.UTF-8\
    UMASK=022 \
    DEBUG=false \
    PGID=0 \
    PUID=0  \
    USER=root \
    WORKDIR=/root 

ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND} \
    # keep the docker container running
    KEEPALIVE=${KEEPALIVE} \
    # The cap_net_bind_service capability in Linux allows a process to bind a socket to Internet domain privileged ports, 
    # which are port numbers less than 1024. 
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PGID=${PGID} \
    PUID=${PUID}  \
    USER=${USER} \
    WORKDIR=${WORKDIR} 

ENV RUST_VERSION=1.63.0+dfsg1-2 \ 
    CARGO_VERSION=0.66.0+ds1-1 

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

# Create a user with PUID and PGID
RUN if [ "${USER}" != "root" ]; then \
    addgroup --gid ${PGID} ${USER}; \
    adduser --home /home/${USER} --uid ${PUID} --gid ${PGID} --gecos ${USER} --shell /bin/bash --disabled-password ${USER}; \
    # sed -i "/%sudo/c ${USER} ALL=(ALL:ALL) NOPASSWD:ALL" /etc/sudoers; \
    fi

# Enable CAP_NET_BIND_SERVICE
# RUN if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then \
#     # setcap 'cap_net_bind_service=+ep' `which nginx`; \
#     fi

COPY entrypoint.d /usr/local/bin/entrypoint.d

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

ENTRYPOINT ["docker-entrypoint.sh"]