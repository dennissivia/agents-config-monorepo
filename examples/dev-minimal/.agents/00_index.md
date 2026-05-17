# AI Instruction Dispatcher

This repository can be used directly as a `.agents/` folder when cloned into a host repository.

Production rule sets live under `rulesets/`.

Default active rule sets for direct clone mode:
- `rulesets/global/`
- `rulesets/dev/`

Load order:
1. Load this `00_index.md` first.
2. Load `rulesets/00_index.md`.
3. Load the selected rule-set files in numeric order.
4. Load `.agents.local/00_index.md` in the host repository, if present.
5. Load project-local overrides from `.agents.local/` only when explicitly referenced.

Rule-set ranges:
- `01-09`: global rules.
- `10-19`: workflow indexes and setup.
- `20-69`: workflow stage rules.
- `70-79`: experimental rules, loaded only when explicitly requested.
- `80-99`: reserved.

Inactive support folders:
- `docs/`
- `bin/`
- `dist/`

These folders are not active instruction sources unless an active instruction file explicitly references them.

Project-specific overrides belong in `.agents.local/`, not in this shared repository.