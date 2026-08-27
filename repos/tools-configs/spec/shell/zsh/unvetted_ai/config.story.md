# Feature: zsh config

<!-- [>] 🤖🤖 -->

## As a developer

Reads the prompt hundreds of times a day, needs location at a glance without a
long path eating the line.

### Location readable in a short prompt (implemented)

I want PS1 rendering `$PWD` with `$HOME` as `~`, non-tail segments cut to
their first character, the last two segments and the git repo root segment
full, the path dropped under tmux where the pane border shows it, the `$PWD`
group header listed as the glob-depth notation `*`, each stack entry rendered
with `$HOME` as `~`,
so that a deep path costs a few characters and still says where you are.

### Only $HOME abbreviates to a tilde (implemented)

I want a named dir (`hash -d`) containing `$PWD` left unabbreviated, `~` for
the `$HOME` segment only, non-tail segments still cut to their first
character, the last two segments and the git repo root segment full,
so that the prompt has one path form, never a surprise `~name`.

<!-- [<] 🤖🤖 -->
