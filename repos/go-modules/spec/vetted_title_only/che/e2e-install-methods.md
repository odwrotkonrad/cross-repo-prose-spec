# Feature: E2E Install Methods

<!-- [>] 🤖 -->

`make e2e-install-methods` proves install methods live: real installs from real
registries and archives, each installed command run afterwards. Variables:

- `METHOD` (`E2E_INSTALL_METHOD`): `all` (default) | `<method>` | `<method>/` prefix
- `PACKAGE` (`E2E_INSTALL_PACKAGE`): `all` (default when unset) | `<pkg>`, other vars narrow further
- `PLATFORM` (`E2E_INSTALL_PLATFORM`): `darwin-arm64` | `linux-arm64` | `linux-amd64`, default autodetected host
- `MODE` (`E2E_INSTALL_MODE`): `with_no_deps` (default) | `with_deps`
- `E2E_INSTALL_CACHE_DIR`: download cache path, default `~/.cache/che/dev`

Scenario: e2e installation tests are based on packages.yml included in che (tested)
  When any install test runs
  Then package definitions come from che's vendored builtin `che/internal/packages/builtin/data/packages.yml`, at the version the `CHE_PACKAGES_REF` group CI variable names
  And selecting a package absent from that file fails the test

Scenario: developer have ability to run installation test of a their chosen package for every installation method (tested)
  When I invoke `make e2e-install-methods PACKAGE=<pkg>`
  Then the package installs for real once per method its entry lists, each into a fresh throwaway HOME
  And each install is verified by running the installed command
  And methods inapplicable on this host are skipped

Scenario: developer runs the full installation suite for their platform with zero configuration (implemented)
  Given `E2E_INSTALL_METHOD`, `E2E_INSTALL_PACKAGE` and `E2E_INSTALL_PLATFORM` are empty
  When I invoke `make e2e-install-methods`
  Then every builtin package installs via every method its entry lists
  And the platform is the autodetected host

Scenario: running e2e installation tests for a given platform attempts only that platform's installation methods (tested)
  Given a target platform (explicit or host-autodetected)
  When install tests run
  Then methods inapplicable to that platform are filtered out up front, never attempted
  And no attempt ends in "no applicable installation method" from a platform mismatch (`apt` on darwin)

Scenario: installation test runs in LOG_LEVEL=info, and can be configured when needed (tested)
  When install tests run, locally or in an MR pipeline
  Then che runs with `CHE_LOG_LEVEL=info`
  And `CHE_LOG_LEVEL` set on the invocation overrides it (`debug`, `trace`)

Scenario: developer have ability to run installation test of all packages for every installation method (implemented)
  When I invoke `make e2e-install-methods` (`PACKAGE` unset or `all`)
  Then every builtin package installs for real once per method its entry lists, each into a fresh environment
  And each install is verified by running the installed command
  And inapplicable methods are skipped

Scenario: a developer have ability to run installation test of all packages for installation method of their choice (tested)
  When I invoke `make e2e-install-methods METHOD=<method>`
  Then every builtin package installs, narrowed to entry methods matching exactly or by `<method>/` prefix (`METHOD=brew` covers `brew/formulae` and `brew/cask`)
  And `METHOD=all` (the default) filters nothing
  And installs gated by `os:` or `requiresCommand:` skip on hosts that do not match

Scenario: developer have ability to run installation test of a their chosen package for installation method of their choice (tested)
  When I invoke `make e2e-install-methods PACKAGE=<pkg> METHOD=<method>`
  Then only that one install and verify runs

Scenario: developer have ability to run installation test of a list of chosen packages (tested)
  When I invoke `make e2e-install-methods PACKAGE=<pkg1>,<pkg2>,...`
  Then each listed package installs for real once per method its entry lists, each into a fresh environment
  And each install is verified by running the installed command
  And a listed package absent from the builtin packages.yml fails the test

Scenario: an already-built che binary is reused, install tests never rebuild it needlessly (tested)
  Given the che binary and e2e harness are built and current
  When I invoke `make e2e-install-methods`
  Then nothing rebuilds
  And a missing or stale binary still builds first

Scenario: developer have ability to run installation test on preinstalled dependencies to speed up the test (MODE=with_deps) (tested)
  When I invoke `make e2e-install-methods ... MODE=with_deps`
  Then the install runs in a throwaway HOME on this host, reusing present dependencies
  And the run is faster, at the cost of not proving dependencies

Scenario: developer have ability to run installation test in environment with absolute minimal dependencies (MODE=with_no_deps) (tested)
  When I invoke `make e2e-install-methods ...` (default `MODE=with_no_deps`)
  Then each install runs in a fresh debian container with only che and its declared base prerequisites
  And the package pulls in its own dependencies, so missing ones surface

Scenario: when testing installs download cache is leveraged to reduce test time (tested)
  When I rerun install tests (any `MODE`)
  Then che-downloaded assets come from che's download cache (`CHE_PACKAGES_DOWNLOAD_CACHE_DIR`), the `downloads` subdir of a host dev cache dir shared across runs (`~/.cache/che/dev`, override `E2E_INSTALL_CACHE_DIR`)
  And in `MODE=with_no_deps` apt archives and lists also come from that dir
  And the environment itself stays bare and isolated

Scenario: developer have ability to run installation test for every supported platform on darwin-arm64 (tested)
  Given the host is darwin-arm64
  When I invoke `make e2e-install-methods ... PLATFORM=<darwin-arm64|linux-arm64|linux-amd64>`
  Then every supported platform is testable: darwin-arm64 on the host (`MODE=with_deps`), linux-arm64 and linux-amd64 in containers (docker platform emulation, che cross-built per arch)
  And the capability lives in the harness and Makefile only, che stays platform-unaware
  And without `PLATFORM` the host platform is used

Scenario: developer have ability to run installation test for platform they're using on linux-amd64 and linux-arm64 (tested)
  Given the host is linux-arm64 or linux-amd64
  When I invoke `make e2e-install-methods ... PLATFORM=<host platform>`
  Then only the host platform is testable
  And any other platform fails with a clear message

Scenario: an MR pipeline tests install methods with `MODE=with_no_deps` and must pass before merging (implemented)
  When an MR pipeline runs the install-methods jobs
  Then they run `MODE=with_no_deps` (each install in a fresh debian container)
  And a failure there fails the pipeline

Scenario: an MR pipeline contains an optional manual no-deps install-methods job (implemented)
  When an MR pipeline is created
  Then it contains an optional manual job running `MODE=with_no_deps` (each install in a fresh debian container)

Scenario: developer runs installation tests in virtualized environment (tested)
  Given a local environment
  When I invoke `make e2e-install-methods ...` (any selection, any mode)
  Then every install runs in a container or VM, never on the host itself

Scenario: each (package, method) pair runs in its own VM or container so packages and dependencies are never shared between tests (tested)
  When install tests run in `MODE=with_no_deps` (the default)
  Then every (package, method) subtest gets its own fresh environment: a tart VM on darwin, a debian container on linux
  And nothing one subtest installs or pulls in is visible to another

Scenario: each darwin e2e installation test runs in its own tart VM so packages are not reused (tested)
  #[why] method coverage only: the per-package darwin matrix is gone, the catalog's own suite is linux-only by decision

  Given the target platform is darwin
  When install tests run
  Then each install runs in its own fresh tart VM
  And nothing one test installs is visible to another

Scenario: an MR pipeline stays fast by testing only a chosen subset of packages per method (implemented)
  When an MR pipeline runs the install-methods jobs
  Then each method group installs only curated packages (up to 5, in the job matrix)
  And only those appear in the test output, no skipped-package noise
  And the full set stays reachable through the manual per-package jobs and local `PACKAGE=all`

Scenario: developer have ability to run installation test of a their chosen package for installation method of their choice in gitlab MR pipeline as optional job (todo)
  #[where] moved to konradodwrot/che-packages: see repos/che-packages/spec/unvetted_ai/catalog/own-repo.story.md

  When an MR pipeline is created
  Then it carries one optional manual job per builtin package per platform, grouped in per-platform stages
  And triggering one runs `make e2e-install-methods PACKAGE=<pkg>` for that platform only
  And a `METHOD` variable set at trigger time narrows the run to one method
  And untriggered jobs never block the pipeline
  And the job list is generated from the builtin `packages.yml`, drift caught by the docs-generation check

<!-- [<] 🤖 -->
