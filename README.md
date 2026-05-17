# agents-config

`agents-config` is an agent-agnostic monorepo for reusable `.agents/` rule sets.

## Repository Notice

This repository is shared publicly so other people can reuse the rules and benefit from the work.

It is maintained as a curated rules repository rather than as an open design forum. The goal is to publish useful, stable rule sets, not to broadly accept new rule collections from outside contributors.

Small corrections such as typos, broken links, or clear logical conflicts in the existing rules may be considered. Larger proposals, generated contribution batches, broad rewrites, and unsolicited rule-set expansions should not be expected to be merged. Issues and pull requests may be closed after a short period when they do not fit the repository's direction or maintenance model.

In practice, this means the repository is source-available and reusable, but intentionally maintainer-curated. Time-limited issues or pull requests may be auto-closed, and AI-generated contribution batches will usually be closed unless they offer unusually high signal and clear maintainer value.

This keeps the project predictable and maintainable while still making the published rules available for others to use, adapt, and learn from.

It supports two installation modes:

1. Direct nested clone for personal authoring and maintenance.
2. Clean install for repositories that should receive only selected rule sets and no nested Git repository.

## Repository Layout

```text
agents-config/
  00_index.md
  SPEC.md
  README.md
  CHANGELOG.md
  LICENSE
  rulesets/
  docs/
  examples/
  bin/
  dist/
```

`rulesets/` is the production source of truth.

Current rule sets:
- `global`: minimal base rules.
- `dev`: development workflow rules.

Implied dependencies:
- `dev -> global`

## Direct Clone Workflow

Clone the repository directly into a host repository as `.agents/`:

```bash
git clone git@github.com:dennissivia/agents-config.git .agents
```

In this mode, the default active rule sets are `rulesets/global/` and `rulesets/dev/`.

Project-local overrides should live in `.agents.local/` in the host repository.

## Clean Install Workflow

Install selected rule sets into a target repository without carrying this repository's Git history:

```bash
bin/install-agents-config.bash global --target .
bin/install-agents-config.bash dev --target .
bin/install-agents-config.bash global dev --target ../some-project
```

The installer copies:
- root `00_index.md`
- the selected rule-set folders under `.agents/`
- implied dependencies such as `global` when `dev` is selected

If the target already contains `.agents/global` or another selected shared rule-set folder, the installer warns before updating matching files in place. `--force` skips that prompt and overwrites targeted files directly.

It does not copy `docs/`, `bin/`, or `dist/` into clean installs.

## Specification And Docs

The canonical repository specification lives in `SPEC.md`.

At a high level:
- `rulesets/global/` contains the shared base rules.
- `rulesets/dev/` contains the shared development workflow rules.
- `.agents.local/` in a host repository is for project-specific local rules and overrides.

Core support docs:
- `docs/concept.md`
- `docs/installation.md`
- `docs/authoring.md`
- `docs/migration.md`

The small published example lives under `examples/dev-minimal/`.

Unpublished imported assessments, drafts, and legacy reference material live under `docs/internal/`, which is ignored by Git.

## Tooling

Scripts in `bin/`:
- `install-agents-config.bash`
- `validate-agents-config.bash`
- `bundle-agents-config.bash`
- `compile-agents.bash`
- `system-test-agents-config.bash`

Run the validator after structural changes:

```bash
bin/validate-agents-config.bash
```

Generate clean bundles under `dist/`:

```bash
bin/bundle-agents-config.bash
```

Compile selected rule sets into a single reference document:

```bash
bin/compile-agents.bash
```

Compile an installed `.agents/` tree into a single `AGENTS.md` file:

```bash
bin/compile-agents.bash --agents-dir examples/dev-minimal/.agents --output examples/dev-minimal/AGENTS.md
```

Run the end-to-end system test from the repository root:

```bash
bin/system-test-agents-config.bash
```

## Contribution Notes

Keep active instruction content under `rulesets/`.
Keep support material under `docs/`.
Update the relevant `00_index.md` files whenever rule-set structure or load order changes.