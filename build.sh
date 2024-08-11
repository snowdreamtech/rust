#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/rust

GITHUB_PROJECT=ghcr.io/snowdreamtech/rust

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
    -t ${DOCKER_HUB_PROJECT}:build-essential-latest \
    -t ${DOCKER_HUB_PROJECT}:build-essential-1.80.1 \
    -t ${DOCKER_HUB_PROJECT}:build-essential-1.80 \
    -t ${DOCKER_HUB_PROJECT}:build-essential-1 \
    -t ${GITHUB_PROJECT}:build-essential-latest \
    -t ${GITHUB_PROJECT}:build-essential-1.80.1 \
    -t ${GITHUB_PROJECT}:build-essential-1.80 \
    -t ${GITHUB_PROJECT}:build-essential-1 \
    . \
    --push
