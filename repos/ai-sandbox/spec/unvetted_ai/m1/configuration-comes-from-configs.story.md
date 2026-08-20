# Feature: Configuration comes from configs

<!--[>] 🤖🤖 -->

## As a session user

Uses the tools. Does not decide where their configuration lives.

### A missing tool arrives by its profile (implemented)

I want a requested tool installed by the configs profile that defines it,
so that the install is repeatable in the next image.

### The base hand-installs nothing a profile defines (todo)

I want tmux and vim arriving by their configs profiles, not the base Dockerfile,
so that no tool has two install paths.

### The session feels like the host (implemented)

I want a tool's configuration in a session matching the host's,
so that there is nothing to relearn inside the sandbox.

## As a workspace maintainer

Owns the configs repo as the single source. Does not maintain sandbox-local
config.

### A configs change reaches sessions untouched (implemented)

I want a rebuilt configuration image carrying the change with no sandbox-side
file edited,
so that configs stays the only place to change a tool.

### The sandbox defines no configuration of its own (todo)

I want a search of the sandbox repo finding no tool configuration, every tool
resolving to configs,
so that the two repos never disagree.

<!--[<] 🤖🤖 -->
