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
# before the code that uses them).
# Allow the fix pass to exit non-zero (unfixable violations expected mid-edit).
uv run ruff check --fix --unfixable F401 "$FILE_PATH" || true
uv run ruff format "$FILE_PATH"

# Report any remaining violations so Claude can address them immediately
# rather than having them surface at git push time.
# Capture to variable so we can route to stderr (PostToolUse hooks report
# failures via stderr; stdout output is not shown to Claude).
RUFF_OUTPUT=$(uv run ruff check "$FILE_PATH" 2>&1 || true)

if [[ -n "$RUFF_OUTPUT" ]]; then
  echo "$RUFF_OUTPUT" >&2
  exit 1
fi
