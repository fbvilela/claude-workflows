---
description: "Phase 1: Research codebase and create PRD from GitHub issue or feature request"
---

# Phase 1: Research & PRD Creation

You are conducting comprehensive research to create a PRD (Product Requirements Document).

## Your Task

Research the following task/issue and create a PRD:

$ARGUMENTS

## Instructions

1. **Read and understand the task** - Parse the issue/request carefully

2. **Research the codebase**:
   - Find files that will be affected by this change
   - Identify existing patterns for similar implementations
   - Discover related components and how they interact
   - Locate relevant tests or examples

3. **Search external documentation** (if needed):
   - Official docs for libraries/frameworks involved
   - Implementation patterns from documentation

4. **Identify dependencies and constraints**

## CRITICAL RULES

- **DO NOT** create an implementation plan
- **DO NOT** write any code
- **DO NOT** suggest how to fix it
- **ONLY** document what exists and what's needed

## Output

Create a file called `PRD.md` in the current directory with:

```markdown
# PRD: [Brief Title]

## Task Summary
[What needs to be done - from the issue/request]

## Relevant Files
| File | Purpose | Why Relevant |
|------|---------|--------------|
| `path/to/file.ts` | Description | How it relates to task |

## Existing Patterns to Follow
[Code snippets showing patterns already used in this codebase that should be followed]

## External Documentation
[Relevant docs, links, and key excerpts]

## Dependencies & Constraints
[What this change depends on, limitations discovered]

## Rollback Plan
[How to revert the change if it doesn't work as expected. Include specific steps to undo, what to verify after rollback, and any fallback approaches]

## Open Questions
[Anything that needs clarification before planning]
```

Keep it concise - this will be input for the spec phase.

---

After creating the PRD, remind the user:

> **PRD created at `PRD.md`**
>
> Next steps:
> 1. Review the PRD
> 2. Run `/clear` to reset context
> 3. Run `/fabio-sdd-create-spec PRD.md` for Phase 2
