# Feature: git-mr-pipeline-status.zsh

<!-- [>] 🤖🤖 -->

Scenario: pipeline verdict is the exit code (implemented)
  When the report finishes
  Then it exits 1 only when the pipeline failed or was canceled, so multi-repo runs flag it ❌
  And exits 0 on any other status: success, still running under --no-wait, manual/blocked, no open MRs
  And no pipeline exits 0 with a `none: <reason>` line naming what was missing

Scenario: branch main implies --main (implemented)
  When I run with `--branch=main`, or from main with no flags
  Then it behaves as `--main`
  And `--main` with any other `--branch` exits 2: `--main excludes --branch`

<!-- [<] 🤖🤖 -->
