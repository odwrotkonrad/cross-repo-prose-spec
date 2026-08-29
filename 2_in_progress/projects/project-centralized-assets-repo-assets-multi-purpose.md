# Project Centralized Assets - Repo Assets Generic

## Contents

- repo, apart from its own makefile, MUST contain another makefile with targets exported for other repos to consume
- repo MUST provide exported GitLab templates for other repos to consume
- repo exported GitLab template jobs MUST clearly signal this is a job from the centralized repo, using part of the job name
- each exported makefile target MUST share a common name component clarifying it comes from centralized assets
- che specs and exported assets MUST NOT live in the `<repo-root>/.che` directory, whose purpose is to contain che configuration for this repo
- each distinct functionality MUST get its own directory in the parametrized file generation config directory:

```
consumer-repo-config/
  precommit-lefthook/
  env-tpl/
  che-tpl/
  che.yml
```

- each functionality directory MUST contain all its files, makefile targets, gitlab templates, scripts etc.
- gitlab templates MUST NOT be rendered onto consumer repositories, they MUST be referred to by file location and ref, and this ref MUST be in repo upstream dependencies as the repo assets generic ref

### Consumption

- each consumer SHOULD consume exported targets
- each consumer SHOULD consume exported gitlab templates
- each repo MUST define `centralized assets - generic assets` ref in its .repo upstream dependencies
- each repo MUST redefine two targets that are not in centralized assets:
  - install che via URL (native installation method) and sh if the one present on the system is older
  - set up common functionality from centralized assets, parametrized to its needs
- each repo MUST NOT repeat makefile targets other than the 2 above
- repeated makefile targets MUST be in the shared makefile provided by `centralized assets - generic assets`

## Exported Files Generation

- exported makefile MUST include targets:
  - generate tracked files
  - generate untracked files
  - verify generation of tracked files

- generate untracked files MUST render `.che/tpl/repo-git-untracked` both from templates repos define themselves and from those defined by centralized assets
- generate tracked files MUST render `.che/tpl/repo-git-tracked` both from templates repos define themselves and from those defined by centralized assets
- generate files targets MUST NOT render .env, which MUST have its own makefile targets for its generation

- repo MUST provide a GitLab template for `verify generation of tracked files`, which should warn / pass depending on whether there is a diff
- `verify generation of tracked files` gitlab job MUST execute in the MR pipeline and should exist in the main pipeline as a manual optional job
- `verify generation of tracked files` MUST render files from .che/tpl/repo-git-tracked, print the diff, and exit 0 if there are no changes, or 1 otherwise, and revert the changes

### Consumption

- each consumer CI should include `verify generation of tracked files` in its CI MR pipeline
- each consumer of `generate env` must define env.tpl in the .che/tpl/... directory
- consumer MUST write env.tpl allowing the partial render type to update its dependencies, using sectioning comments


## Exported Env Generation

- exported makefile MUST include targets:
  - generate env
  - generate env update dependencies
  - generate env update from-shell
  - generate env update all

- `generate env` target MUST retain currently set values in .env
- `generate env update dependencies` target MUST retain currently set values in .env apart from dependency refs
- `generate env update from-shell` target MUST retain currently set values in .env apart from variables that require a shell to get a value
- `generate env update all` target MUST upsert all key-value pairs from the template, retaining only values custom set by the user
- `generate env` and `generate env update dependencies` targets MUST NOT shell out if the variable is not going to be updated or inserted for the first time
- `generate env` targets must only consult env.tpl and the current .env, never other env files
- `che.env` MUST NOT be used in .env generation during runtime
- `upstream.env` MUST NOT be used in .env.tpl generation during runtime
- `upstream.env` MUST be used in .env generation during runtime

### Consumers

## Consumer of repository

- each consumer of makefile targets `generate tracked files` and `generate untracked files` MUST define instructions for generating files in its .che directory
- if a consumer uses .env to define its environment variables, it MUST have it in the `.che/tpl/git-untracked/env.tpl` directory
- `env.tpl` must be unaware


## Exported Precommit

- exported makefile MUST include targets:
    install precommit

- each repo MUST configure the lefthook che spec using parameters, to install checks according to repo needs
- exported lefthook config MAY force precommits on consumer repos, if a strict check constraint must be enforced
- lefthook.yml.tpl MUST exist and MUST combine the common parametrized config and the local repo lefthook.yml

- premade exported precommit lefthook checks MUST include:
  - gitlab.yml verify
  - yml syntax verify

- a gitlab template for the MR pipeline MUST be provided to be executed as a job on changed files in the current branch vs main
- a gitlab template for the main pipeline MUST be provided to be executed as a manual optional job to check precommit on all files in the repo

- precommit locally MUST be executed on changed files in the current branch, before pushing refs
- precommit locally MUST NOT be executed before making a commit

## Exported Repo Dependencies

- repo MUST provide a che spec with dependencies to install for all consumers, including:
  - gnumake
  - lefthook
- che spec with dependencies MUST NOT include:
  - che, che SHOULD NOT reinstall during che execution

## Conventional Tracked Files Generation

- repo MUST provide a parametrized che spec referring to a profile that lives in prose-human for generating README.md and its supplemental docs per README needs for a consumer repo
- repo MUST provide a che spec referring to a profile that lives in prose-human for generating LICENSE for the consumer
- repo MUST provide a che spec to generate dependency refs for the consumer repo: upstream.env, che.variables.yml, che.env, but it is the consumer repo's responsibility to define the templates, and the consumer repo MUST be able to choose which templates it implements

## Conventional Untracked Files Generation

- repo MUST provide a parametrized che spec for generating a makefile, this makefile MUST be referred to by the repo makefile
- repo makefile MUST NOT be templated, instead it MUST refer to makefiles generated to standard locations
- repo MUST provide a parametrized che spec referring to a profile that lives in prose-ai for generating AGENTS.md and CLAUDE.md for the consumer
- repo MUST provide a che spec that generates .che/tpl/repo-git-tracked/env.tpl using the partial render type with sectioning comments to target the dependency area, and this che spec MUST combine upstream.env, adding a dependency mark to each variable, and the current env.tpl
- repo MUST provide a parametrized che spec that generates the exported lefthook.yml for a repo



--- later
- common env template MUST contain a PATH key that prepends .che/local/bin to it
- common makefile targets MUST include a dependency install target preferring the binary archive installation method into untracked .che/local/bin
