# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains **Spec-Driven Development (SDD)** commands for Claude Code - a three-phase workflow that manages AI context to keep Claude performing optimally.

The workflow addresses context degradation: Claude performs best in the 0-40% context range. SDD enforces context clearing between phases via `/clear`.

## Architecture

Four slash commands in `commands/` implement the workflow:

### Interactive Commands (Manual `/clear` between phases)

| Command | Phase | Input | Output |
|---------|-------|-------|--------|
| `/fabio-sdd-create-prd` | 1: Research | GitHub issue URL or text description | `PRD.md` |
| `/fabio-sdd-create-spec` | 2: Spec | `PRD.md` | `spec.md` |
| `/fabio-sdd-implement-spec` | 3: Implement | `spec.md` | Working code |

### Automated Triage (Subagent-based)

| Command | Input | Output |
|---------|-------|--------|
| `/fabio-sdd-triage` | GitHub issue URL or number | PRD + Spec files, GitHub comment |

The triage command automates phases 1-2 using sequential subagents for fresh context (equivalent to `/clear`). It operates in a worktree (`~/.claude/sdd-worktree`), pushes to an `AI-Triage` branch, and posts a summary comment to the issue.

Each command file uses `$ARGUMENTS` to receive user input and includes explicit rules to prevent phase bleeding (e.g., research phase must not plan, spec phase must not code).

## Key Design Principles

1. **Phase isolation**: Each phase has ONE job. Research discovers, Spec plans, Implement executes.
2. **Human checkpoints**: User reviews output and runs `/clear` between each phase.
3. **Spec as contract**: During implementation, follow the spec exactly. Stop and report mismatches rather than improvising.

## Installation

Commands are installed to `~/.claude/commands/` either via:
- `curl -fsSL https://raw.githubusercontent.com/fbvilela/claude-workflows/master/install.sh | bash`
- Manual copy from `commands/*.md`

## Development

This is a documentation-only repository. No build, test, or lint commands exist. Changes involve editing the markdown command files in `commands/`.

When modifying commands, preserve the "magic words" that prevent AI failure modes:
- "Do NOT create an implementation plan" (prevents research→planning bleed)
- "Work back and forth with me" (ensures interactive spec creation)
- "Do NOT add features not in the spec" (prevents implementation scope creep)
- "STOP and report" (prevents bulldozing through problems)
