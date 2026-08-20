# Feature: Local kind cluster

<!--[>] 🤖🤖 -->

## As a sandbox operator

Bootstraps and disposes the cluster. Does not work inside a session.

### No docker daemon to install or keep running (tested)

I want kind provisioning its nodes through podman alone,
so that the host needs no docker daemon and no docker socket.

### The same cluster on linux and macos (implemented)

I want one cluster definition yielding the same node count and kubernetes
version on both platforms,
so that no platform-specific override is carried.

### The cluster is usable the moment it is created (tested)

I want kubectl on the generated kubeconfig reporting every node Ready,
so that bootstrap ends at a working cluster, not a checklist.

### A broken cluster is replaced, never repaired (implemented)

I want delete and create to yield a reachable cluster carrying no prior state,
so that debugging cluster rot is never on the critical path.

<!--[<] 🤖🤖 -->
