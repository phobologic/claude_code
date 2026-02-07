#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only act on Python files
if [[ -z "$FILE_PATH" || ! "$FILE_PATH" =~ \.py$ ]]; then
  exit 0
fi

# Fix lint issues, then format.
# --unfixable F401: don't auto-remove unused imports (they may be added
# before the code that uses them). A standalone `ruff check .` will
# still report them so they can be addressed intentionally.
# Allow ruff check to return non-zero (unfixable violations are expected
# mid-edit) — the hook should still format and exit successfully.
uv run ruff check --fix --unfixable F401 "$FILE_PATH" 2>&1 || true
uv run ruff format "$FILE_PATH" 2>&1
