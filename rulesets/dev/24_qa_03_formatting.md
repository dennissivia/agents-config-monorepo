# Formatting and Linting - Destructive Operation Rules

Formatting and linting tools modify code structure without changing functionality. They are **destructive operations** requiring special handling.

---

## Critical Rule: Formatting is Destructive

**Linting and formatting tools are considered destructive operations** and must follow all global rules for destructive operations (see `global/05_safe_operations.md`).

**Why formatting is destructive:**

- Modifies every line it touches
- Creates massive git diffs spanning hundreds of files
- Buries functional changes under formatting noise
- Makes code review impossible
- Destroys git history traceability
- Cannot be separated from real changes once applied

---

## Prerequisites for Formatting Operations

### 1. Clean Repository Required

**Before running any formatter (spotless, prettier, eslint --fix, etc.):**

1. Run `git status`
2. Verify working directory is **completely clean**:
   - No unstaged changes
   - No uncommitted changes
   - All meaningful work is committed

**If repository is NOT clean:**

- **HARD STOP**
- Tell user: "Repository has uncommitted changes. Formatting would mix with existing work."
- Recommend: "Commit current work first, then run formatting in separate commit"
- **DO NOT proceed** without explicit user confirmation

### 2. User Confirmation Required

Even on clean repository:

- **HARD STOP** before running formatter
- Describe what will be formatted (file count, scope)
- Ask: "Ready to run [formatter] on [N] files? This will be a separate commit."
- Wait for explicit "yes" or "proceed"

---

## Correct Workflow for Formatting

### ✅ Good: Formatting on Clean Repository

```bash
# 1. Verify clean state
git status  # No changes

# 2. Ask user permission
# "Ready to run spotless:apply on 102 files?"

# 3. Run formatter
./mvnw spotless:apply

# 4. Commit formatting separately
git add -A
git commit -m "style: apply spotless formatting (AOSP style)"
```

### ❌ Bad: Formatting on Dirty Repository

```bash
# 1. Working directory has uncommitted feature work
git status  # Shows 50 modified files

# 2. Agent runs formatter without asking
./mvnw spotless:apply  # ⚠️ DISASTER

# 3. Result: Feature changes + formatting changes inseparable
git diff  # Shows 150 modified files, impossible to review
```

---

## Formatting Tools (non-exhaustive list)

These tools are **destructive** and require clean repository + confirmation:

### Backend (Java/Spring)
- `./mvnw spotless:apply`
- `./mvnw spotless:check`
- Any formatter plugin

### Frontend (JavaScript/TypeScript)
- `npm run format` (prettier)
- `npm run lint --fix` (eslint with auto-fix)
- `npx prettier --write`

### General
- Any IDE "format all files" action
- Any bulk code reformatting

---

## When Formatting Goes Wrong

**If you already ran a formatter on dirty repository:**

1. **STOP IMMEDIATELY** - do not make more changes
2. **DO NOT commit** - this mixes feature + formatting
3. **DO NOT attempt recovery** without user permission
4. Acknowledge mistake to user
5. Describe current state (how many files affected)
6. Ask user how to proceed
7. Wait for instructions

**Recovery is also destructive** - get permission first.

---

## Summary

- Formatting is destructive
- Always verify clean repository first (`git status`)
- Always ask user permission before formatting
- Never format on dirty working directory
- When in doubt, HARD STOP and ask

Following these rules prevents disasters like mixing feature work with formatting noise.
