---
description: "Phase 2: Create detailed implementation spec from PRD"
---

# Phase 2: Create Implementation Spec

You are creating a detailed, tactical implementation specification from a PRD.

## Your Task

Read the PRD and create a detailed spec:

$ARGUMENTS

## Flags

Parse the input for optional flags:
- `--auto`: Run in non-interactive mode (skip confirmation, make best-effort decisions)
- `--output <path>`: Write spec to specified path instead of `spec.md`

## Instructions

**Tool Preference:** If the Auggie MCP code retrieval tool is available, prefer using it for understanding and searching the codebase.

1. **Read the PRD completely** - Understand the full context

2. **Before writing the spec** (skip if `--auto`), share with me:
   - Your understanding of what needs to be done
   - Any open questions that need clarification
   - A proposed outline of implementation phases

3. **Wait for my confirmation** before writing the full spec (skip if `--auto`)

## Process Mode

**If `--auto` flag is set (non-interactive):**
- Make best-effort decisions on any ambiguities
- Document all decisions in the "Auto-Mode Decisions" section (question + decision + reasoning)
- Proceed directly to writing the full spec without confirmation
- Note: A human will review this spec before implementation

**Otherwise (interactive mode):**
Work back and forth with me, sharing your open questions and phases outline before writing the plan. Do NOT write the full spec until I confirm the approach.

## Spec Format

Create the spec at the path specified by `--output`, or `spec.md` in the current directory if not specified.

Use this structure:

```markdown
# Spec: [Feature/Task Name]

## Overview
[1-2 sentence summary of what we're implementing]

## What We're NOT Doing
[Explicitly list out-of-scope items]

## Auto-Mode Decisions (only if --auto)
[If running in --auto mode: Document any ambiguities encountered and the assumptions made to proceed. Format as:
- **Question:** [What was unclear or would normally require user input]
- **Decision:** [What was assumed/decided and why]

Otherwise omit this section.]

## Implementation Phases

### Phase 1: [Name]

#### Files to Modify

##### `path/to/file.ts`
**Changes:**
- [Specific change 1]
- [Specific change 2]

**Code:**
```typescript
// Exact code to add or modify
```

##### `path/to/another-file.ts`
...

#### Files to Create

##### `path/to/new-file.ts`
**Purpose:** [Why this file exists]

**Code:**
```typescript
// Full file content
```

#### Success Criteria
**Automated:**
- [ ] Tests pass: `npm test`
- [ ] Types check: `npm run typecheck`
- [ ] Lint passes: `npm run lint`

**Manual:**
- [ ] [Specific manual verification step]

---

### Phase 2: [Name]
[Same structure...]

---

## Testing Strategy
[What to test and how]

## References
- PRD: `PRD.md`
- [Other relevant files]
```

## Rules for the Spec

1. **Be extremely specific** - File paths, line references, exact code
2. **Follow existing patterns** - Use patterns discovered in the PRD
3. **Each phase should be independently testable**
4. **No ambiguity** - The implementation should be almost mechanical

---

## After Creating the Spec

**If `--auto` flag is set:**
Report:
1. The file path
2. A 2-3 sentence summary of the proposed approach
3. Key scope items (what IS and IS NOT being done)

Do not provide next steps.

**Otherwise (interactive mode):**
Remind the user:

> **Spec created at `{output_path}`**
>
> Next steps:
> 1. Review the spec carefully - this is your contract
> 2. Run `/clear` to reset context
> 3. Run `/fabio-sdd-implement-spec {output_path}` for Phase 3
