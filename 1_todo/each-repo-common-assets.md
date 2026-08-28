## Each Repo

- each repo MUST define CHE_REF in its .repo upstream dependencies
- each repo MUST define MISC_REF in its .repo upstream dependencies
- each repo MUST render shared makefile with common utils
- each repo MUST have 2 makefile targets repeated in it:
  - install che via URL and sh if older than the one present on the system
  - set up common assets
- each repo MUST NOT repeat makefile targets other than the 2 above
- repeated makefile targets MUST be in shared makefile in common assets
- che MUST NOT reinstall itself while executing a che profile
- each repo MUST define binaries and programs it uses in its che.yml
- each repo MUST NOT reinstall a binary to an older version if already present on the system
- each repo MUST NOT redefine authentication steps
- each repo in konradodwrot group MUST have a unique name regardless of its containing subgroup

- each repo MUST define dependencies it uses using che, using version constraints
- each repo MUST prefer binary archive installation method for its dependencies
- each repo MUST reuse system dependencies if the version constraint of the currently available binary is not violated
- each repo MUST NOT define che in che.yml in dependencies
- each repo MUST have a repeated target to install che using native installation method (URL + sh)

## Common Assets

- common assets MUST contain common makefile targets used in repos
- common assets MUST contain common gitlab job templates used in repos
- common assets MUST contain common env template
- common env template MUST contain PATH key that prepends .che/local/bin to it
- common makefile targets MUST include common precommit
- common makefile targets MUST include common docs generation and common docs generation verification
- common makefile targets MUST include dependency install target preferring binary archive installation method into untracked .che/local/bin
- common precommit MUST verify .gitlab.yml syntax
- common precommit MUST verify yml file syntax
- common precommit on MR pipelines MUST be executed on changed files in the current branch
- common precommit on main pipelines MUST be a manual optional job, on all files
- common precommit locally MUST be executed on changed files in the current branch, before pushing refs
- common precommit locally MUST NOT be executed before making a commit
- common gitlab job templates MUST include precommit job
- common docs generation MUST render files from .che/tpl/repo-git-tracked and .che/tpl/repo-git-untracked
- common docs generation verification MUST render files from .che/tpl/repo-git-tracked, print the diff, and exit 0 if there are no changes, or 1 otherwise, and revert the generation
- common docs generation verification
- common gitlab job templates MUST include common docs generation verification job
- common docs generation verification job MUST be executed in main pipeline
- common docs generation verification job MUST NOT fail the pipeline if not passed, and instead trigger a warning

## Automation

- when a consumer of an upstream dependency gets its updated ref, it MUST rerender tracked files that were rendered using this upstream dependency
