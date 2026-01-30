# Multiple Code Reviewers

This command performs a comprehensive code review of uncommitted changes using specialized sub-agents.

First, prepare the environment:
```bash
# Check for uncommitted changes and save them to a file
git status --porcelain > .code-review/changed-files.txt

# Create or clear the .code-review directory
mkdir -p .code-review
rm -f .code-review/*.md
touch .code-review/changed-files.txt
```

It's CRUCIAL that reviewers ONLY analyze files listed in .code-review/changed-files.txt and NOTHING ELSE.

If there are uncommitted changes, use the Task tool to invoke these specialized reviewers in parallel:

1. Invoke the code-reviewer-1 sub-agent:
```
Task: Review code for logical correctness
Prompt: Review ONLY files in .code-review/changed-files.txt - do NOT examine any other files
SubagentType: agents/code-reviewer-1
```

2. Invoke the code-reviewer-2 sub-agent:
```
Task: Review code for performance
Prompt: Review ONLY files in .code-review/changed-files.txt - do NOT examine any other files
SubagentType: agents/code-reviewer-2
```

3. Invoke the code-reviewer-3 sub-agent:
```
Task: Review code for readability
Prompt: Review ONLY files in .code-review/changed-files.txt - do NOT examine any other files
SubagentType: agents/code-reviewer-3
```

4. Invoke the security-reviewer sub-agent:
```
Task: Review code for security issues
Prompt: Review ONLY files in .code-review/changed-files.txt - do NOT examine any other files
SubagentType: agents/security-reviewer
```

After all reviewers complete their analysis, invoke the review-coordinator sub-agent:
```
Task: Compile review findings
Prompt: Combine all reviewer findings, combine duplicates, and write the final report to .code-review/final-report.md
SubagentType: agents/review-coordinator
```

When complete, inform the user that the review is finished and present the final report from .code-review/final-report.md.
