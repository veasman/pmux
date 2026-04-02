# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make install                           # Install to ~/.local/bin + bootstrap ~/.config/pmux/ defaults
make uninstall                         # Remove binaries
make purge                             # Remove binaries and config

make install DESTDIR=... PREFIX=/usr   # System/packaging install
```

There is no test suite or linter. The scripts can be run directly from the repo root.

## Releasing

Push a tag `v*` to trigger `.github/workflows/release.yml` which creates a GitHub release. That release then triggers `.github/workflows/aur.yml` which updates the AUR package. The `AUR_SSH_PRIVATE_KEY` secret must be configured in the repo.

## Architecture

pmux is a bash toolset for launching development projects into structured tmux sessions. It has three executable scripts:

**`pmux`** — Main launcher. Discovers projects from `PMUX_FIXED_PROJECTS` (pinned paths) and `PMUX_PROJECT_ROOTS` (scanned directories), then uses fzf to let the user choose one. Based on whether a chosen repo has `.pmux/subprojects`, it creates either a **leaf session** or a **container session** (one window per subproject). Leaf session window order: editor, claude (if `CLAUDE.md` exists), shell, run (if `.pmux/launch.sh` exists). Also handles environment activation: Python venv discovery and nvm for `.nvmrc`.

**`pmux-run`** — Command picker. Detects available commands from the current project (make targets, docker-compose services, npm scripts, go/cargo/pytest commands) and runs the selection in a dedicated `run` tmux window. `--multi` flag splits into panes instead.

**`pmux-cheat`** — Quick reference. Opens cht.sh queries in a tmux popup, using language/command lists from `~/.config/pmux/cheat/`.

## Configuration Model

- **User config**: `~/.config/pmux/config` — shell file sourced at startup, sets env vars like `PMUX_EDITOR_CMD`, `PMUX_SHELL_CMD`, `PMUX_PROJECT_ROOTS`, etc.
- **Per-repo config**: `.pmux/` directory at repo root
  - `.pmux/launch.sh` — optional startup script run when the session is created
  - `.pmux/subprojects` — presence of this file makes the repo a container project; each line is a subdirectory path

## Key Internal Patterns

- `build_shell_prefix()` in `pmux` constructs the shell init string that activates venvs/nvm before launching the interactive shell or editor.
- `run_in_window()` abstracts tmux window creation and is used for both editor and shell windows.
- `build_menu()` in `pmux-run` is the aggregation point for all command detection logic — each tool type appends to a shared `menu` array.
- Loom theme integration is wired into fzf opts via `PMUX_LOOM_FZF_FILE` (a generated file with color variables).
