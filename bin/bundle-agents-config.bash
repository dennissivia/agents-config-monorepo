#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"
INSTALL_SCRIPT="$SCRIPT_DIR/install-agents-config.bash"

declare -a bundle_rulesets=()

if (($# == 0)); then
  bundle_rulesets=(global dev)
else
  bundle_rulesets=("$@")
fi

mkdir -p "$DIST_DIR"

for ruleset in "${bundle_rulesets[@]}"; do
  bundle_dir="$DIST_DIR/$ruleset"
  archive_path="$DIST_DIR/$ruleset.tar.gz"

  rm -rf "$bundle_dir"
  rm -f "$archive_path"
  mkdir -p "$bundle_dir"

  "$INSTALL_SCRIPT" "$ruleset" --target "$bundle_dir" --force >/dev/null
  tar -C "$bundle_dir" -czf "$archive_path" .agents

  printf 'Created bundle directory: %s\n' "${bundle_dir#$REPO_ROOT/}/.agents"
  printf 'Created archive: %s\n' "${archive_path#$REPO_ROOT/}"
done