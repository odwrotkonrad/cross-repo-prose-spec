# Feature: Session auth injection

<!-- [>] 🤖🤖 -->

Scenario: a session never starts half-authenticated (todo)
  Given the SA key is absent from op and `GCP_SA_KEY` is unset
  When `session-create` or `session-attach` runs
  Then it exits non-zero naming the missing op path, before any exec into the pod

<!-- [<] 🤖🤖 -->
