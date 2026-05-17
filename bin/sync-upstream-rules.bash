#!/usr/bin/env bash

# Syncs numbered rule files from upstream legacy repos into rulesets/dev and rulesets/global.
# Pulls from origin/main in each source repo unless --no-pull is given.
# Only [0-9][0-9]_*.md files are synced; README, AGENTS_CODING_SPEC, etc. are excluded.
# Stale rule files present in the destination but absent in the source are deleted.
#
# Usage:
#   sync-upstream-rules.bash [--dry-run] [--no-pull]
#
# Options:
#   --dry-run    Show what would change without writing anything.
#   --no-pull    Skip git pull in source repos; use their current local state.
#
# Source paths can be overridden via environment variables:
#   AGENTS_CONFIG_SHARED_DEV    (default: ../agents-config-shared-dev)
#   AGENTS_CONFIG_SHARED_GLOBAL (default: ../agents-config-shared-global)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECTS_DIR="$(dirname "$REPO_ROOT")"

SRC_DEV="${AGENTS_CONFIG_SHARED_DEV:-$PROJECTS_DIR/agents-config-shared-dev}"
SRC_GLOBAL="${AGENTS_CONFIG_SHARED_GLOBAL:-$PROJECTS_DIR/agents-config-shared-global}"
DST_DEV="$REPO_ROOT/rulesets/dev"
DST_GLOBAL="$REPO_ROOT/rulesets/global"

dry_run=0
no_pull=0

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

usage() {
  sed -n '3,17p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

while (($# > 0)); do
  case "$1" in
    --dry-run) dry_run=1 ;;
    --no-pull) no_pull=1 ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
  shift
done

[[ -d "$SRC_DEV" ]] || fail "dev source not found: $SRC_DEV"
[[ -d "$SRC_GLOBAL" ]] || fail "global source not found: $SRC_GLOBAL"
[[ -d "$DST_DEV" ]] || fail "dev destination not found: $DST_DEV"
[[ -d "$DST_GLOBAL" ]] || fail "global destination not found: $DST_GLOBAL"

pull_repo() {
  local label="$1"
  local path="$2"
  printf 'Pulling %s... ' "$label"
  git -C "$path" pull
}

sync_ruleset() {
  local label="$1"
  local src="$2"
  local dst="$3"

  local -a rsync_args=(
    -avz
    --itemize-changes
    --delete
    --include='[0-9][0-9]_*.md'
    --exclude='*'
  )
  local suffix=""
  if (( dry_run )); then
    rsync_args+=(--dry-run)
    suffix=" (dry run)"
  fi

  printf '\nSyncing %s%s...\n' "$label" "$suffix"
  rsync "${rsync_args[@]}" "$src/" "$dst/"
}

if (( ! no_pull )); then
  pull_repo "agents-config-shared-dev" "$SRC_DEV"
  pull_repo "agents-config-shared-global" "$SRC_GLOBAL"
fi

sync_ruleset "dev" "$SRC_DEV" "$DST_DEV"
sync_ruleset "global" "$SRC_GLOBAL" "$DST_GLOBAL"

if (( dry_run )); then
  printf '\nDry run complete. Run without --dry-run to apply.\n'
else
  printf '\nSync complete.\n'
fi
