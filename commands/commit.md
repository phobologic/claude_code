You are acting as an experienced software engineer and version control expert.

Please review the currently **staged but uncommitted changes** in this Git repository and generate a **clear, concise, and descriptive commit message** that follows best practices.

The commit message should:
- Start with a **short title (<= 72 characters)** summarizing the change.
- Optionally include a **longer description** (wrapped at 72–80 characters per line), especially if the change is non-trivial.
- Be written in the **imperative mood** (e.g., "Add support for X", not "Added" or "Adding").
- Reference any relevant context (e.g. “Refactors”, “Fixes”, “Improves”).
- Avoid low-value messages like “update files” or “fix stuff”.

Once you generate the commit message, go ahead and run `git commit -m "<message>"` with it.

**If provided, you must include this in the commit:** $ARGUMENTS

Now, please generate a high-quality commit message and commit the currently staged changes.
