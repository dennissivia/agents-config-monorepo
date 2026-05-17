# Fixes For A Feature Branch Stay On That Feature Branch

When a bug or issue is discovered **while working on a feature branch**, the
fix MUST be committed to that same feature branch. Never create a new branch
or open a new PR for a fix that belongs to an existing open feature branch.

## Rules

- If CI or local testing reveals a failure caused by code on an active feature
  branch, fix it in that feature branch. Commit the fix there, push, and let
  the existing PR pick it up.
- Never run `git checkout -b fix/...` or similar when a feature branch already
  owns the broken code. Just commit the fix directly to the feature branch.
- Never open a new PR for a fix that belongs to an existing open PR.
- If a fix is accidentally placed on a new branch, move it back: cherry-pick
  the commits onto the correct feature branch, force-close the erroneous PR
  with an explanatory comment, and delete the erroneous branch (local and
  remote).

## Intent

- Feature branches represent a complete, shippable increment — including all
  fixes needed to make that increment correct and mergeable.
- Fragmenting an increment across multiple branches and PRs creates
  unnecessary noise, extra review burden, and inconsistent history.
