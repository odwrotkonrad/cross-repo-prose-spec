# Feature: Separate build steps

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds the image layers on the host. Does not decide what the profiles contain.

### Three layers, three entry points (tested)

I want one step building the base, one installing tools on it and one applying
configuration on top,
so that each layer is rebuilt on its own.

### Tools land before anything configures them (tested)

I want installs running before any configuration is applied,
so that a config op never precedes the tool it targets.

### Each layer does only its own kind of work (implemented)

I want the installs layer restricted to packages and the configuration layer to
links, dirs, templates and scripts,
so that the layer boundary matches the change frequency.

### A setting change rebuilds seconds, not minutes (implemented)

I want a configure-only profile change rebuilding the configuration layer alone,
leaving the installs layer and base untouched,
so that iterating on settings is cheap.

### A rebuilt configuration reuses the tools beneath it (implemented)

I want the installed tools present and not reinstalled in a session from a
rebuilt configuration layer,
so that the cache below the change is kept.

### Adding a tool rebuilds only from that layer up (implemented)

I want a new tool in a configs profile rebuilding the installs layer and the
configuration on it, leaving the base alone,
so that the base stays cold.

### A base change does not disturb what sits above (implemented)

I want the upper layers' sources unchanged and sessions keeping their
configuration after a base rebuild,
so that the rarest change is also the safest.

### A sandbox is buildable with no CI at all (tested)

I want both images building on a host with no CI access and a session running
from them,
so that the build never depends on a pipeline.

<!--[<] 🤖🤖 -->
