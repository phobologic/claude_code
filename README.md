# Claude Code Review Commands

Custom slash commands and sub-agents for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), focused on **multi-agent code review**.

## Why Multi-Review?

Claude Code already handles planning, requirements, design, implementation, and commit messages well on its own. What it *can't* easily do in a single pass is review code from multiple specialized perspectives simultaneously.

The `/multi-review` command runs 4 specialized sub-agents in parallel — each analyzing your changes through a different lens — then aggregates and deduplicates findings into a prioritized report. This catches issues that a single review pass would miss.

## Getting Started

### Prerequisites

You need [Claude Code installed](https://docs.anthropic.com/en/docs/claude-code/quickstart).

### Installation

Copy the commands and agents to your project's `.claude/` directory:

```bash
# Copy to your project
cp -r /path/to/this/repo/commands .claude/
cp -r /path/to/this/repo/agents .claude/
```

Or symlink for personal use across all projects:

```bash
mkdir -p ~/.claude/commands ~/.claude/agents
ln -s /path/to/this/repo/commands/* ~/.claude/commands/
ln -s /path/to/this/repo/agents/* ~/.claude/agents/
```

## Commands

### `/review` — Quick Single-Pass Review

Reviews all uncommitted changes and provides feedback on:
- Code quality, correctness, and security
- Performance concerns
- Test coverage gaps
- Design and modularity

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

Results go to `.code-review/final-report.md`, or directly into [bd](https://github.com/anthropics/bd) issues if `bd` is initialized.

See [examples/multi-review-example.md](examples/multi-review-example.md) for a sample report.

## Configuration

Claude Code uses hierarchical settings:

1. **User settings** (`~/.claude/settings.json`) — All projects
2. **Project settings** (`.claude/settings.json`) — Shared with team
3. **Local settings** (`.claude/settings.local.json`) — Personal overrides, not committed

## What About Planning, Requirements, Design, etc.?

This repo previously included commands for `/requirements`, `/design`, `/plan`, `/phase`, `/feature`, `/feature-complete`, and `/commit`. These were removed because Claude Code with Opus 4.6 handles these tasks well conversationally — plan mode, in particular, makes the rigid `/plan` → `/phase` pipeline unnecessary. The multi-review system remains because parallel specialized analysis is genuinely additive over what you get from a single prompt.

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code GitHub Repository](https://github.com/anthropics/claude-code)
