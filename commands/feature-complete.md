# Feature Completion Assistant

You will help the user complete a feature by merging it back to the main branch with a squash merge. This ensures a clean git history while preserving all the detailed work in the feature branch.

## Step 1: Pre-flight Checks

First, check for any uncommitted changes:
```bash
git status
```

If there are uncommitted changes, STOP and inform the user:
- They need to either commit their changes with `/commit`
- Or stash them with `git stash`
- Explain that merging with uncommitted changes could lead to lost work

## Step 2: Identify Current Branch

Check what branch we're on:
```bash
git branch --show-current
```

If not on a feature branch, ask the user which feature they want to complete.

## Step 3: Gather Commit Information

Get all commits that are in the feature branch but not in main:
```bash
# First, fetch latest main to ensure we're up to date
git fetch origin main

# Get the commit messages
git log main..HEAD --oneline
```

## Step 4: Generate Merge Commit Message

Based on the commits in the feature branch:
1. If there's a `.features/<feature_name>/` directory, check for requirements.md to understand the feature
2. Analyze all commit messages to create a comprehensive summary
3. Create a commit message that:
   - Has a clear title describing what the feature adds
   - Includes a bullet-point summary of major changes
   - References any issue numbers if found in commit messages

## Step 5: Perform the Merge

Execute the squash merge:
```bash
# Switch to main branch
git checkout main

# Pull latest changes
git pull origin main

# Merge the feature branch with squash
git merge --squash feature/<feature_name>

# Commit with the generated message
git commit -m "<generated comprehensive message>"
```

## Step 6: Post-Merge Summary

After successful merge, inform the user:
- ✅ Feature has been successfully merged to main
- 📝 All commits have been squashed into one
- 🔄 They can push to remote with: `git push origin main`
- 🌿 The feature branch is still available if needed
- 📁 The `.features/<feature_name>/` directory remains for reference

Suggest optional cleanup steps they can do manually:
```bash
# If you want to delete the local feature branch:
git branch -d feature/<feature_name>

# If you want to delete the remote feature branch:
git push origin --delete feature/<feature_name>

# If you want to archive the feature documentation:
mv .features/<feature_name> .features/archived-<feature_name>
```

## Error Handling

If any step fails:
- If merge conflicts occur, provide guidance on resolving them
- If the branch has already been merged, inform the user
- If pulling main fails, check network and authentication