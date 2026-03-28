#!/bin/bash

# SDD Commands Installer for Claude Code
# https://github.com/fbvilela/claude-workflows

set -e

COMMANDS_DIR="${HOME}/.claude/commands"
REPO_URL="https://raw.githubusercontent.com/fbvilela/claude-workflows/master/commands"

echo "Installing SDD commands for Claude Code..."

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Download each command file
commands=(
    "fabio-sdd-create-prd.md"
    "fabio-sdd-create-spec.md"
    "fabio-sdd-implement-spec.md"
    "fabio-sdd-triage.md"
    "fabio-review-prs.md"
)

for cmd in "${commands[@]}"; do
    echo "  Downloading $cmd..."
    curl -fsSL "$REPO_URL/$cmd" -o "$COMMANDS_DIR/$cmd"
done

echo ""
echo "Installation complete!"
echo ""
echo "Available commands:"
echo "  /fabio-sdd-create-prd     - Phase 1: Research and create PRD"
echo "  /fabio-sdd-create-spec    - Phase 2: Create implementation spec"
echo "  /fabio-sdd-implement-spec - Phase 3: Implement the spec"
echo "  /fabio-sdd-triage         - Automated: Run PRD + Spec and post to GitHub issue"
echo "  /fabio-review-prs         - Automated code review for pending PRs"
echo ""
echo "Get started:"
echo "  /fabio-sdd-create-prd <github-issue-url-or-description>"
echo "  /fabio-sdd-triage <github-issue-url-or-number>"
echo "  /fabio-review-prs  (configure repos in ~/.claude/review-repos.yaml)"
