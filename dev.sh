#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/infra/scripts"

command="${1:-up}"

case "$command" in
  up|down|restart|rebuild|logs|flags|reset|refresh-flags)
    exec bash "$SCRIPTS_DIR/${command}.sh"
    ;;
  *)
    echo "[bezum] unknown command: $command"
    echo "usage: ./infra/dev.sh {up|down|restart|rebuild|logs|flags|reset|refresh-flags}"
    exit 1
    ;;
esac
