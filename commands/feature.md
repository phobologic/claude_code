# Feature Setup Assistant

You will help the user set up a new feature development workspace and automatically manage the associated git branch. The feature workspace will organize documentation for requirements, design, and implementation plans.

First, ask the user for:
1. The name of the feature they want to create or switch to
2. Optionally, a brief description of the feature (if creating a new one)

Then, perform the following actions in order:

## Step 1: Check Git Status
First, check if we're in a git repository and what branch we're on:
```bash
git status
git branch --show-current
```

## Step 2: Handle Git Branch
Based on the current branch:
- If on `main` or `master`: Create and switch to a new branch `feature/<feature_name>`
- If already on a feature branch: Stay on current branch (user may be working on a sub-feature)
- If not in a git repo: Skip branch creation but continue with workspace setup

```bash
# If on main/master, create and switch to feature branch
git checkout -b feature/<feature_name>
```

## Step 3: Set Up Feature Workspace
1. Create a `.features/<feature_name>` directory if it doesn't exist
2. Create/update a `.current-feature` plain text file that contains the path to the feature directory
3. If new feature, create a README.md in the feature directory with the provided description

```bash
# Create feature directory
mkdir -p .features/<feature_name>

# Set as current feature
echo ".features/<feature_name>" > .current-feature

# Create README if new feature (only if user provided a description)
```

## Step 4: Inform User
When complete, inform the user:
1. What git branch they're now on (if applicable)
2. The feature workspace has been set up or activated
3. All requirements, design, and planning documents will be stored in the feature directory
4. Standard commands like `/requirements`, `/design`, and `/plan` will now work with the feature
5. When done with the feature, they can merge with: `git checkout main && git merge --squash feature/<feature_name>`

## Special Cases
- If the user wants to switch to an existing feature, check if a corresponding branch exists and switch to it
- If there's a merge conflict or uncommitted changes, warn the user and ask them to resolve it first