# Specification: `agents-config` Monorepo For `.agents/` Rule Sets

## Scope Of This Specification

This document specifies the structure, loading rules, numbering model, maintenance boundaries, and lifecycle rules for the `agents-config` monorepo.

This is not the usage guide. The README explains what the repository contains and how to install or use it. This specification defines how the repository must be structured and maintained.

## Core Concepts

### Shared Rules

Shared rules are reusable instruction files maintained in this repository under `rulesets/`.

Current shared rule sets:
- `rulesets/global/`
- `rulesets/dev/`

`global` is the base layer.

`dev` is a workflow layer that depends on `global`.

### Local Rules

Local rules do not live in this repository.

They belong in the host repository under `.agents.local/` and represent project-specific behavior, constraints, or overrides that should not be merged back into the shared rule repository.

### Dispatcher Layers

The active shared dispatch model has two shared layers:

1. `00_index.md`
2. `rulesets/00_index.md`

There is no per-rule-set dispatcher in the current model. Numeric filenames inside each selected rule-set folder define the active order for that rule set.

## Canonical Repository Layout

```text
agents-config/
  00_index.md
  SPEC.md
  README.md
  CHANGELOG.md
  LICENSE

  rulesets/
    00_index.md

    global/
      01_purpose-and-scope.md
      02_foundational-rules.md
      03_communication-guidelines.md
      04_ai-context-maintenance.md
      05_workflow-tools-over-builtins.md
      06_safe-operations.md

    dev/
      10_dev-workflow.md
      11_project-structure-and-deliverable-lifecycle.md
      12_workspace-worktrees.md
      20_analysis-technical-decisions.md
      21_implementation-*.md
      22_refactor-*.md
      23_validate-*.md
      24_qa-*.md
      25_persist-*.md
      26_review-*.md
      27_integrate.md

  docs/
    concept.md
    installation.md
    authoring.md
    migration.md
    internal/

  examples/
    dev-minimal/
      AGENTS.md
      .agents/

  bin/
    install-agents-config.bash
    validate-agents-config.bash
    bundle-agents-config.bash
    compile-agents.bash
    system-test-agents-config.bash

  dist/
    .gitkeep

  tmp/
    ...system test scratch space, ignored by Git...
```

## Source-Of-Truth Boundaries

- `rulesets/` is the production and runtime source of truth for shared rules.
- `docs/` is documentation, not an active instruction source by default.
- `docs/internal/` is for unpublished drafts, imported research, assessments, and legacy reference material.
- `examples/` is for published illustrative installs and compiled outputs.
- `bin/` is for maintenance, install, validation, bundling, compile, and test tooling.
- `dist/` is generated output only.
- `tmp/` is repository-local scratch space only.

## Rule-Set Semantics

### Global

`rulesets/global/` contains the minimum reusable base rules.

These files define shared defaults such as purpose, foundational rules, communication behavior, context maintenance, tool preference, and safe operations.

### Dev

`rulesets/dev/` contains shared development workflow rules.

These files define phases and expectations for analysis, implementation, validation, review, persistence, and integration work.

### Dependency Model

The current dependency model is intentionally simple:

- `global = rulesets/global`
- `dev = rulesets/global + rulesets/dev`

Dependencies are install rules, not folder nesting rules.

The installer may hard-code this relationship until a manifest is actually needed.

## Shared Versus Local Rules

Shared and local rules must remain separate.

Recommended host layout:

```text
target-repo/
  .agents/
  .agents.local/
```

Rules:
- `.agents/` contains shared reusable rules, whether installed cleanly or used as a nested clone of this repository.
- `.agents.local/` contains project-specific local rules owned by the host repository.
- Shared updates must not silently absorb local project rules.
- Local project rules must not be added back into `rulesets/` unless they are intentionally generalized into shared reusable guidance.

## Load Order

Default load order in a host repository:

1. `.agents/00_index.md`
2. `.agents/rulesets/00_index.md` in direct-clone mode, or the equivalent shared conventions represented by the installed files in clean-install mode
3. selected shared rule files in numeric order
4. `.agents.local/00_index.md`, if present
5. explicitly referenced local override files from `.agents.local/`

The clean-install model does not require copying `rulesets/00_index.md` into the target `.agents/` tree. The numbering and folder layout still follow the same specification.

## Numbering Model

Reserved numbering blocks:

| Range | Purpose |
| --- | --- |
| `00` | Dispatcher only |
| `01-09` | Shared global rules |
| `10-19` | Workflow entry and setup |
| `20-69` | Workflow stage rules |
| `70-79` | Experimental or temporary rules |
| `80-99` | Reserved |

Rules:
- numeric prefixes are part of the loading contract
- filenames should remain stable unless there is a real structural reason to rename them
- one file should cover one topic whenever practical
- adding a focused file is preferred over inflating an unrelated file

## Maintenance Rules

- shared rules belong under `rulesets/`
- local rules belong in host repositories under `.agents.local/`
- support narratives and migration notes belong under `docs/`
- unpublished or high-churn material belongs under `docs/internal/`
- generated outputs belong under `dist/`
- scratch test installs belong under `tmp/`

When changing shared rules:
- keep `00_index.md`, `rulesets/00_index.md`, and the docs aligned with the actual rule-set structure
- preserve the distinction between shared reusable guidance and local project-specific guidance
- update the example and re-run validation when structure or numbering changes

## Installer Requirements

`bin/install-agents-config.bash` must:
- accept `install-agents-config.bash <ruleset...> --target <path> [--dry-run] [--force]`
- expand implied dependencies such as `dev -> global`
- create `<target>/.agents/` if missing
- copy root `00_index.md`
- copy selected shared rule-set folders into `<target>/.agents/`
- warn before updating an existing `.agents/global` or selected shared rule-set folder
- overwrite targeted files file by file after confirmation, or immediately when `--force` is used
- never copy `docs/`, `bin/`, or `dist/` into a clean install
- never modify files outside `<target>/.agents/`

## Validation Requirements

`bin/validate-agents-config.bash` should check:
- required repository files exist
- `rulesets/00_index.md` exists
- shared rule files use valid numeric prefixes
- accidental duplicate filenames are not introduced within a rule set
- active shared instruction files do not appear outside `rulesets/`
- the documented example remains consistent with the repository model
- `docs/internal/` and `tmp/` are ignored by Git

## Bundle Requirements

`bin/bundle-agents-config.bash` should:
- generate clean installable outputs under `dist/`
- produce at least `global` and `dev` bundles
- reuse the same selection logic as the installer

## Compile Requirements

`bin/compile-agents.bash` should:
- compile the root dispatcher and selected shared rule sets into a single reference document
- default to the clone-mode active shared rule sets when no selection is provided
- optionally compile an installed `.agents/` tree into a single `AGENTS.md` file
- remain agent-agnostic and avoid vendor-specific mirror outputs by default

## System Test Requirements

`bin/system-test-agents-config.bash` should:
- run from the repository root or via its own path from anywhere
- create a scratch target under `tmp/`
- install at least the `dev` rule set into that scratch target
- verify implied dependency expansion
- verify reinstall behavior for an existing shared install
- compile the installed `.agents/` tree into `AGENTS.md`
- assert that expected files and compiled content exist

## Migration Mapping

Repository mapping:
- `agents-config-shared-global -> rulesets/global`
- `agents-config-shared-dev -> rulesets/dev`
- `agents-config-spec -> SPEC.md` plus `docs/` support material

Prominence rule:
- the active structural specification belongs at the repository root as `SPEC.md`
- the README remains the usage-oriented entry point
- unpublished assessments, drafts, and legacy reference material belong under `docs/internal/`

## Published Example

The repository includes one small real example under `examples/dev-minimal/`.

It should contain:
- `.agents/00_index.md`
- one shared global rule file
- one shared dev rule file
- one compiled `AGENTS.md`

Future examples, if added, should use meaningful domains such as writing or blogging rather than arbitrary placeholder categories.