# Spec-Driven Development (SDD) for Claude Code

A minimal, focused workflow for AI-assisted development that keeps Claude in its "smart zone" by managing context carefully.

## The Problem

When you give Claude Code a big task, it starts strong but degrades as context fills up. By ~50% context usage, you're getting diminished returns. By 70%+, it's making mistakes.

**Vibe coding** — just chatting with the AI and letting it figure things out — leads to:
- Scope creep
- Hallucinated features
- Inconsistent implementations
- Wasted context on exploration that should have happened upfront

## The Solution: Three Phases with Clear Boundaries

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   PHASE 1       │     │   PHASE 2       │     │   PHASE 3       │
│   Research      │────▶│   Spec          │────▶│   Implement     │
│                 │     │                 │     │                 │
│   /clear        │     │   /clear        │     │   Done!         │
└─────────────────┘     └─────────────────┘     └─────────────────┘
     PRD.md                 spec.md                 Code
```

**The key insight:** Clear context between phases. Each phase starts fresh, informed only by the document from the previous phase.

## The Principles

### 1. Separate Research from Planning from Coding

Each phase has ONE job:

| Phase | Job | Output | Forbidden |
|-------|-----|--------|-----------|
| Research | Understand the codebase | PRD.md | Planning, coding, suggesting solutions |
| Spec | Create tactical plan | spec.md | Coding, changing scope |
| Implement | Execute the plan | Code | Adding features, refactoring beyond spec |

### 2. Clear Context Between Phases

After each phase:
1. Review the output document
2. Run `/clear` to wipe Claude's context
3. Start the next phase with a fresh context

This keeps Claude in the ~0-40% context range where it performs best.

### 3. Human Checkpoints are Mandatory

You review and approve:
- The PRD before spec creation
- The spec before implementation
- Each implementation phase before the next

The AI proposes, you approve. Never let it run unsupervised across phase boundaries.

### 4. The Spec is a Contract

The spec isn't a suggestion — it's the exact plan. During implementation:
- Follow it exactly
- Don't add features not in the spec
- Don't "improve" things beyond what's specified
- If reality doesn't match the spec, STOP and ask

## Installation

Run this command to install the SDD commands:

```bash
curl -fsSL https://raw.githubusercontent.com/fbvilela/claude-workflows/master/install.sh | bash
```

Or install manually:

```bash
# Clone the repo
git clone https://github.com/fbvilela/claude-workflows.git

# Copy commands to your Claude Code commands directory
mkdir -p ~/.claude/commands
cp claude-workflows/commands/*.md ~/.claude/commands/
```

## Usage

### Phase 1: Research → PRD

```bash
/fabio-sdd-create-prd https://github.com/user/repo/issues/123
```

Or paste the issue directly:
```bash
/fabio-sdd-create-prd Add dark mode toggle to settings page.
Users should be able to switch between light, dark, and system themes.
```

**Output:** `PRD.md` — documents relevant files, existing patterns, constraints.

**Then:** Review → `/clear`

---

### Phase 2: PRD → Spec

```bash
/fabio-sdd-create-spec PRD.md
```

Claude will:
1. Share its understanding and open questions
2. Propose implementation phases
3. Wait for your confirmation
4. Then write the detailed spec

**Output:** `spec.md` — exact files, exact code, exact success criteria.

**Then:** Review carefully (this is your contract) → `/clear`

---

### Phase 3: Spec → Code

```bash
/fabio-sdd-implement-spec spec.md
```

Claude will:
1. Implement phase by phase
2. Run automated checks after each phase
3. Pause for your manual verification
4. Continue only after you confirm

**Output:** Working code, tested and verified.

## The Magic Words

These phrases in the prompts prevent common AI failure modes:

| Phrase | Prevents |
|--------|----------|
| "Do NOT create an implementation plan" | Research phase turning into planning |
| "Work back and forth with me" | Spec being written without input |
| "Do NOT add features not in the spec" | Scope creep during implementation |
| "STOP and report" (on mismatch) | AI bulldozing through problems |

## Why Not Just Use Plan Mode?

Claude Code's plan mode is just a prompt that says "make a plan first." It doesn't:
- Clear context between phases
- Enforce human checkpoints
- Separate research from planning
- Prevent scope creep

SDD does all of these by design.

## Automated Code Review

The `/fabio-review-prs` command automates your daily PR review queue.

### Setup

1. Create `~/.claude/review-repos.yaml` with the repositories you review:

```yaml
repositories:
  - owner/repo-a
  - owner/repo-b
```

(See `review-repos.example.yaml` for a template.)

2. Install the command (same as above).

### Usage

```bash
/fabio-review-prs
```

Claude will:
1. Find all open PRs where you are a **requested reviewer**
2. Show you a summary table and ask for confirmation
3. Launch a **parallel sub-agent per PR** to review each one
4. Write a detailed review report per PR to `reviews/` (gitignored)

### What Gets Reviewed

Each PR is analyzed for:

| Category | What It Checks |
|----------|---------------|
| **Security** | Injection risks, auth issues, secrets, OWASP Top 10 |
| **Reusability** | DRY violations, missed abstractions, pattern consistency |
| **Code Quality** | Readability, error handling, edge cases, test coverage |

### Output

- One markdown report per PR in `reviews/` (e.g., `reviews/owner-repo-pr-42.md`)
- Each report includes a verdict, findings, and **suggested comments** with file/line references
- **Nothing is posted to GitHub** — you decide what to use

---

## Credits

Based on the methodology from:
- [Deborah Folloni's "Anti-Vibe Coding" workflow](https://dfolloni.substack.com/p/como-eu-uso-o-claude-code-workflow)
- [Dex Horthy's HumanLayer workshop](https://github.com/humanlayer/humanlayer)

## License

MIT — use however you want.
