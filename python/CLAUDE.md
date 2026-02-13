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

## Package Management (uv)

This project uses **uv** as the package manager and task runner. All commands
run through `uv run` to ensure they execute in the project's virtual environment.

- `uv sync` — install/update dependencies from lockfile
- `uv add <package>` — add a dependency (updates `pyproject.toml` + `uv.lock`)
- `uv add --dev <package>` — add a dev dependency
- `uv lock` — regenerate lockfile without installing
- `uv run <command>` — run any command in the project's venv

Never use raw `pip install` or `python -m` directly — always go through `uv run`.

## Linting & Formatting (Ruff)

- `uv run ruff check .` — lint
- `uv run ruff check --fix .` — lint with auto-fix
- `uv run ruff format .` — format

Ruff also runs automatically via hooks on file edits, but these commands are
available for manual checks or pre-commit verification.

## Testing Conventions

- **Invocation strategy** — minimize context usage with tight output by default:
  - **Full suite:** `uv run pytest -q --tb=short` — dots for passing tests,
    short tracebacks only on failure
  - **Specific files/tests:** `uv run pytest -v path/to/test.py` — verbose is
    fine for targeted runs (small output)
  - **On failure follow-up:** `uv run pytest --lf -v --tb=short` — rerun only
    the tests that failed, now with verbose per-test output
- Group related tests in classes (e.g., `TestSessionConfig`, `TestParseDirectives`)
- Mock subprocess with `unittest.mock.patch` + `MagicMock` — never call external CLIs
- Filesystem isolation via `tmp_path`
- No network calls, no external service dependencies
