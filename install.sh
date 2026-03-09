#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pmux"

mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"

install -m 755 "$REPO_DIR/pmux" "$BIN_DIR/pmux"

if [[ ! -f "$CONFIG_DIR/config" ]]; then
    cp "$REPO_DIR/examples/config" "$CONFIG_DIR/config"
fi

echo "pmux installed to $BIN_DIR/pmux"
echo "config: $CONFIG_DIR/config"
