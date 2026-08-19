#[what] Project's Makefile
SHELL := zsh

WRAPPERS := repo-prepare-dev-env
COMMANDS := render-templates repo-prepare-deps repo-ci-prepare-hooks

.PHONY: $(WRAPPERS) $(COMMANDS)

##[>] Dev Environment [genai-include]
#[why] render precedes hooks: the docsgen pre-commit hook runs render-templates and fails on drift,
#   so a fresh clone whose generated files were never rendered would fail its first commit
#[what] make a fresh clone a working checkout: generated docs, dependencies, git hooks
repo-prepare-dev-env: render-templates repo-prepare-deps repo-ci-prepare-hooks
##[<] Dev Environment

##[>] Docs [genai-include]
#[what] render *.ontoRepo.tpl onto the repo (makefile.agents.md)
render-templates:
	@che render-templates
##[<] Docs

##[>] Setup [genai-include]
#[what] install the toolchain this repo declares, then its dependencies
repo-prepare-deps:
	@che run --profiles=devEnv
	@bundle install

#[what] install lefthook git hooks
repo-ci-prepare-hooks:
	@lefthook install --force
##[<] Setup
