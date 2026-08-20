# Feature: Local kind cluster

<!--[>] 🤖🤖 -->

## As a sandbox operator

Bootstraps and disposes the cluster. Does not work inside a session.

### No docker daemon to install or keep running (tested)

I want kind provisioning its nodes through podman alone,
so that the host needs no docker daemon or socket.

### The same cluster on linux and macos (implemented)

I want one cluster definition yielding the same node count and kubernetes
version on both platforms,
so that no platform override is carried.

### The cluster is usable the moment it is created (tested)

I want kubectl on the generated kubeconfig reporting every node Ready,
so that bootstrap ends at a working cluster, not a checklist.

### A broken cluster is replaced, never repaired (implemented)

I want delete then create yielding a reachable cluster with no prior state,
so that debugging cluster rot never lands on the critical path.

<!--[<] 🤖🤖 -->
