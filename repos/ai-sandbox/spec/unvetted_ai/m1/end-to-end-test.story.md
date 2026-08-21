# Feature: End-to-end test

<!--[>] 🤖🤖 -->

## As a sandbox operator

Runs the test on the host before trusting a change. Does not maintain CI.

### One run proves the whole path from nothing (tested)

I want the test creating the cluster and bringing its nodes Ready on a host
with none,
so that bootstrap is verified, not assumed.

### Every layer is proven buildable (tested)

I want the test building the base, installing tools on it and applying
configuration on top,
so that a broken layer is caught before a session needs it.

### The test borrows the host's credentials (implemented)

I want it building both images with the host's credentials, holding no
identity of its own,
so that running the test grants nothing new.

### The session interface is exercised, not just present (tested)

I want the test creating, listing, renaming and stopping a session, each
target doing what it promises,
so that the interface is verified whole.

### Attaching is proven, not assumed (todo)

I want the test attaching to a session and landing in its shell,
so that the target every run starts with is verified too.

### A config update is proven to reach a session (tested)

I want the test updating configuration and recreating the session on the
rebuilt image,
so that the update path is proven to run.

### The update is proven at the behaviour, not the file (todo)

I want the test reading the changed file inside the recreated pod and
confirming the tool behaves by it,
so that a rebuilt image is proven to change what a session does.

### An update never eats persisted work (tested)

I want work in the persisted paths present after the test's update,
so that the persistence promise is tested every run.

### A failure names what broke (implemented)

I want the test failing and naming the broken setup step,
so that a red run points at the fix.

### The host is left as it was found (tested)

I want the sessions the test created gone at the end,
so that a run leaves nothing behind.

### A passing run takes its cluster with it (todo)

I want the cluster the test created gone on a pass, unasked,
so that a run costs no cleanup.

<!--[<] 🤖🤖 -->
