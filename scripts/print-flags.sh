#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENV_FILE="$ROOT_DIR/infra/env/generated/runtime.env"
FLAGS_FILE="$ROOT_DIR/infra/env/generated/flags.env"

if [[ ! -f "$ENV_FILE" || ! -f "$FLAGS_FILE" ]]; then
  echo "[bezum] missing generated env, run ./infra/dev.sh up"
  exit 1
fi

echo "[bezum] flags"
grep '^FLAG_' "$FLAGS_FILE" | sort
echo
echo "[bezum] hints"
grep -E '^(HINT_|PUBLIC_FLAG_TEXT=)' "$ENV_FILE" | sort
