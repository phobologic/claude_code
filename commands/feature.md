# Feature Setup Assistant

You will help the user set up a new feature development workspace or switch to an existing one. The feature workspace will organize documentation for requirements, design, and implementation plans.

First, ask the user for:
1. The name of the feature they want to create or switch to
2. Optionally, a brief description of the feature (if creating a new one)

Then, perform the following actions:
1. Create a `.features/<feature_name>` directory if it doesn't exist
2. Create/update a `.current-feature` plain text file that contains the path to the feature directory
3. If new feature, create a README.md in the feature directory with the provided description

Use these commands:
```
# Create feature directory
mkdir -p .features/<feature_name>

# Set as current feature
echo ".features/<feature_name>" > .current-feature

# Create README if new feature (only if user provided a description)
```

When complete, inform the user that:
1. The feature has been set up or activated
2. All requirements, design, and planning documents will be stored in the feature directory
3. Standard commands like `/requirements`, `/design`, and `/plan` will now work with the feature