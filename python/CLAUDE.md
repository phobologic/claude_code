# Python Conventions

Reusable Python rules. Include from project-level CLAUDE.md files.

## Code Conventions

**Imports** — Every source module starts with `from __future__ import annotations`
(after the module docstring). Test files do not require this. Import order:
future > stdlib > third-party > local, blank lines between groups. No wildcard
imports.

**Typing** — Modern union syntax: `str | None`, `list[str]`, `dict[str, str]`.
Note: frameworks that inspect annotations at runtime (e.g., Typer, Pydantic v1)
may require `Optional[str]` instead of PEP 604 syntax.

**Naming** — `snake_case` functions/variables, `PascalCase` classes,
`UPPER_SNAKE_CASE` constants. Private helpers prefixed with `_`.

**Docstrings** — Google-style on all public functions and classes. Every module
has a docstring on line 1. Include Args/Returns/Raises when non-trivial.

**Dataclasses** — `field(default_factory=...)` for mutable defaults. Factory
classmethods (e.g., `SessionConfig.create()`) for complex construction.

**Interfaces** — `typing.Protocol` for abstract interfaces.

**Error handling** — Specific exceptions from library code (`FileNotFoundError`,
`ValueError`). CLI commands catch and display errors via `console.print` +
`typer.Exit(1)`. No bare `except` clauses. Use `finally` for cleanup.

**Paths** — `pathlib.Path` everywhere. JSON written with `indent=2` and trailing
newline.

## Testing Conventions

- Run: `uv run pytest`
- Group related tests in classes (e.g., `TestSessionConfig`, `TestParseDirectives`)
- Mock subprocess with `unittest.mock.patch` + `MagicMock` — never call external CLIs
- Filesystem isolation via `tmp_path`
- No network calls, no external service dependencies
