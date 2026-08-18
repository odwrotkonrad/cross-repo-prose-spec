# Feature: Rootless cluster nodes

<!--[>] 🤖🤖 -->

## As a security owner

Sets the privilege boundary. Does not run sessions or build images.

### The host machine stays outside the blast radius (todo)

I want node containers rooted inside the podman vm rather than on the machine,
so that the vm is the isolation boundary and host root is never held.

### Privilege on the node grants none in the session (todo)

I want session pods running as the session user, unprivileged, with every
capability dropped,
so that a rootful node buys cilium its datapath without arming the workload.

<!--[<] 🤖🤖 -->
