# Rust

![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/rust)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/rust/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/rust)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/rust)

Docker Image packaging for Rust.

## Overview

This project provides multi-architecture Docker images for Rust, built on top of various base distributions (Debian, Alpine, Rocky). It features a flexible entrypoint system and supports custom user creation at runtime or build time.

## Quick Start

```bash
# Pull and run the default Debian variant
docker pull snowdreamtech/rust:debian
docker run -d --name=rust -e TZ=Asia/Shanghai snowdreamtech/rust:debian

# Or using docker-compose
docker-compose up -d
```

## Distribution Variants

### Debian (Default)

The recommended variant for most use cases, providing broad compatibility and rich package availability.

```bash
docker run -d \
  --name=rust \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/rust:debian
```

**Supported Architectures**: i386, amd64, arm32v5, arm32v7, arm64, mips64le, ppc64le, s390x

**Base Image**: `snowdreamtech/debian:13.5.0`

### Alpine

A lightweight variant optimized for minimal image size and fast startup times.

```bash
docker run -d \
  --name=rust \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/rust:alpine
```

**Supported Architectures**: i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x

**Base Image**: `snowdreamtech/alpine:3.24.0`

### Rocky

An enterprise-grade variant based on Rocky Linux, suitable for production environments requiring RHEL compatibility.

```bash
docker run -d \
  --name=rust \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/rust:rocky
```

**Supported Architectures**: i386, amd64, arm32v5, arm32v7, arm64, mips64le, ppc64le, s390x

**Base Image**: `snowdreamtech/rocky:10.2.0`

## Build Instructions

### Single Architecture Build

```bash
# Build Debian variant
docker build -t snowdreamtech/rust:debian ./docker/debian/

# Build Alpine variant
docker build -t snowdreamtech/rust:alpine ./docker/alpine/

# Build Rocky variant
docker build -t snowdreamtech/rust:rocky ./docker/rocky/
```

### Multi-Architecture Build

Use `docker buildx` to build images for multiple architectures:

```bash
# Create and use buildx builder
docker buildx create --use --name build --node build --driver-opt network=host

# Build Debian for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v5,linux/arm/v7,linux/arm64,linux/mips64le,linux/ppc64le,linux/s390x \
  -t snowdreamtech/rust:debian \
  ./docker/debian/ \
  --push

# Build Alpine for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/ppc64le,linux/riscv64,linux/s390x \
  -t snowdreamtech/rust:alpine \
  ./docker/alpine/ \
  --push

# Build Rocky for multiple architectures
docker buildx build \
  --platform=linux/386,linux/amd64,linux/arm/v5,linux/arm/v7,linux/arm64,linux/mips64le,linux/ppc64le,linux/s390x \
  -t snowdreamtech/rust:rocky \
  ./docker/rocky/ \
  --push
```

## Environment Variables

All variants support the following environment variables for runtime configuration:

| Variable | Default Value | Description |
|----------|---------|-------------|
| `KEEPALIVE` | `0` | Keep container running (1=enable, 0=disable) |
| `CAP_NET_BIND_SERVICE` | `0` | Enable binding to privileged ports (<1024) |
| `LANG` | `C.UTF-8` | Locale for UTF-8 character support |
| `UMASK` | `022` | Default file creation mask |
| `DEBUG` | `false` | Enable debug output in entrypoint script |
| `PGID` | `0` | Primary group ID for custom user creation |
| `PUID` | `0` | User ID for custom user creation |
| `USER` | `root` | Username for custom user creation |
| `WORKDIR` | `/root` | Working directory path |
| `TZ` | - | Timezone (e.g., `Asia/Shanghai`, `America/New_York`) |

**Debian Specific**:

| Variable | Default Value | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | `noninteractive` | Debian package installation mode |

### Custom User Creation

Create a non-root user with specific UID/GID at build time:

```bash
docker build \
  --build-arg PUID=1000 \
  --build-arg PGID=1000 \
  --build-arg USER=appuser \
  -t snowdreamtech/rust:debian-custom \
  ./docker/debian/
```

Or at runtime (requires rebuilding the image):

```bash
docker run -d \
  --name=rust \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=appuser \
  snowdreamtech/rust:debian
```

**Note**: The user is only created if `PUID≠0`, `PGID≠0`, and `USER≠root`.

## Docker Compose Example

### Simple Configuration

```yaml
services:
  rust:
    image: snowdreamtech/rust:debian
    container_name: rust
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

### Advanced Configuration

```yaml
services:
  rust:
    image: snowdreamtech/rust:debian
    container_name: rust
    environment:
      - TZ=Asia/Shanghai
      - DEBUG=true
      - KEEPALIVE=1
    volumes:
      - /path/to/data:/data
    restart: unless-stopped
```

## Semantic Version Tags

Images follow semantic versioning with the format: `{major}.{minor}.{patch}-{variant}`

Examples:

- `snowdreamtech/rust:1.85.0-debian`
- `snowdreamtech/rust:1.96.0-alpine`
- `snowdreamtech/rust:1.92.0-rocky`

This format allows:

- **Full version pinning**: `1.85.0-debian` (Exact version)
- **Variant latest tag**: `latest-debian` (Tracks the latest version for Debian)
- **Global latest tag**: `latest` (Tracks the latest version, defaults to Debian)

## Architecture Support

Each distribution variant supports multiple CPU architectures, enabling deployment across diverse hardware platforms:

| Variant | Architectures |
|---------|---------------|
| **Debian** | i386, amd64, arm32v5, arm32v7, arm64, mips64le, ppc64le, s390x |
| **Alpine** | i386, amd64, arm32v6, arm32v7, arm64, ppc64le, riscv64, s390x |
| **Rocky** | i386, amd64, arm32v5, arm32v7, arm64, mips64le, ppc64le, s390x |

Docker automatically selects the appropriate architecture for your platform when pulling the image.

## Entrypoint System

The base template includes a flexible entrypoint system that executes custom initialization scripts before starting the application.

### How it works

1. The `docker-entrypoint.sh` script runs when the container starts.
2. It executes all executable scripts in `/usr/local/bin/entrypoint.d/` in lexicographical order.
3. Each script receives the container's command-line arguments.
4. If any script fails, the container stops (fail-fast behavior).

### Adding Custom Initialization

Create custom initialization scripts in your derived Dockerfile:

```dockerfile
FROM snowdreamtech/rust:debian

# Add your custom initialization script
COPY my-init.sh /usr/local/bin/entrypoint.d/20-my-init.sh
RUN chmod +x /usr/local/bin/entrypoint.d/20-my-init.sh

# Your application setup
COPY app /app
CMD ["/app/start.sh"]
```

### Debug Mode

Enable debug output to troubleshoot entrypoint execution:

```bash
docker run -e DEBUG=true snowdreamtech/rust:debian
```

Example output:

```
→ [ENTRYPOINT] Executing all scripts in /usr/local/bin/entrypoint.d
→ Running /usr/local/bin/entrypoint.d/10-base-init.sh
→ [ENTRYPOINT] Done.
```

## Development

### Prerequisites

- Docker (>= 20.10)
- Docker Buildx plugin

### Local Build

```bash
# Build all variants
make build

# Build specific variants
docker build -t rust:debian ./docker/debian/
docker build -t rust:alpine ./docker/alpine/
docker build -t rust:rocky ./docker/rocky/
```

### Testing

```bash
# Test default configuration
docker run --rm rust:debian id

# Test custom user creation
docker build --build-arg PUID=1000 --build-arg PGID=1000 --build-arg USER=testuser -t rust:debian-test ./docker/debian/
docker run --rm rust:debian-test id
# Expected output: uid=1000(testuser) gid=1000(testuser)

# Test DEBUG mode
docker run --rm -e DEBUG=true rust:debian
```

## Reference

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
2. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
3. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
4. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
5. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
6. [docker/buildx](https://github.com/docker/buildx)

## Contact (Note: rust)

* Email: <sn0wdr1am@qq.com>
* QQ: 3217680847
* QQ Group: 949022145
* WeChat: sn0wdr1am

## License

MIT
