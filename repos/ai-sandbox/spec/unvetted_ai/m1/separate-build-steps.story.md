# Feature: Separate build steps

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds the image layers on the host. Does not decide profile contents.

### Three layers, three entry points (tested)

I want one step building the base, one installing tools on it, one applying
configuration on top,
so that each layer rebuilds on its own.

### Tools land before anything configures them (tested)

I want installs run before any configuration,
so that a config op never precedes the tool it targets.

### Each layer does only its own kind of work (implemented)

I want the installs layer limited to packages and the configuration layer to
links, dirs, templates and scripts,
so that the layer boundary matches the change frequency.

### A setting change rebuilds seconds, not minutes (implemented)

I want a configure-only profile change rebuilding the configuration layer
alone, installs layer and base untouched,
so that iterating on settings is cheap.

### A rebuilt configuration reuses the tools beneath it (implemented)

I want a session from a rebuilt configuration layer carrying the installed
tools without reinstalling them,
so that the cache below the change is kept.

### Adding a tool rebuilds only from that layer up (implemented)

I want a new tool in a configs profile rebuilding the installs layer and the
configuration on it, base untouched,
so that the base stays cold.

### A base change does not disturb what sits above (implemented)

I want upper-layer sources unchanged and sessions keeping their configuration
after a base rebuild,
so that the rarest change is also the safest.

### A sandbox is buildable with no CI at all (tested)

I want both images building on a host without CI access and a session running
from them,
so that the build never depends on a pipeline.

<!--[<] 🤖🤖 -->
