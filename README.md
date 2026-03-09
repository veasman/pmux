# pmux

**pmux** (Project Multiplexer) is a lightweight tool that launches development projects inside **tmux** sessions.

It automatically:

- opens a tmux workspace for a project
- launches your editor
- opens a shell
- optionally runs project startup scripts
- opens windows for subprojects
- activates Python virtual environments
- activates Node versions via `.nvmrc`

pmux is designed to make switching between development projects fast and consistent.

---

# Quick Start

## 1. Install

Clone the repository and run:

```bash
./install.sh
```

This will install:

```
~/.local/bin/pmux
~/.config/pmux/config
```

Ensure `~/.local/bin` is in your PATH.

---

## 2. Run pmux

Launch the project picker:

```
pmux
```

Select a project and a tmux workspace opens automatically.

You can also open a project directly:

```
pmux ~/repos/myproject
```

---

# Requirements

Required:

- **tmux**
- **bash**

Required for interactive picker:

- **fzf**

Optional:

- **nvm** (for `.nvmrc` support)

---

# What pmux Does

When opening a project, pmux creates a tmux session with:

| Window | Purpose |
|------|------|
| editor | opens your editor in the project root |
| shell | interactive shell |
| run | executes `.mux/launch.sh` if present |
| subprojects | optional windows defined in `.mux/subprojects` |

---

# Configuration

User config is stored at:

```
~/.config/pmux/config
```

Example:

```bash
PMUX_EDITOR_CMD='exec nvim .'
PMUX_SHELL_CMD='exec "$SHELL" -l'

PMUX_FIXED_PROJECTS=(
    "$HOME/.dotfiles"
)

PMUX_PROJECT_ROOTS=(
    "$HOME/repos"
)
```

---

# Project Discovery

pmux builds the project list from:

- directories listed in `PMUX_FIXED_PROJECTS`
- all child directories of `PMUX_PROJECT_ROOTS`

Example:

```
~/repos/project1
~/repos/project2
~/repos/project3
```

All become selectable projects.

---

# Repo Features

pmux supports optional repo configuration.

## `.mux/launch.sh`

Startup script executed when the project opens.

Example:

```bash
#!/usr/bin/env bash
set -euo pipefail

make dev
```

---

## `.mux/subprojects`

List directories to open additional shells for.

Example:

```
backend
frontend
worker
```

---

# Environment Detection

pmux automatically activates environments.

### Python

Searches for:

```
.venv
venv
env
```

Nearest match wins.

---

### Node

Searches for:

```
.nvmrc
```

If found and `nvm` is installed:

```
nvm use
```

runs automatically.

---

# Example Project

```
project/
├── Makefile
├── .mux
│   ├── launch.sh
│   └── subprojects
├── backend
│   └── .venv
├── frontend
│   └── .nvmrc
└── worker
    └── .venv
```

---

# License

MIT
