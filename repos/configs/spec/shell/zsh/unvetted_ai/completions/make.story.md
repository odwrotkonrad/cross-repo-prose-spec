# Feature: make target completion

<!-- [>] 🤖🤖 -->

## As a developer

Runs make targets across unfamiliar repos, remembers a name fragment at best.

### A target found from any fragment of its name (implemented)

I want targets containing the query anywhere in their name listed
case-insensitively, each match in its own group,
so that a half-remembered target is one TAB away.

### A miss stays silent (implemented)

I want a query matching no target listing nothing, inserting nothing, printing
no error, leaving the line unchanged,
so that a wrong guess costs nothing and leaves no zsh pattern error on screen.

<!-- [<] 🤖🤖 -->
