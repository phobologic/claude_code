---
name: setup-python-project
description: Scaffold a new Python project with uv, ruff, pytest, and GitHub Actions CI. Use when the user says "set up a new Python project", "scaffold a project", "create a new Python app", or similar.
argument-hint: "[project-name]"
---

# Setup Python Project

Scaffold a new Python project with opinionated defaults: uv for package management,
ruff for linting/formatting, pytest for testing, and GitHub Actions for CI.

## Phase 1 — Determine project name

- If `$ARGUMENTS` is non-empty, use it as the project name
- Otherwise, infer from `basename $PWD`
- Derive the Python package name by replacing hyphens with underscores (e.g. `my-app` → `my_app`)

Present a brief summary to the user of what will be created, then ask for confirmation:

```
Project name:    <name>
Package dir:     <package_name>/
Tests dir:       tests/
Files to create: pyproject.toml, .python-version, .gitignore, README.md,
                 <package_name>/__init__.py, tests/__init__.py,
                 .github/workflows/test.yml

Proceed? [y/N]
```

## Phase 2 — Preflight checks

Before writing anything:

1. Check if any of the target files already exist. If conflicts exist, list them and ask
   whether to overwrite. Do not overwrite silently.
2. Check if git is initialized (`git rev-parse --git-dir 2>/dev/null`). If not, note it
   in the final report — don't run `git init` yourself.

## Phase 3 — Scaffold files

Write each file in order:

### `pyproject.toml`

```toml
[project]
name = "<name>"
version = "0.1.0"
description = ""
readme = "README.md"
requires-python = ">=3.13"
dependencies = []

[dependency-groups]
dev = [
    "pytest>=8.0.0",
    "pytest-asyncio>=0.23.0",
    "ruff>=0.9.0",
]

[tool.pytest.ini_options]
testpaths = ["tests"]
asyncio_mode = "auto"

[tool.ruff]
target-version = "py313"
line-length = 88

[tool.ruff.lint]
select = [
    "F",    # pyflakes
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "I",    # isort
    "UP",   # pyupgrade
    "B",    # flake8-bugbear
    "SIM",  # flake8-simplify
    "C4",   # flake8-comprehensions
    "RUF",  # ruff-specific rules
]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]

[tool.ruff.lint.isort]
required-imports = ["from __future__ import annotations"]
known-first-party = ["<package_name>"]

[tool.ruff.format]
quote-style = "double"
```

### `.python-version`

```
3.13
```

### `.gitignore`

```
__pycache__/
*.py[cod]
*.egg-info/
dist/
build/
.venv/
.pytest_cache/
.mypy_cache/
.ruff_cache/
.coverage
htmlcov/
tmp/
.code-review/
.tickets/
```

### `README.md`

```markdown
# <name>
```

### `<package_name>/__init__.py`

```python
"""<name>."""
```

### `tests/__init__.py`

Empty file.

### `.github/workflows/test.yml`

```yaml
name: Test

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v4
        with:
          enable-cache: true

      - name: Set up Python
        run: uv python install

      - name: Install dependencies
        run: uv sync --frozen

      - name: Lint
        run: uv run ruff check .

      - name: Format check
        run: uv run ruff format --check .

      - name: Test
        run: uv run pytest -q --tb=short
```

> **Note for published libraries:** Add a `strategy.matrix` with multiple Python versions
> (e.g. 3.11, 3.12, 3.13) and a `publish.yml` workflow for PyPI trusted publishing.

## Phase 4 — Install

Run these commands in sequence, narrating each step:

```bash
uv python pin 3.13
uv sync
```

`uv sync` reads `[dependency-groups]` from `pyproject.toml` and creates the lockfile +
virtual environment in `.venv/`.

## Phase 5 — Report

Print a summary of what was created. Then suggest next steps:

1. If git was not initialized: `git init && git add -A && git commit -m "Initial project scaffold"`
2. To enable auto-formatting hooks in this project:
   ```
   /plugin install claude-python@claude-languages
   ```
3. See the Python rules (`~/.claude/rules/python.md`) for preferred libraries to reach for
   when adding dependencies.
