#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECTS_DIR="$(dirname "$REPO_ROOT")"

SRC_DEV="${AGENTS_CONFIG_SHARED_DEV:-$PROJECTS_DIR/agents-config-shared-dev}"
SRC_GLOBAL="${AGENTS_CONFIG_SHARED_GLOBAL:-$PROJECTS_DIR/agents-config-shared-global}"
DST_DEV="$REPO_ROOT/rulesets/dev"
DST_GLOBAL="$REPO_ROOT/rulesets/global"

# Pattern matching numbered rule files only — excludes README, AGENTS_CODING_SPEC, etc.
RULE_PATTERN='[0-9][0-9]_*.md'

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

show_diff_for_ruleset() {
  local label="$1"
  local src="$2"
  local dst="$3"

  local -a added=() changed=() deleted=()

  while IFS= read -r -d '' f; do
    local name
    name="$(basename "$f")"
    if [[ ! -f "$dst/$name" ]]; then
      added+=("$name")
    elif ! diff -q "$src/$name" "$dst/$name" > /dev/null 2>&1; then
      changed+=("$name")
    fi
  done < <(find "$src" -maxdepth 1 -name "$RULE_PATTERN" -print0 | sort -z)

  while IFS= read -r -d '' f; do
    local name
    name="$(basename "$f")"
    if [[ ! -f "$src/$name" ]]; then
      deleted+=("$name")
    fi
  done < <(find "$dst" -maxdepth 1 -name "$RULE_PATTERN" -print0 | sort -z)

  printf '\n=== %s ===\n' "$label"

  if [[ ${#added[@]} -eq 0 && ${#changed[@]} -eq 0 && ${#deleted[@]} -eq 0 ]]; then
    printf 'No changes.\n'
    return
  fi

  if [[ ${#added[@]} -gt 0 ]]; then
    printf '\nNEW:\n'
    printf '  + %s\n' "${added[@]}"
  fi

  if [[ ${#deleted[@]} -gt 0 ]]; then
    printf '\nSTALE (would be deleted):\n'
    printf '  - %s\n' "${deleted[@]}"
  fi

  if [[ ${#changed[@]} -gt 0 ]]; then
    printf '\nCHANGED:\n'
    for name in "${changed[@]}"; do
      printf '\n--- %s ---\n' "$name"
      diff -u "$dst/$name" "$src/$name" || true
    done
  fi
}

[[ -d "$SRC_DEV" ]] || fail "dev source not found: $SRC_DEV"
[[ -d "$SRC_GLOBAL" ]] || fail "global source not found: $SRC_GLOBAL"
[[ -d "$DST_DEV" ]] || fail "dev destination not found: $DST_DEV"
[[ -d "$DST_GLOBAL" ]] || fail "global destination not found: $DST_GLOBAL"

show_diff_for_ruleset "dev" "$SRC_DEV" "$DST_DEV"
show_diff_for_ruleset "global" "$SRC_GLOBAL" "$DST_GLOBAL"
