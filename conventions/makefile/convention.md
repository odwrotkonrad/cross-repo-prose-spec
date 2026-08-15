# Makefile Convention

## Sectioning (makefile docs autogeneration)

Targets are grouped in `##[>] Section [genai-include]` ... `##[<] Section` blocks. `[genai-include]` marks sections harvested into generated `assets/data/makefile.agents.md` (via `templates/2-data/makefile-agents.md.ontoRepo.tpl` + che), included in `CLAUDE.md` and `AGENTS.md`.

- Every target gets a `#[what]` one-liner above it.
- Env vars get `#[what]` + `#[vals]` above their `export`.

## Shell

- `SHELL := zsh`

## Targets

- `COMMANDS :=` lists all command targets, `WRAPPERS :=` lists aggregate targets.
- `.PHONY: $(WRAPPERS) $(COMMANDS)`.
- Wrappers chain commands as prerequisite lists, no recipes: `run-sync: run-host-upsert-configs run-host-render-templates`.

## Example

Runnable version in `example/`: `Makefile` (env var, wrapper, commands), `che.yml`, `templates/2-data/makefile-agents.md.ontoRepo.tpl`, generated `assets/data/makefile.agents.md`.
