# Feature: One che Binary

<!-- [>] 🤖🤖 -->

Scenario: an operator installs one artifact and has every render entrypoint (implemented)
  Given a host with the che binary and nothing else from this project
  When the operator invokes `che render tpl`, `che render dirs-tree`, `che render makefile-doc` or `che render repo-group-index`
  Then each runs the same engine the standalone binary ran
  And no separate render binary needs installing, pinning or pulling

Scenario: an agent discovers the render entrypoints without knowing their names (implemented)
  When the operator runs `che --help`
  Then `render` appears among che's commands
  And `che render --help` lists all four entrypoints with their descriptions
  And the generated `docs/cli.md` and `assets/data/cli-usage.md` carry them

Scenario: flags and arguments survive the move unchanged (implemented)
  Given an invocation that worked against a standalone render binary
  When the same flags and arguments are passed to the matching `che render` subcommand
  Then the output is byte-identical
  And `-f` and `--check` behave as they did
  And a template reading paths in frontmatter, `readBody` or `renderDirsTree` still resolves them against the cwd

Scenario: a render subcommand answers --version as the standalone binary did (todo)
  When `--version` is passed to a `che render` subcommand
  Then the version prints as the standalone binary printed it
  And the invocation does not fail as an invalid argument

Scenario: the check mode that guards generated docs keeps working (implemented)
  Given a lefthook or CI step that ran a render binary with `--check` to catch stale generated files
  When it runs the `che render` subcommand with `--check` instead
  Then a drifted file still fails the step with the same diff output
  And the exit codes are unchanged

<!-- [<] 🤖🤖 -->
