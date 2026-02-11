# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains custom slash commands and sub-agents for Claude Code, focused on **code review**. The multi-review system runs specialized agents in parallel to catch issues that a single-pass review would miss.

## Architecture

### Slash Commands
- Custom slash commands are stored in the `commands/` directory
- Commands are loaded automatically and invoked using `/` prefix in interactive mode

### Sub-Agents
- Specialized review agents are stored in the `agents/` directory
- Agents are used by the multi-review system to provide specialized code analysis
- The review coordinator aggregates findings from all reviewers

## Available Commands

### Review Commands
- `/review` - Perform standard code review of uncommitted changes
- `/multi-review` - Coordinate parallel reviews from 5 specialized agents

## Multi-Review Agent Specializations

1. **code-reviewer-1**: Logical correctness, best practices, architecture
2. **code-reviewer-2**: Performance, efficiency, resource usage
3. **code-reviewer-3**: Readability, maintainability, documentation
4. **security-reviewer**: Security vulnerabilities, defensive coding
5. **review-coordinator**: Aggregates and prioritizes findings

## Code Review Process

- Reviews analyze uncommitted changes (or specific commits/files when specified)
- Multi-review creates reports in `.code-review/` directory
- Issues are rated by importance: Critical, High, Medium, Low
- Final reports include file locations and line numbers
- When `bd` is installed and initialized, `/multi-review` creates issues directly in bd instead of writing to `.code-review/*.md` files. An epic is created per review session with child issues for each finding. Use `bd children <epic-id>` to browse results.

## Important Notes

- Review reports are generated in `.code-review/` directory
- Local settings should be in `settings.local.json` (gitignored)
