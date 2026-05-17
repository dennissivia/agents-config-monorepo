# Shell Script Headers in bin/

Repository helper scripts under `bin/` are documented entrypoints. Agents and
humans should be able to invoke any of them confidently from the first
fifteen lines of the file, without reading `usage()` at runtime or guessing
which flag combination matches the rule files.

## Core Rule

Every executable script under `bin/` must carry a standard top-of-file
comment block immediately under the shebang. The block contains three
elements in order:

1. **Purpose paragraph** — a short statement describing what the script
   does and what it does *not* do. The "does not" half is mandatory when the
   script has obvious safety-adjacent behaviors a caller might assume
   (idempotency, backup, dry-run defaults, audit logging, side-effects on
   shared infrastructure).

2. **`Examples:`** — two to four common invocations covering the modes a
   human or agent would realistically use.

3. **`Agent example:`** — a single line (or two, when the script has two
   primary modes such as a deploy script with separate backend/frontend
   targets) showing the recommended agent invocation. This is the
   invocation the agent should reach for by default.

## Format

```bash
#!/usr/bin/env bash
#
# <one-paragraph purpose statement: what it does + what it does not do>
#
# Examples:
#   ./bin/<script>.bash
#   ./bin/<script>.bash <common flag>
#
# Agent example:
#   ./bin/<script>.bash <flags that match how rule files invoke it>

set -euo pipefail
```

Notes:

- The `Agent example:` line should include flags such as `--plain` or
  `--initial-wait 0` when the agent typically wants them. This avoids the
  agent re-reading the script just to discover them.
- For scripts with two natural agent modes (e.g., `family-space-api` vs
  `family-space-app` deploy targets), include both lines under
  `Agent example:`.

## Sourced Helper Libraries

Sourced libraries (not invoked directly) follow the same shape with two
adjustments:

- The `Examples:` block shows the consumer-side usage (`source ".../foo.bash"`
  followed by the helper calls).
- The `Agent example:` line states that the file is not invoked directly and
  points at the wrapper scripts that source it.

## Enforcement

- New `bin/` scripts must include the header before merge.
- Existing scripts without the header should be retrofitted when they are
  touched for any other reason, or as a focused cleanup increment.
- Reviewers should treat a missing or partial header as a review blocker for
  any new script.

## Why

- Agents otherwise default to ad-hoc `--help` reads or generic alternatives
  when the right helper is not obvious from the script body.
- Purpose statements that name *what the script does not do* prevent
  assumptions about idempotency, backups, or audit behavior that the script
  does not actually provide.
- A single explicit `Agent example:` line keeps agent runs aligned with how
  the rule files and ADRs invoke the same script, preventing drift between
  documented and observed invocation patterns.

## Related

- ADR documenting this convention in repositories that adopt it (for
  plannit: `docs/adr/0038-shell-script-headers.md`).
