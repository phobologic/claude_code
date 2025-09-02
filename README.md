# Claude Code

Claude Code is Anthropic's official CLI for Claude, providing an interactive command-line tool that helps engineers with software development tasks. This repository contains standards, examples, and tools to help your team effectively use Claude Code in development workflows.

## Introduction

Claude Code empowers developers by providing AI assistance directly in the command line interface. It can help with various software engineering tasks including:

- Code generation and completion
- Code reviews and quality analysis
- Requirement gathering and documentation
- System design and architecture
- Implementation planning
- Commit message creation

This repository serves as a guide for best practices and contains examples to help your engineering team leverage Claude Code effectively in your development workflows.

## Getting Started

### Installation

To install Claude Code, follow the instructions in the [official documentation](https://docs.anthropic.com/en/docs/claude-code/quickstart).

Once installed, you can start an interactive session:

```bash
# Start Claude Code interactive mode
claude
```

### Basic Configuration

Claude Code uses a settings file for configuration. Create your local settings file (which should not be committed to the repository, as it's included in the `.gitignore` file):

```bash
# Create a local settings file
touch settings.local.json
```

Configure permissions and other settings in your `settings.local.json` file. Example:

```json
{
  "permissions": {
    "allow": [
      "Bash(mkdir:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git status:*)",
      "WebFetch(domain:docs.python.org)"
    ],
    "deny": []
  }
}
```

## Slash Command Reference

This repository includes several custom slash commands that demonstrate different ways to use Claude Code in your development workflow. These commands are stored in the `commands/` directory and are used in Claude Code's interactive mode by typing a forward slash (/) followed by the command name.

Claude Code automatically loads custom commands from:
- Project-specific: `.claude/commands/` directory
- Repository root `commands/` directory (as in this project)
- Personal: `~/.claude/commands/` directory

### Requirements Gathering

The `/requirements` command helps create comprehensive requirements documents using the EARS (Easy Approach to Requirements Syntax) method:

```bash
# In Claude Code interactive mode
/requirements
```

This creates a structured requirements document with:
- Project vision and goals
- Target users and stakeholders
- Core functionality and features
- System constraints and interfaces
- Performance requirements

### System Design

The `/design` command creates technical design documents based on requirements:

```bash
# In Claude Code interactive mode
/design
```

This generates design documents including:
- Executive summary
- System architecture
- Component design
- Data model
- API design
- Security considerations

### Implementation Planning

Use the `/plan` command to create detailed implementation plans:

```bash
# In Claude Code interactive mode
/plan
```

This generates plans with:
- Test-driven development steps
- Clear file identification
- Requirement mapping
- Testing instructions

### Implementation Phase

The `/phase` command helps implement specific phases from an implementation plan:

```bash
# In Claude Code interactive mode
/phase Phase X
/phase Phase X.X (if doing sub-phases)
```

This guides you through implementing a specific phase with:
- File modifications
- Implementation decisions
- Edge case handling
- Testing considerations

### Code Review

The `/review` command provides comprehensive code reviews:

```bash
# In Claude Code interactive mode
/review
```

This analyzes uncommitted files and provides:
- Code summary
- Strengths
- Suggestions for improvement (quality, correctness, security, performance)
- Test coverage recommendations

### Multi-Review System

The `/multi-review` command provides an advanced code review using multiple specialized sub-agents:

```bash
# In Claude Code interactive mode
/multi-review
```

This system coordinates five specialized reviewers working in parallel:

1. **Code Reviewer 1**: Focuses on logical correctness, best practices, and architecture
2. **Code Reviewer 2**: Focuses on performance, efficiency, and resource usage
3. **Code Reviewer 3**: Focuses on readability, maintainability, and documentation
4. **Security Reviewer**: Focuses on security vulnerabilities and defensive coding
5. **Review Coordinator**: Aggregates and organizes findings from all reviewers

Each reviewer examines uncommitted changes through its specialized lens, rates issues by importance (Critical, High, Medium, Low), and writes findings to the `.code-review/` directory. The coordinator then compiles these findings into a comprehensive, prioritized report.

You can view an [example of a final multi-review report](examples/multi-review-example.md) to understand the format and depth of analysis provided. The report includes:

```
## Critical Issues

### CRIT-SEC-001: Potential SQL Injection in User Search Function
- **ID**: CRIT-SEC-001
- **Reviewer**: security-reviewer
- **File**: src/controllers/userController.js
- **Line(s)**: 47
- **Description**: The user search function concatenates unsanitized user input directly into a SQL query string
- **Suggested Fix**: Use parameterized queries to prevent SQL injection attacks
- **Importance**: Critical
```

### Commit Messages

Use the `/commit` command to generate clear, concise, and descriptive commit messages following best practices:

```bash
# In Claude Code interactive mode
/commit
/commit A simple commit message to include in the auto-generated commit message.
```

This command helps you create commit messages that:
- Start with a short title (≤ 72 characters)
- Include a longer description for non-trivial changes
- Use imperative mood ("Add support for X")
- Reference relevant context

## Philosophy: Collaborative AI Development

### Why This Workflow?

This workflow is built on a fundamental principle: **AI coding agents should be treated as highly capable collaborators, not magical solutions**. Like any talented engineer, Claude Code is incredibly smart and productive, but also sometimes overly eager and capable of making mistakes.

The workflow emphasizes:

1. **Incremental Progress Over Big Bangs**
   - Small changes are easier to review, understand, and fix
   - Bugs are caught early when they're cheap to fix
   - You maintain connection with your codebase

2. **Human-in-the-Loop Validation**
   - AI excels at rapid implementation but benefits from human judgment
   - Regular review cycles ensure the code aligns with your intentions
   - You remain the architect; AI is the accelerator

3. **Test-Driven Confidence**
   - Writing tests first (Phase X.0) clarifies requirements
   - Tests serve as executable specifications
   - Failed tests guide implementation

4. **Multiple Perspectives**
   - Different reviewers catch different issues (logic, performance, security, readability)
   - Comprehensive review prevents blind spots
   - Prioritized findings help focus on what matters

5. **Documentation as Foundation**
   - Requirements → Design → Plan ensures clarity before coding
   - Documentation serves as a contract between you and the AI
   - Clear specifications lead to better implementations

6. **Reversibility Through Version Control**
   - Granular commits make problematic changes easy to undo
   - Feature branches keep main branch stable
   - Squash merges provide clean history while preserving granular development

### The Result

This approach yields:
- **Better code quality** through continuous review and refinement
- **Deeper understanding** of the codebase through regular engagement
- **Reduced risk** from small, reversible changes
- **Faster debugging** when issues are caught early
- **Sustainable pace** that prevents overwhelming changes

Remember: The goal isn't to move as fast as possible, but to move as fast as sustainable while maintaining quality and understanding.

## Best Practices

### Recommended Feature Development Workflow

The most effective way to develop features with Claude Code follows this careful, iterative pattern:

1. **Create a git branch for your feature**
   ```bash
   git checkout -b feature/user-authentication
   ```

2. **Set up feature workspace**
   ```
   /feature user-authentication
   ```

3. **Planning Phase**
   ```
   /requirements  # Define what you're building
   /design        # Create technical design
   /plan          # Generate implementation plan with phases
   ```

4. **Iterative Implementation Cycle**
   
   **For each sub-phase (recommended approach):**
   ```
   a. /phase Phase 1.0    # Write failing tests
   b. /multi-review       # Review the test structure
   c. Fix any issues from review
   d. /commit             # Commit the tests
   
   e. /phase Phase 1.1    # Implement first part of functionality
   f. /multi-review       # Review the implementation
   g. Fix issues (prioritize Critical and High)
   h. /commit             # Commit this sub-phase
   
   i. /phase Phase 1.2    # Continue implementation as needed
   j. /multi-review       # Review again
   k. Fix issues
   l. /commit             # Commit
   
   Move to Phase 2.0 and repeat...
   ```
   
   **Alternative: Full phase at once (when confident):**
   ```
   a. /phase Phase 1      # Implement entire phase
   b. /multi-review       # Review all changes
   c. Fix issues
   d. /commit             # Commit entire phase
   ```

5. **Feature Completion**
   ```bash
   # When feature is complete, merge to main
   git checkout main
   git merge --squash feature/user-authentication
   git commit -m "Add user authentication feature"
   ```

#### Key Points About This Workflow

- **Git Branches**: Each feature gets its own git branch, allowing clean history via squash merge
- **Granular Commits**: Each sub-phase gets reviewed and committed separately for safety
- **Test-First**: X.0 sub-phases should always be writing failing tests (TDD approach)
- **Frequent Reviews**: Run `/multi-review` after EACH sub-phase, not just at phase end
- **Fix Before Moving On**: Address at least Critical and High priority issues before next sub-phase
- **Flexibility**: Use full phases only when very confident; default to sub-phases

### Alternative Workflows

1. **Multi-Feature Development Workflow**
   ```
   Create Feature A → Requirements → Design → Implementation Plan → 
   Create Feature B → Requirements → Design → Implementation Plan →
   Switch to Feature A → Implement Phase 1.0 → Review → Commit →
   Switch to Feature B → Implement Phase 1.0 → Review → Commit →
   ...and so on
   ```

2. **Bug Fix Workflow**
   ```
   Review Bug → Plan Fix → Implement → Test → /review → Commit
   ```

3. **Quick Code Review Workflow**
   ```
   Implement → /review → Address Issues → Commit
   ```

### Feature Management

The feature management system allows you to:
- Organize work into separate feature workspaces
- Switch between features you're working on
- Keep all documentation for a feature in one place
- Follow feature progress from requirements to implementation
- Maintain clean git history with feature branches

Use the `/feature` command to create a new feature workspace or switch to an existing one.
All documentation (requirements, design, plan) will be stored in the feature directory.

## Examples

### Example 1: Feature Development with Feature Management (Recommended)

```bash
# Create feature branch
git checkout -b feature/user-authentication

# In Claude Code interactive mode

# Step 1: Set up a feature workspace
/feature user-authentication

# Step 2: Create requirements
/requirements Add user authentication feature

# Step 3: Create design document
/design

# Step 4: Create implementation plan
/plan

# Step 5: Implement with sub-phases (recommended approach)
/phase Phase 1.0  # Write failing tests
/multi-review
# Fix any test structure issues
/commit

/phase Phase 1.1  # Implement authentication logic
/multi-review
# Fix Critical and High priority issues
/commit

/phase Phase 1.2  # Add error handling
/multi-review
# Fix issues
/commit

/phase Phase 2.0  # Write tests for session management
/multi-review
/commit

# Continue with remaining phases...

# Step 6: Merge feature when complete
git checkout main
git merge --squash feature/user-authentication
git commit -m "Add user authentication feature"
```

You can work on multiple features by switching between them:

```bash
# Create/switch to another feature
git checkout -b feature/admin-dashboard
/feature admin-dashboard

# Work on the new feature
/requirements Admin dashboard for user management

# Switch back to previous feature
git checkout feature/user-authentication
/feature user-authentication

# Continue working on original feature
/phase Phase 3.0
```

### Example 2: Standard Code Review

```bash
# Make your changes
git add .

# In Claude Code interactive mode

# Request review from Claude Code
/review

# Address feedback and commit
/commit
```

### Example 3: Multi-Agent Code Review

```bash
# Make your changes

# In Claude Code interactive mode

# Request specialized multi-agent review
/multi-review

# Review the comprehensive report in .code-review/final-report.md

# Address critical and high priority issues first

# Commit your changes with improvements
/commit
```

## Contributing

We welcome contributions to improve these Claude Code examples and standards.

### Guidelines

1. Fork this repository
2. Create a feature branch
3. Add or update examples
4. Submit a pull request

### Code Style

Follow the existing code style and conventions in the repository.

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
- [Claude Code GitHub Repository](https://github.com/anthropics/claude-code)
