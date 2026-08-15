# Purpose Convention

Every repo's purpose doc is authored in prose at `prose/repos/<repo-path>/purpose.md` and rendered into the repo as `assets/docs-agents/purpose.md` (gitignored, rendered on demand at the repo's pinned prose version). It answers, in order:

1. What it is: concise repo description, packed with keywords.
2. Why it exists: the need, creator intention.
3. What goals can be achieved with it: high level.

## Example

Skeleton in `example/`: `assets/docs-agents/purpose.md` with all three headings, included by `AGENTS.md` and `CLAUDE.md` (via `@`), inlined in `README.md`.

## Placement

Top of `AGENTS.md`, `CLAUDE.md`, `README.md`:

- Agent files: `@assets/docs-agents/purpose.md` include.
- `README.md`: template include or inline.
