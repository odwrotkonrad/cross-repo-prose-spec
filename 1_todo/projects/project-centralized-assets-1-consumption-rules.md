## Centralized Assets Consumption Rules

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
