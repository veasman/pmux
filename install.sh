#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="${HOME}/.local/bin"
CONFIG_ROOT="${XDG_CONFIG_HOME:-$HOME/.config}/pmux"
CHEAT_DIR="${CONFIG_ROOT}/cheat"

mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_ROOT"
mkdir -p "$CHEAT_DIR"

install -m 755 "$REPO_DIR/pmux" "$BIN_DIR/pmux"
install -m 755 "$REPO_DIR/pmux-run" "$BIN_DIR/pmux-run"
install -m 755 "$REPO_DIR/pmux-cheat" "$BIN_DIR/pmux-cheat"

if [[ ! -f "$CONFIG_ROOT/config" ]]; then
    cp "$REPO_DIR/examples/config" "$CONFIG_ROOT/config"
fi

if [[ ! -f "$CHEAT_DIR/languages" ]]; then
    cp "$REPO_DIR/examples/cheat/languages" "$CHEAT_DIR/languages"
fi

if [[ ! -f "$CHEAT_DIR/commands" ]]; then
    cp "$REPO_DIR/examples/cheat/commands" "$CHEAT_DIR/commands"
fi

cat <<EOF
Installed:
  $BIN_DIR/pmux
  $BIN_DIR/pmux-run
  $BIN_DIR/pmux-cheat

Config:
  $CONFIG_ROOT/config

Cheat files:
  $CHEAT_DIR/languages
  $CHEAT_DIR/commands
EOF
