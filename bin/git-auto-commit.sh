#!/usr/bin/env bash
set -euo pipefail

# Read the full Claude command execution input from stdin
input=$(cat)

# Use CLAUDE_PROJECT_DIR if set, otherwise use current directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)/.claude}"
cd "$PROJECT_DIR"

# Determine what files were changed
changed_files=$(git status --porcelain | grep -E "^[AM]" | awk '{print $2}' || echo "")

# Exit if nothing changed
if [[ -z "$changed_files" ]]; then
  exit 0
fi

# Stage all modified and new files
git add -u
git add .

# Build a descriptive commit message (basic version from Claude's summary)
summary=$(jq -r '.command // empty' <<< "$input" 2>/dev/null || echo "")
commit_msg="Claude Code: $summary"

# Fallback if no summary
if [[ -z "$commit_msg" || "$commit_msg" == "Claude Code: " ]]; then
  commit_msg="Claude Code: automated commit after command execution"
fi

# Commit changes
git commit -m "$commit_msg"
