#!/usr/bin/env bash
set -euo pipefail

. "$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd
)/infra/scripts/common.sh"

"$ROOT_DIR/infra/scripts/generate-flags.sh"
compose_cmd build --no-cache
compose_cmd up -d
"$ROOT_DIR/infra/scripts/print-flags.sh"
