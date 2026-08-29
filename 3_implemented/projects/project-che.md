- che version command MUST output the resolved semver release, never `latest`, if `latest` ref was used for installation

## Che Native Installation Method

- che MUST define a che install script using minimal dependencies to install CHE
- install script MUST work on darwin arm64 and linux arm64 and amd64
- install script MUST respect INSTALL_CHE_VERSION variable, defaulting to the latest version
- install script MUST have options --skip-if-present and --skip-if-present-is-newer
- install script by default installs INSTALL_CHE_VERSION version of che and skips install only if INSTALL_CHE_VERSION matches the currently installed che
- install script skips install fast according to --skip-if-present and --skip-if-present-is-newer or if INSTALL_CHE_VERSION matches the current version
- install script MUST be executed by sh
- install script MUST accept --version argument to specify a version of che to install
- install script MUST NOT hardcode the latest version of che, it MUST use latest - a rolling version
- each install script behavior toggle or option MUST be controlled via both environment variables and options, never only one of the two
- each install script behavior variable MUST have a different namespace than che itself, i.e. they MUST NOT begin with CHE_...
- install script behavior MUST be discoverable by invoking it using --help option

### CI release and testing

- install script in CI is tested on an OCI image of the absolute necessary minimal size
- install script MUST be tested in CI MR pipeline for both linux arm64 and linux amd64
- install script MUST be tested in CI MR pipeline only if the install script itself changes its contents
- up-to-date install script MUST be published as a publicly available URL in che release pipeline when the install script changes its contents
- install script MUST NOT be re-published on changes not relevant to the script
- install script upload pipeline MUST be executed in release pipeline only if the install script changes its contents
- install script MUST NOT be tested in CI for darwin
- install script MUST be tested locally on darwin for arm64
- install script MUST be tested locally using a temporary binary path
- install script CI parts MUST live in their own gitlab.yml file, and it MUST be included in trigger "changed files"
