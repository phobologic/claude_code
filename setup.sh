#!/usr/bin/env bash
set -euo pipefail

# Resolve the directory where this script (and the repo) lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# List available languages by finding directories with a CLAUDE.md
list_languages() {
  echo "Available languages:"
  for dir in "$SCRIPT_DIR"/*/; do
    if [[ -f "$dir/CLAUDE.md" ]]; then
      echo "  $(basename "$dir")"
    fi
  done
}

if [[ $# -eq 0 ]]; then
  echo "Usage: $(basename "$0") <language>"
  echo ""
  list_languages
  exit 0
fi

LANG="$1"
LANG_DIR="$SCRIPT_DIR/$LANG"

if [[ ! -d "$LANG_DIR" || ! -f "$LANG_DIR/CLAUDE.md" ]]; then
  echo "Error: no language config found for '$LANG'"
  echo ""
  list_languages
  exit 1
fi

echo "Setting up Claude Code for: $LANG"

# Create directories
mkdir -p .claude/rules .claude/hooks

# Symlink language rules
if [[ -e .claude/rules/"$LANG".md ]]; then
  echo "  skip: .claude/rules/$LANG.md already exists"
else
  ln -s "$LANG_DIR/CLAUDE.md" .claude/rules/"$LANG".md
  echo "  link: .claude/rules/$LANG.md -> $LANG_DIR/CLAUDE.md"
fi

# Symlink hooks
if [[ -d "$LANG_DIR/hooks" ]]; then
  for hook in "$LANG_DIR"/hooks/*; do
    hook_name="$(basename "$hook")"
    if [[ -e .claude/hooks/"$hook_name" ]]; then
      echo "  skip: .claude/hooks/$hook_name already exists"
    else
      ln -s "$hook" .claude/hooks/"$hook_name"
      echo "  link: .claude/hooks/$hook_name -> $hook"
    fi
  done
fi

# Copy settings (don't symlink — projects may need to add their own)
if [[ -f "$LANG_DIR/settings.json" ]]; then
  if [[ -e .claude/settings.json ]]; then
    echo "  skip: .claude/settings.json already exists (merge manually from $LANG_DIR/settings.json)"
  else
    cp "$LANG_DIR/settings.json" .claude/settings.json
    echo "  copy: .claude/settings.json"
  fi
fi

# Scaffold CLAUDE.md if it doesn't exist
if [[ ! -f CLAUDE.md ]]; then
  PROJECT_NAME="$(basename "$(pwd)")"
  cat > CLAUDE.md << EOF
# $PROJECT_NAME

## Commands

\`\`\`
# Add project commands here
\`\`\`
EOF
  echo "  create: CLAUDE.md (edit to add project-specific details)"
else
  echo "  skip: CLAUDE.md already exists"
fi

echo ""
echo "Done. Review .claude/ and CLAUDE.md, then commit what should be shared."
