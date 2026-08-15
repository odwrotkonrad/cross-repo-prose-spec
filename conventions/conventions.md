# Conventions

- `conventions/purpose/convention.md`: every repo's purpose doc, three headings (what, why, goals), authored in prose (`repos/<repo-path>/purpose.md`), rendered into the repo as gitignored `assets/docs-agents/purpose.md`, included at the top of `AGENTS.md`, `CLAUDE.md`, `README.md`.
- `conventions/comments/convention.md`: comment label prefixes (`[where]`, `[why]`, `[what]`), `[>]`/`[<]` sectioning, 🤖 AI-generated marks.
- `conventions/makefile/convention.md`: house Makefile style, `[genai-include]` sectioning that feeds the generated Makefile doc for AI agents.
- `conventions/templates/convention.md`: repo docs generated with che templates pinned to a prose version (`@gitlab.com/konradodwrot/prose//<path>?ref=vX.Y.Z`). `AGENTS.md`, `CLAUDE.md` and intermediates gitignored, `README.md` and `LICENSE` rendered and tracked. `make render-templates`.
- `conventions/ci/convention.md`: lefthook pre-commit hooks (minimal: docs generation check), re-run in a minimal CI validate job.
- `conventions/license/convention.md`: every public repo carries `LICENSE` (unmodified MIT), rendered from the canonical `prose/shared/license/LICENSE`.
- `conventions/spec-scenarios/convention.md`: behavior specs as markdown feature files, all in prose (`repos/<repo-path>/spec/`), edited there before implementing in the repo. Gherkin-style scenarios, each with a `Status:` line (`todo | implemented | tested`) kept accurate, each title a value statement for its audience. Vetting dirs: `vetted/` (AI never touches), `vetted_title_only/` (titles frozen, rest editable), `unvetted_ai/` (AI free rein, new AI scenarios land here). Moves between dirs come from human will. `technical-requirements.md` uses the same dirs, prefer `vetted/`: on add or change, AI urges vetting first.
- `conventions/claude-agents/convention.md`: per-repo `RO-<Repo>`/`RW-<Repo>` claude agents, che-rendered into `.claude/` on virt only. Shared snippets served from `configs` (authored in prose), consumed via one remote profile include plus `ctx`, rendered outputs never committed.

Each convention dir carries a runnable `example/`. This repo follows all of them.
