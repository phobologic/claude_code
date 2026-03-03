---
name: use-railway
description: Set up Railway CLI rules for this project by creating a symlink into .claude/rules/.
disable-model-invocation: true
---

Set up Railway CLI rules for this project by creating a symlink into `.claude/rules/`.

Steps:
1. Create `.claude/rules/` if it doesn't exist
2. Check if `.claude/rules/railway.md` already exists (as a file or symlink)
   - If it already points to the correct target, report "already set up" and stop
   - If it exists but points elsewhere, report the conflict and stop — don't overwrite
3. Create the symlink: `ln -s ~/git/claude_code/tools/railway.md .claude/rules/railway.md`
4. Confirm success

This makes Railway CLI conventions available in this project automatically. The source file lives in `~/git/claude_code/tools/railway.md`.
