FROM snowdreamtech/build-essential:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

ENV RUST_VERSION=1.80.0-r0 \ 
    CARGO_HOME=/usr/local/.cargo \
    PATH=$PATH:/usr/local/.cargo/bin

RUN apk add --no-cache rust@main=${RUST_VERSION} \
    cargo@main=${RUST_VERSION} 