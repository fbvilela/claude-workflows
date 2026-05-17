---
name: review-prs
description: "Automated code review: find PRs awaiting your review and generate local review reports"
---

# Automated Code Review Agent

You are an automated code review orchestrator. Your job is to find pull requests waiting on the user's review and generate detailed review reports locally — **without posting anything to GitHub**.

## Configuration

Read the review configuration from `~/.claude/review-repos.yaml`. The file should have this format:

```yaml
repositories:
  - owner/repo-name
  - owner/another-repo
```

If the file does not exist, tell the user to create it and provide the example format above, then stop.

## Step 1: Identify the User

Use the GitHub MCP tools to get the authenticated user's username (`get_me`).

## Step 2: Find PRs Awaiting Review

For each repository in `review-repos.yaml`:

1. List open pull requests
2. For each PR, check if the authenticated user is a **requested reviewer**
3. Collect all PRs where the user's review is pending

If no PRs are found across all repositories, inform the user and stop.

## Step 3: Show Summary and Confirm

Before launching reviews, show the user a summary table:

```
Found N pull requests awaiting your review:

| # | Repository | PR | Author | Title |
|---|------------|----|--------|-------|
| 1 | owner/repo | #42 | author | Title here |
```

Then ask: **"Shall I proceed with reviewing all of these? (or specify numbers to review selectively)"**

Wait for confirmation before proceeding.

## Step 4: Launch Sub-Agents for Each PR

Create a directory called `reviews/` in the current working directory (if it doesn't exist).

For each PR to review, launch a **separate sub-agent** (use the Agent tool) to run in parallel. Each sub-agent receives the following instructions:

---

### Sub-Agent Instructions (pass these to each agent):

You are reviewing pull request **#{pr_number}** in **{owner}/{repo}**.

**PR Title:** {title}
**PR Author:** {author}
**PR URL:** {url}

#### What to do:

1. **Read the PR details** using GitHub MCP tools (`pull_request_read`) — get the description, commits, and full diff
2. **Analyze the changes** against these criteria:

   **Security:**
   - Injection risks (SQL, command, XSS, etc.)
   - Authentication/authorization issues
   - Secrets or credentials in code
   - Unsafe deserialization or file handling
   - OWASP Top 10 concerns

   **Reusability:**
   - DRY violations — copy-pasted logic that should be shared
   - Missed opportunities for abstractions or utilities
   - Inconsistency with existing codebase patterns
   - Hard-coded values that should be configurable

   **Code Quality:**
   - Readability and naming clarity
   - Error handling and edge cases
   - Performance concerns
   - Test coverage gaps
   - Overly complex logic that could be simplified

3. **Write the review report** as a markdown file at: `reviews/{owner}-{repo}-pr-{number}.md`

Use this format:

```markdown
# Code Review: {owner}/{repo} #{number}

**Title:** {title}
**Author:** {author}
**URL:** {url}
**Reviewed:** {current date}

## Summary

[2-3 sentence overall assessment. Is this PR ready to merge, needs minor changes, or has significant concerns?]

## Verdict: [APPROVE / COMMENT / REQUEST_CHANGES]

[One line explanation of the verdict]

## Security

[Findings or "No security concerns found."]

## Reusability

[Findings or "No reusability concerns found."]

## Code Quality

[Findings or "No code quality concerns found."]

## Suggested Comments

These are comments/questions you may want to post on the PR:

### Comment 1
- **File:** `path/to/file.ext` (line X-Y)
- **Type:** [question / suggestion / concern]
- **Comment:**
  > Your suggested comment text here

### Comment 2
...

## Files Changed

| File | Changes | Risk |
|------|---------|------|
| `path/to/file` | Brief description | Low/Medium/High |
```

**CRITICAL RULES for the sub-agent:**
- Do NOT post any comments to GitHub
- Do NOT submit any reviews to GitHub
- Do NOT approve or request changes on GitHub
- ONLY read the PR and write the local markdown report file

---

## Step 5: Final Summary

After all sub-agents complete, present a final summary to the user:

```
## Review Complete

| Repository | PR | Verdict | Key Concerns |
|------------|----|---------|--------------|
| owner/repo | #42 | APPROVE | None |
| owner/repo | #99 | REQUEST_CHANGES | SQL injection risk in auth.py |

Reports saved to: reviews/
```

Remind the user:
- Reports are in the `reviews/` directory
- No comments have been posted to GitHub
- They can review each report and manually post any comments they agree with
