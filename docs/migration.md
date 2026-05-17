# Migration

This monorepo consolidates three prior sources.

Repository mapping:
- `agents-config-shared-global` becomes `rulesets/global/`
- `agents-config-shared-dev` becomes `rulesets/dev/`
- `agents-config-spec` contributes the canonical `SPEC.md` and supporting material under `docs/`

Recommended migration path for existing users:

1. Replace direct references to the old shared repositories with this monorepo.
2. For nested-clone workflows, clone this repository as `.agents/`.
3. For clean installs, use `bin/install-agents-config.bash` with the desired rule sets.
4. Move project-specific overrides into `.agents.local/` if they previously lived inside shared config directories.

Shared versus local guidance after migration:
- `rulesets/global/` is the shared base layer.
- `rulesets/dev/` is the shared workflow layer.
- `.agents.local/` in the host repository is the place for project-specific local rules.

Repository owner follow-up:
- archive or redirect the old shared repositories once consumers have a migration path
- point old README files to this repository and to the new rule-set paths