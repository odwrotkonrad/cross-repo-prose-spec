# Feature: One che Binary

<!-- [>] 🤖🤖 -->

Scenario: an operator installs one artifact and has every render entrypoint (implemented)
  Given a host with the che binary and nothing else from this project
  When the operator invokes `che render tpl`, `che render dirs-tree`, `che render makefile-doc` or `che render repo-group-index`
  Then each runs the engine the standalone binary ran
  And no separate render binary is installed, pinned or pulled

Scenario: an agent discovers the render entrypoints without knowing their names (implemented)
  When the operator runs `che --help`
  Then `render` appears among che's commands
  And `che render --help` lists all four entrypoints with their descriptions
  And the generated `docs/cli.md` and `assets/data/cli-usage.md` carry them

Scenario: flags and arguments survive the move unchanged (implemented)
  Given an invocation that worked against a standalone render binary
  When the same flags and arguments go to the matching `che render` subcommand
  Then the output is byte-identical
  And `-f` and `--check` behave as before
  And paths in frontmatter, `readBody` or `renderDirsTree` still resolve against the cwd

Scenario: a render subcommand answers --version as the standalone binary did (todo)
  When `--version` is passed to a `che render` subcommand
  Then the version prints as the standalone binary printed it
  And the invocation does not fail as an invalid argument

Scenario: the check mode that guards generated docs keeps working (implemented)
  Given a lefthook or CI step that ran a render binary with `--check`
  When it runs the `che render` subcommand with `--check` instead
  Then a drifted file still fails the step with the same diff output
  And the exit codes are unchanged

<!-- [<] 🤖🤖 -->
