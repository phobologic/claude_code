---
name: review
description: Quick code review using an adversarial sub-agent. Surfaces Critical and High issues first. Creates tk tickets for Critical/High/Medium findings if tk is available.
disable-model-invocation: true
---

You are orchestrating a fast pre-merge code review. A dedicated adversarial sub-agent does the actual reviewing so it brings a fresh, unbiased perspective.

## Step 1: Collect context

Run in a single Bash call:

```bash
mkdir -p .code-review
rm -f .code-review/changed-files.txt .code-review/claude-md-context.txt
git status --porcelain | awk '{print $NF}' > .code-review/changed-files.txt
TK_AVAILABLE=false
command -v tk >/dev/null 2>&1 && TK_AVAILABLE=true
SESSION_TAG="review-$(date +%Y%m%d-%H%M)"
echo "TK_AVAILABLE=$TK_AVAILABLE"
echo "SESSION_TAG=$SESSION_TAG"
echo "--- Files to review ---"
cat .code-review/changed-files.txt
```

## Step 2: Collect CLAUDE.md context

Run this to give the critic project convention awareness:

```bash
[ -f CLAUDE.md ] && { echo "=== CLAUDE.md (root) ==="; cat CLAUDE.md; echo; } > .code-review/claude-md-context.txt
while IFS= read -r file; do
  dir=$(dirname "$file")
  if [ "$dir" != "." ] && [ -f "$dir/CLAUDE.md" ]; then
    echo "=== CLAUDE.md ($dir) ===" >> .code-review/claude-md-context.txt
    cat "$dir/CLAUDE.md" >> .code-review/claude-md-context.txt
    echo >> .code-review/claude-md-context.txt
  fi
done < .code-review/changed-files.txt
[ ! -s .code-review/claude-md-context.txt ] && rm -f .code-review/claude-md-context.txt
```

## Step 3: Guard

If `.code-review/changed-files.txt` is empty, tell the user there are no uncommitted changes to review and stop.

## Step 4: Launch the code-critic sub-agent

Use the Task tool to invoke the `code-critic` sub-agent. Pass `REVIEW_CMD`, and tk parameters when available.

### tk mode (TK_AVAILABLE=true)

```
Task: Adversarial code review
Prompt: TK_MODE=true SESSION_TAG=<session_tag> REVIEW_CMD=git diff HEAD -- Review ONLY the files listed in .code-review/changed-files.txt and nothing else
SubagentType: code-critic
```

### non-tk mode (TK_AVAILABLE=false)

```
Task: Adversarial code review
Prompt: REVIEW_CMD=git diff HEAD -- Review ONLY the files listed in .code-review/changed-files.txt and nothing else
SubagentType: code-critic
```

## Step 5: Present results

The critic's output is the review. Display it.

In tk mode, additionally tell the user:
- The session tag used: `<session_tag>`
- How to find all tickets from this review: `tk query '.tags | contains(["<session_tag>"])'`
