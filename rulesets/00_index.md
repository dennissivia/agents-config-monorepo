# Rule-Set Index

`rulesets/` contains the production rule sets that can be loaded directly in clone mode or copied into a clean `.agents/` install.

Rule-set conventions:
- Each direct child folder is a reusable rule set.
- Rule-set files are loaded in numeric order after the root dispatcher and this index.
- Dependencies are installer rules, not folder nesting rules.
- Only files inside selected rule-set folders are active by default.

Naming guidance:
- Use numeric prefixes for active rule files.
- Keep files scoped to one topic.
- Prefer adding files over renumbering existing files.

Initial dependency rules:
- `dev` requires `global`.