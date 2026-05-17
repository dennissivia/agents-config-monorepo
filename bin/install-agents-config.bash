#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RULESETS_DIR="$REPO_ROOT/rulesets"

usage() {
  cat <<'EOF'
Usage:
  install-agents-config.bash <ruleset...> --target <path> [--dry-run] [--force]

Examples:
  install-agents-config.bash global --target .
  install-agents-config.bash dev --target .
  install-agents-config.bash global dev --target ../some-project
  install-agents-config.bash dev --target . --dry-run
  install-agents-config.bash dev --target . --force
EOF
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

declare -a requested_rulesets=()
declare -a selected_rulesets=()
declare -a implied_rulesets=()
declare -a copied_files=()
declare -a skipped_files=()
declare -a existing_ruleset_dirs=()

declare -A seen_rulesets=()

target_path=""
dry_run=0
force=0
overwrite_existing=0

while (($# > 0)); do
  case "$1" in
    --target)
      shift
      (($# > 0)) || fail "--target requires a path"
      target_path="$1"
      ;;
    --dry-run)
      dry_run=1
      ;;
    --force)
      force=1
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

((${#requested_rulesets[@]} > 0)) || fail "at least one ruleset is required"
[[ -n "$target_path" ]] || fail "--target is required"

resolve_ruleset() {
  local ruleset="$1"

  [[ -d "$RULESETS_DIR/$ruleset" ]] || fail "unknown ruleset: $ruleset"
  [[ -n "${seen_rulesets[$ruleset]:-}" ]] && return 0

  case "$ruleset" in
    dev)
      if [[ -z "${seen_rulesets[global]:-}" ]]; then
        implied_rulesets+=("global")
      fi
      resolve_ruleset global
      ;;
  esac

  seen_rulesets[$ruleset]=1
  selected_rulesets+=("$ruleset")
}

for ruleset in "${requested_rulesets[@]}"; do
  resolve_ruleset "$ruleset"
done

target_abs="$(cd "$target_path" && pwd)"
agents_dir="$target_abs/.agents"

confirm_overwrite() {
  local response

  if [[ $dry_run -eq 1 ]]; then
    overwrite_existing=1
    return 0
  fi

  printf 'Warning: existing shared rule-set folders were found in %s\n' "$agents_dir" >&2
  printf 'The following folders will be updated file by file and matching files will be overwritten:\n' >&2
  printf '  %s\n' "${existing_ruleset_dirs[@]}" >&2
  printf 'This can be destructive if the target contains local edits in shared rule-set folders. Continue? [y/N] ' >&2
  read -r response

  case "$response" in
    y|Y|yes|YES)
      overwrite_existing=1
      ;;
    *)
      fail "install cancelled"
      ;;
  esac
}

for ruleset in "${selected_rulesets[@]}"; do
  if [[ -d "$agents_dir/$ruleset" ]]; then
    existing_ruleset_dirs+=(".agents/$ruleset")
  fi
done

if [[ ${#existing_ruleset_dirs[@]} -gt 0 ]]; then
  if [[ $force -eq 1 ]]; then
    overwrite_existing=1
  else
    confirm_overwrite
  fi
fi

copy_file() {
  local source_file="$1"
  local destination_file="$2"
  local destination_dir
  destination_dir="$(dirname "$destination_file")"

  if [[ -e "$destination_file" && $force -eq 0 && $overwrite_existing -eq 0 ]]; then
    skipped_files+=("${destination_file#$target_abs/}")
    return 0
  fi

  copied_files+=("${destination_file#$target_abs/}")

  if [[ $dry_run -eq 1 ]]; then
    return 0
  fi

  mkdir -p "$destination_dir"
  cp "$source_file" "$destination_file"
}

if [[ $dry_run -eq 0 ]]; then
  mkdir -p "$agents_dir"
fi

copy_file "$REPO_ROOT/00_index.md" "$agents_dir/00_index.md"

for ruleset in "${selected_rulesets[@]}"; do
  while IFS= read -r source_file; do
    relative_path="${source_file#$RULESETS_DIR/}"
    copy_file "$source_file" "$agents_dir/$relative_path"
  done < <(find "$RULESETS_DIR/$ruleset" -type f | sort)
done

printf 'Target: %s\n' "$agents_dir"

if ((${#existing_ruleset_dirs[@]} > 0)); then
  printf 'Existing shared rule-set folders:\n'
  printf '  %s\n' "${existing_ruleset_dirs[@]}"
else
  printf 'Existing shared rule-set folders:\n'
  printf '  (none)\n'
fi

if ((${#implied_rulesets[@]} > 0)); then
  printf 'Implied rule sets:\n'
  printf '  %s\n' "${implied_rulesets[@]}"
else
  printf 'Implied rule sets:\n'
  printf '  (none)\n'
fi

if ((${#copied_files[@]} > 0)); then
  if [[ $dry_run -eq 1 ]]; then
    printf 'Files that would be copied:\n'
  else
    printf 'Copied files:\n'
  fi
  printf '  %s\n' "${copied_files[@]}"
else
  printf 'Copied files:\n'
  printf '  (none)\n'
fi

if ((${#skipped_files[@]} > 0)); then
  printf 'Skipped files:\n'
  printf '  %s\n' "${skipped_files[@]}"
else
  printf 'Skipped files:\n'
  printf '  (none)\n'
fi