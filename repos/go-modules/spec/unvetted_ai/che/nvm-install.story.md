# Feature: nvm Installs Once and Is Found Where It Landed

<!-- [>] 🤖🤖 -->

npm packages need node, node needs nvm. che installs nvm with the catalog's
script, then sources `nvm.sh` to run `nvm install <version>`. Both sides resolve
the directory the same way: `NVM_DIR`, else `$XDG_CONFIG_HOME/nvm`, else
`$HOME/.nvm`.

On linux/arm64 CI this breaks. che installs nvm twice with no "already
installed" between, then fails to source the file it just wrote:

```
installed node dependency nvm via script
installed node dependency nvm via script
bash: line 1: /root/.config/nvm/nvm.sh: No such file or directory
che: bash -c . "/root/.config/nvm/nvm.sh" && nvm install 24.19.0: exit status 1
```

Reproduced twice, 22 and 28 minutes apart, identical output.

It does not reproduce locally. Same che binary, catalog, `debian:bookworm-slim`
arm64 image, environment and `/root/.cache` mount: ccstatusline installs end to
end, nvm, then node 24.19.0 and 22.23.2, then the package. Locally the second
nvm install short-circuits in `validateArtifact` with `already installed via
script`, the line CI never prints.

So resolution logic is not the difference. Something in CI leaves
`validateArtifact` blind to a file the install just wrote, and the second
install proceeds where it should skip.

## As a pipeline maintainer

Owns the CI pipeline and its images. Does not own che's installer drivers.

### Node-dependent packages installing on every architecture CI runs (todo)

I want an npm-through-node-through-nvm package to install nvm once, source
`nvm.sh` from the directory that install wrote to, and install the package
instead of failing on a missing `nvm.sh`,
so that the same package does not pass on one arch and fail on another.

### An install that already happened recognised as such (tested)

I want `validateArtifact` to skip the install and say so when its file is
present,
so that a rerun never installs twice.

### A second install of one package within one run impossible (todo)

I want the artifact probe to see a file an earlier step of the same run wrote,
in CI as locally, rather than silently installing again,
so that a duplicate install cannot happen, and is visible if attempted.

### A CI failure reproducible by hand (todo)

I want the same che, catalog and image to match what CI reported, a CI-only
failure traced to a named difference in that environment,
so that debugging does not mean pushing commits to a pipeline.

<!-- [<] 🤖🤖 -->
