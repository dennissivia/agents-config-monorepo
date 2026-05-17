# Plan-Only Work Stays On Main

Plan drafting, roadmap updates, and implementation-plan writing do not require
a feature branch by default.

## Rules

- Stay on `main` for plan-only work unless the user explicitly wants a separate
  branch.
- Create a feature branch when implementation begins, or when the planning work
  is already bundled into an implementation slice.
- The feature branch must exist **before the first implementation edit**. Do
  not start coding, testing implementation changes, or preparing a PR from
  `main` and plan to branch later.
- If implementation accidentally starts on `main`, stop and create the feature
  branch immediately from the current dirty state before the next edit,
  QA pass, or persistence-prep step.
- If a branch was created too early for plan-only work, either move back to
  `main` or rename the branch to match the first actual implementation slice
  once that slice is chosen.

## Intent

- Avoid branch overhead for docs and plans that are still shaping the work.
- Keep branch names tied to shippable implementation slices rather than vague
  planning phases.
- Keep all implementation, QA, and review-prep work anchored to a
  reviewable feature branch instead of retroactively moving dirty
  implementation off `main`.
