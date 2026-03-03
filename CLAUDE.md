# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository is the source of truth for `~/.claude/` — personal Claude Code dotfiles.
It provides global slash commands, sub-agents for multi-agent code review, a global CLAUDE.md
with working style rules, language plugins for auto-formatting, and tool rules for deployment
and database conventions.

## Repository Structure

```
commands/       Global slash commands (review, multi-review, use-railway, use-sqlalchemy, …)
agents/         Sub-agents for multi-agent code review (5 specialized reviewers)
languages/      Per-language Claude Code plugins (go, python) — hooks + rules
tools/          Per-tool rules files (railway, sqlalchemy) — loaded via .claude/rules/ symlinks
bin/            Utility scripts (tk plugins, etc.)
docs/           Documentation and migration guides
CLAUDE.global.md  Global CLAUDE.md — symlinked to ~/.claude/CLAUDE.md
install.sh      Sets up ~/.claude/ symlinks from scratch
```

## Installation

Run `./install.sh` to configure `~/.claude/`:
- `~/.claude/CLAUDE.md` → `CLAUDE.global.md`
- `~/.claude/commands/` → `commands/`
- `~/.claude/agents/` → `agents/`
- `~/.claude/rules/go.md` → `languages/go/rules/CLAUDE.md`
- `~/.claude/rules/python.md` → `languages/python/rules/CLAUDE.md`

To add language auto-formatting hooks to a project:
```
# Step 1 — add the marketplace once per machine:
/plugin marketplace add ~/git/claude_code/languages

# Step 2 — install in your project:
/plugin install claude-go@claude-languages
/plugin install claude-python@claude-languages
```

## Architecture

### Slash Commands
- Custom slash commands are stored in the `commands/` directory
- Commands are loaded automatically and invoked using `/` prefix in interactive mode

### Sub-Agents
- Specialized review agents are stored in the `agents/` directory
- Agents are used by the multi-review system to provide specialized code analysis
- The review coordinator aggregates findings from all reviewers

### Language Plugins
- Each language in `languages/` is a Claude Code plugin
- Plugins provide PostToolUse hooks for auto-formatting (goimports, ruff)
- Installed per-project with `/plugin install` — no `settings.json` editing required
- Rules (coding conventions) are loaded globally via `~/.claude/rules/` symlinks set up by `install.sh`
- Rules are path-scoped: Go rules only load for `*.go` files, Python rules for `*.py` files
- See `languages/README.md` for details

### Tool Rules
- `tools/` contains plain markdown rule files for deployment and database tooling
- Rules are loaded per-project by symlinking into `.claude/rules/`
- Use `/use-railway` or `/use-sqlalchemy` commands to set up symlinks automatically
- See `tools/README.md` for details

## Available Commands

### Review Commands
- `/review` - Perform standard code review of uncommitted changes
- `/multi-review` - Coordinate parallel reviews from 5 specialized agents

### Tool Setup Commands
- `/use-railway` - Symlink Railway CLI rules into this project's `.claude/rules/`
- `/use-sqlalchemy` - Symlink SQLAlchemy/Alembic rules into this project's `.claude/rules/`

## Multi-Review Agent Specializations

1. **code-reviewer-1**: Logical correctness, best practices, architecture
2. **code-reviewer-2**: Performance, efficiency, resource usage
3. **code-reviewer-3**: Readability, maintainability, documentation
4. **security-reviewer**: Security vulnerabilities, defensive coding
5. **review-coordinator**: Aggregates and prioritizes findings

## Code Review Process

- Reviews analyze uncommitted changes (or specific commits/files when specified)
- Multi-review creates reports in `.code-review/` directory
- Issues are rated by importance: Critical, High, Medium, Low
- Final reports include file locations and line numbers
- When `tk` is installed, `/multi-review` creates tickets directly instead of writing to `.code-review/*.md` files. An epic is created per review session with child tickets for each finding. Use `tk query '.[] | select(.parent=="<epic-id>")'` to browse results.

## Important Notes

- `CLAUDE.global.md` is symlinked to `~/.claude/CLAUDE.md` — it cannot be renamed to `CLAUDE.md` here because that would cause it to be loaded twice when working in this repo
- Review reports are generated in `.code-review/` directory
- Local settings should be in `settings.local.json` (gitignored)
