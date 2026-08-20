# Feature: language principles option on the code skills

<!-- [>] 🤖🤖 -->

## As a developer

Runs the code skills on a codebase, expects the user's own design taste, not a
generic one.

### Go design principles applied by naming the language (implemented)

I want a code skill run with a scope and `lang go` printing the Go principles
from the claude rules into its Language Principles section,
so that every Go target in scope is judged by the user's Go taste.

### Python the same way (implemented)

I want `lang python` printing the Python principles into the same section,
so that Python gets the same treatment as Go.

### Ruby the same way (implemented)

I want `lang ruby` printing the Ruby principles into the same section,
so that Ruby is no longer the language the skills cannot judge.

### An unsupported language fails loudly (implemented)

I want a `lang` with no principles file failing with the unknown lang and the
resolved path, and no `lang` running without a principles section,
so that a typo never silently drops the principles.

## As a repo owner

Authors the rules files, owns how they reach the host, states nothing twice
across them.

### Ruby principles carry Ruby's own idiom (implemented)

I want the Ruby file covering objects, modules, duck typing, blocks and
Enumerable as Ruby's own concerns, design-level only, no frontmatter paths key,
so that it is not the Go file transliterated.

### Python principles stay apart from the path-scoped rules (implemented)

I want the Python principles file design-level only, no frontmatter paths key,
restating nothing from `code/python/python.md` or `code/python/scripts.md`,
so that typing, docstrings and script structure are stated once.

### Principles reach the host through the normal render path (implemented)

I want a principles file added under the prose claude-rules tree and wired into
the configs render spec, so rendering configs writes it under the claude rules
tree and loading configs puts it where the skill script reads it,
so that no rule needs its own delivery path.

<!-- [<] 🤖🤖 -->
