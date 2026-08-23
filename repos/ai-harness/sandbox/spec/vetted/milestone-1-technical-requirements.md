# Milestone 1: Technical Requirements

## Container Provider

- Podman is the provider, not docker. No docker daemon is involved.
- The node containers run rootful. Cilium's ebpf datapath mounts `/sys/fs/bpf` and writes
  `/etc/sysctl.d`, which a rootless container cannot do at all: its user namespace never held the
  capability, so even a privileged container fails the same mount. Rootless nodes and enforced egress
  are mutually exclusive, and enforced egress is worth more.
- Rootlessness is a property of the session pod, which is what a session actually runs in. Node
  containers being root is confined to the podman vm, never the developer's machine.

## Cluster

- A local kind cluster on the developer host.
- One definition serves linux and macos: setup parity is what every choice answers to.

## Network

- Cilium is the CNI, so network policy is enforced by the same component that moves the packets.
- Egress is deny by default. A session reaches nothing until a rule admits it.
- DNS is blocked unless the name is whitelisted: resolution is the first gate, not an afterthought.
- Ports and protocols are whitelisted too. A whitelisted name grants no port it does not name.
- The sandbox cannot reach the host. The host can reach the pods: the direction is one-way by design.
- Host ports are closed to sessions unless a rule names them. The host is a destination like any other,
  denied by default rather than reachable because it is nearby. Cilium does not deny the host on its
  own, so a rule names it explicitly.
- Default-deny is written as a real rule over an empty endpoint selector. Cilium enforces only on an
  endpoint some policy selects, and an empty egress list leaves it allow-all, so the deny must select
  every pod in the namespace including one carrying the wrong labels.
- A session is never created while the policy is absent. Creating one refuses unless cilium is ready
  and the policy applied, so no session exists in a window where egress is unenforced.

## Resources

- The cluster caps total cpu and memory, so a sandbox cannot overload the machine hosting it.
- A pod's requests are low: a session reserves little and is scheduled easily.
- A pod's limit is high: a session may burst to nearly the whole cluster cap when the machine is idle.
- The gap between the two is deliberate. Sessions are bursty and mostly idle, so reserving for the
  peak would waste the machine.

## Session Image

- One image boots a session, assembled from three layers: base, tool installs, configuration.
- The lower two change rarely, so a session start pulls only the configuration layer when it moved,
  and usually nothing at all.
- The session runs as that user, never as root. The pod is not privileged: the writable layer every
  session gets is the container runtime's own, not a mount the pod has to make for itself.
- The user holds passwordless sudo inside the container and belongs to the root group: the boundary is
  the pod, not the account. An agent running unattended must never stall on a permission it can be
  given up front.
- Sudo is a setuid binary, so the pod keeps the capabilities it needs and drops the rest. Root inside a
  pod that cannot mount, and cannot escalate beyond it, reaches nothing outside the pod.

## Session Purpose

- A session exists to run an interactive agent, claude or codex, with full permissions: the agent is
  not asked to confirm its actions.
- The sandbox is what makes that safe. Confinement is the pod, never a prompt the agent must answer.

## Build Steps

- Three layers, ordered by how often they change: the base, then tool installs, then configuration.
- The base holds zsh, the session user with a home, and che.
- The installs layer runs che restricted to installing packages. Nothing is configured here.
- The configuration layer runs every other che op: links, dirs, rendered templates, scripts.
- The order is the point. Installs are slow and change rarely, configuration is fast and changes
  often, so a settings change rebuilds only the last layer and reuses the installs beneath it.
- Each layer is built on its own. Rebuilding configuration rebuilds neither installs nor base, and
  their layers are already on the node: neither rebuilt nor pulled again.
- Both build on the host that runs the cluster. No CI pipeline builds either, which is provisional.
- CI's part is validation: che dry runs over the profiles, catching a broken profile without building
  anything.

## User Interface

- Make is the interface. Session work is six targets, each prefixed `session-`:
  - `session-attach`: attach to a session, creating one when none exists, offering a picker when
    several do. The picker can show stopped sessions too, so past outcomes stay inspectable.
  - `session-create`: create a new session.
  - `session-ls`: list sessions, running and, on request, stopped.
  - `session-update-config`: rebuild the configuration image and recreate each session's pod on it.
    Persisted data survives, the pod does not.
  - `session-stop`: shut a session's pod down, keeping its data.
  - `session-rename`: give a session a name of your choosing.
- Reporting resource use per session is milestone 2's, with the collector whose retention a windowed
  central value and peak depend on.
- A new session is named a random mnemonic, so it can be said aloud and recognised in a list. A
  timestamp identifies a session without describing it.
- The mnemonic combines everyday words: an adjective, a colour, a creature, a thing. Two sessions are
  told apart at a glance, and a name can be repeated from memory.
- The remaining targets exist but are not session verbs: building any layer, bootstrapping the
  cluster, removing a session and its data.
- Removing a session deletes its volume explicitly. A volume claimed by a template outlives the
  workload that claimed it, so without that delete every removed session leaks its storage.
- A session outlives its terminal. Closing the terminal detaches, never stops the pod.

## End-to-End Test

- One e2e test exercises the setup against a real cluster, covering what breaking would make the
  sandbox unusable:
  - Bootstrapping the cluster.
  - Building all three layers: base, installs, configuration.
  - The session interface targets.
  - Updating configuration: the rebuilt image reaches a session, and data persisted from the previous
    pod is still there.
- It runs on the host, which is also where both images are built. Building there keeps the test's
  credentials the host's own and spares it a separate identity.
- It asserts outcomes, not steps: a session that runs, a target that does what it promises.

## Image Distribution

- A host-local registry holds the built layers, and the cluster pulls through a mirror pointing at it.
  Pulls stay off the external network and a rebuild transfers only the layers that changed.
- The registry must be up before the cluster is created, or the mirror never resolves.
- A layer's build inputs decide whether it is rebuilt. A credential written into a layer is not one of
  them by default, so the build makes it one: otherwise a changed credential silently reuses the layer
  built without it.

## Configuration Tooling

- Che builds every layer. Configuration is a che profile, never a hand-run command.
- The same profiles serve both layers, run twice with different ops: installs first, everything else
  after. A profile is not split in two to achieve this.
- Every tool a session installs or configures comes from the configs repo, so a session behaves like
  the host the user already knows. A tool configured anywhere else is a divergence to fix in configs.
- The che profile that builds the configuration image lives in the sandbox repo and pulls configs as a
  remote source. The sandbox owns which profiles apply, configs owns what each one does.

### Installed Tools

- Agents: claude, codex.
- Shell and terminal: zsh, tmux, vim.
- Languages: go, python, ruby, node.
- Cloud: gcloud.
- Every profile under the configs dev tree.
- The relevant remaining linux configuration from configs, excluding ollama and the observability
  tooling. Both exclusions are provisional.

## Workspace

- Git repositories come from gitlab, cloned by the workspace cloning che profile.
- The profile is what populates the workspace: no repository is cloned by hand.
- The clone happens when the configuration image is built, so a session starts with its workspace
  already present and every session on that image carries the same one. Refreshing it is a rebuild.

## Identity

- Every sandbox shares one identity. Sessions are not told apart by their credentials.
- Least privilege throughout: an identity holds the permissions its work needs and no others.
- Two identities are defined today, gcp and gitlab. The list grows only by adding one here.

### GCP

- Access is a service account, read-only, scoped to two projects: the one holding secrets and the one
  holding the iac infrastructure.
- No write anywhere, and no read outside those two projects.
- The service account is assigned when the configuration image is built, not per session. Every
  sandbox booting that image gets the same one.

### GitLab

- Access is a personal access token, expected to change to another mechanism later.
- Scoped to the gitlab group. Nothing outside the group is reachable.
- It may read, push to unprotected branches, and open merge requests.
- It may not merge a merge request. Merging stays a human act.

### SSH Keys

- Two keypairs, one for auth and one for signing, kept separate so a key's use is evident from which
  key it is.
- Both impersonate the user who operates the sandbox: work done in a session is that user's work.

### Provisioning

- All sandbox IAM is managed by the iac repo, in the module designated for it.
- Nothing sandbox-side creates, grants or renews a credential. A permission change is a change to
  that module.

## User Configuration

- Claude is authenticated in the configuration image, so every session inherits that authentication. A
  session is never logged in by hand, and a new one starts ready to work.
- Authentication is provisioned without a person in the loop wherever it can be: a credential the host
  already holds, written in when the configuration image is built.
- Where no such flow exists, the fallback is a container booted for that purpose alone. The user logs
  in once, the credential is captured into the image, and the container is shut down.
- A credential that expires is refreshed by rebuilding, not from inside a session: a session's writes
  never leave its own pod.
- The fallback is a build-time step, never something a session does. A session that finds no
  authentication fails rather than prompting.
- User configuration is an image layered on the base, and a session boots from the result. There is no
  separate disk and nothing is mounted in from the host.
- The container runtime already gives every pod a shared read-only base and a private writable layer.
  That is the whole mechanism: sessions on one node share the configuration once, and each session's
  writes are its own.
- A session writes anywhere it likes. Those writes are private to it and never reach the image.
- Configuration changes by rebuilding the image, never from inside a session.
- A session's whole home is its own volume, seeded from the image when the session is created and
  never seeded again.
- An update reaches the sessions created after it. An existing session keeps the configuration it was
  seeded with, because its home is not re-seeded. Recreating its pod does not change what its home
  holds.
- What outlives a stopped session is therefore the whole home: the workspace, the agent's state,
  shell history, and anything else the session wrote there.
