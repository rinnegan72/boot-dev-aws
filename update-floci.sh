#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker compose pull floci
docker compose up -d
docker image prune -f --filter "label=org.opencontainers.image.title=floci"