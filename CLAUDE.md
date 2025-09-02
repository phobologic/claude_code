# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains standards, examples, and tools to help teams effectively use Claude Code in development workflows. It provides custom slash commands and sub-agents that demonstrate different ways to use Claude Code for software engineering tasks.

## Architecture

### Slash Commands System
- Custom slash commands are stored in the `commands/` directory
- Each command is a markdown file that provides instructions for Claude Code
- Commands are loaded automatically and invoked using `/` prefix in interactive mode

### Sub-Agents System
- Specialized review agents are stored in the `agents/` directory
- Agents are used by the multi-review system to provide specialized code analysis
- The review coordinator aggregates findings from all reviewers

### Feature Management System
- Features are organized in `.features/<feature_name>` directories
- Current feature is tracked in `.current-feature` file
- All documentation for a feature (requirements, design, plan) is stored in its directory

## Available Commands

### Core Development Commands
- `/requirements` - Create EARS-based requirements documents
- `/design` - Generate technical design documents from requirements
- `/plan` - Create detailed implementation plans with test-driven development steps
- `/phase <Phase X>` - Implement specific phases from the plan
- `/feature <name>` - Create feature workspace and git branch (or switch to existing)
- `/feature-complete` - Merge completed feature to main with squash merge

### Review Commands
- `/review` - Perform standard code review of uncommitted changes
- `/multi-review` - Coordinate parallel reviews from 5 specialized agents
- `/commit [message]` - Generate best-practice commit messages

## Multi-Review Agent Specializations

1. **code-reviewer-1**: Logical correctness, best practices, architecture
2. **code-reviewer-2**: Performance, efficiency, resource usage
3. **code-reviewer-3**: Readability, maintainability, documentation
4. **security-reviewer**: Security vulnerabilities, defensive coding
5. **review-coordinator**: Aggregates and prioritizes findings

## Development Workflow

### Recommended Feature Development
1. `/feature <name>` - Automatically creates feature branch and workspace
2. `/requirements` - Document requirements
3. `/design` - Create technical design
4. `/plan` - Generate implementation plan
5. For each sub-phase:
   - `/phase Phase X.0` - Write failing tests
   - `/multi-review` - Review test structure
   - Fix issues and `/commit`
   - `/phase Phase X.1` - Implement functionality
   - `/multi-review` - Review implementation
   - Fix Critical/High issues and `/commit`
   - Continue with X.2, X.3 as needed
6. `/feature-complete` - Squash merge to main with comprehensive commit message

### Code Review Process
- Reviews analyze uncommitted changes
- Multi-review creates reports in `.code-review/` directory
- Issues are rated by importance: Critical, High, Medium, Low
- Final reports include file locations and line numbers

## Important Notes

- Feature documentation is stored in `.features/<feature_name>/`
- Current feature is tracked in `.current-feature` file
- Review reports are generated in `.code-review/` directory
- Local settings should be in `settings.local.json` (gitignored)