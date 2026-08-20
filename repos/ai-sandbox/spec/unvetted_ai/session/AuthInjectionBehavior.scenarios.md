# Feature: Session auth injection

<!-- [>] 🤖🤖 -->

Scenario: an image is never baked half-authenticated (implemented)
  Given the SA key is absent from op
  When the config image builds
  Then it exits non-zero naming the missing op path, before any layer is built

Scenario: a session never starts half-authenticated (todo)
  Given the SA key is absent from op and `GCP_SA_KEY` is unset
  When `session-create` or `session-attach` runs
  Then it exits non-zero naming the missing op path, before any exec into the pod

<!-- [<] 🤖🤖 -->
