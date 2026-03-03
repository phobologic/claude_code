# Tool Rules

Per-tool Claude Code rules for deployment and database tooling. Each file is a plain
markdown reference that gets loaded via `.claude/rules/` symlinks.

## Available Tools

| File | Description |
|------|-------------|
| `railway.md` | Railway CLI cheat sheet and safety conventions |
| `sqlalchemy.md` | SQLAlchemy async patterns and Alembic migration conventions |

## Adding to a Project

The easiest way is with the global slash commands (available after running `./install.sh`):

```
/use-railway      # Sets up railway.md rules for this project
/use-sqlalchemy   # Sets up sqlalchemy.md rules for this project
```

Claude will create the `.claude/rules/` symlink automatically.

Or manually:

```bash
mkdir -p .claude/rules
ln -s ~/git/claude_code/tools/railway.md .claude/rules/railway.md
ln -s ~/git/claude_code/tools/sqlalchemy.md .claude/rules/sqlalchemy.md
```

Rules take effect immediately in the next Claude Code session (or after `/memory` refresh).

## Why symlinks?

Claude Code loads rules from `.claude/rules/*.md` automatically. Symlinking into this
repo means rules stay in sync — edit `tools/railway.md` once and every project using
it picks up the change.

## Adding a New Tool

1. Create `tools/<tool>.md` with CLI reference and conventions
2. Update this README
3. Create `commands/use-<tool>.md` as a global slash command for easy setup
