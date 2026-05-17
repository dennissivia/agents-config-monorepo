#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$REPO_ROOT/tmp/system-test"
TARGET_DIR="$TMP_DIR/host-repo"
COMPILED_FILE="$TARGET_DIR/AGENTS.md"

fail() {
  printf 'System test failed: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  local file_path="$1"
  [[ -f "$file_path" ]] || fail "missing file: ${file_path#$REPO_ROOT/}"
}

assert_contains() {
  local needle="$1"
  local file_path="$2"
  grep -q "$needle" "$file_path" || fail "expected content not found in ${file_path#$REPO_ROOT/}: $needle"
}

rm -rf "$TMP_DIR"
mkdir -p "$TARGET_DIR"

"$REPO_ROOT/bin/install-agents-config.bash" dev --target "$TARGET_DIR"

assert_file "$TARGET_DIR/.agents/00_index.md"
assert_file "$TARGET_DIR/.agents/global/01_purpose-and-scope.md"
assert_file "$TARGET_DIR/.agents/dev/10_dev-workflow.md"

printf 'local change\n' >> "$TARGET_DIR/.agents/global/01_purpose-and-scope.md"
printf 'y\n' | "$REPO_ROOT/bin/install-agents-config.bash" dev --target "$TARGET_DIR"
assert_contains 'single source of truth' "$TARGET_DIR/.agents/global/01_purpose-and-scope.md"

"$REPO_ROOT/bin/compile-agents.bash" --agents-dir "$TARGET_DIR/.agents" --output "$COMPILED_FILE"

assert_file "$COMPILED_FILE"
assert_contains 'AI Instruction Dispatcher' "$COMPILED_FILE"
assert_contains '01_purpose-and-scope.md' "$COMPILED_FILE"
assert_contains '10_dev-workflow.md' "$COMPILED_FILE"

printf 'System test passed.\n'