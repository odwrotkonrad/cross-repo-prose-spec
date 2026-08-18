# Feature: Che Log

<!-- [>] 🤖🤖 -->

Scenario: one env var dials verbosity, info by default (tested)
  When I set `CHE_LOG_LEVEL=<level>` with level error | warn | info | debug | trace
  Then the human log includes that level and every higher-severity level
  And info is the default when unset

Scenario: raising verbosity only adds lines, severe ones stay (tested)
  Given severity order error > warn > info > debug > trace
  When I set the log level
  Then error shows only error lines
  And warn shows error and warn lines
  And info shows error, warn and info lines
  And debug shows error, warn, info and debug lines
  And trace shows every line
  And a line below the selected level never prints

Scenario: severity prefixes grep-filter, info lines stay unprefixed (tested)
  When the human log prints a line
  Then an error line starts with `[error] `
  And a warn line starts with `[warn] `
  And a debug line starts with `[debug] `
  And a trace line starts with `[trace] `
  And an info line carries no level prefix

Scenario: config show defaults to changed options, with sources (tested)
  When I invoke `che config show` or `che config show --delta`
  Then the output lists the config options differing from defaults, with sources
  And --delta is the default mode

Scenario: --all lists every config option, value and source (tested)
  When I invoke `che config show --all`
  Then the output lists every config option with its value and source

Scenario: --defaults prints a default config straight from che (tested)
  When I invoke `che config show --defaults`
  Then every option prints with its code default, configured values ignored
  And `--defaults` is mutually exclusive with `--delta` and `--all`

Scenario: --output=yaml seeds a config.yml from any show mode (tested)
  When I invoke `che config show [--all|--defaults] --output=yaml`
  Then the options print as nested YAML in the config-file shape (`packages.binary.checkInPath` -> `packages: {binary: {checkInPath: ...}}`), in config order
  And bools and lists keep their types, flag-only options (cheWorkingDirectory, skipRunIf, errexit, packages.override) are omitted
  And the output round-trips: saved as `$XDG_CONFIG_HOME/che/config.yml` it resolves without error
  And `--output=text` (the default) keeps the `key = value  (source)` lines

Scenario: config show output pipes clean, no summary line (tested)
  When I invoke `che config show` in any mode
  Then the output holds only the per-option lines
  And no `config delta ...` summary line precedes them

Scenario: changed options list first in --all (tested)
  When I invoke `che config show --all`
  Then the changed options list first, in config order
  And the remaining options follow, in config order

Scenario: untouched options label (unset), not (default) (tested)
  Given a config option no source sets
  When I invoke `che config show --all`
  Then that option shows its default value labeled `(unset)`, not `(default)`

Scenario: a source-set option keeps its source label even at the default value (tested)
  Given a config option a source sets to its default value
  When I invoke `che config show --all`
  Then that option is labeled with its source, e.g. `(cliFlag)`
  And it sorts with the changed options

<!-- [<] 🤖🤖 -->
