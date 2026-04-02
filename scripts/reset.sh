#!/usr/bin/env bash
set -euo pipefail

. "$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
)/infra/scripts/common.sh"

compose_cmd down -v || true
rm -f "$ENV_FILE"
rm -f "$ROOT_DIR/infra/env/generated/flags.env"
"$ROOT_DIR/infra/scripts/generate-flags.sh"
compose_cmd up -d --build
"$ROOT_DIR/infra/scripts/print-flags.sh"
