# Milestone 1: Overview

<!--[>] 🤖🤖 -->
- podman is the container provider, no docker daemon
- the node containers run rootful, which cilium's ebpf datapath requires; session pods stay
  unprivileged and never run as root
- a local kind cluster on podman, identical on linux and macos
- cilium is the CNI, egress denied by default: dns names, ports and protocols are whitelisted
- cpu and memory are capped cluster-wide, pods request little and may burst high
- a rarely-changing base image: zsh, the session user with a home, che, nothing more
- the session runs as that user, who holds passwordless sudo and is in the root group
- a session runs claude or codex interactively, with permission prompts off
- the configuration image carries claude, codex, zsh, tmux, vim, go, python, ruby, node, gcloud and
  the configs dev profiles, minus ollama and observability
- the sandbox repo owns the configuration-image che profile, configs is its remote source
- three layers by change frequency: base, then che installs only, then all other che configuration
- both build on the host, no CI build; CI dry-runs the che profiles instead
- one host-run e2e test covers cluster bootstrap, both builds, the session targets and a config update
- make is the interface: session-attach, session-create, session-ls, session-update-config,
  session-stop, session-rename
- a session's whole home is a per-session volume, seeded once from the image and never re-seeded, so
  a config update reaches new sessions while existing ones keep what they were seeded with
- new sessions get a random mnemonic name: adjectives, colours, creatures and things combined
- host ports are closed to sessions unless a rule names them
- closing the terminal detaches, the pod keeps running
- che builds both images
- tools installed or configured in a session come from the configs repo, matching the user's host setup
- git repositories come from gitlab via the workspace cloning che profile
- sandboxes share one least-privileged identity, defined today for gcp and gitlab
- gcp: a read-only service account scoped to the secrets and iac projects, assigned when the
  configuration image is built
- gitlab: a group-scoped token that reads, pushes unprotected branches and opens MRs, never merges
- two ssh keypairs, auth and signing, both impersonating the operating user
- all sandbox IAM is managed by the iac repo's designated module
- user configuration is an image layer, the runtime gives each pod a private writable layer over it
- what must outlive a stopped session is persisted deliberately: workspace, agent state, shell history
- claude is authenticated in the configuration image, every session inherits that authentication
- authentication is provisioned without user interaction where possible, otherwise by a throwaway
  login container at image build time
- the sandbox cannot reach the host, the host can reach the pods
<!--[<] 🤖🤖 -->
