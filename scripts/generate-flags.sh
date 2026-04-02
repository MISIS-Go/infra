#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="$ROOT_DIR/infra/env/generated"
OUT_FILE="$OUT_DIR/runtime.env"
FLAGS_FILE="$OUT_DIR/flags.env"

. "$ROOT_DIR/infra/scripts/common-env.sh"

mkdir -p "$OUT_DIR"

random_hex() {
  od -An -N16 -tx1 /dev/urandom | tr -d ' \n'
}

random_flag() {
  printf 'flag{%s}\n' "$(random_hex)"
}

if [[ -f "$OUT_FILE" ]]; then
  tmp_file="$(mktemp)"
  grep -v '^FLAG_' "$OUT_FILE" >"$tmp_file" || true
  mv "$tmp_file" "$OUT_FILE"
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    key="${line%%=*}"
    if ! grep -q "^${key}=" "$OUT_FILE"; then
      echo "$line" >>"$OUT_FILE"
      echo "[bezum] appended missing env key: $key"
    fi
  done < <(required_env_lines)
  if [[ ! -f "$FLAGS_FILE" ]]; then
    cat >"$FLAGS_FILE" <<EOF
FLAG_AUTH_ADMIN=$(random_flag)
FLAG_NOTES_XSS=$(random_flag)
FLAG_CHAT_HIDDEN=$(random_flag)
FLAG_INTERNAL_MEMORY=$(random_flag)
FLAG_BANK_SSRF=$(random_flag)
FLAG_CHAIN_FINAL=$(random_flag)
EOF
    echo "[bezum] generated missing $FLAGS_FILE"
  fi
  echo "[bezum] generated env already exists: $OUT_FILE"
  exit 0
fi

cat >"$OUT_FILE" <<EOF
JWT_SECRET=$(random_hex)
AUTH_COOKIE=bezum_jwt
$(required_env_lines)
EOF

cat >"$FLAGS_FILE" <<EOF
FLAG_AUTH_ADMIN=$(random_flag)
FLAG_NOTES_XSS=$(random_flag)
FLAG_CHAT_HIDDEN=$(random_flag)
FLAG_INTERNAL_MEMORY=$(random_flag)
FLAG_BANK_SSRF=$(random_flag)
FLAG_CHAIN_FINAL=$(random_flag)
EOF

echo "[bezum] generated $OUT_FILE"
echo "[bezum] generated $FLAGS_FILE"
