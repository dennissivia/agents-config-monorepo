# Test Ownership and Debugging Strategy

Two unconditional rules that govern how broken tests and broken code are handled.

---

## Rule 1: Broken Tests Are Always Your Fault

**All broken tests and broken code are caused by the current changes.**

Do not attempt to verify whether a failure is pre-existing. This means:

- **Never** run `git stash && <test-command>` to check "was this already broken?"
- **Never** run tests before and after a change to look for regressions as a validation strategy
- **Never** frame a failure as "possibly pre-existing"

The only exception: a comment in the source code or test explicitly marking it as
known-broken (e.g., `// TODO: broken, skipped until X is resolved`). In that case,
raise it with the user for confirmation before proceeding.

All tests must pass after every feature. A failing test is always your problem to fix.

---

## Rule 2: Methodical Debugging — Isolate, List, Fix One at a Time

When failures occur, follow this strict protocol:

### Step 1: Identify and List All Failures

Read the error output carefully and compile a complete list of distinct failures.
Do **not** start fixing yet. Identify each unique error message or root cause.

### Step 2: Find the Most Foundational Failure

Rank failures by causality. Ask: "If I fix X, will it unblock Y and Z automatically?"

A foundational failure is one that triggers cascading failures in other tests.
Fix the root cause first, not the symptoms.

### Step 3: Fix One Failure — Isolate, Reproduce, Fix, Verify

For each failure (starting with the most foundational):

1. **Isolate** — understand exactly why it fails. Read the error, trace the cause.
2. **Fix** — make the minimal code change that addresses this specific failure.
3. **Run only the affected test(s)** — not the full suite.
4. **Move on** — once that test passes, proceed to the next failure in the list.

**Never** run the entire test suite to "see if things improve." This is:
- A waste of time and tokens
- Not a diagnostic strategy
- A symptom of guessing instead of reasoning

### Step 4: Run the Full Suite Only at the End

After all identified failures are individually fixed and verified, run the full suite
once as a final gate check.

---

## When You Cannot Understand a Failure

If investigation does not reveal the cause after systematic inspection:

**HARD STOP.** Ask the user with:
- A concise description of the failing test and the exact error
- What you investigated and why
- Why that investigation did not resolve it

Do not guess. Do not try random fixes hoping something works.
