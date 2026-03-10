#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
CONFIG_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/pmux"
CHEAT_DIR="${CONFIG_ROOT}/cheat"

remove_file() {
    local path="$1"
    if [[ -f "$path" || -L "$path" ]]; then
        rm -f "$path"
        echo "Removed: $path"
    else
        echo "Not found: $path"
    fi
}

remove_dir_if_empty() {
    local path="$1"
    if [[ -d "$path" ]]; then
        rmdir "$path" 2>/dev/null && echo "Removed empty dir: $path" || true
    fi
}

usage() {
cat <<EOF
uninstall.sh - remove pmux binaries

Usage:
  ./uninstall.sh
  ./uninstall.sh --purge-config
  ./uninstall.sh --help

Options:
  --purge-config   Also remove pmux config and cheat files
  --help           Show this help text
EOF
}

PURGE_CONFIG=0

case "${1:-}" in
    --purge-config)
        PURGE_CONFIG=1
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    "")
        ;;
    *)
        echo "Error: unknown option: $1" >&2
        usage >&2
        exit 1
        ;;
esac

remove_file "$BIN_DIR/pmux"
remove_file "$BIN_DIR/pmux-run"
remove_file "$BIN_DIR/pmux-cheat"

if [[ "$PURGE_CONFIG" -eq 1 ]]; then
    remove_file "$CONFIG_ROOT/config"
    remove_file "$CHEAT_DIR/languages"
    remove_file "$CHEAT_DIR/commands"

    remove_dir_if_empty "$CHEAT_DIR"
    remove_dir_if_empty "$CONFIG_ROOT"
else
    echo "Kept config:"
    echo "  $CONFIG_ROOT/config"
    echo "  $CHEAT_DIR/languages"
    echo "  $CHEAT_DIR/commands"
    echo "Use --purge-config to remove them too."
fi
