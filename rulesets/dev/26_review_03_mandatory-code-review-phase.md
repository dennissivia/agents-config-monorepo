# Mandatory Code Review Phase

After all tests pass and before proposing a commit, the agent **must** perform a
structured self-review of every change. This is non-negotiable and applies to all
code changes regardless of size.

---

## When to Run

- After the quality gates phase (tests, lint, format) passes.
- Before proposing a commit message or creating a PR.
- Also after any significant refactoring mid-session.

---

## Review Checklist

Work through each category and report findings. Flag issues as **BLOCKER**,
**IMPORTANT**, or **SUGGESTION**.

### 1. Code Quality

- Are functions and methods focused on a single responsibility?
- Is cyclomatic complexity reasonable? Flag any function with more than ~5 branches.
- Are there magic numbers, inline constants, or hardcoded strings that belong in named constants?
- Is error handling explicit and complete, or are failures silently swallowed?

### 2. Race Conditions and Concurrency

- Does any shared mutable state exist without synchronization?
- Are async operations properly sequenced? Could interleaving produce incorrect results?
- Backend: Are `@Transactional` boundaries drawn at the right level?
- Frontend: Could concurrent state updates (e.g., stale closures in React) cause inconsistencies?

### 3. Type Safety and Weak Typing

- Are there uses of `any`, `Object`, raw `Map`, or untyped collections?
- Are there stringly-typed comparisons (`status === "loading"`) instead of discriminated unions or enums?
- Are there non-null assertions (`!` in TypeScript, unchecked casts in Java) that could panic at runtime?
- Are nullable values properly guarded before use?
- Are API boundaries validated — is external data treated as `unknown` / `Object` before narrowing?

### 4. Missing Abstractions and Duplication

- Is logic repeated across multiple locations that could be extracted into a shared utility?
- Are there patterns that should be encapsulated in a type, class, or hook?
- Do test files repeat setup code that belongs in `beforeEach` / `@BeforeEach` blocks?

### 5. Leaky Abstractions and Clean Architecture

- Does a lower layer expose implementation details to higher layers (e.g., database entities leaking into API responses)?
- Do domain models depend on infrastructure concerns (e.g., persistence annotations bleeding into business logic)?
- Does a service directly reference HTTP request/response types?
- Frontend: Are infrastructure concerns (API calls, storage) mixed into presentation components instead of isolated in services or hooks?

### 6. DDD Alignment

- Are domain concepts named consistently with the ubiquitous language in the codebase and docs?
- Is business logic in the service/domain layer, not in controllers or UI components?
- Are domain boundaries respected — does one aggregate/context reach directly into another?

---

## Output Format

Report findings grouped by category. Use this structure:

```
## Code Review

### Blockers
- [file:line] Description of the issue and why it must be fixed.

### Important
- [file:line] Description and recommended fix.

### Suggestions
- [file:line] Non-blocking improvement.

### No issues found in: [category names]
```

If all categories are clean, state that explicitly. Do not skip the report.
A clean review with "no issues found" is still a required output.

---

## Fixing Blockers

- Fix all **BLOCKER** items before proceeding to commit.
- Re-run tests after fixing blockers to confirm no regressions.
- Flag **IMPORTANT** items to the user; fix unless they explicitly defer.
- **SUGGESTION** items may be deferred with a note.
