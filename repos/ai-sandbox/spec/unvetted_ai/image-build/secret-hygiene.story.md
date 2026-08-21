# Feature: Build secrets never land on disk

<!-- [>] 🤖🤖 -->

## As the sandbox operator

Builds the session image on the host with podman.

### A build leaves no secret copy behind (implemented)

I want every `--secret` fed from a throwaway context dir deleted when the build
ends,
so that no credential file sits beside the repo after a build.

<!-- [<] 🤖🤖 -->
