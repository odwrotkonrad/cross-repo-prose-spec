# Feature: Command Predicate In runIf

<!-- [>] 🤖🤖 -->

Scenario: a config author gates a profile on a command that succeeds (tested)
  Given a profile with `runIf: [cmd:<argv>]`
  When the command exits 0
  Then the predicate passes and the profile is eligible

Scenario: a failing gate keeps a profile out of the run (tested)
  Given a profile with `runIf: [cmd:<argv>]`
  When the command exits non-zero
  Then the predicate fails and the profile is skipped
  And the skip is reported with the failing predicate

Scenario: a missing binary skips instead of aborting the run (implemented)
  Given a profile with `runIf: [cmd:<argv>]` naming a binary absent from PATH
  When the predicate is evaluated
  Then the predicate fails and the profile is skipped
  And the run continues to the remaining profiles

Scenario: a gate over mutable state is never answered from cache (tested)
  Given a profile with `runIf: [cmd:<argv>]`
  When the predicate is evaluated twice
  Then the command runs twice
  And a `builtin:` predicate in the same evaluator still runs once

Scenario: a decision-only probe leaves the output clean (implemented)
  Given a profile with `runIf: [cmd:<argv>]` whose command writes to stdout and stderr
  When the predicate is evaluated
  Then neither stream appears in che's output
  And only the exit code decides

Scenario: a command gate composes with the existing literal form (tested)
  Given a profile with `runIf: [cmd:<argv> == true]`
  When the command exits 0
  Then the predicate passes
  And the same expression fails when the command exits non-zero

Scenario: every predicate must pass before a profile runs (implemented)
  Given a profile with `runIf: [env:<NAME>, cmd:<argv>]`
  When one predicate fails
  Then the profile is skipped regardless of the other

Scenario: a gate executes a binary rather than a shell line (implemented)
  Given a profile with `runIf: [cmd:<argv>]` whose argv contains quotes or a shell operator
  When the predicate is evaluated
  Then the argv is split on whitespace and passed to the binary verbatim
  And no shell interprets it

Scenario: an empty command predicate is rejected as malformed (tested)
  Given a profile with `runIf: [cmd:]`
  When the predicate is evaluated
  Then evaluation errors, naming the empty command

Scenario: an unknown source names the sources it accepts (tested)
  Given a profile with a `runIf` entry carrying an unrecognized prefix
  When the predicate is evaluated
  Then the error lists `builtin:<name>`, `env:<NAME>` and `cmd:<argv>`

Scenario: spec validation accepts a command predicate (implemented)
  Given a `che.yml` using `cmd:<argv>` in `runIf`
  When che runs with `--validate-spec=error`
  Then the spec validates and the run proceeds

<!-- [<] 🤖🤖 -->
