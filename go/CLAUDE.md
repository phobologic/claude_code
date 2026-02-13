# Go Conventions

Reusable Go rules. Include from project-level CLAUDE.md files.

## Code Conventions

**Formatting** — All Go code is formatted with `goimports` (a superset of
`gofmt` that also manages import grouping). Import blocks are ordered:
stdlib > third-party > local, separated by blank lines. Never hand-format;
rely on the tool.

**Naming** — MixedCaps for exported identifiers, mixedCaps for unexported.
No underscores in Go names (except in test functions like `Test_specifics`).
Acronyms are all-caps: `HTTPClient`, `UserID`, `ParseURL`. Receiver names
are short (1-2 letters), consistent across methods, and never `this` or
`self`.

**Error handling** — Always check returned errors; never assign to `_`. Wrap
with context: `fmt.Errorf("doing X: %w", err)`. Use `errors.Is` and
`errors.As` for comparison. Define sentinel errors as package-level vars:
`var ErrNotFound = errors.New("not found")`. Return early on error (no deep
nesting).

**Interfaces** — Accept interfaces, return concrete types. Keep interfaces
small (1-3 methods). Define interfaces at the call site (consumer), not at
the implementation site. Standard suffix: `-er` for single-method interfaces
(`Reader`, `Stringer`).

**Packages** — Short, lowercase, single-word names. No underscores, no
mixedCaps. Avoid generic names (`util`, `common`, `base`, `helpers`). Package
name is part of the qualified call, so avoid stutter: `http.Server` not
`http.HTTPServer`.

**Comments** — Godoc format: sentence starting with the name of the declared
symbol. All exported types, functions, constants, and variables must have
comments. Package comments go in a `doc.go` file or at the top of the
principal source file.

**Structs** — Always use named fields in struct literals (`Foo{Name: "x"}`
not `Foo{"x"}`). Use pointer receivers for methods that mutate state or for
large structs. Use value receivers for small, immutable types.

**Context** — Pass `context.Context` as the first parameter to functions that
need it. Never store a context in a struct field. Derive child contexts with
`context.WithCancel`, `context.WithTimeout`, etc.

**Concurrency** — Prefer channels for communication between goroutines,
`sync.Mutex` for protecting shared state. Always manage goroutine lifecycle
to avoid leaks (use `context` cancellation or `sync.WaitGroup`). Use
`golang.org/x/sync/errgroup` for concurrent operations that can fail.

## Module Management

This project uses **Go modules** for dependency management. All commands run
from the module root (where `go.mod` lives).

- `go mod init <module-path>` — initialize a new module
- `go mod tidy` — add missing and remove unused dependencies
- `go get <package>@<version>` — add or update a specific dependency
- `go mod download` — download dependencies to local cache

Always run `go mod tidy` after adding or removing imports. Set the minimum Go
version in `go.mod` to the oldest supported version.

## Linting & Formatting

- **Preferred linter:** `golangci-lint run ./...` — comprehensive lint suite
  that includes `go vet`, `staticcheck`, and many other analyzers. Run after
  completing a set of changes, just like tests.
- `goimports -w .` — format and fix imports (runs automatically via hooks on
  file edits)

goimports handles formatting automatically. Use `golangci-lint` as the primary
tool for catching issues — don't run `go vet` separately since golangci-lint
subsumes it.

## Testing Conventions

- **Invocation strategy** — minimize context usage with tight output by default:
  - **Full suite:** `go test ./...` — one line per package, verbose only on failure
  - **Specific packages:** `go test -v ./pkg/foo/...` — verbose is fine for targeted runs
  - **On failure follow-up:** `go test -v -run TestName ./pkg/foo` — rerun the specific failing test with verbose output
  - **Never use `-v` on `./...`** — table-driven subtests produce enormous output
- Table-driven tests as the standard pattern with named sub-tests via `t.Run`
- Use `t.Helper()` in all test helper functions for accurate line reporting
- Use `t.Parallel()` in tests and subtests that have no shared mutable state
- Filesystem isolation via `t.TempDir()` (auto-cleaned)
- HTTP testing via `httptest.NewServer` / `httptest.NewRecorder`
- No external test frameworks — stdlib `testing` only
- No network calls, no external service dependencies
