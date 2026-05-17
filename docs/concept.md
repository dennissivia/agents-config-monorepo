# Concept

This repository separates reusable agent rules into installable rule sets.

Why `rulesets/` exists:
- it is the production source of truth
- it avoids generic source-code naming such as `src/`
- it keeps runtime content separate from support docs and generated artifacts

Why `global` and `dev` are separate:
- `global` is the smallest useful baseline
- `dev` adds a development workflow for repositories that want deeper coding guidance
- installation can stay minimal when only the base rules are needed

Why load order matters:
- the root dispatcher establishes the shared entrypoint
- `rulesets/00_index.md` defines shared rule-set conventions
- numeric prefixes keep active files deterministic

How `.agents/` and `.agents.local/` relate:
- `.agents/` holds shared reusable rules
- `.agents.local/` holds project-specific overrides
- shared updates should not absorb project-local behavior

Why there is no per-rule-set dispatcher:
- the root dispatcher and `rulesets/00_index.md` already define the active model
- numeric filenames provide enough load order within each selected rule set
- avoiding per-rule-set dispatchers keeps the reusable rule folders simpler