#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RULESETS_DIR="$REPO_ROOT/rulesets"

usage() {
  cat <<'EOF'
Usage:
  compile-agents.bash [ruleset...] [--output <file>]
  compile-agents.bash --agents-dir <path> [--output <file>]

Examples:
  compile-agents.bash
  compile-agents.bash global --output AGENTS.md
  compile-agents.bash dev --output /tmp/AGENTS.md
  compile-agents.bash --agents-dir examples/dev-minimal/.agents --output examples/dev-minimal/AGENTS.md
EOF
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

declare -a requested_rulesets=()
declare -a selected_rulesets=()
declare -A seen_rulesets=()

output_file="$REPO_ROOT/AGENTS.md"
agents_dir=""

while (($# > 0)); do
  case "$1" in
    --output)
      shift
      (($# > 0)) || fail "--output requires a path"
      output_file="$1"
      ;;
    --agents-dir)
      shift
      (($# > 0)) || fail "--agents-dir requires a path"
      agents_dir="$1"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      fail "unknown option: $1"
      ;;
    *)
      requested_rulesets+=("$1")
      ;;
  esac
  shift
done

if [[ -n "$agents_dir" && ${#requested_rulesets[@]} -gt 0 ]]; then
  fail "ruleset arguments cannot be combined with --agents-dir"
fi

if [[ -z "$agents_dir" && ${#requested_rulesets[@]} == 0 ]]; then
  requested_rulesets=(global dev)
fi

resolve_ruleset() {
  local ruleset="$1"

  [[ -d "$RULESETS_DIR/$ruleset" ]] || fail "unknown ruleset: $ruleset"
  [[ -n "${seen_rulesets[$ruleset]:-}" ]] && return 0

  case "$ruleset" in
    dev)
      resolve_ruleset global
      ;;
  esac

  seen_rulesets[$ruleset]=1
  selected_rulesets+=("$ruleset")
}

mkdir -p "$(dirname "$output_file")"

cat > "$output_file" <<'EOF'
# Compiled AI Instructions

This file is generated from the `agents-config` monorepo.

Source of truth:
- `00_index.md`
- `rulesets/`

Included rule sets:
EOF

append_file() {
  local file_path="$1"
  printf '## %s\n\n' "${file_path#$REPO_ROOT/}" >> "$output_file"
  cat "$file_path" >> "$output_file"
  printf '\n\n' >> "$output_file"
}

if [[ -n "$agents_dir" ]]; then
  agents_dir="$(cd "$agents_dir" && pwd)"
  [[ -d "$agents_dir" ]] || fail "unknown agents dir: $agents_dir"
  [[ -f "$agents_dir/00_index.md" ]] || fail "agents dir is missing 00_index.md"

  printf -- '- `installed-agents`\n' >> "$output_file"
  printf '\n---\n\n' >> "$output_file"

  append_file "$agents_dir/00_index.md"
  while IFS= read -r source_file; do
    append_file "$source_file"
  done < <(find "$agents_dir" -mindepth 2 -maxdepth 2 -type f -name '*.md' | sort)
else
  for ruleset in "${requested_rulesets[@]}"; do
    resolve_ruleset "$ruleset"
  done

  printf -- '- `%s`\n' "${selected_rulesets[@]}" >> "$output_file"
  printf '\n---\n\n' >> "$output_file"

  append_file "$REPO_ROOT/00_index.md"
  append_file "$RULESETS_DIR/00_index.md"

  for ruleset in "${selected_rulesets[@]}"; do
    while IFS= read -r source_file; do
      append_file "$source_file"
    done < <(find "$RULESETS_DIR/$ruleset" -maxdepth 1 -type f -name '*.md' | sort)
  done
fi

printf 'Generated %s\n' "$output_file"