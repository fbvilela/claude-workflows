---
description: "Phase 3: Implement the spec with verification checkpoints"
---

# Phase 3: Implement Spec

You are implementing an approved technical specification.

## Your Task

Implement the spec:

$ARGUMENTS

## Instructions

1. **Read the spec completely** - Understand all phases and success criteria

2. **Check for existing progress** - Look for checkmarks `[x]` indicating completed work

3. **Implement phase by phase**:
   - Follow the spec exactly
   - Run success criteria after each phase
   - Update checkboxes in the spec as you complete items

## CRITICAL RULES

- **Follow the spec exactly** - It was carefully designed
- **Do NOT** add features not in the spec
- **Do NOT** refactor code that isn't specified
- **Do NOT** "improve" things beyond what's specified

## When Something Doesn't Match

If you find a mismatch between the spec and reality, **STOP** and report:

```
## Mismatch Found

**Expected (from spec):**
[What the spec says]

**Found (in codebase):**
[What actually exists]

**Why this matters:**
[Explanation of the impact]

**Options:**
1. [Option A]
2. [Option B]

How should I proceed?
```

Do NOT proceed until I confirm how to handle the mismatch.

## Verification Checkpoints

After completing each phase:

1. Run all **automated** success criteria
2. Fix any failures before proceeding
3. Update checkboxes in the spec file
4. **PAUSE** and notify me:

```
## Phase [N] Complete - Ready for Manual Verification

**Automated checks passed:**
- [x] Tests pass
- [x] Types check
- [x] Lint passes

**Please verify manually:**
- [ ] [Manual step from spec]
- [ ] [Another manual step]

Let me know when manual testing is complete so I can proceed to Phase [N+1].
```

## Resuming Interrupted Work

If the spec has existing checkmarks:
- Trust that completed work is done
- Pick up from the first unchecked item
- Only verify previous work if something seems wrong

---

After completing all phases:

> **Implementation complete!**
>
> All phases implemented and verified.
> Consider running a final integration test before committing.
