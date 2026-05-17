# Installation

This repository supports two installation modes.

## Direct Clone

Use direct clone when you want to maintain the shared rules as a nested repository:

```bash
git clone git@github.com:dennissivia/agents-config.git .agents
```

Result:
- the whole repository becomes the host repo's `.agents/` folder
- default active rule sets are `rulesets/global/` and `rulesets/dev/`
- support material remains available under `docs/`, `bin/`, and `dist/`

## Clean Install

Use clean install when the target repository should receive only selected rule sets:

```bash
bin/install-agents-config.bash global --target .
bin/install-agents-config.bash dev --target .
bin/install-agents-config.bash global dev --target ../some-project
```

The installer copies only:
- `<target>/.agents/00_index.md`
- selected rule-set folders under `<target>/.agents/`
- implied dependencies such as `global` for `dev`

It does not copy `docs/`, `bin/`, or `dist/`.

If the target already contains `.agents/global` or another selected shared rule-set folder, the installer warns before updating matching files in place. This refresh path overwrites matching files one by one rather than replacing the whole folder blindly.

Use `--force` to skip the confirmation prompt when you intentionally want to refresh an existing shared install.

## Example

The repository publishes a small example under `examples/dev-minimal/`.

It contains:
- one dispatcher copy under `.agents/00_index.md`
- one global rule file
- one dev rule file
- one compiled `AGENTS.md`

Refresh the example with:

```bash
bin/compile-agents.bash --agents-dir examples/dev-minimal/.agents --output examples/dev-minimal/AGENTS.md
```

## System Test

Run the repository-level system test from the top directory:

```bash
bin/system-test-agents-config.bash
```

The system test installs into a scratch target under `tmp/`, compiles the installed `.agents/` tree, and verifies that the expected files and compiled output exist.

## Bundles

Generate clean installable bundles under `dist/`:

```bash
bin/bundle-agents-config.bash
```

Expected outputs include:
- `dist/global/.agents/`
- `dist/dev/.agents/`
- `dist/global.tar.gz`
- `dist/dev.tar.gz`