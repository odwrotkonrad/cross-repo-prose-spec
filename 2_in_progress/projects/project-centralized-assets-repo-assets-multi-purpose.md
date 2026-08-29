# Project Centralized Assets - Repo Assets Generic

## Contents

- repo apart from it's own makefile MUST contain another makefile with targets exported for other repos to consume
- repo MUST provide exported GitLab templates for other repos to consume
- repo exported GitLab templates jobs MUST clearly signal this is a job from centralized repo, using part of its job name
- each exported makefile target MUST share common name component in it clarifying it comes from centralized assets
- each che specs, and exported assets MUST NOT live in `<repo-root>/.che` directory, which purpose is to contain che configuration for this repo
- each distinct functionality MUST get it's own directory in containing parametrized file generation config directory:

```
consumer-repo-config/
  precommit-lefthook/
  env-tpl/
  che-tpl/
  che.yml
```

- each functionality directory MUST contain all its files, makefile targets, gitlab templates, scripts etc.
- gitlab templates MUST NOT be rendered onto consumer repositories, they MUST be refered to by filelocation and ref, and this ref MUST be in repo upstream dependencies as repo assets generic ref

### Consumption

- each consumer SHOULD consume exported targets
- each consumer SHOULD consume exported gitlab templates
- each repo MUST define `centralized assets - generic assets` ref in its .repo upstream dependencies
- each repo MUST redefine two targets that are not in centralized assets:
  - install che via URL (native installation method) and sh if older than the one present on the system
  - set up common functionality from centralized assets, parametrized to its needs
- each repo MUST NOT repeat makefile targets other than the 2 above
- repeated makefile targets MUST be in shared makefile provided by `centralized assets - generic assets`

## Exported Files Generation

- exported makefile MUST include targets:
  - generate tracked files
  - generate untracked files
  - verify generation of tracked files

- generate untracked files MUST render both `.che/tpl/repo-git-untracked` from templates repos defines themselves, as well those defined in by centralized assets,
- generate tracked files MUST render both `.che/tpl/repo-git-tracked` from templates repos defines themselves, as well those defined in by centralized assets
- generate files targets MUST not render .env, which MUST have own makefile targets for its generation

- repo MUST provide GitLab template for `verify generation of tracked files`, which should warn / pass depending on whether there is a diff
- `verify generation of tracked files` gitlab job MUST execute in MR pipeline and should exist in main pipeline as manual optional job
- `verify generation of tracked files` MUST render files from .che/tpl/repo-git-tracked, print the diff, and exit 0 if there are no changes, or 1 otherwise, and revert the changes

### Consumption

- each consumer CI should include `verify generation of tracked files` in it's CI MR pipeline
- each consumer of `generate env` must define env.tpl in .che/tpl/... directory
- consumer MUST write env.tpl allowing for partial render type to update it's dependencies, using sectioning comments


## Exported Env Generation

- exported makefile MUST include targets:
  - generate env
  - generate env update dependencies
  - generate env update from-shell
  - generate env update all

- `generate env` target MUST retain currently set values in .env
- `generate env update dependencies` target MUST retail currently set values in .env apart from dependency refs
- `generate env update from-shell` target MUST retail currently set values in .env apart from variables that require shell to get a value
- `generate env update all` target MUST upsert all key-value pairs from template, retaining only custom set values by user
- `generate env` and `generate env update dependencies` targets MUST NOT shell out, if the variable is not going to be updated, or inserted for a first time
- `generate env` targets must only consult env.tpl and current .env, never other env files
- `che.env` MUST NOT be used in .env generation during runtime
- `upstream.env` MUST NOT be used in .env.tpl generation during runtime
- `upstream.env` MUST be used in .env generation during runtime

### Consumers

## Consumer of repository

- each consumer of makefile targets `generate tracked files` and `generate untracked files` MUST define instructions for generating files in its .che directory
- if consumer uses .env for to define it's environment variables, it MUST have it in `.che/tpl/git-untracked/env.tpl directory
- `env.tpl` must be unaware


## Exported Precommit

- exported makefile MUST include targets:
    install precommit

- each repo MUST configure the lefthook che spec using parameters, to install checks according to repo needs
- exported lefthook config MAY force precommits on consumer repos, if strict check constraint must be enforced
- lefthook.yml.tpl MUST exist and MUST combine common parametrized config and local repo lefthook.yml

- premade exported precommit lefthook checks MUST include:
  - gitlab.yml verify
  - yml syntax verify

- gitlab template for MR pipeline MUST be provided to be executed as a job on changed files in the current branch vs main
- gitlab template for main pipeline MUST be provided to be executed as manual optional job to check precommit on all files in repo

- precommit locally MUST be executed on changed files in the current branch, before pushing refs
- precommit locally MUST NOT be executed before making a commit

## Exported Repo Dependencies

- repo MUST provide che spec with dependencies to install for all consumers and include:
  - gnumake
  - lefthook
- che spec with dependencies MUST NOT include:
  - che, che SHOULD NOT reinstall during che execution

## Conventional Tracked Files Generation

- repo MUST provide parametrized che spec with refering a profile that lives in prose-human for generating README.md and it's supplemental docs per README needs for a consumer repo
- repo MUST provide che spec with refering a profile that lives in prose-human for generating LICENSE for consumer
- repo MUST provide che spec to generate dependency refs for consumer repo: upstream.env, che.variables.yml, che.env, but it's consumer repo responsibility to define the templates; and consumer repo MUST be able to choose which templates it implements

## Conventional Untracked Files Generation

- repo MUST provide parametrized che spec for generating makefile, this makefile MUST be refered by repo makefile
- repo makefile MUST not be templated, instead it MUST refer to makefiles generated to standard locations
- repo MUST provide parametrized che spec with refering a profile that lives in prose-ai for generating AGENTS.md and CLAUDE.md for consumer
- repo MUST provide che spec that generates .che/tpl/repo-git-tracked/env.tpl using partial render type using sectioning comments to target dependency area, and this che spec MUST combine upstream.env adding dependency mark to each variable and current env.tpl
- repo MUST provide parametrized che spec that generates exported lefthook.yml for a repo



--- later
- common env template MUST contain PATH key that prepends .che/local/bin to it
- common makefile targets MUST include dependency install target preferring binary archive installation method into untracked .che/local/bin
