Set up SQLAlchemy async + Alembic rules for this project by creating a symlink into `.claude/rules/`.

Steps:
1. Create `.claude/rules/` if it doesn't exist
2. Check if `.claude/rules/sqlalchemy.md` already exists (as a file or symlink)
   - If it already points to the correct target, report "already set up" and stop
   - If it exists but points elsewhere, report the conflict and stop — don't overwrite
3. Create the symlink: `ln -s ~/git/claude_code/tools/sqlalchemy.md .claude/rules/sqlalchemy.md`
4. Confirm success

This makes SQLAlchemy async patterns and Alembic migration conventions available in this project automatically. The source file lives in `~/git/claude_code/tools/sqlalchemy.md`.
