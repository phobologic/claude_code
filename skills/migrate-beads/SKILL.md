---
name: migrate-beads
description: Migrate this project's issue tracking from beads (bd) to tickets (tk).
disable-model-invocation: true
---

# Migrate from Beads to Tickets

Migrate this project's issue tracking from beads (bd) to tickets (tk).

## Step 1: Preflight checks

Run these checks and stop if any fail:

```bash
# Verify tk is installed
command -v tk >/dev/null 2>&1 && echo "tk: OK" || echo "tk: MISSING"

# Verify .beads exists with data to migrate
[ -f .beads/issues.jsonl ] && echo "beads data: OK" || echo "beads data: MISSING"

# Check for uncommitted changes that should be committed first
git status --porcelain
```

If `tk` is missing, tell the user to install it. If `.beads/issues.jsonl` is missing, there's nothing to migrate. If there are uncommitted changes, ask the user to commit or stash them first.

## Step 2: Run migration

```bash
tk migrate-beads
```

## Step 3: Verify migration

Compare the old and new systems side by side:

```bash
echo "=== tk ready ==="
tk ready
echo ""
echo "=== tk blocked ==="
tk blocked
echo ""
echo "=== bd ready ==="
bd ready
echo ""
echo "=== bd blocked ==="
bd blocked
```

Present the comparison to the user. Ask them to confirm the migration looks correct before proceeding.

## Step 4: Remove beads data

After user confirmation:

```bash
git rm -rf .beads
```

Verify nothing survived (`.beads/.gitignore` can cause tracked files like `issues.jsonl` to be missed):

```bash
# Stage any tracked files that git rm missed
git ls-files --deleted .beads | xargs -r git add
# Clean up anything left on disk
rm -rf .beads
```

Stage the new tickets:

```bash
git add .tickets
```

## Step 5: Remove beads git hooks

Beads installs shim hooks in `.git/hooks/` that will break after migration (e.g. `pre-commit` fails with "no beads database found"). Remove them:

```bash
grep -rl 'bd.shim\|bd hook' .git/hooks/ 2>/dev/null | xargs -r rm -v
```

Report what was removed to the user. If nothing was found, note that no beads hooks were present.

## Step 6: Update CLAUDE.md

If the project has a `CLAUDE.md` that references `bd` or beads:

1. Read the file
2. Replace the beads/bd issue tracking section with the tickets/tk equivalent:
   - `bd ready` → `tk ready`
   - `bd show <id>` → `tk show <id>`
   - `bd create --title="..." ...` → `tk create "..." ...`
   - `bd update <id> --status=in_progress` → `tk start <id>`
   - `bd close <id>` → `tk close <id>`
   - `bd dep add <child> <parent>` → `tk dep <child> <parent>`
   - `bd sync` → remove (not needed, files tracked by git)
   - `bd prime` → remove (not needed)
   - `.beads/` → `.tickets/`
   - Never use `tk edit` (opens $EDITOR, blocks agents)
   - Use `tk add-note <id> "text"` to append context

Stage the updated CLAUDE.md:
```bash
git add CLAUDE.md
```

## Step 7: Commit

Create a commit with the migration:

```bash
git commit -m "Migrate issue tracking from beads to tickets"
```

Inform the user that migration is complete and they can now use `tk` commands for all issue tracking.
