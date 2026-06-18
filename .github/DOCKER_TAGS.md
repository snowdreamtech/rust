# Docker Image Tags Reference

This document describes the Docker image tagging strategy for the Rust project.

## Tag Naming Convention

All images use the format: `snowdreamtech/rust:TAG`

Where `TAG` follows these patterns:

- **Variant-specific tags**: `TAG-variant` (e.g., `nightly-alpine`, `1.96.0-alpine`)
- **Default tags** (Debian only): `TAG` (e.g., `nightly`, `latest`, `1.85.0`)

## Supported Registries

All tags are pushed to three registries:

- **DockerHub**: `snowdreamtech/rust:TAG`
- **GitHub Container Registry**: `ghcr.io/snowdreamtech/rust:TAG`
- **Quay.io**: `quay.io/snowdreamtech/rust:TAG`

## Tag Scenarios

### 1. Branch Builds (dev/main)

#### Push to `dev` branch

```bash
git push origin dev
```

**Generated tags:**

```
snowdreamtech/rust:dev-alpine
snowdreamtech/rust:dev-debian
snowdreamtech/rust:dev              # ← Debian (default)
snowdreamtech/rust:dev-rocky
```

#### Push to `main` branch

```bash
git push origin main
```

**Generated tags:**

```
snowdreamtech/rust:main-alpine
snowdreamtech/rust:latest-alpine
snowdreamtech/rust:main-debian
snowdreamtech/rust:latest-debian
snowdreamtech/rust:main             # ← Debian (default)
snowdreamtech/rust:latest           # ← Debian (default)
snowdreamtech/rust:main-rocky
snowdreamtech/rust:latest-rocky
```

---

### 2. Release Tags (Semantic Versioning)

#### Alpine Release

```bash
git tag alpine-v1.96.0
git push origin alpine-v1.96.0
```

**Generated tags:**

```
snowdreamtech/rust:1.96.0-alpine
snowdreamtech/rust:latest-alpine
```

#### Debian Release

```bash
git tag debian-v1.85.0
git push origin debian-v1.85.0
```

**Generated tags:**

```
snowdreamtech/rust:1.85.0-debian
snowdreamtech/rust:latest-debian
snowdreamtech/rust:1.85.0           # ← Debian (default)
snowdreamtech/rust:latest           # ← Debian (default)
```

#### Rocky Release

```bash
git tag rocky-v1.92.0
git push origin rocky-v1.92.0
```

**Generated tags:**

```
snowdreamtech/rust:1.92.0-rocky
snowdreamtech/rust:latest-rocky
```

---

### 3. Nightly Builds (Scheduled)

**Trigger:** Automatically every day at 17:00 UTC

**Generated tags:**

```
# Alpine
snowdreamtech/rust:nightly-alpine
snowdreamtech/rust:20260427-alpine

# Debian (with default tags)
snowdreamtech/rust:nightly-debian
snowdreamtech/rust:20260427-debian
snowdreamtech/rust:nightly          # ← Debian (default)
snowdreamtech/rust:20260427         # ← Debian (default)

# Rocky
snowdreamtech/rust:nightly-rocky
snowdreamtech/rust:20260427-rocky
```

---

## Tag Priority

Tags are generated with the following priority (higher number = higher priority):

| Priority | Type | Example Tags | Trigger |
|----------|------|--------------|---------|
| 1000 | Nightly | `nightly`, `nightly-alpine` | Schedule |
| 900 | Date | `20260427`, `20260427-alpine` | Schedule |
| 800 | Version | `1.96.0-alpine`, `1.85.0` | Tag push |
| 600 | Branch | `dev-alpine`, `main-debian` | Branch push |
| 200 | Latest | `latest`, `latest-alpine` | Main/Tag |

---

## Default Variant (Debian)

Debian is designated as the **default variant** (`is_latest: true`), which means:

✅ **Debian gets BOTH suffixed AND unsuffixed tags:**

```
snowdreamtech/rust:nightly-debian   # Variant-specific
snowdreamtech/rust:nightly          # Default (no suffix)

snowdreamtech/rust:1.85.0-debian    # Variant-specific
snowdreamtech/rust:1.85.0           # Default (no suffix)

snowdreamtech/rust:latest-debian    # Variant-specific
snowdreamtech/rust:latest           # Default (no suffix)
```

❌ **Alpine and Rocky get ONLY suffixed tags:**

```
snowdreamtech/rust:nightly-alpine   # Variant-specific only
snowdreamtech/rust:nightly-rocky    # Variant-specific only
```

---

## Usage Examples

### Pull the latest Debian image (default)

```bash
docker pull snowdreamtech/rust:latest
# or
docker pull snowdreamtech/rust:latest-debian
```

### Pull the latest Alpine image

```bash
docker pull snowdreamtech/rust:latest-alpine
```

### Pull the latest Rocky image

```bash
docker pull snowdreamtech/rust:latest-rocky
```

### Pull a specific version

```bash
# Alpine 1.96.0
docker pull snowdreamtech/rust:1.96.0-alpine

# Debian 1.85.0 (two ways)
docker pull snowdreamtech/rust:1.85.0-debian
docker pull snowdreamtech/rust:1.85.0

# Rocky 1.92.0
docker pull snowdreamtech/rust:1.92.0-rocky
```

### Pull nightly builds

```bash
# Alpine nightly
docker pull snowdreamtech/rust:nightly-alpine

# Debian nightly (two ways)
docker pull snowdreamtech/rust:nightly-debian
docker pull snowdreamtech/rust:nightly

# Rocky nightly
docker pull snowdreamtech/rust:nightly-rocky
```

---

## Tag Lifecycle

### Development Flow

```
1. Push to dev → rust:dev-alpine, rust:dev-debian, rust:dev, rust:dev-rocky
2. Push to main → rust:main-alpine, rust:latest-alpine, rust:main-debian, rust:latest-debian, rust:main, rust:latest, rust:main-rocky, rust:latest-rocky
3. Create tag → rust:VERSION-variant, rust:latest-variant (+ unsuffixed for Debian)
```

### Release Flow (with Release Please)

```
1. Merge PR to main → Release Please creates release PR
2. Merge release PR → Release Please creates tags (alpine-vX.Y.Z, debian-vX.Y.Z, rocky-vX.Y.Z)
3. Tag push triggers build → Images published with version tags
```

---

## Matrix Configuration

The workflow uses a matrix strategy with three variants:

```yaml
matrix:
  include:
    - variant: alpine
      version: "1.96.0"
      is_latest: false

    - variant: debian
      version: "1.85.0"
      is_latest: true    # ← Default variant

    - variant: rocky
      version: "1.92.0"
      is_latest: false
```

Only the variant with `is_latest: true` receives unsuffixed tags.

---

## Metadata Action Configuration

The key configuration that enables this tagging strategy:

```yaml
images: |
  name=snowdreamtech/rust,enable=true
  name=ghcr.io/snowdreamtech/rust,enable=true
  name=quay.io/snowdreamtech/rust,enable=true
flavor: |
  latest=false
  prefix=
  suffix=-${{ matrix.variant }}  # ← Adds variant suffix to all tags
```

For Debian (is_latest), additional rules generate unsuffixed tags:

```yaml
type=raw,enable=${{ matrix.is_latest }},priority=1000,prefix=,suffix=,pattern=nightly
```

This creates both `nightly-debian` (from flavor suffix) and `nightly` (from this rule).
