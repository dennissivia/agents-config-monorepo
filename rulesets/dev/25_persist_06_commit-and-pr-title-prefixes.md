# Commit and PR Title Prefixes

Commit subjects and PR titles use a small capitalized prefix vocabulary to make
intent obvious without adopting Conventional Commits.

This is the standard convention. Do not substitute Conventional Commit types
(`feat:`, `fix:`, `docs:`) or abbreviated forms (`Feat:`, `Fix:`) under any
circumstances.

Branch names use a different convention: lowercase long-form slash prefixes
such as `feature/...` or `bugfix/...`. The slash form belongs to branch names
only.

---

## Required Prefixes

Use exactly one of these capitalized title prefixes:

- `Feature:` for user-facing functionality and behavior changes
- `Bugfix:` for bug fixes and production regressions
- `Tech:` for internal technical work, refactors, infrastructure, quality, or
  non-user-facing engineering improvements
- `Docs:` for documentation, ADR, roadmap, README, or rule-only changes

This prefix belongs in the commit subject and the PR title.

## Required Emoji

Every commit subject and PR title must lead with a fitting emoji. The emoji
visually conveys change type and improves scan-ability. Examples:

```markdown
🔐 Feature: Add passkey sign-in to auth page
🐛 Bugfix: Fix mobile overview layout regressions
🛠️ Tech: Address passkey review follow-ups
📝 Docs: Document repository title prefix convention
```

Choose the emoji by semantic fit. Do not default to the same emoji when a more
accurate one exists for the actual change.

---

## Title Shape

```
<emoji> <Prefix>: <imperative subject>
```

Rules:

- Use the colon form in titles. Slash prefixes such as `feature/` or `bugfix/`
  are for branch names only and never appear in commit subjects or PR titles.
- Use long-form prefixes. Do not use abbreviated forms such as `Feat:`,
  `Fix:`, or `fix:`.
- Keep the subject after the prefix imperative / present tense (`add`, not
  `added`).
- Choose the prefix by the **primary purpose** of the commit, not by every
  file touched.

---

## Exception: Review-Fix Commits

Review-fix commits follow the dedicated review-fix commit-message template and
do not use these title prefixes. Keep the leading emoji, but omit `Feature:`,
`Bugfix:`, `Tech:`, and `Docs:` for review-fix subjects.

---

## Notes

- These are repository conventions, not an external standard.
- Do not use Conventional Commit types such as `feat:`, `fix:`, or `docs:`.
- Do not use slash prefixes such as `feature/`, `bugfix/`, or `tech/` in commit
  subjects or PR titles.
- Use the existing structured commit-message templates and emoji rule together
  with this prefix convention.
