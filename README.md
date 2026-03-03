# Claude Code Dotfiles

Personal Claude Code dotfiles — global slash commands, multi-agent code review, language plugins,
tool rules, and working style rules for `~/.claude/`.

## What's Here

| Directory | Purpose |
|-----------|---------|
| `commands/` | Global slash commands: `/review`, `/multi-review`, `/use-railway`, `/use-sqlalchemy`, … |
| `agents/` | 5 specialized code review sub-agents |
| `languages/` | Per-language Claude Code plugins (Go, Python) — auto-formatting hooks + rules |
| `tools/` | Per-tool rule files (Railway, SQLAlchemy) — loaded via `.claude/rules/` symlinks |
| `bin/` | Utility scripts (tk plugins, etc.) |
| `CLAUDE.global.md` | Global CLAUDE.md with personal working style rules |
| `install.sh` | Sets up `~/.claude/` symlinks from scratch |

## Installation

```bash
git clone https://github.com/you/claude_code ~/git/claude_code
cd ~/git/claude_code
./install.sh
```

This creates:
- `~/.claude/CLAUDE.md` → `CLAUDE.global.md`
- `~/.claude/commands/` → `commands/`
- `~/.claude/agents/` → `agents/`
- `~/.claude/rules/go.md` → `languages/go/rules/CLAUDE.md` *(path-scoped to `*.go` files)*
- `~/.claude/rules/python.md` → `languages/python/rules/CLAUDE.md` *(path-scoped to `*.py` files)*

## Language Plugins

Language plugins provide **auto-formatting hooks** (goimports for Go, ruff for Python).
Rules (coding conventions) are installed globally by `install.sh` above — no extra step needed.

To activate formatting hooks in a project:

**Step 1 — add the marketplace once per machine:**
```
/plugin marketplace add ~/git/claude_code/languages
```

**Step 2 — install in your project:**
```
/plugin install claude-go@claude-languages
/plugin install claude-python@claude-languages
```

See [`languages/README.md`](languages/README.md) for details.

## Tool Rules

CLI reference and conventions for deployment and database tooling. Rules are loaded
per-project via `.claude/rules/` symlinks. Use the global slash commands to set them up:

```
/use-railway      # Railway CLI conventions (run in your project)
/use-sqlalchemy   # SQLAlchemy async + Alembic conventions (run in your project)
```

Claude will create the symlink automatically. See [`tools/README.md`](tools/README.md) for details.

## Review Commands

### `/review` — Quick Single-Pass Review

Reviews all uncommitted changes and provides feedback on code quality, correctness,
security, performance, and test coverage.

### `/multi-review` — Parallel Multi-Agent Review

Coordinates 5 specialized agents working in parallel:

| Agent | Focus |
|-------|-------|
| **code-reviewer-1** | Logical correctness, best practices, architecture |
| **code-reviewer-2** | Performance, efficiency, resource usage |
| **code-reviewer-3** | Readability, maintainability, documentation |
| **security-reviewer** | Security vulnerabilities, defensive coding |
| **review-coordinator** | Aggregates, deduplicates, and prioritizes findings |

Issues are rated by importance: **Critical**, **High**, **Medium**, **Low**.

#### Review Scope

```bash
/multi-review                    # Uncommitted changes (default)
/multi-review last 3 commits     # Recent commits
/multi-review since abc123       # Since a specific commit
/multi-review src/auth.py        # Specific files
```

#### Output

Results go to `.code-review/final-report.md`, or directly into [tk](https://github.com/wedow/ticket)
tickets if `tk` is installed.

See [examples/multi-review-example.md](examples/multi-review-example.md) for a sample report.

## Migrating from v1

If you set up projects with the old `setup.sh`, see
[`docs/migration-v1-to-v2.md`](docs/migration-v1-to-v2.md).

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code GitHub Repository](https://github.com/anthropics/claude-code)
