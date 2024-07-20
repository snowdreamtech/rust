FROM snowdreamtech/build-essential:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV RUST_VERSION=1.79.0-r1 \ 
    CARGO_HOME=$HOME/.cargo \
    PATH=$PATH:${CARGO_HOME}/bin

RUN apk add --no-cache rust@main=${RUST_VERSION} \
    cargo@main=${RUST_VERSION} 