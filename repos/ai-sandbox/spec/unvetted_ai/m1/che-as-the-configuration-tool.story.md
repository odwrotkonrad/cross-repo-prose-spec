# Feature: Che as the configuration tool

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds images from profiles. Does not configure anything by hand.

### The build is reproducible from a profile (implemented)

I want che applying the image's configuration from a profile,
so that the build is readable as source.

### Nothing lands by a hand-run command (todo)

I want tmux, the credentials and the remote rewrites applied by profile ops,
so that the Dockerfile holds no configuration of its own.

### The configuration image is rendered, not assembled (implemented)

I want che rendering the configuration image from a profile on a host holding
the sources,
so that no build script exists to drift.

### One profile set serves both layers (implemented)

I want the installs layer and the configuration layer running the same profiles,
each applying only its own ops,
so that a profile is authored once.

### The same sources yield the same image (todo)

I want a rebuild from unchanged sources producing identical contents,
so that a rebuild is never a variable.

<!--[<] 🤖🤖 -->
