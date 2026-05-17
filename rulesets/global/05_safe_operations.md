# Safe Operations and Destructive Actions

These rules ensure safe collaboration and prevent accidental data loss or git history corruption.

---

## Critical: Destructive Operations Require Confirmation

**HARD STOP - Always ask before:**

- Any git operation that modifies history (rebase, reset, force push, branch deletion)
- Any file or directory deletion
- Any mass operation affecting multiple files
- Any operation that might cover meaningful changes with noise
- Any operation that significantly impacts git history traceability

**Rule:** Every destructive operation requires explicit user confirmation before execution.

---

## Mass Operations - Double Confirmation Required

**Mass operations include:**

- Bulk file modifications (10+ files)
- Repository-wide formatting/linting
- Bulk deletions or moves
- Operations that generate high churn in git diff
- Any operation that might bury functional changes under formatting noise

**Requirements:**

1. **HARD STOP** before any mass operation
2. Clearly describe what will be modified and why
3. Wait for explicit user confirmation
4. Never proceed with "I assume this is okay"

---

## Uncommitted Changes - Protect Work in Progress

**Before any mass operation:**

1. Check for uncommitted or unstaged files: `git status`
2. If working directory is **not clean**:
   - **HARD STOP**
   - Inform user: "Working directory has uncommitted changes"
   - Recommend: "Commit current work before proceeding with [operation]"
   - Wait for user decision
3. Only proceed after user explicitly confirms or commits

**Rationale:** Mass operations on dirty working directories make it impossible to separate meaningful changes from operation noise in git history.

---

## Examples of Operations Requiring Confirmation

### Always Require Confirmation:
- `git reset --hard`
- `git rebase`
- `git push --force`
- `rm -rf` (any recursive deletion)
- Mass file formatting (spotless, prettier, etc.)
- Dependency updates affecting multiple files
- Refactoring across multiple files
- Branch deletion

### Safe Without Confirmation:
- Single file edits within scope of task
- Running tests
- Reading files
- Checking status (`git status`, `git log`)

---

## Violations and Recovery

**If you realize you performed a destructive operation without confirmation:**

1. **STOP IMMEDIATELY**
2. Acknowledge the mistake
3. Describe current state clearly
4. Ask user how to proceed
5. **Do not attempt recovery without permission** - recovery itself is destructive

---

**Remember:** When in doubt, ask. User confirmation is free; recovering from mistakes wastes time and money.
