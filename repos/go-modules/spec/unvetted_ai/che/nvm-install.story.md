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

## As a pipeline maintainer

Owns the CI pipeline and the images it runs. Does not own che's installer
drivers.

### Node-dependent packages installing on every architecture CI runs (todo)

I want a package whose path is npm through node through nvm to install nvm once,
source `nvm.sh` from the directory that install wrote it to, and install the
package rather than failing on a missing `nvm.sh`,
so that a pipeline is not architecture-dependent for the same package.

### An install that already happened recognised as such (tested)

I want `validateArtifact` to skip the install and say so when its file is
present,
so that a rerun never installs a second time.

### A second install of one package within one run impossible (todo)

I want the artifact probe to see the file an earlier step of the same run wrote,
in CI as locally, rather than installing again in silence,
so that a duplicate install is impossible and visible if attempted.

### A CI failure reproducible by hand (todo)

I want the same che against the same catalog in the same image to match what CI
reported, a CI-only failure traceable to a named difference in that environment
rather than left unexplained,
so that debugging does not require pushing commits to a pipeline.

<!-- [<] 🤖🤖 -->
