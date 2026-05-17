# Authoring

## Active Content Rules

- Put reusable active instruction files under `rulesets/`.
- Use numeric prefixes for active rule files.
- Keep support documentation out of the active load path by default.
- Use the root `00_index.md` plus `rulesets/00_index.md` as the shared dispatch layer.

## Numeric Ranges

- `00`: dispatcher only
- `01-09`: global rules
- `10-19`: workflow indexes and setup
- `20-69`: workflow stage rules
- `70-79`: experimental or WIP
- `80-99`: reserved

## Adding A Rule Set

1. Create `rulesets/<name>/`.
2. Add active files with numeric prefixes.
3. Update `rulesets/00_index.md` if dependency or naming guidance changes.
4. Update the installer if the new rule set implies dependencies.
5. Update `README.md` and `docs/installation.md` if the new rule set should be user-visible.

For future examples or optional expansions, use meaningful domains such as `writing` or `blogging` rather than arbitrary placeholder categories.

## Editing Existing Rules

- Prefer adding focused files over inflating broad catch-all files.
- Avoid duplicating `global` content in workflow-specific rule sets.
- Preserve filenames when possible so installs and bundles remain stable.
- Re-run validation after structural changes.

## Internal Material

- Put unpublished drafts, assessments, and legacy reference material under `docs/internal/`.
- Keep `docs/internal/` ignored by Git so the published repository stays focused on the canonical docs and examples.
- Use `tmp/` for repo-local scratch installs and system-test outputs; keep it ignored by Git.