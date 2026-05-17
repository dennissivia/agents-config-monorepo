# `.agents/` Maintenance (Global)

The `.agents/` rules are a living system that defines expectations for behavior, workflow, quality, and communication. AI agents must keep it consistent and up to date.

---

## When Starting Work
- Re-read `.agents/` before any substantial change.
- Use it as the primary anchor if the conversational context resets.
- Ask the user if unclear how to apply a rule to the current task.

## Rule Loading Commands
- When loading `.agents/` rules from disk, use filesystem traversal commands such as
  `find` or `ls`.
- Do not use `rg --files` as the source of truth for rule discovery. Ripgrep obeys
  ignore rules by default and can omit ignored, nested, or externally managed rule
  folders that still belong to the active instruction set.
- If a repository has shared, vendored, symlinked, or nested rule folders, follow
  links intentionally when needed and exclude embedded `.git/` internals from the
  rule-file list.

---

## When the Human Hands Back Work
- When the human hands work back after a pause, merge, PR review, or interrupted
  turn, re-read the compiled `.agents/` rules before continuing.
- This applies even when the agent has recent conversational context. The
  compiled rules are the current workflow contract and must be refreshed before:
  - implementing more code,
  - processing PR review feedback,
  - running persistence or review-publication operations,
  - changing quality-assurance or workflow rules.
- After re-reading, continue from the repository state and the active workflow
  phase. Do not skip required triage, quality assurance,
  persistence-prep confirmation, or review steps.

---

## When Learning New Preferences
- Update the relevant `.agents/` file immediately.
- Keep the numeric structure stable: add new files instead of renumbering existing ones.
- If scopes diverge (shared/vendor/local), document precedence in `00_index.md`.

---

## When Maintaining Consistency
- Avoid duplicating rules in multiple places—reference patterns instead.
- When rules interact, specify which has priority (dispatcher guidance or closest file wins).
- Mark unclear or ambiguous rules for clarification rather than guessing.

---

## When the Rules Grow
- Keep content concise and high-signal.
- Remove outdated information proactively.
- `.agents/` must remain easy to read even in token-constrained scenarios.

---

Use these rules to maintain stable behavior across conversations, sessions, and repositories.
