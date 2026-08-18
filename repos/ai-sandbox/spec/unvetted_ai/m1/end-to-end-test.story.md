# Feature: End-to-end test

<!--[>] 🤖🤖 -->

## As a sandbox operator

Runs the test on the host before trusting a change. Does not maintain CI.

### One run proves the whole path from nothing (todo)

I want the test creating the cluster and bringing its nodes Ready on a host with
none,
so that bootstrap is verified, not assumed.

### Every layer is proven buildable (todo)

I want the test building the base, installing tools on it and applying
configuration on top,
so that a broken layer is caught before a session needs it.

### The test borrows the host's credentials (todo)

I want it building both images with the host's credentials and holding no
identity of its own,
so that running the test grants nothing new.

### The session interface is exercised, not just present (todo)

I want the test creating, listing, attaching to and stopping a session, each
target doing what it promises,
so that the interface is verified as a whole.

### A config update is proven to reach a session (todo)

I want the test updating configuration, recreating the session on the rebuilt
image, reading the changed file inside the pod and confirming the tool behaves
by it,
so that the update path is proven at the behaviour, not the file.

### An update never eats persisted work (todo)

I want work in the persisted paths present after the test's update,
so that the persistence promise is tested every run.

### A failure names what broke (todo)

I want the test failing and naming the broken setup step,
so that a red run points at the fix.

### The host is left as it was found (todo)

I want the cluster and sessions the test created gone at the end,
so that running it costs no cleanup.

<!--[<] 🤖🤖 -->
