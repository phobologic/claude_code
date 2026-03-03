#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CLAUDE="$HOME/.claude"

mkdir -p "$CLAUDE"

link() {
  local src="$1"
  local dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "  ok:   $dst"
  elif [[ -e "$dst" ]]; then
    echo "  skip: $dst already exists (not a symlink to $src)"
  else
    ln -sf "$src" "$dst"
    echo "  link: $dst -> $src"
  fi
}

link "$DOTFILES/CLAUDE.global.md" "$CLAUDE/CLAUDE.md"
link "$DOTFILES/commands"         "$CLAUDE/commands"
link "$DOTFILES/agents"           "$CLAUDE/agents"

mkdir -p "$CLAUDE/rules"
link "$DOTFILES/languages/go/rules/CLAUDE.md"     "$CLAUDE/rules/go.md"
link "$DOTFILES/languages/python/rules/CLAUDE.md" "$CLAUDE/rules/python.md"

# Ensure .tickets/ is globally gitignored (tk stores tickets locally, not in git)
GIT_IGNORE="${XDG_CONFIG_HOME:-$HOME/.config}/git/ignore"
mkdir -p "$(dirname "$GIT_IGNORE")"
if ! grep -qF '.tickets/' "$GIT_IGNORE" 2>/dev/null; then
  echo '.tickets/' >> "$GIT_IGNORE"
  echo "  add:  .tickets/ to $GIT_IGNORE"
else
  echo "  ok:   .tickets/ already in $GIT_IGNORE"
fi

echo ""
echo "Done. ~/.claude/ is configured."
echo ""
echo "Language rules (Go, Python) are now active globally via ~/.claude/rules/."
echo ""
echo "To add language formatting hooks to a project, open Claude Code and run:"
echo "  # Step 1 — add the language marketplace (once per machine):"
echo "  /plugin marketplace add $DOTFILES/languages"
echo ""
echo "  # Step 2 — install the language plugin in your project:"
echo "  /plugin install claude-go@claude-languages"
echo "  /plugin install claude-python@claude-languages"
echo ""
echo "To add tool-specific rules to a project, open Claude Code in that project and run:"
echo "  /use-railway      # Railway CLI conventions"
echo "  /use-sqlalchemy   # SQLAlchemy async + Alembic conventions"
