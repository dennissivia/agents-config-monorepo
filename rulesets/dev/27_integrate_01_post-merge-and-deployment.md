# Post-Merge Integration And Deployment

This file defines the workflow that starts after a reviewed branch is merged or
otherwise integrated into the mainline.

It covers two concerns:

- local repository integration after merge
- optional manual or locally triggered deployment

---

## Purpose

The review phase ends when the branch is merged, closed, or otherwise no longer
waiting on review work.

The integration/deployment phase ensures:

- the local workspace is synchronized back to the integration branch,
- temporary feature-branch state is cleaned up safely,
- manual deployment is considered when the merged change affects runtime code,
- temporary local work is preserved and restored safely around deployment.

---

## Phase A: Post-Merge Integration

When merge or close is detected:

1. Report the state clearly.
   - Example: "The review is merged. Starting post-merge integration."
2. Check the working tree.
   - If the working tree is not clean, stash the current local changes before
     switching branches.
   - Use a named stash message.
3. Switch back to the integration branch.
   - Use the repository default branch unless repository rules specify a different
     integration target.
4. Fetch and update the integration branch.
   - Prefer fast-forward update when possible.
   - If the repository requires a different sync strategy, follow that rule.
   - Hard stop on conflicts; ask the user.
5. Remove the merged feature branch locally when safe.
   - Try the non-destructive branch-delete path first.
   - If the delete fails because of squash-merge history shape, verify the changes
     are already contained in the integration branch before forcing branch removal.
   - If containment is unclear, stop and ask the user.
6. Restore any stash created by this cleanup flow.
   - Restore only the stash created for this integration pass.
   - Do not pop unrelated older stashes.
7. Confirm the clean integrated state.

Outcome:
- local workspace is back on the integration branch
- merged feature branch is removed locally when safe
- local in-progress work is restored if it was stashed for this flow

---

## Phase B: Deployment Decision

After post-merge integration, determine whether deployment action is required.

### No deployment needed

No deployment step is required when any of the following is true:

- the merged change is documentation-only or otherwise non-runtime
- automated deployment already handles publication for this repository
- repository workflow explicitly says no local/manual deployment happens here

In these cases, state that clearly and end the phase.

### Manual or locally triggered deployment needed

If the repository uses local/manual deployment commands for merged runtime code:

1. Tell the user deployment is applicable.
2. Explain why deployment is needed now.
3. Ask for explicit approval before running deployment.

Example:

> "The merged change affects runtime code and this repository uses a local
> deployment flow. Should I deploy it now?"

---

## Deployment Safety Rules

Before running a local/manual deployment command:

1. Check whether the working tree currently contains local code changes.
2. If it does, stash those changes before deployment.
3. Run the repository-defined deployment command only after user approval.
4. If deployment fails:
   - stop,
   - report the failure clearly,
   - preserve enough state for retry,
   - restore any temporary stash only when it is safe to do so.
5. After a successful deployment, restore any stash created specifically for the
   deployment step.

Do not invent deployment commands in this file. The repository's local rules or
runbooks define the actual deployment command and target environment.

---

## Shared Workflow Expectations

- Deployment approval is always a human handoff.
- Stashing around deployment is for preserving local work, not for hiding
  uncommitted feature work from the user.
- If deployment touches external systems, validate the effective target and
  parameters with the user before execution.
- If the repository has automated deployment and no local action is required,
  report that and stop rather than simulating a deployment step.

---

## Relationship To Other Phases

- Phase 8 (`25_persist_*`) persists the approved code change.
- Phase 9 (`26_review_*`) publishes and iterates on review.
- This file covers what happens after merge/close is detected.
