## Centralized Assets Consumption Rules

## Each Repo

- each repo MUST define che ref in its .repo upstream dependencies
- each repo MUST define binaries and programs it uses in its che.yml

- each repo MUST only pin refs of it's direct upstream dependencies, and MUST NOT pin upstream dependencies of direct upstream dependencies

- each repo MUST reuse system dependencies if the version constraint of the currently available binary is not violated
- each repo MUST prefer binary archive installation method for its dependencies
- each repo MUST define dependencies it uses using che, using version constraints
- each repo MUST NOT redefine authentication steps if these are common to other repositories
- each repo MUST NOT reinstall a binary to an older version if already present on the system



- each repo in konradodwrot group MUST have a unique name regardless of its containing subgroup


- each repo MUST NOT define che in che.yml in dependencies
