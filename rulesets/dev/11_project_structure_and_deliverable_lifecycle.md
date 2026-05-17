# Project Structure and Deliverable Lifecycle

Defines the canonical hierarchy for organising work and the mandatory gate sequence
that must run at every deliverable boundary before a commit is made.

---

## Project Hierarchy

```
Version
  └── Milestone
        └── Deliverable
```

**Version** — A product scope increment with a clear user-facing goal. Defined in
the product planning docs (`docs/planning/`). Examples: `V0.5-auth`, `V1.0-launch`.

**Milestone** — A logical unit within a version. Contains a set of deliverables.
Defined in the version's implementation plan. Examples: `M1`, `M2`.

**Deliverable** — An observable user or system outcome. Defined in the milestone's
implementation plan as `Deliverable 1`, `Deliverable 2`, etc.

---

## Deliverable Lifecycle — Mandatory Sequence

Every deliverable is a **commit boundary**. After completing the implementation of a
deliverable, the following gates must run **in order** before any git staging or
committing:

### Gate 0: Completeness Check (Before Any Gate)

Before running any other gate, verify that **every step of the current deliverable
is fully implemented** — across all stacks (frontend AND backend).

1. Re-read the deliverable definition in the milestone implementation plan.
2. For each listed step, confirm it exists in the working tree.
3. If any step is missing (e.g., frontend step skipped while backend was built),
   **HARD STOP** — implement the missing steps before proceeding.

**This applies especially to cross-stack deliverables.** If a deliverable lists both
a frontend step and a backend step, both must be complete before committing either.
Never commit a partial deliverable (e.g., backend only when frontend was specified).

**Why this matters:** Skipping frontend steps inflates PR size, breaks the
vertical-slice principle, and produces backend-only "deliverables" that cannot be
demoed or validated end-to-end.

---

### Gate 1: Tests (23_validate_01, 24_qa_*)
- Run the full test suite (unit + integration).
- All tests must pass. Zero exceptions.

### Gate 2: Format and Lint (24_qa_03)
- Run the formatter and linter for each affected stack.
- Backend: `./mvnw spotless:check` (or `spotless:apply` if clean).
- Frontend: `npm run lint`.
- All checks must pass.

### Gate 3: Mandatory Code Review (26_review_03)
- Apply the full mandatory code review phase.
- Resolve all blockers and important issues before proceeding.

### Gate 4: Size and Doc Hygiene Check (26_review_04)
- Count lines added. If over the 800 LOC threshold, apply the extraction review.
- Check for duplicate or version-suffixed planning documents.

---

### Gate 5: Stage Changes (Requires User Confirmation)

Once all gates above pass:

1. **STOP and announce:** "All gates pass for Deliverable N. Ready to stage. Shall I?"
2. **Wait for explicit user confirmation.**
3. **Stage all deliverable changes:** `git add <files>`
4. **Verify staged files:** `git status --short` — confirm all intended files are
   staged (status `A` or `M` in first column), no unexpected files.

**Why stage before refactoring:**  
The staged snapshot captures the "working green state". After refactoring, the diff
between staged and working tree shows exactly what changed during cleanup. This makes
the refactor reviewable and reversible.

---

### Gate 6: Refactoring Pass (Phase 5)

With changes safely staged:

- Apply Phase 5 (Refinement & Refactoring) from `10_dev_workflow.md`.
- Scope: code added or modified in this deliverable only.
- Keep behaviour identical. Run only the affected tests to verify each change.
- After the refactoring pass, re-run the full suite (Gate 1) and lint (Gate 2).

---

### Gate 7: Commit (Requires User Confirmation)

- **STOP:** Propose the commit message as rendered Markdown in chat.
- **Wait for explicit user approval.**
- Commit using temp file per `25_persist_01` rules.
- Announce: "Committed locally. Ready for D(N+1) or should I push?"

---

## PR vs Push

A PR is not required after every deliverable. The default is:

- **Commit locally** after each deliverable (mandatory).
- **Push to feature branch** when the user asks, or when accumulated churn warrants
  a review checkpoint per `26_review_01` limits.
- **Open PR** only when explicitly requested or when a branch is complete.

---

## Summary Table

| Step | Action | Confirmation required |
|------|--------|-----------------------|
| 0 | Completeness check — all steps across all stacks done | No — implement missing steps |
| 1 | All tests green | No — fix any failures |
| 2 | Format + lint clean | No — fix any failures |
| 3 | Mandatory code review | No — fix blockers/important |
| 4 | Size + doc hygiene | No — apply extraction if needed |
| 5 | Stage changes | **Yes — wait for user** |
| 6 | Refactor pass + re-run tests | No — fix any failures |
| 7 | Commit | **Yes — propose message, wait for approval** |
