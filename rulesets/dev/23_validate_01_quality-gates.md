# Quality Gates

Quality checks ensure that changes are safe, consistent, and ready for review. 
They must be run before any change-persistence operation (commit, push, PR).

## What to Run

1. Format code using the project's formatter or linting rules.
2. Run static analysis / linting gates that exist for the repository.
3. Run compile / typecheck gates that exist for the repository.
4. Run the full test suite (unit + integration/end-to-end if available).
5. Report accessibility results as their own quality dimension when the project has an a11y gate or folds a11y into another suite.
6. Confirm the working tree is clean and no unintended changes were introduced.
7. Check documentation coverage for meaningful technical decisions and local developer workflow changes.

## How to Run Quality Gates

- Use the repository's **local validation rules** for the exact commands.
- Shared rules define **what categories of gates are required**; local rules define **how this repository runs them**.
- Always run test gates in **non-watch mode** when they are meant to complete and exit.
- If the repository provides wrapper scripts in `bin/` or `scripts/`, local rules may prefer those over raw tool commands.

## How to Run Tests

**Always run tests in non-watch mode (run once and exit):**

Frontend:

```bash
cd /home/dennis/dev/private/projects/plannit/frontend && npm run test:run
```

Backend:

```bash
cd /home/dennis/dev/private/projects/plannit/backend && ./mvnw test
```

**Never use watch mode** in quality gates or automated workflows. Watch mode is only for interactive development.

## Behavior During Validation

- Treat failing tests or lint errors as blockers; fix them before proceeding.
- Treat missing required documentation for meaningful changes as a blocker when repository rules require it.
- Do not modify, skip, disable, rewrite, or work around tests to force a green build.
- **NEVER delete or remove tests entirely** - this reduces coverage and hides problems.
- If a test is failing:
  1. First, attempt to fix the code or test to make it pass
  2. If the fix would reduce coverage or seems wrong - **HARD STOP**
  3. Pause immediately and ask user: "Test X is failing. Should I: (a) fix the implementation, (b) fix the test, or (c) handle this differently?"
- If tests cannot be executed (missing tools, broken environment, unclear output), **stop immediately and ask the user for help** rather than guessing or bypassing.
- If tests or formatters do not exist, state this explicitly rather than inventing tools or commands.
- When the output is unclear or surprising, pause and request clarification.

## Reporting Back to the Human

- Always report the quality-gate outcome back to the user in a compact, structured way.
- Include the gate category, whether it ran, and whether it passed or failed.
- For test suites, include skipped / ignored / disabled / pending counts when the tooling exposes them.
- If a broader wrapper already includes multiple dimensions (for example E2E plus accessibility), do not double-run the same tests just to split the numbers; instead, report the included dimensions clearly.
- If a repository has no separate lint, typecheck, or accessibility gate for one side of the stack, state that explicitly instead of implying coverage that does not exist.

## When to Run

- After implementing or refactoring code.
- Before staging, committing, or pushing.
- When investigating CI failures or unexpected diffs.

## Good Practice

- Keep changes small so quality gates reveal issues early.
- If a failure appears unrelated to your changes, highlight it rather than masking it.
- Use tests to confirm behavior is unchanged during refactoring.
- Check whether the change settled a meaningful decision or altered how the system is run or validated locally, and document that before commit when applicable.
- When in doubt about how to resolve a failing check, ask for confirmation.

The goal is to ensure changes are correct, consistent, and aligned with the project’s standards—without shortcuts or bypasses.
