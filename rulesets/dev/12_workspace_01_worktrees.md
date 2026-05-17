# Worktree Checkout Mode

Worktrees are supported for parallel agent work, but they are not the default.
The default checkout mode remains the current working tree plus a regular
feature branch.

## When To Use A Worktree

- Use a worktree only when the user explicitly requests worktree-based work or
  parallel agent work that should use isolated checkouts.
- Do not switch to worktrees only because a worktree container exists.
- Worktree mode changes only the checkout location. The planning,
  implementation, quality assurance, persistence-prep, review, and
  integration/deployment workflow stays the same.

## Worktree Container Selection

When worktree mode is requested, check the repository root for an existing
container in this order:

1. `.wt/`
2. `.worktrees/`
3. `worktrees/`

Use the first existing container in that order.

If none of those containers exists, pause and ask the user where the worktree
should be created before creating a new container or falling back to a regular
checkout.

## Branch And Directory Rules

- Use the same branch naming rules as the standard workflow:
  `feature/<description>`, `bugfix/<description>`, `tech/<description>`, or
  `docs/<description>`.
- Do not invent worktree-specific branch prefixes.
- Derive the worktree directory name from the branch description using safe path
  characters: lowercase letters, numbers, and hyphens.
- Before creating the worktree, state the selected container, target directory,
  base branch, and feature branch.
- Creating a worktree with a new branch is a branch-creation action; follow the
  same confirmation and safety rules that apply to a regular feature branch.

## Parallel Work Safety

- Each parallel feature or fix gets its own branch and its own worktree.
- Do not use a shared worktree for multiple active features.
- Do not use worktrees to bypass branch-size checks, QA gates,
  persistence-prep handoffs, commit approval, push approval, review approval,
  or integration/deployment approvals.
