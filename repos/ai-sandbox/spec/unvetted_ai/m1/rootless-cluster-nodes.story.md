# Feature: Rootless cluster nodes

<!--[>] 🤖🤖 -->

## As a security owner

Sets the privilege boundary. Does not run sessions or build images.

### The host machine stays outside the blast radius (implemented)

I want node containers rooted inside the podman vm rather than on the machine,
so that the vm is the isolation boundary and host root is never held.

### Privilege on the node grants none in the session (tested)

I want session pods running as the session user, unprivileged,
so that a rootful node never runs the workload as root.

### The session holds no kernel capability (todo)

I want every capability dropped and privilege escalation disallowed,
so that a rootful node buys cilium its datapath without arming the workload.

<!--[<] 🤖🤖 -->
