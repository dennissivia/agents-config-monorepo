# Testing Standards

Testing ensures correctness, protects refactoring, and prevents regressions.

## Bug Regression Tests — Mandatory

**Every confirmed bug fix must be accompanied by a regression test.**

- When a bug is found and fixed, add a test that would have caught it before the fix.
- If a faulty test already exists (wrong expectation, missing case), fix the test — do not just fix the code.
- The regression test must fail on the unfixed code and pass after the fix.
- Name the test to clearly describe the bug scenario (e.g., `"does not treat 200 with empty body as an error"`).
- This applies to all layers: unit tests, integration tests, and e2e tests.

**If no obvious test location exists:**
1. Add it to the nearest existing test file for the affected component/module.
2. If a test file does not exist, create one following the existing project patterns.

## Test Requirements
- Add or update tests for all new features and significant changes, covering:
  - happy paths
  - edge cases
  - error conditions and boundary values
- Run all available test suites before committing or merging:
  - unit tests
  - integration tests
  - end-to-end or system tests where applicable
- All tests must pass before merging or asking for review.

## Test Reporting

- When reporting test outcomes to the human, include skipped / ignored / disabled / pending counts when the test runner exposes them.
- If multiple test levels are covered by one wrapper command, report the covered levels and the single source of truth rather than rerunning the same tests for cosmetic separation.
- If a project includes accessibility checks inside an E2E suite, report accessibility as a distinct dimension in the summary even though it shares the same wrapper run.

## Test Organization
- Use descriptive test names that explain the intent and expected behavior.
- Group related tests logically and share setup/fixtures where appropriate.
- Prefer clear, minimal setup over deeply nested or overly clever test utilities.
- Extract constants for repeated test data to avoid duplication and improve readability.

## Test Quality
- Test quality should aim to match production code quality. Tests are maintained code, not disposable scaffolding.
- Keep unit tests focused on one behavior and assert only what is necessary for that behavior.
- Avoid redundant assertions when an earlier assertion already proves the same outcome.
- In more complex integration-style tests, prefer additional step-by-step assertions when they improve failure diagnosis.
- If setup is noisy or repeated, extract meaningful helpers, builders, fixture wrappers, or assertion helpers instead of copying setup across tests.
- Only extract helpers when they improve readability and reuse; do not hide important behavior behind overly generic abstractions.
- If a test is noisy because a well-established community tool would improve setup, assertions, or failure reporting, suggest that tool to the user before introducing it.
- Prefer readable expected-value setup and explicit failure messages over clever but opaque test code.

## Test Coverage Goals
- Unit tests for core business logic (services, domain functions, core modules).
- Integration tests for public interfaces and I/O boundaries 
  (e.g., HTTP controllers/handlers, APIs, messaging endpoints, CLIs).
- Explicit tests for null/empty/invalid inputs and error paths.
- Tests for concurrent or multi-access scenarios where shared state or thread/async safety matters.

## Behavior for AI Agents

- Follow existing testing patterns, frameworks, and file structure used in the repository.
- Do not introduce new testing libraries or frameworks unless explicitly requested.
- **CRITICAL: Never skip, disable, delete, or remove tests to make tests pass.**
- **If a test is failing and the fix seems unclear or would reduce coverage - HARD STOP.**
  - Pause immediately
  - Report the failing test to the user
  - Ask: "Test X is failing. Options: (a) fix implementation, (b) fix test, (c) investigate together?"
- Attempt to fix failing tests by:
  1. Fixing the implementation to meet test expectations
  2. Updating the test if requirements changed (but never reducing coverage)
  3. Adding missing mocks/setup if test environment is incomplete
- If the test tooling reports tests as **skipped/ignored by default** (e.g., slow or integration suites), and it is feasible to run them, run the full suite at least once before considering the work done, or explicitly call out why they could not be run.
- If tests fail or cannot be executed due to environment/tooling issues, stop and ask the user for guidance instead of guessing or bypassing.

## Test Coverage Protection

**Removing tests reduces coverage and hides problems. This is never acceptable.**

- If a test seems "superfluous" or "unnecessary" - **HARD STOP and ask user**
- If a test is difficult to fix - **HARD STOP and ask user**
- If a test is blocking progress - **HARD STOP and ask user**
- The only valid reason to remove a test: user explicitly approves it

**Good fixes:**

- Update implementation to match test expectations
- Fix test setup/mocks if broken
- Update assertions if requirements legitimately changed

**Bad "fixes" (never do these):**

- Deleting failing tests
- Commenting out test cases
- Making tests always pass (e.g., `expect(true).toBe(true)`)
- Reducing what tests verify
- Skipping tests with `.skip()` or similar
