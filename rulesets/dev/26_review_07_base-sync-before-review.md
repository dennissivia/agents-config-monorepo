# Base Sync Before Review Publication

Before pushing a branch for review publication or for a PR update, check whether
it needs to be synchronized with the target branch.

## Target Branch

- Use the repository's configured default branch when one is defined.
- Otherwise use the PR target branch.
- If neither is known, use `main`.

## Required Check

Before the push that will create or update a review artifact:

1. Fetch the target branch from the remote.
2. Compare the feature branch against the updated target branch.
3. Determine whether the feature branch is behind or has diverged from the
   target branch.
4. Report the result in the persistence-prep or review handoff.

## Rebase Decision

- If the branch is already current with the target branch, proceed with the
  normal review-publication flow.
- If the branch is behind or diverged, pause and ask for explicit confirmation
  before rebasing.
- Rebase onto the target branch unless a repository-specific rule defines a
  different sync strategy.
- If rebase conflicts occur, stop and report the conflict. Do not resolve
  conflicts silently.

## Published Branch Safety

- If the branch has already been pushed, a rebase may require a history rewrite
  before the next push.
- Do not force-push or use force-with-lease unless the user explicitly approves
  that operation in the current conversation turn.
- After a successful rebase, rerun the required validation for the changed scope
  before pushing or updating the review artifact.

## Intent

Parallel feature work can move the target branch while another agent is still
working. The pre-review base-sync check keeps published review branches close to
that target branch and surfaces sync decisions before publication.
