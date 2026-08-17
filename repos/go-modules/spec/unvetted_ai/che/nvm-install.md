# Feature: nvm Installs Once and Is Found Where It Landed

<!-- [>] 🤖🤖 -->

Packages reach npm through node through nvm. che installs nvm with the
catalog's script, then sources `nvm.sh` to run `nvm install <version>`. Both
sides resolve the directory the same way: `NVM_DIR`, else `$XDG_CONFIG_HOME/nvm`,
else `$HOME/.nvm`.

In CI on linux/arm64 that breaks. che reports installing nvm twice with no
"already installed" between the two, then fails to source the file it has just
written:

```
installed node dependency nvm via script
installed node dependency nvm via script
bash: line 1: /root/.config/nvm/nvm.sh: No such file or directory
che: bash -c . "/root/.config/nvm/nvm.sh" && nvm install 24.19.0: exit status 1
```

Reproduced twice, 22 and 28 minutes apart, identical both times.

It does not reproduce locally. The same che binary, the same catalog, the same
`debian:bookworm-slim` arm64 image, the same environment and the same
`/root/.cache` mount installs ccstatusline end to end: nvm, then node 24.19.0
and 22.23.2, then the package. Locally the second nvm install always
short-circuits on `validateArtifact` with `already installed via script`, which
is the line CI never prints.

So the difference is not the resolution logic on either side. Something in CI
leaves `validateArtifact` unable to see a file the install just wrote, and the
second install proceeds where it should have been skipped.

Scenario: a package that needs node gets it, on every architecture CI runs
  Status: todo
  Given a package whose install path is npm through node through nvm
  When it installs on any architecture the pipeline covers
  Then nvm is installed once
  And `nvm.sh` is sourced from the directory that install wrote it to
  And the package installs, rather than failing on a missing `nvm.sh`

Scenario: an install that already happened is recognised as such
  Status: todo
  Given nvm has just been installed by an earlier step of the same run
  When a later step needs it again
  Then `validateArtifact` sees the file and the install is skipped
  And che says so, rather than installing a second time in silence

Scenario: the same install behaves the same in CI as by hand
  Status: todo
  Given an operator reproducing a CI failure locally
  When they run the same che against the same catalog in the same image
  Then the outcome matches what CI reported
  And a failure that only appears in CI is traceable to a named difference in that environment,
    not left as an unexplained divergence

<!-- [<] 🤖🤖 -->
