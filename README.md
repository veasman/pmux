# pmux

**pmux** (Project Multiplexer) is a lightweight tool for launching development projects into structured **tmux** sessions.

It is designed for two kinds of repositories:

- **leaf projects**: normal projects you work in directly
- **container projects**: repos that mainly organize and coordinate subprojects

pmux automatically:

- opens a tmux session for a project
- launches Neovim or your configured editor
- opens an interactive shell
- optionally runs project startup scripts
- supports container repos with subproject editor windows
- activates Python virtual environments
- activates Node versions via `.nvmrc`

Related tools:

- **pmux-run**: detect and run likely project commands in the current tmux session
- **pmux-cheat**: open cht.sh lookups in tmux

---

# Requirements

Required:

- **tmux**

Required for interactive project picking:

- **fzf**

Optional:

- **nvm** (for `.nvmrc` support)
- **jq** (for better `package.json` script detection in `pmux-run`)
- **curl** (for `pmux-cheat`)
- **xclip** (for the example tmux clipboard binding on X11)

---

# Quick Start

## 1. Install

Clone the repository and run:

```bash
./install.sh
````

This installs:

```text
~/.local/bin/pmux
~/.local/bin/pmux-run
~/.local/bin/pmux-cheat
~/.config/pmux/config
~/.config/pmux/cheat/languages
~/.config/pmux/cheat/commands
```

Make sure `~/.local/bin` is in your `PATH`.

---

## 2. Run pmux

Launch the project picker:

```bash
pmux
```

Or open a project directly:

```bash
pmux ~/repos/myproject
```

If a tmux session for that project already exists, pmux attaches to it or switches to it.

---

# How pmux Works

pmux detects project type based on:

```text
.pmux/subprojects
```

* If it exists, the repo is treated as a **container project**
* If it does not exist, the repo is treated as a **leaf project**

---

# Leaf Projects

A leaf project is a normal standalone project.

Example:

```text
myapp/
├── .pmux/
│   └── launch.sh
├── src/
└── package.json
```

pmux creates:

| Window | Purpose                                        |
| ------ | ---------------------------------------------- |
| editor | opens the editor in the project root           |
| shell  | opens an interactive shell in the project root |
| run    | runs `.pmux/launch.sh`, if present             |

---

# Container Projects

A container project is a repo that contains subprojects.

Example:

```text
platform/
├── .pmux/
│   ├── launch.sh
│   └── subprojects
├── frontend/
├── backend/
└── worker/
```

Example `.pmux/subprojects`:

```text
frontend
backend
worker
```

pmux creates:

| Window   | Purpose                                 |
| -------- | --------------------------------------- |
| frontend | editor window for `frontend/`           |
| backend  | editor window for `backend/`            |
| worker   | editor window for `worker/`             |
| shell    | root shell in the container project     |
| run      | runs root `.pmux/launch.sh`, if present |

Notes:

* container projects do **not** create a root editor window
* subprojects get editor windows only
* subprojects do **not** automatically get shell or run windows

---

# Repo Features

pmux supports optional repo-local configuration under:

```text
.pmux/
```

## `.pmux/launch.sh`

Optional startup script for the project root.

For leaf projects, this creates the `run` window.

For container projects, this creates a root-level `run` window.

Example:

```bash
#!/usr/bin/env bash
set -euo pipefail

make dev
```

## `.pmux/subprojects`

Optional file that marks a repo as a **container project**.

Each non-empty, non-comment line should be a relative subdirectory path.

Example:

```text
frontend
backend
worker
```

Comments and blank lines are allowed:

```text
# app surfaces
frontend
backend

# jobs
worker
```

If `.pmux/subprojects` exists but contains no valid directories, pmux exits with an error.

---

# Environment Detection

Before launching commands in a window, pmux attempts to load local development environments.

## Python

pmux searches upward from the window directory toward the project root for:

```text
.venv
venv
env
```

If found, it activates the nearest match.

## Node

pmux searches upward from the window directory toward the project root for:

```text
.nvmrc
```

If found, and `nvm` is installed, pmux runs:

```bash
nvm use
```

This applies per window, so different subprojects in a container repo can use different environments.

---

# pmux-run

`pmux-run` is a current-project command picker for tmux.

It inspects the current pane directory and suggests likely commands such as:

* `make <target>`
* `docker compose -f <file> up`
* `docker compose -f <file> down`
* `docker build ...`
* `npm run <script>`
* `go test ./...`
* `go run .`
* `cargo run`
* `cargo test`
* `python -m pytest`

It runs the selected command in a `run` window in the current tmux session.

Examples:

```bash
pmux-run
pmux-run --multi
```

`--multi` lets you pick multiple commands and run them in panes in the `run` window.

---

# pmux-cheat

`pmux-cheat` opens quick cht.sh lookups in tmux.

It reads from:

```text
~/.config/pmux/cheat/languages
~/.config/pmux/cheat/commands
```

and opens a new tmux window with the result.

---

# Configuration

User config lives at:

```text
~/.config/pmux/config
```

Example:

```bash
PMUX_EDITOR_CMD='exec nvim .'
PMUX_SHELL_CMD='exec "$SHELL" -l'
PMUX_CHOOSER_CMD='fzf --prompt="Project > "'

PMUX_FIXED_PROJECTS=(
    "$HOME/.dotfiles"
)

PMUX_PROJECT_ROOTS=(
    "$HOME/repos"
)
```

---

# Project Discovery

pmux builds its selectable project list from:

* directories in `PMUX_FIXED_PROJECTS`
* first-level child directories of `PMUX_PROJECT_ROOTS`

Example:

```text
~/repos/project1
~/repos/project2
~/repos/project3
```

All become selectable projects.

---

# Example Layouts

## Leaf project

```text
project/
├── .pmux/
│   └── launch.sh
├── .venv/
└── src/
```

Creates:

```text
editor
shell
run
```

## Container project

```text
project/
├── .pmux/
│   ├── launch.sh
│   └── subprojects
├── backend/
│   └── .venv/
├── frontend/
│   └── .nvmrc
└── worker/
```

Creates:

```text
backend
frontend
worker
shell
run
```

---

# Suggested tmux Bindings

```tmux
bind-key -r f display-popup -E "~/.local/bin/pmux"
bind-key -r r run-shell "~/.local/bin/pmux-run"
bind-key -r R run-shell "~/.local/bin/pmux-run --multi"
bind-key -r c run-shell "~/.local/bin/pmux-cheat"
```

---

# License

MIT
