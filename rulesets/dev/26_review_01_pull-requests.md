# Review Publication And Pull Requests

Pull requests are the primary review artifact for branch-based work.

This file defines how a persisted branch is published for review and how that
review artifact is kept accurate while the branch evolves.

---

## Purpose

The review phase starts only after the code has already been persisted through
commit and, when needed, branch push.

This phase is responsible for:

- deciding whether a pull request should be opened now,
- creating the pull request,
- shaping the review narrative,
- keeping the review artifact aligned with later commits,
- respecting size, safety, and publication rules.

---

## Review Publication Preconditions

Before opening a pull request:

1. The persistence workflow is complete for the current slice.
2. Required validation gates have already passed.
3. The branch contains only intended changes.
4. The branch is based on the correct target branch.
5. The user has approved review publication.

### Versioned increment rule

When the branch contains the **last increment of a versioned release**, confirm
before opening the pull request that the codebase already includes the intended
version bump for each changed application surface.

The reviewed and merged code should already carry the release version. Do not
plan a separate follow-up just to bump the version after review.

---

## Review Artifact Quality

The pull request is the final narrative reviewers will use.

It must:

- explain the user or system outcome,
- summarize the overall solution,
- capture major trade-offs or risks,
- stay aligned with the current branch state.

When multiple commits exist on the branch:

- keep the PR body cohesive across the full branch,
- update the PR body when later commits change scope, behavior, risk, or
  accepted limitations,
- do not let the PR body drift behind the branch.

---

## Review Publication Rules

- Prefer the repository's standard PR tooling for publication.
- Create a normal PR by default unless the user explicitly wants draft or the
  branch is intentionally incomplete.
- Do not publish a review artifact with known failing required checks unless the
  purpose of the review is explicitly to discuss those failures.
- Do not merge the PR. Merging is always a human action.

---

## Review Size And Coherence

Review artifacts must remain reviewable.

Soft limit:
- about 2,000 lines of total churn per PR

If the branch exceeds that threshold:

1. surface the size to the user,
2. assess whether the branch is still one coherent vertical slice,
3. recommend splitting only when the work is genuinely separable.

This is a review checkpoint, not an automatic blocker.

---

## Ongoing Review Maintenance

When additional commits are added to an open PR:

1. re-check whether the PR body is still accurate,
2. include any needed PR-body adjustment in the same approval handoff as the
   new commit message,
3. keep the review artifact current before or with the new push.

---

## Communication After Publication

After creating or materially updating a PR, report:

- the review link,
- what the branch delivers,
- what reviewers should focus on,
- anything still uncertain or risky.
