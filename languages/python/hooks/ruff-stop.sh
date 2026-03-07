#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

# Prevent infinite loops: if the hook output caused Claude to continue and
# stop again, stop_hook_active will be true — skip re-running.
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
  exit 0
fi

# Find all .py files modified since the last commit (staged + unstaged).
CHANGED_PY=$(git diff --name-only HEAD 2>/dev/null | grep '\.py$' || true)

if [[ -z "$CHANGED_PY" ]]; then
  exit 0
fi

# Batch ruff check+fix across all modified files. Per-file fixing was already
# done by PostToolUse, but cross-file issues may now be fixable now that all
# files exist. --unfixable F401 kept consistent with the PostToolUse hook.
echo "$CHANGED_PY" | xargs uv run ruff check --fix --unfixable F401 || true

# Check pass — capture output to report violations to Claude via structured JSON.
RUFF_OUTPUT=$(echo "$CHANGED_PY" | xargs uv run ruff check 2>&1 || true)

if [[ -n "$RUFF_OUTPUT" ]]; then
  echo "{\"decision\": \"block\", \"reason\": $(echo "$RUFF_OUTPUT" | jq -Rs .)}"
fi
