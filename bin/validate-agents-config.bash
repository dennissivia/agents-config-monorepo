#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RULESETS_DIR="$REPO_ROOT/rulesets"

declare -a errors=()

record_error() {
  errors+=("$1")
}

require_file() {
  local file_path="$1"
  [[ -f "$file_path" ]] || record_error "missing file: ${file_path#$REPO_ROOT/}"
}

require_file "$REPO_ROOT/00_index.md"
require_file "$REPO_ROOT/README.md"
require_file "$REPO_ROOT/SPEC.md"
require_file "$REPO_ROOT/LICENSE"
require_file "$RULESETS_DIR/00_index.md"
require_file "$REPO_ROOT/docs/installation.md"
require_file "$REPO_ROOT/docs/authoring.md"
require_file "$REPO_ROOT/docs/migration.md"
require_file "$REPO_ROOT/.gitignore"
require_file "$REPO_ROOT/examples/dev-minimal/.agents/00_index.md"
require_file "$REPO_ROOT/examples/dev-minimal/.agents/global/01_purpose-and-scope.md"
require_file "$REPO_ROOT/examples/dev-minimal/.agents/dev/10_dev-workflow.md"
require_file "$REPO_ROOT/examples/dev-minimal/AGENTS.md"

while IFS= read -r ruleset_dir; do
  declare -A seen_names=()
  while IFS= read -r ruleset_file; do
    base_name="$(basename "$ruleset_file")"
    lower_name="$(printf '%s' "$base_name" | tr '[:upper:]' '[:lower:]')"

    if [[ ! "$base_name" =~ ^[0-9]{2}[-_].+\.md$ ]]; then
      record_error "invalid active filename in ${ruleset_dir#$REPO_ROOT/}: $base_name"
    fi

    if [[ -n "${seen_names[$lower_name]:-}" ]]; then
      record_error "duplicate filename in ${ruleset_dir#$REPO_ROOT/}: $base_name"
    fi
    seen_names[$lower_name]=1
  done < <(find "$ruleset_dir" -maxdepth 1 -type f -name '*.md' | sort)
done < <(find "$RULESETS_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

while IFS= read -r root_markdown; do
  base_name="$(basename "$root_markdown")"
  case "$base_name" in
    00_index.md|README.md|CHANGELOG.md|LICENSE|SPEC.md)
      ;;
    *)
      if [[ "$base_name" =~ ^[0-9]{2}[-_].+\.md$ ]]; then
        record_error "unsupported active instruction file outside rulesets: $base_name"
      fi
      ;;
  esac
done < <(find "$REPO_ROOT" -maxdepth 1 -type f | sort)

if ! grep -q 'Inactive support folders:' "$REPO_ROOT/00_index.md"; then
  record_error "root dispatcher does not declare inactive support folders"
fi

for support_dir in docs/ bin/ dist/; do
  if ! grep -q "$support_dir" "$REPO_ROOT/00_index.md"; then
    record_error "root dispatcher does not mention support folder: $support_dir"
  fi
done

global_hashes="$({ find "$RULESETS_DIR/global" -maxdepth 1 -type f -name '*.md' -exec sha256sum {} + 2>/dev/null || true; } | awk '{print $1}' | sort -u)"
dev_hashes="$({ find "$RULESETS_DIR/dev" -maxdepth 1 -type f -name '*.md' -exec sha256sum {} + 2>/dev/null || true; } | awk '{print $1}' | sort -u)"

if [[ -n "$global_hashes" && -n "$dev_hashes" ]]; then
  while IFS= read -r digest; do
    [[ -z "$digest" ]] && continue
    if grep -qx "$digest" <<<"$dev_hashes"; then
      record_error "dev duplicates a global rule file verbatim"
      break
    fi
  done <<<"$global_hashes"
fi

if ! grep -qx 'docs/internal/' "$REPO_ROOT/.gitignore"; then
  record_error ".gitignore does not ignore docs/internal/"
fi

if ! grep -qx 'tmp/' "$REPO_ROOT/.gitignore"; then
  record_error ".gitignore does not ignore tmp/"
fi

if ! grep -q 'Repository Notice' "$REPO_ROOT/README.md"; then
  record_error "README.md does not include the repository notice"
fi

if ! grep -q '^# Compiled AI Instructions' "$REPO_ROOT/examples/dev-minimal/AGENTS.md"; then
  record_error "examples/dev-minimal/AGENTS.md is missing the compiled header"
fi

if ((${#errors[@]} > 0)); then
  printf 'Validation failed:\n' >&2
  printf '  %s\n' "${errors[@]}" >&2
  exit 1
fi

printf 'Validation passed.\n'