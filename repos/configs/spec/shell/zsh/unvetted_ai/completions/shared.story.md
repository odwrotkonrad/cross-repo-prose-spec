# Feature: shared completion behavior

<!-- [>] 🤖🤖 -->

## As a developer

Navigates completion menus by keyboard, expects the line untouched until an
entry is accepted.

### Long menus traversed in fewer keystrokes (implemented)

I want alt+down and alt+up moving the selection 3 rows without inserting
characters into the command line,
so that a tall menu is crossed without holding an arrow key.

### The command position offers what can actually be run (implemented)

I want TAB in command position listing scripts, alias, builtins, functions,
commands and parameters groups, each alphabetical and truncated to its max-hints
(default 6), the query fuzzy-matching within every group, a history group last
truncated to 4, and a word holding `/` or `~` delegated to stock `_autocd` path
completion,
so that the first word completes from every source without drowning the screen.

<!-- [<] 🤖🤖 -->
