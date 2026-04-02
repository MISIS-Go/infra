#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FLAGS_FILE="$ROOT_DIR/infra/env/generated/flags.env"

mkdir -p "$(dirname "$FLAGS_FILE")"

random_hex() {
  od -An -N16 -tx1 /dev/urandom | tr -d ' \n'
}

random_flag() {
  printf 'flag{%s}\n' "$(random_hex)"
}

cat >"$FLAGS_FILE" <<EOF
FLAG_AUTH_ADMIN=$(random_flag)
FLAG_NOTES_XSS=$(random_flag)
FLAG_CHAT_HIDDEN=$(random_flag)
FLAG_INTERNAL_MEMORY=$(random_flag)
FLAG_BANK_SSRF=$(random_flag)
FLAG_CHAIN_FINAL=$(random_flag)
EOF

echo "[bezum] refreshed $FLAGS_FILE"
"$ROOT_DIR/infra/scripts/print-flags.sh"
