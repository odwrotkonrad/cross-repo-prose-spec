# Technical Requirements: che packages

<!-- [>] 🤖🤖 -->

## Supported Installation Methods

- `npm`
- `go`
- `gem`
- `binariesRemoteArchive`
- `script`
- `buildFromSource`
- `pyenv`
- `nvm`
- `nix`

### Linux

- `apt`

### Darwin

- `brew`
- `cask`

## Supported Platforms

- `darwin-arm64`
- `linux-arm64`
- `linux-amd64`

## E2E Installation Testing

Local installs never touch the host. Each run is virtualized per platform.

- `darwin-arm64`: tart macOS VM
- `linux-arm64`, `linux-amd64`: docker container

<!-- [<] 🤖🤖 -->
