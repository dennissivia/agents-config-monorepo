# Automated Code Review Focus

Rules for automated PR review agents (Copilot Code Review, Codex, similar
tools), and for any reviewer applying a structured checklist.

The goal is high-signal feedback. Flag what genuinely matters; do not flag
what automated formatters and linters already cover.

---

## Repository-Awareness

If the project is a monorepo (e.g., separate frontend and backend roots),
respect the boundary:

- Changes scoped to one root should not implicitly imply changes on the other.
- Cross-root changes must be treated as cross-stack work, not a flat edit.

If the project is a single-root codebase, this section is a no-op.

---

## Review Severity Tiers

Use a consistent severity vocabulary across reviewers and stacks:

- **Critical** — must flag. Correctness, security, data loss, or
  contract-breaking.
- **Important** — should flag. Missing error handling, missing test coverage
  for a behavior change, logic smells with realistic impact.
- **Style / Suggestion** — optional, low-priority improvements.

Do not raise critical-tier flags for stylistic preferences.

---

## Review Focus By Concern

The following categories apply to most stacks. Stack-specific details belong
in the per-project rules; this file lists the universal review concerns.

### Correctness And Safety (Critical)

- Use of unsafe casts or escape hatches that bypass the type system (e.g.,
  `any`, non-null assertions, raw casts, untyped maps in service layers).
- Missing null / absence checks at boundaries where the value can legitimately
  be missing.
- SQL injection or string-concatenated query construction.
- Secrets or credentials in code, logs, or test fixtures.
- Missing validation on external input (HTTP, message-queue payloads, file
  uploads).

### Concurrency And Transactions (Critical)

- Shared mutable state without synchronization.
- Async sequencing that allows incorrect interleaving.
- Transaction boundaries drawn at the wrong layer.

### Tests (Critical / Important)

- Tests that skip or disable other tests to pass.
- Tests without meaningful assertions.
- Database-writing integration tests that lack transactional rollback when
  rollback would work and no documented exception applies.
- Missing edge-case coverage (null, empty, boundary values).
- Missing assertions on quantity before indexing into collections.
- Hardcoded test data that could collide across tests.

### Schema And Migrations (Critical)

- `DROP COLUMN` (or equivalent) without considering data migration.
- Schema changes that would break existing data.
- Constraint additions where existing data may violate the constraint.

### API And Contract Hygiene (Important)

- New or changed endpoints not reflected in their API contract / OpenAPI
  documentation, including non-happy-path responses.
- Inconsistent naming between API contracts, domain models, and persistence
  schemas.

### Style (Optional)

- `const` vs `let` (or equivalent) when the value does not change.
- Early returns over deeply nested conditionals.
- Constructor injection over field injection (where idiomatic).

---

## What NOT To Flag

Avoid noise on items that automated formatters and linters already cover:

- Formatting issues (handled by automated formatters).
- Import ordering (handled by linters).
- Line length unless extreme.
- Naming preferences already consistent with the codebase.
- Suggestions that conflict with documented project conventions (e.g., a
  repository's soft-delete naming convention or a deliberate departure from
  framework defaults).

---

## Reviewer Behavior

- Be specific: reference exact lines / code.
- Explain **why** something is problematic, not just **what**.
- Severity matters: distinguish critical issues from suggestions.
- Do not repeat resolved comments on re-review.
- Where the project has documented decisions (ADRs, design docs, agent rules),
  cite the relevant decision instead of restating principle from memory.

---

## Stack-Specific Extensions

Project-local rules may extend this file with stack-specific checks (e.g.,
TypeScript strictness, Spring Boot validation annotations, Flyway migration
naming). Treat those local extensions as authoritative for that project; this
file remains the universal baseline.
