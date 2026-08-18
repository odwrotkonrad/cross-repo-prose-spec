# Feature: zsh config

<!-- [>] 🤖🤖 -->

## As a developer

Reads the prompt hundreds of times a day, needs location at a glance without
losing the line to a long path.

### Location readable in a short prompt (implemented)

I want PS1 rendering `$PWD` with `$HOME` as `~`, non-tail segments abbreviated
to their first character and the last two segments full, the `$PWD` group header
listed as the glob-depth notation `*` and each stack entry rendered with `$HOME`
as `~`,
so that a deep path costs a few characters and still names where you are.

### Only $HOME abbreviates to a tilde (implemented)

I want a named dir (`hash -d`) whose target contains `$PWD` left unabbreviated,
`~` shown for the `$HOME` segment only, non-tail segments still cut to their
first character and the last two segments full,
so that the prompt names one path form, never a surprise `~name`.

<!-- [<] 🤖🤖 -->
