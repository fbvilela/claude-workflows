---
description: "Phase 2: Create detailed implementation spec from PRD"
---

# Phase 2: Create Implementation Spec

You are creating a detailed, tactical implementation specification from a PRD.

## Your Task

Read the PRD and create a detailed spec:

$ARGUMENTS

## Instructions

1. **Read the PRD completely** - Understand the full context

2. **Before writing the spec**, share with me:
   - Your understanding of what needs to be done
   - Any open questions that need clarification
   - A proposed outline of implementation phases

3. **Wait for my confirmation** before writing the full spec

## CRITICAL: Interactive Process

**Work back and forth with me, sharing your open questions and phases outline before writing the plan.**

Do NOT write the full spec until I confirm the approach.

## Spec Format

Once confirmed, create `spec.md` with this structure:

```markdown
# Spec: [Feature/Task Name]

## Overview
[1-2 sentence summary of what we're implementing]

## What We're NOT Doing
[Explicitly list out-of-scope items]

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

After creating the spec, remind the user:

> **Spec created at `spec.md`**
>
> Next steps:
> 1. Review the spec carefully - this is your contract
> 2. Run `/clear` to reset context
> 3. Run `/fabio-sdd-implement-spec spec.md` for Phase 3
