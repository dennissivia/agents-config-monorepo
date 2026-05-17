# Review-Fix Commit Messages

This file defines the commit message template and rules for commits that address
PR review feedback. It extends `25_persist_02_commit-messages.md` and takes precedence
for review-fix commits.

---

## When to Use This Template

Use this template when the **primary purpose of the commit is to address PR review
feedback** — comments from automated reviewers (Copilot, etc.) or human reviewers.

Do not use this template when review fixes are bundled with new features or significant
additions. In that case, use the full feature commit template.

---

## Template

```markdown
<emoji> <brief review-fix topic description>

## Summary
<One sentence: what category of issues were addressed. No PR numbers, no "inline comments", no reviewer names.>

## Key changes
- <Problem fixed or improvement made — concept-level, no code>
- <Each bullet = one fix or closely related group>

## Validation / quality
- **Test focus:** <High-level use cases or behavior areas the tests focused on; no file names or test counts>
- **Automated tests:** <Pass/fail outcome and new/updated unit, integration, or E2E coverage areas>
- **Manual tests** (optional): <Manual QA explicitly performed or requested by the human>
- **Findings** (optional): <Bugs found during QA that were fixed immediately or added to the backlog>
```

### Subject Line

- Do not use repository title prefixes (`Feature:`, `Bugfix:`, `Tech:`, `Docs:`) for review-fix commits.
- Keep the emoji and use a brief topic phrase to describe the change category (e.g., `Address security and error handling feedback`, `Address tooling and type safety feedback`).
- No PR numbers, no "inline comments", no reviewer names.
- Keep it under one readable phrase.

---

## Rules for the Summary

The summary must read as if explaining to an engineering lead or product manager who
is evaluating the deployment. They should understand what category of concerns were
addressed without reading the diff or knowing who left the comments.

**Good:**
> "Addresses security, error handling, and tooling review feedback."

**Bad:**
> "Addresses PR #31 inline review comments from Copilot reviewer."
> "Fixes issues found in the automated code review."

Rules:
- State the category of concerns (security, error handling, test coverage, type safety, tooling, etc.)
- One sentence
- No PR numbers, no reviewer attribution, no "inline comments"

---

## Rules for Key Changes

### Concept-level, not code-level

Each bullet describes the **underlying problem fixed or improvement made** — not
the code change.

Ask: "What was wrong or missing, and what was done to address it?"

The reviewer reading this should understand the intent without knowing any class
names, method signatures, file paths, or library details.

**Never include:**
- Class, method, or function names
- File paths or script names
- Library-specific type names, annotations, or HTTP status codes
- Shell command fragments or code snippets

### Do and Don't

| ✅ Do | ❌ Don't |
|---|---|
| Session fixation prevention enabled, tests added | Added `.sessionFixation().none()` to Spring Security config on sign-in |
| Unauthorized state mapped to known HTTP error | `ApiErrorType.UNAUTHORIZED` added with `statusToErrorType(401)` mapping |
| API error handling refactored: error code translation utility added | `getApiErrorMessage()` with exhaustive switch over 10 `ApiErrorType` values |
| i18n keys added for API errors | `common.apiError.*` keys added to `en.json` and `de.json` |
| Exceptions replaced with result objects in timezone/schedule flow | `Result<void, ApiError>` propagated through `TimezoneBanner` |
| Coverage tooling improved: reduced execution time and token usage | `bin/run-coverage.bash` redesigned with `--save` flag, replaces `save-coverage.bash` |
| Diff stats extended with net change column | `bin/git-diff-stats.bash` extended with `±net` column between `-del` and `=churn` |

---

## Rules for Validation / Quality

The `Validation / quality` section uses outcome-level fields:

### Test focus

State the use cases or behavior areas the tests focused on. Keep it to one line,
and do not mention file names, test method names, or test counts.

**Good:**
> Session security and error-state handling around sign-in.

**Bad:**
> `SecurityConfigIntegrationTest.java` updated with session fixation assertion.

### Automated tests

State whether automated tests passed and what automated coverage was added or
updated at the unit, integration, or E2E level.

**Good:**
> All passed; updated integration tests for session security and frontend tests for error copy.

**Bad:**
> Tests pass.

### Manual tests

Optional. Mention only manual QA explicitly requested or performed by the human.

### Findings

Optional. Mention only bugs or quality issues found during QA that were fixed
immediately or recorded for follow-up.

---

## No Context / Intent Section

Review-fix commits do not have a Context / Intent section.

The parent commit or PR body provides the context. The reviewer can understand
the intent from the summary and key changes alone. Restating context is noise.

---

## Length

Keep the entire message under 20 lines. Review-fix commits are focused by definition.
Less is more as long as every significant fix is named.
