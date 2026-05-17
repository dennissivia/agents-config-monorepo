# Persistence-Prep Handoff

This file defines the hard handoff inside the **change-persistence phase**.

It starts after quality assurance has completed and before any persistence
action such as staging, committing, pushing, or review publication.

---

## Purpose

Quality assurance proves the change is ready for persistence consideration.
The persistence-prep handoff prepares the user to decide
whether to:

- proceed to commit, push, or review publication / PR creation,
- or ask for more cleanup first.

This keeps QA and persistence decisions distinct.

---

## Mandatory Sequence

Before any persistence action:

1. Confirm quality assurance completed and summarize the quality result.
2. Verify the checkout context:
   - the work is on the expected feature branch, or
   - the work is in the user-requested worktree for that feature.
3. Inspect the changed files and identify the persistence scope.
   - Include only files related to the current work.
   - Include docs and agent rules when they are part of the work.
   - Exclude unrelated local changes.
4. Re-read the applicable persistence, commit-template, and commit-content rules.
5. Present the implemented improvement at a high level.
6. Present the proposed staging scope and commit strategy.
7. Present the proposed commit message(s) as rendered Markdown.
8. Pause for explicit persistence confirmation.

Do not commit, push, start review publication, or resolve review comments
before this handoff and approval.


---

## What To Present

The persistence-prep handoff should be concise and decision-oriented.

Include:

1. What the completed slice improved.
2. The suggested commit message(s).
3. Any persistence-phase caveat (for example, repositories where shared rule files have
   their own remote and must not be committed by the agent).
4. The explicit pause for confirmation.

The commit message proposal belongs here, not in the QA phase.

When proposing commit messages or PR body content:

- Show the rendered commit message in chat before any git command is run.
- Keep the `Quality assurance` or equivalent quality section outcome-focused.
- Do **not** include literal CLI commands in commit messages or PR bodies.
- Do **not** include file inventories there unless the user explicitly wants
  them.

---

## Relationship To Quality Assurance

- The repository's quality-gate rule defines the concrete gates.
- The change-review-and-size-assessment step contributes the QA review and size
  result.
- This file owns the hard handoff after quality assurance.

If quality assurance has not completed, do not use this file as if persistence
work may begin.
