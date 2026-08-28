## Che Native Installation Method

- che MUST define che install script using minimal dependencies to install CHE
- install script MUST work on darwin arm64 and linux arm64 and amd64
- install script MUST respect CHE_VERSION variable, defaulting to latest version
- install script MUST have options --skip-if-present and --skip-if-present-is-newer
- install script by default installs CHE_VERSION version of che and skips install only if CHE_VERSION matches currently installed che
- install script skips install fast according to --skip-if-present and --skip-if-present-is-newer or if CHE_VERSION matches current version
- install script MUST be executed by sh
- install script MUST accept --version argument to specify a version of che to install
- install script MUST not hardcode latest version of che, it MUST use latest - a rolling version
- each install script behavior toggle or option MUST be controlled via both environment variables and options, never one of both
- install script behavior MUST be discoverably by invoking it using --help option

### CI release and testing

- install script test in CI is tested on OCI image with absolute necessary minimal size
- install script MUST be tested in CI MR pipeline for both linux arm64 and linux amd64
- install script MUST be tested in CI MR pipeline only if install script itself changes its contents
- up-to-date install script MUST be published as publicly available URL in che release pipeline when install script changes its contents
- install script MUST NOT be re-published on non relevant to script changes
- install script upload pipeline MUST be executed in release pipeline only if install script changes its contents
- install script MUST NOT be tested in CI for darwin
- install script MUST be tested locally in darwin for arm64
- install script MUST be tested locally using temporary binary path
- che install script
