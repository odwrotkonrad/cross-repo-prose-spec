# example

Example repo for the templates convention.

@assets/docs-agents/purpose.md

{{ remoteFile (printf "gitlab.com/konradodwrot/prose//conventions/comments/convention.md?ref=%s" (env.Getenv "PROSE_REF")) }}

@assets/data/makefile.agents.md

## Directory Tree

@assets/data/repo-structure.md
