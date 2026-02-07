# Global Rules

Reusable rules for all projects. Include from project-level CLAUDE.md files.

## Git Safety

- **Never run `git push`**. The user will push manually.

## Issue Tracking (Beads)

This project uses **bd** (beads) for issue tracking. Issues are stored in
`.beads/` as a SQLite database with JSONL git sync.

**When to use beads** — Use `bd` for all task/issue tracking instead of
markdown files, TodoWrite, or TaskCreate. Create issues before starting work,
claim them with `--status in_progress`, and close them when done.

**Essential commands:**

```
bd ready                                    # Show unblocked work
bd show <id>                                # View issue details
bd create --title="..." --type=task -p 2    # Create issue (priority 0-4)
bd update <id> --status=in_progress         # Claim work
bd close <id>                               # Complete work
bd dep add <child> <parent>                 # child depends on parent
bd sync                                     # Sync with git
```

**Workflow:**

1. `bd ready` — find available work
2. `bd update <id> --status=in_progress` — claim it
3. Do the work
4. `bd close <id>` — mark complete
5. `bd sync` — sync at session end

**Epics and hierarchy:**

- Create epics with `--type=epic` to group related work (e.g., code review
  findings, multi-part features)
- Attach children with `--parent=<epic-id>` on `bd create`
- Children get hierarchical IDs: `epic-id.1`, `epic-id.2`, etc.
- Types: `bug`, `task`, `feature`, `epic`, `chore`

```
bd create --title="Improve X" --type=epic -p 1 -d "..."
bd create --title="Fix Y" --type=bug -p 1 --parent=<epic-id> -d "..."
```

**Rules:**

- Priority uses integers 0-4 (0=critical, 4=backlog), not words
- Never use `bd edit` — it opens `$EDITOR` which blocks agents
- Run `bd sync` before ending a session
- Use `bd prime` for full workflow context after compaction or new session

## Living Document

CLAUDE.md is the source of truth for project conventions. When writing code:

1. Follow the patterns documented in CLAUDE.md
2. If you notice a recurring pattern not yet listed, point it out to the user
3. On user confirmation, add the pattern to `CLAUDE.local.md` (project-specific conventions that evolve during development)
4. Keep entries concise — every line should prevent a future inconsistency
