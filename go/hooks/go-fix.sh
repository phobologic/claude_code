#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only act on Go files
if [[ -z "$FILE_PATH" || ! "$FILE_PATH" =~ \.go$ ]]; then
  exit 0
fi

# Format and fix imports.
# goimports is a superset of gofmt: it formats code AND manages import
# grouping (stdlib, third-party, local). The -w flag writes in place.
goimports -w "$FILE_PATH" 2>&1
