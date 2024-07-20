FROM snowdreamtech/build-essential:3.20.0

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

RUN apk add --no-cache rust=1.78.0-r0 \
    cargo 