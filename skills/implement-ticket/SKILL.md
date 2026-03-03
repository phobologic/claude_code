---
name: implement-ticket
description: Implement one or more tk tickets. Use when the user says "implement ticket X", "work on ticket", "do ticket #N", "tackle the next ticket", or similar.
argument-hint: "[id ...] [-- extra instructions]"
---

# Implement Ticket

## Phase 0 — Argument parsing

Parse `$ARGUMENTS`:
- Ticket IDs are space-separated tokens before any `--`
- Everything after `--` is extra instructions that inform the design phase
- Examples:
  - `/implement-ticket 42` — single ticket
  - `/implement-ticket 42 43` — process both, sequentially
  - `/implement-ticket 42 -- focus on error handling, skip migration` — ticket with constraints

## Phase 1 — Ticket selection

**If ticket IDs were provided**: run `tk show-multi <ids>` to load full context.

**If no IDs provided**:
1. Run `tk ready` to get unblocked work
2. Read each ticket's description to understand scope and context
3. Present two things to the user:
   - **Suggested next tickets** (2–3 picks with reasoning — e.g., "unblocks the most
     downstream work", "highest priority", "quickest win based on scope")
   - **Full ready list** for their reference
4. Ask the user which ticket(s) to proceed with

## Phase 2 — Complexity triage

Read the selected ticket(s) and parent epic (if set). Make a judgment call:

**Straightforward** — typo, config change, single clear action with no design ambiguity:
- Describe what you'll do in 1–2 sentences
- Ask the user for a quick go-ahead
- Skip Phases 3–4 and proceed directly to implementation

**Complex** — new feature, tricky bug, or non-obvious design decisions:
- Proceed through the full design and planning flow below

## Phase 3 — Design discussion (complex only)

Before writing any plan:

1. Scan the affected code area with Glob and Grep to understand existing patterns
2. Check for reusable utilities — avoid reinventing what already exists
3. Incorporate any extra instructions from Phase 0 as constraints on the design
4. Identify open questions: ambiguous acceptance criteria, approach tradeoffs,
   constraints from CLAUDE.md or the parent epic
5. Work through each question interactively with the user

This phase ends when design intent is unambiguous.

## Phase 4 — Plan + approval (complex only)

Present a full implementation plan:
- Files to create or modify
- Key decisions made in Phase 3
- Test strategy (what to test, how)
- Schema or migration changes if applicable

Wait for explicit user approval before writing any code.

## Phase 5 — Implementation

Run `tk start <id>` to claim the ticket, then implement according to the approved plan.

## Phase 6 — Tests

1. Run tests scoped to the changed area first (faster feedback)
2. Run the full test suite
3. Fix any failures before continuing — do not proceed with a broken suite

## Phase 7 — Commit + close

1. Stage relevant files and commit with a message that references the ticket ID
2. `tk add-note <id> "..."` — record design decisions made in Phase 3, approaches
   considered, and any gotchas encountered
3. `tk close <id>`
4. Run `git status` and confirm it's clean

## Multiple tickets

If multiple ticket IDs were provided, process them one at a time in the order given.
Complete all phases for each ticket before starting the next.
