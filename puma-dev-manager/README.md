# puma-dev-manager

A local web app for managing [puma-dev](https://github.com/puma/puma-dev) apps and their git worktrees. Runs as a Rack app hosted by puma-dev itself.

## What it does

- Lists all apps registered in `~/.puma-dev/`
- For any app that is a git repo, lists its git worktrees
- Lets you switch which worktree puma-dev points to by rewriting the symlink
- Touches `tmp/restart.txt` in the new worktree to trigger puma-dev reload

## Requirements

- Ruby
- [puma-dev](https://github.com/puma/puma-dev) installed and running
- Bundler (`gem install bundler`)

## Setup

```bash
# 1. Clone or create the repo
cd ~/dev
git clone <repo-url> puma-dev-manager
cd puma-dev-manager

# 2. Install dependencies
bundle install

# 3. Register with puma-dev
ln -s $(pwd) ~/.puma-dev/puma-dev-manager

# 4. Visit
open https://puma-dev-manager.test
```

## How it works

- **Screen 1 — App list** (`GET /`): Shows all entries in `~/.puma-dev/`, indicating whether each is a symlink or real directory, along with the current git branch.
- **Screen 2 — Worktree picker** (`GET /apps/:name`): Shows the app's current target path, lists all git worktrees, and lets you switch between them.
- **Switching** (`POST /apps/:name/switch`): Rewrites the symlink in `~/.puma-dev/` to point to the selected worktree and touches `tmp/restart.txt` to trigger a puma-dev reload.

## Tech stack

- **Backend:** Sinatra (single `app.rb`)
- **Frontend:** Vanilla HTML + CSS + JS (no build step)
- **No database** — the filesystem is the source of truth
